using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Windows.Input;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using CinemaAPP.Services;

namespace CinemaAPP.ViewModels
{
    public class RoomManagementViewModel : ObservableObject
    {
        private readonly RoomService _roomService = new();
        private List<Room> _allRooms = new();

        private string _searchText = "";
        private string _filterType = "All";

        // KPI
        private int _totalRoomsCount;
        private int _totalSeatsCount;
        private int _activeRoomsCount;
        private int _readyRoomsCount;

        // Modal Form Thêm / Sửa
        private bool _isEditorOpen;
        private string _editorTitle = "Thêm phòng chiếu mới";
        private int _editingRoomId;
        private string _formRoomName = "";
        private string _formRoomType = "2D";
        private int _formNumRows = 10;
        private int _formSeatsPerRow = 12;

        private bool _hasNameError;
        private string _nameError = "";
        private bool _hasDimensionError;
        private string _dimensionError = "";
        private string _bannerMessage = "";
        private bool _isMessageError;
        private bool _showBanner;

        // Modal Sơ đồ ghế
        private bool _isSeatMapOpen;
        private Room? _selectedRoom;
        private ObservableCollection<SeatMapRow> _seatMapRows = new();

        public ObservableCollection<Room> FilteredRooms { get; } = new();

        public List<string> RoomTypeOptions { get; } = new()
        {
            "2D",
            "3D",
            "IMAX Laser",
            "VIP"
        };

        // ================= KHOẢNG TÌM KIẾM & BỘ LỌC =================
        public string SearchText
        {
            get => _searchText;
            set
            {
                if (SetProperty(ref _searchText, value))
                {
                    ApplyFilter();
                }
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
                    OnPropertyChanged(nameof(IsFilterVIP));
                    ApplyFilter();
                }
            }
        }

        public bool IsFilterAll => FilterType == "All";
        public bool IsFilter2D => FilterType == "2D";
        public bool IsFilter3D => FilterType == "3D";
        public bool IsFilterIMAX => FilterType == "IMAX";
        public bool IsFilterVIP => FilterType == "VIP";

