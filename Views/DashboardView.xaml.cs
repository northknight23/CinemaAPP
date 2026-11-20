using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using CinemaAPP.ViewModels;
namespace CinemaAPP.Views
{
    // Màn Tổng quan (Quản trị). Logic nằm ở DashboardViewModel (gán DataContext trong XAML).
    public partial class DashboardView : UserControl
    {
        public DashboardView()
        {
            InitializeComponent();
            // Chỉ tự tải lại khi màn đang hiện; chuyển sang màn khác thì dừng
            Loaded += (s, e) => (DataContext as DashboardViewModel)?.StartAutoRefresh();
            Unloaded += (s, e) => (DataContext as DashboardViewModel)?.StopAutoRefresh();
        }

        // Bấm chuột trái vào nút "7 ngày qua" / "⋮" thì mở menu xổ xuống ngay dưới nút.
        private void OpenMenu(object sender, RoutedEventArgs e)
        {
            if (sender is not Button { ContextMenu: { } menu } button) return;
            menu.PlacementTarget = button;
            menu.Placement = PlacementMode.Bottom;
            menu.DataContext = button.DataContext;
            menu.IsOpen = true;
        }
    }
}
