using System.Collections.ObjectModel;
using System.Globalization;
using System.Windows.Input;
using CinemaAPP.Helpers;
using CinemaAPP.Services;

namespace CinemaAPP.ViewModels
{
    // Một dòng "Vé theo suất chiếu" ở tab Chốt ca
    public record ShowSummary(string MovieTitle, string ShowText, int Tickets, decimal Revenue)
    {
        public string RevenueText => SaleRecord.Money(Revenue).Replace(" đ", "");
    }

    // Một dòng "Theo phương thức thanh toán" (có Method + MethodText nên dùng lại chip MethodChip)
    public record MethodSummary(PaymentMethod Method, int Orders, decimal Amount)
    {
        public string MethodText => SaleRecord.MethodName(Method);
        public string OrdersText => $"{Orders} đơn";
        public string AmountText => SaleRecord.Money(Amount);
    }

    // Màn HÓA ĐƠN CA (chỉ Nhân viên): hóa đơn của chính mình trong ca hôm nay, hỗ trợ khách hủy vé, nộp chốt ca.
    // Quản trị viên xem và xác nhận bàn giao ở màn Giao dịch & Đối soát.
    // Dữ liệu lấy từ SalesDemoStore; khi ghép CSDL đổi sang BookingService, giao diện giữ nguyên.
    public class MyShiftViewModel : ObservableObject
    {
        public const string AllMethods = "Tất cả thanh toán";
        private static readonly CultureInfo Vi = new CultureInfo("vi-VN");

        // Người đang đăng nhập (cùng cách lấy với màn Bán vé để thấy đúng đơn mình vừa bán)
        public string StaffName { get; } = AppSession.CurrentUser?.FullName ?? "Quản trị viên";
        public string StaffUsername { get; } = AppSession.CurrentUser?.Username ?? "admin";
        public DateTime ShiftDay { get; } = DateTime.Today;
        private (DateTime, string) ShiftKey => (ShiftDay, StaffUsername);

        public string ShiftTitle => $"Ca hôm nay · {ShiftDay:dd/MM/yyyy}";
        public string ShiftSubText => $"{StaffName} · {StaffUsername}";

        // Trạng thái ca: Open = đang bán; Pending = đã nộp chốt ca, chờ Quản trị viên; Done = đã bàn giao
        public string ShiftStatusKind => SalesDemoStore.Handovers.ContainsKey(ShiftKey) ? "Done"
            : SalesDemoStore.ShiftReports.ContainsKey(ShiftKey) ? "Pending" : "Open";
        public string ShiftStatusText => ShiftStatusKind switch
        {
            "Done" => "Đã bàn giao",
            "Pending" => "Đã chốt · chờ xác nhận",
            _ => "Đang mở",
        };
        public bool IsShiftOpen => ShiftStatusKind == "Open";

        // ================= Tab =================
        private bool isListTab = true;
        public bool IsListTab
        {
            get => isListTab;
            set
            {
                if (SetProperty(ref isListTab, value))
                {
                    OnPropertyChanged(nameof(IsCloseTab));
                    Message = "";
                }
            }
        }
        public bool IsCloseTab { get => !IsListTab; set { if (value) IsListTab = false; } }

        // ================= Bộ lọc =================
        public List<string> MethodOptions { get; } = new() { AllMethods, "Tiền mặt", "Chuyển khoản", "Thẻ" };

        private string selectedMethod = AllMethods;
        public string SelectedMethod { get => selectedMethod; set { if (SetProperty(ref selectedMethod, value)) Refresh(); } }

        private string searchText = "";
        public string SearchText { get => searchText; set { if (SetProperty(ref searchText, value)) Refresh(); } }

        // ================= 4 ô số (cả ca, không theo bộ lọc) =================
        private string ordersText = "0", ticketsText = "0", revenueText = "0 đ", cancelledText = "0", refundText = "";
        public string OrdersText { get => ordersText; private set => SetProperty(ref ordersText, value); }
        public string TicketsText { get => ticketsText; private set => SetProperty(ref ticketsText, value); }
        public string RevenueText { get => revenueText; private set => SetProperty(ref revenueText, value); }
        public string CancelledText { get => cancelledText; private set => SetProperty(ref cancelledText, value); }
        public string RefundText { get => refundText; private set => SetProperty(ref refundText, value); }