        public string CountAllText => $"Tất cả ({_allRooms.Count})";
        public string Count2DText => $"2D ({_allRooms.Count(r => (r.RoomType ?? "").ToUpper().Contains("2D"))})";
        public string Count3DText => $"3D ({_allRooms.Count(r => (r.RoomType ?? "").ToUpper().Contains("3D"))})";
        public string CountIMAXText => $"IMAX ({_allRooms.Count(r => (r.RoomType ?? "").ToUpper().Contains("IMAX"))})";
        public string CountVIPText => $"VIP ({_allRooms.Count(r => (r.RoomType ?? "").ToUpper().Contains("VIP"))})";

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
            set => SetProperty(ref _formRoomType, value);
        }

        public int FormNumRows
        {
            get => _formNumRows;
            set
            {
                if (SetProperty(ref _formNumRows, value))
                {
                    OnPropertyChanged(nameof(FormSeatPreview));
                }
            }
        }

        public int FormSeatsPerRow
        {
            get => _formSeatsPerRow;
            set
            {
                if (SetProperty(ref _formSeatsPerRow, value))
                {
                    OnPropertyChanged(nameof(FormSeatPreview));
                }
            }
        }

        public string FormSeatPreview
        {
            get
            {
                int total = Math.Max(0, FormNumRows * FormSeatsPerRow);
                char maxRowChar = (char)('A' + Math.Clamp(FormNumRows - 1, 0, 25));
                return $"{total} ghế (Hàng A đến {maxRowChar}, {FormSeatsPerRow} ghế/hàng)";
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

        public string BannerMessage
        {
            get => _bannerMessage;
            set => SetProperty(ref _bannerMessage, value);
        }

        public bool IsMessageError
        {
            get => _isMessageError;
            set => SetProperty(ref _isMessageError, value);
        }

        public bool ShowBanner
        {
            get => _showBanner;
            set => SetProperty(ref _showBanner, value);
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
                {
                    OnPropertyChanged(nameof(SeatMapTitle));
                }
            }
        }

        public string SeatMapTitle => SelectedRoom != null
            ? $"Sơ đồ ghế - {SelectedRoom.RoomName} ({SelectedRoom.RoomType})"
            : "Sơ đồ ghế";

        public ObservableCollection<SeatMapRow> SeatMapRows
        {
            get => _seatMapRows;
            set => SetProperty(ref _seatMapRows, value);
        }

        // ================= CÁC LỆNH (COMMANDS) =================
        public ICommand SetFilterCommand { get; }
        public ICommand NewRoomCommand { get; }
        public ICommand EditRoomCommand { get; }
        public ICommand DeleteRoomCommand { get; }
        public ICommand SaveRoomCommand { get; }
        public ICommand CancelCommand { get; }
        public ICommand ViewSeatMapCommand { get; }
        public ICommand CloseSeatMapCommand { get; }

        public RoomManagementViewModel()
        {
            SetFilterCommand = new RelayCommand(p =>
            {
                if (p is string type)
                {
                    FilterType = type;
                }
            });

            NewRoomCommand = new RelayCommand(_ =>
            {
                _editingRoomId = 0;
                EditorTitle = "Thêm phòng chiếu mới";
                FormRoomName = "";
                FormRoomType = "2D";
                FormNumRows = 10;
                FormSeatsPerRow = 12;
                ClearErrors();
                IsEditorOpen = true;
            });

            EditRoomCommand = new RelayCommand(p =>
            {
                if (p is Room room)
                {
                    _editingRoomId = room.RoomID;
                    EditorTitle = $"Chỉnh sửa - {room.RoomName}";
                    FormRoomName = room.RoomName;
                    FormRoomType = room.RoomType;
                    FormNumRows = room.NumRows;
                    FormSeatsPerRow = room.SeatsPerRow;
                    ClearErrors();
                    IsEditorOpen = true;
                }
            });

            DeleteRoomCommand = new RelayCommand(p =>
            {
                if (p is Room room)
                {
                    try
                    {
                        _roomService.Delete(room.RoomID);
                        LoadRooms();
                    }
                    catch (Exception ex)
                    {
                        System.Windows.MessageBox.Show(ex.Message, "Thông báo", System.Windows.MessageBoxButton.OK, System.Windows.MessageBoxImage.Warning);
                    }
                }
            });

            SaveRoomCommand = new RelayCommand(_ =>
            {
                if (!ValidateForm()) return;

                var roomToSave = new Room
                {
                    RoomID = _editingRoomId,
                    RoomName = FormRoomName.Trim(),
                    RoomType = FormRoomType,
                    NumRows = FormNumRows,
                    SeatsPerRow = FormSeatsPerRow
                };

                try
                {
                    _roomService.Save(roomToSave);
                    IsEditorOpen = false;
                    LoadRooms();
                }
                catch (Exception ex)
                {
                    BannerMessage = ex.Message;
                    IsMessageError = true;
                    ShowBanner = true;
                }
            });

            CancelCommand = new RelayCommand(_ =>
            {
                IsEditorOpen = false;
                ClearErrors();
            });

            ViewSeatMapCommand = new RelayCommand(p =>
            {
                if (p is Room room)
                {
                    SelectedRoom = room;
                    var rows = _roomService.GetSeatMap(room);
                    SeatMapRows = new ObservableCollection<SeatMapRow>(rows);
                    IsSeatMapOpen = true;
                }
            });

            CloseSeatMapCommand = new RelayCommand(_ =>
            {
                IsSeatMapOpen = false;
            });

            LoadRooms();
        }

        private void ClearErrors()
        {
            HasNameError = false;
            NameError = "";
            HasDimensionError = false;
            DimensionError = "";
            ShowBanner = false;
            BannerMessage = "";
        }

        private bool ValidateForm()
        {
            ClearErrors();
            bool valid = true;

            if (string.IsNullOrWhiteSpace(FormRoomName))
            {
                HasNameError = true;
                NameError = "Vui lòng nhập tên phòng chiếu.";
                valid = false;
            }

            if (FormNumRows < 1 || FormNumRows > 26)
            {
                HasDimensionError = true;
                DimensionError = "Số hàng ghế hợp lệ từ 1 đến 26 hàng (A - Z).";
                valid = false;
            }
            else if (FormSeatsPerRow < 1 || FormSeatsPerRow > 50)
            {
                HasDimensionError = true;
                DimensionError = "Số ghế mỗi hàng hợp lệ từ 1 đến 50 ghế.";
                valid = false;
            }

            return valid;
        }

        private void LoadRooms()
        {
            _allRooms = _roomService.GetAll();
            UpdateKpis();
            ApplyFilter();
        }

        private void UpdateKpis()
        {
            TotalRoomsCount = _allRooms.Count;
            TotalSeatsCount = _allRooms.Sum(r => r.TotalSeats);
            ActiveRoomsCount = _allRooms.Count(r => r.RoomStatus == "Đang chiếu");
            ReadyRoomsCount = _allRooms.Count(r => r.RoomStatus == "Sẵn sàng");

            OnPropertyChanged(nameof(CountAllText));
            OnPropertyChanged(nameof(Count2DText));
            OnPropertyChanged(nameof(Count3DText));
            OnPropertyChanged(nameof(CountIMAXText));
            OnPropertyChanged(nameof(CountVIPText));
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
