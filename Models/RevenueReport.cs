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
    }

    // Một mốc trên biểu đồ: một ngày, hoặc một giờ trong ngày.
    public class RevenuePoint
    {
        public DateTime Time { get; set; }
        public decimal Amount { get; set; }
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
