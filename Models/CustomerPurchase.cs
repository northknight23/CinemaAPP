namespace CinemaAPP.Models
{
    // Một lần mua vé của khách (dùng cho mục "Mua gần đây" trong hồ sơ khách)
    public class CustomerPurchase
    {
        public int BookingID { get; set; }
        public DateTime CreatedAt { get; set; }
        public string MovieTitle { get; set; } = "";
        public DateTime? ShowStart { get; set; }
        public int Tickets { get; set; }
        public decimal Amount { get; set; }

        public string DateText => CreatedAt.ToString("dd'/'MM");
        public string AmountText => Format.Money(Amount);

        // "Suất 19:00 · 3 vé · +30 điểm"
        public string MetaText
        {
            get
            {
                string show = ShowStart != null ? $"Suất {ShowStart:HH:mm} · " : "";
                return $"{show}{Tickets} vé · +{Format.Number((int)(Amount / 10_000m))} điểm";
            }
        }
    }
}
