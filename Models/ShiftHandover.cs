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
        public bool IsReported => ReportedAt != null;
        public bool IsConfirmed => ConfirmedAt != null;
    }
}
