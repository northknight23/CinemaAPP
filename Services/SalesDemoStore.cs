using CinemaAPP.ViewModels;

namespace CinemaAPP.Services
{
    // Kho đơn bán GIẢ dùng chung cho màn Bán vé và màn Giao dịch khi chưa ghép CSDL.
    // Sinh sẵn đơn của 7 ngày gần nhất (cố định theo ngày); màn Bán vé thanh toán xong thì thêm đơn vào đây,
    // nên sang màn Giao dịch thấy ngay. Đóng app là mất (chưa lưu CSDL).
    // Khi ghép CSDL: thay bằng BookingService (đọc BOOKING + TICKET, hủy đơn, lưu bàn giao ca).
    public static class SalesDemoStore
    {
        public static List<StaffInfo> Staff { get; } = new List<StaffInfo>
        {
            new("Phạm Thu Hà", "nv01", "Ca sáng 08:00 – 16:00"),
            new("Đỗ Quang Huy", "nv02", "Ca sáng 08:00 – 16:00"),
            new("Lê Minh Châu", "nv03", "Ca chiều 13:00 – 22:00"),
        };

        public static List<SaleRecord> Sales { get; } = new List<SaleRecord>();

        // Bàn giao ca: (ngày, username) → kết quả. Sau này là bảng riêng (nhờ A thêm nếu nhóm làm phần này).
        public static Dictionary<(DateTime Day, string Username), Handover> Handovers { get; } = new();

        public static int NextBookingId { get; private set; } = 1001;

        private static readonly (string Title, string Format, int Hour, int Minute, string Room)[] Schedule =
        {
            ("Cuộc Phiêu Lưu Mùa Hè", "2D", 9, 30, "Phòng 1"),
            ("Cuộc Phiêu Lưu Mùa Hè", "2D", 14, 0, "Phòng 2"),
            ("Cuộc Phiêu Lưu Mùa Hè", "2D", 20, 15, "Phòng 4"),
            ("Bóng Ma Rạp Cũ", "2D", 18, 45, "Phòng 3"),
            ("Bóng Ma Rạp Cũ", "2D", 21, 30, "Phòng 1"),
            ("Đội Cứu Hộ Mèo", "3D", 10, 15, "Phòng 3"),
            ("Đội Cứu Hộ Mèo", "3D", 16, 30, "Phòng 2"),
        };

        private static readonly (string Name, string Phone)[] Members =
        {
            ("Nguyễn Văn An", "0901234567"), ("Trần Thị Bình", "0912345678"), ("Lê Hoàng Nam", "0987654321"),
            ("Võ Thị Mai", "0934567890"), ("Bùi Đức Long", "0978123456"), ("Hồ Ngọc Lan", "0945678123"),
        };

        private static readonly string[] Reasons = { "Khách đổi ý", "Bấm nhầm", "Sự cố phòng chiếu" };

        static SalesDemoStore()
        {
            for (int daysAgo = 6; daysAgo >= 0; daysAgo--)
                SeedDay(DateTime.Today.AddDays(-daysAgo), daysAgo == 0);
        }

        public static SaleRecord Add(SaleRecord draft)
        {
            var sale = new SaleRecord
            {
                BookingID = NextBookingId++, CreatedAt = draft.CreatedAt, MovieTitle = draft.MovieTitle,
                ShowStart = draft.ShowStart, RoomName = draft.RoomName, ShowFormat = draft.ShowFormat,
                Seats = draft.Seats, StaffName = draft.StaffName, StaffUsername = draft.StaffUsername,
                CustomerName = draft.CustomerName, CustomerPhone = draft.CustomerPhone,
                Method = draft.Method, CashGiven = draft.CashGiven, Total = draft.Total,
            };
            Sales.Add(sale);
            return sale;
        }

