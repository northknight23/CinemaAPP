# Ghi chú trước khi sửa lỗi

> Đọc file này trước mỗi lần sửa lỗi hoặc thêm tính năng ở màn **Tổng quan** (Dashboard) và phần khung `MainWindow`.
> Ghi lại từ những lần làm sai trước đây (cập nhật 21/11/2026) để không lặp lại.

---

## 1. Quy tắc làm việc

1. **Hỏi rõ trước khi đụng vào code:** người hỏi muốn *sửa luôn* hay chỉ muốn *ý kiến / hướng dẫn từng bước*? Không chắc thì mặc định là **hướng dẫn**, không tự sửa.
2. **Chỉ sửa đúng phạm vi được giao.** Bảo sửa `MainWindow.xaml` thì không tự sửa thêm ViewModel, Styles hay file khác khi chưa hỏi.
3. **Git: mọi thao tác ngoài việc đọc đều phải hỏi trước** (stash, checkout, merge, fast-forward, xóa nhánh). Tuyệt đối không commit / push khi chưa được yêu cầu.
4. **Luôn nhắc khi có thay đổi chưa commit** trước lúc đổi nhánh, vì đổi nhánh hoặc bấm discard là mất. Đã từng mất trọn phần sửa `MainWindow` vì chuyện này.
5. **Trả lời ngắn khi câu hỏi ngắn.** Chỉ đưa nhiều phương án khi thật sự cần chọn.

---

## 2. Lỗi đã gặp — nguyên nhân — cách tránh

| Lỗi | Nguyên nhân | Cách tránh |
|---|---|---|
| Đường "TB 3 ngày" sai ở 2 ngày đầu | Chỉ lấy dữ liệu trong kỳ, nên ngày 1 tính trung bình 1 ngày, ngày 2 tính 2 ngày | Trung bình trượt phải lấy thêm dữ liệu **trước** khoảng đang xem (kỳ trước đã tải sẵn), hoặc để trống điểm thiếu dữ liệu. Nay đã thay bằng đường tỷ lệ lấp đầy |
| Cửa sổ *Binding Failures* báo `IsUp property not found on DashboardViewModel` | `Border` vừa có `DataContext="{Binding XxxDelta}"` vừa có Style trigger `{Binding IsUp}`. Trigger chạy trước khi DataContext kịp đổi | Không đổi `DataContext` trên phần tử có trigger. Dùng `ContentControl Content="{Binding XxxDelta}"` + `DataTemplate`. **Chưa sửa**, xem mục 3 |
| Biểu đồ cột nhỏ quá mảnh, mờ | Khe giữa cột cố định 3.3px, ô biểu đồ co theo chỗ thừa, 14 ngày thì 14 cột | Kích thước tính theo tỷ lệ, làm tròn pixel, thử với số liệu dài và 14 ngày trước khi giao |
| Tô màu tăng/giảm sai ý | Mỗi điểm so với điểm liền trước, trong khi người dùng muốn **cả đường** theo % hôm nay so với hôm qua | **Chốt ý nghĩa màu trước khi code**: so cái gì với cái gì, bằng nhau thì màu gì |
| "339 vé mà lấp đầy 14%" gây hiểu nhầm | Cột vé tính theo **ngày lập đơn**, tỷ lệ lấp đầy tính theo **ngày suất chiếu** | Khi đặt hai chỉ số cạnh nhau phải ghi rõ cơ sở thời gian, hoặc dùng cùng một cơ sở |
| Chú thích ghi "Lấp đầy: 14 vé" | Chép mẫu chuỗi cũ của "TB 3 ngày" nên còn đơn vị "vé" | Đổi chỉ số thì soát lại **toàn bộ chuỗi hiển thị** đi kèm (đơn vị, nhãn chú thích, tên trục) |
| "-7%" ở thẻ Lấp đầy bị hiểu là giảm 7% | `DeltaInfo.Points` trả **điểm phần trăm** (7% − 14% = −7), không phải % thay đổi | Ghi rõ là "điểm %" hoặc thống nhất một cách tính cho mọi thẻ |
| Lỗi build `occupancySpark does not exist` | Hướng dẫn "bỏ `RevenueSpark`" nhưng dòng khai báo chứa cả 3 field, bị xóa cả dòng | Khi một dòng khai báo nhiều biến, chỉ xóa đúng biến cần xóa |
| Ký hiệu tiền lệch nhau (₫ ở Figma, đ ở app) | Thiết kế mẫu dùng ₫, còn `Format.Money` ghi `"đ"` | Tiền luôn dùng `Format.Money` (`1.250.000 đ`), kể cả trong bản thiết kế |
| Màu theo Style không có tác dụng | Thẻ có `Stroke="..."` viết thẳng (giá trị local) nên thắng trigger của Style | Muốn đổi màu bằng Style thì **xóa thuộc tính viết thẳng** trên phần tử |

