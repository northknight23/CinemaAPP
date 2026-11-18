using System.Collections.ObjectModel;
using System.Windows.Input;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using CinemaAPP.Services;

namespace CinemaAPP.ViewModels
{
    // Màn Thống kê doanh thu (chỉ Admin mở được — B kiểm tra AppSession.IsAdmin ở menu).
    public class RevenueViewModel : ObservableObject
    {
        private const double MaxBarHeight = 170;   // chiều cao cột cao nhất (pixel)
        private const int MaxCustomDays = 31;

        private static readonly string[] DayShort = { "CN", "T2", "T3", "T4", "T5", "T6", "T7" };
        private static readonly string[] DayLong =
            { "Chủ Nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy" };

        private readonly RevenueService service = new RevenueService();

        // ================= Khoảng thời gian =================
        private string preset = "week";   // "today" | "week" | "month" | "custom"
        public bool IsToday { get => preset == "today"; set { if (value) SetPreset("today"); } }
        public bool IsWeek { get => preset == "week"; set { if (value) SetPreset("week"); } }
        public bool IsMonth { get => preset == "month"; set { if (value) SetPreset("month"); } }
        public bool IsCustom { get => preset == "custom"; set { if (value) SetPreset("custom"); } }

        // Hai ô chọn ngày (chỉ hiện khi chọn "Tùy chọn")
        private DateTime? fromDate = DateTime.Today.AddDays(-6);
        public DateTime? FromDate { get => fromDate; set => SetProperty(ref fromDate, value); }

        private DateTime? toDate = DateTime.Today;
        public DateTime? ToDate { get => toDate; set => SetProperty(ref toDate, value); }

        private string rangeText = "";
        public string RangeText { get => rangeText; private set => SetProperty(ref rangeText, value); }

        // ================= Số liệu =================
        private string revenueText = "—", ticketsText = "—", ordersText = "—", avgPriceText = "—", cancelledText = "—";
        private string ticketsPerOrderText = "", withCustomerText = "";
        public string RevenueText { get => revenueText; private set => SetProperty(ref revenueText, value); }
        public string TicketsText { get => ticketsText; private set => SetProperty(ref ticketsText, value); }
        public string OrdersText { get => ordersText; private set => SetProperty(ref ordersText, value); }
        public string AvgPriceText { get => avgPriceText; private set => SetProperty(ref avgPriceText, value); }
        public string CancelledText { get => cancelledText; private set => SetProperty(ref cancelledText, value); }
        public string TicketsPerOrderText { get => ticketsPerOrderText; private set => SetProperty(ref ticketsPerOrderText, value); }
        public string WithCustomerText { get => withCustomerText; private set => SetProperty(ref withCustomerText, value); }

        private string chartTitle = "Doanh thu theo ngày";
        public string ChartTitle { get => chartTitle; private set => SetProperty(ref chartTitle, value); }

        public ObservableCollection<ChartBar> Bars { get; } = new ObservableCollection<ChartBar>();
        public ObservableCollection<MovieRow> Movies { get; } = new ObservableCollection<MovieRow>();
        public ObservableCollection<StaffRow> Staff { get; } = new ObservableCollection<StaffRow>();

        private bool hasData;
        public bool HasData
        {
            get => hasData;
            private set { if (SetProperty(ref hasData, value)) OnPropertyChanged(nameof(IsEmpty)); }
        }
        public bool IsEmpty => !hasData && !isLoading && message.Length == 0;

        private bool isLoading;
        public bool IsLoading
        {
            get => isLoading;
            private set { if (SetProperty(ref isLoading, value)) OnPropertyChanged(nameof(IsEmpty)); }
        }

        private string message = "";
        public string Message
        {
            get => message;
            private set
            {
                if (SetProperty(ref message, value))
                {
                    OnPropertyChanged(nameof(HasMessage));
                    OnPropertyChanged(nameof(IsEmpty));
                }
            }
        }
        public bool HasMessage => message.Length > 0;
        public bool IsMessageError => true;   // màn này chỉ có thông báo lỗi

        // ================= Lệnh =================
        public ICommand ApplyCustomCommand { get; }
        public ICommand ReloadCommand { get; }

        public RevenueViewModel()
        {
            ApplyCustomCommand = new RelayCommand(async _ => await LoadAsync());
            ReloadCommand = new RelayCommand(async _ => await LoadAsync());
            _ = LoadAsync();
        }

        private async void SetPreset(string value)
        {
            preset = value;
            OnPropertyChanged(nameof(IsToday));
            OnPropertyChanged(nameof(IsWeek));
            OnPropertyChanged(nameof(IsMonth));
            OnPropertyChanged(nameof(IsCustom));
            if (value != "custom") await LoadAsync();   // "Tùy chọn": chờ bấm nút Xem
        }

        // Khoảng [from, to) theo lựa chọn hiện tại. Sai → trả về null và ghi Message.
        private (DateTime from, DateTime to)? GetRange()
        {
            DateTime today = DateTime.Today;
            switch (preset)
            {
                case "today": return (today, today.AddDays(1));
                case "week": return (today.AddDays(-6), today.AddDays(1));
                case "month": return (new DateTime(today.Year, today.Month, 1), today.AddDays(1));
            }

            if (FromDate == null || ToDate == null) { Message = "Hãy chọn đủ Từ ngày và Đến ngày."; return null; }
            DateTime from = FromDate.Value.Date, to = ToDate.Value.Date;
            if (from > to) { Message = "Từ ngày phải trước hoặc bằng Đến ngày."; return null; }
            if ((to - from).TotalDays + 1 > MaxCustomDays) { Message = $"Chỉ xem tối đa {MaxCustomDays} ngày một lần."; return null; }
            return (from, to.AddDays(1));
        }

