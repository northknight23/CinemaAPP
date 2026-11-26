using System;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Input;
using System.Windows.Threading;
using CinemaAPP.Helpers;
using CinemaAPP.Models;

namespace CinemaAPP.ViewModels
{
    public sealed class MainViewModel : ObservableObject
    {
        private readonly DispatcherTimer timer;
        private readonly Func<string, bool, object?>? viewFactory;
        private readonly Dictionary<string, object> cachedViews = new();
        private string currentTime = "";
        private string currentDate = "";
        private string currentPageId = "Overview";
        private bool isAdmin = true;
        private object? currentView;
        private bool isLogoutConfirmOpen;

        public string CurrentTime
        {
            get => currentTime;
            private set => SetProperty(ref currentTime, value);
        }

        public string CurrentDate
        {
            get => currentDate;
            private set => SetProperty(ref currentDate, value);
        }

        public bool IsAdmin
        {
            get => isAdmin;
            set
            {
                if (SetProperty(ref isAdmin, value))
                {
                    OnPropertyChanged(nameof(AdminVisibility));
                    OnPropertyChanged(nameof(StaffVisibility));
                    OnPropertyChanged(nameof(UserFullName));
                    OnPropertyChanged(nameof(UserRoleSubtext));
                    OnPropertyChanged(nameof(UserInitials));
                    OnPropertyChanged(nameof(PageHeaderTitle));
                }
            }
        }

        public Visibility AdminVisibility => IsAdmin ? Visibility.Visible : Visibility.Collapsed;
        // Mục chỉ nhân viên thấy (Bán vé): Quản trị viên không bán vé, chỉ xem Giao dịch & Đối soát
        public Visibility StaffVisibility => IsAdmin ? Visibility.Collapsed : Visibility.Visible;

        public string UserFullName => AppSession.CurrentUser?.FullName 
            ?? (IsAdmin ? "Quản trị viên" : "Nguyễn Văn An");

        public string UserRoleSubtext => AppSession.CurrentUser != null
            ? $"{AppSession.CurrentUser.RoleText} · {AppSession.CurrentUser.Username}"
            : (IsAdmin ? "Quản trị · admin" : "Nhân viên · nv01");

        public string UserInitials => AppSession.CurrentUser != null
            ? AppSession.CurrentUser.Initials
            : (IsAdmin ? "QV" : "NA");

        public string CurrentPageId
        {
            get => currentPageId;
            set
            {
                if (SetProperty(ref currentPageId, value))
                {
                    OnPropertyChanged(nameof(IsOverviewSelected));
                    OnPropertyChanged(nameof(IsTicketsSelected));
                    OnPropertyChanged(nameof(IsTransactionsSelected));
                    OnPropertyChanged(nameof(IsMyShiftSelected));
                    OnPropertyChanged(nameof(IsCustomersSelected));
                    OnPropertyChanged(nameof(IsMoviesSelected));
                    OnPropertyChanged(nameof(IsRoomsSelected));
                    OnPropertyChanged(nameof(IsShowtimesSelected));
                    OnPropertyChanged(nameof(IsAccountsSelected));
                    OnPropertyChanged(nameof(IsRevenueSelected));
                    OnPropertyChanged(nameof(PageBreadcrumb));
                    OnPropertyChanged(nameof(PageHeaderTitle));
                }
            }
        }

        public bool IsOverviewSelected => CurrentPageId == "Overview";
        public bool IsTicketsSelected => CurrentPageId == "Tickets";
        public bool IsTransactionsSelected => CurrentPageId == "Transactions";
        public bool IsMyShiftSelected => CurrentPageId == "MyShift";
        public bool IsCustomersSelected => CurrentPageId == "Customers";
        public bool IsMoviesSelected => CurrentPageId == "Movies";
        public bool IsRoomsSelected => CurrentPageId == "Rooms";
        public bool IsShowtimesSelected => CurrentPageId == "Showtimes";
        public bool IsAccountsSelected => CurrentPageId == "Accounts";
        public bool IsRevenueSelected => CurrentPageId == "Revenue";

        public string PageBreadcrumb => CurrentPageId switch
        {
            "Overview" => "Tổng quan",
            "Tickets" => "Bán hàng",
            "Transactions" => "Bán hàng",
            "MyShift" => "Bán hàng",
            "Customers" => "Bán hàng",
            "Movies" => "Quản lý",
            "Rooms" => "Quản lý",
            "Showtimes" => "Quản lý",
            "Accounts" => "Quản lý",
            "Revenue" => "Báo cáo",
            _ => "UIT Cinema"
        };

