using System.Collections.ObjectModel;
using System.Text.RegularExpressions;
using System.Windows.Input;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using CinemaAPP.Services;

namespace CinemaAPP.ViewModels
{
    // Khung bên phải đang hiện gì
    public enum CustomerPanel { None, View, Edit, New }

    // Màn Quản lý khách hàng:
    //  - trên cùng: ô tìm kiếm + 4 thẻ số liệu (so với tháng trước)
    //  - trái: danh sách, lọc theo hạng, sắp xếp
    //  - phải: CHỈ hiện khi bấm một khách (hồ sơ) hoặc bấm "Thêm khách" (form đăng ký)
    public class CustomerManagementViewModel : ObservableObject
    {
        private const string DbError = "Không kết nối được cơ sở dữ liệu. Kiểm tra SQL Server rồi bấm Tải lại.";
        private const int HistoryCount = 4;

        private readonly CustomerService service = new CustomerService();
        private List<Customer> all = new List<Customer>();
        private bool keepForm;            // đang lọc lại danh sách → đừng mở lại hồ sơ
        private int historyFor;           // khách đang tải lịch sử (bỏ kết quả cũ nếu đã đổi khách)

        public ObservableCollection<Customer> Customers { get; } = new ObservableCollection<Customer>();
        public ObservableCollection<CustomerPurchase> RecentPurchases { get; } = new ObservableCollection<CustomerPurchase>();

        // ================= 4 thẻ số liệu =================
        public string MembersValue { get; private set; } = "0";
        public string MembersTrendText { get; private set; } = "";
        public bool MembersTrendUp { get; private set; } = true;

        public string ReturningValue { get; private set; } = "0";
        public string ReturningTrendText { get; private set; } = "";
        public bool ReturningTrendUp { get; private set; } = true;

        public string RevenueValue { get; private set; } = "0";
        public string RevenueTrendText { get; private set; } = "";
        public bool RevenueTrendUp { get; private set; } = true;

        public string GoldValue { get; private set; } = "0";
        public string GoldTrendText { get; private set; } = "";
        public bool GoldTrendUp { get; private set; } = true;

        private (decimal ThisMonth, decimal LastMonth) memberRevenue;

        // ================= Tìm kiếm, lọc hạng, sắp xếp =================
        private string searchText = "";
        public string SearchText
        {
            get => searchText;
            set
            {
                if (SetProperty(ref searchText, value))
                {
                    OnPropertyChanged(nameof(EmptyTitle));
                    OnPropertyChanged(nameof(EmptyCta));
                    ApplyFilter();
                }
            }
        }

        private string tierFilter = "all";
        public bool TierAll { get => tierFilter == "all"; set { if (value) SetTier("all"); } }
        public bool TierGold { get => tierFilter == MemberTier.Gold; set { if (value) SetTier(MemberTier.Gold); } }
        public bool TierSilver { get => tierFilter == MemberTier.Silver; set { if (value) SetTier(MemberTier.Silver); } }
        public bool TierBasic { get => tierFilter == MemberTier.Basic; set { if (value) SetTier(MemberTier.Basic); } }
        public string TierAllText => $"Tất cả · {all.Count}";
        public string TierGoldText => $"Vàng · {all.Count(c => c.Tier == MemberTier.Gold)}";
        public string TierSilverText => $"Bạc · {all.Count(c => c.Tier == MemberTier.Silver)}";
        public string TierBasicText => $"Thường · {all.Count(c => c.Tier == MemberTier.Basic)}";

        private string sortMode = "recent";   // "recent" | "points" | "name"
        public bool SortRecent { get => sortMode == "recent"; set { if (value) SetSort("recent"); } }
        public bool SortPoints { get => sortMode == "points"; set { if (value) SetSort("points"); } }
        public bool SortName { get => sortMode == "name"; set { if (value) SetSort("name"); } }

        public string FooterText => $"Hiển thị {Customers.Count} / {all.Count} khách hàng · Bấm vào một khách để xem hồ sơ";

        private bool isLoading;
        public bool IsLoading
        {
            get => isLoading;
            private set { if (SetProperty(ref isLoading, value)) OnPropertyChanged(nameof(IsEmpty)); }
        }
        public bool IsEmpty => !IsLoading && Customers.Count == 0;
        public string EmptyTitle => SearchText.Trim().Length > 0
            ? $"Chưa có khách nào khớp “{SearchText.Trim()}”"
            : "Chưa có khách nào trong nhóm này";
        public string EmptyCta => SearchPhone() is string p && p.Length >= 9
            ? $"Đăng ký thành viên với số {(p.Length == 10 ? $"{p[..4]} {p[4..7]} {p[7..]}" : p)}"
            : "Thêm khách hàng mới";

