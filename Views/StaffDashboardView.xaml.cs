using System.Windows.Controls;
using CinemaAPP.ViewModels;

namespace CinemaAPP.Views
{
    // Màn Tổng quan của Nhân viên. Logic nằm ở StaffDashboardViewModel (gán DataContext trong XAML).
    public partial class StaffDashboardView : UserControl
    {
        public StaffDashboardView()
        {
            InitializeComponent();
            // Chỉ tự tải lại khi màn đang hiện; chuyển sang màn khác thì dừng
            Loaded += (s, e) => (DataContext as StaffDashboardViewModel)?.StartAutoRefresh();
            Unloaded += (s, e) => (DataContext as StaffDashboardViewModel)?.StopAutoRefresh();
        }
    }
}