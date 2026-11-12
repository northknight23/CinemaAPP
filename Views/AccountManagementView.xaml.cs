using System.Windows;
using System.Windows.Controls;
using CinemaAPP.ViewModels;

namespace CinemaAPP.Views
{
    public partial class AccountManagementView : UserControl
    {
        private readonly AccountManagementViewModel vm = new AccountManagementViewModel();

        public AccountManagementView()
        {
            InitializeComponent();
            DataContext = vm;

            // ViewModel nhờ View xóa 2 ô mật khẩu (khi chọn dòng khác, bấm Mới, lưu xong…)
            vm.PasswordsCleared += (s, e) =>
            {
                pwdNew.Clear();
                pwdConfirm.Clear();
            };
        }

        // PasswordBox không binding được → chuyển mật khẩu sang ViewModel ở đây (giống màn Login)
        private void PwdNew_PasswordChanged(object sender, RoutedEventArgs e) => vm.NewPassword = pwdNew.Password;

        private void PwdConfirm_PasswordChanged(object sender, RoutedEventArgs e) => vm.ConfirmPassword = pwdConfirm.Password;
    }
}
