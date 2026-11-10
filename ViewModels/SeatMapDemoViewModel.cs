using System.Collections.ObjectModel;
using System.Windows.Input;
using CinemaAPP.Helpers;

namespace CinemaAPP.ViewModels
{
    // Sơ đồ ghế dùng DỮ LIỆU GIẢ (chưa cần CSDL): 3 loại ghế Thường / VIP / Đôi, có lối đi.
    // Khi ghép với CSDL: lấy ghế từ bảng SEAT của phòng, IsSold lấy từ
    // ShowtimeService.GetSoldSeatIds.
    public class SeatMapDemoViewModel : ObservableObject
    {
        public const int MaxSeats = 8;          // tối đa số ghế một lần đặt
        private const int SeatsPerRow = 12;
        private static readonly int[] AisleBefore = { 3, 11 };   // lối đi trước ghế số 3 và số 11

        // Thông tin suất chiếu (giả)
        public string MovieTitle { get; } = "Cuộc Phiêu Lưu Mùa Hè";
        public string AgeRating { get; } = "P";
        public string ShowInfo { get; } = "22:30 – 00:30  ·  20/11/2026";
        public string RoomInfo { get; } = "Phòng 6  ·  2D Phụ đề";

        public decimal StandardPrice { get; } = 75000;
        public decimal VipPrice { get; } = 90000;
        public decimal CouplePrice { get; } = 180000;

        public ObservableCollection<SeatRowItem> Rows { get; } = new ObservableCollection<SeatRowItem>();

        private int selectedCount;
        public int SelectedCount { get => selectedCount; set => SetProperty(ref selectedCount, value); }

        private decimal total;
        public decimal Total { get => total; set => SetProperty(ref total, value); }

        private string selectedLabels = "Chưa chọn ghế";
        public string SelectedLabels { get => selectedLabels; set => SetProperty(ref selectedLabels, value); }

        private string message = "";
        public string Message { get => message; set => SetProperty(ref message, value); }

        public ICommand ToggleSeatCommand { get; }
        public ICommand ClearCommand { get; }
        public ICommand ContinueCommand { get; }

        public SeatMapDemoViewModel()
        {
            int id = 1;
            foreach (string row in new[] { "A", "B", "C" })
                Rows.Add(BuildRow(row, SeatType.Standard, StandardPrice, ref id));
            foreach (string row in new[] { "D", "E", "F", "G", "H" })
                Rows.Add(BuildRow(row, SeatType.Vip, VipPrice, ref id));
            Rows.Add(BuildCoupleRow("J", ref id));

            // Giả lập vài ghế đã bán
            foreach (string label in new[] { "C1", "D5", "D6", "E7", "F8", "F9", "J5-6" })
                AllSeats().First(s => s.Label == label).IsSold = true;

            // CommandParameter là chính ô ghế được bấm
            ToggleSeatCommand = new RelayCommand(p =>
            {
                if (p is not SeatItem seat || seat.IsSold || seat.IsAisle) return;
                if (!seat.IsSelected && SelectedCount >= MaxSeats)
                {
                    Message = $"Mỗi lần chỉ đặt tối đa {MaxSeats} ghế.";
                    return;
                }
                seat.IsSelected = !seat.IsSelected;
                Message = "";
                UpdateSummary();
            });

            ClearCommand = new RelayCommand(_ =>
            {
                foreach (SeatItem s in AllSeats()) s.IsSelected = false;
                Message = "";
                UpdateSummary();
            }, _ => SelectedCount > 0);

            // Tuần 3 mới ghép thanh toán thật (BookingService.CreateBooking)
            ContinueCommand = new RelayCommand(
                _ => Message = "Thanh toán sẽ được ghép với CSDL ở tuần 3.",
                _ => SelectedCount > 0);
        }

        private IEnumerable<SeatItem> AllSeats() => Rows.SelectMany(r => r.Seats).Where(s => !s.IsAisle);

        private void UpdateSummary()
        {
            List<SeatItem> selected = AllSeats().Where(s => s.IsSelected).ToList();
            SelectedCount = selected.Count;
            Total = selected.Sum(s => s.Price);
            SelectedLabels = selected.Count == 0 ? "Chưa chọn ghế" : string.Join(", ", selected.Select(s => s.Label));
        }

        private static SeatRowItem BuildRow(string rowLabel, SeatType type, decimal price, ref int id)
        {
            var row = new SeatRowItem { RowLabel = rowLabel };
            for (int n = 1; n <= SeatsPerRow; n++)
            {
                if (AisleBefore.Contains(n)) row.Seats.Add(SeatItem.Aisle());
                row.Seats.Add(new SeatItem
                {
                    SeatID = id++, RowLabel = rowLabel, NumberText = n.ToString(), Type = type, Price = price
                });
            }
            return row;
        }

        // Hàng ghế đôi: mỗi ô chiếm chỗ 2 ghế thường nên vẫn thẳng cột với các hàng trên.
        private SeatRowItem BuildCoupleRow(string rowLabel, ref int id)
        {
            var row = new SeatRowItem { RowLabel = rowLabel };
            for (int n = 1; n <= SeatsPerRow; n += 2)
            {
                if (AisleBefore.Contains(n)) row.Seats.Add(SeatItem.Aisle());
                row.Seats.Add(new SeatItem
                {
                    SeatID = id++, RowLabel = rowLabel, NumberText = $"{n}-{n + 1}",
                    Type = SeatType.Couple, Price = CouplePrice
                });
            }
            return row;
        }
    }
}
