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
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT AccountID, Username, PasswordHash, FullName, AccountRole
                  FROM ACCOUNT WHERE Username = @Username", conn);
            cmd.Parameters.Add("@Username", SqlDbType.NVarChar, 50).Value = username;

            using SqlDataReader r = cmd.ExecuteReader();
            if (!r.Read()) return null;                       // không có tên này

            string savedHash = r.GetString(2);
            string inputHash = PasswordHasher.Hash(password);
            if (!string.Equals(savedHash, inputHash, StringComparison.OrdinalIgnoreCase))
                return null;                                  // sai mật khẩu

            return new Account
            {
                AccountID = r.GetInt32(0),
                Username = r.GetString(1),
                FullName = r.GetString(3),
                AccountRole = r.IsDBNull(4) ? "" : r.GetString(4)
            };
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

        // Danh sách tài khoản + số đơn mỗi người đã lập (để biết có xóa được không).
        public List<Account> GetAll()
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT a.AccountID, a.Username, a.FullName, a.AccountRole,
                         (SELECT COUNT(*) FROM BOOKING b WHERE b.AccountID = a.AccountID) AS OrderCount
                  FROM ACCOUNT a
                  ORDER BY a.AccountID", conn);

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
                    OrderCount = r.GetInt32(4)
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
