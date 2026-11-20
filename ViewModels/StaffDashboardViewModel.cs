using System.Collections.ObjectModel;
using System.Windows.Input;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using CinemaAPP.Services;
using System.Windows.Threading;
namespace CinemaAPP.ViewModels
{
    // Màn Tổng quan của Nhân viên (thiết kế Figma "dashboard-for-staff").
    // Số liệu thật: đơn của chính nhân viên trong ngày (BOOKING) và suất chiếu hôm nay (SHOWTIME/SEAT/TICKET).
    public class StaffDashboardViewModel : ObservableObject
    {
        private const int MaxShowRows = 6;          // số suất hiện ở bảng "Suất chiếu sắp tới"
        private const int MaxSaleRows = 5;          // số đơn hiện ở "Giao dịch gần đây của tôi"
        private const double NearlyFullPercent = 90; // đã bán từ 90% ghế trở lên → "Sắp kín"
        private const int MaxRecentLookups = 3;

        private static readonly string[] DayLong =
            { "Chủ Nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy" };

        // Khách vừa tra cứu: giữ trong cả phiên làm việc (đổi màn rồi quay lại vẫn còn)
        private static readonly Dictionary<string, ObservableCollection<Customer>> lookupsByUser = new();
        private ObservableCollection<Customer> recentLookups => lookupsByUser.TryGetValue(StaffUsername, out var list) ? list : lookupsByUser[StaffUsername] = new();
        private readonly ShowtimeService dashboard = new();
        private readonly BookingService booking = new();
        private readonly CustomerService customers = new();
        // Tự tải lại mỗi 1 phút khi màn đang mở (View gọi Start/Stop lúc hiện/ẩn)
        private readonly DispatcherTimer autoRefresh = new() { Interval = TimeSpan.FromMinutes(1) };
        private bool isBusy;   // đang tải → bỏ qua lần gọi trùng (hẹn giờ + bấm nút cùng lúc)

        // ================= Người dùng & ca =================
        // Lấy giống màn Hóa đơn ca (MyShiftViewModel) để hai màn khớp số liệu
        public string StaffName { get; } = AppSession.CurrentUser?.FullName ?? "Quản trị viên";
        public string StaffUsername { get; } = AppSession.CurrentUser?.Username ?? "admin";
        public DateTime ShiftDay { get; } = DateTime.Today;
        private (DateTime, string) ShiftKey => (ShiftDay, StaffUsername);

        public string Greeting => "Xin chào, " + StaffName;
        public string DateText => $"{DayLong[(int)ShiftDay.DayOfWeek]}, {ShiftDay:dd'/'MM'/'yyyy} · Ca hôm nay";

        // Open = đang bán; Pending = đã nộp chốt ca, chờ Quản trị viên; Done = đã bàn giao
        public string ShiftStatusKind => SalesDemoStore.Handovers.ContainsKey(ShiftKey) ? "Done"
            : SalesDemoStore.ShiftReports.ContainsKey(ShiftKey) ? "Pending" : "Open";
        public string ShiftStatusText => ShiftStatusKind switch
        {
            "Done" => "Đã bàn giao",
            "Pending" => "Đã chốt · chờ xác nhận",
            _ => "Ca đang mở",
        };
        public string ShiftStatusTone => ShiftStatusKind switch { "Done" => "Info", "Pending" => "Warning", _ => "Success" };
        public string CloseButtonText => ShiftStatusKind == "Open" ? "Chốt ca" : "Xem chốt ca";

        // ================= 3 thẻ số liệu =================
        private string ticketsText = "—", revenueText = "—", remainingShowsText = "—";
        public string TicketsText { get => ticketsText; private set => SetProperty(ref ticketsText, value); }
        public string RevenueText { get => revenueText; private set => SetProperty(ref revenueText, value); }
        public string RemainingShowsText { get => remainingShowsText; private set => SetProperty(ref remainingShowsText, value); }

        // ================= Suất chiếu sắp tới =================
        public ObservableCollection<UpcomingShowItem> Shows { get; } = new();

        private string showsSubtitle = "";
        public string ShowsSubtitle { get => showsSubtitle; private set => SetProperty(ref showsSubtitle, value); }

        private bool isShowsEmpty;
        public bool IsShowsEmpty { get => isShowsEmpty; private set => SetProperty(ref isShowsEmpty, value); }

        // ================= Giao dịch gần đây của tôi =================
        public ObservableCollection<MySaleItem> Sales { get; } = new();

        private string salesSubtitle = "";
        public string SalesSubtitle { get => salesSubtitle; private set => SetProperty(ref salesSubtitle, value); }

        private bool isSalesEmpty;
        public bool IsSalesEmpty { get => isSalesEmpty; private set => SetProperty(ref isSalesEmpty, value); }

