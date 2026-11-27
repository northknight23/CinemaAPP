using System;
using System.Collections.Generic;
using System.Text;

namespace CinemaAPP.Models
{
    public class ShiftHandover
    {
        public int ShiftHandoverID { get; set; }
        public DateTime ShiftDate { get; set; }
        public int AccountID { get; set; }
        public decimal? ReportedCash { get; set; }
        public string? ReportNote { get; set; }
        public DateTime? ReportedAt { get; set; }
        public decimal? ConfirmedCash { get; set; }
        public string? ConfirmNote { get; set; }
        public DateTime? ConfirmedAt { get; set; }
        public int? ConfirmedBy { get; set; }
        // ---- Lấy từ bảng ACCOUNT (ShiftService JOIN sẵn) ----
        public string Username { get; set; } = "";          // ACCOUNT.Username của nhân viên
        public string FullName { get; set; } = "";          // ACCOUNT.FullName của nhân viên
        public string ConfirmedByName { get; set; } = "";   // ACCOUNT.FullName của Quản trị viên xác nhận
        public bool IsReported => ReportedAt != null;
        public bool IsConfirmed => ConfirmedAt != null;
    }
}
