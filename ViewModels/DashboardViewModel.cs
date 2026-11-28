using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Input;
using System.Windows.Threading;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using CinemaAPP.Services;

namespace CinemaAPP.ViewModels
{
    // Màn Tổng quan của Quản trị viên (thiết kế Figma "Dashboard · Light").
    // Số liệu thật từ CSDL: đơn BOOKING/TICKET và suất chiếu SHOWTIME.
    public class DashboardViewModel : ObservableObject
    {
        public const double PlotHeight = 230;     // chiều cao vùng vẽ biểu đồ tuần (pixel)
        private const int RecentRows = 5;         // số dòng ở bảng "Lịch sử giao dịch gần đây"

        private static readonly string[] DayShort = { "CN", "T2", "T3", "T4", "T5", "T6", "T7" };
        private static readonly string[] DayLong =
            { "Chủ Nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy" };

        private readonly ShowtimeService showtimes = new ShowtimeService();
        private readonly BookingService booking = new BookingService();
        private readonly RevenueService revenue = new RevenueService();   // tiền + vé: dùng chung với màn Thống kê doanh thu
        private readonly DispatcherTimer autoRefresh = new() { Interval = TimeSpan.FromMinutes(2) };
        private bool isBusy;
        private List<ActivityItem> allActivities = new();
        private List<RecentSale> recentAll = new();

        // ================= Lời chào & khoảng thời gian =================
        public string Greeting => "Xin chào, " + (AppSession.CurrentUser?.FullName ?? "Quản trị viên");

        private int rangeDays = 7;
        public int RangeDays
        {
            get => rangeDays;
            private set
            {
                if (SetProperty(ref rangeDays, value))
                {
                    OnPropertyChanged(nameof(RangeText));
                    OnPropertyChanged(nameof(CompareText));
                    OnPropertyChanged(nameof(Is7Days));
                    OnPropertyChanged(nameof(Is14Days));
                }
            }
        }
        public string RangeText => $"{RangeDays} ngày qua";
        // Kỳ trước có đủ ngày có lịch chiếu thì mới so sánh (tránh "+652%" ảo khi kỳ trước thiếu dữ liệu)
        private bool canCompare = true;
        public string CompareText => canCompare
            ? $"so với {RangeDays} ngày trước"
            : "Kỳ trước chưa đủ lịch chiếu để so sánh";
        public bool Is7Days => RangeDays == 7;
        public bool Is14Days => RangeDays == 14;

        // ================= 3 thẻ số liệu hôm nay =================
        private string revenueTodayText = "—", ticketsTodayText = "—", occupancyTodayText = "—";
        public string RevenueTodayText { get => revenueTodayText; private set => SetProperty(ref revenueTodayText, value); }
        public string TicketsTodayText { get => ticketsTodayText; private set => SetProperty(ref ticketsTodayText, value); }
        public string OccupancyTodayText { get => occupancyTodayText; private set => SetProperty(ref occupancyTodayText, value); }

        private DeltaInfo? revenueDelta, ticketsDelta, occupancyDelta, totalDelta;
        public DeltaInfo? RevenueDelta { get => revenueDelta; private set => SetProperty(ref revenueDelta, value); }
        public DeltaInfo? TicketsDelta { get => ticketsDelta; private set => SetProperty(ref ticketsDelta, value); }
        public DeltaInfo? OccupancyDelta { get => occupancyDelta; private set => SetProperty(ref occupancyDelta, value); }
        private double[] ticketsSpark = Array.Empty<double>(), occupancySpark = Array.Empty<double>();
        public double[] TicketsSpark { get => ticketsSpark; private set => SetProperty(ref ticketsSpark, value); }
        public double[] OccupancySpark { get => occupancySpark; private set => SetProperty(ref occupancySpark, value); }

        // ================= Biểu đồ "Xu hướng bán vé tuần" =================
        private string totalTicketsText = "—";
        public string TotalTicketsText { get => totalTicketsText; private set => SetProperty(ref totalTicketsText, value); }
        public DeltaInfo? TotalDelta { get => totalDelta; private set => SetProperty(ref totalDelta, value); }

