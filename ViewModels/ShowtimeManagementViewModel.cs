using System.Windows.Input;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using CinemaAPP.Services;
using Microsoft.Data.SqlClient;

namespace CinemaAPP.ViewModels
{
    // Một ngày trên dải chọn ngày / trong ô chọn ngày của form
    public record DayOption(DateTime Date, string Top, string Bottom, string CountText)
    {
        public override string ToString() => $"{Top}, {Bottom}";
    }

    // Một phim trong ô chọn phim của form
    public record MovieOption(Movie Movie)
    {
        public override string ToString() => $"{Movie.Title} · {Movie.DurationMin} phút";
    }

    // Một suất trong "Lịch phòng" của form, giúp chọn giờ trống
    public record RoomSlot(string TimeText, string Title, string Code, bool IsConflict);

    // Màn QUẢN LÝ SUẤT CHIẾU (chỉ Quản trị viên). Đọc / ghi bảng SHOWTIME qua ShowtimeService.
    // Quy tắc: không chồng giờ trong cùng phòng (tính cả 15 phút dọn phòng), không xếp vào giờ đã qua,
    // suất đã bán vé hoặc đã chiếu thì không sửa, không hủy.
    public class ShowtimeManagementViewModel : ObservableObject
    {
        private const string AllMovies = "Tất cả phim";
        private const string AllRooms = "Tất cả phòng";
        private const string AllStatus = "Tất cả trạng thái";
        private const int Clean = ShowtimeService.CleaningMinutes;

        private readonly ShowtimeService service = new();
        private readonly MovieService movieService = new();
        private List<Showtime> week = new();                                  // suất của 7 ngày đang xem
        private readonly Dictionary<DateTime, List<Showtime>> otherDays = new(); // ngày ngoài tuần, đọc khi form cần

        public ShowtimeManagementViewModel()
        {
            weekStart = DateTime.Today;
            selectedDate = DateTime.Today;

            PrevWeekCommand = new RelayCommand(_ => MoveWeek(-7));
            NextWeekCommand = new RelayCommand(_ => MoveWeek(7));
            TodayCommand = new RelayCommand(_ => { weekStart = DateTime.Today; selectedDate = DateTime.Today; LoadWeek(); });
            ReloadCommand = new RelayCommand(_ => { Message = ""; LoadWeek(); });
            ResetFiltersCommand = new RelayCommand(_ =>
            {
                searchText = ""; selectedMovieFilter = AllMovies; selectedRoomFilter = AllRooms; selectedStatusFilter = AllStatus;
                OnPropertyChanged(nameof(SearchText)); OnPropertyChanged(nameof(SelectedMovieFilter));
                OnPropertyChanged(nameof(SelectedRoomFilter)); OnPropertyChanged(nameof(SelectedStatusFilter));
                Refresh();
            });

            NewCommand = new RelayCommand(_ => OpenEditor(null));
            EditCommand = new RelayCommand(p => { if (p is ShowtimeRow r) OpenEditor(r); });
            SaveCommand = new RelayCommand(_ => Save(), _ => !IsLocked);
            CloseEditorCommand = new RelayCommand(_ => IsEditorOpen = false);
            UseSuggestCommand = new RelayCommand(_ => { if (suggestedTime is DateTime t) FormTime = t.ToString("HH:mm"); });

            AskDeleteCommand = new RelayCommand(p => { if (p is ShowtimeRow r) AskDelete(r); });
            ConfirmDeleteCommand = new RelayCommand(_ => ConfirmDelete());
            CloseDeleteCommand = new RelayCommand(_ => DeleteTarget = null);

            LoadWeek();
        }

        // ================= Dải ngày =================
        private DateTime weekStart;
        private DateTime selectedDate;
        public List<DayOption> Days { get; private set; } = new();

        private DayOption? selectedDay;
        public DayOption? SelectedDay
        {
            get => selectedDay;
            set
            {
                if (value == null) return;   // ListBox đặt null khi thay danh sách ngày
                if (SetProperty(ref selectedDay, value))
                {
                    selectedDate = value.Date;
                    Refresh();
                }
            }
        }

        public string WeekText => $"{weekStart:dd/MM} – {weekStart.AddDays(6):dd/MM/yyyy}";

