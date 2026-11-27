using System;
using System.Collections.Generic;
using System.Text;

namespace CinemaAPP.Models
{
    public enum SeatType
    {
        Standard,
        Vip,
        Couple
    }
    public class Seat
    {
        public int SeatID { get; set; }
        public int RoomID { get; set; }
        public string RowLabel { get; set; } = "";
        public int SeatNumber { get; set; }
        public SeatType SeatType { get; set; } = SeatType.Standard;
    }
}
