using System.Windows;
using CinemaAPP.Models;
using CinemaAPP.Services;

namespace CinemaAPP.ViewModels
{
    // Trạng thái suất chiếu, tính theo giờ hiện tại (không lưu trong CSDL)
    public enum ShowStatus { NotOnSale, OnSale, SoldOut, Showing, Ended }

    // Một dòng trên bảng Quản lý suất chiếu: dữ liệu Showtime + chữ hiển thị
    public class ShowtimeRow
    {
        public Showtime Data { get; }
        public ShowStatus Status { get; }

        public ShowtimeRow(Showtime data, DateTime now)
        {
            Data = data;
            Status = GetStatus(data, now);
        }

        public static ShowStatus GetStatus(Showtime s, DateTime now)
        {
            if (now >= s.EndTime) return ShowStatus.Ended;
            if (now >= s.StartTime) return ShowStatus.Showing;
            if (s.StartTime.Date >= now.Date.AddDays(ShowtimeService.SaleOpenDays)) return ShowStatus.NotOnSale;
            return s.TotalSeats > 0 && s.SoldSeats >= s.TotalSeats ? ShowStatus.SoldOut : ShowStatus.OnSale;
        }

        public static string StatusName(ShowStatus status) => status switch
        {
            ShowStatus.NotOnSale => "Sắp mở bán",
            ShowStatus.OnSale => "Đang mở bán",
            ShowStatus.SoldOut => "Hết vé",
            ShowStatus.Showing => "Đang chiếu",
            _ => "Đã kết thúc",
        };

        public static string CodeOf(int showtimeId) => $"SC{showtimeId:000}";

        public string Code => CodeOf(Data.ShowtimeID);
        public string Title => Data.Title;
        public string AgeRating => Data.AgeRating;
        public string MovieInfo => string.IsNullOrWhiteSpace(Data.Genre)
            ? $"{Data.DurationMin} phút"
            : $"{Data.Genre} · {Data.DurationMin} phút";
        public string RoomName => Data.RoomName;
        public string FormatText => string.IsNullOrWhiteSpace(Data.AudioType)
            ? Data.ShowFormat
            : $"{Data.ShowFormat} {Data.AudioType}";
        public string StartText => Data.StartTime.ToString("HH:mm");
        public string EndText => Data.EndTime.ToString("HH:mm");
        public string FreeAtText => $"Phòng trống lúc {Data.EndTime.AddMinutes(ShowtimeService.CleaningMinutes):HH:mm}";
        public string SeatsText => $"{Data.SoldSeats}/{Data.TotalSeats} ghế";
        public double FillPercent => Data.TotalSeats == 0 ? 0 : 100.0 * Data.SoldSeats / Data.TotalSeats;
        public string FillText => $"{FillPercent:0}%";
        // Màu thanh lấp đầy: dưới 50% xanh lá, 50–80% vàng, từ 80% đỏ
        public string FillLevel => FillPercent >= 80 ? "High" : FillPercent >= 50 ? "Mid" : "Low";
        // Thanh lấp đầy: hai cột star, cả hai bằng 0 thì chỉ còn nền xám
        public GridLength SoldWidth => new GridLength(Data.SoldSeats, GridUnitType.Star);
        public GridLength FreeWidth => new GridLength(Math.Max(0, Data.TotalSeats - Data.SoldSeats), GridUnitType.Star);
        public string PriceText => Format.Money(Data.BasePrice);
        public string RevenueText => Data.Revenue == 0 ? "—" : Format.Money(Data.Revenue);
        public string StatusText => StatusName(Status);
        public bool IsStarted => Status is ShowStatus.Showing or ShowStatus.Ended;
    }
}
