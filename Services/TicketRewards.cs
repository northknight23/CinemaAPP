using CinemaAPP.ViewModels;

namespace CinemaAPP.Services
{
    public static class TicketRewards
    {
        // Cộng phần tích lũy cả đơn, quy đổi 1.000đ = 1 điểm rồi làm tròn xuống.
        public static int Calculate(IEnumerable<(SeatType Type, decimal Price)> seats, decimal discount = 0)
        {
            var items = seats.ToArray();
            decimal gross = items.Sum(s => s.Price);
            if (discount < 0 || discount > gross)
                throw new ArgumentOutOfRangeException(nameof(discount));
            if (gross == 0) return 0;
            // Phân bổ giảm giá theo tỷ lệ giá từng ghế, không tích điểm trên phần đã giảm.
            return (int)decimal.Floor(items.Sum(s => s.Price * (s.Type switch
            {
                SeatType.Vip => 0.07m,
                SeatType.Couple => 0.10m,
                _ => 0.05m,
            })) * (gross - discount) / gross / 1000m);
        }
    }
}
