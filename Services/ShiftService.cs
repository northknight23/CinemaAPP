using System.Data;
using CinemaAPP.Data;
using Microsoft.Data.SqlClient;

namespace CinemaAPP.Services
{
    public record ShiftEntry(
        DateTime ShiftDate,
        int AccountID,
        string Username,
        string FullName,
        ShiftReport? Report,
        Handover? Handover);

    // Đọc / ghi báo cáo chốt ca của nhân viên và xác nhận bàn giao của Quản trị viên trên bảng SHIFT_HANDOVER.
    public class ShiftService
    {
        public List<ShiftEntry> GetByDate(DateTime day)
        {
            DateTime shiftDate = day.Date;
            using var conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT sh.ShiftDate, a.AccountID, a.Username, a.FullName,
                         sh.ReportedCash, sh.ReportNote, sh.ReportedAt,
                         sh.ConfirmedCash, sh.ConfirmNote, sh.ConfirmedAt,
                         ISNULL(c.FullName, N'')
                  FROM SHIFT_HANDOVER sh
                  JOIN ACCOUNT a ON a.AccountID = sh.AccountID
                  LEFT JOIN ACCOUNT c ON c.AccountID = sh.ConfirmedBy
                  WHERE sh.ShiftDate = @Date
                  ORDER BY a.Username", conn);
            cmd.Parameters.Add("@Date", SqlDbType.Date).Value = shiftDate;

            var entries = new List<ShiftEntry>();
            using var reader = cmd.ExecuteReader();
            while (reader.Read())
                entries.Add(ReadEntry(reader));

            SalesDemoStore.SyncDayCache(shiftDate, entries);
            return entries;
        }

        public (ShiftReport? Report, Handover? Handover) GetForStaff(DateTime day, string username)
        {
            DateTime shiftDate = day.Date;
            using var conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT sh.ShiftDate, a.AccountID, a.Username, a.FullName,
                         sh.ReportedCash, sh.ReportNote, sh.ReportedAt,
                         sh.ConfirmedCash, sh.ConfirmNote, sh.ConfirmedAt,
                         ISNULL(c.FullName, N'')
                  FROM SHIFT_HANDOVER sh
                  JOIN ACCOUNT a ON a.AccountID = sh.AccountID
                  LEFT JOIN ACCOUNT c ON c.AccountID = sh.ConfirmedBy
                  WHERE sh.ShiftDate = @Date AND a.Username = @Username", conn);
            cmd.Parameters.Add("@Date", SqlDbType.Date).Value = shiftDate;
            cmd.Parameters.Add("@Username", SqlDbType.NVarChar, 50).Value = username;

            ShiftEntry? entry = null;
            using var reader = cmd.ExecuteReader();
            if (reader.Read())
                entry = ReadEntry(reader);

            SalesDemoStore.SyncStaffCache(shiftDate, username, entry?.Report, entry?.Handover);
            return (entry?.Report, entry?.Handover);
        }

