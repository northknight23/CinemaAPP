using CinemaAPP.Helpers;

namespace CinemaAPP.ViewModels
{
    // Một suất trong hộp thoại "Đổi suất chiếu" (dữ liệu giả, sau này lấy từ bảng SHOWTIME).
    public class ShowtimeOption : ObservableObject
    {
        public int ShowtimeID { get; init; }
        public string TimeRange { get; init; } = "";   // ví dụ "22:30 – 00:30"
        public string Date { get; init; } = "";
        public string Format { get; init; } = "";      // ví dụ "2D Phụ đề"
        public string RoomName { get; init; } = "";

        private bool isCurrent;
        public bool IsCurrent { get => isCurrent; set => SetProperty(ref isCurrent, value); }
    }
}