        public ObservableCollection<ChartDay> ChartDays { get; } = new();

        // Nhãn trục tung, từ trên xuống: max, 3/4, 1/2, 1/4, 0
        private string[] axisLabels = { "", "", "", "", "0" };
        public string[] AxisLabels { get => axisLabels; private set => SetProperty(ref axisLabels, value); }

        // Đường trung bình (nét đứt): khoảng cách từ mép trên vùng vẽ
        private Thickness averageMargin = new Thickness(0, PlotHeight, 0, 0);
        public Thickness AverageMargin { get => averageMargin; private set => SetProperty(ref averageMargin, value); }

        // Đường "TB 3 ngày": chiều cao (pixel) từ đáy vùng vẽ của từng ngày
        private double[] trendHeights = Array.Empty<double>();
        public double[] TrendHeights { get => trendHeights; private set => SetProperty(ref trendHeights, value); }

        // Độ lệch ngang (pixel) của từng ngày, từ tâm ô tới tâm cột kỳ này — đường TB 3 ngày đi qua đúng giữa cột
        private double[] trendOffsets = Array.Empty<double>();
        public double[] TrendOffsets { get => trendOffsets; private set => SetProperty(ref trendOffsets, value); }

        // Đường "Lấp đầy kỳ trước" (nét đứt): đi qua đúng tâm cột kỳ trước
        private double[] prevTrendHeights = Array.Empty<double>(), prevTrendOffsets = Array.Empty<double>();
        public double[] PrevTrendHeights { get => prevTrendHeights; private set => SetProperty(ref prevTrendHeights, value); }
        public double[] PrevTrendOffsets { get => prevTrendOffsets; private set => SetProperty(ref prevTrendOffsets, value); }

        // Kỳ trước có ít nhất 1 ngày có suất chiếu thì mới vẽ (ngày không có suất: đường đứt đoạn)
        private bool showPrevTrend;
        public bool ShowPrevTrend { get => showPrevTrend; private set => SetProperty(ref showPrevTrend, value); }

        // ================= "Giao dịch mới nhất" =================
        private string feedTab = "today";   // "today" | "yesterday" | "week"
        public bool IsFeedToday { get => feedTab == "today"; set { if (value) SetFeedTab("today"); } }
        public bool IsFeedYesterday { get => feedTab == "yesterday"; set { if (value) SetFeedTab("yesterday"); } }
        public bool IsFeedWeek { get => feedTab == "week"; set { if (value) SetFeedTab("week"); } }

        private string feedSearch = "";
        public string FeedSearch
        {
            get => feedSearch;
            set { if (SetProperty(ref feedSearch, value)) RefreshFeed(); }
        }

        public ObservableCollection<ActivityItem> Feed { get; } = new();

        private string feedCountText = "0", feedCountLabel = "hoạt động mới hôm nay";
        public string FeedCountText { get => feedCountText; private set => SetProperty(ref feedCountText, value); }
        public string FeedCountLabel { get => feedCountLabel; private set => SetProperty(ref feedCountLabel, value); }

        private bool isFeedEmpty;
        public bool IsFeedEmpty { get => isFeedEmpty; private set => SetProperty(ref isFeedEmpty, value); }

        // ================= "Lịch sử giao dịch gần đây" =================
        public ObservableCollection<RecentSale> Recent { get; } = new();

        private bool isRecentEmpty;
        public bool IsRecentEmpty { get => isRecentEmpty; private set => SetProperty(ref isRecentEmpty, value); }

        private bool? allSelected = false;
        public bool? AllSelected
        {
            get => allSelected;
            set
            {
                if (!SetProperty(ref allSelected, value) || value == null) return;
                foreach (var row in Recent) row.IsSelected = value.Value;
            }
        }

        private string sortKey = "time";
        private bool sortAscending;

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
        public ICommand SetRangeCommand { get; }
        public ICommand SortCommand { get; }

