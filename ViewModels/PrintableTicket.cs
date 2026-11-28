using CinemaAPP.Models;
using CinemaAPP.Services;

namespace CinemaAPP.ViewModels
{
    public sealed record PrintableTicket(ShowtimeOption Show, string AgeRating, string StaffName,
        PaymentMethod Method, bool HasMember, int PointsUsed, IReadOnlyList<TicketSeat> Seats, Booking? Sale)
    {
        public string TicketCode => Sale == null ? "" : FormattableString.Invariant($"{Sale.BookingID}");
        public string MovieText => string.IsNullOrWhiteSpace(AgeRating) ? Show.MovieTitle : $"{Show.MovieTitle} [{AgeRating}]";
        public string ShowtimeText => $"{Show.StartTime:dd/MM/yyyy} · {Show.TimeRange}";
        public string MethodText => SaleRecord.MethodName(Method);
        public decimal DiscountAmount => PointsUsed * 1000m;
        public string SubtotalText => Format.Money(Seats.Sum(s => s.Price));
        public string DiscountText => $"-{Format.Money(DiscountAmount)} ({PointsUsed} điểm)";
        public string TotalText => Format.Money(Seats.Sum(s => s.Price) - DiscountAmount);
        public int Points => Sale?.PointsEarned ?? (HasMember ? TicketRewards.Calculate(Seats.Select(s => (s.Type, s.Price)), DiscountAmount) : 0);
        public string PointsText => HasMember ? $"+{Points} điểm" : "0 điểm · Khách vãng lai";
        public string StatusText => Sale == null ? "Xem trước · Chưa thanh toán" : $"Đã thanh toán · {Sale.CreatedAt:HH:mm dd/MM/yyyy}";
    }

    public sealed record TicketSeat(string Label, SeatType Type, decimal Price)
    {
        public string PriceText => Format.Money(Price);
        public string TypeText => Type switch
        {
            SeatType.Vip => "Vé VIP",
            SeatType.Couple => "Vé đôi",
            _ => "Vé thường",
        };
    }
}
