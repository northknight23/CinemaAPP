using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using CinemaAPP.Services;

namespace CinemaAPP.ViewModels
{
    public class RoomManagementViewModel : ObservableObject
    {
        private readonly RoomService _roomService = new();
        private readonly BookingService _bookingService = new();
        private List<Room> _allRooms = new();
        private bool _isRefreshing;
        private bool _isBusy;
        private bool _suppressShowtimeReload;

        private string _searchText = "";
        private string _filterType = "All";

        // KPI
        private int _totalRoomsCount;
        private int _totalSeatsCount;
        private int _activeRoomsCount;
        private int _readyRoomsCount;
        private int _totalTodaySoldCount;

        // Banner thông báo toàn trang
        private string _bannerMessage = "";
        private bool _isMessageError;

        // Modal Form Thêm / Sửa
        private bool _isEditorOpen;
        private string _editorTitle = "Thêm phòng chiếu mới";
        private int _editingRoomId;
        private string _formRoomName = "";
        private string _formRoomType = "2D";
        private string _formNumRowsText = "9";
        private string _formSeatsPerRowText = "12";

        private bool _hasNameError;
        private string _nameError = "";
        private bool _hasDimensionError;
        private string _dimensionError = "";
        private string _editorError = "";

        // Modal xác nhận xóa phòng
        private bool _isDeleteConfirmOpen;
        private Room? _roomToDelete;

        // Modal Sơ đồ ghế
        private bool _isSeatMapOpen;
        private Room? _selectedRoom;
        private string _seatMapSummary = "";
        private RoomShowtimeInfo? _selectedRoomShowtime;
        private ObservableCollection<SeatRowItem> _seatMapRows = new();

        public ObservableCollection<Room> FilteredRooms { get; } = new();
        public ObservableCollection<RoomShowtimeInfo> RoomShowtimes { get; } = new();

        public List<string> RoomTypeOptions { get; } = new()
        {
            "2D",
            "3D",
            "IMAX"
        };

        // ================= TÌM KIẾM & BỘ LỌC =================
        public string SearchText
        {
            get => _searchText;
            set
            {
                if (SetProperty(ref _searchText, value))
                    ApplyFilter();
            }
        }

        public string FilterType
        {
            get => _filterType;
            set
            {
                if (SetProperty(ref _filterType, value))
                {
                    OnPropertyChanged(nameof(IsFilterAll));
                    OnPropertyChanged(nameof(IsFilter2D));
                    OnPropertyChanged(nameof(IsFilter3D));
                    OnPropertyChanged(nameof(IsFilterIMAX));
                    ApplyFilter();
                }
            }
        }

        public bool IsFilterAll => FilterType == "All";
        public bool IsFilter2D => FilterType == "2D";
        public bool IsFilter3D => FilterType == "3D";
        public bool IsFilterIMAX => FilterType == "IMAX";

        public string CountAllText => $"Tất cả ({_allRooms.Count})";
        public string Count2DText => $"2D ({_allRooms.Count(r => (r.RoomType ?? "").ToUpper().Contains("2D"))})";
        public string Count3DText => $"3D ({_allRooms.Count(r => (r.RoomType ?? "").ToUpper().Contains("3D"))})";
        public string CountIMAXText => $"IMAX ({_allRooms.Count(r => (r.RoomType ?? "").ToUpper().Contains("IMAX"))})";

        // ================= KPI CHỈ SỐ =================
        public int TotalRoomsCount
        {
            get => _totalRoomsCount;
            set => SetProperty(ref _totalRoomsCount, value);
        }

        public int TotalSeatsCount
        {
            get => _totalSeatsCount;
            set => SetProperty(ref _totalSeatsCount, value);
        }

        public int ActiveRoomsCount
        {
            get => _activeRoomsCount;
            set => SetProperty(ref _activeRoomsCount, value);
        }

        public int ReadyRoomsCount
        {
            get => _readyRoomsCount;
            set => SetProperty(ref _readyRoomsCount, value);
        }

        public int TotalTodaySoldCount
        {
            get => _totalTodaySoldCount;
            set => SetProperty(ref _totalTodaySoldCount, value);
        }