---

## 3. Còn tồn tại / chưa kiểm tra

- [ ] **Chưa chạy với SQL Server thật.** `ShowtimeService.GetRange / BookingService.GetSales` và màn Tổng quan mới chỉ được thử bằng dữ liệu mẫu. Khi CSDL chạy được, cần kiểm lại: số liệu từng thẻ, biểu đồ 7/14 ngày, ngày không có suất chiếu, ngày không có đơn.
- [ ] **Cảnh báo Binding `IsUp`** vẫn còn ở các ô % (`Views/DashboardView.xaml`, các `Border Style="{StaticResource DeltaPill}" DataContext="{Binding ...Delta}"`).
- [x] **Tổng quan của nhân viên** đã có: `Views/StaffDashboardView.xaml` + `ViewModels/StaffDashboardViewModel.cs` (theo Figma *dashboard-for-staff*). Đã chạy được với SQL Server thật (suất chiếu hôm nay); phần đơn của nhân viên mới thử bằng dữ liệu mẫu.
  - "Suất còn lại hôm nay" = suất **chưa bắt đầu và còn ghế**; "Sắp kín" = đã bán ≥ 90% ghế.
  - Ca làm **không có giờ bắt đầu/kết thúc** trong CSDL, nên màn không hiện giờ ca. Trạng thái ca lấy từ `SalesDemoStore` (giống màn Hóa đơn ca).
  - "Khách vừa tra cứu" chỉ lưu trong phiên đang mở, tắt app là mất.
- Icon dùng chung nằm ở `Resources/Icon_Logo.xaml` (key `Ic*`), style dùng chung của màn Tổng quan nằm ở `Resources/ManagementStyles.xaml` (key `Dash*`). **Không khai báo lại cùng key trong view**, vì key trong view sẽ che key dùng chung.
- [ ] **Chưa có test** cho phần tính toán: % tăng/giảm (`DeltaInfo`), bước chia trục (`NiceStep`), tỷ lệ lấp đầy.
- [ ] `MainViewModel` (Tổng quan) mở `DashboardView` cho Quản trị viên; tiêu đề nhân viên vẫn là "Ca làm của tôi" dù chưa có màn.

---

## 4. Checklist trước khi báo "xong"

- [ ] Build không lỗi, cửa sổ **Binding Failures** không có dòng mới.
- [ ] Thử trường hợp xấu: **không có dữ liệu**, **mất kết nối CSDL**, **số tiền rất dài**, **khoảng 14 ngày**, **cửa sổ thu nhỏ nhất** (MinWidth 1080).
- [ ] Mỗi chỉ số trả lời được ba câu: *tính từ bảng nào*, *theo ngày nào*, *so với cái gì*.
- [ ] Chuỗi hiển thị đúng đơn vị (vé / đ / %) và khớp định dạng `Format`.
- [ ] Màu chỉ lấy từ `Resources/Styles.xaml`; màu thiếu thì thêm vào đó, không viết mã màu thẳng trong view.
- [ ] Nói rõ phần nào **đã kiểm tra** và phần nào **chưa** (đặc biệt là chưa chạy với CSDL thật).
