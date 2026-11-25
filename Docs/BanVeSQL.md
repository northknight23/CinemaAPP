# Bán vé lưu SQL Server — phần C

## Cài đặt

- CSDL mới: chạy script của A `Database/CinemaDB.sql`, sau đó chạy `Database/MigrateBookingPersistence.sql`, rồi chạy `Database/seed.sql` (và các file `seed_*.sql` bổ sung nếu cần).
- CSDL cũ: chỉ chạy `Database/MigrateBookingPersistence.sql` trên CSDL đang dùng. Script chạy lại được, không xóa dữ liệu.
- Sơ đồ giữ hai dãy ghế biên và hai lối đi như giao diện cũ. Ô lối đi chỉ là phần tử ẩn giữ chỗ, không được tính vào sức chứa hoặc gửi vào TICKET.
- Không sửa `Data/Db.cs`; dùng `CINEMADB_CONN` nếu máy khác dùng SQL Express.

## Luồng thật

1. BookingService đọc suất hôm nay từ SQL, ghế theo RoomID, vé Active; khách tra qua CustomerService.FindByPhone.
2. Ghế thường = BasePrice, VIP = BasePrice × 1,2, ghế đôi = hai ghế vật lý liền nhau, mỗi ghế BasePrice × 1,2 (theo seed dùng chung). Giá làm tròn 4 chữ số thập phân tương thích SQL MONEY.
3. Có thể chọn các ghế còn trống trong cùng suất. Một cặp đôi tính 2 ghế vật lý và hiển thị một dòng trên vé chung.
4. CreateBooking kiểm tra lại nhân viên còn hoạt động, giờ chiếu, ghế thuộc đúng phòng, cặp đôi, giá từng ghế, tiền khách và số dư điểm.
5. Một SqlTransaction Serializable lưu BOOKING + từng TICKET + cập nhật CUSTOMER.Points. Các khóa suất/ghế/khách và unique index vé Active bảo vệ bán trùng, dùng trùng điểm.
6. Chỉ sau Commit mới hiển thị vé đã trả và nút In vé, dùng BookingID thật. Lỗi giữa chừng rollback cả đơn.
7. Nếu lỗi kết nối lúc xác nhận Commit, app không khẳng định chắc chắn chưa lưu: cần kiểm tra lịch sử SQL trước khi thử lại.
8. MyShift và Transactions đọc đơn từ SQL sau mỗi Refresh; CancelBooking lưu hủy, chuyển vé sang Cancelled và hoàn/trừ điểm trong cùng transaction. Không xóa vé lịch sử; ghế Active được giải phóng để bán lại. Nhân viên bị chặn hủy đơn ở cả UI lẫn SQL nếu ca hôm nay đã chốt / bàn giao.
9. Báo cáo chốt ca của nhân viên và xác nhận bàn giao của Quản trị viên được lưu vào bảng `SHIFT_HANDOVER` trong `CINEMADB` qua `ShiftService` (tạo bởi `Database/MigrateBookingPersistence.sql`), giữ nguyên trạng thái khi đóng mở lại ứng dụng và đồng bộ sang bộ nhớ đệm cho màn Tổng quan nhân viên.
10. In vé kiểm tra lại trạng thái Paid trước và sau khi chọn máy in. Không thanh toán thêm lần nữa khi in.

## Điểm

- Tích 5% thường, 7% VIP, 10% đôi trên tiền thực trả sau giảm, quy đổi 1.000đ = 1 điểm, Floor sau khi cộng cả đơn.
- Dùng 1 điểm giảm 1.000đ, không giới hạn 20%: được trừ tương ứng theo số điểm đang có và không vượt quá tổng tiền vé hiện đang thanh toán.
- BOOKING lưu riêng PointsEarned và PointsUsed. Nếu điểm thưởng của đơn đã bị dùng khiến hủy tạo số dư âm, từ chối hủy để xử lý số dư trước.
- Các đơn cũ không có phương thức thanh toán được hiển thị Chưa có dữ liệu, không tự giả định là tiền mặt.

## Phần chưa tích hợp

- Thu tiền mặt/chuyển khoản/thẻ vẫn do nhân viên xác nhận; chưa có kết nối ngân hàng hoặc máy POS, không còn QR giả.
- Tên SeatMapDemoView được giữ để không phá điều hướng của B; dữ liệu bán vé không còn demo.
- Tài liệu HuongDan_Code_Phan_C_CinemaAPP.md ngoài repo là snapshot commit c5316b7, không còn mô tả đầy đủ phiên bản SQL mới.
