using System.Collections.ObjectModel;
using System.Globalization;
using System.Windows.Input;
using CinemaAPP.Helpers;

namespace CinemaAPP.ViewModels
{
    // Màn BÁN VÉ TẠI QUẦY, dùng DỮ LIỆU GIẢ (chưa cần CSDL):
    // trái = suất chiếu hôm nay, giữa = sơ đồ ghế của suất đang chọn, phải = đơn hiện tại + thu tiền.
    // Tên nhân viên, Đăng xuất... thuộc khung app (MainWindow); khi thanh toán thật, AccountID lấy từ
    // AppSession.CurrentUser của màn Đăng nhập.
    // Khi ghép với CSDL: suất lấy từ SHOWTIME, ghế từ SEAT của phòng, ghế đã bán từ
    // ShowtimeService.GetSoldSeatIds, thanh toán gọi BookingService.CreateBooking.
    public class SeatMapDemoViewModel : ObservableObject
    {
        public const int MaxSeats = 8;          // tối đa số ghế một đơn
        private const int SeatsPerRow = 12;
        private static readonly int[] AisleBefore = { 3, 11 };   // lối đi trước ghế số 3 và số 11
        private static readonly CultureInfo Vi = new CultureInfo("vi-VN");

        // Thành viên giả (sau này tra bảng CUSTOMER theo Phone)
        private static readonly Dictionary<string, (string Name, int Points)> Members = new()
        {
            ["0901234567"] = ("Nguyễn Văn An", 120),
            ["0912345678"] = ("Trần Thị Bình", 45),
        };

        // Giao diện sáng / tối (View tự đổi bộ màu theo cờ này)
        private bool isDarkTheme;
        public bool IsDarkTheme
        {
            get => isDarkTheme;
            set
            {
                if (SetProperty(ref isDarkTheme, value))
                    OnPropertyChanged(nameof(ThemeButtonText));
            }
        }
        public string ThemeButtonText => IsDarkTheme ? "☀  Sáng" : "☾  Tối";

        public decimal StandardPrice { get; } = 75000;
        public decimal VipPrice { get; } = 90000;
        public decimal CouplePrice { get; } = 180000;

        public List<MovieShowtimes> Movies { get; } = new List<MovieShowtimes>();
        public int ShowtimeCount => Movies.Sum(m => m.Showtimes.Count);

        private ShowtimeOption currentShowtime = null!;
        public ShowtimeOption CurrentShowtime
        {
            get => currentShowtime;
            set => SetProperty(ref currentShowtime, value);
        }

        public ObservableCollection<SeatRowItem> Rows { get; } = new ObservableCollection<SeatRowItem>();
        public int TotalSeats { get; }

        // Ghế trong đơn, theo thứ tự bấm
        public ObservableCollection<SeatItem> SelectedSeats { get; } = new ObservableCollection<SeatItem>();

        private int selectedCount;
        public int SelectedCount { get => selectedCount; set => SetProperty(ref selectedCount, value); }

        private decimal total;
        public decimal Total { get => total; set => SetProperty(ref total, value); }

        // Ghế trong đơn gom theo loại vé
        public ObservableCollection<OrderLine> OrderLines { get; } = new ObservableCollection<OrderLine>();

        // 1 điểm cho mỗi 10.000 đ, chỉ cộng khi có khách thành viên
        public const decimal MoneyPerPoint = 10000;
        private string pointsText = "—";
        public string PointsText { get => pointsText; set => SetProperty(ref pointsText, value); }

        // ----- Khách thành viên -----
        private string memberPhone = "";
        public string MemberPhone
        {
            get => memberPhone;
            set
            {
                if (SetProperty(ref memberPhone, value))
                {
                    MemberText = "";      // gõ số khác thì bỏ kết quả tìm cũ
                    IsMemberFound = false;
                }
            }
        }

        private string memberText = "";
        public string MemberText { get => memberText; set => SetProperty(ref memberText, value); }

        private bool isMemberFound;
        public bool IsMemberFound
        {
            get => isMemberFound;
            set
            {
                if (SetProperty(ref isMemberFound, value))
                    UpdatePoints();
            }
        }

