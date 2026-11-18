using System.Globalization;
using System.Text;

namespace CinemaAPP.Models
{
    public static class NameHelper
    {
        // "Nguyễn Văn An" → "NA" (chữ đầu của họ + chữ đầu của tên), dùng cho ô tròn avatar.
        public static string Initials(string fullName)
        {
            string[] words = fullName.Split(' ', StringSplitOptions.RemoveEmptyEntries);
            if (words.Length == 0) return "?";
            string first = words[0][..1];
            string last = words.Length > 1 ? words[^1][..1] : "";
            return (first + last).ToUpper();
        }

        // Tên dùng để sắp xếp kiểu Việt Nam: "Nguyễn Văn An" → "An".
        public static string GivenName(string fullName)
        {
            string[] words = fullName.Split(' ', StringSplitOptions.RemoveEmptyEntries);
            return words.Length == 0 ? "" : words[^1];
        }

        // Bỏ dấu + chữ thường để tìm kiếm: "Nguyễn Đức" → "nguyen duc".
        public static string Fold(string text)
        {
            string decomposed = text.ToLowerInvariant().Normalize(NormalizationForm.FormD);
            var sb = new StringBuilder(decomposed.Length);
            foreach (char c in decomposed)
            {
                if (CharUnicodeInfo.GetUnicodeCategory(c) != UnicodeCategory.NonSpacingMark)
                    sb.Append(c == 'đ' ? 'd' : c);
            }
            return sb.ToString().Normalize(NormalizationForm.FormC);
        }
    }
}