        private async Task LoadAsync()
        {
            Message = "";
            var range = GetRange();
            if (range == null) { ClearData(); return; }
            (DateTime from, DateTime to) = range.Value;
            bool byHour = (to - from).TotalDays <= 1;

            RangeText = byHour
                ? $"{DayLong[(int)from.DayOfWeek]}, {from:dd'/'MM'/'yyyy}"
                : $"{from:dd'/'MM} – {to.AddDays(-1):dd'/'MM'/'yyyy}";
            ChartTitle = byHour ? "Doanh thu theo khung giờ" : "Doanh thu theo ngày";

            IsLoading = true;
            try
            {
                // 4 truy vấn chạy ở luồng nền để cửa sổ không bị đơ
                var result = await Task.Run(() => (
                    summary: service.GetSummary(from, to),
                    points: service.GetByTime(from, to, byHour),
                    movies: service.GetTopMovies(from, to, 5),
                    staff: service.GetByStaff(from, to)));

                Fill(from, to, byHour, result.summary, result.points, result.movies, result.staff);
            }
            catch (Exception)
            {
                ClearData();
                Message = "Không kết nối được cơ sở dữ liệu. Kiểm tra SQL Server rồi bấm Tải lại.";
            }
            IsLoading = false;
        }

        private void Fill(DateTime from, DateTime to, bool byHour, RevenueSummary s,
                          List<RevenuePoint> points, List<MovieRevenue> movies, List<StaffRevenue> staff)
        {
            // ---- 5 ô số ----
            RevenueText = Format.Money(s.Revenue);
            TicketsText = Format.Number(s.Tickets);
            OrdersText = Format.Number(s.Orders);
            CancelledText = Format.Number(s.CancelledOrders);
            AvgPriceText = s.Tickets > 0 ? Format.Money(Math.Round(s.Revenue / s.Tickets / 1000) * 1000) : "—";
            TicketsPerOrderText = s.Orders > 0
                ? "TB " + ((double)s.Tickets / s.Orders).ToString("0.0", Format.Vi) + " vé / đơn"
                : "Chưa có đơn";
            WithCustomerText = Format.Number(s.OrdersWithCustomer) + " đơn có khách thành viên";

            // ---- Biểu đồ cột: chèn các mốc không có đơn = 0 ----
            var buckets = new List<(string label, string tip, decimal amount)>();
            if (byHour)
            {
                // Gộp 3 giờ một cột: 09–12h, 12–15h, … ; bỏ các khung sáng sớm không có đơn
                for (int start = 0; start < 24; start += 3)
                {
                    decimal sum = points.Where(p => p.Time.Hour >= start && p.Time.Hour < start + 3).Sum(p => p.Amount);
                    if (start < 9 && sum == 0) continue;
                    string label = $"{start:00}–{start + 3:00}h";
                    buckets.Add((label, $"{label}: {Format.Money(sum)}", sum));
                }
            }
            else
            {
                int days = (int)(to - from).TotalDays;
                for (DateTime d = from; d < to; d = d.AddDays(1))
                {
                    decimal sum = points.Where(p => p.Time.Date == d).Sum(p => p.Amount);
                    string label = days <= 7 ? $"{DayShort[(int)d.DayOfWeek]} {d:dd'/'MM}" : d.ToString("dd");
                    buckets.Add((label, $"{DayShort[(int)d.DayOfWeek]} {d:dd'/'MM'/'yyyy}: {Format.Money(sum)}", sum));
                }
            }

            decimal max = buckets.Count == 0 ? 0 : buckets.Max(b => b.amount);
            Bars.Clear();
            foreach (var b in buckets)
            {
                Bars.Add(new ChartBar
                {
                    Label = b.label,
                    ToolTip = b.tip,
                    ValueText = b.amount > 0 ? Format.Million(b.amount) : "",
                    BarHeight = max == 0 ? 2 : Math.Max(b.amount > 0 ? 4 : 2, (double)(b.amount / max) * MaxBarHeight),
                    IsMax = max > 0 && b.amount == max,
                    ShowValue = buckets.Count <= 14
                });
            }

            // ---- Top phim ----
            Movies.Clear();
            decimal topMovie = movies.Count > 0 ? movies[0].Amount : 0;
            for (int i = 0; i < movies.Count; i++)
            {
                MovieRevenue m = movies[i];
                Movies.Add(new MovieRow
                {
                    Rank = i + 1,
                    Title = m.Title,
                    AmountText = Format.Money(m.Amount),
                    DetailText = $"{Format.Number(m.Tickets)} vé · {Percent(m.Amount, s.Revenue)}",
                    Percent = topMovie == 0 ? 0 : (double)(m.Amount / topMovie) * 100
                });
            }

            // ---- Theo nhân viên ----
            Staff.Clear();
            foreach (StaffRevenue st in staff)
            {
                Staff.Add(new StaffRow
                {
                    Initials = NameHelper.Initials(st.FullName),
                    FullName = st.FullName,
                    Username = st.Username,
                    OrdersText = Format.Number(st.Orders),
                    TicketsText = Format.Number(st.Tickets),
                    AmountText = Format.Money(st.Amount),
                    ShareText = Percent(st.Amount, s.Revenue),
                    Percent = s.Revenue == 0 ? 0 : (double)(st.Amount / s.Revenue) * 100
                });
            }

            HasData = s.Orders > 0;
        }

        private static string Percent(decimal part, decimal total)
            => total == 0 ? "0%" : Math.Round(part / total * 100) + "%";

        private void ClearData()
        {
            RevenueText = TicketsText = OrdersText = AvgPriceText = CancelledText = "—";
            TicketsPerOrderText = WithCustomerText = "";
            Bars.Clear();
            Movies.Clear();
            Staff.Clear();
            HasData = false;
        }
    }
}
