using System;
using System.Collections.Generic;
using System.Text;

namespace CinemaAPP.Models
{
    public enum TicketStatus
    {
        Active,
        Cancelled
    }
    public class Ticket
    {
        public int TicketID { get; set; }
        public int BookingID { get; set; }
        public int ShowtimeID { get; set; }
        public int RoomID { get; set; }
        public int SeatID { get; set; }
        public decimal Price { get; set; }
        public TicketStatus TicketStatus { get; set; } = TicketStatus.Active;
    }
}
