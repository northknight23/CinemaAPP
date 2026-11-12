using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace CinemaAPP.Helpers
{
    public static class RememberedLogin
    {
        private static readonly string FilePath = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
            "UITCinema", "last_user.txt");

        public static string? Load()
        {
            try
            {
                if (!File.Exists(FilePath)) return null;
                string name = File.ReadAllText(FilePath).Trim();
                return name.Length > 0 ? name : null;
            }
            catch { return null; }
        }

        public static void Save(string username)
        {
            try
            {
                Directory.CreateDirectory(Path.GetDirectoryName(FilePath)!);
                File.WriteAllText(FilePath, username);
            }
            catch { /* không lưu được thì thôi, không ảnh hưởng đăng nhập */ }
        }

        public static void Clear()
        {
            try { if (File.Exists(FilePath)) File.Delete(FilePath); }
            catch { }
        }
    }
}