        // ================= BANNER THÔNG BÁO =================
        public string BannerMessage
        {
            get => _bannerMessage;
            set
            {
                if (SetProperty(ref _bannerMessage, value))
                    OnPropertyChanged(nameof(ShowBanner));
            }
        }
        public bool ShowBanner => !string.IsNullOrEmpty(BannerMessage);

        public bool IsMessageError
        {
            get => _isMessageError;
            set => SetProperty(ref _isMessageError, value);
        }

        // ================= BIỂU MẪU THÊM / SỬA =================
        public bool IsEditorOpen
        {
            get => _isEditorOpen;
            set => SetProperty(ref _isEditorOpen, value);
        }

        public string EditorTitle
        {
            get => _editorTitle;
            set => SetProperty(ref _editorTitle, value);
        }

        public string FormRoomName
        {
            get => _formRoomName;
            set
            {
                if (SetProperty(ref _formRoomName, value))
                {
                    HasNameError = false;
                    NameError = "";
                }
            }
        }

        public string FormRoomType
        {
            get => _formRoomType;
            set
            {
                if (SetProperty(ref _formRoomType, value))
                    OnPropertyChanged(nameof(FormSeatPreview));
            }
        }

        public string FormNumRowsText
        {
            get => _formNumRowsText;
            set
            {
                if (SetProperty(ref _formNumRowsText, value))
                {
                    HasDimensionError = false;
                    DimensionError = "";
                    OnPropertyChanged(nameof(FormSeatPreview));
                }
            }
        }

        public string FormSeatsPerRowText
        {
            get => _formSeatsPerRowText;
            set
            {
                if (SetProperty(ref _formSeatsPerRowText, value))
                {
                    HasDimensionError = false;
                    DimensionError = "";
                    OnPropertyChanged(nameof(FormSeatPreview));
                }
            }
        }

        public string FormSeatPreview
        {
            get
            {
                if (!int.TryParse(FormNumRowsText?.Trim(), out int numRows) ||
                    !int.TryParse(FormSeatsPerRowText?.Trim(), out int seatsPerRow) ||
                    numRows < 1 || numRows > 25 || seatsPerRow < 1 || seatsPerRow > 50)
                {
                    return "Nhập số hàng (1 - 25) và số ghế/hàng (1 - 50)";
                }

                int std = 0, vip = 0, couple = 0;
                for (int r = 0; r < numRows; r++)
                {
                    string type = RoomService.GetDefaultSeatType(FormRoomType, r, numRows, seatsPerRow);
                    if (type == "Standard") std += seatsPerRow;
                    else if (type == "Vip") vip += seatsPerRow;
                    else couple += seatsPerRow;
                }

                string maxRow = RoomService.GetRowLabel(numRows - 1);
                int total = numRows * seatsPerRow;
                string coupleNote = couple > 0 ? $" · {couple / 2} cặp Đôi" : "";
                return $"{total} ghế (A - {maxRow}, {seatsPerRow} ghế/hàng): {std} Thường · {vip} VIP{coupleNote}";
            }
        }

        public bool HasNameError
        {
            get => _hasNameError;
            set => SetProperty(ref _hasNameError, value);
        }

        public string NameError
        {
            get => _nameError;
            set => SetProperty(ref _nameError, value);
        }

        public bool HasDimensionError
        {
            get => _hasDimensionError;
            set => SetProperty(ref _hasDimensionError, value);
        }

        public string DimensionError
        {
            get => _dimensionError;
            set => SetProperty(ref _dimensionError, value);
        }

        public string EditorError
        {
            get => _editorError;
            set
            {
                if (SetProperty(ref _editorError, value))
                    OnPropertyChanged(nameof(HasEditorError));
            }
        }
        public bool HasEditorError => !string.IsNullOrEmpty(EditorError);

        // ================= XÁC NHẬN XÓA PHÒNG =================
        public bool IsDeleteConfirmOpen
        {
            get => _isDeleteConfirmOpen;
            set => SetProperty(ref _isDeleteConfirmOpen, value);
        }

        public Room? RoomToDelete
        {
            get => _roomToDelete;
            set => SetProperty(ref _roomToDelete, value);
        }

        // ================= MODAL SƠ ĐỒ GHẾ =================
        public bool IsSeatMapOpen
        {
            get => _isSeatMapOpen;
            set => SetProperty(ref _isSeatMapOpen, value);
        }

