using System;
using System.Collections.Generic;
using System.Data;
using CinemaAPP.Data;
using CinemaAPP.Models;
using Microsoft.Data.SqlClient;

namespace CinemaAPP.Services
{
    public class RoomService
    {
        private const int ForeignKeyViolation = 547;
        private const int UniqueViolation = 2627;
        private const int UniqueIndexViolation = 2601;

        public List<Room> GetAll()
        {
            var list = new List<Room>();
            try
            {
                using SqlConnection conn = Db.Open();
                using var cmd = new SqlCommand(@"
                    SELECT r.RoomID, r.RoomName, r.RoomType, r.NumRows, r.SeatsPerRow,
                           s_now.Title AS NowTitle, s_now.StartTime AS NowStart, s_now.DurationMin AS NowDuration,
                           s_next.Title AS NextTitle, s_next.StartTime AS NextStart
                    FROM ROOM r
                    OUTER APPLY (
                        SELECT TOP 1 m.Title, s.StartTime, m.DurationMin
                        FROM SHOWTIME s
                        JOIN MOVIE m ON s.MovieID = m.MovieID
                        WHERE s.RoomID = r.RoomID 
                          AND s.StartTime <= SYSDATETIME() 
                          AND DATEADD(minute, m.DurationMin, s.StartTime) >= SYSDATETIME()
                        ORDER BY s.StartTime DESC
                    ) s_now
                    OUTER APPLY (
                        SELECT TOP 1 m.Title, s.StartTime
                        FROM SHOWTIME s
                        JOIN MOVIE m ON s.MovieID = m.MovieID
                        WHERE s.RoomID = r.RoomID 
                          AND s.StartTime > SYSDATETIME()
                        ORDER BY s.StartTime ASC
                    ) s_next
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
                        SeatsPerRow = r.GetInt32(4)
                    };

                    if (!r.IsDBNull(5)) // Đang có suất chiếu
                    {
                        string title = r.GetString(5);
                        DateTime start = r.GetDateTime(6);
                        int duration = r.GetInt32(7);
                        DateTime end = start.AddMinutes(duration);
                        room.RoomStatus = "Đang chiếu";
                        room.CurrentSchedule = $"{title} · {start:HH:mm} - {end:HH:mm}";
                    }
                    else if (!r.IsDBNull(8)) // Có suất chiếu sắp tới
                    {
                        string title = r.GetString(8);
                        DateTime start = r.GetDateTime(9);
                        room.RoomStatus = "Sẵn sàng";
                        room.CurrentSchedule = $"Suất tiếp: {title} · {start:HH:mm}";
                    }
                    else
                    {
                        room.RoomStatus = "Sẵn sàng";
                        room.CurrentSchedule = "Chưa có lịch chiếu";
                    }

                    list.Add(room);
                }
            }
            catch (Exception)
            {
                // Khi không kết nối được CSDL hoặc bảng ROOM rỗng, trả về danh sách rỗng (không dùng dữ liệu giả)
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

                    // Tự động sinh hàng loạt ghế trong bảng SEAT
                    GenerateSeats(conn, trans, room.RoomID, room.NumRows, room.SeatsPerRow);
                }
                else
                {
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

                    // Kiểm tra xem đã có vé nào bán gắn với ghế của phòng này chưa
                    using var checkCmd = new SqlCommand(@"
                        SELECT COUNT(*) FROM TICKET t
                        JOIN SEAT s ON t.SeatID = s.SeatID
                        WHERE s.RoomID = @RoomID", conn, trans);
                    checkCmd.Parameters.Add("@RoomID", SqlDbType.Int).Value = room.RoomID;
                    int ticketCount = (int)checkCmd.ExecuteScalar()!;

                    if (ticketCount == 0)
                    {
                        using var delSeatsCmd = new SqlCommand("DELETE FROM SEAT WHERE RoomID = @RoomID", conn, trans);
                        delSeatsCmd.Parameters.Add("@RoomID", SqlDbType.Int).Value = room.RoomID;
                        delSeatsCmd.ExecuteNonQuery();

                        GenerateSeats(conn, trans, room.RoomID, room.NumRows, room.SeatsPerRow);
                    }
                }

                trans.Commit();
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

        private void GenerateSeats(SqlConnection conn, SqlTransaction trans, int roomId, int numRows, int seatsPerRow)
        {
            for (int r = 0; r < numRows; r++)
            {
                string rowLabel = ((char)('A' + r)).ToString();
                for (int s = 1; s <= seatsPerRow; s++)
                {
                    using var cmd = new SqlCommand(@"
                        INSERT INTO SEAT (RoomID, RowLabel, SeatNumber)
                        VALUES (@RoomID, @RowLabel, @SeatNumber)", conn, trans);
                    cmd.Parameters.Add("@RoomID", SqlDbType.Int).Value = roomId;
                    cmd.Parameters.Add("@RowLabel", SqlDbType.NVarChar, 5).Value = rowLabel;
                    cmd.Parameters.Add("@SeatNumber", SqlDbType.Int).Value = s;
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

        public List<SeatMapRow> GetSeatMap(Room room)
        {
            var rows = new List<SeatMapRow>();
            bool isAllVip = room.RoomType?.ToUpperInvariant() == "VIP";
            int vipStartRow = isAllVip ? 0 : Math.Max(0, room.NumRows / 2);

            for (int r = 0; r < room.NumRows; r++)
            {
                string rowLabel = ((char)('A' + r)).ToString();
                var rowItem = new SeatMapRow { RowLabel = rowLabel };
                bool isVipRow = isAllVip || (r >= vipStartRow);

                for (int s = 1; s <= room.SeatsPerRow; s++)
                {
                    rowItem.Seats.Add(new SeatMapSeat
                    {
                        RowLabel = rowLabel,
                        SeatNumber = s,
                        IsVip = isVipRow
                    });
                }
                rows.Add(rowItem);
            }
            return rows;
        }
    }
}
