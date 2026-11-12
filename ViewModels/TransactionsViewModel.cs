using System.Collections.ObjectModel;
using System.Globalization;
using System.Windows;
using System.Windows.Input;
using CinemaAPP.Helpers;
using CinemaAPP.Services;

namespace CinemaAPP.ViewModels
{
    // Khoảng ngày để lọc: [From, To)
    public record DateRange(string Text, DateTime From, DateTime To)
    {
        public bool IsSingleDay => To - From == TimeSpan.FromDays(1);
        public override string ToString() => Text;   // ô chọn ngày hiện Text
    }

    // Màn GIAO DỊCH & ĐỐI SOÁT (chỉ Quản trị viên): tra cứu đơn đã bán, hủy đơn, đối soát tiền cuối ca.
    // Dữ liệu lấy từ SalesDemoStore (đơn bán ở màn Bán vé trong lần chạy này); khi ghép CSDL đổi sang BookingService, giao diện giữ nguyên.
    public class TransactionsViewModel : ObservableObject
    {
        public const string AllStaff = "Tất cả nhân viên";
        public const string AllMethods = "Tất cả thanh toán";

        // ================= Tab =================
        private bool isListTab = true;
        public bool IsListTab
        {
            get => isListTab;
            set
            {
                if (SetProperty(ref isListTab, value))
                {
                    OnPropertyChanged(nameof(IsReconTab));
                    Message = "";
                }
            }
        }
        public bool IsReconTab { get => !IsListTab; set { if (value) IsListTab = false; } }

        // ================= Bộ lọc =================
        public List<DateRange> DateOptions { get; }
        public List<string> StaffOptions { get; }
        public List<string> MethodOptions { get; } = new() { AllMethods, "Tiền mặt", "Chuyển khoản", "Thẻ" };

        private DateRange selectedDate;
        public DateRange SelectedDate { get => selectedDate; set { if (SetProperty(ref selectedDate, value)) Refresh(); } }

        private string selectedStaffFilter = AllStaff;
        public string SelectedStaffFilter { get => selectedStaffFilter; set { if (SetProperty(ref selectedStaffFilter, value)) Refresh(); } }

        private string selectedMethod = AllMethods;
        public string SelectedMethod { get => selectedMethod; set { if (SetProperty(ref selectedMethod, value)) Refresh(); } }

        private string searchText = "";
        public string SearchText { get => searchText; set { if (SetProperty(ref searchText, value)) Refresh(); } }

        // ================= 4 ô số =================
        private string ordersText = "0", ticketsText = "0", revenueText = "0 đ", cancelledText = "0", refundText = "";
        public string OrdersText { get => ordersText; private set => SetProperty(ref ordersText, value); }
        public string TicketsText { get => ticketsText; private set => SetProperty(ref ticketsText, value); }
        public string RevenueText { get => revenueText; private set => SetProperty(ref revenueText, value); }
        public string CancelledText { get => cancelledText; private set => SetProperty(ref cancelledText, value); }
        public string RefundText { get => refundText; private set => SetProperty(ref refundText, value); }

        // ================= Tab 1: Lịch sử giao dịch =================
        public ObservableCollection<SaleRecord> Transactions { get; } = new ObservableCollection<SaleRecord>();

        private bool isEmpty;
        public bool IsEmpty { get => isEmpty; private set => SetProperty(ref isEmpty, value); }

        private SaleRecord? selectedSale;
        public SaleRecord? SelectedSale
        {
            get => selectedSale;
            set
            {
                if (SetProperty(ref selectedSale, value))
                {
                    SelectedReason = null;
                    IsConfirmingCancel = false;
                    OnPropertyChanged(nameof(HasSelection));
                    OnPropertyChanged(nameof(CanShowCancelBox));
                }
            }
        }
        public bool HasSelection => SelectedSale != null;

        // Hủy đơn: chọn lý do → bấm Hủy → xác nhận lần nữa (thao tác không hoàn tác được)
        public bool IsAdmin => AppSession.CurrentUser == null || AppSession.IsAdmin;
        public List<string> CancelReasons => SalesDemoStore.CancelReasons;

        private string? selectedReason;
        public string? SelectedReason
        {
            get => selectedReason;
            set
            {
                if (SetProperty(ref selectedReason, value))
                {
                    OnPropertyChanged(nameof(CancelImpactText));
                    CommandManager.InvalidateRequerySuggested();   // bật nút Hủy ngay khi chọn lý do
                }
            }
        }

        private bool isConfirmingCancel;
        public bool IsConfirmingCancel
        {
            get => isConfirmingCancel;
            set
            {
                if (SetProperty(ref isConfirmingCancel, value))
                    CommandManager.InvalidateRequerySuggested();
            }
        }