        // ================= Bộ lọc =================
        private string searchText = "";
        public string SearchText
        {
            get => searchText;
            set { if (SetProperty(ref searchText, value)) Refresh(); }
        }

        public List<string> MovieFilterOptions { get; private set; } = new() { AllMovies };
        private string selectedMovieFilter = AllMovies;
        public string? SelectedMovieFilter
        {
            get => selectedMovieFilter;
            set { if (SetProperty(ref selectedMovieFilter, value ?? AllMovies)) Refresh(); }
        }

        public List<string> RoomFilterOptions { get; private set; } = new() { AllRooms };
        private string selectedRoomFilter = AllRooms;
        public string? SelectedRoomFilter
        {
            get => selectedRoomFilter;
            set { if (SetProperty(ref selectedRoomFilter, value ?? AllRooms)) Refresh(); }
        }

        public List<string> StatusFilterOptions { get; } = new List<string> { AllStatus }
            .Concat(Enum.GetValues<ShowStatus>().Select(ShowtimeRow.StatusName)).ToList();
        private string selectedStatusFilter = AllStatus;
        public string? SelectedStatusFilter
        {
            get => selectedStatusFilter;
            set { if (SetProperty(ref selectedStatusFilter, value ?? AllStatus)) Refresh(); }
        }

        // ================= Bảng + 4 ô số =================
        public List<ShowtimeRow> Showtimes { get; private set; } = new();
        public bool IsEmpty => Showtimes.Count == 0;
        public string EmptyText { get; private set; } = "";
        public string TableTitle { get; private set; } = "";

        public string ShowCountText { get; private set; } = "";
        public string ShowCountSub { get; private set; } = "";
        public string OnSaleText { get; private set; } = "";
        public string OnSaleSub { get; private set; } = "";
        public string SeatsSoldText { get; private set; } = "";
        public string SeatsSoldSub { get; private set; } = "";
        public string RevenueText { get; private set; } = "";

        // ================= Thông báo =================
        private string message = "";
        public string Message
        {
            get => message;
            set => SetProperty(ref message, value);
        }

        private bool isMessageError;
        public bool IsMessageError
        {
            get => isMessageError;
            set => SetProperty(ref isMessageError, value);
        }

        private void ShowMessage(string text, bool isError)
        {
            IsMessageError = isError;
            Message = text;
        }

        // ================= Lệnh =================
        public ICommand PrevWeekCommand { get; }
        public ICommand NextWeekCommand { get; }
        public ICommand TodayCommand { get; }
        public ICommand ReloadCommand { get; }
        public ICommand ResetFiltersCommand { get; }
        public ICommand NewCommand { get; }
        public ICommand EditCommand { get; }
        public ICommand SaveCommand { get; }
        public ICommand CloseEditorCommand { get; }
        public ICommand UseSuggestCommand { get; }
        public ICommand AskDeleteCommand { get; }
        public ICommand ConfirmDeleteCommand { get; }
        public ICommand CloseDeleteCommand { get; }

        // ================= Nạp dữ liệu =================
        private void MoveWeek(int days)
        {
            weekStart = weekStart.AddDays(days);
            selectedDate = weekStart;
            LoadWeek();
        }

        private void LoadWeek()
        {
            otherDays.Clear();
            try
            {
                week = service.GetRange(weekStart, weekStart.AddDays(7));
            }
            catch (Exception ex)
            {
                week = new List<Showtime>();
                ShowMessage("Không đọc được lịch chiếu từ CSDL: " + ex.Message, true);
            }

            Days = Enumerable.Range(0, 7).Select(i =>
            {
                DateTime d = weekStart.AddDays(i);
                int n = week.Count(s => s.StartTime.Date == d);
                return new DayOption(d, DayName(d), d.ToString("dd/MM"), $"{n} suất");
            }).ToList();
            OnPropertyChanged(nameof(Days));
            OnPropertyChanged(nameof(WeekText));

            // Ô lọc phim / phòng lấy theo cả tuần để không nhảy khi đổi ngày
            MovieFilterOptions = new List<string> { AllMovies }.Concat(week.Select(s => s.Title).Distinct().OrderBy(t => t)).ToList();
            RoomFilterOptions = new List<string> { AllRooms }.Concat(week.Select(s => s.RoomName).Distinct().OrderBy(t => t)).ToList();
            if (!MovieFilterOptions.Contains(selectedMovieFilter)) selectedMovieFilter = AllMovies;
            if (!RoomFilterOptions.Contains(selectedRoomFilter)) selectedRoomFilter = AllRooms;
            OnPropertyChanged(nameof(MovieFilterOptions)); OnPropertyChanged(nameof(SelectedMovieFilter));
            OnPropertyChanged(nameof(RoomFilterOptions)); OnPropertyChanged(nameof(SelectedRoomFilter));

            selectedDay = Days.FirstOrDefault(d => d.Date == selectedDate) ?? Days[0];
            selectedDate = selectedDay.Date;
            OnPropertyChanged(nameof(SelectedDay));
            Refresh();
        }

