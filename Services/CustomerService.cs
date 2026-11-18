using System.Data;
using CinemaAPP.Data;
using CinemaAPP.Models;
using Microsoft.Data.SqlClient;

namespace CinemaAPP.Services
{
    public class CustomerService
    {
        private const int ForeignKeyViolation = 547;
        private const int UniqueViolation = 2627;
        private const int UniqueIndexViolation = 2601;

        // Ngày đầu tháng hiện tại: mốc để so sánh "tháng này" với "tới hết tháng trước"
        public static DateTime MonthStart => new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1);

        // Danh sách khách + thống kê mua vé.
        // OrderCount đếm MỌI đơn (kể cả đơn hủy) vì đơn nào cũng làm khóa ngoại chặn xóa;
        // các cột còn lại chỉ tính đơn đã thanh toán.
        // SpentBeforeMonth / PaidOrdersBeforeMonth: số liệu tính tới đầu tháng này, để thẻ số liệu so với tháng trước.
        public List<Customer> GetAll()
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT c.CustomerID, c.FullName, c.Phone, c.Points,
                         COUNT(b.BookingID) AS OrderCount,
                         SUM(CASE WHEN b.BookingStatus = @Paid THEN 1 ELSE 0 END) AS PaidOrders,
                         ISNULL(SUM(CASE WHEN b.BookingStatus = @Paid THEN b.TotalAmount END), 0) AS TotalSpent,
                         MAX(CASE WHEN b.BookingStatus = @Paid THEN b.CreatedAt END) AS LastPurchase,
                         MIN(CASE WHEN b.BookingStatus = @Paid THEN b.CreatedAt END) AS FirstPurchase,
                         ISNULL(SUM(CASE WHEN b.BookingStatus = @Paid AND b.CreatedAt < @MonthStart THEN b.TotalAmount END), 0) AS SpentBeforeMonth,
                         SUM(CASE WHEN b.BookingStatus = @Paid AND b.CreatedAt < @MonthStart THEN 1 ELSE 0 END) AS PaidOrdersBeforeMonth
                  FROM CUSTOMER c
                  LEFT JOIN BOOKING b ON b.CustomerID = c.CustomerID
                  GROUP BY c.CustomerID, c.FullName, c.Phone, c.Points
                  ORDER BY c.CustomerID", conn);
            cmd.Parameters.Add("@Paid", SqlDbType.NVarChar, 20).Value = BookingStatus.Paid;
            cmd.Parameters.Add("@MonthStart", SqlDbType.DateTime2).Value = MonthStart;

