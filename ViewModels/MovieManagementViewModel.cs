using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using CinemaAPP.Services;

namespace CinemaAPP.ViewModels
{
    public class MovieManagementViewModel : ObservableObject
    {
        private readonly MovieService service = new();
        private List<Movie> allMovies = new();
        private Movie? editingMovie;

        public ObservableCollection<Movie> FilteredMovies { get; } = new();

        // ================= Tìm kiếm & Lọc =================
        private string searchText = "";
        public string SearchText
        {
            get => searchText;
            set
            {
                if (SetProperty(ref searchText, value))
                    ApplyFilter();
            }
        }

        private string filterStatus = "All"; // All | NowShowing | ComingSoon | Ended
        public string FilterStatus
        {
            get => filterStatus;
            set
            {
                if (SetProperty(ref filterStatus, value))
                {
                    OnPropertyChanged(nameof(IsFilterAll));
                    OnPropertyChanged(nameof(IsFilterNowShowing));
                    OnPropertyChanged(nameof(IsFilterComingSoon));
                    OnPropertyChanged(nameof(IsFilterEnded));
                    ApplyFilter();
                }
            }
        }

        public bool IsFilterAll => FilterStatus == "All";
        public bool IsFilterNowShowing => FilterStatus == "NowShowing";
        public bool IsFilterComingSoon => FilterStatus == "ComingSoon";
        public bool IsFilterEnded => FilterStatus == "Ended";

        public string CountAllText => $"Tất cả ({allMovies.Count})";
        public string CountNowShowingText => $"Đang chiếu ({allMovies.Count(m => m.MovieStatus == "Đang chiếu")})";
        public string CountComingSoonText => $"Sắp chiếu ({allMovies.Count(m => m.MovieStatus == "Sắp chiếu")})";
        public string CountEndedText => $"Ngừng chiếu ({allMovies.Count(m => m.MovieStatus == "Ngừng chiếu")})";

        // ================= Form Thêm / Sửa =================
        private bool isEditorOpen;
        public bool IsEditorOpen
        {
            get => isEditorOpen;
            set => SetProperty(ref isEditorOpen, value);
        }

        private string editorTitle = "Thêm phim mới";
        public string EditorTitle
        {
            get => editorTitle;
            set => SetProperty(ref editorTitle, value);
        }

        private string formTitle = "";
        public string FormTitle
        {
            get => formTitle;
            set { if (SetProperty(ref formTitle, value)) TitleError = ""; }
        }

        private string formGenre = "";
        public string FormGenre
        {
            get => formGenre;
            set => SetProperty(ref formGenre, value);
        }

        private int formDuration = 100;
        public int FormDuration
        {
            get => formDuration;
            set { if (SetProperty(ref formDuration, value)) DurationError = ""; }
        }

        private string formAgeRating = "P";
        public string FormAgeRating
        {
            get => formAgeRating;
            set => SetProperty(ref formAgeRating, value);
        }

        private string formMovieStatus = "Đang chiếu";
        public string FormMovieStatus
        {
            get => formMovieStatus;
            set => SetProperty(ref formMovieStatus, value);
        }

        private DateTime formReleaseDate = DateTime.Today;
        public DateTime FormReleaseDate
        {
            get => formReleaseDate;
            set => SetProperty(ref formReleaseDate, value);
        }

        private string formDescription = "";
        public string FormDescription
        {
            get => formDescription;
            set => SetProperty(ref formDescription, value);
        }

        private string formPosterPath = "";
        public string FormPosterPath
        {
            get => formPosterPath;
            set => SetProperty(ref formPosterPath, value);
        }

        private string titleError = "";
        public string TitleError
        {
            get => titleError;
            set { if (SetProperty(ref titleError, value)) OnPropertyChanged(nameof(HasTitleError)); }
        }
        public bool HasTitleError => titleError.Length > 0;

        private string durationError = "";
        public string DurationError
        {
            get => durationError;
            set { if (SetProperty(ref durationError, value)) OnPropertyChanged(nameof(HasDurationError)); }
        }
        public bool HasDurationError => durationError.Length > 0;

        public List<string> AgeRatingOptions { get; } = new() { "P", "T13", "T16", "T18" };
        public List<string> MovieStatusOptions { get; } = new() { "Đang chiếu", "Sắp chiếu", "Ngừng chiếu" };

        // ================= Lệnh =================
        public ICommand SetFilterCommand { get; }
        public ICommand NewMovieCommand { get; }
        public ICommand EditMovieCommand { get; }
        public ICommand DeleteMovieCommand { get; }
        public ICommand SaveCommand { get; }
        public ICommand CancelCommand { get; }
        public ICommand ReloadCommand { get; }

