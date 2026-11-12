using System.Collections.ObjectModel;
using System.Text.RegularExpressions;
using System.Windows.Input;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using CinemaAPP.Services;

namespace CinemaAPP.ViewModels
{
    // Màn Quản lý khách hàng: danh sách bên trái, form Thêm/Sửa bên phải.
    public class CustomerManagementViewModel : ObservableObject
    {
        private const string DbError = "Không kết nối được cơ sở dữ liệu. Kiểm tra SQL Server rồi bấm Tải lại.";

        private readonly CustomerService service = new CustomerService();
        private List<Customer> all = new List<Customer>();
        private int? editingId;        // null = đang thêm mới
        private bool keepForm;         // đang lọc lại danh sách → đừng nạp lại form

        public ObservableCollection<Customer> Customers { get; } = new ObservableCollection<Customer>();

        // ================= Ô thống kê nhanh =================
        public string TotalText => Format.Number(all.Count);
        public string BuyersText => Format.Number(all.Count(c => c.OrderCount > 0));
        public string PointsText => Format.Number(all.Sum(c => c.Points)) + " điểm";

        // ================= Tìm kiếm + sắp xếp =================
        private string searchText = "";
        public string SearchText
        {
            get => searchText;
            set { if (SetProperty(ref searchText, value)) ApplyFilter(); }
        }

        private string sortMode = "recent";   // "recent" | "points" | "name"
        public bool SortRecent { get => sortMode == "recent"; set { if (value) SetSort("recent"); } }
        public bool SortPoints { get => sortMode == "points"; set { if (value) SetSort("points"); } }
        public bool SortName { get => sortMode == "name"; set { if (value) SetSort("name"); } }

        public string FooterText => $"Hiển thị {Customers.Count} / {all.Count} khách hàng · Chọn một dòng để xem và sửa";

        private bool isLoading;
        public bool IsLoading
        {
            get => isLoading;
            private set { if (SetProperty(ref isLoading, value)) OnPropertyChanged(nameof(IsEmpty)); }
        }
        public bool IsEmpty => !IsLoading && Customers.Count == 0;

        // ================= Dòng đang chọn =================
        private Customer? selectedCustomer;
        public Customer? SelectedCustomer
        {
            get => selectedCustomer;
            set
            {
                if (SetProperty(ref selectedCustomer, value) && value != null && !keepForm)
                    EditCustomer(value, keepMessage: false);
            }
        }

        // Khách đang sửa (để hiện 4 ô điểm / chi tiêu / số đơn / mua gần nhất)
        private Customer? current;
        public Customer? Current { get => current; private set => SetProperty(ref current, value); }
        public string CurrentPointsText => Format.Number(current?.Points ?? 0);
        public string CurrentSpentText => Format.Money(current?.TotalSpent ?? 0);
        public string CurrentOrdersText => Format.Number(current?.OrderCount ?? 0);
        public string CurrentLastText => current?.LastPurchaseText ?? "—";

        // ================= Form =================
        public bool IsEditing => editingId != null;
        public bool IsCreating => editingId == null;
        public string FormTitle => IsEditing ? "Thông tin khách hàng" : "Thêm khách hàng mới";
        public string FormSubtitle => IsEditing ? $"Mã KH #{editingId}" : "Tạo hồ sơ để khách tích điểm khi mua vé.";
        public string SaveText => IsEditing ? "Lưu thay đổi" : "Thêm khách hàng";

        private string formName = "";
        public string FormName
        {
            get => formName;
            set { if (SetProperty(ref formName, value)) { NameError = ""; Message = ""; } }
        }

        private string formPhone = "";
        public string FormPhone
        {
            get => formPhone;
            set { if (SetProperty(ref formPhone, value)) { PhoneError = ""; Message = ""; } }
        }

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

        public CustomerManagementViewModel()
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
                all = await Task.Run(() => service.GetAll());
            }
            catch (Exception)
            {
                all = new List<Customer>();
                ShowError(DbError);
            }
            IsLoading = false;

            OnPropertyChanged(nameof(TotalText));
            OnPropertyChanged(nameof(BuyersText));
            OnPropertyChanged(nameof(PointsText));

