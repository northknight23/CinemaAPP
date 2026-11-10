using System.Data;
using CinemaAPP.Data;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using Microsoft.Data.SqlClient;

namespace CinemaAPP.Services
{
    public class AccountService
    {
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
    }
}