        public DashboardViewModel()
        {
            ReloadCommand = new RelayCommand(async _ => await LoadAsync());
            SetRangeCommand = new RelayCommand(async p =>
            {
                if (p is string s && int.TryParse(s, out int days) && days != RangeDays)
                {
                    RangeDays = days;
                    await LoadAsync();
                }
            });
            SortCommand = new RelayCommand(p =>
            {
                if (p is not string key) return;
                sortAscending = key == sortKey ? !sortAscending : key is "code" or "customer" or "status";
                sortKey = key;
                RefreshRecent();
            });
            autoRefresh.Tick += async (s, e) => await LoadAsync(quiet: true);
            _ = LoadAsync();
        }
        public void StartAutoRefresh() => autoRefresh.Start();
        public void StopAutoRefresh() => autoRefresh.Stop();
        // ================= Tải dữ liệu =================
        // quiet = true: tải lại ngầm theo hẹn giờ (không làm mờ màn, lỗi thì giữ số liệu đang hiện)
        private async Task LoadAsync(bool quiet = false)
        {
            if (isBusy) return;           // lần tải trước chưa xong → bỏ qua
            isBusy = true;
            if (!quiet) IsLoading = true;
            DateTime today = DateTime.Today;
            DateTime from = today.AddDays(-(RangeDays * 2 - 1));   // gồm cả kỳ trước để so sánh
            DateTime to = today.AddDays(1);
            DateTime salesFrom = today.AddDays(-6);                 // "Tuần này" ở cột hoạt động = 7 ngày gần nhất
            DateTime yesterday = today.AddDays(-1);
            DateTime yesterdaySameTime = yesterday + DateTime.Now.TimeOfDay;

            try
            {
                var result = await Task.Run(() => (
                    shows: showtimes.GetRange(from, to),                      // ghế, vé của suất: theo NGÀY CHIẾU
                    daily: revenue.GetByTime(from, to, byHour: false),       // tiền, vé bán: theo NGÀY LẬP ĐƠN
                    ySame: revenue.GetSummary(yesterday, yesterdaySameTime), // hôm qua tính tới giờ này
                    sales: booking.GetSales(salesFrom, to)));                 // từng đơn: chỉ cần 7 ngày cho cột hoạt động
                var stats = BuildDailyStats(from, to, result.daily, result.shows);
                Fill(stats, result.sales.Select(b => new SaleRecord(b)).ToList(), result.ySame);
                Message = "";             // tải được → tắt thông báo lỗi cũ (nếu có)
            }
            catch (Exception)
            {
                if (!quiet) Clear();      // tải ngầm lỗi: giữ nguyên số đang hiện, chỉ báo lỗi
                Message = "Không kết nối được cơ sở dữ liệu. Đang thử lại mỗi 2 phút, hoặc bấm Tải lại (nút ⋮ ở góc trên).";
            }
            IsLoading = false;
            isBusy = false;
        }
        // Gộp số liệu theo ngày từ dữ liệu có sẵn:
        //   - doanh thu, số vé bán: đơn đã thanh toán (RevenueService.GetByTime), theo NGÀY LẬP ĐƠN
        //     → cùng nguồn với màn Thống kê doanh thu nên hai màn luôn ra cùng một số
        //   - vé của suất, tỷ lệ lấp đầy: ghế đã bán / tổng ghế (ShowtimeService.GetRange), theo NGÀY CHIẾU
        private static List<DailyStat> BuildDailyStats(DateTime from, DateTime to, List<RevenuePoint> daily, List<Showtime> shows)
        {
            var list = new List<DailyStat>();
            for (DateTime d = from.Date; d < to; d = d.AddDays(1))
            {
                var day = daily.Where(p => p.Time.Date == d).ToList();
                var dayShows = shows.Where(s => s.StartTime.Date == d).ToList();
                list.Add(new DailyStat
                {
                    Day = d,
                    Revenue = day.Sum(p => p.Amount),
                    Tickets = day.Sum(p => p.Tickets),
                    Seats = dayShows.Sum(s => s.TotalSeats),
                    SoldSeats = dayShows.Sum(s => s.SoldSeats),
                });
            }
            return list;
        }
        private void Fill(List<DailyStat> stats, List<SaleRecord> sales, RevenueSummary ySame)
        {
            var current = stats.Skip(RangeDays).ToList();      // RangeDays ngày gần nhất, ngày cuối = hôm nay
            var previous = stats.Take(RangeDays).ToList();     // cùng số ngày ngay trước đó
            DailyStat today = current[^1];
            DailyStat yesterday = current.Count > 1 ? current[^2] : previous[^1];

            // ---- 3 thẻ số liệu ----
            RevenueTodayText = Format.Money(today.Revenue);
            TicketsTodayText = Format.Number(today.Tickets);
            OccupancyTodayText = Math.Round(today.Occupancy) + "%";
            bool hasOrderToday = today.Tickets > 0;
        
            RevenueDelta = hasOrderToday ? DeltaInfo.Percent(today.Revenue, yesterday.Revenue, " so với hôm qua") : null;
            TicketsDelta = hasOrderToday ? DeltaInfo.Percent(today.Tickets, yesterday.Tickets, "") : null;
            OccupancyDelta = hasOrderToday && yesterday.Seats > 0 ? DeltaInfo.Points(today.Occupancy, yesterday.Occupancy) : null;
            // Biểu đồ nhỏ ở 3 thẻ luôn là 7 ngày gần nhất (không theo khoảng 7/14 ngày của biểu đồ lớn)
            var week = current.TakeLast(7).ToList();
            TicketsSpark = week.Select(d => (double)d.Tickets).ToArray();
            OccupancySpark = week.Select(d => d.Occupancy).ToArray();

            // ---- Biểu đồ tuần ----
            int total = current.Sum(d => d.SoldSeats);
            TotalTicketsText = Format.Number(total) + " vé";
            int prevShowDays = previous.Count(d => d.Seats > 0);   // số ngày kỳ trước có suất chiếu
            int curShowDays = current.Count(d => d.Seats > 0);
            canCompare = prevShowDays >= curShowDays;
            OnPropertyChanged(nameof(CompareText));
            TotalDelta = canCompare ? DeltaInfo.Percent(total, previous.Sum(d => d.SoldSeats), "") : null;
            FillChart(current, previous);

            // ---- Hoạt động & bảng giao dịch ----
            allActivities = BuildActivities(sales);
            RefreshFeed();
            recentAll = sales.OrderByDescending(s => s.CreatedAt).Take(RecentRows).Select(s => new RecentSale(s)).ToList();
            RefreshRecent();
        }