        private void Refresh()
        {
            DateTime now = DateTime.Now;
            List<ShowtimeRow> day = week.Where(s => s.StartTime.Date == selectedDate)
                                        .Select(s => new ShowtimeRow(s, now)).ToList();

            // 4 ô số: cả ngày, không theo bộ lọc
            int sold = day.Sum(r => r.Data.SoldSeats), total = day.Sum(r => r.Data.TotalSeats);
            var onSale = day.Where(r => r.Status is ShowStatus.OnSale or ShowStatus.SoldOut).ToList();
            ShowCountText = $"{day.Count} suất";
            ShowCountSub = $"{day.Select(r => r.Data.RoomID).Distinct().Count()} phòng chiếu";
            OnSaleText = $"{onSale.Count} suất";
            OnSaleSub = $"còn {Format.Number(onSale.Sum(r => Math.Max(0, r.Data.TotalSeats - r.Data.SoldSeats)))} ghế trống";
            SeatsSoldText = Format.Number(sold);
            SeatsSoldSub = total == 0 ? "/ 0 ghế" : $"/ {Format.Number(total)} ghế ({100.0 * sold / total:0}%)";
            RevenueText = Format.Money(day.Sum(r => r.Data.Revenue));

            string q = searchText.Trim();
            Showtimes = day.Where(r =>
                    (q == "" || r.Code.Contains(q, StringComparison.OrdinalIgnoreCase) || r.Title.Contains(q, StringComparison.OrdinalIgnoreCase))
                    && (selectedMovieFilter == AllMovies || r.Title == selectedMovieFilter)
                    && (selectedRoomFilter == AllRooms || r.RoomName == selectedRoomFilter)
                    && (selectedStatusFilter == AllStatus || r.StatusText == selectedStatusFilter))
                .ToList();

            TableTitle = $"Lịch chiếu {DayName(selectedDate).ToLower(Format.Vi)} {selectedDate:dd/MM/yyyy} · {Showtimes.Count}/{day.Count} suất";
            EmptyText = day.Count == 0
                ? "Ngày này chưa có suất chiếu. Bấm \"Thêm suất chiếu\" để xếp lịch."
                : "Không có suất nào khớp bộ lọc.";

            foreach (string name in new[] { nameof(Showtimes), nameof(IsEmpty), nameof(EmptyText), nameof(TableTitle),
                         nameof(ShowCountText), nameof(ShowCountSub), nameof(OnSaleText), nameof(OnSaleSub),
                         nameof(SeatsSoldText), nameof(SeatsSoldSub), nameof(RevenueText) })
                OnPropertyChanged(name);
        }

        private static string DayName(DateTime d)
        {
            if (d == DateTime.Today) return "Hôm nay";
            if (d == DateTime.Today.AddDays(1)) return "Ngày mai";
            string name = Format.Vi.DateTimeFormat.GetDayName(d.DayOfWeek);
            return char.ToUpper(name[0]) + name[1..];
        }

        // Suất của một ngày (đã nạp trong tuần, hoặc đọc riêng cho form)
        private List<Showtime> GetDay(DateTime date)
        {
            if (date >= weekStart && date < weekStart.AddDays(7))
                return week.Where(s => s.StartTime.Date == date).ToList();
            if (!otherDays.TryGetValue(date, out var list))
            {
                try { list = service.GetRange(date, date.AddDays(1)); }
                catch { list = new List<Showtime>(); }
                otherDays[date] = list;
            }
            return list;
        }

