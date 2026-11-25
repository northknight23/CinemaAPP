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
        private string roomName = "";
        public string RoomName
        {
            get => roomName;
            set
            {
                if (SetProperty(ref roomName, value))
                    OnPropertyChanged(nameof(RoomFormat));
            }
        }
        public string ShowFormat { get; init; } = "";   // 2D / 3D
        public string AudioType { get; init; } = "";    // Phụ đề / Lồng tiếng

        // Các SeatID thật đã có vé Active của suất này.
        public HashSet<int> SoldSeatIds { get; } = new HashSet<int>();

        public string StartText => StartTime.ToString("HH:mm");
        public DateTime EndTime => StartTime.AddMinutes(DurationMin);
        public string TimeRange => $"{StartText} – {EndTime:HH:mm}";
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
                    OnPropertyChanged(nameof(StatusBadge));
                }
            }
        }
        public string FreeText => $"Còn {FreeSeats} ghế";
        public string StatusBadge => GetStatusBadge(DateTime.Now);

        internal string GetStatusBadge(DateTime now)
        {
            if (now >= EndTime) return "END";
            if (now >= StartTime) return "START";
            return FreeSeats <= 0 ? "HẾT VÉ" : "";
        }

        internal void NotifyAvailabilityChanged()
        {
            OnPropertyChanged(nameof(CanSell));
            OnPropertyChanged(nameof(StatusBadge));
        }

        private bool isCurrent;
        public bool IsCurrent { get => isCurrent; set => SetProperty(ref isCurrent, value); }
    }
}
