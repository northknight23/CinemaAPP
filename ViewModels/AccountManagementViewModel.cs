using System.Collections.ObjectModel;
using System.Text.RegularExpressions;
using System.Windows.Input;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using CinemaAPP.Services;

namespace CinemaAPP.ViewModels
{
    // Màn Quản lý tài khoản: danh sách bên trái, form Thêm/Sửa bên phải.
    public class AccountManagementViewModel : ObservableObject
    {
        private const string DbError = "Không kết nối được cơ sở dữ liệu. Kiểm tra SQL Server rồi bấm Tải lại.";

        private readonly AccountService service = new AccountService();
        private List<Account> all = new List<Account>();   // toàn bộ tài khoản lấy từ CSDL
        private int? editingId;                            // null = đang thêm mới
        private bool keepForm;                             // đang lọc lại danh sách → đừng nạp lại form

        public ObservableCollection<Account> Accounts { get; } = new ObservableCollection<Account>();

        // ================= Tìm kiếm + lọc =================
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
        public string FooterText => $"Hiển thị {Accounts.Count} / {all.Count} tài khoản · Chọn một dòng để sửa";

        private bool isLoading;
        public bool IsLoading
        {
            get => isLoading;
            private set { if (SetProperty(ref isLoading, value)) OnPropertyChanged(nameof(IsEmpty)); }
        }
        public bool IsEmpty => !IsLoading && Accounts.Count == 0;

        // ================= Dòng đang chọn =================
        private Account? selectedAccount;
        public Account? SelectedAccount
        {
            get => selectedAccount;
            set
            {
                if (SetProperty(ref selectedAccount, value) && value != null && !keepForm)
                    EditAccount(value, keepMessage: false);
            }
        }

        // ================= Form =================
        public bool IsEditing => editingId != null;
        public bool IsCreating => editingId == null;
        public bool IsSelf => editingId != null && editingId == AppSession.CurrentUser?.AccountID;
        public bool CanChangeRole => !IsSelf;

        public string FormTitle => IsEditing ? "Sửa tài khoản" : "Thêm tài khoản mới";
        public string FormSubtitle => IsEditing
            ? $"{formUsername} · Mã TK #{editingId}"
            : "Tạo tài khoản đăng nhập cho nhân viên mới.";
        public string SaveText => IsEditing ? "Lưu thay đổi" : "Tạo tài khoản";
        public string PasswordLabel => IsEditing ? "Mật khẩu mới" : "Mật khẩu";
        public string PasswordHint => (IsEditing ? "Để trống nếu không đổi mật khẩu. " : "Ít nhất 6 ký tự. ")
                                      + "Mật khẩu được băm SHA-256 trước khi lưu.";

        private string formUsername = "";
        public string FormUsername
        {
            get => formUsername;
            set { if (SetProperty(ref formUsername, value)) { UsernameError = ""; Message = ""; } }
        }

        private string formFullName = "";
        public string FormFullName
        {
            get => formFullName;
            set { if (SetProperty(ref formFullName, value)) { FullNameError = ""; Message = ""; } }
        }

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

        // ---------- Thông báo xanh/đỏ ----------
        private string message = "";
        public string Message
        {
            get => message;
            private set { if (SetProperty(ref message, value)) OnPropertyChanged(nameof(HasMessage)); }
        }
        public bool HasMessage => message.Length > 0;

        private bool isMessageError;
        public bool IsMessageError { get => isMessageError; private set => SetProperty(ref isMessageError, value); }

        private bool isConfirmingDelete;
        public bool IsConfirmingDelete { get => isConfirmingDelete; private set => SetProperty(ref isConfirmingDelete, value); }

        // ================= Lệnh =================
        public ICommand NewCommand { get; }
        public ICommand SaveCommand { get; }
        public ICommand ResetCommand { get; }
        public ICommand DeleteCommand { get; }
        public ICommand ConfirmDeleteCommand { get; }
        public ICommand CancelDeleteCommand { get; }
        public ICommand ReloadCommand { get; }

