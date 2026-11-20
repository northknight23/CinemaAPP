using System.Windows;
using System.Windows.Media;

namespace CinemaAPP.Views
{
    // Các hình vẽ nhỏ của màn Tổng quan, vẽ thẳng từ dữ liệu (không dùng thư viện biểu đồ).

    // Lớp cha: một mảng giá trị + một màu nét.
    public abstract class ChartElement : FrameworkElement
    {
        public static readonly DependencyProperty ValuesProperty = DependencyProperty.Register(
            nameof(Values), typeof(double[]), typeof(ChartElement),
            new FrameworkPropertyMetadata(null, FrameworkPropertyMetadataOptions.AffectsRender));

        public static readonly DependencyProperty StrokeProperty = DependencyProperty.Register(
            nameof(Stroke), typeof(Brush), typeof(ChartElement),
            new FrameworkPropertyMetadata(Brushes.Gray, FrameworkPropertyMetadataOptions.AffectsRender));

        public double[]? Values
        {
            get => (double[]?)GetValue(ValuesProperty);
            set => SetValue(ValuesProperty, value);
        }

        public Brush Stroke
        {
            get => (Brush)GetValue(StrokeProperty);
            set => SetValue(StrokeProperty, value);
        }

        protected static Color ColorOf(Brush brush) => brush is SolidColorBrush s ? s.Color : Colors.Gray;
    }

    // Đường gấp khúc có vùng tô mờ dần xuống đáy (spark/line-teal, spark/line-gold).
    public class SparkLine : ChartElement
    {
        protected override void OnRender(DrawingContext dc)
        {
            double[]? v = Values;
            double w = ActualWidth, h = ActualHeight;
            if (v == null || v.Length < 2 || w <= 0 || h <= 0) return;

            double min = v.Min(), max = v.Max();
            const double top = 8, bottom = 2;   // chừa lề như bản vẽ 110×52
            Point P(int i)
            {
                double t = max == min ? 0.5 : (v[i] - min) / (max - min);
                return new Point(i * w / (v.Length - 1), h - bottom - t * (h - top - bottom));
            }

            var line = new StreamGeometry();
            using (var g = line.Open())
            {
                g.BeginFigure(P(0), false, false);
                for (int i = 1; i < v.Length; i++) g.LineTo(P(i), true, true);
            }

            var area = new StreamGeometry();
            using (var g = area.Open())
            {
                g.BeginFigure(new Point(0, h), true, true);
                for (int i = 0; i < v.Length; i++) g.LineTo(P(i), true, true);
                g.LineTo(new Point(w, h), true, true);
            }

            Color c = ColorOf(Stroke);
            var fill = new LinearGradientBrush(Color.FromArgb(110, c.R, c.G, c.B), Color.FromArgb(0, c.R, c.G, c.B), 90);
            dc.DrawGeometry(fill, null, area);
          
            dc.DrawGeometry(null, new Pen(Stroke, 2) { StartLineCap = PenLineCap.Round, EndLineCap = PenLineCap.Round, LineJoin = PenLineJoin.Round }, line);
        }
    }

 
    // Đường nối "Tỷ lệ lấp đầy" vẽ chồng lên các cột (các điểm tròn là phần tử riêng trong DashboardView
    // để rê chuột hiện chú thích). Đỉnh thứ i nằm ở tâm ô i của UniformGrid, dịch ngang Offsets[i] pixel.
    // Values = chiều cao (pixel) tính từ đáy.
    public class TrendLine : ChartElement
    {
        public static readonly DependencyProperty OffsetsProperty = DependencyProperty.Register(
            nameof(Offsets), typeof(double[]), typeof(TrendLine),
            new FrameworkPropertyMetadata(null, FrameworkPropertyMetadataOptions.AffectsRender));

        public double[]? Offsets
        {
            get => (double[]?)GetValue(OffsetsProperty);
            set => SetValue(OffsetsProperty, value);
        }

        protected override void OnRender(DrawingContext dc)
        {
            double[]? v = Values;
            double w = ActualWidth, h = ActualHeight;
            if (v == null || v.Length < 2 || w <= 0 || h <= 0) return;

            double[]? off = Offsets;
            double Dx(int i) => off != null && i < off.Length ? off[i] : 0;
            var pts = v.Select((value, i) => new Point((i + 0.5) * w / v.Length + Dx(i), h - value)).ToArray();
            var pen = new Pen(Stroke, 2) { StartLineCap = PenLineCap.Round, EndLineCap = PenLineCap.Round, LineJoin = PenLineJoin.Round };

            var line = new StreamGeometry();
            using (var g = line.Open())
            {
                g.BeginFigure(pts[0], false, false);
                foreach (Point p in pts.Skip(1)) g.LineTo(p, true, true);
            }
            dc.DrawGeometry(null, pen, line);
        }
    }
}
