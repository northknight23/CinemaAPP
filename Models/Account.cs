namespace CinemaAPP.Models
{
    public class Account
    {
        // ---- Cột của bảng ACCOUNT (PasswordHash không bao giờ đưa lên giao diện) ----
        public int AccountID { get; set; }
        public string Username { get; set; } = "";
        public string FullName { get; set; } = "";
        public string AccountRole { get; set; } = "";

        public bool IsAdmin => AccountRole == Roles.Admin;

        // ---- Tính từ BOOKING khi tải danh sách (không phải cột) ----
        public int OrderCount { get; set; }          // mọi đơn, kể cả đơn hủy → dùng để chặn xóa
        public int PaidOrders { get; set; }          // đơn đã thanh toán
        public decimal Revenue { get; set; }         // tổng tiền các đơn đã thanh toán
        public int TodayOrders { get; set; }         // đơn đã thanh toán hôm nay
        public DateTime? LastSale { get; set; }      // lần bán gần nhất (đơn đã thanh toán)

        // ---- Chỉ để hiển thị ----
        public string RoleText => IsAdmin ? "Quản trị" : "Nhân viên";
        public string Initials => NameHelper.Initials(FullName);
        public string OrderCountText => Format.Number(OrderCount);
        public string AtUsername => "@" + Username;

        // Quản trị không bán vé → cột số đơn hiện "—"
        public string OrdersColumnText => IsAdmin ? "—" : Format.Number(PaidOrders);
        public bool HasOrders => PaidOrders > 0;

        public string LastSaleText
        {
            get
            {
                if (IsAdmin) return "Không bán vé";
                if (LastSale == null) return "Chưa bán";
                int days = (DateTime.Today - LastSale.Value.Date).Days;
                return days <= 0 ? "Hôm nay" : days == 1 ? "Hôm qua" : $"{days} ngày trước";
            }
        }

        // 0–5: chọn màu nền avatar để mỗi người một màu
        public int AvatarTone => AccountID % 6;

        // Có phải tài khoản đang đăng nhập không (gán khi tải danh sách)
        public bool IsSelf { get; set; }
    }

    // Giá trị của cột ACCOUNT.AccountRole.
    public static class Roles
    {
        public const string Admin = "Admin";
        public const string Staff = "Staff";
    }
}
