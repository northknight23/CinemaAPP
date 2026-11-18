using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using CinemaAPP.ViewModels;

namespace CinemaAPP.Views
{
    public partial class TicketCard : UserControl
    {
        // Code 39: mẫu 9 phần tử hẹp/rộng cho các chữ số, dấu nối và dấu bắt đầu/kết thúc.
        private const string Alphabet = "0123456789-*";
        private static readonly int[] Patterns =
            { 0x034, 0x121, 0x061, 0x160, 0x031, 0x130, 0x070, 0x025, 0x124, 0x064, 0x085, 0x094 };

        public TicketCard()
        {
            InitializeComponent();
            DataContextChanged += (_, e) =>
            {
                if (e.NewValue is PrintableTicket { Sale: not null } ticket)
                {
                    PaidDetails.Visibility = Visibility.Visible;
                    Barcode.Data = BuildBarcode(ticket.TicketCode, out double width);
                    BarcodeArea.Width = width;
                }
                else
                {
                    PaidDetails.Visibility = Visibility.Collapsed;
                    Barcode.Data = null;
                }
            };
        }

        private static Geometry BuildBarcode(string code, out double totalWidth)
        {
            // Chừa vùng trắng hai đầu để máy quét nhận ra vị trí bắt đầu/kết thúc.
            var bars = new GeometryGroup();
            double x = 10;
            foreach (char character in $"*{code}*")
            {
                int pattern = Patterns[Alphabet.IndexOf(character)];
                for (int bit = 8; bit >= 0; bit--)
                {
                    int width = (pattern & (1 << bit)) == 0 ? 1 : 3;
                    if (bit % 2 == 0)
                        bars.Children.Add(new RectangleGeometry(new Rect(x, 0, width, 36)));
                    x += width;
                }
                x++;
            }

            totalWidth = x + 9;
            return bars;
        }
    }
}
