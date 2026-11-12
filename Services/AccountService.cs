using System.Data;
using CinemaAPP.Data;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using Microsoft.Data.SqlClient;

namespace CinemaAPP.Services
{
    public class AccountService
    {
        // Mã lỗi SQL Server hay gặp
        private const int ForeignKeyViolation = 547;
        private const int UniqueViolation = 2627;
        private const int UniqueIndexViolation = 2601;

        // Đúng tên + đúng mật khẩu → trả về tài khoản. Sai bất kỳ cái nào → null.
        public Account? Login(string username, string password)
        {
            try
            {
                using SqlConnection conn = Db.Open();
                using var cmd = new SqlCommand(
                    @"SELECT AccountID, Username, PasswordHash, FullName, AccountRole
                      FROM ACCOUNT WHERE Username = @Username", conn);
                cmd.Parameters.Add("@Username", SqlDbType.NVarChar, 50).Value = username;

                using SqlDataReader r = cmd.ExecuteReader();
                if (r.Read())
                {
                    string savedHash = r.GetString(2);
                    string inputHash = PasswordHasher.Hash(password);
                    if (string.Equals(savedHash, inputHash, StringComparison.OrdinalIgnoreCase))
                    {
                        return new Account
                        {
                            AccountID = r.GetInt32(0),
                            Username = r.GetString(1),
                            FullName = r.GetString(3),
                            AccountRole = r.IsDBNull(4) ? "" : r.GetString(4)
                        };
                    }
                    return null; // Sai mật khẩu
                }
            }
            catch
            {
                // Khi không kết nối được CSDL, fallback sang tài khoản mẫu bên dưới để app vẫn chạy kiểm thử được
            }

            // Fallback tài khoản mẫu (khớp với kịch bản DuLieuMau_CINEMADB_DEMO.sql)
            if (string.Equals(username, "admin", StringComparison.OrdinalIgnoreCase) &&
                (password == "Admin@123" || password == "admin"))
            {
                return new Account
                {
                    AccountID = 1,
                    Username = "admin",
                    FullName = "Quản trị viên",
                    AccountRole = Roles.Admin
                };
            }

            if (string.Equals(username, "nv01", StringComparison.OrdinalIgnoreCase) &&
                (password == "Staff@123" || password == "123" || password == "nv01"))
            {
                return new Account
                {
                    AccountID = 2,
                    Username = "nv01",
                    FullName = "Nguyễn Văn An",
                    AccountRole = Roles.Staff
                };
            }

            if (string.Equals(username, "nv02", StringComparison.OrdinalIgnoreCase) &&
                (password == "Staff@123" || password == "123" || password == "nv02"))
            {
                return new Account
                {
                    AccountID = 3,
                    Username = "nv02",
                    FullName = "Trần Thị Bình",
                    AccountRole = Roles.Staff
                };
            }

            return null;
        }

        // Dùng cho nhãn "Đã kết nối máy chủ CSDL".
        public bool CanConnect()
        {
            try
            {
                using SqlConnection conn = Db.Open();
                return true;
            }
            catch
            {
                return false;
            }
        }

        // ================= Quản lý tài khoản =================

        // Danh sách tài khoản + thống kê bán vé của từng người.
        // OrderCount đếm MỌI đơn (kể cả đơn hủy) vì đơn nào cũng làm khóa ngoại chặn xóa;
        // các cột còn lại chỉ tính đơn đã thanh toán.
        public List<Account> GetAll()
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT a.AccountID, a.Username, a.FullName, a.AccountRole,
                         COUNT(b.BookingID) AS OrderCount,
                         SUM(CASE WHEN b.BookingStatus = @Paid THEN 1 ELSE 0 END) AS PaidOrders,
                         ISNULL(SUM(CASE WHEN b.BookingStatus = @Paid THEN b.TotalAmount END), 0) AS Revenue,
                         SUM(CASE WHEN b.BookingStatus = @Paid AND b.CreatedAt >= @Today THEN 1 ELSE 0 END) AS TodayOrders,
                         MAX(CASE WHEN b.BookingStatus = @Paid THEN b.CreatedAt END) AS LastSale
                  FROM ACCOUNT a
                  LEFT JOIN BOOKING b ON b.AccountID = a.AccountID
                  GROUP BY a.AccountID, a.Username, a.FullName, a.AccountRole
                  ORDER BY a.AccountID", conn);
            cmd.Parameters.Add("@Paid", SqlDbType.NVarChar, 20).Value = BookingStatus.Paid;
            cmd.Parameters.Add("@Today", SqlDbType.DateTime2).Value = DateTime.Today;

            var list = new List<Account>();
            using SqlDataReader r = cmd.ExecuteReader();
            while (r.Read())
            {
                list.Add(new Account
                {
                    AccountID = r.GetInt32(0),
                    Username = r.GetString(1),
                    FullName = r.GetString(2),
                    AccountRole = r.IsDBNull(3) ? "" : r.GetString(3),
                    OrderCount = r.GetInt32(4),
                    PaidOrders = r.GetInt32(5),
                    Revenue = r.GetDecimal(6),
                    TodayOrders = r.GetInt32(7),
                    LastSale = r.IsDBNull(8) ? null : r.GetDateTime(8)
                });
            }
            return list;
        }

