using System;
using System.Collections.Generic;
using CinemaAPP.Helpers;

namespace CinemaAPP.Models
{
    public class Room : ObservableObject
    {
        private int roomId;
        private string roomName = "";
        private string roomType = "2D";
        private int numRows = 10;
        private int seatsPerRow = 12;
        private string roomStatus = "Sẵn sàng"; // Đang chiếu, Sẵn sàng, Bảo trì
        private string currentSchedule = "Chưa có lịch chiếu";

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
            set
            {
                if (SetProperty(ref roomType, value))
                {
                    OnPropertyChanged(nameof(RoomTypeBg));
                    OnPropertyChanged(nameof(RoomTypeFg));
                    OnPropertyChanged(nameof(RoomTypeBorder));
                }
            }
        }

        public int NumRows
        {
            get => numRows;
            set
            {
                if (SetProperty(ref numRows, value))
                {
                    OnPropertyChanged(nameof(TotalSeats));
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
                {
                    OnPropertyChanged(nameof(StatusBg));
                    OnPropertyChanged(nameof(StatusFg));
                    OnPropertyChanged(nameof(IsNowShowing));
                }
            }
        }

        public bool IsNowShowing => RoomStatus == "Đang chiếu";

        public string CurrentSchedule
        {
            get => currentSchedule;
            set => SetProperty(ref currentSchedule, value);
        }

        // Màu sắc huy hiệu công nghệ (2D, 3D, IMAX, VIP/PREMIUM)
        public string RoomTypeBg => RoomType?.ToUpperInvariant() switch
        {
            "2D" => "#DBEAFE",
            "3D" => "#FFEDD5",
            "IMAX" or "IMAX 3D" or "IMAX LASER" => "#EDE9FE",
            "VIP" or "PREMIUM" => "#FEF3C7",
            _ => "#E2E8F0"
        };

        public string RoomTypeFg => RoomType?.ToUpperInvariant() switch
        {
            "2D" => "#1D4ED8",
            "3D" => "#C2410C",
            "IMAX" or "IMAX 3D" or "IMAX LASER" => "#6D28D9",
            "VIP" or "PREMIUM" => "#B45309",
            _ => "#475569"
        };

        public string RoomTypeBorder => RoomType?.ToUpperInvariant() switch
        {
            "2D" => "#BFDBFE",
            "3D" => "#FED7AA",
            "IMAX" or "IMAX 3D" or "IMAX LASER" => "#DDD6FE",
            "VIP" or "PREMIUM" => "#FDE68A",
            _ => "#CBD5E1"
        };

        // Màu sắc nhãn trạng thái vận hành
        public string StatusBg => RoomStatus switch
        {
            "Đang chiếu" => "#DCFCE7",
            "Sắp chiếu" => "#FEF3C7",
            "Bảo trì" => "#FEE2E2",
            _ => "#F1F5F9" // Sẵn sàng
        };

        public string StatusFg => RoomStatus switch
        {
            "Đang chiếu" => "#166534",
            "Sắp chiếu" => "#B45309",
            "Bảo trì" => "#991B1B",
            _ => "#475569" // Sẵn sàng
        };
    }

    public class SeatMapSeat : ObservableObject
    {
        public int SeatID { get; set; }
        public string RowLabel { get; set; } = "A";
        public int SeatNumber { get; set; } = 1;
        public string SeatCode => $"{RowLabel}{SeatNumber:D2}";
        public bool IsVip { get; set; }
        public string SeatBg => IsVip ? "#FEF3C7" : "#FFFFFF";
        public string SeatFg => IsVip ? "#B45309" : "#1E293B";
        public string SeatBorder => IsVip ? "#F59E0B" : "#CBD5E1";
    }

    public class SeatMapRow
    {
        public string RowLabel { get; set; } = "";
        public List<SeatMapSeat> Seats { get; set; } = new();
    }
}
