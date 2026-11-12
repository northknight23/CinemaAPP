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
        public int OrderCount { get; set; }

        // ---- Chỉ để hiển thị ----
        public string RoleText => IsAdmin ? "Quản trị" : "Nhân viên";
        public string Initials => NameHelper.Initials(FullName);
        public string OrderCountText => Format.Number(OrderCount);
    }

    // Giá trị của cột ACCOUNT.AccountRole.
    public static class Roles
    {
        public const string Admin = "Admin";
        public const string Staff = "Staff";
    }
}
