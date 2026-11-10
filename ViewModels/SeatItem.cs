using CinemaAPP.Helpers;

namespace CinemaAPP.ViewModels
{
    // Loại ghế: quyết định màu trên sơ đồ và giá vé.
    public enum SeatType { Standard, Vip, Couple }

    // Một ô ghế trên sơ đồ.
    public class SeatItem : ObservableObject
    {
        public int SeatID { get; init; }
        public string RowLabel { get; init; } = "";   // ví dụ "E"
        public string NumberText { get; init; } = ""; // chữ hiện trên ô, ví dụ "5" hoặc "1-2" (ghế đôi)
        public SeatType Type { get; init; }
        public decimal Price { get; init; }

        // Ô trống làm lối đi: giữ chỗ trên hàng nhưng không hiện, không bấm được.
        public bool IsAisle { get; init; }

        public string Label => RowLabel + NumberText;  // ví dụ "E5"

        private bool isSold;
        public bool IsSold { get => isSold; set => SetProperty(ref isSold, value); }

        private bool isSelected;
        public bool IsSelected { get => isSelected; set => SetProperty(ref isSelected, value); }

        public static SeatItem Aisle() => new SeatItem { IsAisle = true };
    }
}