        // ================= Chốt ca =================
        private string cashExpectedText = "—";
        public string CashExpectedText { get => cashExpectedText; private set => SetProperty(ref cashExpectedText, value); }

        // ================= Tra cứu khách thành viên =================
        private string phoneQuery = "";
        public string PhoneQuery { get => phoneQuery; set => SetProperty(ref phoneQuery, value); }

        private Customer? lookupResult;
        public Customer? LookupResult
        {
            get => lookupResult;
            private set { if (SetProperty(ref lookupResult, value)) OnPropertyChanged(nameof(HasLookupResult)); }
        }
        public bool HasLookupResult => lookupResult != null;

        private string lookupMessage = "";
        public string LookupMessage
        {
            get => lookupMessage;
            private set { if (SetProperty(ref lookupMessage, value)) OnPropertyChanged(nameof(HasLookupMessage)); }
        }
        public bool HasLookupMessage => lookupMessage.Length > 0;

        private bool isLookupError;
        public bool IsLookupError { get => isLookupError; private set => SetProperty(ref isLookupError, value); }

        public ObservableCollection<Customer> RecentLookups => recentLookups;
        public bool HasRecentLookups => recentLookups.Count > 0;

        // ================= Trạng thái tải =================
        private bool isLoading;
        public bool IsLoading { get => isLoading; private set => SetProperty(ref isLoading, value); }

        private string message = "";
        public string Message
        {
            get => message;
            private set { if (SetProperty(ref message, value)) OnPropertyChanged(nameof(HasMessage)); }
        }
        public bool HasMessage => message.Length > 0;
        public bool IsMessageError => true;   // banner của màn này chỉ báo lỗi

        // ================= Lệnh =================
        public ICommand ReloadCommand { get; }
        public ICommand LookupCommand { get; }
        public ICommand LookupRecentCommand { get; }

        public StaffDashboardViewModel()
        {
            ReloadCommand = new RelayCommand(async _ => await LoadAsync());
            LookupCommand = new RelayCommand(async _ => await LookupAsync());
            LookupRecentCommand = new RelayCommand(async p =>
            {
                if (p is not Customer c) return;
                PhoneQuery = c.Phone;
                await LookupAsync();
            });
            autoRefresh.Tick += async (s, e) => await LoadAsync(quiet: true);
            _ = LoadAsync();
        }

        // ================= Tải dữ liệu =================
        private async Task LoadAsync(bool quiet = false)
        {
            if (isBusy) return;
            isBusy = true;
            if (!quiet) IsLoading = true;
            DateTime from = ShiftDay, to = ShiftDay.AddDays(1);
            try
            {
                var result = await Task.Run(() => (
                    shows: dashboard.GetRange(from, to),
                    sales: booking.GetSales(from, to)));
                Fill(result.shows, result.sales, DateTime.Now);
     
                Message = "";
            }
            catch (Exception)
            {
                if (!quiet) Clear();        // tải ngầm lỗi: giữ số liệu đang hiện, chỉ báo lỗi
                Message = "Không kết nối được cơ sở dữ liệu. Đang thử lại mỗi phút, hoặc bấm ⟳ để tải lại.";

            }
            IsLoading = false;
            isBusy = false;
        }

        private void Fill(List<Showtime> shows, List<SaleRecord> sales, DateTime now)
        {
            // ---- Đơn của chính mình trong ngày (giống màn Hóa đơn ca) ----
            var mine = sales.Where(s => s.StaffUsername == StaffUsername && s.CreatedAt.Date == ShiftDay)
                            .OrderByDescending(s => s.CreatedAt).ToList();
            var paid = mine.Where(s => !s.IsCancelled).ToList();
            int cancelled = mine.Count - paid.Count;

            TicketsText = Format.Number(paid.Sum(s => s.TicketCount)) + " vé";
            RevenueText = Format.Money(paid.Sum(s => s.Total));
            CashExpectedText = Format.Money(paid.Where(s => s.Method == PaymentMethod.Cash).Sum(s => s.Total));
            SalesSubtitle = $"{Format.Number(paid.Count)} đơn trong ca · {Format.Number(cancelled)} đơn đã hủy";

            Sales.Clear();
            var top = mine.Take(MaxSaleRows).ToList();
            for (int i = 0; i < top.Count; i++)
                Sales.Add(new MySaleItem(top[i], i == top.Count - 1));
            IsSalesEmpty = Sales.Count == 0;

            // ---- Suất chiếu chưa bắt đầu ----
            var upcoming = shows.Where(s => s.StartTime > now).OrderBy(s => s.StartTime).ToList();
            int sellable = upcoming.Count(s => s.SoldSeats < s.TotalSeats);
            RemainingShowsText = Format.Number(sellable) + " suất";
            ShowsSubtitle = $"Hôm nay · còn {Format.Number(sellable)} suất bán được · cập nhật {now:HH:mm}";

            Shows.Clear();
            var shown = upcoming.Take(MaxShowRows).ToList();
            for (int i = 0; i < shown.Count; i++)
                Shows.Add(new UpcomingShowItem(shown[i], NearlyFullPercent, i == shown.Count - 1));
            IsShowsEmpty = Shows.Count == 0;
        }

