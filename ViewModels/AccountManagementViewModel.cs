using System.Collections.ObjectModel;
using System.Text.RegularExpressions;
using System.Windows.Input;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using CinemaAPP.Services;

namespace CinemaAPP.ViewModels
{
    // Khung bên phải đang hiện gì
    public enum AccountPanel { None, View, Edit, New }

    // Màn Quản lý tài khoản (chỉ Quản trị mở được):
    //  - trên cùng: ô tìm kiếm + 2 thẻ số liệu
    //  - trái: danh sách, lọc theo vai trò, sắp xếp
    //  - phải: CHỈ hiện khi bấm một tài khoản (hồ sơ) hoặc bấm "Thêm tài khoản" (form)
    // Quy ước: tài khoản Quản trị không bán vé → không hiện số liệu bán hàng.
    public class AccountManagementViewModel : ObservableObject
    {
        private const string DbError = "Không kết nối được cơ sở dữ liệu. Kiểm tra SQL Server rồi bấm Tải lại.";
        private const int SalesCount = 4;

        private readonly AccountService service = new AccountService();
        private List<Account> all = new List<Account>();
        private bool keepForm;          // đang lọc lại danh sách → đừng mở lại hồ sơ
        private int salesFor;           // tài khoản đang tải "Bán gần đây" (bỏ kết quả cũ nếu đã đổi)

        public ObservableCollection<Account> Accounts { get; } = new ObservableCollection<Account>();
        public ObservableCollection<AccountSale> RecentSales { get; } = new ObservableCollection<AccountSale>();

        // ================= 2 thẻ số liệu =================
        public string TotalValue => Format.Number(all.Count);
        public string MonthOrdersValue { get; private set; } = "0";
        public string MonthOrdersTrendText { get; private set; } = "";
        public bool MonthOrdersTrendUp { get; private set; } = true;

        // ================= Tìm kiếm, lọc vai trò, sắp xếp =================
        private string searchText = "";
        public string SearchText
        {
            get => searchText;
            set { if (SetProperty(ref searchText, value)) ApplyFilter(); }
        }

        private string roleFilter = "all";   // "all" | Roles.Admin | Roles.Staff
        public bool FilterAll { get => roleFilter == "all"; set { if (value) SetRoleFilter("all"); } }
        public bool FilterAdmin { get => roleFilter == Roles.Admin; set { if (value) SetRoleFilter(Roles.Admin); } }
        public bool FilterStaff { get => roleFilter == Roles.Staff; set { if (value) SetRoleFilter(Roles.Staff); } }
        public string FilterAllText => $"Tất cả · {all.Count}";
        public string FilterAdminText => $"Quản trị · {all.Count(a => a.IsAdmin)}";
        public string FilterStaffText => $"Nhân viên · {all.Count(a => !a.IsAdmin)}";

        private string sortMode = "recent";   // "recent" | "orders" | "name"
        public bool SortRecent { get => sortMode == "recent"; set { if (value) SetSort("recent"); } }
        public bool SortOrders { get => sortMode == "orders"; set { if (value) SetSort("orders"); } }
        public bool SortName { get => sortMode == "name"; set { if (value) SetSort("name"); } }

        public string FooterText => $"Hiển thị {Accounts.Count} / {all.Count} tài khoản · Bấm vào một tài khoản để xem";

        private bool isLoading;
        public bool IsLoading
        {
            get => isLoading;
            private set { if (SetProperty(ref isLoading, value)) OnPropertyChanged(nameof(IsEmpty)); }
        }
        public bool IsEmpty => !IsLoading && Accounts.Count == 0;

