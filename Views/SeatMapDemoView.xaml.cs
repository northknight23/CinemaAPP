using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;

namespace CinemaAPP.Views
{
    public partial class SeatMapDemoView : UserControl
    {
        private static readonly Uri LightTheme = new("/CinemaAPP;component/Views/Themes/PosLight.xaml", UriKind.Relative);
        private static readonly Uri DarkTheme = new("/CinemaAPP;component/Views/Themes/PosDark.xaml", UriKind.Relative);

        // Chỉ là việc của giao diện (chọn bộ màu), không có nghiệp vụ: ViewModel giữ IsDarkTheme,
        // View nhận qua Binding rồi tự thay bộ màu.
        public static readonly DependencyProperty IsDarkThemeProperty = DependencyProperty.Register(
            nameof(IsDarkTheme), typeof(bool), typeof(SeatMapDemoView),
            new PropertyMetadata(false, (d, e) => ((SeatMapDemoView)d).ApplyTheme((bool)e.NewValue)));

        public bool IsDarkTheme
        {
            get => (bool)GetValue(IsDarkThemeProperty);
            set => SetValue(IsDarkThemeProperty, value);
        }

        public SeatMapDemoView()
        {
            InitializeComponent();
            SetBinding(IsDarkThemeProperty, new Binding("IsDarkTheme"));
        }

        private void ApplyTheme(bool dark)
        {
            Resources.MergedDictionaries[0] = new ResourceDictionary { Source = dark ? DarkTheme : LightTheme };
        }
    }
}