        // ----- Phương thức thanh toán -----
        // 3 cờ Is... để RadioButton Binding vào; gán true cho cờ nào thì đổi phương thức sang cái đó.
        private PaymentMethod method = PaymentMethod.Cash;
        public PaymentMethod Method
        {
            get => method;
            set
            {
                if (SetProperty(ref method, value))
                {
                    OnPropertyChanged(nameof(IsCash));
                    OnPropertyChanged(nameof(IsTransfer));
                    OnPropertyChanged(nameof(IsCard));
                }
            }
        }
        public bool IsCash { get => Method == PaymentMethod.Cash; set { if (value) Method = PaymentMethod.Cash; } }
        public bool IsTransfer { get => Method == PaymentMethod.Transfer; set { if (value) Method = PaymentMethod.Transfer; } }
        public bool IsCard { get => Method == PaymentMethod.Card; set { if (value) Method = PaymentMethod.Card; } }

        // Mã QR minh họa 21×21 ô (không quét được, chỉ để demo bố cục) và nội dung chuyển khoản
        public List<bool> QrCells { get; } = BuildQrCells();
        public string TransferNote => $"UT{nextBookingId}";

        // ----- Thu tiền -----
        private string cashText = "";
        public string CashText
        {
            get => cashText;
            set
            {
                if (SetProperty(ref cashText, value))
                    UpdateChange();
            }
        }

        private decimal cash;
        public decimal Cash { get => cash; set => SetProperty(ref cash, value); }

        private string changeText = "0 đ";
        public string ChangeText { get => changeText; set => SetProperty(ref changeText, value); }

        private bool isCashShort;
        public bool IsCashShort { get => isCashShort; set => SetProperty(ref isCashShort, value); }

        // ----- Thông báo cuối cột phải -----
        private string message = "";
        public string Message { get => message; set => SetProperty(ref message, value); }

        private bool isMessageError;
        public bool IsMessageError { get => isMessageError; set => SetProperty(ref isMessageError, value); }

        private int nextBookingId = 1001;

        public ICommand SelectShowtimeCommand { get; }
        public ICommand ToggleSeatCommand { get; }
        public ICommand ClearCommand { get; }
        public ICommand FindMemberCommand { get; }
        public ICommand SetCashCommand { get; }
        public ICommand PayCommand { get; }
        public ICommand ToggleThemeCommand { get; }

        public SeatMapDemoViewModel()
        {
            int id = 1;
            foreach (string row in new[] { "A", "B", "C" })
                Rows.Add(BuildRow(row, SeatType.Standard, StandardPrice, ref id));
            foreach (string row in new[] { "D", "E", "F", "G", "H" })
                Rows.Add(BuildRow(row, SeatType.Vip, VipPrice, ref id));
            Rows.Add(BuildCoupleRow("J", ref id));
            TotalSeats = AllSeats().Count();

            BuildShowtimes();

            // Mặc định chọn suất sắp chiếu gần nhất; hết suất thì chọn suất đầu tiên
            List<ShowtimeOption> all = Movies.SelectMany(m => m.Showtimes).ToList();
            SelectShowtime(all.Where(s => s.StartTime > DateTime.Now).MinBy(s => s.StartTime) ?? all[0]);

            SelectShowtimeCommand = new RelayCommand(p =>
            {
                if (p is ShowtimeOption option) SelectShowtime(option);
            });

            // CommandParameter là chính ô ghế được bấm (trên sơ đồ hoặc trong danh sách đơn)
            ToggleSeatCommand = new RelayCommand(p =>
            {
                if (p is not SeatItem seat || seat.IsSold || seat.IsAisle) return;
                if (!seat.IsSelected && SelectedCount >= MaxSeats)
                {
                    ShowMessage($"Mỗi đơn chỉ đặt tối đa {MaxSeats} ghế.", true);
                    return;
                }
                seat.IsSelected = !seat.IsSelected;
                if (seat.IsSelected) SelectedSeats.Add(seat);
                else SelectedSeats.Remove(seat);
                Message = "";
                UpdateSummary();
            });

            ClearCommand = new RelayCommand(_ => ResetOrder(), _ => SelectedCount > 0 || CashText != "" || MemberPhone != "");

            FindMemberCommand = new RelayCommand(_ => FindMember());

            // Tham số: "exact" = vừa đủ tổng tiền, còn lại là số tiền (vd "200000")
            SetCashCommand = new RelayCommand(p =>
            {
                decimal amount = p as string == "exact" ? Total : decimal.Parse((string)p!, CultureInfo.InvariantCulture);
                CashText = amount.ToString("N0", Vi);
            }, p => p as string != "exact" || Total > 0);

            // Tiền mặt phải đưa đủ; chuyển khoản / thẻ thì nhân viên bấm sau khi đã nhận tiền
            PayCommand = new RelayCommand(_ => Pay(),
                _ => SelectedCount > 0 && (Method != PaymentMethod.Cash || Cash >= Total));

            ToggleThemeCommand = new RelayCommand(_ => IsDarkTheme = !IsDarkTheme);
        }

