using System.Collections.ObjectModel;
using System.Globalization;
using System.Windows.Input;
using CinemaAPP.Helpers;
using CinemaAPP.Services;
using CinemaAPP.Models;
using Microsoft.Data.SqlClient;

namespace CinemaAPP.ViewModels
{
    // POS đọc và lưu dữ liệu thật qua BookingService; chỉ cho in sau khi transaction thành công.
    public class SeatMapDemoViewModel : ObservableObject
    {
        private static readonly CultureInfo Vi = new CultureInfo("vi-VN");
        private readonly BookingService bookingService = new();
        private readonly CustomerService customerService = new();
        private Customer? currentMember;
        public decimal StandardPrice => CurrentShowtime.BasePrice;
        public decimal VipPrice => BookingService.SeatPrice(CurrentShowtime.BasePrice, SeatType.Vip);
        public decimal CouplePrice => BookingService.SeatPrice(CurrentShowtime.BasePrice, SeatType.Couple) * 2;
        public ObservableCollection<MovieShowtimes> Movies { get; } = new();
        public int ShowtimeCount => Movies.Sum(m => m.Showtimes.Count);

        private ShowtimeOption currentShowtime = new();
        public ShowtimeOption CurrentShowtime
        {
            get => currentShowtime;
            set => SetProperty(ref currentShowtime, value);
        }

        public ObservableCollection<SeatRowItem> Rows { get; } = new ObservableCollection<SeatRowItem>();
        public int TotalSeats { get; private set; }

        // Ghế trong đơn, theo thứ tự bấm
        public ObservableCollection<SeatItem> SelectedSeats { get; } = new ObservableCollection<SeatItem>();

        private int selectedCount;
        public int SelectedCount { get => selectedCount; set => SetProperty(ref selectedCount, value); }

        private decimal total;
        public decimal Total { get => total; set => SetProperty(ref total, value); }

        public decimal GrossTotal => SelectedSeats.Sum(s => s.Price);
        public int MemberBalance => IsMemberFound ? currentMember?.Points ?? 0 : 0;
        public int MaxRedeemPoints => Math.Max(0, Math.Min(MemberBalance, (int)decimal.Floor(GrossTotal / 1000m)));
        private string redeemPointsText = "0";
        public string RedeemPointsText
        {
            get => redeemPointsText;
            set
            {
                if (SetProperty(ref redeemPointsText, value))
                    UpdateSummary();
            }
        }
        public bool IsRedemptionValid => int.TryParse(RedeemPointsText, out int points) && points >= 0 && points <= MaxRedeemPoints;
        public int PointsUsed => IsMemberFound && IsRedemptionValid ? int.Parse(RedeemPointsText) : 0;
        public decimal DiscountAmount => PointsUsed * 1000m;
        public string RedemptionHint => IsRedemptionValid
            ? $"Có {MemberBalance} điểm · Dùng tối đa {MaxRedeemPoints} điểm (không vượt tiền vé)"
            : $"Nhập số nguyên từ 0 đến {MaxRedeemPoints} điểm.";

