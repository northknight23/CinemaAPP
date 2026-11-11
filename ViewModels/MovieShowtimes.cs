using CinemaAPP.Helpers;

namespace CinemaAPP.ViewModels
{
    // Một phim và các suất của nó trong ngày (một nhóm ở cột bên trái).
    public class MovieShowtimes : ObservableObject
    {
        public string Title { get; init; } = "";
        public string AgeRating { get; init; } = "";    // P, K, T13, T16, T18
        public string Genre { get; init; } = "";
        public int DurationMin { get; init; }
        public string? PosterPath { get; init; }        // cột MOVIE.PosterPath, chưa có thì để khung trống
        public List<ShowtimeOption> Showtimes { get; } = new List<ShowtimeOption>();

        public string InfoLine => $"{Genre} · {DurationMin} phút";

        // Nhóm có suất đang chọn thì viền xanh
        private bool isCurrent;
        public bool IsCurrent { get => isCurrent; set => SetProperty(ref isCurrent, value); }
    }
}