        // ================= Tab 1: Hóa đơn trong ca =================
        public ObservableCollection<SaleRecord> Invoices { get; } = new ObservableCollection<SaleRecord>();

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
                    CancelNote = "";
                    IsConfirmingCancel = false;
                    RaiseCancelState();
                }
            }
        }
        public bool HasSelection => SelectedSale != null;

        // Hủy vé hỗ trợ khách: chọn lý do (+ ghi chú) → bấm Hủy → xác nhận lần nữa
        public List<string> CancelReasons => SalesDemoStore.CancelReasons;

        private string? selectedReason;
        public string? SelectedReason
        {
            get => selectedReason;
            set
            {
                if (SetProperty(ref selectedReason, value))
                    CommandManager.InvalidateRequerySuggested();   // bật nút Hủy ngay khi chọn lý do
            }
        }

        private string cancelNote = "";
        public string CancelNote { get => cancelNote; set => SetProperty(ref cancelNote, value); }

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

        // Nhân viên chỉ hủy được đơn của mình, khi suất chưa chiếu và ca chưa chốt. Ngoài ra phải nhờ Quản trị viên.
        public bool CanCancel => CancelBlockedText == "" && SelectedSale is { IsCancelled: false };
        public string CancelBlockedText
        {
            get
            {
                if (SelectedSale == null || SelectedSale.IsCancelled) return "";
                if (!IsShiftOpen) return "Ca đã chốt nên không hủy được nữa. Cần hủy thì báo Quản trị viên.";
                if (SelectedSale.ShowStart <= DateTime.Now) return "Suất chiếu đã bắt đầu nên không hủy được. Cần hủy thì báo Quản trị viên.";
                return "";
            }
        }

        public string CancelImpactText
        {
            get
            {
                if (SelectedSale == null) return "";
                SaleRecord s = SelectedSale;
                string refund = s.Method == PaymentMethod.Cash ? "tiền mặt từ két" : s.Method == PaymentMethod.Transfer ? "qua chuyển khoản" : "về thẻ";
                string points = s.Points > 0 ? $" · trừ lại {s.Points} điểm của khách" : "";
                return $"{s.TicketCount} ghế được mở bán lại · hoàn {s.AmountText} {refund}{points}";
            }
        }

        // ================= Tab 2: Chốt ca =================
        public ObservableCollection<ShowSummary> ShowRows { get; } = new ObservableCollection<ShowSummary>();
        public ObservableCollection<MethodSummary> MethodRows { get; } = new ObservableCollection<MethodSummary>();
        public ObservableCollection<SaleRecord> CancelledSales { get; } = new ObservableCollection<SaleRecord>();

        private decimal systemCash;
        private string systemCashText = "0 đ", totalTicketsText = "0", totalRevenueText = "0";
        public string SystemCashText { get => systemCashText; private set => SetProperty(ref systemCashText, value); }
        public string TotalTicketsText { get => totalTicketsText; private set => SetProperty(ref totalTicketsText, value); }
        public string TotalRevenueText { get => totalRevenueText; private set => SetProperty(ref totalRevenueText, value); }

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

        private string shiftNote = "";
        public string ShiftNote { get => shiftNote; set => SetProperty(ref shiftNote, value); }

        private string diffText = "—", diffLabel = "Chênh lệch", diffKind = "";
        public string DiffText { get => diffText; private set => SetProperty(ref diffText, value); }
        public string DiffLabel { get => diffLabel; private set => SetProperty(ref diffLabel, value); }
        public string DiffKind { get => diffKind; private set => SetProperty(ref diffKind, value); }   // "", Even, Short, Over

        public string CloseStatusText => SalesDemoStore.Handovers.TryGetValue(ShiftKey, out Handover? h)
            ? $"Đã bàn giao lúc {h.At:HH:mm} · xác nhận bởi {h.By}"
            : SalesDemoStore.ShiftReports.TryGetValue(ShiftKey, out ShiftReport? r)
                ? $"Đã nộp chốt ca lúc {r.At:HH:mm}. Chờ Quản trị viên đếm két và xác nhận."
                : "";

        // ================= Thông báo =================
        private string message = "";
        public string Message { get => message; set => SetProperty(ref message, value); }

        private bool isMessageError;
        public bool IsMessageError { get => isMessageError; set => SetProperty(ref isMessageError, value); }

        public ICommand AskCancelCommand { get; }
        public ICommand ConfirmCancelCommand { get; }
        public ICommand BackCommand { get; }
        public ICommand SubmitShiftCommand { get; }

        public MyShiftViewModel()
        {
            AskCancelCommand = new RelayCommand(_ => IsConfirmingCancel = true, _ => CanCancel && SelectedReason != null);
            ConfirmCancelCommand = new RelayCommand(_ => CancelSelected(), _ => CanCancel && SelectedReason != null);
            BackCommand = new RelayCommand(_ => IsConfirmingCancel = false);
            SubmitShiftCommand = new RelayCommand(_ => SubmitShift(), _ => IsShiftOpen && ParseMoney(CountedCashText) != null);

            if (SalesDemoStore.ShiftReports.TryGetValue(ShiftKey, out ShiftReport? report))
            {
                countedCashText = report.CountedCash.ToString("N0", Vi);
                shiftNote = report.Note;
            }

            Refresh();
            SelectedSale = Invoices.FirstOrDefault();
        }

        private void Refresh()
        {
            int? keepSale = SelectedSale?.BookingID;
            var mine = SalesDemoStore.Sales
                .Where(s => s.StaffUsername == StaffUsername && s.CreatedAt.Date == ShiftDay)
                .ToList();
            var paid = mine.Where(s => !s.IsCancelled).ToList();
            var cancelled = mine.Where(s => s.IsCancelled).ToList();

            OrdersText = paid.Count.ToString("N0", Vi);
            TicketsText = paid.Sum(s => s.TicketCount).ToString("N0", Vi);
            RevenueText = SaleRecord.Money(paid.Sum(s => s.Total));
            CancelledText = cancelled.Count.ToString("N0", Vi);
            RefundText = cancelled.Count == 0 ? "" : "· hoàn " + SaleRecord.Money(cancelled.Sum(s => s.Total));

            // ---- Tab 1 ----
            string q = SearchText.Trim().TrimStart('#');
            Invoices.Clear();
            foreach (SaleRecord s in mine.OrderByDescending(s => s.CreatedAt))
                if ((SelectedMethod == AllMethods || s.MethodText == SelectedMethod)
                    && (q == "" || s.BookingID.ToString().Contains(q)
                        || (s.CustomerPhone?.Contains(q) ?? false)
                        || (s.CustomerName?.Contains(q, StringComparison.CurrentCultureIgnoreCase) ?? false)))
                    Invoices.Add(s);
            IsEmpty = Invoices.Count == 0;
            SelectedSale = Invoices.FirstOrDefault(s => s.BookingID == keepSale) ?? Invoices.FirstOrDefault();

            // ---- Tab 2 ----
            ShowRows.Clear();
            foreach (var g in paid.GroupBy(s => (s.MovieTitle, s.ShowStart, s.RoomName)).OrderBy(g => g.Key.ShowStart))
                ShowRows.Add(new ShowSummary(g.Key.MovieTitle, g.First().ShowLong, g.Sum(s => s.TicketCount), g.Sum(s => s.Total)));

            MethodRows.Clear();
            foreach (PaymentMethod m in new[] { PaymentMethod.Cash, PaymentMethod.Transfer, PaymentMethod.Card })
            {
                var byMethod = paid.Where(s => s.Method == m).ToList();
                MethodRows.Add(new MethodSummary(m, byMethod.Count, byMethod.Sum(s => s.Total)));
            }

            CancelledSales.Clear();
            foreach (SaleRecord s in cancelled.OrderByDescending(s => s.CancelledAt))
                CancelledSales.Add(s);

            systemCash = paid.Where(s => s.Method == PaymentMethod.Cash).Sum(s => s.Total);
            SystemCashText = SaleRecord.Money(systemCash);
            TotalTicketsText = paid.Sum(s => s.TicketCount).ToString("N0", Vi);
            TotalRevenueText = paid.Sum(s => s.Total).ToString("N0", Vi);

            OnPropertyChanged(nameof(ShiftStatusKind));
            OnPropertyChanged(nameof(ShiftStatusText));
            OnPropertyChanged(nameof(IsShiftOpen));
            OnPropertyChanged(nameof(CloseStatusText));
            RaiseCancelState();
            UpdateDiff();
        }

        private void RaiseCancelState()
        {
            OnPropertyChanged(nameof(HasSelection));
            OnPropertyChanged(nameof(CanCancel));
            OnPropertyChanged(nameof(CancelBlockedText));
            OnPropertyChanged(nameof(CancelImpactText));
            CommandManager.InvalidateRequerySuggested();
        }

        private void CancelSelected()
        {
            SaleRecord sale = SelectedSale!;
            string note = CancelNote.Trim();
            sale.CancelReason = note == "" ? SelectedReason! : $"{SelectedReason} ({note})";
            sale.CancelledAt = DateTime.Now;
            sale.CancelledBy = StaffName;
            sale.IsCancelled = true;
            IsConfirmingCancel = false;

            Refresh();
            IsMessageError = false;
            Message = $"Đã hủy đơn {sale.Code} cho khách: {sale.TicketCount} ghế được mở bán lại, hoàn {sale.AmountText}.";
        }

        private void SubmitShift()
        {
            decimal counted = ParseMoney(CountedCashText)!.Value;
            SalesDemoStore.ShiftReports[ShiftKey] = new ShiftReport(counted, ShiftNote.Trim(), DateTime.Now);

            decimal diff = counted - systemCash;
            Refresh();
            IsMessageError = diff != 0;
            Message = diff == 0
                ? $"Đã nộp chốt ca: tiền mặt khớp {SaleRecord.Money(counted)}. Chờ Quản trị viên xác nhận."
                : $"Đã nộp chốt ca, {(diff < 0 ? "thiếu" : "thừa")} {SaleRecord.Money(Math.Abs(diff))} so với hệ thống. Chờ Quản trị viên xác nhận.";
        }

        // Chênh lệch = tiền đếm thực tế − tiền mặt theo hệ thống
        private void UpdateDiff()
        {
            decimal? counted = ParseMoney(CountedCashText);
            if (counted == null)
            {
                DiffKind = "";
                DiffLabel = "Chênh lệch";
                DiffText = "—";
                return;
            }
            decimal diff = counted.Value - systemCash;
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
    }
}
