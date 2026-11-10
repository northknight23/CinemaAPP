using System.Collections.ObjectModel;
using System.Windows.Input;
using CinemaAPP.Helpers;

namespace CinemaAPP.ViewModels
{
    // Sơ đồ ghế dùng DỮ LIỆU GIẢ (chưa cần CSDL): 3 loại ghế Thường / VIP / Đôi, lối đi,
    // đổi suất, xem chi tiết loại ghế, phóng to.
    // Khi ghép với CSDL: lấy ghế từ bảng SEAT của phòng, IsSold lấy từ
    // ShowtimeService.GetSoldSeatIds.
    public class SeatMapDemoViewModel : ObservableObject
    {
        public const int MaxSeats = 8;          // tối đa số ghế một lần đặt
        private const int SeatsPerRow = 12;
        private static readonly int[] AisleBefore = { 3, 11 };   // lối đi trước ghế số 3 và số 11

        private const double ZoomStep = 0.25, MinZoom = 1, MaxZoom = 2;

        public string MovieTitle { get; } = "Cuộc Phiêu Lưu Mùa Hè";
        public string AgeRating { get; } = "P";
        public string AgeRatingNote { get; } = "Mọi lứa tuổi";

        public decimal StandardPrice { get; } = 75000;
        public decimal VipPrice { get; } = 90000;
        public decimal CouplePrice { get; } = 180000;

        public ObservableCollection<SeatRowItem> Rows { get; } = new ObservableCollection<SeatRowItem>();
        public List<SeatTypeInfo> SeatTypes { get; }
        public ObservableCollection<ShowtimeOption> Showtimes { get; } = new ObservableCollection<ShowtimeOption>();

        private ShowtimeOption currentShowtime = null!;
        public ShowtimeOption CurrentShowtime
        {
            get => currentShowtime;
            set => SetProperty(ref currentShowtime, value);
        }

        private int selectedCount;
        public int SelectedCount { get => selectedCount; set => SetProperty(ref selectedCount, value); }

        private decimal total;
        public decimal Total { get => total; set => SetProperty(ref total, value); }

        private string selectedLabels = "Chưa chọn ghế";
        public string SelectedLabels { get => selectedLabels; set => SetProperty(ref selectedLabels, value); }

        private string message = "";
        public string Message { get => message; set => SetProperty(ref message, value); }

        // Hai hộp thoại hiện đè lên màn (không mở cửa sổ mới, View chỉ cần Binding vào cờ này)
        private bool isSeatInfoOpen;
        public bool IsSeatInfoOpen { get => isSeatInfoOpen; set => SetProperty(ref isSeatInfoOpen, value); }

        private bool isShowtimePickerOpen;
        public bool IsShowtimePickerOpen
        {
            get => isShowtimePickerOpen;
            set => SetProperty(ref isShowtimePickerOpen, value);
        }

        private double zoom = 1;
        public double Zoom
        {
            get => zoom;
            set
            {
                if (SetProperty(ref zoom, value))
                {
                    OnPropertyChanged(nameof(ZoomText));
                    OnPropertyChanged(nameof(IsZoomed));
                }
            }
        }
        public string ZoomText => $"{(int)Math.Round(Zoom * 100)}%";
        public bool IsZoomed => Zoom > MinZoom;

        // Giao diện sáng / tối (View tự đổi bộ màu theo cờ này)
        private bool isLightTheme;
        public bool IsLightTheme
        {
            get => isLightTheme;
            set
            {
                if (SetProperty(ref isLightTheme, value))
                    OnPropertyChanged(nameof(ThemeButtonText));
            }
        }
        public string ThemeButtonText => IsLightTheme ? "☾  Giao diện tối" : "☀  Giao diện sáng";

        public ICommand ToggleSeatCommand { get; }
        public ICommand ClearCommand { get; }
        public ICommand ContinueCommand { get; }
        public ICommand OpenSeatInfoCommand { get; }
        public ICommand OpenShowtimesCommand { get; }
        public ICommand PickShowtimeCommand { get; }
        public ICommand CloseDialogCommand { get; }
        public ICommand ZoomInCommand { get; }
        public ICommand ZoomOutCommand { get; }
        public ICommand ResetZoomCommand { get; }
        public ICommand ToggleThemeCommand { get; }