            var list = new List<Customer>();
            using SqlDataReader r = cmd.ExecuteReader();
            while (r.Read())
            {
                list.Add(new Customer
                {
                    CustomerID = r.GetInt32(0),
                    FullName = r.GetString(1),
                    Phone = r.GetString(2),
                    Points = r.GetInt32(3),
                    OrderCount = r.GetInt32(4),
                    PaidOrders = r.GetInt32(5),
                    TotalSpent = r.GetDecimal(6),
                    LastPurchase = r.IsDBNull(7) ? null : r.GetDateTime(7),
                    FirstPurchase = r.IsDBNull(8) ? null : r.GetDateTime(8),
                    SpentBeforeMonth = r.GetDecimal(9),
                    PaidOrdersBeforeMonth = r.GetInt32(10)
                });
            }
            return list;
        }

        // Doanh thu từ khách thành viên (đơn có CustomerID):
        // tháng này (từ ngày 1 tới giờ) và CÙNG SỐ NGÀY của tháng trước, để so sánh công bằng.
        public (decimal ThisMonth, decimal LastMonth) GetMemberRevenue()
        {
            DateTime now = DateTime.Now;
            DateTime thisStart = MonthStart;
            DateTime lastStart = thisStart.AddMonths(-1);
            DateTime lastEnd = lastStart + (now - thisStart);
            if (lastEnd > thisStart) lastEnd = thisStart;

            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT ISNULL(SUM(CASE WHEN CreatedAt >= @ThisStart AND CreatedAt < @Now THEN TotalAmount END), 0),
                         ISNULL(SUM(CASE WHEN CreatedAt >= @LastStart AND CreatedAt < @LastEnd THEN TotalAmount END), 0)
                  FROM BOOKING
                  WHERE CustomerID IS NOT NULL AND BookingStatus = @Paid AND CreatedAt >= @LastStart", conn);
            cmd.Parameters.Add("@Paid", SqlDbType.NVarChar, 20).Value = BookingStatus.Paid;
            cmd.Parameters.Add("@ThisStart", SqlDbType.DateTime2).Value = thisStart;
            cmd.Parameters.Add("@Now", SqlDbType.DateTime2).Value = now;
            cmd.Parameters.Add("@LastStart", SqlDbType.DateTime2).Value = lastStart;
            cmd.Parameters.Add("@LastEnd", SqlDbType.DateTime2).Value = lastEnd;

            using SqlDataReader r = cmd.ExecuteReader();
            r.Read();
            return (r.GetDecimal(0), r.GetDecimal(1));
        }

        // Các lần mua gần nhất của một khách (chỉ đơn đã thanh toán), kèm tên phim và giờ suất chiếu.
        public List<CustomerPurchase> GetRecentPurchases(int customerId, int top)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT TOP (@Top) b.BookingID, b.CreatedAt, b.TotalAmount,
                         COUNT(t.TicketID) AS Tickets,
                         MIN(m.Title) AS Title,
                         MIN(s.StartTime) AS ShowStart
                  FROM BOOKING b
                  LEFT JOIN TICKET t   ON t.BookingID = b.BookingID
                  LEFT JOIN SHOWTIME s ON s.ShowtimeID = t.ShowtimeID
                  LEFT JOIN MOVIE m    ON m.MovieID = s.MovieID
                  WHERE b.CustomerID = @CustomerID AND b.BookingStatus = @Paid
                  GROUP BY b.BookingID, b.CreatedAt, b.TotalAmount
                  ORDER BY b.CreatedAt DESC", conn);
            cmd.Parameters.Add("@Top", SqlDbType.Int).Value = top;
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = customerId;
            cmd.Parameters.Add("@Paid", SqlDbType.NVarChar, 20).Value = BookingStatus.Paid;

            var list = new List<CustomerPurchase>();
            using SqlDataReader r = cmd.ExecuteReader();
            while (r.Read())
            {
                list.Add(new CustomerPurchase
                {
                    BookingID = r.GetInt32(0),
                    CreatedAt = r.IsDBNull(1) ? DateTime.MinValue : r.GetDateTime(1),
                    Amount = r.GetDecimal(2),
                    Tickets = r.GetInt32(3),
                    MovieTitle = r.IsDBNull(4) ? "(không rõ phim)" : r.GetString(4),
                    ShowStart = r.IsDBNull(5) ? null : r.GetDateTime(5)
                });
            }
            return list;
        }

        // Màn bán vé (C) dùng để tra khách theo số điện thoại. Không thấy → null.
        public Customer? FindByPhone(string phone)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                "SELECT CustomerID, FullName, Phone, Points FROM CUSTOMER WHERE Phone = @Phone", conn);
            cmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 15).Value = phone;

            using SqlDataReader r = cmd.ExecuteReader();
            if (!r.Read()) return null;
            return new Customer
            {
                CustomerID = r.GetInt32(0),
                FullName = r.GetString(1),
                Phone = r.GetString(2),
                Points = r.GetInt32(3)
            };
        }

        // Thêm khách (điểm bắt đầu = 0 nhờ DEFAULT của cột Points). Trả về CustomerID mới.
        public int Create(string fullName, string phone)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"INSERT INTO CUSTOMER (FullName, Phone)
                  OUTPUT INSERTED.CustomerID
                  VALUES (@FullName, @Phone)", conn);
            cmd.Parameters.Add("@FullName", SqlDbType.NVarChar, 100).Value = fullName;
            cmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 15).Value = phone;

            try
            {
                return (int)cmd.ExecuteScalar();
            }
            catch (SqlException ex) when (ex.Number == UniqueViolation || ex.Number == UniqueIndexViolation)
            {
                throw new InvalidOperationException("Số điện thoại này đã thuộc về khách khác.");
            }
        }

        // Sửa họ tên, số điện thoại. Điểm không sửa ở đây (màn bán vé tự cộng).
        public void Update(int customerId, string fullName, string phone)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"UPDATE CUSTOMER SET FullName = @FullName, Phone = @Phone
                  WHERE CustomerID = @CustomerID", conn);
            cmd.Parameters.Add("@FullName", SqlDbType.NVarChar, 100).Value = fullName;
            cmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 15).Value = phone;
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = customerId;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (SqlException ex) when (ex.Number == UniqueViolation || ex.Number == UniqueIndexViolation)
            {
                throw new InvalidOperationException("Số điện thoại này đã thuộc về khách khác.");
            }
        }

        // Xóa khách. Đã có đơn → SQL chặn bằng khóa ngoại (lỗi 547).
        public void Delete(int customerId)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand("DELETE FROM CUSTOMER WHERE CustomerID = @CustomerID", conn);
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = customerId;
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (SqlException ex) when (ex.Number == ForeignKeyViolation)
            {
                throw new InvalidOperationException(
                    "Không thể xóa: khách đã có đơn mua vé (ràng buộc khóa ngoại).");
            }
        }
    }
}
