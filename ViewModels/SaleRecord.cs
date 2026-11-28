using CinemaAPP.Helpers;
using CinemaAPP.Models;

namespace CinemaAPP.ViewModels
{
    

    // Một nhân viên bán vé (lấy từ người bán của đơn / bảng ACCOUNT).
    public record StaffInfo(string FullName, string Username, string Shift)
    {
        public string Initials => NameHelper.Initials(FullName);
    }

    // Một dòng đơn trên các màn Hóa đơn ca / Giao dịch / Tổng quan: dữ liệu Booking + chữ hiển thị.
    public class SaleRecord
    {
        public Booking Data { get; }
        public SaleRecord(Booking data) { Data = data; }

        // ----- Lấy thẳng từ Model (giữ tên cũ để View và các ViewModel khác không phải sửa) -----
        public int BookingID => Data.BookingID;
        public int AccountID => Data.AccountID;
        public int? CustomerID => Data.CustomerID;
        public DateTime CreatedAt => Data.CreatedAt;
        public string MovieTitle => Data.MovieTitle;
        public DateTime ShowStart => Data.ShowStart;
        public string RoomName => Data.RoomName;
        public string ShowFormat => Data.ShowFormat;
        public List<SoldSeat> Seats => Data.Seats;
        public string StaffName => Data.StaffName;
        public string StaffUsername => Data.StaffUsername;
        public string? CustomerName => Data.CustomerName;
        public string? CustomerPhone => Data.CustomerPhone;
        public PaymentMethod? Method => Data.PaymentMethod;
        public decimal CashGiven => Data.CashGiven ?? 0;
        public decimal Total => Data.TotalAmount;
        public int Points => Data.PointsEarned;
        public int PointsUsed => Data.PointsUsed;
        public bool IsCancelled => Data.IsCancelled;
        public string CancelReason => Data.CancelReason ?? "";
        public DateTime? CancelledAt => Data.CancelledAt;
        public string CancelledBy => Data.CancelledByName;

        // ----- Chỉ để hiển thị -----
        public string Code => "#" + BookingID;
        public string TimeText => CreatedAt.ToString("HH:mm");
        public string ShowText => $"{ShowStart:HH:mm} · {RoomName.Replace("Phòng ", "P")} · {ShowFormat}";
        public string ShowLong => $"{ShowStart:HH:mm} · {RoomName} · {ShowFormat}";
        public int TicketCount => Seats.Sum(s => s.Count);
        public string SeatsText => string.Join(", ", Seats.Select(s => s.Label));
        public string AmountText => Format.Money(Total);
        public string MethodText => MethodName(Method);
        public string StatusText => IsCancelled ? "Đã hủy" : "Đã thanh toán";
        public string CustomerShort => CustomerName ?? "Khách vãng lai";
        public string CustomerText => CustomerPhone == null ? "Khách vãng lai" : $"{CustomerName} · {CustomerPhone}";
        public decimal DiscountAmount => PointsUsed * 1000m;
        public decimal GrossTotal => Total + DiscountAmount;
        public bool HasPointsUsed => PointsUsed > 0;
        public string SubtotalText => Format.Money(GrossTotal);
        public string PointsUsedText => HasPointsUsed ? $"-{Format.Number(PointsUsed)} điểm (-{Format.Money(DiscountAmount)})" : "—";
        public string PointsText => CustomerPhone == null ? "—" : $"+{Format.Number(Points)} điểm";
        public string StaffText => $"{StaffName} · {CreatedAt:HH:mm}";
        public string PaymentDetail => Method == PaymentMethod.Cash && CashGiven > Total
            ? $"Tiền mặt (khách đưa {CashGiven.ToString("N0", Format.Vi)})"
            : MethodText;
        public string CancelInfo
        {
            get
            {
                if (!IsCancelled) return "";
                var parts = new List<string>
                {
                    $"Hủy lúc {CancelledAt:HH:mm dd/MM} bởi {CancelledBy}",
                    $"Lý do: {CancelReason}",
                    $"Đã hoàn {Format.Money(Total)}",
                };
                if (PointsUsed > 0) parts.Add($"hoàn lại {Format.Number(PointsUsed)} điểm đã dùng");
                if (Points > 0) parts.Add($"trừ lại {Format.Number(Points)} điểm thưởng");
                return string.Join(" · ", parts);
            }
        }

        public string CancelSeatsText => $"{TicketCount} ghế được mở bán lại";
        public bool HasCancelPointsImpact => PointsUsed > 0 || Points > 0;
        public string CancelPointsImpactText
        {
            get
            {
                var parts = new List<string>();
                if (PointsUsed > 0) parts.Add($"Hoàn {Format.Number(PointsUsed)} điểm đã dùng");
                if (Points > 0) parts.Add($"{(parts.Count == 0 ? "Trừ" : "trừ")} {Format.Number(Points)} điểm thưởng");
                return string.Join(" · ", parts);
            }
        }

        public string GetCancelMethodLabel(bool includeCashDrawer) => Method switch
        {
            PaymentMethod.Cash => includeCashDrawer ? "tiền mặt từ két" : "tiền mặt",
            PaymentMethod.Transfer => "qua chuyển khoản",
            PaymentMethod.Card => "về thẻ",
            _ => "chưa rõ phương thức",
        };

        public static string MethodName(PaymentMethod? method) => method switch
        {
            PaymentMethod.Cash => "Tiền mặt",
            PaymentMethod.Transfer => "Chuyển khoản",
            PaymentMethod.Card => "Thẻ",
            _ => "Chưa có dữ liệu",
        };
    }
}
