
using System;
using System.Collections.Generic;
using System.Text;

namespace CinemaAPP.Models
{
    public record SoldSeat(string Label, SeatType Type, int Count = 1);
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
        // ---- Lấy từ bảng khác (BookingService JOIN sẵn) ----
        public string StaffUsername { get; set; } = "";     // ACCOUNT.Username người bán
        public string StaffName { get; set; } = "";         // ACCOUNT.FullName người bán
        public string? CustomerName { get; set; }           // CUSTOMER.FullName (null = khách vãng lai)
        public string? CustomerPhone { get; set; }          // CUSTOMER.Phone
        public string CancelledByName { get; set; } = "";   // ACCOUNT.FullName người hủy
        public string MovieTitle { get; set; } = "";        // MOVIE.Title
        public DateTime ShowStart { get; set; }             // SHOWTIME.StartTime
        public string RoomName { get; set; } = "";          // ROOM.RoomName
        public string ShowFormat { get; set; } = "";        // SHOWTIME.ShowFormat
        public List<SoldSeat> Seats { get; set; } = new();  // các ghế của đơn

        public bool IsCancelled => BookingStatus == BookingStatus.Cancelled;
    }
}
