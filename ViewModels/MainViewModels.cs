using System;
using System.Globalization;
using System.Windows;
using System.Windows.Input;
using System.Windows.Threading;
using CinemaAPP.Helpers;
using CinemaAPP.Views;

namespace CinemaAPP.ViewModels
{
    public sealed class MainViewModel : ObservableObject
    {
        private readonly DispatcherTimer timer;
        private string currentTime = "";
        private string currentDate = "";
        private string currentPageId = "Overview";
        private bool isAdmin = true;
        private object? currentView;

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
                    OnPropertyChanged(nameof(UserFullName));
                    OnPropertyChanged(nameof(UserRoleSubtext));
                    OnPropertyChanged(nameof(UserInitials));
                    OnPropertyChanged(nameof(PageHeaderTitle));
                }
            }
        }

        public Visibility AdminVisibility => IsAdmin ? Visibility.Visible : Visibility.Collapsed;

        public string UserFullName => IsAdmin ? "Quản trị viên" : "Nguyễn Văn An";
        public string UserRoleSubtext => IsAdmin ? "Quản trị · admin" : "Nhân viên · nv01";
        public string UserInitials => IsAdmin ? "QV" : "NA";

        public string CurrentPageId
        {
            get => currentPageId;
            set
            {
                if (SetProperty(ref currentPageId, value))
                {
                    OnPropertyChanged(nameof(IsOverviewSelected));
                    OnPropertyChanged(nameof(IsTicketsSelected));
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

        // ================= Lệnh =================
        public ICommand SelectPageCommand { get; }
        public ICommand ToggleRoleCommand { get; }
        public ICommand LogoutCommand { get; }

        public MainViewModel()
        {
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

            ToggleRoleCommand = new RelayCommand(_ =>
            {
                IsAdmin = !IsAdmin;
            });

            LogoutCommand = new RelayCommand(_ =>
            {
                AppSession.Logout();
                var loginWin = new LoginWindow();
                loginWin.Show();
                Application.Current.MainWindow?.Close();
            });

            // Đồng hồ thời gian thực
            UpdateClock();
            timer = new DispatcherTimer { Interval = TimeSpan.FromSeconds(1) };
            timer.Tick += (s, e) => UpdateClock();
            timer.Start();

            // Mặc định ở màn Tổng quan (chưa có giao diện, để trống vùng bên phải)
            NavigateTo("Overview");
        }

        private void NavigateTo(string pageId)
        {
            CurrentPageId = pageId;

            // Khi ấn nút nào thì giao diện tương ứng sẽ hiện ra ở vùng bên phải
            CurrentView = pageId switch
            {
                "Tickets" => new SeatMapDemoView(),
                "Customers" => new CustomerManagementView(),
                "Accounts" => new AccountManagementView(),
                "Revenue" => new RevenueView(),
                _ => null // "Overview", "Movies", "Rooms", "Showtimes": Để trống sẵn sàng nạp giao diện khi phát triển
            };
        }

        private void UpdateClock()
        {
            var now = DateTime.Now;
            CurrentTime = now.ToString("HH:mm:ss");

            var viCulture = new CultureInfo("vi-VN");
            var dayOfWeek = viCulture.DateTimeFormat.GetDayName(now.DayOfWeek);
            dayOfWeek = char.ToUpper(dayOfWeek[0]) + dayOfWeek.Substring(1);
            CurrentDate = $"{dayOfWeek}, {now:dd/MM/yyyy}";
        }
    }
}