        // Chỉ cộng điểm cho khách thành viên; quy tắc theo loại ghế nằm ở TicketRewards.
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
                    currentMember = null;
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
                {
                    RedeemPointsText = "0";
                    UpdateSummary();
                }
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
                    OnPropertyChanged(nameof(CanPay));
                    RefreshTicket();
                }
            }
        }
        public bool IsCash { get => Method == PaymentMethod.Cash; set { if (value) Method = PaymentMethod.Cash; } }
        public bool IsTransfer { get => Method == PaymentMethod.Transfer; set { if (value) Method = PaymentMethod.Transfer; } }
        public bool IsCard { get => Method == PaymentMethod.Card; set { if (value) Method = PaymentMethod.Card; } }

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
        public decimal Cash
        {
            get => cash;
            set
            {
                if (SetProperty(ref cash, value))
                    OnPropertyChanged(nameof(CanPay));
            }
        }

        private string changeText = "0 đ";
        public string ChangeText { get => changeText; set => SetProperty(ref changeText, value); }

        private bool isCashShort;
        public bool IsCashShort { get => isCashShort; set => SetProperty(ref isCashShort, value); }

        // ----- Thông báo cuối cột phải -----
        private string message = "";
        public string Message { get => message; set => SetProperty(ref message, value); }

        private bool isMessageError;
        public bool IsMessageError { get => isMessageError; set => SetProperty(ref isMessageError, value); }

        public ICommand SelectShowtimeCommand { get; }
        public ICommand ToggleSeatCommand { get; }
        public ICommand ClearCommand { get; }
        public ICommand FindMemberCommand { get; }
        public ICommand SetCashCommand { get; }
        public ICommand PayCommand { get; }
        public ICommand ReloadCommand { get; }

        private PrintableTicket? previewTicket;
        public PrintableTicket? PreviewTicket
        {
            get => previewTicket;
            private set
            {
                if (SetProperty(ref previewTicket, value))
                    OnPropertyChanged(nameof(IsPaidTicket));
            }
        }
        public bool IsPaidTicket => PreviewTicket?.Sale != null;
        public bool CanPay => CurrentShowtime.CanSell && SelectedCount > 0 && IsRedemptionValid && (Method != PaymentMethod.Cash || Cash >= Total);

        public SeatMapDemoViewModel()
        {
            SelectShowtimeCommand = new RelayCommand(p =>
            {
                if (p is ShowtimeOption option) SelectShowtime(option);
            });

            // CommandParameter là chính ô ghế được bấm (trên sơ đồ hoặc trong danh sách đơn)
            ToggleSeatCommand = new RelayCommand(p =>
            {
                if (p is not SeatItem seat || seat.IsSold || seat.IsAisle) return;
                if (CurrentShowtime.StartTime <= DateTime.Now)
                {
                    ShowMessage("Suất đã bắt đầu, hãy chọn suất khác.", true);
                    return;
                }
                seat.IsSelected = !seat.IsSelected;
                if (seat.IsSelected) SelectedSeats.Add(seat);
                else SelectedSeats.Remove(seat);
                Message = "";
                UpdateSummary();
            });

            ClearCommand = new RelayCommand(_ => ResetOrder(), _ => IsPaidTicket || SelectedCount > 0 || CashText != "" || MemberPhone != "");

            FindMemberCommand = new RelayCommand(_ => FindMember());

            // Tham số: "exact" = vừa đủ tổng tiền, còn lại là số tiền (vd "200000")
            SetCashCommand = new RelayCommand(p =>
            {
                decimal amount = p as string == "exact" ? Total : decimal.Parse((string)p!, CultureInfo.InvariantCulture);
                CashText = amount.ToString("N0", Vi);
            }, p => p as string != "exact" || SelectedCount > 0);

            // Tiền mặt phải đưa đủ; chuyển khoản / thẻ thì nhân viên bấm sau khi đã nhận tiền
            PayCommand = new RelayCommand(_ => Pay(), _ => CanPay);
            ReloadCommand = new RelayCommand(_ => LoadShowtimes());
            LoadShowtimes();
        }

        private IEnumerable<SeatItem> AllSeats() => Rows.SelectMany(r => r.Seats).Where(s => !s.IsAisle);

        private DateTime lastAvailabilityCheck = DateTime.Now;

        internal void RefreshShowtimeAvailability()
        {
            DateTime now = DateTime.Now;
            foreach (var show in Movies.SelectMany(m => m.Showtimes))
            {
                if (show.GetStatusBadge(lastAvailabilityCheck) != show.GetStatusBadge(now))
                {
                    show.NotifyAvailabilityChanged();
                    if (show == CurrentShowtime)
                        OnPropertyChanged(nameof(CanPay));
                }
            }
            lastAvailabilityCheck = now;
        }

        private bool isSyncing;

        internal async Task SyncFromDatabaseAsync()
        {
            if (isSyncing) return;
            isSyncing = true;
            try
            {
                int currentShowId = CurrentShowtime.ShowtimeID;
                int currentRoomId = CurrentShowtime.RoomID;

                var (latestMovies, latestSeats, latestSoldIds) = await Task.Run(() =>
                {
                    var mList = bookingService.GetTodayShowtimes();
                    List<PhysicalSeat>? seats = null;
                    HashSet<int>? sold = null;
                    if (currentShowId > 0 && currentRoomId > 0)
                    {
                        seats = bookingService.GetSeats(currentRoomId);
                        sold = bookingService.GetSoldSeatIds(currentShowId);
                    }
                    return (mList, seats, sold);
                });

                // 1. Đồng bộ danh sách phim & suất chiếu hôm nay (số ghế trống, tên phòng...)
                var currentIds = Movies.SelectMany(m => m.Showtimes).Select(s => s.ShowtimeID).ToList();
                var latestFlat = latestMovies.SelectMany(m => m.Showtimes).ToList();
                var latestIds = latestFlat.Select(s => s.ShowtimeID).ToList();

                if (currentIds.SequenceEqual(latestIds))
                {
                    var lookup = latestFlat.ToDictionary(s => s.ShowtimeID);
                    foreach (var existing in Movies.SelectMany(m => m.Showtimes))
                    {
                        if (lookup.TryGetValue(existing.ShowtimeID, out var src))
                        {
                            existing.RoomName = src.RoomName;
                            existing.FreeSeats = src.FreeSeats;
                        }
                    }
                }
                else
                {
                    Movies.Clear();
                    foreach (var m in latestMovies) Movies.Add(m);
                    var restored = latestFlat.FirstOrDefault(s => s.ShowtimeID == currentShowId);
                    if (restored != null)
                    {
                        restored.IsCurrent = true;
                        var parent = Movies.FirstOrDefault(m => m.Showtimes.Contains(restored));
                        if (parent != null) parent.IsCurrent = true;
                        CurrentShowtime = restored;
                    }
                    OnPropertyChanged(nameof(ShowtimeCount));
                }

                // 2. Đồng bộ sơ đồ ghế (ghế đã bán / chưa bán & thay đổi cấu trúc phòng từ Admin)
                if (currentShowId > 0 && latestSeats != null && latestSoldIds != null)
                {
                    var currentSeatIds = AllSeats().SelectMany(s => s.SeatIDs).ToList();
                    var latestSeatIds = latestSeats.Select(s => s.ID).ToList();

                    if (!currentSeatIds.SequenceEqual(latestSeatIds))
                    {
                        // Cấu trúc ghế phòng chiếu vừa được Admin cập nhật -> dựng lại sơ đồ ghế
                        Rows.Clear();
                        var rebuilt = BookingService.BuildSeatRows(latestSeats, CurrentShowtime.BasePrice, latestSoldIds);
                        foreach (var row in rebuilt) Rows.Add(row);
                        TotalSeats = latestSeats.Count;
                        OnPropertyChanged(nameof(TotalSeats));

                        if (!IsPaidTicket && SelectedSeats.Count > 0)
                        {
                            foreach (var s in SelectedSeats) s.IsSelected = false;
                            SelectedSeats.Clear();
                            UpdateSummary();
                            ShowMessage("Sơ đồ ghế của phòng vừa được cập nhật, vui lòng chọn lại ghế.", true);
                        }
                    }
                    else
                    {
                        bool deselectedAny = false;
                        foreach (var seat in AllSeats())
                        {
                            bool soldNow = seat.SeatIDs.Any(latestSoldIds.Contains);
                            seat.IsSold = soldNow;
                            if (soldNow && seat.IsSelected && !IsPaidTicket)
                            {
                                seat.IsSelected = false;
                                SelectedSeats.Remove(seat);
                                deselectedAny = true;
                            }
                        }
                        if (deselectedAny)
                        {
                            UpdateSummary();
                            ShowMessage("Một số ghế bạn đang chọn vừa được bán ở nơi khác.", true);
                        }
                    }

                    CurrentShowtime.FreeSeats = AllSeats().Where(s => !s.IsSold).Sum(s => s.SeatIDs.Count);
                    OnPropertyChanged(nameof(CanPay));
                }
            }
            catch
            {
                // Bỏ qua lỗi thoáng qua khi đồng bộ nền
            }
            finally
            {
                isSyncing = false;
            }
        }

        private void LoadShowtimes()
        {
            ResetOrder();
            Rows.Clear();
            Movies.Clear();
            TotalSeats = 0;
            CurrentShowtime = new ShowtimeOption();
            try
            {
                foreach (var movie in bookingService.GetTodayShowtimes()) Movies.Add(movie);
                var first = Movies.SelectMany(m => m.Showtimes).FirstOrDefault(s => s.CanSell);
                if (first != null) SelectShowtime(first);
                else ShowMessage("Không có suất còn mở bán hôm nay. Kiểm tra lịch chiếu hoặc bấm Tải lại.", false);
            }
            catch (Exception ex)
            {
                ShowMessage("Không tải được suất chiếu từ SQL Server: " + ex.Message, true);
            }
            OnPropertyChanged(nameof(ShowtimeCount));
            OnPropertyChanged(nameof(TotalSeats));
        }

        private void LoadSeatMap()
        {
            Rows.Clear();
            var seats = bookingService.GetSeats(CurrentShowtime.RoomID);
            var sold = bookingService.GetSoldSeatIds(CurrentShowtime.ShowtimeID);
            var rows = BookingService.BuildSeatRows(seats, CurrentShowtime.BasePrice, sold);
            foreach (var row in rows) Rows.Add(row);
            TotalSeats = seats.Count;
            CurrentShowtime.FreeSeats = rows.SelectMany(r => r.Seats).Where(s => !s.IsAisle && !s.IsSold).Sum(s => s.SeatIDs.Count);
            OnPropertyChanged(nameof(TotalSeats));
        }

        // Đổi suất: bỏ đơn đang làm dở và tô lại ghế đã bán của suất mới.
        private void SelectShowtime(ShowtimeOption option)
        {
            if (option == CurrentShowtime) return;
            if (!option.CanSell)
            {
                ShowMessage("Suất đã bắt đầu hoặc hết vé. Hãy tải lại danh sách.", true);
                return;
            }
            foreach (MovieShowtimes movie in Movies)
            {
                foreach (ShowtimeOption show in movie.Showtimes) show.IsCurrent = show == option;
                movie.IsCurrent = movie.Showtimes.Contains(option);
            }
            CurrentShowtime = option;
            ResetOrder();
            OnPropertyChanged(nameof(StandardPrice));
            OnPropertyChanged(nameof(VipPrice));
            OnPropertyChanged(nameof(CouplePrice));
            try { LoadSeatMap(); }
            catch (Exception ex) { ShowMessage("Không tải được sơ đồ ghế: " + ex.Message, true); }
        }

        private void FindMember()
        {
            IsMemberFound = false;
            currentMember = null;
            string phone = MemberPhone.Trim();
            if (phone.Length is < 9 or > 15 || !phone.All(char.IsDigit))
            {
                MemberText = "Nhập số điện thoại hợp lệ (9–15 chữ số).";
                return;
            }
            try
            {
                currentMember = customerService.FindByPhone(phone);
                IsMemberFound = currentMember != null;
                MemberText = currentMember == null ? "Không tìm thấy thành viên, có thể bán như khách vãng lai."
                    : $"{currentMember.FullName} · {currentMember.Points} điểm";
            }
            catch (Exception ex) { MemberText = "Không tìm được khách từ SQL Server: " + ex.Message; }
        }

        private void Pay()
        {
            UpdateSummary();
            if (!CanPay) { ShowMessage("Kiểm tra suất chiếu, tiền thanh toán và số điểm sử dụng.", true); return; }
            if (AppSession.CurrentUser is not { IsAdmin: false } user)
            {
                ShowMessage("Cần đăng nhập tài khoản nhân viên để thanh toán.", true);
                return;
            }
            BookingResult result;
            try
            {
                var quotes = SelectedSeats.SelectMany(s => s.SeatIDs
                    .Select(id => new SeatQuote(id, s.Price / s.SeatIDs.Count))).ToArray();
                result = bookingService.CreateBooking(user.AccountID, CurrentShowtime.ShowtimeID,
                    IsMemberFound ? currentMember?.CustomerID : null, Method, Cash, PointsUsed, quotes);
            }
            catch (Exception ex)
            {
                foreach (var seat in SelectedSeats) seat.IsSelected = false;
                SelectedSeats.Clear();
                UpdateSummary();
                try { LoadSeatMap(); } catch { /* Giữ lỗi lưu đơn làm thông báo chính. */ }
                string status = ex is SqlException
                    ? "Chưa xác nhận được thanh toán. Hãy kiểm tra lịch sử giao dịch trước khi thử lại: "
                    : "Chưa thanh toán: ";
                ShowMessage(status + ex.Message, true);
                return;
            }

            ResetOrder();
            PreviewTicket = result.Ticket;
            string message = $"Đã lưu đơn {result.Sale.Code} vào SQL Server: {result.Sale.AmountText}.";
            try { LoadSeatMap(); }
            catch { message += " Chưa tải lại được ghế; bấm Tải lại khi kết nối ổn định."; }
            ShowMessage(message, false);
        }

        // Xóa đơn đang làm: bỏ chọn ghế, tiền khách đưa, khách thành viên, về lại tiền mặt.
        private void ResetOrder()
        {
            foreach (SeatItem s in SelectedSeats) s.IsSelected = false;
            SelectedSeats.Clear();
            RedeemPointsText = "0";
            CashText = "";
            MemberPhone = "";
            IsMemberFound = false;
            Method = PaymentMethod.Cash;
            Message = "";
            UpdateSummary();
        }

        private void UpdateSummary()
        {
            SelectedCount = SelectedSeats.Sum(s => s.SeatIDs.Count);
            Total = GrossTotal - DiscountAmount;
            OnPropertyChanged(nameof(MemberBalance));
            OnPropertyChanged(nameof(MaxRedeemPoints));
            OnPropertyChanged(nameof(RedemptionHint));
            OnPropertyChanged(nameof(IsRedemptionValid));

            UpdatePoints();
            UpdateChange();
            OnPropertyChanged(nameof(CanPay));
            PreviewTicket = SelectedCount > 0 ? CreateTicket() : null;
        }

        private void RefreshTicket()
        {
            if (SelectedCount > 0)
                PreviewTicket = CreateTicket();
        }

        private PrintableTicket CreateTicket(SaleRecord? sale = null)
        {
            string ageRating = Movies.FirstOrDefault(m => m.Showtimes.Contains(CurrentShowtime))?.AgeRating ?? "";
            string staffName = sale?.StaffName ?? AppSession.CurrentUser?.FullName ?? "Quản trị viên";
            return new PrintableTicket(CurrentShowtime, ageRating, staffName, Method, IsMemberFound, PointsUsed,
                SelectedSeats.Select(s => new TicketSeat(s.Label, s.Type, s.Price)).ToArray(), sale);
        }

        private void UpdatePoints()
        {
            PointsText = IsMemberFound
                ? $"+{TicketRewards.Calculate(SelectedSeats.Select(s => (s.Type, s.Price)), DiscountAmount)} điểm" : "—";
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

    }
}
