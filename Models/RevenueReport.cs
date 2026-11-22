namespace CinemaAPP.Models
{
    // Kết quả thống kê trong một khoảng thời gian [From, To).
    public class RevenueSummary
    {
        public decimal Revenue { get; set; }          // tổng TotalAmount của đơn đã thanh toán
        public int Orders { get; set; }               // số đơn đã thanh toán
        public int Tickets { get; set; }              // số vé thuộc các đơn đó
        public int CancelledOrders { get; set; }
        public int OrdersWithCustomer { get; set; }   // đơn có khách thành viên
        public decimal MemberRevenue { get; set; }    // doanh thu của các đơn có khách thành viên
    }

    // Một ô heatmap: số vé của các suất chiếu bắt đầu trong khung 3 giờ [Slot, Slot + 3) của ngày Day.
    public class HeatCell
    {
        public DateTime Day { get; set; }
        public int Slot { get; set; }                 // 9, 12, 15, 18, 21 …
        public int Tickets { get; set; }
    }

    // Doanh thu vé theo định dạng chiếu (2D, IMAX …).
    public class FormatRevenue
    {
        public string Format { get; set; } = "";
        public decimal Amount { get; set; }
    }

    // Một mốc trên biểu đồ: một ngày, hoặc một giờ trong ngày.
    public class RevenuePoint
    {
        public DateTime Time { get; set; }
        public decimal Amount { get; set; }
        public int Tickets { get; set; }              // số vé của các đơn trong mốc này
    }

    public class MovieRevenue
    {
        public string Title { get; set; } = "";
        public int Tickets { get; set; }
        public decimal Amount { get; set; }
    }

    public class StaffRevenue
    {
        public string Username { get; set; } = "";
        public string FullName { get; set; } = "";
        public int Orders { get; set; }
        public int Tickets { get; set; }
        public decimal Amount { get; set; }
    }
}