        // ================= Khung bên phải =================
        private CustomerPanel panel = CustomerPanel.None;
        public CustomerPanel Panel
        {
            get => panel;
            private set
            {
                if (SetProperty(ref panel, value))
                {
                    OnPropertyChanged(nameof(IsPanelVisible));
                    OnPropertyChanged(nameof(IsViewMode));
                    OnPropertyChanged(nameof(IsFormMode));
                    OnPropertyChanged(nameof(IsCreating));
                    OnPropertyChanged(nameof(FormTitle));
                    OnPropertyChanged(nameof(FormSubtitle));
                    OnPropertyChanged(nameof(SaveText));
                }
            }
        }
        public bool IsPanelVisible => Panel != CustomerPanel.None;
        public bool IsViewMode => Panel == CustomerPanel.View;
        public bool IsFormMode => Panel == CustomerPanel.Edit || Panel == CustomerPanel.New;
        public bool IsCreating => Panel == CustomerPanel.New;

        // Dòng đang chọn trong danh sách: bấm vào → mở hồ sơ
        private Customer? selectedCustomer;
        public Customer? SelectedCustomer
        {
            get => selectedCustomer;
            set
            {
                if (SetProperty(ref selectedCustomer, value) && value != null && !keepForm)
                    ShowProfile(value, keepMessage: false);
            }
        }

        // Khách đang hiện trong hồ sơ
        private Customer? current;
        public Customer? Current { get => current; private set => SetProperty(ref current, value); }

        public string CurrentPointsText => Format.Number(current?.Points ?? 0);
        public string CurrentSpentText
        {
            get
            {
                decimal spent = current?.TotalSpent ?? 0;
                return spent >= 1_000_000m ? (spent / 1_000_000m).ToString("0.00", Format.Vi) + " tr" : Format.Money(spent);
            }
        }
        public string CurrentOrdersText => Format.Number(current?.PaidOrders ?? 0);
        public string CurrentTierText => current == null ? "" : "Hạng " + current.TierText;

        public string ProgressTitle => current?.Tier switch
        {
            MemberTier.Gold => "Đã đạt hạng cao nhất",
            MemberTier.Silver => "Lên hạng Vàng",
            _ => "Lên hạng Bạc"
        };
        public string ProgressNote
        {
            get
            {
                if (current == null) return "";
                decimal? next = NextTierAt(current);
                return next == null ? Format.Money(current.TotalSpent) : "còn " + Format.Money(next.Value - current.TotalSpent);
            }
        }
        public double ProgressValue
        {
            get
            {
                if (current == null) return 0;
                decimal? next = NextTierAt(current);
                return next == null ? 100 : (double)Math.Min(100m, current.TotalSpent * 100m / next.Value);
            }
        }

        public bool HasHistory => RecentPurchases.Count > 0;
        public bool NoHistory => current != null && current.PaidOrders == 0;

        // ================= Form thêm / sửa =================
        public string FormTitle => IsCreating ? "Đăng ký thành viên mới" : "Sửa thông tin khách";
        public string FormSubtitle => IsCreating
            ? "Khách bắt đầu với 0 điểm, được cộng điểm từ lần mua vé tới."
            : "Điểm và lịch sử mua không đổi khi sửa họ tên, số điện thoại.";
        public string SaveText => IsCreating ? "Đăng ký" : "Lưu thay đổi";

        private string formName = "";
        public string FormName
        {
            get => formName;
            set { if (SetProperty(ref formName, value)) { NameError = ""; OnPropertyChanged(nameof(IsFormNameEmpty)); } }
        }
        public bool IsFormNameEmpty => formName.Length == 0;

        private string formPhone = "";
        public string FormPhone
        {
            get => formPhone;
            set { if (SetProperty(ref formPhone, value)) { PhoneError = ""; OnPropertyChanged(nameof(IsFormPhoneEmpty)); } }
        }
        public bool IsFormPhoneEmpty => formPhone.Length == 0;

        private string nameError = "";
        public string NameError
        {
            get => nameError;
            private set { if (SetProperty(ref nameError, value)) OnPropertyChanged(nameof(HasNameError)); }
        }
        public bool HasNameError => nameError.Length > 0;

