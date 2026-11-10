using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Input;
using CinemaAPP.ViewModels;

namespace CinemaAPP.Views
{
    public partial class SeatMapDemoView : UserControl
    {
        private static readonly Uri DarkTheme = new("/CinemaAPP;component/Views/Themes/SeatMapDark.xaml", UriKind.Relative);
        private static readonly Uri LightTheme = new("/CinemaAPP;component/Views/Themes/SeatMapLight.xaml", UriKind.Relative);

        // Chỉ là việc của giao diện (chọn bộ màu), không có nghiệp vụ: ViewModel giữ IsLightTheme,
        // View nhận qua Binding rồi tự thay bộ màu.
        public static readonly DependencyProperty IsLightThemeProperty = DependencyProperty.Register(
            nameof(IsLightTheme), typeof(bool), typeof(SeatMapDemoView),
            new PropertyMetadata(false, (d, e) => ((SeatMapDemoView)d).ApplyTheme((bool)e.NewValue)));

        public bool IsLightTheme
        {
            get => (bool)GetValue(IsLightThemeProperty);
            set => SetValue(IsLightThemeProperty, value);
        }

        public SeatMapDemoView()
        {
            InitializeComponent();
            SetBinding(IsLightThemeProperty, new Binding("IsLightTheme"));
        }

        private void ApplyTheme(bool light)
        {
            Resources.MergedDictionaries[0] = new ResourceDictionary { Source = light ? LightTheme : DarkTheme };
        }

        // Lăn chuột lên = phóng to, lăn xuống = thu nhỏ. Mức zoom vẫn do lệnh của ViewModel quyết định;
        // View chỉ cuộn lại sao cho điểm đang nằm dưới con trỏ giữ nguyên chỗ.
        private void MapScroll_PreviewMouseWheel(object sender, MouseWheelEventArgs e)
        {
            if (DataContext is not SeatMapDemoViewModel vm) return;
            e.Handled = true;   // không để ScrollViewer cuộn dọc

            ICommand command = e.Delta > 0 ? vm.ZoomInCommand : vm.ZoomOutCommand;
            if (!command.CanExecute(null)) return;

            Point mouse = e.GetPosition(MapScroll);
            double oldZoom = vm.Zoom;
            double x = (MapScroll.HorizontalOffset + mouse.X) / oldZoom;   // tọa độ trên sơ đồ gốc
            double y = (MapScroll.VerticalOffset + mouse.Y) / oldZoom;

            command.Execute(null);
            MapScroll.UpdateLayout();
            MapScroll.ScrollToHorizontalOffset(x * vm.Zoom - mouse.X);
            MapScroll.ScrollToVerticalOffset(y * vm.Zoom - mouse.Y);
        }
    }
}
