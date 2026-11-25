using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Input;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using CinemaAPP.Services;

namespace CinemaAPP.ViewModels
{
    // Màn Thống kê doanh thu (chỉ Admin mở được — B kiểm tra AppSession.IsAdmin ở menu).
    // Bố cục theo Figma "Thống kê doanh thu · v2": nhận xét → ô tổng + 4 ô số → heatmap + cơ cấu → phim + nhân viên.
    public class RevenueViewModel : ObservableObject
    {
        // Biểu đồ vùng trong ô Tổng doanh thu (phải khớp Height="150" trong RevenueView.xaml)
        public const double ChartHeight = 150;
        private const double ChartTopRoom = 40;      // chừa chỗ cho nhãn vàng phía trên điểm cao nhất
        private const double ChartBottomRoom = 8;
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

        private string rangeText = "", rangeLongText = "";
        public string RangeText { get => rangeText; private set => SetProperty(ref rangeText, value); }          // "14/11 – 20/11/2026"
        public string RangeLongText { get => rangeLongText; private set => SetProperty(ref rangeLongText, value); } // "Thứ Bảy 14/11 – Thứ Sáu 20/11/2026"

        // ================= Ô Tổng doanh thu =================
        private string revenueText = "—", revenueNumberText = "—", heroSubText = "";
        public string RevenueText { get => revenueText; private set => SetProperty(ref revenueText, value); }             // "212.259.000 đ"
        public string RevenueNumberText { get => revenueNumberText; private set => SetProperty(ref revenueNumberText, value); } // "212.259.000"
        public string HeroSubText { get => heroSubText; private set => SetProperty(ref heroSubText, value); }             // "2.219 vé · 936 đơn · trung bình 96.000 đ/vé"

        private double[]? trendHeights;
        public double[]? TrendHeights { get => trendHeights; private set => SetProperty(ref trendHeights, value); }
        public ObservableCollection<TrendPoint> TrendPoints { get; } = new ObservableCollection<TrendPoint>();

        // ================= 4 ô số =================
        private string ticketsText = "—", ticketsHintText = "", ordersText = "—", ticketsPerOrderText = "";
        private string memberShareText = "—", memberHintText = "", cancelledText = "—", cancelHintText = "";
        public string TicketsText { get => ticketsText; private set => SetProperty(ref ticketsText, value); }
        public string TicketsHintText { get => ticketsHintText; private set => SetProperty(ref ticketsHintText, value); }
        public string OrdersText { get => ordersText; private set => SetProperty(ref ordersText, value); }
        public string TicketsPerOrderText { get => ticketsPerOrderText; private set => SetProperty(ref ticketsPerOrderText, value); }
        public string MemberShareText { get => memberShareText; private set => SetProperty(ref memberShareText, value); }
        public string MemberHintText { get => memberHintText; private set => SetProperty(ref memberHintText, value); }
        public string CancelledText { get => cancelledText; private set => SetProperty(ref cancelledText, value); }
        public string CancelHintText { get => cancelHintText; private set => SetProperty(ref cancelHintText, value); }

        // ================= Nhận xét =================
        private string insightText = "";
        public string InsightText
        {
            get => insightText;
            private set { if (SetProperty(ref insightText, value)) OnPropertyChanged(nameof(HasInsight)); }
        }
        public bool HasInsight => insightText.Length > 0;

        // ================= Heatmap =================
        public ObservableCollection<string> HeatDays { get; } = new ObservableCollection<string>();
        public ObservableCollection<HeatRow> HeatRows { get; } = new ObservableCollection<HeatRow>();

        private string heatSummaryText = "";
        public string HeatSummaryText { get => heatSummaryText; private set => SetProperty(ref heatSummaryText, value); }

        private bool hasHeatmap, showHeatNumbers = true;
        public bool HasHeatmap
        {
            get => hasHeatmap;
            private set { if (SetProperty(ref hasHeatmap, value)) OnPropertyChanged(nameof(IsHeatmapEmpty)); }
        }
        public bool IsHeatmapEmpty => !hasHeatmap;
        public bool ShowHeatNumbers { get => showHeatNumbers; private set => SetProperty(ref showHeatNumbers, value); } // nhiều ngày quá thì ô nhỏ, bỏ số

        // ================= Cơ cấu doanh thu =================
        private double[]? donutValues;
        public double[]? DonutValues { get => donutValues; private set => SetProperty(ref donutValues, value); }   // [thành viên, khách lẻ]

