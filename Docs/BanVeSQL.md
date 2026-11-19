# Bán vé lưu SQL Server — phần C

## Cài đặt

- CSDL mới: chạy script của A `Database/CinemaDB.sql`, sau đó chạy `Database/MigrateBookingPersistence.sql`.
- CSDL cũ: chỉ chạy migration trên CSDL đang dùng. Script chạy lại được, không xóa dữ liệu.
- Migration đã được chạy trên CINEMADB của máy phát triển. Các ghế cũ chưa có SeatType nhận Standard; muốn có VIP/ghế đôi phải phân loại trong SEAT.
- Riêng bộ phòng [TEST] cũ trên máy, đã chạy thêm BackfillLegacyTestSeatTypes.sql: phân loại theo quy tắc seed của nhóm (thường → VIP → hàng đôi cuối phòng), không đổi ID, số ghế hay vé đã bán. Script chỉ nhận phòng hoàn toàn thuộc bộ [TEST] và chưa có ghế được phân loại.
- Sơ đồ giữ hai dãy ghế biên và hai lối đi như giao diện cũ. Ô lối đi chỉ là phần tử ẩn giữ chỗ, không được tính vào sức chứa hoặc gửi vào TICKET.
- Không sửa `Data/Db.cs`; dùng `CINEMADB_CONN` nếu máy khác dùng SQL Express.

## Luồng thật

1. BookingService đọc suất hôm nay từ SQL, ghế theo RoomID, vé Active; khách tra qua CustomerService.FindByPhone.
2. Ghế thường = BasePrice, VIP = BasePrice × 1,2, ghế đôi = hai ghế vật lý liền nhau, mỗi ghế BasePrice × 1,2 (theo seed dùng chung). Giá làm tròn 4 chữ số thập phân tương thích SQL MONEY.
3. Tối đa 8 ghế vật lý/đơn; một cặp đôi tính 2 ghế nhưng vẫn một dòng trên vé chung.
4. CreateBooking kiểm tra lại nhân viên còn hoạt động, giờ chiếu, ghế thuộc đúng phòng, cặp đôi, giá từng ghế, tiền khách và số dư điểm.
5. Một SqlTransaction Serializable lưu BOOKING + từng TICKET + cập nhật CUSTOMER.Points. Các khóa suất/ghế/khách và unique index vé Active bảo vệ bán trùng, dùng trùng điểm.
6. Chỉ sau Commit mới hiển thị vé đã trả và nút In vé, dùng BookingID thật. Lỗi giữa chừng rollback cả đơn.
7. Nếu lỗi kết nối lúc xác nhận Commit, app không khẳng định chắc chắn chưa lưu: cần kiểm tra lịch sử SQL trước khi thử lại.
8. MyShift và Transactions đọc đơn từ SQL sau mỗi Refresh; CancelBooking lưu hủy, chuyển vé sang Cancelled và hoàn/trừ điểm trong cùng transaction. Không xóa vé lịch sử; ghế Active được giải phóng để bán lại.
9. In vé kiểm tra lại trạng thái Paid trước và sau khi chọn máy in. Không thanh toán thêm lần nữa khi in.

## Điểm

- Tích 5% thường, 7% VIP, 10% đôi trên tiền thực trả sau giảm, quy đổi 1.000đ = 1 điểm, Floor sau khi cộng cả đơn.
- Dùng 1 điểm giảm 1.000đ, không vượt số dư hay 20% giá vé trước giảm.
- BOOKING lưu riêng PointsEarned và PointsUsed. Nếu điểm thưởng của đơn đã bị dùng khiến hủy tạo số dư âm, từ chối hủy để xử lý số dư trước.
- Các đơn cũ không có phương thức thanh toán được hiển thị Chưa có dữ liệu, không tự giả định là tiền mặt.

## Phần chưa tích hợp

- Thu tiền mặt/chuyển khoản/thẻ vẫn do nhân viên xác nhận; chưa có kết nối ngân hàng hoặc máy POS, không còn QR giả.
- ShiftReports/Handovers (báo cáo và xác nhận ca) vẫn trong bộ nhớ. Hóa đơn, vé, điểm, trạng thái hủy đã lưu SQL, nhưng báo cáo ca chưa có bảng riêng.
- Tên SeatMapDemoView được giữ để không phá điều hướng của B; dữ liệu bán vé không còn demo.
- Tài liệu HuongDan_Code_Phan_C_CinemaAPP.md ngoài repo là snapshot commit c5316b7, không còn mô tả đầy đủ phiên bản SQL mới.

## Kiểm thử

Project `E:\project cinema\TestData\BookingSqlTest` ở ngoài repo. Chạy `dotnet run -- "E:/project cinema"`.
Nó tự tạo CSDL CINEMA_POS_TEST_<guid>, thử migration, lưu đơn, mở tiến trình khác đọc lại, rollback, bán trùng đồng thời,
dùng điểm đồng thời, ghế đôi, giá thay đổi, tiền thiếu, hết giờ, sai quyền, lỗi kết nối và hủy/bán lại ghế; rồi xóa đúng CSDL thử.
Không tạo hóa đơn thử trong CINEMADB, không gửi lệnh in vật lý.
