using System.Globalization;
using CinemaAPP.Helpers;

namespace CinemaAPP.ViewModels
{
    // Một ghế trong đơn đã bán (chỉ để hiện chip ghế ở màn Giao dịch).
    public record SoldSeat(string Label, SeatType Type);

    // Một nhân viên bán vé (giả lập bảng ACCOUNT có AccountRole = Staff).
    public record StaffInfo(string FullName, string Username, string Shift)
    {
        public string Initials => string.Concat(FullName.Split(' ', StringSplitOptions.RemoveEmptyEntries).TakeLast(2).Select(w => char.ToUpper(w[0])));
    }

    // Một đơn đã bán = một dòng BOOKING + các TICKET của nó (dữ liệu giả, xem SalesDemoStore).
    // Khi ghép CSDL: cột hủy đơn là BOOKING.CancelReason / CancelledAt / CancelledBy (nhờ A thêm).
    public class SaleRecord : ObservableObject
    {
        private static readonly CultureInfo Vi = new CultureInfo("vi-VN");

        public int BookingID { get; init; }
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

        public int Points => CustomerPhone == null ? 0 : (int)(Total / SeatMapDemoViewModel.MoneyPerPoint);

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
        public int TicketCount => Seats.Count;
        public string AmountText => Money(Total);
        public string MethodText => MethodName(Method);
        public string StatusText => IsCancelled ? "Đã hủy" : "Đã thanh toán";
        public string CustomerText => CustomerPhone == null ? "Khách vãng lai" : $"{CustomerName} · {CustomerPhone}";
        public string PointsText => CustomerPhone == null ? "—" : $"+{Points} điểm";
        public string StaffText => $"{StaffName} · {CreatedAt:HH:mm}";
        public string PaymentDetail => Method == PaymentMethod.Cash && CashGiven > Total
            ? $"Tiền mặt (khách đưa {CashGiven.ToString("N0", Vi)})"
            : MethodText;
        public string CancelInfo => IsCancelled
            ? $"Hủy lúc {CancelledAt:HH:mm dd/MM} bởi {CancelledBy} · Lý do: {CancelReason} · Đã hoàn {Money(Total)}"
            : "";

        public static string MethodName(PaymentMethod method) => method switch
        {
            PaymentMethod.Cash => "Tiền mặt",
            PaymentMethod.Transfer => "Chuyển khoản",
            _ => "Thẻ",
        };

        public static string Money(decimal value) => value.ToString("N0", Vi) + " đ";
    }
}