        private IEnumerable<SeatItem> AllSeats() => Rows.SelectMany(r => r.Seats).Where(s => !s.IsAisle);

        private void BuildShowtimes()
        {
            DateTime today = DateTime.Today;
            var summer = new MovieShowtimes { Title = "Cuộc Phiêu Lưu Mùa Hè", AgeRating = "P", Genre = "Phiêu lưu", DurationMin = 120 };
            var ghost = new MovieShowtimes { Title = "Bóng Ma Rạp Cũ", AgeRating = "T16", Genre = "Kinh dị", DurationMin = 100 };
            var cats = new MovieShowtimes { Title = "Đội Cứu Hộ Mèo", AgeRating = "P", Genre = "Hoạt hình", DurationMin = 95 };

            int id = 1;
            void Add(MovieShowtimes movie, int hour, int minute, string room, string format, string audio)
            {
                var showtime = new ShowtimeOption
                {
                    ShowtimeID = id++, MovieTitle = movie.Title, DurationMin = movie.DurationMin,
                    StartTime = today.AddHours(hour).AddMinutes(minute),
                    RoomName = room, ShowFormat = format, AudioType = audio
                };
                // Giả lập vé đã bán: mỗi suất một bộ khác nhau nhưng cố định (seed theo ShowtimeID)
                var random = new Random(showtime.ShowtimeID * 7919);
                foreach (SeatItem seat in AllSeats())
                    if (random.NextDouble() < 0.1) showtime.SoldSeatIds.Add(seat.SeatID);
                showtime.FreeSeats = TotalSeats - showtime.SoldSeatIds.Count;
                movie.Showtimes.Add(showtime);
            }

            Add(summer, 9, 30, "Phòng 1", "2D", "Phụ đề");
            Add(summer, 14, 0, "Phòng 2", "2D", "Phụ đề");
            Add(summer, 20, 15, "Phòng 4", "2D", "Lồng tiếng");
            Add(ghost, 18, 45, "Phòng 3", "2D", "Phụ đề");
            Add(ghost, 21, 30, "Phòng 1", "2D", "Phụ đề");
            Add(cats, 10, 15, "Phòng 3", "3D", "Lồng tiếng");
            Add(cats, 16, 30, "Phòng 2", "3D", "Lồng tiếng");
            Movies.AddRange(new[] { summer, ghost, cats });
        }

        // Đổi suất: bỏ đơn đang làm dở và tô lại ghế đã bán của suất mới.
        private void SelectShowtime(ShowtimeOption option)
        {
            if (option == CurrentShowtime) return;
            foreach (MovieShowtimes movie in Movies)
            {
                foreach (ShowtimeOption s in movie.Showtimes) s.IsCurrent = s == option;
                movie.IsCurrent = movie.Showtimes.Contains(option);
            }
            CurrentShowtime = option;
            ResetOrder();
            foreach (SeatItem seat in AllSeats())
                seat.IsSold = option.SoldSeatIds.Contains(seat.SeatID);
        }

        private void FindMember()
        {
            string phone = MemberPhone.Trim();
            if (phone == "")
            {
                IsMemberFound = false;
                MemberText = "Nhập số điện thoại để tìm.";
            }
            else if (Members.TryGetValue(phone, out var member))
            {
                IsMemberFound = true;
                MemberText = $"{member.Name} · {member.Points} điểm";
            }
            else
            {
                IsMemberFound = false;
                MemberText = "Không tìm thấy thành viên.";
            }
        }

