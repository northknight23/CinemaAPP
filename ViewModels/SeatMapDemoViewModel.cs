using System.Collections.ObjectModel;
using System.Windows.Input;
using CinemaAPP.Helpers;

namespace CinemaAPP.ViewModels
{
    // Sơ đồ ghế dùng DỮ LIỆU GIẢ (chưa cần CSDL) để luyện ItemsControl + UniformGrid + DataTrigger.
    // Khi ghép với CSDL: lấy ghế từ bảng SEAT của phòng, IsSold lấy từ
    // ShowtimeService.GetSoldSeatIds.
    public class SeatMapDemoViewModel : ObservableObject
    {
        public int SeatsPerRow { get; } = 10;
        public decimal PricePerSeat { get; } = 75000;
        public ObservableCollection<SeatItem> Seats { get; } = new ObservableCollection<SeatItem>();

        private int selectedCount;
        public int SelectedCount { get => selectedCount; set => SetProperty(ref selectedCount, value); }

        private decimal total;
        public decimal Total { get => total; set => SetProperty(ref total, value); }

        public ICommand ToggleSeatCommand { get; }

        public SeatMapDemoViewModel()
        {
            int id = 1;
            for (int r = 0; r < 8; r++)
                for (int n = 1; n <= SeatsPerRow; n++)
                    Seats.Add(new SeatItem { SeatID = id++, Label = $"{(char)('A' + r)}{n}" });

            Seats[44].IsSold = true;   // giả lập E5, E6 đã bán
            Seats[45].IsSold = true;

            // CommandParameter là chính ô ghế được bấm
            ToggleSeatCommand = new RelayCommand(p =>
            {
                if (p is SeatItem seat && !seat.IsSold)
                {
                    seat.IsSelected = !seat.IsSelected;
                    SelectedCount = Seats.Count(s => s.IsSelected);
                    Total = SelectedCount * PricePerSeat;
                }
            });
        }
    }
}
