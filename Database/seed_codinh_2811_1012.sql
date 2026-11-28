-- Du lieu ao CO DINH cho CINEMADB: 28/11/2026 -> 10/12/2026, noi tiep seed_codinh_1011_2711.sql.
-- Chay NGAY SAU seed_codinh_1011_2711.sql (CSDL chua ban them don nao qua app), chi chay 1 lan.
-- Moi gia tri (ID, ngay gio, ghe, gia, diem, tien mat) deu viet san bang INSERT, khong dung ham ngay gio, so ngau nhien hay vong lap
-- => may nao chay, chay luc nao cung ra cung mot du lieu.
-- 377 suat chieu, 2157 hoa don, 4888 ve, 62 ban ghi chot ca. Doanh thu 466.969.000 d.
-- Lich chieu: 28/11 -> 03/12 giong ngay 27/11; tu 04/12 them Bat Ca Ba Tay va Con Mat Thu Ba (khoi chieu 04/12).
-- Ca lam tiep vong xoay cua file goc: ngay thuong 2 nguoi/ca, thu 6 -> CN 3 nguoi/ca. Ca toi 10/12 da nop, dang cho QTV xac nhan.
-- Quy tac giong file goc: ghe thuong = BasePrice, VIP / ghe doi = BasePrice x 1,2; diem 5% / 7% / 10%, 1.000 d = 1 diem.
-- Cuoi file co cac lenh UPDATE CUSTOMER ghi san so diem moi (gia tri co dinh) de diem khach khop voi don moi.
USE CINEMADB;
SET NOCOUNT ON;
SET XACT_ABORT ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;

IF NOT EXISTS (SELECT 1 FROM SHOWTIME WHERE ShowtimeID = 509)
   OR EXISTS (SELECT 1 FROM SHOWTIME WHERE ShowtimeID > 509) OR EXISTS (SELECT 1 FROM BOOKING WHERE BookingID > 2929)
   OR EXISTS (SELECT 1 FROM TICKET WHERE TicketID > 6720) OR EXISTS (SELECT 1 FROM SHIFT_HANDOVER WHERE ShiftHandoverID > 86)
BEGIN
    RAISERROR(N'Chỉ chạy ngay sau seed_codinh_1011_2711.sql: CSDL chưa có dữ liệu gốc, hoặc đã có thêm suất/đơn/chốt ca (file này đã chạy rồi?).', 16, 1);
    RETURN;
END

BEGIN TRANSACTION;

-- ===== SHOWTIME: lich chieu tung ngay, da tinh 15 phut don phong =====
SET IDENTITY_INSERT SHOWTIME ON;
-- Thứ 7 28/11/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(510, 1, 1, '2026-11-28T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(511, 25, 2, '2026-11-28T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(512, 7, 5, '2026-11-28T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(513, 20, 4, '2026-11-28T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(514, 8, 3, '2026-11-28T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 3 | Kiến Lé Phiêu Lưu Ké
(515, 19, 2, '2026-11-28T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(516, 2, 3, '2026-11-28T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(517, 26, 1, '2026-11-28T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(518, 6, 4, '2026-11-28T12:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(519, 3, 5, '2026-11-28T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(520, 25, 2, '2026-11-28T12:45:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(521, 4, 3, '2026-11-28T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(522, 1, 1, '2026-11-28T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(523, 2, 2, '2026-11-28T15:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(524, 20, 5, '2026-11-28T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(525, 20, 4, '2026-11-28T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(526, 5, 3, '2026-11-28T16:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Chị Chị Em Em 3
(527, 24, 1, '2026-11-28T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(528, 26, 2, '2026-11-28T17:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(529, 7, 5, '2026-11-28T18:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(530, 1, 1, '2026-11-28T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(531, 18, 3, '2026-11-28T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Điểm Mù
(532, 3, 4, '2026-11-28T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(533, 14, 2, '2026-11-28T19:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Bò Sữa Bay
(534, 24, 1, '2026-11-28T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(535, 20, 4, '2026-11-28T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(536, 3, 5, '2026-11-28T21:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(537, 11, 2, '2026-11-28T21:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(538, 24, 3, '2026-11-28T21:45:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Mẹ Mìn: Giao Kèo Với Quỷ
-- Chủ nhật 29/11/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(539, 1, 1, '2026-11-29T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(540, 25, 2, '2026-11-29T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(541, 7, 5, '2026-11-29T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(542, 20, 4, '2026-11-29T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(543, 8, 3, '2026-11-29T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 3 | Kiến Lé Phiêu Lưu Ké
(544, 19, 2, '2026-11-29T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(545, 2, 3, '2026-11-29T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(546, 26, 1, '2026-11-29T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(547, 6, 4, '2026-11-29T12:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(548, 3, 5, '2026-11-29T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(549, 25, 2, '2026-11-29T12:45:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(550, 4, 3, '2026-11-29T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(551, 1, 1, '2026-11-29T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(552, 2, 2, '2026-11-29T15:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(553, 20, 5, '2026-11-29T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(554, 20, 4, '2026-11-29T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(555, 5, 3, '2026-11-29T16:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Chị Chị Em Em 3
(556, 24, 1, '2026-11-29T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(557, 26, 2, '2026-11-29T17:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(558, 7, 5, '2026-11-29T18:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(559, 1, 1, '2026-11-29T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(560, 18, 3, '2026-11-29T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Điểm Mù
(561, 3, 4, '2026-11-29T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(562, 14, 2, '2026-11-29T19:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Bò Sữa Bay
(563, 24, 1, '2026-11-29T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(564, 20, 4, '2026-11-29T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(565, 3, 5, '2026-11-29T21:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(566, 11, 2, '2026-11-29T21:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(567, 24, 3, '2026-11-29T21:45:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Mẹ Mìn: Giao Kèo Với Quỷ
-- Thứ 2 30/11/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(568, 1, 1, '2026-11-30T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(569, 25, 2, '2026-11-30T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(570, 7, 5, '2026-11-30T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(571, 20, 4, '2026-11-30T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(572, 8, 3, '2026-11-30T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 3 | Kiến Lé Phiêu Lưu Ké
(573, 19, 2, '2026-11-30T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(574, 2, 3, '2026-11-30T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(575, 26, 1, '2026-11-30T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(576, 6, 4, '2026-11-30T12:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(577, 3, 5, '2026-11-30T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(578, 25, 2, '2026-11-30T12:45:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(579, 4, 3, '2026-11-30T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(580, 1, 1, '2026-11-30T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(581, 2, 2, '2026-11-30T15:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(582, 20, 5, '2026-11-30T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(583, 20, 4, '2026-11-30T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(584, 5, 3, '2026-11-30T16:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Chị Chị Em Em 3
(585, 24, 1, '2026-11-30T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(586, 26, 2, '2026-11-30T17:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(587, 7, 5, '2026-11-30T18:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(588, 1, 1, '2026-11-30T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(589, 18, 3, '2026-11-30T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Điểm Mù
(590, 3, 4, '2026-11-30T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(591, 14, 2, '2026-11-30T19:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Bò Sữa Bay
(592, 24, 1, '2026-11-30T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(593, 20, 4, '2026-11-30T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(594, 3, 5, '2026-11-30T21:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(595, 11, 2, '2026-11-30T21:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(596, 24, 3, '2026-11-30T21:45:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Mẹ Mìn: Giao Kèo Với Quỷ
-- Thứ 3 01/12/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(597, 1, 1, '2026-12-01T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(598, 25, 2, '2026-12-01T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(599, 7, 5, '2026-12-01T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(600, 20, 4, '2026-12-01T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(601, 8, 3, '2026-12-01T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 3 | Kiến Lé Phiêu Lưu Ké
(602, 19, 2, '2026-12-01T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(603, 2, 3, '2026-12-01T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(604, 26, 1, '2026-12-01T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(605, 6, 4, '2026-12-01T12:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(606, 3, 5, '2026-12-01T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(607, 25, 2, '2026-12-01T12:45:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(608, 4, 3, '2026-12-01T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(609, 1, 1, '2026-12-01T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(610, 2, 2, '2026-12-01T15:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(611, 20, 5, '2026-12-01T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(612, 20, 4, '2026-12-01T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(613, 5, 3, '2026-12-01T16:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Chị Chị Em Em 3
(614, 24, 1, '2026-12-01T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(615, 26, 2, '2026-12-01T17:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(616, 7, 5, '2026-12-01T18:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(617, 1, 1, '2026-12-01T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(618, 18, 3, '2026-12-01T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Điểm Mù
(619, 3, 4, '2026-12-01T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(620, 14, 2, '2026-12-01T19:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Bò Sữa Bay
(621, 24, 1, '2026-12-01T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(622, 20, 4, '2026-12-01T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(623, 3, 5, '2026-12-01T21:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(624, 11, 2, '2026-12-01T21:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(625, 24, 3, '2026-12-01T21:45:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Mẹ Mìn: Giao Kèo Với Quỷ
-- Thứ 4 02/12/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(626, 1, 1, '2026-12-02T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(627, 25, 2, '2026-12-02T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(628, 7, 5, '2026-12-02T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(629, 20, 4, '2026-12-02T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(630, 8, 3, '2026-12-02T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 3 | Kiến Lé Phiêu Lưu Ké
(631, 19, 2, '2026-12-02T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(632, 2, 3, '2026-12-02T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(633, 26, 1, '2026-12-02T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(634, 6, 4, '2026-12-02T12:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(635, 3, 5, '2026-12-02T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(636, 25, 2, '2026-12-02T12:45:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(637, 4, 3, '2026-12-02T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(638, 1, 1, '2026-12-02T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(639, 2, 2, '2026-12-02T15:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(640, 20, 5, '2026-12-02T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(641, 20, 4, '2026-12-02T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(642, 5, 3, '2026-12-02T16:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Chị Chị Em Em 3
(643, 24, 1, '2026-12-02T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(644, 26, 2, '2026-12-02T17:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(645, 7, 5, '2026-12-02T18:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(646, 1, 1, '2026-12-02T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(647, 18, 3, '2026-12-02T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Điểm Mù
(648, 3, 4, '2026-12-02T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(649, 14, 2, '2026-12-02T19:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Bò Sữa Bay
(650, 24, 1, '2026-12-02T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(651, 20, 4, '2026-12-02T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(652, 3, 5, '2026-12-02T21:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(653, 11, 2, '2026-12-02T21:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(654, 24, 3, '2026-12-02T21:45:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Mẹ Mìn: Giao Kèo Với Quỷ
-- Thứ 5 03/12/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(655, 1, 1, '2026-12-03T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(656, 25, 2, '2026-12-03T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(657, 7, 5, '2026-12-03T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(658, 20, 4, '2026-12-03T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(659, 8, 3, '2026-12-03T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 3 | Kiến Lé Phiêu Lưu Ké
(660, 19, 2, '2026-12-03T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(661, 2, 3, '2026-12-03T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(662, 26, 1, '2026-12-03T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(663, 6, 4, '2026-12-03T12:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(664, 3, 5, '2026-12-03T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(665, 25, 2, '2026-12-03T12:45:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(666, 4, 3, '2026-12-03T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(667, 1, 1, '2026-12-03T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(668, 2, 2, '2026-12-03T15:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(669, 20, 5, '2026-12-03T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(670, 20, 4, '2026-12-03T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(671, 5, 3, '2026-12-03T16:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Chị Chị Em Em 3
(672, 24, 1, '2026-12-03T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(673, 26, 2, '2026-12-03T17:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(674, 7, 5, '2026-12-03T18:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(675, 1, 1, '2026-12-03T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(676, 18, 3, '2026-12-03T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Điểm Mù
(677, 3, 4, '2026-12-03T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(678, 14, 2, '2026-12-03T19:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Bò Sữa Bay
(679, 24, 1, '2026-12-03T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(680, 20, 4, '2026-12-03T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(681, 3, 5, '2026-12-03T21:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(682, 11, 2, '2026-12-03T21:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(683, 24, 3, '2026-12-03T21:45:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Mẹ Mìn: Giao Kèo Với Quỷ
-- Thứ 6 04/12/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(684, 1, 1, '2026-12-04T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(685, 25, 2, '2026-12-04T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(686, 7, 5, '2026-12-04T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(687, 20, 4, '2026-12-04T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(688, 8, 3, '2026-12-04T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 3 | Kiến Lé Phiêu Lưu Ké
(689, 19, 2, '2026-12-04T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(690, 2, 3, '2026-12-04T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(691, 27, 1, '2026-12-04T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bắt Cá Ba Tay
(692, 6, 4, '2026-12-04T12:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(693, 3, 5, '2026-12-04T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(694, 25, 2, '2026-12-04T12:45:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(695, 28, 3, '2026-12-04T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Con Mắt Thứ Ba
(696, 1, 1, '2026-12-04T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(697, 2, 2, '2026-12-04T15:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(698, 20, 5, '2026-12-04T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(699, 26, 3, '2026-12-04T15:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(700, 20, 4, '2026-12-04T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(701, 24, 1, '2026-12-04T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(702, 26, 2, '2026-12-04T17:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(703, 7, 5, '2026-12-04T18:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(704, 27, 1, '2026-12-04T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bắt Cá Ba Tay
(705, 18, 3, '2026-12-04T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Điểm Mù
(706, 3, 4, '2026-12-04T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(707, 14, 2, '2026-12-04T19:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Bò Sữa Bay
(708, 1, 1, '2026-12-04T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(709, 20, 4, '2026-12-04T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(710, 3, 5, '2026-12-04T21:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(711, 28, 2, '2026-12-04T21:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Con Mắt Thứ Ba
(712, 28, 3, '2026-12-04T21:45:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Con Mắt Thứ Ba
-- Thứ 7 05/12/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(713, 1, 1, '2026-12-05T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(714, 25, 2, '2026-12-05T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(715, 7, 5, '2026-12-05T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(716, 20, 4, '2026-12-05T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(717, 8, 3, '2026-12-05T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 3 | Kiến Lé Phiêu Lưu Ké
(718, 19, 2, '2026-12-05T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(719, 2, 3, '2026-12-05T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(720, 27, 1, '2026-12-05T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bắt Cá Ba Tay
(721, 6, 4, '2026-12-05T12:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(722, 3, 5, '2026-12-05T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(723, 25, 2, '2026-12-05T12:45:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(724, 28, 3, '2026-12-05T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Con Mắt Thứ Ba
(725, 1, 1, '2026-12-05T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(726, 2, 2, '2026-12-05T15:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(727, 20, 5, '2026-12-05T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(728, 26, 3, '2026-12-05T15:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(729, 20, 4, '2026-12-05T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(730, 24, 1, '2026-12-05T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(731, 26, 2, '2026-12-05T17:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(732, 7, 5, '2026-12-05T18:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(733, 27, 1, '2026-12-05T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bắt Cá Ba Tay
(734, 18, 3, '2026-12-05T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Điểm Mù
(735, 3, 4, '2026-12-05T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(736, 14, 2, '2026-12-05T19:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Bò Sữa Bay
(737, 1, 1, '2026-12-05T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(738, 20, 4, '2026-12-05T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(739, 3, 5, '2026-12-05T21:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(740, 28, 2, '2026-12-05T21:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Con Mắt Thứ Ba
(741, 28, 3, '2026-12-05T21:45:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Con Mắt Thứ Ba
-- Chủ nhật 06/12/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(742, 1, 1, '2026-12-06T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(743, 25, 2, '2026-12-06T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(744, 7, 5, '2026-12-06T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(745, 20, 4, '2026-12-06T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(746, 8, 3, '2026-12-06T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 3 | Kiến Lé Phiêu Lưu Ké
(747, 19, 2, '2026-12-06T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(748, 2, 3, '2026-12-06T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(749, 27, 1, '2026-12-06T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bắt Cá Ba Tay
(750, 6, 4, '2026-12-06T12:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(751, 3, 5, '2026-12-06T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(752, 25, 2, '2026-12-06T12:45:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(753, 28, 3, '2026-12-06T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Con Mắt Thứ Ba
(754, 1, 1, '2026-12-06T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(755, 2, 2, '2026-12-06T15:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(756, 20, 5, '2026-12-06T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(757, 26, 3, '2026-12-06T15:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(758, 20, 4, '2026-12-06T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(759, 24, 1, '2026-12-06T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(760, 26, 2, '2026-12-06T17:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(761, 7, 5, '2026-12-06T18:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(762, 27, 1, '2026-12-06T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bắt Cá Ba Tay
(763, 18, 3, '2026-12-06T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Điểm Mù
(764, 3, 4, '2026-12-06T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(765, 14, 2, '2026-12-06T19:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Bò Sữa Bay
(766, 1, 1, '2026-12-06T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(767, 20, 4, '2026-12-06T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(768, 3, 5, '2026-12-06T21:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(769, 28, 2, '2026-12-06T21:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Con Mắt Thứ Ba
(770, 28, 3, '2026-12-06T21:45:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Con Mắt Thứ Ba
-- Thứ 2 07/12/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(771, 1, 1, '2026-12-07T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(772, 25, 2, '2026-12-07T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(773, 7, 5, '2026-12-07T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(774, 20, 4, '2026-12-07T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(775, 8, 3, '2026-12-07T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 3 | Kiến Lé Phiêu Lưu Ké
(776, 19, 2, '2026-12-07T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(777, 2, 3, '2026-12-07T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(778, 27, 1, '2026-12-07T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bắt Cá Ba Tay
(779, 6, 4, '2026-12-07T12:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(780, 3, 5, '2026-12-07T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(781, 25, 2, '2026-12-07T12:45:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(782, 28, 3, '2026-12-07T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Con Mắt Thứ Ba
(783, 1, 1, '2026-12-07T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(784, 2, 2, '2026-12-07T15:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(785, 20, 5, '2026-12-07T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(786, 26, 3, '2026-12-07T15:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(787, 20, 4, '2026-12-07T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(788, 24, 1, '2026-12-07T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(789, 26, 2, '2026-12-07T17:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(790, 7, 5, '2026-12-07T18:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(791, 27, 1, '2026-12-07T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bắt Cá Ba Tay
(792, 18, 3, '2026-12-07T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Điểm Mù
(793, 3, 4, '2026-12-07T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(794, 14, 2, '2026-12-07T19:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Bò Sữa Bay
(795, 1, 1, '2026-12-07T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(796, 20, 4, '2026-12-07T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(797, 3, 5, '2026-12-07T21:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(798, 28, 2, '2026-12-07T21:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Con Mắt Thứ Ba
(799, 28, 3, '2026-12-07T21:45:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Con Mắt Thứ Ba
-- Thứ 3 08/12/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(800, 1, 1, '2026-12-08T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(801, 25, 2, '2026-12-08T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(802, 7, 5, '2026-12-08T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(803, 20, 4, '2026-12-08T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(804, 8, 3, '2026-12-08T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 3 | Kiến Lé Phiêu Lưu Ké
(805, 19, 2, '2026-12-08T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(806, 2, 3, '2026-12-08T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(807, 27, 1, '2026-12-08T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bắt Cá Ba Tay
(808, 6, 4, '2026-12-08T12:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(809, 3, 5, '2026-12-08T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(810, 25, 2, '2026-12-08T12:45:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(811, 28, 3, '2026-12-08T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Con Mắt Thứ Ba
(812, 1, 1, '2026-12-08T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(813, 2, 2, '2026-12-08T15:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(814, 20, 5, '2026-12-08T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(815, 26, 3, '2026-12-08T15:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(816, 20, 4, '2026-12-08T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(817, 24, 1, '2026-12-08T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(818, 26, 2, '2026-12-08T17:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(819, 7, 5, '2026-12-08T18:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(820, 27, 1, '2026-12-08T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bắt Cá Ba Tay
(821, 18, 3, '2026-12-08T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Điểm Mù
(822, 3, 4, '2026-12-08T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(823, 14, 2, '2026-12-08T19:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Bò Sữa Bay
(824, 1, 1, '2026-12-08T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(825, 20, 4, '2026-12-08T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(826, 3, 5, '2026-12-08T21:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(827, 28, 2, '2026-12-08T21:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Con Mắt Thứ Ba
(828, 28, 3, '2026-12-08T21:45:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Con Mắt Thứ Ba
-- Thứ 4 09/12/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(829, 1, 1, '2026-12-09T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(830, 25, 2, '2026-12-09T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(831, 7, 5, '2026-12-09T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(832, 20, 4, '2026-12-09T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(833, 8, 3, '2026-12-09T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 3 | Kiến Lé Phiêu Lưu Ké
(834, 19, 2, '2026-12-09T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(835, 2, 3, '2026-12-09T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(836, 27, 1, '2026-12-09T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bắt Cá Ba Tay
(837, 6, 4, '2026-12-09T12:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(838, 3, 5, '2026-12-09T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(839, 25, 2, '2026-12-09T12:45:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(840, 28, 3, '2026-12-09T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Con Mắt Thứ Ba
(841, 1, 1, '2026-12-09T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(842, 2, 2, '2026-12-09T15:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(843, 20, 5, '2026-12-09T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(844, 26, 3, '2026-12-09T15:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(845, 20, 4, '2026-12-09T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(846, 24, 1, '2026-12-09T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(847, 26, 2, '2026-12-09T17:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(848, 7, 5, '2026-12-09T18:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(849, 27, 1, '2026-12-09T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bắt Cá Ba Tay
(850, 18, 3, '2026-12-09T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Điểm Mù
(851, 3, 4, '2026-12-09T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(852, 14, 2, '2026-12-09T19:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Bò Sữa Bay
(853, 1, 1, '2026-12-09T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(854, 20, 4, '2026-12-09T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(855, 3, 5, '2026-12-09T21:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(856, 28, 2, '2026-12-09T21:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Con Mắt Thứ Ba
(857, 28, 3, '2026-12-09T21:45:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Con Mắt Thứ Ba
-- Thứ 5 10/12/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(858, 1, 1, '2026-12-10T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(859, 25, 2, '2026-12-10T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(860, 7, 5, '2026-12-10T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(861, 20, 4, '2026-12-10T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(862, 8, 3, '2026-12-10T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 3 | Kiến Lé Phiêu Lưu Ké
(863, 19, 2, '2026-12-10T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(864, 2, 3, '2026-12-10T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(865, 27, 1, '2026-12-10T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bắt Cá Ba Tay
(866, 6, 4, '2026-12-10T12:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(867, 3, 5, '2026-12-10T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(868, 25, 2, '2026-12-10T12:45:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(869, 28, 3, '2026-12-10T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Con Mắt Thứ Ba
(870, 1, 1, '2026-12-10T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(871, 2, 2, '2026-12-10T15:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(872, 20, 5, '2026-12-10T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(873, 26, 3, '2026-12-10T15:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(874, 20, 4, '2026-12-10T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(875, 24, 1, '2026-12-10T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(876, 26, 2, '2026-12-10T17:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(877, 7, 5, '2026-12-10T18:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(878, 27, 1, '2026-12-10T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bắt Cá Ba Tay
(879, 18, 3, '2026-12-10T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Điểm Mù
(880, 3, 4, '2026-12-10T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(881, 14, 2, '2026-12-10T19:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Bò Sữa Bay
(882, 1, 1, '2026-12-10T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(883, 20, 4, '2026-12-10T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(884, 3, 5, '2026-12-10T21:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(885, 28, 2, '2026-12-10T21:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Con Mắt Thứ Ba
(886, 28, 3, '2026-12-10T21:45:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Con Mắt Thứ Ba
SET IDENTITY_INSERT SHOWTIME OFF;

-- ===== BOOKING + TICKET: gom theo ngay lap hoa don =====

-- ----- Thứ 7 28/11/2026: 278 hoa don (6 huy), 634 ve, doanh thu 61.865.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(2930, 10, NULL, '2026-11-28T08:02:39', 90000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 510 | Trại Giam Hạnh Phúc | 28/11 09:00 | Phòng 1 | D7
(2931, 10, 42, '2026-11-28T08:02:45', 240000, N'Paid', N'Cash', 240000, 12, 0, NULL, NULL, NULL), -- suat 541 | Dune: Hành Tinh Cát - Phần Hai | 29/11 09:00 | Phòng 5 | D6 D7
(2932, 9, NULL, '2026-11-28T08:03:11', 240000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 512 | Dune: Hành Tinh Cát - Phần Hai | 28/11 09:00 | Phòng 5 | A6 A7
(2933, 3, NULL, '2026-11-28T08:03:28', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 512 | Dune: Hành Tinh Cát - Phần Hai | 28/11 09:00 | Phòng 5 | F8 F9 F10
(2934, 3, NULL, '2026-11-28T08:04:44', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 511 | Hexed: Thế Giới Phép Thuật | 28/11 09:00 | Phòng 2 | A3 A4
(2935, 3, NULL, '2026-11-28T08:05:21', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 543 | Kiến Lé Phiêu Lưu Ké | 29/11 09:30 | Phòng 3 | F4 F5
(2936, 3, NULL, '2026-11-28T08:10:34', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 510 | Trại Giam Hạnh Phúc | 28/11 09:00 | Phòng 1 | D8 D9
(2937, 3, NULL, '2026-11-28T08:10:46', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 518 | Ramayana: Khởi Nguồn Một Huyền Thoại | 28/11 12:15 | Phòng 4 | B7 B8
(2938, 9, NULL, '2026-11-28T08:11:41', 75000, N'Paid', N'Cash', 75000, 0, 0, NULL, NULL, NULL), -- suat 520 | Hexed: Thế Giới Phép Thuật | 28/11 12:45 | Phòng 2 | C8
(2939, 10, NULL, '2026-11-28T08:12:21', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 511 | Hexed: Thế Giới Phép Thuật | 28/11 09:00 | Phòng 2 | A6 A7
(2940, 9, NULL, '2026-11-28T08:12:30', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 564 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 21:00 | Phòng 4 | A6 A7
(2941, 9, NULL, '2026-11-28T08:12:44', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 510 | Trại Giam Hạnh Phúc | 28/11 09:00 | Phòng 1 | B5 B6 B7
(2942, 3, 37, '2026-11-28T08:13:21', 150000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 523 | Ngày Con Còn Mẹ | 28/11 15:00 | Phòng 2 | C5 C6
(2943, 10, NULL, '2026-11-28T08:17:17', 216000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Nhầm suất / ghế', '2026-11-28T08:38:22', 10), -- suat 513 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 09:15 | Phòng 4 | F8 F9
(2944, 9, NULL, '2026-11-28T08:17:53', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 512 | Dune: Hành Tinh Cát - Phần Hai | 28/11 09:00 | Phòng 5 | L3 L4
(2945, 10, NULL, '2026-11-28T08:19:10', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 549 | Hexed: Thế Giới Phép Thuật | 29/11 12:45 | Phòng 2 | E9 E10
(2946, 10, 93, '2026-11-28T08:22:43', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 511 | Hexed: Thế Giới Phép Thuật | 28/11 09:00 | Phòng 2 | D6
(2947, 10, NULL, '2026-11-28T08:29:10', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 512 | Dune: Hành Tinh Cát - Phần Hai | 28/11 09:00 | Phòng 5 | K6 K7
(2948, 9, 95, '2026-11-28T08:31:31', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 512 | Dune: Hành Tinh Cát - Phần Hai | 28/11 09:00 | Phòng 5 | J8 J9
(2949, 10, 108, '2026-11-28T08:33:06', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 510 | Trại Giam Hạnh Phúc | 28/11 09:00 | Phòng 1 | H5 H6
(2950, 10, 108, '2026-11-28T08:34:08', 150000, N'Paid', N'Cash', 500000, 7, 0, NULL, NULL, NULL), -- suat 510 | Trại Giam Hạnh Phúc | 28/11 09:00 | Phòng 1 | B8 B9
(2951, 10, NULL, '2026-11-28T08:34:54', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 511 | Hexed: Thế Giới Phép Thuật | 28/11 09:00 | Phòng 2 | F5 F6 F7 F8
(2952, 10, 66, '2026-11-28T08:37:31', 108000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 513 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 09:15 | Phòng 4 | F6
(2953, 10, NULL, '2026-11-28T08:38:00', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 519 | Godzilla Trừ Không | 28/11 12:15 | Phòng 5 | F5 F6
(2954, 9, NULL, '2026-11-28T08:39:08', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 510 | Trại Giam Hạnh Phúc | 28/11 09:00 | Phòng 1 | J11 J12
(2955, 9, NULL, '2026-11-28T08:40:13', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 541 | Dune: Hành Tinh Cát - Phần Hai | 29/11 09:00 | Phòng 5 | J5 J6
(2956, 3, 31, '2026-11-28T08:40:35', 720000, N'Paid', N'Cash', 720000, 36, 0, NULL, NULL, NULL), -- suat 565 | Godzilla Trừ Không | 29/11 21:15 | Phòng 5 | C4 C5 C6 C7 C8 C9
(2957, 9, NULL, '2026-11-28T08:45:34', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 514 | Kiến Lé Phiêu Lưu Ké | 28/11 09:30 | Phòng 3 | B6 B7
(2958, 9, NULL, '2026-11-28T08:52:49', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 513 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 09:15 | Phòng 4 | D6 D7
(2959, 3, NULL, '2026-11-28T08:56:15', 216000, N'Paid', N'Cash', 220000, 0, 0, NULL, NULL, NULL), -- suat 513 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 09:15 | Phòng 4 | H4 H5
(2960, 9, 31, '2026-11-28T08:59:42', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 517 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 28/11 11:30 | Phòng 1 | F4 F5 F6
(2961, 9, NULL, '2026-11-28T09:01:15', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 519 | Godzilla Trừ Không | 28/11 12:15 | Phòng 5 | H5 H6 H7
(2962, 9, NULL, '2026-11-28T09:02:13', 324000, N'Paid', N'Cash', 324000, 0, 0, NULL, NULL, NULL), -- suat 513 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 09:15 | Phòng 4 | G5 G6 G7
(2963, 3, NULL, '2026-11-28T09:14:30', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 514 | Kiến Lé Phiêu Lưu Ké | 28/11 09:30 | Phòng 3 | F8 F9
(2964, 9, 66, '2026-11-28T09:17:15', 270000, N'Paid', N'Cash', 500000, 18, 0, NULL, NULL, NULL), -- suat 516 | Ngày Con Còn Mẹ | 28/11 11:15 | Phòng 3 | G6 G7 G8
(2965, 9, 21, '2026-11-28T09:19:11', 150000, N'Paid', N'Cash', 500000, 7, 0, NULL, NULL, NULL), -- suat 539 | Trại Giam Hạnh Phúc | 29/11 09:00 | Phòng 1 | C6 C7
(2966, 9, NULL, '2026-11-28T09:20:56', 180000, N'Cancelled', N'Cash', 180000, 0, 0, N'Khách đổi ý', '2026-11-28T10:33:31', 9), -- suat 515 | Ma Mút Con Vượt Kỷ Băng Hà | 28/11 11:15 | Phòng 2 | F6 F7
(2967, 10, NULL, '2026-11-28T09:21:58', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 514 | Kiến Lé Phiêu Lưu Ké | 28/11 09:30 | Phòng 3 | E5 E6 E7 E8
(2968, 9, 104, '2026-11-28T09:30:36', 75000, N'Paid', N'Transfer', NULL, 3, 0, NULL, NULL, NULL), -- suat 520 | Hexed: Thế Giới Phép Thuật | 28/11 12:45 | Phòng 2 | C7
(2969, 10, NULL, '2026-11-28T09:31:26', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 553 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 15:00 | Phòng 5 | G6 G7
(2970, 9, NULL, '2026-11-28T09:33:50', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 515 | Ma Mút Con Vượt Kỷ Băng Hà | 28/11 11:15 | Phòng 2 | E6 E7
(2971, 3, NULL, '2026-11-28T09:38:49', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 555 | Chị Chị Em Em 3 | 29/11 16:00 | Phòng 3 | G5
(2972, 10, 60, '2026-11-28T09:39:31', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 517 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 28/11 11:30 | Phòng 1 | D6 D7 D8
(2973, 10, 111, '2026-11-28T09:41:58', 108000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 561 | Godzilla Trừ Không | 29/11 18:30 | Phòng 4 | F7
(2974, 9, NULL, '2026-11-28T09:45:26', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 563 | Mẹ Mìn: Giao Kèo Với Quỷ | 29/11 21:00 | Phòng 1 | G5 G6 G7
(2975, 3, NULL, '2026-11-28T09:46:30', 225000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 562 | Bò Sữa Bay | 29/11 19:30 | Phòng 2 | B6 B7 B8
(2976, 9, NULL, '2026-11-28T09:53:21', 216000, N'Paid', N'Cash', 220000, 0, 0, NULL, NULL, NULL), -- suat 525 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:30 | Phòng 4 | G9 G10
(2977, 10, NULL, '2026-11-28T09:55:20', 225000, N'Paid', N'Cash', 225000, 0, 0, NULL, NULL, NULL), -- suat 540 | Hexed: Thế Giới Phép Thuật | 29/11 09:00 | Phòng 2 | C8 C9 C10
(2978, 10, NULL, '2026-11-28T09:56:40', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 516 | Ngày Con Còn Mẹ | 28/11 11:15 | Phòng 3 | F6 F7
(2979, 9, 60, '2026-11-28T10:01:44', 360000, N'Paid', N'Cash', 360000, 25, 0, NULL, NULL, NULL), -- suat 523 | Ngày Con Còn Mẹ | 28/11 15:00 | Phòng 2 | E6 E7 E8 E9
(2980, 10, 116, '2026-11-28T10:10:08', 180000, N'Paid', N'Cash', 180000, 18, 0, NULL, NULL, NULL), -- suat 516 | Ngày Con Còn Mẹ | 28/11 11:15 | Phòng 3 | J9 J10
(2981, 10, NULL, '2026-11-28T10:12:04', 180000, N'Cancelled', N'Card', NULL, 0, 0, N'Nhầm suất / ghế', '2026-11-28T10:17:41', 10), -- suat 584 | Chị Chị Em Em 3 | 30/11 16:00 | Phòng 3 | H6 H7
(2982, 3, 41, '2026-11-28T10:16:34', 75000, N'Paid', N'Transfer', NULL, 3, 0, NULL, NULL, NULL), -- suat 528 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 28/11 17:15 | Phòng 2 | C7
(2983, 10, NULL, '2026-11-28T10:17:03', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 529 | Dune: Hành Tinh Cát - Phần Hai | 28/11 18:00 | Phòng 5 | G2 G3 G4
(2984, 3, NULL, '2026-11-28T10:18:37', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 519 | Godzilla Trừ Không | 28/11 12:15 | Phòng 5 | E6
(2985, 10, NULL, '2026-11-28T10:19:42', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 573 | Ma Mút Con Vượt Kỷ Băng Hà | 30/11 11:15 | Phòng 2 | E6
(2986, 10, NULL, '2026-11-28T10:22:42', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 518 | Ramayana: Khởi Nguồn Một Huyền Thoại | 28/11 12:15 | Phòng 4 | D4 D5 D6 D7
(2987, 10, 47, '2026-11-28T10:30:27', 270000, N'Paid', N'Cash', 300000, 18, 0, NULL, NULL, NULL), -- suat 517 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 28/11 11:30 | Phòng 1 | F7 F8 F9
(2988, 3, NULL, '2026-11-28T10:42:03', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 565 | Godzilla Trừ Không | 29/11 21:15 | Phòng 5 | H5 H6
(2989, 10, NULL, '2026-11-28T10:46:16', 216000, N'Paid', N'Cash', 220000, 0, 0, NULL, NULL, NULL), -- suat 525 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:30 | Phòng 4 | G5 G6
(2990, 9, NULL, '2026-11-28T10:49:53', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 519 | Godzilla Trừ Không | 28/11 12:15 | Phòng 5 | F9 F10
(2991, 3, NULL, '2026-11-28T10:51:30', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 518 | Ramayana: Khởi Nguồn Một Huyền Thoại | 28/11 12:15 | Phòng 4 | H4 H5
(2992, 9, 1, '2026-11-28T10:53:26', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 515 | Ma Mút Con Vượt Kỷ Băng Hà | 28/11 11:15 | Phòng 2 | C5 C6
(2993, 9, 108, '2026-11-28T10:54:33', 147000, N'Paid', N'Cash', 200000, 7, 33, NULL, NULL, NULL), -- suat 518 | Ramayana: Khởi Nguồn Một Huyền Thoại | 28/11 12:15 | Phòng 4 | A6 A7
(2994, 3, 114, '2026-11-28T10:55:58', 300000, N'Paid', N'Cash', 300000, 15, 0, NULL, NULL, NULL), -- suat 526 | Chị Chị Em Em 3 | 28/11 16:00 | Phòng 3 | B5 B6 B7 B8
(2995, 9, NULL, '2026-11-28T11:01:32', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 561 | Godzilla Trừ Không | 29/11 18:30 | Phòng 4 | E5 E6 E7 E8
(2996, 3, NULL, '2026-11-28T11:04:52', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 587 | Dune: Hành Tinh Cát - Phần Hai | 30/11 18:00 | Phòng 5 | H6 H7
(2997, 3, NULL, '2026-11-28T11:10:37', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 570 | Dune: Hành Tinh Cát - Phần Hai | 30/11 09:00 | Phòng 5 | L5 L6
(2998, 3, 108, '2026-11-28T11:15:39', 144000, N'Paid', N'Cash', 500000, 10, 0, NULL, NULL, NULL), -- suat 519 | Godzilla Trừ Không | 28/11 12:15 | Phòng 5 | E7
(2999, 9, NULL, '2026-11-28T11:18:10', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 520 | Hexed: Thế Giới Phép Thuật | 28/11 12:45 | Phòng 2 | J5 J6
(3000, 3, NULL, '2026-11-28T11:18:17', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 557 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 29/11 17:15 | Phòng 2 | C2 C3
(3001, 3, NULL, '2026-11-28T11:19:20', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 533 | Bò Sữa Bay | 28/11 19:30 | Phòng 2 | F6 F7
(3002, 9, 48, '2026-11-28T11:19:26', 432000, N'Paid', N'Transfer', NULL, 43, 0, NULL, NULL, NULL), -- suat 518 | Ramayana: Khởi Nguồn Một Huyền Thoại | 28/11 12:15 | Phòng 4 | J1 J2 J3 J4
(3003, 3, NULL, '2026-11-28T11:21:27', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 555 | Chị Chị Em Em 3 | 29/11 16:00 | Phòng 3 | J11 J12
(3004, 10, NULL, '2026-11-28T11:23:26', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 519 | Godzilla Trừ Không | 28/11 12:15 | Phòng 5 | G7
(3005, 9, NULL, '2026-11-28T11:24:25', 150000, N'Cancelled', N'Card', NULL, 0, 0, N'Khách đổi ý', '2026-11-28T12:31:26', 9), -- suat 528 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 28/11 17:15 | Phòng 2 | B5 B6
(3006, 9, NULL, '2026-11-28T11:31:05', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 522 | Trại Giam Hạnh Phúc | 28/11 13:45 | Phòng 1 | E5 E6 E7
(3007, 9, NULL, '2026-11-28T11:33:32', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 521 | Bí Kíp Luyện Cướp | 28/11 13:30 | Phòng 3 | G5 G6
(3008, 3, NULL, '2026-11-28T11:36:46', 576000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 519 | Godzilla Trừ Không | 28/11 12:15 | Phòng 5 | J5 J6 J7 J8
(3009, 10, 64, '2026-11-28T11:41:09', 124000, N'Paid', N'Cash', 124000, 8, 20, NULL, NULL, NULL), -- suat 519 | Godzilla Trừ Không | 28/11 12:15 | Phòng 5 | J9
(3010, 10, NULL, '2026-11-28T11:44:16', 240000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 519 | Godzilla Trừ Không | 28/11 12:15 | Phòng 5 | D7 D8
(3011, 9, NULL, '2026-11-28T11:46:09', 216000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 532 | Godzilla Trừ Không | 28/11 18:30 | Phòng 4 | H6 H7
(3012, 10, NULL, '2026-11-28T11:47:25', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 520 | Hexed: Thế Giới Phép Thuật | 28/11 12:45 | Phòng 2 | G5 G6
(3013, 10, NULL, '2026-11-28T11:49:02', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 520 | Hexed: Thế Giới Phép Thuật | 28/11 12:45 | Phòng 2 | E8 E9 E10 E11
(3014, 3, NULL, '2026-11-28T11:56:01', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 519 | Godzilla Trừ Không | 28/11 12:15 | Phòng 5 | F7 F8
(3015, 10, NULL, '2026-11-28T11:57:02', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 531 | Điểm Mù | 28/11 18:30 | Phòng 3 | A6 A7
(3016, 9, 27, '2026-11-28T12:00:55', 180000, N'Paid', N'Cash', 180000, 18, 0, NULL, NULL, NULL), -- suat 520 | Hexed: Thế Giới Phép Thuật | 28/11 12:45 | Phòng 2 | J11 J12
(3017, 10, NULL, '2026-11-28T12:02:54', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 530 | Trại Giam Hạnh Phúc | 28/11 18:30 | Phòng 1 | E6 E7
(3018, 3, 101, '2026-11-28T12:11:35', 216000, N'Paid', N'Cash', 216000, 15, 0, NULL, NULL, NULL), -- suat 564 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 21:00 | Phòng 4 | G3 G4
(3019, 3, NULL, '2026-11-28T12:11:49', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 520 | Hexed: Thế Giới Phép Thuật | 28/11 12:45 | Phòng 2 | G7
(3020, 9, NULL, '2026-11-28T12:14:06', 720000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 524 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:00 | Phòng 5 | K8 K9 K10 K11 K12
(3021, 10, NULL, '2026-11-28T12:22:54', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 520 | Hexed: Thế Giới Phép Thuật | 28/11 12:45 | Phòng 2 | E6 E7
(3022, 10, NULL, '2026-11-28T12:26:51', 240000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 577 | Godzilla Trừ Không | 30/11 12:15 | Phòng 5 | C7 C8
(3023, 9, NULL, '2026-11-28T12:36:26', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 561 | Godzilla Trừ Không | 29/11 18:30 | Phòng 4 | A4 A5 A6
(3024, 10, 78, '2026-11-28T12:37:42', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 521 | Bí Kíp Luyện Cướp | 28/11 13:30 | Phòng 3 | E6 E7
(3025, 9, NULL, '2026-11-28T12:38:49', 240000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 524 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:00 | Phòng 5 | A4 A5
(3026, 10, NULL, '2026-11-28T12:40:51', 450000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 528 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 28/11 17:15 | Phòng 2 | E1 E2 E3 E4 E5
(3027, 10, NULL, '2026-11-28T12:42:30', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 522 | Trại Giam Hạnh Phúc | 28/11 13:45 | Phòng 1 | D6 D7 D8
(3028, 3, NULL, '2026-11-28T12:44:34', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 521 | Bí Kíp Luyện Cướp | 28/11 13:30 | Phòng 3 | H5 H6
(3029, 9, 78, '2026-11-28T12:44:43', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 531 | Điểm Mù | 28/11 18:30 | Phòng 3 | E6 E7
(3030, 3, NULL, '2026-11-28T12:46:32', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 526 | Chị Chị Em Em 3 | 28/11 16:00 | Phòng 3 | J5 J6
(3031, 9, NULL, '2026-11-28T12:52:41', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 531 | Điểm Mù | 28/11 18:30 | Phòng 3 | B7 B8
(3032, 9, 49, '2026-11-28T12:53:15', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 521 | Bí Kíp Luyện Cướp | 28/11 13:30 | Phòng 3 | G7 G8
(3033, 10, NULL, '2026-11-28T12:57:07', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 530 | Trại Giam Hạnh Phúc | 28/11 18:30 | Phòng 1 | C6
(3034, 3, 80, '2026-11-28T12:59:43', 216000, N'Paid', N'Cash', 216000, 15, 0, NULL, NULL, NULL), -- suat 561 | Godzilla Trừ Không | 29/11 18:30 | Phòng 4 | D8 D9
(3035, 3, NULL, '2026-11-28T13:00:49', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 533 | Bò Sữa Bay | 28/11 19:30 | Phòng 2 | H4
(3036, 10, NULL, '2026-11-28T13:01:37', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 535 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 21:00 | Phòng 4 | D7 D8
(3037, 10, 96, '2026-11-28T13:05:20', 270000, N'Paid', N'Cash', 500000, 18, 0, NULL, NULL, NULL), -- suat 527 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 16:15 | Phòng 1 | G7 G8 G9
(3038, 10, NULL, '2026-11-28T13:05:32', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 525 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:30 | Phòng 4 | A6 A7
(3039, 10, NULL, '2026-11-28T13:15:26', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 554 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 15:30 | Phòng 4 | H6 H7
(3040, 3, NULL, '2026-11-28T13:15:59', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 549 | Hexed: Thế Giới Phép Thuật | 29/11 12:45 | Phòng 2 | D6 D7
(3041, 3, NULL, '2026-11-28T13:19:00', 225000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 556 | Mẹ Mìn: Giao Kèo Với Quỷ | 29/11 16:15 | Phòng 1 | C6 C7 C8
(3042, 3, NULL, '2026-11-28T13:25:45', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 528 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 28/11 17:15 | Phòng 2 | H7 H8
(3043, 10, NULL, '2026-11-28T13:28:59', 225000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 523 | Ngày Con Còn Mẹ | 28/11 15:00 | Phòng 2 | C8 C9 C10
(3044, 9, NULL, '2026-11-28T13:29:15', 432000, N'Paid', N'Cash', 440000, 0, 0, NULL, NULL, NULL), -- suat 564 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 21:00 | Phòng 4 | J1 J2 J3 J4
(3045, 3, NULL, '2026-11-28T13:33:03', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 522 | Trại Giam Hạnh Phúc | 28/11 13:45 | Phòng 1 | F5 F6
(3046, 10, NULL, '2026-11-28T13:35:14', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 526 | Chị Chị Em Em 3 | 28/11 16:00 | Phòng 3 | D7 D8
(3047, 9, NULL, '2026-11-28T13:37:40', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 526 | Chị Chị Em Em 3 | 28/11 16:00 | Phòng 3 | E9 E10 E11
(3048, 3, NULL, '2026-11-28T13:37:58', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 551 | Trại Giam Hạnh Phúc | 29/11 13:45 | Phòng 1 | J11 J12
(3049, 10, 29, '2026-11-28T13:40:01', 450000, N'Paid', N'Transfer', NULL, 31, 0, NULL, NULL, NULL), -- suat 538 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:45 | Phòng 3 | H4 H5 H6 H7 H8
(3050, 10, 93, '2026-11-28T13:42:27', 278000, N'Paid', N'Cash', 300000, 19, 46, NULL, NULL, NULL), -- suat 535 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 21:00 | Phòng 4 | H8 H9 H10
(3051, 3, 102, '2026-11-28T13:50:44', 120000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 524 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:00 | Phòng 5 | C8
(3052, 9, NULL, '2026-11-28T13:52:46', 75000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 559 | Trại Giam Hạnh Phúc | 29/11 18:30 | Phòng 1 | C6
(3053, 3, NULL, '2026-11-28T13:56:04', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 527 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 16:15 | Phòng 1 | F6 F7 F8
(3054, 3, 15, '2026-11-28T13:59:15', 153000, N'Paid', N'Transfer', NULL, 15, 27, NULL, NULL, NULL), -- suat 528 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 28/11 17:15 | Phòng 2 | J7 J8
(3055, 10, NULL, '2026-11-28T14:07:22', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 524 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:00 | Phòng 5 | K6
(3056, 3, 13, '2026-11-28T14:09:40', 75000, N'Paid', N'Cash', 75000, 3, 0, NULL, NULL, NULL), -- suat 540 | Hexed: Thế Giới Phép Thuật | 29/11 09:00 | Phòng 2 | C6
(3057, 10, 86, '2026-11-28T14:11:00', 240000, N'Cancelled', N'Cash', 240000, 12, 0, N'Khách đổi ý', '2026-11-28T14:50:48', 10), -- suat 529 | Dune: Hành Tinh Cát - Phần Hai | 28/11 18:00 | Phòng 5 | A6 A7
(3058, 3, NULL, '2026-11-28T14:11:50', 720000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 529 | Dune: Hành Tinh Cát - Phần Hai | 28/11 18:00 | Phòng 5 | G5 G6 G7 G8 G9
(3059, 3, NULL, '2026-11-28T14:12:21', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 523 | Ngày Con Còn Mẹ | 28/11 15:00 | Phòng 2 | D6 D7
(3060, 9, 35, '2026-11-28T14:13:21', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 530 | Trại Giam Hạnh Phúc | 28/11 18:30 | Phòng 1 | D6 D7
(3061, 3, NULL, '2026-11-28T14:15:07', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 524 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:00 | Phòng 5 | E4 E5
(3062, 9, NULL, '2026-11-28T14:16:35', 324000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 532 | Godzilla Trừ Không | 28/11 18:30 | Phòng 4 | H10 H11 H12
(3063, 9, 96, '2026-11-28T14:18:54', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 534 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:00 | Phòng 1 | D10
(3064, 10, NULL, '2026-11-28T14:20:16', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 525 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:30 | Phòng 4 | J7 J8
(3065, 10, NULL, '2026-11-28T14:21:09', 480000, N'Paid', N'Cash', 480000, 0, 0, NULL, NULL, NULL), -- suat 524 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:00 | Phòng 5 | C4 C5 C6 C7
(3066, 9, NULL, '2026-11-28T14:23:40', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 524 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:00 | Phòng 5 | E8 E9
(3067, 9, NULL, '2026-11-28T14:25:17', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 526 | Chị Chị Em Em 3 | 28/11 16:00 | Phòng 3 | F6 F7
(3068, 3, NULL, '2026-11-28T14:25:36', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 524 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:00 | Phòng 5 | E6
(3069, 10, NULL, '2026-11-28T14:25:44', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 535 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 21:00 | Phòng 4 | G6 G7
(3070, 3, NULL, '2026-11-28T14:28:46', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 533 | Bò Sữa Bay | 28/11 19:30 | Phòng 2 | H1 H2 H3
(3071, 3, 72, '2026-11-28T14:29:49', 648000, N'Paid', N'Card', NULL, 45, 0, NULL, NULL, NULL), -- suat 525 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:30 | Phòng 4 | E4 E5 E6 E7 E8 E9
(3072, 3, NULL, '2026-11-28T14:32:09', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 524 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:00 | Phòng 5 | K5
(3073, 9, 78, '2026-11-28T14:34:25', 108000, N'Paid', N'Cash', 108000, 7, 0, NULL, NULL, NULL), -- suat 525 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:30 | Phòng 4 | E11
(3074, 10, NULL, '2026-11-28T14:36:40', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 530 | Trại Giam Hạnh Phúc | 28/11 18:30 | Phòng 1 | H6 H7
(3075, 9, NULL, '2026-11-28T14:41:40', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 524 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:00 | Phòng 5 | L11 L12
(3076, 10, 28, '2026-11-28T14:41:57', 300000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 523 | Ngày Con Còn Mẹ | 28/11 15:00 | Phòng 2 | A5 A6 A7 A8
(3077, 3, NULL, '2026-11-28T14:42:12', 150000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 526 | Chị Chị Em Em 3 | 28/11 16:00 | Phòng 3 | A6 A7
(3078, 3, NULL, '2026-11-28T14:42:28', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 525 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:30 | Phòng 4 | G7
(3079, 3, 22, '2026-11-28T14:44:58', 180000, N'Paid', N'Cash', 180000, 9, 0, NULL, NULL, NULL), -- suat 532 | Godzilla Trừ Không | 28/11 18:30 | Phòng 4 | C7 C8
(3080, 9, 28, '2026-11-28T14:46:49', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 528 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 28/11 17:15 | Phòng 2 | E6 E7
(3081, 3, NULL, '2026-11-28T14:47:11', 120000, N'Paid', N'Cash', 120000, 0, 0, NULL, NULL, NULL), -- suat 524 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:00 | Phòng 5 | B9
(3082, 3, 21, '2026-11-28T14:47:55', 90000, N'Paid', N'Transfer', NULL, 4, 0, NULL, NULL, NULL), -- suat 532 | Godzilla Trừ Không | 28/11 18:30 | Phòng 4 | A6
(3083, 9, 109, '2026-11-28T14:48:53', 180000, N'Paid', N'Cash', 200000, 18, 0, NULL, NULL, NULL), -- suat 530 | Trại Giam Hạnh Phúc | 28/11 18:30 | Phòng 1 | J9 J10
(3084, 3, NULL, '2026-11-28T14:50:31', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 525 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 15:30 | Phòng 4 | D6 D7
(3085, 3, NULL, '2026-11-28T14:50:51', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 523 | Ngày Con Còn Mẹ | 28/11 15:00 | Phòng 2 | G5 G6
(3086, 10, NULL, '2026-11-28T14:56:38', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 533 | Bò Sữa Bay | 28/11 19:30 | Phòng 2 | F4 F5
(3087, 10, NULL, '2026-11-28T14:57:53', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 529 | Dune: Hành Tinh Cát - Phần Hai | 28/11 18:00 | Phòng 5 | E6 E7
(3088, 10, 42, '2026-11-28T14:58:43', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 527 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 16:15 | Phòng 1 | E7
(3089, 9, NULL, '2026-11-28T14:59:00', 270000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 533 | Bò Sữa Bay | 28/11 19:30 | Phòng 2 | H8 H9 H10
(3090, 4, NULL, '2026-11-28T15:09:07', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 529 | Dune: Hành Tinh Cát - Phần Hai | 28/11 18:00 | Phòng 5 | K5 K6 K7 K8
(3091, 6, NULL, '2026-11-28T15:12:10', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 528 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 28/11 17:15 | Phòng 2 | D5 D6 D7
(3092, 4, NULL, '2026-11-28T15:12:29', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 527 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 16:15 | Phòng 1 | D5 D6 D7 D8
(3093, 5, NULL, '2026-11-28T15:17:59', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 526 | Chị Chị Em Em 3 | 28/11 16:00 | Phòng 3 | G5 G6
(3094, 5, NULL, '2026-11-28T15:19:36', 108000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 532 | Godzilla Trừ Không | 28/11 18:30 | Phòng 4 | H8
(3095, 6, NULL, '2026-11-28T15:23:25', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 534 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:00 | Phòng 1 | E6 E7
(3096, 5, NULL, '2026-11-28T15:26:31', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 537 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 28/11 21:45 | Phòng 2 | D8 D9
(3097, 6, 75, '2026-11-28T15:26:38', 324000, N'Paid', N'Transfer', NULL, 22, 0, NULL, NULL, NULL), -- suat 532 | Godzilla Trừ Không | 28/11 18:30 | Phòng 4 | F4 F5 F6
(3098, 5, NULL, '2026-11-28T15:32:02', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 557 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 29/11 17:15 | Phòng 2 | B6 B7
(3099, 5, NULL, '2026-11-28T15:32:46', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 530 | Trại Giam Hạnh Phúc | 28/11 18:30 | Phòng 1 | H8 H9
(3100, 5, NULL, '2026-11-28T15:36:07', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 531 | Điểm Mù | 28/11 18:30 | Phòng 3 | F6 F7 F8
(3101, 6, NULL, '2026-11-28T15:37:01', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 550 | Bí Kíp Luyện Cướp | 29/11 13:30 | Phòng 3 | B5 B6
(3102, 6, NULL, '2026-11-28T15:37:29', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 529 | Dune: Hành Tinh Cát - Phần Hai | 28/11 18:00 | Phòng 5 | J7 J8
(3103, 6, NULL, '2026-11-28T15:39:34', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 543 | Kiến Lé Phiêu Lưu Ké | 29/11 09:30 | Phòng 3 | D3 D4 D5 D6
(3104, 4, NULL, '2026-11-28T15:42:38', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 527 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 16:15 | Phòng 1 | J11 J12
(3105, 4, 70, '2026-11-28T15:50:27', 225000, N'Paid', N'Transfer', NULL, 11, 0, NULL, NULL, NULL), -- suat 538 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:45 | Phòng 3 | B5 B6 B7
(3106, 6, NULL, '2026-11-28T15:58:29', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 561 | Godzilla Trừ Không | 29/11 18:30 | Phòng 4 | B7 B8
(3107, 5, NULL, '2026-11-28T16:01:32', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 528 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 28/11 17:15 | Phòng 2 | G7 G8
(3108, 6, NULL, '2026-11-28T16:04:26', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 534 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:00 | Phòng 1 | D7 D8
(3109, 6, 104, '2026-11-28T16:04:59', 156000, N'Paid', N'Transfer', NULL, 10, 24, NULL, NULL, NULL), -- suat 528 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 28/11 17:15 | Phòng 2 | G5 G6
(3110, 4, NULL, '2026-11-28T16:08:10', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 536 | Godzilla Trừ Không | 28/11 21:15 | Phòng 5 | F7 F8 F9
(3111, 6, 108, '2026-11-28T16:12:49', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 560 | Điểm Mù | 29/11 18:30 | Phòng 3 | G6 G7
(3112, 6, NULL, '2026-11-28T16:12:53', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 528 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 28/11 17:15 | Phòng 2 | F4 F5 F6 F7
(3113, 6, 88, '2026-11-28T16:15:23', 75000, N'Paid', N'Cash', 100000, 3, 0, NULL, NULL, NULL), -- suat 579 | Bí Kíp Luyện Cướp | 30/11 13:30 | Phòng 3 | C7
(3114, 5, NULL, '2026-11-28T16:18:06', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 532 | Godzilla Trừ Không | 28/11 18:30 | Phòng 4 | G6 G7
(3115, 5, NULL, '2026-11-28T16:18:50', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 528 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 28/11 17:15 | Phòng 2 | E10 E11
(3116, 5, NULL, '2026-11-28T16:26:08', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 531 | Điểm Mù | 28/11 18:30 | Phòng 3 | H8
(3117, 5, NULL, '2026-11-28T16:26:25', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 531 | Điểm Mù | 28/11 18:30 | Phòng 3 | H6
(3118, 6, NULL, '2026-11-28T16:42:03', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 531 | Điểm Mù | 28/11 18:30 | Phòng 3 | D11 D12
(3119, 4, 34, '2026-11-28T16:45:21', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 561 | Godzilla Trừ Không | 29/11 18:30 | Phòng 4 | F9 F10
(3120, 6, NULL, '2026-11-28T16:45:54', 144000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 529 | Dune: Hành Tinh Cát - Phần Hai | 28/11 18:00 | Phòng 5 | F7
(3121, 6, NULL, '2026-11-28T16:46:24', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 528 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 28/11 17:15 | Phòng 2 | H5 H6
(3122, 5, NULL, '2026-11-28T16:46:50', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 529 | Dune: Hành Tinh Cát - Phần Hai | 28/11 18:00 | Phòng 5 | E4 E5
(3123, 5, 70, '2026-11-28T16:47:18', 270000, N'Paid', N'Cash', 300000, 18, 0, NULL, NULL, NULL), -- suat 528 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 28/11 17:15 | Phòng 2 | D8 D9 D10
(3124, 4, NULL, '2026-11-28T16:48:27', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 531 | Điểm Mù | 28/11 18:30 | Phòng 3 | D5 D6 D7 D8
(3125, 6, NULL, '2026-11-28T16:48:53', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 532 | Godzilla Trừ Không | 28/11 18:30 | Phòng 4 | F8 F9
(3126, 5, 93, '2026-11-28T16:48:54', 576000, N'Paid', N'Cash', 576000, 57, 0, NULL, NULL, NULL), -- suat 536 | Godzilla Trừ Không | 28/11 21:15 | Phòng 5 | L5 L6 L7 L8
(3127, 5, 28, '2026-11-28T16:53:08', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 537 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 28/11 21:45 | Phòng 2 | B8 B9
(3128, 4, NULL, '2026-11-28T16:53:27', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 537 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 28/11 21:45 | Phòng 2 | B10
(3129, 5, NULL, '2026-11-28T16:54:11', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 566 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 29/11 21:45 | Phòng 2 | F11 F12
(3130, 4, NULL, '2026-11-28T16:54:47', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 530 | Trại Giam Hạnh Phúc | 28/11 18:30 | Phòng 1 | F5 F6 F7
(3131, 6, NULL, '2026-11-28T16:57:49', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 529 | Dune: Hành Tinh Cát - Phần Hai | 28/11 18:00 | Phòng 5 | J6
(3132, 5, NULL, '2026-11-28T17:01:07', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 530 | Trại Giam Hạnh Phúc | 28/11 18:30 | Phòng 1 | F9 F10
(3133, 6, 69, '2026-11-28T17:03:18', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 532 | Godzilla Trừ Không | 28/11 18:30 | Phòng 4 | G9 G10
(3134, 5, NULL, '2026-11-28T17:03:24', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 530 | Trại Giam Hạnh Phúc | 28/11 18:30 | Phòng 1 | E4 E5
(3135, 6, NULL, '2026-11-28T17:04:31', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 530 | Trại Giam Hạnh Phúc | 28/11 18:30 | Phòng 1 | D3 D4
(3136, 5, NULL, '2026-11-28T17:06:42', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 531 | Điểm Mù | 28/11 18:30 | Phòng 3 | G7 G8
(3137, 5, NULL, '2026-11-28T17:07:46', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 533 | Bò Sữa Bay | 28/11 19:30 | Phòng 2 | H6 H7
(3138, 5, NULL, '2026-11-28T17:08:52', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 529 | Dune: Hành Tinh Cát - Phần Hai | 28/11 18:00 | Phòng 5 | G10 G11
(3139, 5, NULL, '2026-11-28T17:10:53', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 531 | Điểm Mù | 28/11 18:30 | Phòng 3 | D2 D3
(3140, 6, NULL, '2026-11-28T17:12:20', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 532 | Godzilla Trừ Không | 28/11 18:30 | Phòng 4 | B7
(3141, 4, 4, '2026-11-28T17:13:09', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 539 | Trại Giam Hạnh Phúc | 29/11 09:00 | Phòng 1 | E7 E8
(3142, 4, 108, '2026-11-28T17:13:27', 360000, N'Paid', N'Card', NULL, 25, 0, NULL, NULL, NULL), -- suat 533 | Bò Sữa Bay | 28/11 19:30 | Phòng 2 | E1 E2 E3 E4
(3143, 5, NULL, '2026-11-28T17:25:49', 324000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 535 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 21:00 | Phòng 4 | D4 D5 D6
(3144, 6, 55, '2026-11-28T17:26:43', 240000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 582 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 30/11 15:00 | Phòng 5 | C6 C7
(3145, 4, NULL, '2026-11-28T17:27:51', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 534 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:00 | Phòng 1 | G10 G11
(3146, 4, 29, '2026-11-28T17:31:18', 216000, N'Paid', N'Cash', 500000, 15, 0, NULL, NULL, NULL), -- suat 535 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 21:00 | Phòng 4 | H6 H7
(3147, 5, 15, '2026-11-28T17:34:41', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 538 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:45 | Phòng 3 | D6 D7
(3148, 4, NULL, '2026-11-28T17:37:10', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 529 | Dune: Hành Tinh Cát - Phần Hai | 28/11 18:00 | Phòng 5 | K9
(3149, 6, NULL, '2026-11-28T17:49:07', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 595 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 30/11 21:45 | Phòng 2 | E4
(3150, 5, NULL, '2026-11-28T17:52:49', 360000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-28T18:27:33', 5), -- suat 533 | Bò Sữa Bay | 28/11 19:30 | Phòng 2 | E5 E6 E7 E8
(3151, 4, 49, '2026-11-28T17:56:14', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 534 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:00 | Phòng 1 | G4 G5
(3152, 5, NULL, '2026-11-28T18:01:08', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 532 | Godzilla Trừ Không | 28/11 18:30 | Phòng 4 | C5 C6
(3153, 5, NULL, '2026-11-28T18:02:46', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 530 | Trại Giam Hạnh Phúc | 28/11 18:30 | Phòng 1 | D9 D10
(3154, 5, NULL, '2026-11-28T18:04:27', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 532 | Godzilla Trừ Không | 28/11 18:30 | Phòng 4 | H1 H2 H3 H4
(3155, 6, 80, '2026-11-28T18:04:40', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 530 | Trại Giam Hạnh Phúc | 28/11 18:30 | Phòng 1 | G4 G5
(3156, 6, NULL, '2026-11-28T18:06:09', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 531 | Điểm Mù | 28/11 18:30 | Phòng 3 | J1 J2
(3157, 5, NULL, '2026-11-28T18:15:34', 450000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 533 | Bò Sữa Bay | 28/11 19:30 | Phòng 2 | F8 F9 F10 F11 F12
(3158, 5, NULL, '2026-11-28T18:16:29', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 533 | Bò Sữa Bay | 28/11 19:30 | Phòng 2 | H11 H12
(3159, 4, NULL, '2026-11-28T18:22:55', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 533 | Bò Sữa Bay | 28/11 19:30 | Phòng 2 | B5 B6
(3160, 5, NULL, '2026-11-28T18:31:45', 216000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 535 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 21:00 | Phòng 4 | E4 E5
(3161, 5, 113, '2026-11-28T18:31:59', 250000, N'Paid', N'Transfer', NULL, 12, 20, NULL, NULL, NULL), -- suat 535 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 21:00 | Phòng 4 | B5 B6 B7
(3162, 4, NULL, '2026-11-28T18:33:30', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 537 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 28/11 21:45 | Phòng 2 | C6
(3163, 6, NULL, '2026-11-28T18:35:21', 270000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 533 | Bò Sữa Bay | 28/11 19:30 | Phòng 2 | D5 D6 D7
(3164, 5, NULL, '2026-11-28T18:40:20', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 541 | Dune: Hành Tinh Cát - Phần Hai | 29/11 09:00 | Phòng 5 | F7 F8
(3165, 4, NULL, '2026-11-28T18:54:59', 450000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 533 | Bò Sữa Bay | 28/11 19:30 | Phòng 2 | G7 G8 G9 G10 G11
(3166, 5, 21, '2026-11-28T18:58:02', 75000, N'Paid', N'Cash', 500000, 3, 0, NULL, NULL, NULL), -- suat 537 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 28/11 21:45 | Phòng 2 | B7
(3167, 5, 26, '2026-11-28T19:04:10', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 534 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:00 | Phòng 1 | J5 J6
(3168, 4, 64, '2026-11-28T19:06:33', 216000, N'Paid', N'Cash', 216000, 15, 0, NULL, NULL, NULL), -- suat 535 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 21:00 | Phòng 4 | D9 D10
(3169, 4, NULL, '2026-11-28T19:16:32', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 565 | Godzilla Trừ Không | 29/11 21:15 | Phòng 5 | E7 E8
(3170, 6, 93, '2026-11-28T19:18:28', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 536 | Godzilla Trừ Không | 28/11 21:15 | Phòng 5 | J6 J7
(3171, 6, 67, '2026-11-28T19:23:19', 360000, N'Paid', N'Cash', 360000, 36, 0, NULL, NULL, NULL), -- suat 566 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 29/11 21:45 | Phòng 2 | J9 J10 J11 J12
(3172, 6, NULL, '2026-11-28T19:29:27', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 549 | Hexed: Thế Giới Phép Thuật | 29/11 12:45 | Phòng 2 | H7
(3173, 6, NULL, '2026-11-28T19:31:00', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 568 | Trại Giam Hạnh Phúc | 30/11 09:00 | Phòng 1 | J1 J2
(3174, 4, NULL, '2026-11-28T19:44:04', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 534 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:00 | Phòng 1 | E8
(3175, 4, NULL, '2026-11-28T19:44:17', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 539 | Trại Giam Hạnh Phúc | 29/11 09:00 | Phòng 1 | J1 J2 J3 J4
(3176, 5, 63, '2026-11-28T19:45:52', 180000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 534 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:00 | Phòng 1 | J11 J12
(3177, 4, NULL, '2026-11-28T19:53:11', 300000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 537 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 28/11 21:45 | Phòng 2 | B3 B4 B5 B6
(3178, 5, NULL, '2026-11-28T19:54:23', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 534 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:00 | Phòng 1 | E9 E10 E11 E12
(3179, 6, NULL, '2026-11-28T20:08:13', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 535 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 21:00 | Phòng 4 | A6 A7 A8
(3180, 6, NULL, '2026-11-28T20:11:35', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 534 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:00 | Phòng 1 | F6 F7
(3181, 5, 32, '2026-11-28T20:17:01', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 534 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:00 | Phòng 1 | G6 G7
(3182, 6, 21, '2026-11-28T20:17:08', 180000, N'Paid', N'Cash', 180000, 9, 0, NULL, NULL, NULL), -- suat 535 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 21:00 | Phòng 4 | C7 C8
(3183, 5, 38, '2026-11-28T20:17:33', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 538 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:45 | Phòng 3 | B9 B10
(3184, 6, 108, '2026-11-28T20:18:08', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 534 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:00 | Phòng 1 | H6 H7
(3185, 5, NULL, '2026-11-28T20:30:41', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 537 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 28/11 21:45 | Phòng 2 | A5 A6
(3186, 6, NULL, '2026-11-28T20:30:59', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 537 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 28/11 21:45 | Phòng 2 | A8 A9
(3187, 6, 66, '2026-11-28T20:33:31', 216000, N'Paid', N'Cash', 300000, 21, 0, NULL, NULL, NULL), -- suat 535 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 21:00 | Phòng 4 | J3 J4
(3188, 5, NULL, '2026-11-28T20:33:42', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 538 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:45 | Phòng 3 | E6 E7 E8
(3189, 4, 70, '2026-11-28T20:34:54', 240000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 536 | Godzilla Trừ Không | 28/11 21:15 | Phòng 5 | B8 B9
(3190, 6, NULL, '2026-11-28T20:39:43', 720000, N'Paid', N'Cash', 720000, 0, 0, NULL, NULL, NULL), -- suat 536 | Godzilla Trừ Không | 28/11 21:15 | Phòng 5 | J8 J9 J10 J11 J12
(3191, 4, NULL, '2026-11-28T20:39:56', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 537 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 28/11 21:45 | Phòng 2 | H4 H5
(3192, 4, 80, '2026-11-28T20:40:50', 180000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 534 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:00 | Phòng 1 | D1 D2
(3193, 6, NULL, '2026-11-28T20:43:22', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 538 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:45 | Phòng 3 | B11 B12
(3194, 6, 73, '2026-11-28T20:45:06', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 537 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 28/11 21:45 | Phòng 2 | F5 F6 F7 F8
(3195, 6, NULL, '2026-11-28T20:45:09', 300000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 538 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:45 | Phòng 3 | B1 B2 B3 B4
(3196, 6, NULL, '2026-11-28T20:45:11', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 537 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 28/11 21:45 | Phòng 2 | E7 E8
(3197, 5, NULL, '2026-11-28T20:45:20', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 534 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:00 | Phòng 1 | E4 E5
(3198, 4, NULL, '2026-11-28T20:45:35', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 535 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 28/11 21:00 | Phòng 4 | B9 B10 B11 B12
(3199, 5, NULL, '2026-11-28T20:45:57', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 534 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:00 | Phòng 1 | D5 D6
(3200, 5, 110, '2026-11-28T20:51:40', 288000, N'Paid', N'Cash', 500000, 20, 0, NULL, NULL, NULL), -- suat 536 | Godzilla Trừ Không | 28/11 21:15 | Phòng 5 | K6 K7
(3201, 4, 115, '2026-11-28T20:54:28', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 555 | Chị Chị Em Em 3 | 29/11 16:00 | Phòng 3 | F5 F6
(3202, 4, 67, '2026-11-28T20:54:56', 151000, N'Paid', N'Transfer', NULL, 15, 29, NULL, NULL, NULL), -- suat 557 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 29/11 17:15 | Phòng 2 | J9 J10
(3203, 4, 49, '2026-11-28T21:03:19', 288000, N'Paid', N'Cash', 288000, 28, 0, NULL, NULL, NULL), -- suat 536 | Godzilla Trừ Không | 28/11 21:15 | Phòng 5 | L11 L12
(3204, 6, NULL, '2026-11-28T21:09:13', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 538 | Mẹ Mìn: Giao Kèo Với Quỷ | 28/11 21:45 | Phòng 3 | J11 J12
(3205, 4, NULL, '2026-11-28T21:18:32', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 537 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 28/11 21:45 | Phòng 2 | H6 H7
(3206, 4, 79, '2026-11-28T21:33:14', 90000, N'Paid', N'Cash', 90000, 4, 0, NULL, NULL, NULL), -- suat 564 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 21:00 | Phòng 4 | C6
(3207, 6, 24, '2026-11-28T21:34:56', 180000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL); -- suat 567 | Mẹ Mìn: Giao Kèo Với Quỷ | 29/11 21:45 | Phòng 3 | E9 E10
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(6721, 2930, 510, 1, 43, 90000, N'Active'),
(6722, 2931, 541, 5, 474, 120000, N'Active'),
(6723, 2931, 541, 5, 475, 120000, N'Active'),
(6724, 2932, 512, 5, 438, 120000, N'Active'),
(6725, 2932, 512, 5, 439, 120000, N'Active'),
(6726, 2933, 512, 5, 500, 144000, N'Active'),
(6727, 2933, 512, 5, 501, 144000, N'Active'),
(6728, 2933, 512, 5, 502, 144000, N'Active'),
(6729, 2934, 511, 2, 111, 75000, N'Active'),
(6730, 2934, 511, 2, 112, 75000, N'Active'),
(6731, 2935, 543, 3, 280, 90000, N'Active'),
(6732, 2935, 543, 3, 281, 90000, N'Active'),
(6733, 2936, 510, 1, 44, 90000, N'Active'),
(6734, 2936, 510, 1, 45, 90000, N'Active'),
(6735, 2937, 518, 4, 343, 90000, N'Active'),
(6736, 2937, 518, 4, 344, 90000, N'Active'),
(6737, 2938, 520, 2, 140, 75000, N'Active'),
(6738, 2939, 511, 2, 114, 75000, N'Active'),
(6739, 2939, 511, 2, 115, 75000, N'Active'),
(6740, 2940, 564, 4, 330, 90000, N'Active'),
(6741, 2940, 564, 4, 331, 90000, N'Active'),
(6742, 2941, 510, 1, 17, 75000, N'Active'),
(6743, 2941, 510, 1, 18, 75000, N'Active'),
(6744, 2941, 510, 1, 19, 75000, N'Active'),
(6745, 2942, 523, 2, 137, 75000, N'Active'),
(6746, 2942, 523, 2, 138, 75000, N'Active'),
(6747, 2943, 513, 4, 392, 108000, N'Cancelled'),
(6748, 2943, 513, 4, 393, 108000, N'Cancelled'),
(6749, 2944, 512, 5, 555, 144000, N'Active'),
(6750, 2944, 512, 5, 556, 144000, N'Active'),
(6751, 2945, 549, 2, 165, 90000, N'Active'),
(6752, 2945, 549, 2, 166, 90000, N'Active'),
(6753, 2946, 511, 2, 150, 90000, N'Active'),
(6754, 2947, 512, 5, 546, 144000, N'Active'),
(6755, 2947, 512, 5, 547, 144000, N'Active'),
(6756, 2948, 512, 5, 536, 144000, N'Active'),
(6757, 2948, 512, 5, 537, 144000, N'Active'),
(6758, 2949, 510, 1, 89, 90000, N'Active'),
(6759, 2949, 510, 1, 90, 90000, N'Active'),
(6760, 2950, 510, 1, 20, 75000, N'Active'),
(6761, 2950, 510, 1, 21, 75000, N'Active'),
(6762, 2951, 511, 2, 173, 90000, N'Active'),
(6763, 2951, 511, 2, 174, 90000, N'Active'),
(6764, 2951, 511, 2, 175, 90000, N'Active'),
(6765, 2951, 511, 2, 176, 90000, N'Active'),
(6766, 2952, 513, 4, 390, 108000, N'Active'),
(6767, 2953, 519, 5, 497, 144000, N'Active'),
(6768, 2953, 519, 5, 498, 144000, N'Active'),
(6769, 2954, 510, 1, 107, 90000, N'Active'),
(6770, 2954, 510, 1, 108, 90000, N'Active'),
(6771, 2955, 541, 5, 533, 144000, N'Active'),
(6772, 2955, 541, 5, 534, 144000, N'Active'),
(6773, 2956, 565, 5, 460, 120000, N'Active'),
(6774, 2956, 565, 5, 461, 120000, N'Active'),
(6775, 2956, 565, 5, 462, 120000, N'Active'),
(6776, 2956, 565, 5, 463, 120000, N'Active'),
(6777, 2956, 565, 5, 464, 120000, N'Active'),
(6778, 2956, 565, 5, 465, 120000, N'Active'),
(6779, 2957, 514, 3, 234, 75000, N'Active'),
(6780, 2957, 514, 3, 235, 75000, N'Active'),
(6781, 2958, 513, 4, 366, 108000, N'Active'),
(6782, 2958, 513, 4, 367, 108000, N'Active'),
(6783, 2959, 513, 4, 412, 108000, N'Active'),
(6784, 2959, 513, 4, 413, 108000, N'Active'),
(6785, 2960, 517, 1, 64, 90000, N'Active'),
(6786, 2960, 517, 1, 65, 90000, N'Active'),
(6787, 2960, 517, 1, 66, 90000, N'Active'),
(6788, 2961, 519, 5, 521, 144000, N'Active'),
(6789, 2961, 519, 5, 522, 144000, N'Active'),
(6790, 2961, 519, 5, 523, 144000, N'Active'),
(6791, 2962, 513, 4, 401, 108000, N'Active'),
(6792, 2962, 513, 4, 402, 108000, N'Active'),
(6793, 2962, 513, 4, 403, 108000, N'Active'),
(6794, 2963, 514, 3, 284, 90000, N'Active'),
(6795, 2963, 514, 3, 285, 90000, N'Active'),
(6796, 2964, 516, 3, 294, 90000, N'Active'),
(6797, 2964, 516, 3, 295, 90000, N'Active'),
(6798, 2964, 516, 3, 296, 90000, N'Active'),
(6799, 2965, 539, 1, 30, 75000, N'Active'),
(6800, 2965, 539, 1, 31, 75000, N'Active'),
(6801, 2966, 515, 2, 174, 90000, N'Cancelled'),
(6802, 2966, 515, 2, 175, 90000, N'Cancelled'),
(6803, 2967, 514, 3, 269, 90000, N'Active'),
(6804, 2967, 514, 3, 270, 90000, N'Active'),
(6805, 2967, 514, 3, 271, 90000, N'Active'),
(6806, 2967, 514, 3, 272, 90000, N'Active'),
(6807, 2968, 520, 2, 139, 75000, N'Active'),
(6808, 2969, 553, 5, 510, 144000, N'Active'),
(6809, 2969, 553, 5, 511, 144000, N'Active'),
(6810, 2970, 515, 2, 162, 90000, N'Active'),
(6811, 2970, 515, 2, 163, 90000, N'Active'),
(6812, 2971, 555, 3, 293, 90000, N'Active'),
(6813, 2972, 517, 1, 42, 90000, N'Active'),
(6814, 2972, 517, 1, 43, 90000, N'Active'),
(6815, 2972, 517, 1, 44, 90000, N'Active'),
(6816, 2973, 561, 4, 391, 108000, N'Active'),
(6817, 2974, 563, 1, 77, 90000, N'Active'),
(6818, 2974, 563, 1, 78, 90000, N'Active'),
(6819, 2974, 563, 1, 79, 90000, N'Active'),
(6820, 2975, 562, 2, 126, 75000, N'Active'),
(6821, 2975, 562, 2, 127, 75000, N'Active'),
(6822, 2975, 562, 2, 128, 75000, N'Active'),
(6823, 2976, 525, 4, 405, 108000, N'Active'),
(6824, 2976, 525, 4, 406, 108000, N'Active'),
(6825, 2977, 540, 2, 140, 75000, N'Active'),
(6826, 2977, 540, 2, 141, 75000, N'Active'),
(6827, 2977, 540, 2, 142, 75000, N'Active'),
(6828, 2978, 516, 3, 282, 90000, N'Active'),
(6829, 2978, 516, 3, 283, 90000, N'Active'),
(6830, 2979, 523, 2, 162, 90000, N'Active'),
(6831, 2979, 523, 2, 163, 90000, N'Active'),
(6832, 2979, 523, 2, 164, 90000, N'Active'),
(6833, 2979, 523, 2, 165, 90000, N'Active'),
(6834, 2980, 516, 3, 321, 90000, N'Active'),
(6835, 2980, 516, 3, 322, 90000, N'Active'),
(6836, 2981, 584, 3, 306, 90000, N'Cancelled'),
(6837, 2981, 584, 3, 307, 90000, N'Cancelled'),
(6838, 2982, 528, 2, 139, 75000, N'Active'),
(6839, 2983, 529, 5, 506, 144000, N'Active'),
(6840, 2983, 529, 5, 507, 144000, N'Active'),
(6841, 2983, 529, 5, 508, 144000, N'Active'),
(6842, 2984, 519, 5, 486, 144000, N'Active'),
(6843, 2985, 573, 2, 162, 90000, N'Active'),
(6844, 2986, 518, 4, 364, 108000, N'Active'),
(6845, 2986, 518, 4, 365, 108000, N'Active'),
(6846, 2986, 518, 4, 366, 108000, N'Active'),
(6847, 2986, 518, 4, 367, 108000, N'Active'),
(6848, 2987, 517, 1, 67, 90000, N'Active'),
(6849, 2987, 517, 1, 68, 90000, N'Active'),
(6850, 2987, 517, 1, 69, 90000, N'Active'),
(6851, 2988, 565, 5, 521, 144000, N'Active'),
(6852, 2988, 565, 5, 522, 144000, N'Active'),
(6853, 2989, 525, 4, 401, 108000, N'Active'),
(6854, 2989, 525, 4, 402, 108000, N'Active'),
(6855, 2990, 519, 5, 501, 144000, N'Active'),
(6856, 2990, 519, 5, 502, 144000, N'Active'),
(6857, 2991, 518, 4, 412, 108000, N'Active'),
(6858, 2991, 518, 4, 413, 108000, N'Active'),
(6859, 2992, 515, 2, 137, 75000, N'Active'),
(6860, 2992, 515, 2, 138, 75000, N'Active'),
(6861, 2993, 518, 4, 330, 90000, N'Active'),
(6862, 2993, 518, 4, 331, 90000, N'Active'),
(6863, 2994, 526, 3, 233, 75000, N'Active'),
(6864, 2994, 526, 3, 234, 75000, N'Active'),
(6865, 2994, 526, 3, 235, 75000, N'Active'),
(6866, 2994, 526, 3, 236, 75000, N'Active'),
(6867, 2995, 561, 4, 377, 108000, N'Active'),
(6868, 2995, 561, 4, 378, 108000, N'Active'),
(6869, 2995, 561, 4, 379, 108000, N'Active'),
(6870, 2995, 561, 4, 380, 108000, N'Active'),
(6871, 2996, 587, 5, 522, 144000, N'Active'),
(6872, 2996, 587, 5, 523, 144000, N'Active'),
(6873, 2997, 570, 5, 557, 144000, N'Active'),
(6874, 2997, 570, 5, 558, 144000, N'Active'),
(6875, 2998, 519, 5, 487, 144000, N'Active'),
(6876, 2999, 520, 2, 209, 90000, N'Active'),
(6877, 2999, 520, 2, 210, 90000, N'Active'),
(6878, 3000, 557, 2, 134, 75000, N'Active'),
(6879, 3000, 557, 2, 135, 75000, N'Active'),
(6880, 3001, 533, 2, 174, 90000, N'Active'),
(6881, 3001, 533, 2, 175, 90000, N'Active'),
(6882, 3002, 518, 4, 421, 108000, N'Active'),
(6883, 3002, 518, 4, 422, 108000, N'Active'),
(6884, 3002, 518, 4, 423, 108000, N'Active'),
(6885, 3002, 518, 4, 424, 108000, N'Active'),
(6886, 3003, 555, 3, 323, 90000, N'Active'),
(6887, 3003, 555, 3, 324, 90000, N'Active'),
(6888, 3004, 519, 5, 511, 144000, N'Active'),
(6889, 3005, 528, 2, 125, 75000, N'Cancelled'),
(6890, 3005, 528, 2, 126, 75000, N'Cancelled'),
(6891, 3006, 522, 1, 53, 90000, N'Active'),
(6892, 3006, 522, 1, 54, 90000, N'Active'),
(6893, 3006, 522, 1, 55, 90000, N'Active'),
(6894, 3007, 521, 3, 293, 90000, N'Active'),
(6895, 3007, 521, 3, 294, 90000, N'Active'),
(6896, 3008, 519, 5, 533, 144000, N'Active'),
(6897, 3008, 519, 5, 534, 144000, N'Active'),
(6898, 3008, 519, 5, 535, 144000, N'Active'),
(6899, 3008, 519, 5, 536, 144000, N'Active'),
(6900, 3009, 519, 5, 537, 144000, N'Active'),
(6901, 3010, 519, 5, 475, 120000, N'Active'),
(6902, 3010, 519, 5, 476, 120000, N'Active'),
(6903, 3011, 532, 4, 414, 108000, N'Active'),
(6904, 3011, 532, 4, 415, 108000, N'Active'),
(6905, 3012, 520, 2, 185, 90000, N'Active'),
(6906, 3012, 520, 2, 186, 90000, N'Active'),
(6907, 3013, 520, 2, 164, 90000, N'Active'),
(6908, 3013, 520, 2, 165, 90000, N'Active'),
(6909, 3013, 520, 2, 166, 90000, N'Active'),
(6910, 3013, 520, 2, 167, 90000, N'Active'),
(6911, 3014, 519, 5, 499, 144000, N'Active'),
(6912, 3014, 519, 5, 500, 144000, N'Active'),
(6913, 3015, 531, 3, 222, 75000, N'Active'),
(6914, 3015, 531, 3, 223, 75000, N'Active'),
(6915, 3016, 520, 2, 215, 90000, N'Active'),
(6916, 3016, 520, 2, 216, 90000, N'Active'),
(6917, 3017, 530, 1, 54, 90000, N'Active'),
(6918, 3017, 530, 1, 55, 90000, N'Active'),
(6919, 3018, 564, 4, 399, 108000, N'Active'),
(6920, 3018, 564, 4, 400, 108000, N'Active'),
(6921, 3019, 520, 2, 187, 90000, N'Active'),
(6922, 3020, 524, 5, 548, 144000, N'Active'),
(6923, 3020, 524, 5, 549, 144000, N'Active'),
(6924, 3020, 524, 5, 550, 144000, N'Active'),
(6925, 3020, 524, 5, 551, 144000, N'Active'),
(6926, 3020, 524, 5, 552, 144000, N'Active'),
(6927, 3021, 520, 2, 162, 90000, N'Active'),
(6928, 3021, 520, 2, 163, 90000, N'Active'),
(6929, 3022, 577, 5, 463, 120000, N'Active'),
(6930, 3022, 577, 5, 464, 120000, N'Active'),
(6931, 3023, 561, 4, 328, 90000, N'Active'),
(6932, 3023, 561, 4, 329, 90000, N'Active'),
(6933, 3023, 561, 4, 330, 90000, N'Active'),
(6934, 3024, 521, 3, 270, 90000, N'Active'),
(6935, 3024, 521, 3, 271, 90000, N'Active'),
(6936, 3025, 524, 5, 436, 120000, N'Active'),
(6937, 3025, 524, 5, 437, 120000, N'Active'),
(6938, 3026, 528, 2, 157, 90000, N'Active'),
(6939, 3026, 528, 2, 158, 90000, N'Active'),
(6940, 3026, 528, 2, 159, 90000, N'Active'),
(6941, 3026, 528, 2, 160, 90000, N'Active'),
(6942, 3026, 528, 2, 161, 90000, N'Active'),
(6943, 3027, 522, 1, 42, 90000, N'Active'),
(6944, 3027, 522, 1, 43, 90000, N'Active'),
(6945, 3027, 522, 1, 44, 90000, N'Active'),
(6946, 3028, 521, 3, 305, 90000, N'Active'),
(6947, 3028, 521, 3, 306, 90000, N'Active'),
(6948, 3029, 531, 3, 270, 90000, N'Active'),
(6949, 3029, 531, 3, 271, 90000, N'Active'),
(6950, 3030, 526, 3, 317, 90000, N'Active'),
(6951, 3030, 526, 3, 318, 90000, N'Active'),
(6952, 3031, 531, 3, 235, 75000, N'Active'),
(6953, 3031, 531, 3, 236, 75000, N'Active'),
(6954, 3032, 521, 3, 295, 90000, N'Active'),
(6955, 3032, 521, 3, 296, 90000, N'Active'),
(6956, 3033, 530, 1, 30, 75000, N'Active'),
(6957, 3034, 561, 4, 368, 108000, N'Active'),
(6958, 3034, 561, 4, 369, 108000, N'Active'),
(6959, 3035, 533, 2, 196, 90000, N'Active'),
(6960, 3036, 535, 4, 367, 108000, N'Active'),
(6961, 3036, 535, 4, 368, 108000, N'Active'),
(6962, 3037, 527, 1, 79, 90000, N'Active'),
(6963, 3037, 527, 1, 80, 90000, N'Active'),
(6964, 3037, 527, 1, 81, 90000, N'Active'),
(6965, 3038, 525, 4, 330, 90000, N'Active'),
(6966, 3038, 525, 4, 331, 90000, N'Active'),
(6967, 3039, 554, 4, 414, 108000, N'Active'),
(6968, 3039, 554, 4, 415, 108000, N'Active'),
(6969, 3040, 549, 2, 150, 90000, N'Active'),
(6970, 3040, 549, 2, 151, 90000, N'Active'),
(6971, 3041, 556, 1, 30, 75000, N'Active'),
(6972, 3041, 556, 1, 31, 75000, N'Active'),
(6973, 3041, 556, 1, 32, 75000, N'Active'),
(6974, 3042, 528, 2, 199, 90000, N'Active'),
(6975, 3042, 528, 2, 200, 90000, N'Active'),
(6976, 3043, 523, 2, 140, 75000, N'Active'),
(6977, 3043, 523, 2, 141, 75000, N'Active'),
(6978, 3043, 523, 2, 142, 75000, N'Active'),
(6979, 3044, 564, 4, 421, 108000, N'Active'),
(6980, 3044, 564, 4, 422, 108000, N'Active'),
(6981, 3044, 564, 4, 423, 108000, N'Active'),
(6982, 3044, 564, 4, 424, 108000, N'Active'),
(6983, 3045, 522, 1, 65, 90000, N'Active'),
(6984, 3045, 522, 1, 66, 90000, N'Active'),
(6985, 3046, 526, 3, 259, 90000, N'Active'),
(6986, 3046, 526, 3, 260, 90000, N'Active'),
(6987, 3047, 526, 3, 273, 90000, N'Active'),
(6988, 3047, 526, 3, 274, 90000, N'Active'),
(6989, 3047, 526, 3, 275, 90000, N'Active'),
(6990, 3048, 551, 1, 107, 90000, N'Active'),
(6991, 3048, 551, 1, 108, 90000, N'Active'),
(6992, 3049, 538, 3, 304, 90000, N'Active'),
(6993, 3049, 538, 3, 305, 90000, N'Active'),
(6994, 3049, 538, 3, 306, 90000, N'Active'),
(6995, 3049, 538, 3, 307, 90000, N'Active'),
(6996, 3049, 538, 3, 308, 90000, N'Active'),
(6997, 3050, 535, 4, 416, 108000, N'Active'),
(6998, 3050, 535, 4, 417, 108000, N'Active'),
(6999, 3050, 535, 4, 418, 108000, N'Active'),
(7000, 3051, 524, 5, 464, 120000, N'Active'),
(7001, 3052, 559, 1, 30, 75000, N'Active'),
(7002, 3053, 527, 1, 66, 90000, N'Active'),
(7003, 3053, 527, 1, 67, 90000, N'Active'),
(7004, 3053, 527, 1, 68, 90000, N'Active'),
(7005, 3054, 528, 2, 211, 90000, N'Active'),
(7006, 3054, 528, 2, 212, 90000, N'Active'),
(7007, 3055, 524, 5, 546, 144000, N'Active'),
(7008, 3056, 540, 2, 138, 75000, N'Active'),
(7009, 3057, 529, 5, 438, 120000, N'Cancelled'),
(7010, 3057, 529, 5, 439, 120000, N'Cancelled'),
(7011, 3058, 529, 5, 509, 144000, N'Active'),
(7012, 3058, 529, 5, 510, 144000, N'Active'),
(7013, 3058, 529, 5, 511, 144000, N'Active'),
(7014, 3058, 529, 5, 512, 144000, N'Active'),
(7015, 3058, 529, 5, 513, 144000, N'Active'),
(7016, 3059, 523, 2, 150, 90000, N'Active'),
(7017, 3059, 523, 2, 151, 90000, N'Active'),
(7018, 3060, 530, 1, 42, 90000, N'Active'),
(7019, 3060, 530, 1, 43, 90000, N'Active'),
(7020, 3061, 524, 5, 484, 144000, N'Active'),
(7021, 3061, 524, 5, 485, 144000, N'Active'),
(7022, 3062, 532, 4, 418, 108000, N'Active'),
(7023, 3062, 532, 4, 419, 108000, N'Active'),
(7024, 3062, 532, 4, 420, 108000, N'Active'),
(7025, 3063, 534, 1, 46, 90000, N'Active'),
(7026, 3064, 525, 4, 427, 108000, N'Active'),
(7027, 3064, 525, 4, 428, 108000, N'Active'),
(7028, 3065, 524, 5, 460, 120000, N'Active'),
(7029, 3065, 524, 5, 461, 120000, N'Active'),
(7030, 3065, 524, 5, 462, 120000, N'Active'),
(7031, 3065, 524, 5, 463, 120000, N'Active'),
(7032, 3066, 524, 5, 488, 144000, N'Active'),
(7033, 3066, 524, 5, 489, 144000, N'Active'),
(7034, 3067, 526, 3, 282, 90000, N'Active'),
(7035, 3067, 526, 3, 283, 90000, N'Active'),
(7036, 3068, 524, 5, 486, 144000, N'Active'),
(7037, 3069, 535, 4, 402, 108000, N'Active'),
(7038, 3069, 535, 4, 403, 108000, N'Active'),
(7039, 3070, 533, 2, 193, 90000, N'Active'),
(7040, 3070, 533, 2, 194, 90000, N'Active'),
(7041, 3070, 533, 2, 195, 90000, N'Active'),
(7042, 3071, 525, 4, 376, 108000, N'Active'),
(7043, 3071, 525, 4, 377, 108000, N'Active'),
(7044, 3071, 525, 4, 378, 108000, N'Active'),
(7045, 3071, 525, 4, 379, 108000, N'Active'),
(7046, 3071, 525, 4, 380, 108000, N'Active'),
(7047, 3071, 525, 4, 381, 108000, N'Active'),
(7048, 3072, 524, 5, 545, 144000, N'Active'),
(7049, 3073, 525, 4, 383, 108000, N'Active'),
(7050, 3074, 530, 1, 90, 90000, N'Active'),
(7051, 3074, 530, 1, 91, 90000, N'Active'),
(7052, 3075, 524, 5, 563, 144000, N'Active'),
(7053, 3075, 524, 5, 564, 144000, N'Active'),
(7054, 3076, 523, 2, 113, 75000, N'Active'),
(7055, 3076, 523, 2, 114, 75000, N'Active'),
(7056, 3076, 523, 2, 115, 75000, N'Active'),
(7057, 3076, 523, 2, 116, 75000, N'Active'),
(7058, 3077, 526, 3, 222, 75000, N'Active'),
(7059, 3077, 526, 3, 223, 75000, N'Active'),
(7060, 3078, 525, 4, 403, 108000, N'Active'),
(7061, 3079, 532, 4, 355, 90000, N'Active'),
(7062, 3079, 532, 4, 356, 90000, N'Active'),
(7063, 3080, 528, 2, 162, 90000, N'Active'),
(7064, 3080, 528, 2, 163, 90000, N'Active'),
(7065, 3081, 524, 5, 453, 120000, N'Active'),
(7066, 3082, 532, 4, 330, 90000, N'Active'),
(7067, 3083, 530, 1, 105, 90000, N'Active'),
(7068, 3083, 530, 1, 106, 90000, N'Active'),
(7069, 3084, 525, 4, 366, 108000, N'Active'),
(7070, 3084, 525, 4, 367, 108000, N'Active'),
(7071, 3085, 523, 2, 185, 90000, N'Active'),
(7072, 3085, 523, 2, 186, 90000, N'Active'),
(7073, 3086, 533, 2, 172, 90000, N'Active'),
(7074, 3086, 533, 2, 173, 90000, N'Active'),
(7075, 3087, 529, 5, 486, 144000, N'Active'),
(7076, 3087, 529, 5, 487, 144000, N'Active'),
(7077, 3088, 527, 1, 55, 90000, N'Active'),
(7078, 3089, 533, 2, 200, 90000, N'Active'),
(7079, 3089, 533, 2, 201, 90000, N'Active'),
(7080, 3089, 533, 2, 202, 90000, N'Active'),
(7081, 3090, 529, 5, 545, 144000, N'Active'),
(7082, 3090, 529, 5, 546, 144000, N'Active'),
(7083, 3090, 529, 5, 547, 144000, N'Active'),
(7084, 3090, 529, 5, 548, 144000, N'Active'),
(7085, 3091, 528, 2, 149, 90000, N'Active'),
(7086, 3091, 528, 2, 150, 90000, N'Active'),
(7087, 3091, 528, 2, 151, 90000, N'Active'),
(7088, 3092, 527, 1, 41, 90000, N'Active'),
(7089, 3092, 527, 1, 42, 90000, N'Active'),
(7090, 3092, 527, 1, 43, 90000, N'Active'),
(7091, 3092, 527, 1, 44, 90000, N'Active'),
(7092, 3093, 526, 3, 293, 90000, N'Active'),
(7093, 3093, 526, 3, 294, 90000, N'Active'),
(7094, 3094, 532, 4, 416, 108000, N'Active'),
(7095, 3095, 534, 1, 54, 90000, N'Active'),
(7096, 3095, 534, 1, 55, 90000, N'Active'),
(7097, 3096, 537, 2, 152, 90000, N'Active'),
(7098, 3096, 537, 2, 153, 90000, N'Active'),
(7099, 3097, 532, 4, 388, 108000, N'Active'),
(7100, 3097, 532, 4, 389, 108000, N'Active'),
(7101, 3097, 532, 4, 390, 108000, N'Active'),
(7102, 3098, 557, 2, 126, 75000, N'Active'),
(7103, 3098, 557, 2, 127, 75000, N'Active'),
(7104, 3099, 530, 1, 92, 90000, N'Active'),
(7105, 3099, 530, 1, 93, 90000, N'Active'),
(7106, 3100, 531, 3, 282, 90000, N'Active'),
(7107, 3100, 531, 3, 283, 90000, N'Active'),
(7108, 3100, 531, 3, 284, 90000, N'Active'),
(7109, 3101, 550, 3, 233, 75000, N'Active'),
(7110, 3101, 550, 3, 234, 75000, N'Active'),
(7111, 3102, 529, 5, 535, 144000, N'Active'),
(7112, 3102, 529, 5, 536, 144000, N'Active'),
(7113, 3103, 543, 3, 255, 90000, N'Active'),
(7114, 3103, 543, 3, 256, 90000, N'Active'),
(7115, 3103, 543, 3, 257, 90000, N'Active'),
(7116, 3103, 543, 3, 258, 90000, N'Active'),
(7117, 3104, 527, 1, 107, 90000, N'Active'),
(7118, 3104, 527, 1, 108, 90000, N'Active'),
(7119, 3105, 538, 3, 233, 75000, N'Active'),
(7120, 3105, 538, 3, 234, 75000, N'Active'),
(7121, 3105, 538, 3, 235, 75000, N'Active'),
(7122, 3106, 561, 4, 343, 90000, N'Active'),
(7123, 3106, 561, 4, 344, 90000, N'Active'),
(7124, 3107, 528, 2, 187, 90000, N'Active'),
(7125, 3107, 528, 2, 188, 90000, N'Active'),
(7126, 3108, 534, 1, 43, 90000, N'Active'),
(7127, 3108, 534, 1, 44, 90000, N'Active'),
(7128, 3109, 528, 2, 185, 90000, N'Active'),
(7129, 3109, 528, 2, 186, 90000, N'Active'),
(7130, 3110, 536, 5, 499, 144000, N'Active'),
(7131, 3110, 536, 5, 500, 144000, N'Active'),
(7132, 3110, 536, 5, 501, 144000, N'Active'),
(7133, 3111, 560, 3, 294, 90000, N'Active'),
(7134, 3111, 560, 3, 295, 90000, N'Active'),
(7135, 3112, 528, 2, 172, 90000, N'Active'),
(7136, 3112, 528, 2, 173, 90000, N'Active'),
(7137, 3112, 528, 2, 174, 90000, N'Active'),
(7138, 3112, 528, 2, 175, 90000, N'Active'),
(7139, 3113, 579, 3, 247, 75000, N'Active'),
(7140, 3114, 532, 4, 402, 108000, N'Active'),
(7141, 3114, 532, 4, 403, 108000, N'Active'),
(7142, 3115, 528, 2, 166, 90000, N'Active'),
(7143, 3115, 528, 2, 167, 90000, N'Active'),
(7144, 3116, 531, 3, 308, 90000, N'Active'),
(7145, 3117, 531, 3, 306, 90000, N'Active'),
(7146, 3118, 531, 3, 263, 90000, N'Active'),
(7147, 3118, 531, 3, 264, 90000, N'Active'),
(7148, 3119, 561, 4, 393, 108000, N'Active'),
(7149, 3119, 561, 4, 394, 108000, N'Active'),
(7150, 3120, 529, 5, 499, 144000, N'Active'),
(7151, 3121, 528, 2, 197, 90000, N'Active'),
(7152, 3121, 528, 2, 198, 90000, N'Active'),
(7153, 3122, 529, 5, 484, 144000, N'Active'),
(7154, 3122, 529, 5, 485, 144000, N'Active'),
(7155, 3123, 528, 2, 152, 90000, N'Active'),
(7156, 3123, 528, 2, 153, 90000, N'Active'),
(7157, 3123, 528, 2, 154, 90000, N'Active'),
(7158, 3124, 531, 3, 257, 90000, N'Active'),
(7159, 3124, 531, 3, 258, 90000, N'Active'),
(7160, 3124, 531, 3, 259, 90000, N'Active'),
(7161, 3124, 531, 3, 260, 90000, N'Active'),
(7162, 3125, 532, 4, 392, 108000, N'Active'),
(7163, 3125, 532, 4, 393, 108000, N'Active'),
(7164, 3126, 536, 5, 557, 144000, N'Active'),
(7165, 3126, 536, 5, 558, 144000, N'Active'),
(7166, 3126, 536, 5, 559, 144000, N'Active'),
(7167, 3126, 536, 5, 560, 144000, N'Active'),
(7168, 3127, 537, 2, 128, 75000, N'Active'),
(7169, 3127, 537, 2, 129, 75000, N'Active'),
(7170, 3128, 537, 2, 130, 75000, N'Active'),
(7171, 3129, 566, 2, 179, 90000, N'Active'),
(7172, 3129, 566, 2, 180, 90000, N'Active'),
(7173, 3130, 530, 1, 65, 90000, N'Active'),
(7174, 3130, 530, 1, 66, 90000, N'Active'),
(7175, 3130, 530, 1, 67, 90000, N'Active'),
(7176, 3131, 529, 5, 534, 144000, N'Active'),
(7177, 3132, 530, 1, 69, 90000, N'Active'),
(7178, 3132, 530, 1, 70, 90000, N'Active'),
(7179, 3133, 532, 4, 405, 108000, N'Active'),
(7180, 3133, 532, 4, 406, 108000, N'Active'),
(7181, 3134, 530, 1, 52, 90000, N'Active'),
(7182, 3134, 530, 1, 53, 90000, N'Active'),
(7183, 3135, 530, 1, 39, 90000, N'Active'),
(7184, 3135, 530, 1, 40, 90000, N'Active'),
(7185, 3136, 531, 3, 295, 90000, N'Active'),
(7186, 3136, 531, 3, 296, 90000, N'Active'),
(7187, 3137, 533, 2, 198, 90000, N'Active'),
(7188, 3137, 533, 2, 199, 90000, N'Active'),
(7189, 3138, 529, 5, 514, 144000, N'Active'),
(7190, 3138, 529, 5, 515, 144000, N'Active'),
(7191, 3139, 531, 3, 254, 90000, N'Active'),
(7192, 3139, 531, 3, 255, 90000, N'Active'),
(7193, 3140, 532, 4, 343, 90000, N'Active'),
(7194, 3141, 539, 1, 55, 90000, N'Active'),
(7195, 3141, 539, 1, 56, 90000, N'Active'),
(7196, 3142, 533, 2, 157, 90000, N'Active'),
(7197, 3142, 533, 2, 158, 90000, N'Active'),
(7198, 3142, 533, 2, 159, 90000, N'Active'),
(7199, 3142, 533, 2, 160, 90000, N'Active'),
(7200, 3143, 535, 4, 364, 108000, N'Active'),
(7201, 3143, 535, 4, 365, 108000, N'Active'),
(7202, 3143, 535, 4, 366, 108000, N'Active'),
(7203, 3144, 582, 5, 462, 120000, N'Active'),
(7204, 3144, 582, 5, 463, 120000, N'Active'),
(7205, 3145, 534, 1, 82, 90000, N'Active'),
(7206, 3145, 534, 1, 83, 90000, N'Active'),
(7207, 3146, 535, 4, 414, 108000, N'Active'),
(7208, 3146, 535, 4, 415, 108000, N'Active'),
(7209, 3147, 538, 3, 258, 90000, N'Active'),
(7210, 3147, 538, 3, 259, 90000, N'Active'),
(7211, 3148, 529, 5, 549, 144000, N'Active'),
(7212, 3149, 595, 2, 160, 90000, N'Active'),
(7213, 3150, 533, 2, 161, 90000, N'Cancelled'),
(7214, 3150, 533, 2, 162, 90000, N'Cancelled'),
(7215, 3150, 533, 2, 163, 90000, N'Cancelled'),
(7216, 3150, 533, 2, 164, 90000, N'Cancelled'),
(7217, 3151, 534, 1, 76, 90000, N'Active'),
(7218, 3151, 534, 1, 77, 90000, N'Active'),
(7219, 3152, 532, 4, 353, 90000, N'Active'),
(7220, 3152, 532, 4, 354, 90000, N'Active'),
(7221, 3153, 530, 1, 45, 90000, N'Active'),
(7222, 3153, 530, 1, 46, 90000, N'Active'),
(7223, 3154, 532, 4, 409, 108000, N'Active'),
(7224, 3154, 532, 4, 410, 108000, N'Active'),
(7225, 3154, 532, 4, 411, 108000, N'Active'),
(7226, 3154, 532, 4, 412, 108000, N'Active'),
(7227, 3155, 530, 1, 76, 90000, N'Active'),
(7228, 3155, 530, 1, 77, 90000, N'Active'),
(7229, 3156, 531, 3, 313, 90000, N'Active'),
(7230, 3156, 531, 3, 314, 90000, N'Active'),
(7231, 3157, 533, 2, 176, 90000, N'Active'),
(7232, 3157, 533, 2, 177, 90000, N'Active'),
(7233, 3157, 533, 2, 178, 90000, N'Active'),
(7234, 3157, 533, 2, 179, 90000, N'Active'),
(7235, 3157, 533, 2, 180, 90000, N'Active'),
(7236, 3158, 533, 2, 203, 90000, N'Active'),
(7237, 3158, 533, 2, 204, 90000, N'Active'),
(7238, 3159, 533, 2, 125, 75000, N'Active'),
(7239, 3159, 533, 2, 126, 75000, N'Active'),
(7240, 3160, 535, 4, 376, 108000, N'Active'),
(7241, 3160, 535, 4, 377, 108000, N'Active'),
(7242, 3161, 535, 4, 341, 90000, N'Active'),
(7243, 3161, 535, 4, 342, 90000, N'Active'),
(7244, 3161, 535, 4, 343, 90000, N'Active'),
(7245, 3162, 537, 2, 138, 75000, N'Active'),
(7246, 3163, 533, 2, 149, 90000, N'Active'),
(7247, 3163, 533, 2, 150, 90000, N'Active'),
(7248, 3163, 533, 2, 151, 90000, N'Active'),
(7249, 3164, 541, 5, 499, 144000, N'Active'),
(7250, 3164, 541, 5, 500, 144000, N'Active'),
(7251, 3165, 533, 2, 187, 90000, N'Active'),
(7252, 3165, 533, 2, 188, 90000, N'Active'),
(7253, 3165, 533, 2, 189, 90000, N'Active'),
(7254, 3165, 533, 2, 190, 90000, N'Active'),
(7255, 3165, 533, 2, 191, 90000, N'Active'),
(7256, 3166, 537, 2, 127, 75000, N'Active'),
(7257, 3167, 534, 1, 101, 90000, N'Active'),
(7258, 3167, 534, 1, 102, 90000, N'Active'),
(7259, 3168, 535, 4, 369, 108000, N'Active'),
(7260, 3168, 535, 4, 370, 108000, N'Active'),
(7261, 3169, 565, 5, 487, 144000, N'Active'),
(7262, 3169, 565, 5, 488, 144000, N'Active'),
(7263, 3170, 536, 5, 534, 144000, N'Active'),
(7264, 3170, 536, 5, 535, 144000, N'Active'),
(7265, 3171, 566, 2, 213, 90000, N'Active'),
(7266, 3171, 566, 2, 214, 90000, N'Active'),
(7267, 3171, 566, 2, 215, 90000, N'Active'),
(7268, 3171, 566, 2, 216, 90000, N'Active'),
(7269, 3172, 549, 2, 199, 90000, N'Active'),
(7270, 3173, 568, 1, 97, 90000, N'Active'),
(7271, 3173, 568, 1, 98, 90000, N'Active'),
(7272, 3174, 534, 1, 56, 90000, N'Active'),
(7273, 3175, 539, 1, 97, 90000, N'Active'),
(7274, 3175, 539, 1, 98, 90000, N'Active'),
(7275, 3175, 539, 1, 99, 90000, N'Active'),
(7276, 3175, 539, 1, 100, 90000, N'Active'),
(7277, 3176, 534, 1, 107, 90000, N'Active'),
(7278, 3176, 534, 1, 108, 90000, N'Active'),
(7279, 3177, 537, 2, 123, 75000, N'Active'),
(7280, 3177, 537, 2, 124, 75000, N'Active'),
(7281, 3177, 537, 2, 125, 75000, N'Active'),
(7282, 3177, 537, 2, 126, 75000, N'Active'),
(7283, 3178, 534, 1, 57, 90000, N'Active'),
(7284, 3178, 534, 1, 58, 90000, N'Active'),
(7285, 3178, 534, 1, 59, 90000, N'Active'),
(7286, 3178, 534, 1, 60, 90000, N'Active'),
(7287, 3179, 535, 4, 330, 90000, N'Active'),
(7288, 3179, 535, 4, 331, 90000, N'Active'),
(7289, 3179, 535, 4, 332, 90000, N'Active'),
(7290, 3180, 534, 1, 66, 90000, N'Active'),
(7291, 3180, 534, 1, 67, 90000, N'Active'),
(7292, 3181, 534, 1, 78, 90000, N'Active'),
(7293, 3181, 534, 1, 79, 90000, N'Active'),
(7294, 3182, 535, 4, 355, 90000, N'Active'),
(7295, 3182, 535, 4, 356, 90000, N'Active'),
(7296, 3183, 538, 3, 237, 75000, N'Active'),
(7297, 3183, 538, 3, 238, 75000, N'Active'),
(7298, 3184, 534, 1, 90, 90000, N'Active'),
(7299, 3184, 534, 1, 91, 90000, N'Active'),
(7300, 3185, 537, 2, 113, 75000, N'Active'),
(7301, 3185, 537, 2, 114, 75000, N'Active'),
(7302, 3186, 537, 2, 116, 75000, N'Active'),
(7303, 3186, 537, 2, 117, 75000, N'Active'),
(7304, 3187, 535, 4, 423, 108000, N'Active'),
(7305, 3187, 535, 4, 424, 108000, N'Active'),
(7306, 3188, 538, 3, 270, 90000, N'Active'),
(7307, 3188, 538, 3, 271, 90000, N'Active'),
(7308, 3188, 538, 3, 272, 90000, N'Active'),
(7309, 3189, 536, 5, 452, 120000, N'Active'),
(7310, 3189, 536, 5, 453, 120000, N'Active'),
(7311, 3190, 536, 5, 536, 144000, N'Active'),
(7312, 3190, 536, 5, 537, 144000, N'Active'),
(7313, 3190, 536, 5, 538, 144000, N'Active'),
(7314, 3190, 536, 5, 539, 144000, N'Active'),
(7315, 3190, 536, 5, 540, 144000, N'Active'),
(7316, 3191, 537, 2, 196, 90000, N'Active'),
(7317, 3191, 537, 2, 197, 90000, N'Active'),
(7318, 3192, 534, 1, 37, 90000, N'Active'),
(7319, 3192, 534, 1, 38, 90000, N'Active'),
(7320, 3193, 538, 3, 239, 75000, N'Active'),
(7321, 3193, 538, 3, 240, 75000, N'Active'),
(7322, 3194, 537, 2, 173, 90000, N'Active'),
(7323, 3194, 537, 2, 174, 90000, N'Active'),
(7324, 3194, 537, 2, 175, 90000, N'Active'),
(7325, 3194, 537, 2, 176, 90000, N'Active'),
(7326, 3195, 538, 3, 229, 75000, N'Active'),
(7327, 3195, 538, 3, 230, 75000, N'Active'),
(7328, 3195, 538, 3, 231, 75000, N'Active'),
(7329, 3195, 538, 3, 232, 75000, N'Active'),
(7330, 3196, 537, 2, 163, 90000, N'Active'),
(7331, 3196, 537, 2, 164, 90000, N'Active'),
(7332, 3197, 534, 1, 52, 90000, N'Active'),
(7333, 3197, 534, 1, 53, 90000, N'Active'),
(7334, 3198, 535, 4, 345, 90000, N'Active'),
(7335, 3198, 535, 4, 346, 90000, N'Active'),
(7336, 3198, 535, 4, 347, 90000, N'Active'),
(7337, 3198, 535, 4, 348, 90000, N'Active'),
(7338, 3199, 534, 1, 41, 90000, N'Active'),
(7339, 3199, 534, 1, 42, 90000, N'Active'),
(7340, 3200, 536, 5, 546, 144000, N'Active'),
(7341, 3200, 536, 5, 547, 144000, N'Active'),
(7342, 3201, 555, 3, 281, 90000, N'Active'),
(7343, 3201, 555, 3, 282, 90000, N'Active'),
(7344, 3202, 557, 2, 213, 90000, N'Active'),
(7345, 3202, 557, 2, 214, 90000, N'Active'),
(7346, 3203, 536, 5, 563, 144000, N'Active'),
(7347, 3203, 536, 5, 564, 144000, N'Active'),
(7348, 3204, 538, 3, 323, 90000, N'Active'),
(7349, 3204, 538, 3, 324, 90000, N'Active'),
(7350, 3205, 537, 2, 198, 90000, N'Active'),
(7351, 3205, 537, 2, 199, 90000, N'Active'),
(7352, 3206, 564, 4, 354, 90000, N'Active'),
(7353, 3207, 567, 3, 273, 90000, N'Active'),
(7354, 3207, 567, 3, 274, 90000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Chủ nhật 29/11/2026: 172 hoa don (6 huy), 396 ve, doanh thu 38.324.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(3208, 4, NULL, '2026-11-29T08:02:34', 540000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 546 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 29/11 11:30 | Phòng 1 | G5 G6 G7 G8 G9 G10
(3209, 4, NULL, '2026-11-29T08:02:56', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 540 | Hexed: Thế Giới Phép Thuật | 29/11 09:00 | Phòng 2 | C7
(3210, 5, NULL, '2026-11-29T08:08:58', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 541 | Dune: Hành Tinh Cát - Phần Hai | 29/11 09:00 | Phòng 5 | H6 H7
(3211, 6, 78, '2026-11-29T08:15:49', 216000, N'Paid', N'Transfer', NULL, 21, 0, NULL, NULL, NULL), -- suat 542 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 09:15 | Phòng 4 | J9 J10
(3212, 6, NULL, '2026-11-29T08:19:44', 90000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 539 | Trại Giam Hạnh Phúc | 29/11 09:00 | Phòng 1 | F6
(3213, 4, 109, '2026-11-29T08:22:10', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 540 | Hexed: Thế Giới Phép Thuật | 29/11 09:00 | Phòng 2 | H6 H7
(3214, 6, NULL, '2026-11-29T08:24:10', 270000, N'Cancelled', N'Cash', 270000, 0, 0, N'Lỗi thanh toán', '2026-11-29T08:55:31', 6), -- suat 584 | Chị Chị Em Em 3 | 30/11 16:00 | Phòng 3 | E5 E6 E7
(3215, 6, NULL, '2026-11-29T08:25:38', 648000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 590 | Godzilla Trừ Không | 30/11 18:30 | Phòng 4 | D4 D5 D6 D7 D8 D9
(3216, 6, 48, '2026-11-29T08:27:01', 180000, N'Paid', N'Card', NULL, 9, 0, NULL, NULL, NULL), -- suat 542 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 09:15 | Phòng 4 | A6 A7
(3217, 6, NULL, '2026-11-29T08:27:24', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 539 | Trại Giam Hạnh Phúc | 29/11 09:00 | Phòng 1 | H4 H5
(3218, 5, 30, '2026-11-29T08:29:05', 152000, N'Paid', N'Cash', 152000, 7, 28, NULL, NULL, NULL), -- suat 542 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 09:15 | Phòng 4 | C6 C7
(3219, 5, NULL, '2026-11-29T08:33:29', 150000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 540 | Hexed: Thế Giới Phép Thuật | 29/11 09:00 | Phòng 2 | B7 B8
(3220, 5, NULL, '2026-11-29T08:34:36', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 545 | Ngày Con Còn Mẹ | 29/11 11:15 | Phòng 3 | J7 J8
(3221, 5, 52, '2026-11-29T08:55:30', 180000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 543 | Kiến Lé Phiêu Lưu Ké | 29/11 09:30 | Phòng 3 | J11 J12
(3222, 4, NULL, '2026-11-29T08:58:38', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 571 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 30/11 09:15 | Phòng 4 | H6 H7
(3223, 5, 80, '2026-11-29T09:02:27', 126000, N'Paid', N'Cash', 126000, 6, 24, NULL, NULL, NULL), -- suat 546 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 29/11 11:30 | Phòng 1 | C4 C5
(3224, 6, 95, '2026-11-29T09:07:22', 216000, N'Paid', N'Cash', 216000, 15, 0, NULL, NULL, NULL), -- suat 547 | Ramayana: Khởi Nguồn Một Huyền Thoại | 29/11 12:15 | Phòng 4 | H6 H7
(3225, 4, NULL, '2026-11-29T09:13:49', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 568 | Trại Giam Hạnh Phúc | 30/11 09:00 | Phòng 1 | H4 H5
(3226, 5, NULL, '2026-11-29T09:18:42', 720000, N'Paid', N'Cash', 720000, 0, 0, NULL, NULL, NULL), -- suat 558 | Dune: Hành Tinh Cát - Phần Hai | 29/11 18:00 | Phòng 5 | G3 G4 G5 G6 G7
(3227, 5, 52, '2026-11-29T09:25:45', 480000, N'Paid', N'Transfer', NULL, 24, 0, NULL, NULL, NULL), -- suat 548 | Godzilla Trừ Không | 29/11 12:15 | Phòng 5 | C5 C6 C7 C8
(3228, 4, NULL, '2026-11-29T09:29:50', 450000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 547 | Ramayana: Khởi Nguồn Một Huyền Thoại | 29/11 12:15 | Phòng 4 | A5 A6 A7 A8 A9
(3229, 5, NULL, '2026-11-29T09:32:04', 150000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-29T10:26:53', 1), -- suat 546 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 29/11 11:30 | Phòng 1 | C6 C7
(3230, 6, 120, '2026-11-29T09:43:56', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 587 | Dune: Hành Tinh Cát - Phần Hai | 30/11 18:00 | Phòng 5 | E6 E7
(3231, 4, NULL, '2026-11-29T10:00:02', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 570 | Dune: Hành Tinh Cát - Phần Hai | 30/11 09:00 | Phòng 5 | J7
(3232, 4, NULL, '2026-11-29T10:02:40', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 595 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 30/11 21:45 | Phòng 2 | E5 E6 E7
(3233, 6, 10, '2026-11-29T10:06:29', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 551 | Trại Giam Hạnh Phúc | 29/11 13:45 | Phòng 1 | G6
(3234, 4, NULL, '2026-11-29T10:10:49', 540000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 549 | Hexed: Thế Giới Phép Thuật | 29/11 12:45 | Phòng 2 | E3 E4 E5 E6 E7 E8
(3235, 6, 43, '2026-11-29T10:16:51', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 551 | Trại Giam Hạnh Phúc | 29/11 13:45 | Phòng 1 | H8
(3236, 6, NULL, '2026-11-29T10:22:55', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 596 | Mẹ Mìn: Giao Kèo Với Quỷ | 30/11 21:45 | Phòng 3 | E5 E6
(3237, 5, NULL, '2026-11-29T10:26:47', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 544 | Ma Mút Con Vượt Kỷ Băng Hà | 29/11 11:15 | Phòng 2 | J5 J6
(3238, 5, NULL, '2026-11-29T10:29:59', 480000, N'Paid', N'Cash', 480000, 0, 0, NULL, NULL, NULL), -- suat 611 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 15:00 | Phòng 5 | C5 C6 C7 C8
(3239, 4, NULL, '2026-11-29T10:30:57', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 590 | Godzilla Trừ Không | 30/11 18:30 | Phòng 4 | A8 A9
(3240, 5, NULL, '2026-11-29T10:41:51', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 545 | Ngày Con Còn Mẹ | 29/11 11:15 | Phòng 3 | G5 G6
(3241, 4, NULL, '2026-11-29T10:44:12', 90000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 545 | Ngày Con Còn Mẹ | 29/11 11:15 | Phòng 3 | F7
(3242, 4, 109, '2026-11-29T10:45:32', 180000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 544 | Ma Mút Con Vượt Kỷ Băng Hà | 29/11 11:15 | Phòng 2 | D8 D9
(3243, 5, NULL, '2026-11-29T10:47:13', 450000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 549 | Hexed: Thế Giới Phép Thuật | 29/11 12:45 | Phòng 2 | F4 F5 F6 F7 F8
(3244, 4, NULL, '2026-11-29T10:51:23', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 559 | Trại Giam Hạnh Phúc | 29/11 18:30 | Phòng 1 | D7
(3245, 6, NULL, '2026-11-29T11:04:02', 240000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 558 | Dune: Hành Tinh Cát - Phần Hai | 29/11 18:00 | Phòng 5 | B5 B6
(3246, 6, 63, '2026-11-29T11:04:11', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 544 | Ma Mút Con Vượt Kỷ Băng Hà | 29/11 11:15 | Phòng 2 | D6 D7
(3247, 6, 21, '2026-11-29T11:04:56', 75000, N'Paid', N'Cash', 500000, 3, 0, NULL, NULL, NULL), -- suat 555 | Chị Chị Em Em 3 | 29/11 16:00 | Phòng 3 | B6
(3248, 4, NULL, '2026-11-29T11:08:19', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Sự cố phòng chiếu', '2026-11-29T12:18:36', 1), -- suat 589 | Điểm Mù | 30/11 18:30 | Phòng 3 | J3 J4
(3249, 4, 42, '2026-11-29T11:08:32', 720000, N'Paid', N'Transfer', NULL, 50, 0, NULL, NULL, NULL), -- suat 548 | Godzilla Trừ Không | 29/11 12:15 | Phòng 5 | G3 G4 G5 G6 G7
(3250, 6, NULL, '2026-11-29T11:14:49', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 551 | Trại Giam Hạnh Phúc | 29/11 13:45 | Phòng 1 | D4 D5
(3251, 5, NULL, '2026-11-29T11:29:19', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 548 | Godzilla Trừ Không | 29/11 12:15 | Phòng 5 | K7 K8
(3252, 4, 10, '2026-11-29T11:31:18', 360000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 582 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 30/11 15:00 | Phòng 5 | A6 A7 A8
(3253, 4, NULL, '2026-11-29T11:34:02', 108000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 554 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 15:30 | Phòng 4 | E7
(3254, 5, 113, '2026-11-29T11:35:14', 180000, N'Paid', N'Cash', 180000, 18, 0, NULL, NULL, NULL), -- suat 551 | Trại Giam Hạnh Phúc | 29/11 13:45 | Phòng 1 | J1 J2
(3255, 5, NULL, '2026-11-29T11:37:47', 375000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 550 | Bí Kíp Luyện Cướp | 29/11 13:30 | Phòng 3 | C5 C6 C7 C8 C9
(3256, 6, NULL, '2026-11-29T11:39:51', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 553 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 15:00 | Phòng 5 | H5 H6
(3257, 4, NULL, '2026-11-29T11:43:38', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 551 | Trại Giam Hạnh Phúc | 29/11 13:45 | Phòng 1 | A6 A7 A8
(3258, 4, NULL, '2026-11-29T11:46:46', 75000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 559 | Trại Giam Hạnh Phúc | 29/11 18:30 | Phòng 1 | C7
(3259, 5, NULL, '2026-11-29T11:49:09', 90000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 601 | Kiến Lé Phiêu Lưu Ké | 01/12 09:30 | Phòng 3 | D6
(3260, 5, NULL, '2026-11-29T11:49:49', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 547 | Ramayana: Khởi Nguồn Một Huyền Thoại | 29/11 12:15 | Phòng 4 | D7 D8
(3261, 4, NULL, '2026-11-29T11:54:34', 108000, N'Paid', N'Cash', 108000, 0, 0, NULL, NULL, NULL), -- suat 554 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 15:30 | Phòng 4 | D9
(3262, 6, NULL, '2026-11-29T11:54:55', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 560 | Điểm Mù | 29/11 18:30 | Phòng 3 | E8 E9
(3263, 6, NULL, '2026-11-29T11:57:26', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 552 | Ngày Con Còn Mẹ | 29/11 15:00 | Phòng 2 | G6 G7
(3264, 6, NULL, '2026-11-29T12:03:52', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 555 | Chị Chị Em Em 3 | 29/11 16:00 | Phòng 3 | E9
(3265, 6, NULL, '2026-11-29T12:10:53', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 551 | Trại Giam Hạnh Phúc | 29/11 13:45 | Phòng 1 | F7 F8
(3266, 4, NULL, '2026-11-29T12:56:34', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 559 | Trại Giam Hạnh Phúc | 29/11 18:30 | Phòng 1 | G6 G7
(3267, 6, NULL, '2026-11-29T12:56:40', 540000, N'Paid', N'Cash', 600000, 0, 0, NULL, NULL, NULL), -- suat 554 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 15:30 | Phòng 4 | D4 D5 D6 D7 D8
(3268, 6, 59, '2026-11-29T12:57:44', 270000, N'Paid', N'Cash', 300000, 18, 0, NULL, NULL, NULL), -- suat 562 | Bò Sữa Bay | 29/11 19:30 | Phòng 2 | F6 F7 F8
(3269, 5, NULL, '2026-11-29T13:05:18', 150000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 557 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 29/11 17:15 | Phòng 2 | A7 A8
(3270, 6, NULL, '2026-11-29T13:08:18', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 551 | Trại Giam Hạnh Phúc | 29/11 13:45 | Phòng 1 | J9 J10
(3271, 5, NULL, '2026-11-29T13:10:27', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 569 | Hexed: Thế Giới Phép Thuật | 30/11 09:00 | Phòng 2 | G6 G7
(3272, 6, 37, '2026-11-29T13:25:53', 432000, N'Paid', N'Card', NULL, 30, 0, NULL, NULL, NULL), -- suat 553 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 15:00 | Phòng 5 | H7 H8 H9
(3273, 6, 81, '2026-11-29T13:27:56', 144000, N'Paid', N'Cash', 500000, 10, 0, NULL, NULL, NULL), -- suat 558 | Dune: Hành Tinh Cát - Phần Hai | 29/11 18:00 | Phòng 5 | H6
(3274, 4, NULL, '2026-11-29T13:38:49', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 553 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 15:00 | Phòng 5 | K7 K8
(3275, 4, NULL, '2026-11-29T13:42:59', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 560 | Điểm Mù | 29/11 18:30 | Phòng 3 | D5 D6
(3276, 5, NULL, '2026-11-29T13:48:06', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 567 | Mẹ Mìn: Giao Kèo Với Quỷ | 29/11 21:45 | Phòng 3 | E6 E7
(3277, 5, NULL, '2026-11-29T14:04:46', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 562 | Bò Sữa Bay | 29/11 19:30 | Phòng 2 | F9 F10
(3278, 4, NULL, '2026-11-29T14:15:17', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 555 | Chị Chị Em Em 3 | 29/11 16:00 | Phòng 3 | C6
(3279, 6, NULL, '2026-11-29T14:15:41', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 556 | Mẹ Mìn: Giao Kèo Với Quỷ | 29/11 16:15 | Phòng 1 | G9
(3280, 6, NULL, '2026-11-29T14:21:57', 216000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 561 | Godzilla Trừ Không | 29/11 18:30 | Phòng 4 | G5 G6
(3281, 5, NULL, '2026-11-29T14:24:24', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 558 | Dune: Hành Tinh Cát - Phần Hai | 29/11 18:00 | Phòng 5 | K2 K3
(3282, 5, 120, '2026-11-29T14:28:07', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 552 | Ngày Con Còn Mẹ | 29/11 15:00 | Phòng 2 | F5 F6
(3283, 4, 66, '2026-11-29T14:28:35', 270000, N'Paid', N'Cash', 300000, 18, 0, NULL, NULL, NULL), -- suat 552 | Ngày Con Còn Mẹ | 29/11 15:00 | Phòng 2 | E6 E7 E8
(3284, 5, NULL, '2026-11-29T14:31:24', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 559 | Trại Giam Hạnh Phúc | 29/11 18:30 | Phòng 1 | D5 D6
(3285, 5, NULL, '2026-11-29T14:32:05', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 563 | Mẹ Mìn: Giao Kèo Với Quỷ | 29/11 21:00 | Phòng 1 | J5 J6 J7 J8
(3286, 5, NULL, '2026-11-29T14:38:21', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 559 | Trại Giam Hạnh Phúc | 29/11 18:30 | Phòng 1 | E9 E10
(3287, 6, NULL, '2026-11-29T14:40:52', 120000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 553 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 15:00 | Phòng 5 | C6
(3288, 5, 54, '2026-11-29T14:42:08', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 557 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 29/11 17:15 | Phòng 2 | D7 D8
(3289, 5, NULL, '2026-11-29T14:42:59', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 557 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 29/11 17:15 | Phòng 2 | D6
(3290, 6, 28, '2026-11-29T14:48:02', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 552 | Ngày Con Còn Mẹ | 29/11 15:00 | Phòng 2 | D6 D7
(3291, 5, 43, '2026-11-29T14:59:38', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 557 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 29/11 17:15 | Phòng 2 | F6 F7
(3292, 9, NULL, '2026-11-29T15:02:51', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 555 | Chị Chị Em Em 3 | 29/11 16:00 | Phòng 3 | B4 B5
(3293, 7, NULL, '2026-11-29T15:04:34', 75000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 555 | Chị Chị Em Em 3 | 29/11 16:00 | Phòng 3 | A8
(3294, 9, 43, '2026-11-29T15:07:49', 150000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 559 | Trại Giam Hạnh Phúc | 29/11 18:30 | Phòng 1 | B6 B7
(3295, 8, NULL, '2026-11-29T15:11:47', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 565 | Godzilla Trừ Không | 29/11 21:15 | Phòng 5 | K7
(3296, 8, 113, '2026-11-29T15:13:58', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 561 | Godzilla Trừ Không | 29/11 18:30 | Phòng 4 | F5 F6
(3297, 7, NULL, '2026-11-29T15:19:13', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 558 | Dune: Hành Tinh Cát - Phần Hai | 29/11 18:00 | Phòng 5 | L5 L6
(3298, 8, NULL, '2026-11-29T15:21:53', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 560 | Điểm Mù | 29/11 18:30 | Phòng 3 | H6 H7
(3299, 7, NULL, '2026-11-29T15:25:27', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 615 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 01/12 17:15 | Phòng 2 | G5 G6 G7 G8
(3300, 8, NULL, '2026-11-29T15:26:19', 108000, N'Paid', N'Cash', 108000, 0, 0, NULL, NULL, NULL), -- suat 564 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 21:00 | Phòng 4 | F7
(3301, 8, NULL, '2026-11-29T15:37:44', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 557 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 29/11 17:15 | Phòng 2 | G6
(3302, 8, NULL, '2026-11-29T15:38:23', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 556 | Mẹ Mìn: Giao Kèo Với Quỷ | 29/11 16:15 | Phòng 1 | G7 G8
(3303, 7, 49, '2026-11-29T15:39:47', 180000, N'Paid', N'Card', NULL, 9, 0, NULL, NULL, NULL), -- suat 561 | Godzilla Trừ Không | 29/11 18:30 | Phòng 4 | A7 A8
(3304, 8, NULL, '2026-11-29T15:40:15', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 560 | Điểm Mù | 29/11 18:30 | Phòng 3 | J11 J12
(3305, 8, NULL, '2026-11-29T15:45:55', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 565 | Godzilla Trừ Không | 29/11 21:15 | Phòng 5 | E5 E6
(3306, 9, NULL, '2026-11-29T15:47:42', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 558 | Dune: Hành Tinh Cát - Phần Hai | 29/11 18:00 | Phòng 5 | J4 J5 J6 J7
(3307, 7, NULL, '2026-11-29T15:57:43', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 562 | Bò Sữa Bay | 29/11 19:30 | Phòng 2 | H8 H9
(3308, 9, 75, '2026-11-29T16:00:05', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 588 | Trại Giam Hạnh Phúc | 30/11 18:30 | Phòng 1 | B6 B7
(3309, 9, NULL, '2026-11-29T16:00:24', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 561 | Godzilla Trừ Không | 29/11 18:30 | Phòng 4 | C4 C5 C6
(3310, 7, NULL, '2026-11-29T16:10:28', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 560 | Điểm Mù | 29/11 18:30 | Phòng 3 | E5 E6
(3311, 7, NULL, '2026-11-29T16:12:28', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 558 | Dune: Hành Tinh Cát - Phần Hai | 29/11 18:00 | Phòng 5 | K4 K5 K6
(3312, 8, 55, '2026-11-29T16:13:36', 324000, N'Paid', N'Transfer', NULL, 22, 0, NULL, NULL, NULL), -- suat 612 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 15:30 | Phòng 4 | H8 H9 H10
(3313, 9, NULL, '2026-11-29T16:23:27', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 561 | Godzilla Trừ Không | 29/11 18:30 | Phòng 4 | H3 H4 H5 H6
(3314, 8, NULL, '2026-11-29T16:24:01', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 560 | Điểm Mù | 29/11 18:30 | Phòng 3 | B6 B7
(3315, 7, 77, '2026-11-29T16:24:15', 300000, N'Paid', N'Cash', 500000, 15, 0, NULL, NULL, NULL), -- suat 557 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 29/11 17:15 | Phòng 2 | C5 C6 C7 C8
(3316, 7, NULL, '2026-11-29T16:25:14', 75000, N'Paid', N'Cash', 80000, 0, 0, NULL, NULL, NULL), -- suat 562 | Bò Sữa Bay | 29/11 19:30 | Phòng 2 | B4
(3317, 7, NULL, '2026-11-29T16:33:49', 240000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 577 | Godzilla Trừ Không | 30/11 12:15 | Phòng 5 | B6 B7
(3318, 8, NULL, '2026-11-29T16:38:09', 108000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 564 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 21:00 | Phòng 4 | H8
(3319, 7, NULL, '2026-11-29T16:41:49', 75000, N'Paid', N'Cash', 75000, 0, 0, NULL, NULL, NULL), -- suat 557 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 29/11 17:15 | Phòng 2 | C10
(3320, 9, NULL, '2026-11-29T16:44:32', 108000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 561 | Godzilla Trừ Không | 29/11 18:30 | Phòng 4 | D5
(3321, 8, NULL, '2026-11-29T16:45:19', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 558 | Dune: Hành Tinh Cát - Phần Hai | 29/11 18:00 | Phòng 5 | F7 F8
(3322, 9, 98, '2026-11-29T16:45:43', 216000, N'Paid', N'Cash', 220000, 15, 0, NULL, NULL, NULL), -- suat 561 | Godzilla Trừ Không | 29/11 18:30 | Phòng 4 | D6 D7
(3323, 7, 95, '2026-11-29T17:04:45', 360000, N'Paid', N'Card', NULL, 25, 0, NULL, NULL, NULL), -- suat 580 | Trại Giam Hạnh Phúc | 30/11 13:45 | Phòng 1 | D5 D6 D7 D8
(3324, 9, NULL, '2026-11-29T17:07:07', 720000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 558 | Dune: Hành Tinh Cát - Phần Hai | 29/11 18:00 | Phòng 5 | K8 K9 K10 K11 K12
(3325, 8, 21, '2026-11-29T17:19:02', 270000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 559 | Trại Giam Hạnh Phúc | 29/11 18:30 | Phòng 1 | E5 E6 E7
(3326, 7, NULL, '2026-11-29T17:27:15', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 562 | Bò Sữa Bay | 29/11 19:30 | Phòng 2 | F3 F4
(3327, 7, 75, '2026-11-29T17:34:24', 90000, N'Paid', N'Cash', 500000, 6, 0, NULL, NULL, NULL), -- suat 578 | Hexed: Thế Giới Phép Thuật | 30/11 12:45 | Phòng 2 | H5
(3328, 7, NULL, '2026-11-29T17:37:57', 108000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 561 | Godzilla Trừ Không | 29/11 18:30 | Phòng 4 | H7
(3329, 7, 89, '2026-11-29T17:40:58', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 560 | Điểm Mù | 29/11 18:30 | Phòng 3 | E7
(3330, 9, NULL, '2026-11-29T17:42:19', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 595 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 30/11 21:45 | Phòng 2 | J3 J4 J5 J6
(3331, 8, NULL, '2026-11-29T17:42:20', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 558 | Dune: Hành Tinh Cát - Phần Hai | 29/11 18:00 | Phòng 5 | G8 G9 G10 G11
(3332, 8, NULL, '2026-11-29T17:46:36', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 592 | Mẹ Mìn: Giao Kèo Với Quỷ | 30/11 21:00 | Phòng 1 | B5 B6 B7
(3333, 9, NULL, '2026-11-29T17:51:21', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 581 | Ngày Con Còn Mẹ | 30/11 15:00 | Phòng 2 | A7 A8 A9
(3334, 9, NULL, '2026-11-29T17:53:23', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 562 | Bò Sữa Bay | 29/11 19:30 | Phòng 2 | C6 C7
(3335, 7, NULL, '2026-11-29T17:53:41', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 562 | Bò Sữa Bay | 29/11 19:30 | Phòng 2 | J3 J4 J5 J6
(3336, 7, 68, '2026-11-29T17:56:48', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 560 | Điểm Mù | 29/11 18:30 | Phòng 3 | D8 D9
(3337, 7, NULL, '2026-11-29T17:56:56', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 559 | Trại Giam Hạnh Phúc | 29/11 18:30 | Phòng 1 | H6 H7
(3338, 9, NULL, '2026-11-29T18:04:38', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 567 | Mẹ Mìn: Giao Kèo Với Quỷ | 29/11 21:45 | Phòng 3 | E3 E4
(3339, 7, NULL, '2026-11-29T18:11:33', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 561 | Godzilla Trừ Không | 29/11 18:30 | Phòng 4 | H9 H10
(3340, 8, NULL, '2026-11-29T18:17:54', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 562 | Bò Sữa Bay | 29/11 19:30 | Phòng 2 | D7
(3341, 9, NULL, '2026-11-29T18:21:31', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 562 | Bò Sữa Bay | 29/11 19:30 | Phòng 2 | H6 H7
(3342, 8, NULL, '2026-11-29T18:22:26', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 559 | Trại Giam Hạnh Phúc | 29/11 18:30 | Phòng 1 | A5 A6 A7
(3343, 8, NULL, '2026-11-29T18:47:22', 270000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 564 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 21:00 | Phòng 4 | B6 B7 B8
(3344, 8, NULL, '2026-11-29T18:47:22', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 576 | Ramayana: Khởi Nguồn Một Huyền Thoại | 30/11 12:15 | Phòng 4 | E6 E7
(3345, 8, NULL, '2026-11-29T18:51:06', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 564 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 21:00 | Phòng 4 | G6 G7
(3346, 8, 68, '2026-11-29T18:52:06', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 562 | Bò Sữa Bay | 29/11 19:30 | Phòng 2 | E8
(3347, 9, NULL, '2026-11-29T18:57:49', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 562 | Bò Sữa Bay | 29/11 19:30 | Phòng 2 | D5 D6
(3348, 7, NULL, '2026-11-29T18:59:31', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 591 | Bò Sữa Bay | 30/11 19:30 | Phòng 2 | H6 H7
(3349, 8, 87, '2026-11-29T19:11:32', 360000, N'Cancelled', N'Card', NULL, 25, 0, N'Khách đổi ý', '2026-11-29T19:23:46', 8), -- suat 562 | Bò Sữa Bay | 29/11 19:30 | Phòng 2 | H2 H3 H4 H5
(3350, 7, NULL, '2026-11-29T19:15:37', 300000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 567 | Mẹ Mìn: Giao Kèo Với Quỷ | 29/11 21:45 | Phòng 3 | A4 A5 A6 A7
(3351, 9, 72, '2026-11-29T19:20:30', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 589 | Điểm Mù | 30/11 18:30 | Phòng 3 | D6 D7
(3352, 7, NULL, '2026-11-29T19:28:52', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 565 | Godzilla Trừ Không | 29/11 21:15 | Phòng 5 | G6 G7
(3353, 7, NULL, '2026-11-29T19:29:34', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 566 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 29/11 21:45 | Phòng 2 | H7 H8 H9
(3354, 7, NULL, '2026-11-29T19:44:40', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 564 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 21:00 | Phòng 4 | F4 F5
(3355, 7, 117, '2026-11-29T19:47:37', 216000, N'Paid', N'Cash', 220000, 15, 0, NULL, NULL, NULL), -- suat 564 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 21:00 | Phòng 4 | G9 G10
(3356, 8, NULL, '2026-11-29T20:00:58', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 565 | Godzilla Trừ Không | 29/11 21:15 | Phòng 5 | J9
(3357, 9, NULL, '2026-11-29T20:04:01', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 563 | Mẹ Mìn: Giao Kèo Với Quỷ | 29/11 21:00 | Phòng 1 | J1 J2
(3358, 9, NULL, '2026-11-29T20:06:12', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 565 | Godzilla Trừ Không | 29/11 21:15 | Phòng 5 | J4 J5
(3359, 7, NULL, '2026-11-29T20:11:23', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 563 | Mẹ Mìn: Giao Kèo Với Quỷ | 29/11 21:00 | Phòng 1 | F6 F7
(3360, 7, NULL, '2026-11-29T20:11:26', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 566 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 29/11 21:45 | Phòng 2 | E3 E4
(3361, 7, NULL, '2026-11-29T20:12:35', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 563 | Mẹ Mìn: Giao Kèo Với Quỷ | 29/11 21:00 | Phòng 1 | B8
(3362, 7, 21, '2026-11-29T20:20:53', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 567 | Mẹ Mìn: Giao Kèo Với Quỷ | 29/11 21:45 | Phòng 3 | D7
(3363, 7, 8, '2026-11-29T20:22:29', 108000, N'Paid', N'Cash', 108000, 7, 0, NULL, NULL, NULL), -- suat 564 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 21:00 | Phòng 4 | F6
(3364, 9, NULL, '2026-11-29T20:26:42', 270000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 586 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 30/11 17:15 | Phòng 2 | F7 F8 F9
(3365, 7, 77, '2026-11-29T20:35:03', 288000, N'Cancelled', N'Cash', 288000, 20, 0, N'Khách đổi ý', '2026-11-29T20:55:08', 7), -- suat 594 | Godzilla Trừ Không | 30/11 21:15 | Phòng 5 | H6 H7
(3366, 8, 69, '2026-11-29T20:35:40', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 566 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 29/11 21:45 | Phòng 2 | D5 D6
(3367, 7, NULL, '2026-11-29T20:41:21', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 565 | Godzilla Trừ Không | 29/11 21:15 | Phòng 5 | J6 J7
(3368, 7, NULL, '2026-11-29T20:45:35', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 606 | Godzilla Trừ Không | 01/12 12:15 | Phòng 5 | F6 F7 F8
(3369, 9, NULL, '2026-11-29T20:46:39', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 568 | Trại Giam Hạnh Phúc | 30/11 09:00 | Phòng 1 | D6 D7 D8 D9
(3370, 9, NULL, '2026-11-29T20:48:14', 324000, N'Paid', N'Cash', 324000, 0, 0, NULL, NULL, NULL), -- suat 564 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 29/11 21:00 | Phòng 4 | F9 F10 F11
(3371, 7, NULL, '2026-11-29T20:53:50', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 565 | Godzilla Trừ Không | 29/11 21:15 | Phòng 5 | L9 L10 L11 L12
(3372, 8, NULL, '2026-11-29T21:05:02', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 567 | Mẹ Mìn: Giao Kèo Với Quỷ | 29/11 21:45 | Phòng 3 | F5 F6
(3373, 7, NULL, '2026-11-29T21:07:15', 75000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 567 | Mẹ Mìn: Giao Kèo Với Quỷ | 29/11 21:45 | Phòng 3 | B7
(3374, 8, NULL, '2026-11-29T21:15:46', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 581 | Ngày Con Còn Mẹ | 30/11 15:00 | Phòng 2 | D5 D6 D7 D8
(3375, 9, 21, '2026-11-29T21:25:55', 360000, N'Paid', N'Cash', 400000, 25, 0, NULL, NULL, NULL), -- suat 566 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 29/11 21:45 | Phòng 2 | E5 E6 E7 E8
(3376, 7, 98, '2026-11-29T21:26:18', 270000, N'Cancelled', N'Transfer', NULL, 18, 0, N'Lỗi thanh toán', '2026-11-29T21:43:25', 7), -- suat 589 | Điểm Mù | 30/11 18:30 | Phòng 3 | G6 G7 G8
(3377, 8, NULL, '2026-11-29T21:28:21', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 566 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 29/11 21:45 | Phòng 2 | F5 F6 F7
(3378, 8, NULL, '2026-11-29T21:28:38', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 566 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 29/11 21:45 | Phòng 2 | F9
(3379, 7, NULL, '2026-11-29T21:38:02', 324000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL); -- suat 576 | Ramayana: Khởi Nguồn Một Huyền Thoại | 30/11 12:15 | Phòng 4 | G5 G6 G7
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(7355, 3208, 546, 1, 77, 90000, N'Active'),
(7356, 3208, 546, 1, 78, 90000, N'Active'),
(7357, 3208, 546, 1, 79, 90000, N'Active'),
(7358, 3208, 546, 1, 80, 90000, N'Active'),
(7359, 3208, 546, 1, 81, 90000, N'Active'),
(7360, 3208, 546, 1, 82, 90000, N'Active'),
(7361, 3209, 540, 2, 139, 75000, N'Active'),
(7362, 3210, 541, 5, 522, 144000, N'Active'),
(7363, 3210, 541, 5, 523, 144000, N'Active'),
(7364, 3211, 542, 4, 429, 108000, N'Active'),
(7365, 3211, 542, 4, 430, 108000, N'Active'),
(7366, 3212, 539, 1, 66, 90000, N'Active'),
(7367, 3213, 540, 2, 198, 90000, N'Active'),
(7368, 3213, 540, 2, 199, 90000, N'Active'),
(7369, 3214, 584, 3, 269, 90000, N'Cancelled'),
(7370, 3214, 584, 3, 270, 90000, N'Cancelled'),
(7371, 3214, 584, 3, 271, 90000, N'Cancelled'),
(7372, 3215, 590, 4, 364, 108000, N'Active'),
(7373, 3215, 590, 4, 365, 108000, N'Active'),
(7374, 3215, 590, 4, 366, 108000, N'Active'),
(7375, 3215, 590, 4, 367, 108000, N'Active'),
(7376, 3215, 590, 4, 368, 108000, N'Active'),
(7377, 3215, 590, 4, 369, 108000, N'Active'),
(7378, 3216, 542, 4, 330, 90000, N'Active'),
(7379, 3216, 542, 4, 331, 90000, N'Active'),
(7380, 3217, 539, 1, 88, 90000, N'Active'),
(7381, 3217, 539, 1, 89, 90000, N'Active'),
(7382, 3218, 542, 4, 354, 90000, N'Active'),
(7383, 3218, 542, 4, 355, 90000, N'Active'),
(7384, 3219, 540, 2, 127, 75000, N'Active'),
(7385, 3219, 540, 2, 128, 75000, N'Active'),
(7386, 3220, 545, 3, 319, 90000, N'Active'),
(7387, 3220, 545, 3, 320, 90000, N'Active'),
(7388, 3221, 543, 3, 323, 90000, N'Active'),
(7389, 3221, 543, 3, 324, 90000, N'Active'),
(7390, 3222, 571, 4, 414, 108000, N'Active'),
(7391, 3222, 571, 4, 415, 108000, N'Active'),
(7392, 3223, 546, 1, 28, 75000, N'Active'),
(7393, 3223, 546, 1, 29, 75000, N'Active'),
(7394, 3224, 547, 4, 414, 108000, N'Active'),
(7395, 3224, 547, 4, 415, 108000, N'Active'),
(7396, 3225, 568, 1, 88, 90000, N'Active'),
(7397, 3225, 568, 1, 89, 90000, N'Active'),
(7398, 3226, 558, 5, 507, 144000, N'Active'),
(7399, 3226, 558, 5, 508, 144000, N'Active'),
(7400, 3226, 558, 5, 509, 144000, N'Active'),
(7401, 3226, 558, 5, 510, 144000, N'Active'),
(7402, 3226, 558, 5, 511, 144000, N'Active'),
(7403, 3227, 548, 5, 461, 120000, N'Active'),
(7404, 3227, 548, 5, 462, 120000, N'Active'),
(7405, 3227, 548, 5, 463, 120000, N'Active'),
(7406, 3227, 548, 5, 464, 120000, N'Active'),
(7407, 3228, 547, 4, 329, 90000, N'Active'),
(7408, 3228, 547, 4, 330, 90000, N'Active'),
(7409, 3228, 547, 4, 331, 90000, N'Active'),
(7410, 3228, 547, 4, 332, 90000, N'Active'),
(7411, 3228, 547, 4, 333, 90000, N'Active'),
(7412, 3229, 546, 1, 30, 75000, N'Cancelled'),
(7413, 3229, 546, 1, 31, 75000, N'Cancelled'),
(7414, 3230, 587, 5, 486, 144000, N'Active'),
(7415, 3230, 587, 5, 487, 144000, N'Active'),
(7416, 3231, 570, 5, 535, 144000, N'Active'),
(7417, 3232, 595, 2, 161, 90000, N'Active'),
(7418, 3232, 595, 2, 162, 90000, N'Active'),
(7419, 3232, 595, 2, 163, 90000, N'Active'),
(7420, 3233, 551, 1, 78, 90000, N'Active'),
(7421, 3234, 549, 2, 159, 90000, N'Active'),
(7422, 3234, 549, 2, 160, 90000, N'Active'),
(7423, 3234, 549, 2, 161, 90000, N'Active'),
(7424, 3234, 549, 2, 162, 90000, N'Active'),
(7425, 3234, 549, 2, 163, 90000, N'Active'),
(7426, 3234, 549, 2, 164, 90000, N'Active'),
(7427, 3235, 551, 1, 92, 90000, N'Active'),
(7428, 3236, 596, 3, 269, 90000, N'Active'),
(7429, 3236, 596, 3, 270, 90000, N'Active'),
(7430, 3237, 544, 2, 209, 90000, N'Active'),
(7431, 3237, 544, 2, 210, 90000, N'Active'),
(7432, 3238, 611, 5, 461, 120000, N'Active'),
(7433, 3238, 611, 5, 462, 120000, N'Active'),
(7434, 3238, 611, 5, 463, 120000, N'Active'),
(7435, 3238, 611, 5, 464, 120000, N'Active'),
(7436, 3239, 590, 4, 332, 90000, N'Active'),
(7437, 3239, 590, 4, 333, 90000, N'Active'),
(7438, 3240, 545, 3, 293, 90000, N'Active'),
(7439, 3240, 545, 3, 294, 90000, N'Active'),
(7440, 3241, 545, 3, 283, 90000, N'Active'),
(7441, 3242, 544, 2, 152, 90000, N'Active'),
(7442, 3242, 544, 2, 153, 90000, N'Active'),
(7443, 3243, 549, 2, 172, 90000, N'Active'),
(7444, 3243, 549, 2, 173, 90000, N'Active'),
(7445, 3243, 549, 2, 174, 90000, N'Active'),
(7446, 3243, 549, 2, 175, 90000, N'Active'),
(7447, 3243, 549, 2, 176, 90000, N'Active'),
(7448, 3244, 559, 1, 43, 90000, N'Active'),
(7449, 3245, 558, 5, 449, 120000, N'Active'),
(7450, 3245, 558, 5, 450, 120000, N'Active'),
(7451, 3246, 544, 2, 150, 90000, N'Active'),
(7452, 3246, 544, 2, 151, 90000, N'Active'),
(7453, 3247, 555, 3, 234, 75000, N'Active'),
(7454, 3248, 589, 3, 315, 90000, N'Cancelled'),
(7455, 3248, 589, 3, 316, 90000, N'Cancelled'),
(7456, 3249, 548, 5, 507, 144000, N'Active'),
(7457, 3249, 548, 5, 508, 144000, N'Active'),
(7458, 3249, 548, 5, 509, 144000, N'Active'),
(7459, 3249, 548, 5, 510, 144000, N'Active'),
(7460, 3249, 548, 5, 511, 144000, N'Active'),
(7461, 3250, 551, 1, 40, 90000, N'Active'),
(7462, 3250, 551, 1, 41, 90000, N'Active'),
(7463, 3251, 548, 5, 547, 144000, N'Active'),
(7464, 3251, 548, 5, 548, 144000, N'Active'),
(7465, 3252, 582, 5, 438, 120000, N'Active'),
(7466, 3252, 582, 5, 439, 120000, N'Active'),
(7467, 3252, 582, 5, 440, 120000, N'Active'),
(7468, 3253, 554, 4, 379, 108000, N'Active'),
(7469, 3254, 551, 1, 97, 90000, N'Active'),
(7470, 3254, 551, 1, 98, 90000, N'Active'),
(7471, 3255, 550, 3, 245, 75000, N'Active'),
(7472, 3255, 550, 3, 246, 75000, N'Active'),
(7473, 3255, 550, 3, 247, 75000, N'Active'),
(7474, 3255, 550, 3, 248, 75000, N'Active'),
(7475, 3255, 550, 3, 249, 75000, N'Active'),
(7476, 3256, 553, 5, 521, 144000, N'Active'),
(7477, 3256, 553, 5, 522, 144000, N'Active'),
(7478, 3257, 551, 1, 6, 75000, N'Active'),
(7479, 3257, 551, 1, 7, 75000, N'Active'),
(7480, 3257, 551, 1, 8, 75000, N'Active'),
(7481, 3258, 559, 1, 31, 75000, N'Active'),
(7482, 3259, 601, 3, 258, 90000, N'Active'),
(7483, 3260, 547, 4, 367, 108000, N'Active'),
(7484, 3260, 547, 4, 368, 108000, N'Active'),
(7485, 3261, 554, 4, 369, 108000, N'Active'),
(7486, 3262, 560, 3, 272, 90000, N'Active'),
(7487, 3262, 560, 3, 273, 90000, N'Active'),
(7488, 3263, 552, 2, 186, 90000, N'Active'),
(7489, 3263, 552, 2, 187, 90000, N'Active'),
(7490, 3264, 555, 3, 273, 90000, N'Active'),
(7491, 3265, 551, 1, 67, 90000, N'Active'),
(7492, 3265, 551, 1, 68, 90000, N'Active'),
(7493, 3266, 559, 1, 78, 90000, N'Active'),
(7494, 3266, 559, 1, 79, 90000, N'Active'),
(7495, 3267, 554, 4, 364, 108000, N'Active'),
(7496, 3267, 554, 4, 365, 108000, N'Active'),
(7497, 3267, 554, 4, 366, 108000, N'Active'),
(7498, 3267, 554, 4, 367, 108000, N'Active'),
(7499, 3267, 554, 4, 368, 108000, N'Active'),
(7500, 3268, 562, 2, 174, 90000, N'Active'),
(7501, 3268, 562, 2, 175, 90000, N'Active'),
(7502, 3268, 562, 2, 176, 90000, N'Active'),
(7503, 3269, 557, 2, 115, 75000, N'Active'),
(7504, 3269, 557, 2, 116, 75000, N'Active'),
(7505, 3270, 551, 1, 105, 90000, N'Active'),
(7506, 3270, 551, 1, 106, 90000, N'Active'),
(7507, 3271, 569, 2, 186, 90000, N'Active'),
(7508, 3271, 569, 2, 187, 90000, N'Active'),
(7509, 3272, 553, 5, 523, 144000, N'Active'),
(7510, 3272, 553, 5, 524, 144000, N'Active'),
(7511, 3272, 553, 5, 525, 144000, N'Active'),
(7512, 3273, 558, 5, 522, 144000, N'Active'),
(7513, 3274, 553, 5, 547, 144000, N'Active'),
(7514, 3274, 553, 5, 548, 144000, N'Active'),
(7515, 3275, 560, 3, 257, 90000, N'Active'),
(7516, 3275, 560, 3, 258, 90000, N'Active'),
(7517, 3276, 567, 3, 270, 90000, N'Active'),
(7518, 3276, 567, 3, 271, 90000, N'Active'),
(7519, 3277, 562, 2, 177, 90000, N'Active'),
(7520, 3277, 562, 2, 178, 90000, N'Active'),
(7521, 3278, 555, 3, 246, 75000, N'Active'),
(7522, 3279, 556, 1, 81, 90000, N'Active'),
(7523, 3280, 561, 4, 401, 108000, N'Active'),
(7524, 3280, 561, 4, 402, 108000, N'Active'),
(7525, 3281, 558, 5, 542, 144000, N'Active'),
(7526, 3281, 558, 5, 543, 144000, N'Active'),
(7527, 3282, 552, 2, 173, 90000, N'Active'),
(7528, 3282, 552, 2, 174, 90000, N'Active'),
(7529, 3283, 552, 2, 162, 90000, N'Active'),
(7530, 3283, 552, 2, 163, 90000, N'Active'),
(7531, 3283, 552, 2, 164, 90000, N'Active'),
(7532, 3284, 559, 1, 41, 90000, N'Active'),
(7533, 3284, 559, 1, 42, 90000, N'Active'),
(7534, 3285, 563, 1, 101, 90000, N'Active'),
(7535, 3285, 563, 1, 102, 90000, N'Active'),
(7536, 3285, 563, 1, 103, 90000, N'Active'),
(7537, 3285, 563, 1, 104, 90000, N'Active'),
(7538, 3286, 559, 1, 57, 90000, N'Active'),
(7539, 3286, 559, 1, 58, 90000, N'Active'),
(7540, 3287, 553, 5, 462, 120000, N'Active'),
(7541, 3288, 557, 2, 151, 90000, N'Active'),
(7542, 3288, 557, 2, 152, 90000, N'Active'),
(7543, 3289, 557, 2, 150, 90000, N'Active'),
(7544, 3290, 552, 2, 150, 90000, N'Active'),
(7545, 3290, 552, 2, 151, 90000, N'Active'),
(7546, 3291, 557, 2, 174, 90000, N'Active'),
(7547, 3291, 557, 2, 175, 90000, N'Active'),
(7548, 3292, 555, 3, 232, 75000, N'Active'),
(7549, 3292, 555, 3, 233, 75000, N'Active'),
(7550, 3293, 555, 3, 224, 75000, N'Active'),
(7551, 3294, 559, 1, 18, 75000, N'Active'),
(7552, 3294, 559, 1, 19, 75000, N'Active'),
(7553, 3295, 565, 5, 547, 144000, N'Active'),
(7554, 3296, 561, 4, 389, 108000, N'Active'),
(7555, 3296, 561, 4, 390, 108000, N'Active'),
(7556, 3297, 558, 5, 557, 144000, N'Active'),
(7557, 3297, 558, 5, 558, 144000, N'Active'),
(7558, 3298, 560, 3, 306, 90000, N'Active'),
(7559, 3298, 560, 3, 307, 90000, N'Active'),
(7560, 3299, 615, 2, 185, 90000, N'Active'),
(7561, 3299, 615, 2, 186, 90000, N'Active'),
(7562, 3299, 615, 2, 187, 90000, N'Active'),
(7563, 3299, 615, 2, 188, 90000, N'Active'),
(7564, 3300, 564, 4, 391, 108000, N'Active'),
(7565, 3301, 557, 2, 186, 90000, N'Active'),
(7566, 3302, 556, 1, 79, 90000, N'Active'),
(7567, 3302, 556, 1, 80, 90000, N'Active'),
(7568, 3303, 561, 4, 331, 90000, N'Active'),
(7569, 3303, 561, 4, 332, 90000, N'Active'),
(7570, 3304, 560, 3, 323, 90000, N'Active'),
(7571, 3304, 560, 3, 324, 90000, N'Active'),
(7572, 3305, 565, 5, 485, 144000, N'Active'),
(7573, 3305, 565, 5, 486, 144000, N'Active'),
(7574, 3306, 558, 5, 532, 144000, N'Active'),
(7575, 3306, 558, 5, 533, 144000, N'Active'),
(7576, 3306, 558, 5, 534, 144000, N'Active'),
(7577, 3306, 558, 5, 535, 144000, N'Active'),
(7578, 3307, 562, 2, 200, 90000, N'Active'),
(7579, 3307, 562, 2, 201, 90000, N'Active'),
(7580, 3308, 588, 1, 18, 75000, N'Active'),
(7581, 3308, 588, 1, 19, 75000, N'Active'),
(7582, 3309, 561, 4, 352, 90000, N'Active'),
(7583, 3309, 561, 4, 353, 90000, N'Active'),
(7584, 3309, 561, 4, 354, 90000, N'Active'),
(7585, 3310, 560, 3, 269, 90000, N'Active'),
(7586, 3310, 560, 3, 270, 90000, N'Active'),
(7587, 3311, 558, 5, 544, 144000, N'Active'),
(7588, 3311, 558, 5, 545, 144000, N'Active'),
(7589, 3311, 558, 5, 546, 144000, N'Active'),
(7590, 3312, 612, 4, 416, 108000, N'Active'),
(7591, 3312, 612, 4, 417, 108000, N'Active'),
(7592, 3312, 612, 4, 418, 108000, N'Active'),
(7593, 3313, 561, 4, 411, 108000, N'Active'),
(7594, 3313, 561, 4, 412, 108000, N'Active'),
(7595, 3313, 561, 4, 413, 108000, N'Active'),
(7596, 3313, 561, 4, 414, 108000, N'Active'),
(7597, 3314, 560, 3, 234, 75000, N'Active'),
(7598, 3314, 560, 3, 235, 75000, N'Active'),
(7599, 3315, 557, 2, 137, 75000, N'Active'),
(7600, 3315, 557, 2, 138, 75000, N'Active'),
(7601, 3315, 557, 2, 139, 75000, N'Active'),
(7602, 3315, 557, 2, 140, 75000, N'Active'),
(7603, 3316, 562, 2, 124, 75000, N'Active'),
(7604, 3317, 577, 5, 450, 120000, N'Active'),
(7605, 3317, 577, 5, 451, 120000, N'Active'),
(7606, 3318, 564, 4, 416, 108000, N'Active'),
(7607, 3319, 557, 2, 142, 75000, N'Active'),
(7608, 3320, 561, 4, 365, 108000, N'Active'),
(7609, 3321, 558, 5, 499, 144000, N'Active'),
(7610, 3321, 558, 5, 500, 144000, N'Active'),
(7611, 3322, 561, 4, 366, 108000, N'Active'),
(7612, 3322, 561, 4, 367, 108000, N'Active'),
(7613, 3323, 580, 1, 41, 90000, N'Active'),
(7614, 3323, 580, 1, 42, 90000, N'Active'),
(7615, 3323, 580, 1, 43, 90000, N'Active'),
(7616, 3323, 580, 1, 44, 90000, N'Active'),
(7617, 3324, 558, 5, 548, 144000, N'Active'),
(7618, 3324, 558, 5, 549, 144000, N'Active'),
(7619, 3324, 558, 5, 550, 144000, N'Active'),
(7620, 3324, 558, 5, 551, 144000, N'Active'),
(7621, 3324, 558, 5, 552, 144000, N'Active'),
(7622, 3325, 559, 1, 53, 90000, N'Active'),
(7623, 3325, 559, 1, 54, 90000, N'Active'),
(7624, 3325, 559, 1, 55, 90000, N'Active'),
(7625, 3326, 562, 2, 171, 90000, N'Active'),
(7626, 3326, 562, 2, 172, 90000, N'Active'),
(7627, 3327, 578, 2, 197, 90000, N'Active'),
(7628, 3328, 561, 4, 415, 108000, N'Active'),
(7629, 3329, 560, 3, 271, 90000, N'Active'),
(7630, 3330, 595, 2, 207, 90000, N'Active'),
(7631, 3330, 595, 2, 208, 90000, N'Active'),
(7632, 3330, 595, 2, 209, 90000, N'Active'),
(7633, 3330, 595, 2, 210, 90000, N'Active'),
(7634, 3331, 558, 5, 512, 144000, N'Active'),
(7635, 3331, 558, 5, 513, 144000, N'Active'),
(7636, 3331, 558, 5, 514, 144000, N'Active'),
(7637, 3331, 558, 5, 515, 144000, N'Active'),
(7638, 3332, 592, 1, 17, 75000, N'Active'),
(7639, 3332, 592, 1, 18, 75000, N'Active'),
(7640, 3332, 592, 1, 19, 75000, N'Active'),
(7641, 3333, 581, 2, 115, 75000, N'Active'),
(7642, 3333, 581, 2, 116, 75000, N'Active'),
(7643, 3333, 581, 2, 117, 75000, N'Active'),
(7644, 3334, 562, 2, 138, 75000, N'Active'),
(7645, 3334, 562, 2, 139, 75000, N'Active'),
(7646, 3335, 562, 2, 207, 90000, N'Active'),
(7647, 3335, 562, 2, 208, 90000, N'Active'),
(7648, 3335, 562, 2, 209, 90000, N'Active'),
(7649, 3335, 562, 2, 210, 90000, N'Active'),
(7650, 3336, 560, 3, 260, 90000, N'Active'),
(7651, 3336, 560, 3, 261, 90000, N'Active'),
(7652, 3337, 559, 1, 90, 90000, N'Active'),
(7653, 3337, 559, 1, 91, 90000, N'Active'),
(7654, 3338, 567, 3, 267, 90000, N'Active'),
(7655, 3338, 567, 3, 268, 90000, N'Active'),
(7656, 3339, 561, 4, 417, 108000, N'Active'),
(7657, 3339, 561, 4, 418, 108000, N'Active'),
(7658, 3340, 562, 2, 151, 90000, N'Active'),
(7659, 3341, 562, 2, 198, 90000, N'Active'),
(7660, 3341, 562, 2, 199, 90000, N'Active'),
(7661, 3342, 559, 1, 5, 75000, N'Active'),
(7662, 3342, 559, 1, 6, 75000, N'Active'),
(7663, 3342, 559, 1, 7, 75000, N'Active'),
(7664, 3343, 564, 4, 342, 90000, N'Active'),
(7665, 3343, 564, 4, 343, 90000, N'Active'),
(7666, 3343, 564, 4, 344, 90000, N'Active'),
(7667, 3344, 576, 4, 378, 108000, N'Active'),
(7668, 3344, 576, 4, 379, 108000, N'Active'),
(7669, 3345, 564, 4, 402, 108000, N'Active'),
(7670, 3345, 564, 4, 403, 108000, N'Active'),
(7671, 3346, 562, 2, 164, 90000, N'Active'),
(7672, 3347, 562, 2, 149, 90000, N'Active'),
(7673, 3347, 562, 2, 150, 90000, N'Active'),
(7674, 3348, 591, 2, 198, 90000, N'Active'),
(7675, 3348, 591, 2, 199, 90000, N'Active'),
(7676, 3349, 562, 2, 194, 90000, N'Cancelled'),
(7677, 3349, 562, 2, 195, 90000, N'Cancelled'),
(7678, 3349, 562, 2, 196, 90000, N'Cancelled'),
(7679, 3349, 562, 2, 197, 90000, N'Cancelled'),
(7680, 3350, 567, 3, 220, 75000, N'Active'),
(7681, 3350, 567, 3, 221, 75000, N'Active'),
(7682, 3350, 567, 3, 222, 75000, N'Active'),
(7683, 3350, 567, 3, 223, 75000, N'Active'),
(7684, 3351, 589, 3, 258, 90000, N'Active'),
(7685, 3351, 589, 3, 259, 90000, N'Active'),
(7686, 3352, 565, 5, 510, 144000, N'Active'),
(7687, 3352, 565, 5, 511, 144000, N'Active'),
(7688, 3353, 566, 2, 199, 90000, N'Active'),
(7689, 3353, 566, 2, 200, 90000, N'Active'),
(7690, 3353, 566, 2, 201, 90000, N'Active'),
(7691, 3354, 564, 4, 388, 108000, N'Active'),
(7692, 3354, 564, 4, 389, 108000, N'Active'),
(7693, 3355, 564, 4, 405, 108000, N'Active'),
(7694, 3355, 564, 4, 406, 108000, N'Active'),
(7695, 3356, 565, 5, 537, 144000, N'Active'),
(7696, 3357, 563, 1, 97, 90000, N'Active'),
(7697, 3357, 563, 1, 98, 90000, N'Active'),
(7698, 3358, 565, 5, 532, 144000, N'Active'),
(7699, 3358, 565, 5, 533, 144000, N'Active'),
(7700, 3359, 563, 1, 66, 90000, N'Active'),
(7701, 3359, 563, 1, 67, 90000, N'Active'),
(7702, 3360, 566, 2, 159, 90000, N'Active'),
(7703, 3360, 566, 2, 160, 90000, N'Active'),
(7704, 3361, 563, 1, 20, 75000, N'Active'),
(7705, 3362, 567, 3, 259, 90000, N'Active'),
(7706, 3363, 564, 4, 390, 108000, N'Active'),
(7707, 3364, 586, 2, 175, 90000, N'Active'),
(7708, 3364, 586, 2, 176, 90000, N'Active'),
(7709, 3364, 586, 2, 177, 90000, N'Active'),
(7710, 3365, 594, 5, 522, 144000, N'Cancelled'),
(7711, 3365, 594, 5, 523, 144000, N'Cancelled'),
(7712, 3366, 566, 2, 149, 90000, N'Active'),
(7713, 3366, 566, 2, 150, 90000, N'Active'),
(7714, 3367, 565, 5, 534, 144000, N'Active'),
(7715, 3367, 565, 5, 535, 144000, N'Active'),
(7716, 3368, 606, 5, 498, 144000, N'Active'),
(7717, 3368, 606, 5, 499, 144000, N'Active'),
(7718, 3368, 606, 5, 500, 144000, N'Active'),
(7719, 3369, 568, 1, 42, 90000, N'Active'),
(7720, 3369, 568, 1, 43, 90000, N'Active'),
(7721, 3369, 568, 1, 44, 90000, N'Active'),
(7722, 3369, 568, 1, 45, 90000, N'Active'),
(7723, 3370, 564, 4, 393, 108000, N'Active'),
(7724, 3370, 564, 4, 394, 108000, N'Active'),
(7725, 3370, 564, 4, 395, 108000, N'Active'),
(7726, 3371, 565, 5, 561, 144000, N'Active'),
(7727, 3371, 565, 5, 562, 144000, N'Active'),
(7728, 3371, 565, 5, 563, 144000, N'Active'),
(7729, 3371, 565, 5, 564, 144000, N'Active'),
(7730, 3372, 567, 3, 281, 90000, N'Active'),
(7731, 3372, 567, 3, 282, 90000, N'Active'),
(7732, 3373, 567, 3, 235, 75000, N'Active'),
(7733, 3374, 581, 2, 149, 90000, N'Active'),
(7734, 3374, 581, 2, 150, 90000, N'Active'),
(7735, 3374, 581, 2, 151, 90000, N'Active'),
(7736, 3374, 581, 2, 152, 90000, N'Active'),
(7737, 3375, 566, 2, 161, 90000, N'Active'),
(7738, 3375, 566, 2, 162, 90000, N'Active'),
(7739, 3375, 566, 2, 163, 90000, N'Active'),
(7740, 3375, 566, 2, 164, 90000, N'Active'),
(7741, 3376, 589, 3, 294, 90000, N'Cancelled'),
(7742, 3376, 589, 3, 295, 90000, N'Cancelled'),
(7743, 3376, 589, 3, 296, 90000, N'Cancelled'),
(7744, 3377, 566, 2, 173, 90000, N'Active'),
(7745, 3377, 566, 2, 174, 90000, N'Active'),
(7746, 3377, 566, 2, 175, 90000, N'Active'),
(7747, 3378, 566, 2, 177, 90000, N'Active'),
(7748, 3379, 576, 4, 401, 108000, N'Active'),
(7749, 3379, 576, 4, 402, 108000, N'Active'),
(7750, 3379, 576, 4, 403, 108000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 2 30/11/2026: 121 hoa don (4 huy), 282 ve, doanh thu 26.748.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(3380, 7, 51, '2026-11-30T08:03:53', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 626 | Trại Giam Hạnh Phúc | 02/12 09:00 | Phòng 1 | F7 F8
(3381, 7, NULL, '2026-11-30T08:08:38', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 569 | Hexed: Thế Giới Phép Thuật | 30/11 09:00 | Phòng 2 | G4 G5
(3382, 8, 56, '2026-11-30T08:23:41', 108000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 651 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 21:00 | Phòng 4 | D6
(3383, 7, NULL, '2026-11-30T08:24:15', 450000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 572 | Kiến Lé Phiêu Lưu Ké | 30/11 09:30 | Phòng 3 | F5 F6 F7 F8 F9
(3384, 7, 80, '2026-11-30T08:31:02', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 601 | Kiến Lé Phiêu Lưu Ké | 01/12 09:30 | Phòng 3 | B6 B7
(3385, 8, NULL, '2026-11-30T08:34:36', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 574 | Ngày Con Còn Mẹ | 30/11 11:15 | Phòng 3 | H6 H7 H8
(3386, 8, 25, '2026-11-30T08:40:17', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 569 | Hexed: Thế Giới Phép Thuật | 30/11 09:00 | Phòng 2 | H8 H9
(3387, 7, NULL, '2026-11-30T08:41:32', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 569 | Hexed: Thế Giới Phép Thuật | 30/11 09:00 | Phòng 2 | H5 H6
(3388, 7, 64, '2026-11-30T08:49:15', 360000, N'Paid', N'Cash', 500000, 18, 0, NULL, NULL, NULL), -- suat 571 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 30/11 09:15 | Phòng 4 | C5 C6 C7 C8
(3389, 8, NULL, '2026-11-30T08:56:19', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 580 | Trại Giam Hạnh Phúc | 30/11 13:45 | Phòng 1 | J11 J12
(3390, 8, NULL, '2026-11-30T08:57:46', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 571 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 30/11 09:15 | Phòng 4 | B6 B7
(3391, 8, NULL, '2026-11-30T09:09:25', 576000, N'Paid', N'Cash', 600000, 0, 0, NULL, NULL, NULL), -- suat 577 | Godzilla Trừ Không | 30/11 12:15 | Phòng 5 | L9 L10 L11 L12
(3392, 8, NULL, '2026-11-30T09:20:30', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 582 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 30/11 15:00 | Phòng 5 | K7 K8
(3393, 8, 70, '2026-11-30T09:29:07', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 590 | Godzilla Trừ Không | 30/11 18:30 | Phòng 4 | H6 H7
(3394, 8, NULL, '2026-11-30T09:46:12', 225000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 580 | Trại Giam Hạnh Phúc | 30/11 13:45 | Phòng 1 | B6 B7 B8
(3395, 8, 33, '2026-11-30T09:49:39', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 573 | Ma Mút Con Vượt Kỷ Băng Hà | 30/11 11:15 | Phòng 2 | D6 D7 D8
(3396, 8, NULL, '2026-11-30T09:50:55', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 575 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 30/11 11:30 | Phòng 1 | D6 D7 D8 D9
(3397, 8, NULL, '2026-11-30T09:59:09', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 622 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 21:00 | Phòng 4 | D5 D6 D7
(3398, 7, NULL, '2026-11-30T10:15:07', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 620 | Bò Sữa Bay | 01/12 19:30 | Phòng 2 | J7 J8
(3399, 7, NULL, '2026-11-30T10:35:45', 450000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-11-30T11:46:38', 7), -- suat 586 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 30/11 17:15 | Phòng 2 | G4 G5 G6 G7 G8
(3400, 7, NULL, '2026-11-30T10:37:11', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 574 | Ngày Con Còn Mẹ | 30/11 11:15 | Phòng 3 | A6 A7
(3401, 8, NULL, '2026-11-30T10:38:05', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 605 | Ramayana: Khởi Nguồn Một Huyền Thoại | 01/12 12:15 | Phòng 4 | H6 H7
(3402, 8, NULL, '2026-11-30T10:53:06', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 579 | Bí Kíp Luyện Cướp | 30/11 13:30 | Phòng 3 | E8 E9
(3403, 7, 32, '2026-11-30T10:55:26', 180000, N'Paid', N'Transfer', NULL, 9, 0, NULL, NULL, NULL), -- suat 583 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 30/11 15:30 | Phòng 4 | A4 A5
(3404, 8, NULL, '2026-11-30T10:56:03', 120000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 616 | Dune: Hành Tinh Cát - Phần Hai | 01/12 18:00 | Phòng 5 | D7
(3405, 7, NULL, '2026-11-30T11:02:05', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 618 | Điểm Mù | 01/12 18:30 | Phòng 3 | H6
(3406, 8, 66, '2026-11-30T11:05:02', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 614 | Mẹ Mìn: Giao Kèo Với Quỷ | 01/12 16:15 | Phòng 1 | D6 D7
(3407, 7, NULL, '2026-11-30T11:08:23', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 578 | Hexed: Thế Giới Phép Thuật | 30/11 12:45 | Phòng 2 | E6 E7
(3408, 7, NULL, '2026-11-30T11:26:09', 150000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 584 | Chị Chị Em Em 3 | 30/11 16:00 | Phòng 3 | B5 B6
(3409, 8, 67, '2026-11-30T11:27:44', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 617 | Trại Giam Hạnh Phúc | 01/12 18:30 | Phòng 1 | H6 H7 H8
(3410, 8, 44, '2026-11-30T11:36:37', 300000, N'Cancelled', N'Card', NULL, 15, 0, N'Khách đổi ý', '2026-11-30T11:40:51', 8), -- suat 627 | Hexed: Thế Giới Phép Thuật | 02/12 09:00 | Phòng 2 | A5 A6 A7 A8
(3411, 7, NULL, '2026-11-30T11:40:29', 360000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 578 | Hexed: Thế Giới Phép Thuật | 30/11 12:45 | Phòng 2 | G5 G6 G7 G8
(3412, 7, NULL, '2026-11-30T11:44:59', 450000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 576 | Ramayana: Khởi Nguồn Một Huyền Thoại | 30/11 12:15 | Phòng 4 | A4 A5 A6 A7 A8
(3413, 8, NULL, '2026-11-30T11:59:14', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 599 | Dune: Hành Tinh Cát - Phần Hai | 01/12 09:00 | Phòng 5 | G6 G7
(3414, 8, NULL, '2026-11-30T12:09:38', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 581 | Ngày Con Còn Mẹ | 30/11 15:00 | Phòng 2 | G7
(3415, 8, NULL, '2026-11-30T12:26:06', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 579 | Bí Kíp Luyện Cướp | 30/11 13:30 | Phòng 3 | D7 D8
(3416, 7, NULL, '2026-11-30T12:36:13', 540000, N'Paid', N'Cash', 1000000, 0, 0, NULL, NULL, NULL), -- suat 583 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 30/11 15:30 | Phòng 4 | A6 A7 A8 A9 A10 A11
(3417, 7, NULL, '2026-11-30T12:52:49', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 618 | Điểm Mù | 01/12 18:30 | Phòng 3 | E6 E7
(3418, 7, NULL, '2026-11-30T12:52:54', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 649 | Bò Sữa Bay | 02/12 19:30 | Phòng 2 | A6 A7 A8
(3419, 7, NULL, '2026-11-30T13:00:12', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 591 | Bò Sữa Bay | 30/11 19:30 | Phòng 2 | D8 D9
(3420, 8, NULL, '2026-11-30T13:02:12', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 650 | Mẹ Mìn: Giao Kèo Với Quỷ | 02/12 21:00 | Phòng 1 | F6 F7
(3421, 8, 30, '2026-11-30T13:02:48', 270000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 591 | Bò Sữa Bay | 30/11 19:30 | Phòng 2 | H2 H3 H4
(3422, 8, NULL, '2026-11-30T13:12:27', 75000, N'Paid', N'Cash', 75000, 0, 0, NULL, NULL, NULL), -- suat 579 | Bí Kíp Luyện Cướp | 30/11 13:30 | Phòng 3 | A7
(3423, 7, 25, '2026-11-30T13:13:22', 432000, N'Paid', N'Cash', 500000, 30, 0, NULL, NULL, NULL), -- suat 623 | Godzilla Trừ Không | 01/12 21:15 | Phòng 5 | G6 G7 G8
(3424, 7, NULL, '2026-11-30T13:20:08', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 584 | Chị Chị Em Em 3 | 30/11 16:00 | Phòng 3 | G7 G8
(3425, 7, NULL, '2026-11-30T13:25:19', 864000, N'Paid', N'Cash', 864000, 0, 0, NULL, NULL, NULL), -- suat 587 | Dune: Hành Tinh Cát - Phần Hai | 30/11 18:00 | Phòng 5 | J3 J4 J5 J6 J7 J8
(3426, 8, 51, '2026-11-30T13:32:33', 288000, N'Paid', N'Cash', 500000, 20, 0, NULL, NULL, NULL), -- suat 587 | Dune: Hành Tinh Cát - Phần Hai | 30/11 18:00 | Phòng 5 | E4 E5
(3427, 8, NULL, '2026-11-30T13:35:11', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 583 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 30/11 15:30 | Phòng 4 | E6 E7 E8 E9
(3428, 8, 37, '2026-11-30T13:47:38', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 581 | Ngày Con Còn Mẹ | 30/11 15:00 | Phòng 2 | F6 F7
(3429, 8, NULL, '2026-11-30T14:09:23', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 585 | Mẹ Mìn: Giao Kèo Với Quỷ | 30/11 16:15 | Phòng 1 | B7 B8
(3430, 7, 69, '2026-11-30T14:19:54', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 581 | Ngày Con Còn Mẹ | 30/11 15:00 | Phòng 2 | H7
(3431, 7, NULL, '2026-11-30T14:25:33', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 583 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 30/11 15:30 | Phòng 4 | F6 F7
(3432, 8, 46, '2026-11-30T14:30:01', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 585 | Mẹ Mìn: Giao Kèo Với Quỷ | 30/11 16:15 | Phòng 1 | A4 A5
(3433, 7, NULL, '2026-11-30T14:30:56', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 587 | Dune: Hành Tinh Cát - Phần Hai | 30/11 18:00 | Phòng 5 | F7 F8
(3434, 8, 30, '2026-11-30T14:42:24', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 588 | Trại Giam Hạnh Phúc | 30/11 18:30 | Phòng 1 | E7 E8 E9
(3435, 7, NULL, '2026-11-30T14:53:50', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 588 | Trại Giam Hạnh Phúc | 30/11 18:30 | Phòng 1 | F6 F7
(3436, 10, NULL, '2026-11-30T15:03:17', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 599 | Dune: Hành Tinh Cát - Phần Hai | 01/12 09:00 | Phòng 5 | K6 K7
(3437, 9, 37, '2026-11-30T15:03:30', 180000, N'Paid', N'Cash', 200000, 9, 0, NULL, NULL, NULL), -- suat 622 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 21:00 | Phòng 4 | C7 C8
(3438, 9, NULL, '2026-11-30T15:09:25', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 590 | Godzilla Trừ Không | 30/11 18:30 | Phòng 4 | B5 B6
(3439, 9, 102, '2026-11-30T15:12:30', 144000, N'Paid', N'Transfer', NULL, 10, 0, NULL, NULL, NULL), -- suat 635 | Godzilla Trừ Không | 02/12 12:15 | Phòng 5 | J7
(3440, 9, 81, '2026-11-30T15:16:57', 288000, N'Paid', N'Cash', 288000, 20, 0, NULL, NULL, NULL), -- suat 587 | Dune: Hành Tinh Cát - Phần Hai | 30/11 18:00 | Phòng 5 | G5 G6
(3441, 9, NULL, '2026-11-30T15:22:53', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 585 | Mẹ Mìn: Giao Kèo Với Quỷ | 30/11 16:15 | Phòng 1 | J1 J2
(3442, 9, 59, '2026-11-30T15:24:58', 75000, N'Paid', N'Cash', 500000, 3, 0, NULL, NULL, NULL), -- suat 644 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 02/12 17:15 | Phòng 2 | B7
(3443, 9, 44, '2026-11-30T15:33:51', 216000, N'Paid', N'Cash', 300000, 15, 0, NULL, NULL, NULL), -- suat 593 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 30/11 21:00 | Phòng 4 | F8 F9
(3444, 9, NULL, '2026-11-30T15:34:55', 288000, N'Cancelled', N'Cash', 288000, 0, 0, N'Lỗi thanh toán', '2026-11-30T16:18:40', 2), -- suat 587 | Dune: Hành Tinh Cát - Phần Hai | 30/11 18:00 | Phòng 5 | L5 L6
(3445, 9, 62, '2026-11-30T15:39:33', 180000, N'Paid', N'Cash', 180000, 18, 0, NULL, NULL, NULL), -- suat 618 | Điểm Mù | 01/12 18:30 | Phòng 3 | J11 J12
(3446, 9, NULL, '2026-11-30T15:48:35', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 590 | Godzilla Trừ Không | 30/11 18:30 | Phòng 4 | C6 C7
(3447, 9, 93, '2026-11-30T16:05:50', 288000, N'Paid', N'Cash', 500000, 20, 0, NULL, NULL, NULL), -- suat 594 | Godzilla Trừ Không | 30/11 21:15 | Phòng 5 | K6 K7
(3448, 9, NULL, '2026-11-30T16:09:16', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 620 | Bò Sữa Bay | 01/12 19:30 | Phòng 2 | E5
(3449, 10, NULL, '2026-11-30T16:14:24', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 588 | Trại Giam Hạnh Phúc | 30/11 18:30 | Phòng 1 | H6
(3450, 9, 33, '2026-11-30T16:16:28', 225000, N'Paid', N'Transfer', NULL, 11, 0, NULL, NULL, NULL), -- suat 633 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 02/12 11:30 | Phòng 1 | C5 C6 C7
(3451, 10, NULL, '2026-11-30T16:17:54', 240000, N'Cancelled', N'Card', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-30T17:09:30', 10), -- suat 606 | Godzilla Trừ Không | 01/12 12:15 | Phòng 5 | D6 D7
(3452, 9, NULL, '2026-11-30T16:18:07', 300000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 586 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 30/11 17:15 | Phòng 2 | A6 A7 A8 A9
(3453, 9, NULL, '2026-11-30T16:26:06', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 623 | Godzilla Trừ Không | 01/12 21:15 | Phòng 5 | E6 E7
(3454, 10, 43, '2026-11-30T16:42:29', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 608 | Bí Kíp Luyện Cướp | 01/12 13:30 | Phòng 3 | D5 D6 D7 D8
(3455, 10, NULL, '2026-11-30T16:53:30', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 587 | Dune: Hành Tinh Cát - Phần Hai | 30/11 18:00 | Phòng 5 | L9 L10
(3456, 9, NULL, '2026-11-30T17:04:05', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 598 | Hexed: Thế Giới Phép Thuật | 01/12 09:00 | Phòng 2 | E5
(3457, 10, NULL, '2026-11-30T17:05:34', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 624 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 01/12 21:45 | Phòng 2 | E6
(3458, 9, NULL, '2026-11-30T17:08:33', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 606 | Godzilla Trừ Không | 01/12 12:15 | Phòng 5 | F4 F5
(3459, 9, 67, '2026-11-30T17:30:51', 144000, N'Paid', N'Transfer', NULL, 10, 0, NULL, NULL, NULL), -- suat 587 | Dune: Hành Tinh Cát - Phần Hai | 30/11 18:00 | Phòng 5 | F6
(3460, 10, NULL, '2026-11-30T17:32:30', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 620 | Bò Sữa Bay | 01/12 19:30 | Phòng 2 | B5 B6
(3461, 10, NULL, '2026-11-30T17:33:41', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 588 | Trại Giam Hạnh Phúc | 30/11 18:30 | Phòng 1 | J3 J4
(3462, 10, 75, '2026-11-30T17:39:31', 360000, N'Paid', N'Card', NULL, 25, 0, NULL, NULL, NULL), -- suat 588 | Trại Giam Hạnh Phúc | 30/11 18:30 | Phòng 1 | H2 H3 H4 H5
(3463, 10, NULL, '2026-11-30T17:41:08', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 592 | Mẹ Mìn: Giao Kèo Với Quỷ | 30/11 21:00 | Phòng 1 | C7 C8
(3464, 10, 114, '2026-11-30T17:41:58', 75000, N'Paid', N'Card', NULL, 3, 0, NULL, NULL, NULL), -- suat 588 | Trại Giam Hạnh Phúc | 30/11 18:30 | Phòng 1 | A6
(3465, 10, NULL, '2026-11-30T17:56:49', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 589 | Điểm Mù | 30/11 18:30 | Phòng 3 | F5 F6
(3466, 9, 77, '2026-11-30T18:02:57', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 589 | Điểm Mù | 30/11 18:30 | Phòng 3 | G9 G10 G11
(3467, 10, 89, '2026-11-30T18:09:15', 288000, N'Paid', N'Cash', 288000, 20, 0, NULL, NULL, NULL), -- suat 594 | Godzilla Trừ Không | 30/11 21:15 | Phòng 5 | J6 J7
(3468, 9, NULL, '2026-11-30T18:16:43', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 591 | Bò Sữa Bay | 30/11 19:30 | Phòng 2 | F6 F7
(3469, 9, NULL, '2026-11-30T18:17:14', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 591 | Bò Sữa Bay | 30/11 19:30 | Phòng 2 | E7 E8
(3470, 10, 1, '2026-11-30T18:17:41', 576000, N'Paid', N'Cash', 576000, 40, 0, NULL, NULL, NULL), -- suat 594 | Godzilla Trừ Không | 30/11 21:15 | Phòng 5 | H8 H9 H10 H11
(3471, 9, 79, '2026-11-30T18:18:45', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 624 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 01/12 21:45 | Phòng 2 | G6
(3472, 9, NULL, '2026-11-30T18:20:04', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 630 | Kiến Lé Phiêu Lưu Ké | 02/12 09:30 | Phòng 3 | E6 E7
(3473, 10, NULL, '2026-11-30T18:31:47', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 625 | Mẹ Mìn: Giao Kèo Với Quỷ | 01/12 21:45 | Phòng 3 | F9 F10
(3474, 10, NULL, '2026-11-30T18:34:05', 75000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 613 | Chị Chị Em Em 3 | 01/12 16:00 | Phòng 3 | C6
(3475, 9, NULL, '2026-11-30T18:39:35', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 591 | Bò Sữa Bay | 30/11 19:30 | Phòng 2 | G6 G7
(3476, 9, NULL, '2026-11-30T18:45:35', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 591 | Bò Sữa Bay | 30/11 19:30 | Phòng 2 | F8 F9 F10 F11
(3477, 10, 77, '2026-11-30T18:55:21', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 596 | Mẹ Mìn: Giao Kèo Với Quỷ | 30/11 21:45 | Phòng 3 | D4 D5
(3478, 9, NULL, '2026-11-30T18:57:01', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 591 | Bò Sữa Bay | 30/11 19:30 | Phòng 2 | D5 D6 D7
(3479, 9, NULL, '2026-11-30T18:58:41', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 591 | Bò Sữa Bay | 30/11 19:30 | Phòng 2 | F1 F2
(3480, 10, NULL, '2026-11-30T19:05:27', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 591 | Bò Sữa Bay | 30/11 19:30 | Phòng 2 | F3 F4
(3481, 10, 28, '2026-11-30T19:09:32', 360000, N'Paid', N'Cash', 360000, 25, 0, NULL, NULL, NULL), -- suat 592 | Mẹ Mìn: Giao Kèo Với Quỷ | 30/11 21:00 | Phòng 1 | E5 E6 E7 E8
(3482, 9, NULL, '2026-11-30T19:13:06', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 596 | Mẹ Mìn: Giao Kèo Với Quỷ | 30/11 21:45 | Phòng 3 | D8 D9
(3483, 10, NULL, '2026-11-30T19:18:47', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 593 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 30/11 21:00 | Phòng 4 | H3 H4
(3484, 10, NULL, '2026-11-30T19:41:00', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 593 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 30/11 21:00 | Phòng 4 | H5 H6 H7 H8
(3485, 10, 21, '2026-11-30T19:43:59', 108000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 593 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 30/11 21:00 | Phòng 4 | G6
(3486, 10, NULL, '2026-11-30T19:46:30', 108000, N'Paid', N'Cash', 110000, 0, 0, NULL, NULL, NULL), -- suat 593 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 30/11 21:00 | Phòng 4 | G7
(3487, 10, NULL, '2026-11-30T19:58:19', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 594 | Godzilla Trừ Không | 30/11 21:15 | Phòng 5 | H4 H5
(3488, 10, NULL, '2026-11-30T20:06:20', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 594 | Godzilla Trừ Không | 30/11 21:15 | Phòng 5 | G7
(3489, 9, NULL, '2026-11-30T20:12:06', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 596 | Mẹ Mìn: Giao Kèo Với Quỷ | 30/11 21:45 | Phòng 3 | F6
(3490, 9, NULL, '2026-11-30T20:16:26', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 596 | Mẹ Mìn: Giao Kèo Với Quỷ | 30/11 21:45 | Phòng 3 | J11 J12
(3491, 9, NULL, '2026-11-30T20:31:37', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 592 | Mẹ Mìn: Giao Kèo Với Quỷ | 30/11 21:00 | Phòng 1 | C5 C6
(3492, 10, 33, '2026-11-30T20:33:23', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 594 | Godzilla Trừ Không | 30/11 21:15 | Phòng 5 | E4 E5
(3493, 9, NULL, '2026-11-30T20:37:29', 270000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 595 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 30/11 21:45 | Phòng 2 | G8 G9 G10
(3494, 10, NULL, '2026-11-30T20:41:07', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 598 | Hexed: Thế Giới Phép Thuật | 01/12 09:00 | Phòng 2 | H5 H6
(3495, 10, NULL, '2026-11-30T20:47:27', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 594 | Godzilla Trừ Không | 30/11 21:15 | Phòng 5 | K3 K4 K5
(3496, 9, 105, '2026-11-30T20:47:49', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 603 | Ngày Con Còn Mẹ | 01/12 11:15 | Phòng 3 | H7 H8
(3497, 9, NULL, '2026-11-30T20:49:49', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 595 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 30/11 21:45 | Phòng 2 | F7 F8
(3498, 9, 113, '2026-11-30T20:55:19', 225000, N'Paid', N'Transfer', NULL, 11, 0, NULL, NULL, NULL), -- suat 595 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 30/11 21:45 | Phòng 2 | B6 B7 B8
(3499, 10, NULL, '2026-11-30T21:24:15', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 595 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 30/11 21:45 | Phòng 2 | G4 G5 G6 G7
(3500, 10, NULL, '2026-11-30T21:32:48', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL); -- suat 596 | Mẹ Mìn: Giao Kèo Với Quỷ | 30/11 21:45 | Phòng 3 | B5 B6
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(7751, 3380, 626, 1, 67, 90000, N'Active'),
(7752, 3380, 626, 1, 68, 90000, N'Active'),
(7753, 3381, 569, 2, 184, 90000, N'Active'),
(7754, 3381, 569, 2, 185, 90000, N'Active'),
(7755, 3382, 651, 4, 366, 108000, N'Active'),
(7756, 3383, 572, 3, 281, 90000, N'Active'),
(7757, 3383, 572, 3, 282, 90000, N'Active'),
(7758, 3383, 572, 3, 283, 90000, N'Active'),
(7759, 3383, 572, 3, 284, 90000, N'Active'),
(7760, 3383, 572, 3, 285, 90000, N'Active'),
(7761, 3384, 601, 3, 234, 75000, N'Active'),
(7762, 3384, 601, 3, 235, 75000, N'Active'),
(7763, 3385, 574, 3, 306, 90000, N'Active'),
(7764, 3385, 574, 3, 307, 90000, N'Active'),
(7765, 3385, 574, 3, 308, 90000, N'Active'),
(7766, 3386, 569, 2, 200, 90000, N'Active'),
(7767, 3386, 569, 2, 201, 90000, N'Active'),
(7768, 3387, 569, 2, 197, 90000, N'Active'),
(7769, 3387, 569, 2, 198, 90000, N'Active'),
(7770, 3388, 571, 4, 353, 90000, N'Active'),
(7771, 3388, 571, 4, 354, 90000, N'Active'),
(7772, 3388, 571, 4, 355, 90000, N'Active'),
(7773, 3388, 571, 4, 356, 90000, N'Active'),
(7774, 3389, 580, 1, 107, 90000, N'Active'),
(7775, 3389, 580, 1, 108, 90000, N'Active'),
(7776, 3390, 571, 4, 342, 90000, N'Active'),
(7777, 3390, 571, 4, 343, 90000, N'Active'),
(7778, 3391, 577, 5, 561, 144000, N'Active'),
(7779, 3391, 577, 5, 562, 144000, N'Active'),
(7780, 3391, 577, 5, 563, 144000, N'Active'),
(7781, 3391, 577, 5, 564, 144000, N'Active'),
(7782, 3392, 582, 5, 547, 144000, N'Active'),
(7783, 3392, 582, 5, 548, 144000, N'Active'),
(7784, 3393, 590, 4, 414, 108000, N'Active'),
(7785, 3393, 590, 4, 415, 108000, N'Active'),
(7786, 3394, 580, 1, 18, 75000, N'Active'),
(7787, 3394, 580, 1, 19, 75000, N'Active'),
(7788, 3394, 580, 1, 20, 75000, N'Active'),
(7789, 3395, 573, 2, 150, 90000, N'Active'),
(7790, 3395, 573, 2, 151, 90000, N'Active'),
(7791, 3395, 573, 2, 152, 90000, N'Active'),
(7792, 3396, 575, 1, 42, 90000, N'Active'),
(7793, 3396, 575, 1, 43, 90000, N'Active'),
(7794, 3396, 575, 1, 44, 90000, N'Active'),
(7795, 3396, 575, 1, 45, 90000, N'Active'),
(7796, 3397, 622, 4, 365, 108000, N'Active'),
(7797, 3397, 622, 4, 366, 108000, N'Active'),
(7798, 3397, 622, 4, 367, 108000, N'Active'),
(7799, 3398, 620, 2, 211, 90000, N'Active'),
(7800, 3398, 620, 2, 212, 90000, N'Active'),
(7801, 3399, 586, 2, 184, 90000, N'Cancelled'),
(7802, 3399, 586, 2, 185, 90000, N'Cancelled'),
(7803, 3399, 586, 2, 186, 90000, N'Cancelled'),
(7804, 3399, 586, 2, 187, 90000, N'Cancelled'),
(7805, 3399, 586, 2, 188, 90000, N'Cancelled'),
(7806, 3400, 574, 3, 222, 75000, N'Active'),
(7807, 3400, 574, 3, 223, 75000, N'Active'),
(7808, 3401, 605, 4, 414, 108000, N'Active'),
(7809, 3401, 605, 4, 415, 108000, N'Active'),
(7810, 3402, 579, 3, 272, 90000, N'Active'),
(7811, 3402, 579, 3, 273, 90000, N'Active'),
(7812, 3403, 583, 4, 328, 90000, N'Active'),
(7813, 3403, 583, 4, 329, 90000, N'Active'),
(7814, 3404, 616, 5, 475, 120000, N'Active'),
(7815, 3405, 618, 3, 306, 90000, N'Active'),
(7816, 3406, 614, 1, 42, 90000, N'Active'),
(7817, 3406, 614, 1, 43, 90000, N'Active'),
(7818, 3407, 578, 2, 162, 90000, N'Active'),
(7819, 3407, 578, 2, 163, 90000, N'Active'),
(7820, 3408, 584, 3, 233, 75000, N'Active'),
(7821, 3408, 584, 3, 234, 75000, N'Active'),
(7822, 3409, 617, 1, 90, 90000, N'Active'),
(7823, 3409, 617, 1, 91, 90000, N'Active'),
(7824, 3409, 617, 1, 92, 90000, N'Active'),
(7825, 3410, 627, 2, 113, 75000, N'Cancelled'),
(7826, 3410, 627, 2, 114, 75000, N'Cancelled'),
(7827, 3410, 627, 2, 115, 75000, N'Cancelled'),
(7828, 3410, 627, 2, 116, 75000, N'Cancelled'),
(7829, 3411, 578, 2, 185, 90000, N'Active'),
(7830, 3411, 578, 2, 186, 90000, N'Active'),
(7831, 3411, 578, 2, 187, 90000, N'Active'),
(7832, 3411, 578, 2, 188, 90000, N'Active'),
(7833, 3412, 576, 4, 328, 90000, N'Active'),
(7834, 3412, 576, 4, 329, 90000, N'Active'),
(7835, 3412, 576, 4, 330, 90000, N'Active'),
(7836, 3412, 576, 4, 331, 90000, N'Active'),
(7837, 3412, 576, 4, 332, 90000, N'Active'),
(7838, 3413, 599, 5, 510, 144000, N'Active'),
(7839, 3413, 599, 5, 511, 144000, N'Active'),
(7840, 3414, 581, 2, 187, 90000, N'Active'),
(7841, 3415, 579, 3, 259, 90000, N'Active'),
(7842, 3415, 579, 3, 260, 90000, N'Active'),
(7843, 3416, 583, 4, 330, 90000, N'Active'),
(7844, 3416, 583, 4, 331, 90000, N'Active'),
(7845, 3416, 583, 4, 332, 90000, N'Active'),
(7846, 3416, 583, 4, 333, 90000, N'Active'),
(7847, 3416, 583, 4, 334, 90000, N'Active'),
(7848, 3416, 583, 4, 335, 90000, N'Active'),
(7849, 3417, 618, 3, 270, 90000, N'Active'),
(7850, 3417, 618, 3, 271, 90000, N'Active'),
(7851, 3418, 649, 2, 114, 75000, N'Active'),
(7852, 3418, 649, 2, 115, 75000, N'Active'),
(7853, 3418, 649, 2, 116, 75000, N'Active'),
(7854, 3419, 591, 2, 152, 90000, N'Active'),
(7855, 3419, 591, 2, 153, 90000, N'Active'),
(7856, 3420, 650, 1, 66, 90000, N'Active'),
(7857, 3420, 650, 1, 67, 90000, N'Active'),
(7858, 3421, 591, 2, 194, 90000, N'Active'),
(7859, 3421, 591, 2, 195, 90000, N'Active'),
(7860, 3421, 591, 2, 196, 90000, N'Active'),
(7861, 3422, 579, 3, 223, 75000, N'Active'),
(7862, 3423, 623, 5, 510, 144000, N'Active'),
(7863, 3423, 623, 5, 511, 144000, N'Active'),
(7864, 3423, 623, 5, 512, 144000, N'Active'),
(7865, 3424, 584, 3, 295, 90000, N'Active'),
(7866, 3424, 584, 3, 296, 90000, N'Active'),
(7867, 3425, 587, 5, 531, 144000, N'Active'),
(7868, 3425, 587, 5, 532, 144000, N'Active'),
(7869, 3425, 587, 5, 533, 144000, N'Active'),
(7870, 3425, 587, 5, 534, 144000, N'Active'),
(7871, 3425, 587, 5, 535, 144000, N'Active'),
(7872, 3425, 587, 5, 536, 144000, N'Active'),
(7873, 3426, 587, 5, 484, 144000, N'Active'),
(7874, 3426, 587, 5, 485, 144000, N'Active'),
(7875, 3427, 583, 4, 378, 108000, N'Active'),
(7876, 3427, 583, 4, 379, 108000, N'Active'),
(7877, 3427, 583, 4, 380, 108000, N'Active'),
(7878, 3427, 583, 4, 381, 108000, N'Active'),
(7879, 3428, 581, 2, 174, 90000, N'Active'),
(7880, 3428, 581, 2, 175, 90000, N'Active'),
(7881, 3429, 585, 1, 19, 75000, N'Active'),
(7882, 3429, 585, 1, 20, 75000, N'Active'),
(7883, 3430, 581, 2, 199, 90000, N'Active'),
(7884, 3431, 583, 4, 390, 108000, N'Active'),
(7885, 3431, 583, 4, 391, 108000, N'Active'),
(7886, 3432, 585, 1, 4, 75000, N'Active'),
(7887, 3432, 585, 1, 5, 75000, N'Active'),
(7888, 3433, 587, 5, 499, 144000, N'Active'),
(7889, 3433, 587, 5, 500, 144000, N'Active'),
(7890, 3434, 588, 1, 55, 90000, N'Active'),
(7891, 3434, 588, 1, 56, 90000, N'Active'),
(7892, 3434, 588, 1, 57, 90000, N'Active'),
(7893, 3435, 588, 1, 66, 90000, N'Active'),
(7894, 3435, 588, 1, 67, 90000, N'Active'),
(7895, 3436, 599, 5, 546, 144000, N'Active'),
(7896, 3436, 599, 5, 547, 144000, N'Active'),
(7897, 3437, 622, 4, 355, 90000, N'Active'),
(7898, 3437, 622, 4, 356, 90000, N'Active'),
(7899, 3438, 590, 4, 341, 90000, N'Active'),
(7900, 3438, 590, 4, 342, 90000, N'Active'),
(7901, 3439, 635, 5, 535, 144000, N'Active'),
(7902, 3440, 587, 5, 509, 144000, N'Active'),
(7903, 3440, 587, 5, 510, 144000, N'Active'),
(7904, 3441, 585, 1, 97, 90000, N'Active'),
(7905, 3441, 585, 1, 98, 90000, N'Active'),
(7906, 3442, 644, 2, 127, 75000, N'Active'),
(7907, 3443, 593, 4, 392, 108000, N'Active'),
(7908, 3443, 593, 4, 393, 108000, N'Active'),
(7909, 3444, 587, 5, 557, 144000, N'Cancelled'),
(7910, 3444, 587, 5, 558, 144000, N'Cancelled'),
(7911, 3445, 618, 3, 323, 90000, N'Active'),
(7912, 3445, 618, 3, 324, 90000, N'Active'),
(7913, 3446, 590, 4, 354, 90000, N'Active'),
(7914, 3446, 590, 4, 355, 90000, N'Active'),
(7915, 3447, 594, 5, 546, 144000, N'Active'),
(7916, 3447, 594, 5, 547, 144000, N'Active'),
(7917, 3448, 620, 2, 161, 90000, N'Active'),
(7918, 3449, 588, 1, 90, 90000, N'Active'),
(7919, 3450, 633, 1, 29, 75000, N'Active'),
(7920, 3450, 633, 1, 30, 75000, N'Active'),
(7921, 3450, 633, 1, 31, 75000, N'Active'),
(7922, 3451, 606, 5, 474, 120000, N'Cancelled'),
(7923, 3451, 606, 5, 475, 120000, N'Cancelled'),
(7924, 3452, 586, 2, 114, 75000, N'Active'),
(7925, 3452, 586, 2, 115, 75000, N'Active'),
(7926, 3452, 586, 2, 116, 75000, N'Active'),
(7927, 3452, 586, 2, 117, 75000, N'Active'),
(7928, 3453, 623, 5, 486, 144000, N'Active'),
(7929, 3453, 623, 5, 487, 144000, N'Active'),
(7930, 3454, 608, 3, 257, 90000, N'Active'),
(7931, 3454, 608, 3, 258, 90000, N'Active'),
(7932, 3454, 608, 3, 259, 90000, N'Active'),
(7933, 3454, 608, 3, 260, 90000, N'Active'),
(7934, 3455, 587, 5, 561, 144000, N'Active'),
(7935, 3455, 587, 5, 562, 144000, N'Active'),
(7936, 3456, 598, 2, 161, 90000, N'Active'),
(7937, 3457, 624, 2, 162, 90000, N'Active'),
(7938, 3458, 606, 5, 496, 144000, N'Active'),
(7939, 3458, 606, 5, 497, 144000, N'Active'),
(7940, 3459, 587, 5, 498, 144000, N'Active'),
(7941, 3460, 620, 2, 125, 75000, N'Active'),
(7942, 3460, 620, 2, 126, 75000, N'Active'),
(7943, 3461, 588, 1, 99, 90000, N'Active'),
(7944, 3461, 588, 1, 100, 90000, N'Active'),
(7945, 3462, 588, 1, 86, 90000, N'Active'),
(7946, 3462, 588, 1, 87, 90000, N'Active'),
(7947, 3462, 588, 1, 88, 90000, N'Active'),
(7948, 3462, 588, 1, 89, 90000, N'Active'),
(7949, 3463, 592, 1, 31, 75000, N'Active'),
(7950, 3463, 592, 1, 32, 75000, N'Active'),
(7951, 3464, 588, 1, 6, 75000, N'Active'),
(7952, 3465, 589, 3, 281, 90000, N'Active'),
(7953, 3465, 589, 3, 282, 90000, N'Active'),
(7954, 3466, 589, 3, 297, 90000, N'Active'),
(7955, 3466, 589, 3, 298, 90000, N'Active'),
(7956, 3466, 589, 3, 299, 90000, N'Active'),
(7957, 3467, 594, 5, 534, 144000, N'Active'),
(7958, 3467, 594, 5, 535, 144000, N'Active'),
(7959, 3468, 591, 2, 174, 90000, N'Active'),
(7960, 3468, 591, 2, 175, 90000, N'Active'),
(7961, 3469, 591, 2, 163, 90000, N'Active'),
(7962, 3469, 591, 2, 164, 90000, N'Active'),
(7963, 3470, 594, 5, 524, 144000, N'Active'),
(7964, 3470, 594, 5, 525, 144000, N'Active'),
(7965, 3470, 594, 5, 526, 144000, N'Active'),
(7966, 3470, 594, 5, 527, 144000, N'Active'),
(7967, 3471, 624, 2, 186, 90000, N'Active'),
(7968, 3472, 630, 3, 270, 90000, N'Active'),
(7969, 3472, 630, 3, 271, 90000, N'Active'),
(7970, 3473, 625, 3, 285, 90000, N'Active'),
(7971, 3473, 625, 3, 286, 90000, N'Active'),
(7972, 3474, 613, 3, 246, 75000, N'Active'),
(7973, 3475, 591, 2, 186, 90000, N'Active'),
(7974, 3475, 591, 2, 187, 90000, N'Active'),
(7975, 3476, 591, 2, 176, 90000, N'Active'),
(7976, 3476, 591, 2, 177, 90000, N'Active'),
(7977, 3476, 591, 2, 178, 90000, N'Active'),
(7978, 3476, 591, 2, 179, 90000, N'Active'),
(7979, 3477, 596, 3, 256, 90000, N'Active'),
(7980, 3477, 596, 3, 257, 90000, N'Active'),
(7981, 3478, 591, 2, 149, 90000, N'Active'),
(7982, 3478, 591, 2, 150, 90000, N'Active'),
(7983, 3478, 591, 2, 151, 90000, N'Active'),
(7984, 3479, 591, 2, 169, 90000, N'Active'),
(7985, 3479, 591, 2, 170, 90000, N'Active'),
(7986, 3480, 591, 2, 171, 90000, N'Active'),
(7987, 3480, 591, 2, 172, 90000, N'Active'),
(7988, 3481, 592, 1, 53, 90000, N'Active'),
(7989, 3481, 592, 1, 54, 90000, N'Active'),
(7990, 3481, 592, 1, 55, 90000, N'Active'),
(7991, 3481, 592, 1, 56, 90000, N'Active'),
(7992, 3482, 596, 3, 260, 90000, N'Active'),
(7993, 3482, 596, 3, 261, 90000, N'Active'),
(7994, 3483, 593, 4, 411, 108000, N'Active'),
(7995, 3483, 593, 4, 412, 108000, N'Active'),
(7996, 3484, 593, 4, 413, 108000, N'Active'),
(7997, 3484, 593, 4, 414, 108000, N'Active'),
(7998, 3484, 593, 4, 415, 108000, N'Active'),
(7999, 3484, 593, 4, 416, 108000, N'Active'),
(8000, 3485, 593, 4, 402, 108000, N'Active'),
(8001, 3486, 593, 4, 403, 108000, N'Active'),
(8002, 3487, 594, 5, 520, 144000, N'Active'),
(8003, 3487, 594, 5, 521, 144000, N'Active'),
(8004, 3488, 594, 5, 511, 144000, N'Active'),
(8005, 3489, 596, 3, 282, 90000, N'Active'),
(8006, 3490, 596, 3, 323, 90000, N'Active'),
(8007, 3490, 596, 3, 324, 90000, N'Active'),
(8008, 3491, 592, 1, 29, 75000, N'Active'),
(8009, 3491, 592, 1, 30, 75000, N'Active'),
(8010, 3492, 594, 5, 484, 144000, N'Active'),
(8011, 3492, 594, 5, 485, 144000, N'Active'),
(8012, 3493, 595, 2, 188, 90000, N'Active'),
(8013, 3493, 595, 2, 189, 90000, N'Active'),
(8014, 3493, 595, 2, 190, 90000, N'Active'),
(8015, 3494, 598, 2, 197, 90000, N'Active'),
(8016, 3494, 598, 2, 198, 90000, N'Active'),
(8017, 3495, 594, 5, 543, 144000, N'Active'),
(8018, 3495, 594, 5, 544, 144000, N'Active'),
(8019, 3495, 594, 5, 545, 144000, N'Active'),
(8020, 3496, 603, 3, 307, 90000, N'Active'),
(8021, 3496, 603, 3, 308, 90000, N'Active'),
(8022, 3497, 595, 2, 175, 90000, N'Active'),
(8023, 3497, 595, 2, 176, 90000, N'Active'),
(8024, 3498, 595, 2, 126, 75000, N'Active'),
(8025, 3498, 595, 2, 127, 75000, N'Active'),
(8026, 3498, 595, 2, 128, 75000, N'Active'),
(8027, 3499, 595, 2, 184, 90000, N'Active'),
(8028, 3499, 595, 2, 185, 90000, N'Active'),
(8029, 3499, 595, 2, 186, 90000, N'Active'),
(8030, 3499, 595, 2, 187, 90000, N'Active'),
(8031, 3500, 596, 3, 233, 75000, N'Active'),
(8032, 3500, 596, 3, 234, 75000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 3 01/12/2026: 119 hoa don (1 huy), 272 ve, doanh thu 26.052.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(3501, 3, 49, '2026-12-01T08:04:15', 180000, N'Paid', N'Cash', 500000, 18, 0, NULL, NULL, NULL), -- suat 597 | Trại Giam Hạnh Phúc | 01/12 09:00 | Phòng 1 | J9 J10
(3502, 10, NULL, '2026-12-01T08:08:26', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 649 | Bò Sữa Bay | 02/12 19:30 | Phòng 2 | J7 J8
(3503, 3, NULL, '2026-12-01T08:20:38', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 641 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 15:30 | Phòng 4 | E4 E5 E6 E7
(3504, 10, 74, '2026-12-01T08:21:02', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 598 | Hexed: Thế Giới Phép Thuật | 01/12 09:00 | Phòng 2 | A5 A6
(3505, 3, 59, '2026-12-01T08:21:02', 150000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 631 | Ma Mút Con Vượt Kỷ Băng Hà | 02/12 11:15 | Phòng 2 | A7 A8
(3506, 3, NULL, '2026-12-01T08:21:56', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 603 | Ngày Con Còn Mẹ | 01/12 11:15 | Phòng 3 | D6 D7
(3507, 10, NULL, '2026-12-01T08:24:57', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 598 | Hexed: Thế Giới Phép Thuật | 01/12 09:00 | Phòng 2 | E7
(3508, 3, NULL, '2026-12-01T08:26:07', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 664 | Godzilla Trừ Không | 03/12 12:15 | Phòng 5 | G5 G6 G7
(3509, 10, NULL, '2026-12-01T08:33:56', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 600 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 09:15 | Phòng 4 | J3 J4 J5 J6
(3510, 10, 93, '2026-12-01T08:36:32', 375000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 647 | Điểm Mù | 02/12 18:30 | Phòng 3 | B1 B2 B3 B4 B5
(3511, 3, NULL, '2026-12-01T08:42:17', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 597 | Trại Giam Hạnh Phúc | 01/12 09:00 | Phòng 1 | B6 B7 B8
(3512, 3, NULL, '2026-12-01T08:43:28', 108000, N'Paid', N'Cash', 108000, 0, 0, NULL, NULL, NULL), -- suat 680 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 21:00 | Phòng 4 | E8
(3513, 3, NULL, '2026-12-01T08:45:12', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 612 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 15:30 | Phòng 4 | F8 F9
(3514, 10, NULL, '2026-12-01T08:49:37', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 608 | Bí Kíp Luyện Cướp | 01/12 13:30 | Phòng 3 | H7 H8
(3515, 10, NULL, '2026-12-01T08:50:27', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 600 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 09:15 | Phòng 4 | B6 B7
(3516, 10, NULL, '2026-12-01T09:16:35', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 601 | Kiến Lé Phiêu Lưu Ké | 01/12 09:30 | Phòng 3 | H6 H7 H8
(3517, 10, NULL, '2026-12-01T09:26:27', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 620 | Bò Sữa Bay | 01/12 19:30 | Phòng 2 | B7
(3518, 10, NULL, '2026-12-01T09:30:04', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 602 | Ma Mút Con Vượt Kỷ Băng Hà | 01/12 11:15 | Phòng 2 | E6 E7
(3519, 3, 98, '2026-12-01T09:31:42', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 649 | Bò Sữa Bay | 02/12 19:30 | Phòng 2 | D6 D7
(3520, 3, 4, '2026-12-01T09:45:13', 360000, N'Paid', N'Cash', 400000, 25, 0, NULL, NULL, NULL), -- suat 602 | Ma Mút Con Vượt Kỷ Băng Hà | 01/12 11:15 | Phòng 2 | D6 D7 D8 D9
(3521, 10, NULL, '2026-12-01T09:50:09', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 618 | Điểm Mù | 01/12 18:30 | Phòng 3 | B4 B5
(3522, 3, NULL, '2026-12-01T10:05:06', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 622 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 21:00 | Phòng 4 | D10 D11
(3523, 3, NULL, '2026-12-01T10:07:25', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 653 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 02/12 21:45 | Phòng 2 | F8 F9
(3524, 10, NULL, '2026-12-01T10:17:50', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 626 | Trại Giam Hạnh Phúc | 02/12 09:00 | Phòng 1 | E7 E8
(3525, 10, NULL, '2026-12-01T10:18:51', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 607 | Hexed: Thế Giới Phép Thuật | 01/12 12:45 | Phòng 2 | F6 F7
(3526, 10, NULL, '2026-12-01T10:21:52', 480000, N'Paid', N'Cash', 480000, 0, 0, NULL, NULL, NULL), -- suat 640 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 15:00 | Phòng 5 | A4 A5 A6 A7
(3527, 3, NULL, '2026-12-01T10:34:19', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 604 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 01/12 11:30 | Phòng 1 | F6 F7
(3528, 3, NULL, '2026-12-01T10:38:35', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 613 | Chị Chị Em Em 3 | 01/12 16:00 | Phòng 3 | D6 D7
(3529, 10, NULL, '2026-12-01T10:43:54', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 619 | Godzilla Trừ Không | 01/12 18:30 | Phòng 4 | C7
(3530, 10, 25, '2026-12-01T10:53:47', 360000, N'Paid', N'Cash', 500000, 25, 0, NULL, NULL, NULL), -- suat 604 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 01/12 11:30 | Phòng 1 | H5 H6 H7 H8
(3531, 3, NULL, '2026-12-01T10:57:14', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 611 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 15:00 | Phòng 5 | F6 F7
(3532, 3, NULL, '2026-12-01T11:00:01', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 609 | Trại Giam Hạnh Phúc | 01/12 13:45 | Phòng 1 | G6 G7 G8 G9
(3533, 10, 75, '2026-12-01T11:14:40', 180000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 627 | Hexed: Thế Giới Phép Thuật | 02/12 09:00 | Phòng 2 | G6 G7
(3534, 3, NULL, '2026-12-01T11:20:30', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 647 | Điểm Mù | 02/12 18:30 | Phòng 3 | D5
(3535, 3, 66, '2026-12-01T11:21:15', 360000, N'Paid', N'Cash', 360000, 36, 0, NULL, NULL, NULL), -- suat 613 | Chị Chị Em Em 3 | 01/12 16:00 | Phòng 3 | J5 J6 J7 J8
(3536, 3, 25, '2026-12-01T11:21:24', 216000, N'Paid', N'Cash', 250000, 15, 0, NULL, NULL, NULL), -- suat 612 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 15:30 | Phòng 4 | H4 H5
(3537, 3, NULL, '2026-12-01T11:21:28', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 638 | Trại Giam Hạnh Phúc | 02/12 13:45 | Phòng 1 | A6 A7 A8
(3538, 10, NULL, '2026-12-01T11:29:02', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 648 | Godzilla Trừ Không | 02/12 18:30 | Phòng 4 | H6 H7
(3539, 3, NULL, '2026-12-01T11:42:37', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 605 | Ramayana: Khởi Nguồn Một Huyền Thoại | 01/12 12:15 | Phòng 4 | D6 D7 D8
(3540, 10, NULL, '2026-12-01T11:43:32', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 651 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 21:00 | Phòng 4 | H5 H6
(3541, 10, 92, '2026-12-01T11:48:36', 288000, N'Paid', N'Cash', 290000, 20, 0, NULL, NULL, NULL), -- suat 652 | Godzilla Trừ Không | 02/12 21:15 | Phòng 5 | F5 F6
(3542, 3, 115, '2026-12-01T11:51:19', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 642 | Chị Chị Em Em 3 | 02/12 16:00 | Phòng 3 | J5 J6
(3543, 3, NULL, '2026-12-01T12:11:11', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 610 | Ngày Con Còn Mẹ | 01/12 15:00 | Phòng 2 | H6 H7
(3544, 10, NULL, '2026-12-01T12:20:28', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 607 | Hexed: Thế Giới Phép Thuật | 01/12 12:45 | Phòng 2 | J5 J6 J7 J8
(3545, 3, 34, '2026-12-01T12:27:06', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 609 | Trại Giam Hạnh Phúc | 01/12 13:45 | Phòng 1 | C7 C8
(3546, 10, NULL, '2026-12-01T12:36:56', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 616 | Dune: Hành Tinh Cát - Phần Hai | 01/12 18:00 | Phòng 5 | L11 L12
(3547, 10, NULL, '2026-12-01T12:44:08', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 656 | Hexed: Thế Giới Phép Thuật | 03/12 09:00 | Phòng 2 | H2 H3 H4 H5
(3548, 10, NULL, '2026-12-01T13:04:02', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 610 | Ngày Con Còn Mẹ | 01/12 15:00 | Phòng 2 | D6 D7
(3549, 10, NULL, '2026-12-01T13:05:02', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 675 | Trại Giam Hạnh Phúc | 03/12 18:30 | Phòng 1 | G3 G4 G5
(3550, 10, 76, '2026-12-01T13:18:56', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 612 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 15:30 | Phòng 4 | D6 D7
(3551, 3, NULL, '2026-12-01T13:21:46', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 618 | Điểm Mù | 01/12 18:30 | Phòng 3 | J3 J4
(3552, 3, 16, '2026-12-01T13:28:34', 75000, N'Paid', N'Cash', 75000, 3, 0, NULL, NULL, NULL), -- suat 614 | Mẹ Mìn: Giao Kèo Với Quỷ | 01/12 16:15 | Phòng 1 | C6
(3553, 3, NULL, '2026-12-01T13:29:08', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 639 | Ngày Con Còn Mẹ | 02/12 15:00 | Phòng 2 | A7 A8
(3554, 3, NULL, '2026-12-01T13:30:34', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 610 | Ngày Con Còn Mẹ | 01/12 15:00 | Phòng 2 | H8 H9
(3555, 3, 21, '2026-12-01T13:50:29', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 612 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 15:30 | Phòng 4 | H6 H7
(3556, 3, NULL, '2026-12-01T13:53:25', 240000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 611 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 15:00 | Phòng 5 | A6 A7
(3557, 3, NULL, '2026-12-01T13:56:15', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 611 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 15:00 | Phòng 5 | L3 L4
(3558, 10, NULL, '2026-12-01T14:01:59', 480000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 616 | Dune: Hành Tinh Cát - Phần Hai | 01/12 18:00 | Phòng 5 | A4 A5 A6 A7
(3559, 3, NULL, '2026-12-01T14:05:57', 324000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 622 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 21:00 | Phòng 4 | E5 E6 E7
(3560, 3, NULL, '2026-12-01T14:07:57', 240000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 611 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 15:00 | Phòng 5 | C9 C10
(3561, 3, NULL, '2026-12-01T14:11:00', 216000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 612 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 15:30 | Phòng 4 | F6 F7
(3562, 3, NULL, '2026-12-01T14:15:26', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 610 | Ngày Con Còn Mẹ | 01/12 15:00 | Phòng 2 | E7 E8
(3563, 3, NULL, '2026-12-01T14:15:55', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 617 | Trại Giam Hạnh Phúc | 01/12 18:30 | Phòng 1 | J1 J2 J3 J4
(3564, 10, NULL, '2026-12-01T14:17:34', 270000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 618 | Điểm Mù | 01/12 18:30 | Phòng 3 | D5 D6 D7
(3565, 3, 5, '2026-12-01T14:44:01', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 620 | Bò Sữa Bay | 01/12 19:30 | Phòng 2 | J11 J12
(3566, 4, NULL, '2026-12-01T15:01:16', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 618 | Điểm Mù | 01/12 18:30 | Phòng 3 | H8
(3567, 4, 72, '2026-12-01T15:09:13', 432000, N'Paid', N'Cash', 450000, 30, 0, NULL, NULL, NULL), -- suat 623 | Godzilla Trừ Không | 01/12 21:15 | Phòng 5 | E8 E9 E10
(3568, 4, 2, '2026-12-01T15:16:41', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 647 | Điểm Mù | 02/12 18:30 | Phòng 3 | D6 D7
(3569, 5, 42, '2026-12-01T15:39:50', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 658 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 09:15 | Phòng 4 | E7 E8
(3570, 4, 46, '2026-12-01T15:53:10', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 614 | Mẹ Mìn: Giao Kèo Với Quỷ | 01/12 16:15 | Phòng 1 | H6 H7
(3571, 5, NULL, '2026-12-01T15:59:24', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 631 | Ma Mút Con Vượt Kỷ Băng Hà | 02/12 11:15 | Phòng 2 | B5 B6
(3572, 4, NULL, '2026-12-01T16:13:41', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 615 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 01/12 17:15 | Phòng 2 | E6 E7
(3573, 4, NULL, '2026-12-01T16:21:59', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 682 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 03/12 21:45 | Phòng 2 | E9
(3574, 5, NULL, '2026-12-01T16:25:58', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 624 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 01/12 21:45 | Phòng 2 | D6
(3575, 4, NULL, '2026-12-01T16:28:29', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 621 | Mẹ Mìn: Giao Kèo Với Quỷ | 01/12 21:00 | Phòng 1 | D4 D5
(3576, 5, NULL, '2026-12-01T16:34:04', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 653 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 02/12 21:45 | Phòng 2 | J11 J12
(3577, 5, NULL, '2026-12-01T16:34:10', 144000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 616 | Dune: Hành Tinh Cát - Phần Hai | 01/12 18:00 | Phòng 5 | J6
(3578, 5, NULL, '2026-12-01T16:36:00', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 676 | Điểm Mù | 03/12 18:30 | Phòng 3 | E3 E4
(3579, 4, 120, '2026-12-01T16:40:18', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 618 | Điểm Mù | 01/12 18:30 | Phòng 3 | B6 B7
(3580, 4, 77, '2026-12-01T16:42:36', 648000, N'Paid', N'Transfer', NULL, 45, 0, NULL, NULL, NULL), -- suat 619 | Godzilla Trừ Không | 01/12 18:30 | Phòng 4 | G4 G5 G6 G7 G8 G9
(3581, 5, NULL, '2026-12-01T16:43:42', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 619 | Godzilla Trừ Không | 01/12 18:30 | Phòng 4 | J3 J4 J5 J6
(3582, 4, 95, '2026-12-01T16:46:32', 150000, N'Paid', N'Cash', 500000, 7, 0, NULL, NULL, NULL), -- suat 617 | Trại Giam Hạnh Phúc | 01/12 18:30 | Phòng 1 | B7 B8
(3583, 5, NULL, '2026-12-01T16:53:41', 288000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-12-01T17:15:10', 5), -- suat 616 | Dune: Hành Tinh Cát - Phần Hai | 01/12 18:00 | Phòng 5 | L3 L4
(3584, 4, NULL, '2026-12-01T17:01:11', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 634 | Ramayana: Khởi Nguồn Một Huyền Thoại | 02/12 12:15 | Phòng 4 | E6 E7
(3585, 4, NULL, '2026-12-01T17:03:57', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 648 | Godzilla Trừ Không | 02/12 18:30 | Phòng 4 | D10 D11
(3586, 5, NULL, '2026-12-01T17:05:08', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 651 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 21:00 | Phòng 4 | H9 H10
(3587, 4, NULL, '2026-12-01T17:07:51', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 615 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 01/12 17:15 | Phòng 2 | B8
(3588, 4, NULL, '2026-12-01T17:22:03', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 620 | Bò Sữa Bay | 01/12 19:30 | Phòng 2 | J1 J2
(3589, 4, NULL, '2026-12-01T17:25:33', 75000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 644 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 02/12 17:15 | Phòng 2 | C6
(3590, 5, 21, '2026-12-01T17:33:41', 180000, N'Paid', N'Cash', 180000, 18, 0, NULL, NULL, NULL), -- suat 620 | Bò Sữa Bay | 01/12 19:30 | Phòng 2 | J5 J6
(3591, 5, 93, '2026-12-01T17:39:42', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 620 | Bò Sữa Bay | 01/12 19:30 | Phòng 2 | H7
(3592, 4, NULL, '2026-12-01T17:42:13', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 622 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 21:00 | Phòng 4 | C5 C6
(3593, 5, 116, '2026-12-01T17:46:48', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 618 | Điểm Mù | 01/12 18:30 | Phòng 3 | B9 B10
(3594, 5, NULL, '2026-12-01T17:58:04', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 618 | Điểm Mù | 01/12 18:30 | Phòng 3 | D9 D10
(3595, 4, NULL, '2026-12-01T18:02:43', 216000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 622 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 21:00 | Phòng 4 | G6 G7
(3596, 4, 113, '2026-12-01T18:05:08', 360000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 619 | Godzilla Trừ Không | 01/12 18:30 | Phòng 4 | A4 A5 A6 A7
(3597, 5, NULL, '2026-12-01T18:10:45', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 647 | Điểm Mù | 02/12 18:30 | Phòng 3 | F6
(3598, 5, 46, '2026-12-01T18:13:06', 152000, N'Paid', N'Cash', 152000, 15, 28, NULL, NULL, NULL), -- suat 617 | Trại Giam Hạnh Phúc | 01/12 18:30 | Phòng 1 | J11 J12
(3599, 4, 25, '2026-12-01T18:16:56', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 672 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 16:15 | Phòng 1 | D6
(3600, 5, 94, '2026-12-01T18:21:39', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 618 | Điểm Mù | 01/12 18:30 | Phòng 3 | G5 G6
(3601, 4, NULL, '2026-12-01T18:34:27', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 620 | Bò Sữa Bay | 01/12 19:30 | Phòng 2 | G7
(3602, 5, NULL, '2026-12-01T18:35:27', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 620 | Bò Sữa Bay | 01/12 19:30 | Phòng 2 | F9 F10
(3603, 4, 2, '2026-12-01T18:35:51', 225000, N'Paid', N'Cash', 225000, 11, 0, NULL, NULL, NULL), -- suat 625 | Mẹ Mìn: Giao Kèo Với Quỷ | 01/12 21:45 | Phòng 3 | C4 C5 C6
(3604, 4, NULL, '2026-12-01T18:35:54', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 620 | Bò Sữa Bay | 01/12 19:30 | Phòng 2 | B8
(3605, 5, NULL, '2026-12-01T18:36:49', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 633 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 02/12 11:30 | Phòng 1 | E4 E5 E6 E7
(3606, 4, 46, '2026-12-01T18:45:19', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 620 | Bò Sữa Bay | 01/12 19:30 | Phòng 2 | F6 F7
(3607, 4, NULL, '2026-12-01T18:47:57', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 620 | Bò Sữa Bay | 01/12 19:30 | Phòng 2 | D6 D7 D8 D9
(3608, 5, NULL, '2026-12-01T18:59:16', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 624 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 01/12 21:45 | Phòng 2 | H6 H7
(3609, 5, NULL, '2026-12-01T19:06:38', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 644 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 02/12 17:15 | Phòng 2 | F6
(3610, 5, NULL, '2026-12-01T19:18:15', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 626 | Trại Giam Hạnh Phúc | 02/12 09:00 | Phòng 1 | E4
(3611, 5, NULL, '2026-12-01T19:45:57', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 624 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 01/12 21:45 | Phòng 2 | H4 H5
(3612, 4, NULL, '2026-12-01T19:46:35', 864000, N'Paid', N'Cash', 864000, 0, 0, NULL, NULL, NULL), -- suat 645 | Dune: Hành Tinh Cát - Phần Hai | 02/12 18:00 | Phòng 5 | F3 F4 F5 F6 F7 F8
(3613, 5, 108, '2026-12-01T20:09:26', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 624 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 01/12 21:45 | Phòng 2 | F9 F10 F11 F12
(3614, 5, 21, '2026-12-01T20:23:01', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 625 | Mẹ Mìn: Giao Kèo Với Quỷ | 01/12 21:45 | Phòng 3 | F6
(3615, 5, NULL, '2026-12-01T20:23:11', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 624 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 01/12 21:45 | Phòng 2 | F5
(3616, 5, 75, '2026-12-01T20:38:55', 300000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 621 | Mẹ Mìn: Giao Kèo Với Quỷ | 01/12 21:00 | Phòng 1 | B6 B7 B8 B9
(3617, 4, NULL, '2026-12-01T20:52:06', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 622 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 01/12 21:00 | Phòng 4 | D8
(3618, 4, 106, '2026-12-01T21:20:14', 145000, N'Paid', N'Transfer', NULL, 7, 35, NULL, NULL, NULL), -- suat 629 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 09:15 | Phòng 4 | B6 B7
(3619, 4, NULL, '2026-12-01T21:31:12', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL); -- suat 624 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 01/12 21:45 | Phòng 2 | F6 F7 F8
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(8033, 3501, 597, 1, 105, 90000, N'Active'),
(8034, 3501, 597, 1, 106, 90000, N'Active'),
(8035, 3502, 649, 2, 211, 90000, N'Active'),
(8036, 3502, 649, 2, 212, 90000, N'Active'),
(8037, 3503, 641, 4, 376, 108000, N'Active'),
(8038, 3503, 641, 4, 377, 108000, N'Active'),
(8039, 3503, 641, 4, 378, 108000, N'Active'),
(8040, 3503, 641, 4, 379, 108000, N'Active'),
(8041, 3504, 598, 2, 113, 75000, N'Active'),
(8042, 3504, 598, 2, 114, 75000, N'Active'),
(8043, 3505, 631, 2, 115, 75000, N'Active'),
(8044, 3505, 631, 2, 116, 75000, N'Active'),
(8045, 3506, 603, 3, 258, 90000, N'Active'),
(8046, 3506, 603, 3, 259, 90000, N'Active'),
(8047, 3507, 598, 2, 163, 90000, N'Active'),
(8048, 3508, 664, 5, 509, 144000, N'Active'),
(8049, 3508, 664, 5, 510, 144000, N'Active'),
(8050, 3508, 664, 5, 511, 144000, N'Active'),
(8051, 3509, 600, 4, 423, 108000, N'Active'),
(8052, 3509, 600, 4, 424, 108000, N'Active'),
(8053, 3509, 600, 4, 425, 108000, N'Active'),
(8054, 3509, 600, 4, 426, 108000, N'Active'),
(8055, 3510, 647, 3, 229, 75000, N'Active'),
(8056, 3510, 647, 3, 230, 75000, N'Active'),
(8057, 3510, 647, 3, 231, 75000, N'Active'),
(8058, 3510, 647, 3, 232, 75000, N'Active'),
(8059, 3510, 647, 3, 233, 75000, N'Active'),
(8060, 3511, 597, 1, 18, 75000, N'Active'),
(8061, 3511, 597, 1, 19, 75000, N'Active'),
(8062, 3511, 597, 1, 20, 75000, N'Active'),
(8063, 3512, 680, 4, 380, 108000, N'Active'),
(8064, 3513, 612, 4, 392, 108000, N'Active'),
(8065, 3513, 612, 4, 393, 108000, N'Active'),
(8066, 3514, 608, 3, 307, 90000, N'Active'),
(8067, 3514, 608, 3, 308, 90000, N'Active'),
(8068, 3515, 600, 4, 342, 90000, N'Active'),
(8069, 3515, 600, 4, 343, 90000, N'Active'),
(8070, 3516, 601, 3, 306, 90000, N'Active'),
(8071, 3516, 601, 3, 307, 90000, N'Active'),
(8072, 3516, 601, 3, 308, 90000, N'Active'),
(8073, 3517, 620, 2, 127, 75000, N'Active'),
(8074, 3518, 602, 2, 162, 90000, N'Active'),
(8075, 3518, 602, 2, 163, 90000, N'Active'),
(8076, 3519, 649, 2, 150, 90000, N'Active'),
(8077, 3519, 649, 2, 151, 90000, N'Active'),
(8078, 3520, 602, 2, 150, 90000, N'Active'),
(8079, 3520, 602, 2, 151, 90000, N'Active'),
(8080, 3520, 602, 2, 152, 90000, N'Active'),
(8081, 3520, 602, 2, 153, 90000, N'Active'),
(8082, 3521, 618, 3, 232, 75000, N'Active'),
(8083, 3521, 618, 3, 233, 75000, N'Active'),
(8084, 3522, 622, 4, 370, 108000, N'Active'),
(8085, 3522, 622, 4, 371, 108000, N'Active'),
(8086, 3523, 653, 2, 176, 90000, N'Active'),
(8087, 3523, 653, 2, 177, 90000, N'Active'),
(8088, 3524, 626, 1, 55, 90000, N'Active'),
(8089, 3524, 626, 1, 56, 90000, N'Active'),
(8090, 3525, 607, 2, 174, 90000, N'Active'),
(8091, 3525, 607, 2, 175, 90000, N'Active'),
(8092, 3526, 640, 5, 436, 120000, N'Active'),
(8093, 3526, 640, 5, 437, 120000, N'Active'),
(8094, 3526, 640, 5, 438, 120000, N'Active'),
(8095, 3526, 640, 5, 439, 120000, N'Active'),
(8096, 3527, 604, 1, 66, 90000, N'Active'),
(8097, 3527, 604, 1, 67, 90000, N'Active'),
(8098, 3528, 613, 3, 258, 90000, N'Active'),
(8099, 3528, 613, 3, 259, 90000, N'Active'),
(8100, 3529, 619, 4, 355, 90000, N'Active'),
(8101, 3530, 604, 1, 89, 90000, N'Active'),
(8102, 3530, 604, 1, 90, 90000, N'Active'),
(8103, 3530, 604, 1, 91, 90000, N'Active'),
(8104, 3530, 604, 1, 92, 90000, N'Active'),
(8105, 3531, 611, 5, 498, 144000, N'Active'),
(8106, 3531, 611, 5, 499, 144000, N'Active'),
(8107, 3532, 609, 1, 78, 90000, N'Active'),
(8108, 3532, 609, 1, 79, 90000, N'Active'),
(8109, 3532, 609, 1, 80, 90000, N'Active'),
(8110, 3532, 609, 1, 81, 90000, N'Active'),
(8111, 3533, 627, 2, 186, 90000, N'Active'),
(8112, 3533, 627, 2, 187, 90000, N'Active'),
(8113, 3534, 647, 3, 257, 90000, N'Active'),
(8114, 3535, 613, 3, 317, 90000, N'Active'),
(8115, 3535, 613, 3, 318, 90000, N'Active'),
(8116, 3535, 613, 3, 319, 90000, N'Active'),
(8117, 3535, 613, 3, 320, 90000, N'Active'),
(8118, 3536, 612, 4, 412, 108000, N'Active'),
(8119, 3536, 612, 4, 413, 108000, N'Active'),
(8120, 3537, 638, 1, 6, 75000, N'Active'),
(8121, 3537, 638, 1, 7, 75000, N'Active'),
(8122, 3537, 638, 1, 8, 75000, N'Active'),
(8123, 3538, 648, 4, 414, 108000, N'Active'),
(8124, 3538, 648, 4, 415, 108000, N'Active'),
(8125, 3539, 605, 4, 366, 108000, N'Active'),
(8126, 3539, 605, 4, 367, 108000, N'Active'),
(8127, 3539, 605, 4, 368, 108000, N'Active'),
(8128, 3540, 651, 4, 413, 108000, N'Active'),
(8129, 3540, 651, 4, 414, 108000, N'Active'),
(8130, 3541, 652, 5, 497, 144000, N'Active'),
(8131, 3541, 652, 5, 498, 144000, N'Active'),
(8132, 3542, 642, 3, 317, 90000, N'Active'),
(8133, 3542, 642, 3, 318, 90000, N'Active'),
(8134, 3543, 610, 2, 198, 90000, N'Active'),
(8135, 3543, 610, 2, 199, 90000, N'Active'),
(8136, 3544, 607, 2, 209, 90000, N'Active'),
(8137, 3544, 607, 2, 210, 90000, N'Active'),
(8138, 3544, 607, 2, 211, 90000, N'Active'),
(8139, 3544, 607, 2, 212, 90000, N'Active'),
(8140, 3545, 609, 1, 31, 75000, N'Active'),
(8141, 3545, 609, 1, 32, 75000, N'Active'),
(8142, 3546, 616, 5, 563, 144000, N'Active'),
(8143, 3546, 616, 5, 564, 144000, N'Active'),
(8144, 3547, 656, 2, 194, 90000, N'Active'),
(8145, 3547, 656, 2, 195, 90000, N'Active'),
(8146, 3547, 656, 2, 196, 90000, N'Active'),
(8147, 3547, 656, 2, 197, 90000, N'Active'),
(8148, 3548, 610, 2, 150, 90000, N'Active'),
(8149, 3548, 610, 2, 151, 90000, N'Active'),
(8150, 3549, 675, 1, 75, 90000, N'Active'),
(8151, 3549, 675, 1, 76, 90000, N'Active'),
(8152, 3549, 675, 1, 77, 90000, N'Active'),
(8153, 3550, 612, 4, 366, 108000, N'Active'),
(8154, 3550, 612, 4, 367, 108000, N'Active'),
(8155, 3551, 618, 3, 315, 90000, N'Active'),
(8156, 3551, 618, 3, 316, 90000, N'Active'),
(8157, 3552, 614, 1, 30, 75000, N'Active'),
(8158, 3553, 639, 2, 115, 75000, N'Active'),
(8159, 3553, 639, 2, 116, 75000, N'Active'),
(8160, 3554, 610, 2, 200, 90000, N'Active'),
(8161, 3554, 610, 2, 201, 90000, N'Active'),
(8162, 3555, 612, 4, 414, 108000, N'Active'),
(8163, 3555, 612, 4, 415, 108000, N'Active'),
(8164, 3556, 611, 5, 438, 120000, N'Active'),
(8165, 3556, 611, 5, 439, 120000, N'Active'),
(8166, 3557, 611, 5, 555, 144000, N'Active'),
(8167, 3557, 611, 5, 556, 144000, N'Active'),
(8168, 3558, 616, 5, 436, 120000, N'Active'),
(8169, 3558, 616, 5, 437, 120000, N'Active'),
(8170, 3558, 616, 5, 438, 120000, N'Active'),
(8171, 3558, 616, 5, 439, 120000, N'Active'),
(8172, 3559, 622, 4, 377, 108000, N'Active'),
(8173, 3559, 622, 4, 378, 108000, N'Active'),
(8174, 3559, 622, 4, 379, 108000, N'Active'),
(8175, 3560, 611, 5, 465, 120000, N'Active'),
(8176, 3560, 611, 5, 466, 120000, N'Active'),
(8177, 3561, 612, 4, 390, 108000, N'Active'),
(8178, 3561, 612, 4, 391, 108000, N'Active'),
(8179, 3562, 610, 2, 163, 90000, N'Active'),
(8180, 3562, 610, 2, 164, 90000, N'Active'),
(8181, 3563, 617, 1, 97, 90000, N'Active'),
(8182, 3563, 617, 1, 98, 90000, N'Active'),
(8183, 3563, 617, 1, 99, 90000, N'Active'),
(8184, 3563, 617, 1, 100, 90000, N'Active'),
(8185, 3564, 618, 3, 257, 90000, N'Active'),
(8186, 3564, 618, 3, 258, 90000, N'Active'),
(8187, 3564, 618, 3, 259, 90000, N'Active'),
(8188, 3565, 620, 2, 215, 90000, N'Active'),
(8189, 3565, 620, 2, 216, 90000, N'Active'),
(8190, 3566, 618, 3, 308, 90000, N'Active'),
(8191, 3567, 623, 5, 488, 144000, N'Active'),
(8192, 3567, 623, 5, 489, 144000, N'Active'),
(8193, 3567, 623, 5, 490, 144000, N'Active'),
(8194, 3568, 647, 3, 258, 90000, N'Active'),
(8195, 3568, 647, 3, 259, 90000, N'Active'),
(8196, 3569, 658, 4, 379, 108000, N'Active'),
(8197, 3569, 658, 4, 380, 108000, N'Active'),
(8198, 3570, 614, 1, 90, 90000, N'Active'),
(8199, 3570, 614, 1, 91, 90000, N'Active'),
(8200, 3571, 631, 2, 125, 75000, N'Active'),
(8201, 3571, 631, 2, 126, 75000, N'Active'),
(8202, 3572, 615, 2, 162, 90000, N'Active'),
(8203, 3572, 615, 2, 163, 90000, N'Active'),
(8204, 3573, 682, 2, 165, 90000, N'Active'),
(8205, 3574, 624, 2, 150, 90000, N'Active'),
(8206, 3575, 621, 1, 40, 90000, N'Active'),
(8207, 3575, 621, 1, 41, 90000, N'Active'),
(8208, 3576, 653, 2, 215, 90000, N'Active'),
(8209, 3576, 653, 2, 216, 90000, N'Active'),
(8210, 3577, 616, 5, 534, 144000, N'Active'),
(8211, 3578, 676, 3, 267, 90000, N'Active'),
(8212, 3578, 676, 3, 268, 90000, N'Active'),
(8213, 3579, 618, 3, 234, 75000, N'Active'),
(8214, 3579, 618, 3, 235, 75000, N'Active'),
(8215, 3580, 619, 4, 400, 108000, N'Active'),
(8216, 3580, 619, 4, 401, 108000, N'Active'),
(8217, 3580, 619, 4, 402, 108000, N'Active'),
(8218, 3580, 619, 4, 403, 108000, N'Active'),
(8219, 3580, 619, 4, 404, 108000, N'Active'),
(8220, 3580, 619, 4, 405, 108000, N'Active'),
(8221, 3581, 619, 4, 423, 108000, N'Active'),
(8222, 3581, 619, 4, 424, 108000, N'Active'),
(8223, 3581, 619, 4, 425, 108000, N'Active'),
(8224, 3581, 619, 4, 426, 108000, N'Active'),
(8225, 3582, 617, 1, 19, 75000, N'Active'),
(8226, 3582, 617, 1, 20, 75000, N'Active'),
(8227, 3583, 616, 5, 555, 144000, N'Cancelled'),
(8228, 3583, 616, 5, 556, 144000, N'Cancelled'),
(8229, 3584, 634, 4, 378, 108000, N'Active'),
(8230, 3584, 634, 4, 379, 108000, N'Active'),
(8231, 3585, 648, 4, 370, 108000, N'Active'),
(8232, 3585, 648, 4, 371, 108000, N'Active'),
(8233, 3586, 651, 4, 417, 108000, N'Active'),
(8234, 3586, 651, 4, 418, 108000, N'Active'),
(8235, 3587, 615, 2, 128, 75000, N'Active'),
(8236, 3588, 620, 2, 205, 90000, N'Active'),
(8237, 3588, 620, 2, 206, 90000, N'Active'),
(8238, 3589, 644, 2, 138, 75000, N'Active'),
(8239, 3590, 620, 2, 209, 90000, N'Active'),
(8240, 3590, 620, 2, 210, 90000, N'Active'),
(8241, 3591, 620, 2, 199, 90000, N'Active'),
(8242, 3592, 622, 4, 353, 90000, N'Active'),
(8243, 3592, 622, 4, 354, 90000, N'Active'),
(8244, 3593, 618, 3, 237, 75000, N'Active'),
(8245, 3593, 618, 3, 238, 75000, N'Active'),
(8246, 3594, 618, 3, 261, 90000, N'Active'),
(8247, 3594, 618, 3, 262, 90000, N'Active'),
(8248, 3595, 622, 4, 402, 108000, N'Active'),
(8249, 3595, 622, 4, 403, 108000, N'Active'),
(8250, 3596, 619, 4, 328, 90000, N'Active'),
(8251, 3596, 619, 4, 329, 90000, N'Active'),
(8252, 3596, 619, 4, 330, 90000, N'Active'),
(8253, 3596, 619, 4, 331, 90000, N'Active'),
(8254, 3597, 647, 3, 282, 90000, N'Active'),
(8255, 3598, 617, 1, 107, 90000, N'Active'),
(8256, 3598, 617, 1, 108, 90000, N'Active'),
(8257, 3599, 672, 1, 42, 90000, N'Active'),
(8258, 3600, 618, 3, 293, 90000, N'Active'),
(8259, 3600, 618, 3, 294, 90000, N'Active'),
(8260, 3601, 620, 2, 187, 90000, N'Active'),
(8261, 3602, 620, 2, 177, 90000, N'Active'),
(8262, 3602, 620, 2, 178, 90000, N'Active'),
(8263, 3603, 625, 3, 244, 75000, N'Active'),
(8264, 3603, 625, 3, 245, 75000, N'Active'),
(8265, 3603, 625, 3, 246, 75000, N'Active'),
(8266, 3604, 620, 2, 128, 75000, N'Active'),
(8267, 3605, 633, 1, 52, 90000, N'Active'),
(8268, 3605, 633, 1, 53, 90000, N'Active'),
(8269, 3605, 633, 1, 54, 90000, N'Active'),
(8270, 3605, 633, 1, 55, 90000, N'Active'),
(8271, 3606, 620, 2, 174, 90000, N'Active'),
(8272, 3606, 620, 2, 175, 90000, N'Active'),
(8273, 3607, 620, 2, 150, 90000, N'Active'),
(8274, 3607, 620, 2, 151, 90000, N'Active'),
(8275, 3607, 620, 2, 152, 90000, N'Active'),
(8276, 3607, 620, 2, 153, 90000, N'Active'),
(8277, 3608, 624, 2, 198, 90000, N'Active'),
(8278, 3608, 624, 2, 199, 90000, N'Active'),
(8279, 3609, 644, 2, 174, 90000, N'Active'),
(8280, 3610, 626, 1, 52, 90000, N'Active'),
(8281, 3611, 624, 2, 196, 90000, N'Active'),
(8282, 3611, 624, 2, 197, 90000, N'Active'),
(8283, 3612, 645, 5, 495, 144000, N'Active'),
(8284, 3612, 645, 5, 496, 144000, N'Active'),
(8285, 3612, 645, 5, 497, 144000, N'Active'),
(8286, 3612, 645, 5, 498, 144000, N'Active'),
(8287, 3612, 645, 5, 499, 144000, N'Active'),
(8288, 3612, 645, 5, 500, 144000, N'Active'),
(8289, 3613, 624, 2, 177, 90000, N'Active'),
(8290, 3613, 624, 2, 178, 90000, N'Active'),
(8291, 3613, 624, 2, 179, 90000, N'Active'),
(8292, 3613, 624, 2, 180, 90000, N'Active'),
(8293, 3614, 625, 3, 282, 90000, N'Active'),
(8294, 3615, 624, 2, 173, 90000, N'Active'),
(8295, 3616, 621, 1, 18, 75000, N'Active'),
(8296, 3616, 621, 1, 19, 75000, N'Active'),
(8297, 3616, 621, 1, 20, 75000, N'Active'),
(8298, 3616, 621, 1, 21, 75000, N'Active'),
(8299, 3617, 622, 4, 368, 108000, N'Active'),
(8300, 3618, 629, 4, 342, 90000, N'Active'),
(8301, 3618, 629, 4, 343, 90000, N'Active'),
(8302, 3619, 624, 2, 174, 90000, N'Active'),
(8303, 3619, 624, 2, 175, 90000, N'Active'),
(8304, 3619, 624, 2, 176, 90000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 4 02/12/2026: 147 hoa don (4 huy), 325 ve, doanh thu 31.479.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(3620, 6, 106, '2026-12-02T08:02:01', 360000, N'Paid', N'Transfer', NULL, 36, 0, NULL, NULL, NULL), -- suat 630 | Kiến Lé Phiêu Lưu Ké | 02/12 09:30 | Phòng 3 | J5 J6 J7 J8
(3621, 5, NULL, '2026-12-02T08:04:13', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 636 | Hexed: Thế Giới Phép Thuật | 02/12 12:45 | Phòng 2 | G7 G8
(3622, 5, NULL, '2026-12-02T08:15:08', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 681 | Godzilla Trừ Không | 03/12 21:15 | Phòng 5 | E9 E10
(3623, 6, NULL, '2026-12-02T08:15:46', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 655 | Trại Giam Hạnh Phúc | 03/12 09:00 | Phòng 1 | D6 D7 D8
(3624, 5, NULL, '2026-12-02T08:20:40', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 629 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 09:15 | Phòng 4 | F7 F8
(3625, 5, 19, '2026-12-02T08:27:27', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 626 | Trại Giam Hạnh Phúc | 02/12 09:00 | Phòng 1 | F5 F6
(3626, 5, 70, '2026-12-02T08:30:51', 216000, N'Paid', N'Cash', 500000, 15, 0, NULL, NULL, NULL), -- suat 680 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 21:00 | Phòng 4 | G5 G6
(3627, 5, NULL, '2026-12-02T08:32:52', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 647 | Điểm Mù | 02/12 18:30 | Phòng 3 | J1 J2
(3628, 5, NULL, '2026-12-02T08:33:06', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 628 | Dune: Hành Tinh Cát - Phần Hai | 02/12 09:00 | Phòng 5 | G6 G7 G8
(3629, 6, 30, '2026-12-02T08:34:01', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 636 | Hexed: Thế Giới Phép Thuật | 02/12 12:45 | Phòng 2 | F6 F7
(3630, 6, NULL, '2026-12-02T08:46:15', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | F6 F7
(3631, 5, NULL, '2026-12-02T08:47:10', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 644 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 02/12 17:15 | Phòng 2 | D5 D6
(3632, 6, NULL, '2026-12-02T09:00:22', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 631 | Ma Mút Con Vượt Kỷ Băng Hà | 02/12 11:15 | Phòng 2 | J9 J10
(3633, 6, 58, '2026-12-02T09:03:05', 180000, N'Paid', N'Cash', 200000, 18, 0, NULL, NULL, NULL), -- suat 637 | Bí Kíp Luyện Cướp | 02/12 13:30 | Phòng 3 | J1 J2
(3634, 5, NULL, '2026-12-02T09:20:12', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 636 | Hexed: Thế Giới Phép Thuật | 02/12 12:45 | Phòng 2 | F3 F4 F5
(3635, 6, NULL, '2026-12-02T09:30:20', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 637 | Bí Kíp Luyện Cướp | 02/12 13:30 | Phòng 3 | E5 E6
(3636, 5, NULL, '2026-12-02T09:37:44', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 671 | Chị Chị Em Em 3 | 03/12 16:00 | Phòng 3 | D5 D6
(3637, 6, 19, '2026-12-02T10:09:39', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 632 | Ngày Con Còn Mẹ | 02/12 11:15 | Phòng 3 | G9 G10 G11
(3638, 6, NULL, '2026-12-02T10:18:28', 120000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 635 | Godzilla Trừ Không | 02/12 12:15 | Phòng 5 | B7
(3639, 5, NULL, '2026-12-02T10:19:24', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 639 | Ngày Con Còn Mẹ | 02/12 15:00 | Phòng 2 | D5 D6
(3640, 6, 80, '2026-12-02T10:31:51', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 707 | Bò Sữa Bay | 04/12 19:30 | Phòng 2 | H5 H6
(3641, 5, NULL, '2026-12-02T10:41:42', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 634 | Ramayana: Khởi Nguồn Một Huyền Thoại | 02/12 12:15 | Phòng 4 | H5 H6
(3642, 5, 21, '2026-12-02T10:41:53', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 685 | Hexed: Thế Giới Phép Thuật | 04/12 09:00 | Phòng 2 | H6 H7
(3643, 6, NULL, '2026-12-02T10:44:59', 216000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 634 | Ramayana: Khởi Nguồn Một Huyền Thoại | 02/12 12:15 | Phòng 4 | H8 H9
(3644, 6, 73, '2026-12-02T10:50:58', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 636 | Hexed: Thế Giới Phép Thuật | 02/12 12:45 | Phòng 2 | E6
(3645, 6, NULL, '2026-12-02T11:00:32', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 635 | Godzilla Trừ Không | 02/12 12:15 | Phòng 5 | J8
(3646, 5, 87, '2026-12-02T11:01:10', 333000, N'Paid', N'Cash', 350000, 33, 27, NULL, NULL, NULL), -- suat 632 | Ngày Con Còn Mẹ | 02/12 11:15 | Phòng 3 | J7 J8 J9 J10
(3647, 5, 25, '2026-12-02T11:03:09', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 644 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 02/12 17:15 | Phòng 2 | G9
(3648, 6, 55, '2026-12-02T11:10:03', 144000, N'Paid', N'Card', NULL, 10, 0, NULL, NULL, NULL), -- suat 635 | Godzilla Trừ Không | 02/12 12:15 | Phòng 5 | H5
(3649, 6, NULL, '2026-12-02T11:13:40', 144000, N'Cancelled', N'Cash', 500000, 0, 0, N'Sự cố phòng chiếu', '2026-12-02T12:22:15', 1), -- suat 681 | Godzilla Trừ Không | 03/12 21:15 | Phòng 5 | J6
(3650, 6, NULL, '2026-12-02T11:14:28', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 646 | Trại Giam Hạnh Phúc | 02/12 18:30 | Phòng 1 | D5 D6 D7
(3651, 6, NULL, '2026-12-02T11:15:39', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 634 | Ramayana: Khởi Nguồn Một Huyền Thoại | 02/12 12:15 | Phòng 4 | A8
(3652, 5, NULL, '2026-12-02T11:29:40', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 635 | Godzilla Trừ Không | 02/12 12:15 | Phòng 5 | G7
(3653, 5, NULL, '2026-12-02T11:40:28', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 658 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 09:15 | Phòng 4 | H6
(3654, 6, NULL, '2026-12-02T11:48:14', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 637 | Bí Kíp Luyện Cướp | 02/12 13:30 | Phòng 3 | G8 G9
(3655, 6, NULL, '2026-12-02T11:53:45', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 640 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 15:00 | Phòng 5 | G4 G5
(3656, 6, NULL, '2026-12-02T11:58:10', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 640 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 15:00 | Phòng 5 | F6 F7
(3657, 6, NULL, '2026-12-02T12:08:25', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 637 | Bí Kíp Luyện Cướp | 02/12 13:30 | Phòng 3 | G6 G7
(3658, 6, NULL, '2026-12-02T12:17:33', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 672 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 16:15 | Phòng 1 | H4
(3659, 5, 42, '2026-12-02T12:49:13', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 649 | Bò Sữa Bay | 02/12 19:30 | Phòng 2 | H6
(3660, 5, NULL, '2026-12-02T12:57:52', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | D5
(3661, 6, NULL, '2026-12-02T12:58:13', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 639 | Ngày Con Còn Mẹ | 02/12 15:00 | Phòng 2 | F5 F6 F7
(3662, 6, NULL, '2026-12-02T12:59:25', 240000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 645 | Dune: Hành Tinh Cát - Phần Hai | 02/12 18:00 | Phòng 5 | C6 C7
(3663, 5, NULL, '2026-12-02T13:00:05', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 638 | Trại Giam Hạnh Phúc | 02/12 13:45 | Phòng 1 | E6 E7
(3664, 5, NULL, '2026-12-02T13:03:01', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 669 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 15:00 | Phòng 5 | E5 E6 E7
(3665, 6, 42, '2026-12-02T13:04:33', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 678 | Bò Sữa Bay | 03/12 19:30 | Phòng 2 | E8 E9
(3666, 5, 8, '2026-12-02T13:15:40', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 638 | Trại Giam Hạnh Phúc | 02/12 13:45 | Phòng 1 | D6 D7
(3667, 5, NULL, '2026-12-02T13:16:23', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 637 | Bí Kíp Luyện Cướp | 02/12 13:30 | Phòng 3 | C7 C8 C9
(3668, 5, NULL, '2026-12-02T13:26:27', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | D3 D4
(3669, 6, 30, '2026-12-02T13:31:11', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 642 | Chị Chị Em Em 3 | 02/12 16:00 | Phòng 3 | G7 G8
(3670, 6, NULL, '2026-12-02T13:38:55', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 668 | Ngày Con Còn Mẹ | 03/12 15:00 | Phòng 2 | H4 H5 H6
(3671, 6, 93, '2026-12-02T13:40:42', 270000, N'Cancelled', N'Transfer', NULL, 18, 0, N'Khách đổi ý', '2026-12-02T14:20:40', 6), -- suat 711 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 2 | H5 H6 H7
(3672, 6, NULL, '2026-12-02T13:49:47', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 640 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 15:00 | Phòng 5 | H6 H7
(3673, 5, NULL, '2026-12-02T13:51:49', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 640 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 15:00 | Phòng 5 | E7
(3674, 5, NULL, '2026-12-02T14:02:20', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 642 | Chị Chị Em Em 3 | 02/12 16:00 | Phòng 3 | H5 H6 H7
(3675, 6, 90, '2026-12-02T14:07:25', 360000, N'Paid', N'Transfer', NULL, 36, 0, NULL, NULL, NULL), -- suat 643 | Mẹ Mìn: Giao Kèo Với Quỷ | 02/12 16:15 | Phòng 1 | J3 J4 J5 J6
(3676, 5, 106, '2026-12-02T14:13:43', 150000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 639 | Ngày Con Còn Mẹ | 02/12 15:00 | Phòng 2 | A5 A6
(3677, 5, NULL, '2026-12-02T14:14:51', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 659 | Kiến Lé Phiêu Lưu Ké | 03/12 09:30 | Phòng 3 | E6 E7
(3678, 6, 53, '2026-12-02T14:15:32', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 639 | Ngày Con Còn Mẹ | 02/12 15:00 | Phòng 2 | D7 D8
(3679, 6, 21, '2026-12-02T14:22:15', 288000, N'Paid', N'Cash', 288000, 20, 0, NULL, NULL, NULL), -- suat 640 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 15:00 | Phòng 5 | K7 K8
(3680, 6, 66, '2026-12-02T14:29:57', 150000, N'Paid', N'Cash', 500000, 7, 0, NULL, NULL, NULL), -- suat 644 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 02/12 17:15 | Phòng 2 | C8 C9
(3681, 6, NULL, '2026-12-02T14:34:25', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 682 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 03/12 21:45 | Phòng 2 | H6 H7
(3682, 6, NULL, '2026-12-02T14:38:21', 108000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 641 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 15:30 | Phòng 4 | F6
(3683, 5, NULL, '2026-12-02T14:45:54', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 645 | Dune: Hành Tinh Cát - Phần Hai | 02/12 18:00 | Phòng 5 | H6 H7 H8
(3684, 5, 93, '2026-12-02T14:45:58', 216000, N'Paid', N'Cash', 216000, 15, 0, NULL, NULL, NULL), -- suat 648 | Godzilla Trừ Không | 02/12 18:30 | Phòng 4 | D2 D3
(3685, 6, 25, '2026-12-02T14:50:05', 288000, N'Paid', N'Cash', 288000, 20, 0, NULL, NULL, NULL), -- suat 669 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 15:00 | Phòng 5 | H6 H7
(3686, 5, NULL, '2026-12-02T14:53:04', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 641 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 15:30 | Phòng 4 | G6 G7 G8
(3687, 6, NULL, '2026-12-02T14:54:35', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 657 | Dune: Hành Tinh Cát - Phần Hai | 03/12 09:00 | Phòng 5 | G4 G5
(3688, 6, NULL, '2026-12-02T14:59:09', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 658 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 09:15 | Phòng 4 | G7 G8
(3689, 8, 69, '2026-12-02T15:00:04', 300000, N'Cancelled', N'Transfer', NULL, 15, 0, N'Khách đổi ý', '2026-12-02T16:11:08', 8), -- suat 647 | Điểm Mù | 02/12 18:30 | Phòng 3 | B6 B7 B8 B9
(3690, 8, 2, '2026-12-02T15:04:38', 576000, N'Paid', N'Transfer', NULL, 40, 0, NULL, NULL, NULL), -- suat 657 | Dune: Hành Tinh Cát - Phần Hai | 03/12 09:00 | Phòng 5 | G6 G7 G8 G9
(3691, 7, 94, '2026-12-02T15:07:07', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 646 | Trại Giam Hạnh Phúc | 02/12 18:30 | Phòng 1 | J11 J12
(3692, 7, NULL, '2026-12-02T15:10:55', 75000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 655 | Trại Giam Hạnh Phúc | 03/12 09:00 | Phòng 1 | B6
(3693, 8, NULL, '2026-12-02T15:18:24', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 644 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 02/12 17:15 | Phòng 2 | G7 G8
(3694, 7, NULL, '2026-12-02T15:21:42', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 711 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 2 | B3 B4 B5
(3695, 7, 19, '2026-12-02T15:34:38', 270000, N'Paid', N'Cash', 500000, 18, 0, NULL, NULL, NULL), -- suat 654 | Mẹ Mìn: Giao Kèo Với Quỷ | 02/12 21:45 | Phòng 3 | F6 F7 F8
(3696, 8, NULL, '2026-12-02T15:41:55', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 659 | Kiến Lé Phiêu Lưu Ké | 03/12 09:30 | Phòng 3 | H6 H7
(3697, 8, NULL, '2026-12-02T15:42:38', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 682 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 03/12 21:45 | Phòng 2 | F5 F6 F7
(3698, 7, NULL, '2026-12-02T15:43:44', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 642 | Chị Chị Em Em 3 | 02/12 16:00 | Phòng 3 | E5 E6 E7
(3699, 7, NULL, '2026-12-02T15:57:05', 90000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 644 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 02/12 17:15 | Phòng 2 | F7
(3700, 8, NULL, '2026-12-02T16:05:59', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 707 | Bò Sữa Bay | 04/12 19:30 | Phòng 2 | E6
(3701, 8, 69, '2026-12-02T16:07:11', 120000, N'Paid', N'Cash', 200000, 6, 0, NULL, NULL, NULL), -- suat 645 | Dune: Hành Tinh Cát - Phần Hai | 02/12 18:00 | Phòng 5 | C8
(3702, 8, NULL, '2026-12-02T16:15:42', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 649 | Bò Sữa Bay | 02/12 19:30 | Phòng 2 | E7
(3703, 8, NULL, '2026-12-02T16:16:14', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 651 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 21:00 | Phòng 4 | F6 F7
(3704, 7, NULL, '2026-12-02T16:23:56', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 697 | Ngày Con Còn Mẹ | 04/12 15:00 | Phòng 2 | G9 G10
(3705, 7, NULL, '2026-12-02T16:27:41', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | A7 A8
(3706, 8, 28, '2026-12-02T16:32:47', 576000, N'Paid', N'Cash', 600000, 40, 0, NULL, NULL, NULL), -- suat 645 | Dune: Hành Tinh Cát - Phần Hai | 02/12 18:00 | Phòng 5 | E9 E10 E11 E12
(3707, 7, 49, '2026-12-02T16:33:50', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 676 | Điểm Mù | 03/12 18:30 | Phòng 3 | E6 E7
(3708, 8, NULL, '2026-12-02T16:38:24', 576000, N'Paid', N'Cash', 576000, 0, 0, NULL, NULL, NULL), -- suat 645 | Dune: Hành Tinh Cát - Phần Hai | 02/12 18:00 | Phòng 5 | E5 E6 E7 E8
(3709, 8, 51, '2026-12-02T16:39:41', 240000, N'Paid', N'Cash', 240000, 12, 0, NULL, NULL, NULL), -- suat 645 | Dune: Hành Tinh Cát - Phần Hai | 02/12 18:00 | Phòng 5 | C9 C10
(3710, 8, NULL, '2026-12-02T16:44:17', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 675 | Trại Giam Hạnh Phúc | 03/12 18:30 | Phòng 1 | J1 J2
(3711, 8, NULL, '2026-12-02T16:48:54', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 656 | Hexed: Thế Giới Phép Thuật | 03/12 09:00 | Phòng 2 | H6
(3712, 8, NULL, '2026-12-02T16:51:14', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 679 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 21:00 | Phòng 1 | A6 A7 A8
(3713, 8, 92, '2026-12-02T16:54:08', 432000, N'Paid', N'Cash', 500000, 30, 0, NULL, NULL, NULL), -- suat 680 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 21:00 | Phòng 4 | D5 D6 D7 D8
(3714, 7, NULL, '2026-12-02T16:58:00', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 644 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 02/12 17:15 | Phòng 2 | J1 J2
(3715, 8, NULL, '2026-12-02T17:01:51', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 644 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 02/12 17:15 | Phòng 2 | G5 G6
(3716, 8, 99, '2026-12-02T17:02:41', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 653 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 02/12 21:45 | Phòng 2 | H6
(3717, 8, 67, '2026-12-02T17:05:20', 216000, N'Paid', N'Cash', 500000, 21, 0, NULL, NULL, NULL), -- suat 700 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 15:30 | Phòng 4 | J3 J4
(3718, 7, 9, '2026-12-02T17:06:24', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 646 | Trại Giam Hạnh Phúc | 02/12 18:30 | Phòng 1 | E7 E8
(3719, 7, NULL, '2026-12-02T17:11:12', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 649 | Bò Sữa Bay | 02/12 19:30 | Phòng 2 | F6 F7
(3720, 8, NULL, '2026-12-02T17:12:23', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 645 | Dune: Hành Tinh Cát - Phần Hai | 02/12 18:00 | Phòng 5 | F9 F10
(3721, 7, NULL, '2026-12-02T17:16:32', 450000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 647 | Điểm Mù | 02/12 18:30 | Phòng 3 | H5 H6 H7 H8 H9
(3722, 8, 111, '2026-12-02T17:25:26', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 646 | Trại Giam Hạnh Phúc | 02/12 18:30 | Phòng 1 | D8 D9 D10 D11
(3723, 8, 90, '2026-12-02T17:30:59', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 653 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 02/12 21:45 | Phòng 2 | G6 G7
(3724, 7, NULL, '2026-12-02T17:31:01', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 646 | Trại Giam Hạnh Phúc | 02/12 18:30 | Phòng 1 | F7 F8
(3725, 8, NULL, '2026-12-02T17:31:54', 108000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 648 | Godzilla Trừ Không | 02/12 18:30 | Phòng 4 | E6
(3726, 8, NULL, '2026-12-02T17:39:52', 540000, N'Paid', N'Cash', 550000, 0, 0, NULL, NULL, NULL), -- suat 649 | Bò Sữa Bay | 02/12 19:30 | Phòng 2 | G4 G5 G6 G7 G8 G9
(3727, 7, NULL, '2026-12-02T17:47:33', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 652 | Godzilla Trừ Không | 02/12 21:15 | Phòng 5 | B3 B4 B5
(3728, 8, NULL, '2026-12-02T17:51:15', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 648 | Godzilla Trừ Không | 02/12 18:30 | Phòng 4 | D5 D6 D7 D8
(3729, 7, NULL, '2026-12-02T17:57:44', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 690 | Ngày Con Còn Mẹ | 04/12 11:15 | Phòng 3 | H5 H6
(3730, 8, NULL, '2026-12-02T18:06:43', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 649 | Bò Sữa Bay | 02/12 19:30 | Phòng 2 | F3 F4 F5
(3731, 8, NULL, '2026-12-02T18:27:11', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 705 | Điểm Mù | 04/12 18:30 | Phòng 3 | J5 J6
(3732, 7, NULL, '2026-12-02T18:32:24', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 672 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 16:15 | Phòng 1 | E6 E7
(3733, 7, NULL, '2026-12-02T18:32:50', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 655 | Trại Giam Hạnh Phúc | 03/12 09:00 | Phòng 1 | F4 F5 F6
(3734, 7, NULL, '2026-12-02T18:50:18', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 652 | Godzilla Trừ Không | 02/12 21:15 | Phòng 5 | H6 H7
(3735, 8, 15, '2026-12-02T18:51:34', 216000, N'Paid', N'Cash', 220000, 15, 0, NULL, NULL, NULL), -- suat 651 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 21:00 | Phòng 4 | D7 D8
(3736, 8, NULL, '2026-12-02T18:53:20', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 675 | Trại Giam Hạnh Phúc | 03/12 18:30 | Phòng 1 | G6 G7
(3737, 8, NULL, '2026-12-02T18:57:31', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 653 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 02/12 21:45 | Phòng 2 | F6
(3738, 7, NULL, '2026-12-02T19:04:23', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 701 | Mẹ Mìn: Giao Kèo Với Quỷ | 04/12 16:15 | Phòng 1 | B6 B7
(3739, 8, NULL, '2026-12-02T19:09:23', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 697 | Ngày Con Còn Mẹ | 04/12 15:00 | Phòng 2 | F6
(3740, 7, NULL, '2026-12-02T19:12:00', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 654 | Mẹ Mìn: Giao Kèo Với Quỷ | 02/12 21:45 | Phòng 3 | E6 E7 E8
(3741, 8, 37, '2026-12-02T19:20:29', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 649 | Bò Sữa Bay | 02/12 19:30 | Phòng 2 | G10
(3742, 7, 25, '2026-12-02T19:29:52', 87000, N'Paid', N'Transfer', NULL, 6, 21, NULL, NULL, NULL), -- suat 651 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 21:00 | Phòng 4 | G6
(3743, 8, NULL, '2026-12-02T19:30:37', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 651 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 21:00 | Phòng 4 | J7 J8 J9 J10
(3744, 8, NULL, '2026-12-02T19:32:13', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 689 | Ma Mút Con Vượt Kỷ Băng Hà | 04/12 11:15 | Phòng 2 | D6 D7
(3745, 7, 81, '2026-12-02T19:33:51', 180000, N'Paid', N'Cash', 180000, 18, 0, NULL, NULL, NULL), -- suat 653 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 02/12 21:45 | Phòng 2 | J7 J8
(3746, 8, NULL, '2026-12-02T19:51:21', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 653 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 02/12 21:45 | Phòng 2 | J3 J4
(3747, 7, 37, '2026-12-02T19:51:29', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 654 | Mẹ Mìn: Giao Kèo Với Quỷ | 02/12 21:45 | Phòng 3 | F2 F3
(3748, 8, NULL, '2026-12-02T19:58:35', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 669 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 15:00 | Phòng 5 | L9 L10
(3749, 8, 115, '2026-12-02T20:00:21', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 667 | Trại Giam Hạnh Phúc | 03/12 13:45 | Phòng 1 | F7
(3750, 7, NULL, '2026-12-02T20:05:18', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 650 | Mẹ Mìn: Giao Kèo Với Quỷ | 02/12 21:00 | Phòng 1 | E6 E7 E8
(3751, 8, 21, '2026-12-02T20:05:50', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 660 | Ma Mút Con Vượt Kỷ Băng Hà | 03/12 11:15 | Phòng 2 | G5 G6 G7
(3752, 7, NULL, '2026-12-02T20:12:30', 360000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-12-02T20:54:36', 7), -- suat 650 | Mẹ Mìn: Giao Kèo Với Quỷ | 02/12 21:00 | Phòng 1 | J7 J8 J9 J10
(3753, 8, NULL, '2026-12-02T20:13:36', 90000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 653 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 02/12 21:45 | Phòng 2 | G5
(3754, 8, NULL, '2026-12-02T20:17:12', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 653 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 02/12 21:45 | Phòng 2 | D6 D7
(3755, 8, 108, '2026-12-02T20:21:25', 144000, N'Paid', N'Transfer', NULL, 10, 0, NULL, NULL, NULL), -- suat 652 | Godzilla Trừ Không | 02/12 21:15 | Phòng 5 | K6
(3756, 8, NULL, '2026-12-02T20:32:16', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 652 | Godzilla Trừ Không | 02/12 21:15 | Phòng 5 | E6 E7
(3757, 7, 63, '2026-12-02T20:33:15', 360000, N'Paid', N'Cash', 500000, 18, 0, NULL, NULL, NULL), -- suat 652 | Godzilla Trừ Không | 02/12 21:15 | Phòng 5 | B7 B8 B9
(3758, 7, 26, '2026-12-02T20:35:41', 180000, N'Paid', N'Transfer', NULL, 9, 0, NULL, NULL, NULL), -- suat 651 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 02/12 21:00 | Phòng 4 | B6 B7
(3759, 7, 98, '2026-12-02T20:39:28', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 654 | Mẹ Mìn: Giao Kèo Với Quỷ | 02/12 21:45 | Phòng 3 | G7 G8
(3760, 7, NULL, '2026-12-02T20:55:26', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 679 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 21:00 | Phòng 1 | F4 F5
(3761, 8, NULL, '2026-12-02T20:56:08', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 666 | Bí Kíp Luyện Cướp | 03/12 13:30 | Phòng 3 | H7 H8
(3762, 8, NULL, '2026-12-02T20:59:53', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 654 | Mẹ Mìn: Giao Kèo Với Quỷ | 02/12 21:45 | Phòng 3 | E3 E4
(3763, 7, NULL, '2026-12-02T21:20:28', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 654 | Mẹ Mìn: Giao Kèo Với Quỷ | 02/12 21:45 | Phòng 3 | D5 D6 D7 D8
(3764, 8, NULL, '2026-12-02T21:28:51', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 653 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 02/12 21:45 | Phòng 2 | D8 D9
(3765, 8, 29, '2026-12-02T21:34:51', 225000, N'Paid', N'Transfer', NULL, 11, 0, NULL, NULL, NULL), -- suat 665 | Hexed: Thế Giới Phép Thuật | 03/12 12:45 | Phòng 2 | A5 A6 A7
(3766, 7, 32, '2026-12-02T21:37:23', 324000, N'Paid', N'Transfer', NULL, 22, 0, NULL, NULL, NULL); -- suat 670 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 15:30 | Phòng 4 | H6 H7 H8
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(8305, 3620, 630, 3, 317, 90000, N'Active'),
(8306, 3620, 630, 3, 318, 90000, N'Active'),
(8307, 3620, 630, 3, 319, 90000, N'Active'),
(8308, 3620, 630, 3, 320, 90000, N'Active'),
(8309, 3621, 636, 2, 187, 90000, N'Active'),
(8310, 3621, 636, 2, 188, 90000, N'Active'),
(8311, 3622, 681, 5, 489, 144000, N'Active'),
(8312, 3622, 681, 5, 490, 144000, N'Active'),
(8313, 3623, 655, 1, 42, 90000, N'Active'),
(8314, 3623, 655, 1, 43, 90000, N'Active'),
(8315, 3623, 655, 1, 44, 90000, N'Active'),
(8316, 3624, 629, 4, 391, 108000, N'Active'),
(8317, 3624, 629, 4, 392, 108000, N'Active'),
(8318, 3625, 626, 1, 65, 90000, N'Active'),
(8319, 3625, 626, 1, 66, 90000, N'Active'),
(8320, 3626, 680, 4, 401, 108000, N'Active'),
(8321, 3626, 680, 4, 402, 108000, N'Active'),
(8322, 3627, 647, 3, 313, 90000, N'Active'),
(8323, 3627, 647, 3, 314, 90000, N'Active'),
(8324, 3628, 628, 5, 510, 144000, N'Active'),
(8325, 3628, 628, 5, 511, 144000, N'Active'),
(8326, 3628, 628, 5, 512, 144000, N'Active'),
(8327, 3629, 636, 2, 174, 90000, N'Active'),
(8328, 3629, 636, 2, 175, 90000, N'Active'),
(8329, 3630, 704, 1, 66, 90000, N'Active'),
(8330, 3630, 704, 1, 67, 90000, N'Active'),
(8331, 3631, 644, 2, 149, 90000, N'Active'),
(8332, 3631, 644, 2, 150, 90000, N'Active'),
(8333, 3632, 631, 2, 213, 90000, N'Active'),
(8334, 3632, 631, 2, 214, 90000, N'Active'),
(8335, 3633, 637, 3, 313, 90000, N'Active'),
(8336, 3633, 637, 3, 314, 90000, N'Active'),
(8337, 3634, 636, 2, 171, 90000, N'Active'),
(8338, 3634, 636, 2, 172, 90000, N'Active'),
(8339, 3634, 636, 2, 173, 90000, N'Active'),
(8340, 3635, 637, 3, 269, 90000, N'Active'),
(8341, 3635, 637, 3, 270, 90000, N'Active'),
(8342, 3636, 671, 3, 257, 90000, N'Active'),
(8343, 3636, 671, 3, 258, 90000, N'Active'),
(8344, 3637, 632, 3, 297, 90000, N'Active'),
(8345, 3637, 632, 3, 298, 90000, N'Active'),
(8346, 3637, 632, 3, 299, 90000, N'Active'),
(8347, 3638, 635, 5, 451, 120000, N'Active'),
(8348, 3639, 639, 2, 149, 90000, N'Active'),
(8349, 3639, 639, 2, 150, 90000, N'Active'),
(8350, 3640, 707, 2, 197, 90000, N'Active'),
(8351, 3640, 707, 2, 198, 90000, N'Active'),
(8352, 3641, 634, 4, 413, 108000, N'Active'),
(8353, 3641, 634, 4, 414, 108000, N'Active'),
(8354, 3642, 685, 2, 198, 90000, N'Active'),
(8355, 3642, 685, 2, 199, 90000, N'Active'),
(8356, 3643, 634, 4, 416, 108000, N'Active'),
(8357, 3643, 634, 4, 417, 108000, N'Active'),
(8358, 3644, 636, 2, 162, 90000, N'Active'),
(8359, 3645, 635, 5, 536, 144000, N'Active'),
(8360, 3646, 632, 3, 319, 90000, N'Active'),
(8361, 3646, 632, 3, 320, 90000, N'Active'),
(8362, 3646, 632, 3, 321, 90000, N'Active'),
(8363, 3646, 632, 3, 322, 90000, N'Active'),
(8364, 3647, 644, 2, 189, 90000, N'Active'),
(8365, 3648, 635, 5, 521, 144000, N'Active'),
(8366, 3649, 681, 5, 534, 144000, N'Cancelled'),
(8367, 3650, 646, 1, 41, 90000, N'Active'),
(8368, 3650, 646, 1, 42, 90000, N'Active'),
(8369, 3650, 646, 1, 43, 90000, N'Active'),
(8370, 3651, 634, 4, 332, 90000, N'Active'),
(8371, 3652, 635, 5, 511, 144000, N'Active'),
(8372, 3653, 658, 4, 414, 108000, N'Active'),
(8373, 3654, 637, 3, 296, 90000, N'Active'),
(8374, 3654, 637, 3, 297, 90000, N'Active'),
(8375, 3655, 640, 5, 508, 144000, N'Active'),
(8376, 3655, 640, 5, 509, 144000, N'Active'),
(8377, 3656, 640, 5, 498, 144000, N'Active'),
(8378, 3656, 640, 5, 499, 144000, N'Active'),
(8379, 3657, 637, 3, 294, 90000, N'Active'),
(8380, 3657, 637, 3, 295, 90000, N'Active'),
(8381, 3658, 672, 1, 88, 90000, N'Active'),
(8382, 3659, 649, 2, 198, 90000, N'Active'),
(8383, 3660, 704, 1, 41, 90000, N'Active'),
(8384, 3661, 639, 2, 173, 90000, N'Active'),
(8385, 3661, 639, 2, 174, 90000, N'Active'),
(8386, 3661, 639, 2, 175, 90000, N'Active'),
(8387, 3662, 645, 5, 462, 120000, N'Active'),
(8388, 3662, 645, 5, 463, 120000, N'Active'),
(8389, 3663, 638, 1, 54, 90000, N'Active'),
(8390, 3663, 638, 1, 55, 90000, N'Active'),
(8391, 3664, 669, 5, 485, 144000, N'Active'),
(8392, 3664, 669, 5, 486, 144000, N'Active'),
(8393, 3664, 669, 5, 487, 144000, N'Active'),
(8394, 3665, 678, 2, 164, 90000, N'Active'),
(8395, 3665, 678, 2, 165, 90000, N'Active'),
(8396, 3666, 638, 1, 42, 90000, N'Active'),
(8397, 3666, 638, 1, 43, 90000, N'Active'),
(8398, 3667, 637, 3, 247, 75000, N'Active'),
(8399, 3667, 637, 3, 248, 75000, N'Active'),
(8400, 3667, 637, 3, 249, 75000, N'Active'),
(8401, 3668, 704, 1, 39, 90000, N'Active'),
(8402, 3668, 704, 1, 40, 90000, N'Active'),
(8403, 3669, 642, 3, 295, 90000, N'Active'),
(8404, 3669, 642, 3, 296, 90000, N'Active'),
(8405, 3670, 668, 2, 196, 90000, N'Active'),
(8406, 3670, 668, 2, 197, 90000, N'Active'),
(8407, 3670, 668, 2, 198, 90000, N'Active'),
(8408, 3671, 711, 2, 197, 90000, N'Cancelled'),
(8409, 3671, 711, 2, 198, 90000, N'Cancelled'),
(8410, 3671, 711, 2, 199, 90000, N'Cancelled'),
(8411, 3672, 640, 5, 522, 144000, N'Active'),
(8412, 3672, 640, 5, 523, 144000, N'Active'),
(8413, 3673, 640, 5, 487, 144000, N'Active'),
(8414, 3674, 642, 3, 305, 90000, N'Active'),
(8415, 3674, 642, 3, 306, 90000, N'Active'),
(8416, 3674, 642, 3, 307, 90000, N'Active'),
(8417, 3675, 643, 1, 99, 90000, N'Active'),
(8418, 3675, 643, 1, 100, 90000, N'Active'),
(8419, 3675, 643, 1, 101, 90000, N'Active'),
(8420, 3675, 643, 1, 102, 90000, N'Active'),
(8421, 3676, 639, 2, 113, 75000, N'Active'),
(8422, 3676, 639, 2, 114, 75000, N'Active'),
(8423, 3677, 659, 3, 270, 90000, N'Active'),
(8424, 3677, 659, 3, 271, 90000, N'Active'),
(8425, 3678, 639, 2, 151, 90000, N'Active'),
(8426, 3678, 639, 2, 152, 90000, N'Active'),
(8427, 3679, 640, 5, 547, 144000, N'Active'),
(8428, 3679, 640, 5, 548, 144000, N'Active'),
(8429, 3680, 644, 2, 140, 75000, N'Active'),
(8430, 3680, 644, 2, 141, 75000, N'Active'),
(8431, 3681, 682, 2, 198, 90000, N'Active'),
(8432, 3681, 682, 2, 199, 90000, N'Active'),
(8433, 3682, 641, 4, 390, 108000, N'Active'),
(8434, 3683, 645, 5, 522, 144000, N'Active'),
(8435, 3683, 645, 5, 523, 144000, N'Active'),
(8436, 3683, 645, 5, 524, 144000, N'Active'),
(8437, 3684, 648, 4, 362, 108000, N'Active'),
(8438, 3684, 648, 4, 363, 108000, N'Active'),
(8439, 3685, 669, 5, 522, 144000, N'Active'),
(8440, 3685, 669, 5, 523, 144000, N'Active'),
(8441, 3686, 641, 4, 402, 108000, N'Active'),
(8442, 3686, 641, 4, 403, 108000, N'Active'),
(8443, 3686, 641, 4, 404, 108000, N'Active'),
(8444, 3687, 657, 5, 508, 144000, N'Active'),
(8445, 3687, 657, 5, 509, 144000, N'Active'),
(8446, 3688, 658, 4, 403, 108000, N'Active'),
(8447, 3688, 658, 4, 404, 108000, N'Active'),
(8448, 3689, 647, 3, 234, 75000, N'Cancelled'),
(8449, 3689, 647, 3, 235, 75000, N'Cancelled'),
(8450, 3689, 647, 3, 236, 75000, N'Cancelled'),
(8451, 3689, 647, 3, 237, 75000, N'Cancelled'),
(8452, 3690, 657, 5, 510, 144000, N'Active'),
(8453, 3690, 657, 5, 511, 144000, N'Active'),
(8454, 3690, 657, 5, 512, 144000, N'Active'),
(8455, 3690, 657, 5, 513, 144000, N'Active'),
(8456, 3691, 646, 1, 107, 90000, N'Active'),
(8457, 3691, 646, 1, 108, 90000, N'Active'),
(8458, 3692, 655, 1, 18, 75000, N'Active'),
(8459, 3693, 644, 2, 187, 90000, N'Active'),
(8460, 3693, 644, 2, 188, 90000, N'Active'),
(8461, 3694, 711, 2, 123, 75000, N'Active'),
(8462, 3694, 711, 2, 124, 75000, N'Active'),
(8463, 3694, 711, 2, 125, 75000, N'Active'),
(8464, 3695, 654, 3, 282, 90000, N'Active'),
(8465, 3695, 654, 3, 283, 90000, N'Active'),
(8466, 3695, 654, 3, 284, 90000, N'Active'),
(8467, 3696, 659, 3, 306, 90000, N'Active'),
(8468, 3696, 659, 3, 307, 90000, N'Active'),
(8469, 3697, 682, 2, 173, 90000, N'Active'),
(8470, 3697, 682, 2, 174, 90000, N'Active'),
(8471, 3697, 682, 2, 175, 90000, N'Active'),
(8472, 3698, 642, 3, 269, 90000, N'Active'),
(8473, 3698, 642, 3, 270, 90000, N'Active'),
(8474, 3698, 642, 3, 271, 90000, N'Active'),
(8475, 3699, 644, 2, 175, 90000, N'Active'),
(8476, 3700, 707, 2, 162, 90000, N'Active'),
(8477, 3701, 645, 5, 464, 120000, N'Active'),
(8478, 3702, 649, 2, 163, 90000, N'Active'),
(8479, 3703, 651, 4, 390, 108000, N'Active'),
(8480, 3703, 651, 4, 391, 108000, N'Active'),
(8481, 3704, 697, 2, 189, 90000, N'Active'),
(8482, 3704, 697, 2, 190, 90000, N'Active'),
(8483, 3705, 704, 1, 7, 75000, N'Active'),
(8484, 3705, 704, 1, 8, 75000, N'Active'),
(8485, 3706, 645, 5, 489, 144000, N'Active'),
(8486, 3706, 645, 5, 490, 144000, N'Active'),
(8487, 3706, 645, 5, 491, 144000, N'Active'),
(8488, 3706, 645, 5, 492, 144000, N'Active'),
(8489, 3707, 676, 3, 270, 90000, N'Active'),
(8490, 3707, 676, 3, 271, 90000, N'Active'),
(8491, 3708, 645, 5, 485, 144000, N'Active'),
(8492, 3708, 645, 5, 486, 144000, N'Active'),
(8493, 3708, 645, 5, 487, 144000, N'Active'),
(8494, 3708, 645, 5, 488, 144000, N'Active'),
(8495, 3709, 645, 5, 465, 120000, N'Active'),
(8496, 3709, 645, 5, 466, 120000, N'Active'),
(8497, 3710, 675, 1, 97, 90000, N'Active'),
(8498, 3710, 675, 1, 98, 90000, N'Active'),
(8499, 3711, 656, 2, 198, 90000, N'Active'),
(8500, 3712, 679, 1, 6, 75000, N'Active'),
(8501, 3712, 679, 1, 7, 75000, N'Active'),
(8502, 3712, 679, 1, 8, 75000, N'Active'),
(8503, 3713, 680, 4, 365, 108000, N'Active'),
(8504, 3713, 680, 4, 366, 108000, N'Active'),
(8505, 3713, 680, 4, 367, 108000, N'Active'),
(8506, 3713, 680, 4, 368, 108000, N'Active'),
(8507, 3714, 644, 2, 205, 90000, N'Active'),
(8508, 3714, 644, 2, 206, 90000, N'Active'),
(8509, 3715, 644, 2, 185, 90000, N'Active'),
(8510, 3715, 644, 2, 186, 90000, N'Active'),
(8511, 3716, 653, 2, 198, 90000, N'Active'),
(8512, 3717, 700, 4, 423, 108000, N'Active'),
(8513, 3717, 700, 4, 424, 108000, N'Active'),
(8514, 3718, 646, 1, 55, 90000, N'Active'),
(8515, 3718, 646, 1, 56, 90000, N'Active'),
(8516, 3719, 649, 2, 174, 90000, N'Active'),
(8517, 3719, 649, 2, 175, 90000, N'Active'),
(8518, 3720, 645, 5, 501, 144000, N'Active'),
(8519, 3720, 645, 5, 502, 144000, N'Active'),
(8520, 3721, 647, 3, 305, 90000, N'Active'),
(8521, 3721, 647, 3, 306, 90000, N'Active'),
(8522, 3721, 647, 3, 307, 90000, N'Active'),
(8523, 3721, 647, 3, 308, 90000, N'Active'),
(8524, 3721, 647, 3, 309, 90000, N'Active'),
(8525, 3722, 646, 1, 44, 90000, N'Active'),
(8526, 3722, 646, 1, 45, 90000, N'Active'),
(8527, 3722, 646, 1, 46, 90000, N'Active'),
(8528, 3722, 646, 1, 47, 90000, N'Active'),
(8529, 3723, 653, 2, 186, 90000, N'Active'),
(8530, 3723, 653, 2, 187, 90000, N'Active'),
(8531, 3724, 646, 1, 67, 90000, N'Active'),
(8532, 3724, 646, 1, 68, 90000, N'Active'),
(8533, 3725, 648, 4, 378, 108000, N'Active'),
(8534, 3726, 649, 2, 184, 90000, N'Active'),
(8535, 3726, 649, 2, 185, 90000, N'Active'),
(8536, 3726, 649, 2, 186, 90000, N'Active'),
(8537, 3726, 649, 2, 187, 90000, N'Active'),
(8538, 3726, 649, 2, 188, 90000, N'Active'),
(8539, 3726, 649, 2, 189, 90000, N'Active'),
(8540, 3727, 652, 5, 447, 120000, N'Active'),
(8541, 3727, 652, 5, 448, 120000, N'Active'),
(8542, 3727, 652, 5, 449, 120000, N'Active'),
(8543, 3728, 648, 4, 365, 108000, N'Active'),
(8544, 3728, 648, 4, 366, 108000, N'Active'),
(8545, 3728, 648, 4, 367, 108000, N'Active'),
(8546, 3728, 648, 4, 368, 108000, N'Active'),
(8547, 3729, 690, 3, 305, 90000, N'Active'),
(8548, 3729, 690, 3, 306, 90000, N'Active'),
(8549, 3730, 649, 2, 171, 90000, N'Active'),
(8550, 3730, 649, 2, 172, 90000, N'Active'),
(8551, 3730, 649, 2, 173, 90000, N'Active'),
(8552, 3731, 705, 3, 317, 90000, N'Active'),
(8553, 3731, 705, 3, 318, 90000, N'Active'),
(8554, 3732, 672, 1, 54, 90000, N'Active'),
(8555, 3732, 672, 1, 55, 90000, N'Active'),
(8556, 3733, 655, 1, 64, 90000, N'Active'),
(8557, 3733, 655, 1, 65, 90000, N'Active'),
(8558, 3733, 655, 1, 66, 90000, N'Active'),
(8559, 3734, 652, 5, 522, 144000, N'Active'),
(8560, 3734, 652, 5, 523, 144000, N'Active'),
(8561, 3735, 651, 4, 367, 108000, N'Active'),
(8562, 3735, 651, 4, 368, 108000, N'Active'),
(8563, 3736, 675, 1, 78, 90000, N'Active'),
(8564, 3736, 675, 1, 79, 90000, N'Active'),
(8565, 3737, 653, 2, 174, 90000, N'Active'),
(8566, 3738, 701, 1, 18, 75000, N'Active'),
(8567, 3738, 701, 1, 19, 75000, N'Active'),
(8568, 3739, 697, 2, 174, 90000, N'Active'),
(8569, 3740, 654, 3, 270, 90000, N'Active'),
(8570, 3740, 654, 3, 271, 90000, N'Active'),
(8571, 3740, 654, 3, 272, 90000, N'Active'),
(8572, 3741, 649, 2, 190, 90000, N'Active'),
(8573, 3742, 651, 4, 402, 108000, N'Active'),
(8574, 3743, 651, 4, 427, 108000, N'Active'),
(8575, 3743, 651, 4, 428, 108000, N'Active'),
(8576, 3743, 651, 4, 429, 108000, N'Active'),
(8577, 3743, 651, 4, 430, 108000, N'Active'),
(8578, 3744, 689, 2, 150, 90000, N'Active'),
(8579, 3744, 689, 2, 151, 90000, N'Active'),
(8580, 3745, 653, 2, 211, 90000, N'Active'),
(8581, 3745, 653, 2, 212, 90000, N'Active'),
(8582, 3746, 653, 2, 207, 90000, N'Active'),
(8583, 3746, 653, 2, 208, 90000, N'Active'),
(8584, 3747, 654, 3, 278, 90000, N'Active'),
(8585, 3747, 654, 3, 279, 90000, N'Active'),
(8586, 3748, 669, 5, 561, 144000, N'Active'),
(8587, 3748, 669, 5, 562, 144000, N'Active'),
(8588, 3749, 667, 1, 67, 90000, N'Active'),
(8589, 3750, 650, 1, 54, 90000, N'Active'),
(8590, 3750, 650, 1, 55, 90000, N'Active'),
(8591, 3750, 650, 1, 56, 90000, N'Active'),
(8592, 3751, 660, 2, 185, 90000, N'Active'),
(8593, 3751, 660, 2, 186, 90000, N'Active'),
(8594, 3751, 660, 2, 187, 90000, N'Active'),
(8595, 3752, 650, 1, 103, 90000, N'Cancelled'),
(8596, 3752, 650, 1, 104, 90000, N'Cancelled'),
(8597, 3752, 650, 1, 105, 90000, N'Cancelled'),
(8598, 3752, 650, 1, 106, 90000, N'Cancelled'),
(8599, 3753, 653, 2, 185, 90000, N'Active'),
(8600, 3754, 653, 2, 150, 90000, N'Active'),
(8601, 3754, 653, 2, 151, 90000, N'Active'),
(8602, 3755, 652, 5, 546, 144000, N'Active'),
(8603, 3756, 652, 5, 486, 144000, N'Active'),
(8604, 3756, 652, 5, 487, 144000, N'Active'),
(8605, 3757, 652, 5, 451, 120000, N'Active'),
(8606, 3757, 652, 5, 452, 120000, N'Active'),
(8607, 3757, 652, 5, 453, 120000, N'Active'),
(8608, 3758, 651, 4, 342, 90000, N'Active'),
(8609, 3758, 651, 4, 343, 90000, N'Active'),
(8610, 3759, 654, 3, 295, 90000, N'Active'),
(8611, 3759, 654, 3, 296, 90000, N'Active'),
(8612, 3760, 679, 1, 64, 90000, N'Active'),
(8613, 3760, 679, 1, 65, 90000, N'Active'),
(8614, 3761, 666, 3, 307, 90000, N'Active'),
(8615, 3761, 666, 3, 308, 90000, N'Active'),
(8616, 3762, 654, 3, 267, 90000, N'Active'),
(8617, 3762, 654, 3, 268, 90000, N'Active'),
(8618, 3763, 654, 3, 257, 90000, N'Active'),
(8619, 3763, 654, 3, 258, 90000, N'Active'),
(8620, 3763, 654, 3, 259, 90000, N'Active'),
(8621, 3763, 654, 3, 260, 90000, N'Active'),
(8622, 3764, 653, 2, 152, 90000, N'Active'),
(8623, 3764, 653, 2, 153, 90000, N'Active'),
(8624, 3765, 665, 2, 113, 75000, N'Active'),
(8625, 3765, 665, 2, 114, 75000, N'Active'),
(8626, 3765, 665, 2, 115, 75000, N'Active'),
(8627, 3766, 670, 4, 414, 108000, N'Active'),
(8628, 3766, 670, 4, 415, 108000, N'Active'),
(8629, 3766, 670, 4, 416, 108000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 5 03/12/2026: 174 hoa don (5 huy), 383 ve, doanh thu 36.536.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(3767, 9, NULL, '2026-12-03T08:00:18', 300000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 656 | Hexed: Thế Giới Phép Thuật | 03/12 09:00 | Phòng 2 | A4 A5 A6 A7
(3768, 9, NULL, '2026-12-03T08:04:57', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Nhầm suất / ghế', '2026-12-03T08:57:20', 9), -- suat 695 | Con Mắt Thứ Ba | 04/12 13:30 | Phòng 3 | H6 H7
(3769, 8, NULL, '2026-12-03T08:06:49', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 658 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 09:15 | Phòng 4 | J3 J4
(3770, 8, NULL, '2026-12-03T08:11:54', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 670 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 15:30 | Phòng 4 | G5 G6 G7 G8
(3771, 9, 47, '2026-12-03T08:20:00', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 663 | Ramayana: Khởi Nguồn Một Huyền Thoại | 03/12 12:15 | Phòng 4 | E6 E7
(3772, 8, 93, '2026-12-03T08:23:12', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 665 | Hexed: Thế Giới Phép Thuật | 03/12 12:45 | Phòng 2 | G7
(3773, 9, NULL, '2026-12-03T08:28:40', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 661 | Ngày Con Còn Mẹ | 03/12 11:15 | Phòng 3 | D6
(3774, 8, NULL, '2026-12-03T08:34:15', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 702 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 04/12 17:15 | Phòng 2 | F6 F7
(3775, 8, NULL, '2026-12-03T08:42:26', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 659 | Kiến Lé Phiêu Lưu Ké | 03/12 09:30 | Phòng 3 | D5 D6 D7 D8
(3776, 9, NULL, '2026-12-03T08:42:36', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 674 | Dune: Hành Tinh Cát - Phần Hai | 03/12 18:00 | Phòng 5 | E5 E6
(3777, 9, NULL, '2026-12-03T08:46:36', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 662 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 03/12 11:30 | Phòng 1 | F6 F7
(3778, 8, 93, '2026-12-03T08:48:44', 90000, N'Cancelled', N'Transfer', NULL, 6, 0, N'Khách đổi ý', '2026-12-03T08:57:15', 8), -- suat 655 | Trại Giam Hạnh Phúc | 03/12 09:00 | Phòng 1 | H5
(3779, 8, NULL, '2026-12-03T09:02:06', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 662 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 03/12 11:30 | Phòng 1 | E5 E6
(3780, 8, NULL, '2026-12-03T09:02:33', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 674 | Dune: Hành Tinh Cát - Phần Hai | 03/12 18:00 | Phòng 5 | F2 F3
(3781, 8, NULL, '2026-12-03T09:08:04', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 660 | Ma Mút Con Vượt Kỷ Băng Hà | 03/12 11:15 | Phòng 2 | E6 E7
(3782, 8, NULL, '2026-12-03T09:17:56', 216000, N'Paid', N'Cash', 220000, 0, 0, NULL, NULL, NULL), -- suat 663 | Ramayana: Khởi Nguồn Một Huyền Thoại | 03/12 12:15 | Phòng 4 | D7 D8
(3783, 8, 69, '2026-12-03T09:26:52', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 710 | Godzilla Trừ Không | 04/12 21:15 | Phòng 5 | K5 K6
(3784, 8, 117, '2026-12-03T09:27:59', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 690 | Ngày Con Còn Mẹ | 04/12 11:15 | Phòng 3 | G4
(3785, 8, 24, '2026-12-03T09:42:39', 75000, N'Paid', N'Transfer', NULL, 3, 0, NULL, NULL, NULL), -- suat 667 | Trại Giam Hạnh Phúc | 03/12 13:45 | Phòng 1 | C6
(3786, 8, 32, '2026-12-03T09:55:55', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 668 | Ngày Con Còn Mẹ | 03/12 15:00 | Phòng 2 | H9 H10 H11
(3787, 9, NULL, '2026-12-03T09:55:55', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 705 | Điểm Mù | 04/12 18:30 | Phòng 3 | F10 F11 F12
(3788, 8, NULL, '2026-12-03T10:09:34', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 664 | Godzilla Trừ Không | 03/12 12:15 | Phòng 5 | A6 A7
(3789, 8, 89, '2026-12-03T10:20:11', 186000, N'Paid', N'Cash', 186000, 13, 30, NULL, NULL, NULL), -- suat 663 | Ramayana: Khởi Nguồn Một Huyền Thoại | 03/12 12:15 | Phòng 4 | D5 D6
(3790, 9, 33, '2026-12-03T10:27:57', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 668 | Ngày Con Còn Mẹ | 03/12 15:00 | Phòng 2 | H7 H8
(3791, 9, NULL, '2026-12-03T10:29:23', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 694 | Hexed: Thế Giới Phép Thuật | 04/12 12:45 | Phòng 2 | G6 G7
(3792, 8, NULL, '2026-12-03T10:30:22', 75000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 712 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 3 | C6
(3793, 8, NULL, '2026-12-03T10:30:22', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | F6 F7
(3794, 9, NULL, '2026-12-03T10:30:38', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 661 | Ngày Con Còn Mẹ | 03/12 11:15 | Phòng 3 | C4 C5 C6
(3795, 8, NULL, '2026-12-03T10:33:30', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 697 | Ngày Con Còn Mẹ | 04/12 15:00 | Phòng 2 | D6 D7
(3796, 8, NULL, '2026-12-03T10:41:56', 216000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 729 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:30 | Phòng 4 | E5 E6
(3797, 8, 69, '2026-12-03T10:42:06', 401000, N'Paid', N'Card', NULL, 28, 31, NULL, NULL, NULL), -- suat 706 | Godzilla Trừ Không | 04/12 18:30 | Phòng 4 | D5 D6 D7 D8
(3798, 8, 87, '2026-12-03T10:47:28', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 677 | Godzilla Trừ Không | 03/12 18:30 | Phòng 4 | F6 F7
(3799, 8, NULL, '2026-12-03T10:48:07', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 662 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 03/12 11:30 | Phòng 1 | B8
(3800, 8, NULL, '2026-12-03T10:49:54', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 667 | Trại Giam Hạnh Phúc | 03/12 13:45 | Phòng 1 | B6 B7
(3801, 8, NULL, '2026-12-03T10:51:47', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 665 | Hexed: Thế Giới Phép Thuật | 03/12 12:45 | Phòng 2 | H5 H6
(3802, 8, NULL, '2026-12-03T11:03:02', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 697 | Ngày Con Còn Mẹ | 04/12 15:00 | Phòng 2 | D4 D5
(3803, 9, NULL, '2026-12-03T11:03:45', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | H9
(3804, 8, 68, '2026-12-03T11:05:46', 180000, N'Paid', N'Cash', 500000, 9, 0, NULL, NULL, NULL), -- suat 663 | Ramayana: Khởi Nguồn Một Huyền Thoại | 03/12 12:15 | Phòng 4 | C5 C6
(3805, 9, NULL, '2026-12-03T11:13:18', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 663 | Ramayana: Khởi Nguồn Một Huyền Thoại | 03/12 12:15 | Phòng 4 | D9 D10
(3806, 9, 103, '2026-12-03T11:14:11', 150000, N'Paid', N'Cash', 500000, 7, 0, NULL, NULL, NULL), -- suat 665 | Hexed: Thế Giới Phép Thuật | 03/12 12:45 | Phòng 2 | C6 C7
(3807, 8, NULL, '2026-12-03T11:17:39', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 668 | Ngày Con Còn Mẹ | 03/12 15:00 | Phòng 2 | G7 G8
(3808, 8, NULL, '2026-12-03T11:24:15', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 673 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 03/12 17:15 | Phòng 2 | B8 B9
(3809, 9, NULL, '2026-12-03T11:24:20', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 671 | Chị Chị Em Em 3 | 03/12 16:00 | Phòng 3 | G4 G5 G6 G7
(3810, 9, 120, '2026-12-03T11:28:54', 576000, N'Paid', N'Cash', 576000, 40, 0, NULL, NULL, NULL), -- suat 664 | Godzilla Trừ Không | 03/12 12:15 | Phòng 5 | H5 H6 H7 H8
(3811, 8, NULL, '2026-12-03T11:29:50', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 696 | Trại Giam Hạnh Phúc | 04/12 13:45 | Phòng 1 | F6 F7
(3812, 9, NULL, '2026-12-03T11:34:57', 108000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 663 | Ramayana: Khởi Nguồn Một Huyền Thoại | 03/12 12:15 | Phòng 4 | H6
(3813, 8, 89, '2026-12-03T11:38:12', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | F9 F10
(3814, 8, NULL, '2026-12-03T11:52:10', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 676 | Điểm Mù | 03/12 18:30 | Phòng 3 | C4 C5
(3815, 9, NULL, '2026-12-03T11:55:54', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 663 | Ramayana: Khởi Nguồn Một Huyền Thoại | 03/12 12:15 | Phòng 4 | E5
(3816, 9, NULL, '2026-12-03T12:07:38', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 666 | Bí Kíp Luyện Cướp | 03/12 13:30 | Phòng 3 | H6
(3817, 8, NULL, '2026-12-03T12:13:35', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 665 | Hexed: Thế Giới Phép Thuật | 03/12 12:45 | Phòng 2 | B5 B6 B7
(3818, 8, NULL, '2026-12-03T12:22:18', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 666 | Bí Kíp Luyện Cướp | 03/12 13:30 | Phòng 3 | F6 F7
(3819, 9, NULL, '2026-12-03T12:30:52', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 670 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 15:30 | Phòng 4 | E5 E6
(3820, 8, NULL, '2026-12-03T12:32:12', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 665 | Hexed: Thế Giới Phép Thuật | 03/12 12:45 | Phòng 2 | B9
(3821, 8, NULL, '2026-12-03T12:44:16', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 690 | Ngày Con Còn Mẹ | 04/12 11:15 | Phòng 3 | E5 E6 E7 E8
(3822, 9, NULL, '2026-12-03T12:49:00', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 686 | Dune: Hành Tinh Cát - Phần Hai | 04/12 09:00 | Phòng 5 | E7 E8
(3823, 8, NULL, '2026-12-03T12:49:02', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 673 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 03/12 17:15 | Phòng 2 | J9 J10
(3824, 8, NULL, '2026-12-03T12:49:22', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 670 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 15:30 | Phòng 4 | E7 E8
(3825, 9, 93, '2026-12-03T12:51:35', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 667 | Trại Giam Hạnh Phúc | 03/12 13:45 | Phòng 1 | E7 E8
(3826, 8, NULL, '2026-12-03T12:54:05', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 667 | Trại Giam Hạnh Phúc | 03/12 13:45 | Phòng 1 | A7 A8
(3827, 9, NULL, '2026-12-03T13:00:00', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 674 | Dune: Hành Tinh Cát - Phần Hai | 03/12 18:00 | Phòng 5 | K7 K8
(3828, 9, 100, '2026-12-03T13:03:18', 75000, N'Paid', N'Cash', 75000, 3, 0, NULL, NULL, NULL), -- suat 702 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 04/12 17:15 | Phòng 2 | B6
(3829, 9, 54, '2026-12-03T13:03:18', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 730 | Mẹ Mìn: Giao Kèo Với Quỷ | 05/12 16:15 | Phòng 1 | E4 E5
(3830, 9, NULL, '2026-12-03T13:07:03', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 675 | Trại Giam Hạnh Phúc | 03/12 18:30 | Phòng 1 | D7 D8
(3831, 8, NULL, '2026-12-03T13:07:55', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 675 | Trại Giam Hạnh Phúc | 03/12 18:30 | Phòng 1 | D5 D6
(3832, 9, 21, '2026-12-03T13:10:20', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 672 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 16:15 | Phòng 1 | D7 D8
(3833, 8, NULL, '2026-12-03T13:17:34', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 666 | Bí Kíp Luyện Cướp | 03/12 13:30 | Phòng 3 | E6 E7
(3834, 9, 32, '2026-12-03T13:20:48', 150000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 671 | Chị Chị Em Em 3 | 03/12 16:00 | Phòng 3 | C7 C8
(3835, 8, NULL, '2026-12-03T13:27:20', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 695 | Con Mắt Thứ Ba | 04/12 13:30 | Phòng 3 | D7 D8
(3836, 9, 117, '2026-12-03T13:27:27', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 738 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 21:00 | Phòng 4 | E4 E5
(3837, 9, NULL, '2026-12-03T13:29:58', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 680 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 21:00 | Phòng 4 | F6 F7
(3838, 8, 31, '2026-12-03T13:37:05', 324000, N'Paid', N'Cash', 324000, 22, 0, NULL, NULL, NULL), -- suat 670 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 15:30 | Phòng 4 | F5 F6 F7
(3839, 9, 3, '2026-12-03T13:37:07', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 667 | Trại Giam Hạnh Phúc | 03/12 13:45 | Phòng 1 | H6 H7
(3840, 9, NULL, '2026-12-03T13:42:16', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 675 | Trại Giam Hạnh Phúc | 03/12 18:30 | Phòng 1 | B6 B7
(3841, 9, NULL, '2026-12-03T13:47:23', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 682 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 03/12 21:45 | Phòng 2 | E5
(3842, 9, NULL, '2026-12-03T13:52:12', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-12-03T14:23:45', 9), -- suat 672 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 16:15 | Phòng 1 | D3 D4
(3843, 8, 46, '2026-12-03T14:24:45', 144000, N'Paid', N'Transfer', NULL, 10, 0, NULL, NULL, NULL), -- suat 710 | Godzilla Trừ Không | 04/12 21:15 | Phòng 5 | H9
(3844, 8, NULL, '2026-12-03T14:25:27', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 672 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 16:15 | Phòng 1 | J3 J4
(3845, 8, NULL, '2026-12-03T14:28:03', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 677 | Godzilla Trừ Không | 03/12 18:30 | Phòng 4 | A7 A8
(3846, 9, NULL, '2026-12-03T14:34:08', 270000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 672 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 16:15 | Phòng 1 | H6 H7 H8
(3847, 9, 67, '2026-12-03T14:50:20', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 684 | Trại Giam Hạnh Phúc | 04/12 09:00 | Phòng 1 | F6 F7
(3848, 3, NULL, '2026-12-03T15:00:51', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 712 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 3 | D5 D6
(3849, 3, NULL, '2026-12-03T15:03:24', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 694 | Hexed: Thế Giới Phép Thuật | 04/12 12:45 | Phòng 2 | G3 G4
(3850, 3, 113, '2026-12-03T15:04:55', 720000, N'Paid', N'Cash', 720000, 50, 0, NULL, NULL, NULL), -- suat 710 | Godzilla Trừ Không | 04/12 21:15 | Phòng 5 | K7 K8 K9 K10 K11
(3851, 3, NULL, '2026-12-03T15:06:40', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 707 | Bò Sữa Bay | 04/12 19:30 | Phòng 2 | C10 C11
(3852, 3, 42, '2026-12-03T15:13:58', 432000, N'Paid', N'Cash', 432000, 30, 0, NULL, NULL, NULL), -- suat 687 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 09:15 | Phòng 4 | H4 H5 H6 H7
(3853, 10, NULL, '2026-12-03T15:14:47', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 676 | Điểm Mù | 03/12 18:30 | Phòng 3 | H6 H7 H8 H9
(3854, 10, 108, '2026-12-03T15:20:54', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 726 | Ngày Con Còn Mẹ | 05/12 15:00 | Phòng 2 | G3 G4 G5
(3855, 3, NULL, '2026-12-03T15:24:40', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 706 | Godzilla Trừ Không | 04/12 18:30 | Phòng 4 | G8 G9
(3856, 3, NULL, '2026-12-03T15:28:31', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 683 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 21:45 | Phòng 3 | D6
(3857, 3, NULL, '2026-12-03T15:35:40', 300000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 675 | Trại Giam Hạnh Phúc | 03/12 18:30 | Phòng 1 | A5 A6 A7 A8
(3858, 10, NULL, '2026-12-03T15:38:09', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 736 | Bò Sữa Bay | 05/12 19:30 | Phòng 2 | J9 J10
(3859, 10, NULL, '2026-12-03T15:42:24', 324000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Sự cố phòng chiếu', '2026-12-03T17:02:03', 2), -- suat 677 | Godzilla Trừ Không | 03/12 18:30 | Phòng 4 | E7 E8 E9
(3860, 10, 25, '2026-12-03T15:42:28', 360000, N'Paid', N'Transfer', NULL, 36, 0, NULL, NULL, NULL), -- suat 682 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 03/12 21:45 | Phòng 2 | J5 J6 J7 J8
(3861, 10, NULL, '2026-12-03T15:53:14', 576000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 674 | Dune: Hành Tinh Cát - Phần Hai | 03/12 18:00 | Phòng 5 | F5 F6 F7 F8
(3862, 3, NULL, '2026-12-03T15:55:52', 432000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 686 | Dune: Hành Tinh Cát - Phần Hai | 04/12 09:00 | Phòng 5 | G7 G8 G9
(3863, 3, NULL, '2026-12-03T16:04:10', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 679 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 21:00 | Phòng 1 | E6 E7 E8
(3864, 3, NULL, '2026-12-03T16:08:05', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 679 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 21:00 | Phòng 1 | E10 E11
(3865, 10, NULL, '2026-12-03T16:11:37', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 701 | Mẹ Mìn: Giao Kèo Với Quỷ | 04/12 16:15 | Phòng 1 | A5 A6 A7
(3866, 3, NULL, '2026-12-03T16:11:40', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 680 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 21:00 | Phòng 4 | F5
(3867, 3, NULL, '2026-12-03T16:12:40', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 673 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 03/12 17:15 | Phòng 2 | B5 B6
(3868, 10, 34, '2026-12-03T16:15:05', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 712 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 3 | E6
(3869, 3, NULL, '2026-12-03T16:21:27', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 673 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 03/12 17:15 | Phòng 2 | C5 C6
(3870, 3, NULL, '2026-12-03T16:24:02', 450000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 676 | Điểm Mù | 03/12 18:30 | Phòng 3 | D7 D8 D9 D10 D11
(3871, 3, NULL, '2026-12-03T16:25:49', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 677 | Godzilla Trừ Không | 03/12 18:30 | Phòng 4 | C5 C6
(3872, 3, 47, '2026-12-03T16:28:11', 324000, N'Paid', N'Transfer', NULL, 22, 0, NULL, NULL, NULL), -- suat 680 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 21:00 | Phòng 4 | F8 F9 F10
(3873, 10, NULL, '2026-12-03T16:36:33', 225000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 723 | Hexed: Thế Giới Phép Thuật | 05/12 12:45 | Phòng 2 | B5 B6 B7
(3874, 10, 23, '2026-12-03T16:38:12', 180000, N'Paid', N'Cash', 180000, 18, 0, NULL, NULL, NULL), -- suat 673 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 03/12 17:15 | Phòng 2 | J7 J8
(3875, 10, NULL, '2026-12-03T16:39:33', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 721 | Ramayana: Khởi Nguồn Một Huyền Thoại | 05/12 12:15 | Phòng 4 | H5 H6
(3876, 3, 67, '2026-12-03T16:39:45', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 673 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 03/12 17:15 | Phòng 2 | F7 F8
(3877, 10, 58, '2026-12-03T16:42:57', 288000, N'Paid', N'Transfer', NULL, 28, 0, NULL, NULL, NULL), -- suat 674 | Dune: Hành Tinh Cát - Phần Hai | 03/12 18:00 | Phòng 5 | L1 L2
(3878, 3, NULL, '2026-12-03T16:44:47', 90000, N'Cancelled', N'Cash', 90000, 0, 0, N'Khách đổi ý', '2026-12-03T17:30:36', 3), -- suat 696 | Trại Giam Hạnh Phúc | 04/12 13:45 | Phòng 1 | G8
(3879, 10, 67, '2026-12-03T16:45:16', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 682 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 03/12 21:45 | Phòng 2 | G7 G8
(3880, 3, NULL, '2026-12-03T16:51:08', 108000, N'Paid', N'Cash', 110000, 0, 0, NULL, NULL, NULL), -- suat 677 | Godzilla Trừ Không | 03/12 18:30 | Phòng 4 | D7
(3881, 3, 87, '2026-12-03T16:54:53', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 675 | Trại Giam Hạnh Phúc | 03/12 18:30 | Phòng 1 | F6
(3882, 3, NULL, '2026-12-03T16:55:14', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 712 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 3 | D7 D8
(3883, 10, NULL, '2026-12-03T17:01:49', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 691 | Bắt Cá Ba Tay | 04/12 11:30 | Phòng 1 | D6 D7
(3884, 3, NULL, '2026-12-03T17:03:24', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 676 | Điểm Mù | 03/12 18:30 | Phòng 3 | D4 D5
(3885, 3, NULL, '2026-12-03T17:03:52', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 683 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 21:45 | Phòng 3 | F5 F6 F7
(3886, 3, NULL, '2026-12-03T17:06:02', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 736 | Bò Sữa Bay | 05/12 19:30 | Phòng 2 | G4 G5
(3887, 3, NULL, '2026-12-03T17:12:45', 150000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 676 | Điểm Mù | 03/12 18:30 | Phòng 3 | B8 B9
(3888, 3, NULL, '2026-12-03T17:13:27', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 676 | Điểm Mù | 03/12 18:30 | Phòng 3 | F6
(3889, 10, NULL, '2026-12-03T17:15:46', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 682 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 03/12 21:45 | Phòng 2 | D7
(3890, 10, NULL, '2026-12-03T17:16:31', 150000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 676 | Điểm Mù | 03/12 18:30 | Phòng 3 | B6 B7
(3891, 3, 17, '2026-12-03T17:23:26', 300000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 678 | Bò Sữa Bay | 03/12 19:30 | Phòng 2 | B1 B2 B3 B4
(3892, 10, NULL, '2026-12-03T17:35:04', 75000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 675 | Trại Giam Hạnh Phúc | 03/12 18:30 | Phòng 1 | B5
(3893, 3, NULL, '2026-12-03T17:38:21', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 684 | Trại Giam Hạnh Phúc | 04/12 09:00 | Phòng 1 | E5 E6
(3894, 10, NULL, '2026-12-03T17:40:41', 240000, N'Paid', N'Cash', 240000, 0, 0, NULL, NULL, NULL), -- suat 674 | Dune: Hành Tinh Cát - Phần Hai | 03/12 18:00 | Phòng 5 | A5 A6
(3895, 3, NULL, '2026-12-03T17:42:01', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 681 | Godzilla Trừ Không | 03/12 21:15 | Phòng 5 | J7 J8
(3896, 3, NULL, '2026-12-03T17:49:59', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 678 | Bò Sữa Bay | 03/12 19:30 | Phòng 2 | H6 H7 H8 H9
(3897, 3, 95, '2026-12-03T17:58:10', 324000, N'Paid', N'Cash', 330000, 22, 0, NULL, NULL, NULL), -- suat 677 | Godzilla Trừ Không | 03/12 18:30 | Phòng 4 | H4 H5 H6
(3898, 10, NULL, '2026-12-03T17:58:40', 576000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 703 | Dune: Hành Tinh Cát - Phần Hai | 04/12 18:00 | Phòng 5 | L3 L4 L5 L6
(3899, 10, NULL, '2026-12-03T18:00:00', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 675 | Trại Giam Hạnh Phúc | 03/12 18:30 | Phòng 1 | C5 C6
(3900, 10, 2, '2026-12-03T18:04:47', 180000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 675 | Trại Giam Hạnh Phúc | 03/12 18:30 | Phòng 1 | F7 F8
(3901, 10, NULL, '2026-12-03T18:05:46', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 685 | Hexed: Thế Giới Phép Thuật | 04/12 09:00 | Phòng 2 | E6 E7
(3902, 10, 88, '2026-12-03T18:11:29', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 680 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 21:00 | Phòng 4 | H5 H6
(3903, 3, NULL, '2026-12-03T18:14:28', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 682 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 03/12 21:45 | Phòng 2 | D8 D9
(3904, 10, NULL, '2026-12-03T18:14:38', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 675 | Trại Giam Hạnh Phúc | 03/12 18:30 | Phòng 1 | H7 H8
(3905, 3, 6, '2026-12-03T18:18:00', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 678 | Bò Sữa Bay | 03/12 19:30 | Phòng 2 | G5 G6
(3906, 10, NULL, '2026-12-03T18:18:33', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 675 | Trại Giam Hạnh Phúc | 03/12 18:30 | Phòng 1 | J9 J10
(3907, 3, NULL, '2026-12-03T18:29:49', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 702 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 04/12 17:15 | Phòng 2 | H4 H5 H6
(3908, 3, 21, '2026-12-03T18:31:08', 450000, N'Paid', N'Transfer', NULL, 22, 0, NULL, NULL, NULL), -- suat 678 | Bò Sữa Bay | 03/12 19:30 | Phòng 2 | B5 B6 B7 B8 B9 B10
(3909, 3, NULL, '2026-12-03T18:33:17', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 679 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 21:00 | Phòng 1 | F6 F7
(3910, 10, NULL, '2026-12-03T18:34:26', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 678 | Bò Sữa Bay | 03/12 19:30 | Phòng 2 | J1 J2
(3911, 3, NULL, '2026-12-03T18:39:30', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | E5
(3912, 10, NULL, '2026-12-03T18:39:31', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 679 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 21:00 | Phòng 1 | H8
(3913, 3, NULL, '2026-12-03T18:44:33', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 683 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 21:45 | Phòng 3 | H5 H6 H7
(3914, 10, NULL, '2026-12-03T18:55:46', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 681 | Godzilla Trừ Không | 03/12 21:15 | Phòng 5 | H6 H7
(3915, 3, 86, '2026-12-03T19:21:55', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 678 | Bò Sữa Bay | 03/12 19:30 | Phòng 2 | G7
(3916, 3, 87, '2026-12-03T19:26:29', 288000, N'Paid', N'Card', NULL, 28, 0, NULL, NULL, NULL), -- suat 681 | Godzilla Trừ Không | 03/12 21:15 | Phòng 5 | L9 L10
(3917, 3, NULL, '2026-12-03T19:27:06', 120000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 681 | Godzilla Trừ Không | 03/12 21:15 | Phòng 5 | B8
(3918, 10, NULL, '2026-12-03T19:27:09', 90000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 689 | Ma Mút Con Vượt Kỷ Băng Hà | 04/12 11:15 | Phòng 2 | F7
(3919, 3, 37, '2026-12-03T19:37:01', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 684 | Trại Giam Hạnh Phúc | 04/12 09:00 | Phòng 1 | H6 H7 H8
(3920, 3, NULL, '2026-12-03T19:43:24', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 680 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 03/12 21:00 | Phòng 4 | J3 J4
(3921, 10, NULL, '2026-12-03T19:52:25', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 739 | Godzilla Trừ Không | 05/12 21:15 | Phòng 5 | F8 F9
(3922, 10, NULL, '2026-12-03T19:55:35', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 708 | Trại Giam Hạnh Phúc | 04/12 21:00 | Phòng 1 | E3 E4 E5
(3923, 10, NULL, '2026-12-03T19:56:21', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 679 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 21:00 | Phòng 1 | C6 C7
(3924, 3, NULL, '2026-12-03T20:09:03', 576000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 681 | Godzilla Trừ Không | 03/12 21:15 | Phòng 5 | E4 E5 E6 E7
(3925, 3, NULL, '2026-12-03T20:12:46', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 681 | Godzilla Trừ Không | 03/12 21:15 | Phòng 5 | F8
(3926, 3, NULL, '2026-12-03T20:16:18', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 682 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 03/12 21:45 | Phòng 2 | E6 E7
(3927, 3, NULL, '2026-12-03T20:18:26', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 681 | Godzilla Trừ Không | 03/12 21:15 | Phòng 5 | K7
(3928, 3, NULL, '2026-12-03T20:18:42', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 679 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 21:00 | Phòng 1 | J1 J2
(3929, 10, NULL, '2026-12-03T20:24:04', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 683 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 21:45 | Phòng 3 | C6 C7
(3930, 3, NULL, '2026-12-03T20:24:08', 75000, N'Paid', N'Cash', 80000, 0, 0, NULL, NULL, NULL), -- suat 679 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 21:00 | Phòng 1 | A5
(3931, 10, 28, '2026-12-03T20:24:43', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 698 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 15:00 | Phòng 5 | G8 G9
(3932, 10, 23, '2026-12-03T20:26:08', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 712 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 3 | F5 F6
(3933, 3, NULL, '2026-12-03T20:33:26', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 681 | Godzilla Trừ Không | 03/12 21:15 | Phòng 5 | H8
(3934, 10, 117, '2026-12-03T21:04:03', 360000, N'Paid', N'Transfer', NULL, 36, 0, NULL, NULL, NULL), -- suat 683 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 21:45 | Phòng 3 | J5 J6 J7 J8
(3935, 10, 55, '2026-12-03T21:05:10', 240000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 681 | Godzilla Trừ Không | 03/12 21:15 | Phòng 5 | B6 B7
(3936, 3, NULL, '2026-12-03T21:05:33', 150000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 682 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 03/12 21:45 | Phòng 2 | A6 A7
(3937, 10, NULL, '2026-12-03T21:13:06', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 709 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 21:00 | Phòng 4 | D2 D3 D4 D5
(3938, 3, 93, '2026-12-03T21:23:33', 180000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 683 | Mẹ Mìn: Giao Kèo Với Quỷ | 03/12 21:45 | Phòng 3 | F9 F10
(3939, 10, 116, '2026-12-03T21:30:12', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 701 | Mẹ Mìn: Giao Kèo Với Quỷ | 04/12 16:15 | Phòng 1 | H4 H5
(3940, 3, 46, '2026-12-03T21:36:05', 450000, N'Paid', N'Transfer', NULL, 31, 0, NULL, NULL, NULL); -- suat 685 | Hexed: Thế Giới Phép Thuật | 04/12 09:00 | Phòng 2 | G4 G5 G6 G7 G8
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(8630, 3767, 656, 2, 112, 75000, N'Active'),
(8631, 3767, 656, 2, 113, 75000, N'Active'),
(8632, 3767, 656, 2, 114, 75000, N'Active'),
(8633, 3767, 656, 2, 115, 75000, N'Active'),
(8634, 3768, 695, 3, 306, 90000, N'Cancelled'),
(8635, 3768, 695, 3, 307, 90000, N'Cancelled'),
(8636, 3769, 658, 4, 423, 108000, N'Active'),
(8637, 3769, 658, 4, 424, 108000, N'Active'),
(8638, 3770, 670, 4, 401, 108000, N'Active'),
(8639, 3770, 670, 4, 402, 108000, N'Active'),
(8640, 3770, 670, 4, 403, 108000, N'Active'),
(8641, 3770, 670, 4, 404, 108000, N'Active'),
(8642, 3771, 663, 4, 378, 108000, N'Active'),
(8643, 3771, 663, 4, 379, 108000, N'Active'),
(8644, 3772, 665, 2, 187, 90000, N'Active'),
(8645, 3773, 661, 3, 258, 90000, N'Active'),
(8646, 3774, 702, 2, 174, 90000, N'Active'),
(8647, 3774, 702, 2, 175, 90000, N'Active'),
(8648, 3775, 659, 3, 257, 90000, N'Active'),
(8649, 3775, 659, 3, 258, 90000, N'Active'),
(8650, 3775, 659, 3, 259, 90000, N'Active'),
(8651, 3775, 659, 3, 260, 90000, N'Active'),
(8652, 3776, 674, 5, 485, 144000, N'Active'),
(8653, 3776, 674, 5, 486, 144000, N'Active'),
(8654, 3777, 662, 1, 66, 90000, N'Active'),
(8655, 3777, 662, 1, 67, 90000, N'Active'),
(8656, 3778, 655, 1, 89, 90000, N'Cancelled'),
(8657, 3779, 662, 1, 53, 90000, N'Active'),
(8658, 3779, 662, 1, 54, 90000, N'Active'),
(8659, 3780, 674, 5, 494, 144000, N'Active'),
(8660, 3780, 674, 5, 495, 144000, N'Active'),
(8661, 3781, 660, 2, 162, 90000, N'Active'),
(8662, 3781, 660, 2, 163, 90000, N'Active'),
(8663, 3782, 663, 4, 367, 108000, N'Active'),
(8664, 3782, 663, 4, 368, 108000, N'Active'),
(8665, 3783, 710, 5, 545, 144000, N'Active'),
(8666, 3783, 710, 5, 546, 144000, N'Active'),
(8667, 3784, 690, 3, 292, 90000, N'Active'),
(8668, 3785, 667, 1, 30, 75000, N'Active'),
(8669, 3786, 668, 2, 201, 90000, N'Active'),
(8670, 3786, 668, 2, 202, 90000, N'Active'),
(8671, 3786, 668, 2, 203, 90000, N'Active'),
(8672, 3787, 705, 3, 286, 90000, N'Active'),
(8673, 3787, 705, 3, 287, 90000, N'Active'),
(8674, 3787, 705, 3, 288, 90000, N'Active'),
(8675, 3788, 664, 5, 438, 120000, N'Active'),
(8676, 3788, 664, 5, 439, 120000, N'Active'),
(8677, 3789, 663, 4, 365, 108000, N'Active'),
(8678, 3789, 663, 4, 366, 108000, N'Active'),
(8679, 3790, 668, 2, 199, 90000, N'Active'),
(8680, 3790, 668, 2, 200, 90000, N'Active'),
(8681, 3791, 694, 2, 186, 90000, N'Active'),
(8682, 3791, 694, 2, 187, 90000, N'Active'),
(8683, 3792, 712, 3, 246, 75000, N'Active'),
(8684, 3793, 733, 1, 66, 90000, N'Active'),
(8685, 3793, 733, 1, 67, 90000, N'Active'),
(8686, 3794, 661, 3, 244, 75000, N'Active'),
(8687, 3794, 661, 3, 245, 75000, N'Active'),
(8688, 3794, 661, 3, 246, 75000, N'Active'),
(8689, 3795, 697, 2, 150, 90000, N'Active'),
(8690, 3795, 697, 2, 151, 90000, N'Active'),
(8691, 3796, 729, 4, 377, 108000, N'Active'),
(8692, 3796, 729, 4, 378, 108000, N'Active'),
(8693, 3797, 706, 4, 365, 108000, N'Active'),
(8694, 3797, 706, 4, 366, 108000, N'Active'),
(8695, 3797, 706, 4, 367, 108000, N'Active'),
(8696, 3797, 706, 4, 368, 108000, N'Active'),
(8697, 3798, 677, 4, 390, 108000, N'Active'),
(8698, 3798, 677, 4, 391, 108000, N'Active'),
(8699, 3799, 662, 1, 20, 75000, N'Active'),
(8700, 3800, 667, 1, 18, 75000, N'Active'),
(8701, 3800, 667, 1, 19, 75000, N'Active'),
(8702, 3801, 665, 2, 197, 90000, N'Active'),
(8703, 3801, 665, 2, 198, 90000, N'Active'),
(8704, 3802, 697, 2, 148, 90000, N'Active'),
(8705, 3802, 697, 2, 149, 90000, N'Active'),
(8706, 3803, 704, 1, 93, 90000, N'Active'),
(8707, 3804, 663, 4, 353, 90000, N'Active'),
(8708, 3804, 663, 4, 354, 90000, N'Active'),
(8709, 3805, 663, 4, 369, 108000, N'Active'),
(8710, 3805, 663, 4, 370, 108000, N'Active'),
(8711, 3806, 665, 2, 138, 75000, N'Active'),
(8712, 3806, 665, 2, 139, 75000, N'Active'),
(8713, 3807, 668, 2, 187, 90000, N'Active'),
(8714, 3807, 668, 2, 188, 90000, N'Active'),
(8715, 3808, 673, 2, 128, 75000, N'Active'),
(8716, 3808, 673, 2, 129, 75000, N'Active'),
(8717, 3809, 671, 3, 292, 90000, N'Active'),
(8718, 3809, 671, 3, 293, 90000, N'Active'),
(8719, 3809, 671, 3, 294, 90000, N'Active'),
(8720, 3809, 671, 3, 295, 90000, N'Active'),
(8721, 3810, 664, 5, 521, 144000, N'Active'),
(8722, 3810, 664, 5, 522, 144000, N'Active'),
(8723, 3810, 664, 5, 523, 144000, N'Active'),
(8724, 3810, 664, 5, 524, 144000, N'Active'),
(8725, 3811, 696, 1, 66, 90000, N'Active'),
(8726, 3811, 696, 1, 67, 90000, N'Active'),
(8727, 3812, 663, 4, 414, 108000, N'Active'),
(8728, 3813, 734, 3, 285, 90000, N'Active'),
(8729, 3813, 734, 3, 286, 90000, N'Active'),
(8730, 3814, 676, 3, 244, 75000, N'Active'),
(8731, 3814, 676, 3, 245, 75000, N'Active'),
(8732, 3815, 663, 4, 377, 108000, N'Active'),
(8733, 3816, 666, 3, 306, 90000, N'Active'),
(8734, 3817, 665, 2, 125, 75000, N'Active'),
(8735, 3817, 665, 2, 126, 75000, N'Active'),
(8736, 3817, 665, 2, 127, 75000, N'Active'),
(8737, 3818, 666, 3, 282, 90000, N'Active'),
(8738, 3818, 666, 3, 283, 90000, N'Active'),
(8739, 3819, 670, 4, 377, 108000, N'Active'),
(8740, 3819, 670, 4, 378, 108000, N'Active'),
(8741, 3820, 665, 2, 129, 75000, N'Active'),
(8742, 3821, 690, 3, 269, 90000, N'Active'),
(8743, 3821, 690, 3, 270, 90000, N'Active'),
(8744, 3821, 690, 3, 271, 90000, N'Active'),
(8745, 3821, 690, 3, 272, 90000, N'Active'),
(8746, 3822, 686, 5, 487, 144000, N'Active'),
(8747, 3822, 686, 5, 488, 144000, N'Active'),
(8748, 3823, 673, 2, 213, 90000, N'Active'),
(8749, 3823, 673, 2, 214, 90000, N'Active'),
(8750, 3824, 670, 4, 379, 108000, N'Active'),
(8751, 3824, 670, 4, 380, 108000, N'Active'),
(8752, 3825, 667, 1, 55, 90000, N'Active'),
(8753, 3825, 667, 1, 56, 90000, N'Active'),
(8754, 3826, 667, 1, 7, 75000, N'Active'),
(8755, 3826, 667, 1, 8, 75000, N'Active'),
(8756, 3827, 674, 5, 547, 144000, N'Active'),
(8757, 3827, 674, 5, 548, 144000, N'Active'),
(8758, 3828, 702, 2, 126, 75000, N'Active'),
(8759, 3829, 730, 1, 52, 90000, N'Active'),
(8760, 3829, 730, 1, 53, 90000, N'Active'),
(8761, 3830, 675, 1, 43, 90000, N'Active'),
(8762, 3830, 675, 1, 44, 90000, N'Active'),
(8763, 3831, 675, 1, 41, 90000, N'Active'),
(8764, 3831, 675, 1, 42, 90000, N'Active'),
(8765, 3832, 672, 1, 43, 90000, N'Active'),
(8766, 3832, 672, 1, 44, 90000, N'Active'),
(8767, 3833, 666, 3, 270, 90000, N'Active'),
(8768, 3833, 666, 3, 271, 90000, N'Active'),
(8769, 3834, 671, 3, 247, 75000, N'Active'),
(8770, 3834, 671, 3, 248, 75000, N'Active'),
(8771, 3835, 695, 3, 259, 90000, N'Active'),
(8772, 3835, 695, 3, 260, 90000, N'Active'),
(8773, 3836, 738, 4, 376, 108000, N'Active'),
(8774, 3836, 738, 4, 377, 108000, N'Active'),
(8775, 3837, 680, 4, 390, 108000, N'Active'),
(8776, 3837, 680, 4, 391, 108000, N'Active'),
(8777, 3838, 670, 4, 389, 108000, N'Active'),
(8778, 3838, 670, 4, 390, 108000, N'Active'),
(8779, 3838, 670, 4, 391, 108000, N'Active'),
(8780, 3839, 667, 1, 90, 90000, N'Active'),
(8781, 3839, 667, 1, 91, 90000, N'Active'),
(8782, 3840, 675, 1, 18, 75000, N'Active'),
(8783, 3840, 675, 1, 19, 75000, N'Active'),
(8784, 3841, 682, 2, 161, 90000, N'Active'),
(8785, 3842, 672, 1, 39, 90000, N'Cancelled'),
(8786, 3842, 672, 1, 40, 90000, N'Cancelled'),
(8787, 3843, 710, 5, 525, 144000, N'Active'),
(8788, 3844, 672, 1, 99, 90000, N'Active'),
(8789, 3844, 672, 1, 100, 90000, N'Active'),
(8790, 3845, 677, 4, 331, 90000, N'Active'),
(8791, 3845, 677, 4, 332, 90000, N'Active'),
(8792, 3846, 672, 1, 90, 90000, N'Active'),
(8793, 3846, 672, 1, 91, 90000, N'Active'),
(8794, 3846, 672, 1, 92, 90000, N'Active'),
(8795, 3847, 684, 1, 66, 90000, N'Active'),
(8796, 3847, 684, 1, 67, 90000, N'Active'),
(8797, 3848, 712, 3, 257, 90000, N'Active'),
(8798, 3848, 712, 3, 258, 90000, N'Active'),
(8799, 3849, 694, 2, 183, 90000, N'Active'),
(8800, 3849, 694, 2, 184, 90000, N'Active'),
(8801, 3850, 710, 5, 547, 144000, N'Active'),
(8802, 3850, 710, 5, 548, 144000, N'Active'),
(8803, 3850, 710, 5, 549, 144000, N'Active'),
(8804, 3850, 710, 5, 550, 144000, N'Active'),
(8805, 3850, 710, 5, 551, 144000, N'Active'),
(8806, 3851, 707, 2, 142, 75000, N'Active'),
(8807, 3851, 707, 2, 143, 75000, N'Active'),
(8808, 3852, 687, 4, 412, 108000, N'Active'),
(8809, 3852, 687, 4, 413, 108000, N'Active'),
(8810, 3852, 687, 4, 414, 108000, N'Active'),
(8811, 3852, 687, 4, 415, 108000, N'Active'),
(8812, 3853, 676, 3, 306, 90000, N'Active'),
(8813, 3853, 676, 3, 307, 90000, N'Active'),
(8814, 3853, 676, 3, 308, 90000, N'Active'),
(8815, 3853, 676, 3, 309, 90000, N'Active'),
(8816, 3854, 726, 2, 183, 90000, N'Active'),
(8817, 3854, 726, 2, 184, 90000, N'Active'),
(8818, 3854, 726, 2, 185, 90000, N'Active'),
(8819, 3855, 706, 4, 404, 108000, N'Active'),
(8820, 3855, 706, 4, 405, 108000, N'Active'),
(8821, 3856, 683, 3, 258, 90000, N'Active'),
(8822, 3857, 675, 1, 5, 75000, N'Active'),
(8823, 3857, 675, 1, 6, 75000, N'Active'),
(8824, 3857, 675, 1, 7, 75000, N'Active'),
(8825, 3857, 675, 1, 8, 75000, N'Active'),
(8826, 3858, 736, 2, 213, 90000, N'Active'),
(8827, 3858, 736, 2, 214, 90000, N'Active'),
(8828, 3859, 677, 4, 379, 108000, N'Cancelled'),
(8829, 3859, 677, 4, 380, 108000, N'Cancelled'),
(8830, 3859, 677, 4, 381, 108000, N'Cancelled'),
(8831, 3860, 682, 2, 209, 90000, N'Active'),
(8832, 3860, 682, 2, 210, 90000, N'Active'),
(8833, 3860, 682, 2, 211, 90000, N'Active'),
(8834, 3860, 682, 2, 212, 90000, N'Active'),
(8835, 3861, 674, 5, 497, 144000, N'Active'),
(8836, 3861, 674, 5, 498, 144000, N'Active'),
(8837, 3861, 674, 5, 499, 144000, N'Active'),
(8838, 3861, 674, 5, 500, 144000, N'Active'),
(8839, 3862, 686, 5, 511, 144000, N'Active'),
(8840, 3862, 686, 5, 512, 144000, N'Active'),
(8841, 3862, 686, 5, 513, 144000, N'Active'),
(8842, 3863, 679, 1, 54, 90000, N'Active'),
(8843, 3863, 679, 1, 55, 90000, N'Active'),
(8844, 3863, 679, 1, 56, 90000, N'Active'),
(8845, 3864, 679, 1, 58, 90000, N'Active'),
(8846, 3864, 679, 1, 59, 90000, N'Active'),
(8847, 3865, 701, 1, 5, 75000, N'Active'),
(8848, 3865, 701, 1, 6, 75000, N'Active'),
(8849, 3865, 701, 1, 7, 75000, N'Active'),
(8850, 3866, 680, 4, 389, 108000, N'Active'),
(8851, 3867, 673, 2, 125, 75000, N'Active'),
(8852, 3867, 673, 2, 126, 75000, N'Active'),
(8853, 3868, 712, 3, 270, 90000, N'Active'),
(8854, 3869, 673, 2, 137, 75000, N'Active'),
(8855, 3869, 673, 2, 138, 75000, N'Active'),
(8856, 3870, 676, 3, 259, 90000, N'Active'),
(8857, 3870, 676, 3, 260, 90000, N'Active'),
(8858, 3870, 676, 3, 261, 90000, N'Active'),
(8859, 3870, 676, 3, 262, 90000, N'Active'),
(8860, 3870, 676, 3, 263, 90000, N'Active'),
(8861, 3871, 677, 4, 353, 90000, N'Active'),
(8862, 3871, 677, 4, 354, 90000, N'Active'),
(8863, 3872, 680, 4, 392, 108000, N'Active'),
(8864, 3872, 680, 4, 393, 108000, N'Active'),
(8865, 3872, 680, 4, 394, 108000, N'Active'),
(8866, 3873, 723, 2, 125, 75000, N'Active'),
(8867, 3873, 723, 2, 126, 75000, N'Active'),
(8868, 3873, 723, 2, 127, 75000, N'Active'),
(8869, 3874, 673, 2, 211, 90000, N'Active'),
(8870, 3874, 673, 2, 212, 90000, N'Active'),
(8871, 3875, 721, 4, 413, 108000, N'Active'),
(8872, 3875, 721, 4, 414, 108000, N'Active'),
(8873, 3876, 673, 2, 175, 90000, N'Active'),
(8874, 3876, 673, 2, 176, 90000, N'Active'),
(8875, 3877, 674, 5, 553, 144000, N'Active'),
(8876, 3877, 674, 5, 554, 144000, N'Active'),
(8877, 3878, 696, 1, 80, 90000, N'Cancelled'),
(8878, 3879, 682, 2, 187, 90000, N'Active'),
(8879, 3879, 682, 2, 188, 90000, N'Active'),
(8880, 3880, 677, 4, 367, 108000, N'Active'),
(8881, 3881, 675, 1, 66, 90000, N'Active'),
(8882, 3882, 712, 3, 259, 90000, N'Active'),
(8883, 3882, 712, 3, 260, 90000, N'Active'),
(8884, 3883, 691, 1, 42, 90000, N'Active'),
(8885, 3883, 691, 1, 43, 90000, N'Active'),
(8886, 3884, 676, 3, 256, 90000, N'Active'),
(8887, 3884, 676, 3, 257, 90000, N'Active'),
(8888, 3885, 683, 3, 281, 90000, N'Active'),
(8889, 3885, 683, 3, 282, 90000, N'Active'),
(8890, 3885, 683, 3, 283, 90000, N'Active'),
(8891, 3886, 736, 2, 184, 90000, N'Active'),
(8892, 3886, 736, 2, 185, 90000, N'Active'),
(8893, 3887, 676, 3, 236, 75000, N'Active'),
(8894, 3887, 676, 3, 237, 75000, N'Active'),
(8895, 3888, 676, 3, 282, 90000, N'Active'),
(8896, 3889, 682, 2, 151, 90000, N'Active'),
(8897, 3890, 676, 3, 234, 75000, N'Active'),
(8898, 3890, 676, 3, 235, 75000, N'Active'),
(8899, 3891, 678, 2, 121, 75000, N'Active'),
(8900, 3891, 678, 2, 122, 75000, N'Active'),
(8901, 3891, 678, 2, 123, 75000, N'Active'),
(8902, 3891, 678, 2, 124, 75000, N'Active'),
(8903, 3892, 675, 1, 17, 75000, N'Active'),
(8904, 3893, 684, 1, 53, 90000, N'Active'),
(8905, 3893, 684, 1, 54, 90000, N'Active'),
(8906, 3894, 674, 5, 437, 120000, N'Active'),
(8907, 3894, 674, 5, 438, 120000, N'Active'),
(8908, 3895, 681, 5, 535, 144000, N'Active'),
(8909, 3895, 681, 5, 536, 144000, N'Active'),
(8910, 3896, 678, 2, 198, 90000, N'Active'),
(8911, 3896, 678, 2, 199, 90000, N'Active'),
(8912, 3896, 678, 2, 200, 90000, N'Active'),
(8913, 3896, 678, 2, 201, 90000, N'Active'),
(8914, 3897, 677, 4, 412, 108000, N'Active'),
(8915, 3897, 677, 4, 413, 108000, N'Active'),
(8916, 3897, 677, 4, 414, 108000, N'Active'),
(8917, 3898, 703, 5, 555, 144000, N'Active'),
(8918, 3898, 703, 5, 556, 144000, N'Active'),
(8919, 3898, 703, 5, 557, 144000, N'Active'),
(8920, 3898, 703, 5, 558, 144000, N'Active'),
(8921, 3899, 675, 1, 29, 75000, N'Active'),
(8922, 3899, 675, 1, 30, 75000, N'Active'),
(8923, 3900, 675, 1, 67, 90000, N'Active'),
(8924, 3900, 675, 1, 68, 90000, N'Active'),
(8925, 3901, 685, 2, 162, 90000, N'Active'),
(8926, 3901, 685, 2, 163, 90000, N'Active'),
(8927, 3902, 680, 4, 413, 108000, N'Active'),
(8928, 3902, 680, 4, 414, 108000, N'Active'),
(8929, 3903, 682, 2, 152, 90000, N'Active'),
(8930, 3903, 682, 2, 153, 90000, N'Active'),
(8931, 3904, 675, 1, 91, 90000, N'Active'),
(8932, 3904, 675, 1, 92, 90000, N'Active'),
(8933, 3905, 678, 2, 185, 90000, N'Active'),
(8934, 3905, 678, 2, 186, 90000, N'Active'),
(8935, 3906, 675, 1, 105, 90000, N'Active'),
(8936, 3906, 675, 1, 106, 90000, N'Active'),
(8937, 3907, 702, 2, 196, 90000, N'Active'),
(8938, 3907, 702, 2, 197, 90000, N'Active'),
(8939, 3907, 702, 2, 198, 90000, N'Active'),
(8940, 3908, 678, 2, 125, 75000, N'Active'),
(8941, 3908, 678, 2, 126, 75000, N'Active'),
(8942, 3908, 678, 2, 127, 75000, N'Active'),
(8943, 3908, 678, 2, 128, 75000, N'Active'),
(8944, 3908, 678, 2, 129, 75000, N'Active'),
(8945, 3908, 678, 2, 130, 75000, N'Active'),
(8946, 3909, 679, 1, 66, 90000, N'Active'),
(8947, 3909, 679, 1, 67, 90000, N'Active'),
(8948, 3910, 678, 2, 205, 90000, N'Active'),
(8949, 3910, 678, 2, 206, 90000, N'Active'),
(8950, 3911, 704, 1, 53, 90000, N'Active'),
(8951, 3912, 679, 1, 92, 90000, N'Active'),
(8952, 3913, 683, 3, 305, 90000, N'Active'),
(8953, 3913, 683, 3, 306, 90000, N'Active'),
(8954, 3913, 683, 3, 307, 90000, N'Active'),
(8955, 3914, 681, 5, 522, 144000, N'Active'),
(8956, 3914, 681, 5, 523, 144000, N'Active'),
(8957, 3915, 678, 2, 187, 90000, N'Active'),
(8958, 3916, 681, 5, 561, 144000, N'Active'),
(8959, 3916, 681, 5, 562, 144000, N'Active'),
(8960, 3917, 681, 5, 452, 120000, N'Active'),
(8961, 3918, 689, 2, 175, 90000, N'Active'),
(8962, 3919, 684, 1, 90, 90000, N'Active'),
(8963, 3919, 684, 1, 91, 90000, N'Active'),
(8964, 3919, 684, 1, 92, 90000, N'Active'),
(8965, 3920, 680, 4, 423, 108000, N'Active'),
(8966, 3920, 680, 4, 424, 108000, N'Active'),
(8967, 3921, 739, 5, 500, 144000, N'Active'),
(8968, 3921, 739, 5, 501, 144000, N'Active'),
(8969, 3922, 708, 1, 51, 90000, N'Active'),
(8970, 3922, 708, 1, 52, 90000, N'Active'),
(8971, 3922, 708, 1, 53, 90000, N'Active'),
(8972, 3923, 679, 1, 30, 75000, N'Active'),
(8973, 3923, 679, 1, 31, 75000, N'Active'),
(8974, 3924, 681, 5, 484, 144000, N'Active'),
(8975, 3924, 681, 5, 485, 144000, N'Active'),
(8976, 3924, 681, 5, 486, 144000, N'Active'),
(8977, 3924, 681, 5, 487, 144000, N'Active'),
(8978, 3925, 681, 5, 500, 144000, N'Active'),
(8979, 3926, 682, 2, 162, 90000, N'Active'),
(8980, 3926, 682, 2, 163, 90000, N'Active'),
(8981, 3927, 681, 5, 547, 144000, N'Active'),
(8982, 3928, 679, 1, 97, 90000, N'Active'),
(8983, 3928, 679, 1, 98, 90000, N'Active'),
(8984, 3929, 683, 3, 246, 75000, N'Active'),
(8985, 3929, 683, 3, 247, 75000, N'Active'),
(8986, 3930, 679, 1, 5, 75000, N'Active'),
(8987, 3931, 698, 5, 512, 144000, N'Active'),
(8988, 3931, 698, 5, 513, 144000, N'Active'),
(8989, 3932, 712, 3, 281, 90000, N'Active'),
(8990, 3932, 712, 3, 282, 90000, N'Active'),
(8991, 3933, 681, 5, 524, 144000, N'Active'),
(8992, 3934, 683, 3, 317, 90000, N'Active'),
(8993, 3934, 683, 3, 318, 90000, N'Active'),
(8994, 3934, 683, 3, 319, 90000, N'Active'),
(8995, 3934, 683, 3, 320, 90000, N'Active'),
(8996, 3935, 681, 5, 450, 120000, N'Active'),
(8997, 3935, 681, 5, 451, 120000, N'Active'),
(8998, 3936, 682, 2, 114, 75000, N'Active'),
(8999, 3936, 682, 2, 115, 75000, N'Active'),
(9000, 3937, 709, 4, 362, 108000, N'Active'),
(9001, 3937, 709, 4, 363, 108000, N'Active'),
(9002, 3937, 709, 4, 364, 108000, N'Active'),
(9003, 3937, 709, 4, 365, 108000, N'Active'),
(9004, 3938, 683, 3, 285, 90000, N'Active'),
(9005, 3938, 683, 3, 286, 90000, N'Active'),
(9006, 3939, 701, 1, 88, 90000, N'Active'),
(9007, 3939, 701, 1, 89, 90000, N'Active'),
(9008, 3940, 685, 2, 184, 90000, N'Active'),
(9009, 3940, 685, 2, 185, 90000, N'Active'),
(9010, 3940, 685, 2, 186, 90000, N'Active'),
(9011, 3940, 685, 2, 187, 90000, N'Active'),
(9012, 3940, 685, 2, 188, 90000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 6 04/12/2026: 216 hoa don (8 huy), 511 ve, doanh thu 47.447.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(3941, 5, NULL, '2026-12-04T08:05:02', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 728 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 15:30 | Phòng 3 | A7 A8
(3942, 5, NULL, '2026-12-04T08:16:44', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 694 | Hexed: Thế Giới Phép Thuật | 04/12 12:45 | Phòng 2 | B5 B6
(3943, 3, 78, '2026-12-04T08:17:14', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 684 | Trại Giam Hạnh Phúc | 04/12 09:00 | Phòng 1 | F8 F9
(3944, 3, NULL, '2026-12-04T08:26:01', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 687 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 09:15 | Phòng 4 | F7 F8
(3945, 4, NULL, '2026-12-04T08:28:19', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 692 | Ramayana: Khởi Nguồn Một Huyền Thoại | 04/12 12:15 | Phòng 4 | J7 J8
(3946, 5, NULL, '2026-12-04T08:32:55', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | H2 H3
(3947, 3, NULL, '2026-12-04T08:37:27', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 691 | Bắt Cá Ba Tay | 04/12 11:30 | Phòng 1 | H5
(3948, 4, NULL, '2026-12-04T08:39:56', 150000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 689 | Ma Mút Con Vượt Kỷ Băng Hà | 04/12 11:15 | Phòng 2 | A6 A7
(3949, 3, NULL, '2026-12-04T08:58:55', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 688 | Kiến Lé Phiêu Lưu Ké | 04/12 09:30 | Phòng 3 | G6 G7
(3950, 5, 90, '2026-12-04T09:16:22', 150000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 688 | Kiến Lé Phiêu Lưu Ké | 04/12 09:30 | Phòng 3 | A6 A7
(3951, 4, 59, '2026-12-04T09:18:20', 225000, N'Paid', N'Cash', 225000, 11, 0, NULL, NULL, NULL), -- suat 713 | Trại Giam Hạnh Phúc | 05/12 09:00 | Phòng 1 | C7 C8 C9
(3952, 5, NULL, '2026-12-04T09:18:24', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 693 | Godzilla Trừ Không | 04/12 12:15 | Phòng 5 | L7 L8
(3953, 3, 114, '2026-12-04T09:19:56', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 688 | Kiến Lé Phiêu Lưu Ké | 04/12 09:30 | Phòng 3 | D6
(3954, 4, 109, '2026-12-04T09:23:06', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 690 | Ngày Con Còn Mẹ | 04/12 11:15 | Phòng 3 | G5 G6 G7 G8
(3955, 5, NULL, '2026-12-04T09:24:59', 864000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 703 | Dune: Hành Tinh Cát - Phần Hai | 04/12 18:00 | Phòng 5 | J4 J5 J6 J7 J8 J9
(3956, 4, NULL, '2026-12-04T09:25:33', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 692 | Ramayana: Khởi Nguồn Một Huyền Thoại | 04/12 12:15 | Phòng 4 | G5 G6
(3957, 5, NULL, '2026-12-04T09:26:44', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 735 | Godzilla Trừ Không | 05/12 18:30 | Phòng 4 | F7 F8 F9 F10
(3958, 3, 8, '2026-12-04T09:27:19', 432000, N'Paid', N'Cash', 432000, 30, 0, NULL, NULL, NULL), -- suat 693 | Godzilla Trừ Không | 04/12 12:15 | Phòng 5 | E6 E7 E8
(3959, 5, NULL, '2026-12-04T09:49:58', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 699 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 04/12 15:30 | Phòng 3 | F2 F3
(3960, 5, NULL, '2026-12-04T09:57:50', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 693 | Godzilla Trừ Không | 04/12 12:15 | Phòng 5 | G7 G8
(3961, 4, NULL, '2026-12-04T09:58:19', 180000, N'Cancelled', N'Card', NULL, 0, 0, N'Khách đổi ý', '2026-12-04T11:08:13', 4), -- suat 707 | Bò Sữa Bay | 04/12 19:30 | Phòng 2 | E9 E10
(3962, 3, 78, '2026-12-04T10:05:07', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 723 | Hexed: Thế Giới Phép Thuật | 05/12 12:45 | Phòng 2 | E6 E7
(3963, 4, 109, '2026-12-04T10:06:48', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 731 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 17:15 | Phòng 2 | J9 J10
(3964, 4, NULL, '2026-12-04T10:06:51', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 689 | Ma Mút Con Vượt Kỷ Băng Hà | 04/12 11:15 | Phòng 2 | E6 E7
(3965, 4, NULL, '2026-12-04T10:18:13', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 769 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 2 | E9
(3966, 5, NULL, '2026-12-04T10:23:44', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 735 | Godzilla Trừ Không | 05/12 18:30 | Phòng 4 | C6 C7
(3967, 3, NULL, '2026-12-04T10:30:48', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 726 | Ngày Con Còn Mẹ | 05/12 15:00 | Phòng 2 | G6 G7
(3968, 4, NULL, '2026-12-04T10:32:11', 90000, N'Cancelled', N'Cash', 90000, 0, 0, N'Lỗi thanh toán', '2026-12-04T10:36:06', 4), -- suat 695 | Con Mắt Thứ Ba | 04/12 13:30 | Phòng 3 | D6
(3969, 5, 94, '2026-12-04T10:42:30', 432000, N'Cancelled', N'Transfer', NULL, 30, 0, N'Khách đổi ý', '2026-12-04T11:49:50', 5), -- suat 692 | Ramayana: Khởi Nguồn Một Huyền Thoại | 04/12 12:15 | Phòng 4 | H4 H5 H6 H7
(3970, 3, NULL, '2026-12-04T10:43:39', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 736 | Bò Sữa Bay | 05/12 19:30 | Phòng 2 | H5 H6
(3971, 4, NULL, '2026-12-04T10:50:04', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 691 | Bắt Cá Ba Tay | 04/12 11:30 | Phòng 1 | E5 E6 E7
(3972, 5, NULL, '2026-12-04T10:58:50', 150000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Sự cố phòng chiếu', '2026-12-04T12:26:35', 1), -- suat 695 | Con Mắt Thứ Ba | 04/12 13:30 | Phòng 3 | B6 B7
(3973, 5, NULL, '2026-12-04T11:04:39', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 696 | Trại Giam Hạnh Phúc | 04/12 13:45 | Phòng 1 | B6 B7
(3974, 5, 29, '2026-12-04T11:05:37', 124000, N'Paid', N'Transfer', NULL, 6, 26, NULL, NULL, NULL), -- suat 694 | Hexed: Thế Giới Phép Thuật | 04/12 12:45 | Phòng 2 | B3 B4
(3975, 5, NULL, '2026-12-04T11:17:54', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 705 | Điểm Mù | 04/12 18:30 | Phòng 3 | H8 H9
(3976, 5, NULL, '2026-12-04T11:19:53', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 746 | Kiến Lé Phiêu Lưu Ké | 06/12 09:30 | Phòng 3 | E6
(3977, 3, NULL, '2026-12-04T11:20:15', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 694 | Hexed: Thế Giới Phép Thuật | 04/12 12:45 | Phòng 2 | B7 B8 B9
(3978, 4, 9, '2026-12-04T11:23:09', 360000, N'Paid', N'Cash', 500000, 25, 0, NULL, NULL, NULL), -- suat 737 | Trại Giam Hạnh Phúc | 05/12 21:00 | Phòng 1 | G5 G6 G7 G8
(3979, 3, NULL, '2026-12-04T11:24:11', 450000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 694 | Hexed: Thế Giới Phép Thuật | 04/12 12:45 | Phòng 2 | C5 C6 C7 C8 C9 C10
(3980, 5, NULL, '2026-12-04T11:28:31', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 693 | Godzilla Trừ Không | 04/12 12:15 | Phòng 5 | K6 K7
(3981, 4, NULL, '2026-12-04T11:31:28', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 763 | Điểm Mù | 06/12 18:30 | Phòng 3 | E8
(3982, 3, NULL, '2026-12-04T11:35:46', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 695 | Con Mắt Thứ Ba | 04/12 13:30 | Phòng 3 | F4 F5
(3983, 4, 69, '2026-12-04T11:38:35', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 726 | Ngày Con Còn Mẹ | 05/12 15:00 | Phòng 2 | D5 D6
(3984, 4, NULL, '2026-12-04T11:39:22', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 695 | Con Mắt Thứ Ba | 04/12 13:30 | Phòng 3 | E7 E8
(3985, 4, 76, '2026-12-04T11:43:50', 90000, N'Paid', N'Cash', 90000, 4, 0, NULL, NULL, NULL), -- suat 700 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 15:30 | Phòng 4 | A5
(3986, 4, 72, '2026-12-04T11:48:58', 233000, N'Paid', N'Cash', 240000, 16, 55, NULL, NULL, NULL), -- suat 703 | Dune: Hành Tinh Cát - Phần Hai | 04/12 18:00 | Phòng 5 | J2 J3
(3987, 3, NULL, '2026-12-04T11:51:42', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 699 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 04/12 15:30 | Phòng 3 | J7 J8 J9 J10
(3988, 3, NULL, '2026-12-04T11:51:47', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | J5 J6
(3989, 5, 86, '2026-12-04T11:53:47', 325000, N'Paid', N'Cash', 325000, 22, 35, NULL, NULL, NULL), -- suat 736 | Bò Sữa Bay | 05/12 19:30 | Phòng 2 | D2 D3 D4 D5
(3990, 5, 69, '2026-12-04T11:55:29', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 692 | Ramayana: Khởi Nguồn Một Huyền Thoại | 04/12 12:15 | Phòng 4 | F5 F6
(3991, 5, NULL, '2026-12-04T11:55:56', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 718 | Ma Mút Con Vượt Kỷ Băng Hà | 05/12 11:15 | Phòng 2 | E6 E7 E8
(3992, 5, NULL, '2026-12-04T11:58:17', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 711 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 2 | A6 A7 A8
(3993, 4, 61, '2026-12-04T12:02:55', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 700 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 15:30 | Phòng 4 | F6 F7
(3994, 3, 109, '2026-12-04T12:10:28', 199000, N'Paid', N'Transfer', NULL, 9, 26, NULL, NULL, NULL), -- suat 724 | Con Mắt Thứ Ba | 05/12 13:30 | Phòng 3 | A6 A7 A8
(3995, 4, NULL, '2026-12-04T12:11:32', 75000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 696 | Trại Giam Hạnh Phúc | 04/12 13:45 | Phòng 1 | A6
(3996, 5, NULL, '2026-12-04T12:11:46', 150000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 724 | Con Mắt Thứ Ba | 05/12 13:30 | Phòng 3 | B6 B7
(3997, 5, 30, '2026-12-04T12:20:47', 270000, N'Paid', N'Card', NULL, 13, 0, NULL, NULL, NULL), -- suat 700 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 15:30 | Phòng 4 | C3 C4 C5
(3998, 3, 42, '2026-12-04T12:35:00', 450000, N'Paid', N'Card', NULL, 31, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | E8 E9 E10 E11 E12
(3999, 4, NULL, '2026-12-04T12:36:09', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 701 | Mẹ Mìn: Giao Kèo Với Quỷ | 04/12 16:15 | Phòng 1 | H7
(4000, 3, NULL, '2026-12-04T12:38:17', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 700 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 15:30 | Phòng 4 | G6 G7
(4001, 4, 67, '2026-12-04T12:42:25', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 695 | Con Mắt Thứ Ba | 04/12 13:30 | Phòng 3 | E6
(4002, 4, NULL, '2026-12-04T12:46:12', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 697 | Ngày Con Còn Mẹ | 04/12 15:00 | Phòng 2 | C5 C6
(4003, 3, NULL, '2026-12-04T12:48:37', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 710 | Godzilla Trừ Không | 04/12 21:15 | Phòng 5 | C5 C6 C7
(4004, 4, 85, '2026-12-04T12:51:04', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 695 | Con Mắt Thứ Ba | 04/12 13:30 | Phòng 3 | F6 F7 F8
(4005, 5, NULL, '2026-12-04T12:52:56', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | E2 E3 E4
(4006, 4, 105, '2026-12-04T12:56:48', 180000, N'Paid', N'Card', NULL, 9, 0, NULL, NULL, NULL), -- suat 700 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 15:30 | Phòng 4 | A6 A7
(4007, 5, NULL, '2026-12-04T13:04:47', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 701 | Mẹ Mìn: Giao Kèo Với Quỷ | 04/12 16:15 | Phòng 1 | J11 J12
(4008, 3, NULL, '2026-12-04T13:12:47', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 717 | Kiến Lé Phiêu Lưu Ké | 05/12 09:30 | Phòng 3 | E6
(4009, 4, NULL, '2026-12-04T13:13:38', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 696 | Trại Giam Hạnh Phúc | 04/12 13:45 | Phòng 1 | D6 D7 D8
(4010, 4, NULL, '2026-12-04T13:15:57', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 766 | Trại Giam Hạnh Phúc | 06/12 21:00 | Phòng 1 | H6 H7
(4011, 4, NULL, '2026-12-04T13:20:36', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 700 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 15:30 | Phòng 4 | H6 H7
(4012, 4, NULL, '2026-12-04T13:22:39', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 695 | Con Mắt Thứ Ba | 04/12 13:30 | Phòng 3 | H9 H10 H11
(4013, 5, NULL, '2026-12-04T13:31:34', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 697 | Ngày Con Còn Mẹ | 04/12 15:00 | Phòng 2 | G6 G7
(4014, 4, NULL, '2026-12-04T13:32:09', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 714 | Hexed: Thế Giới Phép Thuật | 05/12 09:00 | Phòng 2 | E6 E7 E8
(4015, 3, NULL, '2026-12-04T13:44:18', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | E6 E7
(4016, 4, NULL, '2026-12-04T13:45:21', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 737 | Trại Giam Hạnh Phúc | 05/12 21:00 | Phòng 1 | H7 H8
(4017, 4, NULL, '2026-12-04T13:49:19', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 699 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 04/12 15:30 | Phòng 3 | F5 F6 F7
(4018, 3, 89, '2026-12-04T13:54:34', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 713 | Trại Giam Hạnh Phúc | 05/12 09:00 | Phòng 1 | E8 E9
(4019, 3, NULL, '2026-12-04T13:55:28', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-12-04T13:58:30', 3), -- suat 699 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 04/12 15:30 | Phòng 3 | J3 J4
(4020, 5, NULL, '2026-12-04T13:57:07', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 698 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 15:00 | Phòng 5 | G4 G5 G6 G7
(4021, 3, NULL, '2026-12-04T13:57:17', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 700 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 15:30 | Phòng 4 | D2 D3
(4022, 5, NULL, '2026-12-04T14:14:18', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 701 | Mẹ Mìn: Giao Kèo Với Quỷ | 04/12 16:15 | Phòng 1 | D6 D7 D8
(4023, 5, 69, '2026-12-04T14:15:30', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 699 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 04/12 15:30 | Phòng 3 | E6 E7
(4024, 3, NULL, '2026-12-04T14:23:38', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 727 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:00 | Phòng 5 | E7 E8
(4025, 5, NULL, '2026-12-04T14:25:45', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 698 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 15:00 | Phòng 5 | H6 H7
(4026, 4, 81, '2026-12-04T14:26:14', 288000, N'Paid', N'Cash', 288000, 20, 0, NULL, NULL, NULL), -- suat 703 | Dune: Hành Tinh Cát - Phần Hai | 04/12 18:00 | Phòng 5 | F6 F7
(4027, 4, 93, '2026-12-04T14:30:25', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 699 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 04/12 15:30 | Phòng 3 | H4 H5 H6
(4028, 4, NULL, '2026-12-04T14:30:58', 432000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Nhầm suất / ghế', '2026-12-04T14:53:47', 4), -- suat 698 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 15:00 | Phòng 5 | F4 F5 F6
(4029, 4, NULL, '2026-12-04T14:31:04', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 701 | Mẹ Mìn: Giao Kèo Với Quỷ | 04/12 16:15 | Phòng 1 | E6
(4030, 3, NULL, '2026-12-04T14:39:35', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 698 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 15:00 | Phòng 5 | K6 K7
(4031, 5, 70, '2026-12-04T14:42:54', 367000, N'Paid', N'Cash', 400000, 25, 65, NULL, NULL, NULL), -- suat 700 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 15:30 | Phòng 4 | D5 D6 D7 D8
(4032, 4, NULL, '2026-12-04T14:42:56', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 739 | Godzilla Trừ Không | 05/12 21:15 | Phòng 5 | G7
(4033, 5, NULL, '2026-12-04T14:43:41', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 702 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 04/12 17:15 | Phòng 2 | H7 H8
(4034, 3, 51, '2026-12-04T14:47:06', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 698 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 15:00 | Phòng 5 | J5 J6
(4035, 5, 92, '2026-12-04T14:47:10', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 712 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 3 | J7 J8
(4036, 3, NULL, '2026-12-04T14:49:00', 270000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 702 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 04/12 17:15 | Phòng 2 | F8 F9 F10
(4037, 5, NULL, '2026-12-04T14:51:03', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 731 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 17:15 | Phòng 2 | F6 F7
(4038, 5, 116, '2026-12-04T14:55:05', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 702 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 04/12 17:15 | Phòng 2 | G7
(4039, 5, NULL, '2026-12-04T14:55:51', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 703 | Dune: Hành Tinh Cát - Phần Hai | 04/12 18:00 | Phòng 5 | J11 J12
(4040, 4, NULL, '2026-12-04T14:57:29', 108000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 764 | Godzilla Trừ Không | 06/12 18:30 | Phòng 4 | E5
(4041, 6, 117, '2026-12-04T15:00:46', 432000, N'Paid', N'Transfer', NULL, 30, 0, NULL, NULL, NULL), -- suat 722 | Godzilla Trừ Không | 05/12 12:15 | Phòng 5 | H4 H5 H6
(4042, 8, NULL, '2026-12-04T15:10:11', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 763 | Điểm Mù | 06/12 18:30 | Phòng 3 | E6 E7
(4043, 8, NULL, '2026-12-04T15:12:41', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 736 | Bò Sữa Bay | 05/12 19:30 | Phòng 2 | D9 D10
(4044, 6, NULL, '2026-12-04T15:17:43', 375000, N'Paid', N'Cash', 375000, 0, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | B5 B6 B7 B8 B9
(4045, 6, 42, '2026-12-04T15:19:30', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 728 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 15:30 | Phòng 3 | F7 F8
(4046, 8, NULL, '2026-12-04T15:21:51', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 700 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 15:30 | Phòng 4 | C6 C7
(4047, 8, NULL, '2026-12-04T15:22:02', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 707 | Bò Sữa Bay | 04/12 19:30 | Phòng 2 | F7 F8
(4048, 8, 21, '2026-12-04T15:22:32', 248000, N'Paid', N'Transfer', NULL, 17, 22, NULL, NULL, NULL), -- suat 725 | Trại Giam Hạnh Phúc | 05/12 13:45 | Phòng 1 | H5 H6 H7
(4049, 7, NULL, '2026-12-04T15:23:18', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 707 | Bò Sữa Bay | 04/12 19:30 | Phòng 2 | D5 D6 D7
(4050, 8, NULL, '2026-12-04T15:23:45', 108000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 764 | Godzilla Trừ Không | 06/12 18:30 | Phòng 4 | D8
(4051, 8, NULL, '2026-12-04T15:25:42', 120000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 710 | Godzilla Trừ Không | 04/12 21:15 | Phòng 5 | D7
(4052, 7, NULL, '2026-12-04T15:29:30', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 705 | Điểm Mù | 04/12 18:30 | Phòng 3 | E4 E5
(4053, 8, NULL, '2026-12-04T15:32:49', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 705 | Điểm Mù | 04/12 18:30 | Phòng 3 | D6
(4054, 8, 32, '2026-12-04T15:36:26', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 703 | Dune: Hành Tinh Cát - Phần Hai | 04/12 18:00 | Phòng 5 | G6 G7
(4055, 8, 88, '2026-12-04T15:41:22', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 705 | Điểm Mù | 04/12 18:30 | Phòng 3 | F5 F6
(4056, 8, 81, '2026-12-04T15:41:42', 180000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 702 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 04/12 17:15 | Phòng 2 | F3 F4
(4057, 8, 25, '2026-12-04T15:46:13', 393000, N'Paid', N'Cash', 393000, 27, 39, NULL, NULL, NULL), -- suat 706 | Godzilla Trừ Không | 04/12 18:30 | Phòng 4 | F1 F2 F3 F4
(4058, 6, NULL, '2026-12-04T15:46:22', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 709 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 21:00 | Phòng 4 | J7 J8
(4059, 6, NULL, '2026-12-04T15:46:43', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 702 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 04/12 17:15 | Phòng 2 | E4 E5 E6
(4060, 6, 70, '2026-12-04T15:54:42', 173000, N'Paid', N'Card', NULL, 12, 43, NULL, NULL, NULL), -- suat 709 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 21:00 | Phòng 4 | E6 E7
(4061, 8, NULL, '2026-12-04T15:57:28', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 705 | Điểm Mù | 04/12 18:30 | Phòng 3 | G6 G7
(4062, 8, 72, '2026-12-04T15:58:15', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 701 | Mẹ Mìn: Giao Kèo Với Quỷ | 04/12 16:15 | Phòng 1 | B4 B5
(4063, 7, NULL, '2026-12-04T15:58:16', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 707 | Bò Sữa Bay | 04/12 19:30 | Phòng 2 | B5 B6
(4064, 8, 23, '2026-12-04T15:59:49', 360000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 706 | Godzilla Trừ Không | 04/12 18:30 | Phòng 4 | C4 C5 C6 C7
(4065, 7, NULL, '2026-12-04T16:13:37', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 732 | Dune: Hành Tinh Cát - Phần Hai | 05/12 18:00 | Phòng 5 | E4 E5
(4066, 8, NULL, '2026-12-04T16:19:41', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 705 | Điểm Mù | 04/12 18:30 | Phòng 3 | E6 E7
(4067, 8, NULL, '2026-12-04T16:25:52', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | J9 J10
(4068, 7, NULL, '2026-12-04T16:32:24', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 705 | Điểm Mù | 04/12 18:30 | Phòng 3 | F8 F9
(4069, 6, 31, '2026-12-04T16:39:22', 180000, N'Paid', N'Cash', 180000, 18, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | J7 J8
(4070, 7, NULL, '2026-12-04T16:39:43', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 709 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 21:00 | Phòng 4 | F7 F8
(4071, 6, NULL, '2026-12-04T16:41:00', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 746 | Kiến Lé Phiêu Lưu Ké | 06/12 09:30 | Phòng 3 | C7
(4072, 7, NULL, '2026-12-04T16:41:24', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 711 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 2 | E7
(4073, 8, NULL, '2026-12-04T16:42:44', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | A5 A6
(4074, 8, 43, '2026-12-04T16:49:38', 150000, N'Paid', N'Cash', 500000, 7, 0, NULL, NULL, NULL), -- suat 708 | Trại Giam Hạnh Phúc | 04/12 21:00 | Phòng 1 | A7 A8
(4075, 6, 68, '2026-12-04T16:50:08', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 708 | Trại Giam Hạnh Phúc | 04/12 21:00 | Phòng 1 | E6 E7
(4076, 7, NULL, '2026-12-04T16:52:37', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 708 | Trại Giam Hạnh Phúc | 04/12 21:00 | Phòng 1 | E10 E11
(4077, 7, NULL, '2026-12-04T16:56:10', 540000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 702 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 04/12 17:15 | Phòng 2 | E7 E8 E9 E10 E11 E12
(4078, 8, NULL, '2026-12-04T17:00:26', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 735 | Godzilla Trừ Không | 05/12 18:30 | Phòng 4 | H7 H8
(4079, 6, NULL, '2026-12-04T17:00:58', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 707 | Bò Sữa Bay | 04/12 19:30 | Phòng 2 | H7
(4080, 6, 37, '2026-12-04T17:04:02', 450000, N'Paid', N'Cash', 450000, 31, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | H4 H5 H6 H7 H8
(4081, 8, 116, '2026-12-04T17:04:31', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | D7 D8
(4082, 8, NULL, '2026-12-04T17:09:11', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 730 | Mẹ Mìn: Giao Kèo Với Quỷ | 05/12 16:15 | Phòng 1 | G4 G5
(4083, 7, NULL, '2026-12-04T17:10:28', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 730 | Mẹ Mìn: Giao Kèo Với Quỷ | 05/12 16:15 | Phòng 1 | G6 G7
(4084, 8, NULL, '2026-12-04T17:14:37', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | G5 G6
(4085, 8, NULL, '2026-12-04T17:18:38', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 712 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 3 | H5 H6
(4086, 7, 78, '2026-12-04T17:21:59', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | F11 F12
(4087, 6, NULL, '2026-12-04T17:25:55', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 761 | Dune: Hành Tinh Cát - Phần Hai | 06/12 18:00 | Phòng 5 | K9 K10
(4088, 8, 23, '2026-12-04T17:26:11', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 705 | Điểm Mù | 04/12 18:30 | Phòng 3 | F3 F4
(4089, 6, 72, '2026-12-04T17:28:51', 180000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | D9 D10
(4090, 7, NULL, '2026-12-04T17:32:31', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Nhầm suất / ghế', '2026-12-04T17:53:28', 7), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | F9 F10
(4091, 6, NULL, '2026-12-04T17:33:31', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | G8 G9
(4092, 7, 110, '2026-12-04T17:35:14', 360000, N'Paid', N'Cash', 400000, 18, 0, NULL, NULL, NULL), -- suat 735 | Godzilla Trừ Không | 05/12 18:30 | Phòng 4 | A5 A6 A7 A8
(4093, 7, 26, '2026-12-04T17:35:55', 180000, N'Paid', N'Transfer', NULL, 12, 36, NULL, NULL, NULL), -- suat 706 | Godzilla Trừ Không | 04/12 18:30 | Phòng 4 | F6 F7
(4094, 6, NULL, '2026-12-04T17:43:21', 300000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | B7 B8 B9 B10
(4095, 8, 69, '2026-12-04T17:43:42', 148000, N'Paid', N'Transfer', NULL, 14, 32, NULL, NULL, NULL), -- suat 707 | Bò Sữa Bay | 04/12 19:30 | Phòng 2 | J11 J12
(4096, 7, 117, '2026-12-04T17:44:52', 450000, N'Paid', N'Card', NULL, 31, 0, NULL, NULL, NULL), -- suat 742 | Trại Giam Hạnh Phúc | 06/12 09:00 | Phòng 1 | H4 H5 H6 H7 H8
(4097, 8, NULL, '2026-12-04T17:45:54', 324000, N'Paid', N'Cash', 324000, 0, 0, NULL, NULL, NULL), -- suat 729 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:30 | Phòng 4 | G5 G6 G7
(4098, 8, NULL, '2026-12-04T17:47:17', 300000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 707 | Bò Sữa Bay | 04/12 19:30 | Phòng 2 | A5 A6 A7 A8
(4099, 6, NULL, '2026-12-04T17:49:41', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 710 | Godzilla Trừ Không | 04/12 21:15 | Phòng 5 | E9 E10
(4100, 8, NULL, '2026-12-04T17:49:57', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 735 | Godzilla Trừ Không | 05/12 18:30 | Phòng 4 | B3 B4 B5
(4101, 6, NULL, '2026-12-04T17:53:06', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 706 | Godzilla Trừ Không | 04/12 18:30 | Phòng 4 | B6 B7
(4102, 7, NULL, '2026-12-04T17:55:21', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 726 | Ngày Con Còn Mẹ | 05/12 15:00 | Phòng 2 | E5 E6
(4103, 6, 93, '2026-12-04T17:55:30', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 727 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:00 | Phòng 5 | F6 F7
(4104, 7, NULL, '2026-12-04T17:55:43', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 712 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 3 | E2 E3 E4
(4105, 6, NULL, '2026-12-04T18:02:29', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 707 | Bò Sữa Bay | 04/12 19:30 | Phòng 2 | E7 E8
(4106, 7, 59, '2026-12-04T18:03:31', 88000, N'Paid', N'Cash', 88000, 6, 20, NULL, NULL, NULL), -- suat 709 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 21:00 | Phòng 4 | G5
(4107, 7, NULL, '2026-12-04T18:05:36', 180000, N'Cancelled', N'Cash', 200000, 0, 0, N'Khách đổi ý', '2026-12-04T18:11:26', 7), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | F2 F3
(4108, 7, NULL, '2026-12-04T18:06:04', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 731 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 17:15 | Phòng 2 | F8 F9
(4109, 7, NULL, '2026-12-04T18:06:33', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 704 | Bắt Cá Ba Tay | 04/12 18:30 | Phòng 1 | F4
(4110, 6, NULL, '2026-12-04T18:09:32', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 707 | Bò Sữa Bay | 04/12 19:30 | Phòng 2 | G4 G5
(4111, 7, NULL, '2026-12-04T18:13:35', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 707 | Bò Sữa Bay | 04/12 19:30 | Phòng 2 | G6 G7
(4112, 8, 103, '2026-12-04T18:13:41', 360000, N'Paid', N'Cash', 360000, 25, 0, NULL, NULL, NULL), -- suat 705 | Điểm Mù | 04/12 18:30 | Phòng 3 | G9 G10 G11 G12
(4113, 6, 64, '2026-12-04T18:14:34', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 712 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 3 | C7 C8
(4114, 7, NULL, '2026-12-04T18:16:21', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 712 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 3 | G5 G6
(4115, 7, 21, '2026-12-04T18:33:56', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 737 | Trại Giam Hạnh Phúc | 05/12 21:00 | Phòng 1 | H4 H5
(4116, 8, NULL, '2026-12-04T18:35:05', 108000, N'Paid', N'Cash', 108000, 0, 0, NULL, NULL, NULL), -- suat 709 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 21:00 | Phòng 4 | F6
(4117, 8, NULL, '2026-12-04T18:43:36', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 732 | Dune: Hành Tinh Cát - Phần Hai | 05/12 18:00 | Phòng 5 | E8 E9 E10
(4118, 7, NULL, '2026-12-04T18:44:00', 300000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 707 | Bò Sữa Bay | 04/12 19:30 | Phòng 2 | C5 C6 C7 C8
(4119, 7, 31, '2026-12-04T18:45:50', 240000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 722 | Godzilla Trừ Không | 05/12 12:15 | Phòng 5 | D5 D6
(4120, 6, NULL, '2026-12-04T18:48:52', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 709 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 21:00 | Phòng 4 | D6 D7
(4121, 6, 23, '2026-12-04T18:52:46', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 717 | Kiến Lé Phiêu Lưu Ké | 05/12 09:30 | Phòng 3 | G7 G8
(4122, 7, 5, '2026-12-04T18:54:27', 293000, N'Paid', N'Cash', 500000, 14, 67, NULL, NULL, NULL), -- suat 738 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 21:00 | Phòng 4 | C6 C7 C8 C9
(4123, 8, NULL, '2026-12-04T18:55:31', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 741 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 3 | G4
(4124, 8, NULL, '2026-12-04T19:08:03', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 711 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 2 | G8 G9
(4125, 8, NULL, '2026-12-04T19:09:57', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 707 | Bò Sữa Bay | 04/12 19:30 | Phòng 2 | B7
(4126, 6, NULL, '2026-12-04T19:14:25', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 707 | Bò Sữa Bay | 04/12 19:30 | Phòng 2 | G2 G3
(4127, 8, 29, '2026-12-04T19:16:12', 288000, N'Paid', N'Cash', 288000, 20, 0, NULL, NULL, NULL), -- suat 710 | Godzilla Trừ Không | 04/12 21:15 | Phòng 5 | H5 H6
(4128, 6, NULL, '2026-12-04T19:28:53', 324000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 750 | Ramayana: Khởi Nguồn Một Huyền Thoại | 06/12 12:15 | Phòng 4 | E4 E5 E6
(4129, 8, NULL, '2026-12-04T19:28:56', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 710 | Godzilla Trừ Không | 04/12 21:15 | Phòng 5 | F7 F8
(4130, 8, 67, '2026-12-04T19:39:34', 150000, N'Paid', N'Cash', 500000, 7, 0, NULL, NULL, NULL), -- suat 708 | Trại Giam Hạnh Phúc | 04/12 21:00 | Phòng 1 | A5 A6
(4131, 7, 53, '2026-12-04T19:42:19', 225000, N'Paid', N'Cash', 225000, 11, 0, NULL, NULL, NULL), -- suat 708 | Trại Giam Hạnh Phúc | 04/12 21:00 | Phòng 1 | A2 A3 A4
(4132, 7, 120, '2026-12-04T19:46:21', 216000, N'Paid', N'Cash', 216000, 15, 0, NULL, NULL, NULL), -- suat 721 | Ramayana: Khởi Nguồn Một Huyền Thoại | 05/12 12:15 | Phòng 4 | H7 H8
(4133, 6, NULL, '2026-12-04T19:48:18', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 719 | Ngày Con Còn Mẹ | 05/12 11:15 | Phòng 3 | G4 G5 G6 G7
(4134, 8, NULL, '2026-12-04T19:59:31', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | J9 J10
(4135, 8, NULL, '2026-12-04T19:59:42', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 724 | Con Mắt Thứ Ba | 05/12 13:30 | Phòng 3 | D6 D7
(4136, 7, 113, '2026-12-04T20:06:13', 270000, N'Paid', N'Cash', 500000, 18, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | E5 E6 E7
(4137, 6, 22, '2026-12-04T20:16:45', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 708 | Trại Giam Hạnh Phúc | 04/12 21:00 | Phòng 1 | F6 F7
(4138, 8, NULL, '2026-12-04T20:16:48', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 708 | Trại Giam Hạnh Phúc | 04/12 21:00 | Phòng 1 | E8 E9
(4139, 6, NULL, '2026-12-04T20:19:40', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 708 | Trại Giam Hạnh Phúc | 04/12 21:00 | Phòng 1 | C6 C7 C8
(4140, 6, NULL, '2026-12-04T20:28:31', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 712 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 3 | E7 E8
(4141, 7, NULL, '2026-12-04T20:30:28', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 732 | Dune: Hành Tinh Cát - Phần Hai | 05/12 18:00 | Phòng 5 | L11 L12
(4142, 8, NULL, '2026-12-04T20:35:41', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 709 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 04/12 21:00 | Phòng 4 | H6 H7
(4143, 8, NULL, '2026-12-04T20:43:35', 720000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 710 | Godzilla Trừ Không | 04/12 21:15 | Phòng 5 | E2 E3 E4 E5 E6
(4144, 7, NULL, '2026-12-04T20:54:34', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 710 | Godzilla Trừ Không | 04/12 21:15 | Phòng 5 | E7 E8
(4145, 6, NULL, '2026-12-04T20:58:57', 375000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 711 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 2 | B6 B7 B8 B9 B10
(4146, 8, 115, '2026-12-04T21:01:32', 288000, N'Paid', N'Cash', 500000, 20, 0, NULL, NULL, NULL), -- suat 710 | Godzilla Trừ Không | 04/12 21:15 | Phòng 5 | K3 K4
(4147, 8, NULL, '2026-12-04T21:01:42', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 712 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 3 | C1 C2
(4148, 7, NULL, '2026-12-04T21:04:27', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 711 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 2 | E8 E9 E10 E11
(4149, 8, 89, '2026-12-04T21:04:45', 576000, N'Paid', N'Card', NULL, 40, 0, NULL, NULL, NULL), -- suat 722 | Godzilla Trừ Không | 05/12 12:15 | Phòng 5 | F7 F8 F9 F10
(4150, 6, NULL, '2026-12-04T21:11:41', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 723 | Hexed: Thế Giới Phép Thuật | 05/12 12:45 | Phòng 2 | G4 G5
(4151, 7, 72, '2026-12-04T21:13:59', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 766 | Trại Giam Hạnh Phúc | 06/12 21:00 | Phòng 1 | F6 F7 F8 F9
(4152, 8, NULL, '2026-12-04T21:15:13', 150000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 712 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 3 | C4 C5
(4153, 8, NULL, '2026-12-04T21:23:17', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 712 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 3 | F7 F8
(4154, 6, NULL, '2026-12-04T21:24:57', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 711 | Con Mắt Thứ Ba | 04/12 21:45 | Phòng 2 | G6 G7
(4155, 6, NULL, '2026-12-04T21:26:04', 300000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 755 | Ngày Con Còn Mẹ | 06/12 15:00 | Phòng 2 | C3 C4 C5 C6
(4156, 7, 67, '2026-12-04T21:34:51', 300000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL); -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | C5 C6 C7 C8
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(9013, 3941, 728, 3, 223, 75000, N'Active'),
(9014, 3941, 728, 3, 224, 75000, N'Active'),
(9015, 3942, 694, 2, 125, 75000, N'Active'),
(9016, 3942, 694, 2, 126, 75000, N'Active'),
(9017, 3943, 684, 1, 68, 90000, N'Active'),
(9018, 3943, 684, 1, 69, 90000, N'Active'),
(9019, 3944, 687, 4, 391, 108000, N'Active'),
(9020, 3944, 687, 4, 392, 108000, N'Active'),
(9021, 3945, 692, 4, 427, 108000, N'Active'),
(9022, 3945, 692, 4, 428, 108000, N'Active'),
(9023, 3946, 733, 1, 86, 90000, N'Active'),
(9024, 3946, 733, 1, 87, 90000, N'Active'),
(9025, 3947, 691, 1, 89, 90000, N'Active'),
(9026, 3948, 689, 2, 114, 75000, N'Active'),
(9027, 3948, 689, 2, 115, 75000, N'Active'),
(9028, 3949, 688, 3, 294, 90000, N'Active'),
(9029, 3949, 688, 3, 295, 90000, N'Active'),
(9030, 3950, 688, 3, 222, 75000, N'Active'),
(9031, 3950, 688, 3, 223, 75000, N'Active'),
(9032, 3951, 713, 1, 31, 75000, N'Active'),
(9033, 3951, 713, 1, 32, 75000, N'Active'),
(9034, 3951, 713, 1, 33, 75000, N'Active'),
(9035, 3952, 693, 5, 559, 144000, N'Active'),
(9036, 3952, 693, 5, 560, 144000, N'Active'),
(9037, 3953, 688, 3, 258, 90000, N'Active'),
(9038, 3954, 690, 3, 293, 90000, N'Active'),
(9039, 3954, 690, 3, 294, 90000, N'Active'),
(9040, 3954, 690, 3, 295, 90000, N'Active'),
(9041, 3954, 690, 3, 296, 90000, N'Active'),
(9042, 3955, 703, 5, 532, 144000, N'Active'),
(9043, 3955, 703, 5, 533, 144000, N'Active'),
(9044, 3955, 703, 5, 534, 144000, N'Active'),
(9045, 3955, 703, 5, 535, 144000, N'Active'),
(9046, 3955, 703, 5, 536, 144000, N'Active'),
(9047, 3955, 703, 5, 537, 144000, N'Active'),
(9048, 3956, 692, 4, 401, 108000, N'Active'),
(9049, 3956, 692, 4, 402, 108000, N'Active'),
(9050, 3957, 735, 4, 391, 108000, N'Active'),
(9051, 3957, 735, 4, 392, 108000, N'Active'),
(9052, 3957, 735, 4, 393, 108000, N'Active'),
(9053, 3957, 735, 4, 394, 108000, N'Active'),
(9054, 3958, 693, 5, 486, 144000, N'Active'),
(9055, 3958, 693, 5, 487, 144000, N'Active'),
(9056, 3958, 693, 5, 488, 144000, N'Active'),
(9057, 3959, 699, 3, 278, 90000, N'Active'),
(9058, 3959, 699, 3, 279, 90000, N'Active'),
(9059, 3960, 693, 5, 511, 144000, N'Active'),
(9060, 3960, 693, 5, 512, 144000, N'Active'),
(9061, 3961, 707, 2, 165, 90000, N'Cancelled'),
(9062, 3961, 707, 2, 166, 90000, N'Cancelled'),
(9063, 3962, 723, 2, 162, 90000, N'Active'),
(9064, 3962, 723, 2, 163, 90000, N'Active'),
(9065, 3963, 731, 2, 213, 90000, N'Active'),
(9066, 3963, 731, 2, 214, 90000, N'Active'),
(9067, 3964, 689, 2, 162, 90000, N'Active'),
(9068, 3964, 689, 2, 163, 90000, N'Active'),
(9069, 3965, 769, 2, 165, 90000, N'Active'),
(9070, 3966, 735, 4, 354, 90000, N'Active'),
(9071, 3966, 735, 4, 355, 90000, N'Active'),
(9072, 3967, 726, 2, 186, 90000, N'Active'),
(9073, 3967, 726, 2, 187, 90000, N'Active'),
(9074, 3968, 695, 3, 258, 90000, N'Cancelled'),
(9075, 3969, 692, 4, 412, 108000, N'Cancelled'),
(9076, 3969, 692, 4, 413, 108000, N'Cancelled'),
(9077, 3969, 692, 4, 414, 108000, N'Cancelled'),
(9078, 3969, 692, 4, 415, 108000, N'Cancelled'),
(9079, 3970, 736, 2, 197, 90000, N'Active'),
(9080, 3970, 736, 2, 198, 90000, N'Active'),
(9081, 3971, 691, 1, 53, 90000, N'Active'),
(9082, 3971, 691, 1, 54, 90000, N'Active'),
(9083, 3971, 691, 1, 55, 90000, N'Active'),
(9084, 3972, 695, 3, 234, 75000, N'Cancelled'),
(9085, 3972, 695, 3, 235, 75000, N'Cancelled'),
(9086, 3973, 696, 1, 18, 75000, N'Active'),
(9087, 3973, 696, 1, 19, 75000, N'Active'),
(9088, 3974, 694, 2, 123, 75000, N'Active'),
(9089, 3974, 694, 2, 124, 75000, N'Active'),
(9090, 3975, 705, 3, 308, 90000, N'Active'),
(9091, 3975, 705, 3, 309, 90000, N'Active'),
(9092, 3976, 746, 3, 270, 90000, N'Active'),
(9093, 3977, 694, 2, 127, 75000, N'Active'),
(9094, 3977, 694, 2, 128, 75000, N'Active'),
(9095, 3977, 694, 2, 129, 75000, N'Active'),
(9096, 3978, 737, 1, 77, 90000, N'Active'),
(9097, 3978, 737, 1, 78, 90000, N'Active'),
(9098, 3978, 737, 1, 79, 90000, N'Active'),
(9099, 3978, 737, 1, 80, 90000, N'Active'),
(9100, 3979, 694, 2, 137, 75000, N'Active'),
(9101, 3979, 694, 2, 138, 75000, N'Active'),
(9102, 3979, 694, 2, 139, 75000, N'Active'),
(9103, 3979, 694, 2, 140, 75000, N'Active'),
(9104, 3979, 694, 2, 141, 75000, N'Active'),
(9105, 3979, 694, 2, 142, 75000, N'Active'),
(9106, 3980, 693, 5, 546, 144000, N'Active'),
(9107, 3980, 693, 5, 547, 144000, N'Active'),
(9108, 3981, 763, 3, 272, 90000, N'Active'),
(9109, 3982, 695, 3, 280, 90000, N'Active'),
(9110, 3982, 695, 3, 281, 90000, N'Active'),
(9111, 3983, 726, 2, 149, 90000, N'Active'),
(9112, 3983, 726, 2, 150, 90000, N'Active'),
(9113, 3984, 695, 3, 271, 90000, N'Active'),
(9114, 3984, 695, 3, 272, 90000, N'Active'),
(9115, 3985, 700, 4, 329, 90000, N'Active'),
(9116, 3986, 703, 5, 530, 144000, N'Active'),
(9117, 3986, 703, 5, 531, 144000, N'Active'),
(9118, 3987, 699, 3, 319, 90000, N'Active'),
(9119, 3987, 699, 3, 320, 90000, N'Active'),
(9120, 3987, 699, 3, 321, 90000, N'Active'),
(9121, 3987, 699, 3, 322, 90000, N'Active'),
(9122, 3988, 733, 1, 101, 90000, N'Active'),
(9123, 3988, 733, 1, 102, 90000, N'Active'),
(9124, 3989, 736, 2, 146, 90000, N'Active'),
(9125, 3989, 736, 2, 147, 90000, N'Active'),
(9126, 3989, 736, 2, 148, 90000, N'Active'),
(9127, 3989, 736, 2, 149, 90000, N'Active'),
(9128, 3990, 692, 4, 389, 108000, N'Active'),
(9129, 3990, 692, 4, 390, 108000, N'Active'),
(9130, 3991, 718, 2, 162, 90000, N'Active'),
(9131, 3991, 718, 2, 163, 90000, N'Active'),
(9132, 3991, 718, 2, 164, 90000, N'Active'),
(9133, 3992, 711, 2, 114, 75000, N'Active'),
(9134, 3992, 711, 2, 115, 75000, N'Active'),
(9135, 3992, 711, 2, 116, 75000, N'Active'),
(9136, 3993, 700, 4, 390, 108000, N'Active'),
(9137, 3993, 700, 4, 391, 108000, N'Active'),
(9138, 3994, 724, 3, 222, 75000, N'Active'),
(9139, 3994, 724, 3, 223, 75000, N'Active'),
(9140, 3994, 724, 3, 224, 75000, N'Active'),
(9141, 3995, 696, 1, 6, 75000, N'Active'),
(9142, 3996, 724, 3, 234, 75000, N'Active'),
(9143, 3996, 724, 3, 235, 75000, N'Active'),
(9144, 3997, 700, 4, 351, 90000, N'Active'),
(9145, 3997, 700, 4, 352, 90000, N'Active'),
(9146, 3997, 700, 4, 353, 90000, N'Active'),
(9147, 3998, 704, 1, 56, 90000, N'Active'),
(9148, 3998, 704, 1, 57, 90000, N'Active'),
(9149, 3998, 704, 1, 58, 90000, N'Active'),
(9150, 3998, 704, 1, 59, 90000, N'Active'),
(9151, 3998, 704, 1, 60, 90000, N'Active'),
(9152, 3999, 701, 1, 91, 90000, N'Active'),
(9153, 4000, 700, 4, 402, 108000, N'Active'),
(9154, 4000, 700, 4, 403, 108000, N'Active'),
(9155, 4001, 695, 3, 270, 90000, N'Active'),
(9156, 4002, 697, 2, 137, 75000, N'Active'),
(9157, 4002, 697, 2, 138, 75000, N'Active'),
(9158, 4003, 710, 5, 461, 120000, N'Active'),
(9159, 4003, 710, 5, 462, 120000, N'Active'),
(9160, 4003, 710, 5, 463, 120000, N'Active'),
(9161, 4004, 695, 3, 282, 90000, N'Active'),
(9162, 4004, 695, 3, 283, 90000, N'Active'),
(9163, 4004, 695, 3, 284, 90000, N'Active'),
(9164, 4005, 734, 3, 266, 90000, N'Active'),
(9165, 4005, 734, 3, 267, 90000, N'Active'),
(9166, 4005, 734, 3, 268, 90000, N'Active'),
(9167, 4006, 700, 4, 330, 90000, N'Active'),
(9168, 4006, 700, 4, 331, 90000, N'Active'),
(9169, 4007, 701, 1, 107, 90000, N'Active'),
(9170, 4007, 701, 1, 108, 90000, N'Active'),
(9171, 4008, 717, 3, 270, 90000, N'Active'),
(9172, 4009, 696, 1, 42, 90000, N'Active'),
(9173, 4009, 696, 1, 43, 90000, N'Active'),
(9174, 4009, 696, 1, 44, 90000, N'Active'),
(9175, 4010, 766, 1, 90, 90000, N'Active'),
(9176, 4010, 766, 1, 91, 90000, N'Active'),
(9177, 4011, 700, 4, 414, 108000, N'Active'),
(9178, 4011, 700, 4, 415, 108000, N'Active'),
(9179, 4012, 695, 3, 309, 90000, N'Active'),
(9180, 4012, 695, 3, 310, 90000, N'Active'),
(9181, 4012, 695, 3, 311, 90000, N'Active'),
(9182, 4013, 697, 2, 186, 90000, N'Active'),
(9183, 4013, 697, 2, 187, 90000, N'Active'),
(9184, 4014, 714, 2, 162, 90000, N'Active'),
(9185, 4014, 714, 2, 163, 90000, N'Active'),
(9186, 4014, 714, 2, 164, 90000, N'Active'),
(9187, 4015, 704, 1, 54, 90000, N'Active'),
(9188, 4015, 704, 1, 55, 90000, N'Active'),
(9189, 4016, 737, 1, 91, 90000, N'Active'),
(9190, 4016, 737, 1, 92, 90000, N'Active'),
(9191, 4017, 699, 3, 281, 90000, N'Active'),
(9192, 4017, 699, 3, 282, 90000, N'Active'),
(9193, 4017, 699, 3, 283, 90000, N'Active'),
(9194, 4018, 713, 1, 56, 90000, N'Active'),
(9195, 4018, 713, 1, 57, 90000, N'Active'),
(9196, 4019, 699, 3, 315, 90000, N'Cancelled'),
(9197, 4019, 699, 3, 316, 90000, N'Cancelled'),
(9198, 4020, 698, 5, 508, 144000, N'Active'),
(9199, 4020, 698, 5, 509, 144000, N'Active'),
(9200, 4020, 698, 5, 510, 144000, N'Active'),
(9201, 4020, 698, 5, 511, 144000, N'Active'),
(9202, 4021, 700, 4, 362, 108000, N'Active'),
(9203, 4021, 700, 4, 363, 108000, N'Active'),
(9204, 4022, 701, 1, 42, 90000, N'Active'),
(9205, 4022, 701, 1, 43, 90000, N'Active'),
(9206, 4022, 701, 1, 44, 90000, N'Active'),
(9207, 4023, 699, 3, 270, 90000, N'Active'),
(9208, 4023, 699, 3, 271, 90000, N'Active'),
(9209, 4024, 727, 5, 487, 144000, N'Active'),
(9210, 4024, 727, 5, 488, 144000, N'Active'),
(9211, 4025, 698, 5, 522, 144000, N'Active'),
(9212, 4025, 698, 5, 523, 144000, N'Active'),
(9213, 4026, 703, 5, 498, 144000, N'Active'),
(9214, 4026, 703, 5, 499, 144000, N'Active'),
(9215, 4027, 699, 3, 304, 90000, N'Active'),
(9216, 4027, 699, 3, 305, 90000, N'Active'),
(9217, 4027, 699, 3, 306, 90000, N'Active'),
(9218, 4028, 698, 5, 496, 144000, N'Cancelled'),
(9219, 4028, 698, 5, 497, 144000, N'Cancelled'),
(9220, 4028, 698, 5, 498, 144000, N'Cancelled'),
(9221, 4029, 701, 1, 54, 90000, N'Active'),
(9222, 4030, 698, 5, 546, 144000, N'Active'),
(9223, 4030, 698, 5, 547, 144000, N'Active'),
(9224, 4031, 700, 4, 365, 108000, N'Active'),
(9225, 4031, 700, 4, 366, 108000, N'Active'),
(9226, 4031, 700, 4, 367, 108000, N'Active'),
(9227, 4031, 700, 4, 368, 108000, N'Active'),
(9228, 4032, 739, 5, 511, 144000, N'Active'),
(9229, 4033, 702, 2, 199, 90000, N'Active'),
(9230, 4033, 702, 2, 200, 90000, N'Active'),
(9231, 4034, 698, 5, 533, 144000, N'Active'),
(9232, 4034, 698, 5, 534, 144000, N'Active'),
(9233, 4035, 712, 3, 319, 90000, N'Active'),
(9234, 4035, 712, 3, 320, 90000, N'Active'),
(9235, 4036, 702, 2, 176, 90000, N'Active'),
(9236, 4036, 702, 2, 177, 90000, N'Active'),
(9237, 4036, 702, 2, 178, 90000, N'Active'),
(9238, 4037, 731, 2, 174, 90000, N'Active'),
(9239, 4037, 731, 2, 175, 90000, N'Active'),
(9240, 4038, 702, 2, 187, 90000, N'Active'),
(9241, 4039, 703, 5, 539, 144000, N'Active'),
(9242, 4039, 703, 5, 540, 144000, N'Active'),
(9243, 4040, 764, 4, 377, 108000, N'Active'),
(9244, 4041, 722, 5, 520, 144000, N'Active'),
(9245, 4041, 722, 5, 521, 144000, N'Active'),
(9246, 4041, 722, 5, 522, 144000, N'Active'),
(9247, 4042, 763, 3, 270, 90000, N'Active'),
(9248, 4042, 763, 3, 271, 90000, N'Active'),
(9249, 4043, 736, 2, 153, 90000, N'Active'),
(9250, 4043, 736, 2, 154, 90000, N'Active'),
(9251, 4044, 704, 1, 17, 75000, N'Active'),
(9252, 4044, 704, 1, 18, 75000, N'Active'),
(9253, 4044, 704, 1, 19, 75000, N'Active'),
(9254, 4044, 704, 1, 20, 75000, N'Active'),
(9255, 4044, 704, 1, 21, 75000, N'Active'),
(9256, 4045, 728, 3, 283, 90000, N'Active'),
(9257, 4045, 728, 3, 284, 90000, N'Active'),
(9258, 4046, 700, 4, 354, 90000, N'Active'),
(9259, 4046, 700, 4, 355, 90000, N'Active'),
(9260, 4047, 707, 2, 175, 90000, N'Active'),
(9261, 4047, 707, 2, 176, 90000, N'Active'),
(9262, 4048, 725, 1, 89, 90000, N'Active'),
(9263, 4048, 725, 1, 90, 90000, N'Active'),
(9264, 4048, 725, 1, 91, 90000, N'Active'),
(9265, 4049, 707, 2, 149, 90000, N'Active'),
(9266, 4049, 707, 2, 150, 90000, N'Active'),
(9267, 4049, 707, 2, 151, 90000, N'Active'),
(9268, 4050, 764, 4, 368, 108000, N'Active'),
(9269, 4051, 710, 5, 475, 120000, N'Active'),
(9270, 4052, 705, 3, 268, 90000, N'Active'),
(9271, 4052, 705, 3, 269, 90000, N'Active'),
(9272, 4053, 705, 3, 258, 90000, N'Active'),
(9273, 4054, 703, 5, 510, 144000, N'Active'),
(9274, 4054, 703, 5, 511, 144000, N'Active'),
(9275, 4055, 705, 3, 281, 90000, N'Active'),
(9276, 4055, 705, 3, 282, 90000, N'Active'),
(9277, 4056, 702, 2, 171, 90000, N'Active'),
(9278, 4056, 702, 2, 172, 90000, N'Active'),
(9279, 4057, 706, 4, 385, 108000, N'Active'),
(9280, 4057, 706, 4, 386, 108000, N'Active'),
(9281, 4057, 706, 4, 387, 108000, N'Active'),
(9282, 4057, 706, 4, 388, 108000, N'Active'),
(9283, 4058, 709, 4, 427, 108000, N'Active'),
(9284, 4058, 709, 4, 428, 108000, N'Active'),
(9285, 4059, 702, 2, 160, 90000, N'Active'),
(9286, 4059, 702, 2, 161, 90000, N'Active'),
(9287, 4059, 702, 2, 162, 90000, N'Active'),
(9288, 4060, 709, 4, 378, 108000, N'Active'),
(9289, 4060, 709, 4, 379, 108000, N'Active'),
(9290, 4061, 705, 3, 294, 90000, N'Active'),
(9291, 4061, 705, 3, 295, 90000, N'Active'),
(9292, 4062, 701, 1, 16, 75000, N'Active'),
(9293, 4062, 701, 1, 17, 75000, N'Active'),
(9294, 4063, 707, 2, 125, 75000, N'Active'),
(9295, 4063, 707, 2, 126, 75000, N'Active'),
(9296, 4064, 706, 4, 352, 90000, N'Active'),
(9297, 4064, 706, 4, 353, 90000, N'Active'),
(9298, 4064, 706, 4, 354, 90000, N'Active'),
(9299, 4064, 706, 4, 355, 90000, N'Active'),
(9300, 4065, 732, 5, 484, 144000, N'Active'),
(9301, 4065, 732, 5, 485, 144000, N'Active'),
(9302, 4066, 705, 3, 270, 90000, N'Active'),
(9303, 4066, 705, 3, 271, 90000, N'Active'),
(9304, 4067, 704, 1, 105, 90000, N'Active'),
(9305, 4067, 704, 1, 106, 90000, N'Active'),
(9306, 4068, 705, 3, 284, 90000, N'Active'),
(9307, 4068, 705, 3, 285, 90000, N'Active'),
(9308, 4069, 704, 1, 103, 90000, N'Active'),
(9309, 4069, 704, 1, 104, 90000, N'Active'),
(9310, 4070, 709, 4, 391, 108000, N'Active'),
(9311, 4070, 709, 4, 392, 108000, N'Active'),
(9312, 4071, 746, 3, 247, 75000, N'Active'),
(9313, 4072, 711, 2, 163, 90000, N'Active'),
(9314, 4073, 704, 1, 5, 75000, N'Active'),
(9315, 4073, 704, 1, 6, 75000, N'Active'),
(9316, 4074, 708, 1, 7, 75000, N'Active'),
(9317, 4074, 708, 1, 8, 75000, N'Active'),
(9318, 4075, 708, 1, 54, 90000, N'Active'),
(9319, 4075, 708, 1, 55, 90000, N'Active'),
(9320, 4076, 708, 1, 58, 90000, N'Active'),
(9321, 4076, 708, 1, 59, 90000, N'Active'),
(9322, 4077, 702, 2, 163, 90000, N'Active'),
(9323, 4077, 702, 2, 164, 90000, N'Active'),
(9324, 4077, 702, 2, 165, 90000, N'Active'),
(9325, 4077, 702, 2, 166, 90000, N'Active'),
(9326, 4077, 702, 2, 167, 90000, N'Active'),
(9327, 4077, 702, 2, 168, 90000, N'Active'),
(9328, 4078, 735, 4, 415, 108000, N'Active'),
(9329, 4078, 735, 4, 416, 108000, N'Active'),
(9330, 4079, 707, 2, 199, 90000, N'Active'),
(9331, 4080, 704, 1, 88, 90000, N'Active'),
(9332, 4080, 704, 1, 89, 90000, N'Active'),
(9333, 4080, 704, 1, 90, 90000, N'Active'),
(9334, 4080, 704, 1, 91, 90000, N'Active'),
(9335, 4080, 704, 1, 92, 90000, N'Active'),
(9336, 4081, 704, 1, 43, 90000, N'Active'),
(9337, 4081, 704, 1, 44, 90000, N'Active'),
(9338, 4082, 730, 1, 76, 90000, N'Active'),
(9339, 4082, 730, 1, 77, 90000, N'Active'),
(9340, 4083, 730, 1, 78, 90000, N'Active'),
(9341, 4083, 730, 1, 79, 90000, N'Active'),
(9342, 4084, 704, 1, 77, 90000, N'Active'),
(9343, 4084, 704, 1, 78, 90000, N'Active'),
(9344, 4085, 712, 3, 305, 90000, N'Active'),
(9345, 4085, 712, 3, 306, 90000, N'Active'),
(9346, 4086, 704, 1, 71, 90000, N'Active'),
(9347, 4086, 704, 1, 72, 90000, N'Active'),
(9348, 4087, 761, 5, 549, 144000, N'Active'),
(9349, 4087, 761, 5, 550, 144000, N'Active'),
(9350, 4088, 705, 3, 279, 90000, N'Active'),
(9351, 4088, 705, 3, 280, 90000, N'Active'),
(9352, 4089, 704, 1, 45, 90000, N'Active'),
(9353, 4089, 704, 1, 46, 90000, N'Active'),
(9354, 4090, 704, 1, 69, 90000, N'Cancelled'),
(9355, 4090, 704, 1, 70, 90000, N'Cancelled'),
(9356, 4091, 704, 1, 80, 90000, N'Active'),
(9357, 4091, 704, 1, 81, 90000, N'Active'),
(9358, 4092, 735, 4, 329, 90000, N'Active'),
(9359, 4092, 735, 4, 330, 90000, N'Active'),
(9360, 4092, 735, 4, 331, 90000, N'Active'),
(9361, 4092, 735, 4, 332, 90000, N'Active'),
(9362, 4093, 706, 4, 390, 108000, N'Active'),
(9363, 4093, 706, 4, 391, 108000, N'Active'),
(9364, 4094, 733, 1, 19, 75000, N'Active'),
(9365, 4094, 733, 1, 20, 75000, N'Active'),
(9366, 4094, 733, 1, 21, 75000, N'Active'),
(9367, 4094, 733, 1, 22, 75000, N'Active'),
(9368, 4095, 707, 2, 215, 90000, N'Active'),
(9369, 4095, 707, 2, 216, 90000, N'Active'),
(9370, 4096, 742, 1, 88, 90000, N'Active'),
(9371, 4096, 742, 1, 89, 90000, N'Active'),
(9372, 4096, 742, 1, 90, 90000, N'Active'),
(9373, 4096, 742, 1, 91, 90000, N'Active'),
(9374, 4096, 742, 1, 92, 90000, N'Active'),
(9375, 4097, 729, 4, 401, 108000, N'Active'),
(9376, 4097, 729, 4, 402, 108000, N'Active'),
(9377, 4097, 729, 4, 403, 108000, N'Active'),
(9378, 4098, 707, 2, 113, 75000, N'Active'),
(9379, 4098, 707, 2, 114, 75000, N'Active'),
(9380, 4098, 707, 2, 115, 75000, N'Active'),
(9381, 4098, 707, 2, 116, 75000, N'Active'),
(9382, 4099, 710, 5, 489, 144000, N'Active'),
(9383, 4099, 710, 5, 490, 144000, N'Active'),
(9384, 4100, 735, 4, 339, 90000, N'Active'),
(9385, 4100, 735, 4, 340, 90000, N'Active'),
(9386, 4100, 735, 4, 341, 90000, N'Active'),
(9387, 4101, 706, 4, 342, 90000, N'Active'),
(9388, 4101, 706, 4, 343, 90000, N'Active'),
(9389, 4102, 726, 2, 161, 90000, N'Active'),
(9390, 4102, 726, 2, 162, 90000, N'Active'),
(9391, 4103, 727, 5, 498, 144000, N'Active'),
(9392, 4103, 727, 5, 499, 144000, N'Active'),
(9393, 4104, 712, 3, 266, 90000, N'Active'),
(9394, 4104, 712, 3, 267, 90000, N'Active'),
(9395, 4104, 712, 3, 268, 90000, N'Active'),
(9396, 4105, 707, 2, 163, 90000, N'Active'),
(9397, 4105, 707, 2, 164, 90000, N'Active'),
(9398, 4106, 709, 4, 401, 108000, N'Active'),
(9399, 4107, 704, 1, 62, 90000, N'Cancelled'),
(9400, 4107, 704, 1, 63, 90000, N'Cancelled'),
(9401, 4108, 731, 2, 176, 90000, N'Active'),
(9402, 4108, 731, 2, 177, 90000, N'Active'),
(9403, 4109, 704, 1, 64, 90000, N'Active'),
(9404, 4110, 707, 2, 184, 90000, N'Active'),
(9405, 4110, 707, 2, 185, 90000, N'Active'),
(9406, 4111, 707, 2, 186, 90000, N'Active'),
(9407, 4111, 707, 2, 187, 90000, N'Active'),
(9408, 4112, 705, 3, 297, 90000, N'Active'),
(9409, 4112, 705, 3, 298, 90000, N'Active'),
(9410, 4112, 705, 3, 299, 90000, N'Active'),
(9411, 4112, 705, 3, 300, 90000, N'Active'),
(9412, 4113, 712, 3, 247, 75000, N'Active'),
(9413, 4113, 712, 3, 248, 75000, N'Active'),
(9414, 4114, 712, 3, 293, 90000, N'Active'),
(9415, 4114, 712, 3, 294, 90000, N'Active'),
(9416, 4115, 737, 1, 88, 90000, N'Active'),
(9417, 4115, 737, 1, 89, 90000, N'Active'),
(9418, 4116, 709, 4, 390, 108000, N'Active'),
(9419, 4117, 732, 5, 488, 144000, N'Active'),
(9420, 4117, 732, 5, 489, 144000, N'Active'),
(9421, 4117, 732, 5, 490, 144000, N'Active'),
(9422, 4118, 707, 2, 137, 75000, N'Active'),
(9423, 4118, 707, 2, 138, 75000, N'Active'),
(9424, 4118, 707, 2, 139, 75000, N'Active'),
(9425, 4118, 707, 2, 140, 75000, N'Active'),
(9426, 4119, 722, 5, 473, 120000, N'Active'),
(9427, 4119, 722, 5, 474, 120000, N'Active'),
(9428, 4120, 709, 4, 366, 108000, N'Active'),
(9429, 4120, 709, 4, 367, 108000, N'Active'),
(9430, 4121, 717, 3, 295, 90000, N'Active'),
(9431, 4121, 717, 3, 296, 90000, N'Active'),
(9432, 4122, 738, 4, 354, 90000, N'Active'),
(9433, 4122, 738, 4, 355, 90000, N'Active'),
(9434, 4122, 738, 4, 356, 90000, N'Active'),
(9435, 4122, 738, 4, 357, 90000, N'Active'),
(9436, 4123, 741, 3, 292, 90000, N'Active'),
(9437, 4124, 711, 2, 188, 90000, N'Active'),
(9438, 4124, 711, 2, 189, 90000, N'Active'),
(9439, 4125, 707, 2, 127, 75000, N'Active'),
(9440, 4126, 707, 2, 182, 90000, N'Active'),
(9441, 4126, 707, 2, 183, 90000, N'Active'),
(9442, 4127, 710, 5, 521, 144000, N'Active'),
(9443, 4127, 710, 5, 522, 144000, N'Active'),
(9444, 4128, 750, 4, 376, 108000, N'Active'),
(9445, 4128, 750, 4, 377, 108000, N'Active'),
(9446, 4128, 750, 4, 378, 108000, N'Active'),
(9447, 4129, 710, 5, 499, 144000, N'Active'),
(9448, 4129, 710, 5, 500, 144000, N'Active'),
(9449, 4130, 708, 1, 5, 75000, N'Active'),
(9450, 4130, 708, 1, 6, 75000, N'Active'),
(9451, 4131, 708, 1, 2, 75000, N'Active'),
(9452, 4131, 708, 1, 3, 75000, N'Active'),
(9453, 4131, 708, 1, 4, 75000, N'Active'),
(9454, 4132, 721, 4, 415, 108000, N'Active'),
(9455, 4132, 721, 4, 416, 108000, N'Active'),
(9456, 4133, 719, 3, 292, 90000, N'Active'),
(9457, 4133, 719, 3, 293, 90000, N'Active'),
(9458, 4133, 719, 3, 294, 90000, N'Active'),
(9459, 4133, 719, 3, 295, 90000, N'Active'),
(9460, 4134, 733, 1, 105, 90000, N'Active'),
(9461, 4134, 733, 1, 106, 90000, N'Active'),
(9462, 4135, 724, 3, 258, 90000, N'Active'),
(9463, 4135, 724, 3, 259, 90000, N'Active'),
(9464, 4136, 734, 3, 269, 90000, N'Active'),
(9465, 4136, 734, 3, 270, 90000, N'Active'),
(9466, 4136, 734, 3, 271, 90000, N'Active'),
(9467, 4137, 708, 1, 66, 90000, N'Active'),
(9468, 4137, 708, 1, 67, 90000, N'Active'),
(9469, 4138, 708, 1, 56, 90000, N'Active'),
(9470, 4138, 708, 1, 57, 90000, N'Active'),
(9471, 4139, 708, 1, 30, 75000, N'Active'),
(9472, 4139, 708, 1, 31, 75000, N'Active'),
(9473, 4139, 708, 1, 32, 75000, N'Active'),
(9474, 4140, 712, 3, 271, 90000, N'Active'),
(9475, 4140, 712, 3, 272, 90000, N'Active'),
(9476, 4141, 732, 5, 563, 144000, N'Active'),
(9477, 4141, 732, 5, 564, 144000, N'Active'),
(9478, 4142, 709, 4, 414, 108000, N'Active'),
(9479, 4142, 709, 4, 415, 108000, N'Active'),
(9480, 4143, 710, 5, 482, 144000, N'Active'),
(9481, 4143, 710, 5, 483, 144000, N'Active'),
(9482, 4143, 710, 5, 484, 144000, N'Active'),
(9483, 4143, 710, 5, 485, 144000, N'Active'),
(9484, 4143, 710, 5, 486, 144000, N'Active'),
(9485, 4144, 710, 5, 487, 144000, N'Active'),
(9486, 4144, 710, 5, 488, 144000, N'Active'),
(9487, 4145, 711, 2, 126, 75000, N'Active'),
(9488, 4145, 711, 2, 127, 75000, N'Active'),
(9489, 4145, 711, 2, 128, 75000, N'Active'),
(9490, 4145, 711, 2, 129, 75000, N'Active'),
(9491, 4145, 711, 2, 130, 75000, N'Active'),
(9492, 4146, 710, 5, 543, 144000, N'Active'),
(9493, 4146, 710, 5, 544, 144000, N'Active'),
(9494, 4147, 712, 3, 241, 75000, N'Active'),
(9495, 4147, 712, 3, 242, 75000, N'Active'),
(9496, 4148, 711, 2, 164, 90000, N'Active'),
(9497, 4148, 711, 2, 165, 90000, N'Active'),
(9498, 4148, 711, 2, 166, 90000, N'Active'),
(9499, 4148, 711, 2, 167, 90000, N'Active'),
(9500, 4149, 722, 5, 499, 144000, N'Active'),
(9501, 4149, 722, 5, 500, 144000, N'Active'),
(9502, 4149, 722, 5, 501, 144000, N'Active'),
(9503, 4149, 722, 5, 502, 144000, N'Active'),
(9504, 4150, 723, 2, 184, 90000, N'Active'),
(9505, 4150, 723, 2, 185, 90000, N'Active'),
(9506, 4151, 766, 1, 66, 90000, N'Active'),
(9507, 4151, 766, 1, 67, 90000, N'Active'),
(9508, 4151, 766, 1, 68, 90000, N'Active'),
(9509, 4151, 766, 1, 69, 90000, N'Active'),
(9510, 4152, 712, 3, 244, 75000, N'Active'),
(9511, 4152, 712, 3, 245, 75000, N'Active'),
(9512, 4153, 712, 3, 283, 90000, N'Active'),
(9513, 4153, 712, 3, 284, 90000, N'Active'),
(9514, 4154, 711, 2, 186, 90000, N'Active'),
(9515, 4154, 711, 2, 187, 90000, N'Active'),
(9516, 4155, 755, 2, 135, 75000, N'Active'),
(9517, 4155, 755, 2, 136, 75000, N'Active'),
(9518, 4155, 755, 2, 137, 75000, N'Active'),
(9519, 4155, 755, 2, 138, 75000, N'Active'),
(9520, 4156, 734, 3, 245, 75000, N'Active'),
(9521, 4156, 734, 3, 246, 75000, N'Active'),
(9522, 4156, 734, 3, 247, 75000, N'Active'),
(9523, 4156, 734, 3, 248, 75000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 7 05/12/2026: 250 hoa don (9 huy), 560 ve, doanh thu 54.737.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(4157, 8, 89, '2026-12-05T08:00:53', 600000, N'Paid', N'Cash', 600000, 30, 0, NULL, NULL, NULL), -- suat 785 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 15:00 | Phòng 5 | D5 D6 D7 D8 D9
(4158, 7, NULL, '2026-12-05T08:01:09', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 744 | Dune: Hành Tinh Cát - Phần Hai | 06/12 09:00 | Phòng 5 | L5 L6
(4159, 7, NULL, '2026-12-05T08:01:22', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 745 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 09:15 | Phòng 4 | A4 A5 A6 A7
(4160, 6, 113, '2026-12-05T08:11:34', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 713 | Trại Giam Hạnh Phúc | 05/12 09:00 | Phòng 1 | J5 J6
(4161, 7, NULL, '2026-12-05T08:14:33', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-12-05T08:59:27', 7), -- suat 717 | Kiến Lé Phiêu Lưu Ké | 05/12 09:30 | Phòng 3 | H5 H6
(4162, 6, NULL, '2026-12-05T08:15:41', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 724 | Con Mắt Thứ Ba | 05/12 13:30 | Phòng 3 | F6 F7
(4163, 8, 42, '2026-12-05T08:18:41', 216000, N'Paid', N'Cash', 216000, 21, 0, NULL, NULL, NULL), -- suat 716 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 09:15 | Phòng 4 | J7 J8
(4164, 7, 69, '2026-12-05T08:24:20', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 718 | Ma Mút Con Vượt Kỷ Băng Hà | 05/12 11:15 | Phòng 2 | D6 D7
(4165, 7, 93, '2026-12-05T08:27:25', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 713 | Trại Giam Hạnh Phúc | 05/12 09:00 | Phòng 1 | E6 E7
(4166, 7, NULL, '2026-12-05T08:30:12', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 721 | Ramayana: Khởi Nguồn Một Huyền Thoại | 05/12 12:15 | Phòng 4 | A5 A6
(4167, 7, 69, '2026-12-05T08:31:22', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 724 | Con Mắt Thứ Ba | 05/12 13:30 | Phòng 3 | E6 E7
(4168, 7, 68, '2026-12-05T08:35:41', 180000, N'Paid', N'Cash', 500000, 9, 0, NULL, NULL, NULL), -- suat 716 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 09:15 | Phòng 4 | A6 A7
(4169, 8, NULL, '2026-12-05T08:39:40', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 714 | Hexed: Thế Giới Phép Thuật | 05/12 09:00 | Phòng 2 | F6
(4170, 7, 113, '2026-12-05T08:39:55', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 728 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 15:30 | Phòng 3 | F4
(4171, 8, NULL, '2026-12-05T08:39:56', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 713 | Trại Giam Hạnh Phúc | 05/12 09:00 | Phòng 1 | F7 F8
(4172, 6, NULL, '2026-12-05T08:41:18', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 792 | Điểm Mù | 07/12 18:30 | Phòng 3 | F6
(4173, 8, NULL, '2026-12-05T08:41:19', 450000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 714 | Hexed: Thế Giới Phép Thuật | 05/12 09:00 | Phòng 2 | G4 G5 G6 G7 G8
(4174, 7, 113, '2026-12-05T08:41:24', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 770 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 3 | F7 F8
(4175, 8, NULL, '2026-12-05T08:42:03', 240000, N'Paid', N'Cash', 240000, 0, 0, NULL, NULL, NULL), -- suat 732 | Dune: Hành Tinh Cát - Phần Hai | 05/12 18:00 | Phòng 5 | C7 C8
(4176, 6, NULL, '2026-12-05T08:42:35', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 715 | Dune: Hành Tinh Cát - Phần Hai | 05/12 09:00 | Phòng 5 | F5 F6 F7
(4177, 7, NULL, '2026-12-05T08:44:55', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 715 | Dune: Hành Tinh Cát - Phần Hai | 05/12 09:00 | Phòng 5 | J6 J7
(4178, 8, NULL, '2026-12-05T08:49:59', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 713 | Trại Giam Hạnh Phúc | 05/12 09:00 | Phòng 1 | G9
(4179, 8, 67, '2026-12-05T08:50:20', 144000, N'Paid', N'Transfer', NULL, 10, 0, NULL, NULL, NULL), -- suat 715 | Dune: Hành Tinh Cát - Phần Hai | 05/12 09:00 | Phòng 5 | K7
(4180, 6, NULL, '2026-12-05T08:54:40', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 717 | Kiến Lé Phiêu Lưu Ké | 05/12 09:30 | Phòng 3 | H7 H8
(4181, 8, NULL, '2026-12-05T08:55:03', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 716 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 09:15 | Phòng 4 | D6 D7
(4182, 7, NULL, '2026-12-05T09:01:53', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 716 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 09:15 | Phòng 4 | E7 E8
(4183, 8, NULL, '2026-12-05T09:05:41', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 722 | Godzilla Trừ Không | 05/12 12:15 | Phòng 5 | L9 L10
(4184, 8, 2, '2026-12-05T09:12:26', 144000, N'Paid', N'Cash', 144000, 10, 0, NULL, NULL, NULL), -- suat 756 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 15:00 | Phòng 5 | F5
(4185, 7, 21, '2026-12-05T09:17:21', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 720 | Bắt Cá Ba Tay | 05/12 11:30 | Phòng 1 | G6 G7
(4186, 6, 78, '2026-12-05T09:21:25', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 717 | Kiến Lé Phiêu Lưu Ké | 05/12 09:30 | Phòng 3 | F6 F7
(4187, 6, NULL, '2026-12-05T09:32:51', 540000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 752 | Hexed: Thế Giới Phép Thuật | 06/12 12:45 | Phòng 2 | G2 G3 G4 G5 G6 G7
(4188, 6, NULL, '2026-12-05T09:49:26', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 752 | Hexed: Thế Giới Phép Thuật | 06/12 12:45 | Phòng 2 | B6 B7
(4189, 7, 108, '2026-12-05T09:53:03', 126000, N'Paid', N'Cash', 500000, 6, 24, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | C9 C10
(4190, 8, NULL, '2026-12-05T09:53:04', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 720 | Bắt Cá Ba Tay | 05/12 11:30 | Phòng 1 | E6 E7 E8
(4191, 6, 115, '2026-12-05T09:54:44', 270000, N'Cancelled', N'Cash', 270000, 18, 0, N'Lỗi thanh toán', '2026-12-05T10:14:57', 6), -- suat 719 | Ngày Con Còn Mẹ | 05/12 11:15 | Phòng 3 | F6 F7 F8
(4192, 7, NULL, '2026-12-05T10:01:23', 216000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 758 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 15:30 | Phòng 4 | D8 D9
(4193, 7, NULL, '2026-12-05T10:04:34', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 728 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 15:30 | Phòng 3 | D6 D7
(4194, 8, NULL, '2026-12-05T10:05:08', 225000, N'Paid', N'Cash', 225000, 0, 0, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | B7 B8 B9
(4195, 7, NULL, '2026-12-05T10:12:46', 120000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 751 | Godzilla Trừ Không | 06/12 12:15 | Phòng 5 | B5
(4196, 6, NULL, '2026-12-05T10:16:09', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 722 | Godzilla Trừ Không | 05/12 12:15 | Phòng 5 | H7 H8
(4197, 6, NULL, '2026-12-05T10:20:48', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 742 | Trại Giam Hạnh Phúc | 06/12 09:00 | Phòng 1 | E6
(4198, 8, NULL, '2026-12-05T10:21:05', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 762 | Bắt Cá Ba Tay | 06/12 18:30 | Phòng 1 | F6 F7 F8
(4199, 6, NULL, '2026-12-05T10:21:35', 480000, N'Paid', N'Cash', 480000, 0, 0, NULL, NULL, NULL), -- suat 732 | Dune: Hành Tinh Cát - Phần Hai | 05/12 18:00 | Phòng 5 | A5 A6 A7 A8
(4200, 6, NULL, '2026-12-05T10:26:17', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 723 | Hexed: Thế Giới Phép Thuật | 05/12 12:45 | Phòng 2 | G6 G7 G8
(4201, 7, NULL, '2026-12-05T10:32:35', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 722 | Godzilla Trừ Không | 05/12 12:15 | Phòng 5 | F5 F6
(4202, 8, NULL, '2026-12-05T10:33:19', 120000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 732 | Dune: Hành Tinh Cát - Phần Hai | 05/12 18:00 | Phòng 5 | B3
(4203, 8, NULL, '2026-12-05T10:33:38', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | A5 A6
(4204, 8, 67, '2026-12-05T10:34:55', 90000, N'Cancelled', N'Cash', 90000, 6, 0, N'Nhầm suất / ghế', '2026-12-05T11:21:13', 8), -- suat 723 | Hexed: Thế Giới Phép Thuật | 05/12 12:45 | Phòng 2 | H5
(4205, 7, NULL, '2026-12-05T10:37:22', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 759 | Mẹ Mìn: Giao Kèo Với Quỷ | 06/12 16:15 | Phòng 1 | F7 F8
(4206, 7, NULL, '2026-12-05T10:38:01', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 770 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 3 | A6 A7
(4207, 7, 45, '2026-12-05T10:39:28', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 739 | Godzilla Trừ Không | 05/12 21:15 | Phòng 5 | F10 F11
(4208, 8, 113, '2026-12-05T10:45:47', 108000, N'Paid', N'Cash', 500000, 7, 0, NULL, NULL, NULL), -- suat 721 | Ramayana: Khởi Nguồn Một Huyền Thoại | 05/12 12:15 | Phòng 4 | F5
(4209, 8, NULL, '2026-12-05T10:46:27', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 726 | Ngày Con Còn Mẹ | 05/12 15:00 | Phòng 2 | J3 J4
(4210, 7, NULL, '2026-12-05T10:53:13', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 725 | Trại Giam Hạnh Phúc | 05/12 13:45 | Phòng 1 | J1 J2 J3 J4
(4211, 8, NULL, '2026-12-05T10:57:18', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | H8 H9
(4212, 8, NULL, '2026-12-05T11:09:43', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 797 | Godzilla Trừ Không | 07/12 21:15 | Phòng 5 | G6 G7
(4213, 8, 68, '2026-12-05T11:13:33', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 723 | Hexed: Thế Giới Phép Thuật | 05/12 12:45 | Phòng 2 | H4
(4214, 8, NULL, '2026-12-05T11:15:27', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 729 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:30 | Phòng 4 | D5 D6
(4215, 6, NULL, '2026-12-05T11:15:53', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 728 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 15:30 | Phòng 3 | G8 G9
(4216, 7, NULL, '2026-12-05T11:17:39', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 724 | Con Mắt Thứ Ba | 05/12 13:30 | Phòng 3 | J3 J4
(4217, 7, NULL, '2026-12-05T11:19:41', 120000, N'Paid', N'Cash', 120000, 0, 0, NULL, NULL, NULL), -- suat 722 | Godzilla Trừ Không | 05/12 12:15 | Phòng 5 | C6
(4218, 6, NULL, '2026-12-05T11:21:03', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 720 | Bắt Cá Ba Tay | 05/12 11:30 | Phòng 1 | F7 F8 F9 F10
(4219, 6, NULL, '2026-12-05T11:27:04', 270000, N'Cancelled', N'Card', NULL, 0, 0, N'Nhầm suất / ghế', '2026-12-05T11:57:43', 6), -- suat 723 | Hexed: Thế Giới Phép Thuật | 05/12 12:45 | Phòng 2 | F5 F6 F7
(4220, 8, NULL, '2026-12-05T11:28:34', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 736 | Bò Sữa Bay | 05/12 19:30 | Phòng 2 | A8 A9
(4221, 7, NULL, '2026-12-05T11:39:21', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 768 | Godzilla Trừ Không | 06/12 21:15 | Phòng 5 | F7 F8 F9
(4222, 6, NULL, '2026-12-05T11:41:00', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 748 | Ngày Con Còn Mẹ | 06/12 11:15 | Phòng 3 | C6 C7
(4223, 6, NULL, '2026-12-05T11:43:00', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 722 | Godzilla Trừ Không | 05/12 12:15 | Phòng 5 | F2 F3 F4
(4224, 8, 72, '2026-12-05T11:47:04', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 751 | Godzilla Trừ Không | 06/12 12:15 | Phòng 5 | H5 H6
(4225, 6, NULL, '2026-12-05T11:47:18', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 721 | Ramayana: Khởi Nguồn Một Huyền Thoại | 05/12 12:15 | Phòng 4 | B4 B5 B6
(4226, 7, NULL, '2026-12-05T11:48:42', 108000, N'Paid', N'Cash', 108000, 0, 0, NULL, NULL, NULL), -- suat 721 | Ramayana: Khởi Nguồn Một Huyền Thoại | 05/12 12:15 | Phòng 4 | D6
(4227, 6, NULL, '2026-12-05T11:48:43', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 739 | Godzilla Trừ Không | 05/12 21:15 | Phòng 5 | E4 E5 E6
(4228, 8, NULL, '2026-12-05T11:50:28', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 735 | Godzilla Trừ Không | 05/12 18:30 | Phòng 4 | J3 J4
(4229, 8, 89, '2026-12-05T11:51:18', 146000, N'Paid', N'Cash', 200000, 10, 34, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | G2 G3
(4230, 8, NULL, '2026-12-05T11:52:34', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 732 | Dune: Hành Tinh Cát - Phần Hai | 05/12 18:00 | Phòng 5 | E1 E2 E3
(4231, 6, NULL, '2026-12-05T11:56:55', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 722 | Godzilla Trừ Không | 05/12 12:15 | Phòng 5 | J5 J6
(4232, 6, 75, '2026-12-05T11:57:37', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 726 | Ngày Con Còn Mẹ | 05/12 15:00 | Phòng 2 | E9 E10
(4233, 7, 1, '2026-12-05T11:59:55', 144000, N'Paid', N'Transfer', NULL, 10, 0, NULL, NULL, NULL), -- suat 722 | Godzilla Trừ Không | 05/12 12:15 | Phòng 5 | E7
(4234, 7, NULL, '2026-12-05T12:01:57', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 769 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 2 | J5 J6
(4235, 8, NULL, '2026-12-05T12:04:26', 450000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 758 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 15:30 | Phòng 4 | C5 C6 C7 C8 C9
(4236, 7, 97, '2026-12-05T12:21:25', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 727 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:00 | Phòng 5 | J2 J3
(4237, 8, 51, '2026-12-05T12:22:47', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 736 | Bò Sữa Bay | 05/12 19:30 | Phòng 2 | G6
(4238, 6, NULL, '2026-12-05T12:24:00', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 724 | Con Mắt Thứ Ba | 05/12 13:30 | Phòng 3 | F2 F3 F4
(4239, 8, NULL, '2026-12-05T12:31:31', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 761 | Dune: Hành Tinh Cát - Phần Hai | 06/12 18:00 | Phòng 5 | L1 L2
(4240, 8, 32, '2026-12-05T12:33:24', 360000, N'Paid', N'Cash', 360000, 36, 0, NULL, NULL, NULL), -- suat 725 | Trại Giam Hạnh Phúc | 05/12 13:45 | Phòng 1 | J7 J8 J9 J10
(4241, 6, 22, '2026-12-05T12:36:56', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 723 | Hexed: Thế Giới Phép Thuật | 05/12 12:45 | Phòng 2 | D6 D7
(4242, 6, NULL, '2026-12-05T12:40:31', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 727 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:00 | Phòng 5 | F8 F9 F10
(4243, 6, NULL, '2026-12-05T12:40:39', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 755 | Ngày Con Còn Mẹ | 06/12 15:00 | Phòng 2 | D4 D5
(4244, 7, NULL, '2026-12-05T12:46:58', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 732 | Dune: Hành Tinh Cát - Phần Hai | 05/12 18:00 | Phòng 5 | E6 E7
(4245, 7, 4, '2026-12-05T12:48:33', 360000, N'Paid', N'Cash', 360000, 25, 0, NULL, NULL, NULL), -- suat 784 | Ngày Con Còn Mẹ | 07/12 15:00 | Phòng 2 | D7 D8 D9 D10
(4246, 8, 72, '2026-12-05T12:48:53', 180000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 731 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 17:15 | Phòng 2 | J5 J6
(4247, 6, NULL, '2026-12-05T12:50:38', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | B7 B8
(4248, 7, 6, '2026-12-05T12:55:31', 324000, N'Paid', N'Transfer', NULL, 22, 0, NULL, NULL, NULL), -- suat 750 | Ramayana: Khởi Nguồn Một Huyền Thoại | 06/12 12:15 | Phòng 4 | H5 H6 H7
(4249, 6, NULL, '2026-12-05T13:02:56', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 729 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:30 | Phòng 4 | G1 G2
(4250, 6, 97, '2026-12-05T13:03:25', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | E6 E7
(4251, 8, NULL, '2026-12-05T13:12:31', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 753 | Con Mắt Thứ Ba | 06/12 13:30 | Phòng 3 | F4 F5
(4252, 6, 33, '2026-12-05T13:13:04', 75000, N'Paid', N'Transfer', NULL, 3, 0, NULL, NULL, NULL), -- suat 726 | Ngày Con Còn Mẹ | 05/12 15:00 | Phòng 2 | A6
(4253, 7, NULL, '2026-12-05T13:14:11', 576000, N'Paid', N'Cash', 600000, 0, 0, NULL, NULL, NULL), -- suat 727 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:00 | Phòng 5 | L5 L6 L7 L8
(4254, 6, NULL, '2026-12-05T13:14:56', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 724 | Con Mắt Thứ Ba | 05/12 13:30 | Phòng 3 | D3 D4 D5
(4255, 7, 97, '2026-12-05T13:16:06', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 728 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 15:30 | Phòng 3 | G6 G7
(4256, 6, NULL, '2026-12-05T13:19:57', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 731 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 17:15 | Phòng 2 | A6 A7
(4257, 6, NULL, '2026-12-05T13:24:05', 75000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 759 | Mẹ Mìn: Giao Kèo Với Quỷ | 06/12 16:15 | Phòng 1 | C7
(4258, 7, NULL, '2026-12-05T13:26:27', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 770 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 3 | D5
(4259, 7, NULL, '2026-12-05T13:29:26', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 727 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:00 | Phòng 5 | J11 J12
(4260, 8, NULL, '2026-12-05T13:36:17', 270000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 798 | Con Mắt Thứ Ba | 07/12 21:45 | Phòng 2 | E6 E7 E8
(4261, 7, NULL, '2026-12-05T13:45:17', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 761 | Dune: Hành Tinh Cát - Phần Hai | 06/12 18:00 | Phòng 5 | K7 K8
(4262, 6, 108, '2026-12-05T13:47:14', 150000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 747 | Ma Mút Con Vượt Kỷ Băng Hà | 06/12 11:15 | Phòng 2 | A6 A7
(4263, 7, NULL, '2026-12-05T13:48:52', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 749 | Bắt Cá Ba Tay | 06/12 11:30 | Phòng 1 | E7 E8
(4264, 6, NULL, '2026-12-05T13:50:56', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 728 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 15:30 | Phòng 3 | J5 J6 J7 J8
(4265, 7, 44, '2026-12-05T13:58:11', 576000, N'Paid', N'Card', NULL, 40, 0, NULL, NULL, NULL), -- suat 727 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:00 | Phòng 5 | J7 J8 J9 J10
(4266, 6, 33, '2026-12-05T14:01:11', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 762 | Bắt Cá Ba Tay | 06/12 18:30 | Phòng 1 | C5 C6
(4267, 8, NULL, '2026-12-05T14:07:01', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 731 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 17:15 | Phòng 2 | E6 E7
(4268, 6, NULL, '2026-12-05T14:10:53', 144000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 727 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:00 | Phòng 5 | J6
(4269, 8, NULL, '2026-12-05T14:20:17', 90000, N'Cancelled', N'Cash', 90000, 0, 0, N'Nhầm suất / ghế', '2026-12-05T14:31:07', 8), -- suat 760 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 06/12 17:15 | Phòng 2 | G7
(4270, 7, NULL, '2026-12-05T14:20:58', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 729 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:30 | Phòng 4 | F4 F5
(4271, 6, 42, '2026-12-05T14:21:17', 120000, N'Paid', N'Cash', 200000, 8, 24, NULL, NULL, NULL), -- suat 732 | Dune: Hành Tinh Cát - Phần Hai | 05/12 18:00 | Phòng 5 | K9
(4272, 7, 66, '2026-12-05T14:22:25', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 726 | Ngày Con Còn Mẹ | 05/12 15:00 | Phòng 2 | G8 G9
(4273, 6, NULL, '2026-12-05T14:22:51', 108000, N'Cancelled', N'Cash', 110000, 0, 0, N'Lỗi thanh toán', '2026-12-05T14:48:17', 6), -- suat 738 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 21:00 | Phòng 4 | H4
(4274, 7, NULL, '2026-12-05T14:26:03', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 726 | Ngày Con Còn Mẹ | 05/12 15:00 | Phòng 2 | H6 H7
(4275, 8, NULL, '2026-12-05T14:33:23', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 727 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:00 | Phòng 5 | H4 H5
(4276, 6, NULL, '2026-12-05T14:33:29', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 727 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:00 | Phòng 5 | J5
(4277, 8, NULL, '2026-12-05T14:34:03', 576000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 732 | Dune: Hành Tinh Cát - Phần Hai | 05/12 18:00 | Phòng 5 | K4 K5 K6 K7
(4278, 7, NULL, '2026-12-05T14:35:14', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 736 | Bò Sữa Bay | 05/12 19:30 | Phòng 2 | J11 J12
(4279, 8, NULL, '2026-12-05T14:39:18', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 726 | Ngày Con Còn Mẹ | 05/12 15:00 | Phòng 2 | H4 H5
(4280, 7, NULL, '2026-12-05T14:42:37', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 727 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:00 | Phòng 5 | K6 K7
(4281, 6, NULL, '2026-12-05T14:45:04', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | H5 H6
(4282, 8, 99, '2026-12-05T14:57:13', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 769 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 2 | H7 H8
(4283, 6, NULL, '2026-12-05T14:57:29', 216000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 729 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 15:30 | Phòng 4 | G8 G9
(4284, 9, NULL, '2026-12-05T15:04:30', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 731 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 17:15 | Phòng 2 | C6 C7
(4285, 3, 46, '2026-12-05T15:09:52', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 751 | Godzilla Trừ Không | 06/12 12:15 | Phòng 5 | J5 J6
(4286, 3, NULL, '2026-12-05T15:11:44', 225000, N'Paid', N'Cash', 225000, 0, 0, NULL, NULL, NULL), -- suat 728 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 15:30 | Phòng 3 | B6 B7 B8
(4287, 10, 21, '2026-12-05T15:17:49', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 736 | Bò Sữa Bay | 05/12 19:30 | Phòng 2 | E4 E5
(4288, 9, NULL, '2026-12-05T15:25:58', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 735 | Godzilla Trừ Không | 05/12 18:30 | Phòng 4 | H3 H4 H5 H6
(4289, 3, NULL, '2026-12-05T15:32:10', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 738 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 21:00 | Phòng 4 | G5 G6
(4290, 9, 41, '2026-12-05T15:32:29', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | G1 G2 G3 G4
(4291, 9, NULL, '2026-12-05T15:33:02', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 731 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 17:15 | Phòng 2 | G3 G4
(4292, 9, 55, '2026-12-05T15:33:54', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 747 | Ma Mút Con Vượt Kỷ Băng Hà | 06/12 11:15 | Phòng 2 | D8 D9
(4293, 10, 59, '2026-12-05T15:36:11', 151000, N'Paid', N'Cash', 200000, 10, 29, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | H5 H6
(4294, 3, NULL, '2026-12-05T15:37:19', 108000, N'Paid', N'Cash', 108000, 0, 0, NULL, NULL, NULL), -- suat 735 | Godzilla Trừ Không | 05/12 18:30 | Phòng 4 | E7
(4295, 9, 93, '2026-12-05T15:42:29', 149000, N'Paid', N'Cash', 150000, 10, 31, NULL, NULL, NULL), -- suat 736 | Bò Sữa Bay | 05/12 19:30 | Phòng 2 | D6 D7
(4296, 3, NULL, '2026-12-05T15:44:46', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | G6 G7
(4297, 3, NULL, '2026-12-05T15:44:47', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | G9 G10
(4298, 3, NULL, '2026-12-05T15:45:09', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 737 | Trại Giam Hạnh Phúc | 05/12 21:00 | Phòng 1 | J3 J4
(4299, 9, NULL, '2026-12-05T15:53:09', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 769 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 2 | H4 H5
(4300, 10, NULL, '2026-12-05T15:54:37', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | D6
(4301, 3, NULL, '2026-12-05T15:55:07', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 736 | Bò Sữa Bay | 05/12 19:30 | Phòng 2 | J7 J8
(4302, 10, NULL, '2026-12-05T15:58:56', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 735 | Godzilla Trừ Không | 05/12 18:30 | Phòng 4 | D6 D7
(4303, 10, 55, '2026-12-05T15:59:16', 174000, N'Paid', N'Cash', 174000, 12, 42, NULL, NULL, NULL), -- suat 767 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 21:00 | Phòng 4 | G5 G6
(4304, 10, NULL, '2026-12-05T16:00:50', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 731 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 17:15 | Phòng 2 | G6 G7 G8
(4305, 9, 109, '2026-12-05T16:01:44', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 747 | Ma Mút Con Vượt Kỷ Băng Hà | 06/12 11:15 | Phòng 2 | F8 F9
(4306, 9, 30, '2026-12-05T16:03:16', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 730 | Mẹ Mìn: Giao Kèo Với Quỷ | 05/12 16:15 | Phòng 1 | C6 C7
(4307, 3, NULL, '2026-12-05T16:05:31', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 738 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 21:00 | Phòng 4 | H6 H7
(4308, 10, NULL, '2026-12-05T16:06:12', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 743 | Hexed: Thế Giới Phép Thuật | 06/12 09:00 | Phòng 2 | C6 C7
(4309, 3, NULL, '2026-12-05T16:09:56', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 751 | Godzilla Trừ Không | 06/12 12:15 | Phòng 5 | G4 G5
(4310, 9, 42, '2026-12-05T16:10:38', 270000, N'Paid', N'Cash', 500000, 18, 0, NULL, NULL, NULL), -- suat 731 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 17:15 | Phòng 2 | D8 D9 D10
(4311, 3, NULL, '2026-12-05T16:12:50', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | J1 J2 J3 J4
(4312, 3, NULL, '2026-12-05T16:15:24', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 731 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 05/12 17:15 | Phòng 2 | D6 D7
(4313, 9, NULL, '2026-12-05T16:17:08', 864000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 732 | Dune: Hành Tinh Cát - Phần Hai | 05/12 18:00 | Phòng 5 | H3 H4 H5 H6 H7 H8
(4314, 3, NULL, '2026-12-05T16:19:05', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | H9 H10
(4315, 9, 80, '2026-12-05T16:23:45', 450000, N'Paid', N'Cash', 500000, 31, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | G8 G9 G10 G11 G12
(4316, 3, NULL, '2026-12-05T16:29:17', 108000, N'Paid', N'Cash', 108000, 0, 0, NULL, NULL, NULL), -- suat 738 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 21:00 | Phòng 4 | E6
(4317, 10, NULL, '2026-12-05T16:29:29', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 732 | Dune: Hành Tinh Cát - Phần Hai | 05/12 18:00 | Phòng 5 | H9 H10
(4318, 3, NULL, '2026-12-05T16:29:37', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | G7
(4319, 3, NULL, '2026-12-05T16:32:51', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 737 | Trại Giam Hạnh Phúc | 05/12 21:00 | Phòng 1 | G9 G10
(4320, 9, 119, '2026-12-05T16:34:26', 240000, N'Paid', N'Cash', 240000, 12, 0, NULL, NULL, NULL), -- suat 768 | Godzilla Trừ Không | 06/12 21:15 | Phòng 5 | C4 C5
(4321, 9, NULL, '2026-12-05T16:35:53', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 739 | Godzilla Trừ Không | 05/12 21:15 | Phòng 5 | C6 C7
(4322, 10, NULL, '2026-12-05T16:37:41', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | F8 F9
(4323, 10, NULL, '2026-12-05T16:37:50', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 755 | Ngày Con Còn Mẹ | 06/12 15:00 | Phòng 2 | D9 D10
(4324, 10, 67, '2026-12-05T16:40:22', 300000, N'Paid', N'Cash', 300000, 15, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | A7 A8 A9 A10
(4325, 9, 28, '2026-12-05T16:47:42', 90000, N'Paid', N'Transfer', NULL, 4, 0, NULL, NULL, NULL), -- suat 735 | Godzilla Trừ Không | 05/12 18:30 | Phòng 4 | C8
(4326, 3, NULL, '2026-12-05T16:48:13', 75000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | A6
(4327, 10, NULL, '2026-12-05T16:49:23', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | F10 F11
(4328, 9, 49, '2026-12-05T16:54:04', 324000, N'Paid', N'Transfer', NULL, 22, 36, NULL, NULL, NULL), -- suat 755 | Ngày Con Còn Mẹ | 06/12 15:00 | Phòng 2 | F6 F7 F8 F9
(4329, 3, 10, '2026-12-05T16:55:42', 90000, N'Paid', N'Cash', 500000, 6, 0, NULL, NULL, NULL), -- suat 752 | Hexed: Thế Giới Phép Thuật | 06/12 12:45 | Phòng 2 | H7
(4330, 9, 31, '2026-12-05T17:02:42', 395000, N'Paid', N'Transfer', NULL, 27, 55, NULL, NULL, NULL), -- suat 740 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 2 | G3 G4 G5 G6 G7
(4331, 9, NULL, '2026-12-05T17:02:44', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 738 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 21:00 | Phòng 4 | G7 G8
(4332, 10, 96, '2026-12-05T17:04:29', 324000, N'Paid', N'Cash', 324000, 22, 0, NULL, NULL, NULL), -- suat 735 | Godzilla Trừ Không | 05/12 18:30 | Phòng 4 | G6 G7 G8
(4333, 3, 43, '2026-12-05T17:11:25', 216000, N'Paid', N'Cash', 216000, 15, 0, NULL, NULL, NULL), -- suat 738 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 21:00 | Phòng 4 | D9 D10
(4334, 9, NULL, '2026-12-05T17:16:47', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | H5 H6 H7
(4335, 10, NULL, '2026-12-05T17:20:07', 75000, N'Paid', N'Cash', 75000, 0, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | C3
(4336, 10, NULL, '2026-12-05T17:20:35', 270000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | F5 F6 F7
(4337, 9, NULL, '2026-12-05T17:29:12', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 735 | Godzilla Trừ Không | 05/12 18:30 | Phòng 4 | G4 G5
(4338, 3, NULL, '2026-12-05T17:29:48', 720000, N'Cancelled', N'Cash', 720000, 0, 0, N'Khách đổi ý', '2026-12-05T17:52:05', 3), -- suat 732 | Dune: Hành Tinh Cát - Phần Hai | 05/12 18:00 | Phòng 5 | B5 B6 B7 B8 B9 B10
(4339, 3, 44, '2026-12-05T17:34:03', 90000, N'Paid', N'Cash', 100000, 4, 0, NULL, NULL, NULL), -- suat 738 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 21:00 | Phòng 4 | A6
(4340, 3, 67, '2026-12-05T17:35:14', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 762 | Bắt Cá Ba Tay | 06/12 18:30 | Phòng 1 | E4 E5
(4341, 3, 54, '2026-12-05T17:44:08', 324000, N'Paid', N'Transfer', NULL, 22, 0, NULL, NULL, NULL), -- suat 764 | Godzilla Trừ Không | 06/12 18:30 | Phòng 4 | E6 E7 E8
(4342, 9, NULL, '2026-12-05T17:45:50', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | E8 E9
(4343, 9, 82, '2026-12-05T17:46:42', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | G4 G5
(4344, 3, NULL, '2026-12-05T17:46:58', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 736 | Bò Sữa Bay | 05/12 19:30 | Phòng 2 | G8 G9
(4345, 10, NULL, '2026-12-05T17:47:15', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 735 | Godzilla Trừ Không | 05/12 18:30 | Phòng 4 | E8 E9
(4346, 9, NULL, '2026-12-05T17:49:53', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 739 | Godzilla Trừ Không | 05/12 21:15 | Phòng 5 | G8
(4347, 3, 92, '2026-12-05T17:51:34', 149000, N'Paid', N'Cash', 500000, 10, 31, NULL, NULL, NULL), -- suat 736 | Bò Sữa Bay | 05/12 19:30 | Phòng 2 | G2 G3
(4348, 9, 87, '2026-12-05T17:51:39', 158000, N'Paid', N'Transfer', NULL, 15, 22, NULL, NULL, NULL), -- suat 737 | Trại Giam Hạnh Phúc | 05/12 21:00 | Phòng 1 | J11 J12
(4349, 3, 69, '2026-12-05T17:52:04', 90000, N'Paid', N'Cash', 500000, 6, 0, NULL, NULL, NULL), -- suat 760 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 06/12 17:15 | Phòng 2 | F7
(4350, 10, 117, '2026-12-05T17:53:36', 180000, N'Paid', N'Transfer', NULL, 9, 0, NULL, NULL, NULL), -- suat 735 | Godzilla Trừ Không | 05/12 18:30 | Phòng 4 | C3 C4
(4351, 3, NULL, '2026-12-05T18:03:28', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 744 | Dune: Hành Tinh Cát - Phần Hai | 06/12 09:00 | Phòng 5 | E6 E7
(4352, 3, NULL, '2026-12-05T18:04:04', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | G11 G12
(4353, 3, 29, '2026-12-05T18:04:09', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 738 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 21:00 | Phòng 4 | H11 H12
(4354, 3, 90, '2026-12-05T18:07:17', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | H7 H8
(4355, 9, NULL, '2026-12-05T18:09:16', 540000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 735 | Godzilla Trừ Không | 05/12 18:30 | Phòng 4 | D8 D9 D10 D11 D12
(4356, 10, NULL, '2026-12-05T18:09:37', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | H10 H11
(4357, 3, NULL, '2026-12-05T18:10:10', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 739 | Godzilla Trừ Không | 05/12 21:15 | Phòng 5 | F6 F7
(4358, 10, NULL, '2026-12-05T18:11:35', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 733 | Bắt Cá Ba Tay | 05/12 18:30 | Phòng 1 | C7
(4359, 3, NULL, '2026-12-05T18:13:34', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | G5 G6
(4360, 9, NULL, '2026-12-05T18:13:59', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 734 | Điểm Mù | 05/12 18:30 | Phòng 3 | E10 E11 E12
(4361, 3, NULL, '2026-12-05T18:16:36', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 753 | Con Mắt Thứ Ba | 06/12 13:30 | Phòng 3 | G7
(4362, 3, 27, '2026-12-05T18:17:19', 360000, N'Paid', N'Card', NULL, 25, 0, NULL, NULL, NULL), -- suat 737 | Trại Giam Hạnh Phúc | 05/12 21:00 | Phòng 1 | E7 E8 E9 E10
(4363, 3, NULL, '2026-12-05T18:17:25', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 739 | Godzilla Trừ Không | 05/12 21:15 | Phòng 5 | G3 G4 G5
(4364, 9, 113, '2026-12-05T18:25:00', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 738 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 21:00 | Phòng 4 | H9 H10
(4365, 3, NULL, '2026-12-05T18:32:20', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 736 | Bò Sữa Bay | 05/12 19:30 | Phòng 2 | G10 G11
(4366, 9, 25, '2026-12-05T18:36:36', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 755 | Ngày Con Còn Mẹ | 06/12 15:00 | Phòng 2 | D6 D7
(4367, 3, 25, '2026-12-05T18:36:38', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 749 | Bắt Cá Ba Tay | 06/12 11:30 | Phòng 1 | C6 C7
(4368, 3, NULL, '2026-12-05T18:50:35', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 797 | Godzilla Trừ Không | 07/12 21:15 | Phòng 5 | E7 E8
(4369, 3, NULL, '2026-12-05T18:52:45', 360000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 741 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 3 | G5 G6 G7 G8
(4370, 3, NULL, '2026-12-05T18:57:38', 120000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 739 | Godzilla Trừ Không | 05/12 21:15 | Phòng 5 | C8
(4371, 3, NULL, '2026-12-05T19:02:11', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 741 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 3 | A6
(4372, 10, 65, '2026-12-05T19:05:21', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 741 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 3 | F4 F5
(4373, 3, NULL, '2026-12-05T19:06:30', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 736 | Bò Sữa Bay | 05/12 19:30 | Phòng 2 | J1 J2
(4374, 9, NULL, '2026-12-05T19:07:00', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 797 | Godzilla Trừ Không | 07/12 21:15 | Phòng 5 | L7 L8
(4375, 3, NULL, '2026-12-05T19:14:31', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 740 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 2 | G11 G12
(4376, 10, NULL, '2026-12-05T19:20:41', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 736 | Bò Sữa Bay | 05/12 19:30 | Phòng 2 | A5 A6
(4377, 3, NULL, '2026-12-05T19:31:24', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 741 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 3 | C5 C6 C7
(4378, 9, NULL, '2026-12-05T19:31:56', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 749 | Bắt Cá Ba Tay | 06/12 11:30 | Phòng 1 | F6 F7
(4379, 3, NULL, '2026-12-05T19:37:09', 324000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 738 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 21:00 | Phòng 4 | D6 D7 D8
(4380, 9, NULL, '2026-12-05T19:41:44', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 738 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 21:00 | Phòng 4 | H8
(4381, 10, NULL, '2026-12-05T19:52:18', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 738 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 21:00 | Phòng 4 | E9 E10
(4382, 3, NULL, '2026-12-05T19:57:44', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 737 | Trại Giam Hạnh Phúc | 05/12 21:00 | Phòng 1 | B6 B7
(4383, 3, NULL, '2026-12-05T19:58:18', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 767 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 21:00 | Phòng 4 | J5 J6
(4384, 9, NULL, '2026-12-05T20:01:26', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 740 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 2 | H7 H8
(4385, 3, NULL, '2026-12-05T20:07:06', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 741 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 3 | F6
(4386, 10, NULL, '2026-12-05T20:10:07', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 764 | Godzilla Trừ Không | 06/12 18:30 | Phòng 4 | J5 J6
(4387, 9, NULL, '2026-12-05T20:15:28', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 739 | Godzilla Trừ Không | 05/12 21:15 | Phòng 5 | L9 L10
(4388, 3, NULL, '2026-12-05T20:23:10', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 739 | Godzilla Trừ Không | 05/12 21:15 | Phòng 5 | E7 E8
(4389, 9, NULL, '2026-12-05T20:33:41', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 767 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 21:00 | Phòng 4 | E5 E6 E7 E8
(4390, 9, NULL, '2026-12-05T20:44:06', 150000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 740 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 2 | B6 B7
(4391, 3, 119, '2026-12-05T20:48:18', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 738 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 05/12 21:00 | Phòng 4 | E7 E8
(4392, 9, NULL, '2026-12-05T20:54:29', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 741 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 3 | G9 G10 G11
(4393, 9, NULL, '2026-12-05T20:58:07', 270000, N'Cancelled', N'Card', NULL, 0, 0, N'Lỗi thanh toán', '2026-12-05T21:34:32', 2), -- suat 740 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 2 | E7 E8 E9
(4394, 10, NULL, '2026-12-05T20:59:14', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 740 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 2 | C5 C6
(4395, 10, NULL, '2026-12-05T21:01:17', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 741 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 3 | B5 B6 B7
(4396, 9, NULL, '2026-12-05T21:03:03', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 743 | Hexed: Thế Giới Phép Thuật | 06/12 09:00 | Phòng 2 | E7 E8
(4397, 9, NULL, '2026-12-05T21:06:27', 90000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-12-05T21:33:10', 9), -- suat 741 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 3 | D6
(4398, 10, NULL, '2026-12-05T21:07:51', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 743 | Hexed: Thế Giới Phép Thuật | 06/12 09:00 | Phòng 2 | G6 G7
(4399, 10, NULL, '2026-12-05T21:07:59', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 739 | Godzilla Trừ Không | 05/12 21:15 | Phòng 5 | H6 H7 H8
(4400, 3, NULL, '2026-12-05T21:12:19', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 741 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 3 | D7 D8
(4401, 9, NULL, '2026-12-05T21:17:53', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 740 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 2 | H4 H5
(4402, 9, NULL, '2026-12-05T21:23:10', 576000, N'Paid', N'Cash', 576000, 0, 0, NULL, NULL, NULL), -- suat 761 | Dune: Hành Tinh Cát - Phần Hai | 06/12 18:00 | Phòng 5 | L7 L8 L9 L10
(4403, 10, 73, '2026-12-05T21:27:20', 180000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 760 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 06/12 17:15 | Phòng 2 | E6 E7
(4404, 3, NULL, '2026-12-05T21:29:53', 90000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 740 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 2 | E5
(4405, 3, NULL, '2026-12-05T21:34:58', 375000, N'Paid', N'Cash', 380000, 0, 0, NULL, NULL, NULL), -- suat 762 | Bắt Cá Ba Tay | 06/12 18:30 | Phòng 1 | A5 A6 A7 A8 A9
(4406, 10, NULL, '2026-12-05T21:36:03', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL); -- suat 740 | Con Mắt Thứ Ba | 05/12 21:45 | Phòng 2 | G9 G10
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(9524, 4157, 785, 5, 473, 120000, N'Active'),
(9525, 4157, 785, 5, 474, 120000, N'Active'),
(9526, 4157, 785, 5, 475, 120000, N'Active'),
(9527, 4157, 785, 5, 476, 120000, N'Active'),
(9528, 4157, 785, 5, 477, 120000, N'Active'),
(9529, 4158, 744, 5, 557, 144000, N'Active'),
(9530, 4158, 744, 5, 558, 144000, N'Active'),
(9531, 4159, 745, 4, 328, 90000, N'Active'),
(9532, 4159, 745, 4, 329, 90000, N'Active'),
(9533, 4159, 745, 4, 330, 90000, N'Active'),
(9534, 4159, 745, 4, 331, 90000, N'Active'),
(9535, 4160, 713, 1, 101, 90000, N'Active'),
(9536, 4160, 713, 1, 102, 90000, N'Active'),
(9537, 4161, 717, 3, 305, 90000, N'Cancelled'),
(9538, 4161, 717, 3, 306, 90000, N'Cancelled'),
(9539, 4162, 724, 3, 282, 90000, N'Active'),
(9540, 4162, 724, 3, 283, 90000, N'Active'),
(9541, 4163, 716, 4, 427, 108000, N'Active'),
(9542, 4163, 716, 4, 428, 108000, N'Active'),
(9543, 4164, 718, 2, 150, 90000, N'Active'),
(9544, 4164, 718, 2, 151, 90000, N'Active'),
(9545, 4165, 713, 1, 54, 90000, N'Active'),
(9546, 4165, 713, 1, 55, 90000, N'Active'),
(9547, 4166, 721, 4, 329, 90000, N'Active'),
(9548, 4166, 721, 4, 330, 90000, N'Active'),
(9549, 4167, 724, 3, 270, 90000, N'Active'),
(9550, 4167, 724, 3, 271, 90000, N'Active'),
(9551, 4168, 716, 4, 330, 90000, N'Active'),
(9552, 4168, 716, 4, 331, 90000, N'Active'),
(9553, 4169, 714, 2, 174, 90000, N'Active'),
(9554, 4170, 728, 3, 280, 90000, N'Active'),
(9555, 4171, 713, 1, 67, 90000, N'Active'),
(9556, 4171, 713, 1, 68, 90000, N'Active'),
(9557, 4172, 792, 3, 282, 90000, N'Active'),
(9558, 4173, 714, 2, 184, 90000, N'Active'),
(9559, 4173, 714, 2, 185, 90000, N'Active'),
(9560, 4173, 714, 2, 186, 90000, N'Active'),
(9561, 4173, 714, 2, 187, 90000, N'Active'),
(9562, 4173, 714, 2, 188, 90000, N'Active'),
(9563, 4174, 770, 3, 283, 90000, N'Active'),
(9564, 4174, 770, 3, 284, 90000, N'Active'),
(9565, 4175, 732, 5, 463, 120000, N'Active'),
(9566, 4175, 732, 5, 464, 120000, N'Active'),
(9567, 4176, 715, 5, 497, 144000, N'Active'),
(9568, 4176, 715, 5, 498, 144000, N'Active'),
(9569, 4176, 715, 5, 499, 144000, N'Active'),
(9570, 4177, 715, 5, 534, 144000, N'Active'),
(9571, 4177, 715, 5, 535, 144000, N'Active'),
(9572, 4178, 713, 1, 81, 90000, N'Active'),
(9573, 4179, 715, 5, 547, 144000, N'Active'),
(9574, 4180, 717, 3, 307, 90000, N'Active'),
(9575, 4180, 717, 3, 308, 90000, N'Active'),
(9576, 4181, 716, 4, 366, 108000, N'Active'),
(9577, 4181, 716, 4, 367, 108000, N'Active'),
(9578, 4182, 716, 4, 379, 108000, N'Active'),
(9579, 4182, 716, 4, 380, 108000, N'Active'),
(9580, 4183, 722, 5, 561, 144000, N'Active'),
(9581, 4183, 722, 5, 562, 144000, N'Active'),
(9582, 4184, 756, 5, 497, 144000, N'Active'),
(9583, 4185, 720, 1, 78, 90000, N'Active'),
(9584, 4185, 720, 1, 79, 90000, N'Active'),
(9585, 4186, 717, 3, 282, 90000, N'Active'),
(9586, 4186, 717, 3, 283, 90000, N'Active'),
(9587, 4187, 752, 2, 182, 90000, N'Active'),
(9588, 4187, 752, 2, 183, 90000, N'Active'),
(9589, 4187, 752, 2, 184, 90000, N'Active'),
(9590, 4187, 752, 2, 185, 90000, N'Active'),
(9591, 4187, 752, 2, 186, 90000, N'Active'),
(9592, 4187, 752, 2, 187, 90000, N'Active'),
(9593, 4188, 752, 2, 126, 75000, N'Active'),
(9594, 4188, 752, 2, 127, 75000, N'Active'),
(9595, 4189, 734, 3, 249, 75000, N'Active'),
(9596, 4189, 734, 3, 250, 75000, N'Active'),
(9597, 4190, 720, 1, 54, 90000, N'Active'),
(9598, 4190, 720, 1, 55, 90000, N'Active'),
(9599, 4190, 720, 1, 56, 90000, N'Active'),
(9600, 4191, 719, 3, 282, 90000, N'Cancelled'),
(9601, 4191, 719, 3, 283, 90000, N'Cancelled'),
(9602, 4191, 719, 3, 284, 90000, N'Cancelled'),
(9603, 4192, 758, 4, 368, 108000, N'Active'),
(9604, 4192, 758, 4, 369, 108000, N'Active'),
(9605, 4193, 728, 3, 258, 90000, N'Active'),
(9606, 4193, 728, 3, 259, 90000, N'Active'),
(9607, 4194, 765, 2, 127, 75000, N'Active'),
(9608, 4194, 765, 2, 128, 75000, N'Active'),
(9609, 4194, 765, 2, 129, 75000, N'Active'),
(9610, 4195, 751, 5, 449, 120000, N'Active'),
(9611, 4196, 722, 5, 523, 144000, N'Active'),
(9612, 4196, 722, 5, 524, 144000, N'Active'),
(9613, 4197, 742, 1, 54, 90000, N'Active'),
(9614, 4198, 762, 1, 66, 90000, N'Active'),
(9615, 4198, 762, 1, 67, 90000, N'Active'),
(9616, 4198, 762, 1, 68, 90000, N'Active'),
(9617, 4199, 732, 5, 437, 120000, N'Active'),
(9618, 4199, 732, 5, 438, 120000, N'Active'),
(9619, 4199, 732, 5, 439, 120000, N'Active'),
(9620, 4199, 732, 5, 440, 120000, N'Active'),
(9621, 4200, 723, 2, 186, 90000, N'Active'),
(9622, 4200, 723, 2, 187, 90000, N'Active'),
(9623, 4200, 723, 2, 188, 90000, N'Active'),
(9624, 4201, 722, 5, 497, 144000, N'Active'),
(9625, 4201, 722, 5, 498, 144000, N'Active'),
(9626, 4202, 732, 5, 447, 120000, N'Active'),
(9627, 4203, 733, 1, 5, 75000, N'Active'),
(9628, 4203, 733, 1, 6, 75000, N'Active'),
(9629, 4204, 723, 2, 197, 90000, N'Cancelled'),
(9630, 4205, 759, 1, 67, 90000, N'Active'),
(9631, 4205, 759, 1, 68, 90000, N'Active'),
(9632, 4206, 770, 3, 222, 75000, N'Active'),
(9633, 4206, 770, 3, 223, 75000, N'Active'),
(9634, 4207, 739, 5, 502, 144000, N'Active'),
(9635, 4207, 739, 5, 503, 144000, N'Active'),
(9636, 4208, 721, 4, 389, 108000, N'Active'),
(9637, 4209, 726, 2, 207, 90000, N'Active'),
(9638, 4209, 726, 2, 208, 90000, N'Active'),
(9639, 4210, 725, 1, 97, 90000, N'Active'),
(9640, 4210, 725, 1, 98, 90000, N'Active'),
(9641, 4210, 725, 1, 99, 90000, N'Active'),
(9642, 4210, 725, 1, 100, 90000, N'Active'),
(9643, 4211, 733, 1, 92, 90000, N'Active'),
(9644, 4211, 733, 1, 93, 90000, N'Active'),
(9645, 4212, 797, 5, 510, 144000, N'Active'),
(9646, 4212, 797, 5, 511, 144000, N'Active'),
(9647, 4213, 723, 2, 196, 90000, N'Active'),
(9648, 4214, 729, 4, 365, 108000, N'Active'),
(9649, 4214, 729, 4, 366, 108000, N'Active'),
(9650, 4215, 728, 3, 296, 90000, N'Active'),
(9651, 4215, 728, 3, 297, 90000, N'Active'),
(9652, 4216, 724, 3, 315, 90000, N'Active'),
(9653, 4216, 724, 3, 316, 90000, N'Active'),
(9654, 4217, 722, 5, 462, 120000, N'Active'),
(9655, 4218, 720, 1, 67, 90000, N'Active'),
(9656, 4218, 720, 1, 68, 90000, N'Active'),
(9657, 4218, 720, 1, 69, 90000, N'Active'),
(9658, 4218, 720, 1, 70, 90000, N'Active'),
(9659, 4219, 723, 2, 173, 90000, N'Cancelled'),
(9660, 4219, 723, 2, 174, 90000, N'Cancelled'),
(9661, 4219, 723, 2, 175, 90000, N'Cancelled'),
(9662, 4220, 736, 2, 116, 75000, N'Active'),
(9663, 4220, 736, 2, 117, 75000, N'Active'),
(9664, 4221, 768, 5, 499, 144000, N'Active'),
(9665, 4221, 768, 5, 500, 144000, N'Active'),
(9666, 4221, 768, 5, 501, 144000, N'Active'),
(9667, 4222, 748, 3, 246, 75000, N'Active'),
(9668, 4222, 748, 3, 247, 75000, N'Active'),
(9669, 4223, 722, 5, 494, 144000, N'Active'),
(9670, 4223, 722, 5, 495, 144000, N'Active'),
(9671, 4223, 722, 5, 496, 144000, N'Active'),
(9672, 4224, 751, 5, 521, 144000, N'Active'),
(9673, 4224, 751, 5, 522, 144000, N'Active'),
(9674, 4225, 721, 4, 340, 90000, N'Active'),
(9675, 4225, 721, 4, 341, 90000, N'Active'),
(9676, 4225, 721, 4, 342, 90000, N'Active'),
(9677, 4226, 721, 4, 366, 108000, N'Active'),
(9678, 4227, 739, 5, 484, 144000, N'Active'),
(9679, 4227, 739, 5, 485, 144000, N'Active'),
(9680, 4227, 739, 5, 486, 144000, N'Active'),
(9681, 4228, 735, 4, 423, 108000, N'Active'),
(9682, 4228, 735, 4, 424, 108000, N'Active'),
(9683, 4229, 733, 1, 74, 90000, N'Active'),
(9684, 4229, 733, 1, 75, 90000, N'Active'),
(9685, 4230, 732, 5, 481, 144000, N'Active'),
(9686, 4230, 732, 5, 482, 144000, N'Active'),
(9687, 4230, 732, 5, 483, 144000, N'Active'),
(9688, 4231, 722, 5, 533, 144000, N'Active'),
(9689, 4231, 722, 5, 534, 144000, N'Active'),
(9690, 4232, 726, 2, 165, 90000, N'Active'),
(9691, 4232, 726, 2, 166, 90000, N'Active'),
(9692, 4233, 722, 5, 487, 144000, N'Active'),
(9693, 4234, 769, 2, 209, 90000, N'Active'),
(9694, 4234, 769, 2, 210, 90000, N'Active'),
(9695, 4235, 758, 4, 353, 90000, N'Active'),
(9696, 4235, 758, 4, 354, 90000, N'Active'),
(9697, 4235, 758, 4, 355, 90000, N'Active'),
(9698, 4235, 758, 4, 356, 90000, N'Active'),
(9699, 4235, 758, 4, 357, 90000, N'Active'),
(9700, 4236, 727, 5, 530, 144000, N'Active'),
(9701, 4236, 727, 5, 531, 144000, N'Active'),
(9702, 4237, 736, 2, 186, 90000, N'Active'),
(9703, 4238, 724, 3, 278, 90000, N'Active'),
(9704, 4238, 724, 3, 279, 90000, N'Active'),
(9705, 4238, 724, 3, 280, 90000, N'Active'),
(9706, 4239, 761, 5, 553, 144000, N'Active'),
(9707, 4239, 761, 5, 554, 144000, N'Active'),
(9708, 4240, 725, 1, 103, 90000, N'Active'),
(9709, 4240, 725, 1, 104, 90000, N'Active'),
(9710, 4240, 725, 1, 105, 90000, N'Active'),
(9711, 4240, 725, 1, 106, 90000, N'Active'),
(9712, 4241, 723, 2, 150, 90000, N'Active'),
(9713, 4241, 723, 2, 151, 90000, N'Active'),
(9714, 4242, 727, 5, 500, 144000, N'Active'),
(9715, 4242, 727, 5, 501, 144000, N'Active'),
(9716, 4242, 727, 5, 502, 144000, N'Active'),
(9717, 4243, 755, 2, 148, 90000, N'Active'),
(9718, 4243, 755, 2, 149, 90000, N'Active'),
(9719, 4244, 732, 5, 486, 144000, N'Active'),
(9720, 4244, 732, 5, 487, 144000, N'Active'),
(9721, 4245, 784, 2, 151, 90000, N'Active'),
(9722, 4245, 784, 2, 152, 90000, N'Active'),
(9723, 4245, 784, 2, 153, 90000, N'Active'),
(9724, 4245, 784, 2, 154, 90000, N'Active'),
(9725, 4246, 731, 2, 209, 90000, N'Active'),
(9726, 4246, 731, 2, 210, 90000, N'Active'),
(9727, 4247, 734, 3, 235, 75000, N'Active'),
(9728, 4247, 734, 3, 236, 75000, N'Active'),
(9729, 4248, 750, 4, 413, 108000, N'Active'),
(9730, 4248, 750, 4, 414, 108000, N'Active'),
(9731, 4248, 750, 4, 415, 108000, N'Active'),
(9732, 4249, 729, 4, 397, 108000, N'Active'),
(9733, 4249, 729, 4, 398, 108000, N'Active'),
(9734, 4250, 733, 1, 54, 90000, N'Active'),
(9735, 4250, 733, 1, 55, 90000, N'Active'),
(9736, 4251, 753, 3, 280, 90000, N'Active'),
(9737, 4251, 753, 3, 281, 90000, N'Active'),
(9738, 4252, 726, 2, 114, 75000, N'Active'),
(9739, 4253, 727, 5, 557, 144000, N'Active'),
(9740, 4253, 727, 5, 558, 144000, N'Active'),
(9741, 4253, 727, 5, 559, 144000, N'Active'),
(9742, 4253, 727, 5, 560, 144000, N'Active'),
(9743, 4254, 724, 3, 255, 90000, N'Active'),
(9744, 4254, 724, 3, 256, 90000, N'Active'),
(9745, 4254, 724, 3, 257, 90000, N'Active'),
(9746, 4255, 728, 3, 294, 90000, N'Active'),
(9747, 4255, 728, 3, 295, 90000, N'Active'),
(9748, 4256, 731, 2, 114, 75000, N'Active'),
(9749, 4256, 731, 2, 115, 75000, N'Active'),
(9750, 4257, 759, 1, 31, 75000, N'Active'),
(9751, 4258, 770, 3, 257, 90000, N'Active'),
(9752, 4259, 727, 5, 539, 144000, N'Active'),
(9753, 4259, 727, 5, 540, 144000, N'Active'),
(9754, 4260, 798, 2, 162, 90000, N'Active'),
(9755, 4260, 798, 2, 163, 90000, N'Active'),
(9756, 4260, 798, 2, 164, 90000, N'Active'),
(9757, 4261, 761, 5, 547, 144000, N'Active'),
(9758, 4261, 761, 5, 548, 144000, N'Active'),
(9759, 4262, 747, 2, 114, 75000, N'Active'),
(9760, 4262, 747, 2, 115, 75000, N'Active'),
(9761, 4263, 749, 1, 55, 90000, N'Active'),
(9762, 4263, 749, 1, 56, 90000, N'Active'),
(9763, 4264, 728, 3, 317, 90000, N'Active'),
(9764, 4264, 728, 3, 318, 90000, N'Active'),
(9765, 4264, 728, 3, 319, 90000, N'Active'),
(9766, 4264, 728, 3, 320, 90000, N'Active'),
(9767, 4265, 727, 5, 535, 144000, N'Active'),
(9768, 4265, 727, 5, 536, 144000, N'Active'),
(9769, 4265, 727, 5, 537, 144000, N'Active'),
(9770, 4265, 727, 5, 538, 144000, N'Active'),
(9771, 4266, 762, 1, 29, 75000, N'Active'),
(9772, 4266, 762, 1, 30, 75000, N'Active'),
(9773, 4267, 731, 2, 162, 90000, N'Active'),
(9774, 4267, 731, 2, 163, 90000, N'Active'),
(9775, 4268, 727, 5, 534, 144000, N'Active'),
(9776, 4269, 760, 2, 187, 90000, N'Cancelled'),
(9777, 4270, 729, 4, 388, 108000, N'Active'),
(9778, 4270, 729, 4, 389, 108000, N'Active'),
(9779, 4271, 732, 5, 549, 144000, N'Active'),
(9780, 4272, 726, 2, 188, 90000, N'Active'),
(9781, 4272, 726, 2, 189, 90000, N'Active'),
(9782, 4273, 738, 4, 412, 108000, N'Cancelled'),
(9783, 4274, 726, 2, 198, 90000, N'Active'),
(9784, 4274, 726, 2, 199, 90000, N'Active'),
(9785, 4275, 727, 5, 520, 144000, N'Active'),
(9786, 4275, 727, 5, 521, 144000, N'Active'),
(9787, 4276, 727, 5, 533, 144000, N'Active'),
(9788, 4277, 732, 5, 544, 144000, N'Active'),
(9789, 4277, 732, 5, 545, 144000, N'Active'),
(9790, 4277, 732, 5, 546, 144000, N'Active'),
(9791, 4277, 732, 5, 547, 144000, N'Active'),
(9792, 4278, 736, 2, 215, 90000, N'Active'),
(9793, 4278, 736, 2, 216, 90000, N'Active'),
(9794, 4279, 726, 2, 196, 90000, N'Active'),
(9795, 4279, 726, 2, 197, 90000, N'Active'),
(9796, 4280, 727, 5, 546, 144000, N'Active'),
(9797, 4280, 727, 5, 547, 144000, N'Active'),
(9798, 4281, 734, 3, 305, 90000, N'Active'),
(9799, 4281, 734, 3, 306, 90000, N'Active'),
(9800, 4282, 769, 2, 199, 90000, N'Active'),
(9801, 4282, 769, 2, 200, 90000, N'Active'),
(9802, 4283, 729, 4, 404, 108000, N'Active'),
(9803, 4283, 729, 4, 405, 108000, N'Active'),
(9804, 4284, 731, 2, 138, 75000, N'Active'),
(9805, 4284, 731, 2, 139, 75000, N'Active'),
(9806, 4285, 751, 5, 533, 144000, N'Active'),
(9807, 4285, 751, 5, 534, 144000, N'Active'),
(9808, 4286, 728, 3, 234, 75000, N'Active'),
(9809, 4286, 728, 3, 235, 75000, N'Active'),
(9810, 4286, 728, 3, 236, 75000, N'Active'),
(9811, 4287, 736, 2, 160, 90000, N'Active'),
(9812, 4287, 736, 2, 161, 90000, N'Active'),
(9813, 4288, 735, 4, 411, 108000, N'Active'),
(9814, 4288, 735, 4, 412, 108000, N'Active'),
(9815, 4288, 735, 4, 413, 108000, N'Active'),
(9816, 4288, 735, 4, 414, 108000, N'Active'),
(9817, 4289, 738, 4, 401, 108000, N'Active'),
(9818, 4289, 738, 4, 402, 108000, N'Active'),
(9819, 4290, 734, 3, 289, 90000, N'Active'),
(9820, 4290, 734, 3, 290, 90000, N'Active'),
(9821, 4290, 734, 3, 291, 90000, N'Active'),
(9822, 4290, 734, 3, 292, 90000, N'Active'),
(9823, 4291, 731, 2, 183, 90000, N'Active'),
(9824, 4291, 731, 2, 184, 90000, N'Active'),
(9825, 4292, 747, 2, 152, 90000, N'Active'),
(9826, 4292, 747, 2, 153, 90000, N'Active'),
(9827, 4293, 765, 2, 197, 90000, N'Active'),
(9828, 4293, 765, 2, 198, 90000, N'Active'),
(9829, 4294, 735, 4, 379, 108000, N'Active'),
(9830, 4295, 736, 2, 150, 90000, N'Active'),
(9831, 4295, 736, 2, 151, 90000, N'Active'),
(9832, 4296, 733, 1, 78, 90000, N'Active'),
(9833, 4296, 733, 1, 79, 90000, N'Active'),
(9834, 4297, 733, 1, 81, 90000, N'Active'),
(9835, 4297, 733, 1, 82, 90000, N'Active'),
(9836, 4298, 737, 1, 99, 90000, N'Active'),
(9837, 4298, 737, 1, 100, 90000, N'Active'),
(9838, 4299, 769, 2, 196, 90000, N'Active'),
(9839, 4299, 769, 2, 197, 90000, N'Active'),
(9840, 4300, 734, 3, 258, 90000, N'Active'),
(9841, 4301, 736, 2, 211, 90000, N'Active'),
(9842, 4301, 736, 2, 212, 90000, N'Active'),
(9843, 4302, 735, 4, 366, 108000, N'Active'),
(9844, 4302, 735, 4, 367, 108000, N'Active'),
(9845, 4303, 767, 4, 401, 108000, N'Active'),
(9846, 4303, 767, 4, 402, 108000, N'Active'),
(9847, 4304, 731, 2, 186, 90000, N'Active'),
(9848, 4304, 731, 2, 187, 90000, N'Active'),
(9849, 4304, 731, 2, 188, 90000, N'Active'),
(9850, 4305, 747, 2, 176, 90000, N'Active'),
(9851, 4305, 747, 2, 177, 90000, N'Active'),
(9852, 4306, 730, 1, 30, 75000, N'Active'),
(9853, 4306, 730, 1, 31, 75000, N'Active'),
(9854, 4307, 738, 4, 414, 108000, N'Active'),
(9855, 4307, 738, 4, 415, 108000, N'Active'),
(9856, 4308, 743, 2, 138, 75000, N'Active'),
(9857, 4308, 743, 2, 139, 75000, N'Active'),
(9858, 4309, 751, 5, 508, 144000, N'Active'),
(9859, 4309, 751, 5, 509, 144000, N'Active'),
(9860, 4310, 731, 2, 152, 90000, N'Active'),
(9861, 4310, 731, 2, 153, 90000, N'Active'),
(9862, 4310, 731, 2, 154, 90000, N'Active'),
(9863, 4311, 733, 1, 97, 90000, N'Active'),
(9864, 4311, 733, 1, 98, 90000, N'Active'),
(9865, 4311, 733, 1, 99, 90000, N'Active'),
(9866, 4311, 733, 1, 100, 90000, N'Active'),
(9867, 4312, 731, 2, 150, 90000, N'Active'),
(9868, 4312, 731, 2, 151, 90000, N'Active'),
(9869, 4313, 732, 5, 519, 144000, N'Active'),
(9870, 4313, 732, 5, 520, 144000, N'Active'),
(9871, 4313, 732, 5, 521, 144000, N'Active'),
(9872, 4313, 732, 5, 522, 144000, N'Active'),
(9873, 4313, 732, 5, 523, 144000, N'Active'),
(9874, 4313, 732, 5, 524, 144000, N'Active'),
(9875, 4314, 734, 3, 309, 90000, N'Active'),
(9876, 4314, 734, 3, 310, 90000, N'Active'),
(9877, 4315, 734, 3, 296, 90000, N'Active'),
(9878, 4315, 734, 3, 297, 90000, N'Active'),
(9879, 4315, 734, 3, 298, 90000, N'Active'),
(9880, 4315, 734, 3, 299, 90000, N'Active'),
(9881, 4315, 734, 3, 300, 90000, N'Active'),
(9882, 4316, 738, 4, 378, 108000, N'Active'),
(9883, 4317, 732, 5, 525, 144000, N'Active'),
(9884, 4317, 732, 5, 526, 144000, N'Active'),
(9885, 4318, 734, 3, 295, 90000, N'Active'),
(9886, 4319, 737, 1, 81, 90000, N'Active'),
(9887, 4319, 737, 1, 82, 90000, N'Active'),
(9888, 4320, 768, 5, 460, 120000, N'Active'),
(9889, 4320, 768, 5, 461, 120000, N'Active'),
(9890, 4321, 739, 5, 462, 120000, N'Active'),
(9891, 4321, 739, 5, 463, 120000, N'Active'),
(9892, 4322, 733, 1, 68, 90000, N'Active'),
(9893, 4322, 733, 1, 69, 90000, N'Active'),
(9894, 4323, 755, 2, 153, 90000, N'Active'),
(9895, 4323, 755, 2, 154, 90000, N'Active'),
(9896, 4324, 733, 1, 7, 75000, N'Active'),
(9897, 4324, 733, 1, 8, 75000, N'Active'),
(9898, 4324, 733, 1, 9, 75000, N'Active'),
(9899, 4324, 733, 1, 10, 75000, N'Active'),
(9900, 4325, 735, 4, 356, 90000, N'Active'),
(9901, 4326, 734, 3, 222, 75000, N'Active'),
(9902, 4327, 733, 1, 70, 90000, N'Active'),
(9903, 4327, 733, 1, 71, 90000, N'Active'),
(9904, 4328, 755, 2, 174, 90000, N'Active'),
(9905, 4328, 755, 2, 175, 90000, N'Active'),
(9906, 4328, 755, 2, 176, 90000, N'Active'),
(9907, 4328, 755, 2, 177, 90000, N'Active'),
(9908, 4329, 752, 2, 199, 90000, N'Active'),
(9909, 4330, 740, 2, 183, 90000, N'Active'),
(9910, 4330, 740, 2, 184, 90000, N'Active'),
(9911, 4330, 740, 2, 185, 90000, N'Active'),
(9912, 4330, 740, 2, 186, 90000, N'Active'),
(9913, 4330, 740, 2, 187, 90000, N'Active'),
(9914, 4331, 738, 4, 403, 108000, N'Active'),
(9915, 4331, 738, 4, 404, 108000, N'Active'),
(9916, 4332, 735, 4, 402, 108000, N'Active'),
(9917, 4332, 735, 4, 403, 108000, N'Active'),
(9918, 4332, 735, 4, 404, 108000, N'Active'),
(9919, 4333, 738, 4, 369, 108000, N'Active'),
(9920, 4333, 738, 4, 370, 108000, N'Active'),
(9921, 4334, 733, 1, 89, 90000, N'Active'),
(9922, 4334, 733, 1, 90, 90000, N'Active'),
(9923, 4334, 733, 1, 91, 90000, N'Active'),
(9924, 4335, 734, 3, 243, 75000, N'Active'),
(9925, 4336, 734, 3, 281, 90000, N'Active'),
(9926, 4336, 734, 3, 282, 90000, N'Active'),
(9927, 4336, 734, 3, 283, 90000, N'Active'),
(9928, 4337, 735, 4, 400, 108000, N'Active'),
(9929, 4337, 735, 4, 401, 108000, N'Active'),
(9930, 4338, 732, 5, 449, 120000, N'Cancelled'),
(9931, 4338, 732, 5, 450, 120000, N'Cancelled'),
(9932, 4338, 732, 5, 451, 120000, N'Cancelled'),
(9933, 4338, 732, 5, 452, 120000, N'Cancelled'),
(9934, 4338, 732, 5, 453, 120000, N'Cancelled'),
(9935, 4338, 732, 5, 454, 120000, N'Cancelled'),
(9936, 4339, 738, 4, 330, 90000, N'Active'),
(9937, 4340, 762, 1, 52, 90000, N'Active'),
(9938, 4340, 762, 1, 53, 90000, N'Active'),
(9939, 4341, 764, 4, 378, 108000, N'Active'),
(9940, 4341, 764, 4, 379, 108000, N'Active'),
(9941, 4341, 764, 4, 380, 108000, N'Active'),
(9942, 4342, 734, 3, 272, 90000, N'Active'),
(9943, 4342, 734, 3, 273, 90000, N'Active'),
(9944, 4343, 733, 1, 76, 90000, N'Active'),
(9945, 4343, 733, 1, 77, 90000, N'Active'),
(9946, 4344, 736, 2, 188, 90000, N'Active'),
(9947, 4344, 736, 2, 189, 90000, N'Active'),
(9948, 4345, 735, 4, 380, 108000, N'Active'),
(9949, 4345, 735, 4, 381, 108000, N'Active'),
(9950, 4346, 739, 5, 512, 144000, N'Active'),
(9951, 4347, 736, 2, 182, 90000, N'Active'),
(9952, 4347, 736, 2, 183, 90000, N'Active'),
(9953, 4348, 737, 1, 107, 90000, N'Active'),
(9954, 4348, 737, 1, 108, 90000, N'Active'),
(9955, 4349, 760, 2, 175, 90000, N'Active'),
(9956, 4350, 735, 4, 351, 90000, N'Active'),
(9957, 4350, 735, 4, 352, 90000, N'Active'),
(9958, 4351, 744, 5, 486, 144000, N'Active'),
(9959, 4351, 744, 5, 487, 144000, N'Active'),
(9960, 4352, 733, 1, 83, 90000, N'Active'),
(9961, 4352, 733, 1, 84, 90000, N'Active'),
(9962, 4353, 738, 4, 419, 108000, N'Active'),
(9963, 4353, 738, 4, 420, 108000, N'Active'),
(9964, 4354, 734, 3, 307, 90000, N'Active'),
(9965, 4354, 734, 3, 308, 90000, N'Active'),
(9966, 4355, 735, 4, 368, 108000, N'Active'),
(9967, 4355, 735, 4, 369, 108000, N'Active'),
(9968, 4355, 735, 4, 370, 108000, N'Active'),
(9969, 4355, 735, 4, 371, 108000, N'Active'),
(9970, 4355, 735, 4, 372, 108000, N'Active'),
(9971, 4356, 733, 1, 94, 90000, N'Active'),
(9972, 4356, 733, 1, 95, 90000, N'Active'),
(9973, 4357, 739, 5, 498, 144000, N'Active'),
(9974, 4357, 739, 5, 499, 144000, N'Active'),
(9975, 4358, 733, 1, 31, 75000, N'Active'),
(9976, 4359, 734, 3, 293, 90000, N'Active'),
(9977, 4359, 734, 3, 294, 90000, N'Active'),
(9978, 4360, 734, 3, 274, 90000, N'Active'),
(9979, 4360, 734, 3, 275, 90000, N'Active'),
(9980, 4360, 734, 3, 276, 90000, N'Active'),
(9981, 4361, 753, 3, 295, 90000, N'Active'),
(9982, 4362, 737, 1, 55, 90000, N'Active'),
(9983, 4362, 737, 1, 56, 90000, N'Active'),
(9984, 4362, 737, 1, 57, 90000, N'Active'),
(9985, 4362, 737, 1, 58, 90000, N'Active'),
(9986, 4363, 739, 5, 507, 144000, N'Active'),
(9987, 4363, 739, 5, 508, 144000, N'Active'),
(9988, 4363, 739, 5, 509, 144000, N'Active'),
(9989, 4364, 738, 4, 417, 108000, N'Active'),
(9990, 4364, 738, 4, 418, 108000, N'Active'),
(9991, 4365, 736, 2, 190, 90000, N'Active'),
(9992, 4365, 736, 2, 191, 90000, N'Active'),
(9993, 4366, 755, 2, 150, 90000, N'Active'),
(9994, 4366, 755, 2, 151, 90000, N'Active'),
(9995, 4367, 749, 1, 30, 75000, N'Active'),
(9996, 4367, 749, 1, 31, 75000, N'Active'),
(9997, 4368, 797, 5, 487, 144000, N'Active'),
(9998, 4368, 797, 5, 488, 144000, N'Active'),
(9999, 4369, 741, 3, 293, 90000, N'Active'),
(10000, 4369, 741, 3, 294, 90000, N'Active'),
(10001, 4369, 741, 3, 295, 90000, N'Active'),
(10002, 4369, 741, 3, 296, 90000, N'Active'),
(10003, 4370, 739, 5, 464, 120000, N'Active'),
(10004, 4371, 741, 3, 222, 75000, N'Active'),
(10005, 4372, 741, 3, 280, 90000, N'Active'),
(10006, 4372, 741, 3, 281, 90000, N'Active'),
(10007, 4373, 736, 2, 205, 90000, N'Active'),
(10008, 4373, 736, 2, 206, 90000, N'Active'),
(10009, 4374, 797, 5, 559, 144000, N'Active'),
(10010, 4374, 797, 5, 560, 144000, N'Active'),
(10011, 4375, 740, 2, 191, 90000, N'Active'),
(10012, 4375, 740, 2, 192, 90000, N'Active'),
(10013, 4376, 736, 2, 113, 75000, N'Active'),
(10014, 4376, 736, 2, 114, 75000, N'Active'),
(10015, 4377, 741, 3, 245, 75000, N'Active'),
(10016, 4377, 741, 3, 246, 75000, N'Active'),
(10017, 4377, 741, 3, 247, 75000, N'Active'),
(10018, 4378, 749, 1, 66, 90000, N'Active'),
(10019, 4378, 749, 1, 67, 90000, N'Active'),
(10020, 4379, 738, 4, 366, 108000, N'Active'),
(10021, 4379, 738, 4, 367, 108000, N'Active'),
(10022, 4379, 738, 4, 368, 108000, N'Active'),
(10023, 4380, 738, 4, 416, 108000, N'Active'),
(10024, 4381, 738, 4, 381, 108000, N'Active'),
(10025, 4381, 738, 4, 382, 108000, N'Active'),
(10026, 4382, 737, 1, 18, 75000, N'Active'),
(10027, 4382, 737, 1, 19, 75000, N'Active'),
(10028, 4383, 767, 4, 425, 108000, N'Active'),
(10029, 4383, 767, 4, 426, 108000, N'Active'),
(10030, 4384, 740, 2, 199, 90000, N'Active'),
(10031, 4384, 740, 2, 200, 90000, N'Active'),
(10032, 4385, 741, 3, 282, 90000, N'Active'),
(10033, 4386, 764, 4, 425, 108000, N'Active'),
(10034, 4386, 764, 4, 426, 108000, N'Active'),
(10035, 4387, 739, 5, 561, 144000, N'Active'),
(10036, 4387, 739, 5, 562, 144000, N'Active'),
(10037, 4388, 739, 5, 487, 144000, N'Active'),
(10038, 4388, 739, 5, 488, 144000, N'Active'),
(10039, 4389, 767, 4, 377, 108000, N'Active'),
(10040, 4389, 767, 4, 378, 108000, N'Active'),
(10041, 4389, 767, 4, 379, 108000, N'Active'),
(10042, 4389, 767, 4, 380, 108000, N'Active'),
(10043, 4390, 740, 2, 126, 75000, N'Active'),
(10044, 4390, 740, 2, 127, 75000, N'Active'),
(10045, 4391, 738, 4, 379, 108000, N'Active'),
(10046, 4391, 738, 4, 380, 108000, N'Active'),
(10047, 4392, 741, 3, 297, 90000, N'Active'),
(10048, 4392, 741, 3, 298, 90000, N'Active'),
(10049, 4392, 741, 3, 299, 90000, N'Active'),
(10050, 4393, 740, 2, 163, 90000, N'Cancelled'),
(10051, 4393, 740, 2, 164, 90000, N'Cancelled'),
(10052, 4393, 740, 2, 165, 90000, N'Cancelled'),
(10053, 4394, 740, 2, 137, 75000, N'Active'),
(10054, 4394, 740, 2, 138, 75000, N'Active'),
(10055, 4395, 741, 3, 233, 75000, N'Active'),
(10056, 4395, 741, 3, 234, 75000, N'Active'),
(10057, 4395, 741, 3, 235, 75000, N'Active'),
(10058, 4396, 743, 2, 163, 90000, N'Active'),
(10059, 4396, 743, 2, 164, 90000, N'Active'),
(10060, 4397, 741, 3, 258, 90000, N'Cancelled'),
(10061, 4398, 743, 2, 186, 90000, N'Active'),
(10062, 4398, 743, 2, 187, 90000, N'Active'),
(10063, 4399, 739, 5, 522, 144000, N'Active'),
(10064, 4399, 739, 5, 523, 144000, N'Active'),
(10065, 4399, 739, 5, 524, 144000, N'Active'),
(10066, 4400, 741, 3, 259, 90000, N'Active'),
(10067, 4400, 741, 3, 260, 90000, N'Active'),
(10068, 4401, 740, 2, 196, 90000, N'Active'),
(10069, 4401, 740, 2, 197, 90000, N'Active'),
(10070, 4402, 761, 5, 559, 144000, N'Active'),
(10071, 4402, 761, 5, 560, 144000, N'Active'),
(10072, 4402, 761, 5, 561, 144000, N'Active'),
(10073, 4402, 761, 5, 562, 144000, N'Active'),
(10074, 4403, 760, 2, 162, 90000, N'Active'),
(10075, 4403, 760, 2, 163, 90000, N'Active'),
(10076, 4404, 740, 2, 161, 90000, N'Active'),
(10077, 4405, 762, 1, 5, 75000, N'Active'),
(10078, 4405, 762, 1, 6, 75000, N'Active'),
(10079, 4405, 762, 1, 7, 75000, N'Active'),
(10080, 4405, 762, 1, 8, 75000, N'Active'),
(10081, 4405, 762, 1, 9, 75000, N'Active'),
(10082, 4406, 740, 2, 189, 90000, N'Active'),
(10083, 4406, 740, 2, 190, 90000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Chủ nhật 06/12/2026: 180 hoa don (6 huy), 414 ve, doanh thu 39.367.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(4407, 3, 49, '2026-12-06T08:00:24', 216000, N'Paid', N'Cash', 220000, 15, 0, NULL, NULL, NULL), -- suat 750 | Ramayana: Khởi Nguồn Một Huyền Thoại | 06/12 12:15 | Phòng 4 | D6 D7
(4408, 3, NULL, '2026-12-06T08:00:42', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 742 | Trại Giam Hạnh Phúc | 06/12 09:00 | Phòng 1 | E9 E10
(4409, 10, NULL, '2026-12-06T08:01:03', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 817 | Mẹ Mìn: Giao Kèo Với Quỷ | 08/12 16:15 | Phòng 1 | E8 E9
(4410, 3, NULL, '2026-12-06T08:06:47', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 760 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 06/12 17:15 | Phòng 2 | E4 E5
(4411, 10, 113, '2026-12-06T08:13:04', 180000, N'Paid', N'Cash', 180000, 18, 0, NULL, NULL, NULL), -- suat 742 | Trại Giam Hạnh Phúc | 06/12 09:00 | Phòng 1 | J3 J4
(4412, 9, NULL, '2026-12-06T08:35:07', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 775 | Kiến Lé Phiêu Lưu Ké | 07/12 09:30 | Phòng 3 | E6 E7
(4413, 10, NULL, '2026-12-06T08:40:13', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 753 | Con Mắt Thứ Ba | 06/12 13:30 | Phòng 3 | J5 J6
(4414, 3, NULL, '2026-12-06T08:47:25', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 752 | Hexed: Thế Giới Phép Thuật | 06/12 12:45 | Phòng 2 | D6 D7
(4415, 9, 108, '2026-12-06T08:48:36', 288000, N'Paid', N'Cash', 290000, 20, 0, NULL, NULL, NULL), -- suat 744 | Dune: Hành Tinh Cát - Phần Hai | 06/12 09:00 | Phòng 5 | E4 E5
(4416, 9, NULL, '2026-12-06T08:50:42', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 750 | Ramayana: Khởi Nguồn Một Huyền Thoại | 06/12 12:15 | Phòng 4 | A6
(4417, 10, NULL, '2026-12-06T08:51:32', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 746 | Kiến Lé Phiêu Lưu Ké | 06/12 09:30 | Phòng 3 | G6 G7 G8 G9
(4418, 10, NULL, '2026-12-06T08:51:53', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 794 | Bò Sữa Bay | 07/12 19:30 | Phòng 2 | F6 F7
(4419, 9, NULL, '2026-12-06T08:56:36', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 745 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 09:15 | Phòng 4 | C6 C7 C8
(4420, 10, 69, '2026-12-06T08:58:25', 360000, N'Paid', N'Cash', 400000, 25, 0, NULL, NULL, NULL), -- suat 757 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 06/12 15:30 | Phòng 3 | D6 D7 D8 D9
(4421, 10, NULL, '2026-12-06T09:05:06', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 750 | Ramayana: Khởi Nguồn Một Huyền Thoại | 06/12 12:15 | Phòng 4 | G7
(4422, 9, NULL, '2026-12-06T09:08:35', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 748 | Ngày Con Còn Mẹ | 06/12 11:15 | Phòng 3 | E7 E8
(4423, 3, NULL, '2026-12-06T09:17:01', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 746 | Kiến Lé Phiêu Lưu Ké | 06/12 09:30 | Phòng 3 | H7
(4424, 9, NULL, '2026-12-06T09:17:50', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 793 | Godzilla Trừ Không | 07/12 18:30 | Phòng 4 | E9 E10 E11 E12
(4425, 9, 85, '2026-12-06T09:27:43', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 748 | Ngày Con Còn Mẹ | 06/12 11:15 | Phòng 3 | A5 A6
(4426, 9, NULL, '2026-12-06T09:30:10', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 749 | Bắt Cá Ba Tay | 06/12 11:30 | Phòng 1 | G6 G7 G8
(4427, 10, NULL, '2026-12-06T09:36:43', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 751 | Godzilla Trừ Không | 06/12 12:15 | Phòng 5 | A8 A9
(4428, 10, NULL, '2026-12-06T09:37:23', 180000, N'Cancelled', N'Cash', 180000, 0, 0, N'Khách đổi ý', '2026-12-06T09:49:03', 10), -- suat 799 | Con Mắt Thứ Ba | 07/12 21:45 | Phòng 3 | D6 D7
(4429, 9, 47, '2026-12-06T09:37:43', 240000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 751 | Godzilla Trừ Không | 06/12 12:15 | Phòng 5 | A6 A7
(4430, 9, NULL, '2026-12-06T09:40:01', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 785 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 15:00 | Phòng 5 | H6 H7
(4431, 3, NULL, '2026-12-06T09:53:29', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 764 | Godzilla Trừ Không | 06/12 18:30 | Phòng 4 | F4
(4432, 9, NULL, '2026-12-06T10:05:29', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 788 | Mẹ Mìn: Giao Kèo Với Quỷ | 07/12 16:15 | Phòng 1 | J5 J6 J7 J8
(4433, 9, NULL, '2026-12-06T10:06:33', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 756 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 15:00 | Phòng 5 | A5 A6 A7
(4434, 9, 21, '2026-12-06T10:15:10', 326000, N'Paid', N'Cash', 326000, 16, 34, NULL, NULL, NULL), -- suat 750 | Ramayana: Khởi Nguồn Một Huyền Thoại | 06/12 12:15 | Phòng 4 | C4 C5 C6 C7
(4435, 3, NULL, '2026-12-06T10:17:13', 360000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Lỗi thanh toán', '2026-12-06T13:39:47', 1), -- suat 815 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 08/12 15:30 | Phòng 3 | E2 E3 E4 E5
(4436, 10, NULL, '2026-12-06T10:17:26', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 748 | Ngày Con Còn Mẹ | 06/12 11:15 | Phòng 3 | D5 D6 D7 D8
(4437, 3, 42, '2026-12-06T10:20:48', 216000, N'Paid', N'Cash', 216000, 15, 0, NULL, NULL, NULL), -- suat 750 | Ramayana: Khởi Nguồn Một Huyền Thoại | 06/12 12:15 | Phòng 4 | G5 G6
(4438, 10, 98, '2026-12-06T10:22:58', 450000, N'Paid', N'Transfer', NULL, 31, 0, NULL, NULL, NULL), -- suat 757 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 06/12 15:30 | Phòng 3 | E4 E5 E6 E7 E8
(4439, 10, NULL, '2026-12-06T10:23:24', 576000, N'Paid', N'Cash', 600000, 0, 0, NULL, NULL, NULL), -- suat 751 | Godzilla Trừ Không | 06/12 12:15 | Phòng 5 | J7 J8 J9 J10
(4440, 10, NULL, '2026-12-06T10:38:29', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 761 | Dune: Hành Tinh Cát - Phần Hai | 06/12 18:00 | Phòng 5 | K3 K4 K5
(4441, 3, NULL, '2026-12-06T10:42:19', 288000, N'Cancelled', N'Card', NULL, 0, 0, N'Khách đổi ý', '2026-12-06T11:24:05', 3), -- suat 790 | Dune: Hành Tinh Cát - Phần Hai | 07/12 18:00 | Phòng 5 | L1 L2
(4442, 3, NULL, '2026-12-06T11:14:22', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 750 | Ramayana: Khởi Nguồn Một Huyền Thoại | 06/12 12:15 | Phòng 4 | D4 D5
(4443, 10, NULL, '2026-12-06T11:15:59', 450000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 759 | Mẹ Mìn: Giao Kèo Với Quỷ | 06/12 16:15 | Phòng 1 | H1 H2 H3 H4 H5
(4444, 10, NULL, '2026-12-06T11:16:02', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 749 | Bắt Cá Ba Tay | 06/12 11:30 | Phòng 1 | B5 B6
(4445, 9, NULL, '2026-12-06T11:22:36', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | G6 G7 G8
(4446, 3, NULL, '2026-12-06T11:27:09', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | G5
(4447, 10, NULL, '2026-12-06T11:31:10', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 750 | Ramayana: Khởi Nguồn Một Huyền Thoại | 06/12 12:15 | Phòng 4 | J1 J2
(4448, 3, NULL, '2026-12-06T11:31:17', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 795 | Trại Giam Hạnh Phúc | 07/12 21:00 | Phòng 1 | E8 E9
(4449, 10, 48, '2026-12-06T11:38:08', 324000, N'Paid', N'Cash', 324000, 22, 0, NULL, NULL, NULL), -- suat 758 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 15:30 | Phòng 4 | H4 H5 H6
(4450, 9, 21, '2026-12-06T11:50:48', 360000, N'Paid', N'Cash', 400000, 18, 0, NULL, NULL, NULL), -- suat 751 | Godzilla Trừ Không | 06/12 12:15 | Phòng 5 | B6 B7 B8
(4451, 9, 77, '2026-12-06T12:04:45', 150000, N'Paid', N'Cash', 200000, 7, 0, NULL, NULL, NULL), -- suat 754 | Trại Giam Hạnh Phúc | 06/12 13:45 | Phòng 1 | C8 C9
(4452, 9, NULL, '2026-12-06T12:06:16', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 756 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 15:00 | Phòng 5 | G7 G8 G9
(4453, 10, NULL, '2026-12-06T12:21:26', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 756 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 15:00 | Phòng 5 | H6
(4454, 3, NULL, '2026-12-06T12:23:16', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 757 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 06/12 15:30 | Phòng 3 | F7
(4455, 3, 28, '2026-12-06T12:26:10', 324000, N'Paid', N'Cash', 324000, 22, 0, NULL, NULL, NULL), -- suat 758 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 15:30 | Phòng 4 | D5 D6 D7
(4456, 3, NULL, '2026-12-06T12:28:58', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 793 | Godzilla Trừ Không | 07/12 18:30 | Phòng 4 | E4 E5 E6 E7
(4457, 10, NULL, '2026-12-06T12:29:55', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 772 | Hexed: Thế Giới Phép Thuật | 07/12 09:00 | Phòng 2 | G5 G6
(4458, 10, NULL, '2026-12-06T12:34:00', 216000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 758 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 15:30 | Phòng 4 | E6 E7
(4459, 3, 93, '2026-12-06T12:47:17', 218000, N'Paid', N'Cash', 218000, 10, 22, NULL, NULL, NULL), -- suat 756 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 15:00 | Phòng 5 | D5 D6
(4460, 3, 1, '2026-12-06T12:53:04', 75000, N'Paid', N'Transfer', NULL, 3, 0, NULL, NULL, NULL), -- suat 755 | Ngày Con Còn Mẹ | 06/12 15:00 | Phòng 2 | C7
(4461, 10, NULL, '2026-12-06T12:54:10', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 759 | Mẹ Mìn: Giao Kèo Với Quỷ | 06/12 16:15 | Phòng 1 | H6
(4462, 9, 30, '2026-12-06T12:55:59', 149000, N'Paid', N'Transfer', NULL, 10, 31, NULL, NULL, NULL), -- suat 753 | Con Mắt Thứ Ba | 06/12 13:30 | Phòng 3 | F7 F8
(4463, 3, 52, '2026-12-06T12:59:19', 120000, N'Paid', N'Cash', 150000, 6, 30, NULL, NULL, NULL), -- suat 754 | Trại Giam Hạnh Phúc | 06/12 13:45 | Phòng 1 | A6 A7
(4464, 9, 63, '2026-12-06T13:06:26', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 754 | Trại Giam Hạnh Phúc | 06/12 13:45 | Phòng 1 | E7 E8
(4465, 10, NULL, '2026-12-06T13:08:21', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 807 | Bắt Cá Ba Tay | 08/12 11:30 | Phòng 1 | G5 G6 G7 G8
(4466, 3, NULL, '2026-12-06T13:10:14', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 757 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 06/12 15:30 | Phòng 3 | G5 G6
(4467, 3, 47, '2026-12-06T13:11:25', 216000, N'Paid', N'Transfer', NULL, 21, 0, NULL, NULL, NULL), -- suat 796 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 21:00 | Phòng 4 | J1 J2
(4468, 10, 63, '2026-12-06T13:13:01', 303000, N'Paid', N'Cash', 303000, 15, 57, NULL, NULL, NULL), -- suat 756 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 15:00 | Phòng 5 | A2 A3 A4
(4469, 9, NULL, '2026-12-06T13:13:19', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 778 | Bắt Cá Ba Tay | 07/12 11:30 | Phòng 1 | B6 B7
(4470, 3, NULL, '2026-12-06T13:13:58', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 753 | Con Mắt Thứ Ba | 06/12 13:30 | Phòng 3 | J11 J12
(4471, 3, NULL, '2026-12-06T13:20:52', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 766 | Trại Giam Hạnh Phúc | 06/12 21:00 | Phòng 1 | G7 G8
(4472, 3, 48, '2026-12-06T13:22:41', 180000, N'Paid', N'Cash', 200000, 9, 0, NULL, NULL, NULL), -- suat 767 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 21:00 | Phòng 4 | B6 B7
(4473, 9, NULL, '2026-12-06T13:24:51', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | G11 G12
(4474, 9, 99, '2026-12-06T13:25:22', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 754 | Trại Giam Hạnh Phúc | 06/12 13:45 | Phòng 1 | C6 C7
(4475, 3, 13, '2026-12-06T13:38:19', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 758 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 15:30 | Phòng 4 | F6 F7
(4476, 9, NULL, '2026-12-06T13:44:37', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 766 | Trại Giam Hạnh Phúc | 06/12 21:00 | Phòng 1 | J9 J10 J11 J12
(4477, 10, NULL, '2026-12-06T13:53:55', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 755 | Ngày Con Còn Mẹ | 06/12 15:00 | Phòng 2 | H6 H7
(4478, 9, NULL, '2026-12-06T13:58:53', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 759 | Mẹ Mìn: Giao Kèo Với Quỷ | 06/12 16:15 | Phòng 1 | H8 H9
(4479, 10, 60, '2026-12-06T14:04:59', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 762 | Bắt Cá Ba Tay | 06/12 18:30 | Phòng 1 | E7 E8 E9
(4480, 3, NULL, '2026-12-06T14:13:58', 720000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 761 | Dune: Hành Tinh Cát - Phần Hai | 06/12 18:00 | Phòng 5 | J7 J8 J9 J10 J11
(4481, 3, 46, '2026-12-06T14:18:45', 240000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 756 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 15:00 | Phòng 5 | D7 D8
(4482, 3, NULL, '2026-12-06T14:19:07', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 756 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 15:00 | Phòng 5 | E5 E6
(4483, 9, NULL, '2026-12-06T14:20:08', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | H11 H12
(4484, 3, NULL, '2026-12-06T14:20:22', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 766 | Trại Giam Hạnh Phúc | 06/12 21:00 | Phòng 1 | F5
(4485, 9, 21, '2026-12-06T14:20:40', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 763 | Điểm Mù | 06/12 18:30 | Phòng 3 | H5 H6
(4486, 10, 32, '2026-12-06T14:22:58', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 763 | Điểm Mù | 06/12 18:30 | Phòng 3 | F2 F3 F4
(4487, 3, NULL, '2026-12-06T14:27:41', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 755 | Ngày Con Còn Mẹ | 06/12 15:00 | Phòng 2 | E6 E7
(4488, 10, NULL, '2026-12-06T14:32:11', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 813 | Ngày Con Còn Mẹ | 08/12 15:00 | Phòng 2 | G9
(4489, 10, NULL, '2026-12-06T14:32:53', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 763 | Điểm Mù | 06/12 18:30 | Phòng 3 | B6 B7
(4490, 9, NULL, '2026-12-06T14:32:54', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 792 | Điểm Mù | 07/12 18:30 | Phòng 3 | E4 E5
(4491, 10, NULL, '2026-12-06T14:47:24', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 756 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 15:00 | Phòng 5 | K6 K7 K8
(4492, 10, 89, '2026-12-06T14:54:56', 150000, N'Paid', N'Cash', 200000, 7, 0, NULL, NULL, NULL), -- suat 762 | Bắt Cá Ba Tay | 06/12 18:30 | Phòng 1 | C7 C8
(4493, 9, NULL, '2026-12-06T14:58:06', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 762 | Bắt Cá Ba Tay | 06/12 18:30 | Phòng 1 | H1 H2 H3
(4494, 6, NULL, '2026-12-06T15:04:14', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 757 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 06/12 15:30 | Phòng 3 | J5 J6
(4495, 6, NULL, '2026-12-06T15:06:00', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 758 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 15:30 | Phòng 4 | G6 G7
(4496, 4, 66, '2026-12-06T15:17:11', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 781 | Hexed: Thế Giới Phép Thuật | 07/12 12:45 | Phòng 2 | E7 E8
(4497, 6, 108, '2026-12-06T15:19:00', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 770 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 3 | H4 H5
(4498, 4, 95, '2026-12-06T15:21:22', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 764 | Godzilla Trừ Không | 06/12 18:30 | Phòng 4 | F6 F7
(4499, 5, 88, '2026-12-06T15:23:14', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 820 | Bắt Cá Ba Tay | 08/12 18:30 | Phòng 1 | G6 G7
(4500, 6, NULL, '2026-12-06T15:28:13', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 764 | Godzilla Trừ Không | 06/12 18:30 | Phòng 4 | D11 D12
(4501, 6, NULL, '2026-12-06T15:46:09', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 759 | Mẹ Mìn: Giao Kèo Với Quỷ | 06/12 16:15 | Phòng 1 | C5 C6
(4502, 5, NULL, '2026-12-06T15:53:42', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 760 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 06/12 17:15 | Phòng 2 | C5 C6
(4503, 5, NULL, '2026-12-06T15:55:48', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 767 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 21:00 | Phòng 4 | G8 G9 G10 G11
(4504, 4, NULL, '2026-12-06T16:06:31', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 761 | Dune: Hành Tinh Cát - Phần Hai | 06/12 18:00 | Phòng 5 | C5 C6
(4505, 4, 40, '2026-12-06T16:09:21', 90000, N'Paid', N'Cash', 500000, 6, 0, NULL, NULL, NULL), -- suat 762 | Bắt Cá Ba Tay | 06/12 18:30 | Phòng 1 | H12
(4506, 6, NULL, '2026-12-06T16:09:37', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 762 | Bắt Cá Ba Tay | 06/12 18:30 | Phòng 1 | G6 G7
(4507, 5, NULL, '2026-12-06T16:15:12', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 760 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 06/12 17:15 | Phòng 2 | A5 A6
(4508, 4, NULL, '2026-12-06T16:15:57', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 764 | Godzilla Trừ Không | 06/12 18:30 | Phòng 4 | A4 A5
(4509, 6, 78, '2026-12-06T16:19:35', 216000, N'Paid', N'Cash', 216000, 15, 0, NULL, NULL, NULL), -- suat 764 | Godzilla Trừ Không | 06/12 18:30 | Phòng 4 | D6 D7
(4510, 6, NULL, '2026-12-06T16:25:15', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 802 | Dune: Hành Tinh Cát - Phần Hai | 08/12 09:00 | Phòng 5 | H6 H7
(4511, 6, NULL, '2026-12-06T16:27:47', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 766 | Trại Giam Hạnh Phúc | 06/12 21:00 | Phòng 1 | D6 D7
(4512, 5, NULL, '2026-12-06T16:29:05', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 795 | Trại Giam Hạnh Phúc | 07/12 21:00 | Phòng 1 | F5 F6 F7
(4513, 5, NULL, '2026-12-06T16:29:48', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 762 | Bắt Cá Ba Tay | 06/12 18:30 | Phòng 1 | D7 D8
(4514, 5, NULL, '2026-12-06T16:37:38', 108000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 767 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 21:00 | Phòng 4 | E2
(4515, 5, NULL, '2026-12-06T16:39:27', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 770 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 3 | F9 F10
(4516, 5, NULL, '2026-12-06T16:39:53', 240000, N'Paid', N'Cash', 240000, 0, 0, NULL, NULL, NULL), -- suat 773 | Dune: Hành Tinh Cát - Phần Hai | 07/12 09:00 | Phòng 5 | B8 B9
(4517, 6, NULL, '2026-12-06T16:49:54', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 761 | Dune: Hành Tinh Cát - Phần Hai | 06/12 18:00 | Phòng 5 | J5 J6
(4518, 5, 1, '2026-12-06T16:58:56', 432000, N'Paid', N'Transfer', NULL, 30, 0, NULL, NULL, NULL), -- suat 767 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 21:00 | Phòng 4 | F3 F4 F5 F6
(4519, 6, NULL, '2026-12-06T17:04:40', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 760 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 06/12 17:15 | Phòng 2 | G8 G9
(4520, 6, NULL, '2026-12-06T17:05:22', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 764 | Godzilla Trừ Không | 06/12 18:30 | Phòng 4 | D3 D4
(4521, 4, 36, '2026-12-06T17:06:40', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 762 | Bắt Cá Ba Tay | 06/12 18:30 | Phòng 1 | H10 H11
(4522, 4, 93, '2026-12-06T17:08:40', 180000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 762 | Bắt Cá Ba Tay | 06/12 18:30 | Phòng 1 | H8 H9
(4523, 6, NULL, '2026-12-06T17:12:57', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 761 | Dune: Hành Tinh Cát - Phần Hai | 06/12 18:00 | Phòng 5 | F7
(4524, 4, NULL, '2026-12-06T17:14:35', 108000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 764 | Godzilla Trừ Không | 06/12 18:30 | Phòng 4 | G7
(4525, 5, NULL, '2026-12-06T17:18:16', 360000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 762 | Bắt Cá Ba Tay | 06/12 18:30 | Phòng 1 | H4 H5 H6 H7
(4526, 4, NULL, '2026-12-06T17:25:37', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 794 | Bò Sữa Bay | 07/12 19:30 | Phòng 2 | H4 H5 H6 H7
(4527, 4, 72, '2026-12-06T17:29:17', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | A8 A9
(4528, 5, NULL, '2026-12-06T17:32:26', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 768 | Godzilla Trừ Không | 06/12 21:15 | Phòng 5 | J7 J8 J9
(4529, 5, 109, '2026-12-06T17:35:36', 240000, N'Paid', N'Cash', 250000, 12, 0, NULL, NULL, NULL), -- suat 761 | Dune: Hành Tinh Cát - Phần Hai | 06/12 18:00 | Phòng 5 | A6 A7
(4530, 6, NULL, '2026-12-06T17:37:57', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 762 | Bắt Cá Ba Tay | 06/12 18:30 | Phòng 1 | J9 J10
(4531, 5, NULL, '2026-12-06T17:38:35', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 763 | Điểm Mù | 06/12 18:30 | Phòng 3 | G4 G5 G6 G7
(4532, 6, 67, '2026-12-06T17:39:09', 180000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | G9 G10
(4533, 4, NULL, '2026-12-06T17:39:14', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 761 | Dune: Hành Tinh Cát - Phần Hai | 06/12 18:00 | Phòng 5 | F5 F6
(4534, 6, NULL, '2026-12-06T17:42:25', 540000, N'Paid', N'Cash', 540000, 0, 0, NULL, NULL, NULL), -- suat 763 | Điểm Mù | 06/12 18:30 | Phòng 3 | D3 D4 D5 D6 D7 D8
(4535, 6, NULL, '2026-12-06T17:43:07', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | J3 J4
(4536, 4, NULL, '2026-12-06T17:45:45', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 794 | Bò Sữa Bay | 07/12 19:30 | Phòng 2 | A9 A10
(4537, 4, NULL, '2026-12-06T17:46:39', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 764 | Godzilla Trừ Không | 06/12 18:30 | Phòng 4 | A7 A8
(4538, 4, NULL, '2026-12-06T17:47:16', 480000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 761 | Dune: Hành Tinh Cát - Phần Hai | 06/12 18:00 | Phòng 5 | C7 C8 C9 C10
(4539, 6, NULL, '2026-12-06T17:52:10', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 761 | Dune: Hành Tinh Cát - Phần Hai | 06/12 18:00 | Phòng 5 | J3 J4
(4540, 5, NULL, '2026-12-06T17:54:19', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 789 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 07/12 17:15 | Phòng 2 | J3 J4
(4541, 5, NULL, '2026-12-06T17:54:55', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 762 | Bắt Cá Ba Tay | 06/12 18:30 | Phòng 1 | J1 J2
(4542, 5, 4, '2026-12-06T18:01:45', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 769 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 2 | G10 G11
(4543, 4, 118, '2026-12-06T18:02:45', 90000, N'Paid', N'Cash', 500000, 6, 0, NULL, NULL, NULL), -- suat 770 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 3 | G7
(4544, 5, 93, '2026-12-06T18:03:12', 216000, N'Paid', N'Cash', 220000, 15, 0, NULL, NULL, NULL), -- suat 764 | Godzilla Trừ Không | 06/12 18:30 | Phòng 4 | D9 D10
(4545, 6, NULL, '2026-12-06T18:12:12', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | H7 H8
(4546, 4, 21, '2026-12-06T18:14:12', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | G1 G2 G3
(4547, 4, NULL, '2026-12-06T18:15:03', 120000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 768 | Godzilla Trừ Không | 06/12 21:15 | Phòng 5 | B5
(4548, 4, NULL, '2026-12-06T18:17:43', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | D6 D7
(4549, 6, NULL, '2026-12-06T18:19:08', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 764 | Godzilla Trừ Không | 06/12 18:30 | Phòng 4 | C5 C6
(4550, 5, NULL, '2026-12-06T18:25:40', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | F9 F10
(4551, 5, 34, '2026-12-06T18:34:11', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | E6 E7
(4552, 5, NULL, '2026-12-06T18:36:07', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 769 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 2 | A5
(4553, 4, 85, '2026-12-06T18:39:00', 75000, N'Paid', N'Cash', 500000, 3, 0, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | B5
(4554, 5, NULL, '2026-12-06T18:46:31', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 797 | Godzilla Trừ Không | 07/12 21:15 | Phòng 5 | K6 K7
(4555, 6, 42, '2026-12-06T18:51:11', 227000, N'Paid', N'Card', NULL, 15, 43, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | H2 H3 H4
(4556, 5, NULL, '2026-12-06T18:53:44', 450000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 765 | Bò Sữa Bay | 06/12 19:30 | Phòng 2 | F4 F5 F6 F7 F8
(4557, 4, NULL, '2026-12-06T18:54:11', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 769 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 2 | E7 E8
(4558, 5, NULL, '2026-12-06T19:05:27', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 770 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 3 | F5 F6
(4559, 6, 92, '2026-12-06T19:06:51', 263000, N'Paid', N'Transfer', NULL, 18, 61, NULL, NULL, NULL), -- suat 779 | Ramayana: Khởi Nguồn Một Huyền Thoại | 07/12 12:15 | Phòng 4 | D9 D10 D11
(4560, 4, NULL, '2026-12-06T19:08:47', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 768 | Godzilla Trừ Không | 06/12 21:15 | Phòng 5 | F6
(4561, 6, 67, '2026-12-06T19:11:02', 180000, N'Paid', N'Transfer', NULL, 9, 0, NULL, NULL, NULL), -- suat 767 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 21:00 | Phòng 4 | C5 C6
(4562, 4, NULL, '2026-12-06T19:15:13', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 769 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 2 | B5 B6
(4563, 6, 109, '2026-12-06T19:41:22', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 770 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 3 | D8 D9
(4564, 5, NULL, '2026-12-06T19:44:43', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 767 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 06/12 21:00 | Phòng 4 | D7 D8
(4565, 4, NULL, '2026-12-06T19:50:43', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 768 | Godzilla Trừ Không | 06/12 21:15 | Phòng 5 | J6
(4566, 6, NULL, '2026-12-06T19:51:19', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Lỗi thanh toán', '2026-12-06T20:13:10', 6), -- suat 769 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 2 | G7 G8
(4567, 5, NULL, '2026-12-06T19:57:35', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 769 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 2 | F4 F5
(4568, 6, NULL, '2026-12-06T20:01:11', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 768 | Godzilla Trừ Không | 06/12 21:15 | Phòng 5 | D5 D6
(4569, 5, NULL, '2026-12-06T20:13:52', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 770 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 3 | H6 H7 H8
(4570, 4, NULL, '2026-12-06T20:22:13', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 766 | Trại Giam Hạnh Phúc | 06/12 21:00 | Phòng 1 | E5 E6 E7
(4571, 5, 68, '2026-12-06T20:22:51', 90000, N'Cancelled', N'Cash', 90000, 6, 0, N'Khách đổi ý', '2026-12-06T20:40:41', 5), -- suat 766 | Trại Giam Hạnh Phúc | 06/12 21:00 | Phòng 1 | G6
(4572, 5, 32, '2026-12-06T20:22:56', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 783 | Trại Giam Hạnh Phúc | 07/12 13:45 | Phòng 1 | G5 G6
(4573, 6, 117, '2026-12-06T20:38:12', 360000, N'Paid', N'Cash', 360000, 18, 0, NULL, NULL, NULL), -- suat 768 | Godzilla Trừ Không | 06/12 21:15 | Phòng 5 | C7 C8 C9
(4574, 6, 92, '2026-12-06T20:40:36', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 769 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 2 | G5
(4575, 6, NULL, '2026-12-06T20:42:17', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 769 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 2 | B7 B8
(4576, 5, NULL, '2026-12-06T20:47:39', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 766 | Trại Giam Hạnh Phúc | 06/12 21:00 | Phòng 1 | G4 G5
(4577, 6, 66, '2026-12-06T20:50:46', 360000, N'Paid', N'Transfer', NULL, 36, 0, NULL, NULL, NULL), -- suat 769 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 2 | J1 J2 J3 J4
(4578, 4, NULL, '2026-12-06T20:53:17', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 770 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 3 | D7
(4579, 4, 75, '2026-12-06T21:13:23', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 770 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 3 | G6
(4580, 5, 93, '2026-12-06T21:14:43', 270000, N'Cancelled', N'Cash', 270000, 18, 0, N'Khách đổi ý', '2026-12-06T21:52:10', 5), -- suat 799 | Con Mắt Thứ Ba | 07/12 21:45 | Phòng 3 | F5 F6 F7
(4581, 6, NULL, '2026-12-06T21:20:38', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 770 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 3 | E4 E5 E6 E7
(4582, 6, NULL, '2026-12-06T21:21:00', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 769 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 2 | D6 D7
(4583, 5, NULL, '2026-12-06T21:24:27', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 794 | Bò Sữa Bay | 07/12 19:30 | Phòng 2 | A1 A2
(4584, 5, NULL, '2026-12-06T21:24:46', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 770 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 3 | J9 J10
(4585, 6, 113, '2026-12-06T21:25:41', 300000, N'Paid', N'Cash', 500000, 15, 0, NULL, NULL, NULL), -- suat 770 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 3 | B5 B6 B7 B8
(4586, 6, NULL, '2026-12-06T21:29:04', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL); -- suat 770 | Con Mắt Thứ Ba | 06/12 21:45 | Phòng 3 | J5 J6
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(10084, 4407, 750, 4, 366, 108000, N'Active'),
(10085, 4407, 750, 4, 367, 108000, N'Active'),
(10086, 4408, 742, 1, 57, 90000, N'Active'),
(10087, 4408, 742, 1, 58, 90000, N'Active'),
(10088, 4409, 817, 1, 56, 90000, N'Active'),
(10089, 4409, 817, 1, 57, 90000, N'Active'),
(10090, 4410, 760, 2, 160, 90000, N'Active'),
(10091, 4410, 760, 2, 161, 90000, N'Active'),
(10092, 4411, 742, 1, 99, 90000, N'Active'),
(10093, 4411, 742, 1, 100, 90000, N'Active'),
(10094, 4412, 775, 3, 270, 90000, N'Active'),
(10095, 4412, 775, 3, 271, 90000, N'Active'),
(10096, 4413, 753, 3, 317, 90000, N'Active'),
(10097, 4413, 753, 3, 318, 90000, N'Active'),
(10098, 4414, 752, 2, 150, 90000, N'Active'),
(10099, 4414, 752, 2, 151, 90000, N'Active'),
(10100, 4415, 744, 5, 484, 144000, N'Active'),
(10101, 4415, 744, 5, 485, 144000, N'Active'),
(10102, 4416, 750, 4, 330, 90000, N'Active'),
(10103, 4417, 746, 3, 294, 90000, N'Active'),
(10104, 4417, 746, 3, 295, 90000, N'Active'),
(10105, 4417, 746, 3, 296, 90000, N'Active'),
(10106, 4417, 746, 3, 297, 90000, N'Active'),
(10107, 4418, 794, 2, 174, 90000, N'Active'),
(10108, 4418, 794, 2, 175, 90000, N'Active'),
(10109, 4419, 745, 4, 354, 90000, N'Active'),
(10110, 4419, 745, 4, 355, 90000, N'Active'),
(10111, 4419, 745, 4, 356, 90000, N'Active'),
(10112, 4420, 757, 3, 258, 90000, N'Active'),
(10113, 4420, 757, 3, 259, 90000, N'Active'),
(10114, 4420, 757, 3, 260, 90000, N'Active'),
(10115, 4420, 757, 3, 261, 90000, N'Active'),
(10116, 4421, 750, 4, 403, 108000, N'Active'),
(10117, 4422, 748, 3, 271, 90000, N'Active'),
(10118, 4422, 748, 3, 272, 90000, N'Active'),
(10119, 4423, 746, 3, 307, 90000, N'Active'),
(10120, 4424, 793, 4, 381, 108000, N'Active'),
(10121, 4424, 793, 4, 382, 108000, N'Active'),
(10122, 4424, 793, 4, 383, 108000, N'Active'),
(10123, 4424, 793, 4, 384, 108000, N'Active'),
(10124, 4425, 748, 3, 221, 75000, N'Active'),
(10125, 4425, 748, 3, 222, 75000, N'Active'),
(10126, 4426, 749, 1, 78, 90000, N'Active'),
(10127, 4426, 749, 1, 79, 90000, N'Active'),
(10128, 4426, 749, 1, 80, 90000, N'Active'),
(10129, 4427, 751, 5, 440, 120000, N'Active'),
(10130, 4427, 751, 5, 441, 120000, N'Active'),
(10131, 4428, 799, 3, 258, 90000, N'Cancelled'),
(10132, 4428, 799, 3, 259, 90000, N'Cancelled'),
(10133, 4429, 751, 5, 438, 120000, N'Active'),
(10134, 4429, 751, 5, 439, 120000, N'Active'),
(10135, 4430, 785, 5, 522, 144000, N'Active'),
(10136, 4430, 785, 5, 523, 144000, N'Active'),
(10137, 4431, 764, 4, 388, 108000, N'Active'),
(10138, 4432, 788, 1, 101, 90000, N'Active'),
(10139, 4432, 788, 1, 102, 90000, N'Active'),
(10140, 4432, 788, 1, 103, 90000, N'Active'),
(10141, 4432, 788, 1, 104, 90000, N'Active'),
(10142, 4433, 756, 5, 437, 120000, N'Active'),
(10143, 4433, 756, 5, 438, 120000, N'Active'),
(10144, 4433, 756, 5, 439, 120000, N'Active'),
(10145, 4434, 750, 4, 352, 90000, N'Active'),
(10146, 4434, 750, 4, 353, 90000, N'Active'),
(10147, 4434, 750, 4, 354, 90000, N'Active'),
(10148, 4434, 750, 4, 355, 90000, N'Active'),
(10149, 4435, 815, 3, 266, 90000, N'Cancelled'),
(10150, 4435, 815, 3, 267, 90000, N'Cancelled'),
(10151, 4435, 815, 3, 268, 90000, N'Cancelled'),
(10152, 4435, 815, 3, 269, 90000, N'Cancelled'),
(10153, 4436, 748, 3, 257, 90000, N'Active'),
(10154, 4436, 748, 3, 258, 90000, N'Active'),
(10155, 4436, 748, 3, 259, 90000, N'Active'),
(10156, 4436, 748, 3, 260, 90000, N'Active'),
(10157, 4437, 750, 4, 401, 108000, N'Active'),
(10158, 4437, 750, 4, 402, 108000, N'Active'),
(10159, 4438, 757, 3, 268, 90000, N'Active'),
(10160, 4438, 757, 3, 269, 90000, N'Active'),
(10161, 4438, 757, 3, 270, 90000, N'Active'),
(10162, 4438, 757, 3, 271, 90000, N'Active'),
(10163, 4438, 757, 3, 272, 90000, N'Active'),
(10164, 4439, 751, 5, 535, 144000, N'Active'),
(10165, 4439, 751, 5, 536, 144000, N'Active'),
(10166, 4439, 751, 5, 537, 144000, N'Active'),
(10167, 4439, 751, 5, 538, 144000, N'Active'),
(10168, 4440, 761, 5, 543, 144000, N'Active'),
(10169, 4440, 761, 5, 544, 144000, N'Active'),
(10170, 4440, 761, 5, 545, 144000, N'Active'),
(10171, 4441, 790, 5, 553, 144000, N'Cancelled'),
(10172, 4441, 790, 5, 554, 144000, N'Cancelled'),
(10173, 4442, 750, 4, 364, 108000, N'Active'),
(10174, 4442, 750, 4, 365, 108000, N'Active'),
(10175, 4443, 759, 1, 85, 90000, N'Active'),
(10176, 4443, 759, 1, 86, 90000, N'Active'),
(10177, 4443, 759, 1, 87, 90000, N'Active'),
(10178, 4443, 759, 1, 88, 90000, N'Active'),
(10179, 4443, 759, 1, 89, 90000, N'Active'),
(10180, 4444, 749, 1, 17, 75000, N'Active'),
(10181, 4444, 749, 1, 18, 75000, N'Active'),
(10182, 4445, 765, 2, 186, 90000, N'Active'),
(10183, 4445, 765, 2, 187, 90000, N'Active'),
(10184, 4445, 765, 2, 188, 90000, N'Active'),
(10185, 4446, 765, 2, 185, 90000, N'Active'),
(10186, 4447, 750, 4, 421, 108000, N'Active'),
(10187, 4447, 750, 4, 422, 108000, N'Active'),
(10188, 4448, 795, 1, 56, 90000, N'Active'),
(10189, 4448, 795, 1, 57, 90000, N'Active'),
(10190, 4449, 758, 4, 412, 108000, N'Active'),
(10191, 4449, 758, 4, 413, 108000, N'Active'),
(10192, 4449, 758, 4, 414, 108000, N'Active'),
(10193, 4450, 751, 5, 450, 120000, N'Active'),
(10194, 4450, 751, 5, 451, 120000, N'Active'),
(10195, 4450, 751, 5, 452, 120000, N'Active'),
(10196, 4451, 754, 1, 32, 75000, N'Active'),
(10197, 4451, 754, 1, 33, 75000, N'Active'),
(10198, 4452, 756, 5, 511, 144000, N'Active'),
(10199, 4452, 756, 5, 512, 144000, N'Active'),
(10200, 4452, 756, 5, 513, 144000, N'Active'),
(10201, 4453, 756, 5, 522, 144000, N'Active'),
(10202, 4454, 757, 3, 283, 90000, N'Active'),
(10203, 4455, 758, 4, 365, 108000, N'Active'),
(10204, 4455, 758, 4, 366, 108000, N'Active'),
(10205, 4455, 758, 4, 367, 108000, N'Active'),
(10206, 4456, 793, 4, 376, 108000, N'Active'),
(10207, 4456, 793, 4, 377, 108000, N'Active'),
(10208, 4456, 793, 4, 378, 108000, N'Active'),
(10209, 4456, 793, 4, 379, 108000, N'Active'),
(10210, 4457, 772, 2, 185, 90000, N'Active'),
(10211, 4457, 772, 2, 186, 90000, N'Active'),
(10212, 4458, 758, 4, 378, 108000, N'Active'),
(10213, 4458, 758, 4, 379, 108000, N'Active'),
(10214, 4459, 756, 5, 473, 120000, N'Active'),
(10215, 4459, 756, 5, 474, 120000, N'Active'),
(10216, 4460, 755, 2, 139, 75000, N'Active'),
(10217, 4461, 759, 1, 90, 90000, N'Active'),
(10218, 4462, 753, 3, 283, 90000, N'Active'),
(10219, 4462, 753, 3, 284, 90000, N'Active'),
(10220, 4463, 754, 1, 6, 75000, N'Active'),
(10221, 4463, 754, 1, 7, 75000, N'Active'),
(10222, 4464, 754, 1, 55, 90000, N'Active'),
(10223, 4464, 754, 1, 56, 90000, N'Active'),
(10224, 4465, 807, 1, 77, 90000, N'Active'),
(10225, 4465, 807, 1, 78, 90000, N'Active'),
(10226, 4465, 807, 1, 79, 90000, N'Active'),
(10227, 4465, 807, 1, 80, 90000, N'Active'),
(10228, 4466, 757, 3, 293, 90000, N'Active'),
(10229, 4466, 757, 3, 294, 90000, N'Active'),
(10230, 4467, 796, 4, 421, 108000, N'Active'),
(10231, 4467, 796, 4, 422, 108000, N'Active'),
(10232, 4468, 756, 5, 434, 120000, N'Active'),
(10233, 4468, 756, 5, 435, 120000, N'Active'),
(10234, 4468, 756, 5, 436, 120000, N'Active'),
(10235, 4469, 778, 1, 18, 75000, N'Active'),
(10236, 4469, 778, 1, 19, 75000, N'Active'),
(10237, 4470, 753, 3, 323, 90000, N'Active'),
(10238, 4470, 753, 3, 324, 90000, N'Active'),
(10239, 4471, 766, 1, 79, 90000, N'Active'),
(10240, 4471, 766, 1, 80, 90000, N'Active'),
(10241, 4472, 767, 4, 342, 90000, N'Active'),
(10242, 4472, 767, 4, 343, 90000, N'Active'),
(10243, 4473, 765, 2, 191, 90000, N'Active'),
(10244, 4473, 765, 2, 192, 90000, N'Active'),
(10245, 4474, 754, 1, 30, 75000, N'Active'),
(10246, 4474, 754, 1, 31, 75000, N'Active'),
(10247, 4475, 758, 4, 390, 108000, N'Active'),
(10248, 4475, 758, 4, 391, 108000, N'Active'),
(10249, 4476, 766, 1, 105, 90000, N'Active'),
(10250, 4476, 766, 1, 106, 90000, N'Active'),
(10251, 4476, 766, 1, 107, 90000, N'Active'),
(10252, 4476, 766, 1, 108, 90000, N'Active'),
(10253, 4477, 755, 2, 198, 90000, N'Active'),
(10254, 4477, 755, 2, 199, 90000, N'Active'),
(10255, 4478, 759, 1, 92, 90000, N'Active'),
(10256, 4478, 759, 1, 93, 90000, N'Active'),
(10257, 4479, 762, 1, 55, 90000, N'Active'),
(10258, 4479, 762, 1, 56, 90000, N'Active'),
(10259, 4479, 762, 1, 57, 90000, N'Active'),
(10260, 4480, 761, 5, 535, 144000, N'Active'),
(10261, 4480, 761, 5, 536, 144000, N'Active'),
(10262, 4480, 761, 5, 537, 144000, N'Active'),
(10263, 4480, 761, 5, 538, 144000, N'Active'),
(10264, 4480, 761, 5, 539, 144000, N'Active'),
(10265, 4481, 756, 5, 475, 120000, N'Active'),
(10266, 4481, 756, 5, 476, 120000, N'Active'),
(10267, 4482, 756, 5, 485, 144000, N'Active'),
(10268, 4482, 756, 5, 486, 144000, N'Active'),
(10269, 4483, 765, 2, 203, 90000, N'Active'),
(10270, 4483, 765, 2, 204, 90000, N'Active'),
(10271, 4484, 766, 1, 65, 90000, N'Active'),
(10272, 4485, 763, 3, 305, 90000, N'Active'),
(10273, 4485, 763, 3, 306, 90000, N'Active'),
(10274, 4486, 763, 3, 278, 90000, N'Active'),
(10275, 4486, 763, 3, 279, 90000, N'Active'),
(10276, 4486, 763, 3, 280, 90000, N'Active'),
(10277, 4487, 755, 2, 162, 90000, N'Active'),
(10278, 4487, 755, 2, 163, 90000, N'Active'),
(10279, 4488, 813, 2, 189, 90000, N'Active'),
(10280, 4489, 763, 3, 234, 75000, N'Active'),
(10281, 4489, 763, 3, 235, 75000, N'Active'),
(10282, 4490, 792, 3, 268, 90000, N'Active'),
(10283, 4490, 792, 3, 269, 90000, N'Active'),
(10284, 4491, 756, 5, 546, 144000, N'Active'),
(10285, 4491, 756, 5, 547, 144000, N'Active'),
(10286, 4491, 756, 5, 548, 144000, N'Active'),
(10287, 4492, 762, 1, 31, 75000, N'Active'),
(10288, 4492, 762, 1, 32, 75000, N'Active'),
(10289, 4493, 762, 1, 85, 90000, N'Active'),
(10290, 4493, 762, 1, 86, 90000, N'Active'),
(10291, 4493, 762, 1, 87, 90000, N'Active'),
(10292, 4494, 757, 3, 317, 90000, N'Active'),
(10293, 4494, 757, 3, 318, 90000, N'Active'),
(10294, 4495, 758, 4, 402, 108000, N'Active'),
(10295, 4495, 758, 4, 403, 108000, N'Active'),
(10296, 4496, 781, 2, 163, 90000, N'Active'),
(10297, 4496, 781, 2, 164, 90000, N'Active'),
(10298, 4497, 770, 3, 304, 90000, N'Active'),
(10299, 4497, 770, 3, 305, 90000, N'Active'),
(10300, 4498, 764, 4, 390, 108000, N'Active'),
(10301, 4498, 764, 4, 391, 108000, N'Active'),
(10302, 4499, 820, 1, 78, 90000, N'Active'),
(10303, 4499, 820, 1, 79, 90000, N'Active'),
(10304, 4500, 764, 4, 371, 108000, N'Active'),
(10305, 4500, 764, 4, 372, 108000, N'Active'),
(10306, 4501, 759, 1, 29, 75000, N'Active'),
(10307, 4501, 759, 1, 30, 75000, N'Active'),
(10308, 4502, 760, 2, 137, 75000, N'Active'),
(10309, 4502, 760, 2, 138, 75000, N'Active'),
(10310, 4503, 767, 4, 404, 108000, N'Active'),
(10311, 4503, 767, 4, 405, 108000, N'Active'),
(10312, 4503, 767, 4, 406, 108000, N'Active'),
(10313, 4503, 767, 4, 407, 108000, N'Active'),
(10314, 4504, 761, 5, 461, 120000, N'Active'),
(10315, 4504, 761, 5, 462, 120000, N'Active'),
(10316, 4505, 762, 1, 96, 90000, N'Active'),
(10317, 4506, 762, 1, 78, 90000, N'Active'),
(10318, 4506, 762, 1, 79, 90000, N'Active'),
(10319, 4507, 760, 2, 113, 75000, N'Active'),
(10320, 4507, 760, 2, 114, 75000, N'Active'),
(10321, 4508, 764, 4, 328, 90000, N'Active'),
(10322, 4508, 764, 4, 329, 90000, N'Active'),
(10323, 4509, 764, 4, 366, 108000, N'Active'),
(10324, 4509, 764, 4, 367, 108000, N'Active'),
(10325, 4510, 802, 5, 522, 144000, N'Active'),
(10326, 4510, 802, 5, 523, 144000, N'Active'),
(10327, 4511, 766, 1, 42, 90000, N'Active'),
(10328, 4511, 766, 1, 43, 90000, N'Active'),
(10329, 4512, 795, 1, 65, 90000, N'Active'),
(10330, 4512, 795, 1, 66, 90000, N'Active'),
(10331, 4512, 795, 1, 67, 90000, N'Active'),
(10332, 4513, 762, 1, 43, 90000, N'Active'),
(10333, 4513, 762, 1, 44, 90000, N'Active'),
(10334, 4514, 767, 4, 374, 108000, N'Active'),
(10335, 4515, 770, 3, 285, 90000, N'Active'),
(10336, 4515, 770, 3, 286, 90000, N'Active'),
(10337, 4516, 773, 5, 452, 120000, N'Active'),
(10338, 4516, 773, 5, 453, 120000, N'Active'),
(10339, 4517, 761, 5, 533, 144000, N'Active'),
(10340, 4517, 761, 5, 534, 144000, N'Active'),
(10341, 4518, 767, 4, 387, 108000, N'Active'),
(10342, 4518, 767, 4, 388, 108000, N'Active'),
(10343, 4518, 767, 4, 389, 108000, N'Active'),
(10344, 4518, 767, 4, 390, 108000, N'Active'),
(10345, 4519, 760, 2, 188, 90000, N'Active'),
(10346, 4519, 760, 2, 189, 90000, N'Active'),
(10347, 4520, 764, 4, 363, 108000, N'Active'),
(10348, 4520, 764, 4, 364, 108000, N'Active'),
(10349, 4521, 762, 1, 94, 90000, N'Active'),
(10350, 4521, 762, 1, 95, 90000, N'Active'),
(10351, 4522, 762, 1, 92, 90000, N'Active'),
(10352, 4522, 762, 1, 93, 90000, N'Active'),
(10353, 4523, 761, 5, 499, 144000, N'Active'),
(10354, 4524, 764, 4, 403, 108000, N'Active'),
(10355, 4525, 762, 1, 88, 90000, N'Active'),
(10356, 4525, 762, 1, 89, 90000, N'Active'),
(10357, 4525, 762, 1, 90, 90000, N'Active'),
(10358, 4525, 762, 1, 91, 90000, N'Active'),
(10359, 4526, 794, 2, 196, 90000, N'Active'),
(10360, 4526, 794, 2, 197, 90000, N'Active'),
(10361, 4526, 794, 2, 198, 90000, N'Active'),
(10362, 4526, 794, 2, 199, 90000, N'Active'),
(10363, 4527, 765, 2, 116, 75000, N'Active'),
(10364, 4527, 765, 2, 117, 75000, N'Active'),
(10365, 4528, 768, 5, 535, 144000, N'Active'),
(10366, 4528, 768, 5, 536, 144000, N'Active'),
(10367, 4528, 768, 5, 537, 144000, N'Active'),
(10368, 4529, 761, 5, 438, 120000, N'Active'),
(10369, 4529, 761, 5, 439, 120000, N'Active'),
(10370, 4530, 762, 1, 105, 90000, N'Active'),
(10371, 4530, 762, 1, 106, 90000, N'Active'),
(10372, 4531, 763, 3, 292, 90000, N'Active'),
(10373, 4531, 763, 3, 293, 90000, N'Active'),
(10374, 4531, 763, 3, 294, 90000, N'Active'),
(10375, 4531, 763, 3, 295, 90000, N'Active'),
(10376, 4532, 765, 2, 189, 90000, N'Active'),
(10377, 4532, 765, 2, 190, 90000, N'Active'),
(10378, 4533, 761, 5, 497, 144000, N'Active'),
(10379, 4533, 761, 5, 498, 144000, N'Active'),
(10380, 4534, 763, 3, 255, 90000, N'Active'),
(10381, 4534, 763, 3, 256, 90000, N'Active'),
(10382, 4534, 763, 3, 257, 90000, N'Active'),
(10383, 4534, 763, 3, 258, 90000, N'Active'),
(10384, 4534, 763, 3, 259, 90000, N'Active'),
(10385, 4534, 763, 3, 260, 90000, N'Active'),
(10386, 4535, 765, 2, 207, 90000, N'Active'),
(10387, 4535, 765, 2, 208, 90000, N'Active'),
(10388, 4536, 794, 2, 117, 75000, N'Active'),
(10389, 4536, 794, 2, 118, 75000, N'Active'),
(10390, 4537, 764, 4, 331, 90000, N'Active'),
(10391, 4537, 764, 4, 332, 90000, N'Active'),
(10392, 4538, 761, 5, 463, 120000, N'Active'),
(10393, 4538, 761, 5, 464, 120000, N'Active'),
(10394, 4538, 761, 5, 465, 120000, N'Active'),
(10395, 4538, 761, 5, 466, 120000, N'Active'),
(10396, 4539, 761, 5, 531, 144000, N'Active'),
(10397, 4539, 761, 5, 532, 144000, N'Active'),
(10398, 4540, 789, 2, 207, 90000, N'Active'),
(10399, 4540, 789, 2, 208, 90000, N'Active'),
(10400, 4541, 762, 1, 97, 90000, N'Active'),
(10401, 4541, 762, 1, 98, 90000, N'Active'),
(10402, 4542, 769, 2, 190, 90000, N'Active'),
(10403, 4542, 769, 2, 191, 90000, N'Active'),
(10404, 4543, 770, 3, 295, 90000, N'Active'),
(10405, 4544, 764, 4, 369, 108000, N'Active'),
(10406, 4544, 764, 4, 370, 108000, N'Active'),
(10407, 4545, 765, 2, 199, 90000, N'Active'),
(10408, 4545, 765, 2, 200, 90000, N'Active'),
(10409, 4546, 765, 2, 181, 90000, N'Active'),
(10410, 4546, 765, 2, 182, 90000, N'Active'),
(10411, 4546, 765, 2, 183, 90000, N'Active'),
(10412, 4547, 768, 5, 449, 120000, N'Active'),
(10413, 4548, 765, 2, 150, 90000, N'Active'),
(10414, 4548, 765, 2, 151, 90000, N'Active'),
(10415, 4549, 764, 4, 353, 90000, N'Active'),
(10416, 4549, 764, 4, 354, 90000, N'Active'),
(10417, 4550, 765, 2, 177, 90000, N'Active'),
(10418, 4550, 765, 2, 178, 90000, N'Active'),
(10419, 4551, 765, 2, 162, 90000, N'Active'),
(10420, 4551, 765, 2, 163, 90000, N'Active'),
(10421, 4552, 769, 2, 113, 75000, N'Active'),
(10422, 4553, 765, 2, 125, 75000, N'Active'),
(10423, 4554, 797, 5, 546, 144000, N'Active'),
(10424, 4554, 797, 5, 547, 144000, N'Active'),
(10425, 4555, 765, 2, 194, 90000, N'Active'),
(10426, 4555, 765, 2, 195, 90000, N'Active'),
(10427, 4555, 765, 2, 196, 90000, N'Active'),
(10428, 4556, 765, 2, 172, 90000, N'Active'),
(10429, 4556, 765, 2, 173, 90000, N'Active'),
(10430, 4556, 765, 2, 174, 90000, N'Active'),
(10431, 4556, 765, 2, 175, 90000, N'Active'),
(10432, 4556, 765, 2, 176, 90000, N'Active'),
(10433, 4557, 769, 2, 163, 90000, N'Active'),
(10434, 4557, 769, 2, 164, 90000, N'Active'),
(10435, 4558, 770, 3, 281, 90000, N'Active'),
(10436, 4558, 770, 3, 282, 90000, N'Active'),
(10437, 4559, 779, 4, 369, 108000, N'Active'),
(10438, 4559, 779, 4, 370, 108000, N'Active'),
(10439, 4559, 779, 4, 371, 108000, N'Active'),
(10440, 4560, 768, 5, 498, 144000, N'Active'),
(10441, 4561, 767, 4, 353, 90000, N'Active'),
(10442, 4561, 767, 4, 354, 90000, N'Active'),
(10443, 4562, 769, 2, 125, 75000, N'Active'),
(10444, 4562, 769, 2, 126, 75000, N'Active'),
(10445, 4563, 770, 3, 260, 90000, N'Active'),
(10446, 4563, 770, 3, 261, 90000, N'Active'),
(10447, 4564, 767, 4, 367, 108000, N'Active'),
(10448, 4564, 767, 4, 368, 108000, N'Active'),
(10449, 4565, 768, 5, 534, 144000, N'Active'),
(10450, 4566, 769, 2, 187, 90000, N'Cancelled'),
(10451, 4566, 769, 2, 188, 90000, N'Cancelled'),
(10452, 4567, 769, 2, 172, 90000, N'Active'),
(10453, 4567, 769, 2, 173, 90000, N'Active'),
(10454, 4568, 768, 5, 473, 120000, N'Active'),
(10455, 4568, 768, 5, 474, 120000, N'Active'),
(10456, 4569, 770, 3, 306, 90000, N'Active'),
(10457, 4569, 770, 3, 307, 90000, N'Active'),
(10458, 4569, 770, 3, 308, 90000, N'Active'),
(10459, 4570, 766, 1, 53, 90000, N'Active'),
(10460, 4570, 766, 1, 54, 90000, N'Active'),
(10461, 4570, 766, 1, 55, 90000, N'Active'),
(10462, 4571, 766, 1, 78, 90000, N'Cancelled'),
(10463, 4572, 783, 1, 77, 90000, N'Active'),
(10464, 4572, 783, 1, 78, 90000, N'Active'),
(10465, 4573, 768, 5, 463, 120000, N'Active'),
(10466, 4573, 768, 5, 464, 120000, N'Active'),
(10467, 4573, 768, 5, 465, 120000, N'Active'),
(10468, 4574, 769, 2, 185, 90000, N'Active'),
(10469, 4575, 769, 2, 127, 75000, N'Active'),
(10470, 4575, 769, 2, 128, 75000, N'Active'),
(10471, 4576, 766, 1, 76, 90000, N'Active'),
(10472, 4576, 766, 1, 77, 90000, N'Active'),
(10473, 4577, 769, 2, 205, 90000, N'Active'),
(10474, 4577, 769, 2, 206, 90000, N'Active'),
(10475, 4577, 769, 2, 207, 90000, N'Active'),
(10476, 4577, 769, 2, 208, 90000, N'Active'),
(10477, 4578, 770, 3, 259, 90000, N'Active'),
(10478, 4579, 770, 3, 294, 90000, N'Active'),
(10479, 4580, 799, 3, 281, 90000, N'Cancelled'),
(10480, 4580, 799, 3, 282, 90000, N'Cancelled'),
(10481, 4580, 799, 3, 283, 90000, N'Cancelled'),
(10482, 4581, 770, 3, 268, 90000, N'Active'),
(10483, 4581, 770, 3, 269, 90000, N'Active'),
(10484, 4581, 770, 3, 270, 90000, N'Active'),
(10485, 4581, 770, 3, 271, 90000, N'Active'),
(10486, 4582, 769, 2, 150, 90000, N'Active'),
(10487, 4582, 769, 2, 151, 90000, N'Active'),
(10488, 4583, 794, 2, 109, 75000, N'Active'),
(10489, 4583, 794, 2, 110, 75000, N'Active'),
(10490, 4584, 770, 3, 321, 90000, N'Active'),
(10491, 4584, 770, 3, 322, 90000, N'Active'),
(10492, 4585, 770, 3, 233, 75000, N'Active'),
(10493, 4585, 770, 3, 234, 75000, N'Active'),
(10494, 4585, 770, 3, 235, 75000, N'Active'),
(10495, 4585, 770, 3, 236, 75000, N'Active'),
(10496, 4586, 770, 3, 317, 90000, N'Active'),
(10497, 4586, 770, 3, 318, 90000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 2 07/12/2026: 128 hoa don (7 huy), 304 ve, doanh thu 28.542.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(4587, 5, NULL, '2026-12-07T08:00:34', 360000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 782 | Con Mắt Thứ Ba | 07/12 13:30 | Phòng 3 | D8 D9 D10 D11
(4588, 4, NULL, '2026-12-07T08:17:01', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 771 | Trại Giam Hạnh Phúc | 07/12 09:00 | Phòng 1 | E5 E6 E7 E8
(4589, 4, NULL, '2026-12-07T08:20:52', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 771 | Trại Giam Hạnh Phúc | 07/12 09:00 | Phòng 1 | B6 B7
(4590, 4, NULL, '2026-12-07T08:21:15', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 773 | Dune: Hành Tinh Cát - Phần Hai | 07/12 09:00 | Phòng 5 | H8 H9
(4591, 5, NULL, '2026-12-07T08:30:58', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 772 | Hexed: Thế Giới Phép Thuật | 07/12 09:00 | Phòng 2 | J1 J2 J3 J4
(4592, 5, NULL, '2026-12-07T08:36:03', 75000, N'Paid', N'Cash', 75000, 0, 0, NULL, NULL, NULL), -- suat 789 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 07/12 17:15 | Phòng 2 | A7
(4593, 4, NULL, '2026-12-07T08:36:44', 600000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 809 | Godzilla Trừ Không | 08/12 12:15 | Phòng 5 | C8 C9 C10 C11 C12
(4594, 5, 93, '2026-12-07T08:38:45', 108000, N'Paid', N'Cash', 108000, 7, 0, NULL, NULL, NULL), -- suat 816 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 08/12 15:30 | Phòng 4 | D6
(4595, 4, 21, '2026-12-07T08:43:44', 234000, N'Paid', N'Transfer', NULL, 16, 36, NULL, NULL, NULL), -- suat 789 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 07/12 17:15 | Phòng 2 | G6 G7 G8
(4596, 5, NULL, '2026-12-07T08:49:04', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 787 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 15:30 | Phòng 4 | E6 E7
(4597, 5, NULL, '2026-12-07T08:57:17', 324000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 774 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 09:15 | Phòng 4 | F9 F10 F11
(4598, 4, NULL, '2026-12-07T09:02:25', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 774 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 09:15 | Phòng 4 | F6 F7
(4599, 4, 48, '2026-12-07T09:07:12', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 775 | Kiến Lé Phiêu Lưu Ké | 07/12 09:30 | Phòng 3 | C7 C8
(4600, 4, NULL, '2026-12-07T09:08:49', 450000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 776 | Ma Mút Con Vượt Kỷ Băng Hà | 07/12 11:15 | Phòng 2 | E4 E5 E6 E7 E8
(4601, 5, NULL, '2026-12-07T09:19:41', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 818 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 08/12 17:15 | Phòng 2 | E8 E9
(4602, 4, NULL, '2026-12-07T09:47:10', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 783 | Trại Giam Hạnh Phúc | 07/12 13:45 | Phòng 1 | G7 G8
(4603, 5, NULL, '2026-12-07T09:50:30', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 810 | Hexed: Thế Giới Phép Thuật | 08/12 12:45 | Phòng 2 | F4 F5 F6
(4604, 4, NULL, '2026-12-07T10:15:07', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 779 | Ramayana: Khởi Nguồn Một Huyền Thoại | 07/12 12:15 | Phòng 4 | G6 G7
(4605, 5, NULL, '2026-12-07T10:22:48', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-12-07T10:44:46', 5), -- suat 783 | Trại Giam Hạnh Phúc | 07/12 13:45 | Phòng 1 | G9 G10
(4606, 5, NULL, '2026-12-07T10:30:38', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 791 | Bắt Cá Ba Tay | 07/12 18:30 | Phòng 1 | E7 E8
(4607, 5, 110, '2026-12-07T10:35:01', 432000, N'Cancelled', N'Cash', 450000, 30, 0, N'Khách đổi ý', '2026-12-07T11:22:01', 5), -- suat 819 | Dune: Hành Tinh Cát - Phần Hai | 08/12 18:00 | Phòng 5 | G4 G5 G6
(4608, 4, 56, '2026-12-07T10:35:54', 270000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 777 | Ngày Con Còn Mẹ | 07/12 11:15 | Phòng 3 | F6 F7 F8
(4609, 5, NULL, '2026-12-07T10:36:23', 480000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 831 | Dune: Hành Tinh Cát - Phần Hai | 09/12 09:00 | Phòng 5 | D7 D8 D9 D10
(4610, 4, NULL, '2026-12-07T10:47:38', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 828 | Con Mắt Thứ Ba | 08/12 21:45 | Phòng 3 | H8
(4611, 4, NULL, '2026-12-07T10:48:59', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 782 | Con Mắt Thứ Ba | 07/12 13:30 | Phòng 3 | F6 F7 F8
(4612, 5, 15, '2026-12-07T11:00:36', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 779 | Ramayana: Khởi Nguồn Một Huyền Thoại | 07/12 12:15 | Phòng 4 | H6 H7
(4613, 4, NULL, '2026-12-07T11:03:42', 540000, N'Paid', N'Cash', 540000, 0, 0, NULL, NULL, NULL), -- suat 786 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 07/12 15:30 | Phòng 3 | H4 H5 H6 H7 H8 H9
(4614, 4, NULL, '2026-12-07T11:09:10', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 779 | Ramayana: Khởi Nguồn Một Huyền Thoại | 07/12 12:15 | Phòng 4 | F5 F6
(4615, 4, NULL, '2026-12-07T11:09:35', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 778 | Bắt Cá Ba Tay | 07/12 11:30 | Phòng 1 | H5 H6
(4616, 4, 36, '2026-12-07T11:18:56', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 781 | Hexed: Thế Giới Phép Thuật | 07/12 12:45 | Phòng 2 | D6 D7
(4617, 5, NULL, '2026-12-07T11:21:16', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 780 | Godzilla Trừ Không | 07/12 12:15 | Phòng 5 | L5 L6
(4618, 4, NULL, '2026-12-07T11:28:53', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 787 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 15:30 | Phòng 4 | D6 D7
(4619, 5, 59, '2026-12-07T11:35:11', 288000, N'Paid', N'Cash', 500000, 20, 0, NULL, NULL, NULL), -- suat 780 | Godzilla Trừ Không | 07/12 12:15 | Phòng 5 | J5 J6
(4620, 5, NULL, '2026-12-07T11:45:37', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 852 | Bò Sữa Bay | 09/12 19:30 | Phòng 2 | D9
(4621, 4, NULL, '2026-12-07T11:51:41', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 780 | Godzilla Trừ Không | 07/12 12:15 | Phòng 5 | L7 L8
(4622, 4, 13, '2026-12-07T11:52:12', 576000, N'Paid', N'Cash', 600000, 40, 0, NULL, NULL, NULL), -- suat 826 | Godzilla Trừ Không | 08/12 21:15 | Phòng 5 | K5 K6 K7 K8
(4623, 5, NULL, '2026-12-07T11:57:22', 108000, N'Paid', N'Cash', 108000, 0, 0, NULL, NULL, NULL), -- suat 822 | Godzilla Trừ Không | 08/12 18:30 | Phòng 4 | E9
(4624, 4, NULL, '2026-12-07T11:59:11', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 779 | Ramayana: Khởi Nguồn Một Huyền Thoại | 07/12 12:15 | Phòng 4 | D6 D7 D8
(4625, 4, NULL, '2026-12-07T12:07:32', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 786 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 07/12 15:30 | Phòng 3 | E6 E7
(4626, 5, NULL, '2026-12-07T12:08:27', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 839 | Hexed: Thế Giới Phép Thuật | 09/12 12:45 | Phòng 2 | F6 F7
(4627, 5, NULL, '2026-12-07T12:10:57', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 805 | Ma Mút Con Vượt Kỷ Băng Hà | 08/12 11:15 | Phòng 2 | D7 D8
(4628, 5, NULL, '2026-12-07T12:11:56', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 823 | Bò Sữa Bay | 08/12 19:30 | Phòng 2 | F7
(4629, 5, 42, '2026-12-07T12:20:31', 225000, N'Paid', N'Transfer', NULL, 11, 0, NULL, NULL, NULL), -- suat 786 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 07/12 15:30 | Phòng 3 | B6 B7 B8
(4630, 4, 44, '2026-12-07T12:26:00', 90000, N'Paid', N'Cash', 500000, 6, 0, NULL, NULL, NULL), -- suat 792 | Điểm Mù | 07/12 18:30 | Phòng 3 | G6
(4631, 4, NULL, '2026-12-07T12:26:31', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 781 | Hexed: Thế Giới Phép Thuật | 07/12 12:45 | Phòng 2 | H6 H7
(4632, 4, 99, '2026-12-07T12:33:30', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 782 | Con Mắt Thứ Ba | 07/12 13:30 | Phòng 3 | D6
(4633, 5, NULL, '2026-12-07T12:36:09', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 817 | Mẹ Mìn: Giao Kèo Với Quỷ | 08/12 16:15 | Phòng 1 | D6 D7
(4634, 4, 2, '2026-12-07T12:43:40', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 782 | Con Mắt Thứ Ba | 07/12 13:30 | Phòng 3 | G6
(4635, 4, 92, '2026-12-07T12:45:28', 144000, N'Paid', N'Card', NULL, 10, 0, NULL, NULL, NULL), -- suat 797 | Godzilla Trừ Không | 07/12 21:15 | Phòng 5 | K5
(4636, 5, 21, '2026-12-07T12:54:03', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 788 | Mẹ Mìn: Giao Kèo Với Quỷ | 07/12 16:15 | Phòng 1 | D6 D7
(4637, 5, NULL, '2026-12-07T13:04:26', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 855 | Godzilla Trừ Không | 09/12 21:15 | Phòng 5 | G6
(4638, 4, NULL, '2026-12-07T13:12:02', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 785 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 15:00 | Phòng 5 | F6 F7
(4639, 4, 32, '2026-12-07T13:39:43', 300000, N'Paid', N'Cash', 300000, 15, 0, NULL, NULL, NULL), -- suat 824 | Trại Giam Hạnh Phúc | 08/12 21:00 | Phòng 1 | C4 C5 C6 C7
(4640, 4, NULL, '2026-12-07T13:41:00', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 787 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 15:30 | Phòng 4 | A6 A7
(4641, 4, 78, '2026-12-07T13:54:17', 360000, N'Cancelled', N'Transfer', NULL, 25, 0, N'Khách đổi ý', '2026-12-07T14:22:09', 4), -- suat 804 | Kiến Lé Phiêu Lưu Ké | 08/12 09:30 | Phòng 3 | F5 F6 F7 F8
(4642, 5, NULL, '2026-12-07T13:54:30', 120000, N'Paid', N'Cash', 120000, 0, 0, NULL, NULL, NULL), -- suat 785 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 15:00 | Phòng 5 | B5
(4643, 5, NULL, '2026-12-07T14:12:39', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 787 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 15:30 | Phòng 4 | A4 A5
(4644, 4, NULL, '2026-12-07T14:13:16', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 789 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 07/12 17:15 | Phòng 2 | F6 F7
(4645, 5, NULL, '2026-12-07T14:15:49', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 793 | Godzilla Trừ Không | 07/12 18:30 | Phòng 4 | F8 F9
(4646, 5, NULL, '2026-12-07T14:18:45', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 784 | Ngày Con Còn Mẹ | 07/12 15:00 | Phòng 2 | G7 G8
(4647, 5, NULL, '2026-12-07T14:19:08', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 798 | Con Mắt Thứ Ba | 07/12 21:45 | Phòng 2 | D4 D5
(4648, 5, 92, '2026-12-07T14:32:03', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 790 | Dune: Hành Tinh Cát - Phần Hai | 07/12 18:00 | Phòng 5 | K5 K6
(4649, 4, 15, '2026-12-07T14:32:30', 108000, N'Paid', N'Cash', 500000, 7, 0, NULL, NULL, NULL), -- suat 787 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 15:30 | Phòng 4 | G8
(4650, 5, NULL, '2026-12-07T14:34:04', 324000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 793 | Godzilla Trừ Không | 07/12 18:30 | Phòng 4 | F3 F4 F5
(4651, 4, NULL, '2026-12-07T14:34:17', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 816 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 08/12 15:30 | Phòng 4 | G6 G7 G8
(4652, 5, NULL, '2026-12-07T14:39:45', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 789 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 07/12 17:15 | Phòng 2 | E6 E7
(4653, 4, 120, '2026-12-07T14:44:40', 144000, N'Cancelled', N'Cash', 144000, 10, 0, N'Khách đổi ý', '2026-12-07T14:51:39', 4), -- suat 790 | Dune: Hành Tinh Cát - Phần Hai | 07/12 18:00 | Phòng 5 | H5
(4654, 5, 120, '2026-12-07T14:50:04', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 791 | Bắt Cá Ba Tay | 07/12 18:30 | Phòng 1 | J3 J4
(4655, 7, NULL, '2026-12-07T15:02:25', 225000, N'Paid', N'Cash', 225000, 0, 0, NULL, NULL, NULL), -- suat 813 | Ngày Con Còn Mẹ | 08/12 15:00 | Phòng 2 | B5 B6 B7
(4656, 7, 59, '2026-12-07T15:07:46', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 792 | Điểm Mù | 07/12 18:30 | Phòng 3 | C4 C5
(4657, 7, NULL, '2026-12-07T15:08:41', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 796 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 21:00 | Phòng 4 | E6 E7
(4658, 6, NULL, '2026-12-07T15:11:33', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 790 | Dune: Hành Tinh Cát - Phần Hai | 07/12 18:00 | Phòng 5 | D6 D7
(4659, 6, NULL, '2026-12-07T15:15:36', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 786 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 07/12 15:30 | Phòng 3 | G6 G7 G8 G9
(4660, 6, NULL, '2026-12-07T15:17:46', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 791 | Bắt Cá Ba Tay | 07/12 18:30 | Phòng 1 | E5 E6
(4661, 7, 80, '2026-12-07T15:19:30', 180000, N'Paid', N'Transfer', NULL, 9, 0, NULL, NULL, NULL), -- suat 787 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 15:30 | Phòng 4 | B6 B7
(4662, 6, NULL, '2026-12-07T15:20:17', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 825 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 08/12 21:00 | Phòng 4 | A4 A5
(4663, 6, 73, '2026-12-07T15:23:46', 180000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 821 | Điểm Mù | 08/12 18:30 | Phòng 3 | G6 G7
(4664, 7, NULL, '2026-12-07T15:30:25', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 800 | Trại Giam Hạnh Phúc | 08/12 09:00 | Phòng 1 | E6 E7
(4665, 7, NULL, '2026-12-07T15:38:04', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 824 | Trại Giam Hạnh Phúc | 08/12 21:00 | Phòng 1 | H6 H7
(4666, 7, NULL, '2026-12-07T15:52:47', 576000, N'Paid', N'Cash', 576000, 0, 0, NULL, NULL, NULL), -- suat 790 | Dune: Hành Tinh Cát - Phần Hai | 07/12 18:00 | Phòng 5 | L7 L8 L9 L10
(4667, 7, 97, '2026-12-07T15:59:23', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 857 | Con Mắt Thứ Ba | 09/12 21:45 | Phòng 3 | D4 D5
(4668, 6, 42, '2026-12-07T16:13:07', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 794 | Bò Sữa Bay | 07/12 19:30 | Phòng 2 | D6 D7
(4669, 6, NULL, '2026-12-07T16:13:09', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-12-07T16:31:27', 6), -- suat 794 | Bò Sữa Bay | 07/12 19:30 | Phòng 2 | H8 H9
(4670, 7, NULL, '2026-12-07T16:20:31', 720000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 802 | Dune: Hành Tinh Cát - Phần Hai | 08/12 09:00 | Phòng 5 | K4 K5 K6 K7 K8
(4671, 7, NULL, '2026-12-07T16:22:55', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 789 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 07/12 17:15 | Phòng 2 | D6 D7 D8
(4672, 7, NULL, '2026-12-07T16:28:46', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 797 | Godzilla Trừ Không | 07/12 21:15 | Phòng 5 | H7 H8
(4673, 6, NULL, '2026-12-07T16:47:13', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 789 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 07/12 17:15 | Phòng 2 | G9 G10
(4674, 7, 26, '2026-12-07T16:53:18', 216000, N'Paid', N'Cash', 216000, 15, 0, NULL, NULL, NULL), -- suat 793 | Godzilla Trừ Không | 07/12 18:30 | Phòng 4 | D5 D6
(4675, 6, NULL, '2026-12-07T16:59:00', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 792 | Điểm Mù | 07/12 18:30 | Phòng 3 | E6 E7
(4676, 6, NULL, '2026-12-07T17:12:35', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 794 | Bò Sữa Bay | 07/12 19:30 | Phòng 2 | G6 G7
(4677, 7, NULL, '2026-12-07T17:14:55', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 792 | Điểm Mù | 07/12 18:30 | Phòng 3 | J1 J2
(4678, 6, NULL, '2026-12-07T17:20:01', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 791 | Bắt Cá Ba Tay | 07/12 18:30 | Phòng 1 | H6 H7
(4679, 7, NULL, '2026-12-07T17:29:04', 216000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 793 | Godzilla Trừ Không | 07/12 18:30 | Phòng 4 | D3 D4
(4680, 7, NULL, '2026-12-07T17:30:43', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 790 | Dune: Hành Tinh Cát - Phần Hai | 07/12 18:00 | Phòng 5 | E7
(4681, 6, 56, '2026-12-07T17:35:43', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 805 | Ma Mút Con Vượt Kỷ Băng Hà | 08/12 11:15 | Phòng 2 | G7 G8
(4682, 6, 1, '2026-12-07T17:40:33', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 794 | Bò Sữa Bay | 07/12 19:30 | Phòng 2 | H1 H2
(4683, 6, 113, '2026-12-07T17:48:04', 360000, N'Paid', N'Card', NULL, 25, 0, NULL, NULL, NULL), -- suat 792 | Điểm Mù | 07/12 18:30 | Phòng 3 | G7 G8 G9 G10
(4684, 7, NULL, '2026-12-07T17:54:12', 150000, N'Cancelled', N'Cash', 200000, 0, 0, N'Nhầm suất / ghế', '2026-12-07T18:23:12', 7), -- suat 791 | Bắt Cá Ba Tay | 07/12 18:30 | Phòng 1 | B6 B7
(4685, 7, NULL, '2026-12-07T17:54:16', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 795 | Trại Giam Hạnh Phúc | 07/12 21:00 | Phòng 1 | D6 D7
(4686, 6, 67, '2026-12-07T18:03:04', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 792 | Điểm Mù | 07/12 18:30 | Phòng 3 | H6 H7
(4687, 6, NULL, '2026-12-07T18:03:22', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 793 | Godzilla Trừ Không | 07/12 18:30 | Phòng 4 | F6 F7
(4688, 7, NULL, '2026-12-07T18:05:03', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 812 | Trại Giam Hạnh Phúc | 08/12 13:45 | Phòng 1 | A7 A8
(4689, 6, NULL, '2026-12-07T18:11:24', 540000, N'Paid', N'Cash', 1000000, 0, 0, NULL, NULL, NULL), -- suat 791 | Bắt Cá Ba Tay | 07/12 18:30 | Phòng 1 | D3 D4 D5 D6 D7 D8
(4690, 6, NULL, '2026-12-07T18:13:46', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 792 | Điểm Mù | 07/12 18:30 | Phòng 3 | D5 D6 D7 D8
(4691, 7, NULL, '2026-12-07T18:20:01', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 792 | Điểm Mù | 07/12 18:30 | Phòng 3 | C7 C8
(4692, 6, NULL, '2026-12-07T18:42:20', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 821 | Điểm Mù | 08/12 18:30 | Phòng 3 | D4 D5
(4693, 6, NULL, '2026-12-07T18:47:38', 450000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 794 | Bò Sữa Bay | 07/12 19:30 | Phòng 2 | A3 A4 A5 A6 A7 A8
(4694, 6, 96, '2026-12-07T19:00:34', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 813 | Ngày Con Còn Mẹ | 08/12 15:00 | Phòng 2 | G7 G8
(4695, 7, NULL, '2026-12-07T19:15:12', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 796 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 21:00 | Phòng 4 | G4
(4696, 6, NULL, '2026-12-07T19:23:21', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 848 | Dune: Hành Tinh Cát - Phần Hai | 09/12 18:00 | Phòng 5 | J4 J5
(4697, 7, NULL, '2026-12-07T19:44:21', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 795 | Trại Giam Hạnh Phúc | 07/12 21:00 | Phòng 1 | F8 F9
(4698, 6, NULL, '2026-12-07T19:46:54', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 796 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 21:00 | Phòng 4 | H5
(4699, 7, NULL, '2026-12-07T19:50:39', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 796 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 21:00 | Phòng 4 | G5 G6 G7 G8
(4700, 6, NULL, '2026-12-07T20:01:35', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 797 | Godzilla Trừ Không | 07/12 21:15 | Phòng 5 | H5 H6
(4701, 7, 25, '2026-12-07T20:04:21', 300000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 798 | Con Mắt Thứ Ba | 07/12 21:45 | Phòng 2 | A2 A3 A4 A5
(4702, 6, NULL, '2026-12-07T20:07:43', 225000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 795 | Trại Giam Hạnh Phúc | 07/12 21:00 | Phòng 1 | A6 A7 A8
(4703, 7, 92, '2026-12-07T20:09:58', 225000, N'Paid', N'Transfer', NULL, 11, 0, NULL, NULL, NULL), -- suat 798 | Con Mắt Thứ Ba | 07/12 21:45 | Phòng 2 | A8 A9 A10
(4704, 6, 94, '2026-12-07T20:20:55', 180000, N'Paid', N'Cash', 180000, 9, 0, NULL, NULL, NULL), -- suat 796 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 21:00 | Phòng 4 | B5 B6
(4705, 6, 47, '2026-12-07T20:25:11', 450000, N'Paid', N'Transfer', NULL, 31, 0, NULL, NULL, NULL), -- suat 799 | Con Mắt Thứ Ba | 07/12 21:45 | Phòng 3 | H6 H7 H8 H9 H10
(4706, 7, NULL, '2026-12-07T20:29:06', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 796 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 21:00 | Phòng 4 | A7 A8 A9
(4707, 7, 1, '2026-12-07T20:37:27', 432000, N'Paid', N'Cash', 432000, 30, 0, NULL, NULL, NULL), -- suat 826 | Godzilla Trừ Không | 08/12 21:15 | Phòng 5 | F5 F6 F7
(4708, 6, NULL, '2026-12-07T20:43:33', 225000, N'Paid', N'Cash', 225000, 0, 0, NULL, NULL, NULL), -- suat 850 | Điểm Mù | 09/12 18:30 | Phòng 3 | C6 C7 C8
(4709, 7, NULL, '2026-12-07T20:49:19', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 798 | Con Mắt Thứ Ba | 07/12 21:45 | Phòng 2 | D6 D7
(4710, 6, NULL, '2026-12-07T20:49:20', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 795 | Trại Giam Hạnh Phúc | 07/12 21:00 | Phòng 1 | E5 E6
(4711, 6, NULL, '2026-12-07T20:49:38', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 796 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 07/12 21:00 | Phòng 4 | H6 H7
(4712, 6, 27, '2026-12-07T21:00:24', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 798 | Con Mắt Thứ Ba | 07/12 21:45 | Phòng 2 | H7
(4713, 7, NULL, '2026-12-07T21:05:28', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 829 | Trại Giam Hạnh Phúc | 09/12 09:00 | Phòng 1 | J3 J4
(4714, 7, 110, '2026-12-07T21:14:57', 75000, N'Cancelled', N'Cash', 75000, 3, 0, N'Lỗi thanh toán', '2026-12-07T21:35:03', 7); -- suat 798 | Con Mắt Thứ Ba | 07/12 21:45 | Phòng 2 | A6
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(10498, 4587, 782, 3, 260, 90000, N'Active'),
(10499, 4587, 782, 3, 261, 90000, N'Active'),
(10500, 4587, 782, 3, 262, 90000, N'Active'),
(10501, 4587, 782, 3, 263, 90000, N'Active'),
(10502, 4588, 771, 1, 53, 90000, N'Active'),
(10503, 4588, 771, 1, 54, 90000, N'Active'),
(10504, 4588, 771, 1, 55, 90000, N'Active'),
(10505, 4588, 771, 1, 56, 90000, N'Active'),
(10506, 4589, 771, 1, 18, 75000, N'Active'),
(10507, 4589, 771, 1, 19, 75000, N'Active'),
(10508, 4590, 773, 5, 524, 144000, N'Active'),
(10509, 4590, 773, 5, 525, 144000, N'Active'),
(10510, 4591, 772, 2, 205, 90000, N'Active'),
(10511, 4591, 772, 2, 206, 90000, N'Active'),
(10512, 4591, 772, 2, 207, 90000, N'Active'),
(10513, 4591, 772, 2, 208, 90000, N'Active'),
(10514, 4592, 789, 2, 115, 75000, N'Active'),
(10515, 4593, 809, 5, 464, 120000, N'Active'),
(10516, 4593, 809, 5, 465, 120000, N'Active'),
(10517, 4593, 809, 5, 466, 120000, N'Active'),
(10518, 4593, 809, 5, 467, 120000, N'Active'),
(10519, 4593, 809, 5, 468, 120000, N'Active'),
(10520, 4594, 816, 4, 366, 108000, N'Active'),
(10521, 4595, 789, 2, 186, 90000, N'Active'),
(10522, 4595, 789, 2, 187, 90000, N'Active'),
(10523, 4595, 789, 2, 188, 90000, N'Active'),
(10524, 4596, 787, 4, 378, 108000, N'Active'),
(10525, 4596, 787, 4, 379, 108000, N'Active'),
(10526, 4597, 774, 4, 393, 108000, N'Active'),
(10527, 4597, 774, 4, 394, 108000, N'Active'),
(10528, 4597, 774, 4, 395, 108000, N'Active'),
(10529, 4598, 774, 4, 390, 108000, N'Active'),
(10530, 4598, 774, 4, 391, 108000, N'Active'),
(10531, 4599, 775, 3, 247, 75000, N'Active'),
(10532, 4599, 775, 3, 248, 75000, N'Active'),
(10533, 4600, 776, 2, 160, 90000, N'Active'),
(10534, 4600, 776, 2, 161, 90000, N'Active'),
(10535, 4600, 776, 2, 162, 90000, N'Active'),
(10536, 4600, 776, 2, 163, 90000, N'Active'),
(10537, 4600, 776, 2, 164, 90000, N'Active'),
(10538, 4601, 818, 2, 164, 90000, N'Active'),
(10539, 4601, 818, 2, 165, 90000, N'Active'),
(10540, 4602, 783, 1, 79, 90000, N'Active'),
(10541, 4602, 783, 1, 80, 90000, N'Active'),
(10542, 4603, 810, 2, 172, 90000, N'Active'),
(10543, 4603, 810, 2, 173, 90000, N'Active'),
(10544, 4603, 810, 2, 174, 90000, N'Active'),
(10545, 4604, 779, 4, 402, 108000, N'Active'),
(10546, 4604, 779, 4, 403, 108000, N'Active'),
(10547, 4605, 783, 1, 81, 90000, N'Cancelled'),
(10548, 4605, 783, 1, 82, 90000, N'Cancelled'),
(10549, 4606, 791, 1, 55, 90000, N'Active'),
(10550, 4606, 791, 1, 56, 90000, N'Active'),
(10551, 4607, 819, 5, 508, 144000, N'Cancelled'),
(10552, 4607, 819, 5, 509, 144000, N'Cancelled'),
(10553, 4607, 819, 5, 510, 144000, N'Cancelled'),
(10554, 4608, 777, 3, 282, 90000, N'Active'),
(10555, 4608, 777, 3, 283, 90000, N'Active'),
(10556, 4608, 777, 3, 284, 90000, N'Active'),
(10557, 4609, 831, 5, 475, 120000, N'Active'),
(10558, 4609, 831, 5, 476, 120000, N'Active'),
(10559, 4609, 831, 5, 477, 120000, N'Active'),
(10560, 4609, 831, 5, 478, 120000, N'Active'),
(10561, 4610, 828, 3, 308, 90000, N'Active'),
(10562, 4611, 782, 3, 282, 90000, N'Active'),
(10563, 4611, 782, 3, 283, 90000, N'Active'),
(10564, 4611, 782, 3, 284, 90000, N'Active'),
(10565, 4612, 779, 4, 414, 108000, N'Active'),
(10566, 4612, 779, 4, 415, 108000, N'Active'),
(10567, 4613, 786, 3, 304, 90000, N'Active'),
(10568, 4613, 786, 3, 305, 90000, N'Active'),
(10569, 4613, 786, 3, 306, 90000, N'Active'),
(10570, 4613, 786, 3, 307, 90000, N'Active'),
(10571, 4613, 786, 3, 308, 90000, N'Active'),
(10572, 4613, 786, 3, 309, 90000, N'Active'),
(10573, 4614, 779, 4, 389, 108000, N'Active'),
(10574, 4614, 779, 4, 390, 108000, N'Active'),
(10575, 4615, 778, 1, 89, 90000, N'Active'),
(10576, 4615, 778, 1, 90, 90000, N'Active'),
(10577, 4616, 781, 2, 150, 90000, N'Active'),
(10578, 4616, 781, 2, 151, 90000, N'Active'),
(10579, 4617, 780, 5, 557, 144000, N'Active'),
(10580, 4617, 780, 5, 558, 144000, N'Active'),
(10581, 4618, 787, 4, 366, 108000, N'Active'),
(10582, 4618, 787, 4, 367, 108000, N'Active'),
(10583, 4619, 780, 5, 533, 144000, N'Active'),
(10584, 4619, 780, 5, 534, 144000, N'Active'),
(10585, 4620, 852, 2, 153, 90000, N'Active'),
(10586, 4621, 780, 5, 559, 144000, N'Active'),
(10587, 4621, 780, 5, 560, 144000, N'Active'),
(10588, 4622, 826, 5, 545, 144000, N'Active'),
(10589, 4622, 826, 5, 546, 144000, N'Active'),
(10590, 4622, 826, 5, 547, 144000, N'Active'),
(10591, 4622, 826, 5, 548, 144000, N'Active'),
(10592, 4623, 822, 4, 381, 108000, N'Active'),
(10593, 4624, 779, 4, 366, 108000, N'Active'),
(10594, 4624, 779, 4, 367, 108000, N'Active'),
(10595, 4624, 779, 4, 368, 108000, N'Active'),
(10596, 4625, 786, 3, 270, 90000, N'Active'),
(10597, 4625, 786, 3, 271, 90000, N'Active'),
(10598, 4626, 839, 2, 174, 90000, N'Active'),
(10599, 4626, 839, 2, 175, 90000, N'Active'),
(10600, 4627, 805, 2, 151, 90000, N'Active'),
(10601, 4627, 805, 2, 152, 90000, N'Active'),
(10602, 4628, 823, 2, 175, 90000, N'Active'),
(10603, 4629, 786, 3, 234, 75000, N'Active'),
(10604, 4629, 786, 3, 235, 75000, N'Active'),
(10605, 4629, 786, 3, 236, 75000, N'Active'),
(10606, 4630, 792, 3, 294, 90000, N'Active'),
(10607, 4631, 781, 2, 198, 90000, N'Active'),
(10608, 4631, 781, 2, 199, 90000, N'Active'),
(10609, 4632, 782, 3, 258, 90000, N'Active'),
(10610, 4633, 817, 1, 42, 90000, N'Active'),
(10611, 4633, 817, 1, 43, 90000, N'Active'),
(10612, 4634, 782, 3, 294, 90000, N'Active'),
(10613, 4635, 797, 5, 545, 144000, N'Active'),
(10614, 4636, 788, 1, 42, 90000, N'Active'),
(10615, 4636, 788, 1, 43, 90000, N'Active'),
(10616, 4637, 855, 5, 510, 144000, N'Active'),
(10617, 4638, 785, 5, 498, 144000, N'Active'),
(10618, 4638, 785, 5, 499, 144000, N'Active'),
(10619, 4639, 824, 1, 28, 75000, N'Active'),
(10620, 4639, 824, 1, 29, 75000, N'Active'),
(10621, 4639, 824, 1, 30, 75000, N'Active'),
(10622, 4639, 824, 1, 31, 75000, N'Active'),
(10623, 4640, 787, 4, 330, 90000, N'Active'),
(10624, 4640, 787, 4, 331, 90000, N'Active'),
(10625, 4641, 804, 3, 281, 90000, N'Cancelled'),
(10626, 4641, 804, 3, 282, 90000, N'Cancelled'),
(10627, 4641, 804, 3, 283, 90000, N'Cancelled'),
(10628, 4641, 804, 3, 284, 90000, N'Cancelled'),
(10629, 4642, 785, 5, 449, 120000, N'Active'),
(10630, 4643, 787, 4, 328, 90000, N'Active'),
(10631, 4643, 787, 4, 329, 90000, N'Active'),
(10632, 4644, 789, 2, 174, 90000, N'Active'),
(10633, 4644, 789, 2, 175, 90000, N'Active'),
(10634, 4645, 793, 4, 392, 108000, N'Active'),
(10635, 4645, 793, 4, 393, 108000, N'Active'),
(10636, 4646, 784, 2, 187, 90000, N'Active'),
(10637, 4646, 784, 2, 188, 90000, N'Active'),
(10638, 4647, 798, 2, 148, 90000, N'Active'),
(10639, 4647, 798, 2, 149, 90000, N'Active'),
(10640, 4648, 790, 5, 545, 144000, N'Active'),
(10641, 4648, 790, 5, 546, 144000, N'Active'),
(10642, 4649, 787, 4, 404, 108000, N'Active'),
(10643, 4650, 793, 4, 387, 108000, N'Active'),
(10644, 4650, 793, 4, 388, 108000, N'Active'),
(10645, 4650, 793, 4, 389, 108000, N'Active'),
(10646, 4651, 816, 4, 402, 108000, N'Active'),
(10647, 4651, 816, 4, 403, 108000, N'Active'),
(10648, 4651, 816, 4, 404, 108000, N'Active'),
(10649, 4652, 789, 2, 162, 90000, N'Active'),
(10650, 4652, 789, 2, 163, 90000, N'Active'),
(10651, 4653, 790, 5, 521, 144000, N'Cancelled'),
(10652, 4654, 791, 1, 99, 90000, N'Active'),
(10653, 4654, 791, 1, 100, 90000, N'Active'),
(10654, 4655, 813, 2, 125, 75000, N'Active'),
(10655, 4655, 813, 2, 126, 75000, N'Active'),
(10656, 4655, 813, 2, 127, 75000, N'Active'),
(10657, 4656, 792, 3, 244, 75000, N'Active'),
(10658, 4656, 792, 3, 245, 75000, N'Active'),
(10659, 4657, 796, 4, 378, 108000, N'Active'),
(10660, 4657, 796, 4, 379, 108000, N'Active'),
(10661, 4658, 790, 5, 474, 120000, N'Active'),
(10662, 4658, 790, 5, 475, 120000, N'Active'),
(10663, 4659, 786, 3, 294, 90000, N'Active'),
(10664, 4659, 786, 3, 295, 90000, N'Active'),
(10665, 4659, 786, 3, 296, 90000, N'Active'),
(10666, 4659, 786, 3, 297, 90000, N'Active'),
(10667, 4660, 791, 1, 53, 90000, N'Active'),
(10668, 4660, 791, 1, 54, 90000, N'Active'),
(10669, 4661, 787, 4, 342, 90000, N'Active'),
(10670, 4661, 787, 4, 343, 90000, N'Active'),
(10671, 4662, 825, 4, 328, 90000, N'Active'),
(10672, 4662, 825, 4, 329, 90000, N'Active'),
(10673, 4663, 821, 3, 294, 90000, N'Active'),
(10674, 4663, 821, 3, 295, 90000, N'Active'),
(10675, 4664, 800, 1, 54, 90000, N'Active'),
(10676, 4664, 800, 1, 55, 90000, N'Active'),
(10677, 4665, 824, 1, 90, 90000, N'Active'),
(10678, 4665, 824, 1, 91, 90000, N'Active'),
(10679, 4666, 790, 5, 559, 144000, N'Active'),
(10680, 4666, 790, 5, 560, 144000, N'Active'),
(10681, 4666, 790, 5, 561, 144000, N'Active'),
(10682, 4666, 790, 5, 562, 144000, N'Active'),
(10683, 4667, 857, 3, 256, 90000, N'Active'),
(10684, 4667, 857, 3, 257, 90000, N'Active'),
(10685, 4668, 794, 2, 150, 90000, N'Active'),
(10686, 4668, 794, 2, 151, 90000, N'Active'),
(10687, 4669, 794, 2, 200, 90000, N'Cancelled'),
(10688, 4669, 794, 2, 201, 90000, N'Cancelled'),
(10689, 4670, 802, 5, 544, 144000, N'Active'),
(10690, 4670, 802, 5, 545, 144000, N'Active'),
(10691, 4670, 802, 5, 546, 144000, N'Active'),
(10692, 4670, 802, 5, 547, 144000, N'Active'),
(10693, 4670, 802, 5, 548, 144000, N'Active'),
(10694, 4671, 789, 2, 150, 90000, N'Active'),
(10695, 4671, 789, 2, 151, 90000, N'Active'),
(10696, 4671, 789, 2, 152, 90000, N'Active'),
(10697, 4672, 797, 5, 523, 144000, N'Active'),
(10698, 4672, 797, 5, 524, 144000, N'Active'),
(10699, 4673, 789, 2, 189, 90000, N'Active'),
(10700, 4673, 789, 2, 190, 90000, N'Active'),
(10701, 4674, 793, 4, 365, 108000, N'Active'),
(10702, 4674, 793, 4, 366, 108000, N'Active'),
(10703, 4675, 792, 3, 270, 90000, N'Active'),
(10704, 4675, 792, 3, 271, 90000, N'Active'),
(10705, 4676, 794, 2, 186, 90000, N'Active'),
(10706, 4676, 794, 2, 187, 90000, N'Active'),
(10707, 4677, 792, 3, 313, 90000, N'Active'),
(10708, 4677, 792, 3, 314, 90000, N'Active'),
(10709, 4678, 791, 1, 90, 90000, N'Active'),
(10710, 4678, 791, 1, 91, 90000, N'Active'),
(10711, 4679, 793, 4, 363, 108000, N'Active'),
(10712, 4679, 793, 4, 364, 108000, N'Active'),
(10713, 4680, 790, 5, 487, 144000, N'Active'),
(10714, 4681, 805, 2, 187, 90000, N'Active'),
(10715, 4681, 805, 2, 188, 90000, N'Active'),
(10716, 4682, 794, 2, 193, 90000, N'Active'),
(10717, 4682, 794, 2, 194, 90000, N'Active'),
(10718, 4683, 792, 3, 295, 90000, N'Active'),
(10719, 4683, 792, 3, 296, 90000, N'Active'),
(10720, 4683, 792, 3, 297, 90000, N'Active'),
(10721, 4683, 792, 3, 298, 90000, N'Active'),
(10722, 4684, 791, 1, 18, 75000, N'Cancelled'),
(10723, 4684, 791, 1, 19, 75000, N'Cancelled'),
(10724, 4685, 795, 1, 42, 90000, N'Active'),
(10725, 4685, 795, 1, 43, 90000, N'Active'),
(10726, 4686, 792, 3, 306, 90000, N'Active'),
(10727, 4686, 792, 3, 307, 90000, N'Active'),
(10728, 4687, 793, 4, 390, 108000, N'Active'),
(10729, 4687, 793, 4, 391, 108000, N'Active'),
(10730, 4688, 812, 1, 7, 75000, N'Active'),
(10731, 4688, 812, 1, 8, 75000, N'Active'),
(10732, 4689, 791, 1, 39, 90000, N'Active'),
(10733, 4689, 791, 1, 40, 90000, N'Active'),
(10734, 4689, 791, 1, 41, 90000, N'Active'),
(10735, 4689, 791, 1, 42, 90000, N'Active'),
(10736, 4689, 791, 1, 43, 90000, N'Active'),
(10737, 4689, 791, 1, 44, 90000, N'Active'),
(10738, 4690, 792, 3, 257, 90000, N'Active'),
(10739, 4690, 792, 3, 258, 90000, N'Active'),
(10740, 4690, 792, 3, 259, 90000, N'Active'),
(10741, 4690, 792, 3, 260, 90000, N'Active'),
(10742, 4691, 792, 3, 247, 75000, N'Active'),
(10743, 4691, 792, 3, 248, 75000, N'Active'),
(10744, 4692, 821, 3, 256, 90000, N'Active'),
(10745, 4692, 821, 3, 257, 90000, N'Active'),
(10746, 4693, 794, 2, 111, 75000, N'Active'),
(10747, 4693, 794, 2, 112, 75000, N'Active'),
(10748, 4693, 794, 2, 113, 75000, N'Active'),
(10749, 4693, 794, 2, 114, 75000, N'Active'),
(10750, 4693, 794, 2, 115, 75000, N'Active'),
(10751, 4693, 794, 2, 116, 75000, N'Active'),
(10752, 4694, 813, 2, 187, 90000, N'Active'),
(10753, 4694, 813, 2, 188, 90000, N'Active'),
(10754, 4695, 796, 4, 400, 108000, N'Active'),
(10755, 4696, 848, 5, 532, 144000, N'Active'),
(10756, 4696, 848, 5, 533, 144000, N'Active'),
(10757, 4697, 795, 1, 68, 90000, N'Active'),
(10758, 4697, 795, 1, 69, 90000, N'Active'),
(10759, 4698, 796, 4, 413, 108000, N'Active'),
(10760, 4699, 796, 4, 401, 108000, N'Active'),
(10761, 4699, 796, 4, 402, 108000, N'Active'),
(10762, 4699, 796, 4, 403, 108000, N'Active'),
(10763, 4699, 796, 4, 404, 108000, N'Active'),
(10764, 4700, 797, 5, 521, 144000, N'Active'),
(10765, 4700, 797, 5, 522, 144000, N'Active'),
(10766, 4701, 798, 2, 110, 75000, N'Active'),
(10767, 4701, 798, 2, 111, 75000, N'Active'),
(10768, 4701, 798, 2, 112, 75000, N'Active'),
(10769, 4701, 798, 2, 113, 75000, N'Active'),
(10770, 4702, 795, 1, 6, 75000, N'Active'),
(10771, 4702, 795, 1, 7, 75000, N'Active'),
(10772, 4702, 795, 1, 8, 75000, N'Active'),
(10773, 4703, 798, 2, 116, 75000, N'Active'),
(10774, 4703, 798, 2, 117, 75000, N'Active'),
(10775, 4703, 798, 2, 118, 75000, N'Active'),
(10776, 4704, 796, 4, 341, 90000, N'Active'),
(10777, 4704, 796, 4, 342, 90000, N'Active'),
(10778, 4705, 799, 3, 306, 90000, N'Active'),
(10779, 4705, 799, 3, 307, 90000, N'Active'),
(10780, 4705, 799, 3, 308, 90000, N'Active'),
(10781, 4705, 799, 3, 309, 90000, N'Active'),
(10782, 4705, 799, 3, 310, 90000, N'Active'),
(10783, 4706, 796, 4, 331, 90000, N'Active'),
(10784, 4706, 796, 4, 332, 90000, N'Active'),
(10785, 4706, 796, 4, 333, 90000, N'Active'),
(10786, 4707, 826, 5, 497, 144000, N'Active'),
(10787, 4707, 826, 5, 498, 144000, N'Active'),
(10788, 4707, 826, 5, 499, 144000, N'Active'),
(10789, 4708, 850, 3, 246, 75000, N'Active'),
(10790, 4708, 850, 3, 247, 75000, N'Active'),
(10791, 4708, 850, 3, 248, 75000, N'Active'),
(10792, 4709, 798, 2, 150, 90000, N'Active'),
(10793, 4709, 798, 2, 151, 90000, N'Active'),
(10794, 4710, 795, 1, 53, 90000, N'Active'),
(10795, 4710, 795, 1, 54, 90000, N'Active'),
(10796, 4711, 796, 4, 414, 108000, N'Active'),
(10797, 4711, 796, 4, 415, 108000, N'Active'),
(10798, 4712, 798, 2, 199, 90000, N'Active'),
(10799, 4713, 829, 1, 99, 90000, N'Active'),
(10800, 4713, 829, 1, 100, 90000, N'Active'),
(10801, 4714, 798, 2, 114, 75000, N'Cancelled');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 3 08/12/2026: 127 hoa don (12 huy), 273 ve, doanh thu 23.686.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(4715, 7, NULL, '2026-12-08T08:04:13', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 801 | Hexed: Thế Giới Phép Thuật | 08/12 09:00 | Phòng 2 | E6 E7
(4716, 8, NULL, '2026-12-08T08:05:03', 216000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 808 | Ramayana: Khởi Nguồn Một Huyền Thoại | 08/12 12:15 | Phòng 4 | J9 J10
(4717, 7, 37, '2026-12-08T08:11:51', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 803 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 08/12 09:15 | Phòng 4 | H7 H8
(4718, 7, NULL, '2026-12-08T08:20:10', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 834 | Ma Mút Con Vượt Kỷ Băng Hà | 09/12 11:15 | Phòng 2 | G6 G7 G8 G9
(4719, 7, 86, '2026-12-08T08:23:32', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 806 | Ngày Con Còn Mẹ | 08/12 11:15 | Phòng 3 | D5 D6
(4720, 8, NULL, '2026-12-08T08:28:12', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 800 | Trại Giam Hạnh Phúc | 08/12 09:00 | Phòng 1 | F6 F7
(4721, 7, NULL, '2026-12-08T08:33:07', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 801 | Hexed: Thế Giới Phép Thuật | 08/12 09:00 | Phòng 2 | G7 G8
(4722, 8, 25, '2026-12-08T08:44:10', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 833 | Kiến Lé Phiêu Lưu Ké | 09/12 09:30 | Phòng 3 | F3
(4723, 7, NULL, '2026-12-08T08:51:50', 648000, N'Paid', N'Cash', 650000, 0, 0, NULL, NULL, NULL), -- suat 803 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 08/12 09:15 | Phòng 4 | G4 G5 G6 G7 G8 G9
(4724, 8, NULL, '2026-12-08T08:52:19', 150000, N'Cancelled', N'Cash', 500000, 0, 0, N'Nhầm suất / ghế', '2026-12-08T09:20:45', 8), -- suat 842 | Ngày Con Còn Mẹ | 09/12 15:00 | Phòng 2 | B8 B9
(4725, 8, 28, '2026-12-08T09:00:41', 150000, N'Paid', N'Cash', 200000, 7, 0, NULL, NULL, NULL), -- suat 841 | Trại Giam Hạnh Phúc | 09/12 13:45 | Phòng 1 | A6 A7
(4726, 8, NULL, '2026-12-08T09:16:14', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 809 | Godzilla Trừ Không | 08/12 12:15 | Phòng 5 | L1 L2
(4727, 8, NULL, '2026-12-08T09:30:54', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 809 | Godzilla Trừ Không | 08/12 12:15 | Phòng 5 | C6 C7
(4728, 7, NULL, '2026-12-08T09:39:53', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 821 | Điểm Mù | 08/12 18:30 | Phòng 3 | F6 F7 F8
(4729, 8, NULL, '2026-12-08T09:46:57', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 808 | Ramayana: Khởi Nguồn Một Huyền Thoại | 08/12 12:15 | Phòng 4 | E6 E7
(4730, 8, NULL, '2026-12-08T10:01:20', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 883 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 21:00 | Phòng 4 | D6 D7
(4731, 7, NULL, '2026-12-08T10:01:27', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 810 | Hexed: Thế Giới Phép Thuật | 08/12 12:45 | Phòng 2 | D6 D7
(4732, 7, NULL, '2026-12-08T10:04:30', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 815 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 08/12 15:30 | Phòng 3 | H3
(4733, 8, NULL, '2026-12-08T10:06:10', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 816 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 08/12 15:30 | Phòng 4 | J9 J10
(4734, 7, 42, '2026-12-08T10:21:41', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 806 | Ngày Con Còn Mẹ | 08/12 11:15 | Phòng 3 | D8 D9
(4735, 8, NULL, '2026-12-08T10:36:15', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 848 | Dune: Hành Tinh Cát - Phần Hai | 09/12 18:00 | Phòng 5 | E6 E7
(4736, 7, NULL, '2026-12-08T10:48:03', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 839 | Hexed: Thế Giới Phép Thuật | 09/12 12:45 | Phòng 2 | A4 A5
(4737, 8, NULL, '2026-12-08T10:50:19', 150000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 812 | Trại Giam Hạnh Phúc | 08/12 13:45 | Phòng 1 | A5 A6
(4738, 7, NULL, '2026-12-08T10:54:19', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 813 | Ngày Con Còn Mẹ | 08/12 15:00 | Phòng 2 | E6 E7 E8
(4739, 7, NULL, '2026-12-08T10:59:32', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 830 | Hexed: Thế Giới Phép Thuật | 09/12 09:00 | Phòng 2 | F5 F6
(4740, 8, NULL, '2026-12-08T11:02:15', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 808 | Ramayana: Khởi Nguồn Một Huyền Thoại | 08/12 12:15 | Phòng 4 | G4 G5 G6 G7
(4741, 7, NULL, '2026-12-08T11:06:27', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 811 | Con Mắt Thứ Ba | 08/12 13:30 | Phòng 3 | D6 D7
(4742, 8, NULL, '2026-12-08T11:19:14', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 833 | Kiến Lé Phiêu Lưu Ké | 09/12 09:30 | Phòng 3 | F6 F7
(4743, 8, NULL, '2026-12-08T11:22:29', 90000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 811 | Con Mắt Thứ Ba | 08/12 13:30 | Phòng 3 | F5
(4744, 8, NULL, '2026-12-08T11:40:12', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 812 | Trại Giam Hạnh Phúc | 08/12 13:45 | Phòng 1 | H6 H7
(4745, 8, NULL, '2026-12-08T11:48:47', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 822 | Godzilla Trừ Không | 08/12 18:30 | Phòng 4 | G6 G7
(4746, 7, NULL, '2026-12-08T11:50:42', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 809 | Godzilla Trừ Không | 08/12 12:15 | Phòng 5 | K6
(4747, 7, NULL, '2026-12-08T11:52:49', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 808 | Ramayana: Khởi Nguồn Một Huyền Thoại | 08/12 12:15 | Phòng 4 | J11 J12
(4748, 8, NULL, '2026-12-08T11:54:55', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 841 | Trại Giam Hạnh Phúc | 09/12 13:45 | Phòng 1 | H6 H7
(4749, 8, 21, '2026-12-08T11:56:03', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 850 | Điểm Mù | 09/12 18:30 | Phòng 3 | F8 F9 F10
(4750, 7, NULL, '2026-12-08T11:58:06', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 808 | Ramayana: Khởi Nguồn Một Huyền Thoại | 08/12 12:15 | Phòng 4 | E4 E5
(4751, 7, NULL, '2026-12-08T12:15:03', 150000, N'Cancelled', N'Cash', 150000, 0, 0, N'Khách đổi ý', '2026-12-08T12:31:56', 7), -- suat 879 | Điểm Mù | 10/12 18:30 | Phòng 3 | B7 B8
(4752, 8, NULL, '2026-12-08T12:15:05', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 831 | Dune: Hành Tinh Cát - Phần Hai | 09/12 09:00 | Phòng 5 | K6 K7
(4753, 8, NULL, '2026-12-08T12:25:09', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 827 | Con Mắt Thứ Ba | 08/12 21:45 | Phòng 2 | G6
(4754, 7, NULL, '2026-12-08T12:34:48', 150000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 812 | Trại Giam Hạnh Phúc | 08/12 13:45 | Phòng 1 | A10 A11
(4755, 7, 68, '2026-12-08T12:49:22', 476000, N'Paid', N'Card', NULL, 33, 100, NULL, NULL, NULL), -- suat 814 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 08/12 15:00 | Phòng 5 | F4 F5 F6 F7
(4756, 8, NULL, '2026-12-08T12:52:57', 120000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 848 | Dune: Hành Tinh Cát - Phần Hai | 09/12 18:00 | Phòng 5 | A6
(4757, 7, 67, '2026-12-08T13:22:43', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 811 | Con Mắt Thứ Ba | 08/12 13:30 | Phòng 3 | G7 G8
(4758, 8, NULL, '2026-12-08T13:35:33', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 814 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 08/12 15:00 | Phòng 5 | G6 G7
(4759, 8, 60, '2026-12-08T13:35:43', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 815 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 08/12 15:30 | Phòng 3 | G6 G7
(4760, 7, NULL, '2026-12-08T13:37:08', 360000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 817 | Mẹ Mìn: Giao Kèo Với Quỷ | 08/12 16:15 | Phòng 1 | D8 D9 D10 D11
(4761, 8, NULL, '2026-12-08T13:47:31', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 871 | Ngày Con Còn Mẹ | 10/12 15:00 | Phòng 2 | E6 E7
(4762, 7, 66, '2026-12-08T13:51:51', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 818 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 08/12 17:15 | Phòng 2 | A8 A9
(4763, 8, NULL, '2026-12-08T14:04:14', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 848 | Dune: Hành Tinh Cát - Phần Hai | 09/12 18:00 | Phòng 5 | F6 F7
(4764, 8, NULL, '2026-12-08T14:13:48', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 815 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 08/12 15:30 | Phòng 3 | C6
(4765, 7, 67, '2026-12-08T14:25:10', 402000, N'Paid', N'Transfer', NULL, 28, 30, NULL, NULL, NULL), -- suat 838 | Godzilla Trừ Không | 09/12 12:15 | Phòng 5 | H6 H7 H8
(4766, 7, 120, '2026-12-08T14:36:46', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 857 | Con Mắt Thứ Ba | 09/12 21:45 | Phòng 3 | F7 F8
(4767, 8, NULL, '2026-12-08T14:37:34', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 854 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 21:00 | Phòng 4 | E4 E5 E6
(4768, 8, NULL, '2026-12-08T14:43:35', 540000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Nhầm suất / ghế', '2026-12-08T14:53:58', 8), -- suat 823 | Bò Sữa Bay | 08/12 19:30 | Phòng 2 | E4 E5 E6 E7 E8 E9
(4769, 7, 78, '2026-12-08T14:59:16', 153000, N'Paid', N'Cash', 200000, 10, 27, NULL, NULL, NULL), -- suat 869 | Con Mắt Thứ Ba | 10/12 13:30 | Phòng 3 | G6 G7
(4770, 10, 79, '2026-12-08T15:01:43', 144000, N'Paid', N'Transfer', NULL, 10, 36, NULL, NULL, NULL), -- suat 815 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 08/12 15:30 | Phòng 3 | H5 H6
(4771, 9, NULL, '2026-12-08T15:07:05', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 818 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 08/12 17:15 | Phòng 2 | G5 G6
(4772, 10, NULL, '2026-12-08T15:11:40', 270000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Sự cố phòng chiếu', '2026-12-08T17:20:04', 2), -- suat 879 | Điểm Mù | 10/12 18:30 | Phòng 3 | G1 G2 G3
(4773, 9, NULL, '2026-12-08T15:18:48', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 822 | Godzilla Trừ Không | 08/12 18:30 | Phòng 4 | H5 H6 H7 H8
(4774, 9, NULL, '2026-12-08T15:21:43', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 815 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 08/12 15:30 | Phòng 3 | H7 H8
(4775, 10, 42, '2026-12-08T15:22:20', 150000, N'Paid', N'Cash', 500000, 7, 0, NULL, NULL, NULL), -- suat 839 | Hexed: Thế Giới Phép Thuật | 09/12 12:45 | Phòng 2 | A7 A8
(4776, 9, NULL, '2026-12-08T15:24:03', 270000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 818 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 08/12 17:15 | Phòng 2 | G7 G8 G9
(4777, 9, NULL, '2026-12-08T15:24:46', 216000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 822 | Godzilla Trừ Không | 08/12 18:30 | Phòng 4 | F6 F7
(4778, 9, NULL, '2026-12-08T15:30:12', 360000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-12-08T15:59:02', 9), -- suat 862 | Kiến Lé Phiêu Lưu Ké | 10/12 09:30 | Phòng 3 | J1 J2 J3 J4
(4779, 9, NULL, '2026-12-08T15:32:27', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 827 | Con Mắt Thứ Ba | 08/12 21:45 | Phòng 2 | D6 D7
(4780, 10, NULL, '2026-12-08T15:35:49', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 828 | Con Mắt Thứ Ba | 08/12 21:45 | Phòng 3 | E7 E8
(4781, 9, 90, '2026-12-08T15:42:38', 120000, N'Paid', N'Cash', 500000, 6, 0, NULL, NULL, NULL), -- suat 848 | Dune: Hành Tinh Cát - Phần Hai | 09/12 18:00 | Phòng 5 | C6
(4782, 9, NULL, '2026-12-08T15:46:49', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 823 | Bò Sữa Bay | 08/12 19:30 | Phòng 2 | H5 H6
(4783, 10, NULL, '2026-12-08T15:47:37', 150000, N'Cancelled', N'Cash', 500000, 0, 0, N'Lỗi thanh toán', '2026-12-08T16:36:13', 10), -- suat 820 | Bắt Cá Ba Tay | 08/12 18:30 | Phòng 1 | A9 A10
(4784, 9, 2, '2026-12-08T15:54:02', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 856 | Con Mắt Thứ Ba | 09/12 21:45 | Phòng 2 | G5 G6
(4785, 10, NULL, '2026-12-08T16:08:10', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 822 | Godzilla Trừ Không | 08/12 18:30 | Phòng 4 | G8 G9
(4786, 10, 76, '2026-12-08T16:09:01', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 852 | Bò Sữa Bay | 09/12 19:30 | Phòng 2 | B6 B7
(4787, 9, 72, '2026-12-08T16:15:42', 225000, N'Paid', N'Transfer', NULL, 11, 0, NULL, NULL, NULL), -- suat 821 | Điểm Mù | 08/12 18:30 | Phòng 3 | A7 A8 A9
(4788, 10, NULL, '2026-12-08T16:33:41', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 820 | Bắt Cá Ba Tay | 08/12 18:30 | Phòng 1 | J11 J12
(4789, 9, NULL, '2026-12-08T16:36:01', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 819 | Dune: Hành Tinh Cát - Phần Hai | 08/12 18:00 | Phòng 5 | H6
(4790, 10, NULL, '2026-12-08T16:37:33', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 821 | Điểm Mù | 08/12 18:30 | Phòng 3 | H7 H8
(4791, 10, NULL, '2026-12-08T16:51:30', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 820 | Bắt Cá Ba Tay | 08/12 18:30 | Phòng 1 | F8 F9 F10
(4792, 9, NULL, '2026-12-08T16:53:19', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 856 | Con Mắt Thứ Ba | 09/12 21:45 | Phòng 2 | E3 E4
(4793, 9, NULL, '2026-12-08T17:02:24', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 819 | Dune: Hành Tinh Cát - Phần Hai | 08/12 18:00 | Phòng 5 | J4
(4794, 10, 51, '2026-12-08T17:05:30', 240000, N'Cancelled', N'Card', NULL, 12, 0, N'Lỗi thanh toán', '2026-12-08T17:42:34', 10), -- suat 819 | Dune: Hành Tinh Cát - Phần Hai | 08/12 18:00 | Phòng 5 | D6 D7
(4795, 9, NULL, '2026-12-08T17:06:09', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 819 | Dune: Hành Tinh Cát - Phần Hai | 08/12 18:00 | Phòng 5 | K7
(4796, 10, 118, '2026-12-08T17:22:02', 300000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 821 | Điểm Mù | 08/12 18:30 | Phòng 3 | B4 B5 B6 B7
(4797, 10, NULL, '2026-12-08T17:22:31', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 822 | Godzilla Trừ Không | 08/12 18:30 | Phòng 4 | A6 A7
(4798, 9, NULL, '2026-12-08T17:25:45', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 820 | Bắt Cá Ba Tay | 08/12 18:30 | Phòng 1 | E6 E7
(4799, 9, NULL, '2026-12-08T17:26:00', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 819 | Dune: Hành Tinh Cát - Phần Hai | 08/12 18:00 | Phòng 5 | K5 K6
(4800, 10, 93, '2026-12-08T17:40:31', 480000, N'Cancelled', N'Transfer', NULL, 24, 0, N'Khách đổi ý', '2026-12-08T18:54:06', 10), -- suat 855 | Godzilla Trừ Không | 09/12 21:15 | Phòng 5 | D5 D6 D7 D8
(4801, 10, 90, '2026-12-08T17:44:21', 108000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 822 | Godzilla Trừ Không | 08/12 18:30 | Phòng 4 | E7
(4802, 10, 35, '2026-12-08T17:49:21', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 820 | Bắt Cá Ba Tay | 08/12 18:30 | Phòng 1 | H7
(4803, 10, NULL, '2026-12-08T17:49:57', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 819 | Dune: Hành Tinh Cát - Phần Hai | 08/12 18:00 | Phòng 5 | G7 G8
(4804, 9, NULL, '2026-12-08T17:55:42', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 844 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 09/12 15:30 | Phòng 3 | B8 B9
(4805, 10, NULL, '2026-12-08T18:04:23', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 821 | Điểm Mù | 08/12 18:30 | Phòng 3 | D6 D7
(4806, 10, NULL, '2026-12-08T18:06:27', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 832 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 09:15 | Phòng 4 | B6 B7
(4807, 9, NULL, '2026-12-08T18:11:40', 180000, N'Cancelled', N'Cash', 180000, 0, 0, N'Sự cố phòng chiếu', '2026-12-08T18:18:19', 2), -- suat 820 | Bắt Cá Ba Tay | 08/12 18:30 | Phòng 1 | G9 G10
(4808, 9, 94, '2026-12-08T18:14:55', 360000, N'Paid', N'Card', NULL, 25, 0, NULL, NULL, NULL), -- suat 828 | Con Mắt Thứ Ba | 08/12 21:45 | Phòng 3 | D4 D5 D6 D7
(4809, 9, NULL, '2026-12-08T18:17:36', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 820 | Bắt Cá Ba Tay | 08/12 18:30 | Phòng 1 | H8 H9
(4810, 10, 31, '2026-12-08T18:21:19', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 820 | Bắt Cá Ba Tay | 08/12 18:30 | Phòng 1 | F6 F7
(4811, 10, 69, '2026-12-08T18:22:06', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 851 | Godzilla Trừ Không | 09/12 18:30 | Phòng 4 | E7 E8
(4812, 9, NULL, '2026-12-08T18:30:18', 120000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 826 | Godzilla Trừ Không | 08/12 21:15 | Phòng 5 | D7
(4813, 9, NULL, '2026-12-08T18:31:21', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 828 | Con Mắt Thứ Ba | 08/12 21:45 | Phòng 3 | H5
(4814, 9, NULL, '2026-12-08T18:37:34', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 848 | Dune: Hành Tinh Cát - Phần Hai | 09/12 18:00 | Phòng 5 | G5 G6
(4815, 9, 49, '2026-12-08T18:44:09', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 846 | Mẹ Mìn: Giao Kèo Với Quỷ | 09/12 16:15 | Phòng 1 | H8 H9
(4816, 10, NULL, '2026-12-08T18:48:01', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 823 | Bò Sữa Bay | 08/12 19:30 | Phòng 2 | F5 F6
(4817, 10, 78, '2026-12-08T18:52:18', 288000, N'Paid', N'Cash', 288000, 20, 0, NULL, NULL, NULL), -- suat 826 | Godzilla Trừ Không | 08/12 21:15 | Phòng 5 | G3 G4
(4818, 9, NULL, '2026-12-08T18:56:35', 216000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 825 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 08/12 21:00 | Phòng 4 | H5 H6
(4819, 9, NULL, '2026-12-08T18:56:36', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 856 | Con Mắt Thứ Ba | 09/12 21:45 | Phòng 2 | F6
(4820, 9, 26, '2026-12-08T19:03:48', 180000, N'Cancelled', N'Transfer', NULL, 12, 0, N'Khách đổi ý', '2026-12-08T19:24:32', 9), -- suat 823 | Bò Sữa Bay | 08/12 19:30 | Phòng 2 | F3 F4
(4821, 9, 69, '2026-12-08T19:04:18', 144000, N'Paid', N'Cash', 144000, 10, 36, NULL, NULL, NULL), -- suat 823 | Bò Sữa Bay | 08/12 19:30 | Phòng 2 | G7 G8
(4822, 9, 116, '2026-12-08T19:18:58', 360000, N'Paid', N'Cash', 360000, 36, 0, NULL, NULL, NULL), -- suat 824 | Trại Giam Hạnh Phúc | 08/12 21:00 | Phòng 1 | J5 J6 J7 J8
(4823, 10, 74, '2026-12-08T19:22:51', 288000, N'Cancelled', N'Cash', 288000, 20, 0, N'Lỗi thanh toán', '2026-12-08T20:50:03', 2), -- suat 848 | Dune: Hành Tinh Cát - Phần Hai | 09/12 18:00 | Phòng 5 | F4 F5
(4824, 10, NULL, '2026-12-08T19:23:27', 288000, N'Cancelled', N'Card', NULL, 0, 0, N'Nhầm suất / ghế', '2026-12-08T19:46:57', 10), -- suat 826 | Godzilla Trừ Không | 08/12 21:15 | Phòng 5 | G6 G7
(4825, 9, NULL, '2026-12-08T19:26:38', 216000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 851 | Godzilla Trừ Không | 09/12 18:30 | Phòng 4 | H6 H7
(4826, 10, 107, '2026-12-08T19:42:34', 216000, N'Paid', N'Transfer', NULL, 21, 0, NULL, NULL, NULL), -- suat 825 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 08/12 21:00 | Phòng 4 | J3 J4
(4827, 9, NULL, '2026-12-08T19:48:25', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 826 | Godzilla Trừ Không | 08/12 21:15 | Phòng 5 | L11 L12
(4828, 10, NULL, '2026-12-08T19:48:46', 90000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 854 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 21:00 | Phòng 4 | B7
(4829, 9, NULL, '2026-12-08T19:49:03', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 848 | Dune: Hành Tinh Cát - Phần Hai | 09/12 18:00 | Phòng 5 | E5
(4830, 10, 49, '2026-12-08T20:19:38', 450000, N'Paid', N'Transfer', NULL, 31, 0, NULL, NULL, NULL), -- suat 852 | Bò Sữa Bay | 09/12 19:30 | Phòng 2 | H5 H6 H7 H8 H9
(4831, 10, 67, '2026-12-08T20:45:05', 230000, N'Paid', N'Transfer', NULL, 11, 40, NULL, NULL, NULL), -- suat 825 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 08/12 21:00 | Phòng 4 | B6 B7 B8
(4832, 9, 100, '2026-12-08T20:47:31', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 854 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 21:00 | Phòng 4 | F6 F7
(4833, 10, 79, '2026-12-08T20:50:45', 75000, N'Paid', N'Transfer', NULL, 3, 0, NULL, NULL, NULL), -- suat 824 | Trại Giam Hạnh Phúc | 08/12 21:00 | Phòng 1 | A7
(4834, 10, 93, '2026-12-08T20:52:24', 90000, N'Paid', N'Cash', 90000, 4, 0, NULL, NULL, NULL), -- suat 825 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 08/12 21:00 | Phòng 4 | A6
(4835, 9, 115, '2026-12-08T20:53:57', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 829 | Trại Giam Hạnh Phúc | 09/12 09:00 | Phòng 1 | H6 H7
(4836, 10, NULL, '2026-12-08T21:07:35', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 827 | Con Mắt Thứ Ba | 08/12 21:45 | Phòng 2 | F6
(4837, 9, 119, '2026-12-08T21:07:45', 150000, N'Paid', N'Card', NULL, 10, 30, NULL, NULL, NULL), -- suat 827 | Con Mắt Thứ Ba | 08/12 21:45 | Phòng 2 | F8 F9
(4838, 9, 9, '2026-12-08T21:09:47', 108000, N'Paid', N'Cash', 500000, 7, 0, NULL, NULL, NULL), -- suat 837 | Ramayana: Khởi Nguồn Một Huyền Thoại | 09/12 12:15 | Phòng 4 | G8
(4839, 10, NULL, '2026-12-08T21:30:37', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 828 | Con Mắt Thứ Ba | 08/12 21:45 | Phòng 3 | H6 H7
(4840, 9, NULL, '2026-12-08T21:33:48', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 827 | Con Mắt Thứ Ba | 08/12 21:45 | Phòng 2 | E6 E7
(4841, 9, 80, '2026-12-08T21:38:53', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL); -- suat 841 | Trại Giam Hạnh Phúc | 09/12 13:45 | Phòng 1 | F5 F6
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(10802, 4715, 801, 2, 162, 90000, N'Active'),
(10803, 4715, 801, 2, 163, 90000, N'Active'),
(10804, 4716, 808, 4, 429, 108000, N'Active'),
(10805, 4716, 808, 4, 430, 108000, N'Active'),
(10806, 4717, 803, 4, 415, 108000, N'Active'),
(10807, 4717, 803, 4, 416, 108000, N'Active'),
(10808, 4718, 834, 2, 186, 90000, N'Active'),
(10809, 4718, 834, 2, 187, 90000, N'Active'),
(10810, 4718, 834, 2, 188, 90000, N'Active'),
(10811, 4718, 834, 2, 189, 90000, N'Active'),
(10812, 4719, 806, 3, 257, 90000, N'Active'),
(10813, 4719, 806, 3, 258, 90000, N'Active'),
(10814, 4720, 800, 1, 66, 90000, N'Active'),
(10815, 4720, 800, 1, 67, 90000, N'Active'),
(10816, 4721, 801, 2, 187, 90000, N'Active'),
(10817, 4721, 801, 2, 188, 90000, N'Active'),
(10818, 4722, 833, 3, 279, 90000, N'Active'),
(10819, 4723, 803, 4, 400, 108000, N'Active'),
(10820, 4723, 803, 4, 401, 108000, N'Active'),
(10821, 4723, 803, 4, 402, 108000, N'Active'),
(10822, 4723, 803, 4, 403, 108000, N'Active'),
(10823, 4723, 803, 4, 404, 108000, N'Active'),
(10824, 4723, 803, 4, 405, 108000, N'Active'),
(10825, 4724, 842, 2, 128, 75000, N'Cancelled'),
(10826, 4724, 842, 2, 129, 75000, N'Cancelled'),
(10827, 4725, 841, 1, 6, 75000, N'Active'),
(10828, 4725, 841, 1, 7, 75000, N'Active'),
(10829, 4726, 809, 5, 553, 144000, N'Active'),
(10830, 4726, 809, 5, 554, 144000, N'Active'),
(10831, 4727, 809, 5, 462, 120000, N'Active'),
(10832, 4727, 809, 5, 463, 120000, N'Active'),
(10833, 4728, 821, 3, 282, 90000, N'Active'),
(10834, 4728, 821, 3, 283, 90000, N'Active'),
(10835, 4728, 821, 3, 284, 90000, N'Active'),
(10836, 4729, 808, 4, 378, 108000, N'Active'),
(10837, 4729, 808, 4, 379, 108000, N'Active'),
(10838, 4730, 883, 4, 366, 108000, N'Active'),
(10839, 4730, 883, 4, 367, 108000, N'Active'),
(10840, 4731, 810, 2, 150, 90000, N'Active'),
(10841, 4731, 810, 2, 151, 90000, N'Active'),
(10842, 4732, 815, 3, 303, 90000, N'Active'),
(10843, 4733, 816, 4, 429, 108000, N'Active'),
(10844, 4733, 816, 4, 430, 108000, N'Active'),
(10845, 4734, 806, 3, 260, 90000, N'Active'),
(10846, 4734, 806, 3, 261, 90000, N'Active'),
(10847, 4735, 848, 5, 486, 144000, N'Active'),
(10848, 4735, 848, 5, 487, 144000, N'Active'),
(10849, 4736, 839, 2, 112, 75000, N'Active'),
(10850, 4736, 839, 2, 113, 75000, N'Active'),
(10851, 4737, 812, 1, 5, 75000, N'Active'),
(10852, 4737, 812, 1, 6, 75000, N'Active'),
(10853, 4738, 813, 2, 162, 90000, N'Active'),
(10854, 4738, 813, 2, 163, 90000, N'Active'),
(10855, 4738, 813, 2, 164, 90000, N'Active'),
(10856, 4739, 830, 2, 173, 90000, N'Active'),
(10857, 4739, 830, 2, 174, 90000, N'Active'),
(10858, 4740, 808, 4, 400, 108000, N'Active'),
(10859, 4740, 808, 4, 401, 108000, N'Active'),
(10860, 4740, 808, 4, 402, 108000, N'Active'),
(10861, 4740, 808, 4, 403, 108000, N'Active'),
(10862, 4741, 811, 3, 258, 90000, N'Active'),
(10863, 4741, 811, 3, 259, 90000, N'Active'),
(10864, 4742, 833, 3, 282, 90000, N'Active'),
(10865, 4742, 833, 3, 283, 90000, N'Active'),
(10866, 4743, 811, 3, 281, 90000, N'Active'),
(10867, 4744, 812, 1, 90, 90000, N'Active'),
(10868, 4744, 812, 1, 91, 90000, N'Active'),
(10869, 4745, 822, 4, 402, 108000, N'Active'),
(10870, 4745, 822, 4, 403, 108000, N'Active'),
(10871, 4746, 809, 5, 546, 144000, N'Active'),
(10872, 4747, 808, 4, 431, 108000, N'Active'),
(10873, 4747, 808, 4, 432, 108000, N'Active'),
(10874, 4748, 841, 1, 90, 90000, N'Active'),
(10875, 4748, 841, 1, 91, 90000, N'Active'),
(10876, 4749, 850, 3, 284, 90000, N'Active'),
(10877, 4749, 850, 3, 285, 90000, N'Active'),
(10878, 4749, 850, 3, 286, 90000, N'Active'),
(10879, 4750, 808, 4, 376, 108000, N'Active'),
(10880, 4750, 808, 4, 377, 108000, N'Active'),
(10881, 4751, 879, 3, 235, 75000, N'Cancelled'),
(10882, 4751, 879, 3, 236, 75000, N'Cancelled'),
(10883, 4752, 831, 5, 546, 144000, N'Active'),
(10884, 4752, 831, 5, 547, 144000, N'Active'),
(10885, 4753, 827, 2, 186, 90000, N'Active'),
(10886, 4754, 812, 1, 10, 75000, N'Active'),
(10887, 4754, 812, 1, 11, 75000, N'Active'),
(10888, 4755, 814, 5, 496, 144000, N'Active'),
(10889, 4755, 814, 5, 497, 144000, N'Active'),
(10890, 4755, 814, 5, 498, 144000, N'Active'),
(10891, 4755, 814, 5, 499, 144000, N'Active'),
(10892, 4756, 848, 5, 438, 120000, N'Active'),
(10893, 4757, 811, 3, 295, 90000, N'Active'),
(10894, 4757, 811, 3, 296, 90000, N'Active'),
(10895, 4758, 814, 5, 510, 144000, N'Active'),
(10896, 4758, 814, 5, 511, 144000, N'Active'),
(10897, 4759, 815, 3, 294, 90000, N'Active'),
(10898, 4759, 815, 3, 295, 90000, N'Active'),
(10899, 4760, 817, 1, 44, 90000, N'Active'),
(10900, 4760, 817, 1, 45, 90000, N'Active'),
(10901, 4760, 817, 1, 46, 90000, N'Active'),
(10902, 4760, 817, 1, 47, 90000, N'Active'),
(10903, 4761, 871, 2, 162, 90000, N'Active'),
(10904, 4761, 871, 2, 163, 90000, N'Active'),
(10905, 4762, 818, 2, 116, 75000, N'Active'),
(10906, 4762, 818, 2, 117, 75000, N'Active'),
(10907, 4763, 848, 5, 498, 144000, N'Active'),
(10908, 4763, 848, 5, 499, 144000, N'Active'),
(10909, 4764, 815, 3, 246, 75000, N'Active'),
(10910, 4765, 838, 5, 522, 144000, N'Active'),
(10911, 4765, 838, 5, 523, 144000, N'Active'),
(10912, 4765, 838, 5, 524, 144000, N'Active'),
(10913, 4766, 857, 3, 283, 90000, N'Active'),
(10914, 4766, 857, 3, 284, 90000, N'Active'),
(10915, 4767, 854, 4, 376, 108000, N'Active'),
(10916, 4767, 854, 4, 377, 108000, N'Active'),
(10917, 4767, 854, 4, 378, 108000, N'Active'),
(10918, 4768, 823, 2, 160, 90000, N'Cancelled'),
(10919, 4768, 823, 2, 161, 90000, N'Cancelled'),
(10920, 4768, 823, 2, 162, 90000, N'Cancelled'),
(10921, 4768, 823, 2, 163, 90000, N'Cancelled'),
(10922, 4768, 823, 2, 164, 90000, N'Cancelled'),
(10923, 4768, 823, 2, 165, 90000, N'Cancelled'),
(10924, 4769, 869, 3, 294, 90000, N'Active'),
(10925, 4769, 869, 3, 295, 90000, N'Active'),
(10926, 4770, 815, 3, 305, 90000, N'Active'),
(10927, 4770, 815, 3, 306, 90000, N'Active'),
(10928, 4771, 818, 2, 185, 90000, N'Active'),
(10929, 4771, 818, 2, 186, 90000, N'Active'),
(10930, 4772, 879, 3, 289, 90000, N'Cancelled'),
(10931, 4772, 879, 3, 290, 90000, N'Cancelled'),
(10932, 4772, 879, 3, 291, 90000, N'Cancelled'),
(10933, 4773, 822, 4, 413, 108000, N'Active'),
(10934, 4773, 822, 4, 414, 108000, N'Active'),
(10935, 4773, 822, 4, 415, 108000, N'Active'),
(10936, 4773, 822, 4, 416, 108000, N'Active'),
(10937, 4774, 815, 3, 307, 90000, N'Active'),
(10938, 4774, 815, 3, 308, 90000, N'Active'),
(10939, 4775, 839, 2, 115, 75000, N'Active'),
(10940, 4775, 839, 2, 116, 75000, N'Active'),
(10941, 4776, 818, 2, 187, 90000, N'Active'),
(10942, 4776, 818, 2, 188, 90000, N'Active'),
(10943, 4776, 818, 2, 189, 90000, N'Active'),
(10944, 4777, 822, 4, 390, 108000, N'Active'),
(10945, 4777, 822, 4, 391, 108000, N'Active'),
(10946, 4778, 862, 3, 313, 90000, N'Cancelled'),
(10947, 4778, 862, 3, 314, 90000, N'Cancelled'),
(10948, 4778, 862, 3, 315, 90000, N'Cancelled'),
(10949, 4778, 862, 3, 316, 90000, N'Cancelled'),
(10950, 4779, 827, 2, 150, 90000, N'Active'),
(10951, 4779, 827, 2, 151, 90000, N'Active'),
(10952, 4780, 828, 3, 271, 90000, N'Active'),
(10953, 4780, 828, 3, 272, 90000, N'Active'),
(10954, 4781, 848, 5, 462, 120000, N'Active'),
(10955, 4782, 823, 2, 197, 90000, N'Active'),
(10956, 4782, 823, 2, 198, 90000, N'Active'),
(10957, 4783, 820, 1, 9, 75000, N'Cancelled'),
(10958, 4783, 820, 1, 10, 75000, N'Cancelled'),
(10959, 4784, 856, 2, 185, 90000, N'Active'),
(10960, 4784, 856, 2, 186, 90000, N'Active'),
(10961, 4785, 822, 4, 404, 108000, N'Active'),
(10962, 4785, 822, 4, 405, 108000, N'Active'),
(10963, 4786, 852, 2, 126, 75000, N'Active'),
(10964, 4786, 852, 2, 127, 75000, N'Active'),
(10965, 4787, 821, 3, 223, 75000, N'Active'),
(10966, 4787, 821, 3, 224, 75000, N'Active'),
(10967, 4787, 821, 3, 225, 75000, N'Active'),
(10968, 4788, 820, 1, 107, 90000, N'Active'),
(10969, 4788, 820, 1, 108, 90000, N'Active'),
(10970, 4789, 819, 5, 522, 144000, N'Active'),
(10971, 4790, 821, 3, 307, 90000, N'Active'),
(10972, 4790, 821, 3, 308, 90000, N'Active'),
(10973, 4791, 820, 1, 68, 90000, N'Active'),
(10974, 4791, 820, 1, 69, 90000, N'Active'),
(10975, 4791, 820, 1, 70, 90000, N'Active'),
(10976, 4792, 856, 2, 159, 90000, N'Active'),
(10977, 4792, 856, 2, 160, 90000, N'Active'),
(10978, 4793, 819, 5, 532, 144000, N'Active'),
(10979, 4794, 819, 5, 474, 120000, N'Cancelled'),
(10980, 4794, 819, 5, 475, 120000, N'Cancelled'),
(10981, 4795, 819, 5, 547, 144000, N'Active'),
(10982, 4796, 821, 3, 232, 75000, N'Active'),
(10983, 4796, 821, 3, 233, 75000, N'Active'),
(10984, 4796, 821, 3, 234, 75000, N'Active'),
(10985, 4796, 821, 3, 235, 75000, N'Active'),
(10986, 4797, 822, 4, 330, 90000, N'Active'),
(10987, 4797, 822, 4, 331, 90000, N'Active'),
(10988, 4798, 820, 1, 54, 90000, N'Active'),
(10989, 4798, 820, 1, 55, 90000, N'Active'),
(10990, 4799, 819, 5, 545, 144000, N'Active'),
(10991, 4799, 819, 5, 546, 144000, N'Active'),
(10992, 4800, 855, 5, 473, 120000, N'Cancelled'),
(10993, 4800, 855, 5, 474, 120000, N'Cancelled'),
(10994, 4800, 855, 5, 475, 120000, N'Cancelled'),
(10995, 4800, 855, 5, 476, 120000, N'Cancelled'),
(10996, 4801, 822, 4, 379, 108000, N'Active'),
(10997, 4802, 820, 1, 91, 90000, N'Active'),
(10998, 4803, 819, 5, 511, 144000, N'Active'),
(10999, 4803, 819, 5, 512, 144000, N'Active'),
(11000, 4804, 844, 3, 236, 75000, N'Active'),
(11001, 4804, 844, 3, 237, 75000, N'Active'),
(11002, 4805, 821, 3, 258, 90000, N'Active'),
(11003, 4805, 821, 3, 259, 90000, N'Active'),
(11004, 4806, 832, 4, 342, 90000, N'Active'),
(11005, 4806, 832, 4, 343, 90000, N'Active'),
(11006, 4807, 820, 1, 81, 90000, N'Cancelled'),
(11007, 4807, 820, 1, 82, 90000, N'Cancelled'),
(11008, 4808, 828, 3, 256, 90000, N'Active'),
(11009, 4808, 828, 3, 257, 90000, N'Active'),
(11010, 4808, 828, 3, 258, 90000, N'Active'),
(11011, 4808, 828, 3, 259, 90000, N'Active'),
(11012, 4809, 820, 1, 92, 90000, N'Active'),
(11013, 4809, 820, 1, 93, 90000, N'Active'),
(11014, 4810, 820, 1, 66, 90000, N'Active'),
(11015, 4810, 820, 1, 67, 90000, N'Active'),
(11016, 4811, 851, 4, 379, 108000, N'Active'),
(11017, 4811, 851, 4, 380, 108000, N'Active'),
(11018, 4812, 826, 5, 475, 120000, N'Active'),
(11019, 4813, 828, 3, 305, 90000, N'Active'),
(11020, 4814, 848, 5, 509, 144000, N'Active'),
(11021, 4814, 848, 5, 510, 144000, N'Active'),
(11022, 4815, 846, 1, 92, 90000, N'Active'),
(11023, 4815, 846, 1, 93, 90000, N'Active'),
(11024, 4816, 823, 2, 173, 90000, N'Active'),
(11025, 4816, 823, 2, 174, 90000, N'Active'),
(11026, 4817, 826, 5, 507, 144000, N'Active'),
(11027, 4817, 826, 5, 508, 144000, N'Active'),
(11028, 4818, 825, 4, 413, 108000, N'Active'),
(11029, 4818, 825, 4, 414, 108000, N'Active'),
(11030, 4819, 856, 2, 174, 90000, N'Active'),
(11031, 4820, 823, 2, 171, 90000, N'Cancelled'),
(11032, 4820, 823, 2, 172, 90000, N'Cancelled'),
(11033, 4821, 823, 2, 187, 90000, N'Active'),
(11034, 4821, 823, 2, 188, 90000, N'Active'),
(11035, 4822, 824, 1, 101, 90000, N'Active'),
(11036, 4822, 824, 1, 102, 90000, N'Active'),
(11037, 4822, 824, 1, 103, 90000, N'Active'),
(11038, 4822, 824, 1, 104, 90000, N'Active'),
(11039, 4823, 848, 5, 496, 144000, N'Cancelled'),
(11040, 4823, 848, 5, 497, 144000, N'Cancelled'),
(11041, 4824, 826, 5, 510, 144000, N'Cancelled'),
(11042, 4824, 826, 5, 511, 144000, N'Cancelled'),
(11043, 4825, 851, 4, 414, 108000, N'Active'),
(11044, 4825, 851, 4, 415, 108000, N'Active'),
(11045, 4826, 825, 4, 423, 108000, N'Active'),
(11046, 4826, 825, 4, 424, 108000, N'Active'),
(11047, 4827, 826, 5, 563, 144000, N'Active'),
(11048, 4827, 826, 5, 564, 144000, N'Active'),
(11049, 4828, 854, 4, 343, 90000, N'Active'),
(11050, 4829, 848, 5, 485, 144000, N'Active'),
(11051, 4830, 852, 2, 197, 90000, N'Active'),
(11052, 4830, 852, 2, 198, 90000, N'Active'),
(11053, 4830, 852, 2, 199, 90000, N'Active'),
(11054, 4830, 852, 2, 200, 90000, N'Active'),
(11055, 4830, 852, 2, 201, 90000, N'Active'),
(11056, 4831, 825, 4, 342, 90000, N'Active'),
(11057, 4831, 825, 4, 343, 90000, N'Active'),
(11058, 4831, 825, 4, 344, 90000, N'Active'),
(11059, 4832, 854, 4, 390, 108000, N'Active'),
(11060, 4832, 854, 4, 391, 108000, N'Active'),
(11061, 4833, 824, 1, 7, 75000, N'Active'),
(11062, 4834, 825, 4, 330, 90000, N'Active'),
(11063, 4835, 829, 1, 90, 90000, N'Active'),
(11064, 4835, 829, 1, 91, 90000, N'Active'),
(11065, 4836, 827, 2, 174, 90000, N'Active'),
(11066, 4837, 827, 2, 176, 90000, N'Active'),
(11067, 4837, 827, 2, 177, 90000, N'Active'),
(11068, 4838, 837, 4, 404, 108000, N'Active'),
(11069, 4839, 828, 3, 306, 90000, N'Active'),
(11070, 4839, 828, 3, 307, 90000, N'Active'),
(11071, 4840, 827, 2, 162, 90000, N'Active'),
(11072, 4840, 827, 2, 163, 90000, N'Active'),
(11073, 4841, 841, 1, 65, 90000, N'Active'),
(11074, 4841, 841, 1, 66, 90000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 4 09/12/2026: 134 hoa don (7 huy), 291 ve, doanh thu 28.264.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(4842, 3, 64, '2026-12-09T08:05:58', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 833 | Kiến Lé Phiêu Lưu Ké | 09/12 09:30 | Phòng 3 | E6
(4843, 3, NULL, '2026-12-09T08:13:40', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 830 | Hexed: Thế Giới Phép Thuật | 09/12 09:00 | Phòng 2 | J5 J6 J7 J8
(4844, 3, NULL, '2026-12-09T08:23:23', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 864 | Ngày Con Còn Mẹ | 10/12 11:15 | Phòng 3 | E7 E8
(4845, 10, 33, '2026-12-09T08:34:36', 120000, N'Paid', N'Cash', 200000, 6, 0, NULL, NULL, NULL), -- suat 831 | Dune: Hành Tinh Cát - Phần Hai | 09/12 09:00 | Phòng 5 | C7
(4846, 10, 22, '2026-12-09T08:40:58', 180000, N'Cancelled', N'Cash', 180000, 18, 0, N'Khách đổi ý', '2026-12-09T08:50:43', 10), -- suat 830 | Hexed: Thế Giới Phép Thuật | 09/12 09:00 | Phòng 2 | J1 J2
(4847, 3, 66, '2026-12-09T08:54:16', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 835 | Ngày Con Còn Mẹ | 09/12 11:15 | Phòng 3 | D5 D6 D7
(4848, 10, NULL, '2026-12-09T08:55:00', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 880 | Godzilla Trừ Không | 10/12 18:30 | Phòng 4 | E3 E4
(4849, 3, 69, '2026-12-09T09:00:05', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 832 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 09:15 | Phòng 4 | H5 H6
(4850, 3, 46, '2026-12-09T09:00:12', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 832 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 09:15 | Phòng 4 | F5 F6
(4851, 10, NULL, '2026-12-09T09:16:48', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 878 | Bắt Cá Ba Tay | 10/12 18:30 | Phòng 1 | B4 B5 B6
(4852, 3, NULL, '2026-12-09T09:21:21', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 833 | Kiến Lé Phiêu Lưu Ké | 09/12 09:30 | Phòng 3 | A5
(4853, 3, 4, '2026-12-09T09:26:25', 180000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 859 | Hexed: Thế Giới Phép Thuật | 10/12 09:00 | Phòng 2 | H6 H7
(4854, 10, 97, '2026-12-09T09:30:20', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 881 | Bò Sữa Bay | 10/12 19:30 | Phòng 2 | G8 G9
(4855, 3, 49, '2026-12-09T09:31:38', 240000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 838 | Godzilla Trừ Không | 09/12 12:15 | Phòng 5 | D6 D7
(4856, 10, NULL, '2026-12-09T09:35:01', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 884 | Godzilla Trừ Không | 10/12 21:15 | Phòng 5 | E6 E7
(4857, 3, 2, '2026-12-09T09:38:19', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 878 | Bắt Cá Ba Tay | 10/12 18:30 | Phòng 1 | F8
(4858, 10, NULL, '2026-12-09T09:43:30', 480000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 838 | Godzilla Trừ Không | 09/12 12:15 | Phòng 5 | A5 A6 A7 A8
(4859, 3, NULL, '2026-12-09T09:43:50', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 838 | Godzilla Trừ Không | 09/12 12:15 | Phòng 5 | F6 F7
(4860, 3, NULL, '2026-12-09T10:20:48', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 836 | Bắt Cá Ba Tay | 09/12 11:30 | Phòng 1 | H7 H8 H9
(4861, 3, 78, '2026-12-09T10:31:38', 216000, N'Paid', N'Transfer', NULL, 21, 0, NULL, NULL, NULL), -- suat 837 | Ramayana: Khởi Nguồn Một Huyền Thoại | 09/12 12:15 | Phòng 4 | J7 J8
(4862, 3, NULL, '2026-12-09T10:35:33', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 880 | Godzilla Trừ Không | 10/12 18:30 | Phòng 4 | E7
(4863, 10, NULL, '2026-12-09T10:36:25', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 881 | Bò Sữa Bay | 10/12 19:30 | Phòng 2 | J5 J6
(4864, 3, NULL, '2026-12-09T10:44:12', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 867 | Godzilla Trừ Không | 10/12 12:15 | Phòng 5 | F6
(4865, 10, NULL, '2026-12-09T10:44:53', 432000, N'Cancelled', N'Cash', 500000, 0, 0, N'Khách đổi ý', '2026-12-09T11:25:46', 10), -- suat 884 | Godzilla Trừ Không | 10/12 21:15 | Phòng 5 | E8 E9 E10
(4866, 10, NULL, '2026-12-09T10:47:43', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 848 | Dune: Hành Tinh Cát - Phần Hai | 09/12 18:00 | Phòng 5 | H6 H7 H8
(4867, 3, NULL, '2026-12-09T10:48:42', 180000, N'Cancelled', N'Cash', 200000, 0, 0, N'Nhầm suất / ghế', '2026-12-09T11:29:35', 3), -- suat 839 | Hexed: Thế Giới Phép Thuật | 09/12 12:45 | Phòng 2 | F4 F5
(4868, 10, NULL, '2026-12-09T10:54:03', 216000, N'Cancelled', N'Cash', 500000, 0, 0, N'Nhầm suất / ghế', '2026-12-09T11:46:28', 10), -- suat 837 | Ramayana: Khởi Nguồn Một Huyền Thoại | 09/12 12:15 | Phòng 4 | H5 H6
(4869, 10, 78, '2026-12-09T11:02:58', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 842 | Ngày Con Còn Mẹ | 09/12 15:00 | Phòng 2 | F7 F8
(4870, 3, NULL, '2026-12-09T11:09:46', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 849 | Bắt Cá Ba Tay | 09/12 18:30 | Phòng 1 | F6 F7
(4871, 10, NULL, '2026-12-09T11:19:11', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 837 | Ramayana: Khởi Nguồn Một Huyền Thoại | 09/12 12:15 | Phòng 4 | C7
(4872, 10, NULL, '2026-12-09T11:27:29', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 878 | Bắt Cá Ba Tay | 10/12 18:30 | Phòng 1 | E6 E7
(4873, 3, 74, '2026-12-09T11:34:08', 324000, N'Paid', N'Transfer', NULL, 22, 0, NULL, NULL, NULL), -- suat 837 | Ramayana: Khởi Nguồn Một Huyền Thoại | 09/12 12:15 | Phòng 4 | D6 D7 D8
(4874, 10, NULL, '2026-12-09T11:34:20', 324000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 866 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/12 12:15 | Phòng 4 | E2 E3 E4
(4875, 10, NULL, '2026-12-09T11:50:58', 324000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 880 | Godzilla Trừ Không | 10/12 18:30 | Phòng 4 | H3 H4 H5
(4876, 3, NULL, '2026-12-09T11:53:21', 216000, N'Paid', N'Cash', 220000, 0, 0, NULL, NULL, NULL), -- suat 837 | Ramayana: Khởi Nguồn Một Huyền Thoại | 09/12 12:15 | Phòng 4 | H8 H9
(4877, 10, 88, '2026-12-09T11:55:34', 450000, N'Paid', N'Cash', 450000, 22, 0, NULL, NULL, NULL), -- suat 851 | Godzilla Trừ Không | 09/12 18:30 | Phòng 4 | A3 A4 A5 A6 A7
(4878, 3, NULL, '2026-12-09T12:02:06', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 838 | Godzilla Trừ Không | 09/12 12:15 | Phòng 5 | G6 G7
(4879, 10, NULL, '2026-12-09T12:06:01', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 843 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 15:00 | Phòng 5 | H6 H7 H8
(4880, 3, NULL, '2026-12-09T12:09:53', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 874 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 15:30 | Phòng 4 | H6 H7
(4881, 10, NULL, '2026-12-09T12:11:33', 150000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 850 | Điểm Mù | 09/12 18:30 | Phòng 3 | A4 A5
(4882, 10, NULL, '2026-12-09T12:23:55', 120000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 872 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 15:00 | Phòng 5 | B8
(4883, 3, NULL, '2026-12-09T12:24:03', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 840 | Con Mắt Thứ Ba | 09/12 13:30 | Phòng 3 | D5 D6 D7
(4884, 10, NULL, '2026-12-09T12:30:20', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 850 | Điểm Mù | 09/12 18:30 | Phòng 3 | E7
(4885, 10, 79, '2026-12-09T12:37:08', 180000, N'Cancelled', N'Card', NULL, 12, 0, N'Sự cố phòng chiếu', '2026-12-09T14:01:50', 1), -- suat 852 | Bò Sữa Bay | 09/12 19:30 | Phòng 2 | E5 E6
(4886, 10, NULL, '2026-12-09T12:40:59', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 843 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 15:00 | Phòng 5 | J3
(4887, 3, 73, '2026-12-09T12:41:33', 270000, N'Paid', N'Cash', 300000, 18, 0, NULL, NULL, NULL), -- suat 852 | Bò Sữa Bay | 09/12 19:30 | Phòng 2 | F3 F4 F5
(4888, 10, NULL, '2026-12-09T12:49:54', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 842 | Ngày Con Còn Mẹ | 09/12 15:00 | Phòng 2 | G6 G7
(4889, 10, NULL, '2026-12-09T12:50:56', 75000, N'Paid', N'Cash', 75000, 0, 0, NULL, NULL, NULL), -- suat 841 | Trại Giam Hạnh Phúc | 09/12 13:45 | Phòng 1 | C6
(4890, 3, NULL, '2026-12-09T12:57:33', 216000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 866 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/12 12:15 | Phòng 4 | F6 F7
(4891, 10, 81, '2026-12-09T12:58:43', 432000, N'Paid', N'Cash', 500000, 30, 0, NULL, NULL, NULL), -- suat 877 | Dune: Hành Tinh Cát - Phần Hai | 10/12 18:00 | Phòng 5 | F2 F3 F4
(4892, 10, NULL, '2026-12-09T13:01:54', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 840 | Con Mắt Thứ Ba | 09/12 13:30 | Phòng 3 | F6 F7
(4893, 10, NULL, '2026-12-09T13:03:17', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 877 | Dune: Hành Tinh Cát - Phần Hai | 10/12 18:00 | Phòng 5 | J5 J6 J7 J8
(4894, 3, NULL, '2026-12-09T13:18:56', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 848 | Dune: Hành Tinh Cát - Phần Hai | 09/12 18:00 | Phòng 5 | K6 K7
(4895, 10, NULL, '2026-12-09T13:33:58', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 845 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 15:30 | Phòng 4 | C3 C4
(4896, 3, NULL, '2026-12-09T13:36:41', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 841 | Trại Giam Hạnh Phúc | 09/12 13:45 | Phòng 1 | E4 E5
(4897, 3, NULL, '2026-12-09T13:42:49', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 852 | Bò Sữa Bay | 09/12 19:30 | Phòng 2 | J7 J8
(4898, 3, NULL, '2026-12-09T13:47:03', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 844 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 09/12 15:30 | Phòng 3 | B5 B6
(4899, 3, 87, '2026-12-09T13:53:26', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 852 | Bò Sữa Bay | 09/12 19:30 | Phòng 2 | G6 G7
(4900, 10, NULL, '2026-12-09T13:54:07', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 869 | Con Mắt Thứ Ba | 10/12 13:30 | Phòng 3 | F5 F6
(4901, 3, NULL, '2026-12-09T13:55:54', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 854 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 21:00 | Phòng 4 | A5 A6
(4902, 3, 72, '2026-12-09T14:05:26', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 847 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 09/12 17:15 | Phòng 2 | F5 F6 F7 F8
(4903, 3, 25, '2026-12-09T14:09:12', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 855 | Godzilla Trừ Không | 09/12 21:15 | Phòng 5 | J2 J3
(4904, 10, 68, '2026-12-09T14:21:12', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 844 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 09/12 15:30 | Phòng 3 | D6 D7
(4905, 10, NULL, '2026-12-09T14:25:03', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 846 | Mẹ Mìn: Giao Kèo Với Quỷ | 09/12 16:15 | Phòng 1 | A7 A8
(4906, 3, NULL, '2026-12-09T14:31:33', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 867 | Godzilla Trừ Không | 10/12 12:15 | Phòng 5 | J6 J7
(4907, 3, 1, '2026-12-09T14:32:22', 180000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 857 | Con Mắt Thứ Ba | 09/12 21:45 | Phòng 3 | H6 H7
(4908, 3, NULL, '2026-12-09T14:36:27', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 842 | Ngày Con Còn Mẹ | 09/12 15:00 | Phòng 2 | F5 F6
(4909, 10, NULL, '2026-12-09T14:47:54', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 845 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 15:30 | Phòng 4 | C6 C7
(4910, 3, 69, '2026-12-09T14:50:38', 255000, N'Paid', N'Card', NULL, 17, 33, NULL, NULL, NULL), -- suat 843 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 15:00 | Phòng 5 | G6 G7
(4911, 3, NULL, '2026-12-09T14:56:17', 240000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 877 | Dune: Hành Tinh Cát - Phần Hai | 10/12 18:00 | Phòng 5 | D5 D6
(4912, 5, NULL, '2026-12-09T15:01:38', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 852 | Bò Sữa Bay | 09/12 19:30 | Phòng 2 | D6 D7 D8
(4913, 4, NULL, '2026-12-09T15:08:39', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 851 | Godzilla Trừ Không | 09/12 18:30 | Phòng 4 | D5 D6 D7
(4914, 4, NULL, '2026-12-09T15:08:43', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 844 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 09/12 15:30 | Phòng 3 | F4
(4915, 4, 18, '2026-12-09T15:18:55', 432000, N'Paid', N'Transfer', NULL, 30, 0, NULL, NULL, NULL), -- suat 845 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 15:30 | Phòng 4 | D5 D6 D7 D8
(4916, 4, NULL, '2026-12-09T15:30:40', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 850 | Điểm Mù | 09/12 18:30 | Phòng 3 | F5 F6 F7
(4917, 5, 89, '2026-12-09T15:50:01', 360000, N'Paid', N'Cash', 400000, 18, 0, NULL, NULL, NULL), -- suat 860 | Dune: Hành Tinh Cát - Phần Hai | 10/12 09:00 | Phòng 5 | A8 A9 A10
(4918, 4, NULL, '2026-12-09T15:53:07', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 847 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 09/12 17:15 | Phòng 2 | E6 E7 E8
(4919, 5, NULL, '2026-12-09T15:58:21', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 850 | Điểm Mù | 09/12 18:30 | Phòng 3 | H6
(4920, 4, 49, '2026-12-09T16:02:55', 450000, N'Paid', N'Transfer', NULL, 31, 0, NULL, NULL, NULL), -- suat 847 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 09/12 17:15 | Phòng 2 | D5 D6 D7 D8 D9
(4921, 5, NULL, '2026-12-09T16:05:07', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 851 | Godzilla Trừ Không | 09/12 18:30 | Phòng 4 | F5 F6 F7 F8
(4922, 4, NULL, '2026-12-09T16:06:13', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 857 | Con Mắt Thứ Ba | 09/12 21:45 | Phòng 3 | D8 D9
(4923, 5, NULL, '2026-12-09T16:16:32', 240000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 872 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 15:00 | Phòng 5 | B4 B5
(4924, 5, NULL, '2026-12-09T16:20:24', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 848 | Dune: Hành Tinh Cát - Phần Hai | 09/12 18:00 | Phòng 5 | E3 E4
(4925, 4, NULL, '2026-12-09T16:20:42', 108000, N'Paid', N'Cash', 110000, 0, 0, NULL, NULL, NULL), -- suat 880 | Godzilla Trừ Không | 10/12 18:30 | Phòng 4 | F5
(4926, 4, NULL, '2026-12-09T16:22:54', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 850 | Điểm Mù | 09/12 18:30 | Phòng 3 | E5 E6
(4927, 4, NULL, '2026-12-09T16:31:04', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 848 | Dune: Hành Tinh Cát - Phần Hai | 09/12 18:00 | Phòng 5 | E8 E9
(4928, 4, NULL, '2026-12-09T16:42:42', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 848 | Dune: Hành Tinh Cát - Phần Hai | 09/12 18:00 | Phòng 5 | L9 L10
(4929, 4, NULL, '2026-12-09T16:44:15', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 864 | Ngày Con Còn Mẹ | 10/12 11:15 | Phòng 3 | D5 D6 D7
(4930, 4, NULL, '2026-12-09T16:45:03', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 866 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/12 12:15 | Phòng 4 | G7 G8
(4931, 4, NULL, '2026-12-09T16:45:23', 75000, N'Paid', N'Cash', 75000, 0, 0, NULL, NULL, NULL), -- suat 859 | Hexed: Thế Giới Phép Thuật | 10/12 09:00 | Phòng 2 | C8
(4932, 4, 120, '2026-12-09T17:03:21', 202000, N'Paid', N'Cash', 202000, 10, 23, NULL, NULL, NULL), -- suat 849 | Bắt Cá Ba Tay | 09/12 18:30 | Phòng 1 | B4 B5 B6
(4933, 5, NULL, '2026-12-09T17:16:24', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 874 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 15:30 | Phòng 4 | G7 G8
(4934, 4, NULL, '2026-12-09T17:24:46', 240000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 855 | Godzilla Trừ Không | 09/12 21:15 | Phòng 5 | B6 B7
(4935, 4, 108, '2026-12-09T17:25:30', 90000, N'Cancelled', N'Transfer', NULL, 6, 0, N'Lỗi thanh toán', '2026-12-09T18:15:21', 4), -- suat 849 | Bắt Cá Ba Tay | 09/12 18:30 | Phòng 1 | D6
(4936, 5, NULL, '2026-12-09T17:26:32', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 851 | Godzilla Trừ Không | 09/12 18:30 | Phòng 4 | J9 J10
(4937, 5, 30, '2026-12-09T17:38:03', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 849 | Bắt Cá Ba Tay | 09/12 18:30 | Phòng 1 | E6 E7
(4938, 4, 78, '2026-12-09T17:38:55', 108000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 851 | Godzilla Trừ Không | 09/12 18:30 | Phòng 4 | F4
(4939, 4, 44, '2026-12-09T17:51:07', 216000, N'Paid', N'Transfer', NULL, 21, 0, NULL, NULL, NULL), -- suat 854 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 21:00 | Phòng 4 | J11 J12
(4940, 5, NULL, '2026-12-09T17:54:47', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 857 | Con Mắt Thứ Ba | 09/12 21:45 | Phòng 3 | E5
(4941, 4, NULL, '2026-12-09T18:08:08', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 865 | Bắt Cá Ba Tay | 10/12 11:30 | Phòng 1 | F6 F7
(4942, 5, NULL, '2026-12-09T18:19:11', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 849 | Bắt Cá Ba Tay | 09/12 18:30 | Phòng 1 | G7 G8 G9
(4943, 4, NULL, '2026-12-09T18:19:29', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 850 | Điểm Mù | 09/12 18:30 | Phòng 3 | B6 B7
(4944, 5, NULL, '2026-12-09T18:25:38', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 853 | Trại Giam Hạnh Phúc | 09/12 21:00 | Phòng 1 | A7 A8
(4945, 5, NULL, '2026-12-09T18:42:21', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 852 | Bò Sữa Bay | 09/12 19:30 | Phòng 2 | B9 B10
(4946, 5, NULL, '2026-12-09T18:44:02', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 853 | Trại Giam Hạnh Phúc | 09/12 21:00 | Phòng 1 | G8 G9 G10 G11
(4947, 5, 85, '2026-12-09T18:50:00', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 855 | Godzilla Trừ Không | 09/12 21:15 | Phòng 5 | J6 J7
(4948, 4, NULL, '2026-12-09T18:50:18', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 857 | Con Mắt Thứ Ba | 09/12 21:45 | Phòng 3 | J1 J2
(4949, 5, NULL, '2026-12-09T18:59:57', 108000, N'Paid', N'Cash', 108000, 0, 0, NULL, NULL, NULL), -- suat 854 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 21:00 | Phòng 4 | F5
(4950, 4, NULL, '2026-12-09T19:00:01', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 875 | Mẹ Mìn: Giao Kèo Với Quỷ | 10/12 16:15 | Phòng 1 | C5 C6
(4951, 4, 36, '2026-12-09T19:00:59', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 856 | Con Mắt Thứ Ba | 09/12 21:45 | Phòng 2 | H4 H5
(4952, 5, NULL, '2026-12-09T19:18:41', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 861 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 09:15 | Phòng 4 | H7
(4953, 5, NULL, '2026-12-09T19:22:57', 576000, N'Paid', N'Cash', 1000000, 0, 0, NULL, NULL, NULL), -- suat 877 | Dune: Hành Tinh Cát - Phần Hai | 10/12 18:00 | Phòng 5 | J1 J2 J3 J4
(4954, 5, 120, '2026-12-09T19:24:59', 108000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 854 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 21:00 | Phòng 4 | G6
(4955, 5, 91, '2026-12-09T19:26:13', 270000, N'Cancelled', N'Transfer', NULL, 18, 0, N'Nhầm suất / ghế', '2026-12-09T20:36:40', 5), -- suat 878 | Bắt Cá Ba Tay | 10/12 18:30 | Phòng 1 | G5 G6 G7
(4956, 4, NULL, '2026-12-09T19:47:22', 324000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 854 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 21:00 | Phòng 4 | G3 G4 G5
(4957, 4, NULL, '2026-12-09T19:53:05', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 853 | Trại Giam Hạnh Phúc | 09/12 21:00 | Phòng 1 | F6 F7 F8
(4958, 4, NULL, '2026-12-09T19:55:36', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 853 | Trại Giam Hạnh Phúc | 09/12 21:00 | Phòng 1 | J1 J2 J3 J4
(4959, 4, NULL, '2026-12-09T20:03:08', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 866 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/12 12:15 | Phòng 4 | C5
(4960, 4, NULL, '2026-12-09T20:04:42', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 877 | Dune: Hành Tinh Cát - Phần Hai | 10/12 18:00 | Phòng 5 | L9 L10
(4961, 4, 27, '2026-12-09T20:10:42', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 857 | Con Mắt Thứ Ba | 09/12 21:45 | Phòng 3 | E6 E7
(4962, 4, NULL, '2026-12-09T20:13:37', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 865 | Bắt Cá Ba Tay | 10/12 11:30 | Phòng 1 | F8 F9 F10
(4963, 4, NULL, '2026-12-09T20:15:13', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 854 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 09/12 21:00 | Phòng 4 | E7 E8
(4964, 5, NULL, '2026-12-09T20:21:14', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 853 | Trại Giam Hạnh Phúc | 09/12 21:00 | Phòng 1 | H6
(4965, 5, NULL, '2026-12-09T20:25:12', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 853 | Trại Giam Hạnh Phúc | 09/12 21:00 | Phòng 1 | G6 G7
(4966, 5, NULL, '2026-12-09T20:28:08', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 877 | Dune: Hành Tinh Cát - Phần Hai | 10/12 18:00 | Phòng 5 | F6
(4967, 4, NULL, '2026-12-09T20:33:49', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 853 | Trại Giam Hạnh Phúc | 09/12 21:00 | Phòng 1 | G3 G4
(4968, 5, NULL, '2026-12-09T20:45:33', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 856 | Con Mắt Thứ Ba | 09/12 21:45 | Phòng 2 | H6
(4969, 4, NULL, '2026-12-09T21:02:02', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 870 | Trại Giam Hạnh Phúc | 10/12 13:45 | Phòng 1 | H7 H8
(4970, 5, NULL, '2026-12-09T21:02:14', 75000, N'Paid', N'Cash', 75000, 0, 0, NULL, NULL, NULL), -- suat 886 | Con Mắt Thứ Ba | 10/12 21:45 | Phòng 3 | B6
(4971, 4, NULL, '2026-12-09T21:09:37', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 857 | Con Mắt Thứ Ba | 09/12 21:45 | Phòng 3 | D6 D7
(4972, 5, NULL, '2026-12-09T21:26:08', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 856 | Con Mắt Thứ Ba | 09/12 21:45 | Phòng 2 | E5 E6 E7 E8
(4973, 4, 22, '2026-12-09T21:26:46', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 856 | Con Mắt Thứ Ba | 09/12 21:45 | Phòng 2 | D5
(4974, 4, NULL, '2026-12-09T21:31:35', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 879 | Điểm Mù | 10/12 18:30 | Phòng 3 | E6 E7
(4975, 4, NULL, '2026-12-09T21:38:03', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL); -- suat 882 | Trại Giam Hạnh Phúc | 10/12 21:00 | Phòng 1 | H7 H8
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(11075, 4842, 833, 3, 270, 90000, N'Active'),
(11076, 4843, 830, 2, 209, 90000, N'Active'),
(11077, 4843, 830, 2, 210, 90000, N'Active'),
(11078, 4843, 830, 2, 211, 90000, N'Active'),
(11079, 4843, 830, 2, 212, 90000, N'Active'),
(11080, 4844, 864, 3, 271, 90000, N'Active'),
(11081, 4844, 864, 3, 272, 90000, N'Active'),
(11082, 4845, 831, 5, 463, 120000, N'Active'),
(11083, 4846, 830, 2, 205, 90000, N'Cancelled'),
(11084, 4846, 830, 2, 206, 90000, N'Cancelled'),
(11085, 4847, 835, 3, 257, 90000, N'Active'),
(11086, 4847, 835, 3, 258, 90000, N'Active'),
(11087, 4847, 835, 3, 259, 90000, N'Active'),
(11088, 4848, 880, 4, 375, 108000, N'Active'),
(11089, 4848, 880, 4, 376, 108000, N'Active'),
(11090, 4849, 832, 4, 413, 108000, N'Active'),
(11091, 4849, 832, 4, 414, 108000, N'Active'),
(11092, 4850, 832, 4, 389, 108000, N'Active'),
(11093, 4850, 832, 4, 390, 108000, N'Active'),
(11094, 4851, 878, 1, 16, 75000, N'Active'),
(11095, 4851, 878, 1, 17, 75000, N'Active'),
(11096, 4851, 878, 1, 18, 75000, N'Active'),
(11097, 4852, 833, 3, 221, 75000, N'Active'),
(11098, 4853, 859, 2, 198, 90000, N'Active'),
(11099, 4853, 859, 2, 199, 90000, N'Active'),
(11100, 4854, 881, 2, 188, 90000, N'Active'),
(11101, 4854, 881, 2, 189, 90000, N'Active'),
(11102, 4855, 838, 5, 474, 120000, N'Active'),
(11103, 4855, 838, 5, 475, 120000, N'Active'),
(11104, 4856, 884, 5, 486, 144000, N'Active'),
(11105, 4856, 884, 5, 487, 144000, N'Active'),
(11106, 4857, 878, 1, 68, 90000, N'Active'),
(11107, 4858, 838, 5, 437, 120000, N'Active'),
(11108, 4858, 838, 5, 438, 120000, N'Active'),
(11109, 4858, 838, 5, 439, 120000, N'Active'),
(11110, 4858, 838, 5, 440, 120000, N'Active'),
(11111, 4859, 838, 5, 498, 144000, N'Active'),
(11112, 4859, 838, 5, 499, 144000, N'Active'),
(11113, 4860, 836, 1, 91, 90000, N'Active'),
(11114, 4860, 836, 1, 92, 90000, N'Active'),
(11115, 4860, 836, 1, 93, 90000, N'Active'),
(11116, 4861, 837, 4, 427, 108000, N'Active'),
(11117, 4861, 837, 4, 428, 108000, N'Active'),
(11118, 4862, 880, 4, 379, 108000, N'Active'),
(11119, 4863, 881, 2, 209, 90000, N'Active'),
(11120, 4863, 881, 2, 210, 90000, N'Active'),
(11121, 4864, 867, 5, 498, 144000, N'Active'),
(11122, 4865, 884, 5, 488, 144000, N'Cancelled'),
(11123, 4865, 884, 5, 489, 144000, N'Cancelled'),
(11124, 4865, 884, 5, 490, 144000, N'Cancelled'),
(11125, 4866, 848, 5, 522, 144000, N'Active'),
(11126, 4866, 848, 5, 523, 144000, N'Active'),
(11127, 4866, 848, 5, 524, 144000, N'Active'),
(11128, 4867, 839, 2, 172, 90000, N'Cancelled'),
(11129, 4867, 839, 2, 173, 90000, N'Cancelled'),
(11130, 4868, 837, 4, 413, 108000, N'Cancelled'),
(11131, 4868, 837, 4, 414, 108000, N'Cancelled'),
(11132, 4869, 842, 2, 175, 90000, N'Active'),
(11133, 4869, 842, 2, 176, 90000, N'Active'),
(11134, 4870, 849, 1, 66, 90000, N'Active'),
(11135, 4870, 849, 1, 67, 90000, N'Active'),
(11136, 4871, 837, 4, 355, 90000, N'Active'),
(11137, 4872, 878, 1, 54, 90000, N'Active'),
(11138, 4872, 878, 1, 55, 90000, N'Active'),
(11139, 4873, 837, 4, 366, 108000, N'Active'),
(11140, 4873, 837, 4, 367, 108000, N'Active'),
(11141, 4873, 837, 4, 368, 108000, N'Active'),
(11142, 4874, 866, 4, 374, 108000, N'Active'),
(11143, 4874, 866, 4, 375, 108000, N'Active'),
(11144, 4874, 866, 4, 376, 108000, N'Active'),
(11145, 4875, 880, 4, 411, 108000, N'Active'),
(11146, 4875, 880, 4, 412, 108000, N'Active'),
(11147, 4875, 880, 4, 413, 108000, N'Active'),
(11148, 4876, 837, 4, 416, 108000, N'Active'),
(11149, 4876, 837, 4, 417, 108000, N'Active'),
(11150, 4877, 851, 4, 327, 90000, N'Active'),
(11151, 4877, 851, 4, 328, 90000, N'Active'),
(11152, 4877, 851, 4, 329, 90000, N'Active'),
(11153, 4877, 851, 4, 330, 90000, N'Active'),
(11154, 4877, 851, 4, 331, 90000, N'Active'),
(11155, 4878, 838, 5, 510, 144000, N'Active'),
(11156, 4878, 838, 5, 511, 144000, N'Active'),
(11157, 4879, 843, 5, 522, 144000, N'Active'),
(11158, 4879, 843, 5, 523, 144000, N'Active'),
(11159, 4879, 843, 5, 524, 144000, N'Active'),
(11160, 4880, 874, 4, 414, 108000, N'Active'),
(11161, 4880, 874, 4, 415, 108000, N'Active'),
(11162, 4881, 850, 3, 220, 75000, N'Active'),
(11163, 4881, 850, 3, 221, 75000, N'Active'),
(11164, 4882, 872, 5, 452, 120000, N'Active'),
(11165, 4883, 840, 3, 257, 90000, N'Active'),
(11166, 4883, 840, 3, 258, 90000, N'Active'),
(11167, 4883, 840, 3, 259, 90000, N'Active'),
(11168, 4884, 850, 3, 271, 90000, N'Active'),
(11169, 4885, 852, 2, 161, 90000, N'Cancelled'),
(11170, 4885, 852, 2, 162, 90000, N'Cancelled'),
(11171, 4886, 843, 5, 531, 144000, N'Active'),
(11172, 4887, 852, 2, 171, 90000, N'Active'),
(11173, 4887, 852, 2, 172, 90000, N'Active'),
(11174, 4887, 852, 2, 173, 90000, N'Active'),
(11175, 4888, 842, 2, 186, 90000, N'Active'),
(11176, 4888, 842, 2, 187, 90000, N'Active'),
(11177, 4889, 841, 1, 30, 75000, N'Active'),
(11178, 4890, 866, 4, 390, 108000, N'Active'),
(11179, 4890, 866, 4, 391, 108000, N'Active'),
(11180, 4891, 877, 5, 494, 144000, N'Active'),
(11181, 4891, 877, 5, 495, 144000, N'Active'),
(11182, 4891, 877, 5, 496, 144000, N'Active'),
(11183, 4892, 840, 3, 282, 90000, N'Active'),
(11184, 4892, 840, 3, 283, 90000, N'Active'),
(11185, 4893, 877, 5, 533, 144000, N'Active'),
(11186, 4893, 877, 5, 534, 144000, N'Active'),
(11187, 4893, 877, 5, 535, 144000, N'Active'),
(11188, 4893, 877, 5, 536, 144000, N'Active'),
(11189, 4894, 848, 5, 546, 144000, N'Active'),
(11190, 4894, 848, 5, 547, 144000, N'Active'),
(11191, 4895, 845, 4, 351, 90000, N'Active'),
(11192, 4895, 845, 4, 352, 90000, N'Active'),
(11193, 4896, 841, 1, 52, 90000, N'Active'),
(11194, 4896, 841, 1, 53, 90000, N'Active'),
(11195, 4897, 852, 2, 211, 90000, N'Active'),
(11196, 4897, 852, 2, 212, 90000, N'Active'),
(11197, 4898, 844, 3, 233, 75000, N'Active'),
(11198, 4898, 844, 3, 234, 75000, N'Active'),
(11199, 4899, 852, 2, 186, 90000, N'Active'),
(11200, 4899, 852, 2, 187, 90000, N'Active'),
(11201, 4900, 869, 3, 281, 90000, N'Active'),
(11202, 4900, 869, 3, 282, 90000, N'Active'),
(11203, 4901, 854, 4, 329, 90000, N'Active'),
(11204, 4901, 854, 4, 330, 90000, N'Active'),
(11205, 4902, 847, 2, 173, 90000, N'Active'),
(11206, 4902, 847, 2, 174, 90000, N'Active'),
(11207, 4902, 847, 2, 175, 90000, N'Active'),
(11208, 4902, 847, 2, 176, 90000, N'Active'),
(11209, 4903, 855, 5, 530, 144000, N'Active'),
(11210, 4903, 855, 5, 531, 144000, N'Active'),
(11211, 4904, 844, 3, 258, 90000, N'Active'),
(11212, 4904, 844, 3, 259, 90000, N'Active'),
(11213, 4905, 846, 1, 7, 75000, N'Active'),
(11214, 4905, 846, 1, 8, 75000, N'Active'),
(11215, 4906, 867, 5, 534, 144000, N'Active'),
(11216, 4906, 867, 5, 535, 144000, N'Active'),
(11217, 4907, 857, 3, 306, 90000, N'Active'),
(11218, 4907, 857, 3, 307, 90000, N'Active'),
(11219, 4908, 842, 2, 173, 90000, N'Active'),
(11220, 4908, 842, 2, 174, 90000, N'Active'),
(11221, 4909, 845, 4, 354, 90000, N'Active'),
(11222, 4909, 845, 4, 355, 90000, N'Active'),
(11223, 4910, 843, 5, 510, 144000, N'Active'),
(11224, 4910, 843, 5, 511, 144000, N'Active'),
(11225, 4911, 877, 5, 473, 120000, N'Active'),
(11226, 4911, 877, 5, 474, 120000, N'Active'),
(11227, 4912, 852, 2, 150, 90000, N'Active'),
(11228, 4912, 852, 2, 151, 90000, N'Active'),
(11229, 4912, 852, 2, 152, 90000, N'Active'),
(11230, 4913, 851, 4, 365, 108000, N'Active'),
(11231, 4913, 851, 4, 366, 108000, N'Active'),
(11232, 4913, 851, 4, 367, 108000, N'Active'),
(11233, 4914, 844, 3, 280, 90000, N'Active'),
(11234, 4915, 845, 4, 365, 108000, N'Active'),
(11235, 4915, 845, 4, 366, 108000, N'Active'),
(11236, 4915, 845, 4, 367, 108000, N'Active'),
(11237, 4915, 845, 4, 368, 108000, N'Active'),
(11238, 4916, 850, 3, 281, 90000, N'Active'),
(11239, 4916, 850, 3, 282, 90000, N'Active'),
(11240, 4916, 850, 3, 283, 90000, N'Active'),
(11241, 4917, 860, 5, 440, 120000, N'Active'),
(11242, 4917, 860, 5, 441, 120000, N'Active'),
(11243, 4917, 860, 5, 442, 120000, N'Active'),
(11244, 4918, 847, 2, 162, 90000, N'Active'),
(11245, 4918, 847, 2, 163, 90000, N'Active'),
(11246, 4918, 847, 2, 164, 90000, N'Active'),
(11247, 4919, 850, 3, 306, 90000, N'Active'),
(11248, 4920, 847, 2, 149, 90000, N'Active'),
(11249, 4920, 847, 2, 150, 90000, N'Active'),
(11250, 4920, 847, 2, 151, 90000, N'Active'),
(11251, 4920, 847, 2, 152, 90000, N'Active'),
(11252, 4920, 847, 2, 153, 90000, N'Active'),
(11253, 4921, 851, 4, 389, 108000, N'Active'),
(11254, 4921, 851, 4, 390, 108000, N'Active'),
(11255, 4921, 851, 4, 391, 108000, N'Active'),
(11256, 4921, 851, 4, 392, 108000, N'Active'),
(11257, 4922, 857, 3, 260, 90000, N'Active'),
(11258, 4922, 857, 3, 261, 90000, N'Active'),
(11259, 4923, 872, 5, 448, 120000, N'Active'),
(11260, 4923, 872, 5, 449, 120000, N'Active'),
(11261, 4924, 848, 5, 483, 144000, N'Active'),
(11262, 4924, 848, 5, 484, 144000, N'Active'),
(11263, 4925, 880, 4, 389, 108000, N'Active'),
(11264, 4926, 850, 3, 269, 90000, N'Active'),
(11265, 4926, 850, 3, 270, 90000, N'Active'),
(11266, 4927, 848, 5, 488, 144000, N'Active'),
(11267, 4927, 848, 5, 489, 144000, N'Active'),
(11268, 4928, 848, 5, 561, 144000, N'Active'),
(11269, 4928, 848, 5, 562, 144000, N'Active'),
(11270, 4929, 864, 3, 257, 90000, N'Active'),
(11271, 4929, 864, 3, 258, 90000, N'Active'),
(11272, 4929, 864, 3, 259, 90000, N'Active'),
(11273, 4930, 866, 4, 403, 108000, N'Active'),
(11274, 4930, 866, 4, 404, 108000, N'Active'),
(11275, 4931, 859, 2, 140, 75000, N'Active'),
(11276, 4932, 849, 1, 16, 75000, N'Active'),
(11277, 4932, 849, 1, 17, 75000, N'Active'),
(11278, 4932, 849, 1, 18, 75000, N'Active'),
(11279, 4933, 874, 4, 403, 108000, N'Active'),
(11280, 4933, 874, 4, 404, 108000, N'Active'),
(11281, 4934, 855, 5, 450, 120000, N'Active'),
(11282, 4934, 855, 5, 451, 120000, N'Active'),
(11283, 4935, 849, 1, 42, 90000, N'Cancelled'),
(11284, 4936, 851, 4, 429, 108000, N'Active'),
(11285, 4936, 851, 4, 430, 108000, N'Active'),
(11286, 4937, 849, 1, 54, 90000, N'Active'),
(11287, 4937, 849, 1, 55, 90000, N'Active'),
(11288, 4938, 851, 4, 388, 108000, N'Active'),
(11289, 4939, 854, 4, 431, 108000, N'Active'),
(11290, 4939, 854, 4, 432, 108000, N'Active'),
(11291, 4940, 857, 3, 269, 90000, N'Active'),
(11292, 4941, 865, 1, 66, 90000, N'Active'),
(11293, 4941, 865, 1, 67, 90000, N'Active'),
(11294, 4942, 849, 1, 79, 90000, N'Active'),
(11295, 4942, 849, 1, 80, 90000, N'Active'),
(11296, 4942, 849, 1, 81, 90000, N'Active'),
(11297, 4943, 850, 3, 234, 75000, N'Active'),
(11298, 4943, 850, 3, 235, 75000, N'Active'),
(11299, 4944, 853, 1, 7, 75000, N'Active'),
(11300, 4944, 853, 1, 8, 75000, N'Active'),
(11301, 4945, 852, 2, 129, 75000, N'Active'),
(11302, 4945, 852, 2, 130, 75000, N'Active'),
(11303, 4946, 853, 1, 80, 90000, N'Active'),
(11304, 4946, 853, 1, 81, 90000, N'Active'),
(11305, 4946, 853, 1, 82, 90000, N'Active'),
(11306, 4946, 853, 1, 83, 90000, N'Active'),
(11307, 4947, 855, 5, 534, 144000, N'Active'),
(11308, 4947, 855, 5, 535, 144000, N'Active'),
(11309, 4948, 857, 3, 313, 90000, N'Active'),
(11310, 4948, 857, 3, 314, 90000, N'Active'),
(11311, 4949, 854, 4, 389, 108000, N'Active'),
(11312, 4950, 875, 1, 29, 75000, N'Active'),
(11313, 4950, 875, 1, 30, 75000, N'Active'),
(11314, 4951, 856, 2, 196, 90000, N'Active'),
(11315, 4951, 856, 2, 197, 90000, N'Active'),
(11316, 4952, 861, 4, 415, 108000, N'Active'),
(11317, 4953, 877, 5, 529, 144000, N'Active'),
(11318, 4953, 877, 5, 530, 144000, N'Active'),
(11319, 4953, 877, 5, 531, 144000, N'Active'),
(11320, 4953, 877, 5, 532, 144000, N'Active'),
(11321, 4954, 854, 4, 402, 108000, N'Active'),
(11322, 4955, 878, 1, 77, 90000, N'Cancelled'),
(11323, 4955, 878, 1, 78, 90000, N'Cancelled'),
(11324, 4955, 878, 1, 79, 90000, N'Cancelled'),
(11325, 4956, 854, 4, 399, 108000, N'Active'),
(11326, 4956, 854, 4, 400, 108000, N'Active'),
(11327, 4956, 854, 4, 401, 108000, N'Active'),
(11328, 4957, 853, 1, 66, 90000, N'Active'),
(11329, 4957, 853, 1, 67, 90000, N'Active'),
(11330, 4957, 853, 1, 68, 90000, N'Active'),
(11331, 4958, 853, 1, 97, 90000, N'Active'),
(11332, 4958, 853, 1, 98, 90000, N'Active'),
(11333, 4958, 853, 1, 99, 90000, N'Active'),
(11334, 4958, 853, 1, 100, 90000, N'Active'),
(11335, 4959, 866, 4, 353, 90000, N'Active'),
(11336, 4960, 877, 5, 561, 144000, N'Active'),
(11337, 4960, 877, 5, 562, 144000, N'Active'),
(11338, 4961, 857, 3, 270, 90000, N'Active'),
(11339, 4961, 857, 3, 271, 90000, N'Active'),
(11340, 4962, 865, 1, 68, 90000, N'Active'),
(11341, 4962, 865, 1, 69, 90000, N'Active'),
(11342, 4962, 865, 1, 70, 90000, N'Active'),
(11343, 4963, 854, 4, 379, 108000, N'Active'),
(11344, 4963, 854, 4, 380, 108000, N'Active'),
(11345, 4964, 853, 1, 90, 90000, N'Active'),
(11346, 4965, 853, 1, 78, 90000, N'Active'),
(11347, 4965, 853, 1, 79, 90000, N'Active'),
(11348, 4966, 877, 5, 498, 144000, N'Active'),
(11349, 4967, 853, 1, 75, 90000, N'Active'),
(11350, 4967, 853, 1, 76, 90000, N'Active'),
(11351, 4968, 856, 2, 198, 90000, N'Active'),
(11352, 4969, 870, 1, 91, 90000, N'Active'),
(11353, 4969, 870, 1, 92, 90000, N'Active'),
(11354, 4970, 886, 3, 234, 75000, N'Active'),
(11355, 4971, 857, 3, 258, 90000, N'Active'),
(11356, 4971, 857, 3, 259, 90000, N'Active'),
(11357, 4972, 856, 2, 161, 90000, N'Active'),
(11358, 4972, 856, 2, 162, 90000, N'Active'),
(11359, 4972, 856, 2, 163, 90000, N'Active'),
(11360, 4972, 856, 2, 164, 90000, N'Active'),
(11361, 4973, 856, 2, 149, 90000, N'Active'),
(11362, 4974, 879, 3, 270, 90000, N'Active'),
(11363, 4974, 879, 3, 271, 90000, N'Active'),
(11364, 4975, 882, 1, 91, 90000, N'Active'),
(11365, 4975, 882, 1, 92, 90000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 5 10/12/2026: 111 hoa don (1 huy), 243 ve, doanh thu 23.922.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(4976, 5, NULL, '2026-12-10T08:14:49', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 868 | Hexed: Thế Giới Phép Thuật | 10/12 12:45 | Phòng 2 | H4 H5 H6 H7
(4977, 6, 63, '2026-12-10T08:15:04', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 859 | Hexed: Thế Giới Phép Thuật | 10/12 09:00 | Phòng 2 | H3 H4
(4978, 6, NULL, '2026-12-10T08:20:54', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 858 | Trại Giam Hạnh Phúc | 10/12 09:00 | Phòng 1 | C8 C9
(4979, 5, NULL, '2026-12-10T08:29:21', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 859 | Hexed: Thế Giới Phép Thuật | 10/12 09:00 | Phòng 2 | G6 G7
(4980, 6, NULL, '2026-12-10T08:35:04', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 879 | Điểm Mù | 10/12 18:30 | Phòng 3 | F6 F7
(4981, 5, 34, '2026-12-10T08:35:17', 432000, N'Paid', N'Cash', 432000, 30, 0, NULL, NULL, NULL), -- suat 866 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/12 12:15 | Phòng 4 | E5 E6 E7 E8
(4982, 6, NULL, '2026-12-10T08:37:54', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 876 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 10/12 17:15 | Phòng 2 | D1 D2 D3 D4
(4983, 6, NULL, '2026-12-10T08:38:00', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 858 | Trại Giam Hạnh Phúc | 10/12 09:00 | Phòng 1 | H6 H7 H8
(4984, 5, NULL, '2026-12-10T08:38:46', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 860 | Dune: Hành Tinh Cát - Phần Hai | 10/12 09:00 | Phòng 5 | G6 G7
(4985, 6, 119, '2026-12-10T08:49:22', 412000, N'Paid', N'Card', NULL, 28, 20, NULL, NULL, NULL), -- suat 861 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 09:15 | Phòng 4 | F6 F7 F8 F9
(4986, 6, NULL, '2026-12-10T09:06:26', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 868 | Hexed: Thế Giới Phép Thuật | 10/12 12:45 | Phòng 2 | C6 C7 C8
(4987, 6, NULL, '2026-12-10T09:11:03', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 870 | Trại Giam Hạnh Phúc | 10/12 13:45 | Phòng 1 | G6 G7 G8
(4988, 6, 1, '2026-12-10T09:15:52', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 862 | Kiến Lé Phiêu Lưu Ké | 10/12 09:30 | Phòng 3 | D6 D7
(4989, 6, NULL, '2026-12-10T10:07:05', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 866 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/12 12:15 | Phòng 4 | H8
(4990, 5, 21, '2026-12-10T10:07:25', 432000, N'Paid', N'Cash', 432000, 30, 0, NULL, NULL, NULL), -- suat 867 | Godzilla Trừ Không | 10/12 12:15 | Phòng 5 | E7 E8 E9
(4991, 5, NULL, '2026-12-10T10:08:05', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 869 | Con Mắt Thứ Ba | 10/12 13:30 | Phòng 3 | B7 B8
(4992, 6, 28, '2026-12-10T10:09:31', 576000, N'Paid', N'Card', NULL, 40, 0, NULL, NULL, NULL), -- suat 867 | Godzilla Trừ Không | 10/12 12:15 | Phòng 5 | F2 F3 F4 F5
(4993, 6, 117, '2026-12-10T10:29:39', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 870 | Trại Giam Hạnh Phúc | 10/12 13:45 | Phòng 1 | E6 E7
(4994, 6, 35, '2026-12-10T10:39:08', 87000, N'Paid', N'Cash', 87000, 6, 21, NULL, NULL, NULL), -- suat 883 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 21:00 | Phòng 4 | D8
(4995, 5, NULL, '2026-12-10T10:41:38', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 867 | Godzilla Trừ Không | 10/12 12:15 | Phòng 5 | F7 F8
(4996, 6, NULL, '2026-12-10T10:51:44', 108000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 874 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 15:30 | Phòng 4 | G5
(4997, 6, 47, '2026-12-10T10:53:13', 360000, N'Paid', N'Cash', 360000, 25, 0, NULL, NULL, NULL), -- suat 863 | Ma Mút Con Vượt Kỷ Băng Hà | 10/12 11:15 | Phòng 2 | D6 D7 D8 D9
(4998, 5, NULL, '2026-12-10T10:56:29', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 878 | Bắt Cá Ba Tay | 10/12 18:30 | Phòng 1 | D3 D4 D5
(4999, 6, NULL, '2026-12-10T11:12:49', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 867 | Godzilla Trừ Không | 10/12 12:15 | Phòng 5 | E6
(5000, 5, NULL, '2026-12-10T11:26:59', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 879 | Điểm Mù | 10/12 18:30 | Phòng 3 | D6 D7
(5001, 5, NULL, '2026-12-10T11:40:49', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 880 | Godzilla Trừ Không | 10/12 18:30 | Phòng 4 | H6 H7
(5002, 6, NULL, '2026-12-10T11:56:41', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 874 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 15:30 | Phòng 4 | G10 G11
(5003, 5, NULL, '2026-12-10T12:03:10', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 866 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/12 12:15 | Phòng 4 | D6 D7
(5004, 5, NULL, '2026-12-10T12:29:49', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 874 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 15:30 | Phòng 4 | C6 C7 C8 C9
(5005, 6, NULL, '2026-12-10T12:53:47', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 872 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 15:00 | Phòng 5 | F6 F7
(5006, 6, NULL, '2026-12-10T13:07:46', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 877 | Dune: Hành Tinh Cát - Phần Hai | 10/12 18:00 | Phòng 5 | H6 H7
(5007, 5, NULL, '2026-12-10T13:08:54', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 880 | Godzilla Trừ Không | 10/12 18:30 | Phòng 4 | E1 E2
(5008, 6, 107, '2026-12-10T13:09:00', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 876 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 10/12 17:15 | Phòng 2 | B7 B8
(5009, 5, 94, '2026-12-10T13:10:50', 216000, N'Cancelled', N'Transfer', NULL, 15, 0, N'Sự cố phòng chiếu', '2026-12-10T14:27:51', 1), -- suat 874 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 15:30 | Phòng 4 | G3 G4
(5010, 6, 48, '2026-12-10T13:23:40', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 875 | Mẹ Mìn: Giao Kèo Với Quỷ | 10/12 16:15 | Phòng 1 | D6 D7
(5011, 6, 31, '2026-12-10T13:33:09', 240000, N'Paid', N'Cash', 240000, 12, 0, NULL, NULL, NULL), -- suat 872 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 15:00 | Phòng 5 | B6 B7
(5012, 6, 1, '2026-12-10T13:36:21', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 881 | Bò Sữa Bay | 10/12 19:30 | Phòng 2 | G4 G5
(5013, 5, NULL, '2026-12-10T13:39:09', 75000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 871 | Ngày Con Còn Mẹ | 10/12 15:00 | Phòng 2 | A6
(5014, 6, NULL, '2026-12-10T13:45:42', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 871 | Ngày Con Còn Mẹ | 10/12 15:00 | Phòng 2 | G6 G7
(5015, 5, NULL, '2026-12-10T13:49:19', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 873 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 10/12 15:30 | Phòng 3 | F5 F6 F7
(5016, 5, 72, '2026-12-10T13:55:14', 288000, N'Paid', N'Cash', 300000, 20, 0, NULL, NULL, NULL), -- suat 872 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 15:00 | Phòng 5 | E6 E7
(5017, 5, NULL, '2026-12-10T14:04:24', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 881 | Bò Sữa Bay | 10/12 19:30 | Phòng 2 | E5 E6
(5018, 5, NULL, '2026-12-10T14:11:34', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 875 | Mẹ Mìn: Giao Kèo Với Quỷ | 10/12 16:15 | Phòng 1 | J9 J10
(5019, 6, NULL, '2026-12-10T14:13:40', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 876 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 10/12 17:15 | Phòng 2 | F4 F5
(5020, 5, NULL, '2026-12-10T14:19:04', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 875 | Mẹ Mìn: Giao Kèo Với Quỷ | 10/12 16:15 | Phòng 1 | J3 J4
(5021, 5, NULL, '2026-12-10T14:26:16', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 879 | Điểm Mù | 10/12 18:30 | Phòng 3 | G6 G7 G8
(5022, 5, NULL, '2026-12-10T14:28:54', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 872 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 15:00 | Phòng 5 | H7 H8
(5023, 5, NULL, '2026-12-10T14:31:21', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 872 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 15:00 | Phòng 5 | F8 F9
(5024, 6, NULL, '2026-12-10T14:31:22', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 871 | Ngày Con Còn Mẹ | 10/12 15:00 | Phòng 2 | G8 G9
(5025, 5, NULL, '2026-12-10T14:34:25', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 873 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 10/12 15:30 | Phòng 3 | J3 J4 J5 J6
(5026, 5, 103, '2026-12-10T14:37:16', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 878 | Bắt Cá Ba Tay | 10/12 18:30 | Phòng 1 | F6 F7
(5027, 6, 54, '2026-12-10T14:51:27', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 871 | Ngày Con Còn Mẹ | 10/12 15:00 | Phòng 2 | D7
(5028, 8, 27, '2026-12-10T15:02:23', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 875 | Mẹ Mìn: Giao Kèo Với Quỷ | 10/12 16:15 | Phòng 1 | F5
(5029, 7, NULL, '2026-12-10T15:04:26', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 881 | Bò Sữa Bay | 10/12 19:30 | Phòng 2 | A5 A6
(5030, 7, NULL, '2026-12-10T15:06:20', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 873 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 10/12 15:30 | Phòng 3 | G5 G6
(5031, 7, 45, '2026-12-10T15:07:54', 360000, N'Paid', N'Cash', 360000, 25, 0, NULL, NULL, NULL), -- suat 881 | Bò Sữa Bay | 10/12 19:30 | Phòng 2 | F7 F8 F9 F10
(5032, 7, NULL, '2026-12-10T15:22:18', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 874 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 15:30 | Phòng 4 | F6 F7
(5033, 8, NULL, '2026-12-10T15:22:19', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 881 | Bò Sữa Bay | 10/12 19:30 | Phòng 2 | G7
(5034, 7, NULL, '2026-12-10T15:32:45', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 885 | Con Mắt Thứ Ba | 10/12 21:45 | Phòng 2 | E6 E7
(5035, 8, 16, '2026-12-10T15:43:32', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 878 | Bắt Cá Ba Tay | 10/12 18:30 | Phòng 1 | H5 H6
(5036, 8, NULL, '2026-12-10T15:54:00', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 881 | Bò Sữa Bay | 10/12 19:30 | Phòng 2 | E9 E10
(5037, 7, NULL, '2026-12-10T15:58:15', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 876 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 10/12 17:15 | Phòng 2 | G8 G9
(5038, 7, 10, '2026-12-10T15:58:45', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 876 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 10/12 17:15 | Phòng 2 | F6 F7
(5039, 8, NULL, '2026-12-10T16:00:39', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 877 | Dune: Hành Tinh Cát - Phần Hai | 10/12 18:00 | Phòng 5 | A6 A7
(5040, 8, NULL, '2026-12-10T16:06:58', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 878 | Bắt Cá Ba Tay | 10/12 18:30 | Phòng 1 | B7
(5041, 8, NULL, '2026-12-10T16:12:19', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 880 | Godzilla Trừ Không | 10/12 18:30 | Phòng 4 | E9 E10
(5042, 7, NULL, '2026-12-10T16:23:50', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 880 | Godzilla Trừ Không | 10/12 18:30 | Phòng 4 | C6 C7
(5043, 8, NULL, '2026-12-10T16:24:51', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 884 | Godzilla Trừ Không | 10/12 21:15 | Phòng 5 | G5 G6
(5044, 7, 93, '2026-12-10T16:29:50', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 876 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 10/12 17:15 | Phòng 2 | D10 D11
(5045, 7, NULL, '2026-12-10T16:33:42', 216000, N'Paid', N'Cash', 220000, 0, 0, NULL, NULL, NULL), -- suat 880 | Godzilla Trừ Không | 10/12 18:30 | Phòng 4 | H8 H9
(5046, 8, NULL, '2026-12-10T16:35:56', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 876 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 10/12 17:15 | Phòng 2 | D6 D7 D8
(5047, 7, 78, '2026-12-10T16:46:37', 185000, N'Paid', N'Card', NULL, 12, 31, NULL, NULL, NULL), -- suat 880 | Godzilla Trừ Không | 10/12 18:30 | Phòng 4 | F2 F3
(5048, 8, NULL, '2026-12-10T16:53:45', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 880 | Godzilla Trừ Không | 10/12 18:30 | Phòng 4 | C4 C5
(5049, 8, 36, '2026-12-10T17:13:23', 288000, N'Paid', N'Cash', 300000, 20, 0, NULL, NULL, NULL), -- suat 877 | Dune: Hành Tinh Cát - Phần Hai | 10/12 18:00 | Phòng 5 | K6 K7
(5050, 8, NULL, '2026-12-10T17:16:57', 108000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 880 | Godzilla Trừ Không | 10/12 18:30 | Phòng 4 | E8
(5051, 7, 41, '2026-12-10T17:17:12', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 880 | Godzilla Trừ Không | 10/12 18:30 | Phòng 4 | E11 E12
(5052, 8, 23, '2026-12-10T17:17:45', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 881 | Bò Sữa Bay | 10/12 19:30 | Phòng 2 | D6 D7
(5053, 7, NULL, '2026-12-10T17:18:59', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 884 | Godzilla Trừ Không | 10/12 21:15 | Phòng 5 | F6
(5054, 8, NULL, '2026-12-10T17:26:17', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 882 | Trại Giam Hạnh Phúc | 10/12 21:00 | Phòng 1 | A5 A6
(5055, 8, 75, '2026-12-10T17:31:17', 432000, N'Paid', N'Card', NULL, 30, 0, NULL, NULL, NULL), -- suat 877 | Dune: Hành Tinh Cát - Phần Hai | 10/12 18:00 | Phòng 5 | G5 G6 G7
(5056, 7, NULL, '2026-12-10T17:39:37', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 879 | Điểm Mù | 10/12 18:30 | Phòng 3 | A5 A6 A7
(5057, 8, 21, '2026-12-10T17:40:39', 300000, N'Paid', N'Cash', 300000, 15, 0, NULL, NULL, NULL), -- suat 881 | Bò Sữa Bay | 10/12 19:30 | Phòng 2 | B3 B4 B5 B6
(5058, 8, 23, '2026-12-10T17:44:33', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 880 | Godzilla Trừ Không | 10/12 18:30 | Phòng 4 | F6 F7
(5059, 7, NULL, '2026-12-10T17:44:58', 75000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 878 | Bắt Cá Ba Tay | 10/12 18:30 | Phòng 1 | B9
(5060, 7, NULL, '2026-12-10T17:47:19', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 878 | Bắt Cá Ba Tay | 10/12 18:30 | Phòng 1 | D6 D7
(5061, 8, NULL, '2026-12-10T17:50:35', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 879 | Điểm Mù | 10/12 18:30 | Phòng 3 | E8 E9
(5062, 7, NULL, '2026-12-10T17:53:06', 375000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 882 | Trại Giam Hạnh Phúc | 10/12 21:00 | Phòng 1 | B1 B2 B3 B4 B5
(5063, 7, NULL, '2026-12-10T17:59:01', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 883 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 21:00 | Phòng 4 | E6 E7
(5064, 8, NULL, '2026-12-10T18:07:07', 360000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 879 | Điểm Mù | 10/12 18:30 | Phòng 3 | E1 E2 E3 E4
(5065, 7, 46, '2026-12-10T18:14:05', 108000, N'Paid', N'Cash', 500000, 7, 0, NULL, NULL, NULL), -- suat 880 | Godzilla Trừ Không | 10/12 18:30 | Phòng 4 | E6
(5066, 8, NULL, '2026-12-10T18:15:42', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 881 | Bò Sữa Bay | 10/12 19:30 | Phòng 2 | J11 J12
(5067, 7, NULL, '2026-12-10T18:16:36', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 885 | Con Mắt Thứ Ba | 10/12 21:45 | Phòng 2 | G7 G8
(5068, 8, NULL, '2026-12-10T18:17:32', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 882 | Trại Giam Hạnh Phúc | 10/12 21:00 | Phòng 1 | G8
(5069, 7, 103, '2026-12-10T18:21:21', 360000, N'Paid', N'Cash', 360000, 25, 0, NULL, NULL, NULL), -- suat 886 | Con Mắt Thứ Ba | 10/12 21:45 | Phòng 3 | H4 H5 H6 H7
(5070, 8, 27, '2026-12-10T18:24:48', 150000, N'Paid', N'Cash', 500000, 7, 0, NULL, NULL, NULL), -- suat 881 | Bò Sữa Bay | 10/12 19:30 | Phòng 2 | C6 C7
(5071, 8, NULL, '2026-12-10T18:43:27', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 881 | Bò Sữa Bay | 10/12 19:30 | Phòng 2 | A7 A8
(5072, 7, NULL, '2026-12-10T19:07:04', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 884 | Godzilla Trừ Không | 10/12 21:15 | Phòng 5 | B5 B6 B7
(5073, 8, 120, '2026-12-10T19:08:07', 288000, N'Paid', N'Cash', 500000, 20, 0, NULL, NULL, NULL), -- suat 884 | Godzilla Trừ Không | 10/12 21:15 | Phòng 5 | E2 E3
(5074, 8, NULL, '2026-12-10T19:08:20', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 885 | Con Mắt Thứ Ba | 10/12 21:45 | Phòng 2 | D6
(5075, 8, NULL, '2026-12-10T19:18:10', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 885 | Con Mắt Thứ Ba | 10/12 21:45 | Phòng 2 | D7
(5076, 7, NULL, '2026-12-10T19:21:02', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 885 | Con Mắt Thứ Ba | 10/12 21:45 | Phòng 2 | A6
(5077, 7, 31, '2026-12-10T19:38:12', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 885 | Con Mắt Thứ Ba | 10/12 21:45 | Phòng 2 | G5 G6
(5078, 7, NULL, '2026-12-10T19:40:06', 75000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 882 | Trại Giam Hạnh Phúc | 10/12 21:00 | Phòng 1 | B6
(5079, 7, NULL, '2026-12-10T20:07:38', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 884 | Godzilla Trừ Không | 10/12 21:15 | Phòng 5 | J5 J6
(5080, 8, NULL, '2026-12-10T20:21:57', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 882 | Trại Giam Hạnh Phúc | 10/12 21:00 | Phòng 1 | E6
(5081, 8, NULL, '2026-12-10T20:30:13', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 883 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 21:00 | Phòng 4 | H4 H5 H6 H7
(5082, 8, NULL, '2026-12-10T20:33:59', 240000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 884 | Godzilla Trừ Không | 10/12 21:15 | Phòng 5 | D6 D7
(5083, 8, NULL, '2026-12-10T20:41:55', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 883 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 10/12 21:00 | Phòng 4 | F5 F6
(5084, 7, NULL, '2026-12-10T20:44:43', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 886 | Con Mắt Thứ Ba | 10/12 21:45 | Phòng 3 | E4 E5
(5085, 7, NULL, '2026-12-10T21:00:34', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 886 | Con Mắt Thứ Ba | 10/12 21:45 | Phòng 3 | E7 E8
(5086, 7, NULL, '2026-12-10T21:21:35', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL); -- suat 885 | Con Mắt Thứ Ba | 10/12 21:45 | Phòng 2 | A4 A5
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(11366, 4976, 868, 2, 196, 90000, N'Active'),
(11367, 4976, 868, 2, 197, 90000, N'Active'),
(11368, 4976, 868, 2, 198, 90000, N'Active'),
(11369, 4976, 868, 2, 199, 90000, N'Active'),
(11370, 4977, 859, 2, 195, 90000, N'Active'),
(11371, 4977, 859, 2, 196, 90000, N'Active'),
(11372, 4978, 858, 1, 32, 75000, N'Active'),
(11373, 4978, 858, 1, 33, 75000, N'Active'),
(11374, 4979, 859, 2, 186, 90000, N'Active'),
(11375, 4979, 859, 2, 187, 90000, N'Active'),
(11376, 4980, 879, 3, 282, 90000, N'Active'),
(11377, 4980, 879, 3, 283, 90000, N'Active'),
(11378, 4981, 866, 4, 377, 108000, N'Active'),
(11379, 4981, 866, 4, 378, 108000, N'Active'),
(11380, 4981, 866, 4, 379, 108000, N'Active'),
(11381, 4981, 866, 4, 380, 108000, N'Active'),
(11382, 4982, 876, 2, 145, 90000, N'Active'),
(11383, 4982, 876, 2, 146, 90000, N'Active'),
(11384, 4982, 876, 2, 147, 90000, N'Active'),
(11385, 4982, 876, 2, 148, 90000, N'Active'),
(11386, 4983, 858, 1, 90, 90000, N'Active'),
(11387, 4983, 858, 1, 91, 90000, N'Active'),
(11388, 4983, 858, 1, 92, 90000, N'Active'),
(11389, 4984, 860, 5, 510, 144000, N'Active'),
(11390, 4984, 860, 5, 511, 144000, N'Active'),
(11391, 4985, 861, 4, 390, 108000, N'Active'),
(11392, 4985, 861, 4, 391, 108000, N'Active'),
(11393, 4985, 861, 4, 392, 108000, N'Active'),
(11394, 4985, 861, 4, 393, 108000, N'Active'),
(11395, 4986, 868, 2, 138, 75000, N'Active'),
(11396, 4986, 868, 2, 139, 75000, N'Active'),
(11397, 4986, 868, 2, 140, 75000, N'Active'),
(11398, 4987, 870, 1, 78, 90000, N'Active'),
(11399, 4987, 870, 1, 79, 90000, N'Active'),
(11400, 4987, 870, 1, 80, 90000, N'Active'),
(11401, 4988, 862, 3, 258, 90000, N'Active'),
(11402, 4988, 862, 3, 259, 90000, N'Active'),
(11403, 4989, 866, 4, 416, 108000, N'Active'),
(11404, 4990, 867, 5, 487, 144000, N'Active'),
(11405, 4990, 867, 5, 488, 144000, N'Active'),
(11406, 4990, 867, 5, 489, 144000, N'Active'),
(11407, 4991, 869, 3, 235, 75000, N'Active'),
(11408, 4991, 869, 3, 236, 75000, N'Active'),
(11409, 4992, 867, 5, 494, 144000, N'Active'),
(11410, 4992, 867, 5, 495, 144000, N'Active'),
(11411, 4992, 867, 5, 496, 144000, N'Active'),
(11412, 4992, 867, 5, 497, 144000, N'Active'),
(11413, 4993, 870, 1, 54, 90000, N'Active'),
(11414, 4993, 870, 1, 55, 90000, N'Active'),
(11415, 4994, 883, 4, 368, 108000, N'Active'),
(11416, 4995, 867, 5, 499, 144000, N'Active'),
(11417, 4995, 867, 5, 500, 144000, N'Active'),
(11418, 4996, 874, 4, 401, 108000, N'Active'),
(11419, 4997, 863, 2, 150, 90000, N'Active'),
(11420, 4997, 863, 2, 151, 90000, N'Active'),
(11421, 4997, 863, 2, 152, 90000, N'Active'),
(11422, 4997, 863, 2, 153, 90000, N'Active'),
(11423, 4998, 878, 1, 39, 90000, N'Active'),
(11424, 4998, 878, 1, 40, 90000, N'Active'),
(11425, 4998, 878, 1, 41, 90000, N'Active'),
(11426, 4999, 867, 5, 486, 144000, N'Active'),
(11427, 5000, 879, 3, 258, 90000, N'Active'),
(11428, 5000, 879, 3, 259, 90000, N'Active'),
(11429, 5001, 880, 4, 414, 108000, N'Active'),
(11430, 5001, 880, 4, 415, 108000, N'Active'),
(11431, 5002, 874, 4, 406, 108000, N'Active'),
(11432, 5002, 874, 4, 407, 108000, N'Active'),
(11433, 5003, 866, 4, 366, 108000, N'Active'),
(11434, 5003, 866, 4, 367, 108000, N'Active'),
(11435, 5004, 874, 4, 354, 90000, N'Active'),
(11436, 5004, 874, 4, 355, 90000, N'Active'),
(11437, 5004, 874, 4, 356, 90000, N'Active'),
(11438, 5004, 874, 4, 357, 90000, N'Active'),
(11439, 5005, 872, 5, 498, 144000, N'Active'),
(11440, 5005, 872, 5, 499, 144000, N'Active'),
(11441, 5006, 877, 5, 522, 144000, N'Active'),
(11442, 5006, 877, 5, 523, 144000, N'Active'),
(11443, 5007, 880, 4, 373, 108000, N'Active'),
(11444, 5007, 880, 4, 374, 108000, N'Active'),
(11445, 5008, 876, 2, 127, 75000, N'Active'),
(11446, 5008, 876, 2, 128, 75000, N'Active'),
(11447, 5009, 874, 4, 399, 108000, N'Cancelled'),
(11448, 5009, 874, 4, 400, 108000, N'Cancelled'),
(11449, 5010, 875, 1, 42, 90000, N'Active'),
(11450, 5010, 875, 1, 43, 90000, N'Active'),
(11451, 5011, 872, 5, 450, 120000, N'Active'),
(11452, 5011, 872, 5, 451, 120000, N'Active'),
(11453, 5012, 881, 2, 184, 90000, N'Active'),
(11454, 5012, 881, 2, 185, 90000, N'Active'),
(11455, 5013, 871, 2, 114, 75000, N'Active'),
(11456, 5014, 871, 2, 186, 90000, N'Active'),
(11457, 5014, 871, 2, 187, 90000, N'Active'),
(11458, 5015, 873, 3, 281, 90000, N'Active'),
(11459, 5015, 873, 3, 282, 90000, N'Active'),
(11460, 5015, 873, 3, 283, 90000, N'Active'),
(11461, 5016, 872, 5, 486, 144000, N'Active'),
(11462, 5016, 872, 5, 487, 144000, N'Active'),
(11463, 5017, 881, 2, 161, 90000, N'Active'),
(11464, 5017, 881, 2, 162, 90000, N'Active'),
(11465, 5018, 875, 1, 105, 90000, N'Active'),
(11466, 5018, 875, 1, 106, 90000, N'Active'),
(11467, 5019, 876, 2, 172, 90000, N'Active'),
(11468, 5019, 876, 2, 173, 90000, N'Active'),
(11469, 5020, 875, 1, 99, 90000, N'Active'),
(11470, 5020, 875, 1, 100, 90000, N'Active'),
(11471, 5021, 879, 3, 294, 90000, N'Active'),
(11472, 5021, 879, 3, 295, 90000, N'Active'),
(11473, 5021, 879, 3, 296, 90000, N'Active'),
(11474, 5022, 872, 5, 523, 144000, N'Active'),
(11475, 5022, 872, 5, 524, 144000, N'Active'),
(11476, 5023, 872, 5, 500, 144000, N'Active'),
(11477, 5023, 872, 5, 501, 144000, N'Active'),
(11478, 5024, 871, 2, 188, 90000, N'Active'),
(11479, 5024, 871, 2, 189, 90000, N'Active'),
(11480, 5025, 873, 3, 315, 90000, N'Active'),
(11481, 5025, 873, 3, 316, 90000, N'Active'),
(11482, 5025, 873, 3, 317, 90000, N'Active'),
(11483, 5025, 873, 3, 318, 90000, N'Active'),
(11484, 5026, 878, 1, 66, 90000, N'Active'),
(11485, 5026, 878, 1, 67, 90000, N'Active'),
(11486, 5027, 871, 2, 151, 90000, N'Active'),
(11487, 5028, 875, 1, 65, 90000, N'Active'),
(11488, 5029, 881, 2, 113, 75000, N'Active'),
(11489, 5029, 881, 2, 114, 75000, N'Active'),
(11490, 5030, 873, 3, 293, 90000, N'Active'),
(11491, 5030, 873, 3, 294, 90000, N'Active'),
(11492, 5031, 881, 2, 175, 90000, N'Active'),
(11493, 5031, 881, 2, 176, 90000, N'Active'),
(11494, 5031, 881, 2, 177, 90000, N'Active'),
(11495, 5031, 881, 2, 178, 90000, N'Active'),
(11496, 5032, 874, 4, 390, 108000, N'Active'),
(11497, 5032, 874, 4, 391, 108000, N'Active'),
(11498, 5033, 881, 2, 187, 90000, N'Active'),
(11499, 5034, 885, 2, 162, 90000, N'Active'),
(11500, 5034, 885, 2, 163, 90000, N'Active'),
(11501, 5035, 878, 1, 89, 90000, N'Active'),
(11502, 5035, 878, 1, 90, 90000, N'Active'),
(11503, 5036, 881, 2, 165, 90000, N'Active'),
(11504, 5036, 881, 2, 166, 90000, N'Active'),
(11505, 5037, 876, 2, 188, 90000, N'Active'),
(11506, 5037, 876, 2, 189, 90000, N'Active'),
(11507, 5038, 876, 2, 174, 90000, N'Active'),
(11508, 5038, 876, 2, 175, 90000, N'Active'),
(11509, 5039, 877, 5, 438, 120000, N'Active'),
(11510, 5039, 877, 5, 439, 120000, N'Active'),
(11511, 5040, 878, 1, 19, 75000, N'Active'),
(11512, 5041, 880, 4, 381, 108000, N'Active'),
(11513, 5041, 880, 4, 382, 108000, N'Active'),
(11514, 5042, 880, 4, 354, 90000, N'Active'),
(11515, 5042, 880, 4, 355, 90000, N'Active'),
(11516, 5043, 884, 5, 509, 144000, N'Active'),
(11517, 5043, 884, 5, 510, 144000, N'Active'),
(11518, 5044, 876, 2, 154, 90000, N'Active'),
(11519, 5044, 876, 2, 155, 90000, N'Active'),
(11520, 5045, 880, 4, 416, 108000, N'Active'),
(11521, 5045, 880, 4, 417, 108000, N'Active'),
(11522, 5046, 876, 2, 150, 90000, N'Active'),
(11523, 5046, 876, 2, 151, 90000, N'Active'),
(11524, 5046, 876, 2, 152, 90000, N'Active'),
(11525, 5047, 880, 4, 386, 108000, N'Active'),
(11526, 5047, 880, 4, 387, 108000, N'Active'),
(11527, 5048, 880, 4, 352, 90000, N'Active'),
(11528, 5048, 880, 4, 353, 90000, N'Active'),
(11529, 5049, 877, 5, 546, 144000, N'Active'),
(11530, 5049, 877, 5, 547, 144000, N'Active'),
(11531, 5050, 880, 4, 380, 108000, N'Active'),
(11532, 5051, 880, 4, 383, 108000, N'Active'),
(11533, 5051, 880, 4, 384, 108000, N'Active'),
(11534, 5052, 881, 2, 150, 90000, N'Active'),
(11535, 5052, 881, 2, 151, 90000, N'Active'),
(11536, 5053, 884, 5, 498, 144000, N'Active'),
(11537, 5054, 882, 1, 5, 75000, N'Active'),
(11538, 5054, 882, 1, 6, 75000, N'Active'),
(11539, 5055, 877, 5, 509, 144000, N'Active'),
(11540, 5055, 877, 5, 510, 144000, N'Active'),
(11541, 5055, 877, 5, 511, 144000, N'Active'),
(11542, 5056, 879, 3, 221, 75000, N'Active'),
(11543, 5056, 879, 3, 222, 75000, N'Active'),
(11544, 5056, 879, 3, 223, 75000, N'Active'),
(11545, 5057, 881, 2, 123, 75000, N'Active'),
(11546, 5057, 881, 2, 124, 75000, N'Active'),
(11547, 5057, 881, 2, 125, 75000, N'Active'),
(11548, 5057, 881, 2, 126, 75000, N'Active'),
(11549, 5058, 880, 4, 390, 108000, N'Active'),
(11550, 5058, 880, 4, 391, 108000, N'Active'),
(11551, 5059, 878, 1, 21, 75000, N'Active'),
(11552, 5060, 878, 1, 42, 90000, N'Active'),
(11553, 5060, 878, 1, 43, 90000, N'Active'),
(11554, 5061, 879, 3, 272, 90000, N'Active'),
(11555, 5061, 879, 3, 273, 90000, N'Active'),
(11556, 5062, 882, 1, 13, 75000, N'Active'),
(11557, 5062, 882, 1, 14, 75000, N'Active'),
(11558, 5062, 882, 1, 15, 75000, N'Active'),
(11559, 5062, 882, 1, 16, 75000, N'Active'),
(11560, 5062, 882, 1, 17, 75000, N'Active'),
(11561, 5063, 883, 4, 378, 108000, N'Active'),
(11562, 5063, 883, 4, 379, 108000, N'Active'),
(11563, 5064, 879, 3, 265, 90000, N'Active'),
(11564, 5064, 879, 3, 266, 90000, N'Active'),
(11565, 5064, 879, 3, 267, 90000, N'Active'),
(11566, 5064, 879, 3, 268, 90000, N'Active'),
(11567, 5065, 880, 4, 378, 108000, N'Active'),
(11568, 5066, 881, 2, 215, 90000, N'Active'),
(11569, 5066, 881, 2, 216, 90000, N'Active'),
(11570, 5067, 885, 2, 187, 90000, N'Active'),
(11571, 5067, 885, 2, 188, 90000, N'Active'),
(11572, 5068, 882, 1, 80, 90000, N'Active'),
(11573, 5069, 886, 3, 304, 90000, N'Active'),
(11574, 5069, 886, 3, 305, 90000, N'Active'),
(11575, 5069, 886, 3, 306, 90000, N'Active'),
(11576, 5069, 886, 3, 307, 90000, N'Active'),
(11577, 5070, 881, 2, 138, 75000, N'Active'),
(11578, 5070, 881, 2, 139, 75000, N'Active'),
(11579, 5071, 881, 2, 115, 75000, N'Active'),
(11580, 5071, 881, 2, 116, 75000, N'Active'),
(11581, 5072, 884, 5, 449, 120000, N'Active'),
(11582, 5072, 884, 5, 450, 120000, N'Active'),
(11583, 5072, 884, 5, 451, 120000, N'Active'),
(11584, 5073, 884, 5, 482, 144000, N'Active'),
(11585, 5073, 884, 5, 483, 144000, N'Active'),
(11586, 5074, 885, 2, 150, 90000, N'Active'),
(11587, 5075, 885, 2, 151, 90000, N'Active'),
(11588, 5076, 885, 2, 114, 75000, N'Active'),
(11589, 5077, 885, 2, 185, 90000, N'Active'),
(11590, 5077, 885, 2, 186, 90000, N'Active'),
(11591, 5078, 882, 1, 18, 75000, N'Active'),
(11592, 5079, 884, 5, 533, 144000, N'Active'),
(11593, 5079, 884, 5, 534, 144000, N'Active'),
(11594, 5080, 882, 1, 54, 90000, N'Active'),
(11595, 5081, 883, 4, 412, 108000, N'Active'),
(11596, 5081, 883, 4, 413, 108000, N'Active'),
(11597, 5081, 883, 4, 414, 108000, N'Active'),
(11598, 5081, 883, 4, 415, 108000, N'Active'),
(11599, 5082, 884, 5, 474, 120000, N'Active'),
(11600, 5082, 884, 5, 475, 120000, N'Active'),
(11601, 5083, 883, 4, 389, 108000, N'Active'),
(11602, 5083, 883, 4, 390, 108000, N'Active'),
(11603, 5084, 886, 3, 268, 90000, N'Active'),
(11604, 5084, 886, 3, 269, 90000, N'Active'),
(11605, 5085, 886, 3, 271, 90000, N'Active'),
(11606, 5085, 886, 3, 272, 90000, N'Active'),
(11607, 5086, 885, 2, 112, 75000, N'Active'),
(11608, 5086, 885, 2, 113, 75000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ===== SHIFT_HANDOVER: chot ca cua nhan vien + xac nhan ban giao cua QTV =====
-- ReportedCash = tien mat dem duoc; tien mat he thong = tong don Paid tra bang Cash do nhan vien lap trong ngay.
SET IDENTITY_INSERT SHIFT_HANDOVER ON;
INSERT INTO SHIFT_HANDOVER (ShiftHandoverID, ShiftDate, AccountID, ReportedCash, ReportNote, ReportedAt, ConfirmedCash, ConfirmNote, ConfirmedAt, ConfirmedBy) VALUES
(87, '2026-11-28', 9, 4635000, N'', '2026-11-28T15:06:40', 4635000, N'', '2026-11-28T15:42:22', 1), -- nv07 ca sang, tien mat he thong 4.635.000 d
(88, '2026-11-28', 10, 7176000, N'', '2026-11-28T15:10:59', 7176000, N'', '2026-11-28T15:44:48', 1), -- nv08 ca sang, tien mat he thong 7.176.000 d
(89, '2026-11-28', 3, 5379000, N'', '2026-11-28T15:18:17', 5379000, N'', '2026-11-28T16:11:24', 1), -- nv01 ca sang, tien mat he thong 5.379.000 d
(90, '2026-11-28', 4, 2100000, N'', '2026-11-28T22:05:56', 2100000, N'Đủ tiền.', '2026-11-28T22:55:38', 2), -- nv02 ca toi, tien mat he thong 2.100.000 d
(91, '2026-11-28', 5, 5223000, N'', '2026-11-28T22:13:34', 5223000, N'', '2026-11-29T08:51:42', 2), -- nv03 ca toi, tien mat he thong 5.223.000 d
(92, '2026-11-28', 6, 4473000, N'', '2026-11-28T22:17:45', 4473000, N'Khớp báo cáo.', '2026-11-28T22:39:27', 2), -- nv04 ca toi, tien mat he thong 4.473.000 d
(93, '2026-11-29', 5, 3794000, N'', '2026-11-29T15:08:30', 3794000, N'Đủ tiền.', '2026-11-29T17:09:23', 1), -- nv03 ca sang, tien mat he thong 3.794.000 d
(94, '2026-11-29', 4, 1317000, N'', '2026-11-29T15:21:31', 1317000, N'Đủ tiền.', '2026-11-29T17:23:33', 1), -- nv02 ca sang, tien mat he thong 1.317.000 d
(95, '2026-11-29', 6, NULL, NULL, NULL, 2811000, N'Nhân viên quên nộp chốt ca, QTV tự kiểm két và xác nhận.', '2026-11-29T16:00:16', 1), -- nv04 ca sang, tien mat he thong 2.811.000 d
(96, '2026-11-29', 9, 3390000, N'', '2026-11-29T22:02:50', 3390000, N'Đủ tiền.', '2026-11-30T08:38:08', 2), -- nv07 ca toi, tien mat he thong 3.390.000 d
(97, '2026-11-29', 7, 2748000, N'', '2026-11-29T22:22:44', 2748000, N'', '2026-11-30T08:36:55', 2), -- nv05 ca toi, tien mat he thong 2.748.000 d
(98, '2026-11-29', 8, 2418000, N'', '2026-11-29T22:24:59', 2418000, N'', '2026-11-29T22:36:56', 2), -- nv06 ca toi, tien mat he thong 2.418.000 d
(99, '2026-11-30', 8, 2754000, N'', '2026-11-30T15:13:12', 2754000, N'', '2026-11-30T15:42:50', 1), -- nv06 ca sang, tien mat he thong 2.754.000 d
(100, '2026-11-30', 7, 4164000, N'', '2026-11-30T15:14:27', 4164000, N'', '2026-11-30T16:43:10', 1), -- nv05 ca sang, tien mat he thong 4.164.000 d
(101, '2026-11-30', 10, 2484000, N'', '2026-11-30T22:16:00', 2484000, N'Khớp báo cáo.', '2026-12-01T08:45:48', 2), -- nv08 ca toi, tien mat he thong 2.484.000 d
(102, '2026-11-30', 9, 3633000, N'', '2026-11-30T22:20:28', 3633000, N'Đủ tiền.', '2026-11-30T22:44:05', 2), -- nv07 ca toi, tien mat he thong 3.633.000 d
(103, '2026-12-01', 3, 4401000, N'', '2026-12-01T15:06:46', 4401000, N'Đủ tiền.', '2026-12-01T17:01:33', 1), -- nv01 ca sang, tien mat he thong 4.401.000 d
(104, '2026-12-01', 10, NULL, NULL, NULL, 3348000, N'Nhân viên quên nộp chốt ca, QTV tự kiểm két và xác nhận.', '2026-12-01T16:06:36', 1), -- nv08 ca sang, tien mat he thong 3.348.000 d
(105, '2026-12-01', 4, 3048000, N'', '2026-12-01T22:15:49', 3048000, N'', '2026-12-02T09:04:51', 2), -- nv02 ca toi, tien mat he thong 3.048.000 d
(106, '2026-12-01', 5, 1718000, N'', '2026-12-01T22:25:41', 1718000, N'Đủ tiền.', '2026-12-02T08:32:36', 2), -- nv03 ca toi, tien mat he thong 1.718.000 d
(107, '2026-12-02', 5, 3213000, N'', '2026-12-02T15:13:50', 3213000, N'', '2026-12-02T15:56:53', 1), -- nv03 ca sang, tien mat he thong 3.213.000 d
(108, '2026-12-02', 6, 3858000, N'', '2026-12-02T15:21:16', 3858000, N'', '2026-12-02T17:06:58', 1), -- nv04 ca sang, tien mat he thong 3.858.000 d
(109, '2026-12-02', 8, 6156000, N'', '2026-12-02T21:59:20', 6156000, N'Đủ tiền.', '2026-12-02T22:47:28', 2), -- nv06 ca toi, tien mat he thong 6.156.000 d
(110, '2026-12-02', 7, 2343000, N'', '2026-12-02T22:23:57', 2343000, N'', '2026-12-02T22:56:54', 2), -- nv05 ca toi, tien mat he thong 2.343.000 d
(111, '2026-12-03', 9, 3213000, N'', '2026-12-03T15:05:46', 3213000, N'', '2026-12-03T16:50:27', 1), -- nv07 ca sang, tien mat he thong 3.213.000 d
(112, '2026-12-03', 8, 3570000, N'', '2026-12-03T15:22:30', 3570000, N'', '2026-12-03T17:32:54', 1), -- nv06 ca sang, tien mat he thong 3.570.000 d
(113, '2026-12-03', 3, 4947000, N'', '2026-12-03T22:01:26', 4947000, N'Khớp báo cáo.', '2026-12-04T08:32:41', 2), -- nv01 ca toi, tien mat he thong 4.947.000 d
(114, '2026-12-03', 10, 3891000, N'', '2026-12-03T22:06:46', 3891000, N'', '2026-12-03T22:32:40', 2), -- nv08 ca toi, tien mat he thong 3.891.000 d
(115, '2026-12-04', 3, 3096000, N'', '2026-12-04T15:02:14', 3096000, N'Khớp báo cáo.', '2026-12-04T16:44:02', 1), -- nv01 ca sang, tien mat he thong 3.096.000 d
(116, '2026-12-04', 5, 3816000, N'Dư 10.000 đ do khách không lấy tiền thối.', '2026-12-04T15:02:52', 3816000, N'Đã đối soát, ghi nhận chênh lệch theo báo cáo nhân viên.', '2026-12-04T17:03:10', 1), -- nv03 ca sang, tien mat he thong 3.806.000 d
(117, '2026-12-04', 4, 2102000, N'', '2026-12-04T15:18:08', 2102000, N'', '2026-12-04T17:02:45', 1), -- nv02 ca sang, tien mat he thong 2.102.000 d
(118, '2026-12-04', 8, 5351000, N'Thiếu 10.000 đ, chưa rõ nguyên nhân.', '2026-12-04T21:58:14', 5351000, N'Đã đối soát, ghi nhận chênh lệch theo báo cáo nhân viên.', '2026-12-04T22:49:06', 2), -- nv06 ca toi, tien mat he thong 5.361.000 d
(119, '2026-12-04', 7, 2712000, N'', '2026-12-04T22:17:33', 2712000, N'', '2026-12-05T08:59:07', 2), -- nv05 ca toi, tien mat he thong 2.712.000 d
(120, '2026-12-04', 6, 3159000, N'', '2026-12-04T22:22:22', 3159000, N'', '2026-12-05T08:54:01', 2), -- nv04 ca toi, tien mat he thong 3.159.000 d
(121, '2026-12-05', 6, 3777000, N'', '2026-12-05T15:07:24', 3777000, N'Khớp báo cáo.', '2026-12-05T16:51:22', 1), -- nv04 ca sang, tien mat he thong 3.777.000 d
(122, '2026-12-05', 8, 5813000, N'', '2026-12-05T15:08:37', 5813000, N'', '2026-12-05T15:49:48', 1), -- nv06 ca sang, tien mat he thong 5.813.000 d
(123, '2026-12-05', 7, 5880000, N'', '2026-12-05T15:14:14', 5880000, N'Khớp báo cáo.', '2026-12-05T17:18:04', 1), -- nv05 ca sang, tien mat he thong 5.880.000 d
(124, '2026-12-05', 10, 2754000, N'Dư 20.000 đ, nghi khách đưa dư.', '2026-12-05T22:01:52', 2754000, N'Đã đối soát, ghi nhận chênh lệch theo báo cáo nhân viên.', '2026-12-06T08:39:55', 2), -- nv08 ca toi, tien mat he thong 2.734.000 d
(125, '2026-12-05', 3, 3812000, N'', '2026-12-05T22:07:23', 3812000, N'', '2026-12-05T22:54:39', 2), -- nv01 ca toi, tien mat he thong 3.812.000 d
(126, '2026-12-05', 9, 3659000, N'', '2026-12-05T22:10:36', 3659000, N'Khớp báo cáo.', '2026-12-06T08:53:19', 2), -- nv07 ca toi, tien mat he thong 3.659.000 d
(127, '2026-12-06', 3, 2084000, N'', '2026-12-06T15:02:31', 2084000, N'', '2026-12-06T16:15:30', 1), -- nv01 ca sang, tien mat he thong 2.084.000 d
(128, '2026-12-06', 9, 3638000, N'', '2026-12-06T15:03:35', 3638000, N'Đủ tiền.', '2026-12-06T15:40:17', 1), -- nv07 ca sang, tien mat he thong 3.638.000 d
(129, '2026-12-06', 10, 4341000, N'', '2026-12-06T15:14:30', 4341000, N'', '2026-12-06T16:00:57', 1), -- nv08 ca sang, tien mat he thong 4.341.000 d
(130, '2026-12-06', 4, 1929000, N'', '2026-12-06T22:00:32', 1929000, N'', '2026-12-06T22:37:45', 2), -- nv02 ca toi, tien mat he thong 1.929.000 d
(131, '2026-12-06', 5, 3384000, N'', '2026-12-06T22:13:28', 3384000, N'', '2026-12-07T08:56:26', 2), -- nv03 ca toi, tien mat he thong 3.384.000 d
(132, '2026-12-06', 6, 3060000, N'', '2026-12-06T22:18:40', 3060000, N'', '2026-12-06T22:49:43', 2), -- nv04 ca toi, tien mat he thong 3.060.000 d
(133, '2026-12-07', 5, 1969000, N'Dư 10.000 đ do khách không lấy tiền thối.', '2026-12-07T15:04:29', 1969000, N'Đã đối soát, ghi nhận chênh lệch theo báo cáo nhân viên.', '2026-12-07T16:02:12', 1), -- nv03 ca sang, tien mat he thong 1.959.000 d
(134, '2026-12-07', 4, 4056000, N'', '2026-12-07T15:07:36', 4056000, N'Khớp báo cáo.', '2026-12-07T15:57:04', 1), -- nv02 ca sang, tien mat he thong 4.056.000 d
(135, '2026-12-07', 7, 3903000, N'', '2026-12-07T21:59:47', 3903000, N'', '2026-12-07T22:45:26', 2), -- nv05 ca toi, tien mat he thong 3.903.000 d
(136, '2026-12-07', 6, 2682000, N'', '2026-12-07T22:21:24', 2682000, N'Khớp báo cáo.', '2026-12-08T08:29:51', 2), -- nv04 ca toi, tien mat he thong 2.682.000 d
(137, '2026-12-08', 8, 3270000, N'', '2026-12-08T15:03:31', 3270000, N'', '2026-12-08T16:47:07', 1), -- nv06 ca sang, tien mat he thong 3.270.000 d
(138, '2026-12-08', 7, 2787000, N'', '2026-12-08T15:04:24', 2787000, N'', '2026-12-08T15:36:23', 1), -- nv05 ca sang, tien mat he thong 2.787.000 d
(139, '2026-12-08', 9, 4008000, N'', '2026-12-08T22:04:30', 4008000, N'', '2026-12-08T22:37:49', 2), -- nv07 ca toi, tien mat he thong 4.008.000 d
(140, '2026-12-08', 10, 1668000, N'', '2026-12-08T22:07:10', 1668000, N'Khớp báo cáo.', '2026-12-09T08:45:19', 2), -- nv08 ca toi, tien mat he thong 1.668.000 d
(141, '2026-12-09', 3, 3690000, N'', '2026-12-09T15:05:57', 3690000, N'', '2026-12-09T15:59:07', 1), -- nv01 ca sang, tien mat he thong 3.690.000 d
(142, '2026-12-09', 10, 2727000, N'', '2026-12-09T15:16:54', 2727000, N'Khớp báo cáo.', '2026-12-09T16:43:52', 1), -- nv08 ca sang, tien mat he thong 2.727.000 d
(143, '2026-12-09', 4, 2959000, N'', '2026-12-09T22:08:27', 2959000, N'Khớp báo cáo.', '2026-12-09T22:42:15', 2), -- nv02 ca toi, tien mat he thong 2.959.000 d
(144, '2026-12-09', 5, 2607000, N'', '2026-12-09T22:11:44', 2607000, N'', '2026-12-10T09:08:00', 2), -- nv03 ca toi, tien mat he thong 2.607.000 d
(145, '2026-12-10', 5, 3168000, N'', '2026-12-10T15:05:37', 3168000, N'Khớp báo cáo.', '2026-12-10T17:07:50', 1), -- nv03 ca sang, tien mat he thong 3.168.000 d
(146, '2026-12-10', 6, NULL, NULL, NULL, 2409000, N'Nhân viên quên nộp chốt ca, QTV tự kiểm két và xác nhận.', '2026-12-10T16:19:57', 1), -- nv04 ca sang, tien mat he thong 2.409.000 d
(147, '2026-12-10', 7, 3765000, N'', '2026-12-10T22:02:03', NULL, NULL, NULL, NULL), -- nv05 ca toi, tien mat he thong 3.765.000 d
(148, '2026-12-10', 8, 2610000, N'', '2026-12-10T22:09:28', NULL, NULL, NULL, NULL); -- nv06 ca toi, tien mat he thong 2.610.000 d
SET IDENTITY_INSERT SHIFT_HANDOVER OFF;

-- ===== CUSTOMER: diem moi = diem cu + diem cong - diem dung cua cac don Paid moi (gia tri ghi san) =====
UPDATE CUSTOMER SET Points = 408 WHERE CustomerID = 1; -- truoc 240
UPDATE CUSTOMER SET Points = 164 WHERE CustomerID = 2; -- truoc 55
UPDATE CUSTOMER SET Points = 38 WHERE CustomerID = 3; -- truoc 26
UPDATE CUSTOMER SET Points = 96 WHERE CustomerID = 4; -- truoc 10
UPDATE CUSTOMER SET Points = 28 WHERE CustomerID = 5; -- truoc 63
UPDATE CUSTOMER SET Points = 173 WHERE CustomerID = 6; -- truoc 139
UPDATE CUSTOMER SET Points = 129 WHERE CustomerID = 8; -- truoc 80
UPDATE CUSTOMER SET Points = 164 WHERE CustomerID = 9; -- truoc 120
UPDATE CUSTOMER SET Points = 83 WHERE CustomerID = 10; -- truoc 41
UPDATE CUSTOMER SET Points = 113 WHERE CustomerID = 13; -- truoc 55
UPDATE CUSTOMER SET Points = 88 WHERE CustomerID = 15; -- truoc 51
UPDATE CUSTOMER SET Points = 33 WHERE CustomerID = 16; -- truoc 18
UPDATE CUSTOMER SET Points = 30 WHERE CustomerID = 17; -- truoc 15
UPDATE CUSTOMER SET Points = 42 WHERE CustomerID = 18; -- truoc 12
UPDATE CUSTOMER SET Points = 80 WHERE CustomerID = 19; -- truoc 32
UPDATE CUSTOMER SET Points = 627 WHERE CustomerID = 21; -- truoc 306
UPDATE CUSTOMER SET Points = 98 WHERE CustomerID = 22; -- truoc 59
UPDATE CUSTOMER SET Points = 183 WHERE CustomerID = 23; -- truoc 84
UPDATE CUSTOMER SET Points = 74 WHERE CustomerID = 24; -- truoc 59
UPDATE CUSTOMER SET Points = 401 WHERE CustomerID = 25; -- truoc 218
UPDATE CUSTOMER SET Points = 27 WHERE CustomerID = 26; -- truoc 9
UPDATE CUSTOMER SET Points = 118 WHERE CustomerID = 27; -- truoc 44
UPDATE CUSTOMER SET Points = 269 WHERE CustomerID = 28; -- truoc 65
UPDATE CUSTOMER SET Points = 164 WHERE CustomerID = 29; -- truoc 92
UPDATE CUSTOMER SET Points = 202 WHERE CustomerID = 30; -- truoc 152
UPDATE CUSTOMER SET Points = 265 WHERE CustomerID = 31; -- truoc 151
UPDATE CUSTOMER SET Points = 266 WHERE CustomerID = 32; -- truoc 97
UPDATE CUSTOMER SET Points = 106 WHERE CustomerID = 33; -- truoc 29
UPDATE CUSTOMER SET Points = 103 WHERE CustomerID = 34; -- truoc 33
UPDATE CUSTOMER SET Points = 64 WHERE CustomerID = 35; -- truoc 61
UPDATE CUSTOMER SET Points = 74 WHERE CustomerID = 36; -- truoc 18
UPDATE CUSTOMER SET Points = 278 WHERE CustomerID = 37; -- truoc 138
UPDATE CUSTOMER SET Points = 19 WHERE CustomerID = 38; -- truoc 12
UPDATE CUSTOMER SET Points = 73 WHERE CustomerID = 40; -- truoc 67
UPDATE CUSTOMER SET Points = 55 WHERE CustomerID = 41; -- truoc 12
UPDATE CUSTOMER SET Points = 287 WHERE CustomerID = 42; -- truoc 61
UPDATE CUSTOMER SET Points = 176 WHERE CustomerID = 43; -- truoc 104
UPDATE CUSTOMER SET Points = 227 WHERE CustomerID = 44; -- truoc 141
UPDATE CUSTOMER SET Points = 77 WHERE CustomerID = 45; -- truoc 32
UPDATE CUSTOMER SET Points = 123 WHERE CustomerID = 46; -- truoc 10
UPDATE CUSTOMER SET Points = 280 WHERE CustomerID = 47; -- truoc 136
UPDATE CUSTOMER SET Points = 164 WHERE CustomerID = 48; -- truoc 62
UPDATE CUSTOMER SET Points = 275 WHERE CustomerID = 49; -- truoc 97
UPDATE CUSTOMER SET Points = 121 WHERE CustomerID = 51; -- truoc 51
UPDATE CUSTOMER SET Points = 66 WHERE CustomerID = 52; -- truoc 48
UPDATE CUSTOMER SET Points = 73 WHERE CustomerID = 53; -- truoc 50
UPDATE CUSTOMER SET Points = 123 WHERE CustomerID = 54; -- truoc 71
UPDATE CUSTOMER SET Points = 146 WHERE CustomerID = 55; -- truoc 108
UPDATE CUSTOMER SET Points = 91 WHERE CustomerID = 56; -- truoc 54
UPDATE CUSTOMER SET Points = 64 WHERE CustomerID = 58; -- truoc 18
UPDATE CUSTOMER SET Points = 103 WHERE CustomerID = 59; -- truoc 70
UPDATE CUSTOMER SET Points = 121 WHERE CustomerID = 60; -- truoc 48
UPDATE CUSTOMER SET Points = 45 WHERE CustomerID = 61; -- truoc 30
UPDATE CUSTOMER SET Points = 68 WHERE CustomerID = 62; -- truoc 50
UPDATE CUSTOMER SET Points = 80 WHERE CustomerID = 63; -- truoc 50
UPDATE CUSTOMER SET Points = 95 WHERE CustomerID = 64; -- truoc 61
UPDATE CUSTOMER SET Points = 55 WHERE CustomerID = 65; -- truoc 43
UPDATE CUSTOMER SET Points = 344 WHERE CustomerID = 66; -- truoc 140
UPDATE CUSTOMER SET Points = 341 WHERE CustomerID = 67; -- truoc 155
UPDATE CUSTOMER SET Points = 105 WHERE CustomerID = 68; -- truoc 106
UPDATE CUSTOMER SET Points = 408 WHERE CustomerID = 69; -- truoc 288
UPDATE CUSTOMER SET Points = 427 WHERE CustomerID = 72; -- truoc 234
UPDATE CUSTOMER SET Points = 121 WHERE CustomerID = 73; -- truoc 48
UPDATE CUSTOMER SET Points = 47 WHERE CustomerID = 74; -- truoc 18
UPDATE CUSTOMER SET Points = 291 WHERE CustomerID = 75; -- truoc 156
UPDATE CUSTOMER SET Points = 51 WHERE CustomerID = 76; -- truoc 25
UPDATE CUSTOMER SET Points = 374 WHERE CustomerID = 77; -- truoc 277
UPDATE CUSTOMER SET Points = 311 WHERE CustomerID = 78; -- truoc 172
UPDATE CUSTOMER SET Points = 25 WHERE CustomerID = 79; -- truoc 38
UPDATE CUSTOMER SET Points = 154 WHERE CustomerID = 80; -- truoc 62
UPDATE CUSTOMER SET Points = 137 WHERE CustomerID = 81; -- truoc 27
UPDATE CUSTOMER SET Points = 57 WHERE CustomerID = 82; -- truoc 45
UPDATE CUSTOMER SET Points = 95 WHERE CustomerID = 85; -- truoc 47
UPDATE CUSTOMER SET Points = 66 WHERE CustomerID = 86; -- truoc 61
UPDATE CUSTOMER SET Points = 114 WHERE CustomerID = 87; -- truoc 54
UPDATE CUSTOMER SET Points = 158 WHERE CustomerID = 88; -- truoc 94
UPDATE CUSTOMER SET Points = 142 WHERE CustomerID = 89; -- truoc 38
UPDATE CUSTOMER SET Points = 178 WHERE CustomerID = 90; -- truoc 98
UPDATE CUSTOMER SET Points = 78 WHERE CustomerID = 92; -- truoc 27
UPDATE CUSTOMER SET Points = 273 WHERE CustomerID = 93; -- truoc 61
UPDATE CUSTOMER SET Points = 80 WHERE CustomerID = 94; -- truoc 16
UPDATE CUSTOMER SET Points = 121 WHERE CustomerID = 95; -- truoc 17
UPDATE CUSTOMER SET Points = 111 WHERE CustomerID = 96; -- truoc 53
UPDATE CUSTOMER SET Points = 120 WHERE CustomerID = 97; -- truoc 52
UPDATE CUSTOMER SET Points = 202 WHERE CustomerID = 98; -- truoc 132
UPDATE CUSTOMER SET Points = 98 WHERE CustomerID = 99; -- truoc 67
UPDATE CUSTOMER SET Points = 48 WHERE CustomerID = 100; -- truoc 30
UPDATE CUSTOMER SET Points = 22 WHERE CustomerID = 101; -- truoc 7
UPDATE CUSTOMER SET Points = 35 WHERE CustomerID = 102; -- truoc 19
UPDATE CUSTOMER SET Points = 125 WHERE CustomerID = 103; -- truoc 56
UPDATE CUSTOMER SET Points = 43 WHERE CustomerID = 104; -- truoc 54
UPDATE CUSTOMER SET Points = 81 WHERE CustomerID = 105; -- truoc 60
UPDATE CUSTOMER SET Points = 51 WHERE CustomerID = 106; -- truoc 36
UPDATE CUSTOMER SET Points = 61 WHERE CustomerID = 107; -- truoc 33
UPDATE CUSTOMER SET Points = 195 WHERE CustomerID = 108; -- truoc 69
UPDATE CUSTOMER SET Points = 229 WHERE CustomerID = 109; -- truoc 125
UPDATE CUSTOMER SET Points = 76 WHERE CustomerID = 110; -- truoc 38
UPDATE CUSTOMER SET Points = 70 WHERE CustomerID = 111; -- truoc 38
UPDATE CUSTOMER SET Points = 344 WHERE CustomerID = 113; -- truoc 106
UPDATE CUSTOMER SET Points = 101 WHERE CustomerID = 114; -- truoc 77
UPDATE CUSTOMER SET Points = 127 WHERE CustomerID = 115; -- truoc 59
UPDATE CUSTOMER SET Points = 161 WHERE CustomerID = 116; -- truoc 70
UPDATE CUSTOMER SET Points = 267 WHERE CustomerID = 117; -- truoc 95
UPDATE CUSTOMER SET Points = 81 WHERE CustomerID = 118; -- truoc 60
UPDATE CUSTOMER SET Points = 42 WHERE CustomerID = 119; -- truoc 27
UPDATE CUSTOMER SET Points = 261 WHERE CustomerID = 120; -- truoc 123

COMMIT;

-- Tong hop sau khi chay
SELECT (SELECT COUNT(*) FROM SHOWTIME) AS SuatChieu, (SELECT COUNT(*) FROM BOOKING) AS HoaDon, (SELECT COUNT(*) FROM TICKET) AS Ve,
       (SELECT COUNT(*) FROM SHIFT_HANDOVER) AS ChotCa, (SELECT SUM(TotalAmount) FROM BOOKING WHERE BookingStatus = N'Paid') AS DoanhThu,
       (SELECT CAST(MAX(StartTime) AS date) FROM SHOWTIME) AS DenNgay;
