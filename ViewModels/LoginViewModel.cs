using System.Windows;
using System.Windows.Input;
using System.Windows.Threading;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using CinemaAPP.Services;

namespace CinemaAPP.ViewModels
{
    public class LoginViewModel : ObservableObject
    {
        private readonly AccountService accountService = new AccountService();
        private readonly DispatcherTimer clock;
        private DateTime now = DateTime.Now;

        // ---------- Dữ liệu hiển thị trên form ----------
        private string username = "";
        public string Username
        {
            get => username;
            set { if (SetProperty(ref username, value)) Message = ""; }   // gõ lại thì ẩn thông báo lỗi
        }

        private string password = "";
        public string Password            // View gán vào đây từ sự kiện PasswordChanged
        {
            get => password;
            set { if (SetProperty(ref password, value)) Message = ""; }
        }

        private bool rememberMe;
        public bool RememberMe { get => rememberMe; set => SetProperty(ref rememberMe, value); }

        private string message = "";
        public string Message
        {
            get => message;
            private set { if (SetProperty(ref message, value)) OnPropertyChanged(nameof(HasMessage)); }
        }
        public bool HasMessage => Message.Length > 0;

        // ---------- Đồng hồ ----------
        private static readonly string[] Days =
            { "Chủ Nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy" };
        public string TimeText => now.ToString("HH':'mm':'ss");
        public string DateText => Days[(int)now.DayOfWeek] + ", " + now.ToString("dd'/'MM'/'yyyy");

        // ---------- Trạng thái kết nối CSDL ----------
        private bool? dbConnected;          // null = đang kiểm tra
        public bool IsDbChecking => dbConnected == null;
        public bool IsDbConnected => dbConnected == true;
        public bool IsDbFailed => dbConnected == false;
        public string DbStatusText => dbConnected switch
        {
            null => "Đang kiểm tra kết nối CSDL…",
            true => "Đã kết nối máy chủ CSDL",
            false => "Chế độ ngoại tuyến (Tài khoản mẫu: admin / nv01)"
        };

        // ---------- Lệnh ----------
        public ICommand LoginCommand { get; }
        public ICommand ClearCommand { get; }
        public ICommand ExitCommand { get; }

        // ViewModel không đụng control → báo cho View tự làm
        public event EventHandler? PasswordCleared;   // xóa ô mật khẩu, con trỏ về ô mật khẩu
        public event EventHandler? FormCleared;       // xóa cả form, con trỏ về ô tên
        public event EventHandler? LoginSucceeded;    // mở màn chính

        public LoginViewModel()
        {
            LoginCommand = new RelayCommand(_ => Login());
            ClearCommand = new RelayCommand(_ => Clear());
            ExitCommand = new RelayCommand(_ => Application.Current.Shutdown());

            string? saved = RememberedLogin.Load();
            if (saved != null) { username = saved; rememberMe = true; }

            clock = new DispatcherTimer { Interval = TimeSpan.FromSeconds(1) };
            clock.Tick += (s, e) =>
            {
                now = DateTime.Now;
                OnPropertyChanged(nameof(TimeText));
                OnPropertyChanged(nameof(DateText));
            };
            clock.Start();

            CheckDatabaseAsync();
        }

        // Kiểm tra kết nối ở luồng nền để cửa sổ không bị đơ
        private async void CheckDatabaseAsync()
        {
            bool ok = await Task.Run(() => accountService.CanConnect());
            dbConnected = ok;
            OnPropertyChanged(nameof(IsDbChecking));
            OnPropertyChanged(nameof(IsDbConnected));
            OnPropertyChanged(nameof(IsDbFailed));
            OnPropertyChanged(nameof(DbStatusText));
        }

        private void Login()
        {
            string user = Username.Trim();
            if (user.Length == 0 || Password.Length == 0)
            {
                Message = "Vui lòng nhập tên đăng nhập và mật khẩu.";
                return;
            }

            Account? account;
            try
            {
                account = accountService.Login(user, Password);
            }
            catch (Exception)
            {
                Message = "Không kết nối được cơ sở dữ liệu. Kiểm tra SQL Server rồi thử lại.";
                return;
            }

            if (account == null)
            {
                Password = "";                                // xóa mật khẩu, giữ tên
                PasswordCleared?.Invoke(this, EventArgs.Empty);
                Message = "Sai tên đăng nhập hoặc mật khẩu."; // đặt SAU khi xóa mật khẩu
                return;
            }

            if (RememberMe) RememberedLogin.Save(user);
            else RememberedLogin.Clear();

            AppSession.CurrentUser = account;
            clock.Stop();
            LoginSucceeded?.Invoke(this, EventArgs.Empty);
        }

        private void Clear()
        {
            Username = "";
            Password = "";
            Message = "";
            FormCleared?.Invoke(this, EventArgs.Empty);
        }
    }
}