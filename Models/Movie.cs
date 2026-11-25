using System;
using System.Windows.Media;
using CinemaAPP.Helpers;

namespace CinemaAPP.Models
{
    public class Movie : ObservableObject
    {
        private int movieId;
        private string title = "";
        private int durationMin;
        private string genre = "";
        private string ageRating = "P";
        private string movieStatus = "Đang chiếu";
        private DateTime? releaseDate;
        private string? posterPath;
        private string? movieDescription;

        // ---- Cột của bảng MOVIE trong CSDL ----
        public int MovieID
        {
            get => movieId;
            set => SetProperty(ref movieId, value);
        }

        public string Title
        {
            get => title;
            set => SetProperty(ref title, value);
        }

        public int DurationMin
        {
            get => durationMin;
            set
            {
                if (SetProperty(ref durationMin, value))
                    OnPropertyChanged(nameof(InfoLine));
            }
        }

        public string Genre
        {
            get => genre;
            set
            {
                if (SetProperty(ref genre, value))
                    OnPropertyChanged(nameof(InfoLine));
            }
        }

        public string AgeRating
        {
            get => ageRating;
            set => SetProperty(ref ageRating, value);
        }

        public string MovieStatus
        {
            get => movieStatus;
            set => SetProperty(ref movieStatus, value);
        }

        public DateTime? ReleaseDate
        {
            get => releaseDate;
            set
            {
                if (SetProperty(ref releaseDate, value))
                    OnPropertyChanged(nameof(ReleaseDateText));
            }
        }

        public string? PosterPath
        {
            get => posterPath;
            set
            {
                if (SetProperty(ref posterPath, value))
                    OnPropertyChanged(nameof(PosterSource));
            }
        }

        public string? MovieDescription
        {
            get => movieDescription;
            set => SetProperty(ref movieDescription, value);
        }

        // ---- Thuộc tính hiển thị ----
        public string InfoLine => string.IsNullOrWhiteSpace(Genre)
            ? $"{DurationMin} phút"
            : $"{Genre} · {DurationMin} phút";

        public string ReleaseDateText => ReleaseDate?.ToString("dd'/'MM'/'yyyy") ?? "—";

        public ImageSource? PosterSource => PosterLoader.Load(PosterPath);
    }
}
