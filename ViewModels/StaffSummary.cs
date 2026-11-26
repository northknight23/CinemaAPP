using CinemaAPP.Models;
using CinemaAPP.Services;

namespace CinemaAPP.ViewModels
{
    // Một dòng ở tab "Đối soát cuối ca": doanh thu của một nhân viên trong khoảng ngày đang lọc.
    public class StaffSummary
    {
        public StaffInfo Staff { get; init; } = null!;
        public int Orders { get; init; }
        public int Tickets { get; init; }
        public decimal Cash { get; init; }
        public decimal Transfer { get; init; }
        public decimal Card { get; init; }
        public decimal UnknownAmount { get; init; }
        public int CancelledCount { get; init; }
        public decimal CancelledAmount { get; init; }
        public Handover? Handover { get; init; }   // null = chưa bàn giao (hoặc đang xem nhiều ngày)
        public ShiftReport? Report { get; init; }  // nhân viên đã tự nộp chốt ca, chờ xác nhận

        public decimal Total => Cash + Transfer + Card + UnknownAmount;
        public bool IsHandedOver => Handover != null;
        public bool IsPending => Handover == null && Report != null;

        public string Name => Staff.FullName;
        public string SubText => $"{Staff.Username} · {Staff.Shift.Split(' ')[0]} {Staff.Shift.Split(' ')[1]}";
        public string Initials => Staff.Initials;
        public string CashText => Cash.ToString("N0", Format.Vi);
        public string TransferText => Transfer.ToString("N0", Format.Vi);
        public string CardText => Card.ToString("N0", Format.Vi);
        public string TotalText => Total.ToString("N0", Format.Vi);
        public string CancelText => CancelledCount == 0 ? "" : $"{CancelledCount} hủy · {CancelledAmount.ToString("N0", Format.Vi)}";
    }
}
