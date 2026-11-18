using System;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using CinemaAPP.Helpers;

namespace CinemaAPP.Models
{
    public class Movie : ObservableObject
    {
        // ---- Cột của bảng MOVIE trong CSDL ----
        public int MovieID { get; set; }
        public string Title { get; set; } = "";
        public int DurationMin { get; set; }
        public string Genre { get; set; } = "";
        public string AgeRating { get; set; } = "P";       // P, T13, T16, T18
        public string MovieStatus { get; set; } = "Đang chiếu"; // Đang chiếu, Sắp chiếu, Ngừng chiếu
        public DateTime? ReleaseDate { get; set; }
        public string? PosterPath { get; set; }
        public string? MovieDescription { get; set; }

        // ---- Thuộc tính hiển thị ----
        public string InfoLine => string.IsNullOrWhiteSpace(Genre)
            ? $"{DurationMin} phút"
            : $"{Genre} · {DurationMin} phút";

        public string ReleaseDateText => ReleaseDate?.ToString("dd'/'MM'/'yyyy") ?? "—";

        // Thuộc tính nạp ảnh Poster thông minh: hỗ trợ cả file cục bộ trên máy, file trong Assets/Posters, và Resource URI
        public ImageSource? PosterSource
        {
            get
            {
                if (string.IsNullOrWhiteSpace(PosterPath)) return null;

                try
                {
                    // 1. Nếu là đường dẫn tuyệt đối tồn tại trên ổ đĩa
                    if (System.IO.File.Exists(PosterPath))
                    {
                        var bmp = new BitmapImage();
                        bmp.BeginInit();
                        bmp.CacheOption = BitmapCacheOption.OnLoad;
                        bmp.UriSource = new Uri(PosterPath, UriKind.Absolute);
                        bmp.EndInit();
                        bmp.Freeze();
                        return bmp;
                    }

                    // 2. Tìm trong thư mục Assets/Posters của ứng dụng
                    string fileName = System.IO.Path.GetFileName(PosterPath);
                    string localPath = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets", "Posters", fileName);
                    if (System.IO.File.Exists(localPath))
                    {
                        var bmp = new BitmapImage();
                        bmp.BeginInit();
                        bmp.CacheOption = BitmapCacheOption.OnLoad;
                        bmp.UriSource = new Uri(localPath, UriKind.Absolute);
                        bmp.EndInit();
                        bmp.Freeze();
                        return bmp;
                    }

                    // 3. Tìm trong thư mục Assets/Posters của source code dự án
                    string projectAssetsPath = System.IO.Path.GetFullPath(System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, @"..\..\..\Assets\Posters", fileName));
                    if (System.IO.File.Exists(projectAssetsPath))
                    {
                        var bmp = new BitmapImage();
                        bmp.BeginInit();
                        bmp.CacheOption = BitmapCacheOption.OnLoad;
                        bmp.UriSource = new Uri(projectAssetsPath, UriKind.Absolute);
                        bmp.EndInit();
                        bmp.Freeze();
                        return bmp;
                    }

                    // 4. Thử nạp từ Pack URI nhúng trong WPF assembly
                    var packUri = new Uri($"pack://application:,,,/Assets/Posters/{fileName}", UriKind.Absolute);
                    var resBmp = new BitmapImage();
                    resBmp.BeginInit();
                    resBmp.CacheOption = BitmapCacheOption.OnLoad;
                    resBmp.UriSource = packUri;
                    resBmp.EndInit();
                    resBmp.Freeze();
                    return resBmp;
                }
                catch
                {
                    return null;
                }
            }
        }

        // Màu cho nhãn độ tuổi [P], [T13], [T16], [T18]
        public string AgeRatingBg => AgeRating switch
        {
            "P" => "#DCFCE7",
            "T13" => "#DBEAFE",
            "T16" => "#FFEDD5",
            "T18" => "#FEE2E2",
            _ => "#F1F5F9"
        };

        public string AgeRatingFg => AgeRating switch
        {
            "P" => "#166534",
            "T13" => "#1D4ED8",
            "T16" => "#C2410C",
            "T18" => "#B91C1C",
            _ => "#475569"
        };

        public string AgeRatingBorder => AgeRating switch
        {
            "P" => "#BBF7D0",
            "T13" => "#BFDBFE",
            "T16" => "#FED7AA",
            "T18" => "#FECACA",
            _ => "#CBD5E1"
        };

        // Màu cho nhãn trạng thái chiếu (duy nhất 1 nhãn)
        public string StatusBg => MovieStatus switch
        {
            "Đang chiếu" => "#DCFCE7",
            "Sắp chiếu" => "#FEF3C7",
            "Ngừng chiếu" => "#F1F5F9",
            _ => "#F1F5F9"
        };

        public string StatusFg => MovieStatus switch
        {
            "Đang chiếu" => "#166534",
            "Sắp chiếu" => "#B45309",
            "Ngừng chiếu" => "#64748B",
            _ => "#64748B"
        };

        // Màu nền gradient dự phòng cho poster
        public string PosterGradientStart => (Math.Abs(MovieID) % 6) switch
        {
            0 => "#1E3A8A",
            1 => "#0F172A",
            2 => "#312E81",
            3 => "#134E4A",
            4 => "#701A75",
            _ => "#3B0764"
        };

        public string PosterGradientEnd => (Math.Abs(MovieID) % 6) switch
        {
            0 => "#3B82F6",
            1 => "#334155",
            2 => "#6366F1",
            3 => "#14B8A6",
            4 => "#D946EF",
            _ => "#9333EA"
        };
    }
}

