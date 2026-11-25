using System.Data;
using System.Globalization;
using CinemaAPP.Data;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using CinemaAPP.ViewModels;
using Microsoft.Data.SqlClient;

namespace CinemaAPP.Services
{
    public record SeatQuote(int SeatID, decimal Price);
    public record BookingResult(SaleRecord Sale, PrintableTicket Ticket);
    public record PhysicalSeat(int ID, string Row, int Number, SeatType Type);

    public class BookingService
    {
        public static decimal SeatPrice(decimal basePrice, SeatType type) =>
            decimal.Round(type == SeatType.Standard ? basePrice : basePrice * 1.2m, 4, MidpointRounding.AwayFromZero);

        public List<MovieShowtimes> GetTodayShowtimes()
        {
            using var conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT s.ShowtimeID,s.RoomID,s.StartTime,s.BasePrice,s.ShowFormat,s.AudioType,
                         m.MovieID,m.Title,m.DurationMin,m.Agerating,m.Genre,m.PosterPath,r.RoomName,
                         (SELECT COUNT(*) FROM SEAT se WHERE se.RoomID=s.RoomID),
                         (SELECT COUNT(*) FROM TICKET t WHERE t.ShowtimeID=s.ShowtimeID AND t.TicketStatus=N'Active')
                  FROM SHOWTIME s JOIN MOVIE m ON m.MovieID=s.MovieID JOIN ROOM r ON r.RoomID=s.RoomID
                  WHERE s.StartTime>=CAST(SYSDATETIME() AS DATE)
                    AND s.StartTime<DATEADD(DAY,1,CAST(SYSDATETIME() AS DATE))
                    AND ISNULL(m.MovieStatus,N'')<>N'Ngừng chiếu'
                  ORDER BY m.Title,s.StartTime", conn);
            using var reader = cmd.ExecuteReader();
            var movies = new Dictionary<int, MovieShowtimes>();
            while (reader.Read())
            {
                int movieId = reader.GetInt32(6);
                if (!movies.TryGetValue(movieId, out var movie))
                {
                    movie = new MovieShowtimes
                    {
                        Title = reader.GetString(7), DurationMin = reader.GetInt32(8),
                        AgeRating = reader.IsDBNull(9) ? "" : reader.GetString(9),
                        Genre = reader.IsDBNull(10) ? "" : reader.GetString(10),
                        PosterPath = reader.IsDBNull(11) ? null : reader.GetString(11),
                    };
                    movies.Add(movieId, movie);
                }
                movie.Showtimes.Add(new ShowtimeOption
                {
                    ShowtimeID = reader.GetInt32(0), RoomID = reader.GetInt32(1),
                    StartTime = reader.GetDateTime(2), BasePrice = reader.GetDecimal(3),
                    ShowFormat = reader.IsDBNull(4) ? "" : reader.GetString(4),
                    AudioType = reader.IsDBNull(5) ? "" : reader.GetString(5),
                    MovieTitle = movie.Title, DurationMin = movie.DurationMin, RoomName = reader.GetString(12),
                    FreeSeats = Math.Max(0, reader.GetInt32(13) - reader.GetInt32(14)),
                });
            }
            return movies.Values.ToList();
        }

        public List<PhysicalSeat> GetSeats(int roomId)
        {
            using var conn = Db.Open();
            return ReadSeats(conn, null, roomId);
        }

        private static List<PhysicalSeat> ReadSeats(SqlConnection conn, SqlTransaction? tx, int roomId)
        {
            using var cmd = new SqlCommand(
                "SELECT SeatID,RowLabel,SeatNumber,SeatType FROM SEAT "
                + (tx == null ? "" : "WITH (UPDLOCK,HOLDLOCK) ")
                + "WHERE RoomID=@Room ORDER BY RowLabel,SeatNumber", conn, tx);
            cmd.Parameters.Add("@Room", SqlDbType.Int).Value = roomId;
            var seats = new List<PhysicalSeat>();
            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                if (!Enum.TryParse<SeatType>(reader.GetString(3), true, out var type) || !Enum.IsDefined(type))
                    throw new InvalidOperationException("Phòng có loại ghế không hợp lệ, cần cập nhật dữ liệu ghế.");
                seats.Add(new PhysicalSeat(reader.GetInt32(0), reader.GetString(1), reader.GetInt32(2), type));
            }
            return seats;
        }