        public ShiftReport SubmitShiftReport(DateTime day, int staffAccountId, decimal countedCash, string note)
        {
            if (countedCash < 0)
                throw new InvalidOperationException("Số tiền mặt đếm thực tế không hợp lệ.");
            string trimmedNote = (note ?? "").Trim();
            if (trimmedNote.Length > 300)
                throw new InvalidOperationException("Ghi chú chốt ca không được vượt quá 300 ký tự.");

            DateTime shiftDate = day.Date;
            using var conn = Db.Open();
            using var tx = conn.BeginTransaction(IsolationLevel.Serializable);

            string username;
            using (var accountCmd = new SqlCommand(
                "SELECT Username FROM ACCOUNT WHERE AccountID = @ID AND AccountRole = N'Staff' AND IsActive = 1", conn, tx))
            {
                accountCmd.Parameters.Add("@ID", SqlDbType.Int).Value = staffAccountId;
                object? raw = accountCmd.ExecuteScalar();
                if (raw is not string u)
                    throw new InvalidOperationException("Cần đăng nhập tài khoản nhân viên đang hoạt động để nộp chốt ca.");
                username = u;
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

            DateTime reportedAt;
            using (var insertCmd = new SqlCommand(
                @"DECLARE @Now DATETIME2 = SYSDATETIME();
                  INSERT INTO SHIFT_HANDOVER (ShiftDate, AccountID, ReportedCash, ReportNote, ReportedAt)
                  VALUES (@Date, @Account, @Cash, @Note, @Now);
                  SELECT @Now;", conn, tx))
            {
                insertCmd.Parameters.Add("@Date", SqlDbType.Date).Value = shiftDate;
                insertCmd.Parameters.Add("@Account", SqlDbType.Int).Value = staffAccountId;
                insertCmd.Parameters.Add("@Cash", SqlDbType.Money).Value = countedCash;
                insertCmd.Parameters.Add("@Note", SqlDbType.NVarChar, 300).Value = trimmedNote;
                reportedAt = (DateTime)insertCmd.ExecuteScalar()!;
            }

            tx.Commit();
            var report = new ShiftReport(countedCash, trimmedNote, reportedAt);
            SalesDemoStore.SyncStaffCache(shiftDate, username, report, null);
            return report;
        }

        public Handover ConfirmHandover(DateTime day, string staffUsername, int adminAccountId, decimal countedCash, string note)
        {
            if (countedCash < 0)
                throw new InvalidOperationException("Số tiền mặt xác nhận không hợp lệ.");
            string trimmedNote = (note ?? "").Trim();
            if (trimmedNote.Length > 300)
                throw new InvalidOperationException("Ghi chú bàn giao không được vượt quá 300 ký tự.");

            DateTime shiftDate = day.Date;
            using var conn = Db.Open();
            using var tx = conn.BeginTransaction(IsolationLevel.Serializable);

            string adminName;
            using (var adminCmd = new SqlCommand(
                "SELECT FullName FROM ACCOUNT WHERE AccountID = @ID AND AccountRole = N'Admin' AND IsActive = 1", conn, tx))
            {
                adminCmd.Parameters.Add("@ID", SqlDbType.Int).Value = adminAccountId;
                object? raw = adminCmd.ExecuteScalar();
                if (raw is not string name)
                    throw new InvalidOperationException("Chỉ tài khoản Quản trị viên đang hoạt động mới được xác nhận bàn giao.");
                adminName = name;
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

            bool exists = false;
            ShiftReport? existingReport = null;
            using (var checkCmd = new SqlCommand(
                @"SELECT ReportedCash, ReportNote, ReportedAt, ConfirmedAt
                  FROM SHIFT_HANDOVER WITH (UPDLOCK, HOLDLOCK)
                  WHERE ShiftDate = @Date AND AccountID = @Staff", conn, tx))
            {
                checkCmd.Parameters.Add("@Date", SqlDbType.Date).Value = shiftDate;
                checkCmd.Parameters.Add("@Staff", SqlDbType.Int).Value = staffAccountId;
                using var reader = checkCmd.ExecuteReader();
                if (reader.Read())
                {
                    exists = true;
                    if (!reader.IsDBNull(3))
                        throw new InvalidOperationException("Ca này đã được xác nhận bàn giao trước đó.");
                    if (!reader.IsDBNull(2))
                        existingReport = new ShiftReport(
                            reader.GetDecimal(0),
                            reader.IsDBNull(1) ? "" : reader.GetString(1),
                            reader.GetDateTime(2));
                }
            }

            DateTime confirmedAt;
            string sql = exists
                ? @"DECLARE @Now DATETIME2 = SYSDATETIME();
                    UPDATE SHIFT_HANDOVER
                    SET ConfirmedCash = @Cash, ConfirmNote = @Note, ConfirmedAt = @Now, ConfirmedBy = @Admin
                    WHERE ShiftDate = @Date AND AccountID = @Staff;
                    SELECT @Now;"
                : @"DECLARE @Now DATETIME2 = SYSDATETIME();
                    INSERT INTO SHIFT_HANDOVER (ShiftDate, AccountID, ConfirmedCash, ConfirmNote, ConfirmedAt, ConfirmedBy)
                    VALUES (@Date, @Staff, @Cash, @Note, @Now, @Admin);
                    SELECT @Now;";

            using (var saveCmd = new SqlCommand(sql, conn, tx))
            {
                saveCmd.Parameters.Add("@Date", SqlDbType.Date).Value = shiftDate;
                saveCmd.Parameters.Add("@Staff", SqlDbType.Int).Value = staffAccountId;
                saveCmd.Parameters.Add("@Cash", SqlDbType.Money).Value = countedCash;
                saveCmd.Parameters.Add("@Note", SqlDbType.NVarChar, 300).Value = trimmedNote;
                saveCmd.Parameters.Add("@Admin", SqlDbType.Int).Value = adminAccountId;
                confirmedAt = (DateTime)saveCmd.ExecuteScalar()!;
            }

            tx.Commit();
            var handover = new Handover(countedCash, trimmedNote, confirmedAt, adminName);
            SalesDemoStore.SyncStaffCache(shiftDate, staffUsername, existingReport, handover);
            return handover;
        }

        private static ShiftEntry ReadEntry(SqlDataReader reader)
        {
            ShiftReport? report = reader.IsDBNull(6)
                ? null
                : new ShiftReport(
                    reader.GetDecimal(4),
                    reader.IsDBNull(5) ? "" : reader.GetString(5),
                    reader.GetDateTime(6));

            Handover? handover = reader.IsDBNull(9)
                ? null
                : new Handover(
                    reader.GetDecimal(7),
                    reader.IsDBNull(8) ? "" : reader.GetString(8),
                    reader.GetDateTime(9),
                    reader.GetString(10));

            return new ShiftEntry(
                reader.GetDateTime(0).Date,
                reader.GetInt32(1),
                reader.GetString(2),
                reader.GetString(3),
                report,
                handover);
        }
    }
}