        public Room? SelectedRoom
        {
            get => _selectedRoom;
            set
            {
                if (SetProperty(ref _selectedRoom, value))
                    OnPropertyChanged(nameof(SeatMapTitle));
            }
        }

        public string SeatMapTitle => SelectedRoom != null
            ? $"Sơ đồ ghế - {SelectedRoom.RoomName} ({SelectedRoom.RoomType})"
            : "Sơ đồ ghế";

        public string SeatMapSummary
        {
            get => _seatMapSummary;
            set => SetProperty(ref _seatMapSummary, value);
        }

        public bool HasRoomShowtimes => RoomShowtimes.Count > 0;
        public bool NoRoomShowtimes => RoomShowtimes.Count == 0;

        public RoomShowtimeInfo? SelectedRoomShowtime
        {
            get => _selectedRoomShowtime;
            set
            {
                if (SetProperty(ref _selectedRoomShowtime, value) && !_suppressShowtimeReload && SelectedRoom != null)
                {
                    _ = LoadSeatMapForRoomAsync(SelectedRoom, value?.ShowtimeID);
                }
            }
        }

        public ObservableCollection<SeatRowItem> SeatMapRows
        {
            get => _seatMapRows;
            set => SetProperty(ref _seatMapRows, value);
        }

        // ================= CÁC LỆNH (COMMANDS) =================
        public ICommand SetFilterCommand { get; }
        public ICommand NewRoomCommand { get; }
        public ICommand EditRoomCommand { get; }
        public ICommand DeleteRoomCommand { get; }
        public ICommand ConfirmDeleteCommand { get; }
        public ICommand CancelDeleteCommand { get; }
        public ICommand SaveRoomCommand { get; }
        public ICommand CancelCommand { get; }
        public ICommand ViewSeatMapCommand { get; }
        public ICommand CloseSeatMapCommand { get; }
        public ICommand ReloadCommand { get; }
        public ICommand DismissBannerCommand { get; }

        public RoomManagementViewModel()
        {
            SetFilterCommand = new RelayCommand(p =>
            {
                if (p is string type)
                    FilterType = type;
            });

            NewRoomCommand = new RelayCommand(_ =>
            {
                _editingRoomId = 0;
                EditorTitle = "Thêm phòng chiếu mới";
                FormRoomName = "";
                FormRoomType = "2D";
                FormNumRowsText = "9";
                FormSeatsPerRowText = "12";
                ClearEditorErrors();
                IsEditorOpen = true;
            });

            EditRoomCommand = new RelayCommand(p =>
            {
                if (p is Room room)
                {
                    _editingRoomId = room.RoomID;
                    EditorTitle = $"Chỉnh sửa - {room.RoomName}";
                    FormRoomName = room.RoomName;
                    FormRoomType = RoomTypeOptions.Contains(room.RoomType) ? room.RoomType : "2D";
                    FormNumRowsText = room.NumRows.ToString();
                    FormSeatsPerRowText = room.SeatsPerRow.ToString();
                    ClearEditorErrors();
                    IsEditorOpen = true;
                }
            });

            DeleteRoomCommand = new RelayCommand(p =>
            {
                if (p is Room room)
                {
                    RoomToDelete = room;
                    IsDeleteConfirmOpen = true;
                }
            });

            ConfirmDeleteCommand = new RelayCommand(async _ => await ConfirmDeleteAsync());
            CancelDeleteCommand = new RelayCommand(_ =>
            {
                IsDeleteConfirmOpen = false;
                RoomToDelete = null;
            });

            SaveRoomCommand = new RelayCommand(async _ => await SaveRoomAsync());
            CancelCommand = new RelayCommand(_ =>
            {
                IsEditorOpen = false;
                ClearEditorErrors();
            });

            ViewSeatMapCommand = new RelayCommand(async p =>
            {
                if (p is Room room)
                    await OpenSeatMapModalAsync(room);
            });

            CloseSeatMapCommand = new RelayCommand(_ => IsSeatMapOpen = false);
            ReloadCommand = new RelayCommand(async _ => await LoadRoomsAsync());
            DismissBannerCommand = new RelayCommand(_ => BannerMessage = "");

            _ = LoadRoomsAsync();
        }