        public bool CanShowCancelBox => SelectedSale != null && !SelectedSale.IsCancelled && IsAdmin;

        public string CancelImpactText
        {
            get
            {
                if (SelectedSale == null) return "";
                SaleRecord s = SelectedSale;
                string refund = s.Method == PaymentMethod.Cash ? "tiền mặt" : s.Method == PaymentMethod.Transfer ? "qua chuyển khoản" : "về thẻ";
                string points = s.Points > 0 ? $" · trừ lại {s.Points} điểm của khách" : "";
                return $"{s.TicketCount} ghế được mở bán lại · hoàn {s.AmountText} {refund}{points}";
            }
        }

        // ================= Tab 2: Đối soát cuối ca =================
        public ObservableCollection<StaffSummary> StaffRows { get; } = new ObservableCollection<StaffSummary>();

        private StaffSummary? selectedStaffRow;
        public StaffSummary? SelectedStaffRow
        {
            get => selectedStaffRow;
            set
            {
                if (SetProperty(ref selectedStaffRow, value))
                {
                    // Chưa bàn giao mà nhân viên đã nộp chốt ca thì điền sẵn số tiền nhân viên báo
                    CountedCashText = (value?.Handover?.CountedCash ?? value?.Report?.CountedCash)?.ToString("N0", Vi) ?? "";
                    HandoverNote = value?.Handover?.Note ?? value?.Report?.Note ?? "";
                    OnPropertyChanged(nameof(HasStaffSelection));
                    OnPropertyChanged(nameof(HandoverDoneText));
                    OnPropertyChanged(nameof(CanEditHandover));
                }
            }
        }
        public bool HasStaffSelection => SelectedStaffRow != null;

        // Dòng tổng + thanh cơ cấu thanh toán
        private string totalOrders = "0", totalTickets = "0", totalCash = "0", totalTransfer = "0", totalCard = "0", totalAll = "0";
        public string TotalOrders { get => totalOrders; private set => SetProperty(ref totalOrders, value); }
        public string TotalTickets { get => totalTickets; private set => SetProperty(ref totalTickets, value); }
        public string TotalCash { get => totalCash; private set => SetProperty(ref totalCash, value); }
        public string TotalTransfer { get => totalTransfer; private set => SetProperty(ref totalTransfer, value); }
        public string TotalCard { get => totalCard; private set => SetProperty(ref totalCard, value); }
        public string TotalAll { get => totalAll; private set => SetProperty(ref totalAll, value); }

        private GridLength cashWidth, transferWidth, cardWidth;
        public GridLength CashWidth { get => cashWidth; private set => SetProperty(ref cashWidth, value); }
        public GridLength TransferWidth { get => transferWidth; private set => SetProperty(ref transferWidth, value); }
        public GridLength CardWidth { get => cardWidth; private set => SetProperty(ref cardWidth, value); }

        private string cashPercent = "", transferPercent = "", cardPercent = "";
        public string CashPercent { get => cashPercent; private set => SetProperty(ref cashPercent, value); }
        public string TransferPercent { get => transferPercent; private set => SetProperty(ref transferPercent, value); }
        public string CardPercent { get => cardPercent; private set => SetProperty(ref cardPercent, value); }

        // Bàn giao tiền mặt của nhân viên đang chọn
        private string countedCashText = "";
        public string CountedCashText
        {
            get => countedCashText;
            set
            {
                if (SetProperty(ref countedCashText, value))
                    UpdateDiff();
            }
        }

        private string handoverNote = "";
        public string HandoverNote { get => handoverNote; set => SetProperty(ref handoverNote, value); }

        private string diffText = "", diffLabel = "", diffKind = "";
        public string DiffText { get => diffText; private set => SetProperty(ref diffText, value); }
        public string DiffLabel { get => diffLabel; private set => SetProperty(ref diffLabel, value); }
        public string DiffKind { get => diffKind; private set => SetProperty(ref diffKind, value); }   // "", Even, Short, Over

        public bool CanEditHandover => SelectedStaffRow != null && !SelectedStaffRow.IsHandedOver && SelectedDate.IsSingleDay;
        public string HandoverDoneText => SelectedStaffRow?.Handover is Handover h
            ? $"Đã bàn giao lúc {h.At:HH:mm} · xác nhận bởi {h.By}"
            : SelectedStaffRow?.Report is ShiftReport r
                ? $"Nhân viên đã nộp chốt ca lúc {r.At:HH:mm}. Đếm lại két rồi bấm xác nhận."
                : SelectedDate.IsSingleDay ? "" : "Chọn một ngày cụ thể để bàn giao ca.";

        // ================= Thông báo =================
        private string message = "";
        public string Message { get => message; set => SetProperty(ref message, value); }

        private bool isMessageError;
        public bool IsMessageError { get => isMessageError; set => SetProperty(ref isMessageError, value); }