        private string phoneError = "";
        public string PhoneError
        {
            get => phoneError;
            private set { if (SetProperty(ref phoneError, value)) OnPropertyChanged(nameof(HasPhoneError)); }
        }
        public bool HasPhoneError => phoneError.Length > 0;

        // ================= Thông báo (hiện phía trên danh sách) =================
        private string message = "";
        public string Message
        {
            get => message;
            private set { if (SetProperty(ref message, value)) OnPropertyChanged(nameof(HasMessage)); }
        }
        public bool HasMessage => message.Length > 0;

        private bool isMessageError;
        public bool IsMessageError { get => isMessageError; private set => SetProperty(ref isMessageError, value); }

        // ================= Xóa (chỉ Quản lý) =================
        public bool CanDelete => AppSession.IsAdmin;
        public bool IsDeleteLocked => current != null && current.OrderCount > 0;
        public bool CanPressDelete => !IsDeleteLocked;
        public bool ShowLockNote => CanDelete && IsDeleteLocked;
        public string DeleteLockNote => "Khách đã có đơn mua vé nên không xóa được — lịch sử bán vé cần giữ lại.";

        private bool isConfirmingDelete;
        public bool IsConfirmingDelete { get => isConfirmingDelete; private set => SetProperty(ref isConfirmingDelete, value); }

        // ================= Lệnh =================
        public ICommand NewCommand { get; }
        public ICommand EditCommand { get; }
        public ICommand SaveCommand { get; }
        public ICommand CancelFormCommand { get; }
        public ICommand ClosePanelCommand { get; }
        public ICommand DeleteCommand { get; }
        public ICommand ConfirmDeleteCommand { get; }
        public ICommand CancelDeleteCommand { get; }
        public ICommand ReloadCommand { get; }

        public CustomerManagementViewModel()
        {
            NewCommand = new RelayCommand(_ => StartNew());
            EditCommand = new RelayCommand(_ => StartEdit(), _ => current != null);
            SaveCommand = new RelayCommand(_ => Save());
            CancelFormCommand = new RelayCommand(_ => CancelForm());
            ClosePanelCommand = new RelayCommand(_ => ClosePanel());
            DeleteCommand = new RelayCommand(_ => AskDelete(), _ => CanDelete && current != null && !IsDeleteLocked);
            ConfirmDeleteCommand = new RelayCommand(_ => ConfirmDelete());
            CancelDeleteCommand = new RelayCommand(_ => IsConfirmingDelete = false);
            ReloadCommand = new RelayCommand(async _ => await LoadAsync(current?.CustomerID));

            _ = LoadAsync(null);
        }

        // ================= Tải dữ liệu =================
        private async Task LoadAsync(int? showId)
        {
            IsLoading = true;
            try
            {
                var data = await Task.Run(() => (service.GetAll(), service.GetMemberRevenue()));
                all = data.Item1;
                memberRevenue = data.Item2;
            }
            catch (Exception)
            {
                all = new List<Customer>();
                memberRevenue = (0, 0);
                ShowError(DbError);
            }
            IsLoading = false;

            UpdateStats();

            Customer? toShow = showId == null ? null : all.Find(c => c.CustomerID == showId);
            if (toShow != null) ShowProfile(toShow, keepMessage: true);
            else if (showId != null) ClosePanel();
            ApplyFilter();
        }

        private void UpdateStats()
        {
            // Thành viên: so với 30 ngày trước (khách mua lần đầu trong 30 ngày là khách mới)
            int total = all.Count;
            int newOnes = all.Count(c => c.FirstPurchase >= DateTime.Today.AddDays(-30));
            MembersValue = Format.Number(total);
            (MembersTrendText, MembersTrendUp) = Trend(total, total - newOnes);

            // Khách quay lại (từ 2 đơn): bây giờ so với lúc đầu tháng
            int returning = all.Count(c => c.PaidOrders >= 2);
            int returningBefore = all.Count(c => c.PaidOrdersBeforeMonth >= 2);
            ReturningValue = Format.Number(returning);
            (ReturningTrendText, ReturningTrendUp) = Trend(returning, returningBefore);

            // Doanh thu thành viên: tháng này so với cùng kỳ tháng trước (đơn vị triệu)
            RevenueValue = Format.Million(memberRevenue.ThisMonth);
            (RevenueTrendText, RevenueTrendUp) = Trend(memberRevenue.ThisMonth, memberRevenue.LastMonth);

            // Hạng Vàng: bây giờ so với lúc đầu tháng
            int gold = all.Count(c => c.Tier == MemberTier.Gold);
            int goldBefore = all.Count(c => c.SpentBeforeMonth >= MemberTier.GoldFrom);
            GoldValue = Format.Number(gold);
            (GoldTrendText, GoldTrendUp) = Trend(gold, goldBefore);

            foreach (string p in new[]
            {
                nameof(MembersValue), nameof(MembersTrendText), nameof(MembersTrendUp),
                nameof(ReturningValue), nameof(ReturningTrendText), nameof(ReturningTrendUp),
                nameof(RevenueValue), nameof(RevenueTrendText), nameof(RevenueTrendUp),
                nameof(GoldValue), nameof(GoldTrendText), nameof(GoldTrendUp),
                nameof(TierAllText), nameof(TierGoldText), nameof(TierSilverText), nameof(TierBasicText)
            })
                OnPropertyChanged(p);
        }

