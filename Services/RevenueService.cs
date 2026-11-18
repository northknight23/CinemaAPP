using System.Data;
using CinemaAPP.Data;
using CinemaAPP.Models;
using Microsoft.Data.SqlClient;

namespace CinemaAPP.Services
{
    // Mọi hàm nhận khoảng thời gian [from, to): gồm from, KHÔNG gồm to.
    // Ví dụ hôm nay: from = 11/11 00:00, to = 12/11 00:00.
    // Chỉ đơn BookingStatus = 'Paid' được tính vào doanh thu.
    public class RevenueService
    {
        public RevenueSummary GetSummary(DateTime from, DateTime to)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT
                      ISNULL(SUM(CASE WHEN b.BookingStatus = @Paid THEN b.TotalAmount END), 0),
                      COUNT(CASE WHEN b.BookingStatus = @Paid THEN 1 END),
                      COUNT(CASE WHEN b.BookingStatus = @Cancelled THEN 1 END),
                      COUNT(CASE WHEN b.BookingStatus = @Paid AND b.CustomerID IS NOT NULL THEN 1 END),
                      (SELECT COUNT(*) FROM TICKET t JOIN BOOKING b2 ON b2.BookingID = t.BookingID
                       WHERE b2.BookingStatus = @Paid AND b2.CreatedAt >= @From AND b2.CreatedAt < @To)
                  FROM BOOKING b
                  WHERE b.CreatedAt >= @From AND b.CreatedAt < @To", conn);
            AddCommonParameters(cmd, from, to);

            using SqlDataReader r = cmd.ExecuteReader();
            r.Read();
            return new RevenueSummary
            {
                Revenue = r.GetDecimal(0),
                Orders = r.GetInt32(1),
                CancelledOrders = r.GetInt32(2),
                OrdersWithCustomer = r.GetInt32(3),
                Tickets = r.GetInt32(4)
            };
        }

        // Doanh thu theo ngày (byHour = false) hoặc theo giờ (byHour = true).
        // Chỉ trả về các mốc CÓ đơn; ViewModel tự chèn các mốc bằng 0.
        public List<RevenuePoint> GetByTime(DateTime from, DateTime to, bool byHour)
        {
            string bucket = byHour
                ? "DATEADD(HOUR, DATEDIFF(HOUR, 0, b.CreatedAt), 0)"   // cắt về đầu giờ
                : "CAST(CAST(b.CreatedAt AS date) AS datetime2)";      // cắt về đầu ngày

            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                $@"SELECT {bucket} AS Bucket, SUM(b.TotalAmount)
                   FROM BOOKING b
                   WHERE b.BookingStatus = @Paid AND b.CreatedAt >= @From AND b.CreatedAt < @To
                   GROUP BY {bucket}
                   ORDER BY Bucket", conn);
            AddCommonParameters(cmd, from, to);

            var list = new List<RevenuePoint>();
            using SqlDataReader r = cmd.ExecuteReader();
            while (r.Read())
                list.Add(new RevenuePoint { Time = r.GetDateTime(0), Amount = r.GetDecimal(1) });
            return list;
        }

        // Top phim theo doanh thu vé (cộng Price của từng vé).
        public List<MovieRevenue> GetTopMovies(DateTime from, DateTime to, int top)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT TOP (@Top) m.Title, COUNT(*) AS Tickets, ISNULL(SUM(t.Price), 0) AS Amount
                  FROM TICKET t
                  JOIN BOOKING b  ON b.BookingID  = t.BookingID
                  JOIN SHOWTIME s ON s.ShowtimeID = t.ShowtimeID
                  JOIN MOVIE m    ON m.MovieID    = s.MovieID
                  WHERE b.BookingStatus = @Paid AND b.CreatedAt >= @From AND b.CreatedAt < @To
                  GROUP BY m.MovieID, m.Title
                  ORDER BY Amount DESC", conn);
            AddCommonParameters(cmd, from, to);
            cmd.Parameters.Add("@Top", SqlDbType.Int).Value = top;

            var list = new List<MovieRevenue>();
            using SqlDataReader r = cmd.ExecuteReader();
            while (r.Read())
                list.Add(new MovieRevenue { Title = r.GetString(0), Tickets = r.GetInt32(1), Amount = r.GetDecimal(2) });
            return list;
        }

        // Doanh thu theo nhân viên lập đơn.
        public List<StaffRevenue> GetByStaff(DateTime from, DateTime to)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT a.Username, a.FullName,
                         COUNT(*) AS Orders,
                         ISNULL(SUM(tc.Cnt), 0) AS Tickets,
                         SUM(b.TotalAmount) AS Amount
                  FROM BOOKING b
                  JOIN ACCOUNT a ON a.AccountID = b.AccountID
                  LEFT JOIN (SELECT BookingID, COUNT(*) AS Cnt FROM TICKET GROUP BY BookingID) tc
                         ON tc.BookingID = b.BookingID
                  WHERE b.BookingStatus = @Paid AND b.CreatedAt >= @From AND b.CreatedAt < @To
                  GROUP BY a.AccountID, a.Username, a.FullName
                  ORDER BY Amount DESC", conn);
            AddCommonParameters(cmd, from, to);

            var list = new List<StaffRevenue>();
            using SqlDataReader r = cmd.ExecuteReader();
            while (r.Read())
            {
                list.Add(new StaffRevenue
                {
                    Username = r.GetString(0),
                    FullName = r.GetString(1),
                    Orders = r.GetInt32(2),
                    Tickets = r.GetInt32(3),
                    Amount = r.GetDecimal(4)
                });
            }
            return list;
        }

        private static void AddCommonParameters(SqlCommand cmd, DateTime from, DateTime to)
        {
            cmd.Parameters.Add("@From", SqlDbType.DateTime2).Value = from;
            cmd.Parameters.Add("@To", SqlDbType.DateTime2).Value = to;
            cmd.Parameters.Add("@Paid", SqlDbType.NVarChar, 20).Value = BookingStatus.Paid;
            cmd.Parameters.Add("@Cancelled", SqlDbType.NVarChar, 20).Value = BookingStatus.Cancelled;
        }
    }
}