        public HashSet<int> GetSoldSeatIds(int showtimeId)
        {
            using var conn = Db.Open();
            using var cmd = new SqlCommand(
                "SELECT SeatID FROM TICKET WHERE ShowtimeID=@Show AND TicketStatus=N'Active'", conn);
            cmd.Parameters.Add("@Show", SqlDbType.Int).Value = showtimeId;
            using var reader = cmd.ExecuteReader();
            var sold = new HashSet<int>();
            while (reader.Read()) sold.Add(reader.GetInt32(0));
            return sold;
        }

        public bool IsBookingPaid(int bookingId)
        {
            using var conn = Db.Open();
            using var cmd = new SqlCommand("SELECT COUNT(*) FROM BOOKING WHERE BookingID=@ID AND BookingStatus=N'Paid'", conn);
            cmd.Parameters.Add("@ID", SqlDbType.Int).Value = bookingId;
            return (int)cmd.ExecuteScalar()! == 1;
        }

        public static List<SeatItem> BuildSeatItems(IEnumerable<PhysicalSeat> source, decimal basePrice)
        {
            var items = new List<SeatItem>();
            foreach (var row in source.GroupBy(s => s.Row).OrderBy(g => g.Key))
            {
                var seats = row.OrderBy(s => s.Number).ToArray();
                for (int i = 0; i < seats.Length; i++)
                {
                    var seat = seats[i];
                    var ids = new List<int> { seat.ID };
                    string number = seat.Number.ToString();
                    if (seat.Type == SeatType.Couple)
                    {
                        if (seat.Number % 2 != 1 || i + 1 >= seats.Length
                            || seats[i + 1].Type != SeatType.Couple || seats[i + 1].Number != seat.Number + 1)
                            throw new InvalidOperationException($"Ghế đôi hàng {seat.Row} chưa có cặp hợp lệ.");
                        ids.Add(seats[++i].ID);
                        number += "-" + seats[i].Number;
                    }
                    items.Add(new SeatItem
                    {
                        SeatID = seat.ID, SeatIDs = ids, RowLabel = seat.Row, NumberText = number,
                        Type = seat.Type, Price = SeatPrice(basePrice, seat.Type) * ids.Count,
                    });
                }
            }
            return items;
        }

        // Gom ghế thành từng hàng kèm lối đi và trạng thái đã bán (dùng chung cho cả Bán vé và Quản lý phòng).
        public static List<SeatRowItem> BuildSeatRows(
            IReadOnlyList<PhysicalSeat> seats,
            decimal basePrice,
            IReadOnlySet<int>? soldSeatIds = null)
        {
            var items = BuildSeatItems(seats, basePrice);
            var rows = new List<SeatRowItem>();
            foreach (var group in items.GroupBy(s => s.RowLabel))
            {
                var row = new SeatRowItem { RowLabel = group.Key };
                int lastNumber = seats.Where(s => s.Row == group.Key).Max(s => s.Number);
                foreach (var seat in group)
                {
                    int number = int.Parse(seat.NumberText.Split('-')[0], CultureInfo.InvariantCulture);
                    if (lastNumber >= 6 && (number == 3 || number == lastNumber - 1))
                        row.Seats.Add(SeatItem.Aisle());
                    if (soldSeatIds != null)
                        seat.IsSold = seat.SeatIDs.Any(soldSeatIds.Contains);
                    row.Seats.Add(seat);
                }
                rows.Add(row);
            }
            return rows;
        }