        private async Task LoadRoomsAsync()
        {
            try
            {
                var loaded = await Task.Run(() => _roomService.GetAll());
                ApplyLatestRooms(loaded);
                if (IsMessageError)
                    BannerMessage = "";
            }
            catch (Exception ex)
            {
                _allRooms = new List<Room>();
                UpdateKpis();
                ApplyFilter();
                ShowBannerMessage("Không tải được danh sách phòng chiếu từ SQL Server: " + ex.Message, isError: true);
            }
        }

        private async Task SaveRoomAsync()
        {
            if (_isBusy) return;
            if (!ValidateForm(out int numRows, out int seatsPerRow)) return;

            var roomToSave = new Room
            {
                RoomID = _editingRoomId,
                RoomName = FormRoomName.Trim(),
                RoomType = FormRoomType,
                NumRows = numRows,
                SeatsPerRow = seatsPerRow
            };

            _isBusy = true;
            try
            {
                await Task.Run(() => _roomService.Save(roomToSave));
                IsEditorOpen = false;
                await LoadRoomsAsync();
                ShowBannerMessage(
                    _editingRoomId == 0
                        ? $"Đã thêm phòng chiếu \"{roomToSave.RoomName}\"."
                        : $"Đã cập nhật phòng chiếu \"{roomToSave.RoomName}\".",
                    isError: false);
            }
            catch (Exception ex)
            {
                EditorError = ex.Message;
            }
            finally
            {
                _isBusy = false;
            }
        }

        private async Task ConfirmDeleteAsync()
        {
            if (_isBusy || RoomToDelete == null) return;
            var target = RoomToDelete;

            _isBusy = true;
            try
            {
                await Task.Run(() => _roomService.Delete(target.RoomID));
                IsDeleteConfirmOpen = false;
                RoomToDelete = null;
                await LoadRoomsAsync();
                ShowBannerMessage($"Đã xóa phòng chiếu \"{target.RoomName}\".", isError: false);
            }
            catch (Exception ex)
            {
                IsDeleteConfirmOpen = false;
                RoomToDelete = null;
                ShowBannerMessage(ex.Message, isError: true);
            }
            finally
            {
                _isBusy = false;
            }
        }

        private async Task OpenSeatMapModalAsync(Room room)
        {
            try
            {
                SelectedRoom = room;
                var showtimes = await Task.Run(() => _roomService.GetTodayShowtimes(room.RoomID));

                _suppressShowtimeReload = true;
                RoomShowtimes.Clear();
                foreach (var st in showtimes) RoomShowtimes.Add(st);
                OnPropertyChanged(nameof(HasRoomShowtimes));
                OnPropertyChanged(nameof(NoRoomShowtimes));

                var defaultShow = showtimes.FirstOrDefault(s => s.ShowtimeID == room.ActiveShowtimeID)
                    ?? showtimes.FirstOrDefault(s => s.StatusTag == "Đang chiếu")
                    ?? showtimes.FirstOrDefault(s => s.StatusTag == "Sắp chiếu")
                    ?? showtimes.LastOrDefault();

                SelectedRoomShowtime = defaultShow;
                _suppressShowtimeReload = false;

                await LoadSeatMapForRoomAsync(room, defaultShow?.ShowtimeID);
                IsSeatMapOpen = true;
            }
            catch (Exception ex)
            {
                _suppressShowtimeReload = false;
                ShowBannerMessage("Không tải được sơ đồ ghế từ SQL Server: " + ex.Message, isError: true);
            }
        }

        private async Task LoadSeatMapForRoomAsync(Room room, int? showtimeId)
        {
            try
            {
                var rows = await Task.Run(() => _roomService.GetSeatMap(room.RoomID, showtimeId));
                SeatMapRows = new ObservableCollection<SeatRowItem>(rows);
                UpdateSeatMapSummary(rows, showtimeId.HasValue);
            }
            catch (Exception ex)
            {
                ShowBannerMessage("Không tải được sơ đồ ghế: " + ex.Message, isError: true);
            }
        }

