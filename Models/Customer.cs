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
        public int OrderCount { get; set; }              // mọi đơn, kể cả đơn hủy → dùng để chặn xóa
        public int PaidOrders { get; set; }              // chỉ đơn đã thanh toán
        public decimal TotalSpent { get; set; }          // chỉ đơn đã thanh toán
        public DateTime? LastPurchase { get; set; }      // chỉ đơn đã thanh toán
        public DateTime? FirstPurchase { get; set; }     // chỉ đơn đã thanh toán
        public decimal SpentBeforeMonth { get; set; }    // tổng chi tiêu tính tới đầu tháng này (để so sánh)
        public int PaidOrdersBeforeMonth { get; set; }   // số đơn đã thanh toán tính tới đầu tháng này

        // ---- Hạng thành viên (tính theo tổng chi tiêu, không lưu trong CSDL) ----
        public string Tier => MemberTier.Of(TotalSpent);
        public string TierText => MemberTier.Text(Tier);
        public bool IsGold => Tier == MemberTier.Gold;

        // ---- Chỉ để hiển thị ----
        public string PhoneText => Phone.Length == 10
            ? $"{Phone[..4]} {Phone[4..7]} {Phone[7..]}"
            : Phone;

        public string PointsText => Format.Number(Points) + " điểm";
        public bool HasPoints => Points > 0;

        public string LastPurchaseText => LastPurchase?.ToString("dd'/'MM'/'yyyy") ?? "—";

        // "Hôm nay", "Hôm qua", "3 ngày trước", "Chưa mua"
        public string LastPurchaseRelative
        {
            get
            {
                if (LastPurchase == null) return "Chưa mua";
                int days = (DateTime.Today - LastPurchase.Value.Date).Days;
                return days <= 0 ? "Hôm nay" : days == 1 ? "Hôm qua" : $"{days} ngày trước";
            }
        }

        public string Initials => NameHelper.Initials(FullName);

        // 0–5: chọn màu nền avatar để mỗi khách một màu (XAML đổi màu theo số này)
        public int AvatarTone => CustomerID % 6;
    }

    // Quy tắc hạng thành viên: Thường < 1 triệu ≤ Bạc < 3 triệu ≤ Vàng
    public static class MemberTier
    {
        public const string Basic = "basic";
        public const string Silver = "silver";
        public const string Gold = "gold";

        public const decimal SilverFrom = 1_000_000m;
        public const decimal GoldFrom = 3_000_000m;

        public static string Of(decimal spent) =>
            spent >= GoldFrom ? Gold : spent >= SilverFrom ? Silver : Basic;

        public static string Text(string tier) => tier switch
        {
            Gold => "Vàng",
            Silver => "Bạc",
            _ => "Thường"
        };
    }
}