        public MovieManagementViewModel()
        {
            SetFilterCommand = new RelayCommand(p =>
            {
                if (p is string st)
                    FilterStatus = st;
            });

            NewMovieCommand = new RelayCommand(_ => OpenNewForm());

            EditMovieCommand = new RelayCommand(p =>
            {
                if (p is Movie m)
                    OpenEditForm(m);
            });

            DeleteMovieCommand = new RelayCommand(p =>
            {
                if (p is Movie m)
                    DeleteMovie(m);
            });

            SaveCommand = new RelayCommand(_ => SaveMovie());
            CancelCommand = new RelayCommand(_ => IsEditorOpen = false);
            ReloadCommand = new RelayCommand(async _ => await LoadDataAsync());

            _ = LoadDataAsync();
        }

        public async Task LoadDataAsync()
        {
            allMovies = await Task.Run(() => service.GetAll());
            UpdateCounts();
            ApplyFilter();
        }

        private void UpdateCounts()
        {
            OnPropertyChanged(nameof(CountAllText));
            OnPropertyChanged(nameof(CountNowShowingText));
            OnPropertyChanged(nameof(CountComingSoonText));
            OnPropertyChanged(nameof(CountEndedText));
        }

        private void ApplyFilter()
        {
            var query = allMovies.AsEnumerable();

            if (!string.IsNullOrWhiteSpace(SearchText))
            {
                var term = SearchText.Trim().ToLower();
                query = query.Where(m =>
                    (m.Title != null && m.Title.ToLower().Contains(term)) ||
                    (m.Genre != null && m.Genre.ToLower().Contains(term)));
            }

            if (FilterStatus == "NowShowing")
                query = query.Where(m => m.MovieStatus == "Đang chiếu");
            else if (FilterStatus == "ComingSoon")
                query = query.Where(m => m.MovieStatus == "Sắp chiếu");
            else if (FilterStatus == "Ended")
                query = query.Where(m => m.MovieStatus == "Ngừng chiếu");

            FilteredMovies.Clear();
            foreach (var m in query)
            {
                FilteredMovies.Add(m);
            }
        }

        private void OpenNewForm()
        {
            editingMovie = null;
            EditorTitle = "Thêm phim mới";
            FormTitle = "";
            FormGenre = "Hành động";
            FormDuration = 100;
            FormAgeRating = "P";
            FormMovieStatus = "Đang chiếu";
            FormReleaseDate = DateTime.Today;
            FormDescription = "";
            FormPosterPath = "";
            TitleError = "";
            DurationError = "";
            IsEditorOpen = true;
        }

        private void OpenEditForm(Movie m)
        {
            editingMovie = m;
            EditorTitle = "Chỉnh sửa thông tin phim";
            FormTitle = m.Title;
            FormGenre = m.Genre;
            FormDuration = m.DurationMin;
            FormAgeRating = m.AgeRating;
            FormMovieStatus = m.MovieStatus;
            FormReleaseDate = m.ReleaseDate ?? DateTime.Today;
            FormDescription = m.MovieDescription ?? "";
            FormPosterPath = m.PosterPath ?? "";
            TitleError = "";
            DurationError = "";
            IsEditorOpen = true;
        }

        private void SaveMovie()
        {
            if (string.IsNullOrWhiteSpace(FormTitle))
            {
                TitleError = "Vui lòng nhập tên phim.";
                return;
            }

            if (FormDuration <= 0)
            {
                DurationError = "Thời lượng phim phải lớn hơn 0.";
                return;
            }

            if (editingMovie == null)
            {
                var newMovie = new Movie
                {
                    Title = FormTitle.Trim(),
                    Genre = FormGenre.Trim(),
                    DurationMin = FormDuration,
                    AgeRating = FormAgeRating,
                    MovieStatus = FormMovieStatus,
                    ReleaseDate = FormReleaseDate,
                    MovieDescription = FormDescription.Trim(),
                    PosterPath = string.IsNullOrWhiteSpace(FormPosterPath) ? null : FormPosterPath.Trim()
                };

                service.Save(newMovie);
                allMovies.Add(newMovie);
            }
            else
            {
                editingMovie.Title = FormTitle.Trim();
                editingMovie.Genre = FormGenre.Trim();
                editingMovie.DurationMin = FormDuration;
                editingMovie.AgeRating = FormAgeRating;
                editingMovie.MovieStatus = FormMovieStatus;
                editingMovie.ReleaseDate = FormReleaseDate;
                editingMovie.MovieDescription = FormDescription.Trim();
                editingMovie.PosterPath = string.IsNullOrWhiteSpace(FormPosterPath) ? null : FormPosterPath.Trim();

                service.Save(editingMovie);
            }

            UpdateCounts();
            ApplyFilter();
            IsEditorOpen = false;
        }

        private void DeleteMovie(Movie m)
        {
            service.Delete(m.MovieID);
            allMovies.Remove(m);
            UpdateCounts();
            ApplyFilter();
        }
    }
}