        private void FillChart(List<DailyStat> current, List<DailyStat> previous)
        {
            double max = Math.Max(current.Max(d => d.SoldSeats), previous.Max(d => d.SoldSeats));
            // Chừa ~15% phía trên để nhãn "Hôm nay: N" không bị cắt khi cột hôm nay cao nhất
            double step = NiceStep(max * 1.15 / 4);
            double axisMax = step * 4;
            AxisLabels = new[]
            {
                Format.Number((int)(step * 4)), Format.Number((int)(step * 3)),
                Format.Number((int)(step * 2)), Format.Number((int)step), "0"
            };

            double Height(int value) => value <= 0 ? 0 : Math.Max(4, value / axisMax * PlotHeight);
            double barWidth = current.Count <= 7 ? 24 : 12;

            // Có cột kỳ trước: cặp (kỳ này | 4px | kỳ trước) nằm giữa ô → tâm cột kỳ này lệch trái (barWidth/2 + 2).
            // Kỳ trước trống: chỉ còn cột kỳ này, nằm đúng giữa ô (thẳng hàng nhãn ngày).
            // Điểm "TB 3 ngày" luôn đặt đúng giữa cột kỳ này.
            var offsets = previous.Select(p => p.SoldSeats > 0 ? -(barWidth / 2 + 2) : 0.0).ToArray();

            // Tỷ lệ lấp đầy từng ngày (%) — vẽ theo trục phụ 0–100% nên không phụ thuộc axisMax của số vé
            var occupancy = current.Select(d => d.Occupancy).ToArray();
            var heights = occupancy.Select(o => Math.Min(o, 100) / 100 * PlotHeight).ToArray();

            // Lấp đầy kỳ trước: cùng trục 0–100%. Tâm cột kỳ trước luôn lệch phải (barWidth/2 + 2) so với tâm ô
            // (cặp cột: kỳ này | 4px | kỳ trước). Ngày kỳ trước KHÔNG có suất chiếu → NaN: đường đứt đoạn, không kéo về 0%.
            var prevOccupancy = previous.Select(d => d.Occupancy).ToArray();
            var prevHeights = previous.Select(d => d.Seats > 0 ? Math.Min(d.Occupancy, 100) / 100 * PlotHeight : double.NaN).ToArray();
            double prevOffset = barWidth / 2 + 2;
            bool showPrev = previous.Any(p => p.Seats > 0);

            ChartDays.Clear();
            for (int i = 0; i < current.Count; i++)
            {
                DailyStat d = current[i], p = previous[i];
                bool isToday = i == current.Count - 1;
                ChartDays.Add(new ChartDay
                {
                    Label = current.Count <= 7 ? $"{DayShort[(int)d.Day.DayOfWeek]} {d.Day:dd'/'MM}" : d.Day.ToString("dd'/'MM"),
                    CurrentHeight = Height(d.SoldSeats),
                    PreviousHeight = Height(p.SoldSeats),
                    HasPrevious = p.SoldSeats > 0,
                    BarWidth = barWidth,
                    IsToday = isToday,
                    ChipText = $"Hôm nay: {Format.Number(d.SoldSeats)}",
                    TipDate = $"{DayLong[(int)d.Day.DayOfWeek]}, {d.Day:dd'/'MM'/'yyyy}",
                    TipTickets = $"{Format.Number(d.SoldSeats)} vé",
                    TipPrevious = $"Cùng kỳ trước ({p.Day:dd'/'MM}): {Format.Number(p.SoldSeats)} vé",
                    TipOccupancy = $"Lấp đầy: {Format.Number((int)Math.Round(occupancy[i]))}%",
                    PointMargin = PointAt(heights[i] - 6, offsets[i]),
                    HasPrevOccupancy = p.Seats > 0,
                    TipPrevOccupancy = $"Lấp đầy: {Format.Number((int)Math.Round(prevOccupancy[i]))}%",
                    PrevPointMargin = PointAt(double.IsNaN(prevHeights[i]) ? 0 : prevHeights[i] - 6, prevOffset),
                });
            }

            double average = current.Average(d => d.SoldSeats);
            AverageMargin = new Thickness(0, PlotHeight - average / axisMax * PlotHeight, 0, 0);
            TrendOffsets = offsets;
            TrendHeights = heights;
            PrevTrendOffsets = previous.Select(_ => prevOffset).ToArray();
            PrevTrendHeights = prevHeights;
            ShowPrevTrend = showPrev;
        }
        // Điểm 12x12 đang căn giữa ô: muốn dịch ngang `offset` px thì chêm margin một bên = 2 × offset
        private static Thickness PointAt(double bottom, double offset) =>
            new Thickness(Math.Max(0, 2 * offset), 0, Math.Max(0, -2 * offset), bottom);