        // ================= Form thêm / sửa =================
        private int editingId;

        private bool isEditorOpen;
        public bool IsEditorOpen
        {
            get => isEditorOpen;
            set => SetProperty(ref isEditorOpen, value);
        }

        public string EditorTitle { get; private set; } = "";
        public string EditorSubtitle { get; private set; } = "";
        public bool IsLocked { get; private set; }
        public string LockText { get; private set; } = "";

        public List<MovieOption> MovieOptions { get; private set; } = new();
        public List<RoomOption> RoomOptions { get; private set; } = new();
        public List<DayOption> DateOptions { get; private set; } = new();
        public List<string> FormatOptions { get; } = new() { "2D", "3D", "IMAX" };
        public List<string> AudioOptions { get; } = new() { "Phụ đề", "Lồng tiếng" };

        private MovieOption? formMovie;
        public MovieOption? FormMovie
        {
            get => formMovie;
            set { if (SetProperty(ref formMovie, value)) UpdatePreview(); }
        }

        private RoomOption? formRoom;
        public RoomOption? FormRoom
        {
            get => formRoom;
            set { if (SetProperty(ref formRoom, value)) UpdatePreview(); }
        }

        private DayOption? formDate;
        public DayOption? FormDate
        {
            get => formDate;
            set { if (SetProperty(ref formDate, value)) UpdatePreview(); }
        }

        private string formTime = "";
        public string FormTime
        {
            get => formTime;
            set { if (SetProperty(ref formTime, value)) UpdatePreview(); }
        }

        private string formFormat = "2D";
        public string FormFormat
        {
            get => formFormat;
            set => SetProperty(ref formFormat, value);
        }

        private string formAudio = "Phụ đề";
        public string FormAudio
        {
            get => formAudio;
            set => SetProperty(ref formAudio, value);
        }

        private string formPrice = "";
        public string FormPrice
        {
            get => formPrice;
            set => SetProperty(ref formPrice, value);
        }

        private string formError = "";
        public string FormError
        {
            get => formError;
            set => SetProperty(ref formError, value);
        }

        // Xem trước: giờ kết thúc, lịch phòng trong ngày, giờ trống gợi ý
        public string EndPreviewText { get; private set; } = "";
        public string RoomDayTitle { get; private set; } = "";
        public List<RoomSlot> RoomSlots { get; private set; } = new();
        public bool HasNoRoomSlots => RoomSlots.Count == 0;
        public string SuggestText { get; private set; } = "";
        private DateTime? suggestedTime;
        public bool HasSuggestTime => suggestedTime != null;