        private string revenueShortText = "", memberPercentText = "", memberAmountText = "", walkInPercentText = "", walkInAmountText = "";
        public string RevenueShortText { get => revenueShortText; private set => SetProperty(ref revenueShortText, value); }   // "212,3 tr"
        public string MemberPercentText { get => memberPercentText; private set => SetProperty(ref memberPercentText, value); }
        public string MemberAmountText { get => memberAmountText; private set => SetProperty(ref memberAmountText, value); }
        public string WalkInPercentText { get => walkInPercentText; private set => SetProperty(ref walkInPercentText, value); }
        public string WalkInAmountText { get => walkInAmountText; private set => SetProperty(ref walkInAmountText, value); }

        private double[]? formatValues;
        public double[]? FormatValues { get => formatValues; private set => SetProperty(ref formatValues, value); }
        public ObservableCollection<FormatShare> Formats { get; } = new ObservableCollection<FormatShare>();

        // ================= Phim + nhân viên =================
        public ObservableCollection<MovieRow> Movies { get; } = new ObservableCollection<MovieRow>();
        public ObservableCollection<StaffRow> Staff { get; } = new ObservableCollection<StaffRow>();

        // ================= Trạng thái =================
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
        public bool IsMessageError => true;

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
            DateTime last = to.AddDays(-1);

            RangeText = byHour ? $"{from:dd'/'MM'/'yyyy}" : $"{from:dd'/'MM} – {last:dd'/'MM'/'yyyy}";
            RangeLongText = byHour
                ? $"{DayLong[(int)from.DayOfWeek]} {from:dd'/'MM'/'yyyy}"
                : $"{DayLong[(int)from.DayOfWeek]} {from:dd'/'MM} – {DayLong[(int)last.DayOfWeek]} {last:dd'/'MM'/'yyyy}";

            IsLoading = true;
            try
            {
                // 6 truy vấn chạy ở luồng nền để cửa sổ không bị đơ
                var r = await Task.Run(() => (
                    summary: service.GetSummary(from, to),
                    points: service.GetByTime(from, to, byHour),
                    movies: service.GetTopMovies(from, to, 5),
                    staff: service.GetByStaff(from, to),
                    heat: service.GetHeatmap(from, to),
                    formats: service.GetByFormat(from, to)));

                Fill(from, to, byHour, r.summary, r.points, r.movies, r.staff, r.heat, r.formats);
            }
            catch (Exception)
            {
                ClearData();
                Message = "Không kết nối được cơ sở dữ liệu. Kiểm tra SQL Server rồi bấm Tải lại.";
            }
            IsLoading = false;
        }