        // Giả lập BookingService.CreateBooking: đánh dấu ghế đã bán cho suất hiện tại.
        private void Pay()
        {
            string labels = string.Join(", ", SelectedSeats.Select(s => s.Label));
            string paid = Money(Total);
            string how = Method switch
            {
                PaymentMethod.Cash => $"Tiền mặt, thối {Money(Cash - Total)}",
                PaymentMethod.Transfer => "Chuyển khoản",
                _ => "Thẻ (POS)",
            };
            string points = IsMemberFound ? $" Cộng {PointsText} cho thành viên." : "";
            foreach (SeatItem seat in SelectedSeats)
            {
                CurrentShowtime.SoldSeatIds.Add(seat.SeatID);
                seat.IsSelected = false;
                seat.IsSold = true;
            }
            CurrentShowtime.FreeSeats -= SelectedSeats.Count;
            int bookingId = nextBookingId++;
            OnPropertyChanged(nameof(TransferNote));

            ResetOrder();
            ShowMessage($"Đã thanh toán đơn #{bookingId}: ghế {labels} – {paid} ({how}).{points}", false);
        }

        // Xóa đơn đang làm: bỏ chọn ghế, tiền khách đưa, khách thành viên, về lại tiền mặt.
        private void ResetOrder()
        {
            foreach (SeatItem s in SelectedSeats) s.IsSelected = false;
            SelectedSeats.Clear();
            CashText = "";
            MemberPhone = "";
            IsMemberFound = false;
            Method = PaymentMethod.Cash;
            Message = "";
            UpdateSummary();
        }

        private void UpdateSummary()
        {
            SelectedCount = SelectedSeats.Count;
            Total = SelectedSeats.Sum(s => s.Price);

            OrderLines.Clear();
            foreach (var group in SelectedSeats.GroupBy(s => s.Type).OrderBy(g => g.Key))
            {
                string name = group.Key switch { SeatType.Vip => "Vé VIP", SeatType.Couple => "Vé Đôi", _ => "Vé Thường" };
                OrderLines.Add(new OrderLine
                {
                    Title = $"{name} · {string.Join(", ", group.Select(s => s.Label))}",
                    Count = group.Count(),
                    Subtotal = group.Sum(s => s.Price)
                });
            }

            UpdatePoints();
            UpdateChange();
        }

        private void UpdatePoints()
        {
            PointsText = IsMemberFound ? $"+{(int)(Total / MoneyPerPoint)} điểm" : "—";
        }

        // Tiền khách đưa chỉ lấy các chữ số (gõ "200.000" hay "200000" đều được).
        private void UpdateChange()
        {
            string digits = new string(CashText.Where(char.IsDigit).ToArray());
            Cash = digits == "" ? 0 : decimal.Parse(digits, CultureInfo.InvariantCulture);
            IsCashShort = Cash > 0 && Cash < Total;
            ChangeText = IsCashShort ? "Còn thiếu " + Money(Total - Cash) : Money(Math.Max(0, Cash - Total));
        }

        private void ShowMessage(string text, bool isError)
        {
            IsMessageError = isError;
            Message = text;
        }

        private static string Money(decimal value) => value.ToString("N0", Vi) + " đ";

        // 3 ô vuông định vị ở 3 góc giống mã QR thật, phần còn lại ngẫu nhiên cố định
        private static List<bool> BuildQrCells()
        {
            const int n = 21;
            var random = new Random(2026);
            var cells = new List<bool>(n * n);
            for (int r = 0; r < n; r++)
                for (int c = 0; c < n; c++)
                {
                    int fr = r < 7 ? r : r >= n - 7 ? r - (n - 7) : -1;
                    int fc = c < 7 ? c : c >= n - 7 ? c - (n - 7) : -1;
                    bool inFinder = fr >= 0 && fc >= 0 && !(r >= n - 7 && c >= n - 7);
                    if (inFinder)
                    {
                        int d = Math.Min(Math.Min(fr, fc), Math.Min(6 - fr, 6 - fc));   // khoảng cách tới mép ô định vị
                        cells.Add(d != 1);
                    }
                    else
                    {
                        bool nearFinder = (r < 8 && (c < 8 || c >= n - 8)) || (r >= n - 8 && c < 8);
                        cells.Add(!nearFinder && random.NextDouble() < 0.5);
                    }
                }
            return cells;
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
