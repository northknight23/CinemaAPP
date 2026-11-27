
using System;
using System.Collections.Generic;
using System.Text;

namespace CinemaAPP.Models
{

    public enum BookingStatus { Paid, Cancelled }
    public enum PaymentMethod { Cash, Transfer, Card}
    public class Booking
    {
        public static IReadOnlyList<string> CancelReasons { get; } = new[]
    {
            "Khách đổi ý", "Nhầm suất / ghế", "Lỗi thanh toán", "Sự cố phòng chiếu",
        };
        public int BookingID { get; set; }
        public int AccountID { get; set; }
        public int? CustomerID { get; set; }
        public DateTime CreatedAt { get; set; }
        public decimal TotalAmount { get; set; }
        public BookingStatus BookingStatus { get; set; } = BookingStatus.Paid;
        public PaymentMethod? PaymentMethod { get; set; }
        public decimal? CashGiven { get; set; }
        public int PointsEarned { get; set; }
        public int PointsUsed { get; set; }
        public string? CancelReason { get; set; }
        public DateTime? CancelledAt { get; set; }
        public int? CancelledBy { get; set; }
    }
}
