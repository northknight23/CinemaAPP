using System;
using System.Collections.Generic;
using System.Data;
using CinemaAPP.Data;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using CinemaAPP.ViewModels;
using Microsoft.Data.SqlClient;

namespace CinemaAPP.Services
{
    public class RoomService
    {
        private const int ForeignKeyViolation = 547;
        private const int UniqueViolation = 2627;
        private const int UniqueIndexViolation = 2601;

        // Bảng chữ cái hàng ghế đồng bộ với seed.sql (bỏ chữ I để tránh nhầm với số 1).
        private const string RowAlphabet = "ABCDEFGHJKLMNOPQRSTUVWXYZ";

        public static string GetRowLabel(int zeroBasedIndex)
        {
            if (zeroBasedIndex < 0 || zeroBasedIndex >= RowAlphabet.Length)
                throw new ArgumentOutOfRangeException(nameof(zeroBasedIndex), "Số hàng ghế hợp lệ từ 1 đến 25 hàng (A - Z, bỏ I).");
            return RowAlphabet[zeroBasedIndex].ToString();
        }

        // Phân loại ghế theo đúng quy ước của seed.sql & BackfillLegacyTestSeatTypes.sql:
        // - Hàng cuối là Couple nếu có từ 4 hàng và số ghế mỗi hàng là số chẵn.
        // - 3 hàng đầu (hoặc 4 hàng đầu với IMAX) là Standard, các hàng giữa là Vip.
        public static string GetDefaultSeatType(string? roomType, int rowIndexZeroBased, int numRows, int seatsPerRow)
        {
            bool hasCoupleRow = numRows >= 4 && seatsPerRow >= 2 && seatsPerRow % 2 == 0;
            if (hasCoupleRow && rowIndexZeroBased == numRows - 1)
                return "Couple";

            bool isImax = string.Equals(roomType?.Trim(), "IMAX", StringComparison.OrdinalIgnoreCase);
            int maxStdRows = isImax ? 4 : 3;
            int stdRows = numRows <= maxStdRows + (hasCoupleRow ? 1 : 0)
                ? Math.Max(1, numRows - (hasCoupleRow ? 2 : 1))
                : maxStdRows;

            return rowIndexZeroBased < stdRows ? "Standard" : "Vip";
        }