        // Bước chia trục đẹp: 1, 2, 2.5, 3, 4, 5 × 10^k (tối thiểu 25 vé / vạch)
        private static double NiceStep(double raw)
        {
            if (raw <= 25) return 25;
            double pow = Math.Pow(10, Math.Floor(Math.Log10(raw)));
            foreach (double m in new[] { 1, 2, 2.5, 3, 4, 5, 10 })
                if (raw <= m * pow) return m * pow;
            return 10 * pow;
        }

        // ================= Hoạt động =================
        private static List<ActivityItem> BuildActivities(List<SaleRecord> sales)
        {
            var list = new List<ActivityItem>();
            foreach (SaleRecord s in sales)
            {
                string tickets = $"{s.TicketCount} vé";
                if (s.CustomerName != null)
                    list.Add(new ActivityItem("member", "Thành viên mua vé", s.CreatedAt,
                        $"{s.CustomerName} · {s.Code} · +{s.Points} điểm"));
                else
                    list.Add(new ActivityItem("sale", "Bán vé thành công", s.CreatedAt,
                        $"{s.Code} · {s.MovieTitle} · {tickets}"));

                if (s.IsCancelled)
                    list.Add(new ActivityItem("cancel", "Hủy đơn", s.CancelledAt ?? s.CreatedAt,
                        string.IsNullOrWhiteSpace(s.CancelReason) ? $"{s.Code} · hoàn {s.AmountText}" : $"{s.Code} · {s.CancelReason}"));
            }
            return list.OrderByDescending(a => a.Time).ToList();
        }

