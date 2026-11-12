# Phác thảo luồng bán vé tại quầy (phần của C)

Người dùng: **nhân viên quầy** (đã đăng nhập, có `AccountID`), bán trên máy POS tại rạp.
Toàn bộ việc bán nằm trên **một màn hình chia 3 cột**, không chuyển qua lại giữa nhiều màn.
Màn này **không có thanh tiêu đề riêng**: logo, tên nhân viên, Đăng xuất thuộc khung app (`MainWindow` của B),
màn bán vé chỉ là phần nội dung hiện trong khung đó.

```
┌──────────────────┬───────────────────────────────────┬───────────────────────┐
│ SUẤT CHIẾU       │ SƠ ĐỒ GHẾ của suất đang chọn       │ ĐƠN HIỆN TẠI          │
│                  │   (nút ☾ Tối / ☀ Sáng, ghế trống)  │                       │
│ HÔM NAY          │                                   │ ghế gom theo loại vé  │
│                  │        ═══ MÀN HÌNH ═══           │                       │
│ Phim A  [P]      │   A  ▢▢ ▢▢▢▢▢▢▢▢ ▢▢  A            │ Khách thành viên (SĐT)│
│  09:30  14:00    │   B  ▢▢ ▢▢▢▢▢▢▢▢ ▢▢  B            │ Số ghế · Điểm · Tổng  │
│  20:15           │   …                               │ Tiền khách đưa / QR / │
│ Phim B  [T16]    │   J  ▭▭ ▭▭▭▭▭▭▭▭ ▭▭  J            │   hướng dẫn quẹt thẻ  │
│  18:45  21:30    │                                   │ [Tiền mặt][QR][Thẻ]   │
│ …                │ chú thích màu + giá               │ [   THANH TOÁN    ]   │
└──────────────────┴───────────────────────────────────┴───────────────────────┘
```

Luồng một đơn: **Chọn suất → Chọn ghế → (Tìm khách thành viên) → Chọn phương thức, thu tiền → Thanh toán → đơn mới**.
Bước nào cũng làm lại được ngay trên màn: bấm suất khác thì đơn đang làm dở bị xóa, bấm lại ghế thì bỏ ghế đó.

Tham chiếu kế hoạch: 8.2 (`ShowtimeService`), 8.3 (sơ đồ ghế), 8.4 (`BookingService`).

---

## 1. Cột trái – Suất chiếu hôm nay

| | |
|---|---|
| **Hiển thị** | Các suất **trong ngày**, nhóm theo phim. Mỗi phim: khung poster, tên, nhãn tuổi (P xanh lá, K xanh dương, T13 cam, T16/T18 đỏ), thể loại · thời lượng. Mỗi suất: giờ bắt đầu, phòng · định dạng, **còn N ghế** |
| **Dữ liệu** | `SHOWTIME` JOIN `MOVIE`, `ROOM`; đếm ghế trong `SEAT` và vé đã bán trong `TICKET` |
| **Service** | `BookingService.GetTodayShowtimes()` *(mới)* |
| **Khi bấm một suất** | Suất đó tô xanh, khung phim viền xanh → cột giữa nạp sơ đồ ghế của suất, đơn đang làm dở bị xóa |

```sql
SELECT s.ShowtimeID, s.StartTime, s.ShowFormat, s.AudioType, s.BasePrice,
       m.MovieID, m.Title, m.Agerating, m.Genre, m.DurationMin, m.PosterPath,
       r.RoomID, r.RoomName,
       (SELECT COUNT(*) FROM SEAT se WHERE se.RoomID = r.RoomID)
     - (SELECT COUNT(*) FROM TICKET t WHERE t.ShowtimeID = s.ShowtimeID) AS FreeSeats
FROM SHOWTIME s
JOIN MOVIE m ON m.MovieID = s.MovieID
JOIN ROOM  r ON r.RoomID  = s.RoomID
WHERE CAST(s.StartTime AS date) = CAST(SYSDATETIME() AS date)
ORDER BY m.Title, s.StartTime;
```

