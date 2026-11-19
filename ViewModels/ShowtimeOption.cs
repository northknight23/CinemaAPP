using CinemaAPP.Helpers;

namespace CinemaAPP.ViewModels
{
    // Một suất thật trong cột suất chiếu hôm nay.
    public class ShowtimeOption : ObservableObject
    {
        public int ShowtimeID { get; init; }
        public int RoomID { get; init; }
        public decimal BasePrice { get; init; }
        public bool CanSell => StartTime > DateTime.Now && FreeSeats > 0;
        public string MovieTitle { get; init; } = "";
        public DateTime StartTime { get; init; }
        public int DurationMin { get; init; }
        public string RoomName { get; init; } = "";
        public string ShowFormat { get; init; } = "";   // 2D / 3D
        public string AudioType { get; init; } = "";    // Phụ đề / Lồng tiếng

        // Các SeatID thật đã có vé Active của suất này.
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
                {
                    OnPropertyChanged(nameof(FreeText));
                    OnPropertyChanged(nameof(CanSell));
                }
            }
        }
        public string FreeText => FreeSeats == 0 ? "Hết ghế" : $"Còn {FreeSeats} ghế";

        private bool isCurrent;
        public bool IsCurrent { get => isCurrent; set => SetProperty(ref isCurrent, value); }
    }
}
