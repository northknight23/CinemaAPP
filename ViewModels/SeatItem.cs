using CinemaAPP.Helpers;

namespace CinemaAPP.ViewModels
{
    // Một ô ghế trên sơ đồ.
    public class SeatItem : ObservableObject
    {
        public int SeatID { get; init; }
        public string Label { get; init; } = "";      // ví dụ "E5"

        private bool isSold;
        public bool IsSold { get => isSold; set => SetProperty(ref isSold, value); }

        private bool isSelected;
        public bool IsSelected { get => isSelected; set => SetProperty(ref isSelected, value); }
    }
}
