namespace CinemaAPP.Services
{
    // Danh sách lý do hủy đơn dùng chung + bộ nhớ đệm đồng bộ từ bảng SHIFT_HANDOVER
    // (để StaffDashboardViewModel hiển thị đúng trạng thái chốt ca ngay khi mở app mà không cần sửa file của A).
    // Mọi thao tác đọc/ghi chính thức đi qua ShiftService (SQL Server).
    public static class SalesDemoStore
    {
        private static readonly object CacheLock = new();
        private static readonly Dictionary<(DateTime Day, string Username), ShiftReport> shiftReports = new();
        private static readonly Dictionary<(DateTime Day, string Username), Handover> handovers = new();
        private static DateTime? loadedDay;

        public static Dictionary<(DateTime Day, string Username), ShiftReport> ShiftReports
        {
            get
            {
                EnsureTodayLoaded();
                return shiftReports;
            }
        }

        public static Dictionary<(DateTime Day, string Username), Handover> Handovers
        {
            get
            {
                EnsureTodayLoaded();
                return handovers;
            }
        }

        // Lý do hủy đơn, dùng chung cho Nhân viên và Quản trị viên
        public static List<string> CancelReasons { get; } = new()
        {
            "Khách đổi ý", "Nhầm suất / ghế", "Lỗi thanh toán", "Sự cố phòng chiếu",
        };

        internal static void SyncDayCache(DateTime day, IEnumerable<ShiftEntry> entries)
        {
            DateTime date = day.Date;
            lock (CacheLock)
            {
                foreach (var key in shiftReports.Keys.Where(k => k.Day == date).ToList())
                    shiftReports.Remove(key);
                foreach (var key in handovers.Keys.Where(k => k.Day == date).ToList())
                    handovers.Remove(key);

                foreach (var entry in entries)
                {
                    var key = (date, entry.Username);
                    if (entry.Report != null) shiftReports[key] = entry.Report;
                    if (entry.Handover != null) handovers[key] = entry.Handover;
                }
                if (date == DateTime.Today)
                    loadedDay = date;
            }
        }

        internal static void SyncStaffCache(DateTime day, string username, ShiftReport? report, Handover? handover)
        {
            var key = (day.Date, username);
            lock (CacheLock)
            {
                if (report != null) shiftReports[key] = report;
                else shiftReports.Remove(key);

                if (handover != null) handovers[key] = handover;
                else handovers.Remove(key);
            }
        }

        internal static void ClearCache()
        {
            lock (CacheLock)
            {
                shiftReports.Clear();
                handovers.Clear();
                loadedDay = null;
            }
        }

        private static void EnsureTodayLoaded()
        {
            DateTime today = DateTime.Today;
            lock (CacheLock)
            {
                if (loadedDay == today) return;
                loadedDay = today;
            }
            try
            {
                new ShiftService().GetByDate(today);
            }
            catch
            {
                // Bỏ qua khi đang mở XAML Designer hoặc chưa kết nối SQL; các màn chính sẽ báo lỗi trực tiếp.
                lock (CacheLock)
                {
                    if (loadedDay == today) loadedDay = null;
                }
            }
        }
    }

    // Báo cáo chốt ca nhân viên tự nộp (tiền mặt đếm được trong két).
    public record ShiftReport(decimal CountedCash, string Note, DateTime At);

    // Kết quả bàn giao tiền mặt cuối ca của một nhân viên trong một ngày.
    public record Handover(decimal CountedCash, string Note, DateTime At, string By);
}