        private void SetFeedTab(string tab)
        {
            feedTab = tab;
            OnPropertyChanged(nameof(IsFeedToday));
            OnPropertyChanged(nameof(IsFeedYesterday));
            OnPropertyChanged(nameof(IsFeedWeek));
            RefreshFeed();
        }

        private void RefreshFeed()
        {
            DateTime today = DateTime.Today;
            (DateTime from, DateTime to, string label) = feedTab switch
            {
                "yesterday" => (today.AddDays(-1), today, "hoạt động hôm qua"),
                "week" => (today.AddDays(-6), today.AddDays(1), "hoạt động trong 7 ngày"),
                _ => (today, today.AddDays(1), "hoạt động mới hôm nay"),
            };

            string q = FeedSearch.Trim();
            var items = allActivities
                .Where(a => a.Time >= from && a.Time < to)
                .Where(a => q.Length == 0
                            || a.Title.Contains(q, StringComparison.CurrentCultureIgnoreCase)
                            || a.Detail.Contains(q, StringComparison.CurrentCultureIgnoreCase))
                .ToList();

            Feed.Clear();
            for (int i = 0; i < items.Count; i++)
            {
                items[i].ShowConnector = i < items.Count - 1;
                Feed.Add(items[i]);
            }
            FeedCountText = Format.Number(items.Count);
            FeedCountLabel = label;
            IsFeedEmpty = items.Count == 0;
        }

        // ================= Bảng giao dịch =================
        private void RefreshRecent()
        {
            IEnumerable<RecentSale> rows = sortKey switch
            {
                "code" => recentAll.OrderBy(r => r.Sale.BookingID),
                "customer" => recentAll.OrderBy(r => r.Customer, StringComparer.CurrentCulture),
                "status" => recentAll.OrderBy(r => r.Sale.IsCancelled),
                "amount" => recentAll.OrderBy(r => r.Sale.Total),
                _ => recentAll.OrderBy(r => r.Sale.CreatedAt),
            };
            if (!sortAscending) rows = rows.Reverse();

            foreach (var row in Recent) row.PropertyChanged -= OnRowChanged;
            Recent.Clear();
            var list = rows.ToList();
            for (int i = 0; i < list.Count; i++)
            {
                list[i].IsLast = i == list.Count - 1;
                list[i].PropertyChanged += OnRowChanged;
                Recent.Add(list[i]);
            }
            IsRecentEmpty = list.Count == 0;
            UpdateAllSelected();
        }

        private void OnRowChanged(object? sender, System.ComponentModel.PropertyChangedEventArgs e)
        {
            if (e.PropertyName == nameof(RecentSale.IsSelected)) UpdateAllSelected();
        }

        private void UpdateAllSelected()
        {
            int selected = Recent.Count(r => r.IsSelected);
            allSelected = selected == 0 ? false : selected == Recent.Count ? true : null;
            OnPropertyChanged(nameof(AllSelected));
        }

