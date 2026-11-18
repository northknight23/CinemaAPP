using System.Windows;
using CinemaAPP.Helpers;

namespace CinemaAPP.Views
{
    // Cửa sổ TẠM để chạy thử 3 màn của A (xem ghi chú đầu file .xaml).
    public partial class ManagementDemoWindow : Window
    {
        // Mỗi màn chỉ tạo 1 lần, chuyển qua lại không phải tải lại
        private AccountManagementView? accounts;
        private CustomerManagementView? customers;
        private RevenueView? revenue;

        public ManagementDemoWindow()
        {
            InitializeComponent();

            txtUser.Text = AppSession.CurrentUser != null
                ? $"Đang đăng nhập: {AppSession.CurrentUser.FullName} ({AppSession.CurrentUser.Username})"
                : "Chưa đăng nhập (đang chạy thử) → màn Tài khoản không biết ai là \"bạn\".";

            navAccounts.IsChecked = true;
        }

        private void Nav_Checked(object sender, RoutedEventArgs e)
        {
            if (sender == navAccounts) host.Content = accounts ??= new AccountManagementView();
            else if (sender == navCustomers) host.Content = customers ??= new CustomerManagementView();
            else if (sender == navRevenue) host.Content = revenue ??= new RevenueView();
        }
    }
}