            Customer? toSelect = selectId == null ? null : all.Find(c => c.CustomerID == selectId);
            if (toSelect != null) EditCustomer(toSelect, keepMessage: true);
            else if (selectId != null) StartNew();
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
                q.Length == 0
                || (digits.Length >= 3 && c.Phone.Contains(digits))
                || NameHelper.Fold(c.FullName).Contains(q));

            list = sortMode switch
            {
                "points" => list.OrderByDescending(c => c.Points),
                "name" => list.OrderBy(c => NameHelper.GivenName(c.FullName), StringComparer.Create(Format.Vi, true))
                              .ThenBy(c => c.FullName, StringComparer.Create(Format.Vi, true)),
                _ => list.OrderByDescending(c => c.LastPurchase ?? DateTime.MinValue).ThenByDescending(c => c.CustomerID)
            };

            keepForm = true;
            Customers.Clear();
            foreach (Customer c in list) Customers.Add(c);
            SelectedCustomer = editingId == null ? null : Customers.FirstOrDefault(c => c.CustomerID == editingId);
            keepForm = false;

            OnPropertyChanged(nameof(FooterText));
            OnPropertyChanged(nameof(IsEmpty));
        }

        // ================= Form =================
        private void EditCustomer(Customer c, bool keepMessage)
        {
            editingId = c.CustomerID;
            Current = c;
            FormName = c.FullName;
            FormPhone = c.Phone;
            ResetFormState(keepMessage);
        }

        private void StartNew()
        {
            editingId = null;
            Current = null;
            FormName = "";
            // Đang tìm một số điện thoại không có → điền sẵn số đó cho nhanh
            string digits = Regex.Replace(SearchText, @"\s", "");
            FormPhone = Regex.IsMatch(digits, @"^0\d{0,9}$") ? digits : "";
            keepForm = true;
            SelectedCustomer = null;
            keepForm = false;
            ResetFormState(keepMessage: false);
        }

        private void Reset()
        {
            Customer? c = all.Find(x => x.CustomerID == editingId);
            if (c != null) EditCustomer(c, keepMessage: false);
            else StartNew();
        }

        private void ResetFormState(bool keepMessage)
        {
            NameError = "";
            PhoneError = "";
            IsConfirmingDelete = false;
            if (!keepMessage) Message = "";

            OnPropertyChanged(nameof(IsEditing));
            OnPropertyChanged(nameof(IsCreating));
            OnPropertyChanged(nameof(FormTitle));
            OnPropertyChanged(nameof(FormSubtitle));
            OnPropertyChanged(nameof(SaveText));
            OnPropertyChanged(nameof(CurrentPointsText));
            OnPropertyChanged(nameof(CurrentSpentText));
            OnPropertyChanged(nameof(CurrentOrdersText));
            OnPropertyChanged(nameof(CurrentLastText));
            CommandManager.InvalidateRequerySuggested();   // nút Xóa bật/tắt theo IsEditing ngay
        }

        private async void Save()
        {
            NameError = "";
            PhoneError = "";
            IsConfirmingDelete = false;

            bool creating = editingId == null;
            string name = Regex.Replace(FormName.Trim(), @"\s+", " ");
            string phone = Regex.Replace(FormPhone, @"[\s.\-]", "");   // cho phép gõ "0901 234 567"

            if (name.Length == 0) NameError = "Vui lòng nhập họ tên khách hàng.";
            else if (name.Length > 100) NameError = "Họ tên tối đa 100 ký tự.";

            if (!Regex.IsMatch(phone, @"^0\d{9}$"))
                PhoneError = "Số điện thoại phải có đúng 10 chữ số và bắt đầu bằng 0.";
            else
            {
                Customer? dup = all.Find(c => c.Phone == phone && c.CustomerID != editingId);
                if (dup != null) PhoneError = $"Số này đã thuộc về khách \"{dup.FullName}\".";
            }

            if (HasNameError || HasPhoneError)
            {
                ShowError("Chưa lưu được — kiểm tra các ô báo đỏ.");
                return;
            }

            try
            {
                int id;
                string done;
                if (creating)
                {
                    id = service.Create(name, phone);
                    done = $"Đã thêm khách {name} ({phone}).";
                    SearchText = "";
                }
                else
                {
                    id = editingId!.Value;
                    service.Update(id, name, phone);
                    done = $"Đã cập nhật thông tin khách {name}.";
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
            Customer? c = all.Find(x => x.CustomerID == editingId);
            if (c == null) return;
            if (c.OrderCount > 0)
            {
                ShowError($"Không thể xóa {c.FullName}: khách đã có {c.OrderCount} đơn mua vé "
                          + "(ràng buộc khóa ngoại). Lịch sử bán hàng phải được giữ lại.");
                return;
            }
            Message = "";
            IsConfirmingDelete = true;
        }

        private async void ConfirmDelete()
        {
            Customer? c = all.Find(x => x.CustomerID == editingId);
            if (c == null) return;
            try
            {
                service.Delete(c.CustomerID);
                StartNew();
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