        private void UpdateSeatMapSummary(IEnumerable<SeatRowItem> rows, bool hasShowtime)
        {
            var allSeats = rows.SelectMany(r => r.Seats).Where(s => !s.IsAisle).ToList();
            int stdCount = allSeats.Where(s => s.Type == SeatType.Standard).Sum(s => s.SeatIDs.Count);
            int vipCount = allSeats.Where(s => s.Type == SeatType.Vip).Sum(s => s.SeatIDs.Count);
            int couplePairs = allSeats.Count(s => s.Type == SeatType.Couple);
            int total = stdCount + vipCount + couplePairs * 2;
            int sold = allSeats.Where(s => s.IsSold).Sum(s => s.SeatIDs.Count);
            int free = Math.Max(0, total - sold);

            if (total == 0)
            {
                SeatMapSummary = "Phòng chưa có dữ liệu ghế trong SQL Server.";
            }
            else if (hasShowtime)
            {
                SeatMapSummary = $"Đã bán: {sold}/{total} ghế · Còn trống: {free} ghế ({stdCount} Thường · {vipCount} VIP · {couplePairs} cặp Đôi)";
            }
            else
            {
                SeatMapSummary = $"{total} ghế ({stdCount} Thường · {vipCount} VIP · {couplePairs} cặp Đôi) · Hôm nay chưa có suất chiếu";
            }
        }

        /// <summary>
        /// Đồng bộ thời gian thực từ SQL Server: cập nhật số ghế đã bán hôm nay trên từng phòng
        /// và cập nhật trực tiếp ghế đã bán/còn trống nếu modal sơ đồ đang mở.
        /// </summary>
        public async Task RefreshLiveAsync()
        {
            if (_isRefreshing) return;
            _isRefreshing = true;
            try
            {
                var latestRooms = await Task.Run(() => _roomService.GetAll());
                ApplyLatestRooms(latestRooms);

                if (IsSeatMapOpen && SelectedRoom != null)
                {
                    int roomId = SelectedRoom.RoomID;
                    int? selectedShowId = SelectedRoomShowtime?.ShowtimeID;

                    var (showtimes, seats, soldIds) = await Task.Run(() =>
                    {
                        var stList = _roomService.GetTodayShowtimes(roomId);
                        var chosenId = selectedShowId;
                        if (!chosenId.HasValue || stList.All(s => s.ShowtimeID != chosenId.Value))
                        {
                            chosenId = (stList.FirstOrDefault(s => s.StatusTag == "Đang chiếu")
                                ?? stList.FirstOrDefault(s => s.StatusTag == "Sắp chiếu")
                                ?? stList.LastOrDefault())?.ShowtimeID;
                        }
                        var physSeats = _bookingService.GetSeats(roomId);
                        var sold = chosenId.HasValue ? _bookingService.GetSoldSeatIds(chosenId.Value) : new HashSet<int>();
                        return (stList, physSeats, sold);
                    });

                    ApplyLiveSeatMap(showtimes, seats, soldIds);
                }
            }
            catch (Exception ex)
            {
                ShowBannerMessage("Mất kết nối đồng bộ phòng chiếu với SQL Server: " + ex.Message, isError: true);
            }
            finally
            {
                _isRefreshing = false;
            }
        }

        private void ApplyLatestRooms(List<Room> latestRooms)
        {
            bool sameSet = latestRooms.Count == _allRooms.Count &&
                           latestRooms.Select(r => r.RoomID).SequenceEqual(_allRooms.Select(r => r.RoomID));

            if (sameSet)
            {
                for (int i = 0; i < latestRooms.Count; i++)
                {
                    var src = latestRooms[i];
                    var dst = _allRooms[i];
                    dst.RoomName = src.RoomName;
                    dst.RoomType = src.RoomType;
                    dst.NumRows = src.NumRows;
                    dst.SeatsPerRow = src.SeatsPerRow;
                    dst.RoomStatus = src.RoomStatus;
                    dst.CurrentSchedule = src.CurrentSchedule;
                    dst.TodaySoldSeats = src.TodaySoldSeats;
                    dst.TodayShowtimeCount = src.TodayShowtimeCount;
                    dst.ActiveShowtimeID = src.ActiveShowtimeID;
                }
                UpdateKpis();
            }
            else
            {
                _allRooms = latestRooms;
                UpdateKpis();
                ApplyFilter();
            }
        }

