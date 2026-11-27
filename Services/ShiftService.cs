using System.Data;
using CinemaAPP.Data;
using Microsoft.Data.SqlClient;
using CinemaAPP.Models;
namespace CinemaAPP.Services
{
    

    // Đọc / ghi báo cáo chốt ca của nhân viên và xác nhận bàn giao của Quản trị viên trên bảng SHIFT_HANDOVER.
    public class ShiftService
    {
        private const string SelectSql =
    @"SELECT sh.ShiftHandoverID, sh.ShiftDate, sh.AccountID,
                     sh.ReportedCash, sh.ReportNote, sh.ReportedAt,
                     sh.ConfirmedCash, sh.ConfirmNote, sh.ConfirmedAt, sh.ConfirmedBy,
                     a.Username, a.FullName, ISNULL(c.FullName, N'')
              FROM SHIFT_HANDOVER sh
              JOIN ACCOUNT a ON a.AccountID = sh.AccountID
              LEFT JOIN ACCOUNT c ON c.AccountID = sh.ConfirmedBy";
        // Đọc một dòng theo đúng thứ tự cột của SelectSql.
        private static ShiftHandover Read(SqlDataReader r) => new ShiftHandover
        {
            ShiftHandoverID = r.GetInt32(0),
            ShiftDate = r.GetDateTime(1),
            AccountID = r.GetInt32(2),
            ReportedCash = r.IsDBNull(3) ? null : r.GetDecimal(3),
            ReportNote = r.IsDBNull(4) ? null : r.GetString(4),
            ReportedAt = r.IsDBNull(5) ? null : r.GetDateTime(5),
            ConfirmedCash = r.IsDBNull(6) ? null : r.GetDecimal(6),
            ConfirmNote = r.IsDBNull(7) ? null : r.GetString(7),
            ConfirmedAt = r.IsDBNull(8) ? null : r.GetDateTime(8),
            ConfirmedBy = r.IsDBNull(9) ? null : r.GetInt32(9),
            Username = r.GetString(10),
            FullName = r.GetString(11),
            ConfirmedByName = r.GetString(12),
        };
        // Mọi ca có báo cáo hoặc bàn giao trong một ngày (màn Giao dịch & Đối soát).
        public List<ShiftHandover> GetByDate(DateTime day)
        {
            using var conn = Db.Open();
            using var cmd = new SqlCommand(SelectSql + " WHERE sh.ShiftDate = @Date ORDER BY a.Username", conn);
            cmd.Parameters.Add("@Date", SqlDbType.Date).Value = day.Date;

            var list = new List<ShiftHandover>();
            using var reader = cmd.ExecuteReader();
            while (reader.Read())
                list.Add(Read(reader));
            return list;
        }

        // Ca của một nhân viên trong ngày. null = chưa có dòng nào = ca đang mở.
        public ShiftHandover? GetForStaff(DateTime day, string username)
        {
            using var conn = Db.Open();
            using var cmd = new SqlCommand(SelectSql + " WHERE sh.ShiftDate = @Date AND a.Username = @Username", conn);
            cmd.Parameters.Add("@Date", SqlDbType.Date).Value = day.Date;
            cmd.Parameters.Add("@Username", SqlDbType.NVarChar, 50).Value = username;

            using var reader = cmd.ExecuteReader();
            return reader.Read() ? Read(reader) : null;
        }

