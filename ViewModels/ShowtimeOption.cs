using CinemaAPP.Helpers;

namespace CinemaAPP.ViewModels
{
    // Một suất chiếu trong cột "Suất chiếu hôm nay" (dữ liệu giả, sau này lấy từ bảng SHOWTIME).
    public class ShowtimeOption : ObservableObject
    {
        public int ShowtimeID { get; init; }
        public string MovieTitle { get; init; } = "";
        public DateTime StartTime { get; init; }
        public int DurationMin { get; init; }
        public string RoomName { get; init; } = "";
        public string ShowFormat { get; init; } = "";   // 2D / 3D
        public string AudioType { get; init; } = "";    // Phụ đề / Lồng tiếng

        // Giả lập bảng TICKET: SeatID đã bán của riêng suất này
        public HashSet<int> SoldSeatIds { get; } = new HashSet<int>();

        public string StartText => StartTime.ToString("HH:mm");
        public string TimeRange => $"{StartText} – {StartTime.AddMinutes(DurationMin):HH:mm}";
        public string RoomFormat => $"{RoomName} · {ShowFormat}";
        public string FormatAudio => $"{ShowFormat} · {AudioType}";

        private int freeSeats;
        public int FreeSeats
        {
            get => freeSeats;
            set
            {
                if (SetProperty(ref freeSeats, value))
                    OnPropertyChanged(nameof(FreeText));
            }
        }
        public string FreeText => FreeSeats == 0 ? "Hết ghế" : $"Còn {FreeSeats} ghế";

        private bool isCurrent;
        public bool IsCurrent { get => isCurrent; set => SetProperty(ref isCurrent, value); }
    }
}
