namespace CinemaAPP.Models
{
    // Số liệu của một ngày cho màn Tổng quan.
    public class DailyStat
    {
        public DateTime Day { get; set; }
        public decimal Revenue { get; set; }   // tổng TotalAmount của đơn đã thanh toán lập trong ngày
        public int Tickets { get; set; }       // số vé thuộc các đơn đó
        public int Seats { get; set; }         // tổng ghế của các suất chiếu trong ngày
        public int SoldSeats { get; set; }     // số vé Active của các suất chiếu trong ngày
        public double Occupancy => Seats == 0 ? 0 : (double)SoldSeats / Seats * 100;
    }
}