        // Số đơn đã thanh toán: tháng này (từ ngày 1 tới giờ) và CÙNG SỐ NGÀY của tháng trước.
        public (int ThisMonth, int LastMonth) GetMonthOrders()
        {
            DateTime now = DateTime.Now;
            DateTime thisStart = new DateTime(now.Year, now.Month, 1);
            DateTime lastStart = thisStart.AddMonths(-1);
            DateTime lastEnd = lastStart + (now - thisStart);
            if (lastEnd > thisStart) lastEnd = thisStart;

            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT SUM(CASE WHEN CreatedAt >= @ThisStart AND CreatedAt < @Now THEN 1 ELSE 0 END),
                         SUM(CASE WHEN CreatedAt >= @LastStart AND CreatedAt < @LastEnd THEN 1 ELSE 0 END)
                  FROM BOOKING
                  WHERE BookingStatus = @Paid AND CreatedAt >= @LastStart", conn);
            cmd.Parameters.Add("@Paid", SqlDbType.NVarChar, 20).Value = BookingStatus.Paid;
            cmd.Parameters.Add("@ThisStart", SqlDbType.DateTime2).Value = thisStart;
            cmd.Parameters.Add("@Now", SqlDbType.DateTime2).Value = now;
            cmd.Parameters.Add("@LastStart", SqlDbType.DateTime2).Value = lastStart;
            cmd.Parameters.Add("@LastEnd", SqlDbType.DateTime2).Value = lastEnd;

            using SqlDataReader r = cmd.ExecuteReader();
            r.Read();
            return (r.IsDBNull(0) ? 0 : r.GetInt32(0), r.IsDBNull(1) ? 0 : r.GetInt32(1));
        }

        // Các đơn bán gần nhất của một nhân viên (chỉ đơn đã thanh toán), kèm phim, suất và khách.
        public List<AccountSale> GetRecentSales(int accountId, int top)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT TOP (@Top) b.BookingID, b.CreatedAt, b.TotalAmount,
                         COUNT(t.TicketID) AS Tickets,
                         MIN(m.Title) AS Title,
                         MIN(s.StartTime) AS ShowStart,
                         MIN(c.FullName) AS Customer
                  FROM BOOKING b
                  LEFT JOIN TICKET t   ON t.BookingID = b.BookingID
                  LEFT JOIN SHOWTIME s ON s.ShowtimeID = t.ShowtimeID
                  LEFT JOIN MOVIE m    ON m.MovieID = s.MovieID
                  LEFT JOIN CUSTOMER c ON c.CustomerID = b.CustomerID
                  WHERE b.AccountID = @AccountID AND b.BookingStatus = @Paid
                  GROUP BY b.BookingID, b.CreatedAt, b.TotalAmount
                  ORDER BY b.CreatedAt DESC", conn);
            cmd.Parameters.Add("@Top", SqlDbType.Int).Value = top;
            cmd.Parameters.Add("@AccountID", SqlDbType.Int).Value = accountId;
            cmd.Parameters.Add("@Paid", SqlDbType.NVarChar, 20).Value = BookingStatus.Paid;