        // "25,00%" + tăng/giảm. Kỳ trước = 0 mà nay có số → coi như tăng 100%.
        private static (string Text, bool Up) Trend(decimal now, decimal before)
        {
            decimal pct = before == 0 ? (now > 0 ? 100 : 0) : (now - before) * 100m / before;
            return (Math.Abs(pct).ToString("N2", Format.Vi) + "%", now >= before);
        }

        private static decimal? NextTierAt(Customer c) => c.Tier switch
        {
            MemberTier.Basic => MemberTier.SilverFrom,
            MemberTier.Silver => MemberTier.GoldFrom,
            _ => null
        };

        private void SetTier(string tier)
        {
            tierFilter = tier;
            OnPropertyChanged(nameof(TierAll));
            OnPropertyChanged(nameof(TierGold));
            OnPropertyChanged(nameof(TierSilver));
            OnPropertyChanged(nameof(TierBasic));
            ApplyFilter();
        }

        private void SetSort(string mode)
        {
            sortMode = mode;
            OnPropertyChanged(nameof(SortRecent));
            OnPropertyChanged(nameof(SortPoints));
            OnPropertyChanged(nameof(SortName));
            ApplyFilter();
        }

        private void ApplyFilter()
        {
            string q = NameHelper.Fold(SearchText.Trim());
            string digits = Regex.Replace(SearchText, @"\D", "");

            IEnumerable<Customer> list = all.Where(c =>
                (q.Length == 0
                 || (digits.Length >= 3 && c.Phone.Contains(digits))
                 || NameHelper.Fold(c.FullName).Contains(q))
                && (tierFilter == "all" || c.Tier == tierFilter));

            var vi = StringComparer.Create(Format.Vi, true);
            list = sortMode switch
            {
                "points" => list.OrderByDescending(c => c.Points),
                "name" => list.OrderBy(c => NameHelper.GivenName(c.FullName), vi).ThenBy(c => c.FullName, vi),
                _ => list.OrderByDescending(c => c.LastPurchase ?? DateTime.MinValue).ThenByDescending(c => c.CustomerID)
            };

            keepForm = true;
            Customers.Clear();
            foreach (Customer c in list) Customers.Add(c);
            SelectedCustomer = Panel == CustomerPanel.New || current == null
                ? null
                : Customers.FirstOrDefault(c => c.CustomerID == current.CustomerID);
            keepForm = false;

            OnPropertyChanged(nameof(FooterText));
            OnPropertyChanged(nameof(IsEmpty));
        }

        // ================= Hồ sơ =================
        private void ShowProfile(Customer c, bool keepMessage)
        {
            Current = c;
            Panel = CustomerPanel.View;
            ResetFormState(keepMessage);
            LoadHistory(c);
        }

        private async void LoadHistory(Customer c)
        {
            historyFor = c.CustomerID;
            RecentPurchases.Clear();
            OnPropertyChanged(nameof(HasHistory));
            if (c.PaidOrders == 0) return;

            List<CustomerPurchase> items;
            try
            {
                items = await Task.Run(() => service.GetRecentPurchases(c.CustomerID, HistoryCount));
            }
            catch (Exception)
            {
                return;   // lịch sử chỉ là phần phụ: lỗi thì để trống, không báo đỏ cả màn
            }
            if (historyFor != c.CustomerID) return;   // người dùng đã bấm sang khách khác
            foreach (CustomerPurchase p in items) RecentPurchases.Add(p);
            OnPropertyChanged(nameof(HasHistory));
        }

