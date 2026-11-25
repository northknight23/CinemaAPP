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
        private bool isBusy;

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

        private string filterStatus = "All";
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

        public ObservableCollection<Movie> FilteredMovies { get; } = new();

        // ================= Banner thông báo (chung cho trang) =================
        private string bannerMessage = "";
        public string BannerMessage
        {
            get => bannerMessage;
            set { if (SetProperty(ref bannerMessage, value)) OnPropertyChanged(nameof(ShowBanner)); }
        }
        public bool ShowBanner => !string.IsNullOrEmpty(BannerMessage);

        private bool isMessageError;
        public bool IsMessageError
        {
            get => isMessageError;
            set => SetProperty(ref isMessageError, value);
        }

        // ================= Biểu mẫu Thêm / Chỉnh sửa =================
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

        private string editorError = "";
        public string EditorError
        {
            get => editorError;
            set { if (SetProperty(ref editorError, value)) OnPropertyChanged(nameof(HasEditorError)); }
        }
        public bool HasEditorError => editorError.Length > 0;

        private Movie? editingMovie;

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

        private string formDurationText = "100";
        public string FormDurationText
        {
            get => formDurationText;
            set { if (SetProperty(ref formDurationText, value)) DurationError = ""; }
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

        private DateTime? formReleaseDate = DateTime.Today;
        public DateTime? FormReleaseDate
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

        // Khớp với CK_MOVIE_AGERATING và CK_MOVIE_STATUS trong CinemaDB.sql
        public List<string> AgeRatingOptions { get; } = new() { "P", "K", "T13", "T16", "T18", "C" };
        public List<string> MovieStatusOptions { get; } = new() { "Đang chiếu", "Sắp chiếu", "Ngừng chiếu" };

        // ================= Xác nhận xóa phim =================
        private bool isDeleteConfirmOpen;
        public bool IsDeleteConfirmOpen
        {
            get => isDeleteConfirmOpen;
            set => SetProperty(ref isDeleteConfirmOpen, value);
        }

        private Movie? movieToDelete;
        public Movie? MovieToDelete
        {
            get => movieToDelete;
            set => SetProperty(ref movieToDelete, value);
        }

        // ================= Lệnh =================
        public ICommand SetFilterCommand { get; }
        public ICommand NewMovieCommand { get; }
        public ICommand EditMovieCommand { get; }
        public ICommand DeleteMovieCommand { get; }
        public ICommand ConfirmDeleteCommand { get; }
        public ICommand CancelDeleteCommand { get; }
        public ICommand SaveCommand { get; }
        public ICommand CancelCommand { get; }
        public ICommand ReloadCommand { get; }
        public ICommand DismissBannerCommand { get; }

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
                {
                    MovieToDelete = m;
                    IsDeleteConfirmOpen = true;
                }
            });

            ConfirmDeleteCommand = new RelayCommand(async _ => await ConfirmDeleteAsync());
            CancelDeleteCommand = new RelayCommand(_ =>
            {
                IsDeleteConfirmOpen = false;
                MovieToDelete = null;
            });

            SaveCommand = new RelayCommand(async _ => await SaveMovieAsync());
            CancelCommand = new RelayCommand(_ => IsEditorOpen = false);
            ReloadCommand = new RelayCommand(async _ => await LoadDataAsync());
            DismissBannerCommand = new RelayCommand(_ => BannerMessage = "");

            _ = LoadDataAsync();
        }

        public async Task LoadDataAsync()
        {
            try
            {
                var loaded = await Task.Run(() => service.GetAll());
                allMovies = loaded;
                UpdateCounts();
                ApplyFilter();
                if (IsMessageError)
                    BannerMessage = "";
            }
            catch (Exception ex)
            {
                allMovies = new List<Movie>();
                UpdateCounts();
                ApplyFilter();
                ShowBannerMessage("Không tải được danh sách phim từ SQL Server: " + ex.Message, isError: true);
            }
        }

        private void ShowBannerMessage(string text, bool isError)
        {
            IsMessageError = isError;
            BannerMessage = text;
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
            FormDurationText = "100";
            FormAgeRating = "P";
            FormMovieStatus = "Đang chiếu";
            FormReleaseDate = DateTime.Today;
            FormDescription = "";
            FormPosterPath = "";
            TitleError = "";
            DurationError = "";
            EditorError = "";
            IsEditorOpen = true;
        }

        private void OpenEditForm(Movie m)
        {
            editingMovie = m;
            EditorTitle = "Chỉnh sửa thông tin phim";
            FormTitle = m.Title;
            FormGenre = m.Genre;
            FormDurationText = m.DurationMin.ToString();
            FormAgeRating = AgeRatingOptions.Contains(m.AgeRating) ? m.AgeRating : "P";
            FormMovieStatus = MovieStatusOptions.Contains(m.MovieStatus) ? m.MovieStatus : "Đang chiếu";
            FormReleaseDate = m.ReleaseDate ?? DateTime.Today;
            FormDescription = m.MovieDescription ?? "";
            FormPosterPath = m.PosterPath ?? "";
            TitleError = "";
            DurationError = "";
            EditorError = "";
            IsEditorOpen = true;
        }

        private async Task SaveMovieAsync()
        {
            if (isBusy) return;

            TitleError = "";
            DurationError = "";
            EditorError = "";

            if (string.IsNullOrWhiteSpace(FormTitle))
            {
                TitleError = "Vui lòng nhập tên phim.";
                return;
            }

            if (!int.TryParse(FormDurationText.Trim(), out int duration) || duration <= 0)
            {
                DurationError = "Thời lượng phim phải là số nguyên lớn hơn 0.";
                return;
            }

            var candidate = new Movie
            {
                MovieID = editingMovie?.MovieID ?? 0,
                Title = FormTitle.Trim(),
                Genre = FormGenre.Trim(),
                DurationMin = duration,
                AgeRating = FormAgeRating,
                MovieStatus = FormMovieStatus,
                ReleaseDate = FormReleaseDate,
                MovieDescription = string.IsNullOrWhiteSpace(FormDescription) ? null : FormDescription.Trim(),
                PosterPath = string.IsNullOrWhiteSpace(FormPosterPath) ? null : FormPosterPath.Trim()
            };

            isBusy = true;
            try
            {
                await Task.Run(() => service.Save(candidate));

                if (editingMovie == null)
                {
                    allMovies.Add(candidate);
                    ShowBannerMessage($"Đã thêm phim \"{candidate.Title}\".", isError: false);
                }
                else
                {
                    editingMovie.Title = candidate.Title;
                    editingMovie.Genre = candidate.Genre;
                    editingMovie.DurationMin = candidate.DurationMin;
                    editingMovie.AgeRating = candidate.AgeRating;
                    editingMovie.MovieStatus = candidate.MovieStatus;
                    editingMovie.ReleaseDate = candidate.ReleaseDate;
                    editingMovie.MovieDescription = candidate.MovieDescription;
                    editingMovie.PosterPath = candidate.PosterPath;
                    ShowBannerMessage($"Đã cập nhật phim \"{editingMovie.Title}\".", isError: false);
                }

                UpdateCounts();
                ApplyFilter();
                IsEditorOpen = false;
            }
            catch (Exception ex)
            {
                EditorError = "Không lưu được phim: " + ex.Message;
            }
            finally
            {
                isBusy = false;
            }
        }

        private async Task ConfirmDeleteAsync()
        {
            if (isBusy || MovieToDelete == null) return;
            var target = MovieToDelete;

            isBusy = true;
            try
            {
                await Task.Run(() => service.Delete(target.MovieID));
                allMovies.Remove(target);
                UpdateCounts();
                ApplyFilter();
                IsDeleteConfirmOpen = false;
                MovieToDelete = null;
                ShowBannerMessage($"Đã xóa phim \"{target.Title}\".", isError: false);
            }
            catch (Exception ex)
            {
                IsDeleteConfirmOpen = false;
                MovieToDelete = null;
                ShowBannerMessage(ex.Message, isError: true);
            }
            finally
            {
                isBusy = false;
            }
        }
    }
}