        private void Fill(DateTime from, DateTime to, bool byHour, RevenueSummary s, List<RevenuePoint> points,
                          List<MovieRevenue> movies, List<StaffRevenue> staff, List<HeatCell> heat, List<FormatRevenue> formats)
        {
            int days = Math.Max(1, (int)(to - from).TotalDays);

            // ---- Ô Tổng doanh thu + 4 ô số ----
            RevenueText = Format.Money(s.Revenue);
            RevenueNumberText = s.Revenue.ToString("N0", Format.Vi);
            string avg = s.Tickets > 0 ? " · trung bình " + Format.Money(Math.Round(s.Revenue / s.Tickets / 1000) * 1000) + "/vé" : "";
            HeroSubText = $"{Format.Number(s.Tickets)} vé · {Format.Number(s.Orders)} đơn{avg}";

            TicketsText = Format.Number(s.Tickets);
            TicketsHintText = days > 1
                ? "TB " + Format.Number((int)Math.Round((double)s.Tickets / days)) + " vé mỗi ngày"
                : "Trong ngày đã chọn";
            OrdersText = Format.Number(s.Orders);
            TicketsPerOrderText = s.Orders > 0
                ? ((double)s.Tickets / s.Orders).ToString("0.00", Format.Vi) + " vé mỗi đơn"
                : "Chưa có đơn";
            MemberShareText = s.Orders > 0 ? Math.Round(100.0 * s.OrdersWithCustomer / s.Orders) + "%" : "—";
            MemberHintText = $"{Format.Number(s.OrdersWithCustomer)} / {Format.Number(s.Orders)} đơn";
            CancelledText = Format.Number(s.CancelledOrders);
            int allOrders = s.Orders + s.CancelledOrders;
            CancelHintText = allOrders > 0
                ? (100.0 * s.CancelledOrders / allOrders).ToString("0.0", Format.Vi) + "% tổng số đơn"
                : "Không tính vào doanh thu";

            // ---- Biểu đồ vùng: chèn các mốc không có đơn = 0 ----
            var buckets = new List<(string label, string tip, decimal amount)>();
            if (byHour)
            {
                // Gộp 3 giờ một mốc: 09–12h, 12–15h, … ; bỏ các khung sáng sớm không có đơn
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
                for (DateTime d = from; d < to; d = d.AddDays(1))
                {
                    decimal sum = points.Where(p => p.Time.Date == d).Sum(p => p.Amount);
                    string label = days <= 7 ? $"{DayShort[(int)d.DayOfWeek]} {d:dd}" : d.ToString("dd");
                    buckets.Add((label, $"{DayShort[(int)d.DayOfWeek]} {d:dd'/'MM'/'yyyy}: {Format.Money(sum)}", sum));
                }
            }
            FillTrend(buckets);

            // ---- Heatmap + nhận xét ----
            FillHeatmap(from, to, heat, out string busiestSlot);
            FillInsight(byHour, buckets, busiestSlot, movies, s.Revenue);

            // ---- Cơ cấu: khách thành viên / khách lẻ ----
            decimal walkIn = s.Revenue - s.MemberRevenue;
            DonutValues = s.Revenue > 0 ? new[] { (double)s.MemberRevenue, (double)walkIn } : null;
            RevenueShortText = Million(s.Revenue);
            MemberPercentText = Percent1(s.MemberRevenue, s.Revenue);
            MemberAmountText = $"{Million(s.MemberRevenue)} · {Format.Number(s.OrdersWithCustomer)} đơn";
            WalkInPercentText = Percent1(walkIn, s.Revenue);
            WalkInAmountText = $"{Million(walkIn)} · {Format.Number(s.Orders - s.OrdersWithCustomer)} đơn";

            // ---- Định dạng chiếu: 2 định dạng lớn nhất, còn lại gộp "Khác" ----
            Formats.Clear();
            decimal formatTotal = formats.Sum(f => f.Amount);
            var parts = formats.Take(2).Select(f => (label: f.Format.Length > 0 ? f.Format : "Không rõ", amount: f.Amount)).ToList();
            decimal rest = formats.Skip(2).Sum(f => f.Amount);
            if (rest > 0) parts.Add(("Khác", rest));
            for (int i = 0; i < parts.Count; i++)
            {
                Formats.Add(new FormatShare
                {
                    Label = parts[i].label,
                    AmountText = Million(parts[i].amount),
                    PercentText = Percent(parts[i].amount, formatTotal),
                    Tone = i
                });
            }
            FormatValues = formatTotal > 0 ? parts.Select(p => (double)p.amount).ToArray() : null;

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

            // ---- Xếp hạng nhân viên (đã sắp theo doanh thu giảm dần) ----
            Staff.Clear();
            decimal topStaff = staff.Count > 0 ? staff[0].Amount : 0;
            for (int i = 0; i < staff.Count; i++)
            {
                StaffRevenue st = staff[i];
                Staff.Add(new StaffRow
                {
                    Rank = i + 1,
                    IsTop = i == 0,
                    IsLast = i == staff.Count - 1,
                    Initials = NameHelper.Initials(st.FullName),
                    FullName = st.FullName,
                    DetailText = $"{st.Username} · {Format.Number(st.Orders)} đơn · {Format.Number(st.Tickets)} vé",
                    AmountText = Format.Money(st.Amount),
                    ShareText = Percent(st.Amount, s.Revenue),
                    Percent = topStaff == 0 ? 0 : (double)(st.Amount / topStaff) * 100
                });
            }

            HasData = s.Orders > 0;
        }

        // Độ cao (pixel, tính từ đáy) của từng mốc. Trục không bắt đầu từ 0 mà từ dưới mốc thấp nhất một chút,
        // để thấy rõ ngày nào hơn ngày nào (giống biểu đồ vùng trên Figma).
        private void FillTrend(List<(string label, string tip, decimal amount)> buckets)
        {
            TrendPoints.Clear();
            if (buckets.Count == 0) { TrendHeights = null; return; }

            decimal max = buckets.Max(b => b.amount), min = buckets.Min(b => b.amount);
            decimal lo = Math.Max(0, min - (max - min) / 2);
            double usable = ChartHeight - ChartTopRoom - ChartBottomRoom;

            var heights = new double[buckets.Count];
            for (int i = 0; i < buckets.Count; i++)
            {
                var b = buckets[i];
                double h = max == lo
                    ? (max == 0 ? ChartBottomRoom : ChartBottomRoom + usable / 2)
                    : ChartBottomRoom + (double)((b.amount - lo) / (max - lo)) * usable;
                heights[i] = h;
                TrendPoints.Add(new TrendPoint
                {
                    Label = b.label,
                    ToolTip = b.tip,
                    ValueText = Million(b.amount),
                    PointMargin = new Thickness(0, 0, 0, h - 6),     // chấm 12×12, tâm nằm trên đường
                    TipMargin = new Thickness(0, 0, 0, h + 10),
                    IsMax = max > 0 && b.amount == max
                });
            }
            TrendHeights = heights;
        }

