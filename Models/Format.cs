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

        // Tỷ lệ thay đổi so với kỳ trước — dùng chung cho Tổng quan, Khách hàng, Tài khoản.
        // Kỳ trước = 0: không chia được → nay có số thì "Mới", nay cũng 0 thì "0%".
        // signed = true  → "+12,5%" / "-3%"      (Tổng quan: không có mũi tên nên cần dấu)
        // signed = false → "12,5%"               (Khách hàng, Tài khoản: đã có mũi tên ↑↓)
        public static string Change(decimal now, decimal before, bool signed = false)
        {
            if (before == 0) return now == 0 ? "0%" : "Mới";
            decimal pct = Math.Round((now - before) * 100m / before, 1);
            if (!signed) pct = Math.Abs(pct);
            string sign = signed && pct > 0 ? "+" : "";
            return sign + pct.ToString("0.#", Vi) + "%";
        }
    }
}
