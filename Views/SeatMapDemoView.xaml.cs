using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;

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
    }
}
