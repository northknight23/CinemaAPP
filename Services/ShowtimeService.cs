using System.Data;
using CinemaAPP.Data;
using CinemaAPP.Models;
using Microsoft.Data.SqlClient;

namespace CinemaAPP.Services
{
    // Đọc / ghi bảng SHOWTIME. Lỗi CSDL không nuốt ở đây: ViewModel bắt và báo cho người dùng.
    public class ShowtimeService
    {
        public const int CleaningMinutes = 15;   // dọn phòng giữa 2 suất
        public const int SaleOpenDays = 3;       // mở bán vé cho suất trong 3 ngày: hôm nay, mai, kia

        private const string SelectSql =
            @"SELECT s.ShowtimeID, s.MovieID, s.RoomID, s.StartTime, s.ShowFormat, s.AudioType, s.BasePrice,
                     m.Title, m.DurationMin, m.Genre, m.Agerating, r.RoomName, r.RoomType,
                     ISNULL(se.Total, r.NumRows * r.SeatsPerRow), ISNULL(t.Sold, 0), ISNULL(t.Revenue, 0)
              FROM SHOWTIME s
              JOIN MOVIE m ON m.MovieID = s.MovieID
              JOIN ROOM r ON r.RoomID = s.RoomID
              OUTER APPLY (SELECT NULLIF(COUNT(*), 0) AS Total FROM SEAT WHERE SEAT.RoomID = s.RoomID) se
              OUTER APPLY (SELECT COUNT(*) AS Sold, SUM(tk.Price) AS Revenue
                           FROM TICKET tk JOIN BOOKING b ON b.BookingID = tk.BookingID
                           WHERE tk.ShowtimeID = s.ShowtimeID AND ISNULL(b.BookingStatus, '') <> @Cancelled) t";

        // Suất bắt đầu trong [from, to)
        public List<Showtime> GetRange(DateTime from, DateTime to)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(SelectSql + " WHERE s.StartTime >= @From AND s.StartTime < @To ORDER BY s.StartTime, r.RoomName", conn);
            cmd.Parameters.Add("@From", SqlDbType.DateTime2).Value = from;
            cmd.Parameters.Add("@To", SqlDbType.DateTime2).Value = to;
            return Read(cmd);
        }

        // Suất có sẵn trong cùng phòng bị chồng giờ với suất mới (đã tính dọn phòng ở cả hai), không có thì null.
        // excludeShowtimeId dùng khi SỬA một suất (không so với chính nó).
        public Showtime? FindOverlap(int roomId, DateTime start, int durationMin, int excludeShowtimeId = 0)
        {
            DateTime end = start.AddMinutes(durationMin + CleaningMinutes);
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                SelectSql + @" WHERE s.RoomID = @RoomID AND s.ShowtimeID <> @ExcludeID
                                 AND @Start < DATEADD(MINUTE, m.DurationMin + @Clean, s.StartTime)
                                 AND s.StartTime < @End
                               ORDER BY s.StartTime", conn);
            cmd.Parameters.Add("@RoomID", SqlDbType.Int).Value = roomId;
            cmd.Parameters.Add("@ExcludeID", SqlDbType.Int).Value = excludeShowtimeId;
            cmd.Parameters.Add("@Start", SqlDbType.DateTime2).Value = start;
            cmd.Parameters.Add("@End", SqlDbType.DateTime2).Value = end;
            cmd.Parameters.Add("@Clean", SqlDbType.Int).Value = CleaningMinutes;
            return Read(cmd).FirstOrDefault();
        }

