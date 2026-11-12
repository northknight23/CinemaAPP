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

        // Danh sách khách + thống kê mua vé.
        // OrderCount đếm MỌI đơn (kể cả đơn hủy) vì đơn nào cũng làm khóa ngoại chặn xóa;
        // TotalSpent và LastPurchase chỉ tính đơn đã thanh toán.
        public List<Customer> GetAll()
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT c.CustomerID, c.FullName, c.Phone, c.Points,
                         COUNT(b.BookingID) AS OrderCount,
                         ISNULL(SUM(CASE WHEN b.BookingStatus = @Paid THEN b.TotalAmount END), 0) AS TotalSpent,
                         MAX(CASE WHEN b.BookingStatus = @Paid THEN b.CreatedAt END) AS LastPurchase
                  FROM CUSTOMER c
                  LEFT JOIN BOOKING b ON b.CustomerID = c.CustomerID
                  GROUP BY c.CustomerID, c.FullName, c.Phone, c.Points
                  ORDER BY c.CustomerID", conn);
            cmd.Parameters.Add("@Paid", SqlDbType.NVarChar, 20).Value = BookingStatus.Paid;

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
                    TotalSpent = r.GetDecimal(5),
                    LastPurchase = r.IsDBNull(6) ? null : r.GetDateTime(6)
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
