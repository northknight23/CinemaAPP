using CinemaAPP.Helpers;
using CinemaAPP.Models;

namespace CinemaAPP.ViewModels
{
    // Một ghế trong đơn đã bán (chỉ để hiện chip ghế ở màn Giao dịch).
    public record SoldSeat(string Label, SeatType Type, int Count = 1);

    // Một nhân viên bán vé (lấy từ người bán của đơn / bảng ACCOUNT).
    public record StaffInfo(string FullName, string Username, string Shift)
    {
        public string Initials => NameHelper.Initials(FullName);
    }

    // Một đơn đã bán = một dòng BOOKING + các TICKET của nó (đọc từ SQL Server).
    public class SaleRecord : ObservableObject
    {
        public int BookingID { get; init; }
        public int AccountID { get; init; }
        public int? CustomerID { get; init; }
        public DateTime CreatedAt { get; init; }
        public string MovieTitle { get; init; } = "";
        public DateTime ShowStart { get; init; }
        public string RoomName { get; init; } = "";     // "Phòng 2"
        public string ShowFormat { get; init; } = "";   // "2D" / "3D"
        public List<SoldSeat> Seats { get; init; } = new List<SoldSeat>();
        public string StaffName { get; init; } = "";
        public string StaffUsername { get; init; } = "";
        public string? CustomerName { get; init; }
        public string? CustomerPhone { get; init; }
        public PaymentMethod Method { get; init; }
        public decimal CashGiven { get; init; }         // chỉ có khi trả tiền mặt
        public decimal Total { get; init; }

        public int Points { get; init; }
        public int PointsUsed { get; init; }

        // ----- Hủy đơn -----
        private bool isCancelled;
        public bool IsCancelled
        {
            get => isCancelled;
            set
            {
                if (SetProperty(ref isCancelled, value))
                {
                    OnPropertyChanged(nameof(StatusText));
                    OnPropertyChanged(nameof(CancelInfo));
                }
            }
        }
        public string CancelReason { get; set; } = "";
        public DateTime? CancelledAt { get; set; }
        public string CancelledBy { get; set; } = "";

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

        public static string MethodName(PaymentMethod method) => method switch
        {
            PaymentMethod.Cash => "Tiền mặt",
            PaymentMethod.Transfer => "Chuyển khoản",
            PaymentMethod.Card => "Thẻ",
            _ => "Chưa có dữ liệu",
        };
    }
}