        private void ClosePanel()
        {
            Current = null;
            Panel = CustomerPanel.None;
            keepForm = true;
            SelectedCustomer = null;
            keepForm = false;
            ResetFormState(keepMessage: true);
        }

        // ================= Form =================
        private void StartNew()
        {
            Current = null;
            keepForm = true;
            SelectedCustomer = null;
            keepForm = false;
            FormName = "";
            FormPhone = SearchPhone() ?? "";   // đang tìm một số chưa có → điền sẵn
            Panel = CustomerPanel.New;
            ResetFormState(keepMessage: false);
        }

        private void StartEdit()
        {
            if (current == null) return;
            FormName = current.FullName;
            FormPhone = current.Phone;
            Panel = CustomerPanel.Edit;
            ResetFormState(keepMessage: false);
        }

        private void CancelForm()
        {
            if (Panel == CustomerPanel.Edit && current != null) ShowProfile(current, keepMessage: false);
            else ClosePanel();
        }

        // Ô tìm kiếm đang là một số điện thoại (bắt đầu bằng 0)? → trả về số đó
        private string? SearchPhone()
        {
            string digits = Regex.Replace(SearchText, @"[\s.\-]", "");
            return Regex.IsMatch(digits, @"^0\d{0,9}$") ? digits : null;
        }

        private void ResetFormState(bool keepMessage)
        {
            NameError = "";
            PhoneError = "";
            IsConfirmingDelete = false;
            if (!keepMessage) Message = "";

            foreach (string p in new[]
            {
                nameof(CurrentPointsText), nameof(CurrentSpentText), nameof(CurrentOrdersText), nameof(CurrentTierText),
                nameof(ProgressTitle), nameof(ProgressNote), nameof(ProgressValue), nameof(NoHistory),
                nameof(IsDeleteLocked), nameof(CanPressDelete), nameof(ShowLockNote)
            })
                OnPropertyChanged(p);
            CommandManager.InvalidateRequerySuggested();
        }

        private async void Save()
        {
            NameError = "";
            PhoneError = "";

            bool creating = Panel == CustomerPanel.New;
            int? editingId = creating ? null : current?.CustomerID;
            string name = Regex.Replace(FormName.Trim(), @"\s+", " ");
            string phone = Regex.Replace(FormPhone, @"[\s.\-]", "");   // cho phép gõ "0901 234 567"

            if (name.Length == 0) NameError = "Vui lòng nhập họ tên khách hàng.";
            else if (name.Length > 100) NameError = "Họ tên tối đa 100 ký tự.";

            if (!Regex.IsMatch(phone, @"^0\d{9}$"))
                PhoneError = "Số điện thoại phải có đúng 10 chữ số và bắt đầu bằng 0.";
            else
            {
                Customer? dup = all.Find(c => c.Phone == phone && c.CustomerID != editingId);
                if (dup != null) PhoneError = $"Số này đã thuộc về khách {dup.FullName}.";
            }

            if (HasNameError || HasPhoneError) return;

            try
            {
                int id;
                string done;
                if (creating)
                {
                    id = await Task.Run(() => service.Create(name, phone));
                    done = $"Đã đăng ký thành viên {name} ({phone}).";
                    searchText = "";
                    OnPropertyChanged(nameof(SearchText));
                    if (!TierAll) SetTier("all");
                }
                else
                {
                    id = editingId!.Value;
                    await Task.Run(() => service.Update(id, name, phone));
                    done = $"Đã cập nhật thông tin {name}.";
                }
                await LoadAsync(id);
                ShowSuccess(done);
            }
            catch (InvalidOperationException ex) { ShowError(ex.Message); }
            catch (Exception) { ShowError(DbError); }
        }

        // ================= Xóa =================
        private void AskDelete()
        {
            if (current == null || !CanDelete || IsDeleteLocked) return;
            Message = "";
            IsConfirmingDelete = true;
        }

        private async void ConfirmDelete()
        {
            Customer? c = current;
            if (c == null || !CanDelete) return;
            try
            {
                await Task.Run(() => service.Delete(c.CustomerID));
                ClosePanel();
                await LoadAsync(null);
                ShowSuccess($"Đã xóa khách hàng {c.FullName}.");
            }
            catch (InvalidOperationException ex) { IsConfirmingDelete = false; ShowError(ex.Message); }
            catch (Exception) { IsConfirmingDelete = false; ShowError(DbError); }
        }

        private void ShowError(string text) { IsMessageError = true; Message = text; }
        private void ShowSuccess(string text) { IsMessageError = false; Message = text; }
    }
}