- Giờ kết thúc = `StartTime + DurationMin`, chỉ để hiển thị.
- Mặc định chọn **suất sắp chiếu gần nhất**.
- Suất **hết ghế**: thẻ ghi "Hết ghế" màu đỏ.
- Suất **đã bắt đầu**: khi ghép CSDL thì làm mờ và không cho bán (bản dữ liệu giả chưa chặn, để test được ở mọi giờ).
- Poster: khung trống, có ảnh ở `MOVIE.PosterPath` thì tự hiện ảnh.

## 2. Cột giữa – Sơ đồ ghế

| | |
|---|---|
| **Hiển thị** | Tên phim, giờ, phòng, định dạng · âm thanh, **ghế trống / tổng ghế**. Màn hình chiếu, các hàng A, B, C… có nhãn hàng hai bên, lối đi, chú thích màu kèm giá |
| **Dữ liệu** | `SEAT WHERE RoomID = <phòng của suất>` và `ShowtimeService.GetSoldSeatIds(showtimeId)` |
| **Service** | `BookingService.GetSeats(roomId)` *(mới)*, `ShowtimeService.GetSoldSeatIds` *(8.2)* |
| **Khi bấm một ghế** | Ghế còn trống → thêm vào đơn (tô xanh); bấm lại → bỏ khỏi đơn. Ghế đã bán (xám) không bấm được |

```sql
SELECT SeatID, RowLabel, SeatNumber FROM SEAT
WHERE RoomID = @RoomID ORDER BY RowLabel, SeatNumber;
```

Quy tắc:
- Chỉ tải ghế của đúng phòng của suất. Kế hoạch ghi rõ đây là quy tắc CSDL không tự chặn được, C# phải tự kiểm tra.
- Tối đa **8 ghế** một đơn (`MaxSeats`); chọn ghế thứ 9 → báo lỗi.
- Màu ghế: Thường / VIP / Đôi / Đang chọn / Đã bán (màu lấy từ `Resources/Styles.xaml`).
- Sơ đồ tự co giãn theo khung: màn quầy to thì ghế to, dễ bấm.

## 3. Cột phải – Đơn hiện tại và thanh toán

### 3.1 Đơn hiện tại
- Ghế **gom theo loại vé**, ví dụ: `Vé VIP · E5, E6 — 2 vé · 180.000 đ`.
- **Bỏ chọn**: xóa cả đơn (ghế, khách, tiền đã nhập), về phương thức Tiền mặt.

### 3.2 Khách thành viên (không bắt buộc)

| | |
|---|---|
| **Hiển thị** | Ô số điện thoại + nút Tìm (Enter cũng tìm). Tìm thấy → "Tên · N điểm" màu xanh; không thấy → báo đỏ |
| **Dữ liệu** | `CUSTOMER` theo `Phone` (cột UNIQUE) |
| **Service** | `CustomerService.FindByPhone(phone)` *(mới)* |

```sql
SELECT CustomerID, FullName, Phone, Points FROM CUSTOMER WHERE Phone = @Phone;
```

- **Điểm tích lũy**: 1 điểm cho mỗi 10.000 đ (`MoneyPerPoint`), chỉ cộng khi có khách thành viên.

### 3.3 Phương thức thanh toán

| Phương thức | Màn hiện gì | Nút THANH TOÁN bật khi |
|---|---|---|
| **Tiền mặt** | Ô "Tiền khách đưa" + nút nhanh Vừa đủ / 100k / 200k / 500k, **tiền thối lại**; đưa thiếu → "Còn thiếu …" màu đỏ | Có ghế **và** tiền khách đưa ≥ tổng |
| **Chuyển khoản / QR** | Mã QR + nội dung chuyển khoản `UT<mã đơn>`. Nhân viên thấy tiền về thì bấm Thanh toán | Có ghế |
| **Thẻ (POS)** | Số tiền cần nhập trên máy quẹt thẻ. Máy POS báo thành công thì bấm Thanh toán | Có ghế |