        private void ApplyLiveSeatMap(List<RoomShowtimeInfo> showtimes, List<PhysicalSeat> physSeats, HashSet<int> soldIds)
        {
            int? prevId = SelectedRoomShowtime?.ShowtimeID;

            _suppressShowtimeReload = true;
            RoomShowtimes.Clear();
            foreach (var st in showtimes) RoomShowtimes.Add(st);
            OnPropertyChanged(nameof(HasRoomShowtimes));
            OnPropertyChanged(nameof(NoRoomShowtimes));

            var currentShow = showtimes.FirstOrDefault(s => s.ShowtimeID == prevId)
                ?? showtimes.FirstOrDefault(s => s.StatusTag == "Đang chiếu")
                ?? showtimes.FirstOrDefault(s => s.StatusTag == "Sắp chiếu")
                ?? showtimes.LastOrDefault();
            SelectedRoomShowtime = currentShow;
            _suppressShowtimeReload = false;

            var currentSeatIds = SeatMapRows.SelectMany(r => r.Seats).Where(s => !s.IsAisle).SelectMany(s => s.SeatIDs).ToList();
            var latestSeatIds = physSeats.Select(s => s.ID).ToList();
            if (!currentSeatIds.SequenceEqual(latestSeatIds))
            {
                var rebuilt = BookingService.BuildSeatRows(physSeats, 0m, currentShow != null ? soldIds : null);
                SeatMapRows = new ObservableCollection<SeatRowItem>(rebuilt);
            }
            else
            {
                foreach (var seat in SeatMapRows.SelectMany(r => r.Seats).Where(s => !s.IsAisle))
                {
                    seat.IsSold = currentShow != null && seat.SeatIDs.Any(soldIds.Contains);
                }
            }

            UpdateSeatMapSummary(SeatMapRows, currentShow != null);
        }

        private void ShowBannerMessage(string text, bool isError)
        {
            IsMessageError = isError;
            BannerMessage = text;
        }

        private void ClearEditorErrors()
        {
            HasNameError = false;
            NameError = "";
            HasDimensionError = false;
            DimensionError = "";
            EditorError = "";
        }

        private bool ValidateForm(out int numRows, out int seatsPerRow)
        {
            ClearEditorErrors();
            bool valid = true;
            numRows = 0;
            seatsPerRow = 0;

            if (string.IsNullOrWhiteSpace(FormRoomName))
            {
                HasNameError = true;
                NameError = "Vui lòng nhập tên phòng chiếu.";
                valid = false;
            }

            if (!int.TryParse(FormNumRowsText?.Trim(), out numRows) || numRows < 1 || numRows > 25)
            {
                HasDimensionError = true;
                DimensionError = "Số hàng ghế phải là số nguyên từ 1 đến 25 hàng (A - Z, bỏ I).";
                valid = false;
            }
            else if (!int.TryParse(FormSeatsPerRowText?.Trim(), out seatsPerRow) || seatsPerRow < 1 || seatsPerRow > 50)
            {
                HasDimensionError = true;
                DimensionError = "Số ghế mỗi hàng phải là số nguyên từ 1 đến 50 ghế.";
                valid = false;
            }

            return valid;
        }

        private void UpdateKpis()
        {
            TotalRoomsCount = _allRooms.Count;
            TotalSeatsCount = _allRooms.Sum(r => r.TotalSeats);
            ActiveRoomsCount = _allRooms.Count(r => r.RoomStatus == "Đang chiếu");
            ReadyRoomsCount = _allRooms.Count(r => r.RoomStatus == "Sẵn sàng");
            TotalTodaySoldCount = _allRooms.Sum(r => r.TodaySoldSeats);

            OnPropertyChanged(nameof(CountAllText));
            OnPropertyChanged(nameof(Count2DText));
            OnPropertyChanged(nameof(Count3DText));
            OnPropertyChanged(nameof(CountIMAXText));
        }

        private void ApplyFilter()
        {
            var query = _allRooms.AsEnumerable();

            if (!string.IsNullOrWhiteSpace(SearchText))
            {
                string kw = SearchText.Trim().ToLowerInvariant();
                query = query.Where(r => (r.RoomName ?? "").ToLowerInvariant().Contains(kw) ||
                                         (r.RoomType ?? "").ToLowerInvariant().Contains(kw));
            }

            if (FilterType != "All")
            {
                query = query.Where(r => (r.RoomType ?? "").ToUpperInvariant().Contains(FilterType.ToUpperInvariant()));
            }

            FilteredRooms.Clear();
            foreach (var r in query)
            {
                FilteredRooms.Add(r);
            }
        }
    }
}