        private void FillHeatmap(DateTime from, DateTime to, List<HeatCell> heat, out string busiestSlot)
        {
            HeatDays.Clear();
            HeatRows.Clear();
            busiestSlot = "";

            var days = new List<DateTime>();
            for (DateTime d = from; d < to; d = d.AddDays(1)) days.Add(d);
            List<int> slots = heat.Select(c => c.Slot).Distinct().OrderBy(x => x).ToList();
            HasHeatmap = slots.Count > 0;
            ShowHeatNumbers = days.Count <= 14;
            if (!HasHeatmap) { HeatSummaryText = ""; return; }

            foreach (DateTime d in days)
                HeatDays.Add(days.Count <= 7 ? $"{DayShort[(int)d.DayOfWeek]}/{d:dd}" : d.ToString("dd"));

            var lookup = heat.ToDictionary(c => (c.Day.Date, c.Slot), c => c.Tickets);
            int Get(DateTime d, int slot) => lookup.TryGetValue((d, slot), out int n) ? n : 0;
            int max = heat.Max(c => c.Tickets);
            int min = days.SelectMany(d => slots.Select(sl => Get(d, sl))).Min();

            foreach (int slot in slots)
            {
                var row = new HeatRow { Label = SlotText(slot) };
                foreach (DateTime d in days)
                {
                    int n = Get(d, slot);
                    double level = n == 0 ? 0.05 : max == min ? 0.6 : 0.12 + 0.88 * (n - min) / (max - min);
                    row.Cells.Add(new HeatCellRow
                    {
                        Text = n.ToString(),
                        ToolTip = $"{DayShort[(int)d.DayOfWeek]} {d:dd'/'MM} · suất {slot}h–{slot + 3}h: {Format.Number(n)} vé",
                        Level = level,
                        IsStrong = level > 0.55
                    });
                }
                HeatRows.Add(row);
            }

            // Khung giờ đông / vắng nhất (cộng cả khoảng)
            var totals = slots.Select(sl => (slot: sl, total: days.Sum(d => Get(d, sl)))).ToList();
            var top = totals.OrderByDescending(t => t.total).First();
            var low = totals.OrderBy(t => t.total).First();
            busiestSlot = SlotText(top.slot);
            HeatSummaryText = totals.Count > 1
                ? $"Đông nhất: khung {SlotText(top.slot)} ({Format.Number(top.total)} vé) · Vắng nhất: khung {SlotText(low.slot)} ({Format.Number(low.total)} vé)"
                : $"Chỉ có khung {SlotText(top.slot)} ({Format.Number(top.total)} vé)";
        }

        // Một câu tóm tắt ghép từ số liệu đã có: mốc cao nhất, khung giờ đông nhất, phim đứng đầu.
        private void FillInsight(bool byHour, List<(string label, string tip, decimal amount)> buckets,
                                 string busiestSlot, List<MovieRevenue> movies, decimal revenue)
        {
            // Chưa có doanh thu thì không nhận xét (heatmap vẫn có thể có vé bán trước cho suất hôm nay)
            if (revenue <= 0) { InsightText = ""; return; }

            var parts = new List<string>();
            if (buckets.Count > 1 && buckets.Any(b => b.amount > 0))
            {
                var best = buckets.OrderByDescending(b => b.amount).First();
                string when = byHour ? "Khung " + best.label : best.tip[..best.tip.IndexOf(':')];
                parts.Add($"{when} có doanh thu cao nhất ({Million(best.amount)}).");
            }
            if (busiestSlot.Length > 0) parts.Add($"Khung {busiestSlot} bán nhiều vé nhất.");
            if (movies.Count > 0 && revenue > 0)
                parts.Add($"Phim \"{movies[0].Title}\" chiếm {Percent(movies[0].Amount, revenue)} doanh thu.");
            InsightText = string.Join(" ", parts);
        }

        private static string Percent(decimal part, decimal total)
            => total == 0 ? "0%" : Math.Round(part / total * 100) + "%";

        private static string Percent1(decimal part, decimal total)
            => total == 0 ? "0%" : (part / total * 100).ToString("0.0", Format.Vi) + "%";

        private static string Million(decimal amount) => Format.Million(amount) + " tr";

        // Nhãn khung giờ: 9 → "9–12h"
        private static string SlotText(int slot) => $"{slot}–{slot + 3}h";

        private void ClearData()
        {
            RevenueText = RevenueNumberText = TicketsText = OrdersText = MemberShareText = CancelledText = "—";
            HeroSubText = TicketsHintText = TicketsPerOrderText = MemberHintText = CancelHintText = "";
            InsightText = HeatSummaryText = RevenueShortText = "";
            MemberPercentText = MemberAmountText = WalkInPercentText = WalkInAmountText = "";
            TrendHeights = null;
            DonutValues = null;
            FormatValues = null;
            TrendPoints.Clear();
            HeatDays.Clear();
            HeatRows.Clear();
            HasHeatmap = false;
            Formats.Clear();
            Movies.Clear();
            Staff.Clear();
            HasData = false;
        }
    }
}