        // Đếm lại vé ngay trước khi sửa / hủy: quầy khác có thể vừa bán.
        public int CountSoldSeats(int showtimeId)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT COUNT(*) FROM TICKET tk JOIN BOOKING b ON b.BookingID = tk.BookingID
                  WHERE tk.ShowtimeID = @ID AND ISNULL(b.BookingStatus, '') <> @Cancelled", conn);
            cmd.Parameters.Add("@ID", SqlDbType.Int).Value = showtimeId;
            cmd.Parameters.Add("@Cancelled", SqlDbType.NVarChar, 20).Value = BookingStatus.Cancelled;
            return Convert.ToInt32(cmd.ExecuteScalar());
        }

        public int Add(Showtime s)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"INSERT INTO SHOWTIME (MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice)
                  VALUES (@MovieID, @RoomID, @StartTime, @ShowFormat, @AudioType, @BasePrice);
                  SELECT CAST(SCOPE_IDENTITY() AS INT);", conn);
            AddFields(cmd, s);
            s.ShowtimeID = (int)cmd.ExecuteScalar();
            return s.ShowtimeID;
        }

        public void Update(Showtime s)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"UPDATE SHOWTIME SET MovieID = @MovieID, RoomID = @RoomID, StartTime = @StartTime,
                         ShowFormat = @ShowFormat, AudioType = @AudioType, BasePrice = @BasePrice
                  WHERE ShowtimeID = @ID", conn);
            AddFields(cmd, s);
            cmd.Parameters.Add("@ID", SqlDbType.Int).Value = s.ShowtimeID;
            cmd.ExecuteNonQuery();
        }

        // Suất đã bán vé thì TICKET còn tham chiếu → SqlException 547, ViewModel báo lỗi.
        public void Delete(int showtimeId)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand("DELETE FROM SHOWTIME WHERE ShowtimeID = @ID", conn);
            cmd.Parameters.Add("@ID", SqlDbType.Int).Value = showtimeId;
            cmd.ExecuteNonQuery();
        }

        public List<RoomOption> GetRooms()
        {
            var list = new List<RoomOption>();
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT r.RoomID, r.RoomName, ISNULL(r.RoomType, ''),
                         ISNULL((SELECT NULLIF(COUNT(*), 0) FROM SEAT WHERE SEAT.RoomID = r.RoomID), r.NumRows * r.SeatsPerRow)
                  FROM ROOM r ORDER BY r.RoomName", conn);
            using SqlDataReader rd = cmd.ExecuteReader();
            while (rd.Read())
                list.Add(new RoomOption(rd.GetInt32(0), rd.GetString(1), rd.GetString(2), rd.GetInt32(3)));
            return list;
        }

        private static void AddFields(SqlCommand cmd, Showtime s)
        {
            cmd.Parameters.Add("@MovieID", SqlDbType.Int).Value = s.MovieID;
            cmd.Parameters.Add("@RoomID", SqlDbType.Int).Value = s.RoomID;
            cmd.Parameters.Add("@StartTime", SqlDbType.DateTime2).Value = s.StartTime;
            cmd.Parameters.Add("@ShowFormat", SqlDbType.NVarChar, 10).Value = s.ShowFormat;
            cmd.Parameters.Add("@AudioType", SqlDbType.NVarChar, 20).Value = s.AudioType;
            cmd.Parameters.Add("@BasePrice", SqlDbType.Money).Value = s.BasePrice;
        }

        private static List<Showtime> Read(SqlCommand cmd)
        {
            cmd.Parameters.Add("@Cancelled", SqlDbType.NVarChar, 20).Value = BookingStatus.Cancelled;
            var list = new List<Showtime>();
            using SqlDataReader r = cmd.ExecuteReader();
            while (r.Read())
            {
                list.Add(new Showtime
                {
                    ShowtimeID = r.GetInt32(0),
                    MovieID = r.GetInt32(1),
                    RoomID = r.GetInt32(2),
                    StartTime = r.GetDateTime(3),
                    ShowFormat = r.IsDBNull(4) ? "2D" : r.GetString(4),
                    AudioType = r.IsDBNull(5) ? "" : r.GetString(5),
                    BasePrice = r.GetDecimal(6),
                    Title = r.GetString(7),
                    DurationMin = r.GetInt32(8),
                    Genre = r.IsDBNull(9) ? "" : r.GetString(9),
                    AgeRating = r.IsDBNull(10) ? "P" : r.GetString(10),
                    RoomName = r.GetString(11),
                    RoomType = r.IsDBNull(12) ? "" : r.GetString(12),
                    TotalSeats = r.GetInt32(13),
                    SoldSeats = r.GetInt32(14),
                    Revenue = r.GetDecimal(15),
                });
            }
            return list;
        }
    }

    // Một phòng trong ô chọn phòng của form suất chiếu
    public record RoomOption(int RoomID, string RoomName, string RoomType, int Capacity)
    {
        public bool IsImax => RoomType.Equals("IMAX", StringComparison.OrdinalIgnoreCase);
        public override string ToString() => string.IsNullOrEmpty(RoomType)
            ? $"{RoomName} · {Capacity} ghế"
            : $"{RoomName} · {RoomType} · {Capacity} ghế";
    }
}
