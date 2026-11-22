using System.Windows;

namespace CinemaAPP.ViewModels
{
    // Các "dòng" chỉ để hiển thị trên màn Thống kê (đã tính sẵn chữ và kích thước).

    // Một mốc trên biểu đồ vùng của ô Tổng doanh thu (một ngày, hoặc một khung giờ khi xem 1 ngày).
    public class TrendPoint
    {
        public string Label { get; set; } = "";        // "T7 14", "14", "09–12h"
        public string ToolTip { get; set; } = "";      // "T7 14/11/2026: 30.812.000 đ"
        public string ValueText { get; set; } = "";    // "36,3 tr" (chỉ hiện ở mốc cao nhất)
        public Thickness PointMargin { get; set; }     // đẩy chấm tròn lên đúng độ cao của đường
        public Thickness TipMargin { get; set; }       // nhãn vàng nằm ngay trên chấm
        public bool IsMax { get; set; }                // mốc cao nhất → chấm vàng + nhãn
    }

    // Một hàng của heatmap: một khung giờ chiếu, mỗi ô là một ngày.
    public class HeatRow
    {
        public string Label { get; set; } = "";        // "9h"
        public List<HeatCellRow> Cells { get; set; } = new();
    }

    public class HeatCellRow
    {
        public string Text { get; set; } = "";         // "106"
        public string ToolTip { get; set; } = "";      // "T4 18/11 · suất 9h–12h: 106 vé"
        public double Level { get; set; }              // 0–1: độ đậm của ô (nhiều vé → đậm)
        public bool IsStrong { get; set; }             // ô đậm → chữ trắng
    }

    // Một phần của thanh định dạng chiếu (2D, IMAX, Khác).
    public class FormatShare
    {
        public string Label { get; set; } = "";        // "2D"
        public string AmountText { get; set; } = "";   // "155,7 tr"
        public string PercentText { get; set; } = "";  // "75%"
        public int Tone { get; set; }                  // 0, 1, 2 → màu thứ mấy của thanh
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
        public int Rank { get; set; }
        public bool IsTop { get; set; }                // hạng 1 → nhãn vàng
        public bool IsLast { get; set; }               // dòng cuối → bỏ viền dưới
        public string Initials { get; set; } = "";
        public string FullName { get; set; } = "";
        public string DetailText { get; set; } = "";   // "nv02 · 287 đơn · 700 vé"
        public string AmountText { get; set; } = "";
        public string ShareText { get; set; } = "";    // tỷ trọng trong tổng doanh thu
        public double Percent { get; set; }            // 0–100, so với người đứng đầu (độ dài thanh)
    }
}
