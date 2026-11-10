using System.Windows;
using System.Windows.Input;
using CinemaAPP.ViewModels;

namespace CinemaAPP.Views
{
    public partial class LoginWindow : Window
    {
        private readonly LoginViewModel vm = new LoginViewModel();

        public LoginWindow()
        {
            InitializeComponent();
            DataContext = vm;

            // ViewModel "nhờ" View làm những việc đụng tới control
            vm.PasswordCleared += (s, e) => { pwdBox.Clear(); pwdBox.Focus(); };
            vm.FormCleared += (s, e) => { pwdBox.Clear(); txtUser.Focus(); };
            vm.LoginSucceeded += (s, e) =>
            {
                new MainWindow().Show();
                Close();
            };

            // Mở lên: đã nhớ tên thì con trỏ ở ô mật khẩu, chưa thì ở ô tên
            Loaded += (s, e) =>
            {
                if (vm.Username.Length > 0) pwdBox.Focus();
                else txtUser.Focus();
            };
        }

        // PasswordBox không binding được → chuyển mật khẩu sang ViewModel ở đây
        private void PwdBox_PasswordChanged(object sender, RoutedEventArgs e)
        {
            vm.Password = pwdBox.Password;
        }

        // Giữ chuột vào con mắt: hiện mật khẩu
        private void Eye_MouseDown(object sender, MouseButtonEventArgs e)
        {
            txtPassReveal.Text = pwdBox.Password;
            txtPassReveal.Visibility = Visibility.Visible;
            pwdBox.Visibility = Visibility.Hidden;
        }

        // Thả chuột hoặc kéo chuột ra ngoài: ẩn lại
        private void Eye_Release(object sender, MouseEventArgs e)
        {
            if (txtPassReveal.Visibility != Visibility.Visible) return;
            txtPassReveal.Visibility = Visibility.Collapsed;
            txtPassReveal.Text = "";
            pwdBox.Visibility = Visibility.Visible;
        }
    }
}