        public ICommand AskCancelCommand { get; }
        public ICommand ConfirmCancelCommand { get; }
        public ICommand BackCommand { get; }
        public ICommand ConfirmHandoverCommand { get; }

        private static readonly CultureInfo Vi = new CultureInfo("vi-VN");

        public TransactionsViewModel()
        {
            DateTime today = DateTime.Today;
            DateOptions = new List<DateRange>
            {
                new($"Hôm nay · {today:dd/MM/yyyy}", today, today.AddDays(1)),
                new($"Hôm qua · {today.AddDays(-1):dd/MM/yyyy}", today.AddDays(-1), today),
                new("7 ngày qua", today.AddDays(-6), today.AddDays(1)),
            };
            selectedDate = DateOptions[0];

            StaffOptions = new List<string> { AllStaff };
            StaffOptions.AddRange(SalesDemoStore.Sales.Select(s => s.StaffName).Distinct());

            AskCancelCommand = new RelayCommand(_ => IsConfirmingCancel = true,
                _ => CanShowCancelBox && SelectedReason != null);
            ConfirmCancelCommand = new RelayCommand(_ => CancelSelected(), _ => CanShowCancelBox && SelectedReason != null);
            BackCommand = new RelayCommand(_ => IsConfirmingCancel = false);
            ConfirmHandoverCommand = new RelayCommand(_ => ConfirmHandover(), _ => CanEditHandover && ParseMoney(CountedCashText) != null);

            Refresh();
            SelectedSale = Transactions.FirstOrDefault();
            SelectedStaffRow = StaffRows.FirstOrDefault(r => !r.IsHandedOver) ?? StaffRows.FirstOrDefault();
        }

        private void Refresh()
        {
            int? keepSale = SelectedSale?.BookingID;
            string? keepStaff = SelectedStaffRow?.Staff.Username;

            // Đơn trong khoảng ngày + nhân viên đang lọc
            var inRange = SalesDemoStore.Sales
                .Where(s => s.CreatedAt >= SelectedDate.From && s.CreatedAt < SelectedDate.To)
                .Where(s => SelectedStaffFilter == AllStaff || s.StaffName == SelectedStaffFilter)
                .ToList();

            // ---- Tab 1 ----
            var byMethod = inRange.Where(s => SelectedMethod == AllMethods || s.MethodText == SelectedMethod).ToList();
            var paid = byMethod.Where(s => !s.IsCancelled).ToList();
            var cancelled = byMethod.Where(s => s.IsCancelled).ToList();
            OrdersText = paid.Count.ToString("N0", Vi);
            TicketsText = paid.Sum(s => s.TicketCount).ToString("N0", Vi);
            RevenueText = SaleRecord.Money(paid.Sum(s => s.Total));
            CancelledText = cancelled.Count.ToString("N0", Vi);
            RefundText = cancelled.Count == 0 ? "" : "· hoàn " + SaleRecord.Money(cancelled.Sum(s => s.Total));

            string q = SearchText.Trim().TrimStart('#');
            Transactions.Clear();
            foreach (SaleRecord s in byMethod.OrderByDescending(s => s.CreatedAt))
                if (q == "" || s.BookingID.ToString().Contains(q)
                    || (s.CustomerPhone?.Contains(q) ?? false)
                    || (s.CustomerName?.Contains(q, StringComparison.CurrentCultureIgnoreCase) ?? false))
                    Transactions.Add(s);
            IsEmpty = Transactions.Count == 0;
            SelectedSale = Transactions.FirstOrDefault(s => s.BookingID == keepSale) ?? Transactions.FirstOrDefault();

            // ---- Tab 2 ----
            StaffRows.Clear();
            var sellers = inRange.Select(s => new StaffInfo(s.StaffName, s.StaffUsername, "Ca quầy"))
                .GroupBy(s => s.Username).Select(g => g.First())
                .Where(s => SelectedStaffFilter == AllStaff || s.FullName == SelectedStaffFilter);
            foreach (StaffInfo staff in sellers)
            {
                var mine = inRange.Where(s => s.StaffUsername == staff.Username).ToList();
                var ok = mine.Where(s => !s.IsCancelled).ToList();
                StaffRows.Add(new StaffSummary
                {
                    Staff = staff,
                    Orders = ok.Count,
                    Tickets = ok.Sum(s => s.TicketCount),
                    Cash = ok.Where(s => s.Method == PaymentMethod.Cash).Sum(s => s.Total),
                    Transfer = ok.Where(s => s.Method == PaymentMethod.Transfer).Sum(s => s.Total),
                    Card = ok.Where(s => s.Method == PaymentMethod.Card).Sum(s => s.Total),
                    CancelledCount = mine.Count(s => s.IsCancelled),
                    CancelledAmount = mine.Where(s => s.IsCancelled).Sum(s => s.Total),
                    Handover = SelectedDate.IsSingleDay && SalesDemoStore.Handovers.TryGetValue((SelectedDate.From, staff.Username), out var h) ? h : null,
                    Report = SelectedDate.IsSingleDay && SalesDemoStore.ShiftReports.TryGetValue((SelectedDate.From, staff.Username), out var r) ? r : null,
                });
            }

            decimal cash = StaffRows.Sum(r => r.Cash), transfer = StaffRows.Sum(r => r.Transfer), card = StaffRows.Sum(r => r.Card);
            decimal all = cash + transfer + card;
            TotalOrders = StaffRows.Sum(r => r.Orders).ToString("N0", Vi);
            TotalTickets = StaffRows.Sum(r => r.Tickets).ToString("N0", Vi);
            TotalCash = cash.ToString("N0", Vi);
            TotalTransfer = transfer.ToString("N0", Vi);
            TotalCard = card.ToString("N0", Vi);
            TotalAll = all.ToString("N0", Vi);
            // Cột thanh cơ cấu dùng độ rộng sao (*) theo số tiền; chưa có đơn thì cả 3 bằng 0, chỉ còn nền xám
            CashWidth = new GridLength((double)cash, GridUnitType.Star);
            TransferWidth = new GridLength((double)transfer, GridUnitType.Star);
            CardWidth = new GridLength((double)card, GridUnitType.Star);
            CashPercent = Percent(cash, all);
            TransferPercent = Percent(transfer, all);
            CardPercent = Percent(card, all);

            SelectedStaffRow = StaffRows.FirstOrDefault(r => r.Staff.Username == keepStaff) ?? StaffRows.FirstOrDefault();
            OnPropertyChanged(nameof(CanEditHandover));
            OnPropertyChanged(nameof(HandoverDoneText));
            UpdateDiff();
        }

