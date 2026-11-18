using System.Printing;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Markup;
using CinemaAPP.ViewModels;

namespace CinemaAPP.Views
{
    public partial class SeatMapDemoView : UserControl
    {
        public SeatMapDemoView()
        {
            InitializeComponent();
        }

        private void Checkout_Click(object sender, RoutedEventArgs e)
        {
            if (DataContext is not SeatMapDemoViewModel vm)
                return;

            if (vm.PreviewTicket is { Sale: { IsCancelled: false } } paidTicket)
                PrintTicket(paidTicket);
            else if (vm.PayCommand.CanExecute(null))
                vm.PayCommand.Execute(null);
        }

        private void PrintTicket(PrintableTicket ticket)
        {
            try
            {
                var dialog = new PrintDialog();
                if (dialog.ShowDialog() != true) return;

                var capabilities = dialog.PrintQueue.GetPrintCapabilities(dialog.PrintTicket);
                var area = capabilities.PageImageableArea;
                double left = area?.OriginWidth ?? 0;
                double top = area?.OriginHeight ?? 0;
                double width = area?.ExtentWidth ?? dialog.PrintableAreaWidth;
                double height = area?.ExtentHeight ?? dialog.PrintableAreaHeight;
                var pageSize = new Size(capabilities.OrientedPageMediaWidth ?? left + width,
                    capabilities.OrientedPageMediaHeight ?? top + height);
                dialog.PrintDocument(BuildPrintDocument(ticket, pageSize, new Rect(left, top, width, height)).DocumentPaginator,
                    $"UIT Cinema - Don {ticket.TicketCode}");
            }
            catch (Exception ex) when (ex is PrintSystemException
                or System.Windows.Xps.XpsException or InvalidOperationException)
            {
                MessageBox.Show(Window.GetWindow(this), "Không gửi được vé đến máy in. Hãy kiểm tra máy in và thử lại.",
                    "In vé", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
        }

        internal static FixedDocument BuildPrintDocument(PrintableTicket ticket, Size pageSize, Rect area)
        {
            var card = new TicketCard { DataContext = ticket };
            card.Measure(new Size(double.PositiveInfinity, double.PositiveInfinity));
            var paper = new Viewbox
            {
                Width = Math.Min(card.DesiredSize.Width, area.Width),
                Height = Math.Min(card.DesiredSize.Height, area.Height),
                Child = card,
            };
            var page = new FixedPage { Width = pageSize.Width, Height = pageSize.Height };
            FixedPage.SetLeft(paper, area.Left + (area.Width - paper.Width) / 2);
            FixedPage.SetTop(paper, area.Top);
            page.Children.Add(paper);
            var content = new PageContent();
            ((IAddChild)content).AddChild(page);
            var document = new FixedDocument();
            document.DocumentPaginator.PageSize = pageSize;
            document.Pages.Add(content);
            return document;
        }
    }
}
