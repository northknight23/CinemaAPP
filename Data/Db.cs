using Microsoft.Data.SqlClient;

namespace CinemaAPP.Data
{
    // Nơi DUY NHẤT chứa chuỗi kết nối CSDL.
    public static class Db
    {
        // Máy dùng SQLEXPRESS: đặt biến môi trường CINEMADB_CONN thay vì sửa file này.
        private const string DefaultConnectionString =
            @"Server=localhost;Database=CINEMADB;Trusted_Connection=True;TrustServerCertificate=True;Connect Timeout=5;";

        public static string ConnectionString =>
            Environment.GetEnvironmentVariable("CINEMADB_CONN") ?? DefaultConnectionString;

        public static SqlConnection Open()
        {
            var conn = new SqlConnection(ConnectionString);
            conn.Open();
            return conn;
        }
    }
}