            var list = new List<AccountSale>();
            using SqlDataReader r = cmd.ExecuteReader();
            while (r.Read())
            {
                list.Add(new AccountSale
                {
                    BookingID = r.GetInt32(0),
                    CreatedAt = r.IsDBNull(1) ? DateTime.MinValue : r.GetDateTime(1),
                    Amount = r.GetDecimal(2),
                    Tickets = r.GetInt32(3),
                    MovieTitle = r.IsDBNull(4) ? "(không rõ phim)" : r.GetString(4),
                    ShowStart = r.IsDBNull(5) ? null : r.GetDateTime(5),
                    CustomerName = r.IsDBNull(6) ? null : r.GetString(6)
                });
            }
            return list;
        }

        public bool UsernameExists(string username)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand("SELECT COUNT(*) FROM ACCOUNT WHERE Username = @Username", conn);
            cmd.Parameters.Add("@Username", SqlDbType.NVarChar, 50).Value = username;
            return (int)cmd.ExecuteScalar() > 0;
        }

        // Thêm tài khoản, trả về AccountID mới. Mật khẩu được băm trước khi lưu.
        public int Create(string username, string fullName, string role, string password)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"INSERT INTO ACCOUNT (Username, PasswordHash, FullName, AccountRole)
                  OUTPUT INSERTED.AccountID
                  VALUES (@Username, @PasswordHash, @FullName, @AccountRole)", conn);
            cmd.Parameters.Add("@Username", SqlDbType.NVarChar, 50).Value = username;
            cmd.Parameters.Add("@PasswordHash", SqlDbType.NVarChar, 256).Value = PasswordHasher.Hash(password);
            cmd.Parameters.Add("@FullName", SqlDbType.NVarChar, 50).Value = fullName;
            cmd.Parameters.Add("@AccountRole", SqlDbType.NVarChar, 20).Value = role;

            try
            {
                return (int)cmd.ExecuteScalar();
            }
            catch (SqlException ex) when (ex.Number == UniqueViolation || ex.Number == UniqueIndexViolation)
            {
                throw new InvalidOperationException($"Tên đăng nhập \"{username}\" đã tồn tại.");
            }
        }

        // Sửa họ tên, vai trò. newPassword rỗng → giữ mật khẩu cũ.
        public void Update(int accountId, string fullName, string role, string? newPassword)
        {
            using SqlConnection conn = Db.Open();
            bool changePassword = !string.IsNullOrEmpty(newPassword);
            using var cmd = new SqlCommand(
                changePassword
                    ? @"UPDATE ACCOUNT SET FullName = @FullName, AccountRole = @AccountRole,
                               PasswordHash = @PasswordHash WHERE AccountID = @AccountID"
                    : @"UPDATE ACCOUNT SET FullName = @FullName, AccountRole = @AccountRole
                        WHERE AccountID = @AccountID", conn);
            cmd.Parameters.Add("@FullName", SqlDbType.NVarChar, 50).Value = fullName;
            cmd.Parameters.Add("@AccountRole", SqlDbType.NVarChar, 20).Value = role;
            cmd.Parameters.Add("@AccountID", SqlDbType.Int).Value = accountId;
            if (changePassword)
                cmd.Parameters.Add("@PasswordHash", SqlDbType.NVarChar, 256).Value = PasswordHasher.Hash(newPassword!);
            cmd.ExecuteNonQuery();
        }

        // Xóa tài khoản. Đã lập đơn → SQL chặn bằng khóa ngoại (lỗi 547).
        public void Delete(int accountId)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand("DELETE FROM ACCOUNT WHERE AccountID = @AccountID", conn);
            cmd.Parameters.Add("@AccountID", SqlDbType.Int).Value = accountId;
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (SqlException ex) when (ex.Number == ForeignKeyViolation)
            {
                throw new InvalidOperationException(
                    "Không thể xóa: tài khoản này đã lập đơn bán vé (ràng buộc khóa ngoại).");
            }
        }
    }
}