        public string PageHeaderTitle => CurrentPageId switch
        {
            "Overview" => IsAdmin ? "Tổng quan hôm nay" : "Ca làm của tôi",
            "Tickets" => "Bán vé & Chọn ghế",
            "Transactions" => "Giao dịch & Đối soát",
            "MyShift" => "Hóa đơn & Chốt ca",
            "Customers" => "Quản lý khách hàng",
            "Movies" => "Quản lý danh sách phim",
            "Rooms" => "Quản lý phòng chiếu",
            "Showtimes" => "Quản lý lịch chiếu",
            "Accounts" => "Quản lý tài khoản hệ thống",
            "Revenue" => "Thống kê & Báo cáo doanh thu",
            _ => "UIT Cinema"
        };

        public object? CurrentView
        {
            get => currentView;
            set => SetProperty(ref currentView, value);
        }

        public bool IsLogoutConfirmOpen
        {
            get => isLogoutConfirmOpen;
            set => SetProperty(ref isLogoutConfirmOpen, value);
        }

        public event EventHandler? LogoutRequested;

        // ================= Lệnh =================
        public ICommand SelectPageCommand { get; }
        public ICommand LogoutCommand { get; }
        public ICommand ConfirmLogoutCommand { get; }
        public ICommand CancelLogoutCommand { get; }

        public MainViewModel() : this(null) { }

        public MainViewModel(Func<string, bool, object?>? pageViewFactory)
        {
            viewFactory = pageViewFactory;

            if (AppSession.CurrentUser != null)
            {
                isAdmin = AppSession.IsAdmin;
            }
            else
            {
                isAdmin = true; // Mặc định Quản lý (Admin) để hiển thị đầy đủ khung
            }

            SelectPageCommand = new RelayCommand(p =>
            {
                if (p is string pageId)
                {
                    NavigateTo(pageId);
                }
            });

            LogoutCommand = new RelayCommand(_ =>
            {
                IsLogoutConfirmOpen = true;
            });

            CancelLogoutCommand = new RelayCommand(_ =>
            {
                IsLogoutConfirmOpen = false;
            });

            ConfirmLogoutCommand = new RelayCommand(_ =>
            {
                IsLogoutConfirmOpen = false;
                timer?.Stop();
                cachedViews.Clear();
                AppSession.Logout();
                LogoutRequested?.Invoke(this, EventArgs.Empty);
            });

            // Đồng hồ thời gian thực
            UpdateClock();
            timer = new DispatcherTimer { Interval = TimeSpan.FromSeconds(1) };
            timer.Tick += (s, e) => UpdateClock();
            timer.Start();

            // Mặc định ở màn Tổng quan
            NavigateTo("Overview");
        }

        private void NavigateTo(string pageId)
        {
            // Kiểm tra phân quyền đầy đủ theo vai trò
            if (!IsAdmin && pageId is "Transactions" or "Movies" or "Rooms" or "Showtimes" or "Accounts" or "Revenue")
            {
                pageId = "Overview";
            }
            else if (IsAdmin && pageId is "Tickets" or "MyShift")
            {
                pageId = "Overview";
            }

            // Bấm lại đúng tab đang mở thì giữ nguyên màn hiện tại (tránh làm mới mất dữ liệu đang nhập)
            if (pageId == CurrentPageId && CurrentView != null)
                return;

            CurrentPageId = pageId;

            // Giữ trạng thái màn Bán vé (Tickets) khi nhân viên chuyển tab sang xem ca/khách rồi quay lại
            if (pageId == "Tickets")
            {
                if (!cachedViews.TryGetValue(pageId, out var ticketsView) && viewFactory != null)
                {
                    ticketsView = viewFactory(pageId, IsAdmin)!;
                    if (ticketsView != null) cachedViews[pageId] = ticketsView;
                }
                CurrentView = ticketsView;
                return;
            }

            CurrentView = viewFactory?.Invoke(pageId, IsAdmin);
        }

        private void UpdateClock()
        {
            var now = DateTime.Now;
            CurrentTime = now.ToString("HH:mm:ss");

            var dayOfWeek = Format.Vi.DateTimeFormat.GetDayName(now.DayOfWeek);
            dayOfWeek = char.ToUpper(dayOfWeek[0]) + dayOfWeek.Substring(1);
            CurrentDate = $"{dayOfWeek}, {now:dd/MM/yyyy}";
        }
    }
}