        // Một ngày: cứ 8–22 phút có một đơn, từ 08:30 tới 22:00 (hôm nay thì tới giờ hiện tại, tối thiểu 11:30).
        private static void SeedDay(DateTime day, bool isToday)
        {
            var random = new Random(day.DayOfYear * 31 + day.Year);
            DateTime end = day.AddHours(22);
            if (isToday)
            {
                DateTime now = DateTime.Now;
                end = now < day.AddHours(11.5) ? day.AddHours(11.5) : now < end ? now : end;
            }

            var usedSeats = new HashSet<(int, string)>();   // (suất, nhãn ghế) đã bán trong ngày
            for (DateTime t = day.AddHours(8.5); t < end; t = t.AddMinutes(random.Next(8, 23)))
            {
                // Suất còn bán: bắt đầu sau giờ bán và trong vòng 7 tiếng tới
                var shows = Enumerable.Range(0, Schedule.Length)
                    .Where(i => day.AddHours(Schedule[i].Hour).AddMinutes(Schedule[i].Minute) is var s && s > t && s < t.AddHours(7))
                    .ToList();
                var staff = Staff.Where(s => OnShift(s, t)).ToList();
                if (shows.Count == 0 || staff.Count == 0) continue;

                int show = shows[random.Next(shows.Count)];
                var (title, format, hour, minute, room) = Schedule[show];
                var seats = PickSeats(random, show, usedSeats);
                if (seats.Count == 0) continue;

                decimal total = seats.Sum(s => Price(s.Type));
                var member = random.NextDouble() < 0.55 ? Members[random.Next(Members.Length)] : default;
                double m = random.NextDouble();
                PaymentMethod method = m < 0.5 ? PaymentMethod.Cash : m < 0.8 ? PaymentMethod.Transfer : PaymentMethod.Card;
                StaffInfo seller = staff[random.Next(staff.Count)];

                SaleRecord sale = Add(new SaleRecord
                {
                    CreatedAt = t.AddSeconds(random.Next(60)), MovieTitle = title,
                    ShowStart = day.AddHours(hour).AddMinutes(minute), RoomName = room, ShowFormat = format,
                    Seats = seats, StaffName = seller.FullName, StaffUsername = seller.Username,
                    CustomerName = member.Name, CustomerPhone = member.Phone,
                    Method = method, Total = total,
                    CashGiven = method == PaymentMethod.Cash ? Math.Ceiling(total / 50000) * 50000 + (random.NextDouble() < 0.4 ? 50000 : 0) : 0,
                });

                if (random.NextDouble() < 0.04)
                {
                    sale.CancelReason = Reasons[random.Next(Reasons.Length)];
                    sale.CancelledAt = sale.CreatedAt.AddMinutes(random.Next(3, 40));
                    sale.CancelledBy = "Quản trị viên";
                    sale.IsCancelled = true;
                }
            }

            // Các ngày trước đã bàn giao xong (tiền đếm khớp hệ thống)
            if (!isToday)
                foreach (StaffInfo s in Staff)
                {
                    decimal cash = Sales.Where(x => x.CreatedAt.Date == day && x.StaffUsername == s.Username
                                                    && !x.IsCancelled && x.Method == PaymentMethod.Cash).Sum(x => x.Total);
                    Handovers[(day, s.Username)] = new Handover(cash, "", day.AddHours(s.Shift.Contains("chiều") ? 22.1 : 16.1), "Quản trị viên");
                }
        }

        private static bool OnShift(StaffInfo s, DateTime t) =>
            s.Shift.Contains("chiều") ? t.Hour >= 13 : t.Hour < 16;

        // 1–4 ghế ngẫu nhiên, không trùng ghế đã bán của suất đó trong ngày.
        private static List<SoldSeat> PickSeats(Random random, int show, HashSet<(int, string)> used)
        {
            int count = random.Next(10) switch { < 2 => 1, < 7 => 2, < 9 => 3, _ => 4 };
            var seats = new List<SoldSeat>();
            for (int tries = 0; seats.Count < count && tries < 30; tries++)
            {
                double r = random.NextDouble();
                SeatType type = r < 0.5 ? SeatType.Standard : r < 0.85 ? SeatType.Vip : SeatType.Couple;
                int n = random.Next(6) * 2 + 1;   // ghế đôi: 1-2, 3-4, …, 11-12
                string label = type switch
                {
                    SeatType.Standard => "ABC"[random.Next(3)] + random.Next(1, 13).ToString(),
                    SeatType.Vip => "DEFGH"[random.Next(5)] + random.Next(1, 13).ToString(),
                    _ => $"J{n}-{n + 1}",
                };
                if (used.Add((show, label))) seats.Add(new SoldSeat(label, type));
            }
            return seats.OrderBy(s => s.Type).ThenBy(s => s.Label).ToList();
        }

        private static decimal Price(SeatType type) => type switch
        {
            SeatType.Vip => 90000,
            SeatType.Couple => 180000,
            _ => 75000,
        };
    }

    // Kết quả bàn giao tiền mặt cuối ca của một nhân viên trong một ngày.
    public record Handover(decimal CountedCash, string Note, DateTime At, string By);
}
