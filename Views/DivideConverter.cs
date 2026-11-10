using System.Globalization;
using System.Windows.Data;

namespace CinemaAPP.Views
{
    // values[0] / values[1]. Dùng cho bản đồ thu nhỏ: đổi vị trí cuộn / kích thước vùng nhìn
    // (đã nhân Zoom) về kích thước sơ đồ gốc, để vẽ khung "đang xem" đúng chỗ.
    public class DivideConverter : IMultiValueConverter
    {
        public object Convert(object[] values, Type targetType, object parameter, CultureInfo culture)
        {
            if (values.Length == 2 && values[0] is double value && values[1] is double divisor && divisor > 0)
                return value / divisor;
            return 0.0;
        }

        public object[] ConvertBack(object value, Type[] targetTypes, object parameter, CultureInfo culture)
            => throw new NotSupportedException();
    }
}
