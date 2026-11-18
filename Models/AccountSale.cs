namespace CinemaAPP.Models
{
    // Một đơn bán vé của nhân viên (dùng cho mục "Bán gần đây" trong hồ sơ tài khoản)
    public class AccountSale
    {
        public int BookingID { get; set; }
        public DateTime CreatedAt { get; set; }
        public string MovieTitle { get; set; } = "";
        public DateTime? ShowStart { get; set; }
        public int Tickets { get; set; }
        public string? CustomerName { get; set; }
        public decimal Amount { get; set; }

        // Hôm nay → "19:42"; ngày khác → "10/11"
        public string TimeText => CreatedAt.Date == DateTime.Today ? CreatedAt.ToString("HH:mm") : CreatedAt.ToString("dd'/'MM");
        public string AmountText => Format.Money(Amount);

        // "Suất 19:00 · 3 vé · Phạm Thu Hà" (không có khách thành viên → "Khách lẻ")
        public string MetaText
        {
            get
            {
                string show = ShowStart != null ? $"Suất {ShowStart:HH:mm} · " : "";
                return $"{show}{Tickets} vé · {CustomerName ?? "Khách lẻ"}";
            }
        }
    }
}