        private void OpenEditor(ShowtimeRow? row)
        {
            Message = "";
            List<Movie> movies;
            try
            {
                movies = movieService.GetAll();
                RoomOptions = service.GetRooms();
            }
            catch (Exception ex)
            {
                ShowMessage("Không đọc được danh sách phim / phòng: " + ex.Message, true);
                return;
            }

            Showtime? s = row?.Data;
            editingId = s?.ShowtimeID ?? 0;

            // Phim ngừng chiếu hoặc chưa có thời lượng thì không xếp suất mới (vẫn giữ phim của suất đang sửa)
            MovieOptions = movies.Where(m => (m.DurationMin > 0 && m.MovieStatus != "Ngừng chiếu") || m.MovieID == s?.MovieID)
                                 .OrderBy(m => m.Title).Select(m => new MovieOption(m)).ToList();

            DateOptions = Enumerable.Range(0, 14).Select(i => DateTime.Today.AddDays(i))
                                    .Select(d => new DayOption(d, DayName(d), d.ToString("dd/MM/yyyy"), "")).ToList();
            if (s != null && s.StartTime.Date < DateTime.Today)
                DateOptions.Insert(0, new DayOption(s.StartTime.Date, DayName(s.StartTime.Date), s.StartTime.ToString("dd/MM/yyyy"), ""));

            // Đổi danh sách TRƯỚC: ComboBox xóa lựa chọn cũ (đẩy null về ViewModel) khi danh sách đổi, sau đó mới gán giá trị form
            OnPropertyChanged(nameof(MovieOptions));
            OnPropertyChanged(nameof(RoomOptions));
            OnPropertyChanged(nameof(DateOptions));

            if (s == null)
            {
                IsLocked = false;
                LockText = "";
                EditorTitle = "Thêm suất chiếu mới";
                EditorSubtitle = $"Hệ thống tự cộng {Clean} phút dọn phòng và chặn suất chồng giờ trong cùng phòng.";
                formMovie = null;
                formRoom = RoomOptions.FirstOrDefault(r => r.RoomName == selectedRoomFilter);
                formDate = DateOptions.FirstOrDefault(d => d.Date == selectedDate) ?? DateOptions[0];
                formTime = "";
                FormFormat = "2D";
                FormAudio = "Phụ đề";
                FormPrice = "75.000";
            }
            else
            {
                IsLocked = row!.IsStarted || s.SoldSeats > 0;
                LockText = row.IsStarted
                    ? "Suất đã bắt đầu chiếu nên chỉ xem được, không sửa."
                    : $"Suất đã bán {s.SoldSeats} vé: không đổi phim, phòng, giờ hay giá vé nữa để không ảnh hưởng khách đã mua.";
                EditorTitle = IsLocked ? $"Chi tiết suất {row.Code}" : $"Sửa suất {row.Code}";
                EditorSubtitle = $"{row.StatusText} · {row.SeatsText} · doanh thu {row.RevenueText}";
                formMovie = MovieOptions.FirstOrDefault(m => m.Movie.MovieID == s.MovieID);
                formRoom = RoomOptions.FirstOrDefault(r => r.RoomID == s.RoomID);
                formDate = DateOptions.FirstOrDefault(d => d.Date == s.StartTime.Date);
                formTime = s.StartTime.ToString("HH:mm");
                FormFormat = s.ShowFormat;
                FormAudio = s.AudioType;
                FormPrice = s.BasePrice.ToString("N0", Format.Vi);
            }

            foreach (string name in new[] { nameof(IsLocked), nameof(LockText), nameof(EditorTitle), nameof(EditorSubtitle),
                         nameof(FormMovie), nameof(FormRoom), nameof(FormDate), nameof(FormTime) })
                OnPropertyChanged(name);

            UpdatePreview();
            if (MovieOptions.Count == 0) FormError = "Chưa có phim nào xếp suất được. Thêm phim (có thời lượng) ở mục Phim trước.";
            else if (RoomOptions.Count == 0) FormError = "Chưa có phòng chiếu. Thêm phòng ở mục Phòng chiếu trước.";
            IsEditorOpen = true;
        }

        private void UpdatePreview()
        {
            FormError = "";
            Movie? movie = formMovie?.Movie;
            int dur = movie?.DurationMin ?? 0;
            DateTime? start = formDate != null && ParseTime(formTime) is TimeSpan t ? formDate.Date + t : null;

            List<Showtime> roomDay = formRoom == null || formDate == null
                ? new List<Showtime>()
                : GetDay(formDate.Date).Where(s => s.RoomID == formRoom.RoomID && s.ShowtimeID != editingId)
                                       .OrderBy(s => s.StartTime).ToList();
            Showtime? conflict = start is DateTime st && dur > 0 ? roomDay.FirstOrDefault(s => Overlaps(s, st, dur)) : null;

            RoomDayTitle = formRoom == null || formDate == null
                ? "Lịch phòng trong ngày"
                : $"Lịch {formRoom.RoomName} · {formDate.Top.ToLower(Format.Vi)} {formDate.Date:dd/MM}";
            RoomSlots = roomDay.Select(s => new RoomSlot(
                $"{s.StartTime:HH:mm} – {s.EndTime.AddMinutes(Clean):HH:mm}", s.Title, ShowtimeRow.CodeOf(s.ShowtimeID), s == conflict)).ToList();

            EndPreviewText = start is DateTime b && dur > 0
                ? $"Hết phim lúc {b.AddMinutes(dur):HH:mm} · phòng trống lúc {b.AddMinutes(dur + Clean):HH:mm}"
                : "Chọn phim và nhập giờ bắt đầu để tính giờ kết thúc.";

            suggestedTime = conflict != null ? FindFreeStart(roomDay, start!.Value, dur) : null;
            SuggestText = conflict == null ? ""
                : $"Trùng suất {ShowtimeRow.CodeOf(conflict.ShowtimeID)} ({conflict.StartTime:HH:mm} – {conflict.EndTime.AddMinutes(Clean):HH:mm})."
                  + (suggestedTime is DateTime g ? $" Giờ trống gần nhất: {g:HH:mm}." : " Phòng không còn chỗ trong ngày này.");

            foreach (string name in new[] { nameof(RoomDayTitle), nameof(RoomSlots), nameof(HasNoRoomSlots),
                         nameof(EndPreviewText), nameof(SuggestText), nameof(HasSuggestTime) })
                OnPropertyChanged(name);
        }

