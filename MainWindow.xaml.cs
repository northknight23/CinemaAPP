using System.Windows;
using CinemaAPP.ViewModels;
using CinemaAPP.Views;

namespace CinemaAPP
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            var vm = new MainViewModel(CreatePageView);
            vm.LogoutRequested += (_, _) =>
            {
                var loginWin = new LoginWindow();
                Application.Current.MainWindow = loginWin;
                loginWin.Show();
                Close();
            };
            DataContext = vm;
        }

        private static object? CreatePageView(string pageId, bool isAdmin) => pageId switch
        {
            "Movies" => new MovieManagementView(),
            "Rooms" => new RoomManagementView(),
            "Tickets" => new SeatMapDemoView(),
            "Transactions" => new TransactionsView(),
            "MyShift" => new MyShiftView(),
            "Showtimes" => new ShowtimeManagementView(),
            "Customers" => new CustomerManagementView(),
            "Accounts" => new AccountManagementView(),
            "Revenue" => new RevenueView(),
            "Overview" when isAdmin => new DashboardView(),
            "Overview" => new StaffDashboardView(),
            _ => null
        };
    }
}