        private void Clear()
        {
            TicketsText = RevenueText = RemainingShowsText = CashExpectedText = "—";
            SalesSubtitle = ShowsSubtitle = "";
            Sales.Clear(); Shows.Clear();
            IsSalesEmpty = IsShowsEmpty = true;
        }

        // ================= Tra cứu khách =================
        private async Task LookupAsync()
        {
            LookupResult = null;
            IsLookupError = false;
            string phone = new string(PhoneQuery.Where(char.IsDigit).ToArray());
            if (phone.Length == 0) { LookupMessage = "Nhập số điện thoại để tra cứu."; return; }

            LookupMessage = "";
            try
            {
                Customer? c = await Task.Run(() => customers.FindByPhone(phone));
                if (c == null) { LookupMessage = $"Không có khách thành viên nào dùng số {phone}."; return; }

                LookupResult = c;
                var old = recentLookups.FirstOrDefault(x => x.CustomerID == c.CustomerID);
                if (old != null) recentLookups.Remove(old);
                recentLookups.Insert(0, c);
                while (recentLookups.Count > MaxRecentLookups) recentLookups.RemoveAt(recentLookups.Count - 1);
                OnPropertyChanged(nameof(HasRecentLookups));
            }
            catch (Exception)
            {
                IsLookupError = true;
                LookupMessage = "Không kết nối được cơ sở dữ liệu để tra cứu.";
            }
        }
        public void StartAutoRefresh() => autoRefresh.Start();
        public void StopAutoRefresh() => autoRefresh.Stop();
    }

    public class UpcomingShowItem
        {
            // Một dòng ở bảng "Suất chiếu sắp tới". Tone: Success (còn ghế) | Warning (sắp kín) | Error (hết ghế).
            public UpcomingShowItem(Showtime s, double nearlyFullPercent, bool isLast)
            {
                double soldPercent = s.TotalSeats == 0 ? 0 : s.SoldSeats * 100.0 / s.TotalSeats;
                TimeText = s.StartTime.ToString("HH:mm");
                Title = s.Title;
                Meta = string.Join(" · ", new[] { s.RoomName, s.ShowFormat, s.AudioType, s.DurationMin > 0 ? $"{s.DurationMin} phút" : "" }
                                       .Where(x => !string.IsNullOrWhiteSpace(x)));
                SeatsText = $"{Format.Number(s.SoldSeats)}/{Format.Number(s.TotalSeats)} ghế";
                SoldPercent = soldPercent;
                CanSell = s.SoldSeats < s.TotalSeats;
                (Tone, StatusText) = !CanSell ? ("Error", "Hết ghế")
                    : soldPercent >= nearlyFullPercent ? ("Warning", "Sắp kín")
                    : ("Success", "Còn ghế");
                IsLast = isLast;
            }
        public string TimeText { get; }
        public string Title { get; }
        public string Meta { get; }
        public string SeatsText { get; }
        public double SoldPercent { get; }
        public bool CanSell { get; }
        public string Tone { get; }
        public string StatusText { get; }
        public bool IsLast { get; }
    }

    // Một đơn ở "Giao dịch gần đây của tôi". Kind: sale | member | cancel (View chọn icon theo Kind).
    public class MySaleItem
    {
        public MySaleItem(SaleRecord s, bool isLast)
        {
            Kind = s.IsCancelled ? "cancel" : s.CustomerName != null ? "member" : "sale";
            Title = $"{s.Code} · {s.MovieTitle}";
            string tickets = $"{s.TicketCount} vé";
            Detail = Kind switch
            {
                "cancel" => $"{tickets} · {(string.IsNullOrWhiteSpace(s.CancelReason) ? "đã hoàn tiền" : s.CancelReason)} · {s.TimeText}",
                "member" => $"{tickets} · {s.CustomerName} +{s.Points} điểm · {s.TimeText}",
                _ => $"{tickets} · {s.MethodText} · {s.TimeText}",
            };
            AmountText = Format.Money(s.Total);
            StatusText = s.IsCancelled ? "Đã hủy" : "Đã thanh toán";
            Tone = s.IsCancelled ? "Error" : "Success";
            IsLast = isLast;
        }

        public string Kind { get; }
        public string Title { get; }
        public string Detail { get; }
        public string AmountText { get; }
        public string StatusText { get; }
        public string Tone { get; }
        public bool IsLast { get; }
    }
}
