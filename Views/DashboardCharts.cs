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

        // Nét đứt (vd "4 3") cho đường kỳ trước; để trống = nét liền
        public static readonly DependencyProperty StrokeDashArrayProperty = DependencyProperty.Register(
            nameof(StrokeDashArray), typeof(DoubleCollection), typeof(TrendLine),
            new FrameworkPropertyMetadata(null, FrameworkPropertyMetadataOptions.AffectsRender));

        public DoubleCollection? StrokeDashArray
        {
            get => (DoubleCollection?)GetValue(StrokeDashArrayProperty);
            set => SetValue(StrokeDashArrayProperty, value);
        }

        protected override void OnRender(DrawingContext dc)
        {
            double[]? v = Values;
            double w = ActualWidth, h = ActualHeight;
            if (v == null || v.Length < 2 || w <= 0 || h <= 0) return;

            double[]? off = Offsets;
            double Dx(int i) => off != null && i < off.Length ? off[i] : 0;
            var pen = new Pen(Stroke, 2) { StartLineCap = PenLineCap.Round, EndLineCap = PenLineCap.Round, LineJoin = PenLineJoin.Round };
            if (StrokeDashArray is { Count: > 0 } dash)
                pen.DashStyle = new DashStyle(dash, 0);

            // Giá trị NaN = ngày không có số liệu → ngắt đường tại đó (vẽ thành nhiều đoạn)
            var line = new StreamGeometry();
            using (var g = line.Open())
            {
                bool open = false;
                for (int i = 0; i < v.Length; i++)
                {
                    if (double.IsNaN(v[i])) { open = false; continue; }
                    var p = new Point((i + 0.5) * w / v.Length + Dx(i), h - v[i]);
                    if (!open) { g.BeginFigure(p, false, false); open = true; }
                    else g.LineTo(p, true, true);
                }
            }
            dc.DrawGeometry(null, pen, line);
        }
    }

    // ================= Màn Thống kê doanh thu =================

    // Biểu đồ vùng của ô Tổng doanh thu: đường cong mềm + vùng tô mờ dần xuống đáy.
    // Giống TrendLine: Values = độ cao (pixel) tính từ đáy, đỉnh i nằm ở tâm ô i của UniformGrid nhãn ngày.
    public class AreaChart : ChartElement
    {
        protected override void OnRender(DrawingContext dc)
        {
            double[]? v = Values;
            double w = ActualWidth, h = ActualHeight;
            if (v == null || v.Length < 2 || w <= 0 || h <= 0) return;

            var pts = v.Select((value, i) => new Point((i + 0.5) * w / v.Length, h - value)).ToArray();

            // Đường cong Catmull-Rom → Bézier: đi qua đúng từng điểm, không gãy khúc
            void Curve(StreamGeometryContext g)
            {
                for (int i = 0; i < pts.Length - 1; i++)
                {
                    Point p0 = pts[Math.Max(i - 1, 0)], p1 = pts[i], p2 = pts[i + 1], p3 = pts[Math.Min(i + 2, pts.Length - 1)];
                    var c1 = new Point(p1.X + (p2.X - p0.X) / 6, p1.Y + (p2.Y - p0.Y) / 6);
                    var c2 = new Point(p2.X - (p3.X - p1.X) / 6, p2.Y - (p3.Y - p1.Y) / 6);
                    g.BezierTo(c1, c2, p2, true, true);
                }
            }

            var area = new StreamGeometry();
            using (var g = area.Open())
            {
                g.BeginFigure(new Point(pts[0].X, h), true, true);
                g.LineTo(pts[0], true, true);
                Curve(g);
                g.LineTo(new Point(pts[^1].X, h), true, true);
            }

            var line = new StreamGeometry();
            using (var g = line.Open())
            {
                g.BeginFigure(pts[0], false, false);
                Curve(g);
            }

            Color c = ColorOf(Stroke);
            var fill = new LinearGradientBrush(Color.FromArgb(140, c.R, c.G, c.B), Color.FromArgb(0, c.R, c.G, c.B), 90);
            dc.DrawGeometry(fill, null, area);
            dc.DrawGeometry(null, new Pen(Stroke, 2.5) { StartLineCap = PenLineCap.Round, EndLineCap = PenLineCap.Round, LineJoin = PenLineJoin.Round }, line);
        }
    }

    // Lớp cha cho biểu đồ tỷ lệ: phần thứ 1, 2, 3 tô bằng Stroke, Stroke2, Stroke3.
    public abstract class ShareChart : ChartElement
    {
        public static readonly DependencyProperty Stroke2Property = DependencyProperty.Register(
            nameof(Stroke2), typeof(Brush), typeof(ShareChart),
            new FrameworkPropertyMetadata(Brushes.Gray, FrameworkPropertyMetadataOptions.AffectsRender));

        public static readonly DependencyProperty Stroke3Property = DependencyProperty.Register(
            nameof(Stroke3), typeof(Brush), typeof(ShareChart),
            new FrameworkPropertyMetadata(Brushes.Gray, FrameworkPropertyMetadataOptions.AffectsRender));

        public Brush Stroke2
        {
            get => (Brush)GetValue(Stroke2Property);
            set => SetValue(Stroke2Property, value);
        }

        public Brush Stroke3
        {
            get => (Brush)GetValue(Stroke3Property);
            set => SetValue(Stroke3Property, value);
        }

        protected Brush BrushAt(int i) => i == 0 ? Stroke : i == 1 ? Stroke2 : Stroke3;
    }

    // Vòng tròn tỷ lệ (donut). Values = giá trị từng phần; chữ ở giữa đặt bằng XAML chồng lên.
    public class DonutChart : ShareChart
    {
        public static readonly DependencyProperty ThicknessProperty = DependencyProperty.Register(
            nameof(Thickness), typeof(double), typeof(DonutChart),
            new FrameworkPropertyMetadata(18.0, FrameworkPropertyMetadataOptions.AffectsRender));

        public double Thickness
        {
            get => (double)GetValue(ThicknessProperty);
            set => SetValue(ThicknessProperty, value);
        }

        protected override void OnRender(DrawingContext dc)
        {
            double[]? v = Values;
            double size = Math.Min(ActualWidth, ActualHeight);
            if (v == null || v.Length == 0 || size <= 0) return;
            double total = v.Sum();
            if (total <= 0) return;

            double r = (size - Thickness) / 2;
            var center = new Point(ActualWidth / 2, ActualHeight / 2);
            Point At(double deg)
            {
                double rad = (deg - 90) * Math.PI / 180;   // 0° ở đỉnh, quay chiều kim đồng hồ
                return new Point(center.X + r * Math.Cos(rad), center.Y + r * Math.Sin(rad));
            }

            int parts = v.Count(x => x > 0);
            const double gap = 1.5;                         // khe nhỏ giữa các phần (độ)
            double start = 0;
            for (int i = 0; i < v.Length; i++)
            {
                if (v[i] <= 0) continue;
                var pen = new Pen(BrushAt(i), Thickness);
                double sweep = v[i] / total * 360;
                if (parts == 1)
                {
                    dc.DrawEllipse(null, pen, center, r, r);  // một phần chiếm trọn vòng
                    return;
                }

                double a0 = start + gap, a1 = start + sweep - gap;
                if (a1 > a0)
                {
                    var arc = new StreamGeometry();
                    using (var g = arc.Open())
                    {
                        g.BeginFigure(At(a0), false, false);
                        g.ArcTo(At(a1), new Size(r, r), 0, a1 - a0 > 180, SweepDirection.Clockwise, true, false);
                    }
                    dc.DrawGeometry(null, pen, arc);
                }
                start += sweep;
            }
        }
    }

    // Thanh ngang chia phần theo tỷ lệ (2D / IMAX / Khác), các phần cách nhau 3px.
    public class ShareBar : ShareChart
    {
        protected override void OnRender(DrawingContext dc)
        {
            double[]? v = Values;
            double w = ActualWidth, h = ActualHeight;
            if (v == null || v.Length == 0 || w <= 0 || h <= 0) return;
            double total = v.Sum();
            if (total <= 0) return;

            const double gap = 3;
            int parts = v.Count(x => x > 0);
            double usable = w - gap * (parts - 1), x = 0;
            for (int i = 0; i < v.Length; i++)
            {
                if (v[i] <= 0) continue;
                double width = v[i] / total * usable;
                dc.DrawRoundedRectangle(BrushAt(i), null, new Rect(x, 0, width, h), h / 2, h / 2);
                x += width + gap;
            }
        }
    }
}