        private void Save()
        {
            if (IsLocked) return;
            Movie? movie = formMovie?.Movie;
            if (movie == null) { FormError = "Chọn phim cho suất chiếu."; return; }
            if (movie.DurationMin <= 0) { FormError = "Phim chưa có thời lượng, cập nhật ở mục Phim trước."; return; }
            if (editingId == 0 && movie.MovieStatus == "Ngừng chiếu") { FormError = "Phim đã ngừng chiếu, không xếp thêm suất."; return; }
            if (formRoom == null) { FormError = "Chọn phòng chiếu."; return; }
            if (formDate == null) { FormError = "Chọn ngày chiếu."; return; }
            if (ParseTime(formTime) is not TimeSpan time) { FormError = "Giờ bắt đầu nhập dạng HH:mm, ví dụ 19:30."; return; }

            DateTime start = formDate.Date + time;
            if (start <= DateTime.Now) { FormError = "Giờ bắt đầu đã qua, chọn giờ muộn hơn."; return; }

            decimal price = ParseMoney(formPrice);
            if (price <= 0) { FormError = "Giá vé cơ bản phải lớn hơn 0."; return; }
            if (price > 1_000_000) { FormError = "Giá vé cơ bản quá lớn, kiểm tra lại (tối đa 1.000.000 đ)."; return; }
            if (formFormat == "IMAX" && !formRoom.IsImax) { FormError = "Định dạng IMAX chỉ chiếu được ở phòng IMAX."; return; }

            try
            {
                Showtime? clash = service.FindOverlap(formRoom.RoomID, start, movie.DurationMin, editingId);
                if (clash != null)
                {
                    var slots = GetDay(start.Date).Where(s => s.RoomID == formRoom.RoomID && s.ShowtimeID != editingId).Append(clash).ToList();
                    DateTime? free = FindFreeStart(slots, start, movie.DurationMin);
                    FormError = $"{formRoom.RoomName} đã có suất {ShowtimeRow.CodeOf(clash.ShowtimeID)} · {clash.Title} "
                              + $"{clash.StartTime:HH:mm} – {clash.EndTime.AddMinutes(Clean):HH:mm} (đã gồm dọn phòng)."
                              + (free is DateTime f ? $" Giờ trống gần nhất: {f:HH:mm}." : "");
                    return;
                }

                if (editingId != 0)
                {
                    int sold = service.CountSoldSeats(editingId);
                    if (sold > 0) { FormError = $"Suất vừa có {sold} vé được bán nên không sửa được nữa."; return; }
                }

                var show = new Showtime
                {
                    ShowtimeID = editingId, MovieID = movie.MovieID, RoomID = formRoom.RoomID, StartTime = start,
                    ShowFormat = formFormat, AudioType = formAudio, BasePrice = price,
                };
                bool isNew = editingId == 0;
                if (isNew) service.Add(show); else service.Update(show);

                IsEditorOpen = false;
                if (start.Date < weekStart || start.Date >= weekStart.AddDays(7)) weekStart = start.Date;
                selectedDate = start.Date;
                LoadWeek();
                ShowMessage($"Đã {(isNew ? "thêm" : "cập nhật")} suất {ShowtimeRow.CodeOf(show.ShowtimeID)}: {movie.Title}, "
                          + $"{formRoom.RoomName}, {start:HH:mm} ngày {start:dd/MM/yyyy}.", false);
            }
            catch (Exception ex)
            {
                FormError = "Lỗi CSDL: " + ex.Message;
            }
        }