        // ================= Khung bên phải =================
        private AccountPanel panel = AccountPanel.None;
        public AccountPanel Panel
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
                    OnPropertyChanged(nameof(IsEditing));
                    OnPropertyChanged(nameof(SaveText));
                    OnPropertyChanged(nameof(PasswordTitle));
                }
            }
        }
        public bool IsPanelVisible => Panel != AccountPanel.None;
        public bool IsViewMode => Panel == AccountPanel.View;
        public bool IsFormMode => Panel == AccountPanel.Edit || Panel == AccountPanel.New;
        public bool IsCreating => Panel == AccountPanel.New;
        public bool IsEditing => Panel == AccountPanel.Edit;

        // Dòng đang chọn trong danh sách: bấm vào → mở hồ sơ
        private Account? selectedAccount;
        public Account? SelectedAccount
        {
            get => selectedAccount;
            set
            {
                if (SetProperty(ref selectedAccount, value) && value != null && !keepForm)
                    ShowProfile(value, keepMessage: false);
            }
        }

        // Tài khoản đang hiện trong hồ sơ
        private Account? current;
        public Account? Current { get => current; private set => SetProperty(ref current, value); }

        public bool IsSelf => current != null && current.AccountID == AppSession.CurrentUser?.AccountID;
        public string ProfileSubText => current == null ? "" : current.AtUsername + (IsSelf ? " · đang đăng nhập" : "");
        public bool IsStaffProfile => current != null && !current.IsAdmin;
        public bool IsAdminProfile => current != null && current.IsAdmin;
        public string CurrentOrdersText => Format.Number(current?.PaidOrders ?? 0);
        public string CurrentRevenueText
        {
            get
            {
                decimal v = current?.Revenue ?? 0;
                return v >= 1_000_000m ? (v / 1_000_000m).ToString("0.0", Format.Vi) + " tr" : Format.Money(v);
            }
        }
        public string CurrentTodayText => Format.Number(current?.TodayOrders ?? 0);
        public bool NoSales => IsStaffProfile && current!.PaidOrders == 0;

        // ================= Form thêm / sửa =================
        private bool resetPasswordMode;   // mở form từ nút "Đặt lại mật khẩu"
        public string FormTitle => IsCreating ? "Thêm tài khoản mới" : resetPasswordMode ? "Đặt lại mật khẩu" : "Sửa tài khoản";
        public string FormSubtitle => IsCreating
            ? "Tạo tài khoản đăng nhập cho nhân viên mới."
            : (current?.AtUsername ?? "") + " · thay đổi có hiệu lực từ lần đăng nhập sau.";
        public string SaveText => IsCreating ? "Tạo tài khoản" : "Lưu thay đổi";
        public string PasswordTitle => IsCreating ? "Mật khẩu đăng nhập" : "Đặt mật khẩu mới (bỏ trống nếu không đổi)";

        private string formUsername = "";
        public string FormUsername
        {
            get => formUsername;
            set { if (SetProperty(ref formUsername, value)) { UsernameError = ""; OnPropertyChanged(nameof(IsFormUsernameEmpty)); } }
        }
        public bool IsFormUsernameEmpty => formUsername.Length == 0;

        private string formFullName = "";
        public string FormFullName
        {
            get => formFullName;
            set { if (SetProperty(ref formFullName, value)) { FullNameError = ""; OnPropertyChanged(nameof(IsFormNameEmpty)); } }
        }
        public bool IsFormNameEmpty => formFullName.Length == 0;

        private bool formIsAdmin;
        public bool FormIsAdmin
        {
            get => formIsAdmin;
            set { if (SetProperty(ref formIsAdmin, value)) OnPropertyChanged(nameof(FormIsStaff)); }
        }
        public bool FormIsStaff
        {
            get => !formIsAdmin;
            set { if (value) FormIsAdmin = false; }
        }

        // Không tự đổi vai trò của chính mình (tránh mất quyền Quản trị)
        public bool CanChangeRole => !(IsEditing && IsSelf);
        public string RoleHint => CanChangeRole
            ? "Nhân viên: bán vé, tra và đăng ký khách hàng. Quản trị: quản lý phim, phòng, suất chiếu, tài khoản, xem thống kê (không bán vé)."
            : "Không tự đổi vai trò của chính mình (tránh mất quyền Quản trị).";

        // PasswordBox không binding được → View gán 2 thuộc tính này trong sự kiện PasswordChanged
        private string newPassword = "";
        public string NewPassword
        {
            get => newPassword;
            set { if (SetProperty(ref newPassword, value)) PasswordError = ""; }
        }

        private string confirmPassword = "";
        public string ConfirmPassword
        {
            get => confirmPassword;
            set { if (SetProperty(ref confirmPassword, value)) ConfirmError = ""; }
        }

        // ---------- Lỗi từng ô ----------
        private string usernameError = "";
        public string UsernameError
        {
            get => usernameError;
            private set { if (SetProperty(ref usernameError, value)) OnPropertyChanged(nameof(HasUsernameError)); }
        }
        public bool HasUsernameError => usernameError.Length > 0;

        private string fullNameError = "";
        public string FullNameError
        {
            get => fullNameError;
            private set { if (SetProperty(ref fullNameError, value)) OnPropertyChanged(nameof(HasFullNameError)); }
        }
        public bool HasFullNameError => fullNameError.Length > 0;

        private string passwordError = "";
        public string PasswordError
        {
            get => passwordError;
            private set { if (SetProperty(ref passwordError, value)) OnPropertyChanged(nameof(HasPasswordError)); }
        }
        public bool HasPasswordError => passwordError.Length > 0;

        private string confirmError = "";
        public string ConfirmError
        {
            get => confirmError;
            private set { if (SetProperty(ref confirmError, value)) OnPropertyChanged(nameof(HasConfirmError)); }
        }
        public bool HasConfirmError => confirmError.Length > 0;

        // ================= Thông báo (phía trên danh sách) =================
        private string message = "";
        public string Message
        {
            get => message;
            private set { if (SetProperty(ref message, value)) OnPropertyChanged(nameof(HasMessage)); }
        }
        public bool HasMessage => message.Length > 0;

        private bool isMessageError;
        public bool IsMessageError { get => isMessageError; private set => SetProperty(ref isMessageError, value); }

        // ================= Xóa =================
        public bool IsDeleteLocked => current == null || IsSelf || current.OrderCount > 0;
        public string DeleteLockNote => current == null ? ""
            : IsSelf ? "Không thể xóa tài khoản đang đăng nhập."
            : current.OrderCount > 0
                ? "Tài khoản đã có đơn bán vé (lịch sử bán hàng cần giữ lại) nên không xóa được. Có thể đổi vai trò hoặc đặt mật khẩu mới."
                : "";
        public bool ShowLockNote => current != null && IsDeleteLocked;

        private bool isConfirmingDelete;
        public bool IsConfirmingDelete { get => isConfirmingDelete; private set => SetProperty(ref isConfirmingDelete, value); }

        // ================= Lệnh =================
        public ICommand NewCommand { get; }
        public ICommand EditCommand { get; }
        public ICommand ResetPasswordCommand { get; }
        public ICommand SaveCommand { get; }
        public ICommand CancelFormCommand { get; }
        public ICommand ClosePanelCommand { get; }
        public ICommand DeleteCommand { get; }
        public ICommand ConfirmDeleteCommand { get; }
        public ICommand CancelDeleteCommand { get; }
        public ICommand ReloadCommand { get; }

        // Nhờ View xóa 2 ô PasswordBox (ViewModel không đụng control)
        public event EventHandler? PasswordsCleared;

        public AccountManagementViewModel()
        {
            NewCommand = new RelayCommand(_ => StartNew());
            EditCommand = new RelayCommand(_ => StartEdit(resetPassword: false), _ => current != null);
            ResetPasswordCommand = new RelayCommand(_ => StartEdit(resetPassword: true), _ => current != null);
            SaveCommand = new RelayCommand(_ => Save());
            CancelFormCommand = new RelayCommand(_ => CancelForm());
            ClosePanelCommand = new RelayCommand(_ => ClosePanel());
            DeleteCommand = new RelayCommand(_ => AskDelete(), _ => !IsDeleteLocked);
            ConfirmDeleteCommand = new RelayCommand(_ => ConfirmDelete());
            CancelDeleteCommand = new RelayCommand(_ => IsConfirmingDelete = false);
            ReloadCommand = new RelayCommand(async _ => await LoadAsync(current?.AccountID));

            _ = LoadAsync(null);
        }

        // ================= Tải dữ liệu =================
        private async Task LoadAsync(int? showId)
        {
            IsLoading = true;
            (int ThisMonth, int LastMonth) month = (0, 0);
            try
            {
                var data = await Task.Run(() => (service.GetAll(), service.GetMonthOrders()));   // chạy nền
                all = data.Item1;
                month = data.Item2;
            }
            catch (Exception)
            {
                all = new List<Account>();
                ShowError(DbError);
            }
            IsLoading = false;

            int? selfId = AppSession.CurrentUser?.AccountID;
            foreach (Account a in all) a.IsSelf = a.AccountID == selfId;

            MonthOrdersValue = Format.Number(month.ThisMonth);
            decimal pct = month.LastMonth == 0
                ? (month.ThisMonth > 0 ? 100 : 0)
                : (month.ThisMonth - month.LastMonth) * 100m / month.LastMonth;
            MonthOrdersTrendText = Math.Abs(pct).ToString("N2", Format.Vi) + "%";
            MonthOrdersTrendUp = month.ThisMonth >= month.LastMonth;

            foreach (string p in new[]
            {
                nameof(TotalValue), nameof(MonthOrdersValue), nameof(MonthOrdersTrendText), nameof(MonthOrdersTrendUp),
                nameof(FilterAllText), nameof(FilterAdminText), nameof(FilterStaffText)
            })
                OnPropertyChanged(p);

            Account? toShow = showId == null ? null : all.Find(a => a.AccountID == showId);
            if (toShow != null) ShowProfile(toShow, keepMessage: true);
            else if (showId != null) ClosePanel();
            ApplyFilter();
        }

        private void SetRoleFilter(string filter)
        {
            roleFilter = filter;
            OnPropertyChanged(nameof(FilterAll));
            OnPropertyChanged(nameof(FilterAdmin));
            OnPropertyChanged(nameof(FilterStaff));
            ApplyFilter();
        }

        private void SetSort(string mode)
        {
            sortMode = mode;
            OnPropertyChanged(nameof(SortRecent));
            OnPropertyChanged(nameof(SortOrders));
            OnPropertyChanged(nameof(SortName));
            ApplyFilter();
        }

        // Dựng lại danh sách hiển thị theo ô tìm kiếm + vai trò + cách sắp xếp
        private void ApplyFilter()
        {
            string q = NameHelper.Fold(SearchText.Trim());
            IEnumerable<Account> list = all.Where(a =>
                (roleFilter == "all" || a.AccountRole == roleFilter)
                && (q.Length == 0 || NameHelper.Fold(a.Username + " " + a.FullName).Contains(q)));

            var vi = StringComparer.Create(Format.Vi, true);
            list = sortMode switch
            {
                "orders" => list.OrderBy(a => a.IsAdmin).ThenByDescending(a => a.PaidOrders),
                "name" => list.OrderBy(a => NameHelper.GivenName(a.FullName), vi).ThenBy(a => a.FullName, vi),
                // Gần đây: người bán gần nhất lên đầu, Quản trị (không bán vé) xuống cuối
                _ => list.OrderBy(a => a.IsAdmin)
                         .ThenByDescending(a => a.LastSale ?? DateTime.MinValue)
                         .ThenByDescending(a => a.TodayOrders)
            };

            keepForm = true;
            Accounts.Clear();
            foreach (Account a in list) Accounts.Add(a);
            SelectedAccount = Panel == AccountPanel.New || current == null
                ? null
                : Accounts.FirstOrDefault(a => a.AccountID == current.AccountID);
            keepForm = false;

            OnPropertyChanged(nameof(FooterText));
            OnPropertyChanged(nameof(IsEmpty));
        }

        // ================= Hồ sơ =================
        private void ShowProfile(Account a, bool keepMessage)
        {
            Current = a;
            Panel = AccountPanel.View;
            ResetFormState(keepMessage);
            LoadSales(a);
        }

        private async void LoadSales(Account a)
        {
            salesFor = a.AccountID;
            RecentSales.Clear();
            if (a.IsAdmin || a.PaidOrders == 0) return;

            List<AccountSale> items;
            try
            {
                items = await Task.Run(() => service.GetRecentSales(a.AccountID, SalesCount));
            }
            catch (Exception)
            {
                return;   // phần phụ: lỗi thì để trống, không báo đỏ cả màn
            }
            if (salesFor != a.AccountID) return;   // đã bấm sang tài khoản khác
            foreach (AccountSale s in items) RecentSales.Add(s);
        }

        private void ClosePanel()
        {
            Current = null;
            Panel = AccountPanel.None;
            keepForm = true;
            SelectedAccount = null;
            keepForm = false;
            ResetFormState(keepMessage: true);
        }

        // ================= Form =================
        private void StartNew()
        {
            Current = null;
            keepForm = true;
            SelectedAccount = null;
            keepForm = false;
            resetPasswordMode = false;
            FormUsername = "";
            FormFullName = "";
            FormIsAdmin = false;
            Panel = AccountPanel.New;
            ResetFormState(keepMessage: false);
        }

        private void StartEdit(bool resetPassword)
        {
            if (current == null) return;
            resetPasswordMode = resetPassword;
            FormUsername = current.Username;
            FormFullName = current.FullName;
            FormIsAdmin = current.IsAdmin;
            Panel = AccountPanel.Edit;
            ResetFormState(keepMessage: false);
        }

        private void CancelForm()
        {
            if (Panel == AccountPanel.Edit && current != null) ShowProfile(current, keepMessage: false);
            else ClosePanel();
        }

        private void ResetFormState(bool keepMessage)
        {
            PasswordsCleared?.Invoke(this, EventArgs.Empty);   // View xóa 2 ô mật khẩu → NewPassword = ""
            NewPassword = "";
            ConfirmPassword = "";
            UsernameError = "";
            FullNameError = "";
            PasswordError = "";
            ConfirmError = "";
            IsConfirmingDelete = false;
            if (!keepMessage) Message = "";

            foreach (string p in new[]
            {
                nameof(IsSelf), nameof(ProfileSubText), nameof(IsStaffProfile), nameof(IsAdminProfile),
                nameof(CurrentOrdersText), nameof(CurrentRevenueText), nameof(CurrentTodayText), nameof(NoSales),
                nameof(FormTitle), nameof(FormSubtitle), nameof(CanChangeRole), nameof(RoleHint),
                nameof(IsDeleteLocked), nameof(DeleteLockNote), nameof(ShowLockNote)
            })
                OnPropertyChanged(p);
            CommandManager.InvalidateRequerySuggested();
        }

        private async void Save()
        {
            UsernameError = "";
            FullNameError = "";
            PasswordError = "";
            ConfirmError = "";

            bool creating = IsCreating;
            string user = FormUsername.Trim();
            string name = Regex.Replace(FormFullName.Trim(), @"\s+", " ");
            string role = FormIsAdmin ? Roles.Admin : Roles.Staff;
            bool changePassword = creating || NewPassword.Length > 0 || ConfirmPassword.Length > 0;

            // ---- Kiểm tra dữ liệu ----
            if (creating)
            {
                if (!Regex.IsMatch(user, "^[A-Za-z0-9_]{3,30}$"))
                    UsernameError = "Từ 3–30 ký tự: chữ không dấu, số hoặc dấu gạch dưới.";
                else if (all.Any(a => string.Equals(a.Username, user, StringComparison.OrdinalIgnoreCase)))
                    UsernameError = $"Tên đăng nhập \"{user}\" đã có người dùng.";
            }
            if (name.Length == 0) FullNameError = "Vui lòng nhập họ tên.";
            else if (name.Length > 50) FullNameError = "Họ tên tối đa 50 ký tự.";

            if (changePassword)
            {
                if (NewPassword.Length < 6) PasswordError = "Mật khẩu cần ít nhất 6 ký tự.";
                if (ConfirmPassword != NewPassword) ConfirmError = "Hai ô mật khẩu chưa khớp nhau.";
            }
            if (!creating && IsSelf) role = Roles.Admin;   // ô vai trò đã khóa, chặn thêm một lần cho chắc

            if (HasUsernameError || HasFullNameError || HasPasswordError || HasConfirmError) return;

            // ---- Ghi CSDL ----
            try
            {
                int id;
                string done;
                string pw = NewPassword;
                if (creating)
                {
                    id = await Task.Run(() => service.Create(user, name, role, pw));
                    done = $"Đã tạo tài khoản @{user}. Nhân viên có thể đăng nhập ngay.";
                    searchText = "";
                    OnPropertyChanged(nameof(SearchText));
                    if (!FilterAll) SetRoleFilter("all");
                }
                else
                {
                    id = current!.AccountID;
                    bool self = IsSelf;
                    await Task.Run(() => service.Update(id, name, role, changePassword ? pw : null));
                    done = $"Đã cập nhật @{current.Username}" + (changePassword ? " và đặt mật khẩu mới." : ".");

                    // Sửa chính mình → cập nhật tên đang hiển thị trên app
                    if (self && AppSession.CurrentUser != null) AppSession.CurrentUser.FullName = name;
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
            if (IsDeleteLocked) return;
            Message = "";
            IsConfirmingDelete = true;
        }

        private async void ConfirmDelete()
        {
            Account? a = current;
            if (a == null || IsDeleteLocked) return;
            try
            {
                await Task.Run(() => service.Delete(a.AccountID));
                ClosePanel();
                await LoadAsync(null);
                ShowSuccess($"Đã xóa tài khoản @{a.Username}.");
            }
            catch (InvalidOperationException ex) { IsConfirmingDelete = false; ShowError(ex.Message); }
            catch (Exception) { IsConfirmingDelete = false; ShowError(DbError); }
        }

        private void ShowError(string text) { IsMessageError = true; Message = text; }
        private void ShowSuccess(string text) { IsMessageError = false; Message = text; }
    }
}
