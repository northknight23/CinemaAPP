namespace CinemaAPP.Models
{
    public class Customer
    {
        // ---- Cột của bảng CUSTOMER ----
        public int CustomerID { get; set; }
        public string FullName { get; set; } = "";
        public string Phone { get; set; } = "";
        public int Points { get; set; }

        // ---- Tính từ BOOKING khi tải danh sách (không phải cột của CUSTOMER) ----
        public int OrderCount { get; set; }          // mọi đơn, kể cả đơn hủy → dùng để chặn xóa
        public decimal TotalSpent { get; set; }      // chỉ đơn đã thanh toán
        public DateTime? LastPurchase { get; set; }  // chỉ đơn đã thanh toán

        // ---- Chỉ để hiển thị ----
        public string PhoneText => Phone.Length == 10
            ? $"{Phone[..4]} {Phone[4..7]} {Phone[7..]}"
            : Phone;

        public string LastPurchaseText => LastPurchase?.ToString("dd'/'MM'/'yyyy") ?? "—";

        public string Initials => NameHelper.Initials(FullName);
    }
}