### 3.4 Khi bấm THANH TOÁN
`BookingService.CreateBooking(...)` *(8.4, cần sửa – xem dưới)* chạy **một transaction**:

1. `INSERT BOOKING (AccountID, CustomerID, TotalAmount, BookingStatus, PaymentMethod)`
   - `AccountID` = nhân viên đang đăng nhập; `CustomerID` = khách thành viên hoặc `NULL`
   - `BookingStatus = N'Paid'`, `CreatedAt` do SQL tự điền
2. Mỗi ghế một `INSERT TICKET (BookingID, ShowtimeID, SeatID, Price)`.
   Ghế đôi = **2 dòng SEAT** liền nhau → **2 vé**, mỗi vé một nửa giá ghế đôi.
3. Có khách thành viên → `UPDATE CUSTOMER SET Points = Points + @Points WHERE CustomerID = @CustomerID`.
4. `COMMIT`. Lỗi ở bất kỳ bước nào → `ROLLBACK` cả đơn.

Sau khi thành công: ghế vừa bán chuyển xám, "còn N ghế" giảm, khung xanh báo
`Đã thanh toán đơn #1001: ghế … – 435.000 đ (Tiền mặt, thối 65.000 đ). Cộng +43 điểm…`, đơn được xóa để bán tiếp.

Xử lý lỗi:

| Lỗi | Nguyên nhân | App làm gì |
|---|---|---|
| `SqlException 2627` (vi phạm `UQ_TICKET_SEAT`) | Quầy khác vừa bán một trong các ghế này | Transaction hủy cả đơn → báo "Có ghế vừa được bán cho người khác, vui lòng chọn lại" → **tải lại sơ đồ**, giữ các ghế còn trống trong đơn |
| Mất kết nối CSDL | Server tắt, sai chuỗi kết nối | Báo lỗi, giữ nguyên đơn để thử lại |

Cần sửa `CreateBooking` của 8.4:
- Nhận danh sách `(SeatID, Price)` thay cho một `pricePerSeat` chung, vì VIP và ghế đôi giá khác nhau; `TotalAmount` = tổng các `Price`.
- Thêm tham số `customerId` (có thể null), `paymentMethod`, `points`.

---

## 4. Đổi từ dữ liệu giả sang thật (tuần 3)

| Dữ liệu giả (tuần 1) | Dữ liệu thật |
|---|---|
| 3 phim, 7 suất dựng sẵn trong `BuildShowtimes()` | `BookingService.GetTodayShowtimes()` |
| `Rows` dựng sẵn A–J, 12 ghế, mọi phòng giống nhau | Nhóm các dòng `SEAT` của phòng theo `RowLabel` |
| `SoldSeatIds` ngẫu nhiên theo suất | `ShowtimeService.GetSoldSeatIds(showtimeId)` |
| Giá 75.000 / 90.000 / 180.000 | Tính từ `SHOWTIME.BasePrice` (xem câu hỏi 1) |
| 2 số điện thoại thành viên giả | `CustomerService.FindByPhone` |
| `Pay()` chỉ tô xám ghế, mã đơn tự tăng từ 1001 | `BookingService.CreateBooking`, mã đơn = `BookingID` |
| Chưa có nhân viên (khung app lo phần hiển thị) | `AppSession.CurrentUser.AccountID` khi tạo BOOKING (màn Đăng nhập của A) |
| Mã QR minh họa, không quét được | Giữ minh họa, hoặc tạo QR VietQR thật nếu còn thời gian |

## 5. Tổ chức code (hiện tại)