        public BookingResult CreateBooking(int accountId, int showtimeId, int? customerId,
            PaymentMethod method, decimal cashGiven, int pointsUsed, IReadOnlyList<SeatQuote> requestedSeats)
        {
            if (!Enum.IsDefined(method) || method == PaymentMethod.Unknown || pointsUsed < 0 || requestedSeats.Count == 0
                || requestedSeats.Select(s => s.SeatID).Distinct().Count() != requestedSeats.Count)
                throw new InvalidOperationException("Danh sách ghế hoặc thông tin thanh toán không hợp lệ.");
            using var conn = Db.Open();
            using var tx = conn.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                using var account = new SqlCommand(
                    "SELECT Username,FullName FROM ACCOUNT WHERE AccountID=@ID AND AccountRole=N'Staff' AND IsActive=1", conn, tx);
                account.Parameters.Add("@ID", SqlDbType.Int).Value = accountId;
                string username, fullName;
                using (var reader = account.ExecuteReader())
                {
                    if (!reader.Read()) throw new InvalidOperationException("Cần đăng nhập tài khoản nhân viên đang hoạt động để bán vé.");
                    username = reader.GetString(0); fullName = reader.GetString(1);
                }

                // Khóa suất trong lúc tạo đơn: lịch không được đổi khi đang xác nhận giá và ghế.
                using var showCmd = new SqlCommand(
                    @"SELECT s.RoomID,s.StartTime,s.BasePrice,s.ShowFormat,s.AudioType,m.Title,m.DurationMin,
                             m.Agerating,r.RoomName,SYSDATETIME(),m.MovieStatus
                      FROM SHOWTIME s WITH (UPDLOCK,HOLDLOCK) JOIN MOVIE m ON m.MovieID=s.MovieID
                      JOIN ROOM r ON r.RoomID=s.RoomID WHERE s.ShowtimeID=@ID", conn, tx);
                showCmd.Parameters.Add("@ID", SqlDbType.Int).Value = showtimeId;
                ShowtimeOption show; string age; DateTime now;
                using (var reader = showCmd.ExecuteReader())
                {
                    if (!reader.Read()) throw new InvalidOperationException("Suất chiếu không còn tồn tại. Hãy tải lại danh sách.");
                    now = reader.GetDateTime(9);
                    if (reader.GetDateTime(1) <= now || (!reader.IsDBNull(10) && reader.GetString(10) == "Ngừng chiếu"))
                        throw new InvalidOperationException("Suất đã bắt đầu hoặc phim ngừng chiếu, không thể bán vé.");
                    show = new ShowtimeOption
                    {
                        ShowtimeID = showtimeId, RoomID = reader.GetInt32(0), StartTime = reader.GetDateTime(1),
                        BasePrice = reader.GetDecimal(2), ShowFormat = reader.IsDBNull(3) ? "" : reader.GetString(3),
                        AudioType = reader.IsDBNull(4) ? "" : reader.GetString(4), MovieTitle = reader.GetString(5),
                        DurationMin = reader.GetInt32(6), RoomName = reader.GetString(8),
                    };
                    age = reader.IsDBNull(7) ? "" : reader.GetString(7);
                }
                var physical = ReadSeats(conn, tx, show.RoomID);
                var requested = requestedSeats.ToDictionary(s => s.SeatID);
                var selected = BuildSeatItems(physical, show.BasePrice)
                    .Where(s => s.SeatIDs.Any(requested.ContainsKey)).ToList();
                if (selected.Sum(s => s.SeatIDs.Count) != requested.Count
                    || selected.Any(s => s.SeatIDs.Any(id => !requested.ContainsKey(id)
                        || requested[id].Price != SeatPrice(show.BasePrice, s.Type))))
                    throw new InvalidOperationException("Ghế hoặc giá vé đã thay đổi. Hãy tải lại sơ đồ và xác nhận lại.");
                decimal gross = selected.Sum(s => s.Price);
                if (gross <= 0) throw new InvalidOperationException("Suất chiếu chưa có giá vé hợp lệ.");
                int balance = 0; string? customerName = null, phone = null;
                if (customerId.HasValue)
                {
                    using var customer = new SqlCommand(
                        "SELECT FullName,Phone,Points FROM CUSTOMER WITH (UPDLOCK,HOLDLOCK) WHERE CustomerID=@ID", conn, tx);
                    customer.Parameters.Add("@ID", SqlDbType.Int).Value = customerId.Value;
                    using var reader = customer.ExecuteReader();
                    if (!reader.Read()) throw new InvalidOperationException("Khách hàng không còn tồn tại.");
                    customerName = reader.GetString(0); phone = reader.GetString(1); balance = reader.GetInt32(2);
                }
                if (pointsUsed > balance || pointsUsed * 1000m > gross)
                    throw new InvalidOperationException("Điểm sử dụng vượt số dư hoặc tổng tiền vé. Hãy tìm lại khách và kiểm tra đơn.");
                decimal total = gross - pointsUsed * 1000m;
                if (method == PaymentMethod.Cash && cashGiven < total)
                    throw new InvalidOperationException("Tiền khách đưa chưa đủ thanh toán.");
                int points = customerId.HasValue
                    ? TicketRewards.Calculate(selected.Select(s => (s.Type, s.Price)), pointsUsed * 1000m) : 0;
                using var booking = new SqlCommand(
                    @"INSERT INTO BOOKING(AccountID,CustomerID,CreatedAt,TotalAmount,BookingStatus,PaymentMethod,CashGiven,PointsEarned,PointsUsed)
                      VALUES(@Account,@Customer,@At,@Total,N'Paid',@Method,@Cash,@Earned,@Used);
                      SELECT CAST(SCOPE_IDENTITY() AS INT)", conn, tx);
                booking.Parameters.Add("@Account", SqlDbType.Int).Value = accountId;
                booking.Parameters.Add("@Customer", SqlDbType.Int).Value = (object?)customerId ?? DBNull.Value;
                booking.Parameters.Add("@At", SqlDbType.DateTime2).Value = now;
                booking.Parameters.Add("@Total", SqlDbType.Money).Value = total;
                booking.Parameters.Add("@Method", SqlDbType.NVarChar, 20).Value = method.ToString();
                booking.Parameters.Add("@Cash", SqlDbType.Money).Value = method == PaymentMethod.Cash ? cashGiven : DBNull.Value;
                booking.Parameters.Add("@Earned", SqlDbType.Int).Value = points;
                booking.Parameters.Add("@Used", SqlDbType.Int).Value = pointsUsed;
                int id = (int)booking.ExecuteScalar()!;
                foreach (var seat in requestedSeats)
                {
                    using var ticket = new SqlCommand(
                        @"INSERT INTO TICKET(BookingID,ShowtimeID,RoomID,SeatID,Price,TicketStatus)
                          VALUES(@Booking,@Show,@Room,@Seat,@Price,N'Active')", conn, tx);
                    ticket.Parameters.Add("@Booking", SqlDbType.Int).Value = id;
                    ticket.Parameters.Add("@Show", SqlDbType.Int).Value = showtimeId;
                    ticket.Parameters.Add("@Room", SqlDbType.Int).Value = show.RoomID;
                    ticket.Parameters.Add("@Seat", SqlDbType.Int).Value = seat.SeatID;
                    ticket.Parameters.Add("@Price", SqlDbType.Money).Value = seat.Price;
                    ticket.ExecuteNonQuery();
                }
                if (customerId.HasValue)
                {
                    using var update = new SqlCommand("UPDATE CUSTOMER SET Points=Points-@Used+@Earned WHERE CustomerID=@ID", conn, tx);
                    update.Parameters.Add("@Used", SqlDbType.Int).Value = pointsUsed;
                    update.Parameters.Add("@Earned", SqlDbType.Int).Value = points;
                    update.Parameters.Add("@ID", SqlDbType.Int).Value = customerId.Value;
                    update.ExecuteNonQuery();
                }
                var sale = new SaleRecord
                {
                    BookingID = id, AccountID = accountId, CustomerID = customerId, CreatedAt = now,
                    MovieTitle = show.MovieTitle, ShowStart = show.StartTime, RoomName = show.RoomName,
                    ShowFormat = show.ShowFormat, StaffName = fullName, StaffUsername = username,
                    CustomerName = customerName, CustomerPhone = phone, Method = method,
                    CashGiven = method == PaymentMethod.Cash ? cashGiven : 0, Total = total, Points = points, PointsUsed = pointsUsed,
                    Seats = selected.Select(s => new SoldSeat(s.Label, s.Type, s.SeatIDs.Count)).ToList(),
                };
                var printable = new PrintableTicket(show, age, fullName, method, customerId.HasValue, pointsUsed,
                    selected.Select(s => new TicketSeat(s.Label, s.Type, s.Price)).ToArray(), sale);
                tx.Commit();
                CinemaSync.NotifyBookingsChanged();
                return new BookingResult(sale, printable);
            }
            catch (SqlException ex) when (ex.Number is 2601 or 2627)
            {
                throw new InvalidOperationException("Có ghế vừa được bán ở quầy khác. Vui lòng tải lại sơ đồ và chọn lại.", ex);
            }
            // Dispose transaction tự rollback nếu chưa Commit, kể cả lỗi khi thêm một trong nhiều vé.
        }

        public List<SaleRecord> GetSales(DateTime from, DateTime to)
        {
            using var conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT b.BookingID,b.AccountID,b.CustomerID,b.CreatedAt,b.TotalAmount,b.PaymentMethod,
                         b.CashGiven,b.PointsEarned,b.PointsUsed,b.BookingStatus,b.CancelReason,b.CancelledAt,
                         ISNULL(cancelled.FullName,N''),a.Username,a.FullName,c.FullName,c.Phone,
                         m.Title,s.StartTime,r.RoomName,s.ShowFormat,se.RowLabel,se.SeatNumber,se.SeatType
                  FROM BOOKING b JOIN ACCOUNT a ON a.AccountID=b.AccountID
                  JOIN TICKET t ON t.BookingID=b.BookingID JOIN SHOWTIME s ON s.ShowtimeID=t.ShowtimeID
                  JOIN MOVIE m ON m.MovieID=s.MovieID JOIN ROOM r ON r.RoomID=s.RoomID
                  JOIN SEAT se ON se.SeatID=t.SeatID
                  LEFT JOIN CUSTOMER c ON c.CustomerID=b.CustomerID
                  LEFT JOIN ACCOUNT cancelled ON cancelled.AccountID=b.CancelledBy
                  WHERE b.CreatedAt>=@From AND b.CreatedAt<@To
                  ORDER BY b.CreatedAt DESC,b.BookingID,se.RowLabel,se.SeatNumber", conn);
            cmd.Parameters.Add("@From", SqlDbType.DateTime2).Value = from;
            cmd.Parameters.Add("@To", SqlDbType.DateTime2).Value = to;
            var sales = new Dictionary<int, SaleRecord>();
            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                int id = reader.GetInt32(0);
                if (!sales.TryGetValue(id, out var sale))
                {
                    if (!Enum.TryParse<PaymentMethod>(reader.IsDBNull(5) ? "" : reader.GetString(5), out var method))
                        method = PaymentMethod.Unknown;
                    sale = new SaleRecord
                    {
                        BookingID = id, AccountID = reader.GetInt32(1),
                        CustomerID = reader.IsDBNull(2) ? null : reader.GetInt32(2),
                        CreatedAt = reader.GetDateTime(3), Total = reader.GetDecimal(4), Method = method,
                        CashGiven = reader.IsDBNull(6) ? 0 : reader.GetDecimal(6),
                        Points = reader.GetInt32(7), PointsUsed = reader.GetInt32(8),
                        IsCancelled = !reader.IsDBNull(9) && reader.GetString(9) == BookingStatus.Cancelled,
                        CancelReason = reader.IsDBNull(10) ? "" : reader.GetString(10),
                        CancelledAt = reader.IsDBNull(11) ? null : reader.GetDateTime(11),
                        CancelledBy = reader.GetString(12), StaffUsername = reader.GetString(13), StaffName = reader.GetString(14),
                        CustomerName = reader.IsDBNull(15) ? null : reader.GetString(15),
                        CustomerPhone = reader.IsDBNull(16) ? null : reader.GetString(16),
                        MovieTitle = reader.GetString(17), ShowStart = reader.GetDateTime(18), RoomName = reader.GetString(19),
                        ShowFormat = reader.IsDBNull(20) ? "" : reader.GetString(20),
                    };
                    sales.Add(id, sale);
                }
                Enum.TryParse<SeatType>(reader.GetString(23), true, out var type);
                sale.Seats.Add(new SoldSeat(reader.GetString(21) + reader.GetInt32(22), type));
            }
            return sales.Values.ToList();
        }

        public void CancelBooking(int bookingId, int accountId, string reason)
        {
            if (string.IsNullOrWhiteSpace(reason) || reason.Length > 200)
                throw new InvalidOperationException("Lý do hủy phải có từ 1 đến 200 ký tự.");
            using var conn = Db.Open();
            using var tx = conn.BeginTransaction(IsolationLevel.Serializable);
            using var command = new SqlCommand(
                @"SELECT b.CustomerID,b.PointsEarned,b.PointsUsed,b.BookingStatus,b.AccountID,
                         b.CreatedAt,a.AccountRole,MIN(s.StartTime),SYSDATETIME()
                  FROM BOOKING b WITH (UPDLOCK,HOLDLOCK)
                  JOIN TICKET t ON t.BookingID=b.BookingID JOIN SHOWTIME s ON s.ShowtimeID=t.ShowtimeID
                  JOIN ACCOUNT a ON a.AccountID=@Account AND a.IsActive=1
                  WHERE b.BookingID=@Booking
                  GROUP BY b.CustomerID,b.PointsEarned,b.PointsUsed,b.BookingStatus,b.AccountID,b.CreatedAt,a.AccountRole", conn, tx);
            command.Parameters.Add("@Account", SqlDbType.Int).Value = accountId;
            command.Parameters.Add("@Booking", SqlDbType.Int).Value = bookingId;
            int? customerId; int earned, used; bool isStaffCancel; DateTime cancelDate;
            using (var reader = command.ExecuteReader())
            {
                if (!reader.Read()) throw new InvalidOperationException("Đơn hoặc tài khoản không còn hợp lệ.");
                if (reader.GetString(3) == BookingStatus.Cancelled) return;
                bool admin = reader.GetString(6) == "Admin";
                DateTime now = reader.GetDateTime(8);
                if (!admin && (reader.GetInt32(4) != accountId
                    || reader.GetDateTime(5).Date != now.Date
                    || reader.GetDateTime(7) <= now))
                    throw new InvalidOperationException("Nhân viên chỉ hủy đơn của mình trong hôm nay trước giờ chiếu.");
                customerId = reader.IsDBNull(0) ? null : reader.GetInt32(0);
                earned = reader.GetInt32(1); used = reader.GetInt32(2);
                isStaffCancel = !admin;
                cancelDate = now.Date;
            }
            if (isStaffCancel)
            {
                using var shiftCheck = new SqlCommand(
                    @"IF OBJECT_ID('dbo.SHIFT_HANDOVER', 'U') IS NOT NULL
                          SELECT COUNT(*) FROM SHIFT_HANDOVER WITH (HOLDLOCK)
                          WHERE ShiftDate = @Date AND AccountID = @Account
                      ELSE SELECT 0", conn, tx);
                shiftCheck.Parameters.Add("@Date", SqlDbType.Date).Value = cancelDate;
                shiftCheck.Parameters.Add("@Account", SqlDbType.Int).Value = accountId;
                if (Convert.ToInt32(shiftCheck.ExecuteScalar()) > 0)
                    throw new InvalidOperationException("Ca đã chốt hoặc đã bàn giao nên nhân viên không thể hủy đơn. Hãy báo Quản trị viên.");
            }
            if (customerId.HasValue)
            {
                using var points = new SqlCommand(
                    @"UPDATE CUSTOMER WITH (UPDLOCK) SET Points=Points+@Used-@Earned
                      WHERE CustomerID=@ID AND Points+@Used>=@Earned", conn, tx);
                points.Parameters.Add("@ID", SqlDbType.Int).Value = customerId.Value;
                points.Parameters.Add("@Earned", SqlDbType.Int).Value = earned;
                points.Parameters.Add("@Used", SqlDbType.Int).Value = used;
                if (points.ExecuteNonQuery() != 1)
                    throw new InvalidOperationException("Điểm thưởng của đơn đã được sử dụng. Cần xử lý số dư khách trước khi hủy.");
            }
            using var cancel = new SqlCommand(
                @"UPDATE BOOKING SET BookingStatus=N'Cancelled',CancelReason=@Reason,CancelledAt=SYSDATETIME(),
                         CancelledBy=@Account WHERE BookingID=@Booking;
                  UPDATE TICKET SET TicketStatus=N'Cancelled' WHERE BookingID=@Booking", conn, tx);
            cancel.Parameters.Add("@Reason", SqlDbType.NVarChar, 200).Value = reason.Trim();
            cancel.Parameters.Add("@Account", SqlDbType.Int).Value = accountId;
            cancel.Parameters.Add("@Booking", SqlDbType.Int).Value = bookingId;
            cancel.ExecuteNonQuery();
            tx.Commit();
            CinemaSync.NotifyBookingsChanged();
        }
    }
}