        public SeatMapDemoViewModel()
        {
            int id = 1;
            foreach (string row in new[] { "A", "B", "C" })
                Rows.Add(BuildRow(row, SeatType.Standard, StandardPrice, ref id));
            foreach (string row in new[] { "D", "E", "F", "G", "H" })
                Rows.Add(BuildRow(row, SeatType.Vip, VipPrice, ref id));
            Rows.Add(BuildCoupleRow("J", ref id));

            SeatTypes = new List<SeatTypeInfo>
            {
                new SeatTypeInfo { Type = SeatType.Standard, Name = "Ghế thường", Position = "Hàng A – C",
                    Price = StandardPrice, ColorHex = "#94A3B8",
                    Description = "Ghế ngồi êm, có chỗ để tay và chỗ để ly. Gần màn hình, phù hợp phim hành động." },
                new SeatTypeInfo { Type = SeatType.Vip, Name = "Ghế VIP", Position = "Hàng D – H",
                    Price = VipPrice, ColorHex = "#F59E0B",
                    Description = "Đệm dày, tựa lưng cao. Nằm giữa phòng chiếu nên góc nhìn và âm thanh tốt nhất." },
                new SeatTypeInfo { Type = SeatType.Couple, Name = "Ghế đôi", Position = "Hàng J (cuối phòng)",
                    Price = CouplePrice, ColorHex = "#A855F7",
                    Description = "Hai chỗ liền nhau không có tay vịn ở giữa, có vách ngăn riêng. Giá tính cho cả 2 người." },
            };

            Showtimes.Add(new ShowtimeOption { ShowtimeID = 1, TimeRange = "18:00 – 20:00", Date = "20/11/2026", Format = "2D Phụ đề", RoomName = "Phòng 2" });
            Showtimes.Add(new ShowtimeOption { ShowtimeID = 2, TimeRange = "20:15 – 22:15", Date = "20/11/2026", Format = "2D Lồng tiếng", RoomName = "Phòng 4" });
            Showtimes.Add(new ShowtimeOption { ShowtimeID = 3, TimeRange = "22:30 – 00:30", Date = "20/11/2026", Format = "2D Phụ đề", RoomName = "Phòng 6" });
            Showtimes.Add(new ShowtimeOption { ShowtimeID = 4, TimeRange = "23:45 – 01:45", Date = "20/11/2026", Format = "IMAX 2D", RoomName = "Phòng 1" });
            ChangeShowtime(Showtimes[2]);

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
                ClearSelection();
                Message = "";
            }, _ => SelectedCount > 0);

            // Tuần 3 mới ghép thanh toán thật (BookingService.CreateBooking)
            ContinueCommand = new RelayCommand(
                _ => Message = "Thanh toán sẽ được ghép với CSDL ở tuần 3.",
                _ => SelectedCount > 0);

            OpenSeatInfoCommand = new RelayCommand(_ => IsSeatInfoOpen = true);
            OpenShowtimesCommand = new RelayCommand(_ => IsShowtimePickerOpen = true);
            CloseDialogCommand = new RelayCommand(_ => { IsSeatInfoOpen = false; IsShowtimePickerOpen = false; });

            PickShowtimeCommand = new RelayCommand(p =>
            {
                if (p is not ShowtimeOption option || option.IsCurrent) return;
                ChangeShowtime(option);
                IsShowtimePickerOpen = false;
                Message = $"Đã đổi sang suất {option.TimeRange}. Ghế đã chọn được bỏ chọn.";
            });

            ZoomInCommand = new RelayCommand(_ => Zoom = Math.Min(MaxZoom, Zoom + ZoomStep), _ => Zoom < MaxZoom);
            ZoomOutCommand = new RelayCommand(_ => Zoom = Math.Max(MinZoom, Zoom - ZoomStep), _ => Zoom > MinZoom);
            ResetZoomCommand = new RelayCommand(_ => Zoom = MinZoom, _ => Zoom > MinZoom);
            ToggleThemeCommand = new RelayCommand(_ => IsLightTheme = !IsLightTheme);
        }

        private IEnumerable<SeatItem> AllSeats() => Rows.SelectMany(r => r.Seats).Where(s => !s.IsAisle);

        // Đổi suất: bỏ ghế đang chọn và nạp lại ghế đã bán của suất mới.
        private void ChangeShowtime(ShowtimeOption option)
        {
            foreach (ShowtimeOption s in Showtimes) s.IsCurrent = s == option;
            CurrentShowtime = option;
            ClearSelection();

            // Giả lập ghế đã bán: mỗi suất một bộ khác nhau nhưng cố định (seed theo ShowtimeID)
            var random = new Random(option.ShowtimeID * 7919);
            foreach (SeatItem seat in AllSeats())
                seat.IsSold = random.NextDouble() < 0.18;
        }

        private void ClearSelection()
        {
            foreach (SeatItem s in AllSeats()) s.IsSelected = false;
            UpdateSummary();
        }

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