        private void CancelSelected()
        {
            SaleRecord sale = SelectedSale!;
            sale.CancelReason = SelectedReason!;
            sale.CancelledAt = DateTime.Now;
            sale.CancelledBy = AppSession.CurrentUser?.FullName ?? "Quản trị viên";
            sale.IsCancelled = true;
            IsConfirmingCancel = false;

            Refresh();
            OnPropertyChanged(nameof(CanShowCancelBox));
            IsMessageError = false;
            Message = $"Đã hủy đơn {sale.Code}: {sale.TicketCount} ghế được mở bán lại, hoàn {sale.AmountText}.";
        }

        private void ConfirmHandover()
        {
            StaffSummary row = SelectedStaffRow!;
            decimal counted = ParseMoney(CountedCashText)!.Value;
            SalesDemoStore.Handovers[(SelectedDate.From, row.Staff.Username)] =
                new Handover(counted, HandoverNote.Trim(), DateTime.Now, AppSession.CurrentUser?.FullName ?? "Quản trị viên");

            decimal diff = counted - row.Cash;
            Refresh();
            IsMessageError = diff != 0;
            Message = diff == 0
                ? $"Đã bàn giao ca của {row.Name}: tiền mặt khớp {SaleRecord.Money(counted)}."
                : $"Đã bàn giao ca của {row.Name}, {(diff < 0 ? "thiếu" : "thừa")} {SaleRecord.Money(Math.Abs(diff))} so với hệ thống.";
        }

        // Chênh lệch = tiền đếm thực tế − tiền mặt theo hệ thống
        private void UpdateDiff()
        {
            decimal? counted = ParseMoney(CountedCashText);
            if (SelectedStaffRow == null || counted == null)
            {
                DiffKind = "";
                DiffLabel = "Chênh lệch";
                DiffText = "—";
                return;
            }
            decimal diff = counted.Value - SelectedStaffRow.Cash;
            DiffKind = diff == 0 ? "Even" : diff < 0 ? "Short" : "Over";
            DiffLabel = diff == 0 ? "Khớp với hệ thống" : diff < 0 ? "Chênh lệch (thiếu)" : "Chênh lệch (thừa)";
            DiffText = diff == 0 ? "0 đ" : (diff < 0 ? "−" : "+") + SaleRecord.Money(Math.Abs(diff));
        }

        // Chỉ lấy chữ số: "2.140.000" hay "2140000" đều được; ô trống → null
        private static decimal? ParseMoney(string text)
        {
            string digits = new string(text.Where(char.IsDigit).ToArray());
            return digits == "" ? null : decimal.Parse(digits, CultureInfo.InvariantCulture);
        }

        private static string Percent(decimal part, decimal all) =>
            all == 0 ? "0%" : Math.Round(part * 100 / all).ToString(CultureInfo.InvariantCulture) + "%";
    }
}
