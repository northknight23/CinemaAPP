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
        public int PointsEarned { get; set; }
        public int PointsUsed { get; set; }

        public string DateText => CreatedAt.ToString("dd'/'MM");
        public string AmountText => Format.Money(Amount);

        // "Suất 19:00 · 3 vé · +18 điểm" (hoặc kèm "-50 điểm" nếu có dùng điểm)
        public string MetaText
        {
            get
            {
                var parts = new List<string>();
                if (ShowStart != null) parts.Add($"Suất {ShowStart:HH:mm}");
                parts.Add($"{Tickets} vé");
                if (PointsUsed > 0) parts.Add($"-{Format.Number(PointsUsed)} điểm");
                if (PointsEarned > 0 || PointsUsed == 0) parts.Add($"+{Format.Number(PointsEarned)} điểm");
                return string.Join(" · ", parts);
            }
        }
    }
}
