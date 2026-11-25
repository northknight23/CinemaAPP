using System;

namespace CinemaAPP.Helpers
{
    /// <summary>
    /// Kênh thông báo thay đổi dữ liệu phòng chiếu và vé bán trong cùng tiến trình
    /// để các màn hình Admin và Nhân viên cập nhật tức thì (kết hợp polling CSDL định kỳ).
    /// </summary>
    public static class CinemaSync
    {
        public static event Action? RoomsChanged;
        public static event Action? BookingsChanged;

        public static void NotifyRoomsChanged() => RoomsChanged?.Invoke();
        public static void NotifyBookingsChanged() => BookingsChanged?.Invoke();
    }
}
