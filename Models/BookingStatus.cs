namespace CinemaAPP.Models
{
    // Giá trị của cột BOOKING.BookingStatus. Màn bán vé (C) ghi, màn thống kê (A) đọc
    // → hai bên phải dùng đúng các hằng này.
    public static class BookingStatus
    {
        public const string Paid = "Paid";            // đã thanh toán → tính vào doanh thu
        public const string Cancelled = "Cancelled";  // đã hủy → không tính doanh thu
    }
}
