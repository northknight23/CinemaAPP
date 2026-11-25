using System;
using CinemaAPP.Helpers;

namespace CinemaAPP.Models
{
    public class Room : ObservableObject
    {
        private int roomId;
        private string roomName = "";
        private string roomType = "2D";
        private int numRows = 9;
        private int seatsPerRow = 12;
        private string roomStatus = "Sẵn sàng";
        private string currentSchedule = "Chưa có lịch chiếu";
        private int todaySoldSeats;
        private int todayShowtimeCount;
        private int? activeShowtimeId;

        // ---- Cột của bảng ROOM trong CSDL ----
        public int RoomID
        {
            get => roomId;
            set => SetProperty(ref roomId, value);
        }

        public string RoomName
        {
            get => roomName;
            set => SetProperty(ref roomName, value);
        }

        public string RoomType
        {
            get => roomType;
            set => SetProperty(ref roomType, value);
        }

        public int NumRows
        {
            get => numRows;
            set
            {
                if (SetProperty(ref numRows, value))
                {
                    OnPropertyChanged(nameof(TotalSeats));
                    OnPropertyChanged(nameof(TotalSeatsBadge));
                    OnPropertyChanged(nameof(SeatConfigText));
                }
            }
        }

        public int SeatsPerRow
        {
            get => seatsPerRow;
            set
            {
                if (SetProperty(ref seatsPerRow, value))
                {
                    OnPropertyChanged(nameof(TotalSeats));
                    OnPropertyChanged(nameof(TotalSeatsBadge));
                    OnPropertyChanged(nameof(SeatConfigText));
                }
            }
        }

        // ---- Thuộc tính tính toán & hiển thị ----
        public int TotalSeats => NumRows * SeatsPerRow;
        public string TotalSeatsBadge => $"{TotalSeats} ghế";
        public string SeatConfigText => $"{NumRows} hàng × {SeatsPerRow} ghế";

        public string RoomStatus
        {
            get => roomStatus;
            set
            {
                if (SetProperty(ref roomStatus, value))
                    OnPropertyChanged(nameof(IsNowShowing));
            }
        }

        public bool IsNowShowing => RoomStatus == "Đang chiếu";

        public string CurrentSchedule
        {
            get => currentSchedule;
            set => SetProperty(ref currentSchedule, value);
        }

        public int TodaySoldSeats
        {
            get => todaySoldSeats;
            set
            {
                if (SetProperty(ref todaySoldSeats, value))
                {
                    OnPropertyChanged(nameof(TodaySoldText));
                    OnPropertyChanged(nameof(HasTodaySold));
                }
            }
        }

        public int TodayShowtimeCount
        {
            get => todayShowtimeCount;
            set
            {
                if (SetProperty(ref todayShowtimeCount, value))
                    OnPropertyChanged(nameof(TodayShowtimeText));
            }
        }

        public int? ActiveShowtimeID
        {
            get => activeShowtimeId;
            set => SetProperty(ref activeShowtimeId, value);
        }

        public bool HasTodaySold => TodaySoldSeats > 0;
        public string TodaySoldText => $"Đã bán hôm nay: {TodaySoldSeats} ghế";
        public string TodayShowtimeText => TodayShowtimeCount > 0 ? $"{TodayShowtimeCount} suất hôm nay" : "Chưa có suất hôm nay";
    }

    public class RoomShowtimeInfo
    {
        public int ShowtimeID { get; set; }
        public int RoomID { get; set; }
        public string MovieTitle { get; set; } = "";
        public DateTime StartTime { get; set; }
        public int DurationMin { get; set; }
        public string ShowFormat { get; set; } = "";
        public string AudioType { get; set; } = "";
        public decimal BasePrice { get; set; }
        public int TotalSeats { get; set; }
        public int SoldSeats { get; set; }

        public int FreeSeats => Math.Max(0, TotalSeats - SoldSeats);
        public DateTime EndTime => StartTime.AddMinutes(DurationMin);
        public string TimeRange => $"{StartTime:HH:mm} – {EndTime:HH:mm}";
        public string StatusTag
        {
            get
            {
                var now = DateTime.Now;
                if (now >= StartTime && now <= EndTime) return "Đang chiếu";
                if (now < StartTime) return "Sắp chiếu";
                return "Đã chiếu";
            }
        }
        public string DisplayText => $"{TimeRange} · {MovieTitle} ({ShowFormat}) [{StatusTag}] — Đã bán {SoldSeats}/{TotalSeats}";
    }
}