        public void SubmitShiftReport(DateTime day, int staffAccountId, decimal countedCash, string note)
        {
            if (countedCash < 0)
                throw new InvalidOperationException("Số tiền mặt đếm thực tế không hợp lệ.");
            string trimmedNote = (note ?? "").Trim();
            if (trimmedNote.Length > 300)
                throw new InvalidOperationException("Ghi chú chốt ca không được vượt quá 300 ký tự.");

            DateTime shiftDate = day.Date;
            using var conn = Db.Open();
            using var tx = conn.BeginTransaction(IsolationLevel.Serializable);

            
            using (var accountCmd = new SqlCommand(
                "SELECT 1 FROM ACCOUNT WHERE AccountID = @ID AND AccountRole = N'Staff' AND IsActive = 1", conn, tx))
            {
                accountCmd.Parameters.Add("@ID", SqlDbType.Int).Value = staffAccountId;

                if (accountCmd.ExecuteScalar() == null)
                    throw new InvalidOperationException("Cần đăng nhập tài khoản nhân viên đang hoạt động để nộp chốt ca.");
            }

            using (var checkCmd = new SqlCommand(
                @"SELECT ReportedAt, ConfirmedAt
                  FROM SHIFT_HANDOVER WITH (UPDLOCK, HOLDLOCK)
                  WHERE ShiftDate = @Date AND AccountID = @Account", conn, tx))
            {
                checkCmd.Parameters.Add("@Date", SqlDbType.Date).Value = shiftDate;
                checkCmd.Parameters.Add("@Account", SqlDbType.Int).Value = staffAccountId;
                using var reader = checkCmd.ExecuteReader();
                if (reader.Read())
                {
                    if (!reader.IsDBNull(1))
                        throw new InvalidOperationException("Ca này đã được Quản trị viên xác nhận bàn giao.");
                    if (!reader.IsDBNull(0))
                        throw new InvalidOperationException("Ca này đã nộp báo cáo chốt ca trước đó.");
                }
            }

            using (var insertCmd = new SqlCommand(
        @"INSERT INTO SHIFT_HANDOVER (ShiftDate, AccountID, ReportedCash, ReportNote, ReportedAt)
          VALUES (@Date, @Account, @Cash, @Note, SYSDATETIME())", conn, tx))
            {
                insertCmd.Parameters.Add("@Date", SqlDbType.Date).Value = shiftDate;
                insertCmd.Parameters.Add("@Account", SqlDbType.Int).Value = staffAccountId;
                insertCmd.Parameters.Add("@Cash", SqlDbType.Money).Value = countedCash;
                insertCmd.Parameters.Add("@Note", SqlDbType.NVarChar, 300).Value = trimmedNote;
                insertCmd.ExecuteNonQuery();
            }

            tx.Commit();
        }

        public void ConfirmHandover(DateTime day, string staffUsername, int adminAccountId, decimal countedCash, string note)
        {
            if (countedCash < 0)
                throw new InvalidOperationException("Số tiền mặt xác nhận không hợp lệ.");
            string trimmedNote = (note ?? "").Trim();
            if (trimmedNote.Length > 300)
                throw new InvalidOperationException("Ghi chú bàn giao không được vượt quá 300 ký tự.");

            DateTime shiftDate = day.Date;
            using var conn = Db.Open();
            using var tx = conn.BeginTransaction(IsolationLevel.Serializable);

            using (var adminCmd = new SqlCommand(
                "SELECT 1 FROM ACCOUNT WHERE AccountID = @ID AND AccountRole = N'Admin' AND IsActive = 1", conn, tx))
            {
                adminCmd.Parameters.Add("@ID", SqlDbType.Int).Value = adminAccountId;
                if (adminCmd.ExecuteScalar() == null)
                    throw new InvalidOperationException("Chỉ tài khoản Quản trị viên đang hoạt động mới được xác nhận bàn giao.");
            }

            int staffAccountId;
            using (var staffCmd = new SqlCommand(
                "SELECT AccountID FROM ACCOUNT WHERE Username = @Username", conn, tx))
            {
                staffCmd.Parameters.Add("@Username", SqlDbType.NVarChar, 50).Value = staffUsername;
                object? raw = staffCmd.ExecuteScalar();
                if (raw is not int id)
                    throw new InvalidOperationException("Không tìm thấy tài khoản nhân viên cần đối soát.");
                staffAccountId = id;
            }

            bool exists;
            using (var checkCmd = new SqlCommand(
                @"SELECT ConfirmedAt FROM SHIFT_HANDOVER WITH (UPDLOCK, HOLDLOCK)
                  WHERE ShiftDate = @Date AND AccountID = @Staff", conn, tx))
            {
                checkCmd.Parameters.Add("@Date", SqlDbType.Date).Value = shiftDate;
                checkCmd.Parameters.Add("@Staff", SqlDbType.Int).Value = staffAccountId;
                using var reader = checkCmd.ExecuteReader();
                exists = reader.Read();                          // có dòng chưa? (nhân viên đã nộp báo cáo)
                if (exists && !reader.IsDBNull(0))
                    throw new InvalidOperationException("Ca này đã được xác nhận bàn giao trước đó.");
            }

            string sql = exists
                    ? @"UPDATE SHIFT_HANDOVER
                    SET ConfirmedCash = @Cash, ConfirmNote = @Note, ConfirmedAt = SYSDATETIME(), ConfirmedBy = @Admin
                    WHERE ShiftDate = @Date AND AccountID = @Staff"
                    : @"INSERT INTO SHIFT_HANDOVER (ShiftDate, AccountID, ConfirmedCash, ConfirmNote, ConfirmedAt, ConfirmedBy)
                    VALUES (@Date, @Staff, @Cash, @Note, SYSDATETIME(), @Admin)";

            using (var saveCmd = new SqlCommand(sql, conn, tx))
            {
                saveCmd.Parameters.Add("@Date", SqlDbType.Date).Value = shiftDate;
                saveCmd.Parameters.Add("@Staff", SqlDbType.Int).Value = staffAccountId;
                saveCmd.Parameters.Add("@Cash", SqlDbType.Money).Value = countedCash;
                saveCmd.Parameters.Add("@Note", SqlDbType.NVarChar, 300).Value = trimmedNote;
                saveCmd.Parameters.Add("@Admin", SqlDbType.Int).Value = adminAccountId;
                saveCmd.ExecuteNonQuery();
            }

            tx.Commit();
      
        }

    }
}