        // ================= Hủy suất =================
        private ShowtimeRow? deleteTarget;
        public ShowtimeRow? DeleteTarget
        {
            get => deleteTarget;
            set
            {
                if (SetProperty(ref deleteTarget, value)) OnPropertyChanged(nameof(IsDeleteOpen));
            }
        }
        public bool IsDeleteOpen => deleteTarget != null;

        private void AskDelete(ShowtimeRow row)
        {
            Message = "";
            if (row.IsStarted)
            {
                ShowMessage($"Suất {row.Code} đã chiếu nên không hủy được (giữ lại để đối soát).", true);
                return;
            }
            int sold;
            try { sold = service.CountSoldSeats(row.Data.ShowtimeID); }
            catch (Exception ex) { ShowMessage("Lỗi CSDL: " + ex.Message, true); return; }
            if (sold > 0)
            {
                ShowMessage($"Suất {row.Code} đã bán {sold} vé nên không hủy được. Cần hoàn vé cho khách trước khi hủy suất.", true);
                return;
            }
            DeleteTarget = row;
        }

        private void ConfirmDelete()
        {
            if (deleteTarget is not ShowtimeRow row) return;
            DeleteTarget = null;
            try
            {
                service.Delete(row.Data.ShowtimeID);
                LoadWeek();
                ShowMessage($"Đã hủy suất {row.Code}: {row.Title}, {row.RoomName}, {row.StartText} ngày {row.Data.StartTime:dd/MM/yyyy}.", false);
            }
            catch (SqlException ex) when (ex.Number == 547)
            {
                ShowMessage($"Suất {row.Code} vừa có vé được bán nên không hủy được.", true);
            }
            catch (Exception ex)
            {
                ShowMessage("Lỗi CSDL: " + ex.Message, true);
            }
        }

        // ================= Tiện ích =================
        // Hai suất cùng phòng chồng giờ: mỗi suất chiếm phòng từ lúc bắt đầu tới hết phim + dọn phòng
        private static bool Overlaps(Showtime s, DateTime start, int durationMin) =>
            start < s.EndTime.AddMinutes(Clean) && s.StartTime < start.AddMinutes(durationMin + Clean);

        // Giờ bắt đầu sớm nhất (từ "from", làm tròn 5 phút) không chồng suất nào, trong cùng ngày
        private static DateTime? FindFreeStart(List<Showtime> slots, DateTime from, int durationMin)
        {
            DateTime earliest = DateTime.Now.AddMinutes(5);
            DateTime t = RoundUp5(from < earliest ? earliest : from);
            for (int i = 0; i <= slots.Count; i++)
            {
                Showtime? c = slots.FirstOrDefault(s => Overlaps(s, t, durationMin));
                if (c == null) return t.Date == from.Date ? t : null;
                t = RoundUp5(c.EndTime.AddMinutes(Clean));
            }
            return null;
        }

        private static DateTime RoundUp5(DateTime t)
        {
            var step = TimeSpan.FromMinutes(5).Ticks;
            long ticks = (t.Ticks + step - 1) / step * step;
            return new DateTime(ticks);
        }

        // Nhận "19:30", "9:05", "1930", "19.30"
        private static TimeSpan? ParseTime(string text)
        {
            string s = text.Trim().Replace('.', ':').Replace('h', ':');
            if (s.Length == 4 && s.All(char.IsDigit)) s = s[..2] + ":" + s[2..];
            string[] parts = s.Split(':');
            if (parts.Length == 2 && int.TryParse(parts[0], out int h) && int.TryParse(parts[1], out int m)
                && parts[1].Length == 2 && h is >= 0 and < 24 && m is >= 0 and < 60)
                return new TimeSpan(h, m, 0);
            return null;
        }

        private static decimal ParseMoney(string text)
        {
            string digits = new string(text.Where(char.IsDigit).ToArray());
            return digits.Length is > 0 and < 10 ? decimal.Parse(digits) : 0;
        }
    }
}
