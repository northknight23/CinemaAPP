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
        public int CancelledCount { get; init; }
        public decimal CancelledAmount { get; init; }
        public Handover? Handover { get; init; }   // null = chưa bàn giao (hoặc đang xem nhiều ngày)
        public ShiftReport? Report { get; init; }  // nhân viên đã tự nộp chốt ca, chờ xác nhận

        public decimal Total => Cash + Transfer + Card;
        public bool IsHandedOver => Handover != null;
        public bool IsPending => Handover == null && Report != null;

        public string Name => Staff.FullName;
        public string SubText => $"{Staff.Username} · {Staff.Shift.Split(' ')[0]} {Staff.Shift.Split(' ')[1]}";
        public string Initials => Staff.Initials;
        public string CashText => SaleRecord.Money(Cash).Replace(" đ", "");
        public string TransferText => SaleRecord.Money(Transfer).Replace(" đ", "");
        public string CardText => SaleRecord.Money(Card).Replace(" đ", "");
        public string TotalText => SaleRecord.Money(Total).Replace(" đ", "");
        public string CancelText => CancelledCount == 0 ? "" : $"{CancelledCount} hủy · {SaleRecord.Money(CancelledAmount).Replace(" đ", "")}";
    }
}