        public List<Room> GetAll()
        {
            var list = new List<Room>();
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(@"
                    SELECT r.RoomID, r.RoomName, r.RoomType, r.NumRows, r.SeatsPerRow,
                           s_now.ShowtimeID AS NowShowtimeID, s_now.Title AS NowTitle, s_now.StartTime AS NowStart, s_now.DurationMin AS NowDuration,
                           s_next.ShowtimeID AS NextShowtimeID, s_next.Title AS NextTitle, s_next.StartTime AS NextStart,
                           s_last_today.ShowtimeID AS LastTodayShowtimeID,
                           ISNULL((
                               SELECT COUNT(*)
                               FROM TICKET t
                               JOIN SHOWTIME s ON s.ShowtimeID = t.ShowtimeID
                               WHERE s.RoomID = r.RoomID
                                 AND t.TicketStatus = N'Active'
                                 AND s.StartTime >= CAST(SYSDATETIME() AS DATE)
                                 AND s.StartTime < DATEADD(DAY, 1, CAST(SYSDATETIME() AS DATE))
                           ), 0) AS TodaySoldSeats,
                           ISNULL((
                               SELECT COUNT(*)
                               FROM SHOWTIME s
                               WHERE s.RoomID = r.RoomID
                                 AND s.StartTime >= CAST(SYSDATETIME() AS DATE)
                                 AND s.StartTime < DATEADD(DAY, 1, CAST(SYSDATETIME() AS DATE))
                           ), 0) AS TodayShowtimeCount
                    FROM ROOM r
                    OUTER APPLY (
                        SELECT TOP 1 s.ShowtimeID, m.Title, s.StartTime, m.DurationMin
                        FROM SHOWTIME s
                        JOIN MOVIE m ON s.MovieID = m.MovieID
                        WHERE s.RoomID = r.RoomID
                          AND s.StartTime <= SYSDATETIME()
                          AND DATEADD(minute, m.DurationMin, s.StartTime) >= SYSDATETIME()
                        ORDER BY s.StartTime DESC
                    ) s_now
                    OUTER APPLY (
                        SELECT TOP 1 s.ShowtimeID, m.Title, s.StartTime
                        FROM SHOWTIME s
                        JOIN MOVIE m ON s.MovieID = m.MovieID
                        WHERE s.RoomID = r.RoomID
                          AND s.StartTime > SYSDATETIME()
                        ORDER BY s.StartTime ASC
                    ) s_next
                    OUTER APPLY (
                        SELECT TOP 1 s.ShowtimeID
                        FROM SHOWTIME s
                        WHERE s.RoomID = r.RoomID
                          AND s.StartTime >= CAST(SYSDATETIME() AS DATE)
                          AND s.StartTime < DATEADD(DAY, 1, CAST(SYSDATETIME() AS DATE))
                        ORDER BY s.StartTime DESC
                    ) s_last_today
                    ORDER BY r.RoomID", conn);

            using SqlDataReader r = cmd.ExecuteReader();
            while (r.Read())
            {
                var room = new Room
                {
                    RoomID = r.GetInt32(0),
                    RoomName = r.GetString(1),
                    RoomType = r.IsDBNull(2) ? "2D" : r.GetString(2),
                    NumRows = r.GetInt32(3),
                    SeatsPerRow = r.GetInt32(4),
                    TodaySoldSeats = r.GetInt32(13),
                    TodayShowtimeCount = r.GetInt32(14)
                };

                if (!r.IsDBNull(5)) // Đang có suất chiếu
                {
                    room.ActiveShowtimeID = r.GetInt32(5);
                    string title = r.GetString(6);
                    DateTime start = r.GetDateTime(7);
                    int duration = r.GetInt32(8);
                    DateTime end = start.AddMinutes(duration);
                    room.RoomStatus = "Đang chiếu";
                    room.CurrentSchedule = $"{title} · {start:HH:mm} - {end:HH:mm}";
                }
                else if (!r.IsDBNull(9)) // Có suất chiếu sắp tới
                {
                    room.ActiveShowtimeID = r.GetInt32(9);
                    string title = r.GetString(10);
                    DateTime start = r.GetDateTime(11);
                    room.RoomStatus = "Sẵn sàng";
                    room.CurrentSchedule = $"Suất tiếp: {title} · {start:HH:mm}";
                }
                else
                {
                    room.ActiveShowtimeID = r.IsDBNull(12) ? null : r.GetInt32(12);
                    room.RoomStatus = "Sẵn sàng";
                    room.CurrentSchedule = room.TodayShowtimeCount > 0 ? "Đã hoàn tất suất hôm nay" : "Chưa có lịch chiếu";
                }

                list.Add(room);
            }

            return list;
        }

        public List<RoomShowtimeInfo> GetTodayShowtimes(int roomId)
        {
            var list = new List<RoomShowtimeInfo>();
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(@"
                SELECT s.ShowtimeID, s.RoomID, m.Title, s.StartTime, m.DurationMin,
                       ISNULL(s.ShowFormat, N''), ISNULL(s.AudioType, N''), s.BasePrice,
                       (SELECT COUNT(*) FROM SEAT se WHERE se.RoomID = s.RoomID) AS TotalSeats,
                       (SELECT COUNT(*) FROM TICKET t WHERE t.ShowtimeID = s.ShowtimeID AND t.TicketStatus = N'Active') AS SoldSeats
                FROM SHOWTIME s
                JOIN MOVIE m ON m.MovieID = s.MovieID
                WHERE s.RoomID = @RoomID
                  AND s.StartTime >= CAST(SYSDATETIME() AS DATE)
                  AND s.StartTime < DATEADD(DAY, 1, CAST(SYSDATETIME() AS DATE))
                ORDER BY s.StartTime ASC", conn);
            cmd.Parameters.Add("@RoomID", SqlDbType.Int).Value = roomId;

            using SqlDataReader r = cmd.ExecuteReader();
            while (r.Read())
            {
                list.Add(new RoomShowtimeInfo
                {
                    ShowtimeID = r.GetInt32(0),
                    RoomID = r.GetInt32(1),
                    MovieTitle = r.GetString(2),
                    StartTime = r.GetDateTime(3),
                    DurationMin = r.GetInt32(4),
                    ShowFormat = r.GetString(5),
                    AudioType = r.GetString(6),
                    BasePrice = r.GetDecimal(7),
                    TotalSeats = r.GetInt32(8),
                    SoldSeats = r.GetInt32(9)
                });
            }
            return list;
        }

        public void Save(Room room)
        {
            using SqlConnection conn = Db.Open();
            using SqlTransaction trans = conn.BeginTransaction();
            try
            {
                if (room.RoomID == 0)
                {
                    using var cmd = new SqlCommand(@"
                        INSERT INTO ROOM (RoomName, RoomType, NumRows, SeatsPerRow)
                        VALUES (@RoomName, @RoomType, @NumRows, @SeatsPerRow);
                        SELECT CAST(SCOPE_IDENTITY() AS INT);", conn, trans);

                    cmd.Parameters.Add("@RoomName", SqlDbType.NVarChar, 50).Value = room.RoomName.Trim();
                    cmd.Parameters.Add("@RoomType", SqlDbType.NVarChar, 10).Value = (object?)room.RoomType ?? DBNull.Value;
                    cmd.Parameters.Add("@NumRows", SqlDbType.Int).Value = room.NumRows;
                    cmd.Parameters.Add("@SeatsPerRow", SqlDbType.Int).Value = room.SeatsPerRow;

                    room.RoomID = (int)cmd.ExecuteScalar()!;

                    // Tự động sinh hàng loạt ghế (Standard, Vip, Couple) đồng bộ với giao diện bán vé
                    GenerateSeats(conn, trans, room.RoomID, room.RoomType, room.NumRows, room.SeatsPerRow);
                }
                else
                {
                    string? oldType = null;
                    int oldRows = 0, oldSeatsPerRow = 0;
                    using (var oldCmd = new SqlCommand(
                        "SELECT RoomType, NumRows, SeatsPerRow FROM ROOM WHERE RoomID = @RoomID", conn, trans))
                    {
                        oldCmd.Parameters.Add("@RoomID", SqlDbType.Int).Value = room.RoomID;
                        using var reader = oldCmd.ExecuteReader();
                        if (!reader.Read())
                            throw new InvalidOperationException("Không tìm thấy phòng chiếu cần cập nhật.");
                        oldType = reader.IsDBNull(0) ? null : reader.GetString(0);
                        oldRows = reader.GetInt32(1);
                        oldSeatsPerRow = reader.GetInt32(2);
                    }

                    bool sizeChanged = oldRows != room.NumRows || oldSeatsPerRow != room.SeatsPerRow;
                    bool typeChanged = !string.Equals(oldType, room.RoomType, StringComparison.OrdinalIgnoreCase);

                    if (sizeChanged || typeChanged)
                    {
                        using var checkCmd = new SqlCommand(@"
                            SELECT COUNT(*) FROM TICKET t
                            JOIN SEAT s ON t.SeatID = s.SeatID
                            WHERE s.RoomID = @RoomID", conn, trans);
                        checkCmd.Parameters.Add("@RoomID", SqlDbType.Int).Value = room.RoomID;
                        int ticketCount = (int)checkCmd.ExecuteScalar()!;

                        if (sizeChanged && ticketCount > 0)
                            throw new InvalidOperationException("Không thể thay đổi kích thước hàng/ghế vì phòng này đã có vé bán ra.");

                        using var cmd = new SqlCommand(@"
                            UPDATE ROOM
                            SET RoomName = @RoomName, RoomType = @RoomType, NumRows = @NumRows, SeatsPerRow = @SeatsPerRow
                            WHERE RoomID = @RoomID", conn, trans);

                        cmd.Parameters.Add("@RoomID", SqlDbType.Int).Value = room.RoomID;
                        cmd.Parameters.Add("@RoomName", SqlDbType.NVarChar, 50).Value = room.RoomName.Trim();
                        cmd.Parameters.Add("@RoomType", SqlDbType.NVarChar, 10).Value = (object?)room.RoomType ?? DBNull.Value;
                        cmd.Parameters.Add("@NumRows", SqlDbType.Int).Value = room.NumRows;
                        cmd.Parameters.Add("@SeatsPerRow", SqlDbType.Int).Value = room.SeatsPerRow;
                        cmd.ExecuteNonQuery();

                        if (ticketCount == 0)
                        {
                            using var delSeatsCmd = new SqlCommand("DELETE FROM SEAT WHERE RoomID = @RoomID", conn, trans);
                            delSeatsCmd.Parameters.Add("@RoomID", SqlDbType.Int).Value = room.RoomID;
                            delSeatsCmd.ExecuteNonQuery();

                            GenerateSeats(conn, trans, room.RoomID, room.RoomType, room.NumRows, room.SeatsPerRow);
                        }
                    }
                    else
                    {
                        using var cmd = new SqlCommand(
                            "UPDATE ROOM SET RoomName = @RoomName WHERE RoomID = @RoomID", conn, trans);
                        cmd.Parameters.Add("@RoomID", SqlDbType.Int).Value = room.RoomID;
                        cmd.Parameters.Add("@RoomName", SqlDbType.NVarChar, 50).Value = room.RoomName.Trim();
                        cmd.ExecuteNonQuery();
                    }
                }

                trans.Commit();
                CinemaSync.NotifyRoomsChanged();
            }
            catch (SqlException ex) when (ex.Number == UniqueViolation || ex.Number == UniqueIndexViolation)
            {
                trans.Rollback();
                throw new InvalidOperationException("Tên phòng chiếu này đã tồn tại trong hệ thống.");
            }
            catch
            {
                trans.Rollback();
                throw;
            }
        }

        private static void GenerateSeats(SqlConnection conn, SqlTransaction trans, int roomId, string? roomType, int numRows, int seatsPerRow)
        {
            for (int r = 0; r < numRows; r++)
            {
                string rowLabel = GetRowLabel(r);
                string seatType = GetDefaultSeatType(roomType, r, numRows, seatsPerRow);
                for (int s = 1; s <= seatsPerRow; s++)
                {
                    using var cmd = new SqlCommand(@"
                        INSERT INTO SEAT (RoomID, RowLabel, SeatNumber, SeatType)
                        VALUES (@RoomID, @RowLabel, @SeatNumber, @SeatType)", conn, trans);
                    cmd.Parameters.Add("@RoomID", SqlDbType.Int).Value = roomId;
                    cmd.Parameters.Add("@RowLabel", SqlDbType.NVarChar, 5).Value = rowLabel;
                    cmd.Parameters.Add("@SeatNumber", SqlDbType.Int).Value = s;
                    cmd.Parameters.Add("@SeatType", SqlDbType.NVarChar, 10).Value = seatType;
                    cmd.ExecuteNonQuery();
                }
            }
        }

        public void Delete(int roomId)
        {
            using SqlConnection conn = Db.Open();

            // 1. Kiểm tra xem phòng có suất chiếu nào liên kết không
            using var checkCmd = new SqlCommand("SELECT COUNT(*) FROM SHOWTIME WHERE RoomID = @RoomID", conn);
            checkCmd.Parameters.Add("@RoomID", SqlDbType.Int).Value = roomId;
            int showtimeCount = (int)checkCmd.ExecuteScalar()!;
            if (showtimeCount > 0)
            {
                throw new InvalidOperationException("Không thể xóa: Phòng chiếu đã có lịch suất chiếu được xếp.");
            }

            using SqlTransaction trans = conn.BeginTransaction();
            try
            {
                // 2. Xóa toàn bộ ghế của phòng
                using var delSeatsCmd = new SqlCommand("DELETE FROM SEAT WHERE RoomID = @RoomID", conn, trans);
                delSeatsCmd.Parameters.Add("@RoomID", SqlDbType.Int).Value = roomId;
                delSeatsCmd.ExecuteNonQuery();

                // 3. Xóa phòng chiếu
                using var delRoomCmd = new SqlCommand("DELETE FROM ROOM WHERE RoomID = @RoomID", conn, trans);
                delRoomCmd.Parameters.Add("@RoomID", SqlDbType.Int).Value = roomId;
                delRoomCmd.ExecuteNonQuery();

                trans.Commit();
                CinemaSync.NotifyRoomsChanged();
            }
            catch (SqlException ex) when (ex.Number == ForeignKeyViolation)
            {
                trans.Rollback();
                throw new InvalidOperationException("Không thể xóa: Phòng chiếu đang có dữ liệu ràng buộc trong hệ thống.");
            }
            catch
            {
                trans.Rollback();
                throw;
            }
        }

        // Lấy sơ đồ ghế thật từ bảng SEAT kèm trạng thái đã bán của suất chiếu (đồng bộ 100% với màn Bán vé).
        public List<SeatRowItem> GetSeatMap(int roomId, int? showtimeId = null)
        {
            var bookingService = new BookingService();
            var seats = bookingService.GetSeats(roomId);
            HashSet<int>? soldIds = showtimeId.HasValue
                ? bookingService.GetSoldSeatIds(showtimeId.Value)
                : null;
            return BookingService.BuildSeatRows(seats, 0m, soldIds);
        }
    }
}