        // Nhờ View xóa 2 ô PasswordBox (ViewModel không đụng control)
        public event EventHandler? PasswordsCleared;

        public AccountManagementViewModel()
        {
            NewCommand = new RelayCommand(_ => StartNew());
            SaveCommand = new RelayCommand(_ => Save());
            ResetCommand = new RelayCommand(_ => Reset());
            DeleteCommand = new RelayCommand(_ => AskDelete(), _ => IsEditing);
            ConfirmDeleteCommand = new RelayCommand(_ => ConfirmDelete());
            CancelDeleteCommand = new RelayCommand(_ => IsConfirmingDelete = false);
            ReloadCommand = new RelayCommand(async _ => await LoadAsync(editingId));

            _ = LoadAsync(null);
        }

        // ================= Tải dữ liệu =================
        private async Task LoadAsync(int? selectId)
        {
            IsLoading = true;
            try
            {
                all = await Task.Run(() => service.GetAll());   // chạy nền để cửa sổ không bị đơ
            }
            catch (Exception)
            {
                all = new List<Account>();
                ShowError(DbError);
            }
            IsLoading = false;

            OnPropertyChanged(nameof(FilterAllText));
            OnPropertyChanged(nameof(FilterAdminText));
            OnPropertyChanged(nameof(FilterStaffText));

            Account? toSelect = selectId == null ? null : all.Find(a => a.AccountID == selectId);
            if (toSelect != null) EditAccount(toSelect, keepMessage: true);
            else if (selectId != null) StartNew();
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

        // Dựng lại danh sách hiển thị theo ô tìm kiếm + bộ lọc vai trò
        private void ApplyFilter()
        {
            string q = NameHelper.Fold(SearchText.Trim());
            keepForm = true;
            Accounts.Clear();
            foreach (Account a in all)
            {
                bool roleOk = roleFilter == "all" || a.AccountRole == roleFilter;
                bool textOk = q.Length == 0 || NameHelper.Fold(a.Username + " " + a.FullName).Contains(q);
                if (roleOk && textOk) Accounts.Add(a);
            }
            SelectedAccount = editingId == null ? null : Accounts.FirstOrDefault(a => a.AccountID == editingId);
            keepForm = false;

            OnPropertyChanged(nameof(FooterText));
            OnPropertyChanged(nameof(IsEmpty));
        }

        // ================= Form =================
        private void EditAccount(Account a, bool keepMessage)
        {
            editingId = a.AccountID;
            FormUsername = a.Username;
            FormFullName = a.FullName;
            FormIsAdmin = a.IsAdmin;
            ResetFormState(keepMessage);
        }

        private void StartNew()
        {
            editingId = null;
            FormUsername = "";
            FormFullName = "";
            FormIsAdmin = false;
            keepForm = true;
            SelectedAccount = null;
            keepForm = false;
            ResetFormState(keepMessage: false);
        }

        private void Reset()
        {
            Account? current = all.Find(a => a.AccountID == editingId);
            if (current != null) EditAccount(current, keepMessage: false);
            else StartNew();
        }

        private void ResetFormState(bool keepMessage)
        {
            PasswordsCleared?.Invoke(this, EventArgs.Empty);   // View xóa 2 ô mật khẩu → NewPassword = ""
            NewPassword = "";
            ConfirmPassword = "";
            ClearErrors();
            IsConfirmingDelete = false;
            if (!keepMessage) Message = "";

            OnPropertyChanged(nameof(IsEditing));
            OnPropertyChanged(nameof(IsCreating));
            OnPropertyChanged(nameof(IsSelf));
            OnPropertyChanged(nameof(CanChangeRole));
            OnPropertyChanged(nameof(FormTitle));
            OnPropertyChanged(nameof(FormSubtitle));
            OnPropertyChanged(nameof(SaveText));
            OnPropertyChanged(nameof(PasswordLabel));
            OnPropertyChanged(nameof(PasswordHint));
            CommandManager.InvalidateRequerySuggested();   // nút Xóa bật/tắt theo IsEditing ngay
        }

        private void ClearErrors()
        {
            UsernameError = "";
            FullNameError = "";
            PasswordError = "";
            ConfirmError = "";
        }

        private async void Save()
        {
            ClearErrors();
            IsConfirmingDelete = false;

            bool creating = editingId == null;
            string user = FormUsername.Trim();
            string name = Regex.Replace(FormFullName.Trim(), @"\s+", " ");
            string role = FormIsAdmin ? Roles.Admin : Roles.Staff;
            bool changePassword = creating || NewPassword.Length > 0 || ConfirmPassword.Length > 0;

            // ---- Kiểm tra dữ liệu ----
            if (creating)
            {
                if (!Regex.IsMatch(user, "^[A-Za-z0-9_]{3,30}$"))
                    UsernameError = "Cần 3–30 ký tự: chữ không dấu, số hoặc dấu _.";
                else if (all.Any(a => string.Equals(a.Username, user, StringComparison.OrdinalIgnoreCase)))
                    UsernameError = $"Tên đăng nhập \"{user}\" đã tồn tại.";
            }
            if (name.Length == 0) FullNameError = "Vui lòng nhập họ tên.";
            else if (name.Length > 50) FullNameError = "Họ tên tối đa 50 ký tự.";

            if (changePassword)
            {
                if (NewPassword.Length < 6) PasswordError = "Cần ít nhất 6 ký tự.";
                if (ConfirmPassword != NewPassword) ConfirmError = "Không khớp với mật khẩu bên cạnh.";
            }
            if (IsSelf) role = Roles.Admin;   // ô vai trò đã khóa, chặn thêm một lần cho chắc

            if (HasUsernameError || HasFullNameError || HasPasswordError || HasConfirmError)
            {
                ShowError("Chưa lưu được — kiểm tra các ô báo đỏ.");
                return;
            }

            // ---- Ghi CSDL ----
            try
            {
                int id;
                string done;
                if (creating)
                {
                    id = service.Create(user, name, role, NewPassword);
                    done = $"Đã tạo tài khoản {user}. Nhân viên có thể đăng nhập ngay.";
                }
                else
                {
                    id = editingId!.Value;
                    service.Update(id, name, role, changePassword ? NewPassword : null);
                    done = $"Đã lưu thay đổi cho {FormUsername}" + (changePassword ? " (đã đặt mật khẩu mới)." : ".");

                    // Sửa chính mình → cập nhật tên đang hiển thị trên app
                    if (IsSelf && AppSession.CurrentUser != null) AppSession.CurrentUser.FullName = name;
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
            Account? current = all.Find(a => a.AccountID == editingId);
            if (current == null) return;

            if (IsSelf)
            {
                ShowError("Không thể xóa tài khoản đang đăng nhập.");
                return;
            }
            if (current.OrderCount > 0)
            {
                ShowError($"Không thể xóa {current.Username}: tài khoản đã lập {current.OrderCountText} đơn bán vé "
                          + "(ràng buộc khóa ngoại). Có thể đổi vai trò hoặc đặt mật khẩu mới thay vì xóa.");
                return;
            }
            Message = "";
            IsConfirmingDelete = true;
        }

        private async void ConfirmDelete()
        {
            Account? current = all.Find(a => a.AccountID == editingId);
            if (current == null) return;
            try
            {
                service.Delete(current.AccountID);
                StartNew();
                await LoadAsync(null);
                ShowSuccess($"Đã xóa tài khoản {current.Username}.");
            }
            catch (InvalidOperationException ex) { IsConfirmingDelete = false; ShowError(ex.Message); }
            catch (Exception) { IsConfirmingDelete = false; ShowError(DbError); }
        }

        private void ShowError(string text) { IsMessageError = true; Message = text; }
        private void ShowSuccess(string text) { IsMessageError = false; Message = text; }
    }
}
