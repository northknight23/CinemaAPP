using CinemaAPP.ViewModels;

namespace CinemaAPP.Services
{
    // Kho đơn bán dùng chung cho màn Bán vé và màn Giao dịch khi chưa ghép CSDL.
    // Ban đầu rỗng: chỉ có các đơn thật vừa thanh toán ở màn Bán vé trong lần chạy này. Đóng app là mất.
    // Dữ liệu test nằm ngoài project (E:\project cinema\TestData), không thêm đơn giả vào đây.
    // Khi ghép CSDL: thay bằng BookingService (đọc BOOKING + TICKET, hủy đơn, lưu bàn giao ca).
    public static class SalesDemoStore
    {
        public static List<SaleRecord> Sales { get; } = new List<SaleRecord>();

        // Nhân viên nộp báo cáo chốt ca: (ngày, username) → tiền đếm được + ghi chú. Chờ Quản trị viên xác nhận.
        public static Dictionary<(DateTime Day, string Username), ShiftReport> ShiftReports { get; } = new();

        // Bàn giao ca: (ngày, username) → kết quả Quản trị viên xác nhận. Sau này là bảng riêng (nhờ A thêm nếu nhóm làm phần này).
        public static Dictionary<(DateTime Day, string Username), Handover> Handovers { get; } = new();

        // Lý do hủy đơn, dùng chung cho Nhân viên và Quản trị viên
        public static List<string> CancelReasons { get; } = new()
        {
            "Khách đổi ý", "Nhầm suất / ghế", "Lỗi thanh toán", "Sự cố phòng chiếu",
        };

        public static int NextBookingId { get; private set; } = 1001;

        public static SaleRecord Add(SaleRecord draft)
        {
            var sale = new SaleRecord
            {
                BookingID = NextBookingId++, CreatedAt = draft.CreatedAt, MovieTitle = draft.MovieTitle,
                ShowStart = draft.ShowStart, RoomName = draft.RoomName, ShowFormat = draft.ShowFormat,
                Seats = draft.Seats, StaffName = draft.StaffName, StaffUsername = draft.StaffUsername,
                CustomerName = draft.CustomerName, CustomerPhone = draft.CustomerPhone,
                Method = draft.Method, CashGiven = draft.CashGiven, Total = draft.Total,
            };
            Sales.Add(sale);
            return sale;
        }
    }

    // Báo cáo chốt ca nhân viên tự nộp (tiền mặt đếm được trong két).
    public record ShiftReport(decimal CountedCash, string Note, DateTime At);

    // Kết quả bàn giao tiền mặt cuối ca của một nhân viên trong một ngày.
    public record Handover(decimal CountedCash, string Note, DateTime At, string By);
}
