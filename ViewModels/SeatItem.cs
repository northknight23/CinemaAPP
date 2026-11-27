using CinemaAPP.Helpers;
using CinemaAPP.Models;
namespace CinemaAPP.ViewModels
{  

    // Một ô ghế trên sơ đồ.
    public class SeatItem : ObservableObject
    {
        public int SeatID { get; init; }
        public IReadOnlyList<int> SeatIDs { get; init; } = Array.Empty<int>();
        public string RowLabel { get; init; } = "";   // ví dụ "E"
        public string NumberText { get; init; } = ""; // ví dụ "5" hoặc "1-2" (ghế đôi)
        public SeatType Type { get; init; }
        public decimal Price { get; init; }

        // Ô trống làm lối đi: giữ chỗ trên hàng nhưng không hiện, không bấm được.
        public bool IsAisle { get; init; }

        public string Label => RowLabel + NumberText;  // ví dụ "E5"

        private bool isSold;
        public bool IsSold
        {
            get => isSold;
            set
            {
                if (SetProperty(ref isSold, value))
                    OnPropertyChanged(nameof(AdminStatusText));
            }
        }

        private bool isSelected;
        public bool IsSelected { get => isSelected; set => SetProperty(ref isSelected, value); }

        public string AdminStatusText => IsSold ? $"Ghế {Label} – Đã bán" : $"Ghế {Label} – Còn trống";

        public static SeatItem Aisle() => new SeatItem { IsAisle = true };
    }
}
