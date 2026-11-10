namespace CinemaAPP.ViewModels
{
    // Một thẻ trong hộp thoại "Chi tiết loại ghế".
    public class SeatTypeInfo
    {
        public SeatType Type { get; init; }
        public string Name { get; init; } = "";
        public string Position { get; init; } = "";     // ví dụ "Hàng D – H"
        public string Description { get; init; } = "";
        public decimal Price { get; init; }
        public string ColorHex { get; init; } = "";     // màu của loại ghế, trùng với sơ đồ
        public string ImagePath { get; init; } = "";    // ảnh thật của loại ghế (Assets/Seats)
    }
}
