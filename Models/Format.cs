using System.Globalization;

namespace CinemaAPP.Models
{
    // Định dạng số kiểu Việt Nam: 1.250.000 đ
    public static class Format
    {
        public static readonly CultureInfo Vi = CultureInfo.GetCultureInfo("vi-VN");

        public static string Money(decimal amount) => amount.ToString("N0", Vi) + " đ";

        public static string Number(int n) => n.ToString("N0", Vi);

        // 19.850.000 → "19,9" (đơn vị triệu, dùng trên cột biểu đồ)
        public static string Million(decimal amount) => (amount / 1_000_000m).ToString("0.0", Vi);
    }
}
