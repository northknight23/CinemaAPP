using System;
using System.Collections.Concurrent;
using System.IO;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace CinemaAPP.Helpers
{
    /// <summary>
    /// Nạp và cache ảnh poster theo đường dẫn/tên file để tránh đọc đĩa lặp lại khi UI render.
    /// </summary>
    public static class PosterLoader
    {
        private static readonly ConcurrentDictionary<string, ImageSource?> Cache = new(StringComparer.OrdinalIgnoreCase);

        public static ImageSource? Load(string? posterPath)
        {
            if (string.IsNullOrWhiteSpace(posterPath))
                return null;

            string key = posterPath.Trim();
            return Cache.GetOrAdd(key, ResolveAndDecode);
        }

        private static ImageSource? ResolveAndDecode(string posterPath)
        {
            try
            {
                if (File.Exists(posterPath))
                    return DecodeUri(new Uri(posterPath, UriKind.Absolute));

                string fileName = Path.GetFileName(posterPath);
                if (string.IsNullOrWhiteSpace(fileName))
                    return null;

                // Tìm trong thư mục Assets/Posters cạnh file chạy (.exe) hoặc thư mục gốc project khi debug
                var dir = new DirectoryInfo(AppDomain.CurrentDomain.BaseDirectory);
                for (int i = 0; i < 4 && dir != null; i++, dir = dir.Parent)
                {
                    string candidate = Path.Combine(dir.FullName, "Assets", "Posters", fileName);
                    if (File.Exists(candidate))
                        return DecodeUri(new Uri(candidate, UriKind.Absolute));
                }

                // Fallback về tài nguyên nhúng trong assembly
                return DecodeUri(new Uri($"pack://application:,,,/Assets/Posters/{fileName}", UriKind.Absolute));
            }
            catch
            {
                return null;
            }
        }

        private static ImageSource DecodeUri(Uri uri)
        {
            var bmp = new BitmapImage();
            bmp.BeginInit();
            bmp.CacheOption = BitmapCacheOption.OnLoad;
            bmp.UriSource = uri;
            bmp.EndInit();
            bmp.Freeze();
            return bmp;
        }
    }
}