```
Views/SeatMapDemoView.xaml(.cs)      Màn bán vé tại quầy (3 cột). Code-behind chỉ đổi bộ màu sáng / tối
Views/Themes/PosLight.xaml           Bộ màu sáng  ┐ cùng tên key, giá trị lấy từ Resources/Styles.xaml
Views/Themes/PosDark.xaml            Bộ màu tối   ┘
ViewModels/SeatMapDemoViewModel.cs   Toàn bộ trạng thái + lệnh của màn (suất, ghế, đơn, khách, thanh toán)
ViewModels/MovieShowtimes.cs         Một phim + các suất của phim trong ngày
ViewModels/ShowtimeOption.cs         Một suất chiếu (giờ, phòng, ghế còn trống, ghế đã bán)
ViewModels/SeatRowItem.cs, SeatItem.cs   Một hàng ghế, một ô ghế
ViewModels/OrderLine.cs              Một dòng trong đơn + enum PaymentMethod
```

Sẽ thêm ở tuần 3: `Services/BookingService.cs` (`GetTodayShowtimes`, `GetSeats`, `CreateBooking`),
`Services/CustomerService.cs` (`FindByPhone`), dùng chung `Services/ShowtimeService.cs` (`HasOverlap`, `GetSoldSeatIds`) với màn Quản lý suất chiếu.
Khi ghép CSDL có thể đổi tên `SeatMapDemoViewModel` / `SeatMapDemoView` thành `SellTicketViewModel` / `SellTicketView`.

Nhờ B thêm vào `MainWindow` / `MainViewModel`: nút menu **"Bán vé"** và `DataTemplate SeatMapDemoViewModel → SeatMapDemoView`.

## 6. Kịch bản demo

1. Bấm suất 20:15 → chọn E5, E6, B10, J3-4 → đơn gom thành 3 dòng, tổng 435.000 đ.
2. Nhập SĐT thành viên → hiện tên và điểm, "Điểm tích lũy +43".
3. Tiền mặt: nhập 300.000 → "Còn thiếu 135.000 đ", nút Thanh toán khóa → bấm 500k → thối 65.000 đ → Thanh toán.
4. Các ghế vừa bán chuyển xám, "còn N ghế" ở cột trái giảm 4.
5. Bán đơn khác bằng **Chuyển khoản / QR** và **Thẻ (POS)**.
6. Chọn ghế thứ 9 → bị chặn.
7. (Tuần 3) Mở 2 cửa sổ app cùng bán một ghế → một bên thành công, bên kia báo "ghế vừa được bán", **không** có đơn nào bị tạo dở.
8. Bấm ☾ Tối / ☀ Sáng (đầu cột sơ đồ ghế) để đổi giao diện.

## 7. Câu hỏi cần cả nhóm chốt

1. **Loại ghế và giá:** bảng `SEAT` chưa có cột loại ghế. Chọn một trong hai:
   - (a) Nhờ A thêm cột `SeatType NVARCHAR(10)` vào `SEAT` (`Standard` / `Vip` / `Couple`), giá = `BasePrice × hệ số` (ví dụ VIP ×1.2, ghế đôi ×2 cho 2 chỗ).
   - (b) Không đổi CSDL: tính loại ghế theo hàng ngay trong code.

   Cách (a) rõ ràng hơn khi demo. Nếu chọn (a), màn **Quản lý phòng** của B cũng cần cho chọn hàng VIP / ghế đôi khi tự sinh ghế.
2. **Phương thức thanh toán:** bảng `BOOKING` chưa có cột lưu. Nhờ A thêm `PaymentMethod NVARCHAR(20)` (`Cash` / `Transfer` / `Card`).
3. ~~Thanh trên cùng đặt ở đâu~~ **Đã chốt (12/11):** màn bán vé bỏ thanh tiêu đề riêng; logo, nhân viên, Đăng xuất do `MainWindow` của B hiển thị.
4. **Lối đi:** CSDL không lưu lối đi. Giữ quy tắc cố định trong code (trước ghế số 3 và 11), hay bỏ?
5. **Xem lại đơn đã bán** (kế hoạch liệt kê trong quyền của nhân viên): ai làm? Nếu là C thì để sang tuần 4.
