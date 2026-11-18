namespace CinemaAPP.ViewModels
{
    // Các "dòng" chỉ để hiển thị trên màn Thống kê (đã tính sẵn chữ và kích thước).

    public class ChartBar
    {
        public string Label { get; set; } = "";       // "T5 05/11", "09–12h"
        public string ValueText { get; set; } = "";   // "19,9" (triệu)
        public string ToolTip { get; set; } = "";     // "T5 05/11: 19.850.000 đ"
        public double BarHeight { get; set; }          // pixel
        public bool IsMax { get; set; }                // cột cao nhất → tô vàng
        public bool ShowValue { get; set; }            // ít cột thì hiện số trên đầu cột
    }

    public class MovieRow
    {
        public int Rank { get; set; }
        public string Title { get; set; } = "";
        public string AmountText { get; set; } = "";
        public string DetailText { get; set; } = "";  // "320 vé · 31%"
        public double Percent { get; set; }            // 0–100, so với phim đứng đầu
    }

    public class StaffRow
    {
        public string Initials { get; set; } = "";
        public string FullName { get; set; } = "";
        public string Username { get; set; } = "";
        public string OrdersText { get; set; } = "";
        public string TicketsText { get; set; } = "";
        public string AmountText { get; set; } = "";
        public string ShareText { get; set; } = "";
        public double Percent { get; set; }            // 0–100, tỷ trọng trong tổng doanh thu
    }
}
