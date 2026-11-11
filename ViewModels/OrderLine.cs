namespace CinemaAPP.ViewModels
{
    public enum PaymentMethod { Cash, Transfer, Card }

    // Một dòng trong "Đơn hiện tại": các ghế cùng loại gom lại, ví dụ "Vé VIP · D5, D6 | 2 vé".
    public class OrderLine
    {
        public string Title { get; init; } = "";
        public int Count { get; init; }
        public decimal Subtotal { get; init; }
    }
}
