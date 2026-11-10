using System.Collections.ObjectModel;

namespace CinemaAPP.ViewModels
{
    // Một hàng ghế trên sơ đồ (A, B, C...). Gồm cả các ô lối đi.
    public class SeatRowItem
    {
        public string RowLabel { get; init; } = "";
        public ObservableCollection<SeatItem> Seats { get; } = new ObservableCollection<SeatItem>();
    }
}