        private void Clear()
        {
            RevenueTodayText = TicketsTodayText = OccupancyTodayText = TotalTicketsText = "—";
            RevenueDelta = TicketsDelta = OccupancyDelta = TotalDelta = null;
            TicketsSpark = OccupancySpark = Array.Empty<double>();
            TrendHeights = Array.Empty<double>();
            TrendOffsets = Array.Empty<double>();
            PrevTrendHeights = Array.Empty<double>();
            PrevTrendOffsets = Array.Empty<double>();
            ShowPrevTrend = false;
            ChartDays.Clear();
            allActivities = new();
            recentAll = new();
            RefreshFeed();
            RefreshRecent();
        }
    }

    // Viên thuốc tăng/giảm (xanh khi tăng hoặc bằng, đỏ khi giảm).
    public record DeltaInfo(string Text, bool IsUp)
    {
        public static DeltaInfo Percent(decimal now, decimal before, string suffix)
                => new DeltaInfo(Format.Change(now, before, signed: true) + suffix, now >= before);

        // Chênh lệch điểm phần trăm (tỷ lệ lấp đầy)
        public static DeltaInfo Points(double now, double before)
        {
            double diff = Math.Round(now - before);
            return new DeltaInfo((diff > 0 ? "+" : "") + diff + "%", diff >= 0);
        }
    }

    // Một ngày trên biểu đồ tuần: cột kỳ này + cột kỳ trước.
    public class ChartDay
    {
        public string Label { get; init; } = "";
        public double CurrentHeight { get; init; }
        public double PreviousHeight { get; init; }
        public bool HasPrevious { get; init; }   // kỳ trước có vé → mới vẽ cột kỳ trước
        public double BarWidth { get; init; }
        public bool IsToday { get; init; }
        public string ChipText { get; init; } = "";
        public string TipDate { get; init; } = "";
        public string TipTickets { get; init; } = "";   // vé của các suất chiếu trong ngày (gồm cả vé bán trước)
        public string TipPrevious { get; init; } = "";
        public string TipOccupancy { get; init; } = "";

        // Điểm "TB 3 ngày" của ngày này (phần tử riêng để rê chuột hiện chú thích)
        public Thickness PointMargin { get; init; }
      

        // Điểm "Lấp đầy kỳ trước": nằm đúng tâm cột kỳ trước
        public bool HasPrevOccupancy { get; init; }   // kỳ trước ngày này có suất chiếu → mới hiện điểm
        public string TipPrevOccupancy { get; init; } = "";
        public Thickness PrevPointMargin { get; init; }
       
    }

    // Một dòng ở cột "Giao dịch mới nhất". Kind: sale | member | cancel (View chọn icon theo Kind).
    public class ActivityItem
    {
        public ActivityItem(string kind, string title, DateTime time, string detail)
        {
            Kind = kind; Title = title; Time = time; Detail = detail;
        }

        public string Kind { get; }
        public string Title { get; }
        public DateTime Time { get; }
        public string Detail { get; }
        public bool ShowConnector { get; set; }
        public string TimeText => Time.Date == DateTime.Today ? Time.ToString("HH:mm") : Time.ToString("HH:mm dd'/'MM");
    }

    // Một dòng ở bảng "Lịch sử giao dịch gần đây".
    public class RecentSale : ObservableObject
    {
        public RecentSale(SaleRecord sale) { Sale = sale; }

        public SaleRecord Sale { get; }
        public string Code => Sale.Code;
        public string TimeText => Sale.CreatedAt.ToString("dd'/'MM'/'yyyy, HH:mm:ss");
        public string Customer => Sale.CustomerShort;
        public string StatusText => Sale.StatusText;
        public bool IsCancelled => Sale.IsCancelled;
        public string AmountText => Format.Money(Sale.Total);
        public bool IsLast { get; set; }

        private bool isSelected;
        public bool IsSelected { get => isSelected; set => SetProperty(ref isSelected, value); }
    }
}
