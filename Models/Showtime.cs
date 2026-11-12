namespace CinemaAPP.Models
{
    // Một dòng SHOWTIME kèm thông tin lấy từ MOVIE, ROOM và TICKET (ShowtimeService JOIN sẵn).
    // C tạo trước theo kế hoạch §7.5 bước 1, A xem lại khi viết đủ 7 Model.
    public class Showtime
    {
        // ---- Cột của bảng SHOWTIME ----
        public int ShowtimeID { get; set; }
        public int MovieID { get; set; }
        public int RoomID { get; set; }
        public DateTime StartTime { get; set; }
        public string ShowFormat { get; set; } = "2D";      // 2D, 3D, IMAX
        public string AudioType { get; set; } = "Phụ đề";   // Phụ đề, Lồng tiếng
        public decimal BasePrice { get; set; }

        // ---- Lấy từ bảng khác ----
        public string Title { get; set; } = "";             // MOVIE.Title
        public int DurationMin { get; set; }                // MOVIE.DurationMin
        public string Genre { get; set; } = "";             // MOVIE.Genre
        public string AgeRating { get; set; } = "P";        // MOVIE.Agerating
        public string RoomName { get; set; } = "";          // ROOM.RoomName
        public string RoomType { get; set; } = "";          // ROOM.RoomType
        public int TotalSeats { get; set; }                 // số dòng SEAT của phòng (chưa sinh ghế thì NumRows × SeatsPerRow)
        public int SoldSeats { get; set; }                  // số TICKET của suất, bỏ đơn đã hủy
        public decimal Revenue { get; set; }                // tổng TICKET.Price của các vé đó

        public DateTime EndTime => StartTime.AddMinutes(DurationMin);
    }
}
