-- Du lieu ao CO DINH cho CINEMADB: 10/11/2026 -> 27/11/2026.
-- Chay ngay sau CinemaDB.sql tren CSDL vua tao (con trong). File nay THAY cho seed.sql + seed_1011_1311.sql
-- + seed_2311_0712.sql, khong chay chung voi cac file do.
-- Moi gia tri (ID, ngay gio, ghe, gia, diem, tien mat) deu viet san bang INSERT, khong dung ham ngay gio, so ngau nhien hay vong lap
-- => may nao chay, chay luc nao cung ra cung mot du lieu.
-- Tai khoan: 2 quan tri vien (admin, admin2) + 8 nhan vien (nv01 -> nv08). Mat khau moi tai khoan: 123456 (bcrypt).
-- 120 khach hang: 16 hang Vang (>= 3.000.000 d), 34 hang Bac (1.000.000 -> < 3.000.000 d),
--   64 hang Thuong da mua ve, 6 khach moi chua mua. Hang tinh theo tong tien don Paid (Models/Customer.cs).
-- 509 suat chieu, 2929 hoa don, 6720 ve, 86 ban ghi chot ca.
-- Quy tac giong app: ghe thuong = BasePrice, VIP / ghe doi = BasePrice x 1,2 moi ghe; 2D 75.000, 3D 90.000, IMAX 120.000.
-- Diem: 5% thuong, 7% VIP, 10% ghe doi tren tien thuc tra, 1.000 d = 1 diem; dung 1 diem giam 1.000 d.
-- Nhan vien chi huy don cua minh trong ngay, truoc gio chieu va truoc khi chot ca; QTV huy duoc moi don.
-- Ca sang 08:00-15:00, ca toi 15:00-22:00. Ca toi 27/11 da nop chot ca, dang cho QTV xac nhan.
USE CINEMADB;
SET NOCOUNT ON;
SET XACT_ABORT ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;

IF EXISTS (SELECT 1 FROM MOVIE) OR EXISTS (SELECT 1 FROM ACCOUNT) OR EXISTS (SELECT 1 FROM CUSTOMER)
BEGIN
    RAISERROR(N'CSDL đã có dữ liệu. Chạy lại CinemaDB.sql để tạo CSDL mới rồi mới chạy seed_codinh_1011_2711.sql.', 16, 1);
    RETURN;
END

BEGIN TRANSACTION;

-- ===== ACCOUNT: 2 quan tri vien + 8 nhan vien =====
SET IDENTITY_INSERT ACCOUNT ON;
INSERT INTO ACCOUNT (AccountID, Username, PasswordHash, FullName, AccountRole, IsActive) VALUES
(1, N'admin', N'$2a$11$GOD8jVUDmajmXHZmmWiqlOjHg2d3I46vxZSkQxiXPOT.d3Nx.sbi2', N'Lê Minh Quân', N'Admin', 1),
(2, N'admin2', N'$2a$11$bDE8I9PfBN9l5gDQYZT50OL5rkq6tGZAfoxqcgV8wUsqbnQlvJQMi', N'Đoàn Thị Kim Ngân', N'Admin', 1),
(3, N'nv01', N'$2a$11$ZP35wI09Qu2TchAgleQu9O9wVEYOTjbJEbkOr57.7NYBew8kMmPUm', N'Nguyễn Thu Hà', N'Staff', 1),
(4, N'nv02', N'$2a$11$qd0NePgcrsq1L1r9DRsDJ.Z2z.2G0ZL4ETQJW.E2EWYSmRhfveac6', N'Trần Quốc Bảo', N'Staff', 1),
(5, N'nv03', N'$2a$11$X/O09BN1A190.DSFUVpb0ucQikvvnCEcAx1Z5AO6g0fQ/3K9abs2u', N'Phạm Ngọc Lan', N'Staff', 1),
(6, N'nv04', N'$2a$11$2zU6/Vn1ZLC5ajaBFiITnueOHmUxFJXBhwWBJj99D6A75oBDG7TxW', N'Võ Thành Đạt', N'Staff', 1),
(7, N'nv05', N'$2a$11$W/NmNalBjyzzFD308xOBvu3gAFCLLE4wfDoKHiRd2gmCXP6jPoXe6', N'Lý Gia Hân', N'Staff', 1),
(8, N'nv06', N'$2a$11$2U7gPwlw3TpW1wuvH8SHHOHTrINZQRx2YYCzDstpvOKd8YhJcV2sq', N'Hồ Minh Khang', N'Staff', 1),
(9, N'nv07', N'$2a$11$yAqYQmmssb1dZ2NvHJ6dSOTgc7EnCpulsFIFFWA9HipzSf9TnDd7a', N'Châu Bảo Trâm', N'Staff', 1),
(10, N'nv08', N'$2a$11$euxs34ZQwQVha0k4hLByDuRHQImbqnfB.e1yOLjHYVwvCTeY8.wAW', N'Mai Đức Thịnh', N'Staff', 1);
SET IDENTITY_INSERT ACCOUNT OFF;

-- ===== MOVIE: trang thai tinh toi 27/11/2026 =====
SET IDENTITY_INSERT MOVIE ON;
INSERT INTO MOVIE (MovieID, Title, DurationMin, Genre, Agerating, MovieStatus, ReleaseDate, PosterPath, MovieDescription) VALUES
(1, N'Trại Giam Hạnh Phúc', 127, N'Hài, Tình Cảm, Gia Đình', N'T16', N'Đang chiếu', '2026-11-18', N'trai-giam-hanh-phuc.jpg', N'Phim Việt Nam của đạo diễn Trung Lùn. Diễn viên: Tuấn Trần, Ma Ran Đô, Lương Thế Thành, Tiến Luật.'),
(2, N'Ngày Con Còn Mẹ', 107, N'Gia Đình, Tâm Lý', N'T16', N'Đang chiếu', '2026-11-11', N'ngay-con-con-me.jpg', N'Phim Việt Nam của đạo diễn Vũ Ngọc Đãng. Diễn viên: Hồng Đào, Phương Anh Đào, Ma Ran Đô.'),
(3, N'Godzilla Trừ Không', 135, N'Hành Động', N'T16', N'Đang chiếu', '2026-11-06', N'godzilla-minus-zero.jpg', N'Phim Nhật Bản của đạo diễn Yamazaki Takashi. Diễn viên: Kamiki Ryunosuke, Hamabe Minami, Yamada Yuki.'),
(4, N'Bí Kíp Luyện Cướp', 122, N'Hành Động', N'T18', N'Đang chiếu', '2026-11-12', N'how-to-rob-a-bank.jpg', N'Phim Mỹ của đạo diễn David Leitch. Diễn viên: Nicholas Hoult, Pete Davidson, Zoë Kravitz.'),
(5, N'Chị Chị Em Em 3', 122, N'Tâm Lý, Tình Cảm', N'T18', N'Đang chiếu', '2026-10-29', N'chi-chi-em-em-3.jpg', N'Phim Việt Nam của đạo diễn Nguyễn Hữu Hoàng. Diễn viên: Chi Pu, Ninh Dương Lan Ngọc, NSND Lê Khanh.'),
(6, N'Ramayana: Khởi Nguồn Một Huyền Thoại', 168, N'Giả Tưởng, Hành Động', N'T13', N'Đang chiếu', '2026-11-06', N'ramayana-rise-of-a-legend.jpg', N'Phim Ấn Độ của đạo diễn Nitesh Tiwari. Diễn viên: Ranbir Kapoor, Yash, Sai Pallavi.'),
(7, N'Dune: Hành Tinh Cát - Phần Hai', 166, N'Giả Tưởng, Hành Động', N'T16', N'Đang chiếu', '2026-11-18', N'dune-2.jpg', N'Phim Mỹ của đạo diễn Denis Villeneuve. Diễn viên: Timothée Chalamet, Zendaya, Rebecca Ferguson.'),
(8, N'Kiến Lé Phiêu Lưu Ké', 77, N'Hoạt Hình', N'P', N'Đang chiếu', '2026-11-14', N'arnie--barney.jpg', N'Phim hoạt hình Đức của đạo diễn Sean Heuston, chiếu bản lồng tiếng.'),
(9, N'Kẻ Hồi Sinh', 101, N'Hành Động', N'T16', N'Đang chiếu', '2026-11-13', N'reawaken-man-the-red.jpg', N'Phim Hàn Quốc của đạo diễn Baek Jong Yeol. Diễn viên: Koo Kyo Hwan, Shin Seung Ho, Kang Ki Young.'),
(10, N'Dune: Hành Tinh Cát', 165, N'Hành Động, Phiêu Lưu, Tâm Lý', N'T13', N'Đang chiếu', '2026-11-13', N'dune.jpg', N'Phim Mỹ của đạo diễn Denis Villeneuve. Diễn viên: Timothée Chalamet, Zendaya, Oscar Isaac.'),
(11, N'Thòng Lọng Ma: Quỷ Cái Đòi Mạng', 105, N'Kinh Dị', N'T18', N'Đang chiếu', '2026-11-11', N'the-rope-curse-4-kuntilanak.jpg', N'Phim Đài Loan của đạo diễn Liêu Sĩ Hàn. Diễn viên: Wilson Hsu, Vera Chen.'),
(12, N'Chàng Mèo Mang Mũ', 107, N'Hoạt Hình, Phiêu Lưu', N'P', N'Đang chiếu', '2026-11-06', N'the-cat-in-the-hat.jpg', N'Phim hoạt hình Mỹ của Warner Bros. Animation, chiếu bản lồng tiếng.'),
(13, N'Thiên Đường Tăm Tối', 100, N'Tâm Lý, Giật Gân', N'T18', N'Ngừng chiếu', '2026-11-05', N'paradise-lost.jpg', N'Phim Hàn Quốc của đạo diễn Yeon Sang Ho. Diễn viên: Kim Hyun Joo, Bae Hyun Sung.'),
(14, N'Bò Sữa Bay', 108, N'Hài, Tình Cảm, Hành Động', N'T18', N'Đang chiếu', '2026-11-05', N'bo-sua-bay.jpg', N'Phim Việt Nam của đạo diễn Nguyễn Phạm Thành Đạt. Diễn viên: Nguyễn Hùng, Ngọc Xuân, Võ Điền Gia Huy.'),
(15, N'Clayface', 108, N'Kinh Dị, Giật Gân', N'T18', N'Ngừng chiếu', '2026-10-28', N'clayface.jpg', N'Phim Mỹ của đạo diễn James Watkins. Diễn viên: Tom Rhys Harries, Naomi Ackie, Eddie Marsan.'),
(16, N'Shaun The Sheep: "Quái Lạ" Ghé Nhà', 91, N'Hoạt Hình', N'P', N'Ngừng chiếu', '2026-10-16', N'shaun-the-sheep-the-beast-of-mossy-bottom.jpg', N'Phim hoạt hình của Aardman Animations, đạo diễn Steve Cox và Matthew Walker.'),
(17, N'Trại Buôn Người', 135, N'Hành Động, Tâm Lý', N'T18', N'Ngừng chiếu', '2026-09-24', N'trai-buon-nguoi.jpg', N'Phim Việt Nam của đạo diễn Toni Dương Bảo Anh. Diễn viên: Steven Nguyễn, Quách Ngọc Ngoan, Huỳnh Minh Kiên.'),
(18, N'Điểm Mù', 175, N'Tài Liệu', N'T16', N'Đang chiếu', '2026-11-27', N'you-can-see-everything.jpg', N'Phim Mỹ của hãng A24, đạo diễn Nathan Fielder và Lance Oppenheim.'),
(19, N'Ma Mút Con Vượt Kỷ Băng Hà', 73, N'Hoạt Hình, Phiêu Lưu', N'P', N'Đang chiếu', '2026-11-20', N'mother-for-a-little-mammoth.jpg', N'Phim hoạt hình Nga của đạo diễn Alexander Voytinskiy.'),
(20, N'Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân', 158, N'Hành Động, Giả Tưởng', N'T16', N'Đang chiếu', '2026-11-20', N'the-hunger-games-sunrise-on-the-reaping.jpg', N'Phim Mỹ của đạo diễn Francis Lawrence. Diễn viên: Mckenna Grace, Ralph Fiennes, Joseph Zada.'),
(21, N'Rosetta (EUFF)', 95, N'Tâm Lý', N'T16', N'Ngừng chiếu', '2026-11-21', N'rosetta.jpg', N'Phim Pháp - Bỉ của đạo diễn Luc Dardenne và Jean-Pierre Dardenne.'),
(22, N'Ba Cây Số Từ Nơi Tận Cùng Thế Giới (EUFF)', 105, N'Giật Gân, Tâm Lý', N'T18', N'Ngừng chiếu', '2026-11-23', N'three-kilometres-to-the-end-of-the-world.jpg', N'Phim Romania của đạo diễn Emanuel Pârvu. Diễn viên: Ciprian Chiujdea, Bogdan Dumitrache, Laura Vasiliu.'),
(23, N'Amrum (EUFF)', 93, N'Tâm Lý, Lịch Sử', N'T13', N'Ngừng chiếu', '2026-11-24', N'amrum.jpg', N'Phim Đức của đạo diễn Fatih Akin. Diễn viên: Jasper Billerbeck, Laura Tonke, Diane Kruger.'),
(24, N'Mẹ Mìn: Giao Kèo Với Quỷ', 112, N'Giật Gân, Tâm Lý', N'T18', N'Đang chiếu', '2026-11-25', N'me-min.jpg', N'Phim Việt Nam của đạo diễn Jack Carry On. Diễn viên: Minh Hằng, Nhật Kim Anh, Khương Lê, Rima Thanh Vy. Suất chiếu sớm 25-26/11.'),
(25, N'Hexed: Thế Giới Phép Thuật', 110, N'Hoạt Hình, Gia Đình, Hài', N'P', N'Đang chiếu', '2026-11-27', N'hexed.jpg', N'Phim hoạt hình Mỹ của Walt Disney Pictures, đạo diễn Jason Hand và Fawn Veerasunthorn. Lồng tiếng: Hailee Steinfeld, Rashida Jones.'),
(26, N'Gặp Gỡ Thông Gia: Dâu Mới Trình Làng', 106, N'Hài, Gia Đình', N'T13', N'Đang chiếu', '2026-11-27', N'focker-in-law.jpg', N'Phim Mỹ của đạo diễn John Hamburg. Diễn viên: Robert De Niro, Ben Stiller, Ariana Grande.'),
(27, N'Bắt Cá Ba Tay', 115, N'Tình Cảm, Hài', N'T13', N'Sắp chiếu', '2026-12-04', N'bat-ca-ba-tay.jpg', N'Phim Việt Nam của đạo diễn Như Trang. Diễn viên: Thúy Ngân, Steven Nguyễn, Ngô Kiến Huy, Otis.'),
(28, N'Con Mắt Thứ Ba', 100, N'Kinh Dị', N'T18', N'Sắp chiếu', '2026-12-04', N'con-mat-thu-ba.jpg', N'Phim Việt Nam của đạo diễn Hàm Trần. Diễn viên: Minh Anh, Quang Tuấn, Trần Nghĩa, Ngọc Phước.');
SET IDENTITY_INSERT MOVIE OFF;

-- ===== ROOM =====
SET IDENTITY_INSERT ROOM ON;
INSERT INTO ROOM (RoomID, RoomName, RoomType, NumRows, SeatsPerRow) VALUES
(1, N'Phòng 1', N'2D', 9, 12),
(2, N'Phòng 2', N'2D', 9, 12),
(3, N'Phòng 3', N'2D', 9, 12),
(4, N'Phòng 4', N'3D', 9, 12),
(5, N'Phòng 5', N'IMAX', 11, 12);
SET IDENTITY_INSERT ROOM OFF;

-- ===== SEAT: 12 ghe/hang, hang thuong -> VIP -> hang ghe doi cuoi phong (moi cap = 2 ghe) =====
SET IDENTITY_INSERT SEAT ON;
-- Phòng 1 (2D): ghe 1 -> 108
INSERT INTO SEAT (SeatID, RoomID, RowLabel, SeatNumber, SeatType) VALUES
(1, 1, N'A', 1, N'Standard'),
(2, 1, N'A', 2, N'Standard'),
(3, 1, N'A', 3, N'Standard'),
(4, 1, N'A', 4, N'Standard'),
(5, 1, N'A', 5, N'Standard'),
(6, 1, N'A', 6, N'Standard'),
(7, 1, N'A', 7, N'Standard'),
(8, 1, N'A', 8, N'Standard'),
(9, 1, N'A', 9, N'Standard'),
(10, 1, N'A', 10, N'Standard'),
(11, 1, N'A', 11, N'Standard'),
(12, 1, N'A', 12, N'Standard'),
(13, 1, N'B', 1, N'Standard'),
(14, 1, N'B', 2, N'Standard'),
(15, 1, N'B', 3, N'Standard'),
(16, 1, N'B', 4, N'Standard'),
(17, 1, N'B', 5, N'Standard'),
(18, 1, N'B', 6, N'Standard'),
(19, 1, N'B', 7, N'Standard'),
(20, 1, N'B', 8, N'Standard'),
(21, 1, N'B', 9, N'Standard'),
(22, 1, N'B', 10, N'Standard'),
(23, 1, N'B', 11, N'Standard'),
(24, 1, N'B', 12, N'Standard'),
(25, 1, N'C', 1, N'Standard'),
(26, 1, N'C', 2, N'Standard'),
(27, 1, N'C', 3, N'Standard'),
(28, 1, N'C', 4, N'Standard'),
(29, 1, N'C', 5, N'Standard'),
(30, 1, N'C', 6, N'Standard'),
(31, 1, N'C', 7, N'Standard'),
(32, 1, N'C', 8, N'Standard'),
(33, 1, N'C', 9, N'Standard'),
(34, 1, N'C', 10, N'Standard'),
(35, 1, N'C', 11, N'Standard'),
(36, 1, N'C', 12, N'Standard'),
(37, 1, N'D', 1, N'Vip'),
(38, 1, N'D', 2, N'Vip'),
(39, 1, N'D', 3, N'Vip'),
(40, 1, N'D', 4, N'Vip'),
(41, 1, N'D', 5, N'Vip'),
(42, 1, N'D', 6, N'Vip'),
(43, 1, N'D', 7, N'Vip'),
(44, 1, N'D', 8, N'Vip'),
(45, 1, N'D', 9, N'Vip'),
(46, 1, N'D', 10, N'Vip'),
(47, 1, N'D', 11, N'Vip'),
(48, 1, N'D', 12, N'Vip'),
(49, 1, N'E', 1, N'Vip'),
(50, 1, N'E', 2, N'Vip'),
(51, 1, N'E', 3, N'Vip'),
(52, 1, N'E', 4, N'Vip'),
(53, 1, N'E', 5, N'Vip'),
(54, 1, N'E', 6, N'Vip'),
(55, 1, N'E', 7, N'Vip'),
(56, 1, N'E', 8, N'Vip'),
(57, 1, N'E', 9, N'Vip'),
(58, 1, N'E', 10, N'Vip'),
(59, 1, N'E', 11, N'Vip'),
(60, 1, N'E', 12, N'Vip'),
(61, 1, N'F', 1, N'Vip'),
(62, 1, N'F', 2, N'Vip'),
(63, 1, N'F', 3, N'Vip'),
(64, 1, N'F', 4, N'Vip'),
(65, 1, N'F', 5, N'Vip'),
(66, 1, N'F', 6, N'Vip'),
(67, 1, N'F', 7, N'Vip'),
(68, 1, N'F', 8, N'Vip'),
(69, 1, N'F', 9, N'Vip'),
(70, 1, N'F', 10, N'Vip'),
(71, 1, N'F', 11, N'Vip'),
(72, 1, N'F', 12, N'Vip'),
(73, 1, N'G', 1, N'Vip'),
(74, 1, N'G', 2, N'Vip'),
(75, 1, N'G', 3, N'Vip'),
(76, 1, N'G', 4, N'Vip'),
(77, 1, N'G', 5, N'Vip'),
(78, 1, N'G', 6, N'Vip'),
(79, 1, N'G', 7, N'Vip'),
(80, 1, N'G', 8, N'Vip'),
(81, 1, N'G', 9, N'Vip'),
(82, 1, N'G', 10, N'Vip'),
(83, 1, N'G', 11, N'Vip'),
(84, 1, N'G', 12, N'Vip'),
(85, 1, N'H', 1, N'Vip'),
(86, 1, N'H', 2, N'Vip'),
(87, 1, N'H', 3, N'Vip'),
(88, 1, N'H', 4, N'Vip'),
(89, 1, N'H', 5, N'Vip'),
(90, 1, N'H', 6, N'Vip'),
(91, 1, N'H', 7, N'Vip'),
(92, 1, N'H', 8, N'Vip'),
(93, 1, N'H', 9, N'Vip'),
(94, 1, N'H', 10, N'Vip'),
(95, 1, N'H', 11, N'Vip'),
(96, 1, N'H', 12, N'Vip'),
(97, 1, N'J', 1, N'Couple'),
(98, 1, N'J', 2, N'Couple'),
(99, 1, N'J', 3, N'Couple'),
(100, 1, N'J', 4, N'Couple'),
(101, 1, N'J', 5, N'Couple'),
(102, 1, N'J', 6, N'Couple'),
(103, 1, N'J', 7, N'Couple'),
(104, 1, N'J', 8, N'Couple'),
(105, 1, N'J', 9, N'Couple'),
(106, 1, N'J', 10, N'Couple'),
(107, 1, N'J', 11, N'Couple'),
(108, 1, N'J', 12, N'Couple');
-- Phòng 2 (2D): ghe 109 -> 216
INSERT INTO SEAT (SeatID, RoomID, RowLabel, SeatNumber, SeatType) VALUES
(109, 2, N'A', 1, N'Standard'),
(110, 2, N'A', 2, N'Standard'),
(111, 2, N'A', 3, N'Standard'),
(112, 2, N'A', 4, N'Standard'),
(113, 2, N'A', 5, N'Standard'),
(114, 2, N'A', 6, N'Standard'),
(115, 2, N'A', 7, N'Standard'),
(116, 2, N'A', 8, N'Standard'),
(117, 2, N'A', 9, N'Standard'),
(118, 2, N'A', 10, N'Standard'),
(119, 2, N'A', 11, N'Standard'),
(120, 2, N'A', 12, N'Standard'),
(121, 2, N'B', 1, N'Standard'),
(122, 2, N'B', 2, N'Standard'),
(123, 2, N'B', 3, N'Standard'),
(124, 2, N'B', 4, N'Standard'),
(125, 2, N'B', 5, N'Standard'),
(126, 2, N'B', 6, N'Standard'),
(127, 2, N'B', 7, N'Standard'),
(128, 2, N'B', 8, N'Standard'),
(129, 2, N'B', 9, N'Standard'),
(130, 2, N'B', 10, N'Standard'),
(131, 2, N'B', 11, N'Standard'),
(132, 2, N'B', 12, N'Standard'),
(133, 2, N'C', 1, N'Standard'),
(134, 2, N'C', 2, N'Standard'),
(135, 2, N'C', 3, N'Standard'),
(136, 2, N'C', 4, N'Standard'),
(137, 2, N'C', 5, N'Standard'),
(138, 2, N'C', 6, N'Standard'),
(139, 2, N'C', 7, N'Standard'),
(140, 2, N'C', 8, N'Standard'),
(141, 2, N'C', 9, N'Standard'),
(142, 2, N'C', 10, N'Standard'),
(143, 2, N'C', 11, N'Standard'),
(144, 2, N'C', 12, N'Standard'),
(145, 2, N'D', 1, N'Vip'),
(146, 2, N'D', 2, N'Vip'),
(147, 2, N'D', 3, N'Vip'),
(148, 2, N'D', 4, N'Vip'),
(149, 2, N'D', 5, N'Vip'),
(150, 2, N'D', 6, N'Vip'),
(151, 2, N'D', 7, N'Vip'),
(152, 2, N'D', 8, N'Vip'),
(153, 2, N'D', 9, N'Vip'),
(154, 2, N'D', 10, N'Vip'),
(155, 2, N'D', 11, N'Vip'),
(156, 2, N'D', 12, N'Vip'),
(157, 2, N'E', 1, N'Vip'),
(158, 2, N'E', 2, N'Vip'),
(159, 2, N'E', 3, N'Vip'),
(160, 2, N'E', 4, N'Vip'),
(161, 2, N'E', 5, N'Vip'),
(162, 2, N'E', 6, N'Vip'),
(163, 2, N'E', 7, N'Vip'),
(164, 2, N'E', 8, N'Vip'),
(165, 2, N'E', 9, N'Vip'),
(166, 2, N'E', 10, N'Vip'),
(167, 2, N'E', 11, N'Vip'),
(168, 2, N'E', 12, N'Vip'),
(169, 2, N'F', 1, N'Vip'),
(170, 2, N'F', 2, N'Vip'),
(171, 2, N'F', 3, N'Vip'),
(172, 2, N'F', 4, N'Vip'),
(173, 2, N'F', 5, N'Vip'),
(174, 2, N'F', 6, N'Vip'),
(175, 2, N'F', 7, N'Vip'),
(176, 2, N'F', 8, N'Vip'),
(177, 2, N'F', 9, N'Vip'),
(178, 2, N'F', 10, N'Vip'),
(179, 2, N'F', 11, N'Vip'),
(180, 2, N'F', 12, N'Vip'),
(181, 2, N'G', 1, N'Vip'),
(182, 2, N'G', 2, N'Vip'),
(183, 2, N'G', 3, N'Vip'),
(184, 2, N'G', 4, N'Vip'),
(185, 2, N'G', 5, N'Vip'),
(186, 2, N'G', 6, N'Vip'),
(187, 2, N'G', 7, N'Vip'),
(188, 2, N'G', 8, N'Vip'),
(189, 2, N'G', 9, N'Vip'),
(190, 2, N'G', 10, N'Vip'),
(191, 2, N'G', 11, N'Vip'),
(192, 2, N'G', 12, N'Vip'),
(193, 2, N'H', 1, N'Vip'),
(194, 2, N'H', 2, N'Vip'),
(195, 2, N'H', 3, N'Vip'),
(196, 2, N'H', 4, N'Vip'),
(197, 2, N'H', 5, N'Vip'),
(198, 2, N'H', 6, N'Vip'),
(199, 2, N'H', 7, N'Vip'),
(200, 2, N'H', 8, N'Vip'),
(201, 2, N'H', 9, N'Vip'),
(202, 2, N'H', 10, N'Vip'),
(203, 2, N'H', 11, N'Vip'),
(204, 2, N'H', 12, N'Vip'),
(205, 2, N'J', 1, N'Couple'),
(206, 2, N'J', 2, N'Couple'),
(207, 2, N'J', 3, N'Couple'),
(208, 2, N'J', 4, N'Couple'),
(209, 2, N'J', 5, N'Couple'),
(210, 2, N'J', 6, N'Couple'),
(211, 2, N'J', 7, N'Couple'),
(212, 2, N'J', 8, N'Couple'),
(213, 2, N'J', 9, N'Couple'),
(214, 2, N'J', 10, N'Couple'),
(215, 2, N'J', 11, N'Couple'),
(216, 2, N'J', 12, N'Couple');
-- Phòng 3 (2D): ghe 217 -> 324
INSERT INTO SEAT (SeatID, RoomID, RowLabel, SeatNumber, SeatType) VALUES
(217, 3, N'A', 1, N'Standard'),
(218, 3, N'A', 2, N'Standard'),
(219, 3, N'A', 3, N'Standard'),
(220, 3, N'A', 4, N'Standard'),
(221, 3, N'A', 5, N'Standard'),
(222, 3, N'A', 6, N'Standard'),
(223, 3, N'A', 7, N'Standard'),
(224, 3, N'A', 8, N'Standard'),
(225, 3, N'A', 9, N'Standard'),
(226, 3, N'A', 10, N'Standard'),
(227, 3, N'A', 11, N'Standard'),
(228, 3, N'A', 12, N'Standard'),
(229, 3, N'B', 1, N'Standard'),
(230, 3, N'B', 2, N'Standard'),
(231, 3, N'B', 3, N'Standard'),
(232, 3, N'B', 4, N'Standard'),
(233, 3, N'B', 5, N'Standard'),
(234, 3, N'B', 6, N'Standard'),
(235, 3, N'B', 7, N'Standard'),
(236, 3, N'B', 8, N'Standard'),
(237, 3, N'B', 9, N'Standard'),
(238, 3, N'B', 10, N'Standard'),
(239, 3, N'B', 11, N'Standard'),
(240, 3, N'B', 12, N'Standard'),
(241, 3, N'C', 1, N'Standard'),
(242, 3, N'C', 2, N'Standard'),
(243, 3, N'C', 3, N'Standard'),
(244, 3, N'C', 4, N'Standard'),
(245, 3, N'C', 5, N'Standard'),
(246, 3, N'C', 6, N'Standard'),
(247, 3, N'C', 7, N'Standard'),
(248, 3, N'C', 8, N'Standard'),
(249, 3, N'C', 9, N'Standard'),
(250, 3, N'C', 10, N'Standard'),
(251, 3, N'C', 11, N'Standard'),
(252, 3, N'C', 12, N'Standard'),
(253, 3, N'D', 1, N'Vip'),
(254, 3, N'D', 2, N'Vip'),
(255, 3, N'D', 3, N'Vip'),
(256, 3, N'D', 4, N'Vip'),
(257, 3, N'D', 5, N'Vip'),
(258, 3, N'D', 6, N'Vip'),
(259, 3, N'D', 7, N'Vip'),
(260, 3, N'D', 8, N'Vip'),
(261, 3, N'D', 9, N'Vip'),
(262, 3, N'D', 10, N'Vip'),
(263, 3, N'D', 11, N'Vip'),
(264, 3, N'D', 12, N'Vip'),
(265, 3, N'E', 1, N'Vip'),
(266, 3, N'E', 2, N'Vip'),
(267, 3, N'E', 3, N'Vip'),
(268, 3, N'E', 4, N'Vip'),
(269, 3, N'E', 5, N'Vip'),
(270, 3, N'E', 6, N'Vip'),
(271, 3, N'E', 7, N'Vip'),
(272, 3, N'E', 8, N'Vip'),
(273, 3, N'E', 9, N'Vip'),
(274, 3, N'E', 10, N'Vip'),
(275, 3, N'E', 11, N'Vip'),
(276, 3, N'E', 12, N'Vip'),
(277, 3, N'F', 1, N'Vip'),
(278, 3, N'F', 2, N'Vip'),
(279, 3, N'F', 3, N'Vip'),
(280, 3, N'F', 4, N'Vip'),
(281, 3, N'F', 5, N'Vip'),
(282, 3, N'F', 6, N'Vip'),
(283, 3, N'F', 7, N'Vip'),
(284, 3, N'F', 8, N'Vip'),
(285, 3, N'F', 9, N'Vip'),
(286, 3, N'F', 10, N'Vip'),
(287, 3, N'F', 11, N'Vip'),
(288, 3, N'F', 12, N'Vip'),
(289, 3, N'G', 1, N'Vip'),
(290, 3, N'G', 2, N'Vip'),
(291, 3, N'G', 3, N'Vip'),
(292, 3, N'G', 4, N'Vip'),
(293, 3, N'G', 5, N'Vip'),
(294, 3, N'G', 6, N'Vip'),
(295, 3, N'G', 7, N'Vip'),
(296, 3, N'G', 8, N'Vip'),
(297, 3, N'G', 9, N'Vip'),
(298, 3, N'G', 10, N'Vip'),
(299, 3, N'G', 11, N'Vip'),
(300, 3, N'G', 12, N'Vip'),
(301, 3, N'H', 1, N'Vip'),
(302, 3, N'H', 2, N'Vip'),
(303, 3, N'H', 3, N'Vip'),
(304, 3, N'H', 4, N'Vip'),
(305, 3, N'H', 5, N'Vip'),
(306, 3, N'H', 6, N'Vip'),
(307, 3, N'H', 7, N'Vip'),
(308, 3, N'H', 8, N'Vip'),
(309, 3, N'H', 9, N'Vip'),
(310, 3, N'H', 10, N'Vip'),
(311, 3, N'H', 11, N'Vip'),
(312, 3, N'H', 12, N'Vip'),
(313, 3, N'J', 1, N'Couple'),
(314, 3, N'J', 2, N'Couple'),
(315, 3, N'J', 3, N'Couple'),
(316, 3, N'J', 4, N'Couple'),
(317, 3, N'J', 5, N'Couple'),
(318, 3, N'J', 6, N'Couple'),
(319, 3, N'J', 7, N'Couple'),
(320, 3, N'J', 8, N'Couple'),
(321, 3, N'J', 9, N'Couple'),
(322, 3, N'J', 10, N'Couple'),
(323, 3, N'J', 11, N'Couple'),
(324, 3, N'J', 12, N'Couple');
-- Phòng 4 (3D): ghe 325 -> 432
INSERT INTO SEAT (SeatID, RoomID, RowLabel, SeatNumber, SeatType) VALUES
(325, 4, N'A', 1, N'Standard'),
(326, 4, N'A', 2, N'Standard'),
(327, 4, N'A', 3, N'Standard'),
(328, 4, N'A', 4, N'Standard'),
(329, 4, N'A', 5, N'Standard'),
(330, 4, N'A', 6, N'Standard'),
(331, 4, N'A', 7, N'Standard'),
(332, 4, N'A', 8, N'Standard'),
(333, 4, N'A', 9, N'Standard'),
(334, 4, N'A', 10, N'Standard'),
(335, 4, N'A', 11, N'Standard'),
(336, 4, N'A', 12, N'Standard'),
(337, 4, N'B', 1, N'Standard'),
(338, 4, N'B', 2, N'Standard'),
(339, 4, N'B', 3, N'Standard'),
(340, 4, N'B', 4, N'Standard'),
(341, 4, N'B', 5, N'Standard'),
(342, 4, N'B', 6, N'Standard'),
(343, 4, N'B', 7, N'Standard'),
(344, 4, N'B', 8, N'Standard'),
(345, 4, N'B', 9, N'Standard'),
(346, 4, N'B', 10, N'Standard'),
(347, 4, N'B', 11, N'Standard'),
(348, 4, N'B', 12, N'Standard'),
(349, 4, N'C', 1, N'Standard'),
(350, 4, N'C', 2, N'Standard'),
(351, 4, N'C', 3, N'Standard'),
(352, 4, N'C', 4, N'Standard'),
(353, 4, N'C', 5, N'Standard'),
(354, 4, N'C', 6, N'Standard'),
(355, 4, N'C', 7, N'Standard'),
(356, 4, N'C', 8, N'Standard'),
(357, 4, N'C', 9, N'Standard'),
(358, 4, N'C', 10, N'Standard'),
(359, 4, N'C', 11, N'Standard'),
(360, 4, N'C', 12, N'Standard'),
(361, 4, N'D', 1, N'Vip'),
(362, 4, N'D', 2, N'Vip'),
(363, 4, N'D', 3, N'Vip'),
(364, 4, N'D', 4, N'Vip'),
(365, 4, N'D', 5, N'Vip'),
(366, 4, N'D', 6, N'Vip'),
(367, 4, N'D', 7, N'Vip'),
(368, 4, N'D', 8, N'Vip'),
(369, 4, N'D', 9, N'Vip'),
(370, 4, N'D', 10, N'Vip'),
(371, 4, N'D', 11, N'Vip'),
(372, 4, N'D', 12, N'Vip'),
(373, 4, N'E', 1, N'Vip'),
(374, 4, N'E', 2, N'Vip'),
(375, 4, N'E', 3, N'Vip'),
(376, 4, N'E', 4, N'Vip'),
(377, 4, N'E', 5, N'Vip'),
(378, 4, N'E', 6, N'Vip'),
(379, 4, N'E', 7, N'Vip'),
(380, 4, N'E', 8, N'Vip'),
(381, 4, N'E', 9, N'Vip'),
(382, 4, N'E', 10, N'Vip'),
(383, 4, N'E', 11, N'Vip'),
(384, 4, N'E', 12, N'Vip'),
(385, 4, N'F', 1, N'Vip'),
(386, 4, N'F', 2, N'Vip'),
(387, 4, N'F', 3, N'Vip'),
(388, 4, N'F', 4, N'Vip'),
(389, 4, N'F', 5, N'Vip'),
(390, 4, N'F', 6, N'Vip'),
(391, 4, N'F', 7, N'Vip'),
(392, 4, N'F', 8, N'Vip'),
(393, 4, N'F', 9, N'Vip'),
(394, 4, N'F', 10, N'Vip'),
(395, 4, N'F', 11, N'Vip'),
(396, 4, N'F', 12, N'Vip'),
(397, 4, N'G', 1, N'Vip'),
(398, 4, N'G', 2, N'Vip'),
(399, 4, N'G', 3, N'Vip'),
(400, 4, N'G', 4, N'Vip'),
(401, 4, N'G', 5, N'Vip'),
(402, 4, N'G', 6, N'Vip'),
(403, 4, N'G', 7, N'Vip'),
(404, 4, N'G', 8, N'Vip'),
(405, 4, N'G', 9, N'Vip'),
(406, 4, N'G', 10, N'Vip'),
(407, 4, N'G', 11, N'Vip'),
(408, 4, N'G', 12, N'Vip'),
(409, 4, N'H', 1, N'Vip'),
(410, 4, N'H', 2, N'Vip'),
(411, 4, N'H', 3, N'Vip'),
(412, 4, N'H', 4, N'Vip'),
(413, 4, N'H', 5, N'Vip'),
(414, 4, N'H', 6, N'Vip'),
(415, 4, N'H', 7, N'Vip'),
(416, 4, N'H', 8, N'Vip'),
(417, 4, N'H', 9, N'Vip'),
(418, 4, N'H', 10, N'Vip'),
(419, 4, N'H', 11, N'Vip'),
(420, 4, N'H', 12, N'Vip'),
(421, 4, N'J', 1, N'Couple'),
(422, 4, N'J', 2, N'Couple'),
(423, 4, N'J', 3, N'Couple'),
(424, 4, N'J', 4, N'Couple'),
(425, 4, N'J', 5, N'Couple'),
(426, 4, N'J', 6, N'Couple'),
(427, 4, N'J', 7, N'Couple'),
(428, 4, N'J', 8, N'Couple'),
(429, 4, N'J', 9, N'Couple'),
(430, 4, N'J', 10, N'Couple'),
(431, 4, N'J', 11, N'Couple'),
(432, 4, N'J', 12, N'Couple');
-- Phòng 5 (IMAX): ghe 433 -> 564
INSERT INTO SEAT (SeatID, RoomID, RowLabel, SeatNumber, SeatType) VALUES
(433, 5, N'A', 1, N'Standard'),
(434, 5, N'A', 2, N'Standard'),
(435, 5, N'A', 3, N'Standard'),
(436, 5, N'A', 4, N'Standard'),
(437, 5, N'A', 5, N'Standard'),
(438, 5, N'A', 6, N'Standard'),
(439, 5, N'A', 7, N'Standard'),
(440, 5, N'A', 8, N'Standard'),
(441, 5, N'A', 9, N'Standard'),
(442, 5, N'A', 10, N'Standard'),
(443, 5, N'A', 11, N'Standard'),
(444, 5, N'A', 12, N'Standard'),
(445, 5, N'B', 1, N'Standard'),
(446, 5, N'B', 2, N'Standard'),
(447, 5, N'B', 3, N'Standard'),
(448, 5, N'B', 4, N'Standard'),
(449, 5, N'B', 5, N'Standard'),
(450, 5, N'B', 6, N'Standard'),
(451, 5, N'B', 7, N'Standard'),
(452, 5, N'B', 8, N'Standard'),
(453, 5, N'B', 9, N'Standard'),
(454, 5, N'B', 10, N'Standard'),
(455, 5, N'B', 11, N'Standard'),
(456, 5, N'B', 12, N'Standard'),
(457, 5, N'C', 1, N'Standard'),
(458, 5, N'C', 2, N'Standard'),
(459, 5, N'C', 3, N'Standard'),
(460, 5, N'C', 4, N'Standard'),
(461, 5, N'C', 5, N'Standard'),
(462, 5, N'C', 6, N'Standard'),
(463, 5, N'C', 7, N'Standard'),
(464, 5, N'C', 8, N'Standard'),
(465, 5, N'C', 9, N'Standard'),
(466, 5, N'C', 10, N'Standard'),
(467, 5, N'C', 11, N'Standard'),
(468, 5, N'C', 12, N'Standard'),
(469, 5, N'D', 1, N'Standard'),
(470, 5, N'D', 2, N'Standard'),
(471, 5, N'D', 3, N'Standard'),
(472, 5, N'D', 4, N'Standard'),
(473, 5, N'D', 5, N'Standard'),
(474, 5, N'D', 6, N'Standard'),
(475, 5, N'D', 7, N'Standard'),
(476, 5, N'D', 8, N'Standard'),
(477, 5, N'D', 9, N'Standard'),
(478, 5, N'D', 10, N'Standard'),
(479, 5, N'D', 11, N'Standard'),
(480, 5, N'D', 12, N'Standard'),
(481, 5, N'E', 1, N'Vip'),
(482, 5, N'E', 2, N'Vip'),
(483, 5, N'E', 3, N'Vip'),
(484, 5, N'E', 4, N'Vip'),
(485, 5, N'E', 5, N'Vip'),
(486, 5, N'E', 6, N'Vip'),
(487, 5, N'E', 7, N'Vip'),
(488, 5, N'E', 8, N'Vip'),
(489, 5, N'E', 9, N'Vip'),
(490, 5, N'E', 10, N'Vip'),
(491, 5, N'E', 11, N'Vip'),
(492, 5, N'E', 12, N'Vip'),
(493, 5, N'F', 1, N'Vip'),
(494, 5, N'F', 2, N'Vip'),
(495, 5, N'F', 3, N'Vip'),
(496, 5, N'F', 4, N'Vip'),
(497, 5, N'F', 5, N'Vip'),
(498, 5, N'F', 6, N'Vip'),
(499, 5, N'F', 7, N'Vip'),
(500, 5, N'F', 8, N'Vip'),
(501, 5, N'F', 9, N'Vip'),
(502, 5, N'F', 10, N'Vip'),
(503, 5, N'F', 11, N'Vip'),
(504, 5, N'F', 12, N'Vip'),
(505, 5, N'G', 1, N'Vip'),
(506, 5, N'G', 2, N'Vip'),
(507, 5, N'G', 3, N'Vip'),
(508, 5, N'G', 4, N'Vip'),
(509, 5, N'G', 5, N'Vip'),
(510, 5, N'G', 6, N'Vip'),
(511, 5, N'G', 7, N'Vip'),
(512, 5, N'G', 8, N'Vip'),
(513, 5, N'G', 9, N'Vip'),
(514, 5, N'G', 10, N'Vip'),
(515, 5, N'G', 11, N'Vip'),
(516, 5, N'G', 12, N'Vip'),
(517, 5, N'H', 1, N'Vip'),
(518, 5, N'H', 2, N'Vip'),
(519, 5, N'H', 3, N'Vip'),
(520, 5, N'H', 4, N'Vip'),
(521, 5, N'H', 5, N'Vip'),
(522, 5, N'H', 6, N'Vip'),
(523, 5, N'H', 7, N'Vip'),
(524, 5, N'H', 8, N'Vip'),
(525, 5, N'H', 9, N'Vip'),
(526, 5, N'H', 10, N'Vip'),
(527, 5, N'H', 11, N'Vip'),
(528, 5, N'H', 12, N'Vip'),
(529, 5, N'J', 1, N'Vip'),
(530, 5, N'J', 2, N'Vip'),
(531, 5, N'J', 3, N'Vip'),
(532, 5, N'J', 4, N'Vip'),
(533, 5, N'J', 5, N'Vip'),
(534, 5, N'J', 6, N'Vip'),
(535, 5, N'J', 7, N'Vip'),
(536, 5, N'J', 8, N'Vip'),
(537, 5, N'J', 9, N'Vip'),
(538, 5, N'J', 10, N'Vip'),
(539, 5, N'J', 11, N'Vip'),
(540, 5, N'J', 12, N'Vip'),
(541, 5, N'K', 1, N'Vip'),
(542, 5, N'K', 2, N'Vip'),
(543, 5, N'K', 3, N'Vip'),
(544, 5, N'K', 4, N'Vip'),
(545, 5, N'K', 5, N'Vip'),
(546, 5, N'K', 6, N'Vip'),
(547, 5, N'K', 7, N'Vip'),
(548, 5, N'K', 8, N'Vip'),
(549, 5, N'K', 9, N'Vip'),
(550, 5, N'K', 10, N'Vip'),
(551, 5, N'K', 11, N'Vip'),
(552, 5, N'K', 12, N'Vip'),
(553, 5, N'L', 1, N'Couple'),
(554, 5, N'L', 2, N'Couple'),
(555, 5, N'L', 3, N'Couple'),
(556, 5, N'L', 4, N'Couple'),
(557, 5, N'L', 5, N'Couple'),
(558, 5, N'L', 6, N'Couple'),
(559, 5, N'L', 7, N'Couple'),
(560, 5, N'L', 8, N'Couple'),
(561, 5, N'L', 9, N'Couple'),
(562, 5, N'L', 10, N'Couple'),
(563, 5, N'L', 11, N'Couple'),
(564, 5, N'L', 12, N'Couple');
SET IDENTITY_INSERT SEAT OFF;

-- ===== CUSTOMER: Points = tong (diem cong - diem dung) cua cac don Paid =====
SET IDENTITY_INSERT CUSTOMER ON;
INSERT INTO CUSTOMER (CustomerID, FullName, Phone, Points) VALUES
(1, N'Nguyễn Văn An', '0901234567', 240), -- hang Vàng, 21 don, chi 4.708.000 d
(2, N'Trần Thị Bình', '0912345678', 55), -- hang Thường, 5 don, chi 858.000 d
(3, N'Lê Hoàng Phúc', '0903111222', 26), -- hang Thường, 2 don, chi 378.000 d
(4, N'Phạm Minh Thư', '0938222333', 10), -- hang Thường, 3 don, chi 524.000 d
(5, N'Đỗ Gia Huy', '0977333444', 63), -- hang Thường, 5 don, chi 888.000 d
(6, N'Hoàng Bảo Ngọc', '0965444555', 139), -- hang Bạc, 6 don, chi 2.244.000 d
(7, N'Bùi Thanh Tùng', '0889555666', 0), -- hang Thường, 0 don, chi 0 d
(8, N'Vũ Khánh Linh', '0326666777', 80), -- hang Bạc, 8 don, chi 1.669.000 d
(9, N'Ngô Đức Mạnh', '0357777888', 120), -- hang Bạc, 9 don, chi 1.824.000 d
(10, N'Đặng Mỹ Duyên', '0703888999', 41), -- hang Thường, 2 don, chi 504.000 d
(11, N'Huỳnh Tấn Phát', '0796999000', 0), -- hang Thường, 0 don, chi 0 d
(12, N'Trương Ngọc Hân', '0848000111', 0), -- hang Thường, 0 don, chi 0 d
(13, N'Đinh Tuấn Lâm', '0814263411', 55), -- hang Thường, 3 don, chi 810.000 d
(14, N'Tạ Thành Cường', '0851208391', 43), -- hang Thường, 2 don, chi 504.000 d
(15, N'Phạm Văn Hào', '0914492664', 51), -- hang Bạc, 12 don, chi 2.788.000 d
(16, N'Hoàng Hoàng Cường', '0781252952', 18), -- hang Thường, 1 don, chi 180.000 d
(17, N'Ngô Phương Thư', '0848746207', 15), -- hang Thường, 3 don, chi 857.000 d
(18, N'Trần Hoài Nhi', '0393387112', 12), -- hang Thường, 1 don, chi 180.000 d
(19, N'Nguyễn Phương Hoa', '0854413995', 32), -- hang Thường, 2 don, chi 510.000 d
(20, N'Tô Tuấn Sơn', '0335886028', 25), -- hang Thường, 3 don, chi 420.000 d
(21, N'Lê Diệu Mai', '0960222181', 306), -- hang Vàng, 29 don, chi 6.111.000 d
(22, N'Dương Nhật Khoa', '0704520200', 59), -- hang Thường, 3 don, chi 864.000 d
(23, N'Nguyễn Gia Phong', '0786738416', 84), -- hang Bạc, 10 don, chi 1.946.000 d
(24, N'Dương Công An', '0343365840', 59), -- hang Thường, 5 don, chi 945.000 d
(25, N'Nguyễn Thị Hà', '0387768392', 218), -- hang Vàng, 34 don, chi 6.421.000 d
(26, N'Nguyễn Công An', '0942680976', 9), -- hang Bạc, 5 don, chi 1.222.000 d
(27, N'Trần Minh Mai', '0774701338', 44), -- hang Thường, 4 don, chi 648.000 d
(28, N'Nguyễn Anh Kiên', '0353092436', 65), -- hang Bạc, 10 don, chi 2.215.000 d
(29, N'Trương Thanh Xuân', '0949363696', 92), -- hang Bạc, 9 don, chi 2.101.000 d
(30, N'Châu Thành Hùng', '0937839677', 152), -- hang Bạc, 9 don, chi 2.268.000 d
(31, N'Trần Anh Bình', '0881996901', 151), -- hang Bạc, 8 don, chi 2.172.000 d
(32, N'Đặng Minh Quỳnh', '0931706049', 97), -- hang Bạc, 7 don, chi 1.515.000 d
(33, N'Nguyễn Đức Phong', '0587632621', 29), -- hang Bạc, 8 don, chi 2.033.000 d
(34, N'Huỳnh Diệu Mai', '0704220764', 33), -- hang Thường, 5 don, chi 877.000 d
(35, N'Châu Thu Nhi', '0381513415', 61), -- hang Thường, 2 don, chi 882.000 d
(36, N'Trần Thu Hiền', '0832145197', 18), -- hang Thường, 4 don, chi 885.000 d
(37, N'Nguyễn Ngọc Giang', '0985437959', 138), -- hang Bạc, 7 don, chi 2.058.000 d
(38, N'Trần Mỹ Vy', '0818834085', 12), -- hang Thường, 1 don, chi 180.000 d
(39, N'Nguyễn Quốc Duy', '0868456990', 31), -- hang Thường, 1 don, chi 450.000 d
(40, N'Võ Phương Oanh', '0399162339', 67), -- hang Thường, 4 don, chi 906.000 d
(41, N'Nguyễn Hoài Hoa', '0371899285', 12), -- hang Thường, 1 don, chi 240.000 d
(42, N'Mai Ngọc Hà', '0938792629', 61), -- hang Vàng, 29 don, chi 6.118.000 d
(43, N'Nguyễn Thanh Nga', '0972115896', 104), -- hang Bạc, 6 don, chi 1.512.000 d
(44, N'Đặng Hữu Nghĩa', '0966276774', 141), -- hang Vàng, 20 don, chi 4.815.000 d
(45, N'Nguyễn Gia Lâm', '0949092207', 32), -- hang Thường, 2 don, chi 468.000 d
(46, N'Đinh Thành Đạt', '0767330801', 10), -- hang Vàng, 16 don, chi 3.563.000 d
(47, N'La Minh Lâm', '0937052052', 136), -- hang Bạc, 7 don, chi 2.160.000 d
(48, N'Đặng Diệu Giang', '0327247579', 62), -- hang Thường, 4 don, chi 900.000 d
(49, N'Lý Minh Huy', '0917509584', 97), -- hang Bạc, 9 don, chi 1.789.000 d
(50, N'Nguyễn Khánh Quỳnh', '0863231884', 43), -- hang Thường, 2 don, chi 702.000 d
(51, N'Hồ Công Đạt', '0853020406', 51), -- hang Thường, 4 don, chi 756.000 d
(52, N'Đinh Nhật Tài', '0587639432', 48), -- hang Thường, 3 don, chi 540.000 d
(53, N'Trương Gia Khang', '0861488737', 50), -- hang Bạc, 8 don, chi 1.974.000 d
(54, N'Châu Mỹ Hà', '0969149390', 71), -- hang Bạc, 7 don, chi 1.582.000 d
(55, N'Lê Quốc Tài', '0919507094', 108), -- hang Bạc, 8 don, chi 2.034.000 d
(56, N'Nguyễn Phương Lan', '0868445638', 54), -- hang Thường, 5 don, chi 873.000 d
(57, N'Hoàng Hoài Diệp', '0796245143', 0), -- hang Thường, 0 don, chi 0 d
(58, N'Hà Đức Khang', '0346697335', 18), -- hang Thường, 2 don, chi 270.000 d
(59, N'Đặng Tuấn Nhân', '0888093242', 70), -- hang Thường, 6 don, chi 903.000 d
(60, N'Hà Gia Dũng', '0323513787', 48), -- hang Bạc, 6 don, chi 1.602.000 d
(61, N'Lê Ngọc Diệp', '0901275571', 30), -- hang Thường, 2 don, chi 420.000 d
(62, N'Nguyễn Công Tâm', '0333806874', 50), -- hang Thường, 3 don, chi 759.000 d
(63, N'Nguyễn Mỹ Trinh', '0567513019', 50), -- hang Thường, 4 don, chi 774.000 d
(64, N'Vũ Đức Lâm', '0399108969', 61), -- hang Thường, 3 don, chi 900.000 d
(65, N'Lê Minh Cường', '0358505412', 43), -- hang Thường, 2 don, chi 651.000 d
(66, N'La Mỹ Yến', '0894706378', 140), -- hang Vàng, 18 don, chi 4.740.000 d
(67, N'Nguyễn Diệu My', '0392500956', 155), -- hang Vàng, 28 don, chi 6.296.000 d
(68, N'Trương Hoài Nga', '0374449454', 106), -- hang Bạc, 7 don, chi 1.599.000 d
(69, N'Trương Quốc Quang', '0861671754', 288), -- hang Vàng, 21 don, chi 4.565.000 d
(70, N'Huỳnh Bảo Thư', '0366388492', 36), -- hang Bạc, 11 don, chi 2.779.000 d
(71, N'Nguyễn Thành Khang', '0858890920', 0), -- hang Thường, 0 don, chi 0 d
(72, N'Nguyễn Quốc Hiếu', '0893766480', 234), -- hang Vàng, 20 don, chi 4.524.000 d
(73, N'Hồ Đức Dũng', '0586617292', 48), -- hang Thường, 3 don, chi 810.000 d
(74, N'Lê Ngọc Hà', '0397122343', 18), -- hang Thường, 1 don, chi 270.000 d
(75, N'Trần Thành Quân', '0918454387', 156), -- hang Bạc, 10 don, chi 2.524.000 d
(76, N'Nguyễn Phương Quỳnh', '0368528695', 25), -- hang Thường, 1 don, chi 360.000 d
(77, N'Lê Tuấn Quân', '0568820521', 277), -- hang Vàng, 18 don, chi 4.251.000 d
(78, N'Lê Diệu Trinh', '0380289672', 172), -- hang Vàng, 13 don, chi 3.460.000 d
(79, N'Nguyễn Công Thiện', '0810139108', 38), -- hang Thường, 4 don, chi 750.000 d
(80, N'Phạm Mỹ Hương', '0373186254', 62), -- hang Bạc, 7 don, chi 1.722.000 d
(81, N'Nguyễn Anh Quân', '0939250524', 27), -- hang Thường, 4 don, chi 894.000 d
(82, N'Nguyễn Công Dũng', '0849069695', 45), -- hang Thường, 3 don, chi 576.000 d
(83, N'Nguyễn Hoài Nhi', '0775901648', 31), -- hang Thường, 3 don, chi 420.000 d
(84, N'Phạm Minh Hào', '0396469734', 0), -- hang Thường, 0 don, chi 0 d
(85, N'Nguyễn Tuấn Hải', '0562662928', 47), -- hang Thường, 3 don, chi 726.000 d
(86, N'La Gia Toàn', '0568338904', 61), -- hang Bạc, 6 don, chi 1.553.000 d
(87, N'Mai Thành Lộc', '0325007223', 54), -- hang Thường, 3 don, chi 855.000 d
(88, N'Trần Mỹ Hạnh', '0348401983', 94), -- hang Bạc, 4 don, chi 1.401.000 d
(89, N'Dương Hữu Lâm', '0797365108', 38), -- hang Bạc, 9 don, chi 1.652.000 d
(90, N'Quách Hoài Hằng', '0896363621', 98), -- hang Bạc, 5 don, chi 1.392.000 d
(91, N'Bùi Thanh Quỳnh', '0798479635', 61), -- hang Thường, 2 don, chi 882.000 d
(92, N'Lê Kim Diệp', '0969079882', 27), -- hang Bạc, 14 don, chi 2.764.000 d
(93, N'Đinh Công Tâm', '0791767281', 61), -- hang Vàng, 29 don, chi 5.967.000 d
(94, N'Tô Thị Oanh', '0914840901', 16), -- hang Bạc, 7 don, chi 1.700.000 d
(95, N'Trần Văn Hải', '0393349183', 17), -- hang Thường, 4 don, chi 809.000 d
(96, N'Đỗ Tuấn An', '0336627076', 53), -- hang Thường, 3 don, chi 774.000 d
(97, N'Dương Kim Thư', '0370882709', 52), -- hang Thường, 4 don, chi 774.000 d
(98, N'Trần Minh Duy', '0793704360', 132), -- hang Bạc, 10 don, chi 2.394.000 d
(99, N'Tô Tuấn Tài', '0895014658', 67), -- hang Thường, 5 don, chi 960.000 d
(100, N'Lê Minh Quân', '0388355678', 30), -- hang Thường, 7 don, chi 927.000 d
(101, N'Trần Quốc Cường', '0762063994', 7), -- hang Thường, 1 don, chi 150.000 d
(102, N'Hoàng Đức Quang', '0856042936', 19), -- hang Thường, 2 don, chi 288.000 d
(103, N'Phạm Diệu Như', '0581884786', 56), -- hang Thường, 4 don, chi 828.000 d
(104, N'Nguyễn Hoài Hạnh', '0772773433', 54), -- hang Thường, 2 don, chi 828.000 d
(105, N'Nguyễn Minh Hằng', '0851247970', 60), -- hang Thường, 1 don, chi 864.000 d
(106, N'Trương Hữu Nghĩa', '0587466481', 36), -- hang Thường, 2 don, chi 432.000 d
(107, N'Lê Gia Tài', '0864725861', 33), -- hang Thường, 5 don, chi 894.000 d
(108, N'Hà Hoài Như', '0830062560', 69), -- hang Vàng, 23 don, chi 5.435.000 d
(109, N'Vũ Ngọc Như', '0862515863', 125), -- hang Bạc, 8 don, chi 1.974.000 d
(110, N'Tạ Minh Sơn', '0762293872', 38), -- hang Thường, 5 don, chi 914.000 d
(111, N'Phạm Thu Quyên', '0779260359', 38), -- hang Thường, 3 don, chi 600.000 d
(112, N'Võ Nhật Vũ', '0708559331', 12), -- hang Thường, 2 don, chi 180.000 d
(113, N'Huỳnh Quốc Nghĩa', '0940640914', 106), -- hang Vàng, 24 don, chi 5.855.000 d
(114, N'Tạ Thành Nhân', '0907226093', 77), -- hang Bạc, 10 don, chi 2.068.000 d
(115, N'Hà Minh Tài', '0855405869', 59), -- hang Thường, 4 don, chi 885.000 d
(116, N'Tô Khánh Trang', '0324579058', 70), -- hang Thường, 5 don, chi 954.000 d
(117, N'Dương Thị Như', '0986260773', 95), -- hang Vàng, 20 don, chi 4.549.000 d
(118, N'Nguyễn Kim Quyên', '0327381914', 60), -- hang Thường, 4 don, chi 810.000 d
(119, N'Phạm Thị Hiền', '0918070394', 27), -- hang Thường, 2 don, chi 396.000 d
(120, N'Phạm Đức Nghĩa', '0385094967', 123); -- hang Bạc, 8 don, chi 2.376.000 d
SET IDENTITY_INSERT CUSTOMER OFF;

-- ===== SHOWTIME: lich chieu tung ngay, da tinh 15 phut don phong =====
SET IDENTITY_INSERT SHOWTIME ON;
-- Thứ 3 10/11/2026: 28 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(1, 14, 1, '2026-11-10T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(2, 3, 5, '2026-11-10T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(3, 6, 4, '2026-11-10T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(4, 16, 2, '2026-11-10T09:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(5, 13, 3, '2026-11-10T09:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(6, 5, 1, '2026-11-10T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(7, 12, 2, '2026-11-10T11:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(8, 15, 3, '2026-11-10T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(9, 6, 5, '2026-11-10T11:45:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Ramayana: Khởi Nguồn Một Huyền Thoại
(10, 3, 4, '2026-11-10T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(11, 14, 1, '2026-11-10T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(12, 16, 2, '2026-11-10T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(13, 13, 3, '2026-11-10T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(14, 3, 5, '2026-11-10T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(15, 6, 4, '2026-11-10T15:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(16, 17, 2, '2026-11-10T15:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(17, 15, 3, '2026-11-10T15:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(18, 5, 1, '2026-11-10T16:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(19, 6, 5, '2026-11-10T17:45:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Ramayana: Khởi Nguồn Một Huyền Thoại
(20, 13, 3, '2026-11-10T18:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(21, 14, 1, '2026-11-10T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(22, 13, 2, '2026-11-10T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thiên Đường Tăm Tối
(23, 3, 4, '2026-11-10T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(24, 15, 3, '2026-11-10T20:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(25, 5, 1, '2026-11-10T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(26, 17, 2, '2026-11-10T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(27, 14, 4, '2026-11-10T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bò Sữa Bay
(28, 3, 5, '2026-11-10T21:00:00', N'IMAX', N'Phụ đề', 120000); -- Phòng 5 | Godzilla Trừ Không
-- Thứ 4 11/11/2026: 28 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(29, 14, 1, '2026-11-11T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(30, 3, 5, '2026-11-11T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(31, 6, 4, '2026-11-11T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(32, 16, 2, '2026-11-11T09:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(33, 13, 3, '2026-11-11T09:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(34, 2, 1, '2026-11-11T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(35, 12, 2, '2026-11-11T11:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(36, 15, 3, '2026-11-11T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(37, 6, 5, '2026-11-11T11:45:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Ramayana: Khởi Nguồn Một Huyền Thoại
(38, 3, 4, '2026-11-11T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(39, 14, 1, '2026-11-11T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(40, 16, 2, '2026-11-11T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(41, 13, 3, '2026-11-11T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(42, 3, 5, '2026-11-11T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(43, 6, 4, '2026-11-11T15:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(44, 17, 2, '2026-11-11T15:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(45, 15, 3, '2026-11-11T15:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(46, 2, 1, '2026-11-11T16:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(47, 6, 5, '2026-11-11T17:45:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Ramayana: Khởi Nguồn Một Huyền Thoại
(48, 13, 3, '2026-11-11T18:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(49, 14, 1, '2026-11-11T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(50, 11, 2, '2026-11-11T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(51, 3, 4, '2026-11-11T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(52, 15, 3, '2026-11-11T20:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(53, 5, 1, '2026-11-11T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(54, 17, 2, '2026-11-11T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(55, 14, 4, '2026-11-11T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bò Sữa Bay
(56, 3, 5, '2026-11-11T21:00:00', N'IMAX', N'Phụ đề', 120000); -- Phòng 5 | Godzilla Trừ Không
-- Thứ 5 12/11/2026: 28 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(57, 14, 1, '2026-11-12T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(58, 3, 5, '2026-11-12T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(59, 6, 4, '2026-11-12T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(60, 16, 2, '2026-11-12T09:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(61, 13, 3, '2026-11-12T09:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(62, 2, 1, '2026-11-12T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(63, 12, 2, '2026-11-12T11:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(64, 15, 3, '2026-11-12T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(65, 6, 5, '2026-11-12T11:45:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Ramayana: Khởi Nguồn Một Huyền Thoại
(66, 3, 4, '2026-11-12T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(67, 14, 1, '2026-11-12T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(68, 16, 2, '2026-11-12T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(69, 13, 3, '2026-11-12T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(70, 3, 5, '2026-11-12T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(71, 6, 4, '2026-11-12T15:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(72, 17, 2, '2026-11-12T15:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(73, 4, 3, '2026-11-12T15:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(74, 2, 1, '2026-11-12T16:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(75, 6, 5, '2026-11-12T17:45:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Ramayana: Khởi Nguồn Một Huyền Thoại
(76, 13, 3, '2026-11-12T18:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(77, 14, 1, '2026-11-12T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(78, 11, 2, '2026-11-12T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(79, 3, 4, '2026-11-12T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(80, 15, 3, '2026-11-12T20:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(81, 5, 1, '2026-11-12T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(82, 17, 2, '2026-11-12T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(83, 4, 4, '2026-11-12T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bí Kíp Luyện Cướp
(84, 3, 5, '2026-11-12T21:00:00', N'IMAX', N'Phụ đề', 120000); -- Phòng 5 | Godzilla Trừ Không
-- Thứ 6 13/11/2026: 28 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(85, 14, 1, '2026-11-13T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(86, 3, 5, '2026-11-13T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(87, 6, 4, '2026-11-13T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(88, 16, 2, '2026-11-13T09:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(89, 13, 3, '2026-11-13T09:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(90, 2, 1, '2026-11-13T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(91, 12, 2, '2026-11-13T11:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(92, 15, 3, '2026-11-13T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(93, 6, 5, '2026-11-13T11:45:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Ramayana: Khởi Nguồn Một Huyền Thoại
(94, 3, 4, '2026-11-13T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(95, 14, 1, '2026-11-13T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(96, 16, 2, '2026-11-13T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(97, 13, 3, '2026-11-13T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(98, 3, 5, '2026-11-13T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(99, 6, 4, '2026-11-13T15:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(100, 17, 2, '2026-11-13T15:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(101, 4, 3, '2026-11-13T15:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(102, 2, 1, '2026-11-13T16:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(103, 6, 5, '2026-11-13T17:45:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Ramayana: Khởi Nguồn Một Huyền Thoại
(104, 9, 3, '2026-11-13T18:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Kẻ Hồi Sinh
(105, 14, 1, '2026-11-13T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(106, 11, 2, '2026-11-13T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(107, 3, 4, '2026-11-13T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(108, 15, 3, '2026-11-13T20:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(109, 5, 1, '2026-11-13T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(110, 17, 2, '2026-11-13T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(111, 4, 4, '2026-11-13T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bí Kíp Luyện Cướp
(112, 3, 5, '2026-11-13T21:00:00', N'IMAX', N'Phụ đề', 120000); -- Phòng 5 | Godzilla Trừ Không
-- Thứ 7 14/11/2026: 28 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(113, 14, 1, '2026-11-14T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(114, 10, 5, '2026-11-14T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(115, 6, 4, '2026-11-14T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(116, 8, 2, '2026-11-14T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Kiến Lé Phiêu Lưu Ké
(117, 4, 3, '2026-11-14T10:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(118, 12, 2, '2026-11-14T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(119, 2, 1, '2026-11-14T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(120, 3, 5, '2026-11-14T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(121, 9, 3, '2026-11-14T12:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Kẻ Hồi Sinh
(122, 3, 4, '2026-11-14T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(123, 16, 2, '2026-11-14T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(124, 5, 1, '2026-11-14T14:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(125, 13, 3, '2026-11-14T14:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(126, 10, 5, '2026-11-14T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(127, 4, 4, '2026-11-14T15:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bí Kíp Luyện Cướp
(128, 2, 2, '2026-11-14T15:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(129, 14, 1, '2026-11-14T16:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(130, 15, 3, '2026-11-14T17:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(131, 6, 4, '2026-11-14T17:45:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(132, 17, 2, '2026-11-14T18:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(133, 3, 5, '2026-11-14T18:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(134, 2, 1, '2026-11-14T19:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(135, 2, 3, '2026-11-14T19:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(136, 11, 2, '2026-11-14T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(137, 3, 4, '2026-11-14T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(138, 10, 5, '2026-11-14T21:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(139, 5, 1, '2026-11-14T21:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(140, 4, 3, '2026-11-14T21:30:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Bí Kíp Luyện Cướp
-- Chủ nhật 15/11/2026: 28 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(141, 14, 1, '2026-11-15T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(142, 10, 5, '2026-11-15T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(143, 6, 4, '2026-11-15T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(144, 8, 2, '2026-11-15T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Kiến Lé Phiêu Lưu Ké
(145, 4, 3, '2026-11-15T10:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(146, 12, 2, '2026-11-15T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(147, 2, 1, '2026-11-15T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(148, 3, 5, '2026-11-15T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(149, 9, 3, '2026-11-15T12:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Kẻ Hồi Sinh
(150, 3, 4, '2026-11-15T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(151, 16, 2, '2026-11-15T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(152, 5, 1, '2026-11-15T14:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(153, 13, 3, '2026-11-15T14:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(154, 10, 5, '2026-11-15T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(155, 4, 4, '2026-11-15T15:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bí Kíp Luyện Cướp
(156, 2, 2, '2026-11-15T15:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(157, 14, 1, '2026-11-15T16:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(158, 15, 3, '2026-11-15T17:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(159, 6, 4, '2026-11-15T17:45:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(160, 17, 2, '2026-11-15T18:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(161, 3, 5, '2026-11-15T18:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(162, 2, 1, '2026-11-15T19:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(163, 2, 3, '2026-11-15T19:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(164, 11, 2, '2026-11-15T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(165, 3, 4, '2026-11-15T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(166, 10, 5, '2026-11-15T21:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(167, 5, 1, '2026-11-15T21:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(168, 4, 3, '2026-11-15T21:30:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Bí Kíp Luyện Cướp
-- Thứ 2 16/11/2026: 28 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(169, 14, 1, '2026-11-16T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(170, 10, 5, '2026-11-16T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(171, 6, 4, '2026-11-16T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(172, 8, 2, '2026-11-16T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Kiến Lé Phiêu Lưu Ké
(173, 4, 3, '2026-11-16T10:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(174, 12, 2, '2026-11-16T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(175, 2, 1, '2026-11-16T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(176, 3, 5, '2026-11-16T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(177, 9, 3, '2026-11-16T12:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Kẻ Hồi Sinh
(178, 3, 4, '2026-11-16T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(179, 16, 2, '2026-11-16T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(180, 5, 1, '2026-11-16T14:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(181, 13, 3, '2026-11-16T14:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(182, 10, 5, '2026-11-16T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(183, 4, 4, '2026-11-16T15:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bí Kíp Luyện Cướp
(184, 2, 2, '2026-11-16T15:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(185, 14, 1, '2026-11-16T16:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(186, 15, 3, '2026-11-16T17:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(187, 6, 4, '2026-11-16T17:45:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(188, 17, 2, '2026-11-16T18:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(189, 3, 5, '2026-11-16T18:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(190, 2, 1, '2026-11-16T19:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(191, 2, 3, '2026-11-16T19:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(192, 11, 2, '2026-11-16T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(193, 3, 4, '2026-11-16T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(194, 10, 5, '2026-11-16T21:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(195, 5, 1, '2026-11-16T21:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(196, 4, 3, '2026-11-16T21:30:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Bí Kíp Luyện Cướp
-- Thứ 3 17/11/2026: 28 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(197, 14, 1, '2026-11-17T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(198, 10, 5, '2026-11-17T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(199, 6, 4, '2026-11-17T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(200, 8, 2, '2026-11-17T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Kiến Lé Phiêu Lưu Ké
(201, 4, 3, '2026-11-17T10:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(202, 12, 2, '2026-11-17T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(203, 2, 1, '2026-11-17T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(204, 3, 5, '2026-11-17T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(205, 9, 3, '2026-11-17T12:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Kẻ Hồi Sinh
(206, 3, 4, '2026-11-17T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(207, 16, 2, '2026-11-17T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(208, 5, 1, '2026-11-17T14:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(209, 13, 3, '2026-11-17T14:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(210, 10, 5, '2026-11-17T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(211, 4, 4, '2026-11-17T15:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bí Kíp Luyện Cướp
(212, 2, 2, '2026-11-17T15:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(213, 14, 1, '2026-11-17T16:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(214, 15, 3, '2026-11-17T17:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(215, 6, 4, '2026-11-17T17:45:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(216, 17, 2, '2026-11-17T18:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(217, 3, 5, '2026-11-17T18:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(218, 2, 1, '2026-11-17T19:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(219, 2, 3, '2026-11-17T19:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(220, 11, 2, '2026-11-17T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(221, 3, 4, '2026-11-17T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(222, 10, 5, '2026-11-17T21:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(223, 5, 1, '2026-11-17T21:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(224, 4, 3, '2026-11-17T21:30:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Bí Kíp Luyện Cướp
-- Thứ 4 18/11/2026: 28 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(225, 1, 1, '2026-11-18T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(226, 10, 5, '2026-11-18T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(227, 6, 4, '2026-11-18T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(228, 8, 2, '2026-11-18T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Kiến Lé Phiêu Lưu Ké
(229, 4, 3, '2026-11-18T10:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(230, 12, 2, '2026-11-18T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(231, 2, 1, '2026-11-18T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(232, 3, 5, '2026-11-18T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(233, 9, 3, '2026-11-18T12:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Kẻ Hồi Sinh
(234, 3, 4, '2026-11-18T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(235, 16, 2, '2026-11-18T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(236, 1, 1, '2026-11-18T14:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(237, 13, 3, '2026-11-18T14:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(238, 7, 5, '2026-11-18T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(239, 4, 4, '2026-11-18T15:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bí Kíp Luyện Cướp
(240, 2, 2, '2026-11-18T15:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(241, 14, 1, '2026-11-18T16:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(242, 15, 3, '2026-11-18T17:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(243, 6, 4, '2026-11-18T17:45:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(244, 17, 2, '2026-11-18T18:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(245, 3, 5, '2026-11-18T18:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(246, 1, 1, '2026-11-18T19:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(247, 2, 3, '2026-11-18T19:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(248, 11, 2, '2026-11-18T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(249, 3, 4, '2026-11-18T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(250, 7, 5, '2026-11-18T21:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(251, 5, 1, '2026-11-18T21:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(252, 1, 3, '2026-11-18T21:30:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Trại Giam Hạnh Phúc
-- Thứ 5 19/11/2026: 28 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(253, 1, 1, '2026-11-19T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(254, 10, 5, '2026-11-19T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(255, 6, 4, '2026-11-19T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(256, 8, 2, '2026-11-19T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Kiến Lé Phiêu Lưu Ké
(257, 4, 3, '2026-11-19T10:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(258, 12, 2, '2026-11-19T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(259, 2, 1, '2026-11-19T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(260, 3, 5, '2026-11-19T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(261, 9, 3, '2026-11-19T12:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Kẻ Hồi Sinh
(262, 3, 4, '2026-11-19T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(263, 16, 2, '2026-11-19T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(264, 1, 1, '2026-11-19T14:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(265, 13, 3, '2026-11-19T14:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(266, 7, 5, '2026-11-19T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(267, 4, 4, '2026-11-19T15:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bí Kíp Luyện Cướp
(268, 2, 2, '2026-11-19T15:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(269, 14, 1, '2026-11-19T16:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(270, 15, 3, '2026-11-19T17:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(271, 6, 4, '2026-11-19T17:45:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(272, 17, 2, '2026-11-19T18:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(273, 3, 5, '2026-11-19T18:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(274, 1, 1, '2026-11-19T19:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(275, 2, 3, '2026-11-19T19:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(276, 11, 2, '2026-11-19T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(277, 3, 4, '2026-11-19T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(278, 7, 5, '2026-11-19T21:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(279, 5, 1, '2026-11-19T21:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(280, 1, 3, '2026-11-19T21:30:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Trại Giam Hạnh Phúc
-- Thứ 6 20/11/2026: 28 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(281, 1, 1, '2026-11-20T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(282, 10, 5, '2026-11-20T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(283, 6, 4, '2026-11-20T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(284, 19, 2, '2026-11-20T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(285, 4, 3, '2026-11-20T10:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(286, 8, 2, '2026-11-20T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Kiến Lé Phiêu Lưu Ké
(287, 2, 1, '2026-11-20T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(288, 3, 5, '2026-11-20T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(289, 9, 3, '2026-11-20T12:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Kẻ Hồi Sinh
(290, 20, 4, '2026-11-20T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(291, 16, 2, '2026-11-20T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(292, 1, 1, '2026-11-20T14:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(293, 13, 3, '2026-11-20T14:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(294, 7, 5, '2026-11-20T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(295, 12, 2, '2026-11-20T15:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(296, 3, 4, '2026-11-20T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(297, 14, 1, '2026-11-20T16:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(298, 15, 3, '2026-11-20T17:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(299, 17, 2, '2026-11-20T18:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(300, 20, 4, '2026-11-20T18:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(301, 3, 5, '2026-11-20T18:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(302, 1, 1, '2026-11-20T19:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(303, 2, 3, '2026-11-20T19:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(304, 11, 2, '2026-11-20T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(305, 4, 4, '2026-11-20T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bí Kíp Luyện Cướp
(306, 7, 5, '2026-11-20T21:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(307, 5, 1, '2026-11-20T21:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(308, 1, 3, '2026-11-20T21:30:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Trại Giam Hạnh Phúc
-- Thứ 7 21/11/2026: 28 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(309, 1, 1, '2026-11-21T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(310, 10, 5, '2026-11-21T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(311, 6, 4, '2026-11-21T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(312, 19, 2, '2026-11-21T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(313, 4, 3, '2026-11-21T10:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(314, 8, 2, '2026-11-21T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Kiến Lé Phiêu Lưu Ké
(315, 2, 1, '2026-11-21T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(316, 3, 5, '2026-11-21T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(317, 9, 3, '2026-11-21T12:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Kẻ Hồi Sinh
(318, 20, 4, '2026-11-21T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(319, 16, 2, '2026-11-21T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(320, 1, 1, '2026-11-21T14:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(321, 13, 3, '2026-11-21T14:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(322, 7, 5, '2026-11-21T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(323, 12, 2, '2026-11-21T15:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(324, 3, 4, '2026-11-21T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(325, 14, 1, '2026-11-21T16:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(326, 15, 3, '2026-11-21T17:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(327, 17, 2, '2026-11-21T18:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(328, 20, 4, '2026-11-21T18:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(329, 3, 5, '2026-11-21T18:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(330, 1, 1, '2026-11-21T19:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(331, 21, 3, '2026-11-21T19:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Rosetta (EUFF)
(332, 11, 2, '2026-11-21T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(333, 4, 4, '2026-11-21T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bí Kíp Luyện Cướp
(334, 7, 5, '2026-11-21T21:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(335, 5, 1, '2026-11-21T21:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(336, 1, 3, '2026-11-21T21:30:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Trại Giam Hạnh Phúc
-- Chủ nhật 22/11/2026: 28 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(337, 1, 1, '2026-11-22T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(338, 10, 5, '2026-11-22T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(339, 6, 4, '2026-11-22T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(340, 19, 2, '2026-11-22T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(341, 4, 3, '2026-11-22T10:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(342, 8, 2, '2026-11-22T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Kiến Lé Phiêu Lưu Ké
(343, 2, 1, '2026-11-22T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(344, 3, 5, '2026-11-22T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(345, 9, 3, '2026-11-22T12:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Kẻ Hồi Sinh
(346, 20, 4, '2026-11-22T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(347, 16, 2, '2026-11-22T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Shaun The Sheep: "Quái Lạ" Ghé Nhà
(348, 1, 1, '2026-11-22T14:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(349, 13, 3, '2026-11-22T14:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(350, 7, 5, '2026-11-22T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(351, 12, 2, '2026-11-22T15:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(352, 3, 4, '2026-11-22T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(353, 14, 1, '2026-11-22T16:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(354, 15, 3, '2026-11-22T17:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(355, 17, 2, '2026-11-22T18:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Trại Buôn Người
(356, 20, 4, '2026-11-22T18:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(357, 3, 5, '2026-11-22T18:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(358, 1, 1, '2026-11-22T19:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(359, 21, 3, '2026-11-22T19:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Rosetta (EUFF)
(360, 11, 2, '2026-11-22T20:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(361, 4, 4, '2026-11-22T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bí Kíp Luyện Cướp
(362, 7, 5, '2026-11-22T21:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(363, 5, 1, '2026-11-22T21:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(364, 1, 3, '2026-11-22T21:30:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Trại Giam Hạnh Phúc
-- Thứ 2 23/11/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(365, 1, 1, '2026-11-23T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(366, 19, 2, '2026-11-23T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(367, 10, 5, '2026-11-23T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(368, 6, 4, '2026-11-23T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(369, 4, 3, '2026-11-23T09:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(370, 8, 2, '2026-11-23T10:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Kiến Lé Phiêu Lưu Ké
(371, 2, 1, '2026-11-23T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(372, 9, 3, '2026-11-23T12:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Kẻ Hồi Sinh
(373, 12, 2, '2026-11-23T12:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(374, 3, 5, '2026-11-23T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(375, 20, 4, '2026-11-23T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(376, 1, 1, '2026-11-23T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(377, 13, 3, '2026-11-23T14:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(378, 2, 2, '2026-11-23T14:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(379, 7, 5, '2026-11-23T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(380, 3, 4, '2026-11-23T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(381, 15, 3, '2026-11-23T16:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(382, 14, 1, '2026-11-23T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(383, 11, 2, '2026-11-23T16:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(384, 20, 4, '2026-11-23T18:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(385, 2, 3, '2026-11-23T18:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(386, 3, 5, '2026-11-23T18:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(387, 1, 1, '2026-11-23T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(388, 22, 2, '2026-11-23T19:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ba Cây Số Từ Nơi Tận Cùng Thế Giới (EUFF)
(389, 1, 3, '2026-11-23T20:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Trại Giam Hạnh Phúc
(390, 5, 1, '2026-11-23T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(391, 4, 4, '2026-11-23T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bí Kíp Luyện Cướp
(392, 7, 5, '2026-11-23T21:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(393, 17, 2, '2026-11-23T21:15:00', N'2D', N'Phụ đề', 75000); -- Phòng 2 | Trại Buôn Người
-- Thứ 3 24/11/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(394, 1, 1, '2026-11-24T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(395, 19, 2, '2026-11-24T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(396, 10, 5, '2026-11-24T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(397, 6, 4, '2026-11-24T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(398, 4, 3, '2026-11-24T09:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(399, 8, 2, '2026-11-24T10:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Kiến Lé Phiêu Lưu Ké
(400, 2, 1, '2026-11-24T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(401, 9, 3, '2026-11-24T12:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Kẻ Hồi Sinh
(402, 12, 2, '2026-11-24T12:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(403, 3, 5, '2026-11-24T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(404, 20, 4, '2026-11-24T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(405, 1, 1, '2026-11-24T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(406, 13, 3, '2026-11-24T14:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(407, 2, 2, '2026-11-24T14:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(408, 7, 5, '2026-11-24T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(409, 3, 4, '2026-11-24T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(410, 15, 3, '2026-11-24T16:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(411, 14, 1, '2026-11-24T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(412, 11, 2, '2026-11-24T16:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(413, 20, 4, '2026-11-24T18:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(414, 2, 3, '2026-11-24T18:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(415, 3, 5, '2026-11-24T18:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(416, 1, 1, '2026-11-24T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(417, 23, 2, '2026-11-24T19:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Amrum (EUFF)
(418, 1, 3, '2026-11-24T20:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Trại Giam Hạnh Phúc
(419, 5, 1, '2026-11-24T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(420, 4, 4, '2026-11-24T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bí Kíp Luyện Cướp
(421, 7, 5, '2026-11-24T21:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(422, 17, 2, '2026-11-24T21:15:00', N'2D', N'Phụ đề', 75000); -- Phòng 2 | Trại Buôn Người
-- Thứ 4 25/11/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(423, 1, 1, '2026-11-25T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(424, 19, 2, '2026-11-25T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(425, 10, 5, '2026-11-25T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(426, 6, 4, '2026-11-25T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(427, 4, 3, '2026-11-25T09:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(428, 8, 2, '2026-11-25T10:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Kiến Lé Phiêu Lưu Ké
(429, 2, 1, '2026-11-25T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(430, 9, 3, '2026-11-25T12:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Kẻ Hồi Sinh
(431, 12, 2, '2026-11-25T12:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(432, 3, 5, '2026-11-25T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(433, 20, 4, '2026-11-25T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(434, 1, 1, '2026-11-25T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(435, 13, 3, '2026-11-25T14:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(436, 2, 2, '2026-11-25T14:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(437, 7, 5, '2026-11-25T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(438, 3, 4, '2026-11-25T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(439, 15, 3, '2026-11-25T16:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(440, 14, 1, '2026-11-25T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(441, 11, 2, '2026-11-25T16:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(442, 20, 4, '2026-11-25T18:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(443, 2, 3, '2026-11-25T18:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(444, 3, 5, '2026-11-25T18:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(445, 1, 1, '2026-11-25T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(446, 24, 2, '2026-11-25T19:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Mẹ Mìn: Giao Kèo Với Quỷ
(447, 24, 3, '2026-11-25T20:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Mẹ Mìn: Giao Kèo Với Quỷ
(448, 5, 1, '2026-11-25T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(449, 4, 4, '2026-11-25T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bí Kíp Luyện Cướp
(450, 7, 5, '2026-11-25T21:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(451, 17, 2, '2026-11-25T21:15:00', N'2D', N'Phụ đề', 75000); -- Phòng 2 | Trại Buôn Người
-- Thứ 5 26/11/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(452, 1, 1, '2026-11-26T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(453, 19, 2, '2026-11-26T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(454, 10, 5, '2026-11-26T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát
(455, 6, 4, '2026-11-26T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(456, 4, 3, '2026-11-26T09:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(457, 8, 2, '2026-11-26T10:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Kiến Lé Phiêu Lưu Ké
(458, 2, 1, '2026-11-26T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Ngày Con Còn Mẹ
(459, 9, 3, '2026-11-26T12:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Kẻ Hồi Sinh
(460, 12, 2, '2026-11-26T12:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Chàng Mèo Mang Mũ
(461, 3, 5, '2026-11-26T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(462, 20, 4, '2026-11-26T12:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(463, 1, 1, '2026-11-26T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(464, 13, 3, '2026-11-26T14:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Thiên Đường Tăm Tối
(465, 2, 2, '2026-11-26T14:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(466, 7, 5, '2026-11-26T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(467, 3, 4, '2026-11-26T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(468, 15, 3, '2026-11-26T16:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Clayface
(469, 14, 1, '2026-11-26T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Bò Sữa Bay
(470, 11, 2, '2026-11-26T16:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(471, 20, 4, '2026-11-26T18:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(472, 2, 3, '2026-11-26T18:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(473, 3, 5, '2026-11-26T18:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(474, 1, 1, '2026-11-26T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(475, 24, 2, '2026-11-26T19:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Mẹ Mìn: Giao Kèo Với Quỷ
(476, 24, 3, '2026-11-26T20:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Mẹ Mìn: Giao Kèo Với Quỷ
(477, 5, 1, '2026-11-26T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Chị Chị Em Em 3
(478, 4, 4, '2026-11-26T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 4 | Bí Kíp Luyện Cướp
(479, 7, 5, '2026-11-26T21:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(480, 17, 2, '2026-11-26T21:15:00', N'2D', N'Phụ đề', 75000); -- Phòng 2 | Trại Buôn Người
-- Thứ 6 27/11/2026: 29 suat
INSERT INTO SHOWTIME (ShowtimeID, MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice) VALUES
(481, 1, 1, '2026-11-27T09:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(482, 25, 2, '2026-11-27T09:00:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(483, 7, 5, '2026-11-27T09:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(484, 20, 4, '2026-11-27T09:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(485, 8, 3, '2026-11-27T09:30:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 3 | Kiến Lé Phiêu Lưu Ké
(486, 19, 2, '2026-11-27T11:15:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Ma Mút Con Vượt Kỷ Băng Hà
(487, 2, 3, '2026-11-27T11:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Ngày Con Còn Mẹ
(488, 26, 1, '2026-11-27T11:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(489, 6, 4, '2026-11-27T12:15:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Ramayana: Khởi Nguồn Một Huyền Thoại
(490, 3, 5, '2026-11-27T12:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(491, 25, 2, '2026-11-27T12:45:00', N'2D', N'Lồng tiếng', 75000), -- Phòng 2 | Hexed: Thế Giới Phép Thuật
(492, 4, 3, '2026-11-27T13:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Bí Kíp Luyện Cướp
(493, 1, 1, '2026-11-27T13:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(494, 2, 2, '2026-11-27T15:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Ngày Con Còn Mẹ
(495, 20, 5, '2026-11-27T15:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(496, 20, 4, '2026-11-27T15:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(497, 5, 3, '2026-11-27T16:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Chị Chị Em Em 3
(498, 24, 1, '2026-11-27T16:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(499, 26, 2, '2026-11-27T17:15:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng
(500, 7, 5, '2026-11-27T18:00:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Dune: Hành Tinh Cát - Phần Hai
(501, 1, 1, '2026-11-27T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Trại Giam Hạnh Phúc
(502, 18, 3, '2026-11-27T18:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 3 | Điểm Mù
(503, 3, 4, '2026-11-27T18:30:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Godzilla Trừ Không
(504, 14, 2, '2026-11-27T19:30:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Bò Sữa Bay
(505, 24, 1, '2026-11-27T21:00:00', N'2D', N'Phụ đề', 75000), -- Phòng 1 | Mẹ Mìn: Giao Kèo Với Quỷ
(506, 20, 4, '2026-11-27T21:00:00', N'3D', N'Phụ đề', 90000), -- Phòng 4 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân
(507, 3, 5, '2026-11-27T21:15:00', N'IMAX', N'Phụ đề', 120000), -- Phòng 5 | Godzilla Trừ Không
(508, 11, 2, '2026-11-27T21:45:00', N'2D', N'Phụ đề', 75000), -- Phòng 2 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng
(509, 24, 3, '2026-11-27T21:45:00', N'2D', N'Phụ đề', 75000); -- Phòng 3 | Mẹ Mìn: Giao Kèo Với Quỷ
SET IDENTITY_INSERT SHOWTIME OFF;

-- ===== BOOKING + TICKET: gom theo ngay lap hoa don =====

-- ----- Thứ 3 10/11/2026: 126 hoa don (8 huy), 314 ve, doanh thu 30.717.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(1, 3, NULL, '2026-11-10T08:02:53', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 2 | Godzilla Trừ Không | 10/11 09:00 | Phòng 5 | E5 E6
(2, 4, 19, '2026-11-10T08:21:11', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 1 | Bò Sữa Bay | 10/11 09:00 | Phòng 1 | E4 E5 E6 E7
(3, 3, 25, '2026-11-10T08:25:28', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 1 | Bò Sữa Bay | 10/11 09:00 | Phòng 1 | F5 F6
(4, 3, NULL, '2026-11-10T08:31:18', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 3 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/11 09:15 | Phòng 4 | C6 C7 C8 C9
(5, 4, NULL, '2026-11-10T08:34:37', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 5 | Thiên Đường Tăm Tối | 10/11 09:30 | Phòng 3 | J3 J4
(6, 3, NULL, '2026-11-10T08:44:09', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 1 | Bò Sữa Bay | 10/11 09:00 | Phòng 1 | D9 D10
(7, 4, NULL, '2026-11-10T08:45:11', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 2 | Godzilla Trừ Không | 10/11 09:00 | Phòng 5 | F8 F9
(8, 3, NULL, '2026-11-10T08:47:49', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 5 | Thiên Đường Tăm Tối | 10/11 09:30 | Phòng 3 | D1
(9, 3, NULL, '2026-11-10T08:51:31', 240000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 2 | Godzilla Trừ Không | 10/11 09:00 | Phòng 5 | A6 A7
(10, 3, NULL, '2026-11-10T08:58:25', 540000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 4 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 10/11 09:30 | Phòng 2 | E7 E8 E9 E10 E11 E12
(11, 3, 75, '2026-11-10T09:08:01', 360000, N'Paid', N'Cash', 400000, 25, 0, NULL, NULL, NULL), -- suat 4 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 10/11 09:30 | Phòng 2 | F4 F5 F6 F7
(12, 3, 20, '2026-11-10T09:17:28', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 8 | Clayface | 10/11 11:30 | Phòng 3 | G4 G5
(13, 4, 97, '2026-11-10T09:29:43', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 13 | Thiên Đường Tăm Tối | 10/11 13:45 | Phòng 3 | E4 E5
(14, 3, NULL, '2026-11-10T09:30:01', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 14 | Godzilla Trừ Không | 10/11 15:00 | Phòng 5 | D11 D12
(15, 3, 43, '2026-11-10T09:30:20', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 10 | Godzilla Trừ Không | 10/11 12:30 | Phòng 4 | H6 H7
(16, 3, 21, '2026-11-10T09:49:00', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 40 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 11/11 13:45 | Phòng 2 | E11 E12
(17, 4, NULL, '2026-11-10T09:49:34', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 6 | Chị Chị Em Em 3 | 10/11 11:15 | Phòng 1 | G6 G7
(18, 3, NULL, '2026-11-10T10:02:30', 360000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Nhầm suất / ghế', '2026-11-10T10:05:30', 3), -- suat 74 | Ngày Con Còn Mẹ | 12/11 16:00 | Phòng 1 | F5 F6 F7 F8
(19, 3, NULL, '2026-11-10T10:07:25', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 14 | Godzilla Trừ Không | 10/11 15:00 | Phòng 5 | G6 G7 G8
(20, 4, NULL, '2026-11-10T10:09:55', 300000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 17 | Clayface | 10/11 15:45 | Phòng 3 | C6 C7 C8 C9
(21, 4, 1, '2026-11-10T10:17:52', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 13 | Thiên Đường Tăm Tối | 10/11 13:45 | Phòng 3 | F8 F9
(22, 4, NULL, '2026-11-10T10:20:24', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 8 | Clayface | 10/11 11:30 | Phòng 3 | G9
(23, 3, NULL, '2026-11-10T10:21:50', 270000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 6 | Chị Chị Em Em 3 | 10/11 11:15 | Phòng 1 | E2 E3 E4
(24, 3, NULL, '2026-11-10T10:22:48', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 7 | Chàng Mèo Mang Mũ | 10/11 11:30 | Phòng 2 | C1 C2
(25, 3, 8, '2026-11-10T10:28:50', 480000, N'Paid', N'Transfer', NULL, 24, 0, NULL, NULL, NULL), -- suat 9 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/11 11:45 | Phòng 5 | C4 C5 C6 C7
(26, 3, NULL, '2026-11-10T10:45:17', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 12 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 10/11 13:45 | Phòng 2 | F10 F11
(27, 3, 93, '2026-11-10T10:56:47', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 16 | Trại Buôn Người | 10/11 15:45 | Phòng 2 | G10
(28, 3, NULL, '2026-11-10T11:18:07', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 9 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/11 11:45 | Phòng 5 | J6 J7
(29, 4, NULL, '2026-11-10T11:30:03', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 22 | Thiên Đường Tăm Tối | 10/11 18:30 | Phòng 2 | H4 H5
(30, 4, 33, '2026-11-10T11:30:49', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 35 | Chàng Mèo Mang Mũ | 11/11 11:30 | Phòng 2 | E5 E6 E7
(31, 4, 111, '2026-11-10T11:34:33', 360000, N'Cancelled', N'Cash', 400000, 18, 0, N'Sự cố phòng chiếu', '2026-11-10T12:53:37', 1), -- suat 10 | Godzilla Trừ Không | 10/11 12:30 | Phòng 4 | B7 B8 B9 B10
(32, 4, 2, '2026-11-10T11:37:34', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 12 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 10/11 13:45 | Phòng 2 | G10
(33, 4, NULL, '2026-11-10T11:45:02', 432000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 10 | Godzilla Trừ Không | 10/11 12:30 | Phòng 4 | E3 E4 E5 E6
(34, 3, NULL, '2026-11-10T11:46:00', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 11 | Bò Sữa Bay | 10/11 13:45 | Phòng 1 | B6 B7 B8
(35, 3, 108, '2026-11-10T11:50:25', 324000, N'Paid', N'Cash', 324000, 22, 0, NULL, NULL, NULL), -- suat 23 | Godzilla Trừ Không | 10/11 18:30 | Phòng 4 | H5 H6 H7
(36, 3, NULL, '2026-11-10T11:58:41', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 14 | Godzilla Trừ Không | 10/11 15:00 | Phòng 5 | L9 L10
(37, 4, NULL, '2026-11-10T11:59:16', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 10 | Godzilla Trừ Không | 10/11 12:30 | Phòng 4 | C9 C10
(38, 4, NULL, '2026-11-10T12:02:37', 75000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 13 | Thiên Đường Tăm Tối | 10/11 13:45 | Phòng 3 | B10
(39, 4, NULL, '2026-11-10T12:04:56', 90000, N'Cancelled', N'Cash', 100000, 0, 0, N'Khách đổi ý', '2026-11-10T12:25:49', 4), -- suat 10 | Godzilla Trừ Không | 10/11 12:30 | Phòng 4 | C11
(40, 3, 44, '2026-11-10T12:21:26', 864000, N'Paid', N'Cash', 900000, 60, 0, NULL, NULL, NULL), -- suat 14 | Godzilla Trừ Không | 10/11 15:00 | Phòng 5 | E4 E5 E6 E7 E8 E9
(41, 4, 62, '2026-11-10T12:21:40', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 21 | Bò Sữa Bay | 10/11 18:30 | Phòng 1 | H7 H8 H9 H10
(42, 4, NULL, '2026-11-10T12:26:55', 450000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 52 | Clayface | 11/11 20:15 | Phòng 3 | A4 A5 A6 A7 A8 A9
(43, 3, NULL, '2026-11-10T12:27:23', 180000, N'Cancelled', N'Card', NULL, 0, 0, N'Nhầm suất / ghế', '2026-11-10T12:42:02', 3), -- suat 24 | Clayface | 10/11 20:15 | Phòng 3 | F11 F12
(44, 3, 101, '2026-11-10T12:28:37', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 13 | Thiên Đường Tăm Tối | 10/11 13:45 | Phòng 3 | A3 A4
(45, 4, 15, '2026-11-10T12:31:17', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 23 | Godzilla Trừ Không | 10/11 18:30 | Phòng 4 | H9 H10
(46, 3, 25, '2026-11-10T12:31:52', 432000, N'Paid', N'Cash', 432000, 30, 0, NULL, NULL, NULL), -- suat 14 | Godzilla Trừ Không | 10/11 15:00 | Phòng 5 | G10 G11 G12
(47, 3, NULL, '2026-11-10T12:34:26', 540000, N'Paid', N'Cash', 540000, 0, 0, NULL, NULL, NULL), -- suat 21 | Bò Sữa Bay | 10/11 18:30 | Phòng 1 | E5 E6 E7 E8 E9 E10
(48, 3, NULL, '2026-11-10T12:42:42', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 16 | Trại Buôn Người | 10/11 15:45 | Phòng 2 | D10 D11
(49, 4, NULL, '2026-11-10T13:00:34', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 75 | Ramayana: Khởi Nguồn Một Huyền Thoại | 12/11 17:45 | Phòng 5 | E6 E7
(50, 4, NULL, '2026-11-10T13:01:10', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 28 | Godzilla Trừ Không | 10/11 21:00 | Phòng 5 | K5 K6 K7 K8
(51, 4, 113, '2026-11-10T13:08:39', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 14 | Godzilla Trừ Không | 10/11 15:00 | Phòng 5 | J5 J6
(52, 4, NULL, '2026-11-10T13:09:28', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 38 | Godzilla Trừ Không | 11/11 12:30 | Phòng 4 | J5 J6
(53, 4, NULL, '2026-11-10T13:14:40', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 15 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/11 15:15 | Phòng 4 | G5 G6 G7 G8
(54, 3, 117, '2026-11-10T13:16:47', 240000, N'Paid', N'Cash', 300000, 12, 0, NULL, NULL, NULL), -- suat 19 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/11 17:45 | Phòng 5 | B4 B5
(55, 4, 28, '2026-11-10T13:17:17', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 19 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/11 17:45 | Phòng 5 | H2 H3
(56, 3, 69, '2026-11-10T13:18:44', 324000, N'Paid', N'Card', NULL, 22, 0, NULL, NULL, NULL), -- suat 15 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/11 15:15 | Phòng 4 | D5 D6 D7
(57, 4, NULL, '2026-11-10T13:21:49', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 27 | Bò Sữa Bay | 10/11 21:00 | Phòng 4 | F4 F5 F6 F7
(58, 4, NULL, '2026-11-10T13:21:58', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 20 | Thiên Đường Tăm Tối | 10/11 18:15 | Phòng 3 | J3 J4
(59, 3, NULL, '2026-11-10T13:32:27', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 21 | Bò Sữa Bay | 10/11 18:30 | Phòng 1 | F11
(60, 4, NULL, '2026-11-10T13:40:10', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 18 | Chị Chị Em Em 3 | 10/11 16:00 | Phòng 1 | E7 E8
(61, 3, NULL, '2026-11-10T13:48:23', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 20 | Thiên Đường Tăm Tối | 10/11 18:15 | Phòng 3 | D4
(62, 4, NULL, '2026-11-10T13:55:55', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 41 | Thiên Đường Tăm Tối | 11/11 13:45 | Phòng 3 | H4 H5
(63, 3, NULL, '2026-11-10T14:01:43', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 22 | Thiên Đường Tăm Tối | 10/11 18:30 | Phòng 2 | D3 D4
(64, 4, 67, '2026-11-10T14:11:24', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 25 | Chị Chị Em Em 3 | 10/11 20:45 | Phòng 1 | H7 H8
(65, 3, 59, '2026-11-10T14:13:26', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 17 | Clayface | 10/11 15:45 | Phòng 3 | H7 H8
(66, 3, 77, '2026-11-10T14:13:44', 576000, N'Paid', N'Cash', 600000, 40, 0, NULL, NULL, NULL), -- suat 19 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/11 17:45 | Phòng 5 | E1 E2 E3 E4
(67, 3, 58, '2026-11-10T14:13:51', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 76 | Thiên Đường Tăm Tối | 12/11 18:15 | Phòng 3 | H1
(68, 3, NULL, '2026-11-10T14:18:58', 180000, N'Cancelled', N'Cash', 200000, 0, 0, N'Nhầm suất / ghế', '2026-11-10T14:43:05', 3), -- suat 21 | Bò Sữa Bay | 10/11 18:30 | Phòng 1 | D4 D5
(69, 3, NULL, '2026-11-10T14:25:35', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 18 | Chị Chị Em Em 3 | 10/11 16:00 | Phòng 1 | H7 H8
(70, 3, NULL, '2026-11-10T14:30:33', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 25 | Chị Chị Em Em 3 | 10/11 20:45 | Phòng 1 | J5 J6
(71, 4, NULL, '2026-11-10T14:34:57', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 55 | Bò Sữa Bay | 11/11 21:00 | Phòng 4 | D5 D6
(72, 3, NULL, '2026-11-10T14:40:20', 108000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 23 | Godzilla Trừ Không | 10/11 18:30 | Phòng 4 | D7
(73, 4, 92, '2026-11-10T14:46:27', 270000, N'Paid', N'Cash', 500000, 18, 0, NULL, NULL, NULL), -- suat 24 | Clayface | 10/11 20:15 | Phòng 3 | G3 G4 G5
(74, 4, 116, '2026-11-10T14:48:34', 216000, N'Paid', N'Cash', 250000, 15, 0, NULL, NULL, NULL), -- suat 23 | Godzilla Trừ Không | 10/11 18:30 | Phòng 4 | F3 F4
(75, 3, 21, '2026-11-10T14:57:38', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 27 | Bò Sữa Bay | 10/11 21:00 | Phòng 4 | E7 E8
(76, 3, NULL, '2026-11-10T14:58:34', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 49 | Bò Sữa Bay | 11/11 18:30 | Phòng 1 | H9 H10
(77, 6, NULL, '2026-11-10T15:00:06', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 19 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/11 17:45 | Phòng 5 | L7 L8
(78, 6, NULL, '2026-11-10T15:03:07', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 54 | Trại Buôn Người | 11/11 20:45 | Phòng 2 | A6 A7 A8
(79, 6, 44, '2026-11-10T15:05:13', 150000, N'Paid', N'Cash', 200000, 7, 0, NULL, NULL, NULL), -- suat 22 | Thiên Đường Tăm Tối | 10/11 18:30 | Phòng 2 | B4 B5
(80, 5, 92, '2026-11-10T15:05:15', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 17 | Clayface | 10/11 15:45 | Phòng 3 | G4 G5
(81, 5, NULL, '2026-11-10T15:07:27', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 21 | Bò Sữa Bay | 10/11 18:30 | Phòng 1 | F2 F3 F4 F5
(82, 5, NULL, '2026-11-10T15:10:49', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 42 | Godzilla Trừ Không | 11/11 15:00 | Phòng 5 | K6 K7
(83, 6, 6, '2026-11-10T15:16:14', 720000, N'Paid', N'Transfer', NULL, 50, 0, NULL, NULL, NULL), -- suat 47 | Ramayana: Khởi Nguồn Một Huyền Thoại | 11/11 17:45 | Phòng 5 | E5 E6 E7 E8 E9
(84, 6, 100, '2026-11-10T15:18:54', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 69 | Thiên Đường Tăm Tối | 12/11 13:45 | Phòng 3 | F2 F3
(85, 5, NULL, '2026-11-10T15:24:40', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 19 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/11 17:45 | Phòng 5 | H5 H6 H7
(86, 6, NULL, '2026-11-10T15:31:39', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 25 | Chị Chị Em Em 3 | 10/11 20:45 | Phòng 1 | E10
(87, 5, NULL, '2026-11-10T15:43:08', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 23 | Godzilla Trừ Không | 10/11 18:30 | Phòng 4 | A7 A8
(88, 6, NULL, '2026-11-10T15:48:01', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 54 | Trại Buôn Người | 11/11 20:45 | Phòng 2 | F8 F9 F10
(89, 6, 1, '2026-11-10T15:48:54', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 25 | Chị Chị Em Em 3 | 10/11 20:45 | Phòng 1 | D5 D6 D7
(90, 5, NULL, '2026-11-10T16:00:25', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 51 | Godzilla Trừ Không | 11/11 18:30 | Phòng 4 | G9 G10
(91, 5, NULL, '2026-11-10T16:13:50', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 26 | Trại Buôn Người | 10/11 20:45 | Phòng 2 | F6
(92, 6, 78, '2026-11-10T16:15:34', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 25 | Chị Chị Em Em 3 | 10/11 20:45 | Phòng 1 | A5 A6
(93, 5, NULL, '2026-11-10T16:17:07', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 55 | Bò Sữa Bay | 11/11 21:00 | Phòng 4 | E9 E10 E11 E12
(94, 6, NULL, '2026-11-10T16:29:51', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 28 | Godzilla Trừ Không | 10/11 21:00 | Phòng 5 | E7 E8
(95, 5, NULL, '2026-11-10T16:37:25', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 19 | Ramayana: Khởi Nguồn Một Huyền Thoại | 10/11 17:45 | Phòng 5 | G1 G2 G3 G4
(96, 5, NULL, '2026-11-10T16:38:53', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 53 | Chị Chị Em Em 3 | 11/11 20:45 | Phòng 1 | G7 G8
(97, 6, 89, '2026-11-10T16:50:57', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 21 | Bò Sữa Bay | 10/11 18:30 | Phòng 1 | F10
(98, 5, NULL, '2026-11-10T16:53:06', 480000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 28 | Godzilla Trừ Không | 10/11 21:00 | Phòng 5 | D5 D6 D7 D8
(99, 6, 95, '2026-11-10T16:55:27', 270000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 22 | Thiên Đường Tăm Tối | 10/11 18:30 | Phòng 2 | E6 E7 E8
(100, 6, 55, '2026-11-10T17:03:20', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 24 | Clayface | 10/11 20:15 | Phòng 3 | F5 F6 F7 F8
(101, 6, NULL, '2026-11-10T17:07:55', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 49 | Bò Sữa Bay | 11/11 18:30 | Phòng 1 | E6
(102, 5, NULL, '2026-11-10T17:16:08', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 27 | Bò Sữa Bay | 10/11 21:00 | Phòng 4 | B9 B10
(103, 6, NULL, '2026-11-10T17:20:00', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 28 | Godzilla Trừ Không | 10/11 21:00 | Phòng 5 | K2 K3
(104, 5, NULL, '2026-11-10T17:20:06', 324000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-11-10T18:00:49', 5), -- suat 23 | Godzilla Trừ Không | 10/11 18:30 | Phòng 4 | D4 D5 D6
(105, 5, 120, '2026-11-10T17:20:09', 180000, N'Paid', N'Cash', 200000, 18, 0, NULL, NULL, NULL), -- suat 22 | Thiên Đường Tăm Tối | 10/11 18:30 | Phòng 2 | J1 J2
(106, 5, NULL, '2026-11-10T17:23:34', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 47 | Ramayana: Khởi Nguồn Một Huyền Thoại | 11/11 17:45 | Phòng 5 | F5 F6
(107, 5, NULL, '2026-11-10T17:28:41', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 28 | Godzilla Trừ Không | 10/11 21:00 | Phòng 5 | L5 L6
(108, 5, 37, '2026-11-10T17:31:09', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 44 | Trại Buôn Người | 11/11 15:45 | Phòng 2 | E1 E2
(109, 5, NULL, '2026-11-10T17:55:40', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 25 | Chị Chị Em Em 3 | 10/11 20:45 | Phòng 1 | G6 G7
(110, 6, 29, '2026-11-10T18:04:26', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 25 | Chị Chị Em Em 3 | 10/11 20:45 | Phòng 1 | D10 D11
(111, 5, 25, '2026-11-10T18:10:44', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 26 | Trại Buôn Người | 10/11 20:45 | Phòng 2 | E9 E10
(112, 5, 34, '2026-11-10T18:14:52', 144000, N'Paid', N'Transfer', NULL, 10, 0, NULL, NULL, NULL), -- suat 37 | Ramayana: Khởi Nguồn Một Huyền Thoại | 11/11 11:45 | Phòng 5 | J7
(113, 6, NULL, '2026-11-10T18:21:21', 270000, N'Cancelled', N'Card', NULL, 0, 0, N'Khách đổi ý', '2026-11-10T18:46:37', 6), -- suat 26 | Trại Buôn Người | 10/11 20:45 | Phòng 2 | E3 E4 E5
(114, 6, NULL, '2026-11-10T18:21:37', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 25 | Chị Chị Em Em 3 | 10/11 20:45 | Phòng 1 | F6 F7 F8
(115, 6, NULL, '2026-11-10T18:22:00', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 54 | Trại Buôn Người | 11/11 20:45 | Phòng 2 | G7 G8
(116, 5, NULL, '2026-11-10T18:40:55', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 26 | Trại Buôn Người | 10/11 20:45 | Phòng 2 | G2 G3 G4 G5
(117, 5, NULL, '2026-11-10T18:42:51', 324000, N'Paid', N'Cash', 350000, 0, 0, NULL, NULL, NULL), -- suat 79 | Godzilla Trừ Không | 12/11 18:30 | Phòng 4 | E5 E6 E7
(118, 5, NULL, '2026-11-10T19:08:37', 648000, N'Paid', N'Cash', 650000, 0, 0, NULL, NULL, NULL), -- suat 51 | Godzilla Trừ Không | 11/11 18:30 | Phòng 4 | H3 H4 H5 H6 H7 H8
(119, 5, 30, '2026-11-10T19:12:12', 432000, N'Paid', N'Transfer', NULL, 30, 0, NULL, NULL, NULL), -- suat 28 | Godzilla Trừ Không | 10/11 21:00 | Phòng 5 | G4 G5 G6
(120, 6, 15, '2026-11-10T19:42:30', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 47 | Ramayana: Khởi Nguồn Một Huyền Thoại | 11/11 17:45 | Phòng 5 | G2 G3
(121, 6, NULL, '2026-11-10T19:47:59', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 28 | Godzilla Trừ Không | 10/11 21:00 | Phòng 5 | G8 G9
(122, 6, NULL, '2026-11-10T19:56:49', 120000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 28 | Godzilla Trừ Không | 10/11 21:00 | Phòng 5 | C6
(123, 5, NULL, '2026-11-10T20:07:13', 288000, N'Cancelled', N'Cash', 300000, 0, 0, N'Khách đổi ý', '2026-11-10T20:45:44', 5), -- suat 28 | Godzilla Trừ Không | 10/11 21:00 | Phòng 5 | E1 E2
(124, 5, NULL, '2026-11-10T20:13:03', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 41 | Thiên Đường Tăm Tối | 11/11 13:45 | Phòng 3 | H2 H3
(125, 6, NULL, '2026-11-10T20:13:35', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 28 | Godzilla Trừ Không | 10/11 21:00 | Phòng 5 | J9 J10
(126, 5, 80, '2026-11-10T21:16:59', 108000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL); -- suat 51 | Godzilla Trừ Không | 11/11 18:30 | Phòng 4 | D10
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(1, 1, 2, 5, 485, 144000, N'Active'),
(2, 1, 2, 5, 486, 144000, N'Active'),
(3, 2, 1, 1, 52, 90000, N'Active'),
(4, 2, 1, 1, 53, 90000, N'Active'),
(5, 2, 1, 1, 54, 90000, N'Active'),
(6, 2, 1, 1, 55, 90000, N'Active'),
(7, 3, 1, 1, 65, 90000, N'Active'),
(8, 3, 1, 1, 66, 90000, N'Active'),
(9, 4, 3, 4, 354, 90000, N'Active'),
(10, 4, 3, 4, 355, 90000, N'Active'),
(11, 4, 3, 4, 356, 90000, N'Active'),
(12, 4, 3, 4, 357, 90000, N'Active'),
(13, 5, 5, 3, 315, 90000, N'Active'),
(14, 5, 5, 3, 316, 90000, N'Active'),
(15, 6, 1, 1, 45, 90000, N'Active'),
(16, 6, 1, 1, 46, 90000, N'Active'),
(17, 7, 2, 5, 500, 144000, N'Active'),
(18, 7, 2, 5, 501, 144000, N'Active'),
(19, 8, 5, 3, 253, 90000, N'Active'),
(20, 9, 2, 5, 438, 120000, N'Active'),
(21, 9, 2, 5, 439, 120000, N'Active'),
(22, 10, 4, 2, 163, 90000, N'Active'),
(23, 10, 4, 2, 164, 90000, N'Active'),
(24, 10, 4, 2, 165, 90000, N'Active'),
(25, 10, 4, 2, 166, 90000, N'Active'),
(26, 10, 4, 2, 167, 90000, N'Active'),
(27, 10, 4, 2, 168, 90000, N'Active'),
(28, 11, 4, 2, 172, 90000, N'Active'),
(29, 11, 4, 2, 173, 90000, N'Active'),
(30, 11, 4, 2, 174, 90000, N'Active'),
(31, 11, 4, 2, 175, 90000, N'Active'),
(32, 12, 8, 3, 292, 90000, N'Active'),
(33, 12, 8, 3, 293, 90000, N'Active'),
(34, 13, 13, 3, 268, 90000, N'Active'),
(35, 13, 13, 3, 269, 90000, N'Active'),
(36, 14, 14, 5, 479, 120000, N'Active'),
(37, 14, 14, 5, 480, 120000, N'Active'),
(38, 15, 10, 4, 414, 108000, N'Active'),
(39, 15, 10, 4, 415, 108000, N'Active'),
(40, 16, 40, 2, 167, 90000, N'Active'),
(41, 16, 40, 2, 168, 90000, N'Active'),
(42, 17, 6, 1, 78, 90000, N'Active'),
(43, 17, 6, 1, 79, 90000, N'Active'),
(44, 18, 74, 1, 65, 90000, N'Cancelled'),
(45, 18, 74, 1, 66, 90000, N'Cancelled'),
(46, 18, 74, 1, 67, 90000, N'Cancelled'),
(47, 18, 74, 1, 68, 90000, N'Cancelled'),
(48, 19, 14, 5, 510, 144000, N'Active'),
(49, 19, 14, 5, 511, 144000, N'Active'),
(50, 19, 14, 5, 512, 144000, N'Active'),
(51, 20, 17, 3, 246, 75000, N'Active'),
(52, 20, 17, 3, 247, 75000, N'Active'),
(53, 20, 17, 3, 248, 75000, N'Active'),
(54, 20, 17, 3, 249, 75000, N'Active'),
(55, 21, 13, 3, 284, 90000, N'Active'),
(56, 21, 13, 3, 285, 90000, N'Active'),
(57, 22, 8, 3, 297, 90000, N'Active'),
(58, 23, 6, 1, 50, 90000, N'Active'),
(59, 23, 6, 1, 51, 90000, N'Active'),
(60, 23, 6, 1, 52, 90000, N'Active'),
(61, 24, 7, 2, 133, 75000, N'Active'),
(62, 24, 7, 2, 134, 75000, N'Active'),
(63, 25, 9, 5, 460, 120000, N'Active'),
(64, 25, 9, 5, 461, 120000, N'Active'),
(65, 25, 9, 5, 462, 120000, N'Active'),
(66, 25, 9, 5, 463, 120000, N'Active'),
(67, 26, 12, 2, 178, 90000, N'Active'),
(68, 26, 12, 2, 179, 90000, N'Active'),
(69, 27, 16, 2, 190, 90000, N'Active'),
(70, 28, 9, 5, 534, 144000, N'Active'),
(71, 28, 9, 5, 535, 144000, N'Active'),
(72, 29, 22, 2, 196, 90000, N'Active'),
(73, 29, 22, 2, 197, 90000, N'Active'),
(74, 30, 35, 2, 161, 90000, N'Active'),
(75, 30, 35, 2, 162, 90000, N'Active'),
(76, 30, 35, 2, 163, 90000, N'Active'),
(77, 31, 10, 4, 343, 90000, N'Cancelled'),
(78, 31, 10, 4, 344, 90000, N'Cancelled'),
(79, 31, 10, 4, 345, 90000, N'Cancelled'),
(80, 31, 10, 4, 346, 90000, N'Cancelled'),
(81, 32, 12, 2, 190, 90000, N'Active'),
(82, 33, 10, 4, 375, 108000, N'Active'),
(83, 33, 10, 4, 376, 108000, N'Active'),
(84, 33, 10, 4, 377, 108000, N'Active'),
(85, 33, 10, 4, 378, 108000, N'Active'),
(86, 34, 11, 1, 18, 75000, N'Active'),
(87, 34, 11, 1, 19, 75000, N'Active'),
(88, 34, 11, 1, 20, 75000, N'Active'),
(89, 35, 23, 4, 413, 108000, N'Active'),
(90, 35, 23, 4, 414, 108000, N'Active'),
(91, 35, 23, 4, 415, 108000, N'Active'),
(92, 36, 14, 5, 561, 144000, N'Active'),
(93, 36, 14, 5, 562, 144000, N'Active'),
(94, 37, 10, 4, 357, 90000, N'Active'),
(95, 37, 10, 4, 358, 90000, N'Active'),
(96, 38, 13, 3, 238, 75000, N'Active'),
(97, 39, 10, 4, 359, 90000, N'Cancelled'),
(98, 40, 14, 5, 484, 144000, N'Active'),
(99, 40, 14, 5, 485, 144000, N'Active'),
(100, 40, 14, 5, 486, 144000, N'Active'),
(101, 40, 14, 5, 487, 144000, N'Active'),
(102, 40, 14, 5, 488, 144000, N'Active'),
(103, 40, 14, 5, 489, 144000, N'Active'),
(104, 41, 21, 1, 91, 90000, N'Active'),
(105, 41, 21, 1, 92, 90000, N'Active'),
(106, 41, 21, 1, 93, 90000, N'Active'),
(107, 41, 21, 1, 94, 90000, N'Active'),
(108, 42, 52, 3, 220, 75000, N'Active'),
(109, 42, 52, 3, 221, 75000, N'Active'),
(110, 42, 52, 3, 222, 75000, N'Active'),
(111, 42, 52, 3, 223, 75000, N'Active'),
(112, 42, 52, 3, 224, 75000, N'Active'),
(113, 42, 52, 3, 225, 75000, N'Active'),
(114, 43, 24, 3, 287, 90000, N'Cancelled'),
(115, 43, 24, 3, 288, 90000, N'Cancelled'),
(116, 44, 13, 3, 219, 75000, N'Active'),
(117, 44, 13, 3, 220, 75000, N'Active'),
(118, 45, 23, 4, 417, 108000, N'Active'),
(119, 45, 23, 4, 418, 108000, N'Active'),
(120, 46, 14, 5, 514, 144000, N'Active'),
(121, 46, 14, 5, 515, 144000, N'Active'),
(122, 46, 14, 5, 516, 144000, N'Active'),
(123, 47, 21, 1, 53, 90000, N'Active'),
(124, 47, 21, 1, 54, 90000, N'Active'),
(125, 47, 21, 1, 55, 90000, N'Active'),
(126, 47, 21, 1, 56, 90000, N'Active'),
(127, 47, 21, 1, 57, 90000, N'Active'),
(128, 47, 21, 1, 58, 90000, N'Active'),
(129, 48, 16, 2, 154, 90000, N'Active'),
(130, 48, 16, 2, 155, 90000, N'Active'),
(131, 49, 75, 5, 486, 144000, N'Active'),
(132, 49, 75, 5, 487, 144000, N'Active'),
(133, 50, 28, 5, 545, 144000, N'Active'),
(134, 50, 28, 5, 546, 144000, N'Active'),
(135, 50, 28, 5, 547, 144000, N'Active'),
(136, 50, 28, 5, 548, 144000, N'Active'),
(137, 51, 14, 5, 533, 144000, N'Active'),
(138, 51, 14, 5, 534, 144000, N'Active'),
(139, 52, 38, 4, 425, 108000, N'Active'),
(140, 52, 38, 4, 426, 108000, N'Active'),
(141, 53, 15, 4, 401, 108000, N'Active'),
(142, 53, 15, 4, 402, 108000, N'Active'),
(143, 53, 15, 4, 403, 108000, N'Active'),
(144, 53, 15, 4, 404, 108000, N'Active'),
(145, 54, 19, 5, 448, 120000, N'Active'),
(146, 54, 19, 5, 449, 120000, N'Active'),
(147, 55, 19, 5, 518, 144000, N'Active'),
(148, 55, 19, 5, 519, 144000, N'Active'),
(149, 56, 15, 4, 365, 108000, N'Active'),
(150, 56, 15, 4, 366, 108000, N'Active'),
(151, 56, 15, 4, 367, 108000, N'Active'),
(152, 57, 27, 4, 388, 90000, N'Active'),
(153, 57, 27, 4, 389, 90000, N'Active'),
(154, 57, 27, 4, 390, 90000, N'Active'),
(155, 57, 27, 4, 391, 90000, N'Active'),
(156, 58, 20, 3, 315, 90000, N'Active'),
(157, 58, 20, 3, 316, 90000, N'Active'),
(158, 59, 21, 1, 71, 90000, N'Active'),
(159, 60, 18, 1, 55, 90000, N'Active'),
(160, 60, 18, 1, 56, 90000, N'Active'),
(161, 61, 20, 3, 256, 90000, N'Active'),
(162, 62, 41, 3, 304, 90000, N'Active'),
(163, 62, 41, 3, 305, 90000, N'Active'),
(164, 63, 22, 2, 147, 90000, N'Active'),
(165, 63, 22, 2, 148, 90000, N'Active'),
(166, 64, 25, 1, 91, 90000, N'Active'),
(167, 64, 25, 1, 92, 90000, N'Active'),
(168, 65, 17, 3, 307, 90000, N'Active'),
(169, 65, 17, 3, 308, 90000, N'Active'),
(170, 66, 19, 5, 481, 144000, N'Active'),
(171, 66, 19, 5, 482, 144000, N'Active'),
(172, 66, 19, 5, 483, 144000, N'Active'),
(173, 66, 19, 5, 484, 144000, N'Active'),
(174, 67, 76, 3, 301, 90000, N'Active'),
(175, 68, 21, 1, 40, 90000, N'Cancelled'),
(176, 68, 21, 1, 41, 90000, N'Cancelled'),
(177, 69, 18, 1, 91, 90000, N'Active'),
(178, 69, 18, 1, 92, 90000, N'Active'),
(179, 70, 25, 1, 101, 90000, N'Active'),
(180, 70, 25, 1, 102, 90000, N'Active'),
(181, 71, 55, 4, 365, 90000, N'Active'),
(182, 71, 55, 4, 366, 90000, N'Active'),
(183, 72, 23, 4, 367, 108000, N'Active'),
(184, 73, 24, 3, 291, 90000, N'Active'),
(185, 73, 24, 3, 292, 90000, N'Active'),
(186, 73, 24, 3, 293, 90000, N'Active'),
(187, 74, 23, 4, 387, 108000, N'Active'),
(188, 74, 23, 4, 388, 108000, N'Active'),
(189, 75, 27, 4, 379, 90000, N'Active'),
(190, 75, 27, 4, 380, 90000, N'Active'),
(191, 76, 49, 1, 93, 90000, N'Active'),
(192, 76, 49, 1, 94, 90000, N'Active'),
(193, 77, 19, 5, 559, 144000, N'Active'),
(194, 77, 19, 5, 560, 144000, N'Active'),
(195, 78, 54, 2, 114, 75000, N'Active'),
(196, 78, 54, 2, 115, 75000, N'Active'),
(197, 78, 54, 2, 116, 75000, N'Active'),
(198, 79, 22, 2, 124, 75000, N'Active'),
(199, 79, 22, 2, 125, 75000, N'Active'),
(200, 80, 17, 3, 292, 90000, N'Active'),
(201, 80, 17, 3, 293, 90000, N'Active'),
(202, 81, 21, 1, 62, 90000, N'Active'),
(203, 81, 21, 1, 63, 90000, N'Active'),
(204, 81, 21, 1, 64, 90000, N'Active'),
(205, 81, 21, 1, 65, 90000, N'Active'),
(206, 82, 42, 5, 546, 144000, N'Active'),
(207, 82, 42, 5, 547, 144000, N'Active'),
(208, 83, 47, 5, 485, 144000, N'Active'),
(209, 83, 47, 5, 486, 144000, N'Active'),
(210, 83, 47, 5, 487, 144000, N'Active'),
(211, 83, 47, 5, 488, 144000, N'Active'),
(212, 83, 47, 5, 489, 144000, N'Active'),
(213, 84, 69, 3, 278, 90000, N'Active'),
(214, 84, 69, 3, 279, 90000, N'Active'),
(215, 85, 19, 5, 521, 144000, N'Active'),
(216, 85, 19, 5, 522, 144000, N'Active'),
(217, 85, 19, 5, 523, 144000, N'Active'),
(218, 86, 25, 1, 58, 90000, N'Active'),
(219, 87, 23, 4, 331, 90000, N'Active'),
(220, 87, 23, 4, 332, 90000, N'Active'),
(221, 88, 54, 2, 176, 90000, N'Active'),
(222, 88, 54, 2, 177, 90000, N'Active'),
(223, 88, 54, 2, 178, 90000, N'Active'),
(224, 89, 25, 1, 41, 90000, N'Active'),
(225, 89, 25, 1, 42, 90000, N'Active'),
(226, 89, 25, 1, 43, 90000, N'Active'),
(227, 90, 51, 4, 405, 108000, N'Active'),
(228, 90, 51, 4, 406, 108000, N'Active'),
(229, 91, 26, 2, 174, 90000, N'Active'),
(230, 92, 25, 1, 5, 75000, N'Active'),
(231, 92, 25, 1, 6, 75000, N'Active'),
(232, 93, 55, 4, 381, 90000, N'Active'),
(233, 93, 55, 4, 382, 90000, N'Active'),
(234, 93, 55, 4, 383, 90000, N'Active'),
(235, 93, 55, 4, 384, 90000, N'Active'),
(236, 94, 28, 5, 487, 144000, N'Active'),
(237, 94, 28, 5, 488, 144000, N'Active'),
(238, 95, 19, 5, 505, 144000, N'Active'),
(239, 95, 19, 5, 506, 144000, N'Active'),
(240, 95, 19, 5, 507, 144000, N'Active'),
(241, 95, 19, 5, 508, 144000, N'Active'),
(242, 96, 53, 1, 79, 90000, N'Active'),
(243, 96, 53, 1, 80, 90000, N'Active'),
(244, 97, 21, 1, 70, 90000, N'Active'),
(245, 98, 28, 5, 473, 120000, N'Active'),
(246, 98, 28, 5, 474, 120000, N'Active'),
(247, 98, 28, 5, 475, 120000, N'Active'),
(248, 98, 28, 5, 476, 120000, N'Active'),
(249, 99, 22, 2, 162, 90000, N'Active'),
(250, 99, 22, 2, 163, 90000, N'Active'),
(251, 99, 22, 2, 164, 90000, N'Active'),
(252, 100, 24, 3, 281, 90000, N'Active'),
(253, 100, 24, 3, 282, 90000, N'Active'),
(254, 100, 24, 3, 283, 90000, N'Active'),
(255, 100, 24, 3, 284, 90000, N'Active'),
(256, 101, 49, 1, 54, 90000, N'Active'),
(257, 102, 27, 4, 345, 75000, N'Active'),
(258, 102, 27, 4, 346, 75000, N'Active'),
(259, 103, 28, 5, 542, 144000, N'Active'),
(260, 103, 28, 5, 543, 144000, N'Active'),
(261, 104, 23, 4, 364, 108000, N'Cancelled'),
(262, 104, 23, 4, 365, 108000, N'Cancelled'),
(263, 104, 23, 4, 366, 108000, N'Cancelled'),
(264, 105, 22, 2, 205, 90000, N'Active'),
(265, 105, 22, 2, 206, 90000, N'Active'),
(266, 106, 47, 5, 497, 144000, N'Active'),
(267, 106, 47, 5, 498, 144000, N'Active'),
(268, 107, 28, 5, 557, 144000, N'Active'),
(269, 107, 28, 5, 558, 144000, N'Active'),
(270, 108, 44, 2, 157, 90000, N'Active'),
(271, 108, 44, 2, 158, 90000, N'Active'),
(272, 109, 25, 1, 78, 90000, N'Active'),
(273, 109, 25, 1, 79, 90000, N'Active'),
(274, 110, 25, 1, 46, 90000, N'Active'),
(275, 110, 25, 1, 47, 90000, N'Active'),
(276, 111, 26, 2, 165, 90000, N'Active'),
(277, 111, 26, 2, 166, 90000, N'Active'),
(278, 112, 37, 5, 535, 144000, N'Active'),
(279, 113, 26, 2, 159, 90000, N'Cancelled'),
(280, 113, 26, 2, 160, 90000, N'Cancelled'),
(281, 113, 26, 2, 161, 90000, N'Cancelled'),
(282, 114, 25, 1, 66, 90000, N'Active'),
(283, 114, 25, 1, 67, 90000, N'Active'),
(284, 114, 25, 1, 68, 90000, N'Active'),
(285, 115, 54, 2, 187, 90000, N'Active'),
(286, 115, 54, 2, 188, 90000, N'Active'),
(287, 116, 26, 2, 182, 90000, N'Active'),
(288, 116, 26, 2, 183, 90000, N'Active'),
(289, 116, 26, 2, 184, 90000, N'Active'),
(290, 116, 26, 2, 185, 90000, N'Active'),
(291, 117, 79, 4, 377, 108000, N'Active'),
(292, 117, 79, 4, 378, 108000, N'Active'),
(293, 117, 79, 4, 379, 108000, N'Active'),
(294, 118, 51, 4, 411, 108000, N'Active'),
(295, 118, 51, 4, 412, 108000, N'Active'),
(296, 118, 51, 4, 413, 108000, N'Active'),
(297, 118, 51, 4, 414, 108000, N'Active'),
(298, 118, 51, 4, 415, 108000, N'Active'),
(299, 118, 51, 4, 416, 108000, N'Active'),
(300, 119, 28, 5, 508, 144000, N'Active'),
(301, 119, 28, 5, 509, 144000, N'Active'),
(302, 119, 28, 5, 510, 144000, N'Active'),
(303, 120, 47, 5, 506, 144000, N'Active'),
(304, 120, 47, 5, 507, 144000, N'Active'),
(305, 121, 28, 5, 512, 144000, N'Active'),
(306, 121, 28, 5, 513, 144000, N'Active'),
(307, 122, 28, 5, 462, 120000, N'Active'),
(308, 123, 28, 5, 481, 144000, N'Cancelled'),
(309, 123, 28, 5, 482, 144000, N'Cancelled'),
(310, 124, 41, 3, 302, 90000, N'Active'),
(311, 124, 41, 3, 303, 90000, N'Active'),
(312, 125, 28, 5, 537, 144000, N'Active'),
(313, 125, 28, 5, 538, 144000, N'Active'),
(314, 126, 51, 4, 370, 108000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 4 11/11/2026: 138 hoa don (6 huy), 300 ve, doanh thu 29.048.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(127, 6, NULL, '2026-11-11T08:05:27', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 33 | Thiên Đường Tăm Tối | 11/11 09:30 | Phòng 3 | F1
(128, 7, NULL, '2026-11-11T08:13:20', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 30 | Godzilla Trừ Không | 11/11 09:00 | Phòng 5 | L11 L12
(129, 6, NULL, '2026-11-11T08:13:27', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 77 | Bò Sữa Bay | 12/11 18:30 | Phòng 1 | H5 H6
(130, 7, NULL, '2026-11-11T08:28:02', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 30 | Godzilla Trừ Không | 11/11 09:00 | Phòng 5 | F7
(131, 6, 89, '2026-11-11T08:29:44', 288000, N'Paid', N'Transfer', NULL, 28, 0, NULL, NULL, NULL), -- suat 30 | Godzilla Trừ Không | 11/11 09:00 | Phòng 5 | L5 L6
(132, 7, NULL, '2026-11-11T08:30:56', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 29 | Bò Sữa Bay | 11/11 09:00 | Phòng 1 | D7 D8 D9
(133, 7, 9, '2026-11-11T08:35:56', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 32 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 11/11 09:30 | Phòng 2 | D6 D7
(134, 6, 108, '2026-11-11T08:40:23', 480000, N'Paid', N'Cash', 480000, 24, 0, NULL, NULL, NULL), -- suat 30 | Godzilla Trừ Không | 11/11 09:00 | Phòng 5 | A4 A5 A6 A7
(135, 7, 44, '2026-11-11T08:41:23', 270000, N'Paid', N'Cash', 300000, 13, 0, NULL, NULL, NULL), -- suat 31 | Ramayana: Khởi Nguồn Một Huyền Thoại | 11/11 09:15 | Phòng 4 | C1 C2 C3
(136, 7, NULL, '2026-11-11T08:45:25', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 31 | Ramayana: Khởi Nguồn Một Huyền Thoại | 11/11 09:15 | Phòng 4 | C9 C10
(137, 6, NULL, '2026-11-11T08:49:43', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 84 | Godzilla Trừ Không | 12/11 21:00 | Phòng 5 | E2 E3
(138, 6, 10, '2026-11-11T08:57:02', 216000, N'Paid', N'Transfer', NULL, 21, 0, NULL, NULL, NULL), -- suat 66 | Godzilla Trừ Không | 12/11 12:30 | Phòng 4 | J7 J8
(139, 6, NULL, '2026-11-11T09:11:49', 300000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 46 | Ngày Con Còn Mẹ | 11/11 16:00 | Phòng 1 | C6 C7 C8 C9
(140, 7, 29, '2026-11-11T09:16:16', 648000, N'Paid', N'Card', NULL, 45, 0, NULL, NULL, NULL), -- suat 79 | Godzilla Trừ Không | 12/11 18:30 | Phòng 4 | G7 G8 G9 G10 G11 G12
(141, 7, NULL, '2026-11-11T09:31:04', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 78 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 12/11 18:30 | Phòng 2 | H6 H7
(142, 7, 1, '2026-11-11T09:31:51', 288000, N'Paid', N'Cash', 290000, 28, 0, NULL, NULL, NULL), -- suat 37 | Ramayana: Khởi Nguồn Một Huyền Thoại | 11/11 11:45 | Phòng 5 | L11 L12
(143, 7, NULL, '2026-11-11T09:39:23', 240000, N'Paid', N'Cash', 240000, 0, 0, NULL, NULL, NULL), -- suat 75 | Ramayana: Khởi Nguồn Một Huyền Thoại | 12/11 17:45 | Phòng 5 | D5 D6
(144, 7, 1, '2026-11-11T09:50:14', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 72 | Trại Buôn Người | 12/11 15:45 | Phòng 2 | B1 B2
(145, 6, NULL, '2026-11-11T09:53:40', 216000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-11-11T10:31:41', 6), -- suat 66 | Godzilla Trừ Không | 12/11 12:30 | Phòng 4 | E6 E7
(146, 6, NULL, '2026-11-11T09:58:15', 216000, N'Paid', N'Cash', 220000, 0, 0, NULL, NULL, NULL), -- suat 38 | Godzilla Trừ Không | 11/11 12:30 | Phòng 4 | J9 J10
(147, 7, 89, '2026-11-11T10:01:38', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 81 | Chị Chị Em Em 3 | 12/11 20:45 | Phòng 1 | H6 H7
(148, 7, NULL, '2026-11-11T10:06:11', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 38 | Godzilla Trừ Không | 11/11 12:30 | Phòng 4 | J7 J8
(149, 7, NULL, '2026-11-11T10:14:52', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 42 | Godzilla Trừ Không | 11/11 15:00 | Phòng 5 | H8
(150, 6, NULL, '2026-11-11T10:15:24', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 34 | Ngày Con Còn Mẹ | 11/11 11:15 | Phòng 1 | E3 E4 E5
(151, 6, 36, '2026-11-11T10:15:31', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 35 | Chàng Mèo Mang Mũ | 11/11 11:30 | Phòng 2 | H3 H4 H5 H6
(152, 6, NULL, '2026-11-11T10:17:04', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 81 | Chị Chị Em Em 3 | 12/11 20:45 | Phòng 1 | E8
(153, 7, NULL, '2026-11-11T10:19:31', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 35 | Chàng Mèo Mang Mũ | 11/11 11:30 | Phòng 2 | J3 J4
(154, 7, 72, '2026-11-11T10:28:17', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 42 | Godzilla Trừ Không | 11/11 15:00 | Phòng 5 | K3 K4
(155, 6, NULL, '2026-11-11T10:31:55', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 36 | Clayface | 11/11 11:30 | Phòng 3 | J1 J2
(156, 7, NULL, '2026-11-11T10:34:26', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 34 | Ngày Con Còn Mẹ | 11/11 11:15 | Phòng 1 | H8
(157, 7, NULL, '2026-11-11T10:45:18', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 39 | Bò Sữa Bay | 11/11 13:45 | Phòng 1 | G5 G6
(158, 7, NULL, '2026-11-11T10:51:07', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 46 | Ngày Con Còn Mẹ | 11/11 16:00 | Phòng 1 | A8 A9
(159, 7, NULL, '2026-11-11T11:00:05', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 50 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 11/11 18:30 | Phòng 2 | G5
(160, 6, NULL, '2026-11-11T11:01:20', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 111 | Bí Kíp Luyện Cướp | 13/11 21:00 | Phòng 4 | F8 F9
(161, 6, NULL, '2026-11-11T11:03:47', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 34 | Ngày Con Còn Mẹ | 11/11 11:15 | Phòng 1 | F6 F7
(162, 6, NULL, '2026-11-11T11:03:55', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 51 | Godzilla Trừ Không | 11/11 18:30 | Phòng 4 | G2 G3
(163, 6, 25, '2026-11-11T11:04:26', 144000, N'Paid', N'Cash', 144000, 10, 0, NULL, NULL, NULL), -- suat 93 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 11:45 | Phòng 5 | F12
(164, 7, NULL, '2026-11-11T11:07:18', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 50 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 11/11 18:30 | Phòng 2 | J3 J4
(165, 7, NULL, '2026-11-11T11:08:20', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 42 | Godzilla Trừ Không | 11/11 15:00 | Phòng 5 | F4 F5 F6
(166, 7, 55, '2026-11-11T11:13:24', 245000, N'Cancelled', N'Transfer', NULL, 17, 25, N'Khách đổi ý', '2026-11-11T11:14:56', 7), -- suat 36 | Clayface | 11/11 11:30 | Phòng 3 | F3 F4 F5
(167, 7, NULL, '2026-11-11T11:13:44', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 46 | Ngày Con Còn Mẹ | 11/11 16:00 | Phòng 1 | D7 D8
(168, 6, NULL, '2026-11-11T11:19:06', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 43 | Ramayana: Khởi Nguồn Một Huyền Thoại | 11/11 15:15 | Phòng 4 | H4 H5
(169, 6, 67, '2026-11-11T11:27:52', 270000, N'Paid', N'Cash', 300000, 18, 0, NULL, NULL, NULL), -- suat 39 | Bò Sữa Bay | 11/11 13:45 | Phòng 1 | H5 H6 H7
(170, 7, NULL, '2026-11-11T11:47:15', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 45 | Clayface | 11/11 15:45 | Phòng 3 | F6 F7
(171, 7, NULL, '2026-11-11T11:50:40', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 49 | Bò Sữa Bay | 11/11 18:30 | Phòng 1 | H7 H8
(172, 6, NULL, '2026-11-11T11:52:51', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 38 | Godzilla Trừ Không | 11/11 12:30 | Phòng 4 | G6 G7
(173, 6, 36, '2026-11-11T11:55:24', 225000, N'Paid', N'Card', NULL, 11, 0, NULL, NULL, NULL), -- suat 45 | Clayface | 11/11 15:45 | Phòng 3 | C2 C3 C4
(174, 7, 42, '2026-11-11T12:06:13', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 102 | Ngày Con Còn Mẹ | 13/11 16:00 | Phòng 1 | J11 J12
(175, 6, NULL, '2026-11-11T12:08:05', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 56 | Godzilla Trừ Không | 11/11 21:00 | Phòng 5 | K6 K7 K8
(176, 7, NULL, '2026-11-11T12:11:40', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 42 | Godzilla Trừ Không | 11/11 15:00 | Phòng 5 | G6 G7 G8
(177, 7, 78, '2026-11-11T12:19:03', 576000, N'Paid', N'Cash', 600000, 40, 0, NULL, NULL, NULL), -- suat 42 | Godzilla Trừ Không | 11/11 15:00 | Phòng 5 | E8 E9 E10 E11
(178, 6, NULL, '2026-11-11T12:23:58', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 39 | Bò Sữa Bay | 11/11 13:45 | Phòng 1 | D11
(179, 6, NULL, '2026-11-11T12:25:44', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 50 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 11/11 18:30 | Phòng 2 | G6 G7
(180, 7, NULL, '2026-11-11T12:26:49', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 39 | Bò Sữa Bay | 11/11 13:45 | Phòng 1 | J1 J2
(181, 6, NULL, '2026-11-11T12:29:42', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 44 | Trại Buôn Người | 11/11 15:45 | Phòng 2 | E9 E10
(182, 6, NULL, '2026-11-11T12:34:09', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 51 | Godzilla Trừ Không | 11/11 18:30 | Phòng 4 | F2 F3
(183, 7, NULL, '2026-11-11T12:35:34', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 43 | Ramayana: Khởi Nguồn Một Huyền Thoại | 11/11 15:15 | Phòng 4 | F10 F11
(184, 7, NULL, '2026-11-11T12:35:44', 324000, N'Paid', N'Cash', 350000, 0, 0, NULL, NULL, NULL), -- suat 51 | Godzilla Trừ Không | 11/11 18:30 | Phòng 4 | F6 F7 F8
(185, 7, NULL, '2026-11-11T12:38:11', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 49 | Bò Sữa Bay | 11/11 18:30 | Phòng 1 | D6 D7
(186, 6, NULL, '2026-11-11T12:45:58', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 44 | Trại Buôn Người | 11/11 15:45 | Phòng 2 | F4
(187, 6, 42, '2026-11-11T12:46:50', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 49 | Bò Sữa Bay | 11/11 18:30 | Phòng 1 | D12
(188, 6, NULL, '2026-11-11T12:58:47', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 42 | Godzilla Trừ Không | 11/11 15:00 | Phòng 5 | J6
(189, 7, NULL, '2026-11-11T13:01:25', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 44 | Trại Buôn Người | 11/11 15:45 | Phòng 2 | E4 E5
(190, 6, 82, '2026-11-11T13:28:07', 216000, N'Paid', N'Cash', 250000, 15, 0, NULL, NULL, NULL), -- suat 43 | Ramayana: Khởi Nguồn Một Huyền Thoại | 11/11 15:15 | Phòng 4 | D6 D7
(191, 7, NULL, '2026-11-11T13:30:27', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 80 | Clayface | 12/11 20:15 | Phòng 3 | E11 E12
(192, 6, NULL, '2026-11-11T13:36:13', 108000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 51 | Godzilla Trừ Không | 11/11 18:30 | Phòng 4 | D3
(193, 7, NULL, '2026-11-11T13:36:54', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 64 | Clayface | 12/11 11:30 | Phòng 3 | D7 D8 D9
(194, 6, NULL, '2026-11-11T13:40:59', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 56 | Godzilla Trừ Không | 11/11 21:00 | Phòng 5 | F8 F9
(195, 6, 113, '2026-11-11T13:44:39', 160000, N'Paid', N'Card', NULL, 11, 20, NULL, NULL, NULL), -- suat 49 | Bò Sữa Bay | 11/11 18:30 | Phòng 1 | G7 G8
(196, 6, 113, '2026-11-11T13:47:16', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 109 | Chị Chị Em Em 3 | 13/11 20:45 | Phòng 1 | D9
(197, 7, NULL, '2026-11-11T13:53:37', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 52 | Clayface | 11/11 20:15 | Phòng 3 | E4 E5
(198, 6, NULL, '2026-11-11T13:55:45', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 46 | Ngày Con Còn Mẹ | 11/11 16:00 | Phòng 1 | J5 J6
(199, 7, NULL, '2026-11-11T13:56:55', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 48 | Thiên Đường Tăm Tối | 11/11 18:15 | Phòng 3 | B5 B6
(200, 7, NULL, '2026-11-11T14:09:06', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 46 | Ngày Con Còn Mẹ | 11/11 16:00 | Phòng 1 | B2 B3
(201, 6, NULL, '2026-11-11T14:09:29', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 45 | Clayface | 11/11 15:45 | Phòng 3 | E8 E9 E10
(202, 7, NULL, '2026-11-11T14:10:32', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 47 | Ramayana: Khởi Nguồn Một Huyền Thoại | 11/11 17:45 | Phòng 5 | H11 H12
(203, 6, NULL, '2026-11-11T14:10:52', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 93 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 11:45 | Phòng 5 | B4 B5 B6
(204, 7, NULL, '2026-11-11T14:19:15', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 45 | Clayface | 11/11 15:45 | Phòng 3 | J7 J8
(205, 7, 47, '2026-11-11T14:38:32', 180000, N'Paid', N'Cash', 180000, 9, 0, NULL, NULL, NULL), -- suat 51 | Godzilla Trừ Không | 11/11 18:30 | Phòng 4 | B6 B7
(206, 7, NULL, '2026-11-11T14:50:38', 576000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 47 | Ramayana: Khởi Nguồn Một Huyền Thoại | 11/11 17:45 | Phòng 5 | H5 H6 H7 H8
(207, 6, NULL, '2026-11-11T14:56:31', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 50 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 11/11 18:30 | Phòng 2 | H2 H3
(208, 7, 59, '2026-11-11T14:58:43', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 44 | Trại Buôn Người | 11/11 15:45 | Phòng 2 | J3 J4
(209, 8, 9, '2026-11-11T15:00:08', 240000, N'Paid', N'Cash', 240000, 12, 0, NULL, NULL, NULL), -- suat 103 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 17:45 | Phòng 5 | B9 B10
(210, 8, 93, '2026-11-11T15:01:24', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 55 | Bò Sữa Bay | 11/11 21:00 | Phòng 4 | H11
(211, 9, 79, '2026-11-11T15:12:34', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 81 | Chị Chị Em Em 3 | 12/11 20:45 | Phòng 1 | C5 C6
(212, 9, 69, '2026-11-11T15:13:28', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 55 | Bò Sữa Bay | 11/11 21:00 | Phòng 4 | J5 J6
(213, 9, NULL, '2026-11-11T15:24:38', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 47 | Ramayana: Khởi Nguồn Một Huyền Thoại | 11/11 17:45 | Phòng 5 | C8 C9
(214, 9, NULL, '2026-11-11T15:24:49', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 51 | Godzilla Trừ Không | 11/11 18:30 | Phòng 4 | E5 E6
(215, 8, NULL, '2026-11-11T15:30:29', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 53 | Chị Chị Em Em 3 | 11/11 20:45 | Phòng 1 | E7 E8 E9 E10
(216, 9, NULL, '2026-11-11T15:32:01', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 50 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 11/11 18:30 | Phòng 2 | E10 E11
(217, 8, NULL, '2026-11-11T15:35:58', 120000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 47 | Ramayana: Khởi Nguồn Một Huyền Thoại | 11/11 17:45 | Phòng 5 | D10
(218, 9, NULL, '2026-11-11T15:37:56', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 53 | Chị Chị Em Em 3 | 11/11 20:45 | Phòng 1 | D4 D5
(219, 8, NULL, '2026-11-11T15:38:56', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 50 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 11/11 18:30 | Phòng 2 | F11
(220, 8, NULL, '2026-11-11T15:42:35', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 48 | Thiên Đường Tăm Tối | 11/11 18:15 | Phòng 3 | D3 D4
(221, 9, NULL, '2026-11-11T15:53:24', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 54 | Trại Buôn Người | 11/11 20:45 | Phòng 2 | F6 F7
(222, 9, 44, '2026-11-11T15:53:48', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 49 | Bò Sữa Bay | 11/11 18:30 | Phòng 1 | E7 E8
(223, 8, NULL, '2026-11-11T16:04:49', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 48 | Thiên Đường Tăm Tối | 11/11 18:15 | Phòng 3 | E1
(224, 9, NULL, '2026-11-11T16:05:09', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 50 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 11/11 18:30 | Phòng 2 | G9 G10
(225, 9, NULL, '2026-11-11T16:05:24', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 56 | Godzilla Trừ Không | 11/11 21:00 | Phòng 5 | F3 F4
(226, 9, NULL, '2026-11-11T16:08:43', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 51 | Godzilla Trừ Không | 11/11 18:30 | Phòng 4 | B8 B9 B10
(227, 9, NULL, '2026-11-11T16:14:20', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 47 | Ramayana: Khởi Nguồn Một Huyền Thoại | 11/11 17:45 | Phòng 5 | J10
(228, 8, 25, '2026-11-11T16:18:09', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 50 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 11/11 18:30 | Phòng 2 | E6 E7
(229, 9, 117, '2026-11-11T16:18:57', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 106 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 13/11 18:30 | Phòng 2 | D7 D8
(230, 9, NULL, '2026-11-11T16:21:55', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 52 | Clayface | 11/11 20:15 | Phòng 3 | D7 D8
(231, 9, NULL, '2026-11-11T16:24:34', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 53 | Chị Chị Em Em 3 | 11/11 20:45 | Phòng 1 | C1 C2 C3
(232, 9, NULL, '2026-11-11T16:25:12', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 55 | Bò Sữa Bay | 11/11 21:00 | Phòng 4 | E3 E4 E5
(233, 9, 114, '2026-11-11T16:36:53', 240000, N'Paid', N'Cash', 240000, 12, 0, NULL, NULL, NULL), -- suat 56 | Godzilla Trừ Không | 11/11 21:00 | Phòng 5 | C4 C5
(234, 8, NULL, '2026-11-11T16:53:17', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 51 | Godzilla Trừ Không | 11/11 18:30 | Phòng 4 | D5 D6 D7 D8
(235, 9, NULL, '2026-11-11T17:01:53', 540000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 77 | Bò Sữa Bay | 12/11 18:30 | Phòng 1 | D3 D4 D5 D6 D7 D8
(236, 8, NULL, '2026-11-11T17:02:15', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 55 | Bò Sữa Bay | 11/11 21:00 | Phòng 4 | C10 C11 C12
(237, 9, NULL, '2026-11-11T17:09:33', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 101 | Bí Kíp Luyện Cướp | 13/11 15:45 | Phòng 3 | C5 C6 C7
(238, 8, 77, '2026-11-11T17:17:24', 144000, N'Paid', N'Transfer', NULL, 10, 0, NULL, NULL, NULL), -- suat 56 | Godzilla Trừ Không | 11/11 21:00 | Phòng 5 | H3
(239, 8, NULL, '2026-11-11T17:18:36', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 49 | Bò Sữa Bay | 11/11 18:30 | Phòng 1 | C9 C10 C11
(240, 9, NULL, '2026-11-11T17:23:07', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 74 | Ngày Con Còn Mẹ | 12/11 16:00 | Phòng 1 | B10 B11
(241, 9, 92, '2026-11-11T17:25:49', 180000, N'Paid', N'Card', NULL, 9, 0, NULL, NULL, NULL), -- suat 51 | Godzilla Trừ Không | 11/11 18:30 | Phòng 4 | C6 C7
(242, 9, NULL, '2026-11-11T17:26:37', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 53 | Chị Chị Em Em 3 | 11/11 20:45 | Phòng 1 | F1 F2
(243, 9, 48, '2026-11-11T17:37:15', 180000, N'Cancelled', N'Cash', 180000, 12, 0, N'Sự cố phòng chiếu', '2026-11-11T21:10:38', 2), -- suat 54 | Trại Buôn Người | 11/11 20:45 | Phòng 2 | F3 F4
(244, 9, NULL, '2026-11-11T17:41:18', 90000, N'Cancelled', N'Cash', 100000, 0, 0, N'Nhầm suất / ghế', '2026-11-11T17:49:36', 9), -- suat 48 | Thiên Đường Tăm Tối | 11/11 18:15 | Phòng 3 | G5
(245, 9, 78, '2026-11-11T17:46:49', 169000, N'Paid', N'Card', NULL, 11, 47, NULL, NULL, NULL), -- suat 51 | Godzilla Trừ Không | 11/11 18:30 | Phòng 4 | F10 F11
(246, 8, NULL, '2026-11-11T18:11:33', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 107 | Godzilla Trừ Không | 13/11 18:30 | Phòng 4 | B12
(247, 9, NULL, '2026-11-11T18:20:55', 300000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 52 | Clayface | 11/11 20:15 | Phòng 3 | B7 B8 B9 B10
(248, 8, NULL, '2026-11-11T18:27:57', 225000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 54 | Trại Buôn Người | 11/11 20:45 | Phòng 2 | C6 C7 C8
(249, 9, NULL, '2026-11-11T18:33:11', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 68 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 12/11 13:45 | Phòng 2 | G9 G10 G11
(250, 9, NULL, '2026-11-11T18:38:23', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 52 | Clayface | 11/11 20:15 | Phòng 3 | F1 F2 F3
(251, 8, 81, '2026-11-11T18:41:34', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 75 | Ramayana: Khởi Nguồn Một Huyền Thoại | 12/11 17:45 | Phòng 5 | G4 G5
(252, 9, NULL, '2026-11-11T18:44:37', 450000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 55 | Bò Sữa Bay | 11/11 21:00 | Phòng 4 | G3 G4 G5 G6 G7
(253, 9, NULL, '2026-11-11T18:49:27', 180000, N'Cancelled', N'Cash', 180000, 0, 0, N'Khách đổi ý', '2026-11-11T19:19:39', 9), -- suat 62 | Ngày Con Còn Mẹ | 12/11 11:15 | Phòng 1 | D6 D7
(254, 8, NULL, '2026-11-11T18:49:48', 75000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 52 | Clayface | 11/11 20:15 | Phòng 3 | C8
(255, 9, NULL, '2026-11-11T18:52:16', 90000, N'Cancelled', N'Cash', 90000, 0, 0, N'Nhầm suất / ghế', '2026-11-11T19:02:58', 9), -- suat 54 | Trại Buôn Người | 11/11 20:45 | Phòng 2 | E9
(256, 8, 89, '2026-11-11T18:53:47', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 54 | Trại Buôn Người | 11/11 20:45 | Phòng 2 | E10 E11
(257, 8, NULL, '2026-11-11T18:54:13', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 52 | Clayface | 11/11 20:15 | Phòng 3 | B5 B6
(258, 9, NULL, '2026-11-11T19:04:56', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 53 | Chị Chị Em Em 3 | 11/11 20:45 | Phòng 1 | D6
(259, 8, NULL, '2026-11-11T19:15:38', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 56 | Godzilla Trừ Không | 11/11 21:00 | Phòng 5 | L5 L6
(260, 8, 119, '2026-11-11T20:29:43', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 66 | Godzilla Trừ Không | 12/11 12:30 | Phòng 4 | D5 D6
(261, 8, 25, '2026-11-11T20:33:43', 216000, N'Paid', N'Cash', 250000, 15, 0, NULL, NULL, NULL), -- suat 79 | Godzilla Trừ Không | 12/11 18:30 | Phòng 4 | E11 E12
(262, 8, NULL, '2026-11-11T20:51:22', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 84 | Godzilla Trừ Không | 12/11 21:00 | Phòng 5 | E6 E7
(263, 9, NULL, '2026-11-11T21:21:24', 144000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 103 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 17:45 | Phòng 5 | K12
(264, 9, NULL, '2026-11-11T21:33:50', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL); -- suat 79 | Godzilla Trừ Không | 12/11 18:30 | Phòng 4 | J7 J8
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(315, 127, 33, 3, 277, 90000, N'Active'),
(316, 128, 30, 5, 563, 144000, N'Active'),
(317, 128, 30, 5, 564, 144000, N'Active'),
(318, 129, 77, 1, 89, 90000, N'Active'),
(319, 129, 77, 1, 90, 90000, N'Active'),
(320, 130, 30, 5, 499, 144000, N'Active'),
(321, 131, 30, 5, 557, 144000, N'Active'),
(322, 131, 30, 5, 558, 144000, N'Active'),
(323, 132, 29, 1, 43, 90000, N'Active'),
(324, 132, 29, 1, 44, 90000, N'Active'),
(325, 132, 29, 1, 45, 90000, N'Active'),
(326, 133, 32, 2, 150, 90000, N'Active'),
(327, 133, 32, 2, 151, 90000, N'Active'),
(328, 134, 30, 5, 436, 120000, N'Active'),
(329, 134, 30, 5, 437, 120000, N'Active'),
(330, 134, 30, 5, 438, 120000, N'Active'),
(331, 134, 30, 5, 439, 120000, N'Active'),
(332, 135, 31, 4, 349, 90000, N'Active'),
(333, 135, 31, 4, 350, 90000, N'Active'),
(334, 135, 31, 4, 351, 90000, N'Active'),
(335, 136, 31, 4, 357, 90000, N'Active'),
(336, 136, 31, 4, 358, 90000, N'Active'),
(337, 137, 84, 5, 482, 144000, N'Active'),
(338, 137, 84, 5, 483, 144000, N'Active'),
(339, 138, 66, 4, 427, 108000, N'Active'),
(340, 138, 66, 4, 428, 108000, N'Active'),
(341, 139, 46, 1, 30, 75000, N'Active'),
(342, 139, 46, 1, 31, 75000, N'Active'),
(343, 139, 46, 1, 32, 75000, N'Active'),
(344, 139, 46, 1, 33, 75000, N'Active'),
(345, 140, 79, 4, 403, 108000, N'Active'),
(346, 140, 79, 4, 404, 108000, N'Active'),
(347, 140, 79, 4, 405, 108000, N'Active'),
(348, 140, 79, 4, 406, 108000, N'Active'),
(349, 140, 79, 4, 407, 108000, N'Active'),
(350, 140, 79, 4, 408, 108000, N'Active'),
(351, 141, 78, 2, 198, 90000, N'Active'),
(352, 141, 78, 2, 199, 90000, N'Active'),
(353, 142, 37, 5, 563, 144000, N'Active'),
(354, 142, 37, 5, 564, 144000, N'Active'),
(355, 143, 75, 5, 473, 120000, N'Active'),
(356, 143, 75, 5, 474, 120000, N'Active'),
(357, 144, 72, 2, 121, 75000, N'Active'),
(358, 144, 72, 2, 122, 75000, N'Active'),
(359, 145, 66, 4, 378, 108000, N'Cancelled'),
(360, 145, 66, 4, 379, 108000, N'Cancelled'),
(361, 146, 38, 4, 429, 108000, N'Active'),
(362, 146, 38, 4, 430, 108000, N'Active'),
(363, 147, 81, 1, 90, 90000, N'Active'),
(364, 147, 81, 1, 91, 90000, N'Active'),
(365, 148, 38, 4, 427, 108000, N'Active'),
(366, 148, 38, 4, 428, 108000, N'Active'),
(367, 149, 42, 5, 524, 144000, N'Active'),
(368, 150, 34, 1, 51, 90000, N'Active'),
(369, 150, 34, 1, 52, 90000, N'Active'),
(370, 150, 34, 1, 53, 90000, N'Active'),
(371, 151, 35, 2, 195, 90000, N'Active'),
(372, 151, 35, 2, 196, 90000, N'Active'),
(373, 151, 35, 2, 197, 90000, N'Active'),
(374, 151, 35, 2, 198, 90000, N'Active'),
(375, 152, 81, 1, 56, 90000, N'Active'),
(376, 153, 35, 2, 207, 90000, N'Active'),
(377, 153, 35, 2, 208, 90000, N'Active'),
(378, 154, 42, 5, 543, 144000, N'Active'),
(379, 154, 42, 5, 544, 144000, N'Active'),
(380, 155, 36, 3, 313, 90000, N'Active'),
(381, 155, 36, 3, 314, 90000, N'Active'),
(382, 156, 34, 1, 92, 90000, N'Active'),
(383, 157, 39, 1, 77, 90000, N'Active'),
(384, 157, 39, 1, 78, 90000, N'Active'),
(385, 158, 46, 1, 8, 75000, N'Active'),
(386, 158, 46, 1, 9, 75000, N'Active'),
(387, 159, 50, 2, 185, 90000, N'Active'),
(388, 160, 111, 4, 392, 90000, N'Active'),
(389, 160, 111, 4, 393, 90000, N'Active'),
(390, 161, 34, 1, 66, 90000, N'Active'),
(391, 161, 34, 1, 67, 90000, N'Active'),
(392, 162, 51, 4, 398, 108000, N'Active'),
(393, 162, 51, 4, 399, 108000, N'Active'),
(394, 163, 93, 5, 504, 144000, N'Active'),
(395, 164, 50, 2, 207, 90000, N'Active'),
(396, 164, 50, 2, 208, 90000, N'Active'),
(397, 165, 42, 5, 496, 144000, N'Active'),
(398, 165, 42, 5, 497, 144000, N'Active'),
(399, 165, 42, 5, 498, 144000, N'Active'),
(400, 166, 36, 3, 279, 90000, N'Cancelled'),
(401, 166, 36, 3, 280, 90000, N'Cancelled'),
(402, 166, 36, 3, 281, 90000, N'Cancelled'),
(403, 167, 46, 1, 43, 90000, N'Active'),
(404, 167, 46, 1, 44, 90000, N'Active'),
(405, 168, 43, 4, 412, 108000, N'Active'),
(406, 168, 43, 4, 413, 108000, N'Active'),
(407, 169, 39, 1, 89, 90000, N'Active'),
(408, 169, 39, 1, 90, 90000, N'Active'),
(409, 169, 39, 1, 91, 90000, N'Active'),
(410, 170, 45, 3, 282, 90000, N'Active'),
(411, 170, 45, 3, 283, 90000, N'Active'),
(412, 171, 49, 1, 91, 90000, N'Active'),
(413, 171, 49, 1, 92, 90000, N'Active'),
(414, 172, 38, 4, 402, 108000, N'Active'),
(415, 172, 38, 4, 403, 108000, N'Active'),
(416, 173, 45, 3, 242, 75000, N'Active'),
(417, 173, 45, 3, 243, 75000, N'Active'),
(418, 173, 45, 3, 244, 75000, N'Active'),
(419, 174, 102, 1, 107, 90000, N'Active'),
(420, 174, 102, 1, 108, 90000, N'Active'),
(421, 175, 56, 5, 546, 144000, N'Active'),
(422, 175, 56, 5, 547, 144000, N'Active'),
(423, 175, 56, 5, 548, 144000, N'Active'),
(424, 176, 42, 5, 510, 144000, N'Active'),
(425, 176, 42, 5, 511, 144000, N'Active'),
(426, 176, 42, 5, 512, 144000, N'Active'),
(427, 177, 42, 5, 488, 144000, N'Active'),
(428, 177, 42, 5, 489, 144000, N'Active'),
(429, 177, 42, 5, 490, 144000, N'Active'),
(430, 177, 42, 5, 491, 144000, N'Active'),
(431, 178, 39, 1, 47, 90000, N'Active'),
(432, 179, 50, 2, 186, 90000, N'Active'),
(433, 179, 50, 2, 187, 90000, N'Active'),
(434, 180, 39, 1, 97, 90000, N'Active'),
(435, 180, 39, 1, 98, 90000, N'Active'),
(436, 181, 44, 2, 165, 90000, N'Active'),
(437, 181, 44, 2, 166, 90000, N'Active'),
(438, 182, 51, 4, 386, 108000, N'Active'),
(439, 182, 51, 4, 387, 108000, N'Active'),
(440, 183, 43, 4, 394, 108000, N'Active'),
(441, 183, 43, 4, 395, 108000, N'Active'),
(442, 184, 51, 4, 390, 108000, N'Active'),
(443, 184, 51, 4, 391, 108000, N'Active'),
(444, 184, 51, 4, 392, 108000, N'Active'),
(445, 185, 49, 1, 42, 90000, N'Active'),
(446, 185, 49, 1, 43, 90000, N'Active'),
(447, 186, 44, 2, 172, 90000, N'Active'),
(448, 187, 49, 1, 48, 90000, N'Active'),
(449, 188, 42, 5, 534, 144000, N'Active'),
(450, 189, 44, 2, 160, 90000, N'Active'),
(451, 189, 44, 2, 161, 90000, N'Active'),
(452, 190, 43, 4, 366, 108000, N'Active'),
(453, 190, 43, 4, 367, 108000, N'Active'),
(454, 191, 80, 3, 275, 90000, N'Active'),
(455, 191, 80, 3, 276, 90000, N'Active'),
(456, 192, 51, 4, 363, 108000, N'Active'),
(457, 193, 64, 3, 259, 90000, N'Active'),
(458, 193, 64, 3, 260, 90000, N'Active'),
(459, 193, 64, 3, 261, 90000, N'Active'),
(460, 194, 56, 5, 500, 144000, N'Active'),
(461, 194, 56, 5, 501, 144000, N'Active'),
(462, 195, 49, 1, 79, 90000, N'Active'),
(463, 195, 49, 1, 80, 90000, N'Active'),
(464, 196, 109, 1, 45, 90000, N'Active'),
(465, 197, 52, 3, 268, 90000, N'Active'),
(466, 197, 52, 3, 269, 90000, N'Active'),
(467, 198, 46, 1, 101, 90000, N'Active'),
(468, 198, 46, 1, 102, 90000, N'Active'),
(469, 199, 48, 3, 233, 75000, N'Active'),
(470, 199, 48, 3, 234, 75000, N'Active'),
(471, 200, 46, 1, 14, 75000, N'Active'),
(472, 200, 46, 1, 15, 75000, N'Active'),
(473, 201, 45, 3, 272, 90000, N'Active'),
(474, 201, 45, 3, 273, 90000, N'Active'),
(475, 201, 45, 3, 274, 90000, N'Active'),
(476, 202, 47, 5, 527, 144000, N'Active'),
(477, 202, 47, 5, 528, 144000, N'Active'),
(478, 203, 93, 5, 448, 120000, N'Active'),
(479, 203, 93, 5, 449, 120000, N'Active'),
(480, 203, 93, 5, 450, 120000, N'Active'),
(481, 204, 45, 3, 319, 90000, N'Active'),
(482, 204, 45, 3, 320, 90000, N'Active'),
(483, 205, 51, 4, 342, 90000, N'Active'),
(484, 205, 51, 4, 343, 90000, N'Active'),
(485, 206, 47, 5, 521, 144000, N'Active'),
(486, 206, 47, 5, 522, 144000, N'Active'),
(487, 206, 47, 5, 523, 144000, N'Active'),
(488, 206, 47, 5, 524, 144000, N'Active'),
(489, 207, 50, 2, 194, 90000, N'Active'),
(490, 207, 50, 2, 195, 90000, N'Active'),
(491, 208, 44, 2, 207, 90000, N'Active'),
(492, 208, 44, 2, 208, 90000, N'Active'),
(493, 209, 103, 5, 453, 120000, N'Active'),
(494, 209, 103, 5, 454, 120000, N'Active'),
(495, 210, 55, 4, 419, 90000, N'Active'),
(496, 211, 81, 1, 29, 75000, N'Active'),
(497, 211, 81, 1, 30, 75000, N'Active'),
(498, 212, 55, 4, 425, 90000, N'Active'),
(499, 212, 55, 4, 426, 90000, N'Active'),
(500, 213, 47, 5, 464, 120000, N'Active'),
(501, 213, 47, 5, 465, 120000, N'Active'),
(502, 214, 51, 4, 377, 108000, N'Active'),
(503, 214, 51, 4, 378, 108000, N'Active'),
(504, 215, 53, 1, 55, 90000, N'Active'),
(505, 215, 53, 1, 56, 90000, N'Active'),
(506, 215, 53, 1, 57, 90000, N'Active'),
(507, 215, 53, 1, 58, 90000, N'Active'),
(508, 216, 50, 2, 166, 90000, N'Active'),
(509, 216, 50, 2, 167, 90000, N'Active'),
(510, 217, 47, 5, 478, 120000, N'Active'),
(511, 218, 53, 1, 40, 90000, N'Active'),
(512, 218, 53, 1, 41, 90000, N'Active'),
(513, 219, 50, 2, 179, 90000, N'Active'),
(514, 220, 48, 3, 255, 90000, N'Active'),
(515, 220, 48, 3, 256, 90000, N'Active'),
(516, 221, 54, 2, 174, 90000, N'Active'),
(517, 221, 54, 2, 175, 90000, N'Active'),
(518, 222, 49, 1, 55, 90000, N'Active'),
(519, 222, 49, 1, 56, 90000, N'Active'),
(520, 223, 48, 3, 265, 90000, N'Active'),
(521, 224, 50, 2, 189, 90000, N'Active'),
(522, 224, 50, 2, 190, 90000, N'Active'),
(523, 225, 56, 5, 495, 144000, N'Active'),
(524, 225, 56, 5, 496, 144000, N'Active'),
(525, 226, 51, 4, 344, 90000, N'Active'),
(526, 226, 51, 4, 345, 90000, N'Active'),
(527, 226, 51, 4, 346, 90000, N'Active'),
(528, 227, 47, 5, 538, 144000, N'Active'),
(529, 228, 50, 2, 162, 90000, N'Active'),
(530, 228, 50, 2, 163, 90000, N'Active'),
(531, 229, 106, 2, 151, 90000, N'Active'),
(532, 229, 106, 2, 152, 90000, N'Active'),
(533, 230, 52, 3, 259, 90000, N'Active'),
(534, 230, 52, 3, 260, 90000, N'Active'),
(535, 231, 53, 1, 25, 75000, N'Active'),
(536, 231, 53, 1, 26, 75000, N'Active'),
(537, 231, 53, 1, 27, 75000, N'Active'),
(538, 232, 55, 4, 375, 90000, N'Active'),
(539, 232, 55, 4, 376, 90000, N'Active'),
(540, 232, 55, 4, 377, 90000, N'Active'),
(541, 233, 56, 5, 460, 120000, N'Active'),
(542, 233, 56, 5, 461, 120000, N'Active'),
(543, 234, 51, 4, 365, 108000, N'Active'),
(544, 234, 51, 4, 366, 108000, N'Active'),
(545, 234, 51, 4, 367, 108000, N'Active'),
(546, 234, 51, 4, 368, 108000, N'Active'),
(547, 235, 77, 1, 39, 90000, N'Active'),
(548, 235, 77, 1, 40, 90000, N'Active'),
(549, 235, 77, 1, 41, 90000, N'Active'),
(550, 235, 77, 1, 42, 90000, N'Active'),
(551, 235, 77, 1, 43, 90000, N'Active'),
(552, 235, 77, 1, 44, 90000, N'Active'),
(553, 236, 55, 4, 358, 75000, N'Active'),
(554, 236, 55, 4, 359, 75000, N'Active'),
(555, 236, 55, 4, 360, 75000, N'Active'),
(556, 237, 101, 3, 245, 75000, N'Active'),
(557, 237, 101, 3, 246, 75000, N'Active'),
(558, 237, 101, 3, 247, 75000, N'Active'),
(559, 238, 56, 5, 519, 144000, N'Active'),
(560, 239, 49, 1, 33, 75000, N'Active'),
(561, 239, 49, 1, 34, 75000, N'Active'),
(562, 239, 49, 1, 35, 75000, N'Active'),
(563, 240, 74, 1, 22, 75000, N'Active'),
(564, 240, 74, 1, 23, 75000, N'Active'),
(565, 241, 51, 4, 354, 90000, N'Active'),
(566, 241, 51, 4, 355, 90000, N'Active'),
(567, 242, 53, 1, 61, 90000, N'Active'),
(568, 242, 53, 1, 62, 90000, N'Active'),
(569, 243, 54, 2, 171, 90000, N'Cancelled'),
(570, 243, 54, 2, 172, 90000, N'Cancelled'),
(571, 244, 48, 3, 293, 90000, N'Cancelled'),
(572, 245, 51, 4, 394, 108000, N'Active'),
(573, 245, 51, 4, 395, 108000, N'Active'),
(574, 246, 107, 4, 348, 90000, N'Active'),
(575, 247, 52, 3, 235, 75000, N'Active'),
(576, 247, 52, 3, 236, 75000, N'Active'),
(577, 247, 52, 3, 237, 75000, N'Active'),
(578, 247, 52, 3, 238, 75000, N'Active'),
(579, 248, 54, 2, 138, 75000, N'Active'),
(580, 248, 54, 2, 139, 75000, N'Active'),
(581, 248, 54, 2, 140, 75000, N'Active'),
(582, 249, 68, 2, 189, 90000, N'Active'),
(583, 249, 68, 2, 190, 90000, N'Active'),
(584, 249, 68, 2, 191, 90000, N'Active'),
(585, 250, 52, 3, 277, 90000, N'Active'),
(586, 250, 52, 3, 278, 90000, N'Active'),
(587, 250, 52, 3, 279, 90000, N'Active'),
(588, 251, 75, 5, 508, 144000, N'Active'),
(589, 251, 75, 5, 509, 144000, N'Active'),
(590, 252, 55, 4, 399, 90000, N'Active'),
(591, 252, 55, 4, 400, 90000, N'Active'),
(592, 252, 55, 4, 401, 90000, N'Active'),
(593, 252, 55, 4, 402, 90000, N'Active'),
(594, 252, 55, 4, 403, 90000, N'Active'),
(595, 253, 62, 1, 42, 90000, N'Cancelled'),
(596, 253, 62, 1, 43, 90000, N'Cancelled'),
(597, 254, 52, 3, 248, 75000, N'Active'),
(598, 255, 54, 2, 165, 90000, N'Cancelled'),
(599, 256, 54, 2, 166, 90000, N'Active'),
(600, 256, 54, 2, 167, 90000, N'Active'),
(601, 257, 52, 3, 233, 75000, N'Active'),
(602, 257, 52, 3, 234, 75000, N'Active'),
(603, 258, 53, 1, 42, 90000, N'Active'),
(604, 259, 56, 5, 557, 144000, N'Active'),
(605, 259, 56, 5, 558, 144000, N'Active'),
(606, 260, 66, 4, 365, 108000, N'Active'),
(607, 260, 66, 4, 366, 108000, N'Active'),
(608, 261, 79, 4, 383, 108000, N'Active'),
(609, 261, 79, 4, 384, 108000, N'Active'),
(610, 262, 84, 5, 486, 144000, N'Active'),
(611, 262, 84, 5, 487, 144000, N'Active'),
(612, 263, 103, 5, 552, 144000, N'Active'),
(613, 264, 79, 4, 427, 108000, N'Active'),
(614, 264, 79, 4, 428, 108000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 5 12/11/2026: 150 hoa don (7 huy), 371 ve, doanh thu 35.666.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(265, 10, NULL, '2026-11-12T08:04:11', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 57 | Bò Sữa Bay | 12/11 09:00 | Phòng 1 | H8 H9 H10
(266, 9, NULL, '2026-11-12T08:05:57', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 101 | Bí Kíp Luyện Cướp | 13/11 15:45 | Phòng 3 | F6 F7
(267, 9, NULL, '2026-11-12T08:08:04', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 58 | Godzilla Trừ Không | 12/11 09:00 | Phòng 5 | E6 E7
(268, 9, 108, '2026-11-12T08:09:46', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 57 | Bò Sữa Bay | 12/11 09:00 | Phòng 1 | G6 G7
(269, 9, 9, '2026-11-12T08:10:41', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 122 | Godzilla Trừ Không | 14/11 12:30 | Phòng 4 | G4 G5
(270, 10, NULL, '2026-11-12T08:13:10', 540000, N'Paid', N'Cash', 540000, 0, 0, NULL, NULL, NULL), -- suat 102 | Ngày Con Còn Mẹ | 13/11 16:00 | Phòng 1 | E5 E6 E7 E8 E9 E10
(271, 10, 110, '2026-11-12T08:22:22', 288000, N'Paid', N'Cash', 300000, 28, 0, NULL, NULL, NULL), -- suat 58 | Godzilla Trừ Không | 12/11 09:00 | Phòng 5 | L9 L10
(272, 10, NULL, '2026-11-12T08:26:50', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 108 | Clayface | 13/11 20:15 | Phòng 3 | F5
(273, 9, 86, '2026-11-12T08:27:04', 75000, N'Paid', N'Transfer', NULL, 3, 0, NULL, NULL, NULL), -- suat 130 | Clayface | 14/11 17:00 | Phòng 3 | B6
(274, 10, NULL, '2026-11-12T08:27:10', 450000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 74 | Ngày Con Còn Mẹ | 12/11 16:00 | Phòng 1 | F8 F9 F10 F11 F12
(275, 10, NULL, '2026-11-12T08:30:38', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 58 | Godzilla Trừ Không | 12/11 09:00 | Phòng 5 | K2 K3
(276, 9, 108, '2026-11-12T08:37:57', 288000, N'Paid', N'Cash', 300000, 20, 0, NULL, NULL, NULL), -- suat 70 | Godzilla Trừ Không | 12/11 15:00 | Phòng 5 | G1 G2
(277, 9, NULL, '2026-11-12T08:43:52', 150000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 61 | Thiên Đường Tăm Tối | 12/11 09:30 | Phòng 3 | A10 A11
(278, 10, 113, '2026-11-12T08:53:11', 108000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 59 | Ramayana: Khởi Nguồn Một Huyền Thoại | 12/11 09:15 | Phòng 4 | E6
(279, 10, NULL, '2026-11-12T09:04:21', 288000, N'Cancelled', N'Card', NULL, 0, 0, N'Khách đổi ý', '2026-11-12T09:28:53', 10), -- suat 112 | Godzilla Trừ Không | 13/11 21:00 | Phòng 5 | G5 G6
(280, 9, 25, '2026-11-12T09:05:06', 360000, N'Paid', N'Cash', 360000, 25, 0, NULL, NULL, NULL), -- suat 64 | Clayface | 12/11 11:30 | Phòng 3 | G5 G6 G7 G8
(281, 9, NULL, '2026-11-12T09:11:27', 450000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 60 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 12/11 09:30 | Phòng 2 | G4 G5 G6 G7 G8
(282, 9, NULL, '2026-11-12T09:15:13', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 120 | Godzilla Trừ Không | 14/11 12:15 | Phòng 5 | G6 G7 G8 G9
(283, 9, NULL, '2026-11-12T09:15:25', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 62 | Ngày Con Còn Mẹ | 12/11 11:15 | Phòng 1 | G9
(284, 9, NULL, '2026-11-12T09:18:35', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 74 | Ngày Con Còn Mẹ | 12/11 16:00 | Phòng 1 | F5 F6
(285, 9, 21, '2026-11-12T09:20:57', 576000, N'Paid', N'Card', NULL, 40, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | H7 H8 H9 H10
(286, 9, NULL, '2026-11-12T09:21:40', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 63 | Chàng Mèo Mang Mũ | 12/11 11:30 | Phòng 2 | D5 D6
(287, 9, NULL, '2026-11-12T09:21:40', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 86 | Godzilla Trừ Không | 13/11 09:00 | Phòng 5 | C4 C5
(288, 9, NULL, '2026-11-12T09:34:59', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 66 | Godzilla Trừ Không | 12/11 12:30 | Phòng 4 | G8 G9
(289, 9, NULL, '2026-11-12T09:39:46', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 79 | Godzilla Trừ Không | 12/11 18:30 | Phòng 4 | D7 D8
(290, 10, 68, '2026-11-12T09:46:26', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 74 | Ngày Con Còn Mẹ | 12/11 16:00 | Phòng 1 | F2 F3 F4
(291, 10, NULL, '2026-11-12T09:56:52', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 98 | Godzilla Trừ Không | 13/11 15:00 | Phòng 5 | F11 F12
(292, 10, 69, '2026-11-12T10:02:58', 176000, N'Paid', N'Transfer', NULL, 12, 40, NULL, NULL, NULL), -- suat 94 | Godzilla Trừ Không | 13/11 12:30 | Phòng 4 | H4 H5
(293, 9, NULL, '2026-11-12T10:04:49', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 71 | Ramayana: Khởi Nguồn Một Huyền Thoại | 12/11 15:15 | Phòng 4 | G5 G6 G7 G8
(294, 9, 23, '2026-11-12T10:14:05', 75000, N'Paid', N'Cash', 100000, 3, 0, NULL, NULL, NULL), -- suat 69 | Thiên Đường Tăm Tối | 12/11 13:45 | Phòng 3 | A2
(295, 10, NULL, '2026-11-12T10:17:46', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 70 | Godzilla Trừ Không | 12/11 15:00 | Phòng 5 | F5 F6
(296, 10, 46, '2026-11-12T10:22:22', 120000, N'Paid', N'Cash', 500000, 6, 0, NULL, NULL, NULL), -- suat 65 | Ramayana: Khởi Nguồn Một Huyền Thoại | 12/11 11:45 | Phòng 5 | C6
(297, 9, 103, '2026-11-12T10:25:30', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 70 | Godzilla Trừ Không | 12/11 15:00 | Phòng 5 | G6 G7
(298, 10, NULL, '2026-11-12T10:27:42', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 74 | Ngày Con Còn Mẹ | 12/11 16:00 | Phòng 1 | J5 J6
(299, 9, NULL, '2026-11-12T10:30:13', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 65 | Ramayana: Khởi Nguồn Một Huyền Thoại | 12/11 11:45 | Phòng 5 | F11 F12
(300, 9, NULL, '2026-11-12T10:31:19', 450000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 79 | Godzilla Trừ Không | 12/11 18:30 | Phòng 4 | A1 A2 A3 A4 A5
(301, 10, 109, '2026-11-12T10:31:44', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 100 | Trại Buôn Người | 13/11 15:45 | Phòng 2 | F4 F5 F6
(302, 9, 67, '2026-11-12T10:34:33', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 62 | Ngày Con Còn Mẹ | 12/11 11:15 | Phòng 1 | G2 G3
(303, 9, NULL, '2026-11-12T10:47:26', 450000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 66 | Godzilla Trừ Không | 12/11 12:30 | Phòng 4 | C3 C4 C5 C6 C7
(304, 9, NULL, '2026-11-12T10:47:51', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 75 | Ramayana: Khởi Nguồn Một Huyền Thoại | 12/11 17:45 | Phòng 5 | E2 E3 E4 E5
(305, 9, NULL, '2026-11-12T10:52:45', 108000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 99 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 15:15 | Phòng 4 | F9
(306, 9, NULL, '2026-11-12T10:57:12', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 69 | Thiên Đường Tăm Tối | 12/11 13:45 | Phòng 3 | E2 E3
(307, 9, NULL, '2026-11-12T11:09:09', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 65 | Ramayana: Khởi Nguồn Một Huyền Thoại | 12/11 11:45 | Phòng 5 | G8 G9 G10 G11
(308, 10, NULL, '2026-11-12T11:16:50', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 72 | Trại Buôn Người | 12/11 15:45 | Phòng 2 | D5 D6
(309, 10, 98, '2026-11-12T11:28:43', 432000, N'Paid', N'Transfer', NULL, 30, 0, NULL, NULL, NULL), -- suat 99 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 15:15 | Phòng 4 | D4 D5 D6 D7
(310, 9, 93, '2026-11-12T11:29:59', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 66 | Godzilla Trừ Không | 12/11 12:30 | Phòng 4 | H3 H4
(311, 9, 22, '2026-11-12T11:32:58', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 109 | Chị Chị Em Em 3 | 13/11 20:45 | Phòng 1 | G10 G11
(312, 9, NULL, '2026-11-12T11:34:09', 216000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 79 | Godzilla Trừ Không | 12/11 18:30 | Phòng 4 | E1 E2
(313, 9, NULL, '2026-11-12T11:35:55', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 66 | Godzilla Trừ Không | 12/11 12:30 | Phòng 4 | B2 B3 B4 B5
(314, 9, NULL, '2026-11-12T11:48:48', 144000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 103 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 17:45 | Phòng 5 | F9
(315, 9, NULL, '2026-11-12T11:53:25', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 79 | Godzilla Trừ Không | 12/11 18:30 | Phòng 4 | F7 F8 F9 F10
(316, 10, NULL, '2026-11-12T11:58:19', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 77 | Bò Sữa Bay | 12/11 18:30 | Phòng 1 | F7
(317, 10, NULL, '2026-11-12T11:58:50', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 77 | Bò Sữa Bay | 12/11 18:30 | Phòng 1 | G4 G5
(318, 10, NULL, '2026-11-12T12:01:04', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 67 | Bò Sữa Bay | 12/11 13:45 | Phòng 1 | D5 D6 D7
(319, 9, NULL, '2026-11-12T12:05:24', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 67 | Bò Sữa Bay | 12/11 13:45 | Phòng 1 | C7 C8
(320, 9, NULL, '2026-11-12T12:05:32', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 68 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 12/11 13:45 | Phòng 2 | G7 G8
(321, 9, 21, '2026-11-12T12:07:46', 108000, N'Paid', N'Cash', 108000, 7, 0, NULL, NULL, NULL), -- suat 71 | Ramayana: Khởi Nguồn Một Huyền Thoại | 12/11 15:15 | Phòng 4 | E5
(322, 10, 91, '2026-11-12T12:16:07', 432000, N'Paid', N'Card', NULL, 30, 0, NULL, NULL, NULL), -- suat 70 | Godzilla Trừ Không | 12/11 15:00 | Phòng 5 | H7 H8 H9
(323, 10, 21, '2026-11-12T12:16:59', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 88 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 13/11 09:30 | Phòng 2 | H3 H4
(324, 10, NULL, '2026-11-12T12:20:21', 75000, N'Cancelled', N'Cash', 100000, 0, 0, N'Nhầm suất / ghế', '2026-11-12T12:36:10', 10), -- suat 140 | Bí Kíp Luyện Cướp | 14/11 21:30 | Phòng 3 | C10
(325, 9, NULL, '2026-11-12T12:32:07', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 70 | Godzilla Trừ Không | 12/11 15:00 | Phòng 5 | C6 C7 C8
(326, 10, NULL, '2026-11-12T12:35:44', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 91 | Chàng Mèo Mang Mũ | 13/11 11:30 | Phòng 2 | J7 J8
(327, 9, NULL, '2026-11-12T12:39:47', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 106 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 13/11 18:30 | Phòng 2 | C7 C8
(328, 10, 74, '2026-11-12T12:40:55', 270000, N'Paid', N'Cash', 500000, 18, 0, NULL, NULL, NULL), -- suat 69 | Thiên Đường Tăm Tối | 12/11 13:45 | Phòng 3 | G6 G7 G8
(329, 9, 46, '2026-11-12T12:44:23', 216000, N'Paid', N'Cash', 250000, 15, 0, NULL, NULL, NULL), -- suat 79 | Godzilla Trừ Không | 12/11 18:30 | Phòng 4 | E9 E10
(330, 9, 64, '2026-11-12T12:44:45', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 108 | Clayface | 13/11 20:15 | Phòng 3 | E9 E10
(331, 10, NULL, '2026-11-12T12:47:58', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 77 | Bò Sữa Bay | 12/11 18:30 | Phòng 1 | B3 B4
(332, 9, NULL, '2026-11-12T12:49:43', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 79 | Godzilla Trừ Không | 12/11 18:30 | Phòng 4 | F1 F2
(333, 9, 54, '2026-11-12T12:51:17', 225000, N'Paid', N'Cash', 300000, 11, 0, NULL, NULL, NULL), -- suat 83 | Bí Kíp Luyện Cướp | 12/11 21:00 | Phòng 4 | A7 A8 A9
(334, 9, NULL, '2026-11-12T12:52:24', 240000, N'Paid', N'Cash', 240000, 0, 0, NULL, NULL, NULL), -- suat 70 | Godzilla Trừ Không | 12/11 15:00 | Phòng 5 | D6 D7
(335, 9, 25, '2026-11-12T12:59:03', 216000, N'Paid', N'Cash', 216000, 15, 0, NULL, NULL, NULL), -- suat 99 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 15:15 | Phòng 4 | F1 F2
(336, 9, NULL, '2026-11-12T13:01:27', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 72 | Trại Buôn Người | 12/11 15:45 | Phòng 2 | H7 H8
(337, 9, NULL, '2026-11-12T13:08:59', 288000, N'Cancelled', N'Card', NULL, 0, 0, N'Khách đổi ý', '2026-11-12T13:46:17', 9), -- suat 70 | Godzilla Trừ Không | 12/11 15:00 | Phòng 5 | J4 J5
(338, 9, NULL, '2026-11-12T13:12:01', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 108 | Clayface | 13/11 20:15 | Phòng 3 | D5
(339, 10, NULL, '2026-11-12T13:12:14', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 127 | Bí Kíp Luyện Cướp | 14/11 15:15 | Phòng 4 | G6 G7 G8
(340, 10, NULL, '2026-11-12T13:30:20', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 74 | Ngày Con Còn Mẹ | 12/11 16:00 | Phòng 1 | H5
(341, 10, NULL, '2026-11-12T13:37:57', 300000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 76 | Thiên Đường Tăm Tối | 12/11 18:15 | Phòng 3 | B5 B6 B7 B8
(342, 9, 60, '2026-11-12T13:37:59', 288000, N'Paid', N'Cash', 300000, 20, 0, NULL, NULL, NULL), -- suat 75 | Ramayana: Khởi Nguồn Một Huyền Thoại | 12/11 17:45 | Phòng 5 | H11 H12
(343, 9, 93, '2026-11-12T13:47:29', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 81 | Chị Chị Em Em 3 | 12/11 20:45 | Phòng 1 | C2 C3
(344, 9, NULL, '2026-11-12T13:53:10', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 79 | Godzilla Trừ Không | 12/11 18:30 | Phòng 4 | A8 A9 A10
(345, 9, NULL, '2026-11-12T13:53:56', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 70 | Godzilla Trừ Không | 12/11 15:00 | Phòng 5 | J12
(346, 9, 90, '2026-11-12T13:58:08', 150000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 105 | Bò Sữa Bay | 13/11 18:30 | Phòng 1 | B4 B5
(347, 10, NULL, '2026-11-12T13:59:28', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 80 | Clayface | 12/11 20:15 | Phòng 3 | J9 J10
(348, 10, 87, '2026-11-12T13:59:45', 225000, N'Paid', N'Card', NULL, 11, 0, NULL, NULL, NULL), -- suat 74 | Ngày Con Còn Mẹ | 12/11 16:00 | Phòng 1 | C10 C11 C12
(349, 9, NULL, '2026-11-12T14:00:41', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 88 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 13/11 09:30 | Phòng 2 | H6 H7 H8
(350, 9, NULL, '2026-11-12T14:08:13', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 75 | Ramayana: Khởi Nguồn Một Huyền Thoại | 12/11 17:45 | Phòng 5 | A5 A6
(351, 10, NULL, '2026-11-12T14:14:04', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 135 | Ngày Con Còn Mẹ | 14/11 19:15 | Phòng 3 | F5 F6 F7 F8
(352, 9, 21, '2026-11-12T14:14:40', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 82 | Trại Buôn Người | 12/11 20:45 | Phòng 2 | D7 D8
(353, 10, NULL, '2026-11-12T14:25:21', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 77 | Bò Sữa Bay | 12/11 18:30 | Phòng 1 | H3 H4
(354, 10, 75, '2026-11-12T14:28:56', 288000, N'Cancelled', N'Cash', 290000, 20, 0, N'Lỗi thanh toán', '2026-11-12T14:39:21', 10), -- suat 75 | Ramayana: Khởi Nguồn Một Huyền Thoại | 12/11 17:45 | Phòng 5 | F6 F7
(355, 10, NULL, '2026-11-12T14:28:57', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 137 | Godzilla Trừ Không | 14/11 21:00 | Phòng 4 | C8 C9
(356, 9, NULL, '2026-11-12T14:31:33', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 140 | Bí Kíp Luyện Cướp | 14/11 21:30 | Phòng 3 | F9 F10
(357, 10, 46, '2026-11-12T14:32:56', 432000, N'Paid', N'Cash', 432000, 30, 0, NULL, NULL, NULL), -- suat 71 | Ramayana: Khởi Nguồn Một Huyền Thoại | 12/11 15:15 | Phòng 4 | F8 F9 F10 F11
(358, 9, NULL, '2026-11-12T14:34:30', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 109 | Chị Chị Em Em 3 | 13/11 20:45 | Phòng 1 | J5 J6
(359, 10, NULL, '2026-11-12T14:58:02', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 82 | Trại Buôn Người | 12/11 20:45 | Phòng 2 | E5
(360, 4, NULL, '2026-11-12T15:00:21', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 79 | Godzilla Trừ Không | 12/11 18:30 | Phòng 4 | C1 C2
(361, 4, 31, '2026-11-12T15:14:50', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 76 | Thiên Đường Tăm Tối | 12/11 18:15 | Phòng 3 | H9 H10 H11 H12
(362, 4, 42, '2026-11-12T15:17:07', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 117 | Bí Kíp Luyện Cướp | 14/11 10:00 | Phòng 3 | C7 C8
(363, 3, NULL, '2026-11-12T15:19:05', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 80 | Clayface | 12/11 20:15 | Phòng 3 | J3 J4
(364, 3, NULL, '2026-11-12T15:21:48', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 79 | Godzilla Trừ Không | 12/11 18:30 | Phòng 4 | C7
(365, 3, NULL, '2026-11-12T15:22:19', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 75 | Ramayana: Khởi Nguồn Một Huyền Thoại | 12/11 17:45 | Phòng 5 | H9 H10
(366, 4, 63, '2026-11-12T15:27:28', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 81 | Chị Chị Em Em 3 | 12/11 20:45 | Phòng 1 | F6 F7
(367, 3, NULL, '2026-11-12T15:30:03', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 84 | Godzilla Trừ Không | 12/11 21:00 | Phòng 5 | G9 G10 G11
(368, 4, NULL, '2026-11-12T15:35:54', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 98 | Godzilla Trừ Không | 13/11 15:00 | Phòng 5 | F8 F9 F10
(369, 3, NULL, '2026-11-12T15:40:17', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 77 | Bò Sữa Bay | 12/11 18:30 | Phòng 1 | E6 E7
(370, 3, 108, '2026-11-12T15:40:32', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 78 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 12/11 18:30 | Phòng 2 | G6 G7
(371, 3, NULL, '2026-11-12T15:46:54', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 79 | Godzilla Trừ Không | 12/11 18:30 | Phòng 4 | H11
(372, 4, 81, '2026-11-12T15:49:31', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 108 | Clayface | 13/11 20:15 | Phòng 3 | H7 H8
(373, 4, 1, '2026-11-12T15:49:38', 324000, N'Paid', N'Cash', 350000, 22, 0, NULL, NULL, NULL), -- suat 137 | Godzilla Trừ Không | 14/11 21:00 | Phòng 4 | G8 G9 G10
(374, 3, 42, '2026-11-12T15:50:07', 450000, N'Paid', N'Card', NULL, 22, 0, NULL, NULL, NULL), -- suat 82 | Trại Buôn Người | 12/11 20:45 | Phòng 2 | B4 B5 B6 B7 B8 B9
(375, 4, 77, '2026-11-12T15:59:44', 216000, N'Paid', N'Card', NULL, 21, 0, NULL, NULL, NULL), -- suat 87 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 09:15 | Phòng 4 | J5 J6
(376, 3, 59, '2026-11-12T16:04:01', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 78 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 12/11 18:30 | Phòng 2 | J1 J2
(377, 3, 117, '2026-11-12T16:17:38', 156000, N'Paid', N'Transfer', NULL, 10, 24, NULL, NULL, NULL), -- suat 77 | Bò Sữa Bay | 12/11 18:30 | Phòng 1 | E4 E5
(378, 3, NULL, '2026-11-12T16:21:28', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 122 | Godzilla Trừ Không | 14/11 12:30 | Phòng 4 | G7 G8 G9 G10
(379, 3, NULL, '2026-11-12T16:21:42', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 84 | Godzilla Trừ Không | 12/11 21:00 | Phòng 5 | J5 J6
(380, 4, NULL, '2026-11-12T16:28:02', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 84 | Godzilla Trừ Không | 12/11 21:00 | Phòng 5 | K7 K8
(381, 3, NULL, '2026-11-12T16:41:11', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 107 | Godzilla Trừ Không | 13/11 18:30 | Phòng 4 | H5 H6 H7
(382, 4, NULL, '2026-11-12T16:45:49', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 83 | Bí Kíp Luyện Cướp | 12/11 21:00 | Phòng 4 | G7
(383, 3, NULL, '2026-11-12T16:47:36', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 83 | Bí Kíp Luyện Cướp | 12/11 21:00 | Phòng 4 | E4 E5
(384, 3, NULL, '2026-11-12T16:50:09', 300000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 77 | Bò Sữa Bay | 12/11 18:30 | Phòng 1 | B9 B10 B11 B12
(385, 3, 92, '2026-11-12T17:09:53', 432000, N'Paid', N'Card', NULL, 30, 0, NULL, NULL, NULL), -- suat 112 | Godzilla Trừ Không | 13/11 21:00 | Phòng 5 | G9 G10 G11
(386, 4, 43, '2026-11-12T17:15:47', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 83 | Bí Kíp Luyện Cướp | 12/11 21:00 | Phòng 4 | H10 H11 H12
(387, 4, NULL, '2026-11-12T17:44:25', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 113 | Bò Sữa Bay | 14/11 09:00 | Phòng 1 | H6 H7
(388, 3, 32, '2026-11-12T17:46:07', 450000, N'Paid', N'Card', NULL, 31, 0, NULL, NULL, NULL), -- suat 109 | Chị Chị Em Em 3 | 13/11 20:45 | Phòng 1 | E2 E3 E4 E5 E6
(389, 3, NULL, '2026-11-12T17:56:41', 540000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 80 | Clayface | 12/11 20:15 | Phòng 3 | E4 E5 E6 E7 E8 E9
(390, 4, 78, '2026-11-12T17:58:33', 216000, N'Cancelled', N'Cash', 216000, 15, 0, N'Khách đổi ý', '2026-11-12T18:27:59', 4), -- suat 107 | Godzilla Trừ Không | 13/11 18:30 | Phòng 4 | G4 G5
(391, 4, NULL, '2026-11-12T18:00:46', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 81 | Chị Chị Em Em 3 | 12/11 20:45 | Phòng 1 | D5 D6
(392, 3, NULL, '2026-11-12T18:03:47', 450000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Nhầm suất / ghế', '2026-11-12T18:41:47', 3), -- suat 81 | Chị Chị Em Em 3 | 12/11 20:45 | Phòng 1 | E3 E4 E5 E6 E7
(393, 4, NULL, '2026-11-12T18:07:39', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 80 | Clayface | 12/11 20:15 | Phòng 3 | C6 C7
(394, 4, NULL, '2026-11-12T18:08:18', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 79 | Godzilla Trừ Không | 12/11 18:30 | Phòng 4 | B1 B2 B3 B4
(395, 4, NULL, '2026-11-12T18:08:40', 216000, N'Paid', N'Cash', 220000, 0, 0, NULL, NULL, NULL), -- suat 79 | Godzilla Trừ Không | 12/11 18:30 | Phòng 4 | G5 G6
(396, 4, 118, '2026-11-12T18:15:31', 270000, N'Paid', N'Cash', 300000, 18, 0, NULL, NULL, NULL), -- suat 100 | Trại Buôn Người | 13/11 15:45 | Phòng 2 | H8 H9 H10
(397, 3, NULL, '2026-11-12T18:15:54', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 81 | Chị Chị Em Em 3 | 12/11 20:45 | Phòng 1 | G7
(398, 3, NULL, '2026-11-12T18:25:32', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 82 | Trại Buôn Người | 12/11 20:45 | Phòng 2 | F4 F5
(399, 3, 72, '2026-11-12T18:28:12', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 82 | Trại Buôn Người | 12/11 20:45 | Phòng 2 | J11 J12
(400, 3, NULL, '2026-11-12T18:28:36', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 83 | Bí Kíp Luyện Cướp | 12/11 21:00 | Phòng 4 | G8 G9
(401, 4, NULL, '2026-11-12T18:42:01', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 132 | Trại Buôn Người | 14/11 18:00 | Phòng 2 | F6 F7
(402, 4, 27, '2026-11-12T18:55:24', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 81 | Chị Chị Em Em 3 | 12/11 20:45 | Phòng 1 | E2 E3 E4 E5
(403, 3, NULL, '2026-11-12T18:55:42', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 136 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 14/11 20:45 | Phòng 2 | G7 G8
(404, 3, NULL, '2026-11-12T18:56:38', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 100 | Trại Buôn Người | 13/11 15:45 | Phòng 2 | E8 E9
(405, 4, NULL, '2026-11-12T18:59:02', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 81 | Chị Chị Em Em 3 | 12/11 20:45 | Phòng 1 | C1
(406, 3, NULL, '2026-11-12T19:02:50', 324000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Nhầm suất / ghế', '2026-11-12T19:11:39', 3), -- suat 94 | Godzilla Trừ Không | 13/11 12:30 | Phòng 4 | H8 H9 H10
(407, 4, NULL, '2026-11-12T19:09:55', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 106 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 13/11 18:30 | Phòng 2 | E9 E10 E11 E12
(408, 3, NULL, '2026-11-12T19:27:21', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 107 | Godzilla Trừ Không | 13/11 18:30 | Phòng 4 | D9 D10 D11 D12
(409, 4, NULL, '2026-11-12T20:03:25', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 84 | Godzilla Trừ Không | 12/11 21:00 | Phòng 5 | J2 J3
(410, 3, NULL, '2026-11-12T20:23:02', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 110 | Trại Buôn Người | 13/11 20:45 | Phòng 2 | E2 E3 E4
(411, 4, NULL, '2026-11-12T20:28:54', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 94 | Godzilla Trừ Không | 13/11 12:30 | Phòng 4 | G6 G7
(412, 3, NULL, '2026-11-12T20:38:57', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 98 | Godzilla Trừ Không | 13/11 15:00 | Phòng 5 | G5 G6 G7
(413, 4, NULL, '2026-11-12T21:09:35', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 90 | Ngày Con Còn Mẹ | 13/11 11:15 | Phòng 1 | C3 C4
(414, 4, NULL, '2026-11-12T21:12:09', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL); -- suat 109 | Chị Chị Em Em 3 | 13/11 20:45 | Phòng 1 | C10 C11 C12
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(615, 265, 57, 1, 92, 90000, N'Active'),
(616, 265, 57, 1, 93, 90000, N'Active'),
(617, 265, 57, 1, 94, 90000, N'Active'),
(618, 266, 101, 3, 282, 90000, N'Active'),
(619, 266, 101, 3, 283, 90000, N'Active'),
(620, 267, 58, 5, 486, 144000, N'Active'),
(621, 267, 58, 5, 487, 144000, N'Active'),
(622, 268, 57, 1, 78, 90000, N'Active'),
(623, 268, 57, 1, 79, 90000, N'Active'),
(624, 269, 122, 4, 400, 108000, N'Active'),
(625, 269, 122, 4, 401, 108000, N'Active'),
(626, 270, 102, 1, 53, 90000, N'Active'),
(627, 270, 102, 1, 54, 90000, N'Active'),
(628, 270, 102, 1, 55, 90000, N'Active'),
(629, 270, 102, 1, 56, 90000, N'Active'),
(630, 270, 102, 1, 57, 90000, N'Active'),
(631, 270, 102, 1, 58, 90000, N'Active'),
(632, 271, 58, 5, 561, 144000, N'Active'),
(633, 271, 58, 5, 562, 144000, N'Active'),
(634, 272, 108, 3, 281, 90000, N'Active'),
(635, 273, 130, 3, 234, 75000, N'Active'),
(636, 274, 74, 1, 68, 90000, N'Active'),
(637, 274, 74, 1, 69, 90000, N'Active'),
(638, 274, 74, 1, 70, 90000, N'Active'),
(639, 274, 74, 1, 71, 90000, N'Active'),
(640, 274, 74, 1, 72, 90000, N'Active'),
(641, 275, 58, 5, 542, 144000, N'Active'),
(642, 275, 58, 5, 543, 144000, N'Active'),
(643, 276, 70, 5, 505, 144000, N'Active'),
(644, 276, 70, 5, 506, 144000, N'Active'),
(645, 277, 61, 3, 226, 75000, N'Active'),
(646, 277, 61, 3, 227, 75000, N'Active'),
(647, 278, 59, 4, 378, 108000, N'Active'),
(648, 279, 112, 5, 509, 144000, N'Cancelled'),
(649, 279, 112, 5, 510, 144000, N'Cancelled'),
(650, 280, 64, 3, 293, 90000, N'Active'),
(651, 280, 64, 3, 294, 90000, N'Active'),
(652, 280, 64, 3, 295, 90000, N'Active'),
(653, 280, 64, 3, 296, 90000, N'Active'),
(654, 281, 60, 2, 184, 90000, N'Active'),
(655, 281, 60, 2, 185, 90000, N'Active'),
(656, 281, 60, 2, 186, 90000, N'Active'),
(657, 281, 60, 2, 187, 90000, N'Active'),
(658, 281, 60, 2, 188, 90000, N'Active'),
(659, 282, 120, 5, 510, 144000, N'Active'),
(660, 282, 120, 5, 511, 144000, N'Active'),
(661, 282, 120, 5, 512, 144000, N'Active'),
(662, 282, 120, 5, 513, 144000, N'Active'),
(663, 283, 62, 1, 81, 90000, N'Active'),
(664, 284, 74, 1, 65, 90000, N'Active'),
(665, 284, 74, 1, 66, 90000, N'Active'),
(666, 285, 133, 5, 523, 144000, N'Active'),
(667, 285, 133, 5, 524, 144000, N'Active'),
(668, 285, 133, 5, 525, 144000, N'Active'),
(669, 285, 133, 5, 526, 144000, N'Active'),
(670, 286, 63, 2, 149, 90000, N'Active'),
(671, 286, 63, 2, 150, 90000, N'Active'),
(672, 287, 86, 5, 460, 120000, N'Active'),
(673, 287, 86, 5, 461, 120000, N'Active'),
(674, 288, 66, 4, 404, 108000, N'Active'),
(675, 288, 66, 4, 405, 108000, N'Active'),
(676, 289, 79, 4, 367, 108000, N'Active'),
(677, 289, 79, 4, 368, 108000, N'Active'),
(678, 290, 74, 1, 62, 90000, N'Active'),
(679, 290, 74, 1, 63, 90000, N'Active'),
(680, 290, 74, 1, 64, 90000, N'Active'),
(681, 291, 98, 5, 503, 144000, N'Active'),
(682, 291, 98, 5, 504, 144000, N'Active'),
(683, 292, 94, 4, 412, 108000, N'Active'),
(684, 292, 94, 4, 413, 108000, N'Active'),
(685, 293, 71, 4, 401, 108000, N'Active'),
(686, 293, 71, 4, 402, 108000, N'Active'),
(687, 293, 71, 4, 403, 108000, N'Active'),
(688, 293, 71, 4, 404, 108000, N'Active'),
(689, 294, 69, 3, 218, 75000, N'Active'),
(690, 295, 70, 5, 497, 144000, N'Active'),
(691, 295, 70, 5, 498, 144000, N'Active'),
(692, 296, 65, 5, 462, 120000, N'Active'),
(693, 297, 70, 5, 510, 144000, N'Active'),
(694, 297, 70, 5, 511, 144000, N'Active'),
(695, 298, 74, 1, 101, 90000, N'Active'),
(696, 298, 74, 1, 102, 90000, N'Active'),
(697, 299, 65, 5, 503, 144000, N'Active'),
(698, 299, 65, 5, 504, 144000, N'Active'),
(699, 300, 79, 4, 325, 90000, N'Active'),
(700, 300, 79, 4, 326, 90000, N'Active'),
(701, 300, 79, 4, 327, 90000, N'Active'),
(702, 300, 79, 4, 328, 90000, N'Active'),
(703, 300, 79, 4, 329, 90000, N'Active'),
(704, 301, 100, 2, 172, 90000, N'Active'),
(705, 301, 100, 2, 173, 90000, N'Active'),
(706, 301, 100, 2, 174, 90000, N'Active'),
(707, 302, 62, 1, 74, 90000, N'Active'),
(708, 302, 62, 1, 75, 90000, N'Active'),
(709, 303, 66, 4, 351, 90000, N'Active'),
(710, 303, 66, 4, 352, 90000, N'Active'),
(711, 303, 66, 4, 353, 90000, N'Active'),
(712, 303, 66, 4, 354, 90000, N'Active'),
(713, 303, 66, 4, 355, 90000, N'Active'),
(714, 304, 75, 5, 482, 144000, N'Active'),
(715, 304, 75, 5, 483, 144000, N'Active'),
(716, 304, 75, 5, 484, 144000, N'Active'),
(717, 304, 75, 5, 485, 144000, N'Active'),
(718, 305, 99, 4, 393, 108000, N'Active'),
(719, 306, 69, 3, 266, 90000, N'Active'),
(720, 306, 69, 3, 267, 90000, N'Active'),
(721, 307, 65, 5, 512, 144000, N'Active'),
(722, 307, 65, 5, 513, 144000, N'Active'),
(723, 307, 65, 5, 514, 144000, N'Active'),
(724, 307, 65, 5, 515, 144000, N'Active'),
(725, 308, 72, 2, 149, 90000, N'Active'),
(726, 308, 72, 2, 150, 90000, N'Active'),
(727, 309, 99, 4, 364, 108000, N'Active'),
(728, 309, 99, 4, 365, 108000, N'Active'),
(729, 309, 99, 4, 366, 108000, N'Active'),
(730, 309, 99, 4, 367, 108000, N'Active'),
(731, 310, 66, 4, 411, 108000, N'Active'),
(732, 310, 66, 4, 412, 108000, N'Active'),
(733, 311, 109, 1, 82, 90000, N'Active'),
(734, 311, 109, 1, 83, 90000, N'Active'),
(735, 312, 79, 4, 373, 108000, N'Active'),
(736, 312, 79, 4, 374, 108000, N'Active'),
(737, 313, 66, 4, 338, 90000, N'Active'),
(738, 313, 66, 4, 339, 90000, N'Active'),
(739, 313, 66, 4, 340, 90000, N'Active'),
(740, 313, 66, 4, 341, 90000, N'Active'),
(741, 314, 103, 5, 501, 144000, N'Active'),
(742, 315, 79, 4, 391, 108000, N'Active'),
(743, 315, 79, 4, 392, 108000, N'Active'),
(744, 315, 79, 4, 393, 108000, N'Active'),
(745, 315, 79, 4, 394, 108000, N'Active'),
(746, 316, 77, 1, 67, 90000, N'Active'),
(747, 317, 77, 1, 76, 90000, N'Active'),
(748, 317, 77, 1, 77, 90000, N'Active'),
(749, 318, 67, 1, 41, 90000, N'Active'),
(750, 318, 67, 1, 42, 90000, N'Active'),
(751, 318, 67, 1, 43, 90000, N'Active'),
(752, 319, 67, 1, 31, 75000, N'Active'),
(753, 319, 67, 1, 32, 75000, N'Active'),
(754, 320, 68, 2, 187, 90000, N'Active'),
(755, 320, 68, 2, 188, 90000, N'Active'),
(756, 321, 71, 4, 377, 108000, N'Active'),
(757, 322, 70, 5, 523, 144000, N'Active'),
(758, 322, 70, 5, 524, 144000, N'Active'),
(759, 322, 70, 5, 525, 144000, N'Active'),
(760, 323, 88, 2, 195, 90000, N'Active'),
(761, 323, 88, 2, 196, 90000, N'Active'),
(762, 324, 140, 3, 250, 75000, N'Cancelled'),
(763, 325, 70, 5, 462, 120000, N'Active'),
(764, 325, 70, 5, 463, 120000, N'Active'),
(765, 325, 70, 5, 464, 120000, N'Active'),
(766, 326, 91, 2, 211, 90000, N'Active'),
(767, 326, 91, 2, 212, 90000, N'Active'),
(768, 327, 106, 2, 139, 75000, N'Active'),
(769, 327, 106, 2, 140, 75000, N'Active'),
(770, 328, 69, 3, 294, 90000, N'Active'),
(771, 328, 69, 3, 295, 90000, N'Active'),
(772, 328, 69, 3, 296, 90000, N'Active'),
(773, 329, 79, 4, 381, 108000, N'Active'),
(774, 329, 79, 4, 382, 108000, N'Active'),
(775, 330, 108, 3, 273, 90000, N'Active'),
(776, 330, 108, 3, 274, 90000, N'Active'),
(777, 331, 77, 1, 15, 75000, N'Active'),
(778, 331, 77, 1, 16, 75000, N'Active'),
(779, 332, 79, 4, 385, 108000, N'Active'),
(780, 332, 79, 4, 386, 108000, N'Active'),
(781, 333, 83, 4, 331, 75000, N'Active'),
(782, 333, 83, 4, 332, 75000, N'Active'),
(783, 333, 83, 4, 333, 75000, N'Active'),
(784, 334, 70, 5, 474, 120000, N'Active'),
(785, 334, 70, 5, 475, 120000, N'Active'),
(786, 335, 99, 4, 385, 108000, N'Active'),
(787, 335, 99, 4, 386, 108000, N'Active'),
(788, 336, 72, 2, 199, 90000, N'Active'),
(789, 336, 72, 2, 200, 90000, N'Active'),
(790, 337, 70, 5, 532, 144000, N'Cancelled'),
(791, 337, 70, 5, 533, 144000, N'Cancelled'),
(792, 338, 108, 3, 257, 90000, N'Active'),
(793, 339, 127, 4, 402, 90000, N'Active'),
(794, 339, 127, 4, 403, 90000, N'Active'),
(795, 339, 127, 4, 404, 90000, N'Active'),
(796, 340, 74, 1, 89, 90000, N'Active'),
(797, 341, 76, 3, 233, 75000, N'Active'),
(798, 341, 76, 3, 234, 75000, N'Active'),
(799, 341, 76, 3, 235, 75000, N'Active'),
(800, 341, 76, 3, 236, 75000, N'Active'),
(801, 342, 75, 5, 527, 144000, N'Active'),
(802, 342, 75, 5, 528, 144000, N'Active'),
(803, 343, 81, 1, 26, 75000, N'Active'),
(804, 343, 81, 1, 27, 75000, N'Active'),
(805, 344, 79, 4, 332, 90000, N'Active'),
(806, 344, 79, 4, 333, 90000, N'Active'),
(807, 344, 79, 4, 334, 90000, N'Active'),
(808, 345, 70, 5, 540, 144000, N'Active'),
(809, 346, 105, 1, 16, 75000, N'Active'),
(810, 346, 105, 1, 17, 75000, N'Active'),
(811, 347, 80, 3, 321, 90000, N'Active'),
(812, 347, 80, 3, 322, 90000, N'Active'),
(813, 348, 74, 1, 34, 75000, N'Active'),
(814, 348, 74, 1, 35, 75000, N'Active'),
(815, 348, 74, 1, 36, 75000, N'Active'),
(816, 349, 88, 2, 198, 90000, N'Active'),
(817, 349, 88, 2, 199, 90000, N'Active'),
(818, 349, 88, 2, 200, 90000, N'Active'),
(819, 350, 75, 5, 437, 120000, N'Active'),
(820, 350, 75, 5, 438, 120000, N'Active'),
(821, 351, 135, 3, 281, 90000, N'Active'),
(822, 351, 135, 3, 282, 90000, N'Active'),
(823, 351, 135, 3, 283, 90000, N'Active'),
(824, 351, 135, 3, 284, 90000, N'Active'),
(825, 352, 82, 2, 151, 90000, N'Active'),
(826, 352, 82, 2, 152, 90000, N'Active'),
(827, 353, 77, 1, 87, 90000, N'Active'),
(828, 353, 77, 1, 88, 90000, N'Active'),
(829, 354, 75, 5, 498, 144000, N'Cancelled'),
(830, 354, 75, 5, 499, 144000, N'Cancelled'),
(831, 355, 137, 4, 356, 90000, N'Active'),
(832, 355, 137, 4, 357, 90000, N'Active'),
(833, 356, 140, 3, 285, 90000, N'Active'),
(834, 356, 140, 3, 286, 90000, N'Active'),
(835, 357, 71, 4, 392, 108000, N'Active'),
(836, 357, 71, 4, 393, 108000, N'Active'),
(837, 357, 71, 4, 394, 108000, N'Active'),
(838, 357, 71, 4, 395, 108000, N'Active'),
(839, 358, 109, 1, 101, 90000, N'Active'),
(840, 358, 109, 1, 102, 90000, N'Active'),
(841, 359, 82, 2, 161, 90000, N'Active'),
(842, 360, 79, 4, 349, 90000, N'Active'),
(843, 360, 79, 4, 350, 90000, N'Active'),
(844, 361, 76, 3, 309, 90000, N'Active'),
(845, 361, 76, 3, 310, 90000, N'Active'),
(846, 361, 76, 3, 311, 90000, N'Active'),
(847, 361, 76, 3, 312, 90000, N'Active'),
(848, 362, 117, 3, 247, 75000, N'Active'),
(849, 362, 117, 3, 248, 75000, N'Active'),
(850, 363, 80, 3, 315, 90000, N'Active'),
(851, 363, 80, 3, 316, 90000, N'Active'),
(852, 364, 79, 4, 355, 90000, N'Active'),
(853, 365, 75, 5, 525, 144000, N'Active'),
(854, 365, 75, 5, 526, 144000, N'Active'),
(855, 366, 81, 1, 66, 90000, N'Active'),
(856, 366, 81, 1, 67, 90000, N'Active'),
(857, 367, 84, 5, 513, 144000, N'Active'),
(858, 367, 84, 5, 514, 144000, N'Active'),
(859, 367, 84, 5, 515, 144000, N'Active'),
(860, 368, 98, 5, 500, 144000, N'Active'),
(861, 368, 98, 5, 501, 144000, N'Active'),
(862, 368, 98, 5, 502, 144000, N'Active'),
(863, 369, 77, 1, 54, 90000, N'Active'),
(864, 369, 77, 1, 55, 90000, N'Active'),
(865, 370, 78, 2, 186, 90000, N'Active'),
(866, 370, 78, 2, 187, 90000, N'Active'),
(867, 371, 79, 4, 419, 108000, N'Active'),
(868, 372, 108, 3, 307, 90000, N'Active'),
(869, 372, 108, 3, 308, 90000, N'Active'),
(870, 373, 137, 4, 404, 108000, N'Active'),
(871, 373, 137, 4, 405, 108000, N'Active'),
(872, 373, 137, 4, 406, 108000, N'Active'),
(873, 374, 82, 2, 124, 75000, N'Active'),
(874, 374, 82, 2, 125, 75000, N'Active'),
(875, 374, 82, 2, 126, 75000, N'Active'),
(876, 374, 82, 2, 127, 75000, N'Active'),
(877, 374, 82, 2, 128, 75000, N'Active'),
(878, 374, 82, 2, 129, 75000, N'Active'),
(879, 375, 87, 4, 425, 108000, N'Active'),
(880, 375, 87, 4, 426, 108000, N'Active'),
(881, 376, 78, 2, 205, 90000, N'Active'),
(882, 376, 78, 2, 206, 90000, N'Active'),
(883, 377, 77, 1, 52, 90000, N'Active'),
(884, 377, 77, 1, 53, 90000, N'Active'),
(885, 378, 122, 4, 403, 108000, N'Active'),
(886, 378, 122, 4, 404, 108000, N'Active'),
(887, 378, 122, 4, 405, 108000, N'Active'),
(888, 378, 122, 4, 406, 108000, N'Active'),
(889, 379, 84, 5, 533, 144000, N'Active'),
(890, 379, 84, 5, 534, 144000, N'Active'),
(891, 380, 84, 5, 547, 144000, N'Active'),
(892, 380, 84, 5, 548, 144000, N'Active'),
(893, 381, 107, 4, 413, 108000, N'Active'),
(894, 381, 107, 4, 414, 108000, N'Active'),
(895, 381, 107, 4, 415, 108000, N'Active'),
(896, 382, 83, 4, 403, 90000, N'Active'),
(897, 383, 83, 4, 376, 90000, N'Active'),
(898, 383, 83, 4, 377, 90000, N'Active'),
(899, 384, 77, 1, 21, 75000, N'Active'),
(900, 384, 77, 1, 22, 75000, N'Active'),
(901, 384, 77, 1, 23, 75000, N'Active'),
(902, 384, 77, 1, 24, 75000, N'Active'),
(903, 385, 112, 5, 513, 144000, N'Active'),
(904, 385, 112, 5, 514, 144000, N'Active'),
(905, 385, 112, 5, 515, 144000, N'Active'),
(906, 386, 83, 4, 418, 90000, N'Active'),
(907, 386, 83, 4, 419, 90000, N'Active'),
(908, 386, 83, 4, 420, 90000, N'Active'),
(909, 387, 113, 1, 90, 90000, N'Active'),
(910, 387, 113, 1, 91, 90000, N'Active'),
(911, 388, 109, 1, 50, 90000, N'Active'),
(912, 388, 109, 1, 51, 90000, N'Active'),
(913, 388, 109, 1, 52, 90000, N'Active'),
(914, 388, 109, 1, 53, 90000, N'Active'),
(915, 388, 109, 1, 54, 90000, N'Active'),
(916, 389, 80, 3, 268, 90000, N'Active'),
(917, 389, 80, 3, 269, 90000, N'Active'),
(918, 389, 80, 3, 270, 90000, N'Active'),
(919, 389, 80, 3, 271, 90000, N'Active'),
(920, 389, 80, 3, 272, 90000, N'Active'),
(921, 389, 80, 3, 273, 90000, N'Active'),
(922, 390, 107, 4, 400, 108000, N'Cancelled'),
(923, 390, 107, 4, 401, 108000, N'Cancelled'),
(924, 391, 81, 1, 41, 90000, N'Active'),
(925, 391, 81, 1, 42, 90000, N'Active'),
(926, 392, 81, 1, 51, 90000, N'Cancelled'),
(927, 392, 81, 1, 52, 90000, N'Cancelled'),
(928, 392, 81, 1, 53, 90000, N'Cancelled'),
(929, 392, 81, 1, 54, 90000, N'Cancelled'),
(930, 392, 81, 1, 55, 90000, N'Cancelled'),
(931, 393, 80, 3, 246, 75000, N'Active'),
(932, 393, 80, 3, 247, 75000, N'Active'),
(933, 394, 79, 4, 337, 90000, N'Active'),
(934, 394, 79, 4, 338, 90000, N'Active'),
(935, 394, 79, 4, 339, 90000, N'Active'),
(936, 394, 79, 4, 340, 90000, N'Active'),
(937, 395, 79, 4, 401, 108000, N'Active'),
(938, 395, 79, 4, 402, 108000, N'Active'),
(939, 396, 100, 2, 200, 90000, N'Active'),
(940, 396, 100, 2, 201, 90000, N'Active'),
(941, 396, 100, 2, 202, 90000, N'Active'),
(942, 397, 81, 1, 79, 90000, N'Active'),
(943, 398, 82, 2, 172, 90000, N'Active'),
(944, 398, 82, 2, 173, 90000, N'Active'),
(945, 399, 82, 2, 215, 90000, N'Active'),
(946, 399, 82, 2, 216, 90000, N'Active'),
(947, 400, 83, 4, 404, 90000, N'Active'),
(948, 400, 83, 4, 405, 90000, N'Active'),
(949, 401, 132, 2, 174, 90000, N'Active'),
(950, 401, 132, 2, 175, 90000, N'Active'),
(951, 402, 81, 1, 50, 90000, N'Active'),
(952, 402, 81, 1, 51, 90000, N'Active'),
(953, 402, 81, 1, 52, 90000, N'Active'),
(954, 402, 81, 1, 53, 90000, N'Active'),
(955, 403, 136, 2, 187, 90000, N'Active'),
(956, 403, 136, 2, 188, 90000, N'Active'),
(957, 404, 100, 2, 164, 90000, N'Active'),
(958, 404, 100, 2, 165, 90000, N'Active'),
(959, 405, 81, 1, 25, 75000, N'Active'),
(960, 406, 94, 4, 416, 108000, N'Cancelled'),
(961, 406, 94, 4, 417, 108000, N'Cancelled'),
(962, 406, 94, 4, 418, 108000, N'Cancelled'),
(963, 407, 106, 2, 165, 90000, N'Active'),
(964, 407, 106, 2, 166, 90000, N'Active'),
(965, 407, 106, 2, 167, 90000, N'Active'),
(966, 407, 106, 2, 168, 90000, N'Active'),
(967, 408, 107, 4, 369, 108000, N'Active'),
(968, 408, 107, 4, 370, 108000, N'Active'),
(969, 408, 107, 4, 371, 108000, N'Active'),
(970, 408, 107, 4, 372, 108000, N'Active'),
(971, 409, 84, 5, 530, 144000, N'Active'),
(972, 409, 84, 5, 531, 144000, N'Active'),
(973, 410, 110, 2, 158, 90000, N'Active'),
(974, 410, 110, 2, 159, 90000, N'Active'),
(975, 410, 110, 2, 160, 90000, N'Active'),
(976, 411, 94, 4, 402, 108000, N'Active'),
(977, 411, 94, 4, 403, 108000, N'Active'),
(978, 412, 98, 5, 509, 144000, N'Active'),
(979, 412, 98, 5, 510, 144000, N'Active'),
(980, 412, 98, 5, 511, 144000, N'Active'),
(981, 413, 90, 1, 27, 75000, N'Active'),
(982, 413, 90, 1, 28, 75000, N'Active'),
(983, 414, 109, 1, 34, 75000, N'Active'),
(984, 414, 109, 1, 35, 75000, N'Active'),
(985, 414, 109, 1, 36, 75000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 6 13/11/2026: 166 hoa don (7 huy), 376 ve, doanh thu 38.562.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(415, 5, NULL, '2026-11-13T08:16:08', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 86 | Godzilla Trừ Không | 13/11 09:00 | Phòng 5 | J6
(416, 5, NULL, '2026-11-13T08:18:41', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 137 | Godzilla Trừ Không | 14/11 21:00 | Phòng 4 | E4 E5 E6
(417, 5, NULL, '2026-11-13T08:28:03', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 115 | Ramayana: Khởi Nguồn Một Huyền Thoại | 14/11 09:15 | Phòng 4 | D2 D3
(418, 5, 49, '2026-11-13T08:32:45', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 89 | Thiên Đường Tăm Tối | 13/11 09:30 | Phòng 3 | B8 B9
(419, 4, NULL, '2026-11-13T08:33:32', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 85 | Bò Sữa Bay | 13/11 09:00 | Phòng 1 | J11 J12
(420, 6, NULL, '2026-11-13T08:37:29', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 85 | Bò Sữa Bay | 13/11 09:00 | Phòng 1 | C10 C11
(421, 4, NULL, '2026-11-13T08:38:38', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 86 | Godzilla Trừ Không | 13/11 09:00 | Phòng 5 | L5 L6
(422, 6, NULL, '2026-11-13T08:38:48', 144000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 86 | Godzilla Trừ Không | 13/11 09:00 | Phòng 5 | H7
(423, 6, NULL, '2026-11-13T08:39:07', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 85 | Bò Sữa Bay | 13/11 09:00 | Phòng 1 | D12
(424, 6, NULL, '2026-11-13T08:39:51', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 167 | Chị Chị Em Em 3 | 15/11 21:30 | Phòng 1 | G6 G7
(425, 6, NULL, '2026-11-13T08:39:55', 75000, N'Paid', N'Cash', 75000, 0, 0, NULL, NULL, NULL), -- suat 85 | Bò Sữa Bay | 13/11 09:00 | Phòng 1 | C4
(426, 5, NULL, '2026-11-13T08:42:43', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 86 | Godzilla Trừ Không | 13/11 09:00 | Phòng 5 | D6 D7 D8
(427, 4, NULL, '2026-11-13T08:43:47', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 89 | Thiên Đường Tăm Tối | 13/11 09:30 | Phòng 3 | A2 A3 A4
(428, 5, 44, '2026-11-13T08:45:07', 144000, N'Paid', N'Cash', 150000, 10, 0, NULL, NULL, NULL), -- suat 86 | Godzilla Trừ Không | 13/11 09:00 | Phòng 5 | F6
(429, 5, NULL, '2026-11-13T08:45:45', 432000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 94 | Godzilla Trừ Không | 13/11 12:30 | Phòng 4 | E1 E2 E3 E4
(430, 5, NULL, '2026-11-13T08:46:46', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 85 | Bò Sữa Bay | 13/11 09:00 | Phòng 1 | D4 D5
(431, 5, NULL, '2026-11-13T08:54:06', 108000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 87 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 09:15 | Phòng 4 | G8
(432, 5, NULL, '2026-11-13T08:59:18', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 117 | Bí Kíp Luyện Cướp | 14/11 10:00 | Phòng 3 | E6 E7
(433, 5, NULL, '2026-11-13T09:15:34', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 140 | Bí Kíp Luyện Cướp | 14/11 21:30 | Phòng 3 | H1 H2
(434, 5, NULL, '2026-11-13T09:25:36', 90000, N'Cancelled', N'Cash', 90000, 0, 0, N'Lỗi thanh toán', '2026-11-13T09:36:47', 5), -- suat 97 | Thiên Đường Tăm Tối | 13/11 13:45 | Phòng 3 | H4
(435, 5, NULL, '2026-11-13T09:25:38', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 90 | Ngày Con Còn Mẹ | 13/11 11:15 | Phòng 1 | G4 G5 G6
(436, 5, NULL, '2026-11-13T09:37:04', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 138 | Dune: Hành Tinh Cát | 14/11 21:00 | Phòng 5 | G10 G11
(437, 4, 56, '2026-11-13T09:47:45', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 91 | Chàng Mèo Mang Mũ | 13/11 11:30 | Phòng 2 | E9 E10 E11
(438, 5, 46, '2026-11-13T09:48:09', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 90 | Ngày Con Còn Mẹ | 13/11 11:15 | Phòng 1 | E10
(439, 4, NULL, '2026-11-13T09:57:17', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 90 | Ngày Con Còn Mẹ | 13/11 11:15 | Phòng 1 | J5 J6
(440, 6, NULL, '2026-11-13T09:57:33', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 92 | Clayface | 13/11 11:30 | Phòng 3 | F3 F4 F5
(441, 4, NULL, '2026-11-13T10:02:45', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 99 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 15:15 | Phòng 4 | H1 H2 H3
(442, 6, 52, '2026-11-13T10:22:20', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 100 | Trại Buôn Người | 13/11 15:45 | Phòng 2 | J5 J6
(443, 4, NULL, '2026-11-13T10:25:30', 576000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 93 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 11:45 | Phòng 5 | H6 H7 H8 H9
(444, 5, NULL, '2026-11-13T10:26:03', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 91 | Chàng Mèo Mang Mũ | 13/11 11:30 | Phòng 2 | E6 E7
(445, 4, NULL, '2026-11-13T10:27:10', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 102 | Ngày Con Còn Mẹ | 13/11 16:00 | Phòng 1 | F5 F6
(446, 5, 117, '2026-11-13T10:27:17', 180000, N'Paid', N'Cash', 200000, 9, 0, NULL, NULL, NULL), -- suat 99 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 15:15 | Phòng 4 | C9 C10
(447, 5, 115, '2026-11-13T10:39:08', 432000, N'Paid', N'Transfer', NULL, 30, 0, NULL, NULL, NULL), -- suat 94 | Godzilla Trừ Không | 13/11 12:30 | Phòng 4 | E5 E6 E7 E8
(448, 5, NULL, '2026-11-13T10:42:20', 480000, N'Paid', N'Cash', 480000, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | B3 B4 B5 B6
(449, 4, NULL, '2026-11-13T10:53:49', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 95 | Bò Sữa Bay | 13/11 13:45 | Phòng 1 | F1 F2 F3
(450, 4, NULL, '2026-11-13T10:55:15', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 107 | Godzilla Trừ Không | 13/11 18:30 | Phòng 4 | E2 E3
(451, 6, NULL, '2026-11-13T10:58:02', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 128 | Ngày Con Còn Mẹ | 14/11 15:30 | Phòng 2 | G3 G4
(452, 4, NULL, '2026-11-13T10:58:16', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 139 | Chị Chị Em Em 3 | 14/11 21:30 | Phòng 1 | J5 J6
(453, 5, NULL, '2026-11-13T11:13:05', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 105 | Bò Sữa Bay | 13/11 18:30 | Phòng 1 | D9 D10
(454, 6, NULL, '2026-11-13T11:14:31', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Nhầm suất / ghế', '2026-11-13T11:28:22', 6), -- suat 92 | Clayface | 13/11 11:30 | Phòng 3 | G8 G9
(455, 6, NULL, '2026-11-13T11:18:52', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 95 | Bò Sữa Bay | 13/11 13:45 | Phòng 1 | G6 G7
(456, 4, 66, '2026-11-13T11:27:19', 540000, N'Paid', N'Transfer', NULL, 37, 0, NULL, NULL, NULL), -- suat 102 | Ngày Con Còn Mẹ | 13/11 16:00 | Phòng 1 | D4 D5 D6 D7 D8 D9
(457, 6, NULL, '2026-11-13T11:36:12', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 94 | Godzilla Trừ Không | 13/11 12:30 | Phòng 4 | J3 J4
(458, 6, 75, '2026-11-13T11:36:21', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 96 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 13/11 13:45 | Phòng 2 | E5 E6
(459, 6, NULL, '2026-11-13T11:39:14', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 97 | Thiên Đường Tăm Tối | 13/11 13:45 | Phòng 3 | E5 E6
(460, 6, NULL, '2026-11-13T11:41:23', 120000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | D12
(461, 6, NULL, '2026-11-13T11:43:14', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 95 | Bò Sữa Bay | 13/11 13:45 | Phòng 1 | G3
(462, 6, NULL, '2026-11-13T11:46:37', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 95 | Bò Sữa Bay | 13/11 13:45 | Phòng 1 | H5 H6
(463, 4, 6, '2026-11-13T11:48:33', 324000, N'Paid', N'Transfer', NULL, 22, 0, NULL, NULL, NULL), -- suat 94 | Godzilla Trừ Không | 13/11 12:30 | Phòng 4 | E10 E11 E12
(464, 5, NULL, '2026-11-13T11:51:36', 144000, N'Cancelled', N'Card', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-13T12:09:48', 5), -- suat 103 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 17:45 | Phòng 5 | F7
(465, 5, 111, '2026-11-13T11:55:20', 150000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 163 | Ngày Con Còn Mẹ | 15/11 19:15 | Phòng 3 | A6 A7
(466, 4, NULL, '2026-11-13T11:55:27', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 152 | Chị Chị Em Em 3 | 15/11 14:00 | Phòng 1 | E7 E8
(467, 5, NULL, '2026-11-13T11:56:51', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 96 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 13/11 13:45 | Phòng 2 | C5 C6
(468, 6, NULL, '2026-11-13T11:57:38', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 97 | Thiên Đường Tăm Tối | 13/11 13:45 | Phòng 3 | F5 F6
(469, 5, NULL, '2026-11-13T11:58:49', 432000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 137 | Godzilla Trừ Không | 14/11 21:00 | Phòng 4 | F5 F6 F7 F8
(470, 4, NULL, '2026-11-13T12:01:32', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 96 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 13/11 13:45 | Phòng 2 | F6 F7 F8
(471, 5, NULL, '2026-11-13T12:02:29', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 164 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 15/11 20:45 | Phòng 2 | G4 G5 G6 G7
(472, 5, NULL, '2026-11-13T12:13:12', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 103 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 17:45 | Phòng 5 | L11 L12
(473, 6, NULL, '2026-11-13T12:13:31', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 97 | Thiên Đường Tăm Tối | 13/11 13:45 | Phòng 3 | H9
(474, 4, NULL, '2026-11-13T12:16:57', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 120 | Godzilla Trừ Không | 14/11 12:15 | Phòng 5 | J4 J5
(475, 6, NULL, '2026-11-13T12:21:05', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 102 | Ngày Con Còn Mẹ | 13/11 16:00 | Phòng 1 | F2
(476, 5, NULL, '2026-11-13T12:29:07', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 95 | Bò Sữa Bay | 13/11 13:45 | Phòng 1 | D3 D4
(477, 5, NULL, '2026-11-13T12:35:23', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 103 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 17:45 | Phòng 5 | H1 H2
(478, 6, NULL, '2026-11-13T12:37:47', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | H5
(479, 5, NULL, '2026-11-13T12:46:03', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 109 | Chị Chị Em Em 3 | 13/11 20:45 | Phòng 1 | B4 B5
(480, 5, NULL, '2026-11-13T12:48:31', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 98 | Godzilla Trừ Không | 13/11 15:00 | Phòng 5 | B6 B7
(481, 4, 91, '2026-11-13T12:53:11', 450000, N'Paid', N'Transfer', NULL, 31, 0, NULL, NULL, NULL), -- suat 134 | Ngày Con Còn Mẹ | 14/11 19:00 | Phòng 1 | D8 D9 D10 D11 D12
(482, 5, NULL, '2026-11-13T12:56:38', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 107 | Godzilla Trừ Không | 13/11 18:30 | Phòng 4 | A9 A10
(483, 4, NULL, '2026-11-13T13:02:34', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 98 | Godzilla Trừ Không | 13/11 15:00 | Phòng 5 | J9 J10 J11
(484, 5, 113, '2026-11-13T13:05:08', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 98 | Godzilla Trừ Không | 13/11 15:00 | Phòng 5 | H1 H2
(485, 5, 67, '2026-11-13T13:06:08', 75000, N'Paid', N'Transfer', NULL, 3, 0, NULL, NULL, NULL), -- suat 102 | Ngày Con Còn Mẹ | 13/11 16:00 | Phòng 1 | C11
(486, 5, NULL, '2026-11-13T13:06:16', 225000, N'Paid', N'Cash', 225000, 0, 0, NULL, NULL, NULL), -- suat 102 | Ngày Con Còn Mẹ | 13/11 16:00 | Phòng 1 | C8 C9 C10
(487, 5, NULL, '2026-11-13T13:06:49', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 101 | Bí Kíp Luyện Cướp | 13/11 15:45 | Phòng 3 | D4 D5
(488, 6, NULL, '2026-11-13T13:13:42', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 96 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 13/11 13:45 | Phòng 2 | J7 J8
(489, 4, 29, '2026-11-13T13:16:43', 94000, N'Paid', N'Cash', 100000, 6, 50, NULL, NULL, NULL), -- suat 98 | Godzilla Trừ Không | 13/11 15:00 | Phòng 5 | K10
(490, 5, NULL, '2026-11-13T13:19:15', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 112 | Godzilla Trừ Không | 13/11 21:00 | Phòng 5 | F10 F11 F12
(491, 4, 52, '2026-11-13T13:20:58', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 117 | Bí Kíp Luyện Cướp | 14/11 10:00 | Phòng 3 | E3 E4
(492, 4, NULL, '2026-11-13T13:26:37', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 103 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 17:45 | Phòng 5 | F3 F4
(493, 6, NULL, '2026-11-13T13:29:32', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | J9 J10
(494, 4, NULL, '2026-11-13T13:35:08', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 104 | Kẻ Hồi Sinh | 13/11 18:15 | Phòng 3 | A7 A8
(495, 4, NULL, '2026-11-13T13:42:16', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 102 | Ngày Con Còn Mẹ | 13/11 16:00 | Phòng 1 | G8 G9
(496, 4, 80, '2026-11-13T13:43:19', 216000, N'Paid', N'Cash', 300000, 15, 0, NULL, NULL, NULL), -- suat 143 | Ramayana: Khởi Nguồn Một Huyền Thoại | 15/11 09:15 | Phòng 4 | D6 D7
(497, 4, NULL, '2026-11-13T13:48:16', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 102 | Ngày Con Còn Mẹ | 13/11 16:00 | Phòng 1 | D10 D11 D12
(498, 4, NULL, '2026-11-13T13:48:53', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 100 | Trại Buôn Người | 13/11 15:45 | Phòng 2 | F7 F8
(499, 5, NULL, '2026-11-13T13:52:18', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 107 | Godzilla Trừ Không | 13/11 18:30 | Phòng 4 | J1 J2
(500, 4, NULL, '2026-11-13T13:57:20', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 103 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 17:45 | Phòng 5 | E5 E6
(501, 5, NULL, '2026-11-13T14:03:41', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 107 | Godzilla Trừ Không | 13/11 18:30 | Phòng 4 | J3 J4
(502, 6, NULL, '2026-11-13T14:06:57', 180000, N'Cancelled', N'Cash', 180000, 0, 0, N'Nhầm suất / ghế', '2026-11-13T14:32:17', 6), -- suat 116 | Kiến Lé Phiêu Lưu Ké | 14/11 09:30 | Phòng 2 | J11 J12
(503, 4, NULL, '2026-11-13T14:07:12', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 134 | Ngày Con Còn Mẹ | 14/11 19:00 | Phòng 1 | H5 H6
(504, 5, 1, '2026-11-13T14:08:39', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 104 | Kẻ Hồi Sinh | 13/11 18:15 | Phòng 3 | E3 E4
(505, 5, 109, '2026-11-13T14:09:55', 270000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 118 | Chàng Mèo Mang Mũ | 14/11 11:15 | Phòng 2 | D6 D7 D8
(506, 4, NULL, '2026-11-13T14:20:15', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 99 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 15:15 | Phòng 4 | J5 J6
(507, 4, NULL, '2026-11-13T14:24:41', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 154 | Dune: Hành Tinh Cát | 15/11 15:00 | Phòng 5 | L1 L2
(508, 5, NULL, '2026-11-13T14:35:15', 576000, N'Paid', N'Cash', 600000, 0, 0, NULL, NULL, NULL), -- suat 103 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 17:45 | Phòng 5 | H4 H5 H6 H7
(509, 5, 68, '2026-11-13T14:35:46', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 107 | Godzilla Trừ Không | 13/11 18:30 | Phòng 4 | F1 F2
(510, 6, NULL, '2026-11-13T14:37:08', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 130 | Clayface | 14/11 17:00 | Phòng 3 | A4 A5
(511, 4, NULL, '2026-11-13T14:39:00', 432000, N'Paid', N'Cash', 440000, 0, 0, NULL, NULL, NULL), -- suat 138 | Dune: Hành Tinh Cát | 14/11 21:00 | Phòng 5 | H6 H7 H8
(512, 5, 33, '2026-11-13T14:41:12', 360000, N'Paid', N'Card', NULL, 25, 0, NULL, NULL, NULL), -- suat 129 | Bò Sữa Bay | 14/11 16:30 | Phòng 1 | G2 G3 G4 G5
(513, 5, NULL, '2026-11-13T14:46:56', 240000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 103 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 17:45 | Phòng 5 | D1 D2
(514, 4, NULL, '2026-11-13T14:48:48', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 108 | Clayface | 13/11 20:15 | Phòng 3 | D10 D11
(515, 5, NULL, '2026-11-13T14:50:10', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 105 | Bò Sữa Bay | 13/11 18:30 | Phòng 1 | F1 F2
(516, 5, NULL, '2026-11-13T14:57:45', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 106 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 13/11 18:30 | Phòng 2 | F4 F5 F6 F7
(517, 7, NULL, '2026-11-13T15:03:46', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 159 | Ramayana: Khởi Nguồn Một Huyền Thoại | 15/11 17:45 | Phòng 4 | E6 E7
(518, 8, NULL, '2026-11-13T15:06:51', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 154 | Dune: Hành Tinh Cát | 15/11 15:00 | Phòng 5 | F12
(519, 8, NULL, '2026-11-13T15:07:04', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | G6 G7 G8
(520, 7, NULL, '2026-11-13T15:07:35', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 104 | Kẻ Hồi Sinh | 13/11 18:15 | Phòng 3 | G5 G6
(521, 7, NULL, '2026-11-13T15:13:29', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 151 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 15/11 13:30 | Phòng 2 | H8
(522, 8, NULL, '2026-11-13T15:22:11', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 103 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 17:45 | Phòng 5 | L1 L2
(523, 8, NULL, '2026-11-13T15:24:00', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 103 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 17:45 | Phòng 5 | L5 L6
(524, 8, NULL, '2026-11-13T15:32:44', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 106 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 13/11 18:30 | Phòng 2 | G9
(525, 7, NULL, '2026-11-13T15:33:12', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 110 | Trại Buôn Người | 13/11 20:45 | Phòng 2 | F8 F9
(526, 8, NULL, '2026-11-13T15:33:57', 576000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 103 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 17:45 | Phòng 5 | G4 G5 G6 G7
(527, 9, NULL, '2026-11-13T15:35:26', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 106 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 13/11 18:30 | Phòng 2 | H3 H4 H5
(528, 9, NULL, '2026-11-13T15:40:22', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 109 | Chị Chị Em Em 3 | 13/11 20:45 | Phòng 1 | F6
(529, 9, 110, '2026-11-13T15:41:45', 152000, N'Paid', N'Cash', 152000, 10, 28, NULL, NULL, NULL), -- suat 111 | Bí Kíp Luyện Cướp | 13/11 21:00 | Phòng 4 | F6 F7
(530, 8, 67, '2026-11-13T15:44:15', 375000, N'Paid', N'Cash', 400000, 18, 0, NULL, NULL, NULL), -- suat 117 | Bí Kíp Luyện Cướp | 14/11 10:00 | Phòng 3 | B8 B9 B10 B11 B12
(531, 9, 100, '2026-11-13T15:52:17', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 135 | Ngày Con Còn Mẹ | 14/11 19:15 | Phòng 3 | G5 G6
(532, 9, 42, '2026-11-13T15:54:02', 432000, N'Paid', N'Card', NULL, 30, 0, NULL, NULL, NULL), -- suat 142 | Dune: Hành Tinh Cát | 15/11 09:00 | Phòng 5 | G8 G9 G10
(533, 8, 54, '2026-11-13T15:55:02', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | G5 G6
(534, 9, NULL, '2026-11-13T15:58:47', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 120 | Godzilla Trừ Không | 14/11 12:15 | Phòng 5 | B5 B6 B7
(535, 8, NULL, '2026-11-13T16:01:09', 216000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-11-13T16:26:46', 8), -- suat 107 | Godzilla Trừ Không | 13/11 18:30 | Phòng 4 | J7 J8
(536, 9, NULL, '2026-11-13T16:01:58', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 110 | Trại Buôn Người | 13/11 20:45 | Phòng 2 | G5 G6
(537, 9, 21, '2026-11-13T16:05:17', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 105 | Bò Sữa Bay | 13/11 18:30 | Phòng 1 | F8
(538, 7, NULL, '2026-11-13T16:09:10', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 103 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 17:45 | Phòng 5 | G1 G2 G3
(539, 7, NULL, '2026-11-13T16:16:04', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 107 | Godzilla Trừ Không | 13/11 18:30 | Phòng 4 | F4 F5 F6 F7
(540, 8, NULL, '2026-11-13T16:17:16', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 112 | Godzilla Trừ Không | 13/11 21:00 | Phòng 5 | K6 K7
(541, 9, NULL, '2026-11-13T16:20:15', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 167 | Chị Chị Em Em 3 | 15/11 21:30 | Phòng 1 | J3 J4
(542, 8, NULL, '2026-11-13T16:20:51', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 107 | Godzilla Trừ Không | 13/11 18:30 | Phòng 4 | H9 H10
(543, 9, NULL, '2026-11-13T16:30:51', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 110 | Trại Buôn Người | 13/11 20:45 | Phòng 2 | D5
(544, 9, NULL, '2026-11-13T16:44:43', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | F9 F10
(545, 9, NULL, '2026-11-13T16:54:22', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 130 | Clayface | 14/11 17:00 | Phòng 3 | D6
(546, 7, NULL, '2026-11-13T16:56:44', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 103 | Ramayana: Khởi Nguồn Một Huyền Thoại | 13/11 17:45 | Phòng 5 | H10
(547, 8, NULL, '2026-11-13T17:03:54', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 109 | Chị Chị Em Em 3 | 13/11 20:45 | Phòng 1 | F3 F4
(548, 9, NULL, '2026-11-13T17:06:21', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 124 | Chị Chị Em Em 3 | 14/11 14:00 | Phòng 1 | G7
(549, 8, NULL, '2026-11-13T17:15:43', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 107 | Godzilla Trừ Không | 13/11 18:30 | Phòng 4 | E4 E5
(550, 8, NULL, '2026-11-13T17:23:35', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 163 | Ngày Con Còn Mẹ | 15/11 19:15 | Phòng 3 | G11 G12
(551, 8, NULL, '2026-11-13T17:25:15', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 116 | Kiến Lé Phiêu Lưu Ké | 14/11 09:30 | Phòng 2 | E9 E10
(552, 9, 93, '2026-11-13T17:30:54', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 109 | Chị Chị Em Em 3 | 13/11 20:45 | Phòng 1 | H5 H6
(553, 8, 69, '2026-11-13T17:51:06', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 110 | Trại Buôn Người | 13/11 20:45 | Phòng 2 | H9 H10
(554, 9, NULL, '2026-11-13T17:51:50', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 106 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 13/11 18:30 | Phòng 2 | J9 J10
(555, 9, 42, '2026-11-13T18:01:39', 360000, N'Paid', N'Cash', 360000, 25, 0, NULL, NULL, NULL), -- suat 129 | Bò Sữa Bay | 14/11 16:30 | Phòng 1 | D6 D7 D8 D9
(556, 8, NULL, '2026-11-13T18:17:13', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 112 | Godzilla Trừ Không | 13/11 21:00 | Phòng 5 | H6 H7 H8
(557, 7, NULL, '2026-11-13T18:17:41', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-11-13T18:27:16', 7), -- suat 109 | Chị Chị Em Em 3 | 13/11 20:45 | Phòng 1 | J11 J12
(558, 9, 42, '2026-11-13T18:23:05', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 108 | Clayface | 13/11 20:15 | Phòng 3 | E2 E3 E4
(559, 8, NULL, '2026-11-13T18:24:07', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 111 | Bí Kíp Luyện Cướp | 13/11 21:00 | Phòng 4 | D7 D8 D9
(560, 9, 21, '2026-11-13T18:30:42', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 154 | Dune: Hành Tinh Cát | 15/11 15:00 | Phòng 5 | J10 J11
(561, 7, NULL, '2026-11-13T18:38:34', 324000, N'Paid', N'Cash', 330000, 0, 0, NULL, NULL, NULL), -- suat 137 | Godzilla Trừ Không | 14/11 21:00 | Phòng 4 | H1 H2 H3
(562, 8, 114, '2026-11-13T18:47:22', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 109 | Chị Chị Em Em 3 | 13/11 20:45 | Phòng 1 | G2 G3
(563, 8, NULL, '2026-11-13T18:47:55', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 140 | Bí Kíp Luyện Cướp | 14/11 21:30 | Phòng 3 | E7 E8
(564, 9, NULL, '2026-11-13T18:49:51', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 114 | Dune: Hành Tinh Cát | 14/11 09:00 | Phòng 5 | L9 L10
(565, 9, NULL, '2026-11-13T18:52:02', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 137 | Godzilla Trừ Không | 14/11 21:00 | Phòng 4 | B3 B4 B5
(566, 8, NULL, '2026-11-13T18:52:26', 864000, N'Paid', N'Cash', 864000, 0, 0, NULL, NULL, NULL), -- suat 112 | Godzilla Trừ Không | 13/11 21:00 | Phòng 5 | J3 J4 J5 J6 J7 J8
(567, 8, NULL, '2026-11-13T18:54:18', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 164 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 15/11 20:45 | Phòng 2 | D6 D7 D8 D9
(568, 7, NULL, '2026-11-13T18:54:47', 75000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 111 | Bí Kíp Luyện Cướp | 13/11 21:00 | Phòng 4 | B6
(569, 8, NULL, '2026-11-13T18:59:00', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 163 | Ngày Con Còn Mẹ | 15/11 19:15 | Phòng 3 | J11 J12
(570, 7, 120, '2026-11-13T19:13:54', 720000, N'Paid', N'Card', NULL, 50, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | G1 G2 G3 G4 G5
(571, 8, NULL, '2026-11-13T19:28:58', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 139 | Chị Chị Em Em 3 | 14/11 21:30 | Phòng 1 | J11 J12
(572, 9, 2, '2026-11-13T19:41:14', 120000, N'Cancelled', N'Transfer', NULL, 6, 0, N'Khách đổi ý', '2026-11-13T20:00:45', 9), -- suat 112 | Godzilla Trừ Không | 13/11 21:00 | Phòng 5 | D10
(573, 9, NULL, '2026-11-13T19:46:32', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 111 | Bí Kíp Luyện Cướp | 13/11 21:00 | Phòng 4 | H5
(574, 7, NULL, '2026-11-13T19:56:03', 720000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 112 | Godzilla Trừ Không | 13/11 21:00 | Phòng 5 | F3 F4 F5 F6 F7
(575, 7, NULL, '2026-11-13T20:09:42', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 149 | Kẻ Hồi Sinh | 15/11 12:30 | Phòng 3 | E6 E7
(576, 9, NULL, '2026-11-13T20:11:06', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 159 | Ramayana: Khởi Nguồn Một Huyền Thoại | 15/11 17:45 | Phòng 4 | G9 G10
(577, 8, NULL, '2026-11-13T20:12:07', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 136 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 14/11 20:45 | Phòng 2 | E3 E4
(578, 7, NULL, '2026-11-13T21:11:00', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 138 | Dune: Hành Tinh Cát | 14/11 21:00 | Phòng 5 | E7 E8
(579, 8, NULL, '2026-11-13T21:13:10', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 136 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 14/11 20:45 | Phòng 2 | G10 G11
(580, 8, NULL, '2026-11-13T21:29:37', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL); -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | D7 D8
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(986, 415, 86, 5, 534, 144000, N'Active'),
(987, 416, 137, 4, 376, 108000, N'Active'),
(988, 416, 137, 4, 377, 108000, N'Active'),
(989, 416, 137, 4, 378, 108000, N'Active'),
(990, 417, 115, 4, 362, 108000, N'Active'),
(991, 417, 115, 4, 363, 108000, N'Active'),
(992, 418, 89, 3, 236, 75000, N'Active'),
(993, 418, 89, 3, 237, 75000, N'Active'),
(994, 419, 85, 1, 107, 90000, N'Active'),
(995, 419, 85, 1, 108, 90000, N'Active'),
(996, 420, 85, 1, 34, 75000, N'Active'),
(997, 420, 85, 1, 35, 75000, N'Active'),
(998, 421, 86, 5, 557, 144000, N'Active'),
(999, 421, 86, 5, 558, 144000, N'Active'),
(1000, 422, 86, 5, 523, 144000, N'Active'),
(1001, 423, 85, 1, 48, 90000, N'Active'),
(1002, 424, 167, 1, 78, 90000, N'Active'),
(1003, 424, 167, 1, 79, 90000, N'Active'),
(1004, 425, 85, 1, 28, 75000, N'Active'),
(1005, 426, 86, 5, 474, 120000, N'Active'),
(1006, 426, 86, 5, 475, 120000, N'Active'),
(1007, 426, 86, 5, 476, 120000, N'Active'),
(1008, 427, 89, 3, 218, 75000, N'Active'),
(1009, 427, 89, 3, 219, 75000, N'Active'),
(1010, 427, 89, 3, 220, 75000, N'Active'),
(1011, 428, 86, 5, 498, 144000, N'Active'),
(1012, 429, 94, 4, 373, 108000, N'Active'),
(1013, 429, 94, 4, 374, 108000, N'Active'),
(1014, 429, 94, 4, 375, 108000, N'Active'),
(1015, 429, 94, 4, 376, 108000, N'Active'),
(1016, 430, 85, 1, 40, 90000, N'Active'),
(1017, 430, 85, 1, 41, 90000, N'Active'),
(1018, 431, 87, 4, 404, 108000, N'Active'),
(1019, 432, 117, 3, 270, 90000, N'Active'),
(1020, 432, 117, 3, 271, 90000, N'Active'),
(1021, 433, 140, 3, 301, 90000, N'Active'),
(1022, 433, 140, 3, 302, 90000, N'Active'),
(1023, 434, 97, 3, 304, 90000, N'Cancelled'),
(1024, 435, 90, 1, 76, 90000, N'Active'),
(1025, 435, 90, 1, 77, 90000, N'Active'),
(1026, 435, 90, 1, 78, 90000, N'Active'),
(1027, 436, 138, 5, 514, 144000, N'Active'),
(1028, 436, 138, 5, 515, 144000, N'Active'),
(1029, 437, 91, 2, 165, 90000, N'Active'),
(1030, 437, 91, 2, 166, 90000, N'Active'),
(1031, 437, 91, 2, 167, 90000, N'Active'),
(1032, 438, 90, 1, 58, 90000, N'Active'),
(1033, 439, 90, 1, 101, 90000, N'Active'),
(1034, 439, 90, 1, 102, 90000, N'Active'),
(1035, 440, 92, 3, 279, 90000, N'Active'),
(1036, 440, 92, 3, 280, 90000, N'Active'),
(1037, 440, 92, 3, 281, 90000, N'Active'),
(1038, 441, 99, 4, 409, 108000, N'Active'),
(1039, 441, 99, 4, 410, 108000, N'Active'),
(1040, 441, 99, 4, 411, 108000, N'Active'),
(1041, 442, 100, 2, 209, 90000, N'Active'),
(1042, 442, 100, 2, 210, 90000, N'Active'),
(1043, 443, 93, 5, 522, 144000, N'Active'),
(1044, 443, 93, 5, 523, 144000, N'Active'),
(1045, 443, 93, 5, 524, 144000, N'Active'),
(1046, 443, 93, 5, 525, 144000, N'Active'),
(1047, 444, 91, 2, 162, 90000, N'Active'),
(1048, 444, 91, 2, 163, 90000, N'Active'),
(1049, 445, 102, 1, 65, 90000, N'Active'),
(1050, 445, 102, 1, 66, 90000, N'Active'),
(1051, 446, 99, 4, 357, 90000, N'Active'),
(1052, 446, 99, 4, 358, 90000, N'Active'),
(1053, 447, 94, 4, 377, 108000, N'Active'),
(1054, 447, 94, 4, 378, 108000, N'Active'),
(1055, 447, 94, 4, 379, 108000, N'Active'),
(1056, 447, 94, 4, 380, 108000, N'Active'),
(1057, 448, 161, 5, 447, 120000, N'Active'),
(1058, 448, 161, 5, 448, 120000, N'Active'),
(1059, 448, 161, 5, 449, 120000, N'Active'),
(1060, 448, 161, 5, 450, 120000, N'Active'),
(1061, 449, 95, 1, 61, 90000, N'Active'),
(1062, 449, 95, 1, 62, 90000, N'Active'),
(1063, 449, 95, 1, 63, 90000, N'Active'),
(1064, 450, 107, 4, 374, 108000, N'Active'),
(1065, 450, 107, 4, 375, 108000, N'Active'),
(1066, 451, 128, 2, 183, 90000, N'Active'),
(1067, 451, 128, 2, 184, 90000, N'Active'),
(1068, 452, 139, 1, 101, 90000, N'Active'),
(1069, 452, 139, 1, 102, 90000, N'Active'),
(1070, 453, 105, 1, 45, 90000, N'Active'),
(1071, 453, 105, 1, 46, 90000, N'Active'),
(1072, 454, 92, 3, 296, 90000, N'Cancelled'),
(1073, 454, 92, 3, 297, 90000, N'Cancelled'),
(1074, 455, 95, 1, 78, 90000, N'Active'),
(1075, 455, 95, 1, 79, 90000, N'Active'),
(1076, 456, 102, 1, 40, 90000, N'Active'),
(1077, 456, 102, 1, 41, 90000, N'Active'),
(1078, 456, 102, 1, 42, 90000, N'Active'),
(1079, 456, 102, 1, 43, 90000, N'Active'),
(1080, 456, 102, 1, 44, 90000, N'Active'),
(1081, 456, 102, 1, 45, 90000, N'Active'),
(1082, 457, 94, 4, 423, 108000, N'Active'),
(1083, 457, 94, 4, 424, 108000, N'Active'),
(1084, 458, 96, 2, 161, 90000, N'Active'),
(1085, 458, 96, 2, 162, 90000, N'Active'),
(1086, 459, 97, 3, 269, 90000, N'Active'),
(1087, 459, 97, 3, 270, 90000, N'Active'),
(1088, 460, 161, 5, 480, 120000, N'Active'),
(1089, 461, 95, 1, 75, 90000, N'Active'),
(1090, 462, 95, 1, 89, 90000, N'Active'),
(1091, 462, 95, 1, 90, 90000, N'Active'),
(1092, 463, 94, 4, 382, 108000, N'Active'),
(1093, 463, 94, 4, 383, 108000, N'Active'),
(1094, 463, 94, 4, 384, 108000, N'Active'),
(1095, 464, 103, 5, 499, 144000, N'Cancelled'),
(1096, 465, 163, 3, 222, 75000, N'Active'),
(1097, 465, 163, 3, 223, 75000, N'Active'),
(1098, 466, 152, 1, 55, 90000, N'Active'),
(1099, 466, 152, 1, 56, 90000, N'Active'),
(1100, 467, 96, 2, 137, 75000, N'Active'),
(1101, 467, 96, 2, 138, 75000, N'Active'),
(1102, 468, 97, 3, 281, 90000, N'Active'),
(1103, 468, 97, 3, 282, 90000, N'Active'),
(1104, 469, 137, 4, 389, 108000, N'Active'),
(1105, 469, 137, 4, 390, 108000, N'Active'),
(1106, 469, 137, 4, 391, 108000, N'Active'),
(1107, 469, 137, 4, 392, 108000, N'Active'),
(1108, 470, 96, 2, 174, 90000, N'Active'),
(1109, 470, 96, 2, 175, 90000, N'Active'),
(1110, 470, 96, 2, 176, 90000, N'Active'),
(1111, 471, 164, 2, 184, 90000, N'Active'),
(1112, 471, 164, 2, 185, 90000, N'Active'),
(1113, 471, 164, 2, 186, 90000, N'Active'),
(1114, 471, 164, 2, 187, 90000, N'Active'),
(1115, 472, 103, 5, 563, 144000, N'Active'),
(1116, 472, 103, 5, 564, 144000, N'Active'),
(1117, 473, 97, 3, 309, 90000, N'Active'),
(1118, 474, 120, 5, 532, 144000, N'Active'),
(1119, 474, 120, 5, 533, 144000, N'Active'),
(1120, 475, 102, 1, 62, 90000, N'Active'),
(1121, 476, 95, 1, 39, 90000, N'Active'),
(1122, 476, 95, 1, 40, 90000, N'Active'),
(1123, 477, 103, 5, 517, 144000, N'Active'),
(1124, 477, 103, 5, 518, 144000, N'Active'),
(1125, 478, 162, 1, 89, 90000, N'Active'),
(1126, 479, 109, 1, 16, 75000, N'Active'),
(1127, 479, 109, 1, 17, 75000, N'Active'),
(1128, 480, 98, 5, 450, 120000, N'Active'),
(1129, 480, 98, 5, 451, 120000, N'Active'),
(1130, 481, 134, 1, 44, 90000, N'Active'),
(1131, 481, 134, 1, 45, 90000, N'Active'),
(1132, 481, 134, 1, 46, 90000, N'Active'),
(1133, 481, 134, 1, 47, 90000, N'Active'),
(1134, 481, 134, 1, 48, 90000, N'Active'),
(1135, 482, 107, 4, 333, 90000, N'Active'),
(1136, 482, 107, 4, 334, 90000, N'Active'),
(1137, 483, 98, 5, 537, 144000, N'Active'),
(1138, 483, 98, 5, 538, 144000, N'Active'),
(1139, 483, 98, 5, 539, 144000, N'Active'),
(1140, 484, 98, 5, 517, 144000, N'Active'),
(1141, 484, 98, 5, 518, 144000, N'Active'),
(1142, 485, 102, 1, 35, 75000, N'Active'),
(1143, 486, 102, 1, 32, 75000, N'Active'),
(1144, 486, 102, 1, 33, 75000, N'Active'),
(1145, 486, 102, 1, 34, 75000, N'Active'),
(1146, 487, 101, 3, 256, 90000, N'Active'),
(1147, 487, 101, 3, 257, 90000, N'Active'),
(1148, 488, 96, 2, 211, 90000, N'Active'),
(1149, 488, 96, 2, 212, 90000, N'Active'),
(1150, 489, 98, 5, 550, 144000, N'Active'),
(1151, 490, 112, 5, 502, 144000, N'Active'),
(1152, 490, 112, 5, 503, 144000, N'Active'),
(1153, 490, 112, 5, 504, 144000, N'Active'),
(1154, 491, 117, 3, 267, 90000, N'Active'),
(1155, 491, 117, 3, 268, 90000, N'Active'),
(1156, 492, 103, 5, 495, 144000, N'Active'),
(1157, 492, 103, 5, 496, 144000, N'Active'),
(1158, 493, 133, 5, 537, 144000, N'Active'),
(1159, 493, 133, 5, 538, 144000, N'Active'),
(1160, 494, 104, 3, 223, 75000, N'Active'),
(1161, 494, 104, 3, 224, 75000, N'Active'),
(1162, 495, 102, 1, 80, 90000, N'Active'),
(1163, 495, 102, 1, 81, 90000, N'Active'),
(1164, 496, 143, 4, 366, 108000, N'Active'),
(1165, 496, 143, 4, 367, 108000, N'Active'),
(1166, 497, 102, 1, 46, 90000, N'Active'),
(1167, 497, 102, 1, 47, 90000, N'Active'),
(1168, 497, 102, 1, 48, 90000, N'Active'),
(1169, 498, 100, 2, 175, 90000, N'Active'),
(1170, 498, 100, 2, 176, 90000, N'Active'),
(1171, 499, 107, 4, 421, 108000, N'Active'),
(1172, 499, 107, 4, 422, 108000, N'Active'),
(1173, 500, 103, 5, 485, 144000, N'Active'),
(1174, 500, 103, 5, 486, 144000, N'Active'),
(1175, 501, 107, 4, 423, 108000, N'Active'),
(1176, 501, 107, 4, 424, 108000, N'Active'),
(1177, 502, 116, 2, 215, 90000, N'Cancelled'),
(1178, 502, 116, 2, 216, 90000, N'Cancelled'),
(1179, 503, 134, 1, 89, 90000, N'Active'),
(1180, 503, 134, 1, 90, 90000, N'Active'),
(1181, 504, 104, 3, 267, 90000, N'Active'),
(1182, 504, 104, 3, 268, 90000, N'Active'),
(1183, 505, 118, 2, 150, 90000, N'Active'),
(1184, 505, 118, 2, 151, 90000, N'Active'),
(1185, 505, 118, 2, 152, 90000, N'Active'),
(1186, 506, 99, 4, 425, 108000, N'Active'),
(1187, 506, 99, 4, 426, 108000, N'Active'),
(1188, 507, 154, 5, 553, 144000, N'Active'),
(1189, 507, 154, 5, 554, 144000, N'Active'),
(1190, 508, 103, 5, 520, 144000, N'Active'),
(1191, 508, 103, 5, 521, 144000, N'Active'),
(1192, 508, 103, 5, 522, 144000, N'Active'),
(1193, 508, 103, 5, 523, 144000, N'Active'),
(1194, 509, 107, 4, 385, 108000, N'Active'),
(1195, 509, 107, 4, 386, 108000, N'Active'),
(1196, 510, 130, 3, 220, 75000, N'Active'),
(1197, 510, 130, 3, 221, 75000, N'Active'),
(1198, 511, 138, 5, 522, 144000, N'Active'),
(1199, 511, 138, 5, 523, 144000, N'Active'),
(1200, 511, 138, 5, 524, 144000, N'Active'),
(1201, 512, 129, 1, 74, 90000, N'Active'),
(1202, 512, 129, 1, 75, 90000, N'Active'),
(1203, 512, 129, 1, 76, 90000, N'Active'),
(1204, 512, 129, 1, 77, 90000, N'Active'),
(1205, 513, 103, 5, 469, 120000, N'Active'),
(1206, 513, 103, 5, 470, 120000, N'Active'),
(1207, 514, 108, 3, 262, 90000, N'Active'),
(1208, 514, 108, 3, 263, 90000, N'Active'),
(1209, 515, 105, 1, 61, 90000, N'Active'),
(1210, 515, 105, 1, 62, 90000, N'Active'),
(1211, 516, 106, 2, 172, 90000, N'Active'),
(1212, 516, 106, 2, 173, 90000, N'Active'),
(1213, 516, 106, 2, 174, 90000, N'Active'),
(1214, 516, 106, 2, 175, 90000, N'Active'),
(1215, 517, 159, 4, 378, 108000, N'Active'),
(1216, 517, 159, 4, 379, 108000, N'Active'),
(1217, 518, 154, 5, 504, 144000, N'Active'),
(1218, 519, 133, 5, 510, 144000, N'Active'),
(1219, 519, 133, 5, 511, 144000, N'Active'),
(1220, 519, 133, 5, 512, 144000, N'Active'),
(1221, 520, 104, 3, 293, 90000, N'Active'),
(1222, 520, 104, 3, 294, 90000, N'Active'),
(1223, 521, 151, 2, 200, 90000, N'Active'),
(1224, 522, 103, 5, 553, 144000, N'Active'),
(1225, 522, 103, 5, 554, 144000, N'Active'),
(1226, 523, 103, 5, 557, 144000, N'Active'),
(1227, 523, 103, 5, 558, 144000, N'Active'),
(1228, 524, 106, 2, 189, 90000, N'Active'),
(1229, 525, 110, 2, 176, 90000, N'Active'),
(1230, 525, 110, 2, 177, 90000, N'Active'),
(1231, 526, 103, 5, 508, 144000, N'Active'),
(1232, 526, 103, 5, 509, 144000, N'Active'),
(1233, 526, 103, 5, 510, 144000, N'Active'),
(1234, 526, 103, 5, 511, 144000, N'Active'),
(1235, 527, 106, 2, 195, 90000, N'Active'),
(1236, 527, 106, 2, 196, 90000, N'Active'),
(1237, 527, 106, 2, 197, 90000, N'Active'),
(1238, 528, 109, 1, 66, 90000, N'Active'),
(1239, 529, 111, 4, 390, 90000, N'Active'),
(1240, 529, 111, 4, 391, 90000, N'Active'),
(1241, 530, 117, 3, 236, 75000, N'Active'),
(1242, 530, 117, 3, 237, 75000, N'Active'),
(1243, 530, 117, 3, 238, 75000, N'Active'),
(1244, 530, 117, 3, 239, 75000, N'Active'),
(1245, 530, 117, 3, 240, 75000, N'Active'),
(1246, 531, 135, 3, 293, 90000, N'Active'),
(1247, 531, 135, 3, 294, 90000, N'Active'),
(1248, 532, 142, 5, 512, 144000, N'Active'),
(1249, 532, 142, 5, 513, 144000, N'Active'),
(1250, 532, 142, 5, 514, 144000, N'Active'),
(1251, 533, 162, 1, 77, 90000, N'Active'),
(1252, 533, 162, 1, 78, 90000, N'Active'),
(1253, 534, 120, 5, 449, 120000, N'Active'),
(1254, 534, 120, 5, 450, 120000, N'Active'),
(1255, 534, 120, 5, 451, 120000, N'Active'),
(1256, 535, 107, 4, 427, 108000, N'Cancelled'),
(1257, 535, 107, 4, 428, 108000, N'Cancelled'),
(1258, 536, 110, 2, 185, 90000, N'Active'),
(1259, 536, 110, 2, 186, 90000, N'Active'),
(1260, 537, 105, 1, 68, 90000, N'Active'),
(1261, 538, 103, 5, 505, 144000, N'Active'),
(1262, 538, 103, 5, 506, 144000, N'Active'),
(1263, 538, 103, 5, 507, 144000, N'Active'),
(1264, 539, 107, 4, 388, 108000, N'Active'),
(1265, 539, 107, 4, 389, 108000, N'Active'),
(1266, 539, 107, 4, 390, 108000, N'Active'),
(1267, 539, 107, 4, 391, 108000, N'Active'),
(1268, 540, 112, 5, 546, 144000, N'Active'),
(1269, 540, 112, 5, 547, 144000, N'Active'),
(1270, 541, 167, 1, 99, 90000, N'Active'),
(1271, 541, 167, 1, 100, 90000, N'Active'),
(1272, 542, 107, 4, 417, 108000, N'Active'),
(1273, 542, 107, 4, 418, 108000, N'Active'),
(1274, 543, 110, 2, 149, 90000, N'Active'),
(1275, 544, 133, 5, 501, 144000, N'Active'),
(1276, 544, 133, 5, 502, 144000, N'Active'),
(1277, 545, 130, 3, 258, 90000, N'Active'),
(1278, 546, 103, 5, 526, 144000, N'Active'),
(1279, 547, 109, 1, 63, 90000, N'Active'),
(1280, 547, 109, 1, 64, 90000, N'Active'),
(1281, 548, 124, 1, 79, 90000, N'Active'),
(1282, 549, 107, 4, 376, 108000, N'Active'),
(1283, 549, 107, 4, 377, 108000, N'Active'),
(1284, 550, 163, 3, 299, 90000, N'Active'),
(1285, 550, 163, 3, 300, 90000, N'Active'),
(1286, 551, 116, 2, 165, 90000, N'Active'),
(1287, 551, 116, 2, 166, 90000, N'Active'),
(1288, 552, 109, 1, 89, 90000, N'Active'),
(1289, 552, 109, 1, 90, 90000, N'Active'),
(1290, 553, 110, 2, 201, 90000, N'Active'),
(1291, 553, 110, 2, 202, 90000, N'Active'),
(1292, 554, 106, 2, 213, 90000, N'Active'),
(1293, 554, 106, 2, 214, 90000, N'Active'),
(1294, 555, 129, 1, 42, 90000, N'Active'),
(1295, 555, 129, 1, 43, 90000, N'Active'),
(1296, 555, 129, 1, 44, 90000, N'Active'),
(1297, 555, 129, 1, 45, 90000, N'Active'),
(1298, 556, 112, 5, 522, 144000, N'Active'),
(1299, 556, 112, 5, 523, 144000, N'Active'),
(1300, 556, 112, 5, 524, 144000, N'Active'),
(1301, 557, 109, 1, 107, 90000, N'Cancelled'),
(1302, 557, 109, 1, 108, 90000, N'Cancelled'),
(1303, 558, 108, 3, 266, 90000, N'Active'),
(1304, 558, 108, 3, 267, 90000, N'Active'),
(1305, 558, 108, 3, 268, 90000, N'Active'),
(1306, 559, 111, 4, 367, 90000, N'Active'),
(1307, 559, 111, 4, 368, 90000, N'Active'),
(1308, 559, 111, 4, 369, 90000, N'Active'),
(1309, 560, 154, 5, 538, 144000, N'Active'),
(1310, 560, 154, 5, 539, 144000, N'Active'),
(1311, 561, 137, 4, 409, 108000, N'Active'),
(1312, 561, 137, 4, 410, 108000, N'Active'),
(1313, 561, 137, 4, 411, 108000, N'Active'),
(1314, 562, 109, 1, 74, 90000, N'Active'),
(1315, 562, 109, 1, 75, 90000, N'Active'),
(1316, 563, 140, 3, 271, 90000, N'Active'),
(1317, 563, 140, 3, 272, 90000, N'Active'),
(1318, 564, 114, 5, 561, 144000, N'Active'),
(1319, 564, 114, 5, 562, 144000, N'Active'),
(1320, 565, 137, 4, 339, 90000, N'Active'),
(1321, 565, 137, 4, 340, 90000, N'Active'),
(1322, 565, 137, 4, 341, 90000, N'Active'),
(1323, 566, 112, 5, 531, 144000, N'Active'),
(1324, 566, 112, 5, 532, 144000, N'Active'),
(1325, 566, 112, 5, 533, 144000, N'Active'),
(1326, 566, 112, 5, 534, 144000, N'Active'),
(1327, 566, 112, 5, 535, 144000, N'Active'),
(1328, 566, 112, 5, 536, 144000, N'Active'),
(1329, 567, 164, 2, 150, 90000, N'Active'),
(1330, 567, 164, 2, 151, 90000, N'Active'),
(1331, 567, 164, 2, 152, 90000, N'Active'),
(1332, 567, 164, 2, 153, 90000, N'Active'),
(1333, 568, 111, 4, 342, 75000, N'Active'),
(1334, 569, 163, 3, 323, 90000, N'Active'),
(1335, 569, 163, 3, 324, 90000, N'Active'),
(1336, 570, 133, 5, 505, 144000, N'Active'),
(1337, 570, 133, 5, 506, 144000, N'Active'),
(1338, 570, 133, 5, 507, 144000, N'Active'),
(1339, 570, 133, 5, 508, 144000, N'Active'),
(1340, 570, 133, 5, 509, 144000, N'Active'),
(1341, 571, 139, 1, 107, 90000, N'Active'),
(1342, 571, 139, 1, 108, 90000, N'Active'),
(1343, 572, 112, 5, 478, 120000, N'Cancelled'),
(1344, 573, 111, 4, 413, 90000, N'Active'),
(1345, 574, 112, 5, 495, 144000, N'Active'),
(1346, 574, 112, 5, 496, 144000, N'Active'),
(1347, 574, 112, 5, 497, 144000, N'Active'),
(1348, 574, 112, 5, 498, 144000, N'Active'),
(1349, 574, 112, 5, 499, 144000, N'Active'),
(1350, 575, 149, 3, 270, 90000, N'Active'),
(1351, 575, 149, 3, 271, 90000, N'Active'),
(1352, 576, 159, 4, 405, 108000, N'Active'),
(1353, 576, 159, 4, 406, 108000, N'Active'),
(1354, 577, 136, 2, 159, 90000, N'Active'),
(1355, 577, 136, 2, 160, 90000, N'Active'),
(1356, 578, 138, 5, 487, 144000, N'Active'),
(1357, 578, 138, 5, 488, 144000, N'Active'),
(1358, 579, 136, 2, 190, 90000, N'Active'),
(1359, 579, 136, 2, 191, 90000, N'Active'),
(1360, 580, 162, 1, 43, 90000, N'Active'),
(1361, 580, 162, 1, 44, 90000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 7 14/11/2026: 202 hoa don (6 huy), 489 ve, doanh thu 47.654.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(581, 7, 44, '2026-11-14T08:09:38', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 152 | Chị Chị Em Em 3 | 15/11 14:00 | Phòng 1 | G9 G10 G11
(582, 7, 113, '2026-11-14T08:11:58', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 151 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 15/11 13:30 | Phòng 2 | D1
(583, 7, NULL, '2026-11-14T08:12:55', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 117 | Bí Kíp Luyện Cướp | 14/11 10:00 | Phòng 3 | D2 D3 D4 D5
(584, 8, NULL, '2026-11-14T08:14:16', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 113 | Bò Sữa Bay | 14/11 09:00 | Phòng 1 | E5 E6
(585, 7, 120, '2026-11-14T08:15:34', 120000, N'Paid', N'Cash', 120000, 6, 0, NULL, NULL, NULL), -- suat 114 | Dune: Hành Tinh Cát | 14/11 09:00 | Phòng 5 | D2
(586, 8, NULL, '2026-11-14T08:21:21', 450000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 113 | Bò Sữa Bay | 14/11 09:00 | Phòng 1 | E7 E8 E9 E10 E11
(587, 9, NULL, '2026-11-14T08:22:35', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 153 | Thiên Đường Tăm Tối | 15/11 14:45 | Phòng 3 | F6 F7 F8
(588, 7, NULL, '2026-11-14T08:27:13', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 113 | Bò Sữa Bay | 14/11 09:00 | Phòng 1 | F1 F2 F3 F4
(589, 9, NULL, '2026-11-14T08:27:36', 75000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 113 | Bò Sữa Bay | 14/11 09:00 | Phòng 1 | B5
(590, 7, NULL, '2026-11-14T08:29:37', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 117 | Bí Kíp Luyện Cướp | 14/11 10:00 | Phòng 3 | D8 D9 D10
(591, 8, NULL, '2026-11-14T08:31:17', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 113 | Bò Sữa Bay | 14/11 09:00 | Phòng 1 | C3 C4
(592, 9, 25, '2026-11-14T08:31:34', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 115 | Ramayana: Khởi Nguồn Một Huyền Thoại | 14/11 09:15 | Phòng 4 | F8 F9
(593, 7, NULL, '2026-11-14T08:37:21', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 159 | Ramayana: Khởi Nguồn Một Huyền Thoại | 15/11 17:45 | Phòng 4 | C6 C7
(594, 7, NULL, '2026-11-14T08:38:55', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 150 | Godzilla Trừ Không | 15/11 12:30 | Phòng 4 | J5 J6
(595, 8, NULL, '2026-11-14T08:40:08', 240000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 114 | Dune: Hành Tinh Cát | 14/11 09:00 | Phòng 5 | D7 D8
(596, 9, NULL, '2026-11-14T08:40:19', 216000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 115 | Ramayana: Khởi Nguồn Một Huyền Thoại | 14/11 09:15 | Phòng 4 | D11 D12
(597, 9, NULL, '2026-11-14T08:41:09', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 116 | Kiến Lé Phiêu Lưu Ké | 14/11 09:30 | Phòng 2 | F5 F6 F7 F8
(598, 8, NULL, '2026-11-14T08:42:49', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 113 | Bò Sữa Bay | 14/11 09:00 | Phòng 1 | C8 C9
(599, 8, 72, '2026-11-14T08:44:28', 288000, N'Paid', N'Cash', 290000, 28, 0, NULL, NULL, NULL), -- suat 114 | Dune: Hành Tinh Cát | 14/11 09:00 | Phòng 5 | L3 L4
(600, 9, NULL, '2026-11-14T08:47:26', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 118 | Chàng Mèo Mang Mũ | 14/11 11:15 | Phòng 2 | G7
(601, 7, 47, '2026-11-14T08:48:42', 864000, N'Paid', N'Transfer', NULL, 60, 0, NULL, NULL, NULL), -- suat 114 | Dune: Hành Tinh Cát | 14/11 09:00 | Phòng 5 | J6 J7 J8 J9 J10 J11
(602, 7, NULL, '2026-11-14T08:49:41', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 124 | Chị Chị Em Em 3 | 14/11 14:00 | Phòng 1 | H4 H5
(603, 7, NULL, '2026-11-14T08:51:03', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 115 | Ramayana: Khởi Nguồn Một Huyền Thoại | 14/11 09:15 | Phòng 4 | C5 C6 C7
(604, 7, NULL, '2026-11-14T08:52:54', 576000, N'Paid', N'Cash', 600000, 0, 0, NULL, NULL, NULL), -- suat 114 | Dune: Hành Tinh Cát | 14/11 09:00 | Phòng 5 | K2 K3 K4 K5
(605, 9, 1, '2026-11-14T08:54:06', 216000, N'Paid', N'Transfer', NULL, 21, 0, NULL, NULL, NULL), -- suat 150 | Godzilla Trừ Không | 15/11 12:30 | Phòng 4 | J3 J4
(606, 9, NULL, '2026-11-14T09:01:01', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 116 | Kiến Lé Phiêu Lưu Ké | 14/11 09:30 | Phòng 2 | B4 B5 B6
(607, 8, NULL, '2026-11-14T09:08:26', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 121 | Kẻ Hồi Sinh | 14/11 12:30 | Phòng 3 | G10
(608, 9, NULL, '2026-11-14T09:11:36', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 116 | Kiến Lé Phiêu Lưu Ké | 14/11 09:30 | Phòng 2 | H4 H5 H6 H7
(609, 8, 92, '2026-11-14T09:15:17', 432000, N'Paid', N'Cash', 500000, 30, 0, NULL, NULL, NULL), -- suat 120 | Godzilla Trừ Không | 14/11 12:15 | Phòng 5 | H7 H8 H9
(610, 8, NULL, '2026-11-14T09:16:25', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 118 | Chàng Mèo Mang Mũ | 14/11 11:15 | Phòng 2 | A8 A9
(611, 9, 49, '2026-11-14T09:18:07', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 117 | Bí Kíp Luyện Cướp | 14/11 10:00 | Phòng 3 | F8 F9
(612, 7, 69, '2026-11-14T09:22:31', 270000, N'Paid', N'Cash', 300000, 18, 0, NULL, NULL, NULL), -- suat 177 | Kẻ Hồi Sinh | 16/11 12:30 | Phòng 3 | G6 G7 G8
(613, 9, NULL, '2026-11-14T09:25:30', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 123 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 14/11 13:30 | Phòng 2 | D7 D8
(614, 9, NULL, '2026-11-14T09:27:22', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 153 | Thiên Đường Tăm Tối | 15/11 14:45 | Phòng 3 | J7 J8
(615, 9, NULL, '2026-11-14T09:28:29', 540000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 156 | Ngày Con Còn Mẹ | 15/11 15:30 | Phòng 2 | G3 G4 G5 G6 G7 G8
(616, 9, NULL, '2026-11-14T09:33:35', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 173 | Bí Kíp Luyện Cướp | 16/11 10:00 | Phòng 3 | G5 G6
(617, 8, NULL, '2026-11-14T09:34:23', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 163 | Ngày Con Còn Mẹ | 15/11 19:15 | Phòng 3 | G4 G5 G6 G7
(618, 9, 32, '2026-11-14T09:38:03', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 119 | Ngày Con Còn Mẹ | 14/11 11:30 | Phòng 1 | D2 D3
(619, 7, NULL, '2026-11-14T09:39:33', 540000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 123 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 14/11 13:30 | Phòng 2 | F3 F4 F5 F6 F7 F8
(620, 7, 60, '2026-11-14T09:42:03', 360000, N'Paid', N'Card', NULL, 25, 0, NULL, NULL, NULL), -- suat 152 | Chị Chị Em Em 3 | 15/11 14:00 | Phòng 1 | F6 F7 F8 F9
(621, 8, 83, '2026-11-14T09:46:51', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 129 | Bò Sữa Bay | 14/11 16:30 | Phòng 1 | J7 J8
(622, 8, NULL, '2026-11-14T10:00:18', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 122 | Godzilla Trừ Không | 14/11 12:30 | Phòng 4 | C6 C7 C8
(623, 9, 21, '2026-11-14T10:02:53', 60000, N'Paid', N'Transfer', NULL, 6, 120, NULL, NULL, NULL), -- suat 121 | Kẻ Hồi Sinh | 14/11 12:30 | Phòng 3 | J9 J10
(624, 8, NULL, '2026-11-14T10:13:12', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 120 | Godzilla Trừ Không | 14/11 12:15 | Phòng 5 | C10 C11 C12
(625, 7, NULL, '2026-11-14T10:18:31', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 120 | Godzilla Trừ Không | 14/11 12:15 | Phòng 5 | G3 G4
(626, 9, NULL, '2026-11-14T10:22:57', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 120 | Godzilla Trừ Không | 14/11 12:15 | Phòng 5 | K9 K10
(627, 8, NULL, '2026-11-14T10:24:24', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 124 | Chị Chị Em Em 3 | 14/11 14:00 | Phòng 1 | E7 E8
(628, 9, NULL, '2026-11-14T10:25:24', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 127 | Bí Kíp Luyện Cướp | 14/11 15:15 | Phòng 4 | C3 C4
(629, 9, NULL, '2026-11-14T10:27:00', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 120 | Godzilla Trừ Không | 14/11 12:15 | Phòng 5 | E2
(630, 7, 73, '2026-11-14T10:29:13', 360000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 122 | Godzilla Trừ Không | 14/11 12:30 | Phòng 4 | C1 C2 C3 C4
(631, 7, 72, '2026-11-14T10:31:27', 78000, N'Paid', N'Transfer', NULL, 5, 66, NULL, NULL, NULL), -- suat 120 | Godzilla Trừ Không | 14/11 12:15 | Phòng 5 | J10
(632, 9, 47, '2026-11-14T10:32:08', 216000, N'Cancelled', N'Cash', 250000, 15, 0, N'Nhầm suất / ghế', '2026-11-14T10:36:21', 9), -- suat 122 | Godzilla Trừ Không | 14/11 12:30 | Phòng 4 | E6 E7
(633, 9, 1, '2026-11-14T10:33:33', 360000, N'Paid', N'Cash', 360000, 18, 0, NULL, NULL, NULL), -- suat 120 | Godzilla Trừ Không | 14/11 12:15 | Phòng 5 | A3 A4 A5
(634, 9, NULL, '2026-11-14T10:37:10', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 126 | Dune: Hành Tinh Cát | 14/11 15:00 | Phòng 5 | L5 L6
(635, 8, NULL, '2026-11-14T10:41:55', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 119 | Ngày Con Còn Mẹ | 14/11 11:30 | Phòng 1 | G6 G7
(636, 9, NULL, '2026-11-14T10:46:37', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 119 | Ngày Con Còn Mẹ | 14/11 11:30 | Phòng 1 | B6
(637, 7, NULL, '2026-11-14T10:48:04', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 121 | Kẻ Hồi Sinh | 14/11 12:30 | Phòng 3 | F8 F9
(638, 7, NULL, '2026-11-14T10:52:45', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 160 | Trại Buôn Người | 15/11 18:00 | Phòng 2 | B6 B7
(639, 9, NULL, '2026-11-14T10:57:14', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 122 | Godzilla Trừ Không | 14/11 12:30 | Phòng 4 | G2 G3
(640, 8, 15, '2026-11-14T11:02:37', 300000, N'Paid', N'Cash', 300000, 15, 0, NULL, NULL, NULL), -- suat 132 | Trại Buôn Người | 14/11 18:00 | Phòng 2 | A5 A6 A7 A8
(641, 7, 15, '2026-11-14T11:12:53', 360000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 122 | Godzilla Trừ Không | 14/11 12:30 | Phòng 4 | A8 A9 A10 A11
(642, 9, 48, '2026-11-14T11:14:49', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 192 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 16/11 20:45 | Phòng 2 | D5
(643, 7, 9, '2026-11-14T11:21:03', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 152 | Chị Chị Em Em 3 | 15/11 14:00 | Phòng 1 | D4
(644, 8, 93, '2026-11-14T11:23:18', 180000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 123 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 14/11 13:30 | Phòng 2 | J7 J8
(645, 8, 67, '2026-11-14T11:26:16', 150000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 124 | Chị Chị Em Em 3 | 14/11 14:00 | Phòng 1 | B9 B10
(646, 9, NULL, '2026-11-14T11:29:38', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 126 | Dune: Hành Tinh Cát | 14/11 15:00 | Phòng 5 | J5 J6
(647, 7, NULL, '2026-11-14T11:30:45', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 120 | Godzilla Trừ Không | 14/11 12:15 | Phòng 5 | D9 D10
(648, 9, NULL, '2026-11-14T11:34:31', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 130 | Clayface | 14/11 17:00 | Phòng 3 | J11 J12
(649, 8, NULL, '2026-11-14T11:38:03', 120000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 120 | Godzilla Trừ Không | 14/11 12:15 | Phòng 5 | A6
(650, 8, NULL, '2026-11-14T11:38:27', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 120 | Godzilla Trừ Không | 14/11 12:15 | Phòng 5 | F6 F7
(651, 8, 54, '2026-11-14T11:38:49', 157000, N'Paid', N'Cash', 200000, 7, 23, NULL, NULL, NULL), -- suat 122 | Godzilla Trừ Không | 14/11 12:30 | Phòng 4 | B11 B12
(652, 9, NULL, '2026-11-14T11:39:59', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 120 | Godzilla Trừ Không | 14/11 12:15 | Phòng 5 | F10 F11 F12
(653, 7, NULL, '2026-11-14T11:41:32', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 134 | Ngày Con Còn Mẹ | 14/11 19:00 | Phòng 1 | E3 E4 E5
(654, 7, NULL, '2026-11-14T11:45:01', 75000, N'Paid', N'Cash', 75000, 0, 0, NULL, NULL, NULL), -- suat 123 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 14/11 13:30 | Phòng 2 | C10
(655, 8, NULL, '2026-11-14T11:49:50', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 123 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 14/11 13:30 | Phòng 2 | F9
(656, 7, 120, '2026-11-14T11:54:46', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 121 | Kẻ Hồi Sinh | 14/11 12:30 | Phòng 3 | G7
(657, 9, 118, '2026-11-14T11:58:37', 270000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 127 | Bí Kíp Luyện Cướp | 14/11 15:15 | Phòng 4 | E3 E4 E5
(658, 8, 65, '2026-11-14T11:59:27', 75000, N'Paid', N'Cash', 100000, 3, 0, NULL, NULL, NULL), -- suat 130 | Clayface | 14/11 17:00 | Phòng 3 | B7
(659, 7, NULL, '2026-11-14T12:00:16', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | F3 F4
(660, 7, NULL, '2026-11-14T12:05:11', 540000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 128 | Ngày Con Còn Mẹ | 14/11 15:30 | Phòng 2 | E6 E7 E8 E9 E10 E11
(661, 8, NULL, '2026-11-14T12:08:06', 648000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 131 | Ramayana: Khởi Nguồn Một Huyền Thoại | 14/11 17:45 | Phòng 4 | E1 E2 E3 E4 E5 E6
(662, 7, NULL, '2026-11-14T12:11:49', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 121 | Kẻ Hồi Sinh | 14/11 12:30 | Phòng 3 | H8 H9 H10
(663, 7, 108, '2026-11-14T12:25:05', 240000, N'Paid', N'Card', NULL, 16, 30, NULL, NULL, NULL), -- suat 141 | Bò Sữa Bay | 15/11 09:00 | Phòng 1 | F5 F6 F7
(664, 8, NULL, '2026-11-14T12:26:56', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 127 | Bí Kíp Luyện Cướp | 14/11 15:15 | Phòng 4 | H1 H2 H3 H4
(665, 7, NULL, '2026-11-14T12:30:20', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | K5 K6
(666, 7, NULL, '2026-11-14T12:32:04', 375000, N'Paid', N'Cash', 375000, 0, 0, NULL, NULL, NULL), -- suat 124 | Chị Chị Em Em 3 | 14/11 14:00 | Phòng 1 | C4 C5 C6 C7 C8
(667, 9, NULL, '2026-11-14T12:35:27', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 127 | Bí Kíp Luyện Cướp | 14/11 15:15 | Phòng 4 | D6 D7
(668, 7, NULL, '2026-11-14T12:42:29', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 124 | Chị Chị Em Em 3 | 14/11 14:00 | Phòng 1 | D8 D9
(669, 9, 77, '2026-11-14T12:44:54', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 134 | Ngày Con Còn Mẹ | 14/11 19:00 | Phòng 1 | E6
(670, 9, NULL, '2026-11-14T12:46:29', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 152 | Chị Chị Em Em 3 | 15/11 14:00 | Phòng 1 | H3 H4
(671, 9, NULL, '2026-11-14T12:48:36', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 127 | Bí Kíp Luyện Cướp | 14/11 15:15 | Phòng 4 | E1 E2
(672, 7, NULL, '2026-11-14T12:49:46', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 125 | Thiên Đường Tăm Tối | 14/11 14:45 | Phòng 3 | F6 F7 F8 F9
(673, 9, NULL, '2026-11-14T12:54:58', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 124 | Chị Chị Em Em 3 | 14/11 14:00 | Phòng 1 | B1 B2
(674, 8, NULL, '2026-11-14T12:59:43', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 127 | Bí Kíp Luyện Cướp | 14/11 15:15 | Phòng 4 | E9 E10 E11 E12
(675, 8, NULL, '2026-11-14T13:02:55', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 129 | Bò Sữa Bay | 14/11 16:30 | Phòng 1 | H4 H5
(676, 9, 5, '2026-11-14T13:07:50', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 135 | Ngày Con Còn Mẹ | 14/11 19:15 | Phòng 3 | C7 C8
(677, 9, NULL, '2026-11-14T13:08:37', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 137 | Godzilla Trừ Không | 14/11 21:00 | Phòng 4 | H4 H5
(678, 9, NULL, '2026-11-14T13:10:51', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 130 | Clayface | 14/11 17:00 | Phòng 3 | J7 J8
(679, 8, NULL, '2026-11-14T13:13:51', 432000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | J2 J3 J4
(680, 9, 113, '2026-11-14T13:22:17', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 134 | Ngày Con Còn Mẹ | 14/11 19:00 | Phòng 1 | G6 G7 G8
(681, 9, NULL, '2026-11-14T13:22:23', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 132 | Trại Buôn Người | 14/11 18:00 | Phòng 2 | D8
(682, 8, NULL, '2026-11-14T13:29:26', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 126 | Dune: Hành Tinh Cát | 14/11 15:00 | Phòng 5 | F5 F6
(683, 8, NULL, '2026-11-14T13:33:32', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 129 | Bò Sữa Bay | 14/11 16:30 | Phòng 1 | G6
(684, 9, NULL, '2026-11-14T13:36:46', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 129 | Bò Sữa Bay | 14/11 16:30 | Phòng 1 | H7
(685, 8, NULL, '2026-11-14T13:43:13', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 147 | Ngày Con Còn Mẹ | 15/11 11:30 | Phòng 1 | H3 H4 H5
(686, 8, 90, '2026-11-14T13:46:05', 270000, N'Paid', N'Cash', 500000, 18, 0, NULL, NULL, NULL), -- suat 134 | Ngày Con Còn Mẹ | 14/11 19:00 | Phòng 1 | E10 E11 E12
(687, 9, NULL, '2026-11-14T13:47:52', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | E5 E6
(688, 9, NULL, '2026-11-14T13:50:57', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | J7 J8
(689, 9, NULL, '2026-11-14T13:51:27', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 177 | Kẻ Hồi Sinh | 16/11 12:30 | Phòng 3 | D4 D5
(690, 8, NULL, '2026-11-14T13:54:25', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 134 | Ngày Con Còn Mẹ | 14/11 19:00 | Phòng 1 | C4 C5
(691, 9, NULL, '2026-11-14T13:54:57', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | C3 C4 C5
(692, 9, NULL, '2026-11-14T13:59:41', 240000, N'Paid', N'Cash', 240000, 0, 0, NULL, NULL, NULL), -- suat 176 | Godzilla Trừ Không | 16/11 12:15 | Phòng 5 | A5 A6
(693, 9, 26, '2026-11-14T14:05:04', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 126 | Dune: Hành Tinh Cát | 14/11 15:00 | Phòng 5 | E2 E3
(694, 8, NULL, '2026-11-14T14:05:31', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 132 | Trại Buôn Người | 14/11 18:00 | Phòng 2 | H8 H9 H10
(695, 8, NULL, '2026-11-14T14:05:32', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 132 | Trại Buôn Người | 14/11 18:00 | Phòng 2 | D10 D11
(696, 9, NULL, '2026-11-14T14:08:37', 240000, N'Paid', N'Cash', 240000, 0, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | C7 C8
(697, 8, NULL, '2026-11-14T14:11:53', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | L5 L6
(698, 9, NULL, '2026-11-14T14:13:10', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | A7 A8 A9
(699, 9, NULL, '2026-11-14T14:13:31', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | L7 L8
(700, 8, NULL, '2026-11-14T14:19:03', 225000, N'Paid', N'Cash', 225000, 0, 0, NULL, NULL, NULL), -- suat 132 | Trại Buôn Người | 14/11 18:00 | Phòng 2 | C7 C8 C9
(701, 7, NULL, '2026-11-14T14:20:14', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 135 | Ngày Con Còn Mẹ | 14/11 19:15 | Phòng 3 | E8
(702, 7, NULL, '2026-11-14T14:31:51', 75000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 130 | Clayface | 14/11 17:00 | Phòng 3 | B3
(703, 9, 109, '2026-11-14T14:38:02', 75000, N'Paid', N'Transfer', NULL, 3, 0, NULL, NULL, NULL), -- suat 167 | Chị Chị Em Em 3 | 15/11 21:30 | Phòng 1 | B11
(704, 7, NULL, '2026-11-14T14:41:13', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 132 | Trại Buôn Người | 14/11 18:00 | Phòng 2 | G6 G7 G8
(705, 8, NULL, '2026-11-14T14:44:39', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 127 | Bí Kíp Luyện Cướp | 14/11 15:15 | Phòng 4 | G1 G2 G3
(706, 8, 79, '2026-11-14T14:46:40', 270000, N'Cancelled', N'Cash', 270000, 18, 0, N'Lỗi thanh toán', '2026-11-14T14:51:06', 8), -- suat 132 | Trại Buôn Người | 14/11 18:00 | Phòng 2 | H5 H6 H7
(707, 8, NULL, '2026-11-14T14:48:15', 864000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 138 | Dune: Hành Tinh Cát | 14/11 21:00 | Phòng 5 | F1 F2 F3 F4 F5 F6
(708, 9, NULL, '2026-11-14T14:49:43', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 127 | Bí Kíp Luyện Cướp | 14/11 15:15 | Phòng 4 | B2 B3 B4
(709, 9, 30, '2026-11-14T14:49:51', 432000, N'Paid', N'Cash', 440000, 30, 0, NULL, NULL, NULL), -- suat 138 | Dune: Hành Tinh Cát | 14/11 21:00 | Phòng 5 | G7 G8 G9
(710, 7, NULL, '2026-11-14T14:52:55', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 129 | Bò Sữa Bay | 14/11 16:30 | Phòng 1 | J5 J6
(711, 7, NULL, '2026-11-14T14:53:30', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 129 | Bò Sữa Bay | 14/11 16:30 | Phòng 1 | E8 E9
(712, 8, NULL, '2026-11-14T14:56:23', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 130 | Clayface | 14/11 17:00 | Phòng 3 | F8
(713, 10, 88, '2026-11-14T15:00:38', 375000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 129 | Bò Sữa Bay | 14/11 16:30 | Phòng 1 | A4 A5 A6 A7 A8
(714, 4, 43, '2026-11-14T15:01:33', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 131 | Ramayana: Khởi Nguồn Một Huyền Thoại | 14/11 17:45 | Phòng 4 | F3 F4
(715, 4, NULL, '2026-11-14T15:08:36', 144000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | E10
(716, 3, NULL, '2026-11-14T15:09:16', 720000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | D1 D2 D3 D4 D5 D6
(717, 10, NULL, '2026-11-14T15:15:23', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 164 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 15/11 20:45 | Phòng 2 | E3
(718, 3, NULL, '2026-11-14T15:15:38', 120000, N'Paid', N'Cash', 120000, 0, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | D9
(719, 3, 107, '2026-11-14T15:29:17', 288000, N'Paid', N'Cash', 288000, 20, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | F6 F7
(720, 3, NULL, '2026-11-14T15:30:36', 324000, N'Cancelled', N'Card', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-14T15:38:41', 3), -- suat 137 | Godzilla Trừ Không | 14/11 21:00 | Phòng 4 | E7 E8 E9
(721, 10, NULL, '2026-11-14T15:33:21', 450000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 131 | Ramayana: Khởi Nguồn Một Huyền Thoại | 14/11 17:45 | Phòng 4 | B5 B6 B7 B8 B9
(722, 10, 55, '2026-11-14T15:49:39', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 163 | Ngày Con Còn Mẹ | 15/11 19:15 | Phòng 3 | F6 F7
(723, 10, NULL, '2026-11-14T15:52:27', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 131 | Ramayana: Khởi Nguồn Một Huyền Thoại | 14/11 17:45 | Phòng 4 | D5 D6 D7
(724, 3, NULL, '2026-11-14T15:52:37', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 130 | Clayface | 14/11 17:00 | Phòng 3 | D3 D4 D5
(725, 3, NULL, '2026-11-14T16:02:34', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 135 | Ngày Con Còn Mẹ | 14/11 19:15 | Phòng 3 | H8 H9
(726, 3, NULL, '2026-11-14T16:11:26', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 135 | Ngày Con Còn Mẹ | 14/11 19:15 | Phòng 3 | H2 H3 H4
(727, 4, 25, '2026-11-14T16:11:58', 144000, N'Paid', N'Card', NULL, 10, 0, NULL, NULL, NULL), -- suat 138 | Dune: Hành Tinh Cát | 14/11 21:00 | Phòng 5 | G4
(728, 3, NULL, '2026-11-14T16:15:34', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | K1 K2
(729, 10, NULL, '2026-11-14T16:21:48', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 135 | Ngày Con Còn Mẹ | 14/11 19:15 | Phòng 3 | A9 A10
(730, 3, 53, '2026-11-14T16:28:49', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 139 | Chị Chị Em Em 3 | 14/11 21:30 | Phòng 1 | E6 E7 E8
(731, 4, 21, '2026-11-14T16:33:30', 216000, N'Paid', N'Cash', 250000, 21, 0, NULL, NULL, NULL), -- suat 165 | Godzilla Trừ Không | 15/11 21:00 | Phòng 4 | J1 J2
(732, 4, NULL, '2026-11-14T16:38:50', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 138 | Dune: Hành Tinh Cát | 14/11 21:00 | Phòng 5 | J9 J10 J11
(733, 3, NULL, '2026-11-14T16:40:41', 240000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | A4 A5
(734, 4, 93, '2026-11-14T16:41:00', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 131 | Ramayana: Khởi Nguồn Một Huyền Thoại | 14/11 17:45 | Phòng 4 | F9 F10
(735, 10, 66, '2026-11-14T16:53:06', 450000, N'Paid', N'Cash', 450000, 31, 0, NULL, NULL, NULL), -- suat 136 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 14/11 20:45 | Phòng 2 | D5 D6 D7 D8 D9
(736, 4, 44, '2026-11-14T17:02:37', 360000, N'Paid', N'Cash', 400000, 18, 120, NULL, NULL, NULL), -- suat 138 | Dune: Hành Tinh Cát | 14/11 21:00 | Phòng 5 | B7 B8 B9 B10
(737, 3, NULL, '2026-11-14T17:10:11', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | G9 G10 G11
(738, 4, NULL, '2026-11-14T17:15:05', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 140 | Bí Kíp Luyện Cướp | 14/11 21:30 | Phòng 3 | F6
(739, 4, NULL, '2026-11-14T17:17:52', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 133 | Godzilla Trừ Không | 14/11 18:15 | Phòng 5 | H12
(740, 3, NULL, '2026-11-14T17:18:29', 225000, N'Paid', N'Cash', 225000, 0, 0, NULL, NULL, NULL), -- suat 140 | Bí Kíp Luyện Cướp | 14/11 21:30 | Phòng 3 | A3 A4 A5
(741, 3, NULL, '2026-11-14T17:26:35', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 135 | Ngày Con Còn Mẹ | 14/11 19:15 | Phòng 3 | D4 D5 D6 D7
(742, 3, NULL, '2026-11-14T17:32:10', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 138 | Dune: Hành Tinh Cát | 14/11 21:00 | Phòng 5 | G5
(743, 4, 44, '2026-11-14T17:32:41', 144000, N'Paid', N'Cash', 144000, 10, 0, NULL, NULL, NULL), -- suat 166 | Dune: Hành Tinh Cát | 15/11 21:00 | Phòng 5 | F6
(744, 4, NULL, '2026-11-14T17:34:09', 240000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | A6 A7
(745, 4, 72, '2026-11-14T17:55:21', 75000, N'Paid', N'Cash', 100000, 3, 0, NULL, NULL, NULL), -- suat 136 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 14/11 20:45 | Phòng 2 | A5
(746, 4, 69, '2026-11-14T17:59:31', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 135 | Ngày Con Còn Mẹ | 14/11 19:15 | Phòng 3 | G11 G12
(747, 10, NULL, '2026-11-14T18:05:50', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 137 | Godzilla Trừ Không | 14/11 21:00 | Phòng 4 | G4 G5
(748, 3, 49, '2026-11-14T18:19:28', 144000, N'Paid', N'Cash', 144000, 10, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | E2
(749, 10, 70, '2026-11-14T18:22:08', 270000, N'Cancelled', N'Card', NULL, 18, 0, N'Khách đổi ý', '2026-11-14T18:58:21', 10), -- suat 140 | Bí Kíp Luyện Cướp | 14/11 21:30 | Phòng 3 | G6 G7 G8
(750, 10, 47, '2026-11-14T18:27:05', 300000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 139 | Chị Chị Em Em 3 | 14/11 21:30 | Phòng 1 | C8 C9 C10 C11
(751, 3, 27, '2026-11-14T18:28:17', 108000, N'Paid', N'Cash', 110000, 7, 0, NULL, NULL, NULL), -- suat 159 | Ramayana: Khởi Nguồn Một Huyền Thoại | 15/11 17:45 | Phòng 4 | H7
(752, 3, 86, '2026-11-14T18:32:53', 288000, N'Paid', N'Cash', 300000, 28, 0, NULL, NULL, NULL), -- suat 138 | Dune: Hành Tinh Cát | 14/11 21:00 | Phòng 5 | L5 L6
(753, 3, 1, '2026-11-14T18:36:41', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 196 | Bí Kíp Luyện Cướp | 16/11 21:30 | Phòng 3 | E5 E6
(754, 4, 42, '2026-11-14T18:37:31', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 191 | Ngày Con Còn Mẹ | 16/11 19:15 | Phòng 3 | F6 F7
(755, 4, NULL, '2026-11-14T18:38:46', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 138 | Dune: Hành Tinh Cát | 14/11 21:00 | Phòng 5 | F8 F9
(756, 10, NULL, '2026-11-14T18:44:37', 180000, N'Cancelled', N'Cash', 180000, 0, 0, N'Khách đổi ý', '2026-11-14T18:55:50', 10), -- suat 140 | Bí Kíp Luyện Cướp | 14/11 21:30 | Phòng 3 | F3 F4
(757, 4, NULL, '2026-11-14T18:55:23', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 140 | Bí Kíp Luyện Cướp | 14/11 21:30 | Phòng 3 | J9 J10
(758, 10, 78, '2026-11-14T18:59:01', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 163 | Ngày Con Còn Mẹ | 15/11 19:15 | Phòng 3 | D9 D10
(759, 3, 54, '2026-11-14T19:03:34', 300000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 140 | Bí Kíp Luyện Cướp | 14/11 21:30 | Phòng 3 | B3 B4 B5 B6
(760, 3, 75, '2026-11-14T19:05:51', 304000, N'Paid', N'Transfer', NULL, 21, 20, NULL, NULL, NULL), -- suat 137 | Godzilla Trừ Không | 14/11 21:00 | Phòng 4 | E1 E2 E3
(761, 10, 109, '2026-11-14T19:13:18', 144000, N'Paid', N'Cash', 200000, 10, 0, NULL, NULL, NULL), -- suat 138 | Dune: Hành Tinh Cát | 14/11 21:00 | Phòng 5 | H11
(762, 3, NULL, '2026-11-14T19:15:54', 576000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 138 | Dune: Hành Tinh Cát | 14/11 21:00 | Phòng 5 | J4 J5 J6 J7
(763, 3, NULL, '2026-11-14T19:30:20', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 138 | Dune: Hành Tinh Cát | 14/11 21:00 | Phòng 5 | K5
(764, 3, NULL, '2026-11-14T19:30:23', 108000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 143 | Ramayana: Khởi Nguồn Một Huyền Thoại | 15/11 09:15 | Phòng 4 | F9
(765, 4, NULL, '2026-11-14T19:36:42', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 136 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 14/11 20:45 | Phòng 2 | C4 C5
(766, 3, NULL, '2026-11-14T19:37:37', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 152 | Chị Chị Em Em 3 | 15/11 14:00 | Phòng 1 | C4 C5
(767, 3, NULL, '2026-11-14T19:37:47', 360000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-14T20:06:48', 3), -- suat 136 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 14/11 20:45 | Phòng 2 | E6 E7 E8 E9
(768, 3, NULL, '2026-11-14T19:41:12', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 149 | Kẻ Hồi Sinh | 15/11 12:30 | Phòng 3 | F10
(769, 4, NULL, '2026-11-14T19:51:25', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | F5 F6 F7 F8
(770, 10, NULL, '2026-11-14T19:59:53', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 153 | Thiên Đường Tăm Tối | 15/11 14:45 | Phòng 3 | A5 A6
(771, 4, NULL, '2026-11-14T20:01:44', 480000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 138 | Dune: Hành Tinh Cát | 14/11 21:00 | Phòng 5 | C7 C8 C9 C10
(772, 3, NULL, '2026-11-14T20:30:15', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 140 | Bí Kíp Luyện Cướp | 14/11 21:30 | Phòng 3 | J5 J6
(773, 4, NULL, '2026-11-14T20:32:31', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 142 | Dune: Hành Tinh Cát | 15/11 09:00 | Phòng 5 | L1 L2
(774, 4, NULL, '2026-11-14T20:38:45', 300000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 149 | Kẻ Hồi Sinh | 15/11 12:30 | Phòng 3 | C6 C7 C8 C9
(775, 10, NULL, '2026-11-14T20:38:48', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 138 | Dune: Hành Tinh Cát | 14/11 21:00 | Phòng 5 | H9 H10
(776, 10, 93, '2026-11-14T20:44:23', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 140 | Bí Kíp Luyện Cướp | 14/11 21:30 | Phòng 3 | D5
(777, 3, NULL, '2026-11-14T20:47:07', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 139 | Chị Chị Em Em 3 | 14/11 21:30 | Phòng 1 | J3 J4
(778, 3, NULL, '2026-11-14T20:52:57', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 188 | Trại Buôn Người | 16/11 18:00 | Phòng 2 | C7 C8
(779, 3, 67, '2026-11-14T20:59:00', 432000, N'Paid', N'Card', NULL, 30, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | J8 J9 J10
(780, 10, NULL, '2026-11-14T21:19:29', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 146 | Chàng Mèo Mang Mũ | 15/11 11:15 | Phòng 2 | F6
(781, 4, NULL, '2026-11-14T21:28:57', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 155 | Bí Kíp Luyện Cướp | 15/11 15:15 | Phòng 4 | G6 G7
(782, 3, 27, '2026-11-14T21:38:03', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL); -- suat 168 | Bí Kíp Luyện Cướp | 15/11 21:30 | Phòng 3 | G12
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(1362, 581, 152, 1, 81, 90000, N'Active'),
(1363, 581, 152, 1, 82, 90000, N'Active'),
(1364, 581, 152, 1, 83, 90000, N'Active'),
(1365, 582, 151, 2, 145, 90000, N'Active'),
(1366, 583, 117, 3, 254, 90000, N'Active'),
(1367, 583, 117, 3, 255, 90000, N'Active'),
(1368, 583, 117, 3, 256, 90000, N'Active'),
(1369, 583, 117, 3, 257, 90000, N'Active'),
(1370, 584, 113, 1, 53, 90000, N'Active'),
(1371, 584, 113, 1, 54, 90000, N'Active'),
(1372, 585, 114, 5, 470, 120000, N'Active'),
(1373, 586, 113, 1, 55, 90000, N'Active'),
(1374, 586, 113, 1, 56, 90000, N'Active'),
(1375, 586, 113, 1, 57, 90000, N'Active'),
(1376, 586, 113, 1, 58, 90000, N'Active'),
(1377, 586, 113, 1, 59, 90000, N'Active'),
(1378, 587, 153, 3, 282, 90000, N'Active'),
(1379, 587, 153, 3, 283, 90000, N'Active'),
(1380, 587, 153, 3, 284, 90000, N'Active'),
(1381, 588, 113, 1, 61, 90000, N'Active'),
(1382, 588, 113, 1, 62, 90000, N'Active'),
(1383, 588, 113, 1, 63, 90000, N'Active'),
(1384, 588, 113, 1, 64, 90000, N'Active'),
(1385, 589, 113, 1, 17, 75000, N'Active'),
(1386, 590, 117, 3, 260, 90000, N'Active'),
(1387, 590, 117, 3, 261, 90000, N'Active'),
(1388, 590, 117, 3, 262, 90000, N'Active'),
(1389, 591, 113, 1, 27, 75000, N'Active'),
(1390, 591, 113, 1, 28, 75000, N'Active'),
(1391, 592, 115, 4, 392, 108000, N'Active'),
(1392, 592, 115, 4, 393, 108000, N'Active'),
(1393, 593, 159, 4, 354, 90000, N'Active'),
(1394, 593, 159, 4, 355, 90000, N'Active'),
(1395, 594, 150, 4, 425, 108000, N'Active'),
(1396, 594, 150, 4, 426, 108000, N'Active'),
(1397, 595, 114, 5, 475, 120000, N'Active'),
(1398, 595, 114, 5, 476, 120000, N'Active'),
(1399, 596, 115, 4, 371, 108000, N'Active'),
(1400, 596, 115, 4, 372, 108000, N'Active'),
(1401, 597, 116, 2, 173, 90000, N'Active'),
(1402, 597, 116, 2, 174, 90000, N'Active'),
(1403, 597, 116, 2, 175, 90000, N'Active'),
(1404, 597, 116, 2, 176, 90000, N'Active'),
(1405, 598, 113, 1, 32, 75000, N'Active'),
(1406, 598, 113, 1, 33, 75000, N'Active'),
(1407, 599, 114, 5, 555, 144000, N'Active'),
(1408, 599, 114, 5, 556, 144000, N'Active'),
(1409, 600, 118, 2, 187, 90000, N'Active'),
(1410, 601, 114, 5, 534, 144000, N'Active'),
(1411, 601, 114, 5, 535, 144000, N'Active'),
(1412, 601, 114, 5, 536, 144000, N'Active'),
(1413, 601, 114, 5, 537, 144000, N'Active'),
(1414, 601, 114, 5, 538, 144000, N'Active'),
(1415, 601, 114, 5, 539, 144000, N'Active'),
(1416, 602, 124, 1, 88, 90000, N'Active'),
(1417, 602, 124, 1, 89, 90000, N'Active'),
(1418, 603, 115, 4, 353, 90000, N'Active'),
(1419, 603, 115, 4, 354, 90000, N'Active'),
(1420, 603, 115, 4, 355, 90000, N'Active'),
(1421, 604, 114, 5, 542, 144000, N'Active'),
(1422, 604, 114, 5, 543, 144000, N'Active'),
(1423, 604, 114, 5, 544, 144000, N'Active'),
(1424, 604, 114, 5, 545, 144000, N'Active'),
(1425, 605, 150, 4, 423, 108000, N'Active'),
(1426, 605, 150, 4, 424, 108000, N'Active'),
(1427, 606, 116, 2, 124, 75000, N'Active'),
(1428, 606, 116, 2, 125, 75000, N'Active'),
(1429, 606, 116, 2, 126, 75000, N'Active'),
(1430, 607, 121, 3, 298, 90000, N'Active'),
(1431, 608, 116, 2, 196, 90000, N'Active'),
(1432, 608, 116, 2, 197, 90000, N'Active'),
(1433, 608, 116, 2, 198, 90000, N'Active'),
(1434, 608, 116, 2, 199, 90000, N'Active'),
(1435, 609, 120, 5, 523, 144000, N'Active'),
(1436, 609, 120, 5, 524, 144000, N'Active'),
(1437, 609, 120, 5, 525, 144000, N'Active'),
(1438, 610, 118, 2, 116, 75000, N'Active'),
(1439, 610, 118, 2, 117, 75000, N'Active'),
(1440, 611, 117, 3, 284, 90000, N'Active'),
(1441, 611, 117, 3, 285, 90000, N'Active'),
(1442, 612, 177, 3, 294, 90000, N'Active'),
(1443, 612, 177, 3, 295, 90000, N'Active'),
(1444, 612, 177, 3, 296, 90000, N'Active'),
(1445, 613, 123, 2, 151, 90000, N'Active'),
(1446, 613, 123, 2, 152, 90000, N'Active'),
(1447, 614, 153, 3, 319, 90000, N'Active'),
(1448, 614, 153, 3, 320, 90000, N'Active'),
(1449, 615, 156, 2, 183, 90000, N'Active'),
(1450, 615, 156, 2, 184, 90000, N'Active'),
(1451, 615, 156, 2, 185, 90000, N'Active'),
(1452, 615, 156, 2, 186, 90000, N'Active'),
(1453, 615, 156, 2, 187, 90000, N'Active'),
(1454, 615, 156, 2, 188, 90000, N'Active'),
(1455, 616, 173, 3, 293, 90000, N'Active'),
(1456, 616, 173, 3, 294, 90000, N'Active'),
(1457, 617, 163, 3, 292, 90000, N'Active'),
(1458, 617, 163, 3, 293, 90000, N'Active'),
(1459, 617, 163, 3, 294, 90000, N'Active'),
(1460, 617, 163, 3, 295, 90000, N'Active'),
(1461, 618, 119, 1, 38, 90000, N'Active'),
(1462, 618, 119, 1, 39, 90000, N'Active'),
(1463, 619, 123, 2, 171, 90000, N'Active'),
(1464, 619, 123, 2, 172, 90000, N'Active'),
(1465, 619, 123, 2, 173, 90000, N'Active'),
(1466, 619, 123, 2, 174, 90000, N'Active'),
(1467, 619, 123, 2, 175, 90000, N'Active'),
(1468, 619, 123, 2, 176, 90000, N'Active'),
(1469, 620, 152, 1, 66, 90000, N'Active'),
(1470, 620, 152, 1, 67, 90000, N'Active'),
(1471, 620, 152, 1, 68, 90000, N'Active'),
(1472, 620, 152, 1, 69, 90000, N'Active'),
(1473, 621, 129, 1, 103, 90000, N'Active'),
(1474, 621, 129, 1, 104, 90000, N'Active'),
(1475, 622, 122, 4, 354, 90000, N'Active'),
(1476, 622, 122, 4, 355, 90000, N'Active'),
(1477, 622, 122, 4, 356, 90000, N'Active'),
(1478, 623, 121, 3, 321, 90000, N'Active'),
(1479, 623, 121, 3, 322, 90000, N'Active'),
(1480, 624, 120, 5, 466, 120000, N'Active'),
(1481, 624, 120, 5, 467, 120000, N'Active'),
(1482, 624, 120, 5, 468, 120000, N'Active'),
(1483, 625, 120, 5, 507, 144000, N'Active'),
(1484, 625, 120, 5, 508, 144000, N'Active'),
(1485, 626, 120, 5, 549, 144000, N'Active'),
(1486, 626, 120, 5, 550, 144000, N'Active'),
(1487, 627, 124, 1, 55, 90000, N'Active'),
(1488, 627, 124, 1, 56, 90000, N'Active'),
(1489, 628, 127, 4, 351, 75000, N'Active'),
(1490, 628, 127, 4, 352, 75000, N'Active'),
(1491, 629, 120, 5, 482, 144000, N'Active'),
(1492, 630, 122, 4, 349, 90000, N'Active'),
(1493, 630, 122, 4, 350, 90000, N'Active'),
(1494, 630, 122, 4, 351, 90000, N'Active'),
(1495, 630, 122, 4, 352, 90000, N'Active'),
(1496, 631, 120, 5, 538, 144000, N'Active'),
(1497, 632, 122, 4, 378, 108000, N'Cancelled'),
(1498, 632, 122, 4, 379, 108000, N'Cancelled'),
(1499, 633, 120, 5, 435, 120000, N'Active'),
(1500, 633, 120, 5, 436, 120000, N'Active'),
(1501, 633, 120, 5, 437, 120000, N'Active'),
(1502, 634, 126, 5, 557, 144000, N'Active'),
(1503, 634, 126, 5, 558, 144000, N'Active'),
(1504, 635, 119, 1, 78, 90000, N'Active'),
(1505, 635, 119, 1, 79, 90000, N'Active'),
(1506, 636, 119, 1, 18, 75000, N'Active'),
(1507, 637, 121, 3, 284, 90000, N'Active'),
(1508, 637, 121, 3, 285, 90000, N'Active'),
(1509, 638, 160, 2, 126, 75000, N'Active'),
(1510, 638, 160, 2, 127, 75000, N'Active'),
(1511, 639, 122, 4, 398, 108000, N'Active'),
(1512, 639, 122, 4, 399, 108000, N'Active'),
(1513, 640, 132, 2, 113, 75000, N'Active'),
(1514, 640, 132, 2, 114, 75000, N'Active'),
(1515, 640, 132, 2, 115, 75000, N'Active'),
(1516, 640, 132, 2, 116, 75000, N'Active'),
(1517, 641, 122, 4, 332, 90000, N'Active'),
(1518, 641, 122, 4, 333, 90000, N'Active'),
(1519, 641, 122, 4, 334, 90000, N'Active'),
(1520, 641, 122, 4, 335, 90000, N'Active'),
(1521, 642, 192, 2, 149, 90000, N'Active'),
(1522, 643, 152, 1, 40, 90000, N'Active'),
(1523, 644, 123, 2, 211, 90000, N'Active'),
(1524, 644, 123, 2, 212, 90000, N'Active'),
(1525, 645, 124, 1, 21, 75000, N'Active'),
(1526, 645, 124, 1, 22, 75000, N'Active'),
(1527, 646, 126, 5, 533, 144000, N'Active'),
(1528, 646, 126, 5, 534, 144000, N'Active'),
(1529, 647, 120, 5, 477, 120000, N'Active'),
(1530, 647, 120, 5, 478, 120000, N'Active'),
(1531, 648, 130, 3, 323, 90000, N'Active'),
(1532, 648, 130, 3, 324, 90000, N'Active'),
(1533, 649, 120, 5, 438, 120000, N'Active'),
(1534, 650, 120, 5, 498, 144000, N'Active'),
(1535, 650, 120, 5, 499, 144000, N'Active'),
(1536, 651, 122, 4, 347, 90000, N'Active'),
(1537, 651, 122, 4, 348, 90000, N'Active'),
(1538, 652, 120, 5, 502, 144000, N'Active'),
(1539, 652, 120, 5, 503, 144000, N'Active'),
(1540, 652, 120, 5, 504, 144000, N'Active'),
(1541, 653, 134, 1, 51, 90000, N'Active'),
(1542, 653, 134, 1, 52, 90000, N'Active'),
(1543, 653, 134, 1, 53, 90000, N'Active'),
(1544, 654, 123, 2, 142, 75000, N'Active'),
(1545, 655, 123, 2, 177, 90000, N'Active'),
(1546, 656, 121, 3, 295, 90000, N'Active'),
(1547, 657, 127, 4, 375, 90000, N'Active'),
(1548, 657, 127, 4, 376, 90000, N'Active'),
(1549, 657, 127, 4, 377, 90000, N'Active'),
(1550, 658, 130, 3, 235, 75000, N'Active'),
(1551, 659, 162, 1, 63, 90000, N'Active'),
(1552, 659, 162, 1, 64, 90000, N'Active'),
(1553, 660, 128, 2, 162, 90000, N'Active'),
(1554, 660, 128, 2, 163, 90000, N'Active'),
(1555, 660, 128, 2, 164, 90000, N'Active'),
(1556, 660, 128, 2, 165, 90000, N'Active'),
(1557, 660, 128, 2, 166, 90000, N'Active'),
(1558, 660, 128, 2, 167, 90000, N'Active'),
(1559, 661, 131, 4, 373, 108000, N'Active'),
(1560, 661, 131, 4, 374, 108000, N'Active'),
(1561, 661, 131, 4, 375, 108000, N'Active'),
(1562, 661, 131, 4, 376, 108000, N'Active'),
(1563, 661, 131, 4, 377, 108000, N'Active'),
(1564, 661, 131, 4, 378, 108000, N'Active'),
(1565, 662, 121, 3, 308, 90000, N'Active'),
(1566, 662, 121, 3, 309, 90000, N'Active'),
(1567, 662, 121, 3, 310, 90000, N'Active'),
(1568, 663, 141, 1, 65, 90000, N'Active'),
(1569, 663, 141, 1, 66, 90000, N'Active'),
(1570, 663, 141, 1, 67, 90000, N'Active'),
(1571, 664, 127, 4, 409, 90000, N'Active'),
(1572, 664, 127, 4, 410, 90000, N'Active'),
(1573, 664, 127, 4, 411, 90000, N'Active'),
(1574, 664, 127, 4, 412, 90000, N'Active'),
(1575, 665, 133, 5, 545, 144000, N'Active'),
(1576, 665, 133, 5, 546, 144000, N'Active'),
(1577, 666, 124, 1, 28, 75000, N'Active'),
(1578, 666, 124, 1, 29, 75000, N'Active'),
(1579, 666, 124, 1, 30, 75000, N'Active'),
(1580, 666, 124, 1, 31, 75000, N'Active'),
(1581, 666, 124, 1, 32, 75000, N'Active'),
(1582, 667, 127, 4, 366, 90000, N'Active'),
(1583, 667, 127, 4, 367, 90000, N'Active'),
(1584, 668, 124, 1, 44, 90000, N'Active'),
(1585, 668, 124, 1, 45, 90000, N'Active'),
(1586, 669, 134, 1, 54, 90000, N'Active'),
(1587, 670, 152, 1, 87, 90000, N'Active'),
(1588, 670, 152, 1, 88, 90000, N'Active'),
(1589, 671, 127, 4, 373, 90000, N'Active'),
(1590, 671, 127, 4, 374, 90000, N'Active'),
(1591, 672, 125, 3, 282, 90000, N'Active'),
(1592, 672, 125, 3, 283, 90000, N'Active'),
(1593, 672, 125, 3, 284, 90000, N'Active'),
(1594, 672, 125, 3, 285, 90000, N'Active'),
(1595, 673, 124, 1, 13, 75000, N'Active'),
(1596, 673, 124, 1, 14, 75000, N'Active'),
(1597, 674, 127, 4, 381, 90000, N'Active'),
(1598, 674, 127, 4, 382, 90000, N'Active'),
(1599, 674, 127, 4, 383, 90000, N'Active'),
(1600, 674, 127, 4, 384, 90000, N'Active'),
(1601, 675, 129, 1, 88, 90000, N'Active'),
(1602, 675, 129, 1, 89, 90000, N'Active'),
(1603, 676, 135, 3, 247, 75000, N'Active'),
(1604, 676, 135, 3, 248, 75000, N'Active'),
(1605, 677, 137, 4, 412, 108000, N'Active'),
(1606, 677, 137, 4, 413, 108000, N'Active'),
(1607, 678, 130, 3, 319, 90000, N'Active'),
(1608, 678, 130, 3, 320, 90000, N'Active'),
(1609, 679, 133, 5, 530, 144000, N'Active'),
(1610, 679, 133, 5, 531, 144000, N'Active'),
(1611, 679, 133, 5, 532, 144000, N'Active'),
(1612, 680, 134, 1, 78, 90000, N'Active'),
(1613, 680, 134, 1, 79, 90000, N'Active'),
(1614, 680, 134, 1, 80, 90000, N'Active'),
(1615, 681, 132, 2, 152, 90000, N'Active'),
(1616, 682, 126, 5, 497, 144000, N'Active'),
(1617, 682, 126, 5, 498, 144000, N'Active'),
(1618, 683, 129, 1, 78, 90000, N'Active'),
(1619, 684, 129, 1, 91, 90000, N'Active'),
(1620, 685, 147, 1, 87, 90000, N'Active'),
(1621, 685, 147, 1, 88, 90000, N'Active'),
(1622, 685, 147, 1, 89, 90000, N'Active'),
(1623, 686, 134, 1, 58, 90000, N'Active'),
(1624, 686, 134, 1, 59, 90000, N'Active'),
(1625, 686, 134, 1, 60, 90000, N'Active'),
(1626, 687, 133, 5, 485, 144000, N'Active'),
(1627, 687, 133, 5, 486, 144000, N'Active'),
(1628, 688, 133, 5, 535, 144000, N'Active'),
(1629, 688, 133, 5, 536, 144000, N'Active'),
(1630, 689, 177, 3, 256, 90000, N'Active'),
(1631, 689, 177, 3, 257, 90000, N'Active'),
(1632, 690, 134, 1, 28, 75000, N'Active'),
(1633, 690, 134, 1, 29, 75000, N'Active'),
(1634, 691, 161, 5, 459, 120000, N'Active'),
(1635, 691, 161, 5, 460, 120000, N'Active'),
(1636, 691, 161, 5, 461, 120000, N'Active'),
(1637, 692, 176, 5, 437, 120000, N'Active'),
(1638, 692, 176, 5, 438, 120000, N'Active'),
(1639, 693, 126, 5, 482, 144000, N'Active'),
(1640, 693, 126, 5, 483, 144000, N'Active'),
(1641, 694, 132, 2, 200, 90000, N'Active'),
(1642, 694, 132, 2, 201, 90000, N'Active'),
(1643, 694, 132, 2, 202, 90000, N'Active'),
(1644, 695, 132, 2, 154, 90000, N'Active'),
(1645, 695, 132, 2, 155, 90000, N'Active'),
(1646, 696, 133, 5, 463, 120000, N'Active'),
(1647, 696, 133, 5, 464, 120000, N'Active'),
(1648, 697, 161, 5, 557, 144000, N'Active'),
(1649, 697, 161, 5, 558, 144000, N'Active'),
(1650, 698, 133, 5, 439, 120000, N'Active'),
(1651, 698, 133, 5, 440, 120000, N'Active'),
(1652, 698, 133, 5, 441, 120000, N'Active'),
(1653, 699, 133, 5, 559, 144000, N'Active'),
(1654, 699, 133, 5, 560, 144000, N'Active'),
(1655, 700, 132, 2, 139, 75000, N'Active'),
(1656, 700, 132, 2, 140, 75000, N'Active'),
(1657, 700, 132, 2, 141, 75000, N'Active'),
(1658, 701, 135, 3, 272, 90000, N'Active'),
(1659, 702, 130, 3, 231, 75000, N'Active'),
(1660, 703, 167, 1, 23, 75000, N'Active'),
(1661, 704, 132, 2, 186, 90000, N'Active'),
(1662, 704, 132, 2, 187, 90000, N'Active'),
(1663, 704, 132, 2, 188, 90000, N'Active'),
(1664, 705, 127, 4, 397, 90000, N'Active'),
(1665, 705, 127, 4, 398, 90000, N'Active'),
(1666, 705, 127, 4, 399, 90000, N'Active'),
(1667, 706, 132, 2, 197, 90000, N'Cancelled'),
(1668, 706, 132, 2, 198, 90000, N'Cancelled'),
(1669, 706, 132, 2, 199, 90000, N'Cancelled'),
(1670, 707, 138, 5, 493, 144000, N'Active'),
(1671, 707, 138, 5, 494, 144000, N'Active'),
(1672, 707, 138, 5, 495, 144000, N'Active'),
(1673, 707, 138, 5, 496, 144000, N'Active'),
(1674, 707, 138, 5, 497, 144000, N'Active'),
(1675, 707, 138, 5, 498, 144000, N'Active'),
(1676, 708, 127, 4, 338, 75000, N'Active'),
(1677, 708, 127, 4, 339, 75000, N'Active'),
(1678, 708, 127, 4, 340, 75000, N'Active'),
(1679, 709, 138, 5, 511, 144000, N'Active'),
(1680, 709, 138, 5, 512, 144000, N'Active'),
(1681, 709, 138, 5, 513, 144000, N'Active'),
(1682, 710, 129, 1, 101, 90000, N'Active'),
(1683, 710, 129, 1, 102, 90000, N'Active'),
(1684, 711, 129, 1, 56, 90000, N'Active'),
(1685, 711, 129, 1, 57, 90000, N'Active'),
(1686, 712, 130, 3, 284, 90000, N'Active'),
(1687, 713, 129, 1, 4, 75000, N'Active'),
(1688, 713, 129, 1, 5, 75000, N'Active'),
(1689, 713, 129, 1, 6, 75000, N'Active'),
(1690, 713, 129, 1, 7, 75000, N'Active'),
(1691, 713, 129, 1, 8, 75000, N'Active'),
(1692, 714, 131, 4, 387, 108000, N'Active'),
(1693, 714, 131, 4, 388, 108000, N'Active'),
(1694, 715, 161, 5, 490, 144000, N'Active'),
(1695, 716, 133, 5, 469, 120000, N'Active'),
(1696, 716, 133, 5, 470, 120000, N'Active'),
(1697, 716, 133, 5, 471, 120000, N'Active'),
(1698, 716, 133, 5, 472, 120000, N'Active'),
(1699, 716, 133, 5, 473, 120000, N'Active'),
(1700, 716, 133, 5, 474, 120000, N'Active'),
(1701, 717, 164, 2, 159, 90000, N'Active'),
(1702, 718, 133, 5, 477, 120000, N'Active'),
(1703, 719, 133, 5, 498, 144000, N'Active'),
(1704, 719, 133, 5, 499, 144000, N'Active'),
(1705, 720, 137, 4, 379, 108000, N'Cancelled'),
(1706, 720, 137, 4, 380, 108000, N'Cancelled'),
(1707, 720, 137, 4, 381, 108000, N'Cancelled'),
(1708, 721, 131, 4, 341, 90000, N'Active'),
(1709, 721, 131, 4, 342, 90000, N'Active'),
(1710, 721, 131, 4, 343, 90000, N'Active'),
(1711, 721, 131, 4, 344, 90000, N'Active'),
(1712, 721, 131, 4, 345, 90000, N'Active'),
(1713, 722, 163, 3, 282, 90000, N'Active'),
(1714, 722, 163, 3, 283, 90000, N'Active'),
(1715, 723, 131, 4, 365, 108000, N'Active'),
(1716, 723, 131, 4, 366, 108000, N'Active'),
(1717, 723, 131, 4, 367, 108000, N'Active'),
(1718, 724, 130, 3, 255, 90000, N'Active'),
(1719, 724, 130, 3, 256, 90000, N'Active'),
(1720, 724, 130, 3, 257, 90000, N'Active'),
(1721, 725, 135, 3, 308, 90000, N'Active'),
(1722, 725, 135, 3, 309, 90000, N'Active'),
(1723, 726, 135, 3, 302, 90000, N'Active'),
(1724, 726, 135, 3, 303, 90000, N'Active'),
(1725, 726, 135, 3, 304, 90000, N'Active'),
(1726, 727, 138, 5, 508, 144000, N'Active'),
(1727, 728, 133, 5, 541, 144000, N'Active'),
(1728, 728, 133, 5, 542, 144000, N'Active'),
(1729, 729, 135, 3, 225, 75000, N'Active'),
(1730, 729, 135, 3, 226, 75000, N'Active'),
(1731, 730, 139, 1, 54, 90000, N'Active'),
(1732, 730, 139, 1, 55, 90000, N'Active'),
(1733, 730, 139, 1, 56, 90000, N'Active'),
(1734, 731, 165, 4, 421, 108000, N'Active'),
(1735, 731, 165, 4, 422, 108000, N'Active'),
(1736, 732, 138, 5, 537, 144000, N'Active'),
(1737, 732, 138, 5, 538, 144000, N'Active'),
(1738, 732, 138, 5, 539, 144000, N'Active'),
(1739, 733, 133, 5, 436, 120000, N'Active'),
(1740, 733, 133, 5, 437, 120000, N'Active'),
(1741, 734, 131, 4, 393, 108000, N'Active'),
(1742, 734, 131, 4, 394, 108000, N'Active'),
(1743, 735, 136, 2, 149, 90000, N'Active'),
(1744, 735, 136, 2, 150, 90000, N'Active'),
(1745, 735, 136, 2, 151, 90000, N'Active'),
(1746, 735, 136, 2, 152, 90000, N'Active'),
(1747, 735, 136, 2, 153, 90000, N'Active'),
(1748, 736, 138, 5, 451, 120000, N'Active'),
(1749, 736, 138, 5, 452, 120000, N'Active'),
(1750, 736, 138, 5, 453, 120000, N'Active'),
(1751, 736, 138, 5, 454, 120000, N'Active'),
(1752, 737, 133, 5, 513, 144000, N'Active'),
(1753, 737, 133, 5, 514, 144000, N'Active'),
(1754, 737, 133, 5, 515, 144000, N'Active'),
(1755, 738, 140, 3, 282, 90000, N'Active'),
(1756, 739, 133, 5, 528, 144000, N'Active'),
(1757, 740, 140, 3, 219, 75000, N'Active'),
(1758, 740, 140, 3, 220, 75000, N'Active'),
(1759, 740, 140, 3, 221, 75000, N'Active'),
(1760, 741, 135, 3, 256, 90000, N'Active'),
(1761, 741, 135, 3, 257, 90000, N'Active'),
(1762, 741, 135, 3, 258, 90000, N'Active'),
(1763, 741, 135, 3, 259, 90000, N'Active'),
(1764, 742, 138, 5, 509, 144000, N'Active'),
(1765, 743, 166, 5, 498, 144000, N'Active'),
(1766, 744, 161, 5, 438, 120000, N'Active'),
(1767, 744, 161, 5, 439, 120000, N'Active'),
(1768, 745, 136, 2, 113, 75000, N'Active'),
(1769, 746, 135, 3, 299, 90000, N'Active'),
(1770, 746, 135, 3, 300, 90000, N'Active'),
(1771, 747, 137, 4, 400, 108000, N'Active'),
(1772, 747, 137, 4, 401, 108000, N'Active'),
(1773, 748, 161, 5, 482, 144000, N'Active'),
(1774, 749, 140, 3, 294, 90000, N'Cancelled'),
(1775, 749, 140, 3, 295, 90000, N'Cancelled'),
(1776, 749, 140, 3, 296, 90000, N'Cancelled'),
(1777, 750, 139, 1, 32, 75000, N'Active'),
(1778, 750, 139, 1, 33, 75000, N'Active'),
(1779, 750, 139, 1, 34, 75000, N'Active'),
(1780, 750, 139, 1, 35, 75000, N'Active'),
(1781, 751, 159, 4, 415, 108000, N'Active'),
(1782, 752, 138, 5, 557, 144000, N'Active'),
(1783, 752, 138, 5, 558, 144000, N'Active'),
(1784, 753, 196, 3, 269, 90000, N'Active'),
(1785, 753, 196, 3, 270, 90000, N'Active'),
(1786, 754, 191, 3, 282, 90000, N'Active'),
(1787, 754, 191, 3, 283, 90000, N'Active'),
(1788, 755, 138, 5, 500, 144000, N'Active'),
(1789, 755, 138, 5, 501, 144000, N'Active'),
(1790, 756, 140, 3, 279, 90000, N'Cancelled'),
(1791, 756, 140, 3, 280, 90000, N'Cancelled'),
(1792, 757, 140, 3, 321, 90000, N'Active'),
(1793, 757, 140, 3, 322, 90000, N'Active'),
(1794, 758, 163, 3, 261, 90000, N'Active'),
(1795, 758, 163, 3, 262, 90000, N'Active'),
(1796, 759, 140, 3, 231, 75000, N'Active'),
(1797, 759, 140, 3, 232, 75000, N'Active'),
(1798, 759, 140, 3, 233, 75000, N'Active'),
(1799, 759, 140, 3, 234, 75000, N'Active'),
(1800, 760, 137, 4, 373, 108000, N'Active'),
(1801, 760, 137, 4, 374, 108000, N'Active'),
(1802, 760, 137, 4, 375, 108000, N'Active'),
(1803, 761, 138, 5, 527, 144000, N'Active'),
(1804, 762, 138, 5, 532, 144000, N'Active'),
(1805, 762, 138, 5, 533, 144000, N'Active'),
(1806, 762, 138, 5, 534, 144000, N'Active'),
(1807, 762, 138, 5, 535, 144000, N'Active'),
(1808, 763, 138, 5, 545, 144000, N'Active'),
(1809, 764, 143, 4, 393, 108000, N'Active'),
(1810, 765, 136, 2, 136, 75000, N'Active'),
(1811, 765, 136, 2, 137, 75000, N'Active'),
(1812, 766, 152, 1, 28, 75000, N'Active'),
(1813, 766, 152, 1, 29, 75000, N'Active'),
(1814, 767, 136, 2, 162, 90000, N'Cancelled'),
(1815, 767, 136, 2, 163, 90000, N'Cancelled'),
(1816, 767, 136, 2, 164, 90000, N'Cancelled'),
(1817, 767, 136, 2, 165, 90000, N'Cancelled'),
(1818, 768, 149, 3, 286, 90000, N'Active'),
(1819, 769, 162, 1, 65, 90000, N'Active'),
(1820, 769, 162, 1, 66, 90000, N'Active'),
(1821, 769, 162, 1, 67, 90000, N'Active'),
(1822, 769, 162, 1, 68, 90000, N'Active'),
(1823, 770, 153, 3, 221, 75000, N'Active'),
(1824, 770, 153, 3, 222, 75000, N'Active'),
(1825, 771, 138, 5, 463, 120000, N'Active'),
(1826, 771, 138, 5, 464, 120000, N'Active'),
(1827, 771, 138, 5, 465, 120000, N'Active'),
(1828, 771, 138, 5, 466, 120000, N'Active'),
(1829, 772, 140, 3, 317, 90000, N'Active'),
(1830, 772, 140, 3, 318, 90000, N'Active'),
(1831, 773, 142, 5, 553, 144000, N'Active'),
(1832, 773, 142, 5, 554, 144000, N'Active'),
(1833, 774, 149, 3, 246, 75000, N'Active'),
(1834, 774, 149, 3, 247, 75000, N'Active'),
(1835, 774, 149, 3, 248, 75000, N'Active'),
(1836, 774, 149, 3, 249, 75000, N'Active'),
(1837, 775, 138, 5, 525, 144000, N'Active'),
(1838, 775, 138, 5, 526, 144000, N'Active'),
(1839, 776, 140, 3, 257, 90000, N'Active'),
(1840, 777, 139, 1, 99, 90000, N'Active'),
(1841, 777, 139, 1, 100, 90000, N'Active'),
(1842, 778, 188, 2, 139, 75000, N'Active'),
(1843, 778, 188, 2, 140, 75000, N'Active'),
(1844, 779, 161, 5, 536, 144000, N'Active'),
(1845, 779, 161, 5, 537, 144000, N'Active'),
(1846, 779, 161, 5, 538, 144000, N'Active'),
(1847, 780, 146, 2, 174, 90000, N'Active'),
(1848, 781, 155, 4, 402, 90000, N'Active'),
(1849, 781, 155, 4, 403, 90000, N'Active'),
(1850, 782, 168, 3, 300, 90000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Chủ nhật 15/11/2026: 189 hoa don (9 huy), 447 ve, doanh thu 44.379.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(783, 3, 67, '2026-11-15T08:12:51', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 170 | Dune: Hành Tinh Cát | 16/11 09:00 | Phòng 5 | J5 J6
(784, 3, NULL, '2026-11-15T08:16:20', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 142 | Dune: Hành Tinh Cát | 15/11 09:00 | Phòng 5 | H10 H11
(785, 10, NULL, '2026-11-15T08:23:50', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 170 | Dune: Hành Tinh Cát | 16/11 09:00 | Phòng 5 | G8 G9 G10
(786, 3, NULL, '2026-11-15T08:23:54', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 144 | Kiến Lé Phiêu Lưu Ké | 15/11 09:30 | Phòng 2 | G4 G5 G6 G7
(787, 3, 63, '2026-11-15T08:31:29', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 144 | Kiến Lé Phiêu Lưu Ké | 15/11 09:30 | Phòng 2 | H7 H8
(788, 10, 93, '2026-11-15T08:32:30', 360000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 142 | Dune: Hành Tinh Cát | 15/11 09:00 | Phòng 5 | D6 D7 D8
(789, 4, NULL, '2026-11-15T08:32:55', 288000, N'Cancelled', N'Cash', 300000, 0, 0, N'Lỗi thanh toán', '2026-11-15T08:47:08', 4), -- suat 142 | Dune: Hành Tinh Cát | 15/11 09:00 | Phòng 5 | E2 E3
(790, 3, NULL, '2026-11-15T08:34:10', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 148 | Godzilla Trừ Không | 15/11 12:15 | Phòng 5 | A2 A3
(791, 10, 67, '2026-11-15T08:34:23', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 141 | Bò Sữa Bay | 15/11 09:00 | Phòng 1 | H6 H7
(792, 4, 72, '2026-11-15T08:34:55', 375000, N'Paid', N'Cash', 400000, 18, 0, NULL, NULL, NULL), -- suat 144 | Kiến Lé Phiêu Lưu Ké | 15/11 09:30 | Phòng 2 | B8 B9 B10 B11 B12
(793, 3, NULL, '2026-11-15T08:35:30', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 145 | Bí Kíp Luyện Cướp | 15/11 10:00 | Phòng 3 | E11 E12
(794, 3, 117, '2026-11-15T08:36:05', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 141 | Bò Sữa Bay | 15/11 09:00 | Phòng 1 | G9 G10 G11
(795, 10, NULL, '2026-11-15T08:36:18', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 215 | Ramayana: Khởi Nguồn Một Huyền Thoại | 17/11 17:45 | Phòng 4 | H2 H3
(796, 4, NULL, '2026-11-15T08:40:07', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 143 | Ramayana: Khởi Nguồn Một Huyền Thoại | 15/11 09:15 | Phòng 4 | E5 E6 E7
(797, 10, NULL, '2026-11-15T08:42:21', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 142 | Dune: Hành Tinh Cát | 15/11 09:00 | Phòng 5 | L5 L6
(798, 10, NULL, '2026-11-15T08:43:24', 300000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 141 | Bò Sữa Bay | 15/11 09:00 | Phòng 1 | B6 B7 B8 B9
(799, 10, NULL, '2026-11-15T08:45:01', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 142 | Dune: Hành Tinh Cát | 15/11 09:00 | Phòng 5 | L7 L8
(800, 10, 56, '2026-11-15T08:47:38', 108000, N'Paid', N'Cash', 108000, 7, 0, NULL, NULL, NULL), -- suat 143 | Ramayana: Khởi Nguồn Một Huyền Thoại | 15/11 09:15 | Phòng 4 | H7
(801, 4, 8, '2026-11-15T08:52:27', 225000, N'Paid', N'Transfer', NULL, 11, 0, NULL, NULL, NULL), -- suat 144 | Kiến Lé Phiêu Lưu Ké | 15/11 09:30 | Phòng 2 | B2 B3 B4
(802, 10, NULL, '2026-11-15T08:53:14', 75000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 145 | Bí Kíp Luyện Cướp | 15/11 10:00 | Phòng 3 | A2
(803, 3, NULL, '2026-11-15T08:54:09', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 169 | Bò Sữa Bay | 16/11 09:00 | Phòng 1 | B6 B7
(804, 10, NULL, '2026-11-15T08:55:36', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 150 | Godzilla Trừ Không | 15/11 12:30 | Phòng 4 | H4 H5 H6
(805, 3, NULL, '2026-11-15T09:13:10', 75000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 145 | Bí Kíp Luyện Cướp | 15/11 10:00 | Phòng 3 | C10
(806, 3, 47, '2026-11-15T09:15:44', 216000, N'Paid', N'Cash', 216000, 15, 0, NULL, NULL, NULL), -- suat 150 | Godzilla Trừ Không | 15/11 12:30 | Phòng 4 | F2 F3
(807, 4, NULL, '2026-11-15T09:20:15', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 148 | Godzilla Trừ Không | 15/11 12:15 | Phòng 5 | H1 H2
(808, 10, 69, '2026-11-15T09:20:53', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 145 | Bí Kíp Luyện Cướp | 15/11 10:00 | Phòng 3 | H6 H7
(809, 4, NULL, '2026-11-15T09:26:19', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 218 | Ngày Con Còn Mẹ | 17/11 19:00 | Phòng 1 | B8 B9
(810, 3, 21, '2026-11-15T09:32:52', 288000, N'Paid', N'Cash', 300000, 20, 0, NULL, NULL, NULL), -- suat 189 | Godzilla Trừ Không | 16/11 18:15 | Phòng 5 | H1 H2
(811, 4, NULL, '2026-11-15T09:35:13', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 176 | Godzilla Trừ Không | 16/11 12:15 | Phòng 5 | K5
(812, 3, NULL, '2026-11-15T09:36:32', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 158 | Clayface | 15/11 17:00 | Phòng 3 | E5 E6 E7 E8
(813, 4, 67, '2026-11-15T09:44:54', 288000, N'Paid', N'Cash', 500000, 20, 0, NULL, NULL, NULL), -- suat 148 | Godzilla Trừ Không | 15/11 12:15 | Phòng 5 | K6 K7
(814, 3, NULL, '2026-11-15T09:49:18', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 181 | Thiên Đường Tăm Tối | 16/11 14:45 | Phòng 3 | C7 C8
(815, 4, 111, '2026-11-15T09:50:23', 360000, N'Paid', N'Cash', 400000, 25, 0, NULL, NULL, NULL), -- suat 155 | Bí Kíp Luyện Cướp | 15/11 15:15 | Phòng 4 | E5 E6 E7 E8
(816, 3, NULL, '2026-11-15T09:53:38', 108000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 150 | Godzilla Trừ Không | 15/11 12:30 | Phòng 4 | G5
(817, 4, NULL, '2026-11-15T09:54:53', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 149 | Kẻ Hồi Sinh | 15/11 12:30 | Phòng 3 | D11 D12
(818, 3, NULL, '2026-11-15T09:59:39', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 147 | Ngày Con Còn Mẹ | 15/11 11:30 | Phòng 1 | D6
(819, 3, NULL, '2026-11-15T10:02:06', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 203 | Ngày Con Còn Mẹ | 17/11 11:30 | Phòng 1 | J7 J8
(820, 10, NULL, '2026-11-15T10:03:44', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 149 | Kẻ Hồi Sinh | 15/11 12:30 | Phòng 3 | G1 G2
(821, 4, NULL, '2026-11-15T10:07:05', 120000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 154 | Dune: Hành Tinh Cát | 15/11 15:00 | Phòng 5 | D7
(822, 4, NULL, '2026-11-15T10:17:23', 90000, N'Cancelled', N'Cash', 90000, 0, 0, N'Khách đổi ý', '2026-11-15T11:01:13', 4), -- suat 146 | Chàng Mèo Mang Mũ | 15/11 11:15 | Phòng 2 | H12
(823, 3, NULL, '2026-11-15T10:25:39', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 147 | Ngày Con Còn Mẹ | 15/11 11:30 | Phòng 1 | D7 D8
(824, 3, NULL, '2026-11-15T10:25:46', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 159 | Ramayana: Khởi Nguồn Một Huyền Thoại | 15/11 17:45 | Phòng 4 | F4 F5
(825, 4, 94, '2026-11-15T10:32:02', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 146 | Chàng Mèo Mang Mũ | 15/11 11:15 | Phòng 2 | E6 E7
(826, 4, NULL, '2026-11-15T10:38:43', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 149 | Kẻ Hồi Sinh | 15/11 12:30 | Phòng 3 | H4 H5
(827, 3, 117, '2026-11-15T10:44:35', 75000, N'Paid', N'Cash', 80000, 3, 0, NULL, NULL, NULL), -- suat 158 | Clayface | 15/11 17:00 | Phòng 3 | C4
(828, 10, NULL, '2026-11-15T10:46:27', 540000, N'Paid', N'Cash', 550000, 0, 0, NULL, NULL, NULL), -- suat 158 | Clayface | 15/11 17:00 | Phòng 3 | H4 H5 H6 H7 H8 H9
(829, 3, NULL, '2026-11-15T10:50:58', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 150 | Godzilla Trừ Không | 15/11 12:30 | Phòng 4 | D7 D8
(830, 3, NULL, '2026-11-15T10:54:30', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | C9 C10
(831, 10, 53, '2026-11-15T11:01:41', 144000, N'Paid', N'Cash', 200000, 10, 0, NULL, NULL, NULL), -- suat 154 | Dune: Hành Tinh Cát | 15/11 15:00 | Phòng 5 | F5
(832, 3, NULL, '2026-11-15T11:17:40', 480000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | C7 C8 C9 C10
(833, 3, 22, '2026-11-15T11:17:53', 324000, N'Paid', N'Card', NULL, 22, 0, NULL, NULL, NULL), -- suat 159 | Ramayana: Khởi Nguồn Một Huyền Thoại | 15/11 17:45 | Phòng 4 | G1 G2 G3
(834, 3, 30, '2026-11-15T11:26:08', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 148 | Godzilla Trừ Không | 15/11 12:15 | Phòng 5 | G8 G9
(835, 4, NULL, '2026-11-15T11:26:42', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | E5
(836, 10, NULL, '2026-11-15T11:35:32', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 148 | Godzilla Trừ Không | 15/11 12:15 | Phòng 5 | J5 J6
(837, 4, NULL, '2026-11-15T11:37:08', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 156 | Ngày Con Còn Mẹ | 15/11 15:30 | Phòng 2 | B6 B7
(838, 3, 61, '2026-11-15T11:38:55', 240000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | B9 B10
(839, 4, NULL, '2026-11-15T11:39:19', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 148 | Godzilla Trừ Không | 15/11 12:15 | Phòng 5 | H7
(840, 10, NULL, '2026-11-15T11:45:44', 576000, N'Paid', N'Cash', 600000, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | F6 F7 F8 F9
(841, 3, NULL, '2026-11-15T11:46:26', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 151 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 15/11 13:30 | Phòng 2 | C6 C7
(842, 4, NULL, '2026-11-15T11:50:40', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 158 | Clayface | 15/11 17:00 | Phòng 3 | A6 A7
(843, 4, NULL, '2026-11-15T11:52:18', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 155 | Bí Kíp Luyện Cướp | 15/11 15:15 | Phòng 4 | D5 D6 D7 D8
(844, 3, NULL, '2026-11-15T11:58:22', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 156 | Ngày Con Còn Mẹ | 15/11 15:30 | Phòng 2 | J7 J8
(845, 3, NULL, '2026-11-15T11:58:35', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 187 | Ramayana: Khởi Nguồn Một Huyền Thoại | 16/11 17:45 | Phòng 4 | G7 G8
(846, 4, NULL, '2026-11-15T12:02:32', 375000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 163 | Ngày Con Còn Mẹ | 15/11 19:15 | Phòng 3 | A1 A2 A3 A4 A5
(847, 4, NULL, '2026-11-15T12:08:38', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | G8 G9
(848, 4, NULL, '2026-11-15T12:13:01', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 154 | Dune: Hành Tinh Cát | 15/11 15:00 | Phòng 5 | G10 G11
(849, 3, NULL, '2026-11-15T12:14:34', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 156 | Ngày Con Còn Mẹ | 15/11 15:30 | Phòng 2 | G1
(850, 3, NULL, '2026-11-15T12:16:40', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 155 | Bí Kíp Luyện Cướp | 15/11 15:15 | Phòng 4 | H7 H8
(851, 4, NULL, '2026-11-15T12:18:38', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 209 | Thiên Đường Tăm Tối | 17/11 14:45 | Phòng 3 | J3 J4
(852, 10, NULL, '2026-11-15T12:20:04', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 175 | Ngày Con Còn Mẹ | 16/11 11:30 | Phòng 1 | H6 H7
(853, 4, NULL, '2026-11-15T12:20:17', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 151 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 15/11 13:30 | Phòng 2 | E5 E6
(854, 3, 9, '2026-11-15T12:23:26', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 159 | Ramayana: Khởi Nguồn Một Huyền Thoại | 15/11 17:45 | Phòng 4 | F7 F8
(855, 3, NULL, '2026-11-15T12:30:25', 576000, N'Paid', N'Cash', 600000, 0, 0, NULL, NULL, NULL), -- suat 154 | Dune: Hành Tinh Cát | 15/11 15:00 | Phòng 5 | F8 F9 F10 F11
(856, 3, NULL, '2026-11-15T12:41:04', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 222 | Dune: Hành Tinh Cát | 17/11 21:00 | Phòng 5 | L7 L8
(857, 3, 34, '2026-11-15T12:41:55', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 151 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 15/11 13:30 | Phòng 2 | B2 B3
(858, 3, NULL, '2026-11-15T12:42:14', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 166 | Dune: Hành Tinh Cát | 15/11 21:00 | Phòng 5 | K6 K7
(859, 3, 33, '2026-11-15T12:43:18', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 155 | Bí Kíp Luyện Cướp | 15/11 15:15 | Phòng 4 | D1 D2
(860, 4, NULL, '2026-11-15T12:48:04', 432000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 154 | Dune: Hành Tinh Cát | 15/11 15:00 | Phòng 5 | J4 J5 J6
(861, 3, NULL, '2026-11-15T12:49:51', 75000, N'Paid', N'Cash', 80000, 0, 0, NULL, NULL, NULL), -- suat 181 | Thiên Đường Tăm Tối | 16/11 14:45 | Phòng 3 | C1
(862, 10, NULL, '2026-11-15T12:49:59', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 164 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 15/11 20:45 | Phòng 2 | D2 D3
(863, 4, NULL, '2026-11-15T12:53:15', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | E8 E9
(864, 3, 42, '2026-11-15T12:53:53', 432000, N'Paid', N'Transfer', NULL, 30, 0, NULL, NULL, NULL), -- suat 199 | Ramayana: Khởi Nguồn Một Huyền Thoại | 17/11 09:15 | Phòng 4 | G5 G6 G7 G8
(865, 4, NULL, '2026-11-15T12:56:11', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | L11 L12
(866, 10, NULL, '2026-11-15T12:59:25', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 197 | Bò Sữa Bay | 17/11 09:00 | Phòng 1 | G9 G10
(867, 3, 77, '2026-11-15T12:59:58', 864000, N'Paid', N'Card', NULL, 60, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | H2 H3 H4 H5 H6 H7
(868, 4, NULL, '2026-11-15T13:02:32', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 155 | Bí Kíp Luyện Cướp | 15/11 15:15 | Phòng 4 | F7 F8 F9 F10
(869, 3, NULL, '2026-11-15T13:11:10', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 152 | Chị Chị Em Em 3 | 15/11 14:00 | Phòng 1 | H8 H9
(870, 4, NULL, '2026-11-15T13:24:06', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 153 | Thiên Đường Tăm Tối | 15/11 14:45 | Phòng 3 | G9 G10
(871, 10, NULL, '2026-11-15T13:25:22', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | L7 L8
(872, 4, NULL, '2026-11-15T13:27:09', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 155 | Bí Kíp Luyện Cướp | 15/11 15:15 | Phòng 4 | H4 H5 H6
(873, 10, NULL, '2026-11-15T13:40:32', 450000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 163 | Ngày Con Còn Mẹ | 15/11 19:15 | Phòng 3 | H5 H6 H7 H8 H9
(874, 3, NULL, '2026-11-15T13:41:57', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 158 | Clayface | 15/11 17:00 | Phòng 3 | B6 B7
(875, 3, 45, '2026-11-15T13:47:43', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 157 | Bò Sữa Bay | 15/11 16:30 | Phòng 1 | H9 H10
(876, 3, NULL, '2026-11-15T13:48:23', 288000, N'Cancelled', N'Card', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-15T14:53:39', 1), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | H9 H10
(877, 4, 46, '2026-11-15T13:52:43', 360000, N'Paid', N'Cash', 360000, 25, 0, NULL, NULL, NULL), -- suat 164 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 15/11 20:45 | Phòng 2 | F3 F4 F5 F6
(878, 4, NULL, '2026-11-15T14:10:36', 576000, N'Paid', N'Cash', 600000, 0, 0, NULL, NULL, NULL), -- suat 189 | Godzilla Trừ Không | 16/11 18:15 | Phòng 5 | H6 H7 H8 H9
(879, 4, 44, '2026-11-15T14:13:36', 216000, N'Paid', N'Cash', 250000, 21, 0, NULL, NULL, NULL), -- suat 187 | Ramayana: Khởi Nguồn Một Huyền Thoại | 16/11 17:45 | Phòng 4 | J11 J12
(880, 4, NULL, '2026-11-15T14:17:31', 108000, N'Paid', N'Cash', 108000, 0, 0, NULL, NULL, NULL), -- suat 159 | Ramayana: Khởi Nguồn Một Huyền Thoại | 15/11 17:45 | Phòng 4 | F10
(881, 4, NULL, '2026-11-15T14:19:11', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 154 | Dune: Hành Tinh Cát | 15/11 15:00 | Phòng 5 | H1
(882, 3, NULL, '2026-11-15T14:23:54', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 167 | Chị Chị Em Em 3 | 15/11 21:30 | Phòng 1 | J9 J10
(883, 4, NULL, '2026-11-15T14:27:11', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 160 | Trại Buôn Người | 15/11 18:00 | Phòng 2 | E5 E6
(884, 3, NULL, '2026-11-15T14:35:14', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | J9 J10
(885, 3, 6, '2026-11-15T14:38:04', 90000, N'Cancelled', N'Transfer', NULL, 6, 0, N'Lỗi thanh toán', '2026-11-15T14:51:41', 3), -- suat 168 | Bí Kíp Luyện Cướp | 15/11 21:30 | Phòng 3 | G8
(886, 10, NULL, '2026-11-15T14:38:15', 300000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | B9 B10 B11 B12
(887, 10, NULL, '2026-11-15T14:38:53', 360000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-15T15:03:48', 10), -- suat 159 | Ramayana: Khởi Nguồn Một Huyền Thoại | 15/11 17:45 | Phòng 4 | A6 A7 A8 A9
(888, 3, 21, '2026-11-15T14:44:49', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 160 | Trại Buôn Người | 15/11 18:00 | Phòng 2 | G7 G8
(889, 10, 77, '2026-11-15T14:44:56', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 178 | Godzilla Trừ Không | 16/11 12:30 | Phòng 4 | H4 H5
(890, 10, NULL, '2026-11-15T14:49:35', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 168 | Bí Kíp Luyện Cướp | 15/11 21:30 | Phòng 3 | H9 H10 H11
(891, 4, 31, '2026-11-15T14:53:26', 225000, N'Paid', N'Cash', 225000, 11, 0, NULL, NULL, NULL), -- suat 157 | Bò Sữa Bay | 15/11 16:30 | Phòng 1 | B10 B11 B12
(892, 3, 23, '2026-11-15T14:54:44', 75000, N'Paid', N'Cash', 75000, 3, 0, NULL, NULL, NULL), -- suat 163 | Ngày Con Còn Mẹ | 15/11 19:15 | Phòng 3 | C4
(893, 6, NULL, '2026-11-15T15:05:28', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 159 | Ramayana: Khởi Nguồn Một Huyền Thoại | 15/11 17:45 | Phòng 4 | E8 E9
(894, 5, NULL, '2026-11-15T15:05:57', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | G4 G5 G6 G7
(895, 5, 82, '2026-11-15T15:08:05', 180000, N'Cancelled', N'Cash', 500000, 12, 0, N'Nhầm suất / ghế', '2026-11-15T15:11:00', 5), -- suat 167 | Chị Chị Em Em 3 | 15/11 21:30 | Phòng 1 | G2 G3
(896, 7, NULL, '2026-11-15T15:08:18', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 159 | Ramayana: Khởi Nguồn Một Huyền Thoại | 15/11 17:45 | Phòng 4 | G7 G8
(897, 7, NULL, '2026-11-15T15:12:15', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 166 | Dune: Hành Tinh Cát | 15/11 21:00 | Phòng 5 | L11 L12
(898, 6, NULL, '2026-11-15T15:28:32', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | C7 C8
(899, 6, 113, '2026-11-15T15:29:34', 240000, N'Paid', N'Transfer', NULL, 16, 30, NULL, NULL, NULL), -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | G9 G10 G11
(900, 5, NULL, '2026-11-15T15:34:32', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 158 | Clayface | 15/11 17:00 | Phòng 3 | B4 B5
(901, 6, NULL, '2026-11-15T15:34:48', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | E6 E7
(902, 5, NULL, '2026-11-15T15:35:30', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | E9 E10
(903, 5, NULL, '2026-11-15T15:36:08', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | H10
(904, 7, 65, '2026-11-15T15:36:20', 576000, N'Paid', N'Cash', 576000, 40, 0, NULL, NULL, NULL), -- suat 166 | Dune: Hành Tinh Cát | 15/11 21:00 | Phòng 5 | H5 H6 H7 H8
(905, 5, NULL, '2026-11-15T15:38:52', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 167 | Chị Chị Em Em 3 | 15/11 21:30 | Phòng 1 | E2 E3 E4
(906, 6, NULL, '2026-11-15T15:39:34', 324000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 165 | Godzilla Trừ Không | 15/11 21:00 | Phòng 4 | E1 E2 E3
(907, 5, NULL, '2026-11-15T15:44:48', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | K10 K11
(908, 5, NULL, '2026-11-15T15:50:44', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 163 | Ngày Con Còn Mẹ | 15/11 19:15 | Phòng 3 | E4 E5 E6 E7
(909, 7, NULL, '2026-11-15T15:54:34', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | J4 J5
(910, 5, NULL, '2026-11-15T15:54:54', 144000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | J6
(911, 5, NULL, '2026-11-15T15:56:26', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 166 | Dune: Hành Tinh Cát | 15/11 21:00 | Phòng 5 | H4
(912, 5, NULL, '2026-11-15T15:59:03', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 168 | Bí Kíp Luyện Cướp | 15/11 21:30 | Phòng 3 | D9 D10 D11
(913, 6, NULL, '2026-11-15T16:05:18', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 177 | Kẻ Hồi Sinh | 16/11 12:30 | Phòng 3 | E9 E10 E11
(914, 5, 69, '2026-11-15T16:09:35', 288000, N'Paid', N'Cash', 300000, 28, 0, NULL, NULL, NULL), -- suat 210 | Dune: Hành Tinh Cát | 17/11 15:00 | Phòng 5 | L1 L2
(915, 6, 72, '2026-11-15T16:16:18', 216000, N'Paid', N'Cash', 250000, 15, 0, NULL, NULL, NULL), -- suat 165 | Godzilla Trừ Không | 15/11 21:00 | Phòng 4 | H7 H8
(916, 7, 109, '2026-11-15T16:17:27', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 174 | Chàng Mèo Mang Mũ | 16/11 11:15 | Phòng 2 | J5 J6
(917, 5, NULL, '2026-11-15T16:19:24', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 163 | Ngày Con Còn Mẹ | 15/11 19:15 | Phòng 3 | D5 D6
(918, 6, NULL, '2026-11-15T16:22:08', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 166 | Dune: Hành Tinh Cát | 15/11 21:00 | Phòng 5 | J4 J5
(919, 7, NULL, '2026-11-15T16:22:38', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | E12
(920, 7, NULL, '2026-11-15T16:24:13', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | F9 F10
(921, 5, NULL, '2026-11-15T16:26:15', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | E6 E7
(922, 7, NULL, '2026-11-15T16:29:37', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | A2 A3 A4
(923, 7, NULL, '2026-11-15T16:29:41', 120000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 161 | Godzilla Trừ Không | 15/11 18:15 | Phòng 5 | C6
(924, 7, NULL, '2026-11-15T16:33:01', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 168 | Bí Kíp Luyện Cướp | 15/11 21:30 | Phòng 3 | G9
(925, 5, NULL, '2026-11-15T16:37:21', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 180 | Chị Chị Em Em 3 | 16/11 14:00 | Phòng 1 | B2 B3
(926, 7, 47, '2026-11-15T16:40:54', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 218 | Ngày Con Còn Mẹ | 17/11 19:00 | Phòng 1 | E5 E6 E7
(927, 7, NULL, '2026-11-15T16:41:53', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 163 | Ngày Con Còn Mẹ | 15/11 19:15 | Phòng 3 | B9 B10
(928, 5, 29, '2026-11-15T16:47:42', 225000, N'Paid', N'Card', NULL, 11, 0, NULL, NULL, NULL), -- suat 163 | Ngày Con Còn Mẹ | 15/11 19:15 | Phòng 3 | C5 C6 C7
(929, 7, 107, '2026-11-15T16:52:56', 108000, N'Paid', N'Cash', 110000, 7, 0, NULL, NULL, NULL), -- suat 165 | Godzilla Trừ Không | 15/11 21:00 | Phòng 4 | G6
(930, 6, NULL, '2026-11-15T16:53:57', 240000, N'Cancelled', N'Cash', 240000, 0, 0, N'Lỗi thanh toán', '2026-11-15T17:16:26', 6), -- suat 166 | Dune: Hành Tinh Cát | 15/11 21:00 | Phòng 5 | A1 A2
(931, 6, NULL, '2026-11-15T16:55:36', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 164 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 15/11 20:45 | Phòng 2 | H7 H8 H9 H10
(932, 7, 15, '2026-11-15T16:57:09', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | D4
(933, 7, NULL, '2026-11-15T16:58:08', 216000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-15T18:03:21', 2), -- suat 165 | Godzilla Trừ Không | 15/11 21:00 | Phòng 4 | F8 F9
(934, 6, 66, '2026-11-15T16:58:20', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 163 | Ngày Con Còn Mẹ | 15/11 19:15 | Phòng 3 | E11 E12
(935, 5, NULL, '2026-11-15T17:11:40', 480000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 166 | Dune: Hành Tinh Cát | 15/11 21:00 | Phòng 5 | D6 D7 D8 D9
(936, 6, NULL, '2026-11-15T17:15:05', 270000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 159 | Ramayana: Khởi Nguồn Một Huyền Thoại | 15/11 17:45 | Phòng 4 | C2 C3 C4
(937, 7, 37, '2026-11-15T17:17:55', 576000, N'Cancelled', N'Cash', 600000, 40, 0, N'Sự cố phòng chiếu', '2026-11-15T21:24:48', 2), -- suat 166 | Dune: Hành Tinh Cát | 15/11 21:00 | Phòng 5 | J9 J10 J11 J12
(938, 5, NULL, '2026-11-15T17:21:44', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 166 | Dune: Hành Tinh Cát | 15/11 21:00 | Phòng 5 | G8 G9
(939, 5, NULL, '2026-11-15T17:22:15', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 164 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 15/11 20:45 | Phòng 2 | E8 E9
(940, 7, 108, '2026-11-15T17:32:01', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 177 | Kẻ Hồi Sinh | 16/11 12:30 | Phòng 3 | C2 C3
(941, 6, NULL, '2026-11-15T17:41:39', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 166 | Dune: Hành Tinh Cát | 15/11 21:00 | Phòng 5 | K9
(942, 5, NULL, '2026-11-15T17:46:34', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 178 | Godzilla Trừ Không | 16/11 12:30 | Phòng 4 | C6 C7
(943, 6, 63, '2026-11-15T17:51:07', 324000, N'Paid', N'Cash', 324000, 22, 0, NULL, NULL, NULL), -- suat 165 | Godzilla Trừ Không | 15/11 21:00 | Phòng 4 | E4 E5 E6
(944, 7, 116, '2026-11-15T17:57:21', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 162 | Ngày Con Còn Mẹ | 15/11 19:00 | Phòng 1 | G7 G8
(945, 7, NULL, '2026-11-15T18:07:20', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 172 | Kiến Lé Phiêu Lưu Ké | 16/11 09:30 | Phòng 2 | H1 H2 H3
(946, 5, 25, '2026-11-15T18:10:50', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 163 | Ngày Con Còn Mẹ | 15/11 19:15 | Phòng 3 | H10 H11
(947, 7, NULL, '2026-11-15T18:11:15', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 191 | Ngày Con Còn Mẹ | 16/11 19:15 | Phòng 3 | F10
(948, 5, NULL, '2026-11-15T18:18:39', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 165 | Godzilla Trừ Không | 15/11 21:00 | Phòng 4 | F2 F3
(949, 7, 56, '2026-11-15T18:20:32', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 164 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 15/11 20:45 | Phòng 2 | F9
(950, 5, NULL, '2026-11-15T18:21:39', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 164 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 15/11 20:45 | Phòng 2 | C2 C3
(951, 7, 93, '2026-11-15T18:27:01', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 163 | Ngày Con Còn Mẹ | 15/11 19:15 | Phòng 3 | C11 C12
(952, 6, NULL, '2026-11-15T18:34:19', 720000, N'Paid', N'Cash', 750000, 0, 0, NULL, NULL, NULL), -- suat 166 | Dune: Hành Tinh Cát | 15/11 21:00 | Phòng 5 | E7 E8 E9 E10 E11
(953, 7, NULL, '2026-11-15T18:38:32', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 166 | Dune: Hành Tinh Cát | 15/11 21:00 | Phòng 5 | C7 C8 C9
(954, 7, NULL, '2026-11-15T18:42:50', 300000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 186 | Clayface | 16/11 17:00 | Phòng 3 | B9 B10 B11 B12
(955, 5, NULL, '2026-11-15T18:47:14', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 176 | Godzilla Trừ Không | 16/11 12:15 | Phòng 5 | J8 J9
(956, 7, NULL, '2026-11-15T18:58:55', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 188 | Trại Buôn Người | 16/11 18:00 | Phòng 2 | E6 E7
(957, 7, 28, '2026-11-15T18:59:31', 108000, N'Paid', N'Cash', 200000, 7, 0, NULL, NULL, NULL), -- suat 165 | Godzilla Trừ Không | 15/11 21:00 | Phòng 4 | D7
(958, 7, NULL, '2026-11-15T19:02:23', 300000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 164 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 15/11 20:45 | Phòng 2 | C4 C5 C6 C7
(959, 7, NULL, '2026-11-15T19:06:57', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 186 | Clayface | 16/11 17:00 | Phòng 3 | J7 J8
(960, 6, NULL, '2026-11-15T19:43:07', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 167 | Chị Chị Em Em 3 | 15/11 21:30 | Phòng 1 | E6 E7
(961, 7, NULL, '2026-11-15T19:46:00', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 166 | Dune: Hành Tinh Cát | 15/11 21:00 | Phòng 5 | L5 L6
(962, 7, 1, '2026-11-15T19:46:49', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 167 | Chị Chị Em Em 3 | 15/11 21:30 | Phòng 1 | G2 G3
(963, 6, NULL, '2026-11-15T19:52:46', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 165 | Godzilla Trừ Không | 15/11 21:00 | Phòng 4 | G7
(964, 5, NULL, '2026-11-15T20:01:34', 450000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 195 | Chị Chị Em Em 3 | 16/11 21:30 | Phòng 1 | G7 G8 G9 G10 G11
(965, 7, NULL, '2026-11-15T20:19:05', 240000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 222 | Dune: Hành Tinh Cát | 17/11 21:00 | Phòng 5 | A7 A8
(966, 7, NULL, '2026-11-15T20:25:48', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 166 | Dune: Hành Tinh Cát | 15/11 21:00 | Phòng 5 | L3 L4
(967, 7, 117, '2026-11-15T20:25:57', 540000, N'Paid', N'Card', NULL, 27, 0, NULL, NULL, NULL), -- suat 165 | Godzilla Trừ Không | 15/11 21:00 | Phòng 4 | C7 C8 C9 C10 C11 C12
(968, 7, NULL, '2026-11-15T20:26:56', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 191 | Ngày Con Còn Mẹ | 16/11 19:15 | Phòng 3 | H7 H8 H9
(969, 6, NULL, '2026-11-15T20:51:12', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 192 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 16/11 20:45 | Phòng 2 | H3 H4 H5 H6
(970, 6, NULL, '2026-11-15T20:58:12', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 181 | Thiên Đường Tăm Tối | 16/11 14:45 | Phòng 3 | D6 D7
(971, 7, NULL, '2026-11-15T20:59:41', 720000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL); -- suat 176 | Godzilla Trừ Không | 16/11 12:15 | Phòng 5 | J3 J4 J5 J6 J7
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(1851, 783, 170, 5, 533, 144000, N'Active'),
(1852, 783, 170, 5, 534, 144000, N'Active'),
(1853, 784, 142, 5, 526, 144000, N'Active'),
(1854, 784, 142, 5, 527, 144000, N'Active'),
(1855, 785, 170, 5, 512, 144000, N'Active'),
(1856, 785, 170, 5, 513, 144000, N'Active'),
(1857, 785, 170, 5, 514, 144000, N'Active'),
(1858, 786, 144, 2, 184, 90000, N'Active'),
(1859, 786, 144, 2, 185, 90000, N'Active'),
(1860, 786, 144, 2, 186, 90000, N'Active'),
(1861, 786, 144, 2, 187, 90000, N'Active'),
(1862, 787, 144, 2, 199, 90000, N'Active'),
(1863, 787, 144, 2, 200, 90000, N'Active'),
(1864, 788, 142, 5, 474, 120000, N'Active'),
(1865, 788, 142, 5, 475, 120000, N'Active'),
(1866, 788, 142, 5, 476, 120000, N'Active'),
(1867, 789, 142, 5, 482, 144000, N'Cancelled'),
(1868, 789, 142, 5, 483, 144000, N'Cancelled'),
(1869, 790, 148, 5, 434, 120000, N'Active'),
(1870, 790, 148, 5, 435, 120000, N'Active'),
(1871, 791, 141, 1, 90, 90000, N'Active'),
(1872, 791, 141, 1, 91, 90000, N'Active'),
(1873, 792, 144, 2, 128, 75000, N'Active'),
(1874, 792, 144, 2, 129, 75000, N'Active'),
(1875, 792, 144, 2, 130, 75000, N'Active'),
(1876, 792, 144, 2, 131, 75000, N'Active'),
(1877, 792, 144, 2, 132, 75000, N'Active'),
(1878, 793, 145, 3, 275, 90000, N'Active'),
(1879, 793, 145, 3, 276, 90000, N'Active'),
(1880, 794, 141, 1, 81, 90000, N'Active'),
(1881, 794, 141, 1, 82, 90000, N'Active'),
(1882, 794, 141, 1, 83, 90000, N'Active'),
(1883, 795, 215, 4, 410, 108000, N'Active'),
(1884, 795, 215, 4, 411, 108000, N'Active'),
(1885, 796, 143, 4, 377, 108000, N'Active'),
(1886, 796, 143, 4, 378, 108000, N'Active'),
(1887, 796, 143, 4, 379, 108000, N'Active'),
(1888, 797, 142, 5, 557, 144000, N'Active'),
(1889, 797, 142, 5, 558, 144000, N'Active'),
(1890, 798, 141, 1, 18, 75000, N'Active'),
(1891, 798, 141, 1, 19, 75000, N'Active'),
(1892, 798, 141, 1, 20, 75000, N'Active'),
(1893, 798, 141, 1, 21, 75000, N'Active'),
(1894, 799, 142, 5, 559, 144000, N'Active'),
(1895, 799, 142, 5, 560, 144000, N'Active'),
(1896, 800, 143, 4, 415, 108000, N'Active'),
(1897, 801, 144, 2, 122, 75000, N'Active'),
(1898, 801, 144, 2, 123, 75000, N'Active'),
(1899, 801, 144, 2, 124, 75000, N'Active'),
(1900, 802, 145, 3, 218, 75000, N'Active'),
(1901, 803, 169, 1, 18, 75000, N'Active'),
(1902, 803, 169, 1, 19, 75000, N'Active'),
(1903, 804, 150, 4, 412, 108000, N'Active'),
(1904, 804, 150, 4, 413, 108000, N'Active'),
(1905, 804, 150, 4, 414, 108000, N'Active'),
(1906, 805, 145, 3, 250, 75000, N'Active'),
(1907, 806, 150, 4, 386, 108000, N'Active'),
(1908, 806, 150, 4, 387, 108000, N'Active'),
(1909, 807, 148, 5, 517, 144000, N'Active'),
(1910, 807, 148, 5, 518, 144000, N'Active'),
(1911, 808, 145, 3, 306, 90000, N'Active'),
(1912, 808, 145, 3, 307, 90000, N'Active'),
(1913, 809, 218, 1, 20, 75000, N'Active'),
(1914, 809, 218, 1, 21, 75000, N'Active'),
(1915, 810, 189, 5, 517, 144000, N'Active'),
(1916, 810, 189, 5, 518, 144000, N'Active'),
(1917, 811, 176, 5, 545, 144000, N'Active'),
(1918, 812, 158, 3, 269, 90000, N'Active'),
(1919, 812, 158, 3, 270, 90000, N'Active'),
(1920, 812, 158, 3, 271, 90000, N'Active'),
(1921, 812, 158, 3, 272, 90000, N'Active'),
(1922, 813, 148, 5, 546, 144000, N'Active'),
(1923, 813, 148, 5, 547, 144000, N'Active'),
(1924, 814, 181, 3, 247, 75000, N'Active'),
(1925, 814, 181, 3, 248, 75000, N'Active'),
(1926, 815, 155, 4, 377, 90000, N'Active'),
(1927, 815, 155, 4, 378, 90000, N'Active'),
(1928, 815, 155, 4, 379, 90000, N'Active'),
(1929, 815, 155, 4, 380, 90000, N'Active'),
(1930, 816, 150, 4, 401, 108000, N'Active'),
(1931, 817, 149, 3, 263, 90000, N'Active'),
(1932, 817, 149, 3, 264, 90000, N'Active'),
(1933, 818, 147, 1, 42, 90000, N'Active'),
(1934, 819, 203, 1, 103, 90000, N'Active'),
(1935, 819, 203, 1, 104, 90000, N'Active'),
(1936, 820, 149, 3, 289, 90000, N'Active'),
(1937, 820, 149, 3, 290, 90000, N'Active'),
(1938, 821, 154, 5, 475, 120000, N'Active'),
(1939, 822, 146, 2, 204, 90000, N'Cancelled'),
(1940, 823, 147, 1, 43, 90000, N'Active'),
(1941, 823, 147, 1, 44, 90000, N'Active'),
(1942, 824, 159, 4, 388, 108000, N'Active'),
(1943, 824, 159, 4, 389, 108000, N'Active'),
(1944, 825, 146, 2, 162, 90000, N'Active'),
(1945, 825, 146, 2, 163, 90000, N'Active'),
(1946, 826, 149, 3, 304, 90000, N'Active'),
(1947, 826, 149, 3, 305, 90000, N'Active'),
(1948, 827, 158, 3, 244, 75000, N'Active'),
(1949, 828, 158, 3, 304, 90000, N'Active'),
(1950, 828, 158, 3, 305, 90000, N'Active'),
(1951, 828, 158, 3, 306, 90000, N'Active'),
(1952, 828, 158, 3, 307, 90000, N'Active'),
(1953, 828, 158, 3, 308, 90000, N'Active'),
(1954, 828, 158, 3, 309, 90000, N'Active'),
(1955, 829, 150, 4, 367, 108000, N'Active'),
(1956, 829, 150, 4, 368, 108000, N'Active'),
(1957, 830, 162, 1, 33, 75000, N'Active'),
(1958, 830, 162, 1, 34, 75000, N'Active'),
(1959, 831, 154, 5, 497, 144000, N'Active'),
(1960, 832, 161, 5, 463, 120000, N'Active'),
(1961, 832, 161, 5, 464, 120000, N'Active'),
(1962, 832, 161, 5, 465, 120000, N'Active'),
(1963, 832, 161, 5, 466, 120000, N'Active'),
(1964, 833, 159, 4, 397, 108000, N'Active'),
(1965, 833, 159, 4, 398, 108000, N'Active'),
(1966, 833, 159, 4, 399, 108000, N'Active'),
(1967, 834, 148, 5, 512, 144000, N'Active'),
(1968, 834, 148, 5, 513, 144000, N'Active'),
(1969, 835, 161, 5, 485, 144000, N'Active'),
(1970, 836, 148, 5, 533, 144000, N'Active'),
(1971, 836, 148, 5, 534, 144000, N'Active'),
(1972, 837, 156, 2, 126, 75000, N'Active'),
(1973, 837, 156, 2, 127, 75000, N'Active'),
(1974, 838, 161, 5, 453, 120000, N'Active'),
(1975, 838, 161, 5, 454, 120000, N'Active'),
(1976, 839, 148, 5, 523, 144000, N'Active'),
(1977, 840, 161, 5, 498, 144000, N'Active'),
(1978, 840, 161, 5, 499, 144000, N'Active'),
(1979, 840, 161, 5, 500, 144000, N'Active'),
(1980, 840, 161, 5, 501, 144000, N'Active'),
(1981, 841, 151, 2, 138, 75000, N'Active'),
(1982, 841, 151, 2, 139, 75000, N'Active'),
(1983, 842, 158, 3, 222, 75000, N'Active'),
(1984, 842, 158, 3, 223, 75000, N'Active'),
(1985, 843, 155, 4, 365, 90000, N'Active'),
(1986, 843, 155, 4, 366, 90000, N'Active'),
(1987, 843, 155, 4, 367, 90000, N'Active'),
(1988, 843, 155, 4, 368, 90000, N'Active'),
(1989, 844, 156, 2, 211, 90000, N'Active'),
(1990, 844, 156, 2, 212, 90000, N'Active'),
(1991, 845, 187, 4, 403, 108000, N'Active'),
(1992, 845, 187, 4, 404, 108000, N'Active'),
(1993, 846, 163, 3, 217, 75000, N'Active'),
(1994, 846, 163, 3, 218, 75000, N'Active'),
(1995, 846, 163, 3, 219, 75000, N'Active'),
(1996, 846, 163, 3, 220, 75000, N'Active'),
(1997, 846, 163, 3, 221, 75000, N'Active'),
(1998, 847, 161, 5, 512, 144000, N'Active'),
(1999, 847, 161, 5, 513, 144000, N'Active'),
(2000, 848, 154, 5, 514, 144000, N'Active'),
(2001, 848, 154, 5, 515, 144000, N'Active'),
(2002, 849, 156, 2, 181, 90000, N'Active'),
(2003, 850, 155, 4, 415, 90000, N'Active'),
(2004, 850, 155, 4, 416, 90000, N'Active'),
(2005, 851, 209, 3, 315, 90000, N'Active'),
(2006, 851, 209, 3, 316, 90000, N'Active'),
(2007, 852, 175, 1, 90, 90000, N'Active'),
(2008, 852, 175, 1, 91, 90000, N'Active'),
(2009, 853, 151, 2, 161, 90000, N'Active'),
(2010, 853, 151, 2, 162, 90000, N'Active'),
(2011, 854, 159, 4, 391, 108000, N'Active'),
(2012, 854, 159, 4, 392, 108000, N'Active'),
(2013, 855, 154, 5, 500, 144000, N'Active'),
(2014, 855, 154, 5, 501, 144000, N'Active'),
(2015, 855, 154, 5, 502, 144000, N'Active'),
(2016, 855, 154, 5, 503, 144000, N'Active'),
(2017, 856, 222, 5, 559, 144000, N'Active'),
(2018, 856, 222, 5, 560, 144000, N'Active'),
(2019, 857, 151, 2, 122, 75000, N'Active'),
(2020, 857, 151, 2, 123, 75000, N'Active'),
(2021, 858, 166, 5, 546, 144000, N'Active'),
(2022, 858, 166, 5, 547, 144000, N'Active'),
(2023, 859, 155, 4, 361, 90000, N'Active'),
(2024, 859, 155, 4, 362, 90000, N'Active'),
(2025, 860, 154, 5, 532, 144000, N'Active'),
(2026, 860, 154, 5, 533, 144000, N'Active'),
(2027, 860, 154, 5, 534, 144000, N'Active'),
(2028, 861, 181, 3, 241, 75000, N'Active'),
(2029, 862, 164, 2, 146, 90000, N'Active'),
(2030, 862, 164, 2, 147, 90000, N'Active'),
(2031, 863, 161, 5, 488, 144000, N'Active'),
(2032, 863, 161, 5, 489, 144000, N'Active'),
(2033, 864, 199, 4, 401, 108000, N'Active'),
(2034, 864, 199, 4, 402, 108000, N'Active'),
(2035, 864, 199, 4, 403, 108000, N'Active'),
(2036, 864, 199, 4, 404, 108000, N'Active'),
(2037, 865, 161, 5, 563, 144000, N'Active'),
(2038, 865, 161, 5, 564, 144000, N'Active'),
(2039, 866, 197, 1, 81, 90000, N'Active'),
(2040, 866, 197, 1, 82, 90000, N'Active'),
(2041, 867, 161, 5, 518, 144000, N'Active'),
(2042, 867, 161, 5, 519, 144000, N'Active'),
(2043, 867, 161, 5, 520, 144000, N'Active'),
(2044, 867, 161, 5, 521, 144000, N'Active'),
(2045, 867, 161, 5, 522, 144000, N'Active'),
(2046, 867, 161, 5, 523, 144000, N'Active'),
(2047, 868, 155, 4, 391, 90000, N'Active'),
(2048, 868, 155, 4, 392, 90000, N'Active'),
(2049, 868, 155, 4, 393, 90000, N'Active'),
(2050, 868, 155, 4, 394, 90000, N'Active'),
(2051, 869, 152, 1, 92, 90000, N'Active'),
(2052, 869, 152, 1, 93, 90000, N'Active'),
(2053, 870, 153, 3, 297, 90000, N'Active'),
(2054, 870, 153, 3, 298, 90000, N'Active'),
(2055, 871, 161, 5, 559, 144000, N'Active'),
(2056, 871, 161, 5, 560, 144000, N'Active'),
(2057, 872, 155, 4, 412, 90000, N'Active'),
(2058, 872, 155, 4, 413, 90000, N'Active'),
(2059, 872, 155, 4, 414, 90000, N'Active'),
(2060, 873, 163, 3, 305, 90000, N'Active'),
(2061, 873, 163, 3, 306, 90000, N'Active'),
(2062, 873, 163, 3, 307, 90000, N'Active'),
(2063, 873, 163, 3, 308, 90000, N'Active'),
(2064, 873, 163, 3, 309, 90000, N'Active'),
(2065, 874, 158, 3, 234, 75000, N'Active'),
(2066, 874, 158, 3, 235, 75000, N'Active'),
(2067, 875, 157, 1, 93, 90000, N'Active'),
(2068, 875, 157, 1, 94, 90000, N'Active'),
(2069, 876, 161, 5, 525, 144000, N'Cancelled'),
(2070, 876, 161, 5, 526, 144000, N'Cancelled'),
(2071, 877, 164, 2, 171, 90000, N'Active'),
(2072, 877, 164, 2, 172, 90000, N'Active'),
(2073, 877, 164, 2, 173, 90000, N'Active'),
(2074, 877, 164, 2, 174, 90000, N'Active'),
(2075, 878, 189, 5, 522, 144000, N'Active'),
(2076, 878, 189, 5, 523, 144000, N'Active'),
(2077, 878, 189, 5, 524, 144000, N'Active'),
(2078, 878, 189, 5, 525, 144000, N'Active'),
(2079, 879, 187, 4, 431, 108000, N'Active'),
(2080, 879, 187, 4, 432, 108000, N'Active'),
(2081, 880, 159, 4, 394, 108000, N'Active'),
(2082, 881, 154, 5, 517, 144000, N'Active'),
(2083, 882, 167, 1, 105, 90000, N'Active'),
(2084, 882, 167, 1, 106, 90000, N'Active'),
(2085, 883, 160, 2, 161, 90000, N'Active'),
(2086, 883, 160, 2, 162, 90000, N'Active'),
(2087, 884, 162, 1, 105, 90000, N'Active'),
(2088, 884, 162, 1, 106, 90000, N'Active'),
(2089, 885, 168, 3, 296, 90000, N'Cancelled'),
(2090, 886, 162, 1, 21, 75000, N'Active'),
(2091, 886, 162, 1, 22, 75000, N'Active'),
(2092, 886, 162, 1, 23, 75000, N'Active'),
(2093, 886, 162, 1, 24, 75000, N'Active'),
(2094, 887, 159, 4, 330, 90000, N'Cancelled'),
(2095, 887, 159, 4, 331, 90000, N'Cancelled'),
(2096, 887, 159, 4, 332, 90000, N'Cancelled'),
(2097, 887, 159, 4, 333, 90000, N'Cancelled'),
(2098, 888, 160, 2, 187, 90000, N'Active'),
(2099, 888, 160, 2, 188, 90000, N'Active'),
(2100, 889, 178, 4, 412, 108000, N'Active'),
(2101, 889, 178, 4, 413, 108000, N'Active'),
(2102, 890, 168, 3, 309, 90000, N'Active'),
(2103, 890, 168, 3, 310, 90000, N'Active'),
(2104, 890, 168, 3, 311, 90000, N'Active'),
(2105, 891, 157, 1, 22, 75000, N'Active'),
(2106, 891, 157, 1, 23, 75000, N'Active'),
(2107, 891, 157, 1, 24, 75000, N'Active'),
(2108, 892, 163, 3, 244, 75000, N'Active'),
(2109, 893, 159, 4, 380, 108000, N'Active'),
(2110, 893, 159, 4, 381, 108000, N'Active'),
(2111, 894, 161, 5, 508, 144000, N'Active'),
(2112, 894, 161, 5, 509, 144000, N'Active'),
(2113, 894, 161, 5, 510, 144000, N'Active'),
(2114, 894, 161, 5, 511, 144000, N'Active'),
(2115, 895, 167, 1, 74, 90000, N'Cancelled'),
(2116, 895, 167, 1, 75, 90000, N'Cancelled'),
(2117, 896, 159, 4, 403, 108000, N'Active'),
(2118, 896, 159, 4, 404, 108000, N'Active'),
(2119, 897, 166, 5, 563, 144000, N'Active'),
(2120, 897, 166, 5, 564, 144000, N'Active'),
(2121, 898, 162, 1, 31, 75000, N'Active'),
(2122, 898, 162, 1, 32, 75000, N'Active'),
(2123, 899, 162, 1, 81, 90000, N'Active'),
(2124, 899, 162, 1, 82, 90000, N'Active'),
(2125, 899, 162, 1, 83, 90000, N'Active'),
(2126, 900, 158, 3, 232, 75000, N'Active'),
(2127, 900, 158, 3, 233, 75000, N'Active'),
(2128, 901, 161, 5, 486, 144000, N'Active'),
(2129, 901, 161, 5, 487, 144000, N'Active'),
(2130, 902, 162, 1, 57, 90000, N'Active'),
(2131, 902, 162, 1, 58, 90000, N'Active'),
(2132, 903, 161, 5, 526, 144000, N'Active'),
(2133, 904, 166, 5, 521, 144000, N'Active'),
(2134, 904, 166, 5, 522, 144000, N'Active'),
(2135, 904, 166, 5, 523, 144000, N'Active'),
(2136, 904, 166, 5, 524, 144000, N'Active'),
(2137, 905, 167, 1, 50, 90000, N'Active'),
(2138, 905, 167, 1, 51, 90000, N'Active'),
(2139, 905, 167, 1, 52, 90000, N'Active'),
(2140, 906, 165, 4, 373, 108000, N'Active'),
(2141, 906, 165, 4, 374, 108000, N'Active'),
(2142, 906, 165, 4, 375, 108000, N'Active'),
(2143, 907, 161, 5, 550, 144000, N'Active'),
(2144, 907, 161, 5, 551, 144000, N'Active'),
(2145, 908, 163, 3, 268, 90000, N'Active'),
(2146, 908, 163, 3, 269, 90000, N'Active'),
(2147, 908, 163, 3, 270, 90000, N'Active'),
(2148, 908, 163, 3, 271, 90000, N'Active'),
(2149, 909, 161, 5, 532, 144000, N'Active'),
(2150, 909, 161, 5, 533, 144000, N'Active'),
(2151, 910, 161, 5, 534, 144000, N'Active'),
(2152, 911, 166, 5, 520, 144000, N'Active'),
(2153, 912, 168, 3, 261, 90000, N'Active'),
(2154, 912, 168, 3, 262, 90000, N'Active'),
(2155, 912, 168, 3, 263, 90000, N'Active'),
(2156, 913, 177, 3, 273, 90000, N'Active'),
(2157, 913, 177, 3, 274, 90000, N'Active'),
(2158, 913, 177, 3, 275, 90000, N'Active'),
(2159, 914, 210, 5, 553, 144000, N'Active'),
(2160, 914, 210, 5, 554, 144000, N'Active'),
(2161, 915, 165, 4, 415, 108000, N'Active'),
(2162, 915, 165, 4, 416, 108000, N'Active'),
(2163, 916, 174, 2, 209, 90000, N'Active'),
(2164, 916, 174, 2, 210, 90000, N'Active'),
(2165, 917, 163, 3, 257, 90000, N'Active'),
(2166, 917, 163, 3, 258, 90000, N'Active'),
(2167, 918, 166, 5, 532, 144000, N'Active'),
(2168, 918, 166, 5, 533, 144000, N'Active'),
(2169, 919, 162, 1, 60, 90000, N'Active'),
(2170, 920, 162, 1, 69, 90000, N'Active'),
(2171, 920, 162, 1, 70, 90000, N'Active'),
(2172, 921, 162, 1, 54, 90000, N'Active'),
(2173, 921, 162, 1, 55, 90000, N'Active'),
(2174, 922, 162, 1, 2, 75000, N'Active'),
(2175, 922, 162, 1, 3, 75000, N'Active'),
(2176, 922, 162, 1, 4, 75000, N'Active'),
(2177, 923, 161, 5, 462, 120000, N'Active'),
(2178, 924, 168, 3, 297, 90000, N'Active'),
(2179, 925, 180, 1, 14, 75000, N'Active'),
(2180, 925, 180, 1, 15, 75000, N'Active'),
(2181, 926, 218, 1, 53, 90000, N'Active'),
(2182, 926, 218, 1, 54, 90000, N'Active'),
(2183, 926, 218, 1, 55, 90000, N'Active'),
(2184, 927, 163, 3, 237, 75000, N'Active'),
(2185, 927, 163, 3, 238, 75000, N'Active'),
(2186, 928, 163, 3, 245, 75000, N'Active'),
(2187, 928, 163, 3, 246, 75000, N'Active'),
(2188, 928, 163, 3, 247, 75000, N'Active'),
(2189, 929, 165, 4, 402, 108000, N'Active'),
(2190, 930, 166, 5, 433, 120000, N'Cancelled'),
(2191, 930, 166, 5, 434, 120000, N'Cancelled'),
(2192, 931, 164, 2, 199, 90000, N'Active'),
(2193, 931, 164, 2, 200, 90000, N'Active'),
(2194, 931, 164, 2, 201, 90000, N'Active'),
(2195, 931, 164, 2, 202, 90000, N'Active'),
(2196, 932, 162, 1, 40, 90000, N'Active'),
(2197, 933, 165, 4, 392, 108000, N'Cancelled'),
(2198, 933, 165, 4, 393, 108000, N'Cancelled'),
(2199, 934, 163, 3, 275, 90000, N'Active'),
(2200, 934, 163, 3, 276, 90000, N'Active'),
(2201, 935, 166, 5, 474, 120000, N'Active'),
(2202, 935, 166, 5, 475, 120000, N'Active'),
(2203, 935, 166, 5, 476, 120000, N'Active'),
(2204, 935, 166, 5, 477, 120000, N'Active'),
(2205, 936, 159, 4, 350, 90000, N'Active'),
(2206, 936, 159, 4, 351, 90000, N'Active'),
(2207, 936, 159, 4, 352, 90000, N'Active'),
(2208, 937, 166, 5, 537, 144000, N'Cancelled'),
(2209, 937, 166, 5, 538, 144000, N'Cancelled'),
(2210, 937, 166, 5, 539, 144000, N'Cancelled'),
(2211, 937, 166, 5, 540, 144000, N'Cancelled'),
(2212, 938, 166, 5, 512, 144000, N'Active'),
(2213, 938, 166, 5, 513, 144000, N'Active'),
(2214, 939, 164, 2, 164, 90000, N'Active'),
(2215, 939, 164, 2, 165, 90000, N'Active'),
(2216, 940, 177, 3, 242, 75000, N'Active'),
(2217, 940, 177, 3, 243, 75000, N'Active'),
(2218, 941, 166, 5, 549, 144000, N'Active'),
(2219, 942, 178, 4, 354, 90000, N'Active'),
(2220, 942, 178, 4, 355, 90000, N'Active'),
(2221, 943, 165, 4, 376, 108000, N'Active'),
(2222, 943, 165, 4, 377, 108000, N'Active'),
(2223, 943, 165, 4, 378, 108000, N'Active'),
(2224, 944, 162, 1, 79, 90000, N'Active'),
(2225, 944, 162, 1, 80, 90000, N'Active'),
(2226, 945, 172, 2, 193, 90000, N'Active'),
(2227, 945, 172, 2, 194, 90000, N'Active'),
(2228, 945, 172, 2, 195, 90000, N'Active'),
(2229, 946, 163, 3, 310, 90000, N'Active'),
(2230, 946, 163, 3, 311, 90000, N'Active'),
(2231, 947, 191, 3, 286, 90000, N'Active'),
(2232, 948, 165, 4, 386, 108000, N'Active'),
(2233, 948, 165, 4, 387, 108000, N'Active'),
(2234, 949, 164, 2, 177, 90000, N'Active'),
(2235, 950, 164, 2, 134, 75000, N'Active'),
(2236, 950, 164, 2, 135, 75000, N'Active'),
(2237, 951, 163, 3, 251, 75000, N'Active'),
(2238, 951, 163, 3, 252, 75000, N'Active'),
(2239, 952, 166, 5, 487, 144000, N'Active'),
(2240, 952, 166, 5, 488, 144000, N'Active'),
(2241, 952, 166, 5, 489, 144000, N'Active'),
(2242, 952, 166, 5, 490, 144000, N'Active'),
(2243, 952, 166, 5, 491, 144000, N'Active'),
(2244, 953, 166, 5, 463, 120000, N'Active'),
(2245, 953, 166, 5, 464, 120000, N'Active'),
(2246, 953, 166, 5, 465, 120000, N'Active'),
(2247, 954, 186, 3, 237, 75000, N'Active'),
(2248, 954, 186, 3, 238, 75000, N'Active'),
(2249, 954, 186, 3, 239, 75000, N'Active'),
(2250, 954, 186, 3, 240, 75000, N'Active'),
(2251, 955, 176, 5, 536, 144000, N'Active'),
(2252, 955, 176, 5, 537, 144000, N'Active'),
(2253, 956, 188, 2, 162, 90000, N'Active'),
(2254, 956, 188, 2, 163, 90000, N'Active'),
(2255, 957, 165, 4, 367, 108000, N'Active'),
(2256, 958, 164, 2, 136, 75000, N'Active'),
(2257, 958, 164, 2, 137, 75000, N'Active'),
(2258, 958, 164, 2, 138, 75000, N'Active'),
(2259, 958, 164, 2, 139, 75000, N'Active'),
(2260, 959, 186, 3, 319, 90000, N'Active'),
(2261, 959, 186, 3, 320, 90000, N'Active'),
(2262, 960, 167, 1, 54, 90000, N'Active'),
(2263, 960, 167, 1, 55, 90000, N'Active'),
(2264, 961, 166, 5, 557, 144000, N'Active'),
(2265, 961, 166, 5, 558, 144000, N'Active'),
(2266, 962, 167, 1, 74, 90000, N'Active'),
(2267, 962, 167, 1, 75, 90000, N'Active'),
(2268, 963, 165, 4, 403, 108000, N'Active'),
(2269, 964, 195, 1, 79, 90000, N'Active'),
(2270, 964, 195, 1, 80, 90000, N'Active'),
(2271, 964, 195, 1, 81, 90000, N'Active'),
(2272, 964, 195, 1, 82, 90000, N'Active'),
(2273, 964, 195, 1, 83, 90000, N'Active'),
(2274, 965, 222, 5, 439, 120000, N'Active'),
(2275, 965, 222, 5, 440, 120000, N'Active'),
(2276, 966, 166, 5, 555, 144000, N'Active'),
(2277, 966, 166, 5, 556, 144000, N'Active'),
(2278, 967, 165, 4, 355, 90000, N'Active'),
(2279, 967, 165, 4, 356, 90000, N'Active'),
(2280, 967, 165, 4, 357, 90000, N'Active'),
(2281, 967, 165, 4, 358, 90000, N'Active'),
(2282, 967, 165, 4, 359, 90000, N'Active'),
(2283, 967, 165, 4, 360, 90000, N'Active'),
(2284, 968, 191, 3, 307, 90000, N'Active'),
(2285, 968, 191, 3, 308, 90000, N'Active'),
(2286, 968, 191, 3, 309, 90000, N'Active'),
(2287, 969, 192, 2, 195, 90000, N'Active'),
(2288, 969, 192, 2, 196, 90000, N'Active'),
(2289, 969, 192, 2, 197, 90000, N'Active'),
(2290, 969, 192, 2, 198, 90000, N'Active'),
(2291, 970, 181, 3, 258, 90000, N'Active'),
(2292, 970, 181, 3, 259, 90000, N'Active'),
(2293, 971, 176, 5, 531, 144000, N'Active'),
(2294, 971, 176, 5, 532, 144000, N'Active'),
(2295, 971, 176, 5, 533, 144000, N'Active'),
(2296, 971, 176, 5, 534, 144000, N'Active'),
(2297, 971, 176, 5, 535, 144000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 2 16/11/2026: 117 hoa don (3 huy), 263 ve, doanh thu 25.861.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(972, 5, NULL, '2026-11-16T08:13:18', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 169 | Bò Sữa Bay | 16/11 09:00 | Phòng 1 | J7 J8
(973, 6, 70, '2026-11-16T08:19:53', 720000, N'Paid', N'Transfer', NULL, 50, 0, NULL, NULL, NULL), -- suat 170 | Dune: Hành Tinh Cát | 16/11 09:00 | Phòng 5 | K8 K9 K10 K11 K12
(974, 5, NULL, '2026-11-16T08:27:07', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 169 | Bò Sữa Bay | 16/11 09:00 | Phòng 1 | G7 G8
(975, 6, NULL, '2026-11-16T08:28:30', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 172 | Kiến Lé Phiêu Lưu Ké | 16/11 09:30 | Phòng 2 | A5 A6
(976, 6, NULL, '2026-11-16T09:18:10', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 173 | Bí Kíp Luyện Cướp | 16/11 10:00 | Phòng 3 | F3 F4
(977, 5, NULL, '2026-11-16T09:28:33', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 173 | Bí Kíp Luyện Cướp | 16/11 10:00 | Phòng 3 | J7 J8
(978, 6, NULL, '2026-11-16T09:37:11', 108000, N'Paid', N'Cash', 110000, 0, 0, NULL, NULL, NULL), -- suat 178 | Godzilla Trừ Không | 16/11 12:30 | Phòng 4 | E12
(979, 6, 44, '2026-11-16T09:39:35', 216000, N'Paid', N'Cash', 250000, 21, 0, NULL, NULL, NULL), -- suat 206 | Godzilla Trừ Không | 17/11 12:30 | Phòng 4 | J3 J4
(980, 6, NULL, '2026-11-16T09:43:36', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 180 | Chị Chị Em Em 3 | 16/11 14:00 | Phòng 1 | F11 F12
(981, 6, 72, '2026-11-16T09:53:50', 216000, N'Paid', N'Cash', 216000, 15, 0, NULL, NULL, NULL), -- suat 178 | Godzilla Trừ Không | 16/11 12:30 | Phòng 4 | F6 F7
(982, 5, NULL, '2026-11-16T10:31:09', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 186 | Clayface | 16/11 17:00 | Phòng 3 | E1 E2
(983, 6, NULL, '2026-11-16T10:48:20', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 179 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 16/11 13:30 | Phòng 2 | F4 F5 F6
(984, 5, NULL, '2026-11-16T10:50:28', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 191 | Ngày Con Còn Mẹ | 16/11 19:15 | Phòng 3 | G9 G10 G11
(985, 6, NULL, '2026-11-16T10:57:04', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 188 | Trại Buôn Người | 16/11 18:00 | Phòng 2 | B6 B7
(986, 5, NULL, '2026-11-16T10:59:56', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 174 | Chàng Mèo Mang Mũ | 16/11 11:15 | Phòng 2 | H10 H11
(987, 6, NULL, '2026-11-16T11:01:14', 300000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 177 | Kẻ Hồi Sinh | 16/11 12:30 | Phòng 3 | B2 B3 B4 B5
(988, 6, NULL, '2026-11-16T11:01:21', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 177 | Kẻ Hồi Sinh | 16/11 12:30 | Phòng 3 | D7
(989, 6, NULL, '2026-11-16T11:02:04', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 232 | Godzilla Trừ Không | 18/11 12:15 | Phòng 5 | J5
(990, 5, NULL, '2026-11-16T11:05:55', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 189 | Godzilla Trừ Không | 16/11 18:15 | Phòng 5 | K5 K6
(991, 5, NULL, '2026-11-16T11:08:01', 216000, N'Cancelled', N'Cash', 216000, 0, 0, N'Nhầm suất / ghế', '2026-11-16T11:32:19', 5), -- suat 227 | Ramayana: Khởi Nguồn Một Huyền Thoại | 18/11 09:15 | Phòng 4 | J3 J4
(992, 5, NULL, '2026-11-16T11:15:00', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 188 | Trại Buôn Người | 16/11 18:00 | Phòng 2 | G9 G10
(993, 5, 2, '2026-11-16T11:15:33', 240000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 189 | Godzilla Trừ Không | 16/11 18:15 | Phòng 5 | D9 D10
(994, 5, 120, '2026-11-16T11:17:27', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 184 | Ngày Con Còn Mẹ | 16/11 15:30 | Phòng 2 | H5 H6
(995, 6, NULL, '2026-11-16T11:28:09', 648000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 249 | Godzilla Trừ Không | 18/11 21:00 | Phòng 4 | E4 E5 E6 E7 E8 E9
(996, 5, NULL, '2026-11-16T11:37:16', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 179 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 16/11 13:30 | Phòng 2 | D9 D10
(997, 5, 53, '2026-11-16T11:39:20', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 186 | Clayface | 16/11 17:00 | Phòng 3 | G6 G7
(998, 5, NULL, '2026-11-16T11:48:40', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 182 | Dune: Hành Tinh Cát | 16/11 15:00 | Phòng 5 | L5 L6
(999, 5, NULL, '2026-11-16T11:48:53', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | G1 G2
(1000, 5, NULL, '2026-11-16T11:57:16', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 206 | Godzilla Trừ Không | 17/11 12:30 | Phòng 4 | A10
(1001, 5, NULL, '2026-11-16T11:59:35', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 184 | Ngày Con Còn Mẹ | 16/11 15:30 | Phòng 2 | E7 E8
(1002, 6, 75, '2026-11-16T12:03:07', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 183 | Bí Kíp Luyện Cướp | 16/11 15:15 | Phòng 4 | F9 F10
(1003, 5, 9, '2026-11-16T12:06:02', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 180 | Chị Chị Em Em 3 | 16/11 14:00 | Phòng 1 | E5 E6 E7
(1004, 6, NULL, '2026-11-16T12:09:58', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 205 | Kẻ Hồi Sinh | 17/11 12:30 | Phòng 3 | D2
(1005, 6, NULL, '2026-11-16T12:10:13', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 186 | Clayface | 16/11 17:00 | Phòng 3 | D2 D3
(1006, 5, 93, '2026-11-16T12:10:13', 144000, N'Paid', N'Card', NULL, 10, 0, NULL, NULL, NULL), -- suat 189 | Godzilla Trừ Không | 16/11 18:15 | Phòng 5 | G9
(1007, 5, NULL, '2026-11-16T12:20:02', 324000, N'Paid', N'Cash', 324000, 0, 0, NULL, NULL, NULL), -- suat 187 | Ramayana: Khởi Nguồn Một Huyền Thoại | 16/11 17:45 | Phòng 4 | E7 E8 E9
(1008, 6, NULL, '2026-11-16T12:28:13', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 181 | Thiên Đường Tăm Tối | 16/11 14:45 | Phòng 3 | B10
(1009, 5, NULL, '2026-11-16T12:32:08', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 185 | Bò Sữa Bay | 16/11 16:30 | Phòng 1 | G3 G4
(1010, 5, NULL, '2026-11-16T12:35:03', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 189 | Godzilla Trừ Không | 16/11 18:15 | Phòng 5 | G6 G7
(1011, 6, 78, '2026-11-16T12:42:53', 144000, N'Paid', N'Transfer', NULL, 10, 0, NULL, NULL, NULL), -- suat 182 | Dune: Hành Tinh Cát | 16/11 15:00 | Phòng 5 | J12
(1012, 5, NULL, '2026-11-16T12:43:12', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | G5 G6
(1013, 5, NULL, '2026-11-16T12:46:47', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 181 | Thiên Đường Tăm Tối | 16/11 14:45 | Phòng 3 | D8 D9
(1014, 5, NULL, '2026-11-16T13:00:13', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 188 | Trại Buôn Người | 16/11 18:00 | Phòng 2 | H10
(1015, 5, NULL, '2026-11-16T13:01:16', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 187 | Ramayana: Khởi Nguồn Một Huyền Thoại | 16/11 17:45 | Phòng 4 | C6 C7
(1016, 6, 75, '2026-11-16T13:08:17', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 189 | Godzilla Trừ Không | 16/11 18:15 | Phòng 5 | G1 G2
(1017, 6, 25, '2026-11-16T13:11:17', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 190 | Ngày Con Còn Mẹ | 16/11 19:00 | Phòng 1 | J7 J8
(1018, 5, NULL, '2026-11-16T13:13:04', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 186 | Clayface | 16/11 17:00 | Phòng 3 | G8 G9 G10 G11
(1019, 5, NULL, '2026-11-16T13:19:22', 144000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 189 | Godzilla Trừ Không | 16/11 18:15 | Phòng 5 | J4
(1020, 6, 17, '2026-11-16T13:48:51', 540000, N'Paid', N'Transfer', NULL, 37, 0, NULL, NULL, NULL), -- suat 193 | Godzilla Trừ Không | 16/11 21:00 | Phòng 4 | G4 G5 G6 G7 G8
(1021, 5, 89, '2026-11-16T13:51:41', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 185 | Bò Sữa Bay | 16/11 16:30 | Phòng 1 | D4 D5
(1022, 5, NULL, '2026-11-16T13:56:14', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 194 | Dune: Hành Tinh Cát | 16/11 21:00 | Phòng 5 | L1 L2
(1023, 6, NULL, '2026-11-16T14:07:59', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 195 | Chị Chị Em Em 3 | 16/11 21:30 | Phòng 1 | G5 G6
(1024, 5, NULL, '2026-11-16T14:12:26', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 190 | Ngày Con Còn Mẹ | 16/11 19:00 | Phòng 1 | E8 E9
(1025, 5, NULL, '2026-11-16T14:17:34', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 191 | Ngày Con Còn Mẹ | 16/11 19:15 | Phòng 3 | C8 C9
(1026, 5, NULL, '2026-11-16T14:19:43', 216000, N'Paid', N'Cash', 220000, 0, 0, NULL, NULL, NULL), -- suat 187 | Ramayana: Khởi Nguồn Một Huyền Thoại | 16/11 17:45 | Phòng 4 | J9 J10
(1027, 6, 99, '2026-11-16T14:25:38', 180000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 186 | Clayface | 16/11 17:00 | Phòng 3 | J5 J6
(1028, 6, NULL, '2026-11-16T14:25:41', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 187 | Ramayana: Khởi Nguồn Một Huyền Thoại | 16/11 17:45 | Phòng 4 | D1 D2
(1029, 5, NULL, '2026-11-16T14:41:55', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 213 | Bò Sữa Bay | 17/11 16:30 | Phòng 1 | B5 B6
(1030, 5, NULL, '2026-11-16T14:43:56', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 185 | Bò Sữa Bay | 16/11 16:30 | Phòng 1 | G7 G8 G9
(1031, 5, NULL, '2026-11-16T14:44:42', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 185 | Bò Sữa Bay | 16/11 16:30 | Phòng 1 | J9 J10
(1032, 5, NULL, '2026-11-16T14:51:49', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 190 | Ngày Con Còn Mẹ | 16/11 19:00 | Phòng 1 | E6
(1033, 8, 28, '2026-11-16T15:00:49', 432000, N'Paid', N'Cash', 440000, 30, 0, NULL, NULL, NULL), -- suat 206 | Godzilla Trừ Không | 17/11 12:30 | Phòng 4 | G4 G5 G6 G7
(1034, 7, NULL, '2026-11-16T15:03:19', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 191 | Ngày Con Còn Mẹ | 16/11 19:15 | Phòng 3 | E9 E10
(1035, 8, NULL, '2026-11-16T15:06:59', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 194 | Dune: Hành Tinh Cát | 16/11 21:00 | Phòng 5 | H7
(1036, 7, NULL, '2026-11-16T15:11:51', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 186 | Clayface | 16/11 17:00 | Phòng 3 | E3 E4
(1037, 7, NULL, '2026-11-16T15:14:08', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 189 | Godzilla Trừ Không | 16/11 18:15 | Phòng 5 | F2 F3 F4 F5
(1038, 7, NULL, '2026-11-16T15:14:57', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 185 | Bò Sữa Bay | 16/11 16:30 | Phòng 1 | B4 B5
(1039, 8, NULL, '2026-11-16T15:15:59', 288000, N'Cancelled', N'Cash', 300000, 0, 0, N'Nhầm suất / ghế', '2026-11-16T15:30:52', 8), -- suat 189 | Godzilla Trừ Không | 16/11 18:15 | Phòng 5 | H4 H5
(1040, 8, NULL, '2026-11-16T15:17:01', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 187 | Ramayana: Khởi Nguồn Một Huyền Thoại | 16/11 17:45 | Phòng 4 | H6 H7
(1041, 7, NULL, '2026-11-16T15:25:54', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 190 | Ngày Con Còn Mẹ | 16/11 19:00 | Phòng 1 | G5 G6
(1042, 8, 90, '2026-11-16T15:28:07', 432000, N'Paid', N'Transfer', NULL, 30, 0, NULL, NULL, NULL), -- suat 193 | Godzilla Trừ Không | 16/11 21:00 | Phòng 4 | E1 E2 E3 E4
(1043, 7, NULL, '2026-11-16T15:29:36', 108000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 187 | Ramayana: Khởi Nguồn Một Huyền Thoại | 16/11 17:45 | Phòng 4 | F3
(1044, 7, NULL, '2026-11-16T15:40:27', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 189 | Godzilla Trừ Không | 16/11 18:15 | Phòng 5 | E11 E12
(1045, 8, NULL, '2026-11-16T15:56:18', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 191 | Ngày Con Còn Mẹ | 16/11 19:15 | Phòng 3 | A8 A9 A10
(1046, 8, NULL, '2026-11-16T15:59:21', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 192 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 16/11 20:45 | Phòng 2 | J5 J6
(1047, 8, 66, '2026-11-16T16:00:54', 352000, N'Paid', N'Cash', 500000, 24, 80, NULL, NULL, NULL), -- suat 189 | Godzilla Trừ Không | 16/11 18:15 | Phòng 5 | H3 H4 H5
(1048, 7, 98, '2026-11-16T16:01:53', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 201 | Bí Kíp Luyện Cướp | 17/11 10:00 | Phòng 3 | F3 F4 F5 F6
(1049, 8, 15, '2026-11-16T16:03:18', 180000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 192 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 16/11 20:45 | Phòng 2 | J9 J10
(1050, 8, NULL, '2026-11-16T16:06:41', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 188 | Trại Buôn Người | 16/11 18:00 | Phòng 2 | E3 E4
(1051, 7, NULL, '2026-11-16T16:08:11', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 191 | Ngày Con Còn Mẹ | 16/11 19:15 | Phòng 3 | H10
(1052, 7, 108, '2026-11-16T16:11:24', 864000, N'Paid', N'Cash', 900000, 60, 0, NULL, NULL, NULL), -- suat 194 | Dune: Hành Tinh Cát | 16/11 21:00 | Phòng 5 | J7 J8 J9 J10 J11 J12
(1053, 8, NULL, '2026-11-16T16:17:46', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 228 | Kiến Lé Phiêu Lưu Ké | 18/11 09:30 | Phòng 2 | E6 E7
(1054, 7, 89, '2026-11-16T16:19:59', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 213 | Bò Sữa Bay | 17/11 16:30 | Phòng 1 | H3 H4
(1055, 7, NULL, '2026-11-16T16:25:38', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 190 | Ngày Con Còn Mẹ | 16/11 19:00 | Phòng 1 | F6 F7
(1056, 8, NULL, '2026-11-16T16:36:59', 216000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 193 | Godzilla Trừ Không | 16/11 21:00 | Phòng 4 | J3 J4
(1057, 7, NULL, '2026-11-16T16:37:30', 225000, N'Paid', N'Cash', 230000, 0, 0, NULL, NULL, NULL), -- suat 191 | Ngày Con Còn Mẹ | 16/11 19:15 | Phòng 3 | B8 B9 B10
(1058, 8, NULL, '2026-11-16T16:46:01', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 192 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 16/11 20:45 | Phòng 2 | E3 E4
(1059, 7, NULL, '2026-11-16T17:02:24', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 189 | Godzilla Trừ Không | 16/11 18:15 | Phòng 5 | J7 J8 J9
(1060, 8, NULL, '2026-11-16T17:03:02', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 252 | Trại Giam Hạnh Phúc | 18/11 21:30 | Phòng 3 | G7 G8 G9 G10
(1061, 7, NULL, '2026-11-16T17:03:12', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 193 | Godzilla Trừ Không | 16/11 21:00 | Phòng 4 | C8 C9
(1062, 7, 117, '2026-11-16T17:11:49', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 191 | Ngày Con Còn Mẹ | 16/11 19:15 | Phòng 3 | E11 E12
(1063, 7, 120, '2026-11-16T17:15:30', 150000, N'Paid', N'Cash', 150000, 10, 30, NULL, NULL, NULL), -- suat 219 | Ngày Con Còn Mẹ | 17/11 19:15 | Phòng 3 | F7 F8
(1064, 7, NULL, '2026-11-16T17:26:46', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 190 | Ngày Con Còn Mẹ | 16/11 19:00 | Phòng 1 | E10 E11
(1065, 8, NULL, '2026-11-16T17:28:40', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 236 | Trại Giam Hạnh Phúc | 18/11 14:00 | Phòng 1 | F4 F5 F6
(1066, 7, NULL, '2026-11-16T17:31:10', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 249 | Godzilla Trừ Không | 18/11 21:00 | Phòng 4 | D11 D12
(1067, 7, 26, '2026-11-16T17:36:32', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 190 | Ngày Con Còn Mẹ | 16/11 19:00 | Phòng 1 | H7 H8
(1068, 8, 33, '2026-11-16T17:43:53', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 194 | Dune: Hành Tinh Cát | 16/11 21:00 | Phòng 5 | E8 E9
(1069, 8, 32, '2026-11-16T17:45:42', 497000, N'Cancelled', N'Transfer', NULL, 34, 43, N'Lỗi thanh toán', '2026-11-16T18:05:06', 8), -- suat 196 | Bí Kíp Luyện Cướp | 16/11 21:30 | Phòng 3 | D5 D6 D7 D8 D9 D10
(1070, 7, NULL, '2026-11-16T17:53:32', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 193 | Godzilla Trừ Không | 16/11 21:00 | Phòng 4 | J9 J10
(1071, 8, NULL, '2026-11-16T17:57:00', 108000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 215 | Ramayana: Khởi Nguồn Một Huyền Thoại | 17/11 17:45 | Phòng 4 | H4
(1072, 8, NULL, '2026-11-16T18:05:37', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 208 | Chị Chị Em Em 3 | 17/11 14:00 | Phòng 1 | F8
(1073, 7, 110, '2026-11-16T18:20:12', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 190 | Ngày Con Còn Mẹ | 16/11 19:00 | Phòng 1 | G1
(1074, 8, NULL, '2026-11-16T18:27:27', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 222 | Dune: Hành Tinh Cát | 17/11 21:00 | Phòng 5 | D3 D4 D5
(1075, 8, NULL, '2026-11-16T18:32:04', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 195 | Chị Chị Em Em 3 | 16/11 21:30 | Phòng 1 | D7 D8 D9 D10
(1076, 7, NULL, '2026-11-16T18:45:07', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 195 | Chị Chị Em Em 3 | 16/11 21:30 | Phòng 1 | D4 D5
(1077, 7, NULL, '2026-11-16T18:49:03', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 196 | Bí Kíp Luyện Cướp | 16/11 21:30 | Phòng 3 | H5 H6 H7 H8
(1078, 8, NULL, '2026-11-16T19:02:10', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 204 | Godzilla Trừ Không | 17/11 12:15 | Phòng 5 | K10 K11 K12
(1079, 7, NULL, '2026-11-16T19:07:41', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 202 | Chàng Mèo Mang Mũ | 17/11 11:15 | Phòng 2 | G7
(1080, 7, 4, '2026-11-16T19:33:36', 288000, N'Paid', N'Card', NULL, 28, 0, NULL, NULL, NULL), -- suat 194 | Dune: Hành Tinh Cát | 16/11 21:00 | Phòng 5 | L9 L10
(1081, 7, 70, '2026-11-16T19:35:26', 240000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 194 | Dune: Hành Tinh Cát | 16/11 21:00 | Phòng 5 | D5 D6
(1082, 7, NULL, '2026-11-16T19:36:37', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 194 | Dune: Hành Tinh Cát | 16/11 21:00 | Phòng 5 | L5 L6
(1083, 7, NULL, '2026-11-16T19:40:14', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 196 | Bí Kíp Luyện Cướp | 16/11 21:30 | Phòng 3 | C7 C8
(1084, 7, NULL, '2026-11-16T20:10:05', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 241 | Bò Sữa Bay | 18/11 16:30 | Phòng 1 | G6 G7
(1085, 8, NULL, '2026-11-16T20:26:12', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 213 | Bò Sữa Bay | 17/11 16:30 | Phòng 1 | D6
(1086, 8, NULL, '2026-11-16T20:32:25', 240000, N'Paid', N'Cash', 240000, 0, 0, NULL, NULL, NULL), -- suat 222 | Dune: Hành Tinh Cát | 17/11 21:00 | Phòng 5 | C6 C7
(1087, 8, 98, '2026-11-16T21:05:29', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 237 | Thiên Đường Tăm Tối | 18/11 14:45 | Phòng 3 | G3 G4
(1088, 7, NULL, '2026-11-16T21:30:33', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL); -- suat 201 | Bí Kíp Luyện Cướp | 17/11 10:00 | Phòng 3 | F10 F11
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(2298, 972, 169, 1, 103, 90000, N'Active'),
(2299, 972, 169, 1, 104, 90000, N'Active'),
(2300, 973, 170, 5, 548, 144000, N'Active'),
(2301, 973, 170, 5, 549, 144000, N'Active'),
(2302, 973, 170, 5, 550, 144000, N'Active'),
(2303, 973, 170, 5, 551, 144000, N'Active'),
(2304, 973, 170, 5, 552, 144000, N'Active'),
(2305, 974, 169, 1, 79, 90000, N'Active'),
(2306, 974, 169, 1, 80, 90000, N'Active'),
(2307, 975, 172, 2, 113, 75000, N'Active'),
(2308, 975, 172, 2, 114, 75000, N'Active'),
(2309, 976, 173, 3, 279, 90000, N'Active'),
(2310, 976, 173, 3, 280, 90000, N'Active'),
(2311, 977, 173, 3, 319, 90000, N'Active'),
(2312, 977, 173, 3, 320, 90000, N'Active'),
(2313, 978, 178, 4, 384, 108000, N'Active'),
(2314, 979, 206, 4, 423, 108000, N'Active'),
(2315, 979, 206, 4, 424, 108000, N'Active'),
(2316, 980, 180, 1, 71, 90000, N'Active'),
(2317, 980, 180, 1, 72, 90000, N'Active'),
(2318, 981, 178, 4, 390, 108000, N'Active'),
(2319, 981, 178, 4, 391, 108000, N'Active'),
(2320, 982, 186, 3, 265, 90000, N'Active'),
(2321, 982, 186, 3, 266, 90000, N'Active'),
(2322, 983, 179, 2, 172, 90000, N'Active'),
(2323, 983, 179, 2, 173, 90000, N'Active'),
(2324, 983, 179, 2, 174, 90000, N'Active'),
(2325, 984, 191, 3, 297, 90000, N'Active'),
(2326, 984, 191, 3, 298, 90000, N'Active'),
(2327, 984, 191, 3, 299, 90000, N'Active'),
(2328, 985, 188, 2, 126, 75000, N'Active'),
(2329, 985, 188, 2, 127, 75000, N'Active'),
(2330, 986, 174, 2, 202, 90000, N'Active'),
(2331, 986, 174, 2, 203, 90000, N'Active'),
(2332, 987, 177, 3, 230, 75000, N'Active'),
(2333, 987, 177, 3, 231, 75000, N'Active'),
(2334, 987, 177, 3, 232, 75000, N'Active'),
(2335, 987, 177, 3, 233, 75000, N'Active'),
(2336, 988, 177, 3, 259, 90000, N'Active'),
(2337, 989, 232, 5, 533, 144000, N'Active'),
(2338, 990, 189, 5, 545, 144000, N'Active'),
(2339, 990, 189, 5, 546, 144000, N'Active'),
(2340, 991, 227, 4, 423, 108000, N'Cancelled'),
(2341, 991, 227, 4, 424, 108000, N'Cancelled'),
(2342, 992, 188, 2, 189, 90000, N'Active'),
(2343, 992, 188, 2, 190, 90000, N'Active'),
(2344, 993, 189, 5, 477, 120000, N'Active'),
(2345, 993, 189, 5, 478, 120000, N'Active'),
(2346, 994, 184, 2, 197, 90000, N'Active'),
(2347, 994, 184, 2, 198, 90000, N'Active'),
(2348, 995, 249, 4, 376, 108000, N'Active'),
(2349, 995, 249, 4, 377, 108000, N'Active'),
(2350, 995, 249, 4, 378, 108000, N'Active'),
(2351, 995, 249, 4, 379, 108000, N'Active'),
(2352, 995, 249, 4, 380, 108000, N'Active'),
(2353, 995, 249, 4, 381, 108000, N'Active'),
(2354, 996, 179, 2, 153, 90000, N'Active'),
(2355, 996, 179, 2, 154, 90000, N'Active'),
(2356, 997, 186, 3, 294, 90000, N'Active'),
(2357, 997, 186, 3, 295, 90000, N'Active'),
(2358, 998, 182, 5, 557, 144000, N'Active'),
(2359, 998, 182, 5, 558, 144000, N'Active'),
(2360, 999, 246, 1, 73, 90000, N'Active'),
(2361, 999, 246, 1, 74, 90000, N'Active'),
(2362, 1000, 206, 4, 334, 90000, N'Active'),
(2363, 1001, 184, 2, 163, 90000, N'Active'),
(2364, 1001, 184, 2, 164, 90000, N'Active'),
(2365, 1002, 183, 4, 393, 90000, N'Active'),
(2366, 1002, 183, 4, 394, 90000, N'Active'),
(2367, 1003, 180, 1, 53, 90000, N'Active'),
(2368, 1003, 180, 1, 54, 90000, N'Active'),
(2369, 1003, 180, 1, 55, 90000, N'Active'),
(2370, 1004, 205, 3, 254, 90000, N'Active'),
(2371, 1005, 186, 3, 254, 90000, N'Active'),
(2372, 1005, 186, 3, 255, 90000, N'Active'),
(2373, 1006, 189, 5, 513, 144000, N'Active'),
(2374, 1007, 187, 4, 379, 108000, N'Active'),
(2375, 1007, 187, 4, 380, 108000, N'Active'),
(2376, 1007, 187, 4, 381, 108000, N'Active'),
(2377, 1008, 181, 3, 238, 75000, N'Active'),
(2378, 1009, 185, 1, 75, 90000, N'Active'),
(2379, 1009, 185, 1, 76, 90000, N'Active'),
(2380, 1010, 189, 5, 510, 144000, N'Active'),
(2381, 1010, 189, 5, 511, 144000, N'Active'),
(2382, 1011, 182, 5, 540, 144000, N'Active'),
(2383, 1012, 246, 1, 77, 90000, N'Active'),
(2384, 1012, 246, 1, 78, 90000, N'Active'),
(2385, 1013, 181, 3, 260, 90000, N'Active'),
(2386, 1013, 181, 3, 261, 90000, N'Active'),
(2387, 1014, 188, 2, 202, 90000, N'Active'),
(2388, 1015, 187, 4, 354, 90000, N'Active'),
(2389, 1015, 187, 4, 355, 90000, N'Active'),
(2390, 1016, 189, 5, 505, 144000, N'Active'),
(2391, 1016, 189, 5, 506, 144000, N'Active'),
(2392, 1017, 190, 1, 103, 90000, N'Active'),
(2393, 1017, 190, 1, 104, 90000, N'Active'),
(2394, 1018, 186, 3, 296, 90000, N'Active'),
(2395, 1018, 186, 3, 297, 90000, N'Active'),
(2396, 1018, 186, 3, 298, 90000, N'Active'),
(2397, 1018, 186, 3, 299, 90000, N'Active'),
(2398, 1019, 189, 5, 532, 144000, N'Active'),
(2399, 1020, 193, 4, 400, 108000, N'Active'),
(2400, 1020, 193, 4, 401, 108000, N'Active'),
(2401, 1020, 193, 4, 402, 108000, N'Active'),
(2402, 1020, 193, 4, 403, 108000, N'Active'),
(2403, 1020, 193, 4, 404, 108000, N'Active'),
(2404, 1021, 185, 1, 40, 90000, N'Active'),
(2405, 1021, 185, 1, 41, 90000, N'Active'),
(2406, 1022, 194, 5, 553, 144000, N'Active'),
(2407, 1022, 194, 5, 554, 144000, N'Active'),
(2408, 1023, 195, 1, 77, 90000, N'Active'),
(2409, 1023, 195, 1, 78, 90000, N'Active'),
(2410, 1024, 190, 1, 56, 90000, N'Active'),
(2411, 1024, 190, 1, 57, 90000, N'Active'),
(2412, 1025, 191, 3, 248, 75000, N'Active'),
(2413, 1025, 191, 3, 249, 75000, N'Active'),
(2414, 1026, 187, 4, 429, 108000, N'Active'),
(2415, 1026, 187, 4, 430, 108000, N'Active'),
(2416, 1027, 186, 3, 317, 90000, N'Active'),
(2417, 1027, 186, 3, 318, 90000, N'Active'),
(2418, 1028, 187, 4, 361, 108000, N'Active'),
(2419, 1028, 187, 4, 362, 108000, N'Active'),
(2420, 1029, 213, 1, 17, 75000, N'Active'),
(2421, 1029, 213, 1, 18, 75000, N'Active'),
(2422, 1030, 185, 1, 79, 90000, N'Active'),
(2423, 1030, 185, 1, 80, 90000, N'Active'),
(2424, 1030, 185, 1, 81, 90000, N'Active'),
(2425, 1031, 185, 1, 105, 90000, N'Active'),
(2426, 1031, 185, 1, 106, 90000, N'Active'),
(2427, 1032, 190, 1, 54, 90000, N'Active'),
(2428, 1033, 206, 4, 400, 108000, N'Active'),
(2429, 1033, 206, 4, 401, 108000, N'Active'),
(2430, 1033, 206, 4, 402, 108000, N'Active'),
(2431, 1033, 206, 4, 403, 108000, N'Active'),
(2432, 1034, 191, 3, 273, 90000, N'Active'),
(2433, 1034, 191, 3, 274, 90000, N'Active'),
(2434, 1035, 194, 5, 523, 144000, N'Active'),
(2435, 1036, 186, 3, 267, 90000, N'Active'),
(2436, 1036, 186, 3, 268, 90000, N'Active'),
(2437, 1037, 189, 5, 494, 144000, N'Active'),
(2438, 1037, 189, 5, 495, 144000, N'Active'),
(2439, 1037, 189, 5, 496, 144000, N'Active'),
(2440, 1037, 189, 5, 497, 144000, N'Active'),
(2441, 1038, 185, 1, 16, 75000, N'Active'),
(2442, 1038, 185, 1, 17, 75000, N'Active'),
(2443, 1039, 189, 5, 520, 144000, N'Cancelled'),
(2444, 1039, 189, 5, 521, 144000, N'Cancelled'),
(2445, 1040, 187, 4, 414, 108000, N'Active'),
(2446, 1040, 187, 4, 415, 108000, N'Active'),
(2447, 1041, 190, 1, 77, 90000, N'Active'),
(2448, 1041, 190, 1, 78, 90000, N'Active'),
(2449, 1042, 193, 4, 373, 108000, N'Active'),
(2450, 1042, 193, 4, 374, 108000, N'Active'),
(2451, 1042, 193, 4, 375, 108000, N'Active'),
(2452, 1042, 193, 4, 376, 108000, N'Active'),
(2453, 1043, 187, 4, 387, 108000, N'Active'),
(2454, 1044, 189, 5, 491, 144000, N'Active'),
(2455, 1044, 189, 5, 492, 144000, N'Active'),
(2456, 1045, 191, 3, 224, 75000, N'Active'),
(2457, 1045, 191, 3, 225, 75000, N'Active'),
(2458, 1045, 191, 3, 226, 75000, N'Active'),
(2459, 1046, 192, 2, 209, 90000, N'Active'),
(2460, 1046, 192, 2, 210, 90000, N'Active'),
(2461, 1047, 189, 5, 519, 144000, N'Active'),
(2462, 1047, 189, 5, 520, 144000, N'Active'),
(2463, 1047, 189, 5, 521, 144000, N'Active'),
(2464, 1048, 201, 3, 279, 90000, N'Active'),
(2465, 1048, 201, 3, 280, 90000, N'Active'),
(2466, 1048, 201, 3, 281, 90000, N'Active'),
(2467, 1048, 201, 3, 282, 90000, N'Active'),
(2468, 1049, 192, 2, 213, 90000, N'Active'),
(2469, 1049, 192, 2, 214, 90000, N'Active'),
(2470, 1050, 188, 2, 159, 90000, N'Active'),
(2471, 1050, 188, 2, 160, 90000, N'Active'),
(2472, 1051, 191, 3, 310, 90000, N'Active'),
(2473, 1052, 194, 5, 535, 144000, N'Active'),
(2474, 1052, 194, 5, 536, 144000, N'Active'),
(2475, 1052, 194, 5, 537, 144000, N'Active'),
(2476, 1052, 194, 5, 538, 144000, N'Active'),
(2477, 1052, 194, 5, 539, 144000, N'Active'),
(2478, 1052, 194, 5, 540, 144000, N'Active'),
(2479, 1053, 228, 2, 162, 90000, N'Active'),
(2480, 1053, 228, 2, 163, 90000, N'Active'),
(2481, 1054, 213, 1, 87, 90000, N'Active'),
(2482, 1054, 213, 1, 88, 90000, N'Active'),
(2483, 1055, 190, 1, 66, 90000, N'Active'),
(2484, 1055, 190, 1, 67, 90000, N'Active'),
(2485, 1056, 193, 4, 423, 108000, N'Active'),
(2486, 1056, 193, 4, 424, 108000, N'Active'),
(2487, 1057, 191, 3, 236, 75000, N'Active'),
(2488, 1057, 191, 3, 237, 75000, N'Active'),
(2489, 1057, 191, 3, 238, 75000, N'Active'),
(2490, 1058, 192, 2, 159, 90000, N'Active'),
(2491, 1058, 192, 2, 160, 90000, N'Active'),
(2492, 1059, 189, 5, 535, 144000, N'Active'),
(2493, 1059, 189, 5, 536, 144000, N'Active'),
(2494, 1059, 189, 5, 537, 144000, N'Active'),
(2495, 1060, 252, 3, 295, 90000, N'Active'),
(2496, 1060, 252, 3, 296, 90000, N'Active'),
(2497, 1060, 252, 3, 297, 90000, N'Active'),
(2498, 1060, 252, 3, 298, 90000, N'Active'),
(2499, 1061, 193, 4, 356, 90000, N'Active'),
(2500, 1061, 193, 4, 357, 90000, N'Active'),
(2501, 1062, 191, 3, 275, 90000, N'Active'),
(2502, 1062, 191, 3, 276, 90000, N'Active'),
(2503, 1063, 219, 3, 283, 90000, N'Active'),
(2504, 1063, 219, 3, 284, 90000, N'Active'),
(2505, 1064, 190, 1, 58, 90000, N'Active'),
(2506, 1064, 190, 1, 59, 90000, N'Active'),
(2507, 1065, 236, 1, 64, 90000, N'Active'),
(2508, 1065, 236, 1, 65, 90000, N'Active'),
(2509, 1065, 236, 1, 66, 90000, N'Active'),
(2510, 1066, 249, 4, 371, 108000, N'Active'),
(2511, 1066, 249, 4, 372, 108000, N'Active'),
(2512, 1067, 190, 1, 91, 90000, N'Active'),
(2513, 1067, 190, 1, 92, 90000, N'Active'),
(2514, 1068, 194, 5, 488, 144000, N'Active'),
(2515, 1068, 194, 5, 489, 144000, N'Active'),
(2516, 1069, 196, 3, 257, 90000, N'Cancelled'),
(2517, 1069, 196, 3, 258, 90000, N'Cancelled'),
(2518, 1069, 196, 3, 259, 90000, N'Cancelled'),
(2519, 1069, 196, 3, 260, 90000, N'Cancelled'),
(2520, 1069, 196, 3, 261, 90000, N'Cancelled'),
(2521, 1069, 196, 3, 262, 90000, N'Cancelled'),
(2522, 1070, 193, 4, 429, 108000, N'Active'),
(2523, 1070, 193, 4, 430, 108000, N'Active'),
(2524, 1071, 215, 4, 412, 108000, N'Active'),
(2525, 1072, 208, 1, 68, 90000, N'Active'),
(2526, 1073, 190, 1, 73, 90000, N'Active'),
(2527, 1074, 222, 5, 471, 120000, N'Active'),
(2528, 1074, 222, 5, 472, 120000, N'Active'),
(2529, 1074, 222, 5, 473, 120000, N'Active'),
(2530, 1075, 195, 1, 43, 90000, N'Active'),
(2531, 1075, 195, 1, 44, 90000, N'Active'),
(2532, 1075, 195, 1, 45, 90000, N'Active'),
(2533, 1075, 195, 1, 46, 90000, N'Active'),
(2534, 1076, 195, 1, 40, 90000, N'Active'),
(2535, 1076, 195, 1, 41, 90000, N'Active'),
(2536, 1077, 196, 3, 305, 90000, N'Active'),
(2537, 1077, 196, 3, 306, 90000, N'Active'),
(2538, 1077, 196, 3, 307, 90000, N'Active'),
(2539, 1077, 196, 3, 308, 90000, N'Active'),
(2540, 1078, 204, 5, 550, 144000, N'Active'),
(2541, 1078, 204, 5, 551, 144000, N'Active'),
(2542, 1078, 204, 5, 552, 144000, N'Active'),
(2543, 1079, 202, 2, 187, 90000, N'Active'),
(2544, 1080, 194, 5, 561, 144000, N'Active'),
(2545, 1080, 194, 5, 562, 144000, N'Active'),
(2546, 1081, 194, 5, 473, 120000, N'Active'),
(2547, 1081, 194, 5, 474, 120000, N'Active'),
(2548, 1082, 194, 5, 557, 144000, N'Active'),
(2549, 1082, 194, 5, 558, 144000, N'Active'),
(2550, 1083, 196, 3, 247, 75000, N'Active'),
(2551, 1083, 196, 3, 248, 75000, N'Active'),
(2552, 1084, 241, 1, 78, 90000, N'Active'),
(2553, 1084, 241, 1, 79, 90000, N'Active'),
(2554, 1085, 213, 1, 42, 90000, N'Active'),
(2555, 1086, 222, 5, 462, 120000, N'Active'),
(2556, 1086, 222, 5, 463, 120000, N'Active'),
(2557, 1087, 237, 3, 291, 90000, N'Active'),
(2558, 1087, 237, 3, 292, 90000, N'Active'),
(2559, 1088, 201, 3, 286, 90000, N'Active'),
(2560, 1088, 201, 3, 287, 90000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 3 17/11/2026: 127 hoa don (6 huy), 262 ve, doanh thu 25.226.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(1089, 9, NULL, '2026-11-17T08:05:14', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 244 | Trại Buôn Người | 18/11 18:00 | Phòng 2 | E10 E11
(1090, 8, NULL, '2026-11-17T08:08:51', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 198 | Dune: Hành Tinh Cát | 17/11 09:00 | Phòng 5 | F7 F8
(1091, 9, NULL, '2026-11-17T08:44:44', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 198 | Dune: Hành Tinh Cát | 17/11 09:00 | Phòng 5 | C8 C9
(1092, 8, 28, '2026-11-17T08:45:52', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 197 | Bò Sữa Bay | 17/11 09:00 | Phòng 1 | E6 E7
(1093, 8, NULL, '2026-11-17T08:48:40', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 207 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 17/11 13:30 | Phòng 2 | H6 H7
(1094, 8, 24, '2026-11-17T08:50:30', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 200 | Kiến Lé Phiêu Lưu Ké | 17/11 09:30 | Phòng 2 | D7 D8
(1095, 9, NULL, '2026-11-17T08:56:47', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 200 | Kiến Lé Phiêu Lưu Ké | 17/11 09:30 | Phòng 2 | G8 G9 G10 G11
(1096, 8, NULL, '2026-11-17T09:06:54', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 233 | Kẻ Hồi Sinh | 18/11 12:30 | Phòng 3 | C5 C6
(1097, 9, NULL, '2026-11-17T09:12:47', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | J9 J10
(1098, 8, NULL, '2026-11-17T09:13:56', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 201 | Bí Kíp Luyện Cướp | 17/11 10:00 | Phòng 3 | C11 C12
(1099, 9, NULL, '2026-11-17T09:14:26', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 208 | Chị Chị Em Em 3 | 17/11 14:00 | Phòng 1 | J7 J8
(1100, 9, 80, '2026-11-17T09:22:25', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 254 | Dune: Hành Tinh Cát | 19/11 09:00 | Phòng 5 | G6 G7
(1101, 8, NULL, '2026-11-17T09:33:59', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 203 | Ngày Con Còn Mẹ | 17/11 11:30 | Phòng 1 | H7 H8
(1102, 9, NULL, '2026-11-17T09:41:56', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 204 | Godzilla Trừ Không | 17/11 12:15 | Phòng 5 | G5 G6
(1103, 8, 78, '2026-11-17T09:44:34', 144000, N'Paid', N'Cash', 200000, 10, 0, NULL, NULL, NULL), -- suat 204 | Godzilla Trừ Không | 17/11 12:15 | Phòng 5 | H9
(1104, 9, NULL, '2026-11-17T10:02:45', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 215 | Ramayana: Khởi Nguồn Một Huyền Thoại | 17/11 17:45 | Phòng 4 | C11 C12
(1105, 8, NULL, '2026-11-17T10:04:09', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 252 | Trại Giam Hạnh Phúc | 18/11 21:30 | Phòng 3 | E5 E6 E7
(1106, 9, 54, '2026-11-17T10:06:01', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 248 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 18/11 20:45 | Phòng 2 | D6 D7
(1107, 9, NULL, '2026-11-17T10:06:13', 432000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 204 | Godzilla Trừ Không | 17/11 12:15 | Phòng 5 | J6 J7 J8
(1108, 9, 1, '2026-11-17T10:16:00', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 252 | Trại Giam Hạnh Phúc | 18/11 21:30 | Phòng 3 | F11
(1109, 9, NULL, '2026-11-17T10:23:35', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 202 | Chàng Mèo Mang Mũ | 17/11 11:15 | Phòng 2 | E4
(1110, 9, 48, '2026-11-17T10:26:03', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 230 | Chàng Mèo Mang Mũ | 18/11 11:15 | Phòng 2 | H5
(1111, 8, NULL, '2026-11-17T10:35:04', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 206 | Godzilla Trừ Không | 17/11 12:30 | Phòng 4 | H5 H6
(1112, 9, NULL, '2026-11-17T10:37:44', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 204 | Godzilla Trừ Không | 17/11 12:15 | Phòng 5 | H11 H12
(1113, 8, NULL, '2026-11-17T10:45:47', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 276 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 19/11 20:45 | Phòng 2 | F8 F9
(1114, 8, 78, '2026-11-17T10:49:34', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 216 | Trại Buôn Người | 17/11 18:00 | Phòng 2 | B8 B9
(1115, 9, NULL, '2026-11-17T10:50:27', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 212 | Ngày Con Còn Mẹ | 17/11 15:30 | Phòng 2 | F11 F12
(1116, 9, NULL, '2026-11-17T10:52:45', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 247 | Ngày Con Còn Mẹ | 18/11 19:15 | Phòng 3 | J7 J8
(1117, 8, 117, '2026-11-17T10:56:58', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | G8
(1118, 8, NULL, '2026-11-17T11:00:57', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 211 | Bí Kíp Luyện Cướp | 17/11 15:15 | Phòng 4 | C5 C6
(1119, 8, 86, '2026-11-17T11:03:15', 300000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 208 | Chị Chị Em Em 3 | 17/11 14:00 | Phòng 1 | B6 B7 B8 B9
(1120, 9, NULL, '2026-11-17T11:13:18', 180000, N'Cancelled', N'Cash', 200000, 0, 0, N'Khách đổi ý', '2026-11-17T11:19:31', 9), -- suat 203 | Ngày Con Còn Mẹ | 17/11 11:30 | Phòng 1 | J5 J6
(1121, 9, NULL, '2026-11-17T11:13:33', 240000, N'Paid', N'Cash', 240000, 0, 0, NULL, NULL, NULL), -- suat 210 | Dune: Hành Tinh Cát | 17/11 15:00 | Phòng 5 | A7 A8
(1122, 9, NULL, '2026-11-17T11:25:33', 75000, N'Paid', N'Cash', 75000, 0, 0, NULL, NULL, NULL), -- suat 219 | Ngày Con Còn Mẹ | 17/11 19:15 | Phòng 3 | C7
(1123, 8, NULL, '2026-11-17T11:26:33', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 211 | Bí Kíp Luyện Cướp | 17/11 15:15 | Phòng 4 | D5 D6
(1124, 9, 70, '2026-11-17T11:29:04', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 210 | Dune: Hành Tinh Cát | 17/11 15:00 | Phòng 5 | E6 E7
(1125, 9, NULL, '2026-11-17T11:30:13', 270000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-17T12:23:08', 1), -- suat 212 | Ngày Con Còn Mẹ | 17/11 15:30 | Phòng 2 | H3 H4 H5
(1126, 8, 25, '2026-11-17T11:31:58', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 261 | Kẻ Hồi Sinh | 19/11 12:30 | Phòng 3 | H6 H7
(1127, 8, 17, '2026-11-17T11:36:35', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 205 | Kẻ Hồi Sinh | 17/11 12:30 | Phòng 3 | H6
(1128, 9, NULL, '2026-11-17T11:49:28', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 272 | Trại Buôn Người | 19/11 18:00 | Phòng 2 | E7 E8 E9
(1129, 8, NULL, '2026-11-17T11:51:15', 576000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 278 | Dune: Hành Tinh Cát - Phần Hai | 19/11 21:00 | Phòng 5 | K3 K4 K5 K6
(1130, 9, NULL, '2026-11-17T11:53:32', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 215 | Ramayana: Khởi Nguồn Một Huyền Thoại | 17/11 17:45 | Phòng 4 | E7 E8
(1131, 9, NULL, '2026-11-17T12:03:04', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 264 | Trại Giam Hạnh Phúc | 19/11 14:00 | Phòng 1 | E8 E9 E10
(1132, 9, 55, '2026-11-17T12:11:14', 186000, N'Paid', N'Transfer', NULL, 13, 30, NULL, NULL, NULL), -- suat 206 | Godzilla Trừ Không | 17/11 12:30 | Phòng 4 | F6 F7
(1133, 8, NULL, '2026-11-17T12:11:17', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 215 | Ramayana: Khởi Nguồn Một Huyền Thoại | 17/11 17:45 | Phòng 4 | F6
(1134, 8, NULL, '2026-11-17T12:14:22', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 218 | Ngày Con Còn Mẹ | 17/11 19:00 | Phòng 1 | H7 H8
(1135, 9, 100, '2026-11-17T12:25:06', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 207 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 17/11 13:30 | Phòng 2 | G7
(1136, 9, NULL, '2026-11-17T12:26:47', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 221 | Godzilla Trừ Không | 17/11 21:00 | Phòng 4 | H1 H2
(1137, 8, NULL, '2026-11-17T12:30:07', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 217 | Godzilla Trừ Không | 17/11 18:15 | Phòng 5 | D2 D3
(1138, 9, 119, '2026-11-17T12:31:09', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 251 | Chị Chị Em Em 3 | 18/11 21:30 | Phòng 1 | H1 H2
(1139, 9, NULL, '2026-11-17T12:34:15', 240000, N'Paid', N'Cash', 240000, 0, 0, NULL, NULL, NULL), -- suat 210 | Dune: Hành Tinh Cát | 17/11 15:00 | Phòng 5 | C8 C9
(1140, 9, NULL, '2026-11-17T12:40:42', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 211 | Bí Kíp Luyện Cướp | 17/11 15:15 | Phòng 4 | H1 H2
(1141, 9, 108, '2026-11-17T12:40:55', 130000, N'Paid', N'Cash', 130000, 9, 140, NULL, NULL, NULL), -- suat 212 | Ngày Con Còn Mẹ | 17/11 15:30 | Phòng 2 | F2 F3 F4
(1142, 9, NULL, '2026-11-17T12:41:06', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 210 | Dune: Hành Tinh Cát | 17/11 15:00 | Phòng 5 | D6 D7 D8
(1143, 8, NULL, '2026-11-17T12:46:32', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 210 | Dune: Hành Tinh Cát | 17/11 15:00 | Phòng 5 | H7 H8
(1144, 9, NULL, '2026-11-17T12:46:55', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 214 | Clayface | 17/11 17:00 | Phòng 3 | E6
(1145, 9, NULL, '2026-11-17T12:46:55', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 217 | Godzilla Trừ Không | 17/11 18:15 | Phòng 5 | E8 E9
(1146, 9, NULL, '2026-11-17T12:47:31', 240000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 217 | Godzilla Trừ Không | 17/11 18:15 | Phòng 5 | A7 A8
(1147, 9, NULL, '2026-11-17T12:50:23', 144000, N'Cancelled', N'Cash', 150000, 0, 0, N'Nhầm suất / ghế', '2026-11-17T13:08:31', 9), -- suat 217 | Godzilla Trừ Không | 17/11 18:15 | Phòng 5 | J9
(1148, 9, NULL, '2026-11-17T13:00:37', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 239 | Bí Kíp Luyện Cướp | 18/11 15:15 | Phòng 4 | D8
(1149, 8, NULL, '2026-11-17T13:03:18', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 209 | Thiên Đường Tăm Tối | 17/11 14:45 | Phòng 3 | F10
(1150, 8, NULL, '2026-11-17T13:03:53', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 210 | Dune: Hành Tinh Cát | 17/11 15:00 | Phòng 5 | G5 G6 G7
(1151, 8, NULL, '2026-11-17T13:07:16', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 219 | Ngày Con Còn Mẹ | 17/11 19:15 | Phòng 3 | D8
(1152, 8, 3, '2026-11-17T13:09:34', 288000, N'Paid', N'Cash', 288000, 20, 0, NULL, NULL, NULL), -- suat 217 | Godzilla Trừ Không | 17/11 18:15 | Phòng 5 | G4 G5
(1153, 9, NULL, '2026-11-17T13:15:55', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 216 | Trại Buôn Người | 17/11 18:00 | Phòng 2 | C6 C7
(1154, 8, NULL, '2026-11-17T13:33:19', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 212 | Ngày Con Còn Mẹ | 17/11 15:30 | Phòng 2 | G11 G12
(1155, 9, NULL, '2026-11-17T13:55:06', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 248 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 18/11 20:45 | Phòng 2 | G1 G2
(1156, 8, 51, '2026-11-17T14:01:38', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 216 | Trại Buôn Người | 17/11 18:00 | Phòng 2 | E4 E5
(1157, 9, NULL, '2026-11-17T14:02:53', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 222 | Dune: Hành Tinh Cát | 17/11 21:00 | Phòng 5 | E2 E3
(1158, 8, NULL, '2026-11-17T14:05:18', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 212 | Ngày Con Còn Mẹ | 17/11 15:30 | Phòng 2 | G4 G5
(1159, 9, NULL, '2026-11-17T14:08:19', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 213 | Bò Sữa Bay | 17/11 16:30 | Phòng 1 | F6 F7
(1160, 9, NULL, '2026-11-17T14:11:16', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 250 | Dune: Hành Tinh Cát - Phần Hai | 18/11 21:00 | Phòng 5 | J9
(1161, 9, 42, '2026-11-17T14:15:35', 12000, N'Paid', N'Cash', 12000, 0, 168, NULL, NULL, NULL), -- suat 252 | Trại Giam Hạnh Phúc | 18/11 21:30 | Phòng 3 | F8 F9
(1162, 8, NULL, '2026-11-17T14:18:04', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 215 | Ramayana: Khởi Nguồn Một Huyền Thoại | 17/11 17:45 | Phòng 4 | G9 G10
(1163, 9, NULL, '2026-11-17T14:18:04', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 220 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 17/11 20:45 | Phòng 2 | E10 E11
(1164, 8, NULL, '2026-11-17T14:21:09', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 214 | Clayface | 17/11 17:00 | Phòng 3 | G7 G8 G9 G10
(1165, 9, NULL, '2026-11-17T14:37:45', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 218 | Ngày Con Còn Mẹ | 17/11 19:00 | Phòng 1 | E10 E11
(1166, 8, NULL, '2026-11-17T14:41:55', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 212 | Ngày Con Còn Mẹ | 17/11 15:30 | Phòng 2 | E6 E7
(1167, 8, NULL, '2026-11-17T14:51:17', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 214 | Clayface | 17/11 17:00 | Phòng 3 | E8
(1168, 3, NULL, '2026-11-17T15:03:14', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 232 | Godzilla Trừ Không | 18/11 12:15 | Phòng 5 | K6
(1169, 10, 114, '2026-11-17T15:05:37', 540000, N'Paid', N'Cash', 540000, 37, 0, NULL, NULL, NULL), -- suat 215 | Ramayana: Khởi Nguồn Một Huyền Thoại | 17/11 17:45 | Phòng 4 | G4 G5 G6 G7 G8
(1170, 3, NULL, '2026-11-17T15:07:39', 270000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 223 | Chị Chị Em Em 3 | 17/11 21:30 | Phòng 1 | D8 D9 D10
(1171, 3, NULL, '2026-11-17T15:14:01', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 216 | Trại Buôn Người | 17/11 18:00 | Phòng 2 | F5 F6
(1172, 3, 49, '2026-11-17T15:21:38', 124000, N'Paid', N'Transfer', NULL, 8, 20, NULL, NULL, NULL), -- suat 217 | Godzilla Trừ Không | 17/11 18:15 | Phòng 5 | K11
(1173, 3, NULL, '2026-11-17T15:27:11', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 224 | Bí Kíp Luyện Cướp | 17/11 21:30 | Phòng 3 | J7 J8
(1174, 3, NULL, '2026-11-17T15:33:04', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 214 | Clayface | 17/11 17:00 | Phòng 3 | H3 H4
(1175, 3, 92, '2026-11-17T15:44:39', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 223 | Chị Chị Em Em 3 | 17/11 21:30 | Phòng 1 | D12
(1176, 3, 55, '2026-11-17T15:45:21', 288000, N'Paid', N'Cash', 300000, 28, 0, NULL, NULL, NULL), -- suat 217 | Godzilla Trừ Không | 17/11 18:15 | Phòng 5 | L3 L4
(1177, 10, NULL, '2026-11-17T15:46:16', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 224 | Bí Kíp Luyện Cướp | 17/11 21:30 | Phòng 3 | D3
(1178, 10, NULL, '2026-11-17T15:47:51', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 219 | Ngày Con Còn Mẹ | 17/11 19:15 | Phòng 3 | H2 H3 H4
(1179, 3, 32, '2026-11-17T15:51:20', 150000, N'Cancelled', N'Cash', 150000, 7, 0, N'Nhầm suất / ghế', '2026-11-17T16:34:21', 3), -- suat 218 | Ngày Con Còn Mẹ | 17/11 19:00 | Phòng 1 | C11 C12
(1180, 3, 42, '2026-11-17T15:53:43', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 219 | Ngày Con Còn Mẹ | 17/11 19:15 | Phòng 3 | C10 C11
(1181, 3, NULL, '2026-11-17T15:54:26', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 220 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 17/11 20:45 | Phòng 2 | D5 D6 D7 D8
(1182, 3, NULL, '2026-11-17T15:55:39', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 216 | Trại Buôn Người | 17/11 18:00 | Phòng 2 | H4 H5
(1183, 3, NULL, '2026-11-17T16:02:45', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 219 | Ngày Con Còn Mẹ | 17/11 19:15 | Phòng 3 | E7 E8 E9 E10
(1184, 3, NULL, '2026-11-17T16:02:59', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 219 | Ngày Con Còn Mẹ | 17/11 19:15 | Phòng 3 | D3 D4 D5 D6
(1185, 3, NULL, '2026-11-17T16:09:11', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 217 | Godzilla Trừ Không | 17/11 18:15 | Phòng 5 | G10 G11 G12
(1186, 3, NULL, '2026-11-17T16:13:08', 480000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 217 | Godzilla Trừ Không | 17/11 18:15 | Phòng 5 | D5 D6 D7 D8
(1187, 10, NULL, '2026-11-17T16:21:28', 108000, N'Paid', N'Cash', 108000, 0, 0, NULL, NULL, NULL), -- suat 271 | Ramayana: Khởi Nguồn Một Huyền Thoại | 19/11 17:45 | Phòng 4 | E11
(1188, 3, NULL, '2026-11-17T16:21:53', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 218 | Ngày Con Còn Mẹ | 17/11 19:00 | Phòng 1 | B6 B7
(1189, 10, NULL, '2026-11-17T16:29:53', 480000, N'Paid', N'Cash', 480000, 0, 0, NULL, NULL, NULL), -- suat 217 | Godzilla Trừ Không | 17/11 18:15 | Phòng 5 | C8 C9 C10 C11
(1190, 3, 98, '2026-11-17T16:39:39', 216000, N'Paid', N'Transfer', NULL, 21, 0, NULL, NULL, NULL), -- suat 221 | Godzilla Trừ Không | 17/11 21:00 | Phòng 4 | J9 J10
(1191, 3, NULL, '2026-11-17T16:44:24', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 276 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 19/11 20:45 | Phòng 2 | E7
(1192, 3, NULL, '2026-11-17T17:00:00', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 223 | Chị Chị Em Em 3 | 17/11 21:30 | Phòng 1 | E8 E9
(1193, 3, 116, '2026-11-17T17:05:06', 108000, N'Paid', N'Cash', 108000, 7, 0, NULL, NULL, NULL), -- suat 243 | Ramayana: Khởi Nguồn Một Huyền Thoại | 18/11 17:45 | Phòng 4 | E11
(1194, 10, NULL, '2026-11-17T17:05:48', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 234 | Godzilla Trừ Không | 18/11 12:30 | Phòng 4 | G7 G8
(1195, 3, 10, '2026-11-17T17:17:43', 360000, N'Cancelled', N'Transfer', NULL, 25, 0, N'Khách đổi ý', '2026-11-17T17:33:01', 3), -- suat 219 | Ngày Con Còn Mẹ | 17/11 19:15 | Phòng 3 | E3 E4 E5 E6
(1196, 10, NULL, '2026-11-17T17:18:13', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 238 | Dune: Hành Tinh Cát - Phần Hai | 18/11 15:00 | Phòng 5 | G1 G2
(1197, 3, NULL, '2026-11-17T17:27:03', 216000, N'Cancelled', N'Cash', 216000, 0, 0, N'Khách đổi ý', '2026-11-17T17:49:08', 3), -- suat 271 | Ramayana: Khởi Nguồn Một Huyền Thoại | 19/11 17:45 | Phòng 4 | F9 F10
(1198, 10, NULL, '2026-11-17T17:27:27', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 224 | Bí Kíp Luyện Cướp | 17/11 21:30 | Phòng 3 | E4 E5
(1199, 3, 72, '2026-11-17T17:35:16', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 222 | Dune: Hành Tinh Cát | 17/11 21:00 | Phòng 5 | G9 G10
(1200, 10, NULL, '2026-11-17T17:35:50', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 220 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 17/11 20:45 | Phòng 2 | E5
(1201, 3, NULL, '2026-11-17T17:38:28', 75000, N'Paid', N'Cash', 80000, 0, 0, NULL, NULL, NULL), -- suat 233 | Kẻ Hồi Sinh | 18/11 12:30 | Phòng 3 | A2
(1202, 3, NULL, '2026-11-17T17:45:36', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 222 | Dune: Hành Tinh Cát | 17/11 21:00 | Phòng 5 | B2 B3
(1203, 3, 93, '2026-11-17T17:52:21', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 224 | Bí Kíp Luyện Cướp | 17/11 21:30 | Phòng 3 | G10
(1204, 10, NULL, '2026-11-17T17:55:55', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 236 | Trại Giam Hạnh Phúc | 18/11 14:00 | Phòng 1 | E5 E6 E7
(1205, 10, NULL, '2026-11-17T18:28:54', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 248 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 18/11 20:45 | Phòng 2 | J7 J8
(1206, 10, NULL, '2026-11-17T18:29:27', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 219 | Ngày Con Còn Mẹ | 17/11 19:15 | Phòng 3 | B6 B7
(1207, 10, NULL, '2026-11-17T18:43:25', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 243 | Ramayana: Khởi Nguồn Một Huyền Thoại | 18/11 17:45 | Phòng 4 | H9 H10
(1208, 3, 100, '2026-11-17T18:50:09', 78000, N'Paid', N'Cash', 100000, 5, 30, NULL, NULL, NULL), -- suat 221 | Godzilla Trừ Không | 17/11 21:00 | Phòng 4 | F6
(1209, 10, NULL, '2026-11-17T19:21:35', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 222 | Dune: Hành Tinh Cát | 17/11 21:00 | Phòng 5 | F6 F7
(1210, 10, 23, '2026-11-17T19:31:40', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 222 | Dune: Hành Tinh Cát | 17/11 21:00 | Phòng 5 | J3 J4
(1211, 3, NULL, '2026-11-17T19:33:30', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | E7 E8 E9 E10
(1212, 3, NULL, '2026-11-17T19:36:56', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 280 | Trại Giam Hạnh Phúc | 19/11 21:30 | Phòng 3 | F2 F3
(1213, 3, NULL, '2026-11-17T20:03:19', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 224 | Bí Kíp Luyện Cướp | 17/11 21:30 | Phòng 3 | E1
(1214, 3, NULL, '2026-11-17T20:08:14', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 239 | Bí Kíp Luyện Cướp | 18/11 15:15 | Phòng 4 | E4 E5
(1215, 10, 8, '2026-11-17T20:43:22', 144000, N'Paid', N'Cash', 150000, 10, 0, NULL, NULL, NULL); -- suat 250 | Dune: Hành Tinh Cát - Phần Hai | 18/11 21:00 | Phòng 5 | G5
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(2561, 1089, 244, 2, 166, 90000, N'Active'),
(2562, 1089, 244, 2, 167, 90000, N'Active'),
(2563, 1090, 198, 5, 499, 144000, N'Active'),
(2564, 1090, 198, 5, 500, 144000, N'Active'),
(2565, 1091, 198, 5, 464, 120000, N'Active'),
(2566, 1091, 198, 5, 465, 120000, N'Active'),
(2567, 1092, 197, 1, 54, 90000, N'Active'),
(2568, 1092, 197, 1, 55, 90000, N'Active'),
(2569, 1093, 207, 2, 198, 90000, N'Active'),
(2570, 1093, 207, 2, 199, 90000, N'Active'),
(2571, 1094, 200, 2, 151, 90000, N'Active'),
(2572, 1094, 200, 2, 152, 90000, N'Active'),
(2573, 1095, 200, 2, 188, 90000, N'Active'),
(2574, 1095, 200, 2, 189, 90000, N'Active'),
(2575, 1095, 200, 2, 190, 90000, N'Active'),
(2576, 1095, 200, 2, 191, 90000, N'Active'),
(2577, 1096, 233, 3, 245, 75000, N'Active'),
(2578, 1096, 233, 3, 246, 75000, N'Active'),
(2579, 1097, 246, 1, 105, 90000, N'Active'),
(2580, 1097, 246, 1, 106, 90000, N'Active'),
(2581, 1098, 201, 3, 251, 75000, N'Active'),
(2582, 1098, 201, 3, 252, 75000, N'Active'),
(2583, 1099, 208, 1, 103, 90000, N'Active'),
(2584, 1099, 208, 1, 104, 90000, N'Active'),
(2585, 1100, 254, 5, 510, 144000, N'Active'),
(2586, 1100, 254, 5, 511, 144000, N'Active'),
(2587, 1101, 203, 1, 91, 90000, N'Active'),
(2588, 1101, 203, 1, 92, 90000, N'Active'),
(2589, 1102, 204, 5, 509, 144000, N'Active'),
(2590, 1102, 204, 5, 510, 144000, N'Active'),
(2591, 1103, 204, 5, 525, 144000, N'Active'),
(2592, 1104, 215, 4, 359, 90000, N'Active'),
(2593, 1104, 215, 4, 360, 90000, N'Active'),
(2594, 1105, 252, 3, 269, 90000, N'Active'),
(2595, 1105, 252, 3, 270, 90000, N'Active'),
(2596, 1105, 252, 3, 271, 90000, N'Active'),
(2597, 1106, 248, 2, 150, 90000, N'Active'),
(2598, 1106, 248, 2, 151, 90000, N'Active'),
(2599, 1107, 204, 5, 534, 144000, N'Active'),
(2600, 1107, 204, 5, 535, 144000, N'Active'),
(2601, 1107, 204, 5, 536, 144000, N'Active'),
(2602, 1108, 252, 3, 287, 90000, N'Active'),
(2603, 1109, 202, 2, 160, 90000, N'Active'),
(2604, 1110, 230, 2, 197, 90000, N'Active'),
(2605, 1111, 206, 4, 413, 108000, N'Active'),
(2606, 1111, 206, 4, 414, 108000, N'Active'),
(2607, 1112, 204, 5, 527, 144000, N'Active'),
(2608, 1112, 204, 5, 528, 144000, N'Active'),
(2609, 1113, 276, 2, 176, 90000, N'Active'),
(2610, 1113, 276, 2, 177, 90000, N'Active'),
(2611, 1114, 216, 2, 128, 75000, N'Active'),
(2612, 1114, 216, 2, 129, 75000, N'Active'),
(2613, 1115, 212, 2, 179, 90000, N'Active'),
(2614, 1115, 212, 2, 180, 90000, N'Active'),
(2615, 1116, 247, 3, 319, 90000, N'Active'),
(2616, 1116, 247, 3, 320, 90000, N'Active'),
(2617, 1117, 246, 1, 80, 90000, N'Active'),
(2618, 1118, 211, 4, 353, 75000, N'Active'),
(2619, 1118, 211, 4, 354, 75000, N'Active'),
(2620, 1119, 208, 1, 18, 75000, N'Active'),
(2621, 1119, 208, 1, 19, 75000, N'Active'),
(2622, 1119, 208, 1, 20, 75000, N'Active'),
(2623, 1119, 208, 1, 21, 75000, N'Active'),
(2624, 1120, 203, 1, 101, 90000, N'Cancelled'),
(2625, 1120, 203, 1, 102, 90000, N'Cancelled'),
(2626, 1121, 210, 5, 439, 120000, N'Active'),
(2627, 1121, 210, 5, 440, 120000, N'Active'),
(2628, 1122, 219, 3, 247, 75000, N'Active'),
(2629, 1123, 211, 4, 365, 90000, N'Active'),
(2630, 1123, 211, 4, 366, 90000, N'Active'),
(2631, 1124, 210, 5, 486, 144000, N'Active'),
(2632, 1124, 210, 5, 487, 144000, N'Active'),
(2633, 1125, 212, 2, 195, 90000, N'Cancelled'),
(2634, 1125, 212, 2, 196, 90000, N'Cancelled'),
(2635, 1125, 212, 2, 197, 90000, N'Cancelled'),
(2636, 1126, 261, 3, 306, 90000, N'Active'),
(2637, 1126, 261, 3, 307, 90000, N'Active'),
(2638, 1127, 205, 3, 306, 90000, N'Active'),
(2639, 1128, 272, 2, 163, 90000, N'Active'),
(2640, 1128, 272, 2, 164, 90000, N'Active'),
(2641, 1128, 272, 2, 165, 90000, N'Active'),
(2642, 1129, 278, 5, 543, 144000, N'Active'),
(2643, 1129, 278, 5, 544, 144000, N'Active'),
(2644, 1129, 278, 5, 545, 144000, N'Active'),
(2645, 1129, 278, 5, 546, 144000, N'Active'),
(2646, 1130, 215, 4, 379, 108000, N'Active'),
(2647, 1130, 215, 4, 380, 108000, N'Active'),
(2648, 1131, 264, 1, 56, 90000, N'Active'),
(2649, 1131, 264, 1, 57, 90000, N'Active'),
(2650, 1131, 264, 1, 58, 90000, N'Active'),
(2651, 1132, 206, 4, 390, 108000, N'Active'),
(2652, 1132, 206, 4, 391, 108000, N'Active'),
(2653, 1133, 215, 4, 390, 108000, N'Active'),
(2654, 1134, 218, 1, 91, 90000, N'Active'),
(2655, 1134, 218, 1, 92, 90000, N'Active'),
(2656, 1135, 207, 2, 187, 90000, N'Active'),
(2657, 1136, 221, 4, 409, 108000, N'Active'),
(2658, 1136, 221, 4, 410, 108000, N'Active'),
(2659, 1137, 217, 5, 470, 120000, N'Active'),
(2660, 1137, 217, 5, 471, 120000, N'Active'),
(2661, 1138, 251, 1, 85, 90000, N'Active'),
(2662, 1138, 251, 1, 86, 90000, N'Active'),
(2663, 1139, 210, 5, 464, 120000, N'Active'),
(2664, 1139, 210, 5, 465, 120000, N'Active'),
(2665, 1140, 211, 4, 409, 90000, N'Active'),
(2666, 1140, 211, 4, 410, 90000, N'Active'),
(2667, 1141, 212, 2, 170, 90000, N'Active'),
(2668, 1141, 212, 2, 171, 90000, N'Active'),
(2669, 1141, 212, 2, 172, 90000, N'Active'),
(2670, 1142, 210, 5, 474, 120000, N'Active'),
(2671, 1142, 210, 5, 475, 120000, N'Active'),
(2672, 1142, 210, 5, 476, 120000, N'Active'),
(2673, 1143, 210, 5, 523, 144000, N'Active'),
(2674, 1143, 210, 5, 524, 144000, N'Active'),
(2675, 1144, 214, 3, 270, 90000, N'Active'),
(2676, 1145, 217, 5, 488, 144000, N'Active'),
(2677, 1145, 217, 5, 489, 144000, N'Active'),
(2678, 1146, 217, 5, 439, 120000, N'Active'),
(2679, 1146, 217, 5, 440, 120000, N'Active'),
(2680, 1147, 217, 5, 537, 144000, N'Cancelled'),
(2681, 1148, 239, 4, 368, 90000, N'Active'),
(2682, 1149, 209, 3, 286, 90000, N'Active'),
(2683, 1150, 210, 5, 509, 144000, N'Active'),
(2684, 1150, 210, 5, 510, 144000, N'Active'),
(2685, 1150, 210, 5, 511, 144000, N'Active'),
(2686, 1151, 219, 3, 260, 90000, N'Active'),
(2687, 1152, 217, 5, 508, 144000, N'Active'),
(2688, 1152, 217, 5, 509, 144000, N'Active'),
(2689, 1153, 216, 2, 138, 75000, N'Active'),
(2690, 1153, 216, 2, 139, 75000, N'Active'),
(2691, 1154, 212, 2, 191, 90000, N'Active'),
(2692, 1154, 212, 2, 192, 90000, N'Active'),
(2693, 1155, 248, 2, 181, 90000, N'Active'),
(2694, 1155, 248, 2, 182, 90000, N'Active'),
(2695, 1156, 216, 2, 160, 90000, N'Active'),
(2696, 1156, 216, 2, 161, 90000, N'Active'),
(2697, 1157, 222, 5, 482, 144000, N'Active'),
(2698, 1157, 222, 5, 483, 144000, N'Active'),
(2699, 1158, 212, 2, 184, 90000, N'Active'),
(2700, 1158, 212, 2, 185, 90000, N'Active'),
(2701, 1159, 213, 1, 66, 90000, N'Active'),
(2702, 1159, 213, 1, 67, 90000, N'Active'),
(2703, 1160, 250, 5, 537, 144000, N'Active'),
(2704, 1161, 252, 3, 284, 90000, N'Active'),
(2705, 1161, 252, 3, 285, 90000, N'Active'),
(2706, 1162, 215, 4, 405, 108000, N'Active'),
(2707, 1162, 215, 4, 406, 108000, N'Active'),
(2708, 1163, 220, 2, 166, 90000, N'Active'),
(2709, 1163, 220, 2, 167, 90000, N'Active'),
(2710, 1164, 214, 3, 295, 90000, N'Active'),
(2711, 1164, 214, 3, 296, 90000, N'Active'),
(2712, 1164, 214, 3, 297, 90000, N'Active'),
(2713, 1164, 214, 3, 298, 90000, N'Active'),
(2714, 1165, 218, 1, 58, 90000, N'Active'),
(2715, 1165, 218, 1, 59, 90000, N'Active'),
(2716, 1166, 212, 2, 162, 90000, N'Active'),
(2717, 1166, 212, 2, 163, 90000, N'Active'),
(2718, 1167, 214, 3, 272, 90000, N'Active'),
(2719, 1168, 232, 5, 546, 144000, N'Active'),
(2720, 1169, 215, 4, 400, 108000, N'Active'),
(2721, 1169, 215, 4, 401, 108000, N'Active'),
(2722, 1169, 215, 4, 402, 108000, N'Active'),
(2723, 1169, 215, 4, 403, 108000, N'Active'),
(2724, 1169, 215, 4, 404, 108000, N'Active'),
(2725, 1170, 223, 1, 44, 90000, N'Active'),
(2726, 1170, 223, 1, 45, 90000, N'Active'),
(2727, 1170, 223, 1, 46, 90000, N'Active'),
(2728, 1171, 216, 2, 173, 90000, N'Active'),
(2729, 1171, 216, 2, 174, 90000, N'Active'),
(2730, 1172, 217, 5, 551, 144000, N'Active'),
(2731, 1173, 224, 3, 319, 90000, N'Active'),
(2732, 1173, 224, 3, 320, 90000, N'Active'),
(2733, 1174, 214, 3, 303, 90000, N'Active'),
(2734, 1174, 214, 3, 304, 90000, N'Active'),
(2735, 1175, 223, 1, 48, 90000, N'Active'),
(2736, 1176, 217, 5, 555, 144000, N'Active'),
(2737, 1176, 217, 5, 556, 144000, N'Active'),
(2738, 1177, 224, 3, 255, 90000, N'Active'),
(2739, 1178, 219, 3, 302, 90000, N'Active'),
(2740, 1178, 219, 3, 303, 90000, N'Active'),
(2741, 1178, 219, 3, 304, 90000, N'Active'),
(2742, 1179, 218, 1, 35, 75000, N'Cancelled'),
(2743, 1179, 218, 1, 36, 75000, N'Cancelled'),
(2744, 1180, 219, 3, 250, 75000, N'Active'),
(2745, 1180, 219, 3, 251, 75000, N'Active'),
(2746, 1181, 220, 2, 149, 90000, N'Active'),
(2747, 1181, 220, 2, 150, 90000, N'Active'),
(2748, 1181, 220, 2, 151, 90000, N'Active'),
(2749, 1181, 220, 2, 152, 90000, N'Active'),
(2750, 1182, 216, 2, 196, 90000, N'Active'),
(2751, 1182, 216, 2, 197, 90000, N'Active'),
(2752, 1183, 219, 3, 271, 90000, N'Active'),
(2753, 1183, 219, 3, 272, 90000, N'Active'),
(2754, 1183, 219, 3, 273, 90000, N'Active'),
(2755, 1183, 219, 3, 274, 90000, N'Active'),
(2756, 1184, 219, 3, 255, 90000, N'Active'),
(2757, 1184, 219, 3, 256, 90000, N'Active'),
(2758, 1184, 219, 3, 257, 90000, N'Active'),
(2759, 1184, 219, 3, 258, 90000, N'Active'),
(2760, 1185, 217, 5, 514, 144000, N'Active'),
(2761, 1185, 217, 5, 515, 144000, N'Active'),
(2762, 1185, 217, 5, 516, 144000, N'Active'),
(2763, 1186, 217, 5, 473, 120000, N'Active'),
(2764, 1186, 217, 5, 474, 120000, N'Active'),
(2765, 1186, 217, 5, 475, 120000, N'Active'),
(2766, 1186, 217, 5, 476, 120000, N'Active'),
(2767, 1187, 271, 4, 383, 108000, N'Active'),
(2768, 1188, 218, 1, 18, 75000, N'Active'),
(2769, 1188, 218, 1, 19, 75000, N'Active'),
(2770, 1189, 217, 5, 464, 120000, N'Active'),
(2771, 1189, 217, 5, 465, 120000, N'Active'),
(2772, 1189, 217, 5, 466, 120000, N'Active'),
(2773, 1189, 217, 5, 467, 120000, N'Active'),
(2774, 1190, 221, 4, 429, 108000, N'Active'),
(2775, 1190, 221, 4, 430, 108000, N'Active'),
(2776, 1191, 276, 2, 163, 90000, N'Active'),
(2777, 1192, 223, 1, 56, 90000, N'Active'),
(2778, 1192, 223, 1, 57, 90000, N'Active'),
(2779, 1193, 243, 4, 383, 108000, N'Active'),
(2780, 1194, 234, 4, 403, 108000, N'Active'),
(2781, 1194, 234, 4, 404, 108000, N'Active'),
(2782, 1195, 219, 3, 267, 90000, N'Cancelled'),
(2783, 1195, 219, 3, 268, 90000, N'Cancelled'),
(2784, 1195, 219, 3, 269, 90000, N'Cancelled'),
(2785, 1195, 219, 3, 270, 90000, N'Cancelled'),
(2786, 1196, 238, 5, 505, 144000, N'Active'),
(2787, 1196, 238, 5, 506, 144000, N'Active'),
(2788, 1197, 271, 4, 393, 108000, N'Cancelled'),
(2789, 1197, 271, 4, 394, 108000, N'Cancelled'),
(2790, 1198, 224, 3, 268, 90000, N'Active'),
(2791, 1198, 224, 3, 269, 90000, N'Active'),
(2792, 1199, 222, 5, 513, 144000, N'Active'),
(2793, 1199, 222, 5, 514, 144000, N'Active'),
(2794, 1200, 220, 2, 161, 90000, N'Active'),
(2795, 1201, 233, 3, 218, 75000, N'Active'),
(2796, 1202, 222, 5, 446, 120000, N'Active'),
(2797, 1202, 222, 5, 447, 120000, N'Active'),
(2798, 1203, 224, 3, 298, 90000, N'Active'),
(2799, 1204, 236, 1, 53, 90000, N'Active'),
(2800, 1204, 236, 1, 54, 90000, N'Active'),
(2801, 1204, 236, 1, 55, 90000, N'Active'),
(2802, 1205, 248, 2, 211, 90000, N'Active'),
(2803, 1205, 248, 2, 212, 90000, N'Active'),
(2804, 1206, 219, 3, 234, 75000, N'Active'),
(2805, 1206, 219, 3, 235, 75000, N'Active'),
(2806, 1207, 243, 4, 417, 108000, N'Active'),
(2807, 1207, 243, 4, 418, 108000, N'Active'),
(2808, 1208, 221, 4, 390, 108000, N'Active'),
(2809, 1209, 222, 5, 498, 144000, N'Active'),
(2810, 1209, 222, 5, 499, 144000, N'Active'),
(2811, 1210, 222, 5, 531, 144000, N'Active'),
(2812, 1210, 222, 5, 532, 144000, N'Active'),
(2813, 1211, 246, 1, 55, 90000, N'Active'),
(2814, 1211, 246, 1, 56, 90000, N'Active'),
(2815, 1211, 246, 1, 57, 90000, N'Active'),
(2816, 1211, 246, 1, 58, 90000, N'Active'),
(2817, 1212, 280, 3, 278, 90000, N'Active'),
(2818, 1212, 280, 3, 279, 90000, N'Active'),
(2819, 1213, 224, 3, 265, 90000, N'Active'),
(2820, 1214, 239, 4, 376, 90000, N'Active'),
(2821, 1214, 239, 4, 377, 90000, N'Active'),
(2822, 1215, 250, 5, 509, 144000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 4 18/11/2026: 156 hoa don (8 huy), 366 ve, doanh thu 33.537.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(1216, 3, NULL, '2026-11-18T08:03:29', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 228 | Kiến Lé Phiêu Lưu Ké | 18/11 09:30 | Phòng 2 | H6 H7
(1217, 3, 117, '2026-11-18T08:10:02', 540000, N'Paid', N'Cash', 600000, 37, 0, NULL, NULL, NULL), -- suat 225 | Trại Giam Hạnh Phúc | 18/11 09:00 | Phòng 1 | G5 G6 G7 G8 G9 G10
(1218, 4, NULL, '2026-11-18T08:10:30', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 225 | Trại Giam Hạnh Phúc | 18/11 09:00 | Phòng 1 | D10
(1219, 4, NULL, '2026-11-18T08:11:50', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 267 | Bí Kíp Luyện Cướp | 19/11 15:15 | Phòng 4 | G9 G10 G11
(1220, 4, NULL, '2026-11-18T08:18:59', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 268 | Ngày Con Còn Mẹ | 19/11 15:30 | Phòng 2 | C5 C6
(1221, 4, NULL, '2026-11-18T08:19:14', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 271 | Ramayana: Khởi Nguồn Một Huyền Thoại | 19/11 17:45 | Phòng 4 | E4 E5
(1222, 4, NULL, '2026-11-18T08:25:08', 120000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 226 | Dune: Hành Tinh Cát | 18/11 09:00 | Phòng 5 | D2
(1223, 3, 31, '2026-11-18T08:29:51', 288000, N'Paid', N'Cash', 300000, 28, 0, NULL, NULL, NULL), -- suat 232 | Godzilla Trừ Không | 18/11 12:15 | Phòng 5 | L7 L8
(1224, 3, NULL, '2026-11-18T08:35:34', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 276 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 19/11 20:45 | Phòng 2 | G7 G8
(1225, 3, NULL, '2026-11-18T08:43:03', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 237 | Thiên Đường Tăm Tối | 18/11 14:45 | Phòng 3 | D2
(1226, 4, NULL, '2026-11-18T08:43:49', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 227 | Ramayana: Khởi Nguồn Một Huyền Thoại | 18/11 09:15 | Phòng 4 | E5 E6 E7
(1227, 4, 25, '2026-11-18T08:45:30', 90000, N'Paid', N'Transfer', NULL, 9, 198, NULL, NULL, NULL), -- suat 226 | Dune: Hành Tinh Cát | 18/11 09:00 | Phòng 5 | L11 L12
(1228, 3, 80, '2026-11-18T08:47:34', 140000, N'Paid', N'Cash', 140000, 14, 40, NULL, NULL, NULL), -- suat 225 | Trại Giam Hạnh Phúc | 18/11 09:00 | Phòng 1 | J1 J2
(1229, 4, NULL, '2026-11-18T08:48:37', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 226 | Dune: Hành Tinh Cát | 18/11 09:00 | Phòng 5 | L9 L10
(1230, 3, NULL, '2026-11-18T08:54:09', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 234 | Godzilla Trừ Không | 18/11 12:30 | Phòng 4 | F4 F5
(1231, 4, NULL, '2026-11-18T08:54:46', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 258 | Chàng Mèo Mang Mũ | 19/11 11:15 | Phòng 2 | J11 J12
(1232, 4, 77, '2026-11-18T08:56:50', 150000, N'Paid', N'Card', NULL, 15, 30, NULL, NULL, NULL), -- suat 229 | Bí Kíp Luyện Cướp | 18/11 10:00 | Phòng 3 | J3 J4
(1233, 3, NULL, '2026-11-18T09:05:33', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 260 | Godzilla Trừ Không | 19/11 12:15 | Phòng 5 | F3 F4
(1234, 4, NULL, '2026-11-18T09:11:06', 75000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 257 | Bí Kíp Luyện Cướp | 19/11 10:00 | Phòng 3 | C12
(1235, 4, 108, '2026-11-18T09:12:49', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 242 | Clayface | 18/11 17:00 | Phòng 3 | G4
(1236, 4, 67, '2026-11-18T09:15:28', 30000, N'Paid', N'Transfer', NULL, 2, 150, NULL, NULL, NULL), -- suat 236 | Trại Giam Hạnh Phúc | 18/11 14:00 | Phòng 1 | F2 F3
(1237, 3, NULL, '2026-11-18T09:28:10', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 264 | Trại Giam Hạnh Phúc | 19/11 14:00 | Phòng 1 | F7 F8 F9
(1238, 3, NULL, '2026-11-18T09:34:05', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 269 | Bò Sữa Bay | 19/11 16:30 | Phòng 1 | G11 G12
(1239, 4, NULL, '2026-11-18T09:42:29', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 236 | Trại Giam Hạnh Phúc | 18/11 14:00 | Phòng 1 | D8
(1240, 4, NULL, '2026-11-18T09:43:28', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 269 | Bò Sữa Bay | 19/11 16:30 | Phòng 1 | B4 B5
(1241, 3, 66, '2026-11-18T09:43:33', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 236 | Trại Giam Hạnh Phúc | 18/11 14:00 | Phòng 1 | H1 H2 H3 H4
(1242, 4, 103, '2026-11-18T09:45:51', 70000, N'Cancelled', N'Cash', 100000, 4, 20, N'Nhầm suất / ghế', '2026-11-18T10:30:00', 4), -- suat 236 | Trại Giam Hạnh Phúc | 18/11 14:00 | Phòng 1 | D12
(1243, 3, NULL, '2026-11-18T10:09:36', 270000, N'Cancelled', N'Card', NULL, 0, 0, N'Khách đổi ý', '2026-11-18T10:39:42', 3), -- suat 293 | Thiên Đường Tăm Tối | 20/11 14:45 | Phòng 3 | D7 D8 D9
(1244, 4, NULL, '2026-11-18T10:20:45', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 290 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 12:30 | Phòng 4 | D6 D7 D8 D9
(1245, 3, 72, '2026-11-18T10:23:20', 432000, N'Paid', N'Card', NULL, 30, 0, NULL, NULL, NULL), -- suat 238 | Dune: Hành Tinh Cát - Phần Hai | 18/11 15:00 | Phòng 5 | G6 G7 G8
(1246, 4, NULL, '2026-11-18T10:29:10', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 238 | Dune: Hành Tinh Cát - Phần Hai | 18/11 15:00 | Phòng 5 | E6 E7
(1247, 3, NULL, '2026-11-18T10:29:45', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 233 | Kẻ Hồi Sinh | 18/11 12:30 | Phòng 3 | J9 J10
(1248, 3, NULL, '2026-11-18T10:29:49', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 274 | Trại Giam Hạnh Phúc | 19/11 19:00 | Phòng 1 | D9
(1249, 4, NULL, '2026-11-18T10:33:01', 300000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 244 | Trại Buôn Người | 18/11 18:00 | Phòng 2 | C3 C4 C5 C6
(1250, 3, 53, '2026-11-18T10:33:59', 270000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 261 | Kẻ Hồi Sinh | 19/11 12:30 | Phòng 3 | F3 F4 F5
(1251, 3, NULL, '2026-11-18T10:38:44', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 238 | Dune: Hành Tinh Cát - Phần Hai | 18/11 15:00 | Phòng 5 | D1 D2
(1252, 4, NULL, '2026-11-18T10:42:18', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 295 | Chàng Mèo Mang Mũ | 20/11 15:30 | Phòng 2 | J7 J8
(1253, 4, NULL, '2026-11-18T10:46:06', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 271 | Ramayana: Khởi Nguồn Một Huyền Thoại | 19/11 17:45 | Phòng 4 | D10
(1254, 4, NULL, '2026-11-18T10:51:47', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 295 | Chàng Mèo Mang Mũ | 20/11 15:30 | Phòng 2 | G7 G8
(1255, 3, NULL, '2026-11-18T10:53:38', 432000, N'Paid', N'Cash', 440000, 0, 0, NULL, NULL, NULL), -- suat 243 | Ramayana: Khởi Nguồn Một Huyền Thoại | 18/11 17:45 | Phòng 4 | F5 F6 F7 F8
(1256, 3, NULL, '2026-11-18T11:00:28', 150000, N'Cancelled', N'Card', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-18T11:31:21', 3), -- suat 235 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 18/11 13:30 | Phòng 2 | C2 C3
(1257, 3, 25, '2026-11-18T11:01:00', 180000, N'Paid', N'Cash', 200000, 9, 0, NULL, NULL, NULL), -- suat 234 | Godzilla Trừ Không | 18/11 12:30 | Phòng 4 | B3 B4
(1258, 4, 44, '2026-11-18T11:01:08', 15000, N'Paid', N'Transfer', NULL, 0, 60, NULL, NULL, NULL), -- suat 236 | Trại Giam Hạnh Phúc | 18/11 14:00 | Phòng 1 | A10
(1259, 3, 93, '2026-11-18T11:12:09', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 238 | Dune: Hành Tinh Cát - Phần Hai | 18/11 15:00 | Phòng 5 | G9 G10
(1260, 3, NULL, '2026-11-18T11:17:39', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 231 | Ngày Con Còn Mẹ | 18/11 11:30 | Phòng 1 | J5 J6
(1261, 3, NULL, '2026-11-18T11:19:10', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 298 | Clayface | 20/11 17:00 | Phòng 3 | H10 H11
(1262, 3, 102, '2026-11-18T11:23:35', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 236 | Trại Giam Hạnh Phúc | 18/11 14:00 | Phòng 1 | E8 E9
(1263, 4, 34, '2026-11-18T11:25:53', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 240 | Ngày Con Còn Mẹ | 18/11 15:30 | Phòng 2 | G9 G10
(1264, 4, NULL, '2026-11-18T11:28:50', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 292 | Trại Giam Hạnh Phúc | 20/11 14:00 | Phòng 1 | J5 J6
(1265, 3, NULL, '2026-11-18T11:29:08', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 233 | Kẻ Hồi Sinh | 18/11 12:30 | Phòng 3 | F3 F4
(1266, 4, NULL, '2026-11-18T11:33:03', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | J5 J6
(1267, 3, NULL, '2026-11-18T11:35:00', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 237 | Thiên Đường Tăm Tối | 18/11 14:45 | Phòng 3 | E6 E7 E8 E9
(1268, 3, 21, '2026-11-18T11:38:22', 324000, N'Paid', N'Cash', 324000, 22, 0, NULL, NULL, NULL), -- suat 234 | Godzilla Trừ Không | 18/11 12:30 | Phòng 4 | E8 E9 E10
(1269, 3, NULL, '2026-11-18T11:47:27', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 247 | Ngày Con Còn Mẹ | 18/11 19:15 | Phòng 3 | B3 B4
(1270, 3, NULL, '2026-11-18T11:52:48', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 307 | Chị Chị Em Em 3 | 20/11 21:30 | Phòng 1 | E6 E7 E8
(1271, 4, NULL, '2026-11-18T11:59:02', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 238 | Dune: Hành Tinh Cát - Phần Hai | 18/11 15:00 | Phòng 5 | A6 A7 A8
(1272, 3, NULL, '2026-11-18T12:10:17', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 257 | Bí Kíp Luyện Cướp | 19/11 10:00 | Phòng 3 | E6
(1273, 3, NULL, '2026-11-18T12:15:49', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 303 | Ngày Con Còn Mẹ | 20/11 19:15 | Phòng 3 | G9
(1274, 3, NULL, '2026-11-18T12:23:28', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 235 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 18/11 13:30 | Phòng 2 | B7 B8 B9
(1275, 4, 68, '2026-11-18T12:28:18', 180000, N'Paid', N'Cash', 200000, 18, 0, NULL, NULL, NULL), -- suat 236 | Trại Giam Hạnh Phúc | 18/11 14:00 | Phòng 1 | J11 J12
(1276, 3, NULL, '2026-11-18T12:39:01', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 283 | Ramayana: Khởi Nguồn Một Huyền Thoại | 20/11 09:15 | Phòng 4 | B11 B12
(1277, 4, 38, '2026-11-18T12:41:43', 150000, N'Cancelled', N'Cash', 150000, 7, 0, N'Khách đổi ý', '2026-11-18T13:07:56', 4), -- suat 239 | Bí Kíp Luyện Cướp | 18/11 15:15 | Phòng 4 | C6 C7
(1278, 4, NULL, '2026-11-18T12:46:26', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 236 | Trại Giam Hạnh Phúc | 18/11 14:00 | Phòng 1 | G6 G7
(1279, 3, NULL, '2026-11-18T12:47:09', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | C7 C8
(1280, 4, NULL, '2026-11-18T12:53:23', 150000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-18T12:55:19', 4), -- suat 241 | Bò Sữa Bay | 18/11 16:30 | Phòng 1 | C6 C7
(1281, 4, 23, '2026-11-18T12:53:56', 154000, N'Paid', N'Card', NULL, 15, 26, NULL, NULL, NULL), -- suat 237 | Thiên Đường Tăm Tối | 18/11 14:45 | Phòng 3 | J5 J6
(1282, 4, 114, '2026-11-18T12:58:49', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 239 | Bí Kíp Luyện Cướp | 18/11 15:15 | Phòng 4 | G6 G7
(1283, 3, NULL, '2026-11-18T13:15:49', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 236 | Trại Giam Hạnh Phúc | 18/11 14:00 | Phòng 1 | H6 H7
(1284, 3, NULL, '2026-11-18T13:16:06', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 250 | Dune: Hành Tinh Cát - Phần Hai | 18/11 21:00 | Phòng 5 | J6 J7
(1285, 4, NULL, '2026-11-18T13:20:36', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 281 | Trại Giam Hạnh Phúc | 20/11 09:00 | Phòng 1 | J9 J10
(1286, 3, NULL, '2026-11-18T13:23:43', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 247 | Ngày Con Còn Mẹ | 18/11 19:15 | Phòng 3 | H9
(1287, 3, 21, '2026-11-18T13:25:12', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 267 | Bí Kíp Luyện Cướp | 19/11 15:15 | Phòng 4 | C7 C8
(1288, 3, NULL, '2026-11-18T13:25:22', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 270 | Clayface | 19/11 17:00 | Phòng 3 | F6 F7
(1289, 4, NULL, '2026-11-18T13:27:01', 300000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 272 | Trại Buôn Người | 19/11 18:00 | Phòng 2 | B7 B8 B9 B10
(1290, 3, NULL, '2026-11-18T13:28:37', 324000, N'Paid', N'Cash', 330000, 0, 0, NULL, NULL, NULL), -- suat 243 | Ramayana: Khởi Nguồn Một Huyền Thoại | 18/11 17:45 | Phòng 4 | E8 E9 E10
(1291, 3, NULL, '2026-11-18T13:32:01', 75000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 247 | Ngày Con Còn Mẹ | 18/11 19:15 | Phòng 3 | B7
(1292, 3, NULL, '2026-11-18T13:32:41', 360000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 242 | Clayface | 18/11 17:00 | Phòng 3 | G6 G7 G8 G9
(1293, 3, NULL, '2026-11-18T13:35:11', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 239 | Bí Kíp Luyện Cướp | 18/11 15:15 | Phòng 4 | G2 G3 G4 G5
(1294, 4, NULL, '2026-11-18T13:43:40', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 239 | Bí Kíp Luyện Cướp | 18/11 15:15 | Phòng 4 | F8 F9 F10 F11
(1295, 3, 21, '2026-11-18T13:53:21', 180000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 244 | Trại Buôn Người | 18/11 18:00 | Phòng 2 | J9 J10
(1296, 4, NULL, '2026-11-18T13:53:27', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 268 | Ngày Con Còn Mẹ | 19/11 15:30 | Phòng 2 | E10 E11
(1297, 4, 66, '2026-11-18T13:56:59', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 244 | Trại Buôn Người | 18/11 18:00 | Phòng 2 | G4 G5
(1298, 3, NULL, '2026-11-18T13:58:46', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 247 | Ngày Con Còn Mẹ | 18/11 19:15 | Phòng 3 | D9 D10
(1299, 4, NULL, '2026-11-18T13:59:15', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 238 | Dune: Hành Tinh Cát - Phần Hai | 18/11 15:00 | Phòng 5 | K6 K7
(1300, 3, NULL, '2026-11-18T14:00:15', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 259 | Ngày Con Còn Mẹ | 19/11 11:30 | Phòng 1 | G6 G7 G8 G9
(1301, 4, 113, '2026-11-18T14:01:40', 180000, N'Paid', N'Cash', 180000, 18, 0, NULL, NULL, NULL), -- suat 239 | Bí Kíp Luyện Cướp | 18/11 15:15 | Phòng 4 | J9 J10
(1302, 3, 88, '2026-11-18T14:07:49', 288000, N'Cancelled', N'Cash', 288000, 28, 0, N'Lỗi thanh toán', '2026-11-18T14:38:17', 3), -- suat 250 | Dune: Hành Tinh Cát - Phần Hai | 18/11 21:00 | Phòng 5 | L5 L6
(1303, 3, NULL, '2026-11-18T14:11:14', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 291 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 20/11 13:30 | Phòng 2 | F6 F7 F8 F9
(1304, 3, NULL, '2026-11-18T14:13:20', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 245 | Godzilla Trừ Không | 18/11 18:15 | Phòng 5 | L11 L12
(1305, 4, NULL, '2026-11-18T14:24:57', 432000, N'Paid', N'Cash', 440000, 0, 0, NULL, NULL, NULL), -- suat 243 | Ramayana: Khởi Nguồn Một Huyền Thoại | 18/11 17:45 | Phòng 4 | D2 D3 D4 D5
(1306, 3, 67, '2026-11-18T14:27:15', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 242 | Clayface | 18/11 17:00 | Phòng 3 | E7
(1307, 4, NULL, '2026-11-18T14:37:42', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | J7 J8
(1308, 3, 77, '2026-11-18T14:40:17', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 250 | Dune: Hành Tinh Cát - Phần Hai | 18/11 21:00 | Phòng 5 | K11 K12
(1309, 3, NULL, '2026-11-18T14:44:02', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 289 | Kẻ Hồi Sinh | 20/11 12:30 | Phòng 3 | J7 J8
(1310, 4, NULL, '2026-11-18T14:47:23', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 273 | Godzilla Trừ Không | 19/11 18:15 | Phòng 5 | D5 D6
(1311, 6, NULL, '2026-11-18T15:04:34', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | E3 E4
(1312, 5, NULL, '2026-11-18T15:07:03', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 248 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 18/11 20:45 | Phòng 2 | G7 G8 G9
(1313, 5, 108, '2026-11-18T15:08:26', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 257 | Bí Kíp Luyện Cướp | 19/11 10:00 | Phòng 3 | F5 F6
(1314, 6, NULL, '2026-11-18T15:18:51', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 245 | Godzilla Trừ Không | 18/11 18:15 | Phòng 5 | H5 H6
(1315, 5, 64, '2026-11-18T15:30:19', 540000, N'Paid', N'Cash', 540000, 37, 0, NULL, NULL, NULL), -- suat 247 | Ngày Con Còn Mẹ | 18/11 19:15 | Phòng 3 | D3 D4 D5 D6 D7 D8
(1316, 5, 29, '2026-11-18T15:32:57', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 245 | Godzilla Trừ Không | 18/11 18:15 | Phòng 5 | F9 F10
(1317, 6, NULL, '2026-11-18T15:43:16', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 244 | Trại Buôn Người | 18/11 18:00 | Phòng 2 | G7
(1318, 5, 117, '2026-11-18T15:45:35', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 264 | Trại Giam Hạnh Phúc | 19/11 14:00 | Phòng 1 | C9 C10
(1319, 6, NULL, '2026-11-18T15:57:28', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 260 | Godzilla Trừ Không | 19/11 12:15 | Phòng 5 | E7
(1320, 5, NULL, '2026-11-18T15:58:36', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 264 | Trại Giam Hạnh Phúc | 19/11 14:00 | Phòng 1 | C5 C6
(1321, 5, NULL, '2026-11-18T16:01:38', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 256 | Kiến Lé Phiêu Lưu Ké | 19/11 09:30 | Phòng 2 | D4 D5
(1322, 5, NULL, '2026-11-18T16:02:59', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | F5 F6
(1323, 5, NULL, '2026-11-18T16:05:51', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | H1 H2 H3 H4
(1324, 6, NULL, '2026-11-18T16:20:43', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | F7
(1325, 6, 22, '2026-11-18T16:25:05', 360000, N'Paid', N'Cash', 360000, 25, 0, NULL, NULL, NULL), -- suat 247 | Ngày Con Còn Mẹ | 18/11 19:15 | Phòng 3 | H4 H5 H6 H7
(1326, 6, 113, '2026-11-18T16:27:21', 270000, N'Paid', N'Cash', 300000, 18, 0, NULL, NULL, NULL), -- suat 251 | Chị Chị Em Em 3 | 18/11 21:30 | Phòng 1 | G5 G6 G7
(1327, 5, NULL, '2026-11-18T16:29:34', 450000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 308 | Trại Giam Hạnh Phúc | 20/11 21:30 | Phòng 3 | D7 D8 D9 D10 D11
(1328, 6, NULL, '2026-11-18T16:29:45', 225000, N'Paid', N'Cash', 225000, 0, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | A2 A3 A4
(1329, 5, NULL, '2026-11-18T16:30:47', 360000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 248 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 18/11 20:45 | Phòng 2 | D9 D10 D11 D12
(1330, 6, NULL, '2026-11-18T16:34:10', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | D6 D7
(1331, 6, NULL, '2026-11-18T16:35:18', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 247 | Ngày Con Còn Mẹ | 18/11 19:15 | Phòng 3 | F7 F8 F9
(1332, 6, NULL, '2026-11-18T16:36:53', 75000, N'Cancelled', N'Card', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-18T16:51:45', 6), -- suat 252 | Trại Giam Hạnh Phúc | 18/11 21:30 | Phòng 3 | A10
(1333, 5, NULL, '2026-11-18T16:38:11', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 291 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 20/11 13:30 | Phòng 2 | F1 F2 F3
(1334, 5, NULL, '2026-11-18T16:41:07', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 252 | Trại Giam Hạnh Phúc | 18/11 21:30 | Phòng 3 | D4 D5 D6 D7
(1335, 5, NULL, '2026-11-18T16:45:53', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 244 | Trại Buôn Người | 18/11 18:00 | Phòng 2 | H4 H5
(1336, 5, NULL, '2026-11-18T16:50:57', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 250 | Dune: Hành Tinh Cát - Phần Hai | 18/11 21:00 | Phòng 5 | F4 F5
(1337, 5, NULL, '2026-11-18T16:51:47', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 248 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 18/11 20:45 | Phòng 2 | E5 E6
(1338, 6, NULL, '2026-11-18T16:52:34', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 273 | Godzilla Trừ Không | 19/11 18:15 | Phòng 5 | G8 G9
(1339, 5, 17, '2026-11-18T16:54:02', 180000, N'Cancelled', N'Transfer', NULL, 18, 0, N'Nhầm suất / ghế', '2026-11-18T17:35:26', 5), -- suat 275 | Ngày Con Còn Mẹ | 19/11 19:15 | Phòng 3 | J7 J8
(1340, 6, 46, '2026-11-18T17:01:29', 360000, N'Paid', N'Cash', 400000, 18, 0, NULL, NULL, NULL), -- suat 245 | Godzilla Trừ Không | 18/11 18:15 | Phòng 5 | A9 A10 A11
(1341, 5, 6, '2026-11-18T17:10:36', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | B8 B9
(1342, 5, NULL, '2026-11-18T17:23:50', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 278 | Dune: Hành Tinh Cát - Phần Hai | 19/11 21:00 | Phòng 5 | L3 L4
(1343, 5, 109, '2026-11-18T17:26:45', 360000, N'Paid', N'Cash', 400000, 25, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | D2 D3 D4 D5
(1344, 6, NULL, '2026-11-18T17:26:59', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 288 | Godzilla Trừ Không | 20/11 12:15 | Phòng 5 | F12
(1345, 5, NULL, '2026-11-18T17:27:39', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 247 | Ngày Con Còn Mẹ | 18/11 19:15 | Phòng 3 | F1 F2
(1346, 5, NULL, '2026-11-18T17:29:08', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 247 | Ngày Con Còn Mẹ | 18/11 19:15 | Phòng 3 | E2 E3 E4 E5
(1347, 5, NULL, '2026-11-18T17:29:43', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 279 | Chị Chị Em Em 3 | 19/11 21:30 | Phòng 1 | D8 D9
(1348, 6, NULL, '2026-11-18T17:31:51', 375000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | C1 C2 C3 C4 C5
(1349, 6, 79, '2026-11-18T17:36:04', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 248 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 18/11 20:45 | Phòng 2 | H11
(1350, 5, 94, '2026-11-18T17:51:04', 360000, N'Paid', N'Cash', 400000, 25, 0, NULL, NULL, NULL), -- suat 251 | Chị Chị Em Em 3 | 18/11 21:30 | Phòng 1 | E5 E6 E7 E8
(1351, 5, NULL, '2026-11-18T17:53:34', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 264 | Trại Giam Hạnh Phúc | 19/11 14:00 | Phòng 1 | D11 D12
(1352, 6, NULL, '2026-11-18T18:04:44', 225000, N'Paid', N'Cash', 230000, 0, 0, NULL, NULL, NULL), -- suat 247 | Ngày Con Còn Mẹ | 18/11 19:15 | Phòng 3 | C6 C7 C8
(1353, 6, NULL, '2026-11-18T18:04:55', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 248 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 18/11 20:45 | Phòng 2 | G5
(1354, 5, 88, '2026-11-18T18:21:19', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 272 | Trại Buôn Người | 19/11 18:00 | Phòng 2 | J7 J8
(1355, 5, NULL, '2026-11-18T18:33:54', 375000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 247 | Ngày Con Còn Mẹ | 18/11 19:15 | Phòng 3 | B8 B9 B10 B11 B12
(1356, 5, NULL, '2026-11-18T18:35:50', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 246 | Trại Giam Hạnh Phúc | 18/11 19:00 | Phòng 1 | A10 A11 A12
(1357, 6, 25, '2026-11-18T18:50:44', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 248 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 18/11 20:45 | Phòng 2 | H9 H10
(1358, 6, 1, '2026-11-18T18:58:23', 144000, N'Paid', N'Cash', 200000, 10, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | E3
(1359, 5, 98, '2026-11-18T19:07:56', 108000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | F10
(1360, 5, NULL, '2026-11-18T19:10:59', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 305 | Bí Kíp Luyện Cướp | 20/11 21:00 | Phòng 4 | G7 G8 G9
(1361, 6, NULL, '2026-11-18T19:14:30', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 252 | Trại Giam Hạnh Phúc | 18/11 21:30 | Phòng 3 | H3 H4 H5
(1362, 5, NULL, '2026-11-18T19:17:08', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 278 | Dune: Hành Tinh Cát - Phần Hai | 19/11 21:00 | Phòng 5 | J4 J5
(1363, 5, 1, '2026-11-18T19:30:22', 432000, N'Paid', N'Card', NULL, 30, 0, NULL, NULL, NULL), -- suat 294 | Dune: Hành Tinh Cát - Phần Hai | 20/11 15:00 | Phòng 5 | G5 G6 G7
(1364, 6, NULL, '2026-11-18T19:30:39', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 249 | Godzilla Trừ Không | 18/11 21:00 | Phòng 4 | F1 F2
(1365, 5, NULL, '2026-11-18T19:32:04', 216000, N'Paid', N'Cash', 220000, 0, 0, NULL, NULL, NULL), -- suat 271 | Ramayana: Khởi Nguồn Một Huyền Thoại | 19/11 17:45 | Phòng 4 | F11 F12
(1366, 5, NULL, '2026-11-18T20:48:40', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 277 | Godzilla Trừ Không | 19/11 21:00 | Phòng 4 | B2 B3
(1367, 6, 2, '2026-11-18T20:55:14', 240000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 273 | Godzilla Trừ Không | 19/11 18:15 | Phòng 5 | C7 C8
(1368, 6, NULL, '2026-11-18T21:03:15', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 264 | Trại Giam Hạnh Phúc | 19/11 14:00 | Phòng 1 | J3 J4
(1369, 5, NULL, '2026-11-18T21:08:00', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 270 | Clayface | 19/11 17:00 | Phòng 3 | E11 E12
(1370, 5, NULL, '2026-11-18T21:08:06', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 251 | Chị Chị Em Em 3 | 18/11 21:30 | Phòng 1 | E9 E10 E11
(1371, 6, NULL, '2026-11-18T21:32:35', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL); -- suat 275 | Ngày Con Còn Mẹ | 19/11 19:15 | Phòng 3 | A6 A7
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(2823, 1216, 228, 2, 198, 90000, N'Active'),
(2824, 1216, 228, 2, 199, 90000, N'Active'),
(2825, 1217, 225, 1, 77, 90000, N'Active'),
(2826, 1217, 225, 1, 78, 90000, N'Active'),
(2827, 1217, 225, 1, 79, 90000, N'Active'),
(2828, 1217, 225, 1, 80, 90000, N'Active'),
(2829, 1217, 225, 1, 81, 90000, N'Active'),
(2830, 1217, 225, 1, 82, 90000, N'Active'),
(2831, 1218, 225, 1, 46, 90000, N'Active'),
(2832, 1219, 267, 4, 405, 90000, N'Active'),
(2833, 1219, 267, 4, 406, 90000, N'Active'),
(2834, 1219, 267, 4, 407, 90000, N'Active'),
(2835, 1220, 268, 2, 137, 75000, N'Active'),
(2836, 1220, 268, 2, 138, 75000, N'Active'),
(2837, 1221, 271, 4, 376, 108000, N'Active'),
(2838, 1221, 271, 4, 377, 108000, N'Active'),
(2839, 1222, 226, 5, 470, 120000, N'Active'),
(2840, 1223, 232, 5, 559, 144000, N'Active'),
(2841, 1223, 232, 5, 560, 144000, N'Active'),
(2842, 1224, 276, 2, 187, 90000, N'Active'),
(2843, 1224, 276, 2, 188, 90000, N'Active'),
(2844, 1225, 237, 3, 254, 90000, N'Active'),
(2845, 1226, 227, 4, 377, 108000, N'Active'),
(2846, 1226, 227, 4, 378, 108000, N'Active'),
(2847, 1226, 227, 4, 379, 108000, N'Active'),
(2848, 1227, 226, 5, 563, 144000, N'Active'),
(2849, 1227, 226, 5, 564, 144000, N'Active'),
(2850, 1228, 225, 1, 97, 90000, N'Active'),
(2851, 1228, 225, 1, 98, 90000, N'Active'),
(2852, 1229, 226, 5, 561, 144000, N'Active'),
(2853, 1229, 226, 5, 562, 144000, N'Active'),
(2854, 1230, 234, 4, 388, 108000, N'Active'),
(2855, 1230, 234, 4, 389, 108000, N'Active'),
(2856, 1231, 258, 2, 215, 90000, N'Active'),
(2857, 1231, 258, 2, 216, 90000, N'Active'),
(2858, 1232, 229, 3, 315, 90000, N'Active'),
(2859, 1232, 229, 3, 316, 90000, N'Active'),
(2860, 1233, 260, 5, 495, 144000, N'Active'),
(2861, 1233, 260, 5, 496, 144000, N'Active'),
(2862, 1234, 257, 3, 252, 75000, N'Active'),
(2863, 1235, 242, 3, 292, 90000, N'Active'),
(2864, 1236, 236, 1, 62, 90000, N'Active'),
(2865, 1236, 236, 1, 63, 90000, N'Active'),
(2866, 1237, 264, 1, 67, 90000, N'Active'),
(2867, 1237, 264, 1, 68, 90000, N'Active'),
(2868, 1237, 264, 1, 69, 90000, N'Active'),
(2869, 1238, 269, 1, 83, 90000, N'Active'),
(2870, 1238, 269, 1, 84, 90000, N'Active'),
(2871, 1239, 236, 1, 44, 90000, N'Active'),
(2872, 1240, 269, 1, 16, 75000, N'Active'),
(2873, 1240, 269, 1, 17, 75000, N'Active'),
(2874, 1241, 236, 1, 85, 90000, N'Active'),
(2875, 1241, 236, 1, 86, 90000, N'Active'),
(2876, 1241, 236, 1, 87, 90000, N'Active'),
(2877, 1241, 236, 1, 88, 90000, N'Active'),
(2878, 1242, 236, 1, 48, 90000, N'Cancelled'),
(2879, 1243, 293, 3, 259, 90000, N'Cancelled'),
(2880, 1243, 293, 3, 260, 90000, N'Cancelled'),
(2881, 1243, 293, 3, 261, 90000, N'Cancelled'),
(2882, 1244, 290, 4, 366, 108000, N'Active'),
(2883, 1244, 290, 4, 367, 108000, N'Active'),
(2884, 1244, 290, 4, 368, 108000, N'Active'),
(2885, 1244, 290, 4, 369, 108000, N'Active'),
(2886, 1245, 238, 5, 510, 144000, N'Active'),
(2887, 1245, 238, 5, 511, 144000, N'Active'),
(2888, 1245, 238, 5, 512, 144000, N'Active'),
(2889, 1246, 238, 5, 486, 144000, N'Active'),
(2890, 1246, 238, 5, 487, 144000, N'Active'),
(2891, 1247, 233, 3, 321, 90000, N'Active'),
(2892, 1247, 233, 3, 322, 90000, N'Active'),
(2893, 1248, 274, 1, 45, 90000, N'Active'),
(2894, 1249, 244, 2, 135, 75000, N'Active'),
(2895, 1249, 244, 2, 136, 75000, N'Active'),
(2896, 1249, 244, 2, 137, 75000, N'Active'),
(2897, 1249, 244, 2, 138, 75000, N'Active'),
(2898, 1250, 261, 3, 279, 90000, N'Active'),
(2899, 1250, 261, 3, 280, 90000, N'Active'),
(2900, 1250, 261, 3, 281, 90000, N'Active'),
(2901, 1251, 238, 5, 469, 120000, N'Active'),
(2902, 1251, 238, 5, 470, 120000, N'Active'),
(2903, 1252, 295, 2, 211, 90000, N'Active'),
(2904, 1252, 295, 2, 212, 90000, N'Active'),
(2905, 1253, 271, 4, 370, 108000, N'Active'),
(2906, 1254, 295, 2, 187, 90000, N'Active'),
(2907, 1254, 295, 2, 188, 90000, N'Active'),
(2908, 1255, 243, 4, 389, 108000, N'Active'),
(2909, 1255, 243, 4, 390, 108000, N'Active'),
(2910, 1255, 243, 4, 391, 108000, N'Active'),
(2911, 1255, 243, 4, 392, 108000, N'Active'),
(2912, 1256, 235, 2, 134, 75000, N'Cancelled'),
(2913, 1256, 235, 2, 135, 75000, N'Cancelled'),
(2914, 1257, 234, 4, 339, 90000, N'Active'),
(2915, 1257, 234, 4, 340, 90000, N'Active'),
(2916, 1258, 236, 1, 10, 75000, N'Active'),
(2917, 1259, 238, 5, 513, 144000, N'Active'),
(2918, 1259, 238, 5, 514, 144000, N'Active'),
(2919, 1260, 231, 1, 101, 90000, N'Active'),
(2920, 1260, 231, 1, 102, 90000, N'Active'),
(2921, 1261, 298, 3, 310, 90000, N'Active'),
(2922, 1261, 298, 3, 311, 90000, N'Active'),
(2923, 1262, 236, 1, 56, 90000, N'Active'),
(2924, 1262, 236, 1, 57, 90000, N'Active'),
(2925, 1263, 240, 2, 189, 90000, N'Active'),
(2926, 1263, 240, 2, 190, 90000, N'Active'),
(2927, 1264, 292, 1, 101, 90000, N'Active'),
(2928, 1264, 292, 1, 102, 90000, N'Active'),
(2929, 1265, 233, 3, 279, 90000, N'Active'),
(2930, 1265, 233, 3, 280, 90000, N'Active'),
(2931, 1266, 246, 1, 101, 90000, N'Active'),
(2932, 1266, 246, 1, 102, 90000, N'Active'),
(2933, 1267, 237, 3, 270, 90000, N'Active'),
(2934, 1267, 237, 3, 271, 90000, N'Active'),
(2935, 1267, 237, 3, 272, 90000, N'Active'),
(2936, 1267, 237, 3, 273, 90000, N'Active'),
(2937, 1268, 234, 4, 380, 108000, N'Active'),
(2938, 1268, 234, 4, 381, 108000, N'Active'),
(2939, 1268, 234, 4, 382, 108000, N'Active'),
(2940, 1269, 247, 3, 231, 75000, N'Active'),
(2941, 1269, 247, 3, 232, 75000, N'Active'),
(2942, 1270, 307, 1, 54, 90000, N'Active'),
(2943, 1270, 307, 1, 55, 90000, N'Active'),
(2944, 1270, 307, 1, 56, 90000, N'Active'),
(2945, 1271, 238, 5, 438, 120000, N'Active'),
(2946, 1271, 238, 5, 439, 120000, N'Active'),
(2947, 1271, 238, 5, 440, 120000, N'Active'),
(2948, 1272, 257, 3, 270, 90000, N'Active'),
(2949, 1273, 303, 3, 297, 90000, N'Active'),
(2950, 1274, 235, 2, 127, 75000, N'Active'),
(2951, 1274, 235, 2, 128, 75000, N'Active'),
(2952, 1274, 235, 2, 129, 75000, N'Active'),
(2953, 1275, 236, 1, 107, 90000, N'Active'),
(2954, 1275, 236, 1, 108, 90000, N'Active'),
(2955, 1276, 283, 4, 347, 90000, N'Active'),
(2956, 1276, 283, 4, 348, 90000, N'Active'),
(2957, 1277, 239, 4, 354, 75000, N'Cancelled'),
(2958, 1277, 239, 4, 355, 75000, N'Cancelled'),
(2959, 1278, 236, 1, 78, 90000, N'Active'),
(2960, 1278, 236, 1, 79, 90000, N'Active'),
(2961, 1279, 246, 1, 31, 75000, N'Active'),
(2962, 1279, 246, 1, 32, 75000, N'Active'),
(2963, 1280, 241, 1, 30, 75000, N'Cancelled'),
(2964, 1280, 241, 1, 31, 75000, N'Cancelled'),
(2965, 1281, 237, 3, 317, 90000, N'Active'),
(2966, 1281, 237, 3, 318, 90000, N'Active'),
(2967, 1282, 239, 4, 402, 90000, N'Active'),
(2968, 1282, 239, 4, 403, 90000, N'Active'),
(2969, 1283, 236, 1, 90, 90000, N'Active'),
(2970, 1283, 236, 1, 91, 90000, N'Active'),
(2971, 1284, 250, 5, 534, 144000, N'Active'),
(2972, 1284, 250, 5, 535, 144000, N'Active'),
(2973, 1285, 281, 1, 105, 90000, N'Active'),
(2974, 1285, 281, 1, 106, 90000, N'Active'),
(2975, 1286, 247, 3, 309, 90000, N'Active'),
(2976, 1287, 267, 4, 355, 75000, N'Active'),
(2977, 1287, 267, 4, 356, 75000, N'Active'),
(2978, 1288, 270, 3, 282, 90000, N'Active'),
(2979, 1288, 270, 3, 283, 90000, N'Active'),
(2980, 1289, 272, 2, 127, 75000, N'Active'),
(2981, 1289, 272, 2, 128, 75000, N'Active'),
(2982, 1289, 272, 2, 129, 75000, N'Active'),
(2983, 1289, 272, 2, 130, 75000, N'Active'),
(2984, 1290, 243, 4, 380, 108000, N'Active'),
(2985, 1290, 243, 4, 381, 108000, N'Active'),
(2986, 1290, 243, 4, 382, 108000, N'Active'),
(2987, 1291, 247, 3, 235, 75000, N'Active'),
(2988, 1292, 242, 3, 294, 90000, N'Active'),
(2989, 1292, 242, 3, 295, 90000, N'Active'),
(2990, 1292, 242, 3, 296, 90000, N'Active'),
(2991, 1292, 242, 3, 297, 90000, N'Active'),
(2992, 1293, 239, 4, 398, 90000, N'Active'),
(2993, 1293, 239, 4, 399, 90000, N'Active'),
(2994, 1293, 239, 4, 400, 90000, N'Active'),
(2995, 1293, 239, 4, 401, 90000, N'Active'),
(2996, 1294, 239, 4, 392, 90000, N'Active'),
(2997, 1294, 239, 4, 393, 90000, N'Active'),
(2998, 1294, 239, 4, 394, 90000, N'Active'),
(2999, 1294, 239, 4, 395, 90000, N'Active'),
(3000, 1295, 244, 2, 213, 90000, N'Active'),
(3001, 1295, 244, 2, 214, 90000, N'Active'),
(3002, 1296, 268, 2, 166, 90000, N'Active'),
(3003, 1296, 268, 2, 167, 90000, N'Active'),
(3004, 1297, 244, 2, 184, 90000, N'Active'),
(3005, 1297, 244, 2, 185, 90000, N'Active'),
(3006, 1298, 247, 3, 261, 90000, N'Active'),
(3007, 1298, 247, 3, 262, 90000, N'Active'),
(3008, 1299, 238, 5, 546, 144000, N'Active'),
(3009, 1299, 238, 5, 547, 144000, N'Active'),
(3010, 1300, 259, 1, 78, 90000, N'Active'),
(3011, 1300, 259, 1, 79, 90000, N'Active'),
(3012, 1300, 259, 1, 80, 90000, N'Active'),
(3013, 1300, 259, 1, 81, 90000, N'Active'),
(3014, 1301, 239, 4, 429, 90000, N'Active'),
(3015, 1301, 239, 4, 430, 90000, N'Active'),
(3016, 1302, 250, 5, 557, 144000, N'Cancelled'),
(3017, 1302, 250, 5, 558, 144000, N'Cancelled'),
(3018, 1303, 291, 2, 174, 90000, N'Active'),
(3019, 1303, 291, 2, 175, 90000, N'Active'),
(3020, 1303, 291, 2, 176, 90000, N'Active'),
(3021, 1303, 291, 2, 177, 90000, N'Active'),
(3022, 1304, 245, 5, 563, 144000, N'Active'),
(3023, 1304, 245, 5, 564, 144000, N'Active'),
(3024, 1305, 243, 4, 362, 108000, N'Active'),
(3025, 1305, 243, 4, 363, 108000, N'Active'),
(3026, 1305, 243, 4, 364, 108000, N'Active'),
(3027, 1305, 243, 4, 365, 108000, N'Active'),
(3028, 1306, 242, 3, 271, 90000, N'Active'),
(3029, 1307, 246, 1, 103, 90000, N'Active'),
(3030, 1307, 246, 1, 104, 90000, N'Active'),
(3031, 1308, 250, 5, 551, 144000, N'Active'),
(3032, 1308, 250, 5, 552, 144000, N'Active'),
(3033, 1309, 289, 3, 319, 90000, N'Active'),
(3034, 1309, 289, 3, 320, 90000, N'Active'),
(3035, 1310, 273, 5, 473, 120000, N'Active'),
(3036, 1310, 273, 5, 474, 120000, N'Active'),
(3037, 1311, 246, 1, 51, 90000, N'Active'),
(3038, 1311, 246, 1, 52, 90000, N'Active'),
(3039, 1312, 248, 2, 187, 90000, N'Active'),
(3040, 1312, 248, 2, 188, 90000, N'Active'),
(3041, 1312, 248, 2, 189, 90000, N'Active'),
(3042, 1313, 257, 3, 281, 90000, N'Active'),
(3043, 1313, 257, 3, 282, 90000, N'Active'),
(3044, 1314, 245, 5, 521, 144000, N'Active'),
(3045, 1314, 245, 5, 522, 144000, N'Active'),
(3046, 1315, 247, 3, 255, 90000, N'Active'),
(3047, 1315, 247, 3, 256, 90000, N'Active'),
(3048, 1315, 247, 3, 257, 90000, N'Active'),
(3049, 1315, 247, 3, 258, 90000, N'Active'),
(3050, 1315, 247, 3, 259, 90000, N'Active'),
(3051, 1315, 247, 3, 260, 90000, N'Active'),
(3052, 1316, 245, 5, 501, 144000, N'Active'),
(3053, 1316, 245, 5, 502, 144000, N'Active'),
(3054, 1317, 244, 2, 187, 90000, N'Active'),
(3055, 1318, 264, 1, 33, 75000, N'Active'),
(3056, 1318, 264, 1, 34, 75000, N'Active'),
(3057, 1319, 260, 5, 487, 144000, N'Active'),
(3058, 1320, 264, 1, 29, 75000, N'Active'),
(3059, 1320, 264, 1, 30, 75000, N'Active'),
(3060, 1321, 256, 2, 148, 90000, N'Active'),
(3061, 1321, 256, 2, 149, 90000, N'Active'),
(3062, 1322, 246, 1, 65, 90000, N'Active'),
(3063, 1322, 246, 1, 66, 90000, N'Active'),
(3064, 1323, 246, 1, 85, 90000, N'Active'),
(3065, 1323, 246, 1, 86, 90000, N'Active'),
(3066, 1323, 246, 1, 87, 90000, N'Active'),
(3067, 1323, 246, 1, 88, 90000, N'Active'),
(3068, 1324, 306, 5, 499, 144000, N'Active'),
(3069, 1325, 247, 3, 304, 90000, N'Active'),
(3070, 1325, 247, 3, 305, 90000, N'Active'),
(3071, 1325, 247, 3, 306, 90000, N'Active'),
(3072, 1325, 247, 3, 307, 90000, N'Active'),
(3073, 1326, 251, 1, 77, 90000, N'Active'),
(3074, 1326, 251, 1, 78, 90000, N'Active'),
(3075, 1326, 251, 1, 79, 90000, N'Active'),
(3076, 1327, 308, 3, 259, 90000, N'Active'),
(3077, 1327, 308, 3, 260, 90000, N'Active'),
(3078, 1327, 308, 3, 261, 90000, N'Active'),
(3079, 1327, 308, 3, 262, 90000, N'Active'),
(3080, 1327, 308, 3, 263, 90000, N'Active'),
(3081, 1328, 246, 1, 2, 75000, N'Active'),
(3082, 1328, 246, 1, 3, 75000, N'Active'),
(3083, 1328, 246, 1, 4, 75000, N'Active'),
(3084, 1329, 248, 2, 153, 90000, N'Active'),
(3085, 1329, 248, 2, 154, 90000, N'Active'),
(3086, 1329, 248, 2, 155, 90000, N'Active'),
(3087, 1329, 248, 2, 156, 90000, N'Active'),
(3088, 1330, 246, 1, 42, 90000, N'Active'),
(3089, 1330, 246, 1, 43, 90000, N'Active'),
(3090, 1331, 247, 3, 283, 90000, N'Active'),
(3091, 1331, 247, 3, 284, 90000, N'Active'),
(3092, 1331, 247, 3, 285, 90000, N'Active'),
(3093, 1332, 252, 3, 226, 75000, N'Cancelled'),
(3094, 1333, 291, 2, 169, 90000, N'Active'),
(3095, 1333, 291, 2, 170, 90000, N'Active'),
(3096, 1333, 291, 2, 171, 90000, N'Active'),
(3097, 1334, 252, 3, 256, 90000, N'Active'),
(3098, 1334, 252, 3, 257, 90000, N'Active'),
(3099, 1334, 252, 3, 258, 90000, N'Active'),
(3100, 1334, 252, 3, 259, 90000, N'Active'),
(3101, 1335, 244, 2, 196, 90000, N'Active'),
(3102, 1335, 244, 2, 197, 90000, N'Active'),
(3103, 1336, 250, 5, 496, 144000, N'Active'),
(3104, 1336, 250, 5, 497, 144000, N'Active'),
(3105, 1337, 248, 2, 161, 90000, N'Active'),
(3106, 1337, 248, 2, 162, 90000, N'Active'),
(3107, 1338, 273, 5, 512, 144000, N'Active'),
(3108, 1338, 273, 5, 513, 144000, N'Active'),
(3109, 1339, 275, 3, 319, 90000, N'Cancelled'),
(3110, 1339, 275, 3, 320, 90000, N'Cancelled'),
(3111, 1340, 245, 5, 441, 120000, N'Active'),
(3112, 1340, 245, 5, 442, 120000, N'Active'),
(3113, 1340, 245, 5, 443, 120000, N'Active'),
(3114, 1341, 246, 1, 20, 75000, N'Active'),
(3115, 1341, 246, 1, 21, 75000, N'Active'),
(3116, 1342, 278, 5, 555, 144000, N'Active'),
(3117, 1342, 278, 5, 556, 144000, N'Active'),
(3118, 1343, 246, 1, 38, 90000, N'Active'),
(3119, 1343, 246, 1, 39, 90000, N'Active'),
(3120, 1343, 246, 1, 40, 90000, N'Active'),
(3121, 1343, 246, 1, 41, 90000, N'Active'),
(3122, 1344, 288, 5, 504, 144000, N'Active'),
(3123, 1345, 247, 3, 277, 90000, N'Active'),
(3124, 1345, 247, 3, 278, 90000, N'Active'),
(3125, 1346, 247, 3, 266, 90000, N'Active'),
(3126, 1346, 247, 3, 267, 90000, N'Active'),
(3127, 1346, 247, 3, 268, 90000, N'Active'),
(3128, 1346, 247, 3, 269, 90000, N'Active'),
(3129, 1347, 279, 1, 44, 90000, N'Active'),
(3130, 1347, 279, 1, 45, 90000, N'Active'),
(3131, 1348, 246, 1, 25, 75000, N'Active'),
(3132, 1348, 246, 1, 26, 75000, N'Active'),
(3133, 1348, 246, 1, 27, 75000, N'Active'),
(3134, 1348, 246, 1, 28, 75000, N'Active'),
(3135, 1348, 246, 1, 29, 75000, N'Active'),
(3136, 1349, 248, 2, 203, 90000, N'Active'),
(3137, 1350, 251, 1, 53, 90000, N'Active'),
(3138, 1350, 251, 1, 54, 90000, N'Active'),
(3139, 1350, 251, 1, 55, 90000, N'Active'),
(3140, 1350, 251, 1, 56, 90000, N'Active'),
(3141, 1351, 264, 1, 47, 90000, N'Active'),
(3142, 1351, 264, 1, 48, 90000, N'Active'),
(3143, 1352, 247, 3, 246, 75000, N'Active'),
(3144, 1352, 247, 3, 247, 75000, N'Active'),
(3145, 1352, 247, 3, 248, 75000, N'Active'),
(3146, 1353, 248, 2, 185, 90000, N'Active'),
(3147, 1354, 272, 2, 211, 90000, N'Active'),
(3148, 1354, 272, 2, 212, 90000, N'Active'),
(3149, 1355, 247, 3, 236, 75000, N'Active'),
(3150, 1355, 247, 3, 237, 75000, N'Active'),
(3151, 1355, 247, 3, 238, 75000, N'Active'),
(3152, 1355, 247, 3, 239, 75000, N'Active'),
(3153, 1355, 247, 3, 240, 75000, N'Active'),
(3154, 1356, 246, 1, 10, 75000, N'Active'),
(3155, 1356, 246, 1, 11, 75000, N'Active'),
(3156, 1356, 246, 1, 12, 75000, N'Active'),
(3157, 1357, 248, 2, 201, 90000, N'Active'),
(3158, 1357, 248, 2, 202, 90000, N'Active'),
(3159, 1358, 301, 5, 483, 144000, N'Active'),
(3160, 1359, 300, 4, 394, 108000, N'Active'),
(3161, 1360, 305, 4, 403, 90000, N'Active'),
(3162, 1360, 305, 4, 404, 90000, N'Active'),
(3163, 1360, 305, 4, 405, 90000, N'Active'),
(3164, 1361, 252, 3, 303, 90000, N'Active'),
(3165, 1361, 252, 3, 304, 90000, N'Active'),
(3166, 1361, 252, 3, 305, 90000, N'Active'),
(3167, 1362, 278, 5, 532, 144000, N'Active'),
(3168, 1362, 278, 5, 533, 144000, N'Active'),
(3169, 1363, 294, 5, 509, 144000, N'Active'),
(3170, 1363, 294, 5, 510, 144000, N'Active'),
(3171, 1363, 294, 5, 511, 144000, N'Active'),
(3172, 1364, 249, 4, 385, 108000, N'Active'),
(3173, 1364, 249, 4, 386, 108000, N'Active'),
(3174, 1365, 271, 4, 395, 108000, N'Active'),
(3175, 1365, 271, 4, 396, 108000, N'Active'),
(3176, 1366, 277, 4, 338, 90000, N'Active'),
(3177, 1366, 277, 4, 339, 90000, N'Active'),
(3178, 1367, 273, 5, 463, 120000, N'Active'),
(3179, 1367, 273, 5, 464, 120000, N'Active'),
(3180, 1368, 264, 1, 99, 90000, N'Active'),
(3181, 1368, 264, 1, 100, 90000, N'Active'),
(3182, 1369, 270, 3, 275, 90000, N'Active'),
(3183, 1369, 270, 3, 276, 90000, N'Active'),
(3184, 1370, 251, 1, 57, 90000, N'Active'),
(3185, 1370, 251, 1, 58, 90000, N'Active'),
(3186, 1370, 251, 1, 59, 90000, N'Active'),
(3187, 1371, 275, 3, 222, 75000, N'Active'),
(3188, 1371, 275, 3, 223, 75000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 5 19/11/2026: 171 hoa don (5 huy), 393 ve, doanh thu 38.362.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(1372, 7, NULL, '2026-11-19T08:00:41', 144000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | G12
(1373, 6, NULL, '2026-11-19T08:15:58', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 262 | Godzilla Trừ Không | 19/11 12:30 | Phòng 4 | B9
(1374, 7, NULL, '2026-11-19T08:23:27', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | F4 F5
(1375, 7, 67, '2026-11-19T08:28:47', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 253 | Trại Giam Hạnh Phúc | 19/11 09:00 | Phòng 1 | E6 E7
(1376, 6, NULL, '2026-11-19T08:33:09', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 254 | Dune: Hành Tinh Cát | 19/11 09:00 | Phòng 5 | L5 L6
(1377, 6, NULL, '2026-11-19T08:39:53', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 254 | Dune: Hành Tinh Cát | 19/11 09:00 | Phòng 5 | F9 F10
(1378, 7, NULL, '2026-11-19T08:47:04', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 253 | Trại Giam Hạnh Phúc | 19/11 09:00 | Phòng 1 | J7 J8
(1379, 6, 89, '2026-11-19T08:48:55', 134000, N'Paid', N'Transfer', NULL, 13, 82, NULL, NULL, NULL), -- suat 255 | Ramayana: Khởi Nguồn Một Huyền Thoại | 19/11 09:15 | Phòng 4 | J9 J10
(1380, 6, 48, '2026-11-19T08:52:46', 432000, N'Paid', N'Cash', 440000, 30, 0, NULL, NULL, NULL), -- suat 255 | Ramayana: Khởi Nguồn Một Huyền Thoại | 19/11 09:15 | Phòng 4 | E6 E7 E8 E9
(1381, 7, NULL, '2026-11-19T08:58:00', 216000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Nhầm suất / ghế', '2026-11-19T09:13:55', 7), -- suat 318 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 12:30 | Phòng 4 | F8 F9
(1382, 6, NULL, '2026-11-19T09:09:11', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 257 | Bí Kíp Luyện Cướp | 19/11 10:00 | Phòng 3 | D2 D3
(1383, 6, NULL, '2026-11-19T09:09:52', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 318 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 12:30 | Phòng 4 | J5 J6
(1384, 7, NULL, '2026-11-19T09:15:35', 75000, N'Paid', N'Cash', 75000, 0, 0, NULL, NULL, NULL), -- suat 257 | Bí Kíp Luyện Cướp | 19/11 10:00 | Phòng 3 | C11
(1385, 7, NULL, '2026-11-19T09:17:08', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 326 | Clayface | 21/11 17:00 | Phòng 3 | D7
(1386, 7, NULL, '2026-11-19T09:19:07', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 256 | Kiến Lé Phiêu Lưu Ké | 19/11 09:30 | Phòng 2 | E2 E3 E4
(1387, 6, NULL, '2026-11-19T09:23:02', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | J1 J2
(1388, 7, NULL, '2026-11-19T09:36:41', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 262 | Godzilla Trừ Không | 19/11 12:30 | Phòng 4 | J5 J6
(1389, 6, NULL, '2026-11-19T09:50:23', 144000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 260 | Godzilla Trừ Không | 19/11 12:15 | Phòng 5 | G8
(1390, 6, 21, '2026-11-19T10:03:26', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 295 | Chàng Mèo Mang Mũ | 20/11 15:30 | Phòng 2 | D3 D4
(1391, 7, NULL, '2026-11-19T10:05:01', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 291 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 20/11 13:30 | Phòng 2 | G1 G2 G3
(1392, 7, NULL, '2026-11-19T10:05:32', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 331 | Rosetta (EUFF) | 21/11 19:15 | Phòng 3 | G8
(1393, 7, NULL, '2026-11-19T10:11:51', 216000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | F5 F6
(1394, 7, 42, '2026-11-19T10:13:16', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 314 | Kiến Lé Phiêu Lưu Ké | 21/11 11:15 | Phòng 2 | H4 H5
(1395, 6, NULL, '2026-11-19T10:16:43', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 268 | Ngày Con Còn Mẹ | 19/11 15:30 | Phòng 2 | F4 F5 F6 F7
(1396, 7, NULL, '2026-11-19T10:21:00', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 269 | Bò Sữa Bay | 19/11 16:30 | Phòng 1 | F1
(1397, 6, NULL, '2026-11-19T10:27:50', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 259 | Ngày Con Còn Mẹ | 19/11 11:30 | Phòng 1 | J7 J8
(1398, 7, 25, '2026-11-19T10:31:05', 124000, N'Paid', N'Transfer', NULL, 8, 20, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | G4
(1399, 7, NULL, '2026-11-19T10:31:23', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 270 | Clayface | 19/11 17:00 | Phòng 3 | G6 G7
(1400, 7, NULL, '2026-11-19T10:31:58', 432000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | E4 E5 E6
(1401, 6, NULL, '2026-11-19T10:38:21', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 258 | Chàng Mèo Mang Mũ | 19/11 11:15 | Phòng 2 | F2
(1402, 6, NULL, '2026-11-19T10:39:18', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 266 | Dune: Hành Tinh Cát - Phần Hai | 19/11 15:00 | Phòng 5 | J5
(1403, 6, NULL, '2026-11-19T10:44:56', 540000, N'Paid', N'Cash', 540000, 0, 0, NULL, NULL, NULL), -- suat 264 | Trại Giam Hạnh Phúc | 19/11 14:00 | Phòng 1 | G1 G2 G3 G4 G5 G6
(1404, 6, 49, '2026-11-19T10:51:31', 75000, N'Paid', N'Card', NULL, 3, 0, NULL, NULL, NULL), -- suat 261 | Kẻ Hồi Sinh | 19/11 12:30 | Phòng 3 | B7
(1405, 7, NULL, '2026-11-19T11:00:58', 270000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-19T11:33:44', 7), -- suat 285 | Bí Kíp Luyện Cướp | 20/11 10:00 | Phòng 3 | G6 G7 G8
(1406, 7, NULL, '2026-11-19T11:04:14', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 259 | Ngày Con Còn Mẹ | 19/11 11:30 | Phòng 1 | E5 E6
(1407, 6, NULL, '2026-11-19T11:09:19', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 314 | Kiến Lé Phiêu Lưu Ké | 21/11 11:15 | Phòng 2 | E3
(1408, 6, NULL, '2026-11-19T11:17:53', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 268 | Ngày Con Còn Mẹ | 19/11 15:30 | Phòng 2 | D6 D7 D8 D9
(1409, 6, NULL, '2026-11-19T11:24:52', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | H9
(1410, 6, NULL, '2026-11-19T11:28:45', 324000, N'Paid', N'Cash', 324000, 0, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | E5 E6 E7
(1411, 6, 67, '2026-11-19T11:30:24', 158000, N'Paid', N'Cash', 200000, 11, 22, NULL, NULL, NULL), -- suat 264 | Trại Giam Hạnh Phúc | 19/11 14:00 | Phòng 1 | D7 D8
(1412, 7, NULL, '2026-11-19T11:30:32', 225000, N'Paid', N'Cash', 225000, 0, 0, NULL, NULL, NULL), -- suat 269 | Bò Sữa Bay | 19/11 16:30 | Phòng 1 | B6 B7 B8
(1413, 7, NULL, '2026-11-19T11:30:39', 450000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 297 | Bò Sữa Bay | 20/11 16:30 | Phòng 1 | E3 E4 E5 E6 E7
(1414, 6, NULL, '2026-11-19T11:30:56', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 305 | Bí Kíp Luyện Cướp | 20/11 21:00 | Phòng 4 | D2 D3
(1415, 7, NULL, '2026-11-19T11:36:56', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 263 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 19/11 13:30 | Phòng 2 | F1 F2 F3 F4
(1416, 7, NULL, '2026-11-19T11:41:46', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 266 | Dune: Hành Tinh Cát - Phần Hai | 19/11 15:00 | Phòng 5 | K6 K7
(1417, 7, NULL, '2026-11-19T11:43:13', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 335 | Chị Chị Em Em 3 | 21/11 21:30 | Phòng 1 | H8 H9 H10 H11
(1418, 6, NULL, '2026-11-19T11:46:30', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 304 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 20/11 20:45 | Phòng 2 | F3 F4
(1419, 7, NULL, '2026-11-19T11:51:55', 324000, N'Paid', N'Cash', 350000, 0, 0, NULL, NULL, NULL), -- suat 271 | Ramayana: Khởi Nguồn Một Huyền Thoại | 19/11 17:45 | Phòng 4 | H5 H6 H7
(1420, 6, 72, '2026-11-19T11:54:17', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 289 | Kẻ Hồi Sinh | 20/11 12:30 | Phòng 3 | E5 E6
(1421, 6, 44, '2026-11-19T12:02:41', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 274 | Trại Giam Hạnh Phúc | 19/11 19:00 | Phòng 1 | H9 H10 H11
(1422, 7, NULL, '2026-11-19T12:04:04', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 263 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 19/11 13:30 | Phòng 2 | B8 B9
(1423, 7, 21, '2026-11-19T12:09:50', 288000, N'Paid', N'Transfer', NULL, 28, 0, NULL, NULL, NULL), -- suat 273 | Godzilla Trừ Không | 19/11 18:15 | Phòng 5 | L3 L4
(1424, 6, 93, '2026-11-19T12:15:31', 240000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 273 | Godzilla Trừ Không | 19/11 18:15 | Phòng 5 | D10 D11
(1425, 6, NULL, '2026-11-19T12:25:59', 240000, N'Paid', N'Cash', 240000, 0, 0, NULL, NULL, NULL), -- suat 266 | Dune: Hành Tinh Cát - Phần Hai | 19/11 15:00 | Phòng 5 | C8 C9
(1426, 6, NULL, '2026-11-19T12:33:22', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 273 | Godzilla Trừ Không | 19/11 18:15 | Phòng 5 | G5 G6
(1427, 6, 70, '2026-11-19T12:35:08', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 264 | Trại Giam Hạnh Phúc | 19/11 14:00 | Phòng 1 | E11 E12
(1428, 7, 23, '2026-11-19T12:35:53', 360000, N'Paid', N'Cash', 360000, 25, 0, NULL, NULL, NULL), -- suat 267 | Bí Kíp Luyện Cướp | 19/11 15:15 | Phòng 4 | D2 D3 D4 D5
(1429, 7, NULL, '2026-11-19T12:39:04', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 267 | Bí Kíp Luyện Cướp | 19/11 15:15 | Phòng 4 | E8 E9 E10
(1430, 6, 35, '2026-11-19T12:44:20', 450000, N'Paid', N'Cash', 450000, 31, 0, NULL, NULL, NULL), -- suat 269 | Bò Sữa Bay | 19/11 16:30 | Phòng 1 | E3 E4 E5 E6 E7
(1431, 7, NULL, '2026-11-19T12:46:18', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 303 | Ngày Con Còn Mẹ | 20/11 19:15 | Phòng 3 | C5
(1432, 6, 93, '2026-11-19T12:54:26', 216000, N'Paid', N'Cash', 250000, 15, 0, NULL, NULL, NULL), -- suat 318 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 12:30 | Phòng 4 | E8 E9
(1433, 7, NULL, '2026-11-19T12:55:03', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 317 | Kẻ Hồi Sinh | 21/11 12:30 | Phòng 3 | H7
(1434, 6, 92, '2026-11-19T13:01:25', 75000, N'Paid', N'Card', NULL, 7, 105, NULL, NULL, NULL), -- suat 275 | Ngày Con Còn Mẹ | 19/11 19:15 | Phòng 3 | J11 J12
(1435, 7, NULL, '2026-11-19T13:08:54', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 267 | Bí Kíp Luyện Cướp | 19/11 15:15 | Phòng 4 | F4 F5 F6
(1436, 6, NULL, '2026-11-19T13:18:01', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | G2 G3
(1437, 7, NULL, '2026-11-19T13:19:24', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 266 | Dune: Hành Tinh Cát - Phần Hai | 19/11 15:00 | Phòng 5 | H5
(1438, 6, NULL, '2026-11-19T13:19:35', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 299 | Trại Buôn Người | 20/11 18:00 | Phòng 2 | J11 J12
(1439, 6, 24, '2026-11-19T13:23:42', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 295 | Chàng Mèo Mang Mũ | 20/11 15:30 | Phòng 2 | H2 H3
(1440, 6, NULL, '2026-11-19T13:26:47', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 271 | Ramayana: Khởi Nguồn Một Huyền Thoại | 19/11 17:45 | Phòng 4 | G3 G4
(1441, 7, 4, '2026-11-19T13:35:27', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 272 | Trại Buôn Người | 19/11 18:00 | Phòng 2 | G4
(1442, 7, NULL, '2026-11-19T13:37:08', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | F6 F7
(1443, 7, NULL, '2026-11-19T13:51:17', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 266 | Dune: Hành Tinh Cát - Phần Hai | 19/11 15:00 | Phòng 5 | F6
(1444, 7, NULL, '2026-11-19T13:51:19', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 326 | Clayface | 21/11 17:00 | Phòng 3 | J7 J8
(1445, 7, NULL, '2026-11-19T13:54:43', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 265 | Thiên Đường Tăm Tối | 19/11 14:45 | Phòng 3 | J5 J6
(1446, 6, NULL, '2026-11-19T14:03:52', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 274 | Trại Giam Hạnh Phúc | 19/11 19:00 | Phòng 1 | F3 F4
(1447, 7, NULL, '2026-11-19T14:07:41', 108000, N'Paid', N'Cash', 108000, 0, 0, NULL, NULL, NULL), -- suat 277 | Godzilla Trừ Không | 19/11 21:00 | Phòng 4 | D5
(1448, 7, NULL, '2026-11-19T14:07:42', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 280 | Trại Giam Hạnh Phúc | 19/11 21:30 | Phòng 3 | H5
(1449, 6, 64, '2026-11-19T14:08:31', 131000, N'Cancelled', N'Transfer', NULL, 9, 49, N'Khách đổi ý', '2026-11-19T14:38:46', 6), -- suat 274 | Trại Giam Hạnh Phúc | 19/11 19:00 | Phòng 1 | F8 F9
(1450, 7, NULL, '2026-11-19T14:10:15', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 282 | Dune: Hành Tinh Cát | 20/11 09:00 | Phòng 5 | A6 A7
(1451, 6, NULL, '2026-11-19T14:11:37', 450000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 304 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 20/11 20:45 | Phòng 2 | F6 F7 F8 F9 F10
(1452, 7, NULL, '2026-11-19T14:12:13', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 274 | Trại Giam Hạnh Phúc | 19/11 19:00 | Phòng 1 | H4 H5 H6 H7
(1453, 6, NULL, '2026-11-19T14:23:06', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 293 | Thiên Đường Tăm Tối | 20/11 14:45 | Phòng 3 | E6 E7 E8 E9
(1454, 7, NULL, '2026-11-19T14:29:56', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 268 | Ngày Con Còn Mẹ | 19/11 15:30 | Phòng 2 | G7 G8
(1455, 6, NULL, '2026-11-19T14:34:15', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 274 | Trại Giam Hạnh Phúc | 19/11 19:00 | Phòng 1 | G7 G8
(1456, 7, 14, '2026-11-19T14:36:46', 216000, N'Paid', N'Cash', 220000, 15, 0, NULL, NULL, NULL), -- suat 271 | Ramayana: Khởi Nguồn Một Huyền Thoại | 19/11 17:45 | Phòng 4 | E9 E10
(1457, 6, NULL, '2026-11-19T14:40:53', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 273 | Godzilla Trừ Không | 19/11 18:15 | Phòng 5 | H12
(1458, 6, NULL, '2026-11-19T14:43:13', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 273 | Godzilla Trừ Không | 19/11 18:15 | Phòng 5 | L7 L8
(1459, 7, NULL, '2026-11-19T14:45:56', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 272 | Trại Buôn Người | 19/11 18:00 | Phòng 2 | H9 H10 H11
(1460, 6, NULL, '2026-11-19T14:46:30', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 275 | Ngày Con Còn Mẹ | 19/11 19:15 | Phòng 3 | F10 F11
(1461, 6, 15, '2026-11-19T14:51:52', 180000, N'Paid', N'Cash', 200000, 18, 0, NULL, NULL, NULL), -- suat 268 | Ngày Con Còn Mẹ | 19/11 15:30 | Phòng 2 | J3 J4
(1462, 6, 21, '2026-11-19T14:54:30', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 324 | Godzilla Trừ Không | 21/11 15:30 | Phòng 4 | H2 H3
(1463, 6, NULL, '2026-11-19T14:56:06', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 275 | Ngày Con Còn Mẹ | 19/11 19:15 | Phòng 3 | F3 F4 F5 F6
(1464, 6, NULL, '2026-11-19T14:56:08', 450000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 274 | Trại Giam Hạnh Phúc | 19/11 19:00 | Phòng 1 | A2 A3 A4 A5 A6 A7
(1465, 9, NULL, '2026-11-19T15:03:55', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 276 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 19/11 20:45 | Phòng 2 | E1 E2
(1466, 9, NULL, '2026-11-19T15:04:02', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 282 | Dune: Hành Tinh Cát | 20/11 09:00 | Phòng 5 | F7 F8
(1467, 9, NULL, '2026-11-19T15:08:50', 576000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 294 | Dune: Hành Tinh Cát - Phần Hai | 20/11 15:00 | Phòng 5 | K5 K6 K7 K8
(1468, 9, 53, '2026-11-19T15:16:01', 576000, N'Paid', N'Transfer', NULL, 40, 0, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | E4 E5 E6 E7
(1469, 9, NULL, '2026-11-19T15:18:08', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 287 | Ngày Con Còn Mẹ | 20/11 11:30 | Phòng 1 | E3 E4 E5
(1470, 9, NULL, '2026-11-19T15:18:54', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 292 | Trại Giam Hạnh Phúc | 20/11 14:00 | Phòng 1 | H3 H4 H5
(1471, 9, 53, '2026-11-19T15:19:25', 30000, N'Paid', N'Transfer', NULL, 1, 90, NULL, NULL, NULL), -- suat 294 | Dune: Hành Tinh Cát - Phần Hai | 20/11 15:00 | Phòng 5 | A4
(1472, 9, NULL, '2026-11-19T15:29:06', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 273 | Godzilla Trừ Không | 19/11 18:15 | Phòng 5 | E5 E6
(1473, 9, NULL, '2026-11-19T15:36:47', 216000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 271 | Ramayana: Khởi Nguồn Một Huyền Thoại | 19/11 17:45 | Phòng 4 | E7 E8
(1474, 8, NULL, '2026-11-19T15:39:02', 120000, N'Paid', N'Cash', 120000, 0, 0, NULL, NULL, NULL), -- suat 288 | Godzilla Trừ Không | 20/11 12:15 | Phòng 5 | C6
(1475, 8, NULL, '2026-11-19T15:58:57', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 290 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 12:30 | Phòng 4 | J1 J2
(1476, 9, NULL, '2026-11-19T15:59:06', 120000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 273 | Godzilla Trừ Không | 19/11 18:15 | Phòng 5 | D3
(1477, 9, NULL, '2026-11-19T16:13:14', 648000, N'Paid', N'Cash', 650000, 0, 0, NULL, NULL, NULL), -- suat 277 | Godzilla Trừ Không | 19/11 21:00 | Phòng 4 | D7 D8 D9 D10 D11 D12
(1478, 9, NULL, '2026-11-19T16:20:10', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 279 | Chị Chị Em Em 3 | 19/11 21:30 | Phòng 1 | F6
(1479, 9, NULL, '2026-11-19T16:22:27', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 273 | Godzilla Trừ Không | 19/11 18:15 | Phòng 5 | J3 J4 J5 J6
(1480, 9, NULL, '2026-11-19T16:23:50', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 298 | Clayface | 20/11 17:00 | Phòng 3 | E7 E8 E9
(1481, 9, NULL, '2026-11-19T16:25:43', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 304 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 20/11 20:45 | Phòng 2 | G5 G6
(1482, 9, NULL, '2026-11-19T16:31:22', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 303 | Ngày Con Còn Mẹ | 20/11 19:15 | Phòng 3 | F4 F5
(1483, 8, 1, '2026-11-19T16:34:55', 250000, N'Paid', N'Card', NULL, 12, 50, NULL, NULL, NULL), -- suat 274 | Trại Giam Hạnh Phúc | 19/11 19:00 | Phòng 1 | C5 C6 C7 C8
(1484, 8, 82, '2026-11-19T16:38:45', 108000, N'Cancelled', N'Transfer', NULL, 7, 0, N'Khách đổi ý', '2026-11-19T16:49:53', 8), -- suat 271 | Ramayana: Khởi Nguồn Một Huyền Thoại | 19/11 17:45 | Phòng 4 | H8
(1485, 9, NULL, '2026-11-19T16:40:58', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 275 | Ngày Con Còn Mẹ | 19/11 19:15 | Phòng 3 | J5 J6
(1486, 9, NULL, '2026-11-19T16:45:21', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 274 | Trại Giam Hạnh Phúc | 19/11 19:00 | Phòng 1 | F5 F6 F7 F8
(1487, 9, 78, '2026-11-19T16:46:46', 720000, N'Paid', N'Cash', 720000, 50, 0, NULL, NULL, NULL), -- suat 278 | Dune: Hành Tinh Cát - Phần Hai | 19/11 21:00 | Phòng 5 | H1 H2 H3 H4 H5
(1488, 8, 48, '2026-11-19T16:49:14', 288000, N'Paid', N'Cash', 300000, 20, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | J7 J8
(1489, 9, 67, '2026-11-19T16:52:09', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 309 | Trại Giam Hạnh Phúc | 21/11 09:00 | Phòng 1 | D5
(1490, 8, 109, '2026-11-19T16:53:44', 450000, N'Paid', N'Cash', 450000, 22, 0, NULL, NULL, NULL), -- suat 275 | Ngày Con Còn Mẹ | 19/11 19:15 | Phòng 3 | C1 C2 C3 C4 C5 C6
(1491, 9, NULL, '2026-11-19T16:59:12', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 278 | Dune: Hành Tinh Cát - Phần Hai | 19/11 21:00 | Phòng 5 | L7 L8
(1492, 9, 75, '2026-11-19T17:02:39', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 276 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 19/11 20:45 | Phòng 2 | A6 A7
(1493, 9, NULL, '2026-11-19T17:03:08', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 284 | Ma Mút Con Vượt Kỷ Băng Hà | 20/11 09:30 | Phòng 2 | H4
(1494, 8, 46, '2026-11-19T17:04:19', 124000, N'Paid', N'Transfer', NULL, 8, 20, NULL, NULL, NULL), -- suat 278 | Dune: Hành Tinh Cát - Phần Hai | 19/11 21:00 | Phòng 5 | F12
(1495, 8, NULL, '2026-11-19T17:12:05', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 277 | Godzilla Trừ Không | 19/11 21:00 | Phòng 4 | C2 C3 C4 C5
(1496, 9, 114, '2026-11-19T17:12:23', 10000, N'Paid', N'Cash', 50000, 0, 65, NULL, NULL, NULL), -- suat 272 | Trại Buôn Người | 19/11 18:00 | Phòng 2 | A3
(1497, 9, NULL, '2026-11-19T17:20:01', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 275 | Ngày Con Còn Mẹ | 19/11 19:15 | Phòng 3 | E9
(1498, 9, 93, '2026-11-19T17:29:56', 10000, N'Paid', N'Transfer', NULL, 0, 170, NULL, NULL, NULL), -- suat 336 | Trại Giam Hạnh Phúc | 21/11 21:30 | Phòng 3 | G6 G7
(1499, 8, NULL, '2026-11-19T17:42:55', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 278 | Dune: Hành Tinh Cát - Phần Hai | 19/11 21:00 | Phòng 5 | E6 E7 E8
(1500, 8, 103, '2026-11-19T17:48:47', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 276 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 19/11 20:45 | Phòng 2 | F6 F7
(1501, 9, 76, '2026-11-19T17:49:22', 360000, N'Paid', N'Cash', 400000, 25, 0, NULL, NULL, NULL), -- suat 274 | Trại Giam Hạnh Phúc | 19/11 19:00 | Phòng 1 | E8 E9 E10 E11
(1502, 9, NULL, '2026-11-19T17:49:48', 225000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 336 | Trại Giam Hạnh Phúc | 21/11 21:30 | Phòng 3 | C10 C11 C12
(1503, 8, NULL, '2026-11-19T17:54:47', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 274 | Trại Giam Hạnh Phúc | 19/11 19:00 | Phòng 1 | B6 B7 B8
(1504, 9, 37, '2026-11-19T17:56:33', 576000, N'Paid', N'Card', NULL, 40, 0, NULL, NULL, NULL), -- suat 278 | Dune: Hành Tinh Cát - Phần Hai | 19/11 21:00 | Phòng 5 | F6 F7 F8 F9
(1505, 9, NULL, '2026-11-19T17:59:30', 450000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 275 | Ngày Con Còn Mẹ | 19/11 19:15 | Phòng 3 | G3 G4 G5 G6 G7
(1506, 9, NULL, '2026-11-19T18:00:32', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 275 | Ngày Con Còn Mẹ | 19/11 19:15 | Phòng 3 | G10
(1507, 9, NULL, '2026-11-19T18:01:34', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 279 | Chị Chị Em Em 3 | 19/11 21:30 | Phòng 1 | E6 E7
(1508, 9, NULL, '2026-11-19T18:06:46', 300000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 276 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 19/11 20:45 | Phòng 2 | C3 C4 C5 C6
(1509, 8, NULL, '2026-11-19T18:08:25', 225000, N'Paid', N'Cash', 230000, 0, 0, NULL, NULL, NULL), -- suat 308 | Trại Giam Hạnh Phúc | 20/11 21:30 | Phòng 3 | B8 B9 B10
(1510, 8, 78, '2026-11-19T18:14:18', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 307 | Chị Chị Em Em 3 | 20/11 21:30 | Phòng 1 | F6 F7
(1511, 9, 66, '2026-11-19T18:15:51', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 274 | Trại Giam Hạnh Phúc | 19/11 19:00 | Phòng 1 | E5
(1512, 9, NULL, '2026-11-19T18:18:10', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 308 | Trại Giam Hạnh Phúc | 20/11 21:30 | Phòng 3 | F7 F8
(1513, 9, NULL, '2026-11-19T18:19:57', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 274 | Trại Giam Hạnh Phúc | 19/11 19:00 | Phòng 1 | D5 D6
(1514, 9, NULL, '2026-11-19T18:30:59', 120000, N'Paid', N'Cash', 120000, 0, 0, NULL, NULL, NULL), -- suat 288 | Godzilla Trừ Không | 20/11 12:15 | Phòng 5 | D9
(1515, 9, NULL, '2026-11-19T18:31:05', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 280 | Trại Giam Hạnh Phúc | 19/11 21:30 | Phòng 3 | H2 H3
(1516, 8, NULL, '2026-11-19T18:34:39', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 281 | Trại Giam Hạnh Phúc | 20/11 09:00 | Phòng 1 | D9 D10
(1517, 9, 25, '2026-11-19T18:39:30', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 275 | Ngày Con Còn Mẹ | 19/11 19:15 | Phòng 3 | D1 D2 D3
(1518, 8, 72, '2026-11-19T18:57:08', 270000, N'Paid', N'Cash', 300000, 18, 0, NULL, NULL, NULL), -- suat 276 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 19/11 20:45 | Phòng 2 | G9 G10 G11
(1519, 8, NULL, '2026-11-19T18:59:59', 108000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 277 | Godzilla Trừ Không | 19/11 21:00 | Phòng 4 | E6
(1520, 9, NULL, '2026-11-19T19:17:04', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 277 | Godzilla Trừ Không | 19/11 21:00 | Phòng 4 | H5 H6 H7 H8
(1521, 8, NULL, '2026-11-19T19:24:58', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 323 | Chàng Mèo Mang Mũ | 21/11 15:30 | Phòng 2 | H11
(1522, 9, 113, '2026-11-19T19:29:00', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 276 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 19/11 20:45 | Phòng 2 | G4 G5
(1523, 9, 42, '2026-11-19T19:41:48', 144000, N'Paid', N'Transfer', NULL, 10, 0, NULL, NULL, NULL), -- suat 288 | Godzilla Trừ Không | 20/11 12:15 | Phòng 5 | F10
(1524, 9, 113, '2026-11-19T19:43:48', 180000, N'Paid', N'Cash', 200000, 18, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | J7 J8
(1525, 8, 23, '2026-11-19T19:45:10', 268000, N'Paid', N'Card', NULL, 18, 20, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | G5 G6
(1526, 9, NULL, '2026-11-19T19:46:01', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 303 | Ngày Con Còn Mẹ | 20/11 19:15 | Phòng 3 | F6 F7
(1527, 9, NULL, '2026-11-19T19:55:49', 108000, N'Paid', N'Cash', 108000, 0, 0, NULL, NULL, NULL), -- suat 296 | Godzilla Trừ Không | 20/11 15:30 | Phòng 4 | D4
(1528, 8, NULL, '2026-11-19T19:56:01', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | L5 L6
(1529, 9, NULL, '2026-11-19T19:56:10', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 280 | Trại Giam Hạnh Phúc | 19/11 21:30 | Phòng 3 | D6 D7
(1530, 8, NULL, '2026-11-19T19:56:50', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 280 | Trại Giam Hạnh Phúc | 19/11 21:30 | Phòng 3 | D3 D4
(1531, 8, NULL, '2026-11-19T20:04:00', 108000, N'Cancelled', N'Cash', 110000, 0, 0, N'Khách đổi ý', '2026-11-19T20:31:05', 8), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | D1
(1532, 8, NULL, '2026-11-19T20:12:15', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 309 | Trại Giam Hạnh Phúc | 21/11 09:00 | Phòng 1 | F6 F7
(1533, 8, NULL, '2026-11-19T20:24:30', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 299 | Trại Buôn Người | 20/11 18:00 | Phòng 2 | J7 J8
(1534, 9, NULL, '2026-11-19T20:24:49', 120000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 294 | Dune: Hành Tinh Cát - Phần Hai | 20/11 15:00 | Phòng 5 | C10
(1535, 9, 54, '2026-11-19T20:24:55', 432000, N'Paid', N'Transfer', NULL, 30, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | D3 D4 D5 D6
(1536, 8, NULL, '2026-11-19T21:02:08', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | G10 G11
(1537, 8, NULL, '2026-11-19T21:11:08', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 326 | Clayface | 21/11 17:00 | Phòng 3 | J5 J6
(1538, 8, NULL, '2026-11-19T21:11:16', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | L3 L4
(1539, 9, NULL, '2026-11-19T21:19:31', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 330 | Trại Giam Hạnh Phúc | 21/11 19:00 | Phòng 1 | D11 D12
(1540, 8, 94, '2026-11-19T21:19:52', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 325 | Bò Sữa Bay | 21/11 16:30 | Phòng 1 | D5 D6
(1541, 9, NULL, '2026-11-19T21:21:32', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 283 | Ramayana: Khởi Nguồn Một Huyền Thoại | 20/11 09:15 | Phòng 4 | J9 J10
(1542, 8, NULL, '2026-11-19T21:27:38', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL); -- suat 332 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 21/11 20:45 | Phòng 2 | H7 H8
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(3189, 1372, 329, 5, 516, 144000, N'Active'),
(3190, 1373, 262, 4, 345, 90000, N'Active'),
(3191, 1374, 302, 1, 64, 90000, N'Active'),
(3192, 1374, 302, 1, 65, 90000, N'Active'),
(3193, 1375, 253, 1, 54, 90000, N'Active'),
(3194, 1375, 253, 1, 55, 90000, N'Active'),
(3195, 1376, 254, 5, 557, 144000, N'Active'),
(3196, 1376, 254, 5, 558, 144000, N'Active'),
(3197, 1377, 254, 5, 501, 144000, N'Active'),
(3198, 1377, 254, 5, 502, 144000, N'Active'),
(3199, 1378, 253, 1, 103, 90000, N'Active'),
(3200, 1378, 253, 1, 104, 90000, N'Active'),
(3201, 1379, 255, 4, 429, 108000, N'Active'),
(3202, 1379, 255, 4, 430, 108000, N'Active'),
(3203, 1380, 255, 4, 378, 108000, N'Active'),
(3204, 1380, 255, 4, 379, 108000, N'Active'),
(3205, 1380, 255, 4, 380, 108000, N'Active'),
(3206, 1380, 255, 4, 381, 108000, N'Active'),
(3207, 1381, 318, 4, 392, 108000, N'Cancelled'),
(3208, 1381, 318, 4, 393, 108000, N'Cancelled'),
(3209, 1382, 257, 3, 254, 90000, N'Active'),
(3210, 1382, 257, 3, 255, 90000, N'Active'),
(3211, 1383, 318, 4, 425, 108000, N'Active'),
(3212, 1383, 318, 4, 426, 108000, N'Active'),
(3213, 1384, 257, 3, 251, 75000, N'Active'),
(3214, 1385, 326, 3, 259, 90000, N'Active'),
(3215, 1386, 256, 2, 158, 90000, N'Active'),
(3216, 1386, 256, 2, 159, 90000, N'Active'),
(3217, 1386, 256, 2, 160, 90000, N'Active'),
(3218, 1387, 301, 5, 529, 144000, N'Active'),
(3219, 1387, 301, 5, 530, 144000, N'Active'),
(3220, 1388, 262, 4, 425, 108000, N'Active'),
(3221, 1388, 262, 4, 426, 108000, N'Active'),
(3222, 1389, 260, 5, 512, 144000, N'Active'),
(3223, 1390, 295, 2, 147, 90000, N'Active'),
(3224, 1390, 295, 2, 148, 90000, N'Active'),
(3225, 1391, 291, 2, 181, 90000, N'Active'),
(3226, 1391, 291, 2, 182, 90000, N'Active'),
(3227, 1391, 291, 2, 183, 90000, N'Active'),
(3228, 1392, 331, 3, 296, 90000, N'Active'),
(3229, 1393, 328, 4, 389, 108000, N'Active'),
(3230, 1393, 328, 4, 390, 108000, N'Active'),
(3231, 1394, 314, 2, 196, 90000, N'Active'),
(3232, 1394, 314, 2, 197, 90000, N'Active'),
(3233, 1395, 268, 2, 172, 90000, N'Active'),
(3234, 1395, 268, 2, 173, 90000, N'Active'),
(3235, 1395, 268, 2, 174, 90000, N'Active'),
(3236, 1395, 268, 2, 175, 90000, N'Active'),
(3237, 1396, 269, 1, 61, 90000, N'Active'),
(3238, 1397, 259, 1, 103, 90000, N'Active'),
(3239, 1397, 259, 1, 104, 90000, N'Active'),
(3240, 1398, 301, 5, 508, 144000, N'Active'),
(3241, 1399, 270, 3, 294, 90000, N'Active'),
(3242, 1399, 270, 3, 295, 90000, N'Active'),
(3243, 1400, 329, 5, 484, 144000, N'Active'),
(3244, 1400, 329, 5, 485, 144000, N'Active'),
(3245, 1400, 329, 5, 486, 144000, N'Active'),
(3246, 1401, 258, 2, 170, 90000, N'Active'),
(3247, 1402, 266, 5, 533, 144000, N'Active'),
(3248, 1403, 264, 1, 73, 90000, N'Active'),
(3249, 1403, 264, 1, 74, 90000, N'Active'),
(3250, 1403, 264, 1, 75, 90000, N'Active'),
(3251, 1403, 264, 1, 76, 90000, N'Active'),
(3252, 1403, 264, 1, 77, 90000, N'Active'),
(3253, 1403, 264, 1, 78, 90000, N'Active'),
(3254, 1404, 261, 3, 235, 75000, N'Active'),
(3255, 1405, 285, 3, 294, 90000, N'Cancelled'),
(3256, 1405, 285, 3, 295, 90000, N'Cancelled'),
(3257, 1405, 285, 3, 296, 90000, N'Cancelled'),
(3258, 1406, 259, 1, 53, 90000, N'Active'),
(3259, 1406, 259, 1, 54, 90000, N'Active'),
(3260, 1407, 314, 2, 159, 90000, N'Active'),
(3261, 1408, 268, 2, 150, 90000, N'Active'),
(3262, 1408, 268, 2, 151, 90000, N'Active'),
(3263, 1408, 268, 2, 152, 90000, N'Active'),
(3264, 1408, 268, 2, 153, 90000, N'Active'),
(3265, 1409, 306, 5, 525, 144000, N'Active'),
(3266, 1410, 300, 4, 377, 108000, N'Active'),
(3267, 1410, 300, 4, 378, 108000, N'Active'),
(3268, 1410, 300, 4, 379, 108000, N'Active'),
(3269, 1411, 264, 1, 43, 90000, N'Active'),
(3270, 1411, 264, 1, 44, 90000, N'Active'),
(3271, 1412, 269, 1, 18, 75000, N'Active'),
(3272, 1412, 269, 1, 19, 75000, N'Active'),
(3273, 1412, 269, 1, 20, 75000, N'Active'),
(3274, 1413, 297, 1, 51, 90000, N'Active'),
(3275, 1413, 297, 1, 52, 90000, N'Active'),
(3276, 1413, 297, 1, 53, 90000, N'Active'),
(3277, 1413, 297, 1, 54, 90000, N'Active'),
(3278, 1413, 297, 1, 55, 90000, N'Active'),
(3279, 1414, 305, 4, 362, 90000, N'Active'),
(3280, 1414, 305, 4, 363, 90000, N'Active'),
(3281, 1415, 263, 2, 169, 90000, N'Active'),
(3282, 1415, 263, 2, 170, 90000, N'Active'),
(3283, 1415, 263, 2, 171, 90000, N'Active'),
(3284, 1415, 263, 2, 172, 90000, N'Active'),
(3285, 1416, 266, 5, 546, 144000, N'Active'),
(3286, 1416, 266, 5, 547, 144000, N'Active'),
(3287, 1417, 335, 1, 92, 90000, N'Active'),
(3288, 1417, 335, 1, 93, 90000, N'Active'),
(3289, 1417, 335, 1, 94, 90000, N'Active'),
(3290, 1417, 335, 1, 95, 90000, N'Active'),
(3291, 1418, 304, 2, 171, 90000, N'Active'),
(3292, 1418, 304, 2, 172, 90000, N'Active'),
(3293, 1419, 271, 4, 413, 108000, N'Active'),
(3294, 1419, 271, 4, 414, 108000, N'Active'),
(3295, 1419, 271, 4, 415, 108000, N'Active'),
(3296, 1420, 289, 3, 269, 90000, N'Active'),
(3297, 1420, 289, 3, 270, 90000, N'Active'),
(3298, 1421, 274, 1, 93, 90000, N'Active'),
(3299, 1421, 274, 1, 94, 90000, N'Active'),
(3300, 1421, 274, 1, 95, 90000, N'Active'),
(3301, 1422, 263, 2, 128, 75000, N'Active'),
(3302, 1422, 263, 2, 129, 75000, N'Active'),
(3303, 1423, 273, 5, 555, 144000, N'Active'),
(3304, 1423, 273, 5, 556, 144000, N'Active'),
(3305, 1424, 273, 5, 478, 120000, N'Active'),
(3306, 1424, 273, 5, 479, 120000, N'Active'),
(3307, 1425, 266, 5, 464, 120000, N'Active'),
(3308, 1425, 266, 5, 465, 120000, N'Active'),
(3309, 1426, 273, 5, 509, 144000, N'Active'),
(3310, 1426, 273, 5, 510, 144000, N'Active'),
(3311, 1427, 264, 1, 59, 90000, N'Active'),
(3312, 1427, 264, 1, 60, 90000, N'Active'),
(3313, 1428, 267, 4, 362, 90000, N'Active'),
(3314, 1428, 267, 4, 363, 90000, N'Active'),
(3315, 1428, 267, 4, 364, 90000, N'Active'),
(3316, 1428, 267, 4, 365, 90000, N'Active'),
(3317, 1429, 267, 4, 380, 90000, N'Active'),
(3318, 1429, 267, 4, 381, 90000, N'Active'),
(3319, 1429, 267, 4, 382, 90000, N'Active'),
(3320, 1430, 269, 1, 51, 90000, N'Active'),
(3321, 1430, 269, 1, 52, 90000, N'Active'),
(3322, 1430, 269, 1, 53, 90000, N'Active'),
(3323, 1430, 269, 1, 54, 90000, N'Active'),
(3324, 1430, 269, 1, 55, 90000, N'Active'),
(3325, 1431, 303, 3, 245, 75000, N'Active'),
(3326, 1432, 318, 4, 380, 108000, N'Active'),
(3327, 1432, 318, 4, 381, 108000, N'Active'),
(3328, 1433, 317, 3, 307, 90000, N'Active'),
(3329, 1434, 275, 3, 323, 90000, N'Active'),
(3330, 1434, 275, 3, 324, 90000, N'Active'),
(3331, 1435, 267, 4, 388, 90000, N'Active'),
(3332, 1435, 267, 4, 389, 90000, N'Active'),
(3333, 1435, 267, 4, 390, 90000, N'Active'),
(3334, 1436, 306, 5, 506, 144000, N'Active'),
(3335, 1436, 306, 5, 507, 144000, N'Active'),
(3336, 1437, 266, 5, 521, 144000, N'Active'),
(3337, 1438, 299, 2, 215, 90000, N'Active'),
(3338, 1438, 299, 2, 216, 90000, N'Active'),
(3339, 1439, 295, 2, 194, 90000, N'Active'),
(3340, 1439, 295, 2, 195, 90000, N'Active'),
(3341, 1440, 271, 4, 399, 108000, N'Active'),
(3342, 1440, 271, 4, 400, 108000, N'Active'),
(3343, 1441, 272, 2, 184, 90000, N'Active'),
(3344, 1442, 301, 5, 498, 144000, N'Active'),
(3345, 1442, 301, 5, 499, 144000, N'Active'),
(3346, 1443, 266, 5, 498, 144000, N'Active'),
(3347, 1444, 326, 3, 319, 90000, N'Active'),
(3348, 1444, 326, 3, 320, 90000, N'Active'),
(3349, 1445, 265, 3, 317, 90000, N'Active'),
(3350, 1445, 265, 3, 318, 90000, N'Active'),
(3351, 1446, 274, 1, 63, 90000, N'Active'),
(3352, 1446, 274, 1, 64, 90000, N'Active'),
(3353, 1447, 277, 4, 365, 108000, N'Active'),
(3354, 1448, 280, 3, 305, 90000, N'Active'),
(3355, 1449, 274, 1, 68, 90000, N'Cancelled'),
(3356, 1449, 274, 1, 69, 90000, N'Cancelled'),
(3357, 1450, 282, 5, 438, 120000, N'Active'),
(3358, 1450, 282, 5, 439, 120000, N'Active'),
(3359, 1451, 304, 2, 174, 90000, N'Active'),
(3360, 1451, 304, 2, 175, 90000, N'Active'),
(3361, 1451, 304, 2, 176, 90000, N'Active'),
(3362, 1451, 304, 2, 177, 90000, N'Active'),
(3363, 1451, 304, 2, 178, 90000, N'Active'),
(3364, 1452, 274, 1, 88, 90000, N'Active'),
(3365, 1452, 274, 1, 89, 90000, N'Active'),
(3366, 1452, 274, 1, 90, 90000, N'Active'),
(3367, 1452, 274, 1, 91, 90000, N'Active'),
(3368, 1453, 293, 3, 270, 90000, N'Active'),
(3369, 1453, 293, 3, 271, 90000, N'Active'),
(3370, 1453, 293, 3, 272, 90000, N'Active'),
(3371, 1453, 293, 3, 273, 90000, N'Active'),
(3372, 1454, 268, 2, 187, 90000, N'Active'),
(3373, 1454, 268, 2, 188, 90000, N'Active'),
(3374, 1455, 274, 1, 79, 90000, N'Active'),
(3375, 1455, 274, 1, 80, 90000, N'Active'),
(3376, 1456, 271, 4, 381, 108000, N'Active'),
(3377, 1456, 271, 4, 382, 108000, N'Active'),
(3378, 1457, 273, 5, 528, 144000, N'Active'),
(3379, 1458, 273, 5, 559, 144000, N'Active'),
(3380, 1458, 273, 5, 560, 144000, N'Active'),
(3381, 1459, 272, 2, 201, 90000, N'Active'),
(3382, 1459, 272, 2, 202, 90000, N'Active'),
(3383, 1459, 272, 2, 203, 90000, N'Active'),
(3384, 1460, 275, 3, 286, 90000, N'Active'),
(3385, 1460, 275, 3, 287, 90000, N'Active'),
(3386, 1461, 268, 2, 207, 90000, N'Active'),
(3387, 1461, 268, 2, 208, 90000, N'Active'),
(3388, 1462, 324, 4, 410, 108000, N'Active'),
(3389, 1462, 324, 4, 411, 108000, N'Active'),
(3390, 1463, 275, 3, 279, 90000, N'Active'),
(3391, 1463, 275, 3, 280, 90000, N'Active'),
(3392, 1463, 275, 3, 281, 90000, N'Active'),
(3393, 1463, 275, 3, 282, 90000, N'Active'),
(3394, 1464, 274, 1, 2, 75000, N'Active'),
(3395, 1464, 274, 1, 3, 75000, N'Active'),
(3396, 1464, 274, 1, 4, 75000, N'Active'),
(3397, 1464, 274, 1, 5, 75000, N'Active'),
(3398, 1464, 274, 1, 6, 75000, N'Active'),
(3399, 1464, 274, 1, 7, 75000, N'Active'),
(3400, 1465, 276, 2, 157, 90000, N'Active'),
(3401, 1465, 276, 2, 158, 90000, N'Active'),
(3402, 1466, 282, 5, 499, 144000, N'Active'),
(3403, 1466, 282, 5, 500, 144000, N'Active'),
(3404, 1467, 294, 5, 545, 144000, N'Active'),
(3405, 1467, 294, 5, 546, 144000, N'Active'),
(3406, 1467, 294, 5, 547, 144000, N'Active'),
(3407, 1467, 294, 5, 548, 144000, N'Active'),
(3408, 1468, 306, 5, 484, 144000, N'Active'),
(3409, 1468, 306, 5, 485, 144000, N'Active'),
(3410, 1468, 306, 5, 486, 144000, N'Active'),
(3411, 1468, 306, 5, 487, 144000, N'Active'),
(3412, 1469, 287, 1, 51, 90000, N'Active'),
(3413, 1469, 287, 1, 52, 90000, N'Active'),
(3414, 1469, 287, 1, 53, 90000, N'Active'),
(3415, 1470, 292, 1, 87, 90000, N'Active'),
(3416, 1470, 292, 1, 88, 90000, N'Active'),
(3417, 1470, 292, 1, 89, 90000, N'Active'),
(3418, 1471, 294, 5, 436, 120000, N'Active'),
(3419, 1472, 273, 5, 485, 144000, N'Active'),
(3420, 1472, 273, 5, 486, 144000, N'Active'),
(3421, 1473, 271, 4, 379, 108000, N'Active'),
(3422, 1473, 271, 4, 380, 108000, N'Active'),
(3423, 1474, 288, 5, 462, 120000, N'Active'),
(3424, 1475, 290, 4, 421, 108000, N'Active'),
(3425, 1475, 290, 4, 422, 108000, N'Active'),
(3426, 1476, 273, 5, 471, 120000, N'Active'),
(3427, 1477, 277, 4, 367, 108000, N'Active'),
(3428, 1477, 277, 4, 368, 108000, N'Active'),
(3429, 1477, 277, 4, 369, 108000, N'Active'),
(3430, 1477, 277, 4, 370, 108000, N'Active'),
(3431, 1477, 277, 4, 371, 108000, N'Active'),
(3432, 1477, 277, 4, 372, 108000, N'Active'),
(3433, 1478, 279, 1, 66, 90000, N'Active'),
(3434, 1479, 273, 5, 531, 144000, N'Active'),
(3435, 1479, 273, 5, 532, 144000, N'Active'),
(3436, 1479, 273, 5, 533, 144000, N'Active'),
(3437, 1479, 273, 5, 534, 144000, N'Active'),
(3438, 1480, 298, 3, 271, 90000, N'Active'),
(3439, 1480, 298, 3, 272, 90000, N'Active'),
(3440, 1480, 298, 3, 273, 90000, N'Active'),
(3441, 1481, 304, 2, 185, 90000, N'Active'),
(3442, 1481, 304, 2, 186, 90000, N'Active'),
(3443, 1482, 303, 3, 280, 90000, N'Active'),
(3444, 1482, 303, 3, 281, 90000, N'Active'),
(3445, 1483, 274, 1, 29, 75000, N'Active'),
(3446, 1483, 274, 1, 30, 75000, N'Active'),
(3447, 1483, 274, 1, 31, 75000, N'Active'),
(3448, 1483, 274, 1, 32, 75000, N'Active'),
(3449, 1484, 271, 4, 416, 108000, N'Cancelled'),
(3450, 1485, 275, 3, 317, 90000, N'Active'),
(3451, 1485, 275, 3, 318, 90000, N'Active'),
(3452, 1486, 274, 1, 65, 90000, N'Active'),
(3453, 1486, 274, 1, 66, 90000, N'Active'),
(3454, 1486, 274, 1, 67, 90000, N'Active'),
(3455, 1486, 274, 1, 68, 90000, N'Active'),
(3456, 1487, 278, 5, 517, 144000, N'Active'),
(3457, 1487, 278, 5, 518, 144000, N'Active'),
(3458, 1487, 278, 5, 519, 144000, N'Active'),
(3459, 1487, 278, 5, 520, 144000, N'Active'),
(3460, 1487, 278, 5, 521, 144000, N'Active'),
(3461, 1488, 301, 5, 535, 144000, N'Active'),
(3462, 1488, 301, 5, 536, 144000, N'Active'),
(3463, 1489, 309, 1, 41, 90000, N'Active'),
(3464, 1490, 275, 3, 241, 75000, N'Active'),
(3465, 1490, 275, 3, 242, 75000, N'Active'),
(3466, 1490, 275, 3, 243, 75000, N'Active'),
(3467, 1490, 275, 3, 244, 75000, N'Active'),
(3468, 1490, 275, 3, 245, 75000, N'Active'),
(3469, 1490, 275, 3, 246, 75000, N'Active'),
(3470, 1491, 278, 5, 559, 144000, N'Active'),
(3471, 1491, 278, 5, 560, 144000, N'Active'),
(3472, 1492, 276, 2, 114, 75000, N'Active'),
(3473, 1492, 276, 2, 115, 75000, N'Active'),
(3474, 1493, 284, 2, 196, 90000, N'Active'),
(3475, 1494, 278, 5, 504, 144000, N'Active'),
(3476, 1495, 277, 4, 350, 90000, N'Active'),
(3477, 1495, 277, 4, 351, 90000, N'Active'),
(3478, 1495, 277, 4, 352, 90000, N'Active'),
(3479, 1495, 277, 4, 353, 90000, N'Active'),
(3480, 1496, 272, 2, 111, 75000, N'Active'),
(3481, 1497, 275, 3, 273, 90000, N'Active'),
(3482, 1498, 336, 3, 294, 90000, N'Active'),
(3483, 1498, 336, 3, 295, 90000, N'Active'),
(3484, 1499, 278, 5, 486, 144000, N'Active'),
(3485, 1499, 278, 5, 487, 144000, N'Active'),
(3486, 1499, 278, 5, 488, 144000, N'Active'),
(3487, 1500, 276, 2, 174, 90000, N'Active'),
(3488, 1500, 276, 2, 175, 90000, N'Active'),
(3489, 1501, 274, 1, 56, 90000, N'Active'),
(3490, 1501, 274, 1, 57, 90000, N'Active'),
(3491, 1501, 274, 1, 58, 90000, N'Active'),
(3492, 1501, 274, 1, 59, 90000, N'Active'),
(3493, 1502, 336, 3, 250, 75000, N'Active'),
(3494, 1502, 336, 3, 251, 75000, N'Active'),
(3495, 1502, 336, 3, 252, 75000, N'Active'),
(3496, 1503, 274, 1, 18, 75000, N'Active'),
(3497, 1503, 274, 1, 19, 75000, N'Active'),
(3498, 1503, 274, 1, 20, 75000, N'Active'),
(3499, 1504, 278, 5, 498, 144000, N'Active'),
(3500, 1504, 278, 5, 499, 144000, N'Active'),
(3501, 1504, 278, 5, 500, 144000, N'Active'),
(3502, 1504, 278, 5, 501, 144000, N'Active'),
(3503, 1505, 275, 3, 291, 90000, N'Active'),
(3504, 1505, 275, 3, 292, 90000, N'Active'),
(3505, 1505, 275, 3, 293, 90000, N'Active'),
(3506, 1505, 275, 3, 294, 90000, N'Active'),
(3507, 1505, 275, 3, 295, 90000, N'Active'),
(3508, 1506, 275, 3, 298, 90000, N'Active'),
(3509, 1507, 279, 1, 54, 90000, N'Active'),
(3510, 1507, 279, 1, 55, 90000, N'Active'),
(3511, 1508, 276, 2, 135, 75000, N'Active'),
(3512, 1508, 276, 2, 136, 75000, N'Active'),
(3513, 1508, 276, 2, 137, 75000, N'Active'),
(3514, 1508, 276, 2, 138, 75000, N'Active'),
(3515, 1509, 308, 3, 236, 75000, N'Active'),
(3516, 1509, 308, 3, 237, 75000, N'Active'),
(3517, 1509, 308, 3, 238, 75000, N'Active'),
(3518, 1510, 307, 1, 66, 90000, N'Active'),
(3519, 1510, 307, 1, 67, 90000, N'Active'),
(3520, 1511, 274, 1, 53, 90000, N'Active'),
(3521, 1512, 308, 3, 283, 90000, N'Active'),
(3522, 1512, 308, 3, 284, 90000, N'Active'),
(3523, 1513, 274, 1, 41, 90000, N'Active'),
(3524, 1513, 274, 1, 42, 90000, N'Active'),
(3525, 1514, 288, 5, 477, 120000, N'Active'),
(3526, 1515, 280, 3, 302, 90000, N'Active'),
(3527, 1515, 280, 3, 303, 90000, N'Active'),
(3528, 1516, 281, 1, 45, 90000, N'Active'),
(3529, 1516, 281, 1, 46, 90000, N'Active'),
(3530, 1517, 275, 3, 253, 90000, N'Active'),
(3531, 1517, 275, 3, 254, 90000, N'Active'),
(3532, 1517, 275, 3, 255, 90000, N'Active'),
(3533, 1518, 276, 2, 189, 90000, N'Active'),
(3534, 1518, 276, 2, 190, 90000, N'Active'),
(3535, 1518, 276, 2, 191, 90000, N'Active'),
(3536, 1519, 277, 4, 378, 108000, N'Active'),
(3537, 1520, 277, 4, 413, 108000, N'Active'),
(3538, 1520, 277, 4, 414, 108000, N'Active'),
(3539, 1520, 277, 4, 415, 108000, N'Active'),
(3540, 1520, 277, 4, 416, 108000, N'Active'),
(3541, 1521, 323, 2, 203, 90000, N'Active'),
(3542, 1522, 276, 2, 184, 90000, N'Active'),
(3543, 1522, 276, 2, 185, 90000, N'Active'),
(3544, 1523, 288, 5, 502, 144000, N'Active'),
(3545, 1524, 302, 1, 103, 90000, N'Active'),
(3546, 1524, 302, 1, 104, 90000, N'Active'),
(3547, 1525, 306, 5, 509, 144000, N'Active'),
(3548, 1525, 306, 5, 510, 144000, N'Active'),
(3549, 1526, 303, 3, 282, 90000, N'Active'),
(3550, 1526, 303, 3, 283, 90000, N'Active'),
(3551, 1527, 296, 4, 364, 108000, N'Active'),
(3552, 1528, 301, 5, 557, 144000, N'Active'),
(3553, 1528, 301, 5, 558, 144000, N'Active'),
(3554, 1529, 280, 3, 258, 90000, N'Active'),
(3555, 1529, 280, 3, 259, 90000, N'Active'),
(3556, 1530, 280, 3, 255, 90000, N'Active'),
(3557, 1530, 280, 3, 256, 90000, N'Active'),
(3558, 1531, 300, 4, 361, 108000, N'Cancelled'),
(3559, 1532, 309, 1, 66, 90000, N'Active'),
(3560, 1532, 309, 1, 67, 90000, N'Active'),
(3561, 1533, 299, 2, 211, 90000, N'Active'),
(3562, 1533, 299, 2, 212, 90000, N'Active'),
(3563, 1534, 294, 5, 466, 120000, N'Active'),
(3564, 1535, 300, 4, 363, 108000, N'Active'),
(3565, 1535, 300, 4, 364, 108000, N'Active'),
(3566, 1535, 300, 4, 365, 108000, N'Active'),
(3567, 1535, 300, 4, 366, 108000, N'Active'),
(3568, 1536, 329, 5, 514, 144000, N'Active'),
(3569, 1536, 329, 5, 515, 144000, N'Active'),
(3570, 1537, 326, 3, 317, 90000, N'Active'),
(3571, 1537, 326, 3, 318, 90000, N'Active'),
(3572, 1538, 306, 5, 555, 144000, N'Active'),
(3573, 1538, 306, 5, 556, 144000, N'Active'),
(3574, 1539, 330, 1, 47, 90000, N'Active'),
(3575, 1539, 330, 1, 48, 90000, N'Active'),
(3576, 1540, 325, 1, 41, 90000, N'Active'),
(3577, 1540, 325, 1, 42, 90000, N'Active'),
(3578, 1541, 283, 4, 429, 108000, N'Active'),
(3579, 1541, 283, 4, 430, 108000, N'Active'),
(3580, 1542, 332, 2, 199, 90000, N'Active'),
(3581, 1542, 332, 2, 200, 90000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 6 20/11/2026: 226 hoa don (7 huy), 504 ve, doanh thu 49.882.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(1543, 9, NULL, '2026-11-20T08:00:25', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 339 | Ramayana: Khởi Nguồn Một Huyền Thoại | 22/11 09:15 | Phòng 4 | F4 F5
(1544, 10, 94, '2026-11-20T08:13:38', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 309 | Trại Giam Hạnh Phúc | 21/11 09:00 | Phòng 1 | G11 G12
(1545, 3, 1, '2026-11-20T08:22:53', 360000, N'Cancelled', N'Cash', 400000, 25, 0, N'Nhầm suất / ghế', '2026-11-20T08:25:36', 3), -- suat 281 | Trại Giam Hạnh Phúc | 20/11 09:00 | Phòng 1 | D4 D5 D6 D7
(1546, 9, NULL, '2026-11-20T08:24:04', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 282 | Dune: Hành Tinh Cát | 20/11 09:00 | Phòng 5 | J11 J12
(1547, 9, NULL, '2026-11-20T08:28:27', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 324 | Godzilla Trừ Không | 21/11 15:30 | Phòng 4 | B6
(1548, 3, NULL, '2026-11-20T08:31:50', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 326 | Clayface | 21/11 17:00 | Phòng 3 | H7 H8 H9 H10
(1549, 10, NULL, '2026-11-20T08:38:28', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 283 | Ramayana: Khởi Nguồn Một Huyền Thoại | 20/11 09:15 | Phòng 4 | H2 H3
(1550, 10, NULL, '2026-11-20T08:39:09', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 281 | Trại Giam Hạnh Phúc | 20/11 09:00 | Phòng 1 | G9 G10 G11 G12
(1551, 3, NULL, '2026-11-20T08:40:18', 120000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 288 | Godzilla Trừ Không | 20/11 12:15 | Phòng 5 | B7
(1552, 3, NULL, '2026-11-20T08:44:33', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 284 | Ma Mút Con Vượt Kỷ Băng Hà | 20/11 09:30 | Phòng 2 | A5 A6
(1553, 9, NULL, '2026-11-20T08:51:05', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 287 | Ngày Con Còn Mẹ | 20/11 11:30 | Phòng 1 | G4 G5
(1554, 9, NULL, '2026-11-20T08:51:22', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 281 | Trại Giam Hạnh Phúc | 20/11 09:00 | Phòng 1 | H1 H2 H3 H4
(1555, 9, 117, '2026-11-20T09:00:23', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 292 | Trại Giam Hạnh Phúc | 20/11 14:00 | Phòng 1 | G4 G5
(1556, 3, 77, '2026-11-20T09:02:54', 75000, N'Paid', N'Transfer', NULL, 3, 0, NULL, NULL, NULL), -- suat 286 | Kiến Lé Phiêu Lưu Ké | 20/11 11:15 | Phòng 2 | B1
(1557, 9, 42, '2026-11-20T09:04:57', 216000, N'Paid', N'Cash', 216000, 15, 0, NULL, NULL, NULL), -- suat 283 | Ramayana: Khởi Nguồn Một Huyền Thoại | 20/11 09:15 | Phòng 4 | D7 D8
(1558, 3, 25, '2026-11-20T09:08:43', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 292 | Trại Giam Hạnh Phúc | 20/11 14:00 | Phòng 1 | F11
(1559, 10, NULL, '2026-11-20T09:09:00', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 316 | Godzilla Trừ Không | 21/11 12:15 | Phòng 5 | G3 G4 G5 G6
(1560, 3, NULL, '2026-11-20T09:11:45', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 285 | Bí Kíp Luyện Cướp | 20/11 10:00 | Phòng 3 | A2
(1561, 9, NULL, '2026-11-20T09:16:24', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 285 | Bí Kíp Luyện Cướp | 20/11 10:00 | Phòng 3 | F3 F4
(1562, 9, NULL, '2026-11-20T09:20:58', 648000, N'Paid', N'Cash', 648000, 0, 0, NULL, NULL, NULL), -- suat 296 | Godzilla Trừ Không | 20/11 15:30 | Phòng 4 | G3 G4 G5 G6 G7 G8
(1563, 9, 46, '2026-11-20T09:23:59', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 289 | Kẻ Hồi Sinh | 20/11 12:30 | Phòng 3 | D3 D4
(1564, 3, NULL, '2026-11-20T09:26:38', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 290 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 12:30 | Phòng 4 | F2 F3
(1565, 9, NULL, '2026-11-20T09:26:51', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | D6 D7
(1566, 9, 30, '2026-11-20T09:27:24', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 285 | Bí Kíp Luyện Cướp | 20/11 10:00 | Phòng 3 | F6 F7
(1567, 3, NULL, '2026-11-20T09:28:38', 240000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-11-20T10:01:42', 3), -- suat 288 | Godzilla Trừ Không | 20/11 12:15 | Phòng 5 | C8 C9
(1568, 9, NULL, '2026-11-20T09:28:50', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 288 | Godzilla Trừ Không | 20/11 12:15 | Phòng 5 | A5 A6 A7
(1569, 3, NULL, '2026-11-20T09:39:46', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 288 | Godzilla Trừ Không | 20/11 12:15 | Phòng 5 | J8 J9
(1570, 10, NULL, '2026-11-20T09:47:28', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 289 | Kẻ Hồi Sinh | 20/11 12:30 | Phòng 3 | G9 G10
(1571, 10, NULL, '2026-11-20T09:47:54', 108000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 296 | Godzilla Trừ Không | 20/11 15:30 | Phòng 4 | E9
(1572, 3, 54, '2026-11-20T09:50:30', 108000, N'Paid', N'Cash', 200000, 7, 0, NULL, NULL, NULL), -- suat 324 | Godzilla Trừ Không | 21/11 15:30 | Phòng 4 | F1
(1573, 9, NULL, '2026-11-20T09:53:05', 225000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 295 | Chàng Mèo Mang Mũ | 20/11 15:30 | Phòng 2 | A6 A7 A8
(1574, 3, NULL, '2026-11-20T09:59:34', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | H7
(1575, 9, NULL, '2026-11-20T10:00:53', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 289 | Kẻ Hồi Sinh | 20/11 12:30 | Phòng 3 | H11 H12
(1576, 3, 106, '2026-11-20T10:04:28', 216000, N'Paid', N'Transfer', NULL, 21, 0, NULL, NULL, NULL), -- suat 290 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 12:30 | Phòng 4 | J11 J12
(1577, 3, 117, '2026-11-20T10:05:40', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 363 | Chị Chị Em Em 3 | 22/11 21:30 | Phòng 1 | G9 G10
(1578, 9, NULL, '2026-11-20T10:05:54', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 335 | Chị Chị Em Em 3 | 21/11 21:30 | Phòng 1 | E2 E3 E4 E5
(1579, 9, 93, '2026-11-20T10:16:14', 270000, N'Paid', N'Cash', 270000, 13, 0, NULL, NULL, NULL), -- suat 290 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 12:30 | Phòng 4 | A10 A11 A12
(1580, 10, 40, '2026-11-20T10:17:32', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 336 | Trại Giam Hạnh Phúc | 21/11 21:30 | Phòng 3 | C6 C7
(1581, 9, NULL, '2026-11-20T10:18:12', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 318 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 12:30 | Phòng 4 | H4
(1582, 9, NULL, '2026-11-20T10:21:44', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 292 | Trại Giam Hạnh Phúc | 20/11 14:00 | Phòng 1 | H1 H2
(1583, 9, 44, '2026-11-20T10:23:33', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 312 | Ma Mút Con Vượt Kỷ Băng Hà | 21/11 09:30 | Phòng 2 | G2 G3
(1584, 9, 66, '2026-11-20T10:24:02', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 330 | Trại Giam Hạnh Phúc | 21/11 19:00 | Phòng 1 | B4 B5
(1585, 10, 69, '2026-11-20T10:28:03', 180000, N'Paid', N'Cash', 180000, 18, 0, NULL, NULL, NULL), -- suat 319 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 21/11 13:30 | Phòng 2 | J7 J8
(1586, 3, NULL, '2026-11-20T10:28:13', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 294 | Dune: Hành Tinh Cát - Phần Hai | 20/11 15:00 | Phòng 5 | F9 F10
(1587, 3, 33, '2026-11-20T10:32:29', 285000, N'Paid', N'Cash', 285000, 19, 75, NULL, NULL, NULL), -- suat 299 | Trại Buôn Người | 20/11 18:00 | Phòng 2 | H4 H5 H6 H7
(1588, 10, NULL, '2026-11-20T10:35:12', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 312 | Ma Mút Con Vượt Kỷ Băng Hà | 21/11 09:30 | Phòng 2 | J5 J6
(1589, 10, NULL, '2026-11-20T10:37:15', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 289 | Kẻ Hồi Sinh | 20/11 12:30 | Phòng 3 | F9 F10 F11 F12
(1590, 3, NULL, '2026-11-20T10:39:05', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 286 | Kiến Lé Phiêu Lưu Ké | 20/11 11:15 | Phòng 2 | F7 F8
(1591, 10, NULL, '2026-11-20T10:41:11', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 288 | Godzilla Trừ Không | 20/11 12:15 | Phòng 5 | L5 L6
(1592, 10, NULL, '2026-11-20T10:43:26', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | L3 L4
(1593, 9, 15, '2026-11-20T10:43:44', 250000, N'Paid', N'Cash', 300000, 17, 110, NULL, NULL, NULL), -- suat 326 | Clayface | 21/11 17:00 | Phòng 3 | G1 G2 G3 G4
(1594, 9, 105, '2026-11-20T10:46:09', 864000, N'Paid', N'Cash', 864000, 60, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | H1 H2 H3 H4 H5 H6
(1595, 10, NULL, '2026-11-20T10:51:11', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 333 | Bí Kíp Luyện Cướp | 21/11 21:00 | Phòng 4 | E1
(1596, 3, NULL, '2026-11-20T10:51:39', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | E10 E11
(1597, 10, 108, '2026-11-20T10:56:07', 150000, N'Paid', N'Transfer', NULL, 10, 30, NULL, NULL, NULL), -- suat 293 | Thiên Đường Tăm Tối | 20/11 14:45 | Phòng 3 | G5 G6
(1598, 9, NULL, '2026-11-20T10:58:17', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 292 | Trại Giam Hạnh Phúc | 20/11 14:00 | Phòng 1 | E11 E12
(1599, 3, 21, '2026-11-20T10:59:11', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 288 | Godzilla Trừ Không | 20/11 12:15 | Phòng 5 | E10 E11
(1600, 3, NULL, '2026-11-20T10:59:43', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 287 | Ngày Con Còn Mẹ | 20/11 11:30 | Phòng 1 | G8 G9
(1601, 3, NULL, '2026-11-20T11:02:05', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 320 | Trại Giam Hạnh Phúc | 21/11 14:00 | Phòng 1 | H8
(1602, 9, NULL, '2026-11-20T11:03:35', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 294 | Dune: Hành Tinh Cát - Phần Hai | 20/11 15:00 | Phòng 5 | E3 E4 E5
(1603, 9, NULL, '2026-11-20T11:06:15', 216000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-11-20T11:47:05', 9), -- suat 290 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 12:30 | Phòng 4 | H4 H5
(1604, 10, 115, '2026-11-20T11:11:11', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | K7 K8
(1605, 9, NULL, '2026-11-20T11:16:14', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 292 | Trại Giam Hạnh Phúc | 20/11 14:00 | Phòng 1 | F5 F6 F7
(1606, 10, NULL, '2026-11-20T11:18:50', 324000, N'Paid', N'Cash', 324000, 0, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | G4 G5 G6
(1607, 9, 6, '2026-11-20T11:26:10', 180000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 292 | Trại Giam Hạnh Phúc | 20/11 14:00 | Phòng 1 | E4 E5
(1608, 3, NULL, '2026-11-20T11:26:32', 150000, N'Cancelled', N'Cash', 150000, 0, 0, N'Lỗi thanh toán', '2026-11-20T11:38:51', 3), -- suat 299 | Trại Buôn Người | 20/11 18:00 | Phòng 2 | C4 C5
(1609, 3, NULL, '2026-11-20T11:32:50', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 290 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 12:30 | Phòng 4 | C6 C7 C8 C9
(1610, 10, NULL, '2026-11-20T11:36:40', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 298 | Clayface | 20/11 17:00 | Phòng 3 | D11
(1611, 10, NULL, '2026-11-20T11:39:01', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 360 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 22/11 20:45 | Phòng 2 | G3 G4 G5
(1612, 3, NULL, '2026-11-20T11:41:48', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 346 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 12:30 | Phòng 4 | E4 E5
(1613, 9, NULL, '2026-11-20T11:43:09', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | E1 E2
(1614, 3, NULL, '2026-11-20T11:45:13', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 297 | Bò Sữa Bay | 20/11 16:30 | Phòng 1 | D9 D10
(1615, 10, 113, '2026-11-20T11:47:16', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 309 | Trại Giam Hạnh Phúc | 21/11 09:00 | Phòng 1 | D3
(1616, 9, NULL, '2026-11-20T11:48:45', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 290 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 12:30 | Phòng 4 | F8 F9
(1617, 9, 67, '2026-11-20T11:51:03', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 292 | Trại Giam Hạnh Phúc | 20/11 14:00 | Phòng 1 | J7 J8
(1618, 10, 62, '2026-11-20T11:51:28', 324000, N'Paid', N'Transfer', NULL, 22, 0, NULL, NULL, NULL), -- suat 311 | Ramayana: Khởi Nguồn Một Huyền Thoại | 21/11 09:15 | Phòng 4 | G7 G8 G9
(1619, 9, NULL, '2026-11-20T11:53:52', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | F3 F4 F5 F6
(1620, 3, NULL, '2026-11-20T11:54:13', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 303 | Ngày Con Còn Mẹ | 20/11 19:15 | Phòng 3 | F8
(1621, 10, 118, '2026-11-20T11:55:05', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 289 | Kẻ Hồi Sinh | 20/11 12:30 | Phòng 3 | E8
(1622, 3, NULL, '2026-11-20T11:56:25', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | J5 J6
(1623, 9, NULL, '2026-11-20T12:02:21', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Nhầm suất / ghế', '2026-11-20T12:08:46', 9), -- suat 298 | Clayface | 20/11 17:00 | Phòng 3 | D6 D7
(1624, 3, 15, '2026-11-20T12:06:06', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 294 | Dune: Hành Tinh Cát - Phần Hai | 20/11 15:00 | Phòng 5 | J3 J4
(1625, 3, NULL, '2026-11-20T12:08:32', 576000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | F2 F3 F4 F5
(1626, 9, NULL, '2026-11-20T12:09:17', 240000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 294 | Dune: Hành Tinh Cát - Phần Hai | 20/11 15:00 | Phòng 5 | C3 C4
(1627, 3, NULL, '2026-11-20T12:12:58', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | J4 J5 J6
(1628, 9, 42, '2026-11-20T12:14:03', 108000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 296 | Godzilla Trừ Không | 20/11 15:30 | Phòng 4 | E5
(1629, 10, NULL, '2026-11-20T12:16:52', 108000, N'Paid', N'Cash', 110000, 0, 0, NULL, NULL, NULL), -- suat 296 | Godzilla Trừ Không | 20/11 15:30 | Phòng 4 | D5
(1630, 3, 29, '2026-11-20T12:22:31', 216000, N'Paid', N'Card', NULL, 21, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | J9 J10
(1631, 9, NULL, '2026-11-20T12:28:37', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | D6 D7
(1632, 3, NULL, '2026-11-20T12:32:31', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 303 | Ngày Con Còn Mẹ | 20/11 19:15 | Phòng 3 | J9 J10
(1633, 10, NULL, '2026-11-20T12:33:43', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 331 | Rosetta (EUFF) | 21/11 19:15 | Phòng 3 | F5 F6 F7
(1634, 10, NULL, '2026-11-20T12:36:29', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 333 | Bí Kíp Luyện Cướp | 21/11 21:00 | Phòng 4 | D7 D8
(1635, 9, 26, '2026-11-20T12:38:05', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 292 | Trại Giam Hạnh Phúc | 20/11 14:00 | Phòng 1 | G7 G8
(1636, 3, 3, '2026-11-20T12:38:48', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 292 | Trại Giam Hạnh Phúc | 20/11 14:00 | Phòng 1 | D1
(1637, 3, NULL, '2026-11-20T12:41:55', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 293 | Thiên Đường Tăm Tối | 20/11 14:45 | Phòng 3 | C3 C4
(1638, 9, NULL, '2026-11-20T12:46:11', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 294 | Dune: Hành Tinh Cát - Phần Hai | 20/11 15:00 | Phòng 5 | F6 F7 F8
(1639, 3, NULL, '2026-11-20T12:47:12', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | K6 K7
(1640, 9, 70, '2026-11-20T12:51:22', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | H7 H8
(1641, 3, NULL, '2026-11-20T12:53:14', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | E3 E4 E5 E6
(1642, 3, NULL, '2026-11-20T12:53:23', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 297 | Bò Sữa Bay | 20/11 16:30 | Phòng 1 | H9 H10 H11
(1643, 9, NULL, '2026-11-20T12:58:45', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | E9 E10 E11
(1644, 10, 109, '2026-11-20T12:58:48', 225000, N'Paid', N'Cash', 225000, 11, 0, NULL, NULL, NULL), -- suat 303 | Ngày Con Còn Mẹ | 20/11 19:15 | Phòng 3 | B8 B9 B10
(1645, 10, NULL, '2026-11-20T12:59:24', 480000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 294 | Dune: Hành Tinh Cát - Phần Hai | 20/11 15:00 | Phòng 5 | D6 D7 D8 D9
(1646, 10, 72, '2026-11-20T13:03:30', 144000, N'Paid', N'Transfer', NULL, 10, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | G8
(1647, 10, NULL, '2026-11-20T13:13:27', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | C12
(1648, 10, NULL, '2026-11-20T13:13:31', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | L9 L10
(1649, 3, 93, '2026-11-20T13:14:10', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | J3 J4
(1650, 10, NULL, '2026-11-20T13:15:41', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 305 | Bí Kíp Luyện Cướp | 20/11 21:00 | Phòng 4 | C6 C7
(1651, 9, 55, '2026-11-20T13:17:22', 480000, N'Paid', N'Cash', 480000, 24, 0, NULL, NULL, NULL), -- suat 294 | Dune: Hành Tinh Cát - Phần Hai | 20/11 15:00 | Phòng 5 | B3 B4 B5 B6
(1652, 9, 113, '2026-11-20T13:21:16', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 294 | Dune: Hành Tinh Cát - Phần Hai | 20/11 15:00 | Phòng 5 | H8 H9
(1653, 10, NULL, '2026-11-20T13:22:05', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 298 | Clayface | 20/11 17:00 | Phòng 3 | C3 C4
(1654, 10, NULL, '2026-11-20T13:31:52', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 354 | Clayface | 22/11 17:00 | Phòng 3 | F6 F7
(1655, 9, 82, '2026-11-20T13:37:26', 180000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 333 | Bí Kíp Luyện Cướp | 21/11 21:00 | Phòng 4 | J11 J12
(1656, 9, NULL, '2026-11-20T13:39:32', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 294 | Dune: Hành Tinh Cát - Phần Hai | 20/11 15:00 | Phòng 5 | E8
(1657, 9, NULL, '2026-11-20T13:40:41', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | C6 C7
(1658, 9, NULL, '2026-11-20T13:46:27', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | G7
(1659, 3, 66, '2026-11-20T13:47:08', 216000, N'Paid', N'Cash', 300000, 15, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | G7 G8
(1660, 9, NULL, '2026-11-20T13:51:59', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 294 | Dune: Hành Tinh Cát - Phần Hai | 20/11 15:00 | Phòng 5 | J8 J9
(1661, 9, NULL, '2026-11-20T13:53:39', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 304 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 20/11 20:45 | Phòng 2 | B11 B12
(1662, 10, NULL, '2026-11-20T13:55:03', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 297 | Bò Sữa Bay | 20/11 16:30 | Phòng 1 | F7 F8
(1663, 3, 102, '2026-11-20T13:57:35', 108000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | E10
(1664, 3, NULL, '2026-11-20T13:59:17', 108000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 296 | Godzilla Trừ Không | 20/11 15:30 | Phòng 4 | E3
(1665, 9, NULL, '2026-11-20T13:59:57', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | F9 F10
(1666, 3, 25, '2026-11-20T14:00:33', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 320 | Trại Giam Hạnh Phúc | 21/11 14:00 | Phòng 1 | E7 E8
(1667, 9, NULL, '2026-11-20T14:01:38', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 295 | Chàng Mèo Mang Mũ | 20/11 15:30 | Phòng 2 | G9 G10 G11 G12
(1668, 10, NULL, '2026-11-20T14:02:22', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 294 | Dune: Hành Tinh Cát - Phần Hai | 20/11 15:00 | Phòng 5 | A8 A9 A10
(1669, 9, NULL, '2026-11-20T14:03:45', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 295 | Chàng Mèo Mang Mũ | 20/11 15:30 | Phòng 2 | G5
(1670, 3, NULL, '2026-11-20T14:07:27', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 294 | Dune: Hành Tinh Cát - Phần Hai | 20/11 15:00 | Phòng 5 | J6 J7
(1671, 3, NULL, '2026-11-20T14:12:09', 108000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | E8
(1672, 3, NULL, '2026-11-20T14:17:04', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 296 | Godzilla Trừ Không | 20/11 15:30 | Phòng 4 | D11 D12
(1673, 10, NULL, '2026-11-20T14:17:06', 216000, N'Paid', N'Cash', 220000, 0, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | J11 J12
(1674, 3, 30, '2026-11-20T14:20:55', 270000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 320 | Trại Giam Hạnh Phúc | 21/11 14:00 | Phòng 1 | F1 F2 F3
(1675, 9, NULL, '2026-11-20T14:33:48', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | F6
(1676, 3, NULL, '2026-11-20T14:34:59', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | E7 E8
(1677, 10, NULL, '2026-11-20T14:37:06', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 356 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 18:00 | Phòng 4 | B6
(1678, 3, 32, '2026-11-20T14:42:22', 180000, N'Paid', N'Transfer', NULL, 9, 0, NULL, NULL, NULL), -- suat 296 | Godzilla Trừ Không | 20/11 15:30 | Phòng 4 | B11 B12
(1679, 9, NULL, '2026-11-20T14:45:37', 480000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 334 | Dune: Hành Tinh Cát - Phần Hai | 21/11 21:00 | Phòng 5 | D1 D2 D3 D4
(1680, 3, NULL, '2026-11-20T14:45:45', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | H8 H9
(1681, 9, 15, '2026-11-20T14:58:08', 360000, N'Paid', N'Cash', 400000, 25, 0, NULL, NULL, NULL), -- suat 308 | Trại Giam Hạnh Phúc | 20/11 21:30 | Phòng 3 | H8 H9 H10 H11
(1682, 3, NULL, '2026-11-20T14:59:47', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 332 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 21/11 20:45 | Phòng 2 | D8 D9 D10
(1683, 4, NULL, '2026-11-20T15:05:40', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 359 | Rosetta (EUFF) | 22/11 19:15 | Phòng 3 | A4 A5
(1684, 5, NULL, '2026-11-20T15:09:11', 75000, N'Paid', N'Cash', 80000, 0, 0, NULL, NULL, NULL), -- suat 297 | Bò Sữa Bay | 20/11 16:30 | Phòng 1 | C6
(1685, 6, NULL, '2026-11-20T15:11:08', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | D3 D4 D5
(1686, 5, NULL, '2026-11-20T15:16:47', 75000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 314 | Kiến Lé Phiêu Lưu Ké | 21/11 11:15 | Phòng 2 | C11
(1687, 5, NULL, '2026-11-20T15:18:17', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | F4 F5
(1688, 5, 5, '2026-11-20T15:18:29', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 298 | Clayface | 20/11 17:00 | Phòng 3 | G1 G2
(1689, 4, 49, '2026-11-20T15:24:38', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 313 | Bí Kíp Luyện Cướp | 21/11 10:00 | Phòng 3 | G6 G7 G8 G9
(1690, 5, NULL, '2026-11-20T15:26:38', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 299 | Trại Buôn Người | 20/11 18:00 | Phòng 2 | J5 J6
(1691, 4, NULL, '2026-11-20T15:28:58', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 299 | Trại Buôn Người | 20/11 18:00 | Phòng 2 | F6 F7 F8
(1692, 6, NULL, '2026-11-20T15:31:39', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 303 | Ngày Con Còn Mẹ | 20/11 19:15 | Phòng 3 | E5
(1693, 5, NULL, '2026-11-20T15:33:16', 300000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 305 | Bí Kíp Luyện Cướp | 20/11 21:00 | Phòng 4 | C9 C10 C11 C12
(1694, 5, 42, '2026-11-20T15:37:19', 180000, N'Paid', N'Cash', 200000, 18, 0, NULL, NULL, NULL), -- suat 305 | Bí Kíp Luyện Cướp | 20/11 21:00 | Phòng 4 | J5 J6
(1695, 5, 68, '2026-11-20T15:38:35', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | H7 H8
(1696, 6, 8, '2026-11-20T15:38:56', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 299 | Trại Buôn Người | 20/11 18:00 | Phòng 2 | D3 D4
(1697, 4, NULL, '2026-11-20T15:39:03', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 304 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 20/11 20:45 | Phòng 2 | H6 H7 H8
(1698, 5, 114, '2026-11-20T15:41:55', 180000, N'Paid', N'Cash', 200000, 18, 0, NULL, NULL, NULL), -- suat 307 | Chị Chị Em Em 3 | 20/11 21:30 | Phòng 1 | J7 J8
(1699, 6, NULL, '2026-11-20T15:43:09', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | E7 E8
(1700, 5, 75, '2026-11-20T15:47:04', 288000, N'Paid', N'Cash', 300000, 20, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | G8 G9
(1701, 4, NULL, '2026-11-20T15:51:53', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | D10 D11
(1702, 4, NULL, '2026-11-20T15:54:17', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | C4 C5 C6
(1703, 4, NULL, '2026-11-20T16:02:04', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | G6 G7
(1704, 4, 117, '2026-11-20T16:02:47', 576000, N'Paid', N'Cash', 600000, 40, 0, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | F1 F2 F3 F4
(1705, 4, NULL, '2026-11-20T16:07:20', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | G2 G3
(1706, 5, NULL, '2026-11-20T16:08:50', 216000, N'Paid', N'Cash', 220000, 0, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | E3 E4
(1707, 6, NULL, '2026-11-20T16:10:06', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | F10 F11 F12
(1708, 4, 6, '2026-11-20T16:10:57', 270000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | G8 G9 G10
(1709, 6, NULL, '2026-11-20T16:16:29', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | G3 G4 G5
(1710, 5, NULL, '2026-11-20T16:18:41', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | L7 L8
(1711, 4, 23, '2026-11-20T16:21:18', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | E9 E10
(1712, 5, NULL, '2026-11-20T16:25:11', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | F10 F11
(1713, 5, NULL, '2026-11-20T16:25:23', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | E6
(1714, 4, NULL, '2026-11-20T16:27:53', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | B2 B3 B4 B5
(1715, 4, NULL, '2026-11-20T16:33:00', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 300 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 20/11 18:00 | Phòng 4 | C8 C9 C10 C11
(1716, 4, NULL, '2026-11-20T16:38:20', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 305 | Bí Kíp Luyện Cướp | 20/11 21:00 | Phòng 4 | F9 F10 F11
(1717, 5, NULL, '2026-11-20T16:38:24', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 354 | Clayface | 22/11 17:00 | Phòng 3 | H7
(1718, 6, NULL, '2026-11-20T16:39:12', 240000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | D3 D4
(1719, 6, NULL, '2026-11-20T16:51:05', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 303 | Ngày Con Còn Mẹ | 20/11 19:15 | Phòng 3 | A7 A8
(1720, 6, 99, '2026-11-20T16:52:11', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | B5 B6
(1721, 4, 72, '2026-11-20T16:53:35', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 307 | Chị Chị Em Em 3 | 20/11 21:30 | Phòng 1 | E12
(1722, 6, NULL, '2026-11-20T16:54:26', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | K5
(1723, 6, NULL, '2026-11-20T16:56:08', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | J7
(1724, 5, 30, '2026-11-20T16:57:11', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 330 | Trại Giam Hạnh Phúc | 21/11 19:00 | Phòng 1 | E5
(1725, 5, NULL, '2026-11-20T16:59:16', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 304 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 20/11 20:45 | Phòng 2 | H4 H5
(1726, 6, NULL, '2026-11-20T16:59:31', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 304 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 20/11 20:45 | Phòng 2 | E7 E8
(1727, 4, 76, '2026-11-20T17:02:05', 288000, N'Cancelled', N'Cash', 500000, 28, 0, N'Khách đổi ý', '2026-11-20T17:09:47', 4), -- suat 301 | Godzilla Trừ Không | 20/11 18:15 | Phòng 5 | L9 L10
(1728, 5, NULL, '2026-11-20T17:04:10', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 308 | Trại Giam Hạnh Phúc | 20/11 21:30 | Phòng 3 | H5
(1729, 4, NULL, '2026-11-20T17:07:56', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | G10
(1730, 5, NULL, '2026-11-20T17:12:13', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | F2 F3
(1731, 6, NULL, '2026-11-20T17:22:19', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | H2 H3 H4
(1732, 4, 80, '2026-11-20T17:24:38', 540000, N'Paid', N'Transfer', NULL, 37, 0, NULL, NULL, NULL), -- suat 315 | Ngày Con Còn Mẹ | 21/11 11:30 | Phòng 1 | E6 E7 E8 E9 E10 E11
(1733, 6, NULL, '2026-11-20T17:35:01', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 308 | Trại Giam Hạnh Phúc | 20/11 21:30 | Phòng 3 | A1 A2 A3
(1734, 6, NULL, '2026-11-20T17:35:28', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 333 | Bí Kíp Luyện Cướp | 21/11 21:00 | Phòng 4 | F6 F7
(1735, 4, 42, '2026-11-20T17:37:33', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 327 | Trại Buôn Người | 21/11 18:00 | Phòng 2 | E1 E2
(1736, 6, NULL, '2026-11-20T17:42:56', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 308 | Trại Giam Hạnh Phúc | 20/11 21:30 | Phòng 3 | E12
(1737, 5, NULL, '2026-11-20T17:49:51', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 302 | Trại Giam Hạnh Phúc | 20/11 19:00 | Phòng 1 | J11 J12
(1738, 6, 67, '2026-11-20T17:50:35', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 305 | Bí Kíp Luyện Cướp | 20/11 21:00 | Phòng 4 | E6 E7 E8
(1739, 6, 55, '2026-11-20T17:53:55', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 305 | Bí Kíp Luyện Cướp | 20/11 21:00 | Phòng 4 | G1 G2
(1740, 5, NULL, '2026-11-20T18:02:42', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 307 | Chị Chị Em Em 3 | 20/11 21:30 | Phòng 1 | D7 D8 D9
(1741, 4, NULL, '2026-11-20T18:08:47', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 304 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 20/11 20:45 | Phòng 2 | E3 E4 E5 E6
(1742, 6, 46, '2026-11-20T18:09:11', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 308 | Trại Giam Hạnh Phúc | 20/11 21:30 | Phòng 3 | G5 G6 G7 G8
(1743, 4, NULL, '2026-11-20T18:16:02', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 308 | Trại Giam Hạnh Phúc | 20/11 21:30 | Phòng 3 | C8 C9
(1744, 6, 40, '2026-11-20T18:18:33', 288000, N'Paid', N'Card', NULL, 28, 0, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | L11 L12
(1745, 5, NULL, '2026-11-20T18:25:43', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 304 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 20/11 20:45 | Phòng 2 | E10 E11
(1746, 6, NULL, '2026-11-20T18:33:44', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | G5 G6
(1747, 6, NULL, '2026-11-20T18:36:18', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 308 | Trại Giam Hạnh Phúc | 20/11 21:30 | Phòng 3 | C1
(1748, 5, NULL, '2026-11-20T18:48:07', 75000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 307 | Chị Chị Em Em 3 | 20/11 21:30 | Phòng 1 | B7
(1749, 5, 30, '2026-11-20T18:59:10', 180000, N'Cancelled', N'Transfer', NULL, 12, 0, N'Lỗi thanh toán', '2026-11-20T19:09:38', 5), -- suat 304 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 20/11 20:45 | Phòng 2 | H1 H2
(1750, 4, NULL, '2026-11-20T19:02:15', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 304 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 20/11 20:45 | Phòng 2 | D6 D7
(1751, 5, NULL, '2026-11-20T19:04:29', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 335 | Chị Chị Em Em 3 | 21/11 21:30 | Phòng 1 | F8 F9
(1752, 5, NULL, '2026-11-20T19:09:31', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 320 | Trại Giam Hạnh Phúc | 21/11 14:00 | Phòng 1 | D1 D2
(1753, 6, NULL, '2026-11-20T19:25:17', 432000, N'Paid', N'Cash', 440000, 0, 0, NULL, NULL, NULL), -- suat 316 | Godzilla Trừ Không | 21/11 12:15 | Phòng 5 | K2 K3 K4
(1754, 6, NULL, '2026-11-20T19:29:58', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 308 | Trại Giam Hạnh Phúc | 20/11 21:30 | Phòng 3 | E6 E7 E8 E9
(1755, 6, 108, '2026-11-20T19:38:27', 270000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 308 | Trại Giam Hạnh Phúc | 20/11 21:30 | Phòng 3 | F3 F4 F5
(1756, 5, 111, '2026-11-20T19:51:06', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 305 | Bí Kíp Luyện Cướp | 20/11 21:00 | Phòng 4 | D7
(1757, 6, NULL, '2026-11-20T19:54:02', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 307 | Chị Chị Em Em 3 | 20/11 21:30 | Phòng 1 | B9 B10
(1758, 6, NULL, '2026-11-20T19:56:00', 240000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | A11 A12
(1759, 4, NULL, '2026-11-20T20:12:22', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 345 | Kẻ Hồi Sinh | 22/11 12:30 | Phòng 3 | J5 J6
(1760, 5, 32, '2026-11-20T20:29:39', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 307 | Chị Chị Em Em 3 | 20/11 21:30 | Phòng 1 | G10 G11
(1761, 5, NULL, '2026-11-20T20:36:34', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 306 | Dune: Hành Tinh Cát - Phần Hai | 20/11 21:00 | Phòng 5 | B7 B8
(1762, 5, NULL, '2026-11-20T20:37:54', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | F6 F7
(1763, 4, NULL, '2026-11-20T20:44:17', 270000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 305 | Bí Kíp Luyện Cướp | 20/11 21:00 | Phòng 4 | E1 E2 E3
(1764, 4, NULL, '2026-11-20T21:12:14', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 308 | Trại Giam Hạnh Phúc | 20/11 21:30 | Phòng 3 | J11 J12
(1765, 5, NULL, '2026-11-20T21:13:23', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 309 | Trại Giam Hạnh Phúc | 21/11 09:00 | Phòng 1 | G3 G4
(1766, 6, 62, '2026-11-20T21:16:51', 75000, N'Paid', N'Transfer', NULL, 3, 0, NULL, NULL, NULL), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | B4
(1767, 5, NULL, '2026-11-20T21:24:03', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | D9 D10
(1768, 5, NULL, '2026-11-20T21:39:58', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL); -- suat 334 | Dune: Hành Tinh Cát - Phần Hai | 21/11 21:00 | Phòng 5 | K7 K8
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(3582, 1543, 339, 4, 388, 108000, N'Active'),
(3583, 1543, 339, 4, 389, 108000, N'Active'),
(3584, 1544, 309, 1, 83, 90000, N'Active'),
(3585, 1544, 309, 1, 84, 90000, N'Active'),
(3586, 1545, 281, 1, 40, 90000, N'Cancelled'),
(3587, 1545, 281, 1, 41, 90000, N'Cancelled'),
(3588, 1545, 281, 1, 42, 90000, N'Cancelled'),
(3589, 1545, 281, 1, 43, 90000, N'Cancelled'),
(3590, 1546, 282, 5, 539, 144000, N'Active'),
(3591, 1546, 282, 5, 540, 144000, N'Active'),
(3592, 1547, 324, 4, 342, 90000, N'Active'),
(3593, 1548, 326, 3, 307, 90000, N'Active'),
(3594, 1548, 326, 3, 308, 90000, N'Active'),
(3595, 1548, 326, 3, 309, 90000, N'Active'),
(3596, 1548, 326, 3, 310, 90000, N'Active'),
(3597, 1549, 283, 4, 410, 108000, N'Active'),
(3598, 1549, 283, 4, 411, 108000, N'Active'),
(3599, 1550, 281, 1, 81, 90000, N'Active'),
(3600, 1550, 281, 1, 82, 90000, N'Active'),
(3601, 1550, 281, 1, 83, 90000, N'Active'),
(3602, 1550, 281, 1, 84, 90000, N'Active'),
(3603, 1551, 288, 5, 451, 120000, N'Active'),
(3604, 1552, 284, 2, 113, 75000, N'Active'),
(3605, 1552, 284, 2, 114, 75000, N'Active'),
(3606, 1553, 287, 1, 76, 90000, N'Active'),
(3607, 1553, 287, 1, 77, 90000, N'Active'),
(3608, 1554, 281, 1, 85, 90000, N'Active'),
(3609, 1554, 281, 1, 86, 90000, N'Active'),
(3610, 1554, 281, 1, 87, 90000, N'Active'),
(3611, 1554, 281, 1, 88, 90000, N'Active'),
(3612, 1555, 292, 1, 76, 90000, N'Active'),
(3613, 1555, 292, 1, 77, 90000, N'Active'),
(3614, 1556, 286, 2, 121, 75000, N'Active'),
(3615, 1557, 283, 4, 367, 108000, N'Active'),
(3616, 1557, 283, 4, 368, 108000, N'Active'),
(3617, 1558, 292, 1, 71, 90000, N'Active'),
(3618, 1559, 316, 5, 507, 144000, N'Active'),
(3619, 1559, 316, 5, 508, 144000, N'Active'),
(3620, 1559, 316, 5, 509, 144000, N'Active'),
(3621, 1559, 316, 5, 510, 144000, N'Active'),
(3622, 1560, 285, 3, 218, 75000, N'Active'),
(3623, 1561, 285, 3, 279, 90000, N'Active'),
(3624, 1561, 285, 3, 280, 90000, N'Active'),
(3625, 1562, 296, 4, 399, 108000, N'Active'),
(3626, 1562, 296, 4, 400, 108000, N'Active'),
(3627, 1562, 296, 4, 401, 108000, N'Active'),
(3628, 1562, 296, 4, 402, 108000, N'Active'),
(3629, 1562, 296, 4, 403, 108000, N'Active'),
(3630, 1562, 296, 4, 404, 108000, N'Active'),
(3631, 1563, 289, 3, 255, 90000, N'Active'),
(3632, 1563, 289, 3, 256, 90000, N'Active'),
(3633, 1564, 290, 4, 386, 108000, N'Active'),
(3634, 1564, 290, 4, 387, 108000, N'Active'),
(3635, 1565, 328, 4, 366, 108000, N'Active'),
(3636, 1565, 328, 4, 367, 108000, N'Active'),
(3637, 1566, 285, 3, 282, 90000, N'Active'),
(3638, 1566, 285, 3, 283, 90000, N'Active'),
(3639, 1567, 288, 5, 464, 120000, N'Cancelled'),
(3640, 1567, 288, 5, 465, 120000, N'Cancelled'),
(3641, 1568, 288, 5, 437, 120000, N'Active'),
(3642, 1568, 288, 5, 438, 120000, N'Active'),
(3643, 1568, 288, 5, 439, 120000, N'Active'),
(3644, 1569, 288, 5, 536, 144000, N'Active'),
(3645, 1569, 288, 5, 537, 144000, N'Active'),
(3646, 1570, 289, 3, 297, 90000, N'Active'),
(3647, 1570, 289, 3, 298, 90000, N'Active'),
(3648, 1571, 296, 4, 381, 108000, N'Active'),
(3649, 1572, 324, 4, 385, 108000, N'Active'),
(3650, 1573, 295, 2, 114, 75000, N'Active'),
(3651, 1573, 295, 2, 115, 75000, N'Active'),
(3652, 1573, 295, 2, 116, 75000, N'Active'),
(3653, 1574, 348, 1, 91, 90000, N'Active'),
(3654, 1575, 289, 3, 311, 90000, N'Active'),
(3655, 1575, 289, 3, 312, 90000, N'Active'),
(3656, 1576, 290, 4, 431, 108000, N'Active'),
(3657, 1576, 290, 4, 432, 108000, N'Active'),
(3658, 1577, 363, 1, 81, 90000, N'Active'),
(3659, 1577, 363, 1, 82, 90000, N'Active'),
(3660, 1578, 335, 1, 50, 90000, N'Active'),
(3661, 1578, 335, 1, 51, 90000, N'Active'),
(3662, 1578, 335, 1, 52, 90000, N'Active'),
(3663, 1578, 335, 1, 53, 90000, N'Active'),
(3664, 1579, 290, 4, 334, 90000, N'Active'),
(3665, 1579, 290, 4, 335, 90000, N'Active'),
(3666, 1579, 290, 4, 336, 90000, N'Active'),
(3667, 1580, 336, 3, 246, 75000, N'Active'),
(3668, 1580, 336, 3, 247, 75000, N'Active'),
(3669, 1581, 318, 4, 412, 108000, N'Active'),
(3670, 1582, 292, 1, 85, 90000, N'Active'),
(3671, 1582, 292, 1, 86, 90000, N'Active'),
(3672, 1583, 312, 2, 182, 90000, N'Active'),
(3673, 1583, 312, 2, 183, 90000, N'Active'),
(3674, 1584, 330, 1, 16, 75000, N'Active'),
(3675, 1584, 330, 1, 17, 75000, N'Active'),
(3676, 1585, 319, 2, 211, 90000, N'Active'),
(3677, 1585, 319, 2, 212, 90000, N'Active'),
(3678, 1586, 294, 5, 501, 144000, N'Active'),
(3679, 1586, 294, 5, 502, 144000, N'Active'),
(3680, 1587, 299, 2, 196, 90000, N'Active'),
(3681, 1587, 299, 2, 197, 90000, N'Active'),
(3682, 1587, 299, 2, 198, 90000, N'Active'),
(3683, 1587, 299, 2, 199, 90000, N'Active'),
(3684, 1588, 312, 2, 209, 90000, N'Active'),
(3685, 1588, 312, 2, 210, 90000, N'Active'),
(3686, 1589, 289, 3, 285, 90000, N'Active'),
(3687, 1589, 289, 3, 286, 90000, N'Active'),
(3688, 1589, 289, 3, 287, 90000, N'Active'),
(3689, 1589, 289, 3, 288, 90000, N'Active'),
(3690, 1590, 286, 2, 175, 90000, N'Active'),
(3691, 1590, 286, 2, 176, 90000, N'Active'),
(3692, 1591, 288, 5, 557, 144000, N'Active'),
(3693, 1591, 288, 5, 558, 144000, N'Active'),
(3694, 1592, 301, 5, 555, 144000, N'Active'),
(3695, 1592, 301, 5, 556, 144000, N'Active'),
(3696, 1593, 326, 3, 289, 90000, N'Active'),
(3697, 1593, 326, 3, 290, 90000, N'Active'),
(3698, 1593, 326, 3, 291, 90000, N'Active'),
(3699, 1593, 326, 3, 292, 90000, N'Active'),
(3700, 1594, 301, 5, 517, 144000, N'Active'),
(3701, 1594, 301, 5, 518, 144000, N'Active'),
(3702, 1594, 301, 5, 519, 144000, N'Active'),
(3703, 1594, 301, 5, 520, 144000, N'Active'),
(3704, 1594, 301, 5, 521, 144000, N'Active'),
(3705, 1594, 301, 5, 522, 144000, N'Active'),
(3706, 1595, 333, 4, 373, 90000, N'Active'),
(3707, 1596, 301, 5, 490, 144000, N'Active'),
(3708, 1596, 301, 5, 491, 144000, N'Active'),
(3709, 1597, 293, 3, 293, 90000, N'Active'),
(3710, 1597, 293, 3, 294, 90000, N'Active'),
(3711, 1598, 292, 1, 59, 90000, N'Active'),
(3712, 1598, 292, 1, 60, 90000, N'Active'),
(3713, 1599, 288, 5, 490, 144000, N'Active'),
(3714, 1599, 288, 5, 491, 144000, N'Active'),
(3715, 1600, 287, 1, 80, 90000, N'Active'),
(3716, 1600, 287, 1, 81, 90000, N'Active'),
(3717, 1601, 320, 1, 92, 90000, N'Active'),
(3718, 1602, 294, 5, 483, 144000, N'Active'),
(3719, 1602, 294, 5, 484, 144000, N'Active'),
(3720, 1602, 294, 5, 485, 144000, N'Active'),
(3721, 1603, 290, 4, 412, 108000, N'Cancelled'),
(3722, 1603, 290, 4, 413, 108000, N'Cancelled'),
(3723, 1604, 301, 5, 547, 144000, N'Active'),
(3724, 1604, 301, 5, 548, 144000, N'Active'),
(3725, 1605, 292, 1, 65, 90000, N'Active'),
(3726, 1605, 292, 1, 66, 90000, N'Active'),
(3727, 1605, 292, 1, 67, 90000, N'Active'),
(3728, 1606, 300, 4, 400, 108000, N'Active'),
(3729, 1606, 300, 4, 401, 108000, N'Active'),
(3730, 1606, 300, 4, 402, 108000, N'Active'),
(3731, 1607, 292, 1, 52, 90000, N'Active'),
(3732, 1607, 292, 1, 53, 90000, N'Active'),
(3733, 1608, 299, 2, 136, 75000, N'Cancelled'),
(3734, 1608, 299, 2, 137, 75000, N'Cancelled'),
(3735, 1609, 290, 4, 354, 90000, N'Active'),
(3736, 1609, 290, 4, 355, 90000, N'Active'),
(3737, 1609, 290, 4, 356, 90000, N'Active'),
(3738, 1609, 290, 4, 357, 90000, N'Active'),
(3739, 1610, 298, 3, 263, 90000, N'Active'),
(3740, 1611, 360, 2, 183, 90000, N'Active'),
(3741, 1611, 360, 2, 184, 90000, N'Active'),
(3742, 1611, 360, 2, 185, 90000, N'Active'),
(3743, 1612, 346, 4, 376, 108000, N'Active'),
(3744, 1612, 346, 4, 377, 108000, N'Active'),
(3745, 1613, 300, 4, 373, 108000, N'Active'),
(3746, 1613, 300, 4, 374, 108000, N'Active'),
(3747, 1614, 297, 1, 45, 90000, N'Active'),
(3748, 1614, 297, 1, 46, 90000, N'Active'),
(3749, 1615, 309, 1, 39, 90000, N'Active'),
(3750, 1616, 290, 4, 392, 108000, N'Active'),
(3751, 1616, 290, 4, 393, 108000, N'Active'),
(3752, 1617, 292, 1, 103, 90000, N'Active'),
(3753, 1617, 292, 1, 104, 90000, N'Active'),
(3754, 1618, 311, 4, 403, 108000, N'Active'),
(3755, 1618, 311, 4, 404, 108000, N'Active'),
(3756, 1618, 311, 4, 405, 108000, N'Active'),
(3757, 1619, 300, 4, 387, 108000, N'Active'),
(3758, 1619, 300, 4, 388, 108000, N'Active'),
(3759, 1619, 300, 4, 389, 108000, N'Active'),
(3760, 1619, 300, 4, 390, 108000, N'Active'),
(3761, 1620, 303, 3, 284, 90000, N'Active'),
(3762, 1621, 289, 3, 272, 90000, N'Active'),
(3763, 1622, 300, 4, 425, 108000, N'Active'),
(3764, 1622, 300, 4, 426, 108000, N'Active'),
(3765, 1623, 298, 3, 258, 90000, N'Cancelled'),
(3766, 1623, 298, 3, 259, 90000, N'Cancelled'),
(3767, 1624, 294, 5, 531, 144000, N'Active'),
(3768, 1624, 294, 5, 532, 144000, N'Active'),
(3769, 1625, 329, 5, 494, 144000, N'Active'),
(3770, 1625, 329, 5, 495, 144000, N'Active'),
(3771, 1625, 329, 5, 496, 144000, N'Active'),
(3772, 1625, 329, 5, 497, 144000, N'Active'),
(3773, 1626, 294, 5, 459, 120000, N'Active'),
(3774, 1626, 294, 5, 460, 120000, N'Active'),
(3775, 1627, 306, 5, 532, 144000, N'Active'),
(3776, 1627, 306, 5, 533, 144000, N'Active'),
(3777, 1627, 306, 5, 534, 144000, N'Active'),
(3778, 1628, 296, 4, 377, 108000, N'Active'),
(3779, 1629, 296, 4, 365, 108000, N'Active'),
(3780, 1630, 300, 4, 429, 108000, N'Active'),
(3781, 1630, 300, 4, 430, 108000, N'Active'),
(3782, 1631, 302, 1, 42, 90000, N'Active'),
(3783, 1631, 302, 1, 43, 90000, N'Active'),
(3784, 1632, 303, 3, 321, 90000, N'Active'),
(3785, 1632, 303, 3, 322, 90000, N'Active'),
(3786, 1633, 331, 3, 281, 90000, N'Active'),
(3787, 1633, 331, 3, 282, 90000, N'Active'),
(3788, 1633, 331, 3, 283, 90000, N'Active'),
(3789, 1634, 333, 4, 367, 90000, N'Active'),
(3790, 1634, 333, 4, 368, 90000, N'Active'),
(3791, 1635, 292, 1, 79, 90000, N'Active'),
(3792, 1635, 292, 1, 80, 90000, N'Active'),
(3793, 1636, 292, 1, 37, 90000, N'Active'),
(3794, 1637, 293, 3, 243, 75000, N'Active'),
(3795, 1637, 293, 3, 244, 75000, N'Active'),
(3796, 1638, 294, 5, 498, 144000, N'Active'),
(3797, 1638, 294, 5, 499, 144000, N'Active'),
(3798, 1638, 294, 5, 500, 144000, N'Active'),
(3799, 1639, 306, 5, 546, 144000, N'Active'),
(3800, 1639, 306, 5, 547, 144000, N'Active'),
(3801, 1640, 300, 4, 415, 108000, N'Active'),
(3802, 1640, 300, 4, 416, 108000, N'Active'),
(3803, 1641, 328, 4, 375, 108000, N'Active'),
(3804, 1641, 328, 4, 376, 108000, N'Active'),
(3805, 1641, 328, 4, 377, 108000, N'Active'),
(3806, 1641, 328, 4, 378, 108000, N'Active'),
(3807, 1642, 297, 1, 93, 90000, N'Active'),
(3808, 1642, 297, 1, 94, 90000, N'Active'),
(3809, 1642, 297, 1, 95, 90000, N'Active'),
(3810, 1643, 302, 1, 57, 90000, N'Active'),
(3811, 1643, 302, 1, 58, 90000, N'Active'),
(3812, 1643, 302, 1, 59, 90000, N'Active'),
(3813, 1644, 303, 3, 236, 75000, N'Active'),
(3814, 1644, 303, 3, 237, 75000, N'Active'),
(3815, 1644, 303, 3, 238, 75000, N'Active'),
(3816, 1645, 294, 5, 474, 120000, N'Active'),
(3817, 1645, 294, 5, 475, 120000, N'Active'),
(3818, 1645, 294, 5, 476, 120000, N'Active'),
(3819, 1645, 294, 5, 477, 120000, N'Active'),
(3820, 1646, 301, 5, 512, 144000, N'Active'),
(3821, 1647, 302, 1, 36, 75000, N'Active'),
(3822, 1648, 306, 5, 561, 144000, N'Active'),
(3823, 1648, 306, 5, 562, 144000, N'Active'),
(3824, 1649, 301, 5, 531, 144000, N'Active'),
(3825, 1649, 301, 5, 532, 144000, N'Active'),
(3826, 1650, 305, 4, 354, 75000, N'Active'),
(3827, 1650, 305, 4, 355, 75000, N'Active'),
(3828, 1651, 294, 5, 447, 120000, N'Active'),
(3829, 1651, 294, 5, 448, 120000, N'Active'),
(3830, 1651, 294, 5, 449, 120000, N'Active'),
(3831, 1651, 294, 5, 450, 120000, N'Active'),
(3832, 1652, 294, 5, 524, 144000, N'Active'),
(3833, 1652, 294, 5, 525, 144000, N'Active'),
(3834, 1653, 298, 3, 243, 75000, N'Active'),
(3835, 1653, 298, 3, 244, 75000, N'Active'),
(3836, 1654, 354, 3, 282, 90000, N'Active'),
(3837, 1654, 354, 3, 283, 90000, N'Active'),
(3838, 1655, 333, 4, 431, 90000, N'Active'),
(3839, 1655, 333, 4, 432, 90000, N'Active'),
(3840, 1656, 294, 5, 488, 144000, N'Active'),
(3841, 1657, 302, 1, 30, 75000, N'Active'),
(3842, 1657, 302, 1, 31, 75000, N'Active'),
(3843, 1658, 358, 1, 79, 90000, N'Active'),
(3844, 1659, 300, 4, 403, 108000, N'Active'),
(3845, 1659, 300, 4, 404, 108000, N'Active'),
(3846, 1660, 294, 5, 536, 144000, N'Active'),
(3847, 1660, 294, 5, 537, 144000, N'Active'),
(3848, 1661, 304, 2, 131, 75000, N'Active'),
(3849, 1661, 304, 2, 132, 75000, N'Active'),
(3850, 1662, 297, 1, 67, 90000, N'Active'),
(3851, 1662, 297, 1, 68, 90000, N'Active'),
(3852, 1663, 328, 4, 382, 108000, N'Active'),
(3853, 1664, 296, 4, 375, 108000, N'Active'),
(3854, 1665, 302, 1, 69, 90000, N'Active'),
(3855, 1665, 302, 1, 70, 90000, N'Active'),
(3856, 1666, 320, 1, 55, 90000, N'Active'),
(3857, 1666, 320, 1, 56, 90000, N'Active'),
(3858, 1667, 295, 2, 189, 90000, N'Active'),
(3859, 1667, 295, 2, 190, 90000, N'Active'),
(3860, 1667, 295, 2, 191, 90000, N'Active'),
(3861, 1667, 295, 2, 192, 90000, N'Active'),
(3862, 1668, 294, 5, 440, 120000, N'Active'),
(3863, 1668, 294, 5, 441, 120000, N'Active'),
(3864, 1668, 294, 5, 442, 120000, N'Active'),
(3865, 1669, 295, 2, 185, 90000, N'Active'),
(3866, 1670, 294, 5, 534, 144000, N'Active'),
(3867, 1670, 294, 5, 535, 144000, N'Active'),
(3868, 1671, 300, 4, 380, 108000, N'Active'),
(3869, 1672, 296, 4, 371, 108000, N'Active'),
(3870, 1672, 296, 4, 372, 108000, N'Active'),
(3871, 1673, 300, 4, 431, 108000, N'Active'),
(3872, 1673, 300, 4, 432, 108000, N'Active'),
(3873, 1674, 320, 1, 61, 90000, N'Active'),
(3874, 1674, 320, 1, 62, 90000, N'Active'),
(3875, 1674, 320, 1, 63, 90000, N'Active'),
(3876, 1675, 302, 1, 66, 90000, N'Active'),
(3877, 1676, 302, 1, 55, 90000, N'Active'),
(3878, 1676, 302, 1, 56, 90000, N'Active'),
(3879, 1677, 356, 4, 342, 90000, N'Active'),
(3880, 1678, 296, 4, 347, 90000, N'Active'),
(3881, 1678, 296, 4, 348, 90000, N'Active'),
(3882, 1679, 334, 5, 469, 120000, N'Active'),
(3883, 1679, 334, 5, 470, 120000, N'Active'),
(3884, 1679, 334, 5, 471, 120000, N'Active'),
(3885, 1679, 334, 5, 472, 120000, N'Active'),
(3886, 1680, 301, 5, 524, 144000, N'Active'),
(3887, 1680, 301, 5, 525, 144000, N'Active'),
(3888, 1681, 308, 3, 308, 90000, N'Active'),
(3889, 1681, 308, 3, 309, 90000, N'Active'),
(3890, 1681, 308, 3, 310, 90000, N'Active'),
(3891, 1681, 308, 3, 311, 90000, N'Active'),
(3892, 1682, 332, 2, 152, 90000, N'Active'),
(3893, 1682, 332, 2, 153, 90000, N'Active'),
(3894, 1682, 332, 2, 154, 90000, N'Active'),
(3895, 1683, 359, 3, 220, 75000, N'Active'),
(3896, 1683, 359, 3, 221, 75000, N'Active'),
(3897, 1684, 297, 1, 30, 75000, N'Active'),
(3898, 1685, 302, 1, 39, 90000, N'Active'),
(3899, 1685, 302, 1, 40, 90000, N'Active'),
(3900, 1685, 302, 1, 41, 90000, N'Active'),
(3901, 1686, 314, 2, 143, 75000, N'Active'),
(3902, 1687, 301, 5, 496, 144000, N'Active'),
(3903, 1687, 301, 5, 497, 144000, N'Active'),
(3904, 1688, 298, 3, 289, 90000, N'Active'),
(3905, 1688, 298, 3, 290, 90000, N'Active'),
(3906, 1689, 313, 3, 294, 90000, N'Active'),
(3907, 1689, 313, 3, 295, 90000, N'Active'),
(3908, 1689, 313, 3, 296, 90000, N'Active'),
(3909, 1689, 313, 3, 297, 90000, N'Active'),
(3910, 1690, 299, 2, 209, 90000, N'Active'),
(3911, 1690, 299, 2, 210, 90000, N'Active'),
(3912, 1691, 299, 2, 174, 90000, N'Active'),
(3913, 1691, 299, 2, 175, 90000, N'Active'),
(3914, 1691, 299, 2, 176, 90000, N'Active'),
(3915, 1692, 303, 3, 269, 90000, N'Active'),
(3916, 1693, 305, 4, 357, 75000, N'Active'),
(3917, 1693, 305, 4, 358, 75000, N'Active'),
(3918, 1693, 305, 4, 359, 75000, N'Active'),
(3919, 1693, 305, 4, 360, 75000, N'Active'),
(3920, 1694, 305, 4, 425, 90000, N'Active'),
(3921, 1694, 305, 4, 426, 90000, N'Active'),
(3922, 1695, 302, 1, 91, 90000, N'Active'),
(3923, 1695, 302, 1, 92, 90000, N'Active'),
(3924, 1696, 299, 2, 147, 90000, N'Active'),
(3925, 1696, 299, 2, 148, 90000, N'Active'),
(3926, 1697, 304, 2, 198, 90000, N'Active'),
(3927, 1697, 304, 2, 199, 90000, N'Active'),
(3928, 1697, 304, 2, 200, 90000, N'Active'),
(3929, 1698, 307, 1, 103, 90000, N'Active'),
(3930, 1698, 307, 1, 104, 90000, N'Active'),
(3931, 1699, 357, 5, 487, 144000, N'Active'),
(3932, 1699, 357, 5, 488, 144000, N'Active'),
(3933, 1700, 329, 5, 512, 144000, N'Active'),
(3934, 1700, 329, 5, 513, 144000, N'Active'),
(3935, 1701, 300, 4, 370, 108000, N'Active'),
(3936, 1701, 300, 4, 371, 108000, N'Active'),
(3937, 1702, 306, 5, 460, 120000, N'Active'),
(3938, 1702, 306, 5, 461, 120000, N'Active'),
(3939, 1702, 306, 5, 462, 120000, N'Active'),
(3940, 1703, 302, 1, 78, 90000, N'Active'),
(3941, 1703, 302, 1, 79, 90000, N'Active'),
(3942, 1704, 306, 5, 493, 144000, N'Active'),
(3943, 1704, 306, 5, 494, 144000, N'Active'),
(3944, 1704, 306, 5, 495, 144000, N'Active'),
(3945, 1704, 306, 5, 496, 144000, N'Active'),
(3946, 1705, 300, 4, 398, 108000, N'Active'),
(3947, 1705, 300, 4, 399, 108000, N'Active'),
(3948, 1706, 300, 4, 375, 108000, N'Active'),
(3949, 1706, 300, 4, 376, 108000, N'Active'),
(3950, 1707, 301, 5, 502, 144000, N'Active'),
(3951, 1707, 301, 5, 503, 144000, N'Active'),
(3952, 1707, 301, 5, 504, 144000, N'Active'),
(3953, 1708, 302, 1, 80, 90000, N'Active'),
(3954, 1708, 302, 1, 81, 90000, N'Active'),
(3955, 1708, 302, 1, 82, 90000, N'Active'),
(3956, 1709, 302, 1, 75, 90000, N'Active'),
(3957, 1709, 302, 1, 76, 90000, N'Active'),
(3958, 1709, 302, 1, 77, 90000, N'Active'),
(3959, 1710, 301, 5, 559, 144000, N'Active'),
(3960, 1710, 301, 5, 560, 144000, N'Active'),
(3961, 1711, 300, 4, 381, 108000, N'Active'),
(3962, 1711, 300, 4, 382, 108000, N'Active'),
(3963, 1712, 306, 5, 502, 144000, N'Active'),
(3964, 1712, 306, 5, 503, 144000, N'Active'),
(3965, 1713, 301, 5, 486, 144000, N'Active'),
(3966, 1714, 300, 4, 338, 90000, N'Active'),
(3967, 1714, 300, 4, 339, 90000, N'Active'),
(3968, 1714, 300, 4, 340, 90000, N'Active'),
(3969, 1714, 300, 4, 341, 90000, N'Active'),
(3970, 1715, 300, 4, 356, 90000, N'Active'),
(3971, 1715, 300, 4, 357, 90000, N'Active'),
(3972, 1715, 300, 4, 358, 90000, N'Active'),
(3973, 1715, 300, 4, 359, 90000, N'Active'),
(3974, 1716, 305, 4, 393, 90000, N'Active'),
(3975, 1716, 305, 4, 394, 90000, N'Active'),
(3976, 1716, 305, 4, 395, 90000, N'Active'),
(3977, 1717, 354, 3, 307, 90000, N'Active'),
(3978, 1718, 301, 5, 471, 120000, N'Active'),
(3979, 1718, 301, 5, 472, 120000, N'Active'),
(3980, 1719, 303, 3, 223, 75000, N'Active'),
(3981, 1719, 303, 3, 224, 75000, N'Active'),
(3982, 1720, 302, 1, 17, 75000, N'Active'),
(3983, 1720, 302, 1, 18, 75000, N'Active'),
(3984, 1721, 307, 1, 60, 90000, N'Active'),
(3985, 1722, 306, 5, 545, 144000, N'Active'),
(3986, 1723, 329, 5, 535, 144000, N'Active'),
(3987, 1724, 330, 1, 53, 90000, N'Active'),
(3988, 1725, 304, 2, 196, 90000, N'Active'),
(3989, 1725, 304, 2, 197, 90000, N'Active'),
(3990, 1726, 304, 2, 163, 90000, N'Active'),
(3991, 1726, 304, 2, 164, 90000, N'Active'),
(3992, 1727, 301, 5, 561, 144000, N'Cancelled'),
(3993, 1727, 301, 5, 562, 144000, N'Cancelled'),
(3994, 1728, 308, 3, 305, 90000, N'Active'),
(3995, 1729, 306, 5, 514, 144000, N'Active'),
(3996, 1730, 302, 1, 62, 90000, N'Active'),
(3997, 1730, 302, 1, 63, 90000, N'Active'),
(3998, 1731, 302, 1, 86, 90000, N'Active'),
(3999, 1731, 302, 1, 87, 90000, N'Active'),
(4000, 1731, 302, 1, 88, 90000, N'Active'),
(4001, 1732, 315, 1, 54, 90000, N'Active'),
(4002, 1732, 315, 1, 55, 90000, N'Active'),
(4003, 1732, 315, 1, 56, 90000, N'Active'),
(4004, 1732, 315, 1, 57, 90000, N'Active'),
(4005, 1732, 315, 1, 58, 90000, N'Active'),
(4006, 1732, 315, 1, 59, 90000, N'Active'),
(4007, 1733, 308, 3, 217, 75000, N'Active'),
(4008, 1733, 308, 3, 218, 75000, N'Active'),
(4009, 1733, 308, 3, 219, 75000, N'Active'),
(4010, 1734, 333, 4, 390, 90000, N'Active'),
(4011, 1734, 333, 4, 391, 90000, N'Active'),
(4012, 1735, 327, 2, 157, 90000, N'Active'),
(4013, 1735, 327, 2, 158, 90000, N'Active'),
(4014, 1736, 308, 3, 276, 90000, N'Active'),
(4015, 1737, 302, 1, 107, 90000, N'Active'),
(4016, 1737, 302, 1, 108, 90000, N'Active'),
(4017, 1738, 305, 4, 378, 90000, N'Active'),
(4018, 1738, 305, 4, 379, 90000, N'Active'),
(4019, 1738, 305, 4, 380, 90000, N'Active'),
(4020, 1739, 305, 4, 397, 90000, N'Active'),
(4021, 1739, 305, 4, 398, 90000, N'Active'),
(4022, 1740, 307, 1, 43, 90000, N'Active'),
(4023, 1740, 307, 1, 44, 90000, N'Active'),
(4024, 1740, 307, 1, 45, 90000, N'Active'),
(4025, 1741, 304, 2, 159, 90000, N'Active'),
(4026, 1741, 304, 2, 160, 90000, N'Active'),
(4027, 1741, 304, 2, 161, 90000, N'Active'),
(4028, 1741, 304, 2, 162, 90000, N'Active'),
(4029, 1742, 308, 3, 293, 90000, N'Active'),
(4030, 1742, 308, 3, 294, 90000, N'Active'),
(4031, 1742, 308, 3, 295, 90000, N'Active'),
(4032, 1742, 308, 3, 296, 90000, N'Active'),
(4033, 1743, 308, 3, 248, 75000, N'Active'),
(4034, 1743, 308, 3, 249, 75000, N'Active'),
(4035, 1744, 306, 5, 563, 144000, N'Active'),
(4036, 1744, 306, 5, 564, 144000, N'Active'),
(4037, 1745, 304, 2, 166, 90000, N'Active'),
(4038, 1745, 304, 2, 167, 90000, N'Active'),
(4039, 1746, 328, 4, 401, 108000, N'Active'),
(4040, 1746, 328, 4, 402, 108000, N'Active'),
(4041, 1747, 308, 3, 241, 75000, N'Active'),
(4042, 1748, 307, 1, 19, 75000, N'Active'),
(4043, 1749, 304, 2, 193, 90000, N'Cancelled'),
(4044, 1749, 304, 2, 194, 90000, N'Cancelled'),
(4045, 1750, 304, 2, 150, 90000, N'Active'),
(4046, 1750, 304, 2, 151, 90000, N'Active'),
(4047, 1751, 335, 1, 68, 90000, N'Active'),
(4048, 1751, 335, 1, 69, 90000, N'Active'),
(4049, 1752, 320, 1, 37, 90000, N'Active'),
(4050, 1752, 320, 1, 38, 90000, N'Active'),
(4051, 1753, 316, 5, 542, 144000, N'Active'),
(4052, 1753, 316, 5, 543, 144000, N'Active'),
(4053, 1753, 316, 5, 544, 144000, N'Active'),
(4054, 1754, 308, 3, 270, 90000, N'Active'),
(4055, 1754, 308, 3, 271, 90000, N'Active'),
(4056, 1754, 308, 3, 272, 90000, N'Active'),
(4057, 1754, 308, 3, 273, 90000, N'Active'),
(4058, 1755, 308, 3, 279, 90000, N'Active'),
(4059, 1755, 308, 3, 280, 90000, N'Active'),
(4060, 1755, 308, 3, 281, 90000, N'Active'),
(4061, 1756, 305, 4, 367, 90000, N'Active'),
(4062, 1757, 307, 1, 21, 75000, N'Active'),
(4063, 1757, 307, 1, 22, 75000, N'Active'),
(4064, 1758, 306, 5, 443, 120000, N'Active'),
(4065, 1758, 306, 5, 444, 120000, N'Active'),
(4066, 1759, 345, 3, 317, 90000, N'Active'),
(4067, 1759, 345, 3, 318, 90000, N'Active'),
(4068, 1760, 307, 1, 82, 90000, N'Active'),
(4069, 1760, 307, 1, 83, 90000, N'Active'),
(4070, 1761, 306, 5, 451, 120000, N'Active'),
(4071, 1761, 306, 5, 452, 120000, N'Active'),
(4072, 1762, 329, 5, 498, 144000, N'Active'),
(4073, 1762, 329, 5, 499, 144000, N'Active'),
(4074, 1763, 305, 4, 373, 90000, N'Active'),
(4075, 1763, 305, 4, 374, 90000, N'Active'),
(4076, 1763, 305, 4, 375, 90000, N'Active'),
(4077, 1764, 308, 3, 323, 90000, N'Active'),
(4078, 1764, 308, 3, 324, 90000, N'Active'),
(4079, 1765, 309, 1, 75, 90000, N'Active'),
(4080, 1765, 309, 1, 76, 90000, N'Active'),
(4081, 1766, 348, 1, 16, 75000, N'Active'),
(4082, 1767, 329, 5, 477, 120000, N'Active'),
(4083, 1767, 329, 5, 478, 120000, N'Active'),
(4084, 1768, 334, 5, 547, 144000, N'Active'),
(4085, 1768, 334, 5, 548, 144000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 7 21/11/2026: 226 hoa don (9 huy), 496 ve, doanh thu 47.589.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(1769, 5, NULL, '2026-11-21T08:02:26', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 354 | Clayface | 22/11 17:00 | Phòng 3 | E4 E5
(1770, 6, NULL, '2026-11-21T08:13:58', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 351 | Chàng Mèo Mang Mũ | 22/11 15:30 | Phòng 2 | G9 G10
(1771, 4, 1, '2026-11-21T08:15:05', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 347 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 22/11 13:30 | Phòng 2 | F10 F11
(1772, 5, NULL, '2026-11-21T08:18:04', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | F6 F7
(1773, 4, 69, '2026-11-21T08:19:36', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 309 | Trại Giam Hạnh Phúc | 21/11 09:00 | Phòng 1 | F12
(1774, 5, NULL, '2026-11-21T08:19:39', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 391 | Bí Kíp Luyện Cướp | 23/11 21:00 | Phòng 4 | B4 B5
(1775, 4, 92, '2026-11-21T08:20:20', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 309 | Trại Giam Hạnh Phúc | 21/11 09:00 | Phòng 1 | E2 E3
(1776, 4, NULL, '2026-11-21T08:29:11', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | E3
(1777, 6, NULL, '2026-11-21T08:29:22', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 309 | Trại Giam Hạnh Phúc | 21/11 09:00 | Phòng 1 | H5 H6 H7
(1778, 5, 88, '2026-11-21T08:29:48', 576000, N'Paid', N'Transfer', NULL, 40, 0, NULL, NULL, NULL), -- suat 310 | Dune: Hành Tinh Cát | 21/11 09:00 | Phòng 5 | F9 F10 F11 F12
(1779, 4, NULL, '2026-11-21T08:30:37', 75000, N'Paid', N'Cash', 80000, 0, 0, NULL, NULL, NULL), -- suat 309 | Trại Giam Hạnh Phúc | 21/11 09:00 | Phòng 1 | C5
(1780, 5, 5, '2026-11-21T08:33:05', 90000, N'Paid', N'Cash', 500000, 6, 0, NULL, NULL, NULL), -- suat 389 | Trại Giam Hạnh Phúc | 23/11 20:30 | Phòng 3 | F8
(1781, 5, NULL, '2026-11-21T08:37:58', 324000, N'Paid', N'Cash', 350000, 0, 0, NULL, NULL, NULL), -- suat 311 | Ramayana: Khởi Nguồn Một Huyền Thoại | 21/11 09:15 | Phòng 4 | H6 H7 H8
(1782, 4, NULL, '2026-11-21T08:45:52', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 313 | Bí Kíp Luyện Cướp | 21/11 10:00 | Phòng 3 | F2 F3
(1783, 5, NULL, '2026-11-21T08:49:07', 120000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 310 | Dune: Hành Tinh Cát | 21/11 09:00 | Phòng 5 | A5
(1784, 4, NULL, '2026-11-21T08:51:09', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 311 | Ramayana: Khởi Nguồn Một Huyền Thoại | 21/11 09:15 | Phòng 4 | B5 B6
(1785, 4, NULL, '2026-11-21T08:51:43', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 309 | Trại Giam Hạnh Phúc | 21/11 09:00 | Phòng 1 | J9 J10
(1786, 6, 28, '2026-11-21T08:51:43', 120000, N'Paid', N'Card', NULL, 8, 60, NULL, NULL, NULL), -- suat 341 | Bí Kíp Luyện Cướp | 22/11 10:00 | Phòng 3 | E7 E8
(1787, 5, NULL, '2026-11-21T08:52:28', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 310 | Dune: Hành Tinh Cát | 21/11 09:00 | Phòng 5 | K12
(1788, 5, NULL, '2026-11-21T08:52:46', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 311 | Ramayana: Khởi Nguồn Một Huyền Thoại | 21/11 09:15 | Phòng 4 | H2 H3
(1789, 4, 26, '2026-11-21T08:53:12', 432000, N'Paid', N'Transfer', NULL, 30, 0, NULL, NULL, NULL), -- suat 316 | Godzilla Trừ Không | 21/11 12:15 | Phòng 5 | G7 G8 G9
(1790, 5, 51, '2026-11-21T08:55:03', 90000, N'Cancelled', N'Transfer', NULL, 4, 0, N'Lỗi thanh toán', '2026-11-21T08:57:41', 5), -- suat 311 | Ramayana: Khởi Nguồn Một Huyền Thoại | 21/11 09:15 | Phòng 4 | C3
(1791, 6, 100, '2026-11-21T08:57:57', 75000, N'Paid', N'Cash', 100000, 3, 0, NULL, NULL, NULL), -- suat 313 | Bí Kíp Luyện Cướp | 21/11 10:00 | Phòng 3 | C11
(1792, 6, NULL, '2026-11-21T09:02:08', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 313 | Bí Kíp Luyện Cướp | 21/11 10:00 | Phòng 3 | C4 C5
(1793, 4, NULL, '2026-11-21T09:07:57', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 323 | Chàng Mèo Mang Mũ | 21/11 15:30 | Phòng 2 | G6 G7
(1794, 4, NULL, '2026-11-21T09:08:30', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 324 | Godzilla Trừ Không | 21/11 15:30 | Phòng 4 | F6 F7
(1795, 5, NULL, '2026-11-21T09:13:54', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 324 | Godzilla Trừ Không | 21/11 15:30 | Phòng 4 | F4 F5
(1796, 6, 103, '2026-11-21T09:14:57', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 321 | Thiên Đường Tăm Tối | 21/11 14:45 | Phòng 3 | G8 G9
(1797, 6, NULL, '2026-11-21T09:15:32', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 312 | Ma Mút Con Vượt Kỷ Băng Hà | 21/11 09:30 | Phòng 2 | H7 H8 H9 H10
(1798, 5, NULL, '2026-11-21T09:19:04', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 342 | Kiến Lé Phiêu Lưu Ké | 22/11 11:15 | Phòng 2 | H11 H12
(1799, 6, NULL, '2026-11-21T09:24:51', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 316 | Godzilla Trừ Không | 21/11 12:15 | Phòng 5 | A5 A6 A7
(1800, 5, NULL, '2026-11-21T09:32:46', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | G8 G9 G10 G11
(1801, 5, 67, '2026-11-21T09:35:07', 432000, N'Paid', N'Transfer', NULL, 30, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | F3 F4 F5
(1802, 6, 31, '2026-11-21T09:35:46', 288000, N'Paid', N'Cash', 288000, 20, 0, NULL, NULL, NULL), -- suat 322 | Dune: Hành Tinh Cát - Phần Hai | 21/11 15:00 | Phòng 5 | F6 F7
(1803, 6, 60, '2026-11-21T09:40:09', 75000, N'Paid', N'Transfer', NULL, 3, 0, NULL, NULL, NULL), -- suat 323 | Chàng Mèo Mang Mũ | 21/11 15:30 | Phòng 2 | A8
(1804, 6, 67, '2026-11-21T09:46:33', 240000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 316 | Godzilla Trừ Không | 21/11 12:15 | Phòng 5 | B4 B5
(1805, 5, NULL, '2026-11-21T09:51:40', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 361 | Bí Kíp Luyện Cướp | 22/11 21:00 | Phòng 4 | F9 F10
(1806, 4, NULL, '2026-11-21T09:52:18', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 316 | Godzilla Trừ Không | 21/11 12:15 | Phòng 5 | F4
(1807, 4, 20, '2026-11-21T09:56:59', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 315 | Ngày Con Còn Mẹ | 21/11 11:30 | Phòng 1 | D4
(1808, 5, NULL, '2026-11-21T09:57:49', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 320 | Trại Giam Hạnh Phúc | 21/11 14:00 | Phòng 1 | C6 C7
(1809, 5, NULL, '2026-11-21T09:59:21', 540000, N'Cancelled', N'Cash', 540000, 0, 0, N'Sự cố phòng chiếu', '2026-11-21T12:43:17', 1), -- suat 318 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 12:30 | Phòng 4 | F4 F5 F6 F7 F8
(1810, 5, NULL, '2026-11-21T10:03:05', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | D6 D7
(1811, 5, NULL, '2026-11-21T10:10:01', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 315 | Ngày Con Còn Mẹ | 21/11 11:30 | Phòng 1 | F6 F7
(1812, 6, NULL, '2026-11-21T10:14:04', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | B7
(1813, 5, 53, '2026-11-21T10:17:08', 216000, N'Paid', N'Cash', 250000, 21, 0, NULL, NULL, NULL), -- suat 318 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 12:30 | Phòng 4 | J9 J10
(1814, 5, NULL, '2026-11-21T10:17:56', 108000, N'Paid', N'Cash', 108000, 0, 0, NULL, NULL, NULL), -- suat 368 | Ramayana: Khởi Nguồn Một Huyền Thoại | 23/11 09:15 | Phòng 4 | G12
(1815, 5, NULL, '2026-11-21T10:20:08', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 320 | Trại Giam Hạnh Phúc | 21/11 14:00 | Phòng 1 | C3 C4
(1816, 6, NULL, '2026-11-21T10:22:42', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 320 | Trại Giam Hạnh Phúc | 21/11 14:00 | Phòng 1 | G7 G8
(1817, 4, NULL, '2026-11-21T10:27:25', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 318 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 12:30 | Phòng 4 | F2 F3
(1818, 5, 89, '2026-11-21T10:29:52', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 314 | Kiến Lé Phiêu Lưu Ké | 21/11 11:15 | Phòng 2 | C9 C10
(1819, 4, NULL, '2026-11-21T10:31:18', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | G6
(1820, 5, 120, '2026-11-21T10:33:43', 720000, N'Paid', N'Cash', 750000, 36, 0, NULL, NULL, NULL), -- suat 316 | Godzilla Trừ Không | 21/11 12:15 | Phòng 5 | C6 C7 C8 C9 C10 C11
(1821, 6, 28, '2026-11-21T10:35:03', 240000, N'Paid', N'Cash', 300000, 12, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | B3 B4
(1822, 4, NULL, '2026-11-21T10:35:40', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 315 | Ngày Con Còn Mẹ | 21/11 11:30 | Phòng 1 | A4 A5
(1823, 5, 100, '2026-11-21T10:40:38', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 352 | Godzilla Trừ Không | 22/11 15:30 | Phòng 4 | G2 G3
(1824, 5, 50, '2026-11-21T10:42:25', 432000, N'Paid', N'Transfer', NULL, 30, 0, NULL, NULL, NULL), -- suat 316 | Godzilla Trừ Không | 21/11 12:15 | Phòng 5 | E1 E2 E3
(1825, 4, NULL, '2026-11-21T10:45:52', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 316 | Godzilla Trừ Không | 21/11 12:15 | Phòng 5 | D4 D5 D6
(1826, 6, 95, '2026-11-21T10:47:46', 108000, N'Paid', N'Cash', 200000, 7, 0, NULL, NULL, NULL), -- suat 318 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 12:30 | Phòng 4 | F9
(1827, 5, NULL, '2026-11-21T10:51:13', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 330 | Trại Giam Hạnh Phúc | 21/11 19:00 | Phòng 1 | H4 H5
(1828, 4, 63, '2026-11-21T10:52:55', 90000, N'Paid', N'Transfer', NULL, 4, 0, NULL, NULL, NULL), -- suat 318 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 12:30 | Phòng 4 | C10
(1829, 6, NULL, '2026-11-21T10:56:56', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 315 | Ngày Con Còn Mẹ | 21/11 11:30 | Phòng 1 | C5 C6
(1830, 4, NULL, '2026-11-21T10:59:25', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | K4 K5
(1831, 6, 113, '2026-11-21T11:00:10', 394000, N'Paid', N'Card', NULL, 27, 146, NULL, NULL, NULL), -- suat 320 | Trại Giam Hạnh Phúc | 21/11 14:00 | Phòng 1 | F4 F5 F6 F7 F8 F9
(1832, 6, NULL, '2026-11-21T11:07:15', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 323 | Chàng Mèo Mang Mũ | 21/11 15:30 | Phòng 2 | D10 D11
(1833, 5, NULL, '2026-11-21T11:07:50', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 319 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 21/11 13:30 | Phòng 2 | B7
(1834, 4, NULL, '2026-11-21T11:10:21', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 323 | Chàng Mèo Mang Mũ | 21/11 15:30 | Phòng 2 | H4 H5
(1835, 5, NULL, '2026-11-21T11:12:29', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 320 | Trại Giam Hạnh Phúc | 21/11 14:00 | Phòng 1 | F10 F11
(1836, 6, NULL, '2026-11-21T11:14:30', 450000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 321 | Thiên Đường Tăm Tối | 21/11 14:45 | Phòng 3 | F7 F8 F9 F10 F11
(1837, 4, NULL, '2026-11-21T11:17:45', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | L9 L10
(1838, 5, 59, '2026-11-21T11:20:37', 108000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 318 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 12:30 | Phòng 4 | E6
(1839, 6, NULL, '2026-11-21T11:24:24', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 325 | Bò Sữa Bay | 21/11 16:30 | Phòng 1 | H9
(1840, 5, NULL, '2026-11-21T11:25:07', 180000, N'Cancelled', N'Cash', 200000, 0, 0, N'Khách đổi ý', '2026-11-21T11:53:12', 5), -- suat 326 | Clayface | 21/11 17:00 | Phòng 3 | J9 J10
(1841, 6, 10, '2026-11-21T11:31:52', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 316 | Godzilla Trừ Không | 21/11 12:15 | Phòng 5 | H7 H8
(1842, 6, NULL, '2026-11-21T11:32:17', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 327 | Trại Buôn Người | 21/11 18:00 | Phòng 2 | G6 G7 G8 G9
(1843, 4, NULL, '2026-11-21T11:35:43', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 318 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 12:30 | Phòng 4 | G2 G3
(1844, 5, NULL, '2026-11-21T11:38:20', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 316 | Godzilla Trừ Không | 21/11 12:15 | Phòng 5 | E4 E5
(1845, 4, NULL, '2026-11-21T11:40:30', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 364 | Trại Giam Hạnh Phúc | 22/11 21:30 | Phòng 3 | F6 F7
(1846, 4, NULL, '2026-11-21T11:41:35', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 363 | Chị Chị Em Em 3 | 22/11 21:30 | Phòng 1 | E3
(1847, 5, NULL, '2026-11-21T11:41:42', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 318 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 12:30 | Phòng 4 | D2 D3 D4 D5
(1848, 6, NULL, '2026-11-21T11:42:50', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 325 | Bò Sữa Bay | 21/11 16:30 | Phòng 1 | G6 G7 G8
(1849, 4, NULL, '2026-11-21T11:50:05', 300000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 320 | Trại Giam Hạnh Phúc | 21/11 14:00 | Phòng 1 | B2 B3 B4 B5
(1850, 6, NULL, '2026-11-21T12:00:55', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | H3 H4 H5
(1851, 5, NULL, '2026-11-21T12:01:31', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 320 | Trại Giam Hạnh Phúc | 21/11 14:00 | Phòng 1 | D6 D7
(1852, 4, NULL, '2026-11-21T12:01:37', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 319 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 21/11 13:30 | Phòng 2 | C10 C11
(1853, 5, NULL, '2026-11-21T12:02:56', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 346 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 12:30 | Phòng 4 | D7 D8 D9
(1854, 5, 21, '2026-11-21T12:06:36', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 340 | Ma Mút Con Vượt Kỷ Băng Hà | 22/11 09:30 | Phòng 2 | G7 G8
(1855, 6, NULL, '2026-11-21T12:15:40', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 321 | Thiên Đường Tăm Tối | 21/11 14:45 | Phòng 3 | J3 J4
(1856, 5, 68, '2026-11-21T12:22:01', 270000, N'Paid', N'Cash', 300000, 18, 0, NULL, NULL, NULL), -- suat 327 | Trại Buôn Người | 21/11 18:00 | Phòng 2 | F4 F5 F6
(1857, 5, NULL, '2026-11-21T12:22:11', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 327 | Trại Buôn Người | 21/11 18:00 | Phòng 2 | J5 J6
(1858, 4, NULL, '2026-11-21T12:24:54', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 321 | Thiên Đường Tăm Tối | 21/11 14:45 | Phòng 3 | H4 H5 H6 H7
(1859, 5, NULL, '2026-11-21T12:25:30', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 324 | Godzilla Trừ Không | 21/11 15:30 | Phòng 4 | B7
(1860, 4, NULL, '2026-11-21T12:28:20', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 320 | Trại Giam Hạnh Phúc | 21/11 14:00 | Phòng 1 | H2 H3 H4
(1861, 4, NULL, '2026-11-21T12:30:38', 480000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | D5 D6 D7 D8
(1862, 6, NULL, '2026-11-21T12:32:11', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 326 | Clayface | 21/11 17:00 | Phòng 3 | J11 J12
(1863, 5, 72, '2026-11-21T12:32:24', 240000, N'Paid', N'Cash', 300000, 12, 0, NULL, NULL, NULL), -- suat 322 | Dune: Hành Tinh Cát - Phần Hai | 21/11 15:00 | Phòng 5 | C7 C8
(1864, 5, 112, '2026-11-21T12:34:50', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 320 | Trại Giam Hạnh Phúc | 21/11 14:00 | Phòng 1 | E10
(1865, 6, NULL, '2026-11-21T12:47:51', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 320 | Trại Giam Hạnh Phúc | 21/11 14:00 | Phòng 1 | A7 A8
(1866, 4, NULL, '2026-11-21T12:56:48', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 324 | Godzilla Trừ Không | 21/11 15:30 | Phòng 4 | F11
(1867, 6, NULL, '2026-11-21T13:02:01', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 350 | Dune: Hành Tinh Cát - Phần Hai | 22/11 15:00 | Phòng 5 | H6 H7
(1868, 4, 5, '2026-11-21T13:07:45', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 323 | Chàng Mèo Mang Mũ | 21/11 15:30 | Phòng 2 | J7 J8
(1869, 4, 42, '2026-11-21T13:14:34', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 385 | Ngày Con Còn Mẹ | 23/11 18:15 | Phòng 3 | H4
(1870, 5, NULL, '2026-11-21T13:17:40', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 356 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 18:00 | Phòng 4 | D6 D7
(1871, 6, 117, '2026-11-21T13:18:57', 324000, N'Paid', N'Transfer', NULL, 22, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | F8 F9 F10
(1872, 5, 108, '2026-11-21T13:26:53', 75000, N'Paid', N'Transfer', NULL, 3, 0, NULL, NULL, NULL), -- suat 320 | Trại Giam Hạnh Phúc | 21/11 14:00 | Phòng 1 | A11
(1873, 4, NULL, '2026-11-21T13:28:01', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 325 | Bò Sữa Bay | 21/11 16:30 | Phòng 1 | J1 J2
(1874, 5, NULL, '2026-11-21T13:32:47', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 326 | Clayface | 21/11 17:00 | Phòng 3 | F7
(1875, 5, NULL, '2026-11-21T13:35:50', 108000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | D9
(1876, 6, NULL, '2026-11-21T13:46:47', 576000, N'Paid', N'Cash', 600000, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | G1 G2 G3 G4
(1877, 4, 115, '2026-11-21T13:47:03', 150000, N'Cancelled', N'Transfer', NULL, 7, 0, N'Khách đổi ý', '2026-11-21T13:50:20', 4), -- suat 323 | Chàng Mèo Mang Mũ | 21/11 15:30 | Phòng 2 | B11 B12
(1878, 5, NULL, '2026-11-21T13:50:20', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 322 | Dune: Hành Tinh Cát - Phần Hai | 21/11 15:00 | Phòng 5 | D11 D12
(1879, 4, NULL, '2026-11-21T13:51:27', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 332 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 21/11 20:45 | Phòng 2 | H4 H5
(1880, 5, 77, '2026-11-21T13:55:46', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 323 | Chàng Mèo Mang Mũ | 21/11 15:30 | Phòng 2 | B11 B12
(1881, 5, NULL, '2026-11-21T13:56:46', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 325 | Bò Sữa Bay | 21/11 16:30 | Phòng 1 | J11 J12
(1882, 6, NULL, '2026-11-21T13:58:20', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | L7 L8
(1883, 6, 96, '2026-11-21T14:10:13', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 332 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 21/11 20:45 | Phòng 2 | F8 F9
(1884, 5, NULL, '2026-11-21T14:12:18', 450000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 323 | Chàng Mèo Mang Mũ | 21/11 15:30 | Phòng 2 | F2 F3 F4 F5 F6
(1885, 4, NULL, '2026-11-21T14:13:22', 576000, N'Paid', N'Cash', 600000, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | J1 J2 J3 J4
(1886, 5, NULL, '2026-11-21T14:13:34', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 352 | Godzilla Trừ Không | 22/11 15:30 | Phòng 4 | B4 B5
(1887, 5, NULL, '2026-11-21T14:20:01', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 330 | Trại Giam Hạnh Phúc | 21/11 19:00 | Phòng 1 | G9 G10
(1888, 6, NULL, '2026-11-21T14:21:11', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | J8
(1889, 6, NULL, '2026-11-21T14:21:46', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 326 | Clayface | 21/11 17:00 | Phòng 3 | D3 D4 D5
(1890, 6, NULL, '2026-11-21T14:25:33', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | F4 F5
(1891, 5, NULL, '2026-11-21T14:27:37', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 361 | Bí Kíp Luyện Cướp | 22/11 21:00 | Phòng 4 | D8 D9
(1892, 6, 32, '2026-11-21T14:29:01', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 327 | Trại Buôn Người | 21/11 18:00 | Phòng 2 | F8 F9
(1893, 6, 24, '2026-11-21T14:41:37', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 331 | Rosetta (EUFF) | 21/11 19:15 | Phòng 3 | E9 E10
(1894, 5, NULL, '2026-11-21T14:41:43', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 334 | Dune: Hành Tinh Cát - Phần Hai | 21/11 21:00 | Phòng 5 | L11 L12
(1895, 5, NULL, '2026-11-21T14:46:22', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | A5 A6
(1896, 4, NULL, '2026-11-21T14:46:34', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 332 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 21/11 20:45 | Phòng 2 | D3 D4 D5 D6
(1897, 4, NULL, '2026-11-21T14:47:16', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 382 | Bò Sữa Bay | 23/11 16:15 | Phòng 1 | F4 F5
(1898, 7, NULL, '2026-11-21T15:01:41', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 333 | Bí Kíp Luyện Cướp | 21/11 21:00 | Phòng 4 | E8 E9
(1899, 9, 37, '2026-11-21T15:03:42', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 335 | Chị Chị Em Em 3 | 21/11 21:30 | Phòng 1 | F2 F3
(1900, 7, NULL, '2026-11-21T15:04:45', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 327 | Trại Buôn Người | 21/11 18:00 | Phòng 2 | G10 G11
(1901, 8, 77, '2026-11-21T15:05:02', 144000, N'Paid', N'Transfer', NULL, 10, 0, NULL, NULL, NULL), -- suat 334 | Dune: Hành Tinh Cát - Phần Hai | 21/11 21:00 | Phòng 5 | H4
(1902, 9, NULL, '2026-11-21T15:05:18', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 333 | Bí Kíp Luyện Cướp | 21/11 21:00 | Phòng 4 | E3 E4
(1903, 9, NULL, '2026-11-21T15:09:19', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 333 | Bí Kíp Luyện Cướp | 21/11 21:00 | Phòng 4 | B5 B6
(1904, 9, NULL, '2026-11-21T15:10:40', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 327 | Trại Buôn Người | 21/11 18:00 | Phòng 2 | E6 E7
(1905, 7, NULL, '2026-11-21T15:16:06', 600000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | C6 C7 C8 C9 C10
(1906, 7, 69, '2026-11-21T15:21:28', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 325 | Bò Sữa Bay | 21/11 16:30 | Phòng 1 | D10 D11
(1907, 8, 25, '2026-11-21T15:22:28', 180000, N'Paid', N'Card', NULL, 9, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | C6 C7
(1908, 9, NULL, '2026-11-21T15:24:12', 480000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 350 | Dune: Hành Tinh Cát - Phần Hai | 22/11 15:00 | Phòng 5 | D1 D2 D3 D4
(1909, 9, 78, '2026-11-21T15:25:57', 225000, N'Paid', N'Cash', 250000, 11, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | B2 B3 B4
(1910, 9, 23, '2026-11-21T15:27:39', 90000, N'Cancelled', N'Cash', 100000, 6, 0, N'Nhầm suất / ghế', '2026-11-21T15:33:08', 9), -- suat 355 | Trại Buôn Người | 22/11 18:00 | Phòng 2 | G8
(1911, 9, 69, '2026-11-21T15:27:49', 225000, N'Paid', N'Transfer', NULL, 11, 0, NULL, NULL, NULL), -- suat 376 | Trại Giam Hạnh Phúc | 23/11 13:45 | Phòng 1 | C1 C2 C3
(1912, 9, NULL, '2026-11-21T15:28:44', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 336 | Trại Giam Hạnh Phúc | 21/11 21:30 | Phòng 3 | C3 C4 C5
(1913, 9, NULL, '2026-11-21T15:30:17', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | F10 F11
(1914, 7, NULL, '2026-11-21T15:35:19', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 326 | Clayface | 21/11 17:00 | Phòng 3 | F9
(1915, 9, NULL, '2026-11-21T15:35:26', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 325 | Bò Sữa Bay | 21/11 16:30 | Phòng 1 | E8 E9
(1916, 8, NULL, '2026-11-21T15:37:22', 288000, N'Cancelled', N'Card', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-21T15:50:07', 8), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | L11 L12
(1917, 9, NULL, '2026-11-21T15:37:57', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 332 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 21/11 20:45 | Phòng 2 | J1 J2
(1918, 9, NULL, '2026-11-21T15:40:38', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 330 | Trại Giam Hạnh Phúc | 21/11 19:00 | Phòng 1 | F11 F12
(1919, 8, 49, '2026-11-21T15:40:42', 180000, N'Cancelled', N'Cash', 200000, 12, 0, N'Nhầm suất / ghế', '2026-11-21T16:10:45', 8), -- suat 330 | Trại Giam Hạnh Phúc | 21/11 19:00 | Phòng 1 | H11 H12
(1920, 9, 43, '2026-11-21T15:47:55', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 327 | Trại Buôn Người | 21/11 18:00 | Phòng 2 | F10
(1921, 9, NULL, '2026-11-21T15:48:58', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | H9 H10
(1922, 8, NULL, '2026-11-21T15:56:11', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 330 | Trại Giam Hạnh Phúc | 21/11 19:00 | Phòng 1 | F6 F7
(1923, 9, 93, '2026-11-21T15:56:21', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 327 | Trại Buôn Người | 21/11 18:00 | Phòng 2 | C6 C7
(1924, 8, NULL, '2026-11-21T16:01:41', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | E8
(1925, 8, 117, '2026-11-21T16:02:01', 120000, N'Paid', N'Cash', 200000, 6, 0, NULL, NULL, NULL), -- suat 334 | Dune: Hành Tinh Cát - Phần Hai | 21/11 21:00 | Phòng 5 | D11
(1926, 9, 81, '2026-11-21T16:02:30', 216000, N'Paid', N'Cash', 250000, 15, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | D1 D2
(1927, 7, NULL, '2026-11-21T16:06:23', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 346 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 12:30 | Phòng 4 | E8 E9
(1928, 8, 113, '2026-11-21T16:07:31', 540000, N'Paid', N'Cash', 550000, 37, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | H1 H2 H3 H4 H5
(1929, 9, NULL, '2026-11-21T16:08:50', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 330 | Trại Giam Hạnh Phúc | 21/11 19:00 | Phòng 1 | A5 A6
(1930, 8, NULL, '2026-11-21T16:09:11', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | D4 D5
(1931, 7, 115, '2026-11-21T16:09:21', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 333 | Bí Kíp Luyện Cướp | 21/11 21:00 | Phòng 4 | G3
(1932, 9, 5, '2026-11-21T16:12:06', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 379 | Dune: Hành Tinh Cát - Phần Hai | 23/11 15:00 | Phòng 5 | H4 H5
(1933, 7, NULL, '2026-11-21T16:12:35', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 336 | Trại Giam Hạnh Phúc | 21/11 21:30 | Phòng 3 | G8 G9
(1934, 9, NULL, '2026-11-21T16:16:10', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 341 | Bí Kíp Luyện Cướp | 22/11 10:00 | Phòng 3 | E4 E5
(1935, 9, 98, '2026-11-21T16:16:16', 258000, N'Paid', N'Transfer', NULL, 18, 30, NULL, NULL, NULL), -- suat 334 | Dune: Hành Tinh Cát - Phần Hai | 21/11 21:00 | Phòng 5 | J2 J3
(1936, 7, NULL, '2026-11-21T16:20:33', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 327 | Trại Buôn Người | 21/11 18:00 | Phòng 2 | D3 D4 D5
(1937, 8, NULL, '2026-11-21T16:21:27', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 333 | Bí Kíp Luyện Cướp | 21/11 21:00 | Phòng 4 | G7 G8
(1938, 7, NULL, '2026-11-21T16:25:36', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 332 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 21/11 20:45 | Phòng 2 | B10 B11
(1939, 9, NULL, '2026-11-21T16:25:55', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 336 | Trại Giam Hạnh Phúc | 21/11 21:30 | Phòng 3 | H3 H4
(1940, 8, NULL, '2026-11-21T16:28:11', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | L3 L4
(1941, 9, NULL, '2026-11-21T16:32:53', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | G2
(1942, 9, NULL, '2026-11-21T16:33:20', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 336 | Trại Giam Hạnh Phúc | 21/11 21:30 | Phòng 3 | H8 H9
(1943, 9, NULL, '2026-11-21T16:41:21', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | E1 E2
(1944, 9, NULL, '2026-11-21T16:43:06', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 331 | Rosetta (EUFF) | 21/11 19:15 | Phòng 3 | E6 E7
(1945, 8, NULL, '2026-11-21T16:47:54', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 336 | Trại Giam Hạnh Phúc | 21/11 21:30 | Phòng 3 | F11 F12
(1946, 9, NULL, '2026-11-21T16:51:39', 240000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | A8 A9
(1947, 9, NULL, '2026-11-21T16:54:52', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 335 | Chị Chị Em Em 3 | 21/11 21:30 | Phòng 1 | J9 J10
(1948, 9, NULL, '2026-11-21T16:57:20', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 334 | Dune: Hành Tinh Cát - Phần Hai | 21/11 21:00 | Phòng 5 | H6
(1949, 9, 17, '2026-11-21T16:58:51', 227000, N'Paid', N'Cash', 227000, 15, 43, NULL, NULL, NULL), -- suat 366 | Ma Mút Con Vượt Kỷ Băng Hà | 23/11 09:00 | Phòng 2 | G6 G7 G8
(1950, 7, NULL, '2026-11-21T16:59:47', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 328 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 21/11 18:00 | Phòng 4 | G4
(1951, 9, NULL, '2026-11-21T17:07:45', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | L5 L6
(1952, 9, NULL, '2026-11-21T17:09:57', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 355 | Trại Buôn Người | 22/11 18:00 | Phòng 2 | G7 G8 G9
(1953, 8, NULL, '2026-11-21T17:12:39', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | H6
(1954, 7, 21, '2026-11-21T17:19:04', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 330 | Trại Giam Hạnh Phúc | 21/11 19:00 | Phòng 1 | H11
(1955, 7, NULL, '2026-11-21T17:20:23', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | L1 L2
(1956, 7, 79, '2026-11-21T17:23:03', 150000, N'Paid', N'Cash', 200000, 7, 0, NULL, NULL, NULL), -- suat 332 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 21/11 20:45 | Phòng 2 | C6 C7
(1957, 9, NULL, '2026-11-21T17:27:31', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 327 | Trại Buôn Người | 21/11 18:00 | Phòng 2 | D1 D2
(1958, 9, NULL, '2026-11-21T17:32:59', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 346 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 12:30 | Phòng 4 | C6 C7
(1959, 8, NULL, '2026-11-21T17:33:45', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 336 | Trại Giam Hạnh Phúc | 21/11 21:30 | Phòng 3 | J3 J4
(1960, 9, NULL, '2026-11-21T17:36:55', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 330 | Trại Giam Hạnh Phúc | 21/11 19:00 | Phòng 1 | C6 C7
(1961, 9, 69, '2026-11-21T17:37:35', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 335 | Chị Chị Em Em 3 | 21/11 21:30 | Phòng 1 | D7
(1962, 8, 44, '2026-11-21T17:55:18', 288000, N'Paid', N'Cash', 300000, 20, 0, NULL, NULL, NULL), -- suat 329 | Godzilla Trừ Không | 21/11 18:15 | Phòng 5 | K8 K9
(1963, 9, 108, '2026-11-21T18:00:03', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 336 | Trại Giam Hạnh Phúc | 21/11 21:30 | Phòng 3 | F3 F4
(1964, 8, NULL, '2026-11-21T18:03:37', 360000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-11-21T18:24:55', 8), -- suat 336 | Trại Giam Hạnh Phúc | 21/11 21:30 | Phòng 3 | E1 E2 E3 E4
(1965, 7, NULL, '2026-11-21T18:04:31', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 333 | Bí Kíp Luyện Cướp | 21/11 21:00 | Phòng 4 | H6 H7 H8
(1966, 9, NULL, '2026-11-21T18:06:12', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 386 | Godzilla Trừ Không | 23/11 18:15 | Phòng 5 | G4 G5
(1967, 7, NULL, '2026-11-21T18:09:01', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 332 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 21/11 20:45 | Phòng 2 | F5 F6 F7
(1968, 8, NULL, '2026-11-21T18:16:44', 375000, N'Cancelled', N'Cash', 375000, 0, 0, N'Nhầm suất / ghế', '2026-11-21T18:50:10', 8), -- suat 335 | Chị Chị Em Em 3 | 21/11 21:30 | Phòng 1 | C6 C7 C8 C9 C10
(1969, 9, NULL, '2026-11-21T18:26:05', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 332 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 21/11 20:45 | Phòng 2 | J5 J6
(1970, 7, 42, '2026-11-21T18:34:35', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 334 | Dune: Hành Tinh Cát - Phần Hai | 21/11 21:00 | Phòng 5 | E7 E8
(1971, 7, NULL, '2026-11-21T18:40:22', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 353 | Bò Sữa Bay | 22/11 16:30 | Phòng 1 | F5 F6 F7
(1972, 7, 44, '2026-11-21T18:40:27', 270000, N'Paid', N'Cash', 300000, 18, 0, NULL, NULL, NULL), -- suat 341 | Bí Kíp Luyện Cướp | 22/11 10:00 | Phòng 3 | H10 H11 H12
(1973, 7, 46, '2026-11-21T18:49:25', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | B9 B10
(1974, 8, NULL, '2026-11-21T18:49:38', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 333 | Bí Kíp Luyện Cướp | 21/11 21:00 | Phòng 4 | C6 C7
(1975, 9, 1, '2026-11-21T18:54:50', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 334 | Dune: Hành Tinh Cát - Phần Hai | 21/11 21:00 | Phòng 5 | F3 F4
(1976, 7, NULL, '2026-11-21T18:56:35', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 333 | Bí Kíp Luyện Cướp | 21/11 21:00 | Phòng 4 | G9 G10 G11
(1977, 8, 67, '2026-11-21T18:58:23', 150000, N'Paid', N'Transfer', NULL, 7, 90, NULL, NULL, NULL), -- suat 334 | Dune: Hành Tinh Cát - Phần Hai | 21/11 21:00 | Phòng 5 | D5 D6
(1978, 7, NULL, '2026-11-21T19:06:45', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 332 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 21/11 20:45 | Phòng 2 | E1 E2
(1979, 8, NULL, '2026-11-21T19:35:18', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 364 | Trại Giam Hạnh Phúc | 22/11 21:30 | Phòng 3 | C11 C12
(1980, 7, NULL, '2026-11-21T19:42:16', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 334 | Dune: Hành Tinh Cát - Phần Hai | 21/11 21:00 | Phòng 5 | E1 E2 E3
(1981, 9, NULL, '2026-11-21T19:42:34', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 335 | Chị Chị Em Em 3 | 21/11 21:30 | Phòng 1 | F4 F5
(1982, 8, NULL, '2026-11-21T19:42:45', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | G1 G2 G3
(1983, 9, NULL, '2026-11-21T19:43:01', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 336 | Trại Giam Hạnh Phúc | 21/11 21:30 | Phòng 3 | E8 E9 E10
(1984, 8, 25, '2026-11-21T19:54:20', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 336 | Trại Giam Hạnh Phúc | 21/11 21:30 | Phòng 3 | F5 F6
(1985, 7, NULL, '2026-11-21T20:07:55', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | G8 G9 G10 G11
(1986, 8, NULL, '2026-11-21T20:23:43', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 333 | Bí Kíp Luyện Cướp | 21/11 21:00 | Phòng 4 | J7 J8
(1987, 8, NULL, '2026-11-21T20:27:55', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 349 | Thiên Đường Tăm Tối | 22/11 14:45 | Phòng 3 | G2
(1988, 9, NULL, '2026-11-21T20:28:58', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 333 | Bí Kíp Luyện Cướp | 21/11 21:00 | Phòng 4 | E5 E6
(1989, 9, NULL, '2026-11-21T20:40:30', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 379 | Dune: Hành Tinh Cát - Phần Hai | 23/11 15:00 | Phòng 5 | L11 L12
(1990, 9, NULL, '2026-11-21T20:42:43', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 382 | Bò Sữa Bay | 23/11 16:15 | Phòng 1 | F7 F8
(1991, 8, 99, '2026-11-21T20:47:12', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 343 | Ngày Con Còn Mẹ | 22/11 11:30 | Phòng 1 | D6 D7
(1992, 8, NULL, '2026-11-21T20:55:12', 540000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 345 | Kẻ Hồi Sinh | 22/11 12:30 | Phòng 3 | F2 F3 F4 F5 F6 F7
(1993, 8, NULL, '2026-11-21T21:27:03', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | D3 D4
(1994, 8, NULL, '2026-11-21T21:30:12', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL); -- suat 346 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 12:30 | Phòng 4 | H9 H10
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(4086, 1769, 354, 3, 268, 90000, N'Active'),
(4087, 1769, 354, 3, 269, 90000, N'Active'),
(4088, 1770, 351, 2, 189, 90000, N'Active'),
(4089, 1770, 351, 2, 190, 90000, N'Active'),
(4090, 1771, 347, 2, 178, 90000, N'Active'),
(4091, 1771, 347, 2, 179, 90000, N'Active'),
(4092, 1772, 358, 1, 66, 90000, N'Active'),
(4093, 1772, 358, 1, 67, 90000, N'Active'),
(4094, 1773, 309, 1, 72, 90000, N'Active'),
(4095, 1774, 391, 4, 340, 75000, N'Active'),
(4096, 1774, 391, 4, 341, 75000, N'Active'),
(4097, 1775, 309, 1, 50, 90000, N'Active'),
(4098, 1775, 309, 1, 51, 90000, N'Active'),
(4099, 1776, 358, 1, 51, 90000, N'Active'),
(4100, 1777, 309, 1, 89, 90000, N'Active'),
(4101, 1777, 309, 1, 90, 90000, N'Active'),
(4102, 1777, 309, 1, 91, 90000, N'Active'),
(4103, 1778, 310, 5, 501, 144000, N'Active'),
(4104, 1778, 310, 5, 502, 144000, N'Active'),
(4105, 1778, 310, 5, 503, 144000, N'Active'),
(4106, 1778, 310, 5, 504, 144000, N'Active'),
(4107, 1779, 309, 1, 29, 75000, N'Active'),
(4108, 1780, 389, 3, 284, 90000, N'Active'),
(4109, 1781, 311, 4, 414, 108000, N'Active'),
(4110, 1781, 311, 4, 415, 108000, N'Active'),
(4111, 1781, 311, 4, 416, 108000, N'Active'),
(4112, 1782, 313, 3, 278, 90000, N'Active'),
(4113, 1782, 313, 3, 279, 90000, N'Active'),
(4114, 1783, 310, 5, 437, 120000, N'Active'),
(4115, 1784, 311, 4, 341, 90000, N'Active'),
(4116, 1784, 311, 4, 342, 90000, N'Active'),
(4117, 1785, 309, 1, 105, 90000, N'Active'),
(4118, 1785, 309, 1, 106, 90000, N'Active'),
(4119, 1786, 341, 3, 271, 90000, N'Active'),
(4120, 1786, 341, 3, 272, 90000, N'Active'),
(4121, 1787, 310, 5, 552, 144000, N'Active'),
(4122, 1788, 311, 4, 410, 108000, N'Active'),
(4123, 1788, 311, 4, 411, 108000, N'Active'),
(4124, 1789, 316, 5, 511, 144000, N'Active'),
(4125, 1789, 316, 5, 512, 144000, N'Active'),
(4126, 1789, 316, 5, 513, 144000, N'Active'),
(4127, 1790, 311, 4, 351, 90000, N'Cancelled'),
(4128, 1791, 313, 3, 251, 75000, N'Active'),
(4129, 1792, 313, 3, 244, 75000, N'Active'),
(4130, 1792, 313, 3, 245, 75000, N'Active'),
(4131, 1793, 323, 2, 186, 90000, N'Active'),
(4132, 1793, 323, 2, 187, 90000, N'Active'),
(4133, 1794, 324, 4, 390, 108000, N'Active'),
(4134, 1794, 324, 4, 391, 108000, N'Active'),
(4135, 1795, 324, 4, 388, 108000, N'Active'),
(4136, 1795, 324, 4, 389, 108000, N'Active'),
(4137, 1796, 321, 3, 296, 90000, N'Active'),
(4138, 1796, 321, 3, 297, 90000, N'Active'),
(4139, 1797, 312, 2, 199, 90000, N'Active'),
(4140, 1797, 312, 2, 200, 90000, N'Active'),
(4141, 1797, 312, 2, 201, 90000, N'Active'),
(4142, 1797, 312, 2, 202, 90000, N'Active'),
(4143, 1798, 342, 2, 203, 90000, N'Active'),
(4144, 1798, 342, 2, 204, 90000, N'Active'),
(4145, 1799, 316, 5, 437, 120000, N'Active'),
(4146, 1799, 316, 5, 438, 120000, N'Active'),
(4147, 1799, 316, 5, 439, 120000, N'Active'),
(4148, 1800, 328, 4, 404, 108000, N'Active'),
(4149, 1800, 328, 4, 405, 108000, N'Active'),
(4150, 1800, 328, 4, 406, 108000, N'Active'),
(4151, 1800, 328, 4, 407, 108000, N'Active'),
(4152, 1801, 362, 5, 495, 144000, N'Active'),
(4153, 1801, 362, 5, 496, 144000, N'Active'),
(4154, 1801, 362, 5, 497, 144000, N'Active'),
(4155, 1802, 322, 5, 498, 144000, N'Active'),
(4156, 1802, 322, 5, 499, 144000, N'Active'),
(4157, 1803, 323, 2, 116, 75000, N'Active'),
(4158, 1804, 316, 5, 448, 120000, N'Active'),
(4159, 1804, 316, 5, 449, 120000, N'Active'),
(4160, 1805, 361, 4, 393, 90000, N'Active'),
(4161, 1805, 361, 4, 394, 90000, N'Active'),
(4162, 1806, 316, 5, 496, 144000, N'Active'),
(4163, 1807, 315, 1, 40, 90000, N'Active'),
(4164, 1808, 320, 1, 30, 75000, N'Active'),
(4165, 1808, 320, 1, 31, 75000, N'Active'),
(4166, 1809, 318, 4, 388, 108000, N'Cancelled'),
(4167, 1809, 318, 4, 389, 108000, N'Cancelled'),
(4168, 1809, 318, 4, 390, 108000, N'Cancelled'),
(4169, 1809, 318, 4, 391, 108000, N'Cancelled'),
(4170, 1809, 318, 4, 392, 108000, N'Cancelled'),
(4171, 1810, 358, 1, 42, 90000, N'Active'),
(4172, 1810, 358, 1, 43, 90000, N'Active'),
(4173, 1811, 315, 1, 66, 90000, N'Active'),
(4174, 1811, 315, 1, 67, 90000, N'Active'),
(4175, 1812, 328, 4, 343, 90000, N'Active'),
(4176, 1813, 318, 4, 429, 108000, N'Active'),
(4177, 1813, 318, 4, 430, 108000, N'Active'),
(4178, 1814, 368, 4, 408, 108000, N'Active'),
(4179, 1815, 320, 1, 27, 75000, N'Active'),
(4180, 1815, 320, 1, 28, 75000, N'Active'),
(4181, 1816, 320, 1, 79, 90000, N'Active'),
(4182, 1816, 320, 1, 80, 90000, N'Active'),
(4183, 1817, 318, 4, 386, 108000, N'Active'),
(4184, 1817, 318, 4, 387, 108000, N'Active'),
(4185, 1818, 314, 2, 141, 75000, N'Active'),
(4186, 1818, 314, 2, 142, 75000, N'Active'),
(4187, 1819, 329, 5, 510, 144000, N'Active'),
(4188, 1820, 316, 5, 462, 120000, N'Active'),
(4189, 1820, 316, 5, 463, 120000, N'Active'),
(4190, 1820, 316, 5, 464, 120000, N'Active'),
(4191, 1820, 316, 5, 465, 120000, N'Active'),
(4192, 1820, 316, 5, 466, 120000, N'Active'),
(4193, 1820, 316, 5, 467, 120000, N'Active'),
(4194, 1821, 362, 5, 447, 120000, N'Active'),
(4195, 1821, 362, 5, 448, 120000, N'Active'),
(4196, 1822, 315, 1, 4, 75000, N'Active'),
(4197, 1822, 315, 1, 5, 75000, N'Active'),
(4198, 1823, 352, 4, 398, 108000, N'Active'),
(4199, 1823, 352, 4, 399, 108000, N'Active'),
(4200, 1824, 316, 5, 481, 144000, N'Active'),
(4201, 1824, 316, 5, 482, 144000, N'Active'),
(4202, 1824, 316, 5, 483, 144000, N'Active'),
(4203, 1825, 316, 5, 472, 120000, N'Active'),
(4204, 1825, 316, 5, 473, 120000, N'Active'),
(4205, 1825, 316, 5, 474, 120000, N'Active'),
(4206, 1826, 318, 4, 393, 108000, N'Active'),
(4207, 1827, 330, 1, 88, 90000, N'Active'),
(4208, 1827, 330, 1, 89, 90000, N'Active'),
(4209, 1828, 318, 4, 358, 90000, N'Active'),
(4210, 1829, 315, 1, 29, 75000, N'Active'),
(4211, 1829, 315, 1, 30, 75000, N'Active'),
(4212, 1830, 329, 5, 544, 144000, N'Active'),
(4213, 1830, 329, 5, 545, 144000, N'Active'),
(4214, 1831, 320, 1, 64, 90000, N'Active'),
(4215, 1831, 320, 1, 65, 90000, N'Active'),
(4216, 1831, 320, 1, 66, 90000, N'Active'),
(4217, 1831, 320, 1, 67, 90000, N'Active'),
(4218, 1831, 320, 1, 68, 90000, N'Active'),
(4219, 1831, 320, 1, 69, 90000, N'Active'),
(4220, 1832, 323, 2, 154, 90000, N'Active'),
(4221, 1832, 323, 2, 155, 90000, N'Active'),
(4222, 1833, 319, 2, 127, 75000, N'Active'),
(4223, 1834, 323, 2, 196, 90000, N'Active'),
(4224, 1834, 323, 2, 197, 90000, N'Active'),
(4225, 1835, 320, 1, 70, 90000, N'Active'),
(4226, 1835, 320, 1, 71, 90000, N'Active'),
(4227, 1836, 321, 3, 283, 90000, N'Active'),
(4228, 1836, 321, 3, 284, 90000, N'Active'),
(4229, 1836, 321, 3, 285, 90000, N'Active'),
(4230, 1836, 321, 3, 286, 90000, N'Active'),
(4231, 1836, 321, 3, 287, 90000, N'Active'),
(4232, 1837, 362, 5, 561, 144000, N'Active'),
(4233, 1837, 362, 5, 562, 144000, N'Active'),
(4234, 1838, 318, 4, 378, 108000, N'Active'),
(4235, 1839, 325, 1, 93, 90000, N'Active'),
(4236, 1840, 326, 3, 321, 90000, N'Cancelled'),
(4237, 1840, 326, 3, 322, 90000, N'Cancelled'),
(4238, 1841, 316, 5, 523, 144000, N'Active'),
(4239, 1841, 316, 5, 524, 144000, N'Active'),
(4240, 1842, 327, 2, 186, 90000, N'Active'),
(4241, 1842, 327, 2, 187, 90000, N'Active'),
(4242, 1842, 327, 2, 188, 90000, N'Active'),
(4243, 1842, 327, 2, 189, 90000, N'Active'),
(4244, 1843, 318, 4, 398, 108000, N'Active'),
(4245, 1843, 318, 4, 399, 108000, N'Active'),
(4246, 1844, 316, 5, 484, 144000, N'Active'),
(4247, 1844, 316, 5, 485, 144000, N'Active'),
(4248, 1845, 364, 3, 282, 90000, N'Active'),
(4249, 1845, 364, 3, 283, 90000, N'Active'),
(4250, 1846, 363, 1, 51, 90000, N'Active'),
(4251, 1847, 318, 4, 362, 108000, N'Active'),
(4252, 1847, 318, 4, 363, 108000, N'Active'),
(4253, 1847, 318, 4, 364, 108000, N'Active'),
(4254, 1847, 318, 4, 365, 108000, N'Active'),
(4255, 1848, 325, 1, 78, 90000, N'Active'),
(4256, 1848, 325, 1, 79, 90000, N'Active'),
(4257, 1848, 325, 1, 80, 90000, N'Active'),
(4258, 1849, 320, 1, 14, 75000, N'Active'),
(4259, 1849, 320, 1, 15, 75000, N'Active'),
(4260, 1849, 320, 1, 16, 75000, N'Active'),
(4261, 1849, 320, 1, 17, 75000, N'Active'),
(4262, 1850, 329, 5, 519, 144000, N'Active'),
(4263, 1850, 329, 5, 520, 144000, N'Active'),
(4264, 1850, 329, 5, 521, 144000, N'Active'),
(4265, 1851, 320, 1, 42, 90000, N'Active'),
(4266, 1851, 320, 1, 43, 90000, N'Active'),
(4267, 1852, 319, 2, 142, 75000, N'Active'),
(4268, 1852, 319, 2, 143, 75000, N'Active'),
(4269, 1853, 346, 4, 367, 108000, N'Active'),
(4270, 1853, 346, 4, 368, 108000, N'Active'),
(4271, 1853, 346, 4, 369, 108000, N'Active'),
(4272, 1854, 340, 2, 187, 90000, N'Active'),
(4273, 1854, 340, 2, 188, 90000, N'Active'),
(4274, 1855, 321, 3, 315, 90000, N'Active'),
(4275, 1855, 321, 3, 316, 90000, N'Active'),
(4276, 1856, 327, 2, 172, 90000, N'Active'),
(4277, 1856, 327, 2, 173, 90000, N'Active'),
(4278, 1856, 327, 2, 174, 90000, N'Active'),
(4279, 1857, 327, 2, 209, 90000, N'Active'),
(4280, 1857, 327, 2, 210, 90000, N'Active'),
(4281, 1858, 321, 3, 304, 90000, N'Active'),
(4282, 1858, 321, 3, 305, 90000, N'Active'),
(4283, 1858, 321, 3, 306, 90000, N'Active'),
(4284, 1858, 321, 3, 307, 90000, N'Active'),
(4285, 1859, 324, 4, 343, 90000, N'Active'),
(4286, 1860, 320, 1, 86, 90000, N'Active'),
(4287, 1860, 320, 1, 87, 90000, N'Active'),
(4288, 1860, 320, 1, 88, 90000, N'Active'),
(4289, 1861, 362, 5, 473, 120000, N'Active'),
(4290, 1861, 362, 5, 474, 120000, N'Active'),
(4291, 1861, 362, 5, 475, 120000, N'Active'),
(4292, 1861, 362, 5, 476, 120000, N'Active'),
(4293, 1862, 326, 3, 323, 90000, N'Active'),
(4294, 1862, 326, 3, 324, 90000, N'Active'),
(4295, 1863, 322, 5, 463, 120000, N'Active'),
(4296, 1863, 322, 5, 464, 120000, N'Active'),
(4297, 1864, 320, 1, 58, 90000, N'Active'),
(4298, 1865, 320, 1, 7, 75000, N'Active'),
(4299, 1865, 320, 1, 8, 75000, N'Active'),
(4300, 1866, 324, 4, 395, 108000, N'Active'),
(4301, 1867, 350, 5, 522, 144000, N'Active'),
(4302, 1867, 350, 5, 523, 144000, N'Active'),
(4303, 1868, 323, 2, 211, 90000, N'Active'),
(4304, 1868, 323, 2, 212, 90000, N'Active'),
(4305, 1869, 385, 3, 304, 90000, N'Active'),
(4306, 1870, 356, 4, 366, 108000, N'Active'),
(4307, 1870, 356, 4, 367, 108000, N'Active'),
(4308, 1871, 328, 4, 392, 108000, N'Active'),
(4309, 1871, 328, 4, 393, 108000, N'Active'),
(4310, 1871, 328, 4, 394, 108000, N'Active'),
(4311, 1872, 320, 1, 11, 75000, N'Active'),
(4312, 1873, 325, 1, 97, 90000, N'Active'),
(4313, 1873, 325, 1, 98, 90000, N'Active'),
(4314, 1874, 326, 3, 283, 90000, N'Active'),
(4315, 1875, 328, 4, 369, 108000, N'Active'),
(4316, 1876, 329, 5, 505, 144000, N'Active'),
(4317, 1876, 329, 5, 506, 144000, N'Active'),
(4318, 1876, 329, 5, 507, 144000, N'Active'),
(4319, 1876, 329, 5, 508, 144000, N'Active'),
(4320, 1877, 323, 2, 131, 75000, N'Cancelled'),
(4321, 1877, 323, 2, 132, 75000, N'Cancelled'),
(4322, 1878, 322, 5, 479, 120000, N'Active'),
(4323, 1878, 322, 5, 480, 120000, N'Active'),
(4324, 1879, 332, 2, 196, 90000, N'Active'),
(4325, 1879, 332, 2, 197, 90000, N'Active'),
(4326, 1880, 323, 2, 131, 75000, N'Active'),
(4327, 1880, 323, 2, 132, 75000, N'Active'),
(4328, 1881, 325, 1, 107, 90000, N'Active'),
(4329, 1881, 325, 1, 108, 90000, N'Active'),
(4330, 1882, 329, 5, 559, 144000, N'Active'),
(4331, 1882, 329, 5, 560, 144000, N'Active'),
(4332, 1883, 332, 2, 176, 90000, N'Active'),
(4333, 1883, 332, 2, 177, 90000, N'Active'),
(4334, 1884, 323, 2, 170, 90000, N'Active'),
(4335, 1884, 323, 2, 171, 90000, N'Active'),
(4336, 1884, 323, 2, 172, 90000, N'Active'),
(4337, 1884, 323, 2, 173, 90000, N'Active'),
(4338, 1884, 323, 2, 174, 90000, N'Active'),
(4339, 1885, 329, 5, 529, 144000, N'Active'),
(4340, 1885, 329, 5, 530, 144000, N'Active'),
(4341, 1885, 329, 5, 531, 144000, N'Active'),
(4342, 1885, 329, 5, 532, 144000, N'Active'),
(4343, 1886, 352, 4, 340, 90000, N'Active'),
(4344, 1886, 352, 4, 341, 90000, N'Active'),
(4345, 1887, 330, 1, 81, 90000, N'Active'),
(4346, 1887, 330, 1, 82, 90000, N'Active'),
(4347, 1888, 329, 5, 536, 144000, N'Active'),
(4348, 1889, 326, 3, 255, 90000, N'Active'),
(4349, 1889, 326, 3, 256, 90000, N'Active'),
(4350, 1889, 326, 3, 257, 90000, N'Active'),
(4351, 1890, 357, 5, 496, 144000, N'Active'),
(4352, 1890, 357, 5, 497, 144000, N'Active'),
(4353, 1891, 361, 4, 368, 90000, N'Active'),
(4354, 1891, 361, 4, 369, 90000, N'Active'),
(4355, 1892, 327, 2, 176, 90000, N'Active'),
(4356, 1892, 327, 2, 177, 90000, N'Active'),
(4357, 1893, 331, 3, 273, 90000, N'Active'),
(4358, 1893, 331, 3, 274, 90000, N'Active'),
(4359, 1894, 334, 5, 563, 144000, N'Active'),
(4360, 1894, 334, 5, 564, 144000, N'Active'),
(4361, 1895, 328, 4, 329, 90000, N'Active'),
(4362, 1895, 328, 4, 330, 90000, N'Active'),
(4363, 1896, 332, 2, 147, 90000, N'Active'),
(4364, 1896, 332, 2, 148, 90000, N'Active'),
(4365, 1896, 332, 2, 149, 90000, N'Active'),
(4366, 1896, 332, 2, 150, 90000, N'Active'),
(4367, 1897, 382, 1, 64, 90000, N'Active'),
(4368, 1897, 382, 1, 65, 90000, N'Active'),
(4369, 1898, 333, 4, 380, 90000, N'Active'),
(4370, 1898, 333, 4, 381, 90000, N'Active'),
(4371, 1899, 335, 1, 62, 90000, N'Active'),
(4372, 1899, 335, 1, 63, 90000, N'Active'),
(4373, 1900, 327, 2, 190, 90000, N'Active'),
(4374, 1900, 327, 2, 191, 90000, N'Active'),
(4375, 1901, 334, 5, 520, 144000, N'Active'),
(4376, 1902, 333, 4, 375, 90000, N'Active'),
(4377, 1902, 333, 4, 376, 90000, N'Active'),
(4378, 1903, 333, 4, 341, 75000, N'Active'),
(4379, 1903, 333, 4, 342, 75000, N'Active'),
(4380, 1904, 327, 2, 162, 90000, N'Active'),
(4381, 1904, 327, 2, 163, 90000, N'Active'),
(4382, 1905, 329, 5, 462, 120000, N'Active'),
(4383, 1905, 329, 5, 463, 120000, N'Active'),
(4384, 1905, 329, 5, 464, 120000, N'Active'),
(4385, 1905, 329, 5, 465, 120000, N'Active'),
(4386, 1905, 329, 5, 466, 120000, N'Active'),
(4387, 1906, 325, 1, 46, 90000, N'Active'),
(4388, 1906, 325, 1, 47, 90000, N'Active'),
(4389, 1907, 328, 4, 354, 90000, N'Active'),
(4390, 1907, 328, 4, 355, 90000, N'Active'),
(4391, 1908, 350, 5, 469, 120000, N'Active'),
(4392, 1908, 350, 5, 470, 120000, N'Active'),
(4393, 1908, 350, 5, 471, 120000, N'Active'),
(4394, 1908, 350, 5, 472, 120000, N'Active'),
(4395, 1909, 358, 1, 14, 75000, N'Active'),
(4396, 1909, 358, 1, 15, 75000, N'Active'),
(4397, 1909, 358, 1, 16, 75000, N'Active'),
(4398, 1910, 355, 2, 188, 90000, N'Cancelled'),
(4399, 1911, 376, 1, 25, 75000, N'Active'),
(4400, 1911, 376, 1, 26, 75000, N'Active'),
(4401, 1911, 376, 1, 27, 75000, N'Active'),
(4402, 1912, 336, 3, 243, 75000, N'Active'),
(4403, 1912, 336, 3, 244, 75000, N'Active'),
(4404, 1912, 336, 3, 245, 75000, N'Active'),
(4405, 1913, 358, 1, 70, 90000, N'Active'),
(4406, 1913, 358, 1, 71, 90000, N'Active'),
(4407, 1914, 326, 3, 285, 90000, N'Active'),
(4408, 1915, 325, 1, 56, 90000, N'Active'),
(4409, 1915, 325, 1, 57, 90000, N'Active'),
(4410, 1916, 329, 5, 563, 144000, N'Cancelled'),
(4411, 1916, 329, 5, 564, 144000, N'Cancelled'),
(4412, 1917, 332, 2, 205, 90000, N'Active'),
(4413, 1917, 332, 2, 206, 90000, N'Active'),
(4414, 1918, 330, 1, 71, 90000, N'Active'),
(4415, 1918, 330, 1, 72, 90000, N'Active'),
(4416, 1919, 330, 1, 95, 90000, N'Cancelled'),
(4417, 1919, 330, 1, 96, 90000, N'Cancelled'),
(4418, 1920, 327, 2, 178, 90000, N'Active'),
(4419, 1921, 329, 5, 525, 144000, N'Active'),
(4420, 1921, 329, 5, 526, 144000, N'Active'),
(4421, 1922, 330, 1, 66, 90000, N'Active'),
(4422, 1922, 330, 1, 67, 90000, N'Active'),
(4423, 1923, 327, 2, 138, 75000, N'Active'),
(4424, 1923, 327, 2, 139, 75000, N'Active'),
(4425, 1924, 328, 4, 380, 108000, N'Active'),
(4426, 1925, 334, 5, 479, 120000, N'Active'),
(4427, 1926, 328, 4, 361, 108000, N'Active'),
(4428, 1926, 328, 4, 362, 108000, N'Active'),
(4429, 1927, 346, 4, 380, 108000, N'Active'),
(4430, 1927, 346, 4, 381, 108000, N'Active'),
(4431, 1928, 328, 4, 409, 108000, N'Active'),
(4432, 1928, 328, 4, 410, 108000, N'Active'),
(4433, 1928, 328, 4, 411, 108000, N'Active'),
(4434, 1928, 328, 4, 412, 108000, N'Active'),
(4435, 1928, 328, 4, 413, 108000, N'Active'),
(4436, 1929, 330, 1, 5, 75000, N'Active'),
(4437, 1929, 330, 1, 6, 75000, N'Active'),
(4438, 1930, 328, 4, 364, 108000, N'Active'),
(4439, 1930, 328, 4, 365, 108000, N'Active'),
(4440, 1931, 333, 4, 399, 90000, N'Active'),
(4441, 1932, 379, 5, 520, 144000, N'Active'),
(4442, 1932, 379, 5, 521, 144000, N'Active'),
(4443, 1933, 336, 3, 296, 90000, N'Active'),
(4444, 1933, 336, 3, 297, 90000, N'Active'),
(4445, 1934, 341, 3, 268, 90000, N'Active'),
(4446, 1934, 341, 3, 269, 90000, N'Active'),
(4447, 1935, 334, 5, 530, 144000, N'Active'),
(4448, 1935, 334, 5, 531, 144000, N'Active'),
(4449, 1936, 327, 2, 147, 90000, N'Active'),
(4450, 1936, 327, 2, 148, 90000, N'Active'),
(4451, 1936, 327, 2, 149, 90000, N'Active'),
(4452, 1937, 333, 4, 403, 90000, N'Active'),
(4453, 1937, 333, 4, 404, 90000, N'Active'),
(4454, 1938, 332, 2, 130, 75000, N'Active'),
(4455, 1938, 332, 2, 131, 75000, N'Active'),
(4456, 1939, 336, 3, 303, 90000, N'Active'),
(4457, 1939, 336, 3, 304, 90000, N'Active'),
(4458, 1940, 329, 5, 555, 144000, N'Active'),
(4459, 1940, 329, 5, 556, 144000, N'Active'),
(4460, 1941, 348, 1, 74, 90000, N'Active'),
(4461, 1942, 336, 3, 308, 90000, N'Active'),
(4462, 1942, 336, 3, 309, 90000, N'Active'),
(4463, 1943, 328, 4, 373, 108000, N'Active'),
(4464, 1943, 328, 4, 374, 108000, N'Active'),
(4465, 1944, 331, 3, 270, 90000, N'Active'),
(4466, 1944, 331, 3, 271, 90000, N'Active'),
(4467, 1945, 336, 3, 287, 90000, N'Active'),
(4468, 1945, 336, 3, 288, 90000, N'Active'),
(4469, 1946, 357, 5, 440, 120000, N'Active'),
(4470, 1946, 357, 5, 441, 120000, N'Active'),
(4471, 1947, 335, 1, 105, 90000, N'Active'),
(4472, 1947, 335, 1, 106, 90000, N'Active'),
(4473, 1948, 334, 5, 522, 144000, N'Active'),
(4474, 1949, 366, 2, 186, 90000, N'Active'),
(4475, 1949, 366, 2, 187, 90000, N'Active'),
(4476, 1949, 366, 2, 188, 90000, N'Active'),
(4477, 1950, 328, 4, 400, 108000, N'Active'),
(4478, 1951, 362, 5, 557, 144000, N'Active'),
(4479, 1951, 362, 5, 558, 144000, N'Active'),
(4480, 1952, 355, 2, 187, 90000, N'Active'),
(4481, 1952, 355, 2, 188, 90000, N'Active'),
(4482, 1952, 355, 2, 189, 90000, N'Active'),
(4483, 1953, 329, 5, 522, 144000, N'Active'),
(4484, 1954, 330, 1, 95, 90000, N'Active'),
(4485, 1955, 329, 5, 553, 144000, N'Active'),
(4486, 1955, 329, 5, 554, 144000, N'Active'),
(4487, 1956, 332, 2, 138, 75000, N'Active'),
(4488, 1956, 332, 2, 139, 75000, N'Active'),
(4489, 1957, 327, 2, 145, 90000, N'Active'),
(4490, 1957, 327, 2, 146, 90000, N'Active'),
(4491, 1958, 346, 4, 354, 90000, N'Active'),
(4492, 1958, 346, 4, 355, 90000, N'Active'),
(4493, 1959, 336, 3, 315, 90000, N'Active'),
(4494, 1959, 336, 3, 316, 90000, N'Active'),
(4495, 1960, 330, 1, 30, 75000, N'Active'),
(4496, 1960, 330, 1, 31, 75000, N'Active'),
(4497, 1961, 335, 1, 43, 90000, N'Active'),
(4498, 1962, 329, 5, 548, 144000, N'Active'),
(4499, 1962, 329, 5, 549, 144000, N'Active'),
(4500, 1963, 336, 3, 279, 90000, N'Active'),
(4501, 1963, 336, 3, 280, 90000, N'Active'),
(4502, 1964, 336, 3, 265, 90000, N'Cancelled'),
(4503, 1964, 336, 3, 266, 90000, N'Cancelled'),
(4504, 1964, 336, 3, 267, 90000, N'Cancelled'),
(4505, 1964, 336, 3, 268, 90000, N'Cancelled'),
(4506, 1965, 333, 4, 414, 90000, N'Active'),
(4507, 1965, 333, 4, 415, 90000, N'Active'),
(4508, 1965, 333, 4, 416, 90000, N'Active'),
(4509, 1966, 386, 5, 508, 144000, N'Active'),
(4510, 1966, 386, 5, 509, 144000, N'Active'),
(4511, 1967, 332, 2, 173, 90000, N'Active'),
(4512, 1967, 332, 2, 174, 90000, N'Active'),
(4513, 1967, 332, 2, 175, 90000, N'Active'),
(4514, 1968, 335, 1, 30, 75000, N'Cancelled'),
(4515, 1968, 335, 1, 31, 75000, N'Cancelled'),
(4516, 1968, 335, 1, 32, 75000, N'Cancelled'),
(4517, 1968, 335, 1, 33, 75000, N'Cancelled'),
(4518, 1968, 335, 1, 34, 75000, N'Cancelled'),
(4519, 1969, 332, 2, 209, 90000, N'Active'),
(4520, 1969, 332, 2, 210, 90000, N'Active'),
(4521, 1970, 334, 5, 487, 144000, N'Active'),
(4522, 1970, 334, 5, 488, 144000, N'Active'),
(4523, 1971, 353, 1, 65, 90000, N'Active'),
(4524, 1971, 353, 1, 66, 90000, N'Active'),
(4525, 1971, 353, 1, 67, 90000, N'Active'),
(4526, 1972, 341, 3, 310, 90000, N'Active'),
(4527, 1972, 341, 3, 311, 90000, N'Active'),
(4528, 1972, 341, 3, 312, 90000, N'Active'),
(4529, 1973, 348, 1, 21, 75000, N'Active'),
(4530, 1973, 348, 1, 22, 75000, N'Active'),
(4531, 1974, 333, 4, 354, 75000, N'Active'),
(4532, 1974, 333, 4, 355, 75000, N'Active'),
(4533, 1975, 334, 5, 495, 144000, N'Active'),
(4534, 1975, 334, 5, 496, 144000, N'Active'),
(4535, 1976, 333, 4, 405, 90000, N'Active'),
(4536, 1976, 333, 4, 406, 90000, N'Active'),
(4537, 1976, 333, 4, 407, 90000, N'Active'),
(4538, 1977, 334, 5, 473, 120000, N'Active'),
(4539, 1977, 334, 5, 474, 120000, N'Active'),
(4540, 1978, 332, 2, 157, 90000, N'Active'),
(4541, 1978, 332, 2, 158, 90000, N'Active'),
(4542, 1979, 364, 3, 251, 75000, N'Active'),
(4543, 1979, 364, 3, 252, 75000, N'Active'),
(4544, 1980, 334, 5, 481, 144000, N'Active'),
(4545, 1980, 334, 5, 482, 144000, N'Active'),
(4546, 1980, 334, 5, 483, 144000, N'Active'),
(4547, 1981, 335, 1, 64, 90000, N'Active'),
(4548, 1981, 335, 1, 65, 90000, N'Active'),
(4549, 1982, 357, 5, 505, 144000, N'Active'),
(4550, 1982, 357, 5, 506, 144000, N'Active'),
(4551, 1982, 357, 5, 507, 144000, N'Active'),
(4552, 1983, 336, 3, 272, 90000, N'Active'),
(4553, 1983, 336, 3, 273, 90000, N'Active'),
(4554, 1983, 336, 3, 274, 90000, N'Active'),
(4555, 1984, 336, 3, 281, 90000, N'Active'),
(4556, 1984, 336, 3, 282, 90000, N'Active'),
(4557, 1985, 348, 1, 80, 90000, N'Active'),
(4558, 1985, 348, 1, 81, 90000, N'Active'),
(4559, 1985, 348, 1, 82, 90000, N'Active'),
(4560, 1985, 348, 1, 83, 90000, N'Active'),
(4561, 1986, 333, 4, 427, 90000, N'Active'),
(4562, 1986, 333, 4, 428, 90000, N'Active'),
(4563, 1987, 349, 3, 290, 90000, N'Active'),
(4564, 1988, 333, 4, 377, 90000, N'Active'),
(4565, 1988, 333, 4, 378, 90000, N'Active'),
(4566, 1989, 379, 5, 563, 144000, N'Active'),
(4567, 1989, 379, 5, 564, 144000, N'Active'),
(4568, 1990, 382, 1, 67, 90000, N'Active'),
(4569, 1990, 382, 1, 68, 90000, N'Active'),
(4570, 1991, 343, 1, 42, 90000, N'Active'),
(4571, 1991, 343, 1, 43, 90000, N'Active'),
(4572, 1992, 345, 3, 278, 90000, N'Active'),
(4573, 1992, 345, 3, 279, 90000, N'Active'),
(4574, 1992, 345, 3, 280, 90000, N'Active'),
(4575, 1992, 345, 3, 281, 90000, N'Active'),
(4576, 1992, 345, 3, 282, 90000, N'Active'),
(4577, 1992, 345, 3, 283, 90000, N'Active'),
(4578, 1993, 358, 1, 39, 90000, N'Active'),
(4579, 1993, 358, 1, 40, 90000, N'Active'),
(4580, 1994, 346, 4, 417, 108000, N'Active'),
(4581, 1994, 346, 4, 418, 108000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Chủ nhật 22/11/2026: 194 hoa don (11 huy), 438 ve, doanh thu 41.552.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(1995, 7, 30, '2026-11-22T08:10:29', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 343 | Ngày Con Còn Mẹ | 22/11 11:30 | Phòng 1 | E11 E12
(1996, 7, 18, '2026-11-22T08:21:20', 150000, N'Cancelled', N'Cash', 150000, 7, 0, N'Khách đổi ý', '2026-11-22T08:46:16', 7), -- suat 347 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 22/11 13:30 | Phòng 2 | C1 C2
(1997, 9, NULL, '2026-11-22T08:26:34', 360000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 338 | Dune: Hành Tinh Cát | 22/11 09:00 | Phòng 5 | D7 D8 D9
(1998, 8, NULL, '2026-11-22T08:27:14', 600000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 338 | Dune: Hành Tinh Cát | 22/11 09:00 | Phòng 5 | A2 A3 A4 A5 A6
(1999, 9, NULL, '2026-11-22T08:33:04', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 344 | Godzilla Trừ Không | 22/11 12:15 | Phòng 5 | G5 G6
(2000, 7, 14, '2026-11-22T08:33:45', 288000, N'Paid', N'Card', NULL, 28, 0, NULL, NULL, NULL), -- suat 338 | Dune: Hành Tinh Cát | 22/11 09:00 | Phòng 5 | L11 L12
(2001, 9, NULL, '2026-11-22T08:34:43', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 337 | Trại Giam Hạnh Phúc | 22/11 09:00 | Phòng 1 | F4 F5 F6
(2002, 9, NULL, '2026-11-22T08:42:51', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 337 | Trại Giam Hạnh Phúc | 22/11 09:00 | Phòng 1 | H7 H8
(2003, 8, 69, '2026-11-22T08:44:34', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 337 | Trại Giam Hạnh Phúc | 22/11 09:00 | Phòng 1 | G7 G8
(2004, 9, NULL, '2026-11-22T08:45:08', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 337 | Trại Giam Hạnh Phúc | 22/11 09:00 | Phòng 1 | A2 A3 A4
(2005, 8, NULL, '2026-11-22T08:46:28', 375000, N'Paid', N'Cash', 375000, 0, 0, NULL, NULL, NULL), -- suat 337 | Trại Giam Hạnh Phúc | 22/11 09:00 | Phòng 1 | C7 C8 C9 C10 C11
(2006, 9, NULL, '2026-11-22T08:49:30', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 343 | Ngày Con Còn Mẹ | 22/11 11:30 | Phòng 1 | F6 F7
(2007, 8, 41, '2026-11-22T08:52:03', 240000, N'Paid', N'Cash', 250000, 12, 0, NULL, NULL, NULL), -- suat 344 | Godzilla Trừ Không | 22/11 12:15 | Phòng 5 | A9 A10
(2008, 7, NULL, '2026-11-22T08:53:17', 576000, N'Paid', N'Cash', 600000, 0, 0, NULL, NULL, NULL), -- suat 338 | Dune: Hành Tinh Cát | 22/11 09:00 | Phòng 5 | E7 E8 E9 E10
(2009, 7, NULL, '2026-11-22T08:54:55', 300000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 343 | Ngày Con Còn Mẹ | 22/11 11:30 | Phòng 1 | C1 C2 C3 C4
(2010, 9, NULL, '2026-11-22T09:01:54', 324000, N'Paid', N'Cash', 324000, 0, 0, NULL, NULL, NULL), -- suat 339 | Ramayana: Khởi Nguồn Một Huyền Thoại | 22/11 09:15 | Phòng 4 | E8 E9 E10
(2011, 7, 31, '2026-11-22T09:03:10', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | F9 F10 F11
(2012, 7, 34, '2026-11-22T09:04:34', 187000, N'Paid', N'Cash', 200000, 18, 29, NULL, NULL, NULL), -- suat 384 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 23/11 18:00 | Phòng 4 | J1 J2
(2013, 7, NULL, '2026-11-22T09:05:37', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 341 | Bí Kíp Luyện Cướp | 22/11 10:00 | Phòng 3 | D7 D8 D9
(2014, 8, 42, '2026-11-22T09:11:44', 288000, N'Paid', N'Cash', 500000, 20, 0, NULL, NULL, NULL), -- suat 344 | Godzilla Trừ Không | 22/11 12:15 | Phòng 5 | J8 J9
(2015, 9, NULL, '2026-11-22T09:12:21', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 386 | Godzilla Trừ Không | 23/11 18:15 | Phòng 5 | F9 F10
(2016, 9, 72, '2026-11-22T09:25:31', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 385 | Ngày Con Còn Mẹ | 23/11 18:15 | Phòng 3 | E4 E5
(2017, 9, NULL, '2026-11-22T09:28:46', 108000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 346 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 12:30 | Phòng 4 | G2
(2018, 8, 21, '2026-11-22T09:28:57', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 383 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 23/11 16:45 | Phòng 2 | E6 E7
(2019, 8, 26, '2026-11-22T09:32:27', 142000, N'Paid', N'Transfer', NULL, 9, 74, NULL, NULL, NULL), -- suat 346 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 12:30 | Phòng 4 | F1 F2
(2020, 7, NULL, '2026-11-22T09:36:14', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 341 | Bí Kíp Luyện Cướp | 22/11 10:00 | Phòng 3 | F7 F8
(2021, 7, NULL, '2026-11-22T09:37:23', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | J5 J6
(2022, 8, NULL, '2026-11-22T09:42:07', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 344 | Godzilla Trừ Không | 22/11 12:15 | Phòng 5 | L7 L8
(2023, 9, 15, '2026-11-22T09:44:19', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 346 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 12:30 | Phòng 4 | E11 E12
(2024, 7, NULL, '2026-11-22T09:53:41', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-11-22T10:35:45', 7), -- suat 391 | Bí Kíp Luyện Cướp | 23/11 21:00 | Phòng 4 | E8 E9
(2025, 9, NULL, '2026-11-22T09:54:37', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 342 | Kiến Lé Phiêu Lưu Ké | 22/11 11:15 | Phòng 2 | B9 B10
(2026, 7, NULL, '2026-11-22T09:59:07', 108000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 346 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 12:30 | Phòng 4 | E6
(2027, 8, NULL, '2026-11-22T10:00:07', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 416 | Trại Giam Hạnh Phúc | 24/11 18:30 | Phòng 1 | F7 F8 F9
(2028, 7, NULL, '2026-11-22T10:04:20', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | G4 G5 G6 G7
(2029, 9, 67, '2026-11-22T10:07:36', 288000, N'Paid', N'Cash', 300000, 28, 0, NULL, NULL, NULL), -- suat 344 | Godzilla Trừ Không | 22/11 12:15 | Phòng 5 | L1 L2
(2030, 9, NULL, '2026-11-22T10:10:18', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 347 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 22/11 13:30 | Phòng 2 | E3 E4 E5
(2031, 7, NULL, '2026-11-22T10:16:44', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 342 | Kiến Lé Phiêu Lưu Ké | 22/11 11:15 | Phòng 2 | F6
(2032, 7, 43, '2026-11-22T10:22:48', 432000, N'Paid', N'Cash', 432000, 30, 0, NULL, NULL, NULL), -- suat 344 | Godzilla Trừ Không | 22/11 12:15 | Phòng 5 | F2 F3 F4
(2033, 7, NULL, '2026-11-22T10:24:50', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 346 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 12:30 | Phòng 4 | A8 A9
(2034, 8, NULL, '2026-11-22T10:30:38', 180000, N'Cancelled', N'Card', NULL, 0, 0, N'Khách đổi ý', '2026-11-22T11:01:49', 8), -- suat 353 | Bò Sữa Bay | 22/11 16:30 | Phòng 1 | G4 G5
(2035, 7, NULL, '2026-11-22T10:31:32', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 407 | Ngày Con Còn Mẹ | 24/11 14:30 | Phòng 2 | G6 G7 G8 G9
(2036, 7, NULL, '2026-11-22T10:32:27', 324000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 346 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 12:30 | Phòng 4 | E1 E2 E3
(2037, 7, 97, '2026-11-22T10:33:11', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | D4
(2038, 9, NULL, '2026-11-22T10:35:44', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 356 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 18:00 | Phòng 4 | G1 G2 G3 G4
(2039, 8, 113, '2026-11-22T10:38:08', 150000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 353 | Bò Sữa Bay | 22/11 16:30 | Phòng 1 | C11 C12
(2040, 7, 93, '2026-11-22T10:39:26', 450000, N'Paid', N'Card', NULL, 22, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | A4 A5 A6 A7 A8 A9
(2041, 8, NULL, '2026-11-22T10:44:01', 240000, N'Cancelled', N'Cash', 240000, 0, 0, N'Lỗi thanh toán', '2026-11-22T11:04:20', 8), -- suat 350 | Dune: Hành Tinh Cát - Phần Hai | 22/11 15:00 | Phòng 5 | A1 A2
(2042, 7, NULL, '2026-11-22T10:45:38', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 388 | Ba Cây Số Từ Nơi Tận Cùng Thế Giới (EUFF) | 23/11 19:00 | Phòng 2 | C6 C7
(2043, 7, 108, '2026-11-22T10:47:16', 450000, N'Paid', N'Card', NULL, 22, 0, NULL, NULL, NULL), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | C6 C7 C8 C9 C10 C11
(2044, 7, NULL, '2026-11-22T10:49:43', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 351 | Chàng Mèo Mang Mũ | 22/11 15:30 | Phòng 2 | F3 F4
(2045, 7, NULL, '2026-11-22T10:55:39', 432000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 346 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 12:30 | Phòng 4 | H3 H4 H5 H6
(2046, 8, NULL, '2026-11-22T11:01:47', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 356 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 18:00 | Phòng 4 | J9 J10
(2047, 9, NULL, '2026-11-22T11:01:56', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 349 | Thiên Đường Tăm Tối | 22/11 14:45 | Phòng 3 | H4 H5
(2048, 9, 112, '2026-11-22T11:03:11', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | E6
(2049, 7, NULL, '2026-11-22T11:07:05', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 385 | Ngày Con Còn Mẹ | 23/11 18:15 | Phòng 3 | D5 D6
(2050, 9, 118, '2026-11-22T11:12:36', 180000, N'Paid', N'Cash', 180000, 18, 0, NULL, NULL, NULL), -- suat 353 | Bò Sữa Bay | 22/11 16:30 | Phòng 1 | J9 J10
(2051, 7, NULL, '2026-11-22T11:13:06', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 345 | Kẻ Hồi Sinh | 22/11 12:30 | Phòng 3 | G8 G9
(2052, 8, NULL, '2026-11-22T11:14:32', 90000, N'Cancelled', N'Cash', 100000, 0, 0, N'Nhầm suất / ghế', '2026-11-22T11:36:58', 8), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | F7
(2053, 8, 44, '2026-11-22T11:15:45', 75000, N'Paid', N'Card', NULL, 3, 0, NULL, NULL, NULL), -- suat 347 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 22/11 13:30 | Phòng 2 | B7
(2054, 8, NULL, '2026-11-22T11:24:48', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 359 | Rosetta (EUFF) | 22/11 19:15 | Phòng 3 | H8 H9
(2055, 8, NULL, '2026-11-22T11:25:42', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 346 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 12:30 | Phòng 4 | D4 D5
(2056, 8, NULL, '2026-11-22T11:27:31', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 350 | Dune: Hành Tinh Cát - Phần Hai | 22/11 15:00 | Phòng 5 | G7 G8
(2057, 9, 8, '2026-11-22T11:32:39', 180000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 349 | Thiên Đường Tăm Tối | 22/11 14:45 | Phòng 3 | J11 J12
(2058, 7, NULL, '2026-11-22T11:32:42', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | E7 E8
(2059, 8, NULL, '2026-11-22T11:33:18', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 346 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 12:30 | Phòng 4 | G4 G5
(2060, 9, 63, '2026-11-22T11:34:02', 216000, N'Cancelled', N'Cash', 500000, 15, 0, N'Khách đổi ý', '2026-11-22T11:38:46', 9), -- suat 346 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 12:30 | Phòng 4 | G6 G7
(2061, 8, NULL, '2026-11-22T11:35:58', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | G7
(2062, 8, NULL, '2026-11-22T11:39:43', 450000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 389 | Trại Giam Hạnh Phúc | 23/11 20:30 | Phòng 3 | E1 E2 E3 E4 E5
(2063, 9, 56, '2026-11-22T11:40:21', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 370 | Kiến Lé Phiêu Lưu Ké | 23/11 10:30 | Phòng 2 | G1 G2
(2064, 8, NULL, '2026-11-22T11:42:07', 216000, N'Paid', N'Cash', 220000, 0, 0, NULL, NULL, NULL), -- suat 356 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 18:00 | Phòng 4 | H5 H6
(2065, 7, 6, '2026-11-22T11:42:14', 600000, N'Paid', N'Card', NULL, 30, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | C5 C6 C7 C8 C9
(2066, 9, NULL, '2026-11-22T11:42:35', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 347 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 22/11 13:30 | Phòng 2 | J5 J6
(2067, 9, NULL, '2026-11-22T11:51:03', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 344 | Godzilla Trừ Không | 22/11 12:15 | Phòng 5 | J5 J6
(2068, 8, NULL, '2026-11-22T11:55:31', 75000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | C5
(2069, 8, 77, '2026-11-22T12:07:18', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 347 | Shaun The Sheep: "Quái Lạ" Ghé Nhà | 22/11 13:30 | Phòng 2 | C10 C11
(2070, 9, NULL, '2026-11-22T12:07:57', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 385 | Ngày Con Còn Mẹ | 23/11 18:15 | Phòng 3 | A7 A8
(2071, 9, 66, '2026-11-22T12:08:51', 10000, N'Paid', N'Card', NULL, 0, 80, NULL, NULL, NULL), -- suat 417 | Amrum (EUFF) | 24/11 19:00 | Phòng 2 | D6
(2072, 7, NULL, '2026-11-22T12:13:20', 75000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 345 | Kẻ Hồi Sinh | 22/11 12:30 | Phòng 3 | A5
(2073, 7, NULL, '2026-11-22T12:16:21', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 350 | Dune: Hành Tinh Cát - Phần Hai | 22/11 15:00 | Phòng 5 | K9 K10
(2074, 8, NULL, '2026-11-22T12:23:45', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | E9 E10
(2075, 7, NULL, '2026-11-22T12:30:36', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | D9 D10
(2076, 8, 95, '2026-11-22T12:34:33', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 355 | Trại Buôn Người | 22/11 18:00 | Phòng 2 | G4 G5
(2077, 9, NULL, '2026-11-22T12:38:02', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 404 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 24/11 12:30 | Phòng 4 | H7
(2078, 9, NULL, '2026-11-22T12:44:11', 375000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 369 | Bí Kíp Luyện Cướp | 23/11 09:30 | Phòng 3 | B6 B7 B8 B9 B10
(2079, 8, NULL, '2026-11-22T12:44:16', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 352 | Godzilla Trừ Không | 22/11 15:30 | Phòng 4 | A9 A10
(2080, 7, NULL, '2026-11-22T12:49:39', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | A6 A7
(2081, 7, 69, '2026-11-22T12:49:53', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | A2 A3
(2082, 9, NULL, '2026-11-22T12:51:39', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 356 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 18:00 | Phòng 4 | F4 F5 F6 F7
(2083, 9, 20, '2026-11-22T12:52:01', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 354 | Clayface | 22/11 17:00 | Phòng 3 | B8 B9
(2084, 7, NULL, '2026-11-22T12:54:33', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 355 | Trại Buôn Người | 22/11 18:00 | Phòng 2 | J1 J2
(2085, 8, NULL, '2026-11-22T13:05:16', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 348 | Trại Giam Hạnh Phúc | 22/11 14:00 | Phòng 1 | D9 D10 D11
(2086, 9, 60, '2026-11-22T13:05:58', 576000, N'Paid', N'Cash', 600000, 40, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | K7 K8 K9 K10
(2087, 7, 33, '2026-11-22T13:07:25', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 356 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 18:00 | Phòng 4 | E8 E9
(2088, 8, NULL, '2026-11-22T13:13:50', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 372 | Kẻ Hồi Sinh | 23/11 12:00 | Phòng 3 | G12
(2089, 9, 67, '2026-11-22T13:19:11', 216000, N'Cancelled', N'Cash', 300000, 15, 0, N'Nhầm suất / ghế', '2026-11-22T13:50:30', 9), -- suat 352 | Godzilla Trừ Không | 22/11 15:30 | Phòng 4 | E6 E7
(2090, 9, NULL, '2026-11-22T13:22:33', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 385 | Ngày Con Còn Mẹ | 23/11 18:15 | Phòng 3 | D9 D10 D11
(2091, 9, 100, '2026-11-22T13:27:06', 108000, N'Paid', N'Cash', 200000, 7, 0, NULL, NULL, NULL), -- suat 409 | Godzilla Trừ Không | 24/11 15:30 | Phòng 4 | G3
(2092, 9, 21, '2026-11-22T13:29:28', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 412 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 24/11 16:45 | Phòng 2 | F9 F10
(2093, 7, NULL, '2026-11-22T13:30:11', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | G1 G2
(2094, 7, 44, '2026-11-22T13:31:14', 432000, N'Paid', N'Cash', 432000, 30, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | H4 H5 H6
(2095, 7, NULL, '2026-11-22T13:44:19', 120000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 386 | Godzilla Trừ Không | 23/11 18:15 | Phòng 5 | D9
(2096, 7, NULL, '2026-11-22T13:44:51', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | C2 C3
(2097, 8, 114, '2026-11-22T13:48:03', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 359 | Rosetta (EUFF) | 22/11 19:15 | Phòng 3 | F6
(2098, 9, NULL, '2026-11-22T13:48:21', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | K3 K4
(2099, 9, NULL, '2026-11-22T13:50:17', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 356 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 18:00 | Phòng 4 | E4 E5
(2100, 8, NULL, '2026-11-22T13:52:01', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 354 | Clayface | 22/11 17:00 | Phòng 3 | E1 E2
(2101, 9, NULL, '2026-11-22T13:54:38', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 356 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 18:00 | Phòng 4 | B9 B10
(2102, 8, NULL, '2026-11-22T13:56:13', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 356 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 18:00 | Phòng 4 | G6
(2103, 7, NULL, '2026-11-22T13:56:17', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | G12
(2104, 7, NULL, '2026-11-22T14:04:18', 75000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 353 | Bò Sữa Bay | 22/11 16:30 | Phòng 1 | C10
(2105, 7, NULL, '2026-11-22T14:04:50', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 351 | Chàng Mèo Mang Mũ | 22/11 15:30 | Phòng 2 | F6 F7
(2106, 7, NULL, '2026-11-22T14:11:57', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | J9 J10
(2107, 8, NULL, '2026-11-22T14:16:08', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 351 | Chàng Mèo Mang Mũ | 22/11 15:30 | Phòng 2 | G1 G2
(2108, 7, NULL, '2026-11-22T14:19:54', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 363 | Chị Chị Em Em 3 | 22/11 21:30 | Phòng 1 | F2 F3
(2109, 8, NULL, '2026-11-22T14:23:02', 375000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 398 | Bí Kíp Luyện Cướp | 24/11 09:30 | Phòng 3 | B7 B8 B9 B10 B11
(2110, 7, NULL, '2026-11-22T14:26:39', 120000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | A4
(2111, 9, NULL, '2026-11-22T14:35:41', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | G9 G10
(2112, 7, NULL, '2026-11-22T14:59:21', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 354 | Clayface | 22/11 17:00 | Phòng 3 | H3 H4
(2113, 4, NULL, '2026-11-22T15:04:39', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | L7 L8
(2114, 4, 85, '2026-11-22T15:06:45', 288000, N'Paid', N'Cash', 300000, 20, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | H7 H8
(2115, 10, 113, '2026-11-22T15:10:01', 288000, N'Paid', N'Cash', 300000, 28, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | L7 L8
(2116, 10, NULL, '2026-11-22T15:11:25', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | F2 F3
(2117, 4, 81, '2026-11-22T15:14:24', 210000, N'Paid', N'Cash', 250000, 10, 30, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | D5 D6
(2118, 3, NULL, '2026-11-22T15:16:54', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 356 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 18:00 | Phòng 4 | F9
(2119, 10, NULL, '2026-11-22T15:19:59', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 361 | Bí Kíp Luyện Cướp | 22/11 21:00 | Phòng 4 | F5 F6
(2120, 10, 117, '2026-11-22T15:25:00', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | H10 H11
(2121, 10, NULL, '2026-11-22T15:29:35', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | J9
(2122, 4, 59, '2026-11-22T15:32:53', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | E6 E7
(2123, 10, NULL, '2026-11-22T15:36:59', 600000, N'Paid', N'Cash', 600000, 0, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | C5 C6 C7 C8 C9
(2124, 10, NULL, '2026-11-22T15:38:00', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 356 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 18:00 | Phòng 4 | E2 E3
(2125, 3, NULL, '2026-11-22T15:44:00', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 361 | Bí Kíp Luyện Cướp | 22/11 21:00 | Phòng 4 | J5 J6
(2126, 4, NULL, '2026-11-22T15:44:29', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | H4 H5 H6
(2127, 3, 51, '2026-11-22T15:48:29', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 355 | Trại Buôn Người | 22/11 18:00 | Phòng 2 | E7 E8
(2128, 10, 42, '2026-11-22T15:48:41', 360000, N'Paid', N'Cash', 400000, 18, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | C1 C2 C3
(2129, 10, NULL, '2026-11-22T15:51:17', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | E6
(2130, 3, NULL, '2026-11-22T15:51:49', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | D8 D9
(2131, 4, NULL, '2026-11-22T15:51:57', 180000, N'Cancelled', N'Cash', 200000, 0, 0, N'Lỗi thanh toán', '2026-11-22T16:15:46', 2), -- suat 360 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 22/11 20:45 | Phòng 2 | F5 F6
(2132, 3, NULL, '2026-11-22T15:54:52', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | J3 J4
(2133, 4, NULL, '2026-11-22T15:57:10', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 363 | Chị Chị Em Em 3 | 22/11 21:30 | Phòng 1 | B4
(2134, 4, 77, '2026-11-22T15:57:29', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 360 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 22/11 20:45 | Phòng 2 | H4 H5
(2135, 10, 68, '2026-11-22T15:58:52', 375000, N'Paid', N'Cash', 400000, 18, 0, NULL, NULL, NULL), -- suat 355 | Trại Buôn Người | 22/11 18:00 | Phòng 2 | B3 B4 B5 B6 B7
(2136, 4, NULL, '2026-11-22T16:00:22', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | H8 H9 H10 H11
(2137, 4, 46, '2026-11-22T16:06:17', 75000, N'Paid', N'Cash', 500000, 3, 0, NULL, NULL, NULL), -- suat 359 | Rosetta (EUFF) | 22/11 19:15 | Phòng 3 | C11
(2138, 10, 9, '2026-11-22T16:08:19', 108000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 356 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 22/11 18:00 | Phòng 4 | E6
(2139, 4, NULL, '2026-11-22T16:13:32', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 381 | Clayface | 23/11 16:00 | Phòng 3 | D8 D9
(2140, 3, 25, '2026-11-22T16:14:41', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 377 | Thiên Đường Tăm Tối | 23/11 14:00 | Phòng 3 | E11 E12
(2141, 4, 47, '2026-11-22T16:19:41', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | C7 C8
(2142, 3, NULL, '2026-11-22T16:21:36', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 381 | Clayface | 23/11 16:00 | Phòng 3 | C7 C8
(2143, 4, NULL, '2026-11-22T16:24:18', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 359 | Rosetta (EUFF) | 22/11 19:15 | Phòng 3 | G6 G7 G8
(2144, 4, NULL, '2026-11-22T16:31:39', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | G4 G5
(2145, 4, NULL, '2026-11-22T16:40:02', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 363 | Chị Chị Em Em 3 | 22/11 21:30 | Phòng 1 | F6 F7
(2146, 3, NULL, '2026-11-22T16:47:32', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 378 | Ngày Con Còn Mẹ | 23/11 14:30 | Phòng 2 | G10
(2147, 3, NULL, '2026-11-22T16:51:36', 450000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 361 | Bí Kíp Luyện Cướp | 22/11 21:00 | Phòng 4 | H8 H9 H10 H11 H12
(2148, 10, 100, '2026-11-22T16:55:11', 450000, N'Cancelled', N'Cash', 450000, 31, 0, N'Sự cố phòng chiếu', '2026-11-22T19:21:18', 2), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | E8 E9 E10 E11 E12
(2149, 4, NULL, '2026-11-22T16:56:04', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | F7 F8
(2150, 3, NULL, '2026-11-22T16:56:52', 375000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 417 | Amrum (EUFF) | 24/11 19:00 | Phòng 2 | A4 A5 A6 A7 A8
(2151, 10, NULL, '2026-11-22T16:59:12', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | E2 E3
(2152, 3, 110, '2026-11-22T17:20:54', 144000, N'Paid', N'Card', NULL, 10, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | F12
(2153, 4, 15, '2026-11-22T17:23:28', 60000, N'Paid', N'Cash', 100000, 4, 30, NULL, NULL, NULL), -- suat 359 | Rosetta (EUFF) | 22/11 19:15 | Phòng 3 | D7
(2154, 3, NULL, '2026-11-22T17:24:10', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | H4 H5 H6 H7
(2155, 4, NULL, '2026-11-22T17:29:04', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | A11 A12
(2156, 10, NULL, '2026-11-22T17:30:28', 240000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 357 | Godzilla Trừ Không | 22/11 18:15 | Phòng 5 | B6 B7
(2157, 10, NULL, '2026-11-22T17:38:09', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | G9 G10
(2158, 10, 85, '2026-11-22T17:43:14', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 374 | Godzilla Trừ Không | 23/11 12:15 | Phòng 5 | H4 H5
(2159, 3, NULL, '2026-11-22T17:47:05', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 359 | Rosetta (EUFF) | 22/11 19:15 | Phòng 3 | D4 D5
(2160, 3, NULL, '2026-11-22T17:52:32', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | H2 H3
(2161, 4, 21, '2026-11-22T17:59:19', 240000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | A6 A7
(2162, 4, NULL, '2026-11-22T17:59:25', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 361 | Bí Kíp Luyện Cướp | 22/11 21:00 | Phòng 4 | G5
(2163, 3, NULL, '2026-11-22T18:11:01', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 358 | Trại Giam Hạnh Phúc | 22/11 19:00 | Phòng 1 | C10
(2164, 3, NULL, '2026-11-22T18:11:32', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 387 | Trại Giam Hạnh Phúc | 23/11 18:30 | Phòng 1 | H6 H7
(2165, 3, NULL, '2026-11-22T18:12:14', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | F11 F12
(2166, 10, NULL, '2026-11-22T18:13:41', 225000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 359 | Rosetta (EUFF) | 22/11 19:15 | Phòng 3 | B6 B7 B8
(2167, 10, NULL, '2026-11-22T18:26:19', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | L3 L4
(2168, 10, NULL, '2026-11-22T18:32:44', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 359 | Rosetta (EUFF) | 22/11 19:15 | Phòng 3 | J11 J12
(2169, 3, NULL, '2026-11-22T18:38:19', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 361 | Bí Kíp Luyện Cướp | 22/11 21:00 | Phòng 4 | D6 D7
(2170, 4, NULL, '2026-11-22T18:42:31', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | H9 H10
(2171, 4, NULL, '2026-11-22T18:49:30', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 360 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 22/11 20:45 | Phòng 2 | J9 J10
(2172, 10, NULL, '2026-11-22T18:50:06', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 363 | Chị Chị Em Em 3 | 22/11 21:30 | Phòng 1 | H7 H8
(2173, 4, 24, '2026-11-22T19:00:42', 225000, N'Paid', N'Transfer', NULL, 11, 0, NULL, NULL, NULL), -- suat 363 | Chị Chị Em Em 3 | 22/11 21:30 | Phòng 1 | B5 B6 B7
(2174, 4, NULL, '2026-11-22T19:04:59', 240000, N'Paid', N'Cash', 240000, 0, 0, NULL, NULL, NULL), -- suat 415 | Godzilla Trừ Không | 24/11 18:15 | Phòng 5 | C9 C10
(2175, 10, NULL, '2026-11-22T19:07:33', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 387 | Trại Giam Hạnh Phúc | 23/11 18:30 | Phòng 1 | D4
(2176, 4, NULL, '2026-11-22T19:29:25', 360000, N'Cancelled', N'Cash', 360000, 0, 0, N'Nhầm suất / ghế', '2026-11-22T19:50:40', 4), -- suat 363 | Chị Chị Em Em 3 | 22/11 21:30 | Phòng 1 | G5 G6 G7 G8
(2177, 3, 29, '2026-11-22T19:29:54', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 390 | Chị Chị Em Em 3 | 23/11 21:00 | Phòng 1 | D12
(2178, 4, NULL, '2026-11-22T19:30:54', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | E7 E8
(2179, 4, NULL, '2026-11-22T19:33:04', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 363 | Chị Chị Em Em 3 | 22/11 21:30 | Phòng 1 | J5 J6
(2180, 3, 25, '2026-11-22T19:37:58', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | J4 J5
(2181, 3, NULL, '2026-11-22T20:05:06', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 387 | Trại Giam Hạnh Phúc | 23/11 18:30 | Phòng 1 | H10 H11
(2182, 4, NULL, '2026-11-22T20:10:22', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 360 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 22/11 20:45 | Phòng 2 | J11 J12
(2183, 4, 33, '2026-11-22T20:10:41', 254000, N'Paid', N'Transfer', NULL, 17, 34, NULL, NULL, NULL), -- suat 362 | Dune: Hành Tinh Cát - Phần Hai | 22/11 21:00 | Phòng 5 | K10 K11
(2184, 4, NULL, '2026-11-22T20:12:57', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 385 | Ngày Con Còn Mẹ | 23/11 18:15 | Phòng 3 | F2 F3 F4
(2185, 4, NULL, '2026-11-22T20:32:37', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-11-22T20:34:17', 4), -- suat 363 | Chị Chị Em Em 3 | 22/11 21:30 | Phòng 1 | J7 J8
(2186, 3, NULL, '2026-11-22T21:03:37', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 369 | Bí Kíp Luyện Cướp | 23/11 09:30 | Phòng 3 | G9 G10 G11 G12
(2187, 4, NULL, '2026-11-22T21:04:24', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 374 | Godzilla Trừ Không | 23/11 12:15 | Phòng 5 | G8
(2188, 3, 25, '2026-11-22T21:16:35', 288000, N'Paid', N'Cash', 300000, 28, 0, NULL, NULL, NULL); -- suat 403 | Godzilla Trừ Không | 24/11 12:15 | Phòng 5 | L3 L4
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(4582, 1995, 343, 1, 59, 90000, N'Active'),
(4583, 1995, 343, 1, 60, 90000, N'Active'),
(4584, 1996, 347, 2, 133, 75000, N'Cancelled'),
(4585, 1996, 347, 2, 134, 75000, N'Cancelled'),
(4586, 1997, 338, 5, 475, 120000, N'Active'),
(4587, 1997, 338, 5, 476, 120000, N'Active'),
(4588, 1997, 338, 5, 477, 120000, N'Active'),
(4589, 1998, 338, 5, 434, 120000, N'Active'),
(4590, 1998, 338, 5, 435, 120000, N'Active'),
(4591, 1998, 338, 5, 436, 120000, N'Active'),
(4592, 1998, 338, 5, 437, 120000, N'Active'),
(4593, 1998, 338, 5, 438, 120000, N'Active'),
(4594, 1999, 344, 5, 509, 144000, N'Active'),
(4595, 1999, 344, 5, 510, 144000, N'Active'),
(4596, 2000, 338, 5, 563, 144000, N'Active'),
(4597, 2000, 338, 5, 564, 144000, N'Active'),
(4598, 2001, 337, 1, 64, 90000, N'Active'),
(4599, 2001, 337, 1, 65, 90000, N'Active'),
(4600, 2001, 337, 1, 66, 90000, N'Active'),
(4601, 2002, 337, 1, 91, 90000, N'Active'),
(4602, 2002, 337, 1, 92, 90000, N'Active'),
(4603, 2003, 337, 1, 79, 90000, N'Active'),
(4604, 2003, 337, 1, 80, 90000, N'Active'),
(4605, 2004, 337, 1, 2, 75000, N'Active'),
(4606, 2004, 337, 1, 3, 75000, N'Active'),
(4607, 2004, 337, 1, 4, 75000, N'Active'),
(4608, 2005, 337, 1, 31, 75000, N'Active'),
(4609, 2005, 337, 1, 32, 75000, N'Active'),
(4610, 2005, 337, 1, 33, 75000, N'Active'),
(4611, 2005, 337, 1, 34, 75000, N'Active'),
(4612, 2005, 337, 1, 35, 75000, N'Active'),
(4613, 2006, 343, 1, 66, 90000, N'Active'),
(4614, 2006, 343, 1, 67, 90000, N'Active'),
(4615, 2007, 344, 5, 441, 120000, N'Active'),
(4616, 2007, 344, 5, 442, 120000, N'Active'),
(4617, 2008, 338, 5, 487, 144000, N'Active'),
(4618, 2008, 338, 5, 488, 144000, N'Active'),
(4619, 2008, 338, 5, 489, 144000, N'Active'),
(4620, 2008, 338, 5, 490, 144000, N'Active'),
(4621, 2009, 343, 1, 25, 75000, N'Active'),
(4622, 2009, 343, 1, 26, 75000, N'Active'),
(4623, 2009, 343, 1, 27, 75000, N'Active'),
(4624, 2009, 343, 1, 28, 75000, N'Active'),
(4625, 2010, 339, 4, 380, 108000, N'Active'),
(4626, 2010, 339, 4, 381, 108000, N'Active'),
(4627, 2010, 339, 4, 382, 108000, N'Active'),
(4628, 2011, 348, 1, 69, 90000, N'Active'),
(4629, 2011, 348, 1, 70, 90000, N'Active'),
(4630, 2011, 348, 1, 71, 90000, N'Active'),
(4631, 2012, 384, 4, 421, 108000, N'Active'),
(4632, 2012, 384, 4, 422, 108000, N'Active'),
(4633, 2013, 341, 3, 259, 90000, N'Active'),
(4634, 2013, 341, 3, 260, 90000, N'Active'),
(4635, 2013, 341, 3, 261, 90000, N'Active'),
(4636, 2014, 344, 5, 536, 144000, N'Active'),
(4637, 2014, 344, 5, 537, 144000, N'Active'),
(4638, 2015, 386, 5, 501, 144000, N'Active'),
(4639, 2015, 386, 5, 502, 144000, N'Active'),
(4640, 2016, 385, 3, 268, 90000, N'Active'),
(4641, 2016, 385, 3, 269, 90000, N'Active'),
(4642, 2017, 346, 4, 398, 108000, N'Active'),
(4643, 2018, 383, 2, 162, 90000, N'Active'),
(4644, 2018, 383, 2, 163, 90000, N'Active'),
(4645, 2019, 346, 4, 385, 108000, N'Active'),
(4646, 2019, 346, 4, 386, 108000, N'Active'),
(4647, 2020, 341, 3, 283, 90000, N'Active'),
(4648, 2020, 341, 3, 284, 90000, N'Active'),
(4649, 2021, 348, 1, 101, 90000, N'Active'),
(4650, 2021, 348, 1, 102, 90000, N'Active'),
(4651, 2022, 344, 5, 559, 144000, N'Active'),
(4652, 2022, 344, 5, 560, 144000, N'Active'),
(4653, 2023, 346, 4, 383, 108000, N'Active'),
(4654, 2023, 346, 4, 384, 108000, N'Active'),
(4655, 2024, 391, 4, 380, 90000, N'Cancelled'),
(4656, 2024, 391, 4, 381, 90000, N'Cancelled'),
(4657, 2025, 342, 2, 129, 75000, N'Active'),
(4658, 2025, 342, 2, 130, 75000, N'Active'),
(4659, 2026, 346, 4, 378, 108000, N'Active'),
(4660, 2027, 416, 1, 67, 90000, N'Active'),
(4661, 2027, 416, 1, 68, 90000, N'Active'),
(4662, 2027, 416, 1, 69, 90000, N'Active'),
(4663, 2028, 348, 1, 76, 90000, N'Active'),
(4664, 2028, 348, 1, 77, 90000, N'Active'),
(4665, 2028, 348, 1, 78, 90000, N'Active'),
(4666, 2028, 348, 1, 79, 90000, N'Active'),
(4667, 2029, 344, 5, 553, 144000, N'Active'),
(4668, 2029, 344, 5, 554, 144000, N'Active'),
(4669, 2030, 347, 2, 159, 90000, N'Active'),
(4670, 2030, 347, 2, 160, 90000, N'Active'),
(4671, 2030, 347, 2, 161, 90000, N'Active'),
(4672, 2031, 342, 2, 174, 90000, N'Active'),
(4673, 2032, 344, 5, 494, 144000, N'Active'),
(4674, 2032, 344, 5, 495, 144000, N'Active'),
(4675, 2032, 344, 5, 496, 144000, N'Active'),
(4676, 2033, 346, 4, 332, 90000, N'Active'),
(4677, 2033, 346, 4, 333, 90000, N'Active'),
(4678, 2034, 353, 1, 76, 90000, N'Cancelled'),
(4679, 2034, 353, 1, 77, 90000, N'Cancelled'),
(4680, 2035, 407, 2, 186, 90000, N'Active'),
(4681, 2035, 407, 2, 187, 90000, N'Active'),
(4682, 2035, 407, 2, 188, 90000, N'Active'),
(4683, 2035, 407, 2, 189, 90000, N'Active'),
(4684, 2036, 346, 4, 373, 108000, N'Active'),
(4685, 2036, 346, 4, 374, 108000, N'Active'),
(4686, 2036, 346, 4, 375, 108000, N'Active'),
(4687, 2037, 348, 1, 40, 90000, N'Active'),
(4688, 2038, 356, 4, 397, 108000, N'Active'),
(4689, 2038, 356, 4, 398, 108000, N'Active'),
(4690, 2038, 356, 4, 399, 108000, N'Active'),
(4691, 2038, 356, 4, 400, 108000, N'Active'),
(4692, 2039, 353, 1, 35, 75000, N'Active'),
(4693, 2039, 353, 1, 36, 75000, N'Active'),
(4694, 2040, 358, 1, 4, 75000, N'Active'),
(4695, 2040, 358, 1, 5, 75000, N'Active'),
(4696, 2040, 358, 1, 6, 75000, N'Active'),
(4697, 2040, 358, 1, 7, 75000, N'Active'),
(4698, 2040, 358, 1, 8, 75000, N'Active'),
(4699, 2040, 358, 1, 9, 75000, N'Active'),
(4700, 2041, 350, 5, 433, 120000, N'Cancelled'),
(4701, 2041, 350, 5, 434, 120000, N'Cancelled'),
(4702, 2042, 388, 2, 138, 75000, N'Active'),
(4703, 2042, 388, 2, 139, 75000, N'Active'),
(4704, 2043, 348, 1, 30, 75000, N'Active'),
(4705, 2043, 348, 1, 31, 75000, N'Active'),
(4706, 2043, 348, 1, 32, 75000, N'Active'),
(4707, 2043, 348, 1, 33, 75000, N'Active'),
(4708, 2043, 348, 1, 34, 75000, N'Active'),
(4709, 2043, 348, 1, 35, 75000, N'Active'),
(4710, 2044, 351, 2, 171, 90000, N'Active'),
(4711, 2044, 351, 2, 172, 90000, N'Active'),
(4712, 2045, 346, 4, 411, 108000, N'Active'),
(4713, 2045, 346, 4, 412, 108000, N'Active'),
(4714, 2045, 346, 4, 413, 108000, N'Active'),
(4715, 2045, 346, 4, 414, 108000, N'Active'),
(4716, 2046, 356, 4, 429, 108000, N'Active'),
(4717, 2046, 356, 4, 430, 108000, N'Active'),
(4718, 2047, 349, 3, 304, 90000, N'Active'),
(4719, 2047, 349, 3, 305, 90000, N'Active'),
(4720, 2048, 348, 1, 54, 90000, N'Active'),
(4721, 2049, 385, 3, 257, 90000, N'Active'),
(4722, 2049, 385, 3, 258, 90000, N'Active'),
(4723, 2050, 353, 1, 105, 90000, N'Active'),
(4724, 2050, 353, 1, 106, 90000, N'Active'),
(4725, 2051, 345, 3, 296, 90000, N'Active'),
(4726, 2051, 345, 3, 297, 90000, N'Active'),
(4727, 2052, 348, 1, 67, 90000, N'Cancelled'),
(4728, 2053, 347, 2, 127, 75000, N'Active'),
(4729, 2054, 359, 3, 308, 90000, N'Active'),
(4730, 2054, 359, 3, 309, 90000, N'Active'),
(4731, 2055, 346, 4, 364, 108000, N'Active'),
(4732, 2055, 346, 4, 365, 108000, N'Active'),
(4733, 2056, 350, 5, 511, 144000, N'Active'),
(4734, 2056, 350, 5, 512, 144000, N'Active'),
(4735, 2057, 349, 3, 323, 90000, N'Active'),
(4736, 2057, 349, 3, 324, 90000, N'Active'),
(4737, 2058, 348, 1, 55, 90000, N'Active'),
(4738, 2058, 348, 1, 56, 90000, N'Active'),
(4739, 2059, 346, 4, 400, 108000, N'Active'),
(4740, 2059, 346, 4, 401, 108000, N'Active'),
(4741, 2060, 346, 4, 402, 108000, N'Cancelled'),
(4742, 2060, 346, 4, 403, 108000, N'Cancelled'),
(4743, 2061, 357, 5, 511, 144000, N'Active'),
(4744, 2062, 389, 3, 265, 90000, N'Active'),
(4745, 2062, 389, 3, 266, 90000, N'Active'),
(4746, 2062, 389, 3, 267, 90000, N'Active'),
(4747, 2062, 389, 3, 268, 90000, N'Active'),
(4748, 2062, 389, 3, 269, 90000, N'Active'),
(4749, 2063, 370, 2, 181, 90000, N'Active'),
(4750, 2063, 370, 2, 182, 90000, N'Active'),
(4751, 2064, 356, 4, 413, 108000, N'Active'),
(4752, 2064, 356, 4, 414, 108000, N'Active'),
(4753, 2065, 357, 5, 461, 120000, N'Active'),
(4754, 2065, 357, 5, 462, 120000, N'Active'),
(4755, 2065, 357, 5, 463, 120000, N'Active'),
(4756, 2065, 357, 5, 464, 120000, N'Active'),
(4757, 2065, 357, 5, 465, 120000, N'Active'),
(4758, 2066, 347, 2, 209, 90000, N'Active'),
(4759, 2066, 347, 2, 210, 90000, N'Active'),
(4760, 2067, 344, 5, 533, 144000, N'Active'),
(4761, 2067, 344, 5, 534, 144000, N'Active'),
(4762, 2068, 358, 1, 29, 75000, N'Active'),
(4763, 2069, 347, 2, 142, 75000, N'Active'),
(4764, 2069, 347, 2, 143, 75000, N'Active'),
(4765, 2070, 385, 3, 223, 75000, N'Active'),
(4766, 2070, 385, 3, 224, 75000, N'Active'),
(4767, 2071, 417, 2, 150, 90000, N'Active'),
(4768, 2072, 345, 3, 221, 75000, N'Active'),
(4769, 2073, 350, 5, 549, 144000, N'Active'),
(4770, 2073, 350, 5, 550, 144000, N'Active'),
(4771, 2074, 348, 1, 57, 90000, N'Active'),
(4772, 2074, 348, 1, 58, 90000, N'Active'),
(4773, 2075, 357, 5, 477, 120000, N'Active'),
(4774, 2075, 357, 5, 478, 120000, N'Active'),
(4775, 2076, 355, 2, 184, 90000, N'Active'),
(4776, 2076, 355, 2, 185, 90000, N'Active'),
(4777, 2077, 404, 4, 415, 108000, N'Active'),
(4778, 2078, 369, 3, 234, 75000, N'Active'),
(4779, 2078, 369, 3, 235, 75000, N'Active'),
(4780, 2078, 369, 3, 236, 75000, N'Active'),
(4781, 2078, 369, 3, 237, 75000, N'Active'),
(4782, 2078, 369, 3, 238, 75000, N'Active'),
(4783, 2079, 352, 4, 333, 90000, N'Active'),
(4784, 2079, 352, 4, 334, 90000, N'Active'),
(4785, 2080, 348, 1, 6, 75000, N'Active'),
(4786, 2080, 348, 1, 7, 75000, N'Active'),
(4787, 2081, 348, 1, 2, 75000, N'Active'),
(4788, 2081, 348, 1, 3, 75000, N'Active'),
(4789, 2082, 356, 4, 388, 108000, N'Active'),
(4790, 2082, 356, 4, 389, 108000, N'Active'),
(4791, 2082, 356, 4, 390, 108000, N'Active'),
(4792, 2082, 356, 4, 391, 108000, N'Active'),
(4793, 2083, 354, 3, 236, 75000, N'Active'),
(4794, 2083, 354, 3, 237, 75000, N'Active'),
(4795, 2084, 355, 2, 205, 90000, N'Active'),
(4796, 2084, 355, 2, 206, 90000, N'Active'),
(4797, 2085, 348, 1, 45, 90000, N'Active'),
(4798, 2085, 348, 1, 46, 90000, N'Active'),
(4799, 2085, 348, 1, 47, 90000, N'Active'),
(4800, 2086, 357, 5, 547, 144000, N'Active'),
(4801, 2086, 357, 5, 548, 144000, N'Active'),
(4802, 2086, 357, 5, 549, 144000, N'Active'),
(4803, 2086, 357, 5, 550, 144000, N'Active'),
(4804, 2087, 356, 4, 380, 108000, N'Active'),
(4805, 2087, 356, 4, 381, 108000, N'Active'),
(4806, 2088, 372, 3, 300, 90000, N'Active'),
(4807, 2089, 352, 4, 378, 108000, N'Cancelled'),
(4808, 2089, 352, 4, 379, 108000, N'Cancelled'),
(4809, 2090, 385, 3, 261, 90000, N'Active'),
(4810, 2090, 385, 3, 262, 90000, N'Active'),
(4811, 2090, 385, 3, 263, 90000, N'Active'),
(4812, 2091, 409, 4, 399, 108000, N'Active'),
(4813, 2092, 412, 2, 177, 90000, N'Active'),
(4814, 2092, 412, 2, 178, 90000, N'Active'),
(4815, 2093, 358, 1, 73, 90000, N'Active'),
(4816, 2093, 358, 1, 74, 90000, N'Active'),
(4817, 2094, 357, 5, 520, 144000, N'Active'),
(4818, 2094, 357, 5, 521, 144000, N'Active'),
(4819, 2094, 357, 5, 522, 144000, N'Active'),
(4820, 2095, 386, 5, 477, 120000, N'Active'),
(4821, 2096, 358, 1, 26, 75000, N'Active'),
(4822, 2096, 358, 1, 27, 75000, N'Active'),
(4823, 2097, 359, 3, 282, 90000, N'Active'),
(4824, 2098, 357, 5, 543, 144000, N'Active'),
(4825, 2098, 357, 5, 544, 144000, N'Active'),
(4826, 2099, 356, 4, 376, 108000, N'Active'),
(4827, 2099, 356, 4, 377, 108000, N'Active'),
(4828, 2100, 354, 3, 265, 90000, N'Active'),
(4829, 2100, 354, 3, 266, 90000, N'Active'),
(4830, 2101, 356, 4, 345, 90000, N'Active'),
(4831, 2101, 356, 4, 346, 90000, N'Active'),
(4832, 2102, 356, 4, 402, 108000, N'Active'),
(4833, 2103, 357, 5, 516, 144000, N'Active'),
(4834, 2104, 353, 1, 34, 75000, N'Active'),
(4835, 2105, 351, 2, 174, 90000, N'Active'),
(4836, 2105, 351, 2, 175, 90000, N'Active'),
(4837, 2106, 358, 1, 105, 90000, N'Active'),
(4838, 2106, 358, 1, 106, 90000, N'Active'),
(4839, 2107, 351, 2, 181, 90000, N'Active'),
(4840, 2107, 351, 2, 182, 90000, N'Active'),
(4841, 2108, 363, 1, 62, 90000, N'Active'),
(4842, 2108, 363, 1, 63, 90000, N'Active'),
(4843, 2109, 398, 3, 235, 75000, N'Active'),
(4844, 2109, 398, 3, 236, 75000, N'Active'),
(4845, 2109, 398, 3, 237, 75000, N'Active'),
(4846, 2109, 398, 3, 238, 75000, N'Active'),
(4847, 2109, 398, 3, 239, 75000, N'Active'),
(4848, 2110, 357, 5, 436, 120000, N'Active'),
(4849, 2111, 357, 5, 513, 144000, N'Active'),
(4850, 2111, 357, 5, 514, 144000, N'Active'),
(4851, 2112, 354, 3, 303, 90000, N'Active'),
(4852, 2112, 354, 3, 304, 90000, N'Active'),
(4853, 2113, 357, 5, 559, 144000, N'Active'),
(4854, 2113, 357, 5, 560, 144000, N'Active'),
(4855, 2114, 357, 5, 523, 144000, N'Active'),
(4856, 2114, 357, 5, 524, 144000, N'Active'),
(4857, 2115, 362, 5, 559, 144000, N'Active'),
(4858, 2115, 362, 5, 560, 144000, N'Active'),
(4859, 2116, 358, 1, 62, 90000, N'Active'),
(4860, 2116, 358, 1, 63, 90000, N'Active'),
(4861, 2117, 357, 5, 473, 120000, N'Active'),
(4862, 2117, 357, 5, 474, 120000, N'Active'),
(4863, 2118, 356, 4, 393, 108000, N'Active'),
(4864, 2119, 361, 4, 389, 90000, N'Active'),
(4865, 2119, 361, 4, 390, 90000, N'Active'),
(4866, 2120, 357, 5, 526, 144000, N'Active'),
(4867, 2120, 357, 5, 527, 144000, N'Active'),
(4868, 2121, 357, 5, 537, 144000, N'Active'),
(4869, 2122, 358, 1, 54, 90000, N'Active'),
(4870, 2122, 358, 1, 55, 90000, N'Active'),
(4871, 2123, 362, 5, 461, 120000, N'Active'),
(4872, 2123, 362, 5, 462, 120000, N'Active'),
(4873, 2123, 362, 5, 463, 120000, N'Active'),
(4874, 2123, 362, 5, 464, 120000, N'Active'),
(4875, 2123, 362, 5, 465, 120000, N'Active'),
(4876, 2124, 356, 4, 374, 108000, N'Active'),
(4877, 2124, 356, 4, 375, 108000, N'Active'),
(4878, 2125, 361, 4, 425, 90000, N'Active'),
(4879, 2125, 361, 4, 426, 90000, N'Active'),
(4880, 2126, 358, 1, 88, 90000, N'Active'),
(4881, 2126, 358, 1, 89, 90000, N'Active'),
(4882, 2126, 358, 1, 90, 90000, N'Active'),
(4883, 2127, 355, 2, 163, 90000, N'Active'),
(4884, 2127, 355, 2, 164, 90000, N'Active'),
(4885, 2128, 362, 5, 457, 120000, N'Active'),
(4886, 2128, 362, 5, 458, 120000, N'Active'),
(4887, 2128, 362, 5, 459, 120000, N'Active'),
(4888, 2129, 357, 5, 486, 144000, N'Active'),
(4889, 2130, 358, 1, 44, 90000, N'Active'),
(4890, 2130, 358, 1, 45, 90000, N'Active'),
(4891, 2131, 360, 2, 173, 90000, N'Cancelled'),
(4892, 2131, 360, 2, 174, 90000, N'Cancelled'),
(4893, 2132, 358, 1, 99, 90000, N'Active'),
(4894, 2132, 358, 1, 100, 90000, N'Active'),
(4895, 2133, 363, 1, 16, 75000, N'Active'),
(4896, 2134, 360, 2, 196, 90000, N'Active'),
(4897, 2134, 360, 2, 197, 90000, N'Active'),
(4898, 2135, 355, 2, 123, 75000, N'Active'),
(4899, 2135, 355, 2, 124, 75000, N'Active'),
(4900, 2135, 355, 2, 125, 75000, N'Active'),
(4901, 2135, 355, 2, 126, 75000, N'Active'),
(4902, 2135, 355, 2, 127, 75000, N'Active'),
(4903, 2136, 358, 1, 92, 90000, N'Active'),
(4904, 2136, 358, 1, 93, 90000, N'Active'),
(4905, 2136, 358, 1, 94, 90000, N'Active'),
(4906, 2136, 358, 1, 95, 90000, N'Active'),
(4907, 2137, 359, 3, 251, 75000, N'Active'),
(4908, 2138, 356, 4, 378, 108000, N'Active'),
(4909, 2139, 381, 3, 260, 90000, N'Active'),
(4910, 2139, 381, 3, 261, 90000, N'Active'),
(4911, 2140, 377, 3, 275, 90000, N'Active'),
(4912, 2140, 377, 3, 276, 90000, N'Active'),
(4913, 2141, 358, 1, 31, 75000, N'Active'),
(4914, 2141, 358, 1, 32, 75000, N'Active'),
(4915, 2142, 381, 3, 247, 75000, N'Active'),
(4916, 2142, 381, 3, 248, 75000, N'Active'),
(4917, 2143, 359, 3, 294, 90000, N'Active'),
(4918, 2143, 359, 3, 295, 90000, N'Active'),
(4919, 2143, 359, 3, 296, 90000, N'Active'),
(4920, 2144, 357, 5, 508, 144000, N'Active'),
(4921, 2144, 357, 5, 509, 144000, N'Active'),
(4922, 2145, 363, 1, 66, 90000, N'Active'),
(4923, 2145, 363, 1, 67, 90000, N'Active'),
(4924, 2146, 378, 2, 190, 90000, N'Active'),
(4925, 2147, 361, 4, 416, 90000, N'Active'),
(4926, 2147, 361, 4, 417, 90000, N'Active'),
(4927, 2147, 361, 4, 418, 90000, N'Active'),
(4928, 2147, 361, 4, 419, 90000, N'Active'),
(4929, 2147, 361, 4, 420, 90000, N'Active'),
(4930, 2148, 358, 1, 56, 90000, N'Cancelled'),
(4931, 2148, 358, 1, 57, 90000, N'Cancelled'),
(4932, 2148, 358, 1, 58, 90000, N'Cancelled'),
(4933, 2148, 358, 1, 59, 90000, N'Cancelled'),
(4934, 2148, 358, 1, 60, 90000, N'Cancelled'),
(4935, 2149, 362, 5, 499, 144000, N'Active'),
(4936, 2149, 362, 5, 500, 144000, N'Active'),
(4937, 2150, 417, 2, 112, 75000, N'Active'),
(4938, 2150, 417, 2, 113, 75000, N'Active'),
(4939, 2150, 417, 2, 114, 75000, N'Active'),
(4940, 2150, 417, 2, 115, 75000, N'Active'),
(4941, 2150, 417, 2, 116, 75000, N'Active'),
(4942, 2151, 362, 5, 482, 144000, N'Active'),
(4943, 2151, 362, 5, 483, 144000, N'Active'),
(4944, 2152, 357, 5, 504, 144000, N'Active'),
(4945, 2153, 359, 3, 259, 90000, N'Active'),
(4946, 2154, 362, 5, 520, 144000, N'Active'),
(4947, 2154, 362, 5, 521, 144000, N'Active'),
(4948, 2154, 362, 5, 522, 144000, N'Active'),
(4949, 2154, 362, 5, 523, 144000, N'Active'),
(4950, 2155, 358, 1, 11, 75000, N'Active'),
(4951, 2155, 358, 1, 12, 75000, N'Active'),
(4952, 2156, 357, 5, 450, 120000, N'Active'),
(4953, 2156, 357, 5, 451, 120000, N'Active'),
(4954, 2157, 358, 1, 81, 90000, N'Active'),
(4955, 2157, 358, 1, 82, 90000, N'Active'),
(4956, 2158, 374, 5, 520, 144000, N'Active'),
(4957, 2158, 374, 5, 521, 144000, N'Active'),
(4958, 2159, 359, 3, 256, 90000, N'Active'),
(4959, 2159, 359, 3, 257, 90000, N'Active'),
(4960, 2160, 358, 1, 86, 90000, N'Active'),
(4961, 2160, 358, 1, 87, 90000, N'Active'),
(4962, 2161, 362, 5, 438, 120000, N'Active'),
(4963, 2161, 362, 5, 439, 120000, N'Active'),
(4964, 2162, 361, 4, 401, 90000, N'Active'),
(4965, 2163, 358, 1, 34, 75000, N'Active'),
(4966, 2164, 387, 1, 90, 90000, N'Active'),
(4967, 2164, 387, 1, 91, 90000, N'Active'),
(4968, 2165, 362, 5, 503, 144000, N'Active'),
(4969, 2165, 362, 5, 504, 144000, N'Active'),
(4970, 2166, 359, 3, 234, 75000, N'Active'),
(4971, 2166, 359, 3, 235, 75000, N'Active'),
(4972, 2166, 359, 3, 236, 75000, N'Active'),
(4973, 2167, 362, 5, 555, 144000, N'Active'),
(4974, 2167, 362, 5, 556, 144000, N'Active'),
(4975, 2168, 359, 3, 323, 90000, N'Active'),
(4976, 2168, 359, 3, 324, 90000, N'Active'),
(4977, 2169, 361, 4, 366, 90000, N'Active'),
(4978, 2169, 361, 4, 367, 90000, N'Active'),
(4979, 2170, 362, 5, 525, 144000, N'Active'),
(4980, 2170, 362, 5, 526, 144000, N'Active'),
(4981, 2171, 360, 2, 213, 90000, N'Active'),
(4982, 2171, 360, 2, 214, 90000, N'Active'),
(4983, 2172, 363, 1, 91, 90000, N'Active'),
(4984, 2172, 363, 1, 92, 90000, N'Active'),
(4985, 2173, 363, 1, 17, 75000, N'Active'),
(4986, 2173, 363, 1, 18, 75000, N'Active'),
(4987, 2173, 363, 1, 19, 75000, N'Active'),
(4988, 2174, 415, 5, 465, 120000, N'Active'),
(4989, 2174, 415, 5, 466, 120000, N'Active'),
(4990, 2175, 387, 1, 40, 90000, N'Active'),
(4991, 2176, 363, 1, 77, 90000, N'Cancelled'),
(4992, 2176, 363, 1, 78, 90000, N'Cancelled'),
(4993, 2176, 363, 1, 79, 90000, N'Cancelled'),
(4994, 2176, 363, 1, 80, 90000, N'Cancelled'),
(4995, 2177, 390, 1, 48, 90000, N'Active'),
(4996, 2178, 362, 5, 487, 144000, N'Active'),
(4997, 2178, 362, 5, 488, 144000, N'Active'),
(4998, 2179, 363, 1, 101, 90000, N'Active'),
(4999, 2179, 363, 1, 102, 90000, N'Active'),
(5000, 2180, 362, 5, 532, 144000, N'Active'),
(5001, 2180, 362, 5, 533, 144000, N'Active'),
(5002, 2181, 387, 1, 94, 90000, N'Active'),
(5003, 2181, 387, 1, 95, 90000, N'Active'),
(5004, 2182, 360, 2, 215, 90000, N'Active'),
(5005, 2182, 360, 2, 216, 90000, N'Active'),
(5006, 2183, 362, 5, 550, 144000, N'Active'),
(5007, 2183, 362, 5, 551, 144000, N'Active'),
(5008, 2184, 385, 3, 278, 90000, N'Active'),
(5009, 2184, 385, 3, 279, 90000, N'Active'),
(5010, 2184, 385, 3, 280, 90000, N'Active'),
(5011, 2185, 363, 1, 103, 90000, N'Cancelled'),
(5012, 2185, 363, 1, 104, 90000, N'Cancelled'),
(5013, 2186, 369, 3, 297, 90000, N'Active'),
(5014, 2186, 369, 3, 298, 90000, N'Active'),
(5015, 2186, 369, 3, 299, 90000, N'Active'),
(5016, 2186, 369, 3, 300, 90000, N'Active'),
(5017, 2187, 374, 5, 512, 144000, N'Active'),
(5018, 2188, 403, 5, 555, 144000, N'Active'),
(5019, 2188, 403, 5, 556, 144000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 2 23/11/2026: 138 hoa don (1 huy), 305 ve, doanh thu 30.061.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(2189, 3, NULL, '2026-11-23T08:02:14', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 399 | Kiến Lé Phiêu Lưu Ké | 24/11 10:30 | Phòng 2 | J9 J10
(2190, 10, NULL, '2026-11-23T08:05:22', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 422 | Trại Buôn Người | 24/11 21:15 | Phòng 2 | G7 G8 G9 G10
(2191, 3, NULL, '2026-11-23T08:14:24', 576000, N'Paid', N'Cash', 576000, 0, 0, NULL, NULL, NULL), -- suat 367 | Dune: Hành Tinh Cát | 23/11 09:00 | Phòng 5 | G1 G2 G3 G4
(2192, 3, 92, '2026-11-23T08:15:16', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 376 | Trại Giam Hạnh Phúc | 23/11 13:45 | Phòng 1 | D6
(2193, 3, NULL, '2026-11-23T08:16:07', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 365 | Trại Giam Hạnh Phúc | 23/11 09:00 | Phòng 1 | B5 B6
(2194, 3, NULL, '2026-11-23T08:21:27', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 431 | Chàng Mèo Mang Mũ | 25/11 12:15 | Phòng 2 | C6 C7
(2195, 3, NULL, '2026-11-23T08:28:52', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 367 | Dune: Hành Tinh Cát | 23/11 09:00 | Phòng 5 | E6 E7 E8
(2196, 3, NULL, '2026-11-23T08:29:41', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 376 | Trại Giam Hạnh Phúc | 23/11 13:45 | Phòng 1 | A7
(2197, 3, NULL, '2026-11-23T08:34:50', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 365 | Trại Giam Hạnh Phúc | 23/11 09:00 | Phòng 1 | E8 E9
(2198, 3, NULL, '2026-11-23T08:36:07', 240000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 367 | Dune: Hành Tinh Cát | 23/11 09:00 | Phòng 5 | D8 D9
(2199, 3, 106, '2026-11-23T08:37:24', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 368 | Ramayana: Khởi Nguồn Một Huyền Thoại | 23/11 09:15 | Phòng 4 | H2 H3
(2200, 3, NULL, '2026-11-23T08:42:40', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 370 | Kiến Lé Phiêu Lưu Ké | 23/11 10:30 | Phòng 2 | G6 G7
(2201, 3, 96, '2026-11-23T08:47:23', 144000, N'Paid', N'Card', NULL, 10, 0, NULL, NULL, NULL), -- suat 367 | Dune: Hành Tinh Cát | 23/11 09:00 | Phòng 5 | K5
(2202, 3, 2, '2026-11-23T09:16:18', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 414 | Ngày Con Còn Mẹ | 24/11 18:15 | Phòng 3 | J7 J8
(2203, 3, 117, '2026-11-23T09:19:45', 180000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 371 | Ngày Con Còn Mẹ | 23/11 11:30 | Phòng 1 | J9 J10
(2204, 3, NULL, '2026-11-23T09:39:20', 450000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 427 | Bí Kíp Luyện Cướp | 25/11 09:30 | Phòng 3 | D6 D7 D8 D9 D10
(2205, 3, NULL, '2026-11-23T09:43:33', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 378 | Ngày Con Còn Mẹ | 23/11 14:30 | Phòng 2 | J11 J12
(2206, 10, NULL, '2026-11-23T09:47:43', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 371 | Ngày Con Còn Mẹ | 23/11 11:30 | Phòng 1 | G9 G10 G11 G12
(2207, 10, NULL, '2026-11-23T09:50:16', 120000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 379 | Dune: Hành Tinh Cát - Phần Hai | 23/11 15:00 | Phòng 5 | B7
(2208, 10, 93, '2026-11-23T09:54:25', 115000, N'Paid', N'Transfer', NULL, 11, 65, NULL, NULL, NULL), -- suat 377 | Thiên Đường Tăm Tối | 23/11 14:00 | Phòng 3 | J5 J6
(2209, 3, NULL, '2026-11-23T10:02:28', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 372 | Kẻ Hồi Sinh | 23/11 12:00 | Phòng 3 | H2 H3 H4
(2210, 3, 46, '2026-11-23T10:05:07', 360000, N'Paid', N'Cash', 400000, 25, 0, NULL, NULL, NULL), -- suat 376 | Trại Giam Hạnh Phúc | 23/11 13:45 | Phòng 1 | E4 E5 E6 E7
(2211, 10, NULL, '2026-11-23T10:07:05', 240000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 379 | Dune: Hành Tinh Cát - Phần Hai | 23/11 15:00 | Phòng 5 | D4 D5
(2212, 3, NULL, '2026-11-23T10:12:10', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 411 | Bò Sữa Bay | 24/11 16:15 | Phòng 1 | H11 H12
(2213, 3, 32, '2026-11-23T10:14:11', 75000, N'Paid', N'Cash', 75000, 3, 0, NULL, NULL, NULL), -- suat 370 | Kiến Lé Phiêu Lưu Ké | 23/11 10:30 | Phòng 2 | B6
(2214, 10, NULL, '2026-11-23T10:16:04', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 374 | Godzilla Trừ Không | 23/11 12:15 | Phòng 5 | L1 L2
(2215, 3, 37, '2026-11-23T10:20:36', 150000, N'Paid', N'Cash', 200000, 7, 0, NULL, NULL, NULL), -- suat 377 | Thiên Đường Tăm Tối | 23/11 14:00 | Phòng 3 | B9 B10
(2216, 10, 69, '2026-11-23T10:30:05', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 400 | Ngày Con Còn Mẹ | 24/11 11:30 | Phòng 1 | E4 E5 E6 E7
(2217, 3, 73, '2026-11-23T10:36:04', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 372 | Kẻ Hồi Sinh | 23/11 12:00 | Phòng 3 | G9 G10 G11
(2218, 3, NULL, '2026-11-23T10:36:46', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 424 | Ma Mút Con Vượt Kỷ Băng Hà | 25/11 09:00 | Phòng 2 | D1 D2
(2219, 3, NULL, '2026-11-23T10:38:31', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 375 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 23/11 12:30 | Phòng 4 | G2 G3
(2220, 10, NULL, '2026-11-23T10:38:45', 240000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 374 | Godzilla Trừ Không | 23/11 12:15 | Phòng 5 | D2 D3
(2221, 10, NULL, '2026-11-23T10:43:17', 324000, N'Paid', N'Cash', 324000, 0, 0, NULL, NULL, NULL), -- suat 375 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 23/11 12:30 | Phòng 4 | D8 D9 D10
(2222, 3, NULL, '2026-11-23T10:43:37', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 422 | Trại Buôn Người | 24/11 21:15 | Phòng 2 | H4 H5 H6 H7
(2223, 3, 21, '2026-11-23T10:45:55', 216000, N'Paid', N'Cash', 216000, 15, 0, NULL, NULL, NULL), -- suat 375 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 23/11 12:30 | Phòng 4 | E10 E11
(2224, 3, NULL, '2026-11-23T10:49:32', 225000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 373 | Chàng Mèo Mang Mũ | 23/11 12:15 | Phòng 2 | C6 C7 C8
(2225, 10, 66, '2026-11-23T10:51:45', 540000, N'Paid', N'Card', NULL, 37, 0, NULL, NULL, NULL), -- suat 409 | Godzilla Trừ Không | 24/11 15:30 | Phòng 4 | F3 F4 F5 F6 F7
(2226, 3, NULL, '2026-11-23T11:00:26', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 375 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 23/11 12:30 | Phòng 4 | F11 F12
(2227, 3, NULL, '2026-11-23T11:01:56', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 375 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 23/11 12:30 | Phòng 4 | D1 D2
(2228, 3, NULL, '2026-11-23T11:17:23', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 374 | Godzilla Trừ Không | 23/11 12:15 | Phòng 5 | L7 L8
(2229, 3, NULL, '2026-11-23T11:18:56', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 374 | Godzilla Trừ Không | 23/11 12:15 | Phòng 5 | E6 E7
(2230, 3, NULL, '2026-11-23T11:19:20', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 372 | Kẻ Hồi Sinh | 23/11 12:00 | Phòng 3 | F10
(2231, 10, NULL, '2026-11-23T11:22:16', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 375 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 23/11 12:30 | Phòng 4 | G7 G8
(2232, 10, 104, '2026-11-23T11:30:45', 180000, N'Paid', N'Cash', 180000, 9, 0, NULL, NULL, NULL), -- suat 384 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 23/11 18:00 | Phòng 4 | B5 B6
(2233, 3, NULL, '2026-11-23T11:31:11', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 373 | Chàng Mèo Mang Mũ | 23/11 12:15 | Phòng 2 | H5
(2234, 3, NULL, '2026-11-23T11:32:30', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 373 | Chàng Mèo Mang Mũ | 23/11 12:15 | Phòng 2 | G2 G3
(2235, 3, NULL, '2026-11-23T11:36:02', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 382 | Bò Sữa Bay | 23/11 16:15 | Phòng 1 | D2
(2236, 3, 28, '2026-11-23T11:38:41', 55000, N'Paid', N'Transfer', NULL, 2, 20, NULL, NULL, NULL), -- suat 385 | Ngày Con Còn Mẹ | 23/11 18:15 | Phòng 3 | A3
(2237, 10, NULL, '2026-11-23T11:48:14', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 438 | Godzilla Trừ Không | 25/11 15:30 | Phòng 4 | F7 F8
(2238, 3, NULL, '2026-11-23T11:48:55', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 413 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 24/11 18:00 | Phòng 4 | B5 B6
(2239, 10, 58, '2026-11-23T11:49:17', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 387 | Trại Giam Hạnh Phúc | 23/11 18:30 | Phòng 1 | E5 E6
(2240, 3, 40, '2026-11-23T11:56:04', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 387 | Trại Giam Hạnh Phúc | 23/11 18:30 | Phòng 1 | E8 E9
(2241, 3, 98, '2026-11-23T12:01:04', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 434 | Trại Giam Hạnh Phúc | 25/11 13:45 | Phòng 1 | H7 H8
(2242, 3, NULL, '2026-11-23T12:01:29', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 403 | Godzilla Trừ Không | 24/11 12:15 | Phòng 5 | C5 C6 C7
(2243, 3, NULL, '2026-11-23T12:15:32', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 379 | Dune: Hành Tinh Cát - Phần Hai | 23/11 15:00 | Phòng 5 | E5 E6 E7 E8
(2244, 3, NULL, '2026-11-23T12:23:21', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 381 | Clayface | 23/11 16:00 | Phòng 3 | F4 F5
(2245, 10, NULL, '2026-11-23T12:33:52', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 380 | Godzilla Trừ Không | 23/11 15:30 | Phòng 4 | C5 C6
(2246, 10, NULL, '2026-11-23T12:34:44', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 435 | Thiên Đường Tăm Tối | 25/11 14:00 | Phòng 3 | H1 H2 H3
(2247, 3, NULL, '2026-11-23T12:43:30', 180000, N'Cancelled', N'Cash', 180000, 0, 0, N'Khách đổi ý', '2026-11-23T12:46:56', 3), -- suat 405 | Trại Giam Hạnh Phúc | 24/11 13:45 | Phòng 1 | F9 F10
(2248, 10, NULL, '2026-11-23T12:46:17', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 380 | Godzilla Trừ Không | 23/11 15:30 | Phòng 4 | E6 E7 E8
(2249, 10, 28, '2026-11-23T12:50:55', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 378 | Ngày Con Còn Mẹ | 23/11 14:30 | Phòng 2 | G8 G9
(2250, 10, NULL, '2026-11-23T12:51:09', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 378 | Ngày Con Còn Mẹ | 23/11 14:30 | Phòng 2 | H9 H10 H11 H12
(2251, 10, 68, '2026-11-23T13:00:11', 108000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 384 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 23/11 18:00 | Phòng 4 | D10
(2252, 3, NULL, '2026-11-23T13:01:03', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 416 | Trại Giam Hạnh Phúc | 24/11 18:30 | Phòng 1 | G6 G7
(2253, 3, NULL, '2026-11-23T13:02:16', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 392 | Dune: Hành Tinh Cát - Phần Hai | 23/11 21:00 | Phòng 5 | G11
(2254, 3, NULL, '2026-11-23T13:08:50', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 380 | Godzilla Trừ Không | 23/11 15:30 | Phòng 4 | H5
(2255, 3, 31, '2026-11-23T13:15:41', 450000, N'Paid', N'Transfer', NULL, 31, 0, NULL, NULL, NULL), -- suat 377 | Thiên Đường Tăm Tối | 23/11 14:00 | Phòng 3 | E2 E3 E4 E5 E6
(2256, 10, 19, '2026-11-23T13:25:05', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 383 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 23/11 16:45 | Phòng 2 | C1 C2
(2257, 3, NULL, '2026-11-23T13:29:38', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 380 | Godzilla Trừ Không | 23/11 15:30 | Phòng 4 | H9 H10
(2258, 3, 67, '2026-11-23T13:38:21', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 386 | Godzilla Trừ Không | 23/11 18:15 | Phòng 5 | K6 K7
(2259, 10, 70, '2026-11-23T13:54:20', 360000, N'Paid', N'Card', NULL, 25, 0, NULL, NULL, NULL), -- suat 383 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 23/11 16:45 | Phòng 2 | F5 F6 F7 F8
(2260, 3, 24, '2026-11-23T13:55:49', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 388 | Ba Cây Số Từ Nơi Tận Cùng Thế Giới (EUFF) | 23/11 19:00 | Phòng 2 | D10 D11
(2261, 3, NULL, '2026-11-23T14:06:16', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 382 | Bò Sữa Bay | 23/11 16:15 | Phòng 1 | B10 B11
(2262, 10, 29, '2026-11-23T14:13:11', 180000, N'Paid', N'Card', NULL, 9, 0, NULL, NULL, NULL), -- suat 380 | Godzilla Trừ Không | 23/11 15:30 | Phòng 4 | B5 B6
(2263, 10, NULL, '2026-11-23T14:15:41', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 386 | Godzilla Trừ Không | 23/11 18:15 | Phòng 5 | L9 L10
(2264, 10, NULL, '2026-11-23T14:21:33', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 388 | Ba Cây Số Từ Nơi Tận Cùng Thế Giới (EUFF) | 23/11 19:00 | Phòng 2 | J11 J12
(2265, 3, 31, '2026-11-23T14:30:26', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 384 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 23/11 18:00 | Phòng 4 | G5 G6
(2266, 10, 46, '2026-11-23T14:30:52', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 384 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 23/11 18:00 | Phòng 4 | E6 E7
(2267, 10, 25, '2026-11-23T14:40:02', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 387 | Trại Giam Hạnh Phúc | 23/11 18:30 | Phòng 1 | G8
(2268, 10, 120, '2026-11-23T14:50:00', 216000, N'Paid', N'Cash', 300000, 15, 0, NULL, NULL, NULL), -- suat 413 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 24/11 18:00 | Phòng 4 | G1 G2
(2269, 3, 77, '2026-11-23T14:51:44', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 390 | Chị Chị Em Em 3 | 23/11 21:00 | Phòng 1 | E10
(2270, 3, NULL, '2026-11-23T14:57:03', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 389 | Trại Giam Hạnh Phúc | 23/11 20:30 | Phòng 3 | F4 F5 F6
(2271, 10, 51, '2026-11-23T14:59:15', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 386 | Godzilla Trừ Không | 23/11 18:15 | Phòng 5 | G7 G8
(2272, 4, NULL, '2026-11-23T15:01:40', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 385 | Ngày Con Còn Mẹ | 23/11 18:15 | Phòng 3 | B11 B12
(2273, 5, NULL, '2026-11-23T15:08:43', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 387 | Trại Giam Hạnh Phúc | 23/11 18:30 | Phòng 1 | F8 F9
(2274, 4, NULL, '2026-11-23T15:25:03', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 387 | Trại Giam Hạnh Phúc | 23/11 18:30 | Phòng 1 | G5 G6 G7
(2275, 5, NULL, '2026-11-23T15:32:47', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 381 | Clayface | 23/11 16:00 | Phòng 3 | D5 D6
(2276, 5, 80, '2026-11-23T15:35:41', 250000, N'Paid', N'Cash', 250000, 17, 20, NULL, NULL, NULL), -- suat 388 | Ba Cây Số Từ Nơi Tận Cùng Thế Giới (EUFF) | 23/11 19:00 | Phòng 2 | H10 H11 H12
(2277, 5, NULL, '2026-11-23T15:38:23', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 386 | Godzilla Trừ Không | 23/11 18:15 | Phòng 5 | J4
(2278, 4, NULL, '2026-11-23T15:38:54', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 393 | Trại Buôn Người | 23/11 21:15 | Phòng 2 | D5 D6
(2279, 4, NULL, '2026-11-23T15:46:53', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 389 | Trại Giam Hạnh Phúc | 23/11 20:30 | Phòng 3 | G8 G9 G10 G11
(2280, 4, 93, '2026-11-23T15:52:28', 432000, N'Paid', N'Transfer', NULL, 30, 0, NULL, NULL, NULL), -- suat 384 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 23/11 18:00 | Phòng 4 | H2 H3 H4 H5
(2281, 5, 116, '2026-11-23T15:53:34', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 385 | Ngày Con Còn Mẹ | 23/11 18:15 | Phòng 3 | J3 J4
(2282, 4, NULL, '2026-11-23T16:09:28', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 386 | Godzilla Trừ Không | 23/11 18:15 | Phòng 5 | L11 L12
(2283, 5, 77, '2026-11-23T16:09:49', 432000, N'Paid', N'Cash', 500000, 30, 0, NULL, NULL, NULL), -- suat 437 | Dune: Hành Tinh Cát - Phần Hai | 25/11 15:00 | Phòng 5 | F5 F6 F7
(2284, 4, 107, '2026-11-23T16:20:05', 48000, N'Paid', N'Transfer', NULL, 2, 27, NULL, NULL, NULL), -- suat 389 | Trại Giam Hạnh Phúc | 23/11 20:30 | Phòng 3 | A12
(2285, 4, 27, '2026-11-23T16:20:08', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 388 | Ba Cây Số Từ Nơi Tận Cùng Thế Giới (EUFF) | 23/11 19:00 | Phòng 2 | E5
(2286, 5, NULL, '2026-11-23T16:20:53', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 413 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 24/11 18:00 | Phòng 4 | F11
(2287, 4, NULL, '2026-11-23T16:22:02', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 413 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 24/11 18:00 | Phòng 4 | G6 G7
(2288, 5, 113, '2026-11-23T16:22:20', 81000, N'Paid', N'Cash', 100000, 5, 99, NULL, NULL, NULL), -- suat 388 | Ba Cây Số Từ Nơi Tận Cùng Thế Giới (EUFF) | 23/11 19:00 | Phòng 2 | F6 F7
(2289, 4, NULL, '2026-11-23T16:23:23', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 386 | Godzilla Trừ Không | 23/11 18:15 | Phòng 5 | G11 G12
(2290, 5, 49, '2026-11-23T16:26:00', 432000, N'Paid', N'Cash', 500000, 30, 0, NULL, NULL, NULL), -- suat 384 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 23/11 18:00 | Phòng 4 | D5 D6 D7 D8
(2291, 5, NULL, '2026-11-23T16:26:38', 108000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 384 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 23/11 18:00 | Phòng 4 | F8
(2292, 5, 83, '2026-11-23T16:26:40', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 390 | Chị Chị Em Em 3 | 23/11 21:00 | Phòng 1 | G8
(2293, 4, NULL, '2026-11-23T16:35:40', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 384 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 23/11 18:00 | Phòng 4 | C11
(2294, 4, NULL, '2026-11-23T16:37:35', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 393 | Trại Buôn Người | 23/11 21:15 | Phòng 2 | F2 F3
(2295, 4, 92, '2026-11-23T16:37:38', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 443 | Ngày Con Còn Mẹ | 25/11 18:15 | Phòng 3 | C9 C10
(2296, 4, NULL, '2026-11-23T16:41:28', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 385 | Ngày Con Còn Mẹ | 23/11 18:15 | Phòng 3 | E6 E7
(2297, 5, NULL, '2026-11-23T16:57:52', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 390 | Chị Chị Em Em 3 | 23/11 21:00 | Phòng 1 | G4 G5 G6
(2298, 5, NULL, '2026-11-23T16:58:29', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 393 | Trại Buôn Người | 23/11 21:15 | Phòng 2 | E7 E8
(2299, 5, NULL, '2026-11-23T17:01:55', 75000, N'Paid', N'Cash', 80000, 0, 0, NULL, NULL, NULL), -- suat 387 | Trại Giam Hạnh Phúc | 23/11 18:30 | Phòng 1 | A7
(2300, 5, NULL, '2026-11-23T17:05:42', 375000, N'Paid', N'Cash', 375000, 0, 0, NULL, NULL, NULL), -- suat 393 | Trại Buôn Người | 23/11 21:15 | Phòng 2 | C5 C6 C7 C8 C9
(2301, 5, NULL, '2026-11-23T17:06:53', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 389 | Trại Giam Hạnh Phúc | 23/11 20:30 | Phòng 3 | G2 G3
(2302, 4, NULL, '2026-11-23T17:16:29', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 384 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 23/11 18:00 | Phòng 4 | J5 J6
(2303, 4, 61, '2026-11-23T17:17:17', 180000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 387 | Trại Giam Hạnh Phúc | 23/11 18:30 | Phòng 1 | J11 J12
(2304, 5, NULL, '2026-11-23T17:20:06', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 393 | Trại Buôn Người | 23/11 21:15 | Phòng 2 | G3 G4
(2305, 4, NULL, '2026-11-23T17:21:51', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 387 | Trại Giam Hạnh Phúc | 23/11 18:30 | Phòng 1 | F4 F5
(2306, 5, NULL, '2026-11-23T17:25:35', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 413 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 24/11 18:00 | Phòng 4 | E4 E5
(2307, 5, 67, '2026-11-23T17:29:09', 150000, N'Paid', N'Cash', 200000, 7, 0, NULL, NULL, NULL), -- suat 446 | Mẹ Mìn: Giao Kèo Với Quỷ | 25/11 19:00 | Phòng 2 | C5 C6
(2308, 4, NULL, '2026-11-23T17:31:23', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 436 | Ngày Con Còn Mẹ | 25/11 14:30 | Phòng 2 | J7 J8
(2309, 5, NULL, '2026-11-23T17:36:16', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 407 | Ngày Con Còn Mẹ | 24/11 14:30 | Phòng 2 | D9 D10
(2310, 5, NULL, '2026-11-23T17:41:03', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 390 | Chị Chị Em Em 3 | 23/11 21:00 | Phòng 1 | H1 H2 H3 H4
(2311, 4, NULL, '2026-11-23T17:54:08', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 414 | Ngày Con Còn Mẹ | 24/11 18:15 | Phòng 3 | D6 D7 D8 D9
(2312, 5, NULL, '2026-11-23T17:56:01', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 403 | Godzilla Trừ Không | 24/11 12:15 | Phòng 5 | E9
(2313, 5, NULL, '2026-11-23T18:15:22', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 405 | Trại Giam Hạnh Phúc | 24/11 13:45 | Phòng 1 | D12
(2314, 5, NULL, '2026-11-23T18:44:41', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 421 | Dune: Hành Tinh Cát - Phần Hai | 24/11 21:00 | Phòng 5 | F9 F10
(2315, 5, 66, '2026-11-23T18:45:21', 160000, N'Paid', N'Transfer', NULL, 11, 20, NULL, NULL, NULL), -- suat 391 | Bí Kíp Luyện Cướp | 23/11 21:00 | Phòng 4 | G4 G5
(2316, 5, 46, '2026-11-23T18:55:12', 240000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 408 | Dune: Hành Tinh Cát - Phần Hai | 24/11 15:00 | Phòng 5 | C4 C5
(2317, 4, 93, '2026-11-23T19:00:18', 144000, N'Paid', N'Cash', 144000, 10, 0, NULL, NULL, NULL), -- suat 421 | Dune: Hành Tinh Cát - Phần Hai | 24/11 21:00 | Phòng 5 | E1
(2318, 4, NULL, '2026-11-23T19:02:11', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 389 | Trại Giam Hạnh Phúc | 23/11 20:30 | Phòng 3 | D4 D5 D6
(2319, 4, 67, '2026-11-23T19:07:58', 180000, N'Paid', N'Card', NULL, 9, 0, NULL, NULL, NULL), -- suat 404 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 24/11 12:30 | Phòng 4 | B1 B2
(2320, 5, NULL, '2026-11-23T19:54:49', 75000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 402 | Chàng Mèo Mang Mũ | 24/11 12:15 | Phòng 2 | C7
(2321, 4, NULL, '2026-11-23T20:09:53', 576000, N'Paid', N'Cash', 576000, 0, 0, NULL, NULL, NULL), -- suat 392 | Dune: Hành Tinh Cát - Phần Hai | 23/11 21:00 | Phòng 5 | H5 H6 H7 H8
(2322, 5, 16, '2026-11-23T20:51:08', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 446 | Mẹ Mìn: Giao Kèo Với Quỷ | 25/11 19:00 | Phòng 2 | J5 J6
(2323, 5, NULL, '2026-11-23T20:51:36', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 430 | Kẻ Hồi Sinh | 25/11 12:00 | Phòng 3 | H5 H6 H7
(2324, 5, 69, '2026-11-23T21:24:25', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 407 | Ngày Con Còn Mẹ | 24/11 14:30 | Phòng 2 | H1 H2
(2325, 4, NULL, '2026-11-23T21:25:08', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 420 | Bí Kíp Luyện Cướp | 24/11 21:00 | Phòng 4 | E9
(2326, 5, NULL, '2026-11-23T21:29:11', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL); -- suat 420 | Bí Kíp Luyện Cướp | 24/11 21:00 | Phòng 4 | D7
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(5020, 2189, 399, 2, 213, 90000, N'Active'),
(5021, 2189, 399, 2, 214, 90000, N'Active'),
(5022, 2190, 422, 2, 187, 90000, N'Active'),
(5023, 2190, 422, 2, 188, 90000, N'Active'),
(5024, 2190, 422, 2, 189, 90000, N'Active'),
(5025, 2190, 422, 2, 190, 90000, N'Active'),
(5026, 2191, 367, 5, 505, 144000, N'Active'),
(5027, 2191, 367, 5, 506, 144000, N'Active'),
(5028, 2191, 367, 5, 507, 144000, N'Active'),
(5029, 2191, 367, 5, 508, 144000, N'Active'),
(5030, 2192, 376, 1, 42, 90000, N'Active'),
(5031, 2193, 365, 1, 17, 75000, N'Active'),
(5032, 2193, 365, 1, 18, 75000, N'Active'),
(5033, 2194, 431, 2, 138, 75000, N'Active'),
(5034, 2194, 431, 2, 139, 75000, N'Active'),
(5035, 2195, 367, 5, 486, 144000, N'Active'),
(5036, 2195, 367, 5, 487, 144000, N'Active'),
(5037, 2195, 367, 5, 488, 144000, N'Active'),
(5038, 2196, 376, 1, 7, 75000, N'Active'),
(5039, 2197, 365, 1, 56, 90000, N'Active'),
(5040, 2197, 365, 1, 57, 90000, N'Active'),
(5041, 2198, 367, 5, 476, 120000, N'Active'),
(5042, 2198, 367, 5, 477, 120000, N'Active'),
(5043, 2199, 368, 4, 410, 108000, N'Active'),
(5044, 2199, 368, 4, 411, 108000, N'Active'),
(5045, 2200, 370, 2, 186, 90000, N'Active'),
(5046, 2200, 370, 2, 187, 90000, N'Active'),
(5047, 2201, 367, 5, 545, 144000, N'Active'),
(5048, 2202, 414, 3, 319, 90000, N'Active'),
(5049, 2202, 414, 3, 320, 90000, N'Active'),
(5050, 2203, 371, 1, 105, 90000, N'Active'),
(5051, 2203, 371, 1, 106, 90000, N'Active'),
(5052, 2204, 427, 3, 258, 90000, N'Active'),
(5053, 2204, 427, 3, 259, 90000, N'Active'),
(5054, 2204, 427, 3, 260, 90000, N'Active'),
(5055, 2204, 427, 3, 261, 90000, N'Active'),
(5056, 2204, 427, 3, 262, 90000, N'Active'),
(5057, 2205, 378, 2, 215, 90000, N'Active'),
(5058, 2205, 378, 2, 216, 90000, N'Active'),
(5059, 2206, 371, 1, 81, 90000, N'Active'),
(5060, 2206, 371, 1, 82, 90000, N'Active'),
(5061, 2206, 371, 1, 83, 90000, N'Active'),
(5062, 2206, 371, 1, 84, 90000, N'Active'),
(5063, 2207, 379, 5, 451, 120000, N'Active'),
(5064, 2208, 377, 3, 317, 90000, N'Active'),
(5065, 2208, 377, 3, 318, 90000, N'Active'),
(5066, 2209, 372, 3, 302, 90000, N'Active'),
(5067, 2209, 372, 3, 303, 90000, N'Active'),
(5068, 2209, 372, 3, 304, 90000, N'Active'),
(5069, 2210, 376, 1, 52, 90000, N'Active'),
(5070, 2210, 376, 1, 53, 90000, N'Active'),
(5071, 2210, 376, 1, 54, 90000, N'Active'),
(5072, 2210, 376, 1, 55, 90000, N'Active'),
(5073, 2211, 379, 5, 472, 120000, N'Active'),
(5074, 2211, 379, 5, 473, 120000, N'Active'),
(5075, 2212, 411, 1, 95, 90000, N'Active'),
(5076, 2212, 411, 1, 96, 90000, N'Active'),
(5077, 2213, 370, 2, 126, 75000, N'Active'),
(5078, 2214, 374, 5, 553, 144000, N'Active'),
(5079, 2214, 374, 5, 554, 144000, N'Active'),
(5080, 2215, 377, 3, 237, 75000, N'Active'),
(5081, 2215, 377, 3, 238, 75000, N'Active'),
(5082, 2216, 400, 1, 52, 90000, N'Active'),
(5083, 2216, 400, 1, 53, 90000, N'Active'),
(5084, 2216, 400, 1, 54, 90000, N'Active'),
(5085, 2216, 400, 1, 55, 90000, N'Active'),
(5086, 2217, 372, 3, 297, 90000, N'Active'),
(5087, 2217, 372, 3, 298, 90000, N'Active'),
(5088, 2217, 372, 3, 299, 90000, N'Active'),
(5089, 2218, 424, 2, 145, 90000, N'Active'),
(5090, 2218, 424, 2, 146, 90000, N'Active'),
(5091, 2219, 375, 4, 398, 108000, N'Active'),
(5092, 2219, 375, 4, 399, 108000, N'Active'),
(5093, 2220, 374, 5, 470, 120000, N'Active'),
(5094, 2220, 374, 5, 471, 120000, N'Active'),
(5095, 2221, 375, 4, 368, 108000, N'Active'),
(5096, 2221, 375, 4, 369, 108000, N'Active'),
(5097, 2221, 375, 4, 370, 108000, N'Active'),
(5098, 2222, 422, 2, 196, 90000, N'Active'),
(5099, 2222, 422, 2, 197, 90000, N'Active'),
(5100, 2222, 422, 2, 198, 90000, N'Active'),
(5101, 2222, 422, 2, 199, 90000, N'Active'),
(5102, 2223, 375, 4, 382, 108000, N'Active'),
(5103, 2223, 375, 4, 383, 108000, N'Active'),
(5104, 2224, 373, 2, 138, 75000, N'Active'),
(5105, 2224, 373, 2, 139, 75000, N'Active'),
(5106, 2224, 373, 2, 140, 75000, N'Active'),
(5107, 2225, 409, 4, 387, 108000, N'Active'),
(5108, 2225, 409, 4, 388, 108000, N'Active'),
(5109, 2225, 409, 4, 389, 108000, N'Active'),
(5110, 2225, 409, 4, 390, 108000, N'Active'),
(5111, 2225, 409, 4, 391, 108000, N'Active'),
(5112, 2226, 375, 4, 395, 108000, N'Active'),
(5113, 2226, 375, 4, 396, 108000, N'Active'),
(5114, 2227, 375, 4, 361, 108000, N'Active'),
(5115, 2227, 375, 4, 362, 108000, N'Active'),
(5116, 2228, 374, 5, 559, 144000, N'Active'),
(5117, 2228, 374, 5, 560, 144000, N'Active'),
(5118, 2229, 374, 5, 486, 144000, N'Active'),
(5119, 2229, 374, 5, 487, 144000, N'Active'),
(5120, 2230, 372, 3, 286, 90000, N'Active'),
(5121, 2231, 375, 4, 403, 108000, N'Active'),
(5122, 2231, 375, 4, 404, 108000, N'Active'),
(5123, 2232, 384, 4, 341, 90000, N'Active'),
(5124, 2232, 384, 4, 342, 90000, N'Active'),
(5125, 2233, 373, 2, 197, 90000, N'Active'),
(5126, 2234, 373, 2, 182, 90000, N'Active'),
(5127, 2234, 373, 2, 183, 90000, N'Active'),
(5128, 2235, 382, 1, 38, 90000, N'Active'),
(5129, 2236, 385, 3, 219, 75000, N'Active'),
(5130, 2237, 438, 4, 391, 108000, N'Active'),
(5131, 2237, 438, 4, 392, 108000, N'Active'),
(5132, 2238, 413, 4, 341, 90000, N'Active'),
(5133, 2238, 413, 4, 342, 90000, N'Active'),
(5134, 2239, 387, 1, 53, 90000, N'Active'),
(5135, 2239, 387, 1, 54, 90000, N'Active'),
(5136, 2240, 387, 1, 56, 90000, N'Active'),
(5137, 2240, 387, 1, 57, 90000, N'Active'),
(5138, 2241, 434, 1, 91, 90000, N'Active'),
(5139, 2241, 434, 1, 92, 90000, N'Active'),
(5140, 2242, 403, 5, 461, 120000, N'Active'),
(5141, 2242, 403, 5, 462, 120000, N'Active'),
(5142, 2242, 403, 5, 463, 120000, N'Active'),
(5143, 2243, 379, 5, 485, 144000, N'Active'),
(5144, 2243, 379, 5, 486, 144000, N'Active'),
(5145, 2243, 379, 5, 487, 144000, N'Active'),
(5146, 2243, 379, 5, 488, 144000, N'Active'),
(5147, 2244, 381, 3, 280, 90000, N'Active'),
(5148, 2244, 381, 3, 281, 90000, N'Active'),
(5149, 2245, 380, 4, 353, 90000, N'Active'),
(5150, 2245, 380, 4, 354, 90000, N'Active'),
(5151, 2246, 435, 3, 301, 90000, N'Active'),
(5152, 2246, 435, 3, 302, 90000, N'Active'),
(5153, 2246, 435, 3, 303, 90000, N'Active'),
(5154, 2247, 405, 1, 69, 90000, N'Cancelled'),
(5155, 2247, 405, 1, 70, 90000, N'Cancelled'),
(5156, 2248, 380, 4, 378, 108000, N'Active'),
(5157, 2248, 380, 4, 379, 108000, N'Active'),
(5158, 2248, 380, 4, 380, 108000, N'Active'),
(5159, 2249, 378, 2, 188, 90000, N'Active'),
(5160, 2249, 378, 2, 189, 90000, N'Active'),
(5161, 2250, 378, 2, 201, 90000, N'Active'),
(5162, 2250, 378, 2, 202, 90000, N'Active'),
(5163, 2250, 378, 2, 203, 90000, N'Active'),
(5164, 2250, 378, 2, 204, 90000, N'Active'),
(5165, 2251, 384, 4, 370, 108000, N'Active'),
(5166, 2252, 416, 1, 78, 90000, N'Active'),
(5167, 2252, 416, 1, 79, 90000, N'Active'),
(5168, 2253, 392, 5, 515, 144000, N'Active'),
(5169, 2254, 380, 4, 413, 108000, N'Active'),
(5170, 2255, 377, 3, 266, 90000, N'Active'),
(5171, 2255, 377, 3, 267, 90000, N'Active'),
(5172, 2255, 377, 3, 268, 90000, N'Active'),
(5173, 2255, 377, 3, 269, 90000, N'Active'),
(5174, 2255, 377, 3, 270, 90000, N'Active'),
(5175, 2256, 383, 2, 133, 75000, N'Active'),
(5176, 2256, 383, 2, 134, 75000, N'Active'),
(5177, 2257, 380, 4, 417, 108000, N'Active'),
(5178, 2257, 380, 4, 418, 108000, N'Active'),
(5179, 2258, 386, 5, 546, 144000, N'Active'),
(5180, 2258, 386, 5, 547, 144000, N'Active'),
(5181, 2259, 383, 2, 173, 90000, N'Active'),
(5182, 2259, 383, 2, 174, 90000, N'Active'),
(5183, 2259, 383, 2, 175, 90000, N'Active'),
(5184, 2259, 383, 2, 176, 90000, N'Active'),
(5185, 2260, 388, 2, 154, 90000, N'Active'),
(5186, 2260, 388, 2, 155, 90000, N'Active'),
(5187, 2261, 382, 1, 22, 75000, N'Active'),
(5188, 2261, 382, 1, 23, 75000, N'Active'),
(5189, 2262, 380, 4, 341, 90000, N'Active'),
(5190, 2262, 380, 4, 342, 90000, N'Active'),
(5191, 2263, 386, 5, 561, 144000, N'Active'),
(5192, 2263, 386, 5, 562, 144000, N'Active'),
(5193, 2264, 388, 2, 215, 90000, N'Active'),
(5194, 2264, 388, 2, 216, 90000, N'Active'),
(5195, 2265, 384, 4, 401, 108000, N'Active'),
(5196, 2265, 384, 4, 402, 108000, N'Active'),
(5197, 2266, 384, 4, 378, 108000, N'Active'),
(5198, 2266, 384, 4, 379, 108000, N'Active'),
(5199, 2267, 387, 1, 80, 90000, N'Active'),
(5200, 2268, 413, 4, 397, 108000, N'Active'),
(5201, 2268, 413, 4, 398, 108000, N'Active'),
(5202, 2269, 390, 1, 58, 90000, N'Active'),
(5203, 2270, 389, 3, 280, 90000, N'Active'),
(5204, 2270, 389, 3, 281, 90000, N'Active'),
(5205, 2270, 389, 3, 282, 90000, N'Active'),
(5206, 2271, 386, 5, 511, 144000, N'Active'),
(5207, 2271, 386, 5, 512, 144000, N'Active'),
(5208, 2272, 385, 3, 239, 75000, N'Active'),
(5209, 2272, 385, 3, 240, 75000, N'Active'),
(5210, 2273, 387, 1, 68, 90000, N'Active'),
(5211, 2273, 387, 1, 69, 90000, N'Active'),
(5212, 2274, 387, 1, 77, 90000, N'Active'),
(5213, 2274, 387, 1, 78, 90000, N'Active'),
(5214, 2274, 387, 1, 79, 90000, N'Active'),
(5215, 2275, 381, 3, 257, 90000, N'Active'),
(5216, 2275, 381, 3, 258, 90000, N'Active'),
(5217, 2276, 388, 2, 202, 90000, N'Active'),
(5218, 2276, 388, 2, 203, 90000, N'Active'),
(5219, 2276, 388, 2, 204, 90000, N'Active'),
(5220, 2277, 386, 5, 532, 144000, N'Active'),
(5221, 2278, 393, 2, 149, 90000, N'Active'),
(5222, 2278, 393, 2, 150, 90000, N'Active'),
(5223, 2279, 389, 3, 296, 90000, N'Active'),
(5224, 2279, 389, 3, 297, 90000, N'Active'),
(5225, 2279, 389, 3, 298, 90000, N'Active'),
(5226, 2279, 389, 3, 299, 90000, N'Active'),
(5227, 2280, 384, 4, 410, 108000, N'Active'),
(5228, 2280, 384, 4, 411, 108000, N'Active'),
(5229, 2280, 384, 4, 412, 108000, N'Active'),
(5230, 2280, 384, 4, 413, 108000, N'Active'),
(5231, 2281, 385, 3, 315, 90000, N'Active'),
(5232, 2281, 385, 3, 316, 90000, N'Active'),
(5233, 2282, 386, 5, 563, 144000, N'Active'),
(5234, 2282, 386, 5, 564, 144000, N'Active'),
(5235, 2283, 437, 5, 497, 144000, N'Active'),
(5236, 2283, 437, 5, 498, 144000, N'Active'),
(5237, 2283, 437, 5, 499, 144000, N'Active'),
(5238, 2284, 389, 3, 228, 75000, N'Active'),
(5239, 2285, 388, 2, 161, 90000, N'Active'),
(5240, 2286, 413, 4, 395, 108000, N'Active'),
(5241, 2287, 413, 4, 402, 108000, N'Active'),
(5242, 2287, 413, 4, 403, 108000, N'Active'),
(5243, 2288, 388, 2, 174, 90000, N'Active'),
(5244, 2288, 388, 2, 175, 90000, N'Active'),
(5245, 2289, 386, 5, 515, 144000, N'Active'),
(5246, 2289, 386, 5, 516, 144000, N'Active'),
(5247, 2290, 384, 4, 365, 108000, N'Active'),
(5248, 2290, 384, 4, 366, 108000, N'Active'),
(5249, 2290, 384, 4, 367, 108000, N'Active'),
(5250, 2290, 384, 4, 368, 108000, N'Active'),
(5251, 2291, 384, 4, 392, 108000, N'Active'),
(5252, 2292, 390, 1, 80, 90000, N'Active'),
(5253, 2293, 384, 4, 359, 90000, N'Active'),
(5254, 2294, 393, 2, 170, 90000, N'Active'),
(5255, 2294, 393, 2, 171, 90000, N'Active'),
(5256, 2295, 443, 3, 249, 75000, N'Active'),
(5257, 2295, 443, 3, 250, 75000, N'Active'),
(5258, 2296, 385, 3, 270, 90000, N'Active'),
(5259, 2296, 385, 3, 271, 90000, N'Active'),
(5260, 2297, 390, 1, 76, 90000, N'Active'),
(5261, 2297, 390, 1, 77, 90000, N'Active'),
(5262, 2297, 390, 1, 78, 90000, N'Active'),
(5263, 2298, 393, 2, 163, 90000, N'Active'),
(5264, 2298, 393, 2, 164, 90000, N'Active'),
(5265, 2299, 387, 1, 7, 75000, N'Active'),
(5266, 2300, 393, 2, 137, 75000, N'Active'),
(5267, 2300, 393, 2, 138, 75000, N'Active'),
(5268, 2300, 393, 2, 139, 75000, N'Active'),
(5269, 2300, 393, 2, 140, 75000, N'Active'),
(5270, 2300, 393, 2, 141, 75000, N'Active'),
(5271, 2301, 389, 3, 290, 90000, N'Active'),
(5272, 2301, 389, 3, 291, 90000, N'Active'),
(5273, 2302, 384, 4, 425, 108000, N'Active'),
(5274, 2302, 384, 4, 426, 108000, N'Active'),
(5275, 2303, 387, 1, 107, 90000, N'Active'),
(5276, 2303, 387, 1, 108, 90000, N'Active'),
(5277, 2304, 393, 2, 183, 90000, N'Active'),
(5278, 2304, 393, 2, 184, 90000, N'Active'),
(5279, 2305, 387, 1, 64, 90000, N'Active'),
(5280, 2305, 387, 1, 65, 90000, N'Active'),
(5281, 2306, 413, 4, 376, 108000, N'Active'),
(5282, 2306, 413, 4, 377, 108000, N'Active'),
(5283, 2307, 446, 2, 137, 75000, N'Active'),
(5284, 2307, 446, 2, 138, 75000, N'Active'),
(5285, 2308, 436, 2, 211, 90000, N'Active'),
(5286, 2308, 436, 2, 212, 90000, N'Active'),
(5287, 2309, 407, 2, 153, 90000, N'Active'),
(5288, 2309, 407, 2, 154, 90000, N'Active'),
(5289, 2310, 390, 1, 85, 90000, N'Active'),
(5290, 2310, 390, 1, 86, 90000, N'Active'),
(5291, 2310, 390, 1, 87, 90000, N'Active'),
(5292, 2310, 390, 1, 88, 90000, N'Active'),
(5293, 2311, 414, 3, 258, 90000, N'Active'),
(5294, 2311, 414, 3, 259, 90000, N'Active'),
(5295, 2311, 414, 3, 260, 90000, N'Active'),
(5296, 2311, 414, 3, 261, 90000, N'Active'),
(5297, 2312, 403, 5, 489, 144000, N'Active'),
(5298, 2313, 405, 1, 48, 90000, N'Active'),
(5299, 2314, 421, 5, 501, 144000, N'Active'),
(5300, 2314, 421, 5, 502, 144000, N'Active'),
(5301, 2315, 391, 4, 400, 90000, N'Active'),
(5302, 2315, 391, 4, 401, 90000, N'Active'),
(5303, 2316, 408, 5, 460, 120000, N'Active'),
(5304, 2316, 408, 5, 461, 120000, N'Active'),
(5305, 2317, 421, 5, 481, 144000, N'Active'),
(5306, 2318, 389, 3, 256, 90000, N'Active'),
(5307, 2318, 389, 3, 257, 90000, N'Active'),
(5308, 2318, 389, 3, 258, 90000, N'Active'),
(5309, 2319, 404, 4, 337, 90000, N'Active'),
(5310, 2319, 404, 4, 338, 90000, N'Active'),
(5311, 2320, 402, 2, 139, 75000, N'Active'),
(5312, 2321, 392, 5, 521, 144000, N'Active'),
(5313, 2321, 392, 5, 522, 144000, N'Active'),
(5314, 2321, 392, 5, 523, 144000, N'Active'),
(5315, 2321, 392, 5, 524, 144000, N'Active'),
(5316, 2322, 446, 2, 209, 90000, N'Active'),
(5317, 2322, 446, 2, 210, 90000, N'Active'),
(5318, 2323, 430, 3, 305, 90000, N'Active'),
(5319, 2323, 430, 3, 306, 90000, N'Active'),
(5320, 2323, 430, 3, 307, 90000, N'Active'),
(5321, 2324, 407, 2, 193, 90000, N'Active'),
(5322, 2324, 407, 2, 194, 90000, N'Active'),
(5323, 2325, 420, 4, 381, 90000, N'Active'),
(5324, 2326, 420, 4, 367, 90000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 3 24/11/2026: 110 hoa don (6 huy), 261 ve, doanh thu 24.992.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(2327, 6, NULL, '2026-11-24T08:11:27', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 445 | Trại Giam Hạnh Phúc | 25/11 18:30 | Phòng 1 | J11 J12
(2328, 5, NULL, '2026-11-24T08:22:09', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 395 | Ma Mút Con Vượt Kỷ Băng Hà | 24/11 09:00 | Phòng 2 | J1 J2
(2329, 6, NULL, '2026-11-24T08:23:09', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 394 | Trại Giam Hạnh Phúc | 24/11 09:00 | Phòng 1 | H5 H6
(2330, 5, NULL, '2026-11-24T08:27:21', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 476 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 20:30 | Phòng 3 | J9 J10
(2331, 5, NULL, '2026-11-24T08:28:55', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 394 | Trại Giam Hạnh Phúc | 24/11 09:00 | Phòng 1 | B9 B10
(2332, 6, 108, '2026-11-24T08:30:24', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 397 | Ramayana: Khởi Nguồn Một Huyền Thoại | 24/11 09:15 | Phòng 4 | E2 E3
(2333, 6, NULL, '2026-11-24T08:32:00', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 396 | Dune: Hành Tinh Cát | 24/11 09:00 | Phòng 5 | H6 H7
(2334, 5, NULL, '2026-11-24T08:32:14', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 398 | Bí Kíp Luyện Cướp | 24/11 09:30 | Phòng 3 | G3 G4
(2335, 5, NULL, '2026-11-24T08:34:36', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 394 | Trại Giam Hạnh Phúc | 24/11 09:00 | Phòng 1 | F9
(2336, 5, 53, '2026-11-24T08:37:07', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 396 | Dune: Hành Tinh Cát | 24/11 09:00 | Phòng 5 | G9 G10
(2337, 6, NULL, '2026-11-24T08:45:26', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 395 | Ma Mút Con Vượt Kỷ Băng Hà | 24/11 09:00 | Phòng 2 | G8 G9
(2338, 6, NULL, '2026-11-24T08:53:26', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 394 | Trại Giam Hạnh Phúc | 24/11 09:00 | Phòng 1 | G5 G6
(2339, 5, 42, '2026-11-24T08:53:57', 100000, N'Paid', N'Cash', 100000, 5, 140, NULL, NULL, NULL), -- suat 403 | Godzilla Trừ Không | 24/11 12:15 | Phòng 5 | D1 D2
(2340, 6, 79, '2026-11-24T09:44:14', 160000, N'Cancelled', N'Cash', 160000, 11, 20, N'Khách đổi ý', '2026-11-24T10:07:35', 6), -- suat 400 | Ngày Con Còn Mẹ | 24/11 11:30 | Phòng 1 | G5 G6
(2341, 6, 92, '2026-11-24T09:44:32', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 413 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 24/11 18:00 | Phòng 4 | E1 E2
(2342, 6, 70, '2026-11-24T09:50:37', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 409 | Godzilla Trừ Không | 24/11 15:30 | Phòng 4 | F9 F10
(2343, 5, NULL, '2026-11-24T09:52:23', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 400 | Ngày Con Còn Mẹ | 24/11 11:30 | Phòng 1 | J5 J6
(2344, 6, 113, '2026-11-24T09:54:22', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 407 | Ngày Con Còn Mẹ | 24/11 14:30 | Phòng 2 | F11 F12
(2345, 5, NULL, '2026-11-24T10:04:01', 576000, N'Paid', N'Cash', 576000, 0, 0, NULL, NULL, NULL), -- suat 408 | Dune: Hành Tinh Cát - Phần Hai | 24/11 15:00 | Phòng 5 | H7 H8 H9 H10
(2346, 5, NULL, '2026-11-24T10:15:32', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 409 | Godzilla Trừ Không | 24/11 15:30 | Phòng 4 | H4 H5
(2347, 5, 25, '2026-11-24T10:17:44', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 452 | Trại Giam Hạnh Phúc | 26/11 09:00 | Phòng 1 | B10 B11
(2348, 6, 103, '2026-11-24T10:24:07', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 405 | Trại Giam Hạnh Phúc | 24/11 13:45 | Phòng 1 | E5 E6
(2349, 6, NULL, '2026-11-24T10:25:34', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 403 | Godzilla Trừ Không | 24/11 12:15 | Phòng 5 | K7 K8 K9
(2350, 5, NULL, '2026-11-24T10:40:05', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 403 | Godzilla Trừ Không | 24/11 12:15 | Phòng 5 | F8 F9
(2351, 6, NULL, '2026-11-24T10:47:26', 324000, N'Paid', N'Cash', 324000, 0, 0, NULL, NULL, NULL), -- suat 404 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 24/11 12:30 | Phòng 4 | F6 F7 F8
(2352, 6, NULL, '2026-11-24T11:05:37', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 402 | Chàng Mèo Mang Mũ | 24/11 12:15 | Phòng 2 | E11
(2353, 6, NULL, '2026-11-24T11:09:55', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 407 | Ngày Con Còn Mẹ | 24/11 14:30 | Phòng 2 | D4 D5
(2354, 6, 1, '2026-11-24T11:12:05', 360000, N'Paid', N'Cash', 360000, 25, 0, NULL, NULL, NULL), -- suat 457 | Kiến Lé Phiêu Lưu Ké | 26/11 10:30 | Phòng 2 | E4 E5 E6 E7
(2355, 6, NULL, '2026-11-24T11:13:32', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 405 | Trại Giam Hạnh Phúc | 24/11 13:45 | Phòng 1 | F9 F10 F11 F12
(2356, 6, 21, '2026-11-24T11:17:36', 288000, N'Paid', N'Cash', 300000, 20, 0, NULL, NULL, NULL), -- suat 403 | Godzilla Trừ Không | 24/11 12:15 | Phòng 5 | J1 J2
(2357, 6, 73, '2026-11-24T11:20:15', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 414 | Ngày Con Còn Mẹ | 24/11 18:15 | Phòng 3 | F1 F2
(2358, 6, NULL, '2026-11-24T11:24:42', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 402 | Chàng Mèo Mang Mũ | 24/11 12:15 | Phòng 2 | A1 A2
(2359, 5, NULL, '2026-11-24T11:33:39', 108000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 467 | Godzilla Trừ Không | 26/11 15:30 | Phòng 4 | G9
(2360, 6, 93, '2026-11-24T11:34:16', 180000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 401 | Kẻ Hồi Sinh | 24/11 12:00 | Phòng 3 | J7 J8
(2361, 6, NULL, '2026-11-24T11:37:47', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 408 | Dune: Hành Tinh Cát - Phần Hai | 24/11 15:00 | Phòng 5 | G7 G8 G9
(2362, 5, NULL, '2026-11-24T11:40:05', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 401 | Kẻ Hồi Sinh | 24/11 12:00 | Phòng 3 | F4
(2363, 6, 55, '2026-11-24T11:41:26', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 469 | Bò Sữa Bay | 26/11 16:15 | Phòng 1 | D6 D7
(2364, 5, 1, '2026-11-24T11:42:19', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 449 | Bí Kíp Luyện Cướp | 25/11 21:00 | Phòng 4 | E7
(2365, 5, NULL, '2026-11-24T11:47:38', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 431 | Chàng Mèo Mang Mũ | 25/11 12:15 | Phòng 2 | G7 G8 G9
(2366, 6, NULL, '2026-11-24T11:53:43', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 416 | Trại Giam Hạnh Phúc | 24/11 18:30 | Phòng 1 | E11 E12
(2367, 5, NULL, '2026-11-24T11:53:44', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 409 | Godzilla Trừ Không | 24/11 15:30 | Phòng 4 | D11 D12
(2368, 5, 9, '2026-11-24T11:57:36', 216000, N'Paid', N'Cash', 250000, 15, 0, NULL, NULL, NULL), -- suat 433 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 25/11 12:30 | Phòng 4 | E8 E9
(2369, 5, NULL, '2026-11-24T12:06:41', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 411 | Bò Sữa Bay | 24/11 16:15 | Phòng 1 | F8 F9
(2370, 6, NULL, '2026-11-24T12:09:18', 270000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-24T12:51:50', 6), -- suat 412 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 24/11 16:45 | Phòng 2 | H8 H9 H10
(2371, 5, NULL, '2026-11-24T12:15:25', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 449 | Bí Kíp Luyện Cướp | 25/11 21:00 | Phòng 4 | F9 F10
(2372, 6, 93, '2026-11-24T12:16:02', 288000, N'Paid', N'Cash', 300000, 20, 0, NULL, NULL, NULL), -- suat 408 | Dune: Hành Tinh Cát - Phần Hai | 24/11 15:00 | Phòng 5 | J5 J6
(2373, 6, NULL, '2026-11-24T12:16:39', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 407 | Ngày Con Còn Mẹ | 24/11 14:30 | Phòng 2 | A6 A7
(2374, 5, NULL, '2026-11-24T12:17:16', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 410 | Clayface | 24/11 16:00 | Phòng 3 | E8 E9 E10 E11
(2375, 6, NULL, '2026-11-24T12:26:51', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 406 | Thiên Đường Tăm Tối | 24/11 14:00 | Phòng 3 | G3 G4 G5
(2376, 5, NULL, '2026-11-24T12:28:54', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 414 | Ngày Con Còn Mẹ | 24/11 18:15 | Phòng 3 | E3 E4 E5
(2377, 5, 87, '2026-11-24T12:35:54', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 405 | Trại Giam Hạnh Phúc | 24/11 13:45 | Phòng 1 | D6 D7 D8 D9
(2378, 6, 98, '2026-11-24T12:41:26', 270000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 420 | Bí Kíp Luyện Cướp | 24/11 21:00 | Phòng 4 | H5 H6 H7
(2379, 6, NULL, '2026-11-24T12:45:17', 375000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 406 | Thiên Đường Tăm Tối | 24/11 14:00 | Phòng 3 | C1 C2 C3 C4 C5
(2380, 6, NULL, '2026-11-24T12:56:42', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 406 | Thiên Đường Tăm Tối | 24/11 14:00 | Phòng 3 | G7 G8
(2381, 5, NULL, '2026-11-24T13:00:32', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 444 | Godzilla Trừ Không | 25/11 18:15 | Phòng 5 | E6 E7
(2382, 6, NULL, '2026-11-24T13:02:23', 144000, N'Paid', N'Cash', 144000, 0, 0, NULL, NULL, NULL), -- suat 450 | Dune: Hành Tinh Cát - Phần Hai | 25/11 21:00 | Phòng 5 | J12
(2383, 6, NULL, '2026-11-24T13:13:42', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 408 | Dune: Hành Tinh Cát - Phần Hai | 24/11 15:00 | Phòng 5 | F4 F5
(2384, 5, NULL, '2026-11-24T13:16:23', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 414 | Ngày Con Còn Mẹ | 24/11 18:15 | Phòng 3 | J1 J2
(2385, 6, NULL, '2026-11-24T13:27:59', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 410 | Clayface | 24/11 16:00 | Phòng 3 | D7 D8
(2386, 5, NULL, '2026-11-24T13:33:53', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-11-24T14:50:09', 1), -- suat 422 | Trại Buôn Người | 24/11 21:15 | Phòng 2 | G1 G2
(2387, 6, NULL, '2026-11-24T13:37:40', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 441 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 25/11 16:45 | Phòng 2 | B6 B7
(2388, 5, NULL, '2026-11-24T13:43:53', 480000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 408 | Dune: Hành Tinh Cát - Phần Hai | 24/11 15:00 | Phòng 5 | A4 A5 A6 A7
(2389, 5, NULL, '2026-11-24T13:46:40', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 434 | Trại Giam Hạnh Phúc | 25/11 13:45 | Phòng 1 | J3 J4
(2390, 5, NULL, '2026-11-24T13:46:53', 648000, N'Paid', N'Cash', 700000, 0, 0, NULL, NULL, NULL), -- suat 409 | Godzilla Trừ Không | 24/11 15:30 | Phòng 4 | E3 E4 E5 E6 E7 E8
(2391, 5, NULL, '2026-11-24T13:49:25', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 414 | Ngày Con Còn Mẹ | 24/11 18:15 | Phòng 3 | G4 G5
(2392, 6, 85, '2026-11-24T14:01:25', 150000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 416 | Trại Giam Hạnh Phúc | 24/11 18:30 | Phòng 1 | C9 C10
(2393, 6, NULL, '2026-11-24T14:08:41', 300000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 414 | Ngày Con Còn Mẹ | 24/11 18:15 | Phòng 3 | A4 A5 A6 A7
(2394, 5, NULL, '2026-11-24T14:14:57', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 440 | Bò Sữa Bay | 25/11 16:15 | Phòng 1 | F7
(2395, 6, NULL, '2026-11-24T14:26:47', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 472 | Ngày Con Còn Mẹ | 26/11 18:15 | Phòng 3 | E7 E8 E9 E10
(2396, 5, NULL, '2026-11-24T14:53:58', 324000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 413 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 24/11 18:00 | Phòng 4 | E8 E9 E10
(2397, 8, NULL, '2026-11-24T15:07:00', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 460 | Chàng Mèo Mang Mũ | 26/11 12:15 | Phòng 2 | C9 C10
(2398, 7, 77, '2026-11-24T15:10:49', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 414 | Ngày Con Còn Mẹ | 24/11 18:15 | Phòng 3 | E9
(2399, 7, NULL, '2026-11-24T15:12:58', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 445 | Trại Giam Hạnh Phúc | 25/11 18:30 | Phòng 1 | E2
(2400, 7, 54, '2026-11-24T15:16:18', 180000, N'Cancelled', N'Transfer', NULL, 12, 0, N'Nhầm suất / ghế', '2026-11-24T15:59:56', 7), -- suat 411 | Bò Sữa Bay | 24/11 16:15 | Phòng 1 | G4 G5
(2401, 7, NULL, '2026-11-24T15:24:50', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 414 | Ngày Con Còn Mẹ | 24/11 18:15 | Phòng 3 | G7 G8 G9 G10
(2402, 7, 25, '2026-11-24T15:29:52', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 416 | Trại Giam Hạnh Phúc | 24/11 18:30 | Phòng 1 | F4 F5
(2403, 8, 42, '2026-11-24T15:30:10', 300000, N'Paid', N'Cash', 500000, 15, 0, NULL, NULL, NULL), -- suat 417 | Amrum (EUFF) | 24/11 19:00 | Phòng 2 | C2 C3 C4 C5
(2404, 7, 60, '2026-11-24T15:30:53', 15000, N'Paid', N'Card', NULL, 0, 60, NULL, NULL, NULL), -- suat 410 | Clayface | 24/11 16:00 | Phòng 3 | A11
(2405, 8, NULL, '2026-11-24T15:32:06', 270000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 416 | Trại Giam Hạnh Phúc | 24/11 18:30 | Phòng 1 | F1 F2 F3
(2406, 8, NULL, '2026-11-24T15:39:56', 300000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 420 | Bí Kíp Luyện Cướp | 24/11 21:00 | Phòng 4 | A9 A10 A11 A12
(2407, 8, NULL, '2026-11-24T15:40:49', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 415 | Godzilla Trừ Không | 24/11 18:15 | Phòng 5 | F5 F6
(2408, 7, NULL, '2026-11-24T15:54:08', 720000, N'Paid', N'Cash', 720000, 0, 0, NULL, NULL, NULL), -- suat 421 | Dune: Hành Tinh Cát - Phần Hai | 24/11 21:00 | Phòng 5 | E5 E6 E7 E8 E9
(2409, 8, NULL, '2026-11-24T16:05:52', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 421 | Dune: Hành Tinh Cát - Phần Hai | 24/11 21:00 | Phòng 5 | F5 F6
(2410, 7, NULL, '2026-11-24T16:06:26', 576000, N'Paid', N'Cash', 600000, 0, 0, NULL, NULL, NULL), -- suat 421 | Dune: Hành Tinh Cát - Phần Hai | 24/11 21:00 | Phòng 5 | K2 K3 K4 K5
(2411, 7, NULL, '2026-11-24T16:07:57', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 414 | Ngày Con Còn Mẹ | 24/11 18:15 | Phòng 3 | H2 H3 H4 H5
(2412, 8, NULL, '2026-11-24T16:10:27', 75000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 414 | Ngày Con Còn Mẹ | 24/11 18:15 | Phòng 3 | B9
(2413, 7, NULL, '2026-11-24T16:12:15', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 420 | Bí Kíp Luyện Cướp | 24/11 21:00 | Phòng 4 | G7 G8
(2414, 8, NULL, '2026-11-24T16:21:01', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 416 | Trại Giam Hạnh Phúc | 24/11 18:30 | Phòng 1 | F11 F12
(2415, 8, NULL, '2026-11-24T16:28:20', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 416 | Trại Giam Hạnh Phúc | 24/11 18:30 | Phòng 1 | G10 G11
(2416, 8, 70, '2026-11-24T16:30:13', 31000, N'Paid', N'Transfer', NULL, 3, 149, NULL, NULL, NULL), -- suat 416 | Trại Giam Hạnh Phúc | 24/11 18:30 | Phòng 1 | J11 J12
(2417, 7, 97, '2026-11-24T16:34:26', 324000, N'Paid', N'Transfer', NULL, 22, 0, NULL, NULL, NULL), -- suat 413 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 24/11 18:00 | Phòng 4 | F7 F8 F9
(2418, 7, NULL, '2026-11-24T16:35:36', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 440 | Bò Sữa Bay | 25/11 16:15 | Phòng 1 | E5 E6 E7
(2419, 8, NULL, '2026-11-24T16:42:49', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 414 | Ngày Con Còn Mẹ | 24/11 18:15 | Phòng 3 | C5 C6
(2420, 8, NULL, '2026-11-24T16:55:43', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 414 | Ngày Con Còn Mẹ | 24/11 18:15 | Phòng 3 | F9 F10
(2421, 7, NULL, '2026-11-24T17:09:41', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 425 | Dune: Hành Tinh Cát | 25/11 09:00 | Phòng 5 | L1 L2
(2422, 7, NULL, '2026-11-24T17:19:21', 288000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 421 | Dune: Hành Tinh Cát - Phần Hai | 24/11 21:00 | Phòng 5 | G4 G5
(2423, 7, NULL, '2026-11-24T17:27:23', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 433 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 25/11 12:30 | Phòng 4 | G7 G8
(2424, 7, NULL, '2026-11-24T17:32:38', 216000, N'Paid', N'Cash', 220000, 0, 0, NULL, NULL, NULL), -- suat 413 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 24/11 18:00 | Phòng 4 | J11 J12
(2425, 8, NULL, '2026-11-24T17:39:20', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-11-24T18:14:49', 8), -- suat 422 | Trại Buôn Người | 24/11 21:15 | Phòng 2 | J7 J8
(2426, 8, NULL, '2026-11-24T17:42:27', 576000, N'Paid', N'Cash', 576000, 0, 0, NULL, NULL, NULL), -- suat 421 | Dune: Hành Tinh Cát - Phần Hai | 24/11 21:00 | Phòng 5 | H9 H10 H11 H12
(2427, 8, 13, '2026-11-24T17:57:31', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 416 | Trại Giam Hạnh Phúc | 24/11 18:30 | Phòng 1 | G4 G5
(2428, 7, NULL, '2026-11-24T18:12:54', 480000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 425 | Dune: Hành Tinh Cát | 25/11 09:00 | Phòng 5 | D1 D2 D3 D4
(2429, 8, 39, '2026-11-24T18:53:22', 450000, N'Paid', N'Transfer', NULL, 31, 0, NULL, NULL, NULL), -- suat 445 | Trại Giam Hạnh Phúc | 25/11 18:30 | Phòng 1 | D4 D5 D6 D7 D8
(2430, 8, NULL, '2026-11-24T18:59:45', 90000, N'Cancelled', N'Card', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-24T19:40:10', 8), -- suat 420 | Bí Kíp Luyện Cướp | 24/11 21:00 | Phòng 4 | F7
(2431, 7, 80, '2026-11-24T19:23:08', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 418 | Trại Giam Hạnh Phúc | 24/11 20:30 | Phòng 3 | D11 D12
(2432, 7, 69, '2026-11-24T20:06:51', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 450 | Dune: Hành Tinh Cát - Phần Hai | 25/11 21:00 | Phòng 5 | E3 E4
(2433, 7, 1, '2026-11-24T20:19:30', 150000, N'Paid', N'Transfer', NULL, 10, 30, NULL, NULL, NULL), -- suat 419 | Chị Chị Em Em 3 | 24/11 21:00 | Phòng 1 | D10 D11
(2434, 7, NULL, '2026-11-24T21:08:06', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | F4 F5
(2435, 8, NULL, '2026-11-24T21:17:39', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 428 | Kiến Lé Phiêu Lưu Ké | 25/11 10:30 | Phòng 2 | H10
(2436, 8, 2, '2026-11-24T21:33:05', 108000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL); -- suat 426 | Ramayana: Khởi Nguồn Một Huyền Thoại | 25/11 09:15 | Phòng 4 | F8
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(5325, 2327, 445, 1, 107, 90000, N'Active'),
(5326, 2327, 445, 1, 108, 90000, N'Active'),
(5327, 2328, 395, 2, 205, 90000, N'Active'),
(5328, 2328, 395, 2, 206, 90000, N'Active'),
(5329, 2329, 394, 1, 89, 90000, N'Active'),
(5330, 2329, 394, 1, 90, 90000, N'Active'),
(5331, 2330, 476, 3, 321, 90000, N'Active'),
(5332, 2330, 476, 3, 322, 90000, N'Active'),
(5333, 2331, 394, 1, 21, 75000, N'Active'),
(5334, 2331, 394, 1, 22, 75000, N'Active'),
(5335, 2332, 397, 4, 374, 108000, N'Active'),
(5336, 2332, 397, 4, 375, 108000, N'Active'),
(5337, 2333, 396, 5, 522, 144000, N'Active'),
(5338, 2333, 396, 5, 523, 144000, N'Active'),
(5339, 2334, 398, 3, 291, 90000, N'Active'),
(5340, 2334, 398, 3, 292, 90000, N'Active'),
(5341, 2335, 394, 1, 69, 90000, N'Active'),
(5342, 2336, 396, 5, 513, 144000, N'Active'),
(5343, 2336, 396, 5, 514, 144000, N'Active'),
(5344, 2337, 395, 2, 188, 90000, N'Active'),
(5345, 2337, 395, 2, 189, 90000, N'Active'),
(5346, 2338, 394, 1, 77, 90000, N'Active'),
(5347, 2338, 394, 1, 78, 90000, N'Active'),
(5348, 2339, 403, 5, 469, 120000, N'Active'),
(5349, 2339, 403, 5, 470, 120000, N'Active'),
(5350, 2340, 400, 1, 77, 90000, N'Cancelled'),
(5351, 2340, 400, 1, 78, 90000, N'Cancelled'),
(5352, 2341, 413, 4, 373, 108000, N'Active'),
(5353, 2341, 413, 4, 374, 108000, N'Active'),
(5354, 2342, 409, 4, 393, 108000, N'Active'),
(5355, 2342, 409, 4, 394, 108000, N'Active'),
(5356, 2343, 400, 1, 101, 90000, N'Active'),
(5357, 2343, 400, 1, 102, 90000, N'Active'),
(5358, 2344, 407, 2, 179, 90000, N'Active'),
(5359, 2344, 407, 2, 180, 90000, N'Active'),
(5360, 2345, 408, 5, 523, 144000, N'Active'),
(5361, 2345, 408, 5, 524, 144000, N'Active'),
(5362, 2345, 408, 5, 525, 144000, N'Active'),
(5363, 2345, 408, 5, 526, 144000, N'Active'),
(5364, 2346, 409, 4, 412, 108000, N'Active'),
(5365, 2346, 409, 4, 413, 108000, N'Active'),
(5366, 2347, 452, 1, 22, 75000, N'Active'),
(5367, 2347, 452, 1, 23, 75000, N'Active'),
(5368, 2348, 405, 1, 53, 90000, N'Active'),
(5369, 2348, 405, 1, 54, 90000, N'Active'),
(5370, 2349, 403, 5, 547, 144000, N'Active'),
(5371, 2349, 403, 5, 548, 144000, N'Active'),
(5372, 2349, 403, 5, 549, 144000, N'Active'),
(5373, 2350, 403, 5, 500, 144000, N'Active'),
(5374, 2350, 403, 5, 501, 144000, N'Active'),
(5375, 2351, 404, 4, 390, 108000, N'Active'),
(5376, 2351, 404, 4, 391, 108000, N'Active'),
(5377, 2351, 404, 4, 392, 108000, N'Active'),
(5378, 2352, 402, 2, 167, 90000, N'Active'),
(5379, 2353, 407, 2, 148, 90000, N'Active'),
(5380, 2353, 407, 2, 149, 90000, N'Active'),
(5381, 2354, 457, 2, 160, 90000, N'Active'),
(5382, 2354, 457, 2, 161, 90000, N'Active'),
(5383, 2354, 457, 2, 162, 90000, N'Active'),
(5384, 2354, 457, 2, 163, 90000, N'Active'),
(5385, 2355, 405, 1, 69, 90000, N'Active'),
(5386, 2355, 405, 1, 70, 90000, N'Active'),
(5387, 2355, 405, 1, 71, 90000, N'Active'),
(5388, 2355, 405, 1, 72, 90000, N'Active'),
(5389, 2356, 403, 5, 529, 144000, N'Active'),
(5390, 2356, 403, 5, 530, 144000, N'Active'),
(5391, 2357, 414, 3, 277, 90000, N'Active'),
(5392, 2357, 414, 3, 278, 90000, N'Active'),
(5393, 2358, 402, 2, 109, 75000, N'Active'),
(5394, 2358, 402, 2, 110, 75000, N'Active'),
(5395, 2359, 467, 4, 405, 108000, N'Active'),
(5396, 2360, 401, 3, 319, 90000, N'Active'),
(5397, 2360, 401, 3, 320, 90000, N'Active'),
(5398, 2361, 408, 5, 511, 144000, N'Active'),
(5399, 2361, 408, 5, 512, 144000, N'Active'),
(5400, 2361, 408, 5, 513, 144000, N'Active'),
(5401, 2362, 401, 3, 280, 90000, N'Active'),
(5402, 2363, 469, 1, 42, 90000, N'Active'),
(5403, 2363, 469, 1, 43, 90000, N'Active'),
(5404, 2364, 449, 4, 379, 90000, N'Active'),
(5405, 2365, 431, 2, 187, 90000, N'Active'),
(5406, 2365, 431, 2, 188, 90000, N'Active'),
(5407, 2365, 431, 2, 189, 90000, N'Active'),
(5408, 2366, 416, 1, 59, 90000, N'Active'),
(5409, 2366, 416, 1, 60, 90000, N'Active'),
(5410, 2367, 409, 4, 371, 108000, N'Active'),
(5411, 2367, 409, 4, 372, 108000, N'Active'),
(5412, 2368, 433, 4, 380, 108000, N'Active'),
(5413, 2368, 433, 4, 381, 108000, N'Active'),
(5414, 2369, 411, 1, 68, 90000, N'Active'),
(5415, 2369, 411, 1, 69, 90000, N'Active'),
(5416, 2370, 412, 2, 200, 90000, N'Cancelled'),
(5417, 2370, 412, 2, 201, 90000, N'Cancelled'),
(5418, 2370, 412, 2, 202, 90000, N'Cancelled'),
(5419, 2371, 449, 4, 393, 90000, N'Active'),
(5420, 2371, 449, 4, 394, 90000, N'Active'),
(5421, 2372, 408, 5, 533, 144000, N'Active'),
(5422, 2372, 408, 5, 534, 144000, N'Active'),
(5423, 2373, 407, 2, 114, 75000, N'Active'),
(5424, 2373, 407, 2, 115, 75000, N'Active'),
(5425, 2374, 410, 3, 272, 90000, N'Active'),
(5426, 2374, 410, 3, 273, 90000, N'Active'),
(5427, 2374, 410, 3, 274, 90000, N'Active'),
(5428, 2374, 410, 3, 275, 90000, N'Active'),
(5429, 2375, 406, 3, 291, 90000, N'Active'),
(5430, 2375, 406, 3, 292, 90000, N'Active'),
(5431, 2375, 406, 3, 293, 90000, N'Active'),
(5432, 2376, 414, 3, 267, 90000, N'Active'),
(5433, 2376, 414, 3, 268, 90000, N'Active'),
(5434, 2376, 414, 3, 269, 90000, N'Active'),
(5435, 2377, 405, 1, 42, 90000, N'Active'),
(5436, 2377, 405, 1, 43, 90000, N'Active'),
(5437, 2377, 405, 1, 44, 90000, N'Active'),
(5438, 2377, 405, 1, 45, 90000, N'Active'),
(5439, 2378, 420, 4, 413, 90000, N'Active'),
(5440, 2378, 420, 4, 414, 90000, N'Active'),
(5441, 2378, 420, 4, 415, 90000, N'Active'),
(5442, 2379, 406, 3, 241, 75000, N'Active'),
(5443, 2379, 406, 3, 242, 75000, N'Active'),
(5444, 2379, 406, 3, 243, 75000, N'Active'),
(5445, 2379, 406, 3, 244, 75000, N'Active'),
(5446, 2379, 406, 3, 245, 75000, N'Active'),
(5447, 2380, 406, 3, 295, 90000, N'Active'),
(5448, 2380, 406, 3, 296, 90000, N'Active'),
(5449, 2381, 444, 5, 486, 144000, N'Active'),
(5450, 2381, 444, 5, 487, 144000, N'Active'),
(5451, 2382, 450, 5, 540, 144000, N'Active'),
(5452, 2383, 408, 5, 496, 144000, N'Active'),
(5453, 2383, 408, 5, 497, 144000, N'Active'),
(5454, 2384, 414, 3, 313, 90000, N'Active'),
(5455, 2384, 414, 3, 314, 90000, N'Active'),
(5456, 2385, 410, 3, 259, 90000, N'Active'),
(5457, 2385, 410, 3, 260, 90000, N'Active'),
(5458, 2386, 422, 2, 181, 90000, N'Cancelled'),
(5459, 2386, 422, 2, 182, 90000, N'Cancelled'),
(5460, 2387, 441, 2, 126, 75000, N'Active'),
(5461, 2387, 441, 2, 127, 75000, N'Active'),
(5462, 2388, 408, 5, 436, 120000, N'Active'),
(5463, 2388, 408, 5, 437, 120000, N'Active'),
(5464, 2388, 408, 5, 438, 120000, N'Active'),
(5465, 2388, 408, 5, 439, 120000, N'Active'),
(5466, 2389, 434, 1, 99, 90000, N'Active'),
(5467, 2389, 434, 1, 100, 90000, N'Active'),
(5468, 2390, 409, 4, 375, 108000, N'Active'),
(5469, 2390, 409, 4, 376, 108000, N'Active'),
(5470, 2390, 409, 4, 377, 108000, N'Active'),
(5471, 2390, 409, 4, 378, 108000, N'Active'),
(5472, 2390, 409, 4, 379, 108000, N'Active'),
(5473, 2390, 409, 4, 380, 108000, N'Active'),
(5474, 2391, 414, 3, 292, 90000, N'Active'),
(5475, 2391, 414, 3, 293, 90000, N'Active'),
(5476, 2392, 416, 1, 33, 75000, N'Active'),
(5477, 2392, 416, 1, 34, 75000, N'Active'),
(5478, 2393, 414, 3, 220, 75000, N'Active'),
(5479, 2393, 414, 3, 221, 75000, N'Active'),
(5480, 2393, 414, 3, 222, 75000, N'Active'),
(5481, 2393, 414, 3, 223, 75000, N'Active'),
(5482, 2394, 440, 1, 67, 90000, N'Active'),
(5483, 2395, 472, 3, 271, 90000, N'Active'),
(5484, 2395, 472, 3, 272, 90000, N'Active'),
(5485, 2395, 472, 3, 273, 90000, N'Active'),
(5486, 2395, 472, 3, 274, 90000, N'Active'),
(5487, 2396, 413, 4, 380, 108000, N'Active'),
(5488, 2396, 413, 4, 381, 108000, N'Active'),
(5489, 2396, 413, 4, 382, 108000, N'Active'),
(5490, 2397, 460, 2, 141, 75000, N'Active'),
(5491, 2397, 460, 2, 142, 75000, N'Active'),
(5492, 2398, 414, 3, 273, 90000, N'Active'),
(5493, 2399, 445, 1, 50, 90000, N'Active'),
(5494, 2400, 411, 1, 76, 90000, N'Cancelled'),
(5495, 2400, 411, 1, 77, 90000, N'Cancelled'),
(5496, 2401, 414, 3, 295, 90000, N'Active'),
(5497, 2401, 414, 3, 296, 90000, N'Active'),
(5498, 2401, 414, 3, 297, 90000, N'Active'),
(5499, 2401, 414, 3, 298, 90000, N'Active'),
(5500, 2402, 416, 1, 64, 90000, N'Active'),
(5501, 2402, 416, 1, 65, 90000, N'Active'),
(5502, 2403, 417, 2, 134, 75000, N'Active'),
(5503, 2403, 417, 2, 135, 75000, N'Active'),
(5504, 2403, 417, 2, 136, 75000, N'Active'),
(5505, 2403, 417, 2, 137, 75000, N'Active'),
(5506, 2404, 410, 3, 227, 75000, N'Active'),
(5507, 2405, 416, 1, 61, 90000, N'Active'),
(5508, 2405, 416, 1, 62, 90000, N'Active'),
(5509, 2405, 416, 1, 63, 90000, N'Active'),
(5510, 2406, 420, 4, 333, 75000, N'Active'),
(5511, 2406, 420, 4, 334, 75000, N'Active'),
(5512, 2406, 420, 4, 335, 75000, N'Active'),
(5513, 2406, 420, 4, 336, 75000, N'Active'),
(5514, 2407, 415, 5, 497, 144000, N'Active'),
(5515, 2407, 415, 5, 498, 144000, N'Active'),
(5516, 2408, 421, 5, 485, 144000, N'Active'),
(5517, 2408, 421, 5, 486, 144000, N'Active'),
(5518, 2408, 421, 5, 487, 144000, N'Active'),
(5519, 2408, 421, 5, 488, 144000, N'Active'),
(5520, 2408, 421, 5, 489, 144000, N'Active'),
(5521, 2409, 421, 5, 497, 144000, N'Active'),
(5522, 2409, 421, 5, 498, 144000, N'Active'),
(5523, 2410, 421, 5, 542, 144000, N'Active'),
(5524, 2410, 421, 5, 543, 144000, N'Active'),
(5525, 2410, 421, 5, 544, 144000, N'Active'),
(5526, 2410, 421, 5, 545, 144000, N'Active'),
(5527, 2411, 414, 3, 302, 90000, N'Active'),
(5528, 2411, 414, 3, 303, 90000, N'Active'),
(5529, 2411, 414, 3, 304, 90000, N'Active'),
(5530, 2411, 414, 3, 305, 90000, N'Active'),
(5531, 2412, 414, 3, 237, 75000, N'Active'),
(5532, 2413, 420, 4, 403, 90000, N'Active'),
(5533, 2413, 420, 4, 404, 90000, N'Active'),
(5534, 2414, 416, 1, 71, 90000, N'Active'),
(5535, 2414, 416, 1, 72, 90000, N'Active'),
(5536, 2415, 416, 1, 82, 90000, N'Active'),
(5537, 2415, 416, 1, 83, 90000, N'Active'),
(5538, 2416, 416, 1, 107, 90000, N'Active'),
(5539, 2416, 416, 1, 108, 90000, N'Active'),
(5540, 2417, 413, 4, 391, 108000, N'Active'),
(5541, 2417, 413, 4, 392, 108000, N'Active'),
(5542, 2417, 413, 4, 393, 108000, N'Active'),
(5543, 2418, 440, 1, 53, 90000, N'Active'),
(5544, 2418, 440, 1, 54, 90000, N'Active'),
(5545, 2418, 440, 1, 55, 90000, N'Active'),
(5546, 2419, 414, 3, 245, 75000, N'Active'),
(5547, 2419, 414, 3, 246, 75000, N'Active'),
(5548, 2420, 414, 3, 285, 90000, N'Active'),
(5549, 2420, 414, 3, 286, 90000, N'Active'),
(5550, 2421, 425, 5, 553, 144000, N'Active'),
(5551, 2421, 425, 5, 554, 144000, N'Active'),
(5552, 2422, 421, 5, 508, 144000, N'Active'),
(5553, 2422, 421, 5, 509, 144000, N'Active'),
(5554, 2423, 433, 4, 403, 108000, N'Active'),
(5555, 2423, 433, 4, 404, 108000, N'Active'),
(5556, 2424, 413, 4, 431, 108000, N'Active'),
(5557, 2424, 413, 4, 432, 108000, N'Active'),
(5558, 2425, 422, 2, 211, 90000, N'Cancelled'),
(5559, 2425, 422, 2, 212, 90000, N'Cancelled'),
(5560, 2426, 421, 5, 525, 144000, N'Active'),
(5561, 2426, 421, 5, 526, 144000, N'Active'),
(5562, 2426, 421, 5, 527, 144000, N'Active'),
(5563, 2426, 421, 5, 528, 144000, N'Active'),
(5564, 2427, 416, 1, 76, 90000, N'Active'),
(5565, 2427, 416, 1, 77, 90000, N'Active'),
(5566, 2428, 425, 5, 469, 120000, N'Active'),
(5567, 2428, 425, 5, 470, 120000, N'Active'),
(5568, 2428, 425, 5, 471, 120000, N'Active'),
(5569, 2428, 425, 5, 472, 120000, N'Active'),
(5570, 2429, 445, 1, 40, 90000, N'Active'),
(5571, 2429, 445, 1, 41, 90000, N'Active'),
(5572, 2429, 445, 1, 42, 90000, N'Active'),
(5573, 2429, 445, 1, 43, 90000, N'Active'),
(5574, 2429, 445, 1, 44, 90000, N'Active'),
(5575, 2430, 420, 4, 391, 90000, N'Cancelled'),
(5576, 2431, 418, 3, 263, 90000, N'Active'),
(5577, 2431, 418, 3, 264, 90000, N'Active'),
(5578, 2432, 450, 5, 483, 144000, N'Active'),
(5579, 2432, 450, 5, 484, 144000, N'Active'),
(5580, 2433, 419, 1, 46, 90000, N'Active'),
(5581, 2433, 419, 1, 47, 90000, N'Active'),
(5582, 2434, 475, 2, 172, 90000, N'Active'),
(5583, 2434, 475, 2, 173, 90000, N'Active'),
(5584, 2435, 428, 2, 202, 90000, N'Active'),
(5585, 2436, 426, 4, 392, 108000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 4 25/11/2026: 149 hoa don (7 huy), 352 ve, doanh thu 33.650.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(2437, 8, 40, '2026-11-25T08:04:13', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 454 | Dune: Hành Tinh Cát | 26/11 09:00 | Phòng 5 | E5 E6
(2438, 9, 25, '2026-11-25T08:07:40', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 423 | Trại Giam Hạnh Phúc | 25/11 09:00 | Phòng 1 | H9 H10 H11
(2439, 9, 8, '2026-11-25T08:09:59', 70000, N'Paid', N'Cash', 100000, 4, 20, NULL, NULL, NULL), -- suat 429 | Ngày Con Còn Mẹ | 25/11 11:30 | Phòng 1 | F9
(2440, 9, NULL, '2026-11-25T08:12:52', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 462 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 26/11 12:30 | Phòng 4 | C11 C12
(2441, 9, NULL, '2026-11-25T08:22:27', 300000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 497 | Chị Chị Em Em 3 | 27/11 16:00 | Phòng 3 | B6 B7 B8 B9
(2442, 9, 92, '2026-11-25T08:22:28', 180000, N'Cancelled', N'Cash', 200000, 12, 0, N'Lỗi thanh toán', '2026-11-25T08:32:55', 9), -- suat 502 | Điểm Mù | 27/11 18:30 | Phòng 3 | H8 H9
(2443, 9, NULL, '2026-11-25T08:24:51', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 423 | Trại Giam Hạnh Phúc | 25/11 09:00 | Phòng 1 | G9 G10
(2444, 9, 42, '2026-11-25T08:28:14', 90000, N'Paid', N'Cash', 100000, 6, 0, NULL, NULL, NULL), -- suat 424 | Ma Mút Con Vượt Kỷ Băng Hà | 25/11 09:00 | Phòng 2 | D4
(2445, 8, NULL, '2026-11-25T08:36:46', 324000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 438 | Godzilla Trừ Không | 25/11 15:30 | Phòng 4 | H4 H5 H6
(2446, 9, NULL, '2026-11-25T08:38:52', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 425 | Dune: Hành Tinh Cát | 25/11 09:00 | Phòng 5 | J9
(2447, 9, NULL, '2026-11-25T08:41:42', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 423 | Trại Giam Hạnh Phúc | 25/11 09:00 | Phòng 1 | G4 G5
(2448, 8, 104, '2026-11-25T08:51:40', 648000, N'Paid', N'Transfer', NULL, 45, 0, NULL, NULL, NULL), -- suat 426 | Ramayana: Khởi Nguồn Một Huyền Thoại | 25/11 09:15 | Phòng 4 | G3 G4 G5 G6 G7 G8
(2449, 8, NULL, '2026-11-25T09:02:01', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 505 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:00 | Phòng 1 | H2 H3 H4 H5
(2450, 9, NULL, '2026-11-25T09:07:59', 216000, N'Paid', N'Cash', 216000, 0, 0, NULL, NULL, NULL), -- suat 506 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 21:00 | Phòng 4 | J11 J12
(2451, 9, 66, '2026-11-25T09:11:39', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 427 | Bí Kíp Luyện Cướp | 25/11 09:30 | Phòng 3 | F2 F3
(2452, 8, NULL, '2026-11-25T09:13:47', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 463 | Trại Giam Hạnh Phúc | 26/11 13:45 | Phòng 1 | G6
(2453, 8, NULL, '2026-11-25T09:15:01', 450000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | C4 C5 C6 C7 C8 C9
(2454, 8, 108, '2026-11-25T09:19:43', 10000, N'Paid', N'Card', NULL, 0, 80, NULL, NULL, NULL), -- suat 477 | Chị Chị Em Em 3 | 26/11 21:00 | Phòng 1 | E4
(2455, 8, NULL, '2026-11-25T09:23:34', 540000, N'Paid', N'Cash', 540000, 0, 0, NULL, NULL, NULL), -- suat 436 | Ngày Con Còn Mẹ | 25/11 14:30 | Phòng 2 | F6 F7 F8 F9 F10 F11
(2456, 9, NULL, '2026-11-25T09:26:48', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 503 | Godzilla Trừ Không | 27/11 18:30 | Phòng 4 | A2
(2457, 9, 92, '2026-11-25T09:31:17', 103000, N'Paid', N'Card', NULL, 5, 47, NULL, NULL, NULL), -- suat 482 | Hexed: Thế Giới Phép Thuật | 27/11 09:00 | Phòng 2 | C9 C10
(2458, 9, NULL, '2026-11-25T09:38:57', 540000, N'Paid', N'Cash', 540000, 0, 0, NULL, NULL, NULL), -- suat 435 | Thiên Đường Tăm Tối | 25/11 14:00 | Phòng 3 | G3 G4 G5 G6 G7 G8
(2459, 9, NULL, '2026-11-25T09:43:11', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 429 | Ngày Con Còn Mẹ | 25/11 11:30 | Phòng 1 | F10 F11 F12
(2460, 9, NULL, '2026-11-25T09:48:04', 375000, N'Paid', N'Cash', 375000, 0, 0, NULL, NULL, NULL), -- suat 434 | Trại Giam Hạnh Phúc | 25/11 13:45 | Phòng 1 | C7 C8 C9 C10 C11
(2461, 9, NULL, '2026-11-25T09:50:13', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 503 | Godzilla Trừ Không | 27/11 18:30 | Phòng 4 | C7 C8
(2462, 9, NULL, '2026-11-25T09:50:56', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 454 | Dune: Hành Tinh Cát | 26/11 09:00 | Phòng 5 | H6 H7
(2463, 8, 32, '2026-11-25T09:57:52', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 439 | Clayface | 25/11 16:00 | Phòng 3 | D9 D10 D11
(2464, 9, NULL, '2026-11-25T09:58:16', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 433 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 25/11 12:30 | Phòng 4 | J11 J12
(2465, 9, NULL, '2026-11-25T09:59:28', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 428 | Kiến Lé Phiêu Lưu Ké | 25/11 10:30 | Phòng 2 | C8 C9
(2466, 9, NULL, '2026-11-25T10:02:51', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 437 | Dune: Hành Tinh Cát - Phần Hai | 25/11 15:00 | Phòng 5 | H6 H7
(2467, 9, NULL, '2026-11-25T10:08:45', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 432 | Godzilla Trừ Không | 25/11 12:15 | Phòng 5 | G10
(2468, 9, 4, '2026-11-25T10:09:54', 146000, N'Paid', N'Transfer', NULL, 10, 34, NULL, NULL, NULL), -- suat 480 | Trại Buôn Người | 26/11 21:15 | Phòng 2 | E5 E6
(2469, 8, NULL, '2026-11-25T10:33:16', 120000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 444 | Godzilla Trừ Không | 25/11 18:15 | Phòng 5 | D10
(2470, 9, NULL, '2026-11-25T10:34:41', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 457 | Kiến Lé Phiêu Lưu Ké | 26/11 10:30 | Phòng 2 | F11 F12
(2471, 9, NULL, '2026-11-25T10:36:20', 108000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 433 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 25/11 12:30 | Phòng 4 | E11
(2472, 8, NULL, '2026-11-25T10:38:26', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 432 | Godzilla Trừ Không | 25/11 12:15 | Phòng 5 | G6 G7
(2473, 8, NULL, '2026-11-25T10:46:02', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 434 | Trại Giam Hạnh Phúc | 25/11 13:45 | Phòng 1 | G1 G2 G3
(2474, 9, 75, '2026-11-25T10:48:06', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 434 | Trại Giam Hạnh Phúc | 25/11 13:45 | Phòng 1 | F8 F9 F10
(2475, 8, 114, '2026-11-25T10:48:51', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 438 | Godzilla Trừ Không | 25/11 15:30 | Phòng 4 | F5 F6
(2476, 9, NULL, '2026-11-25T10:54:34', 360000, N'Paid', N'Cash', 400000, 0, 0, NULL, NULL, NULL), -- suat 452 | Trại Giam Hạnh Phúc | 26/11 09:00 | Phòng 1 | E2 E3 E4 E5
(2477, 8, NULL, '2026-11-25T10:54:51', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 432 | Godzilla Trừ Không | 25/11 12:15 | Phòng 5 | F5 F6
(2478, 9, NULL, '2026-11-25T10:57:57', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 473 | Godzilla Trừ Không | 26/11 18:15 | Phòng 5 | J4 J5
(2479, 8, NULL, '2026-11-25T10:59:41', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 438 | Godzilla Trừ Không | 25/11 15:30 | Phòng 4 | D5 D6
(2480, 9, 37, '2026-11-25T11:07:24', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 431 | Chàng Mèo Mang Mũ | 25/11 12:15 | Phòng 2 | E9 E10
(2481, 8, NULL, '2026-11-25T11:10:09', 432000, N'Paid', N'Cash', 440000, 0, 0, NULL, NULL, NULL), -- suat 442 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 25/11 18:00 | Phòng 4 | E9 E10 E11 E12
(2482, 9, NULL, '2026-11-25T11:13:08', 150000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 474 | Trại Giam Hạnh Phúc | 26/11 18:30 | Phòng 1 | C7 C8
(2483, 8, NULL, '2026-11-25T11:14:48', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 434 | Trại Giam Hạnh Phúc | 25/11 13:45 | Phòng 1 | F3 F4 F5 F6
(2484, 9, NULL, '2026-11-25T11:23:17', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | E2 E3 E4
(2485, 8, NULL, '2026-11-25T11:29:56', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | H10
(2486, 8, NULL, '2026-11-25T11:30:08', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 434 | Trại Giam Hạnh Phúc | 25/11 13:45 | Phòng 1 | D4 D5
(2487, 8, NULL, '2026-11-25T11:33:11', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 444 | Godzilla Trừ Không | 25/11 18:15 | Phòng 5 | F9 F10
(2488, 8, NULL, '2026-11-25T11:33:17', 375000, N'Paid', N'Cash', 375000, 0, 0, NULL, NULL, NULL), -- suat 434 | Trại Giam Hạnh Phúc | 25/11 13:45 | Phòng 1 | B3 B4 B5 B6 B7
(2489, 8, NULL, '2026-11-25T11:34:52', 180000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-11-25T11:48:45', 8), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | J5 J6
(2490, 8, NULL, '2026-11-25T11:45:45', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 432 | Godzilla Trừ Không | 25/11 12:15 | Phòng 5 | E4 E5 E6
(2491, 9, NULL, '2026-11-25T11:48:59', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 452 | Trại Giam Hạnh Phúc | 26/11 09:00 | Phòng 1 | F5 F6 F7
(2492, 9, NULL, '2026-11-25T11:54:51', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 436 | Ngày Con Còn Mẹ | 25/11 14:30 | Phòng 2 | G6 G7
(2493, 9, 51, '2026-11-25T11:57:21', 108000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 438 | Godzilla Trừ Không | 25/11 15:30 | Phòng 4 | E4
(2494, 8, NULL, '2026-11-25T12:00:10', 75000, N'Paid', N'Cash', 75000, 0, 0, NULL, NULL, NULL), -- suat 434 | Trại Giam Hạnh Phúc | 25/11 13:45 | Phòng 1 | C3
(2495, 9, 47, '2026-11-25T12:07:28', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 488 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 11:30 | Phòng 1 | D5 D6
(2496, 8, NULL, '2026-11-25T12:17:05', 270000, N'Cancelled', N'Card', NULL, 0, 0, N'Nhầm suất / ghế', '2026-11-25T12:57:06', 8), -- suat 446 | Mẹ Mìn: Giao Kèo Với Quỷ | 25/11 19:00 | Phòng 2 | G10 G11 G12
(2497, 9, NULL, '2026-11-25T12:41:17', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 435 | Thiên Đường Tăm Tối | 25/11 14:00 | Phòng 3 | F2 F3 F4
(2498, 9, NULL, '2026-11-25T12:42:12', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 450 | Dune: Hành Tinh Cát - Phần Hai | 25/11 21:00 | Phòng 5 | J9 J10
(2499, 8, NULL, '2026-11-25T12:43:32', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 434 | Trại Giam Hạnh Phúc | 25/11 13:45 | Phòng 1 | G7 G8 G9
(2500, 8, NULL, '2026-11-25T12:45:22', 288000, N'Paid', N'Cash', 290000, 0, 0, NULL, NULL, NULL), -- suat 437 | Dune: Hành Tinh Cát - Phần Hai | 25/11 15:00 | Phòng 5 | G5 G6
(2501, 8, 25, '2026-11-25T12:46:48', 240000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 437 | Dune: Hành Tinh Cát - Phần Hai | 25/11 15:00 | Phòng 5 | D5 D6
(2502, 9, NULL, '2026-11-25T12:57:18', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 440 | Bò Sữa Bay | 25/11 16:15 | Phòng 1 | G2
(2503, 9, NULL, '2026-11-25T13:01:29', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 434 | Trại Giam Hạnh Phúc | 25/11 13:45 | Phòng 1 | D6 D7
(2504, 9, 44, '2026-11-25T13:10:27', 75000, N'Paid', N'Cash', 100000, 3, 0, NULL, NULL, NULL), -- suat 435 | Thiên Đường Tăm Tối | 25/11 14:00 | Phòng 3 | C7
(2505, 9, NULL, '2026-11-25T13:15:03', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 437 | Dune: Hành Tinh Cát - Phần Hai | 25/11 15:00 | Phòng 5 | H12
(2506, 9, NULL, '2026-11-25T13:21:37', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 434 | Trại Giam Hạnh Phúc | 25/11 13:45 | Phòng 1 | J5 J6
(2507, 9, NULL, '2026-11-25T13:27:48', 432000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 473 | Godzilla Trừ Không | 26/11 18:15 | Phòng 5 | E6 E7 E8
(2508, 8, NULL, '2026-11-25T13:28:43', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 445 | Trại Giam Hạnh Phúc | 25/11 18:30 | Phòng 1 | C7
(2509, 8, 113, '2026-11-25T13:29:33', 600000, N'Paid', N'Transfer', NULL, 30, 0, NULL, NULL, NULL), -- suat 444 | Godzilla Trừ Không | 25/11 18:15 | Phòng 5 | D2 D3 D4 D5 D6
(2510, 8, 97, '2026-11-25T13:30:05', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 445 | Trại Giam Hạnh Phúc | 25/11 18:30 | Phòng 1 | G6 G7
(2511, 8, 66, '2026-11-25T13:34:16', 432000, N'Paid', N'Card', NULL, 30, 0, NULL, NULL, NULL), -- suat 437 | Dune: Hành Tinh Cát - Phần Hai | 25/11 15:00 | Phòng 5 | G2 G3 G4
(2512, 9, 21, '2026-11-25T13:44:13', 225000, N'Paid', N'Card', NULL, 11, 0, NULL, NULL, NULL), -- suat 436 | Ngày Con Còn Mẹ | 25/11 14:30 | Phòng 2 | B5 B6 B7
(2513, 9, NULL, '2026-11-25T13:44:37', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 504 | Bò Sữa Bay | 27/11 19:30 | Phòng 2 | C2 C3
(2514, 9, NULL, '2026-11-25T13:47:58', 216000, N'Cancelled', N'Cash', 300000, 0, 0, N'Lỗi thanh toán', '2026-11-25T14:29:34', 9), -- suat 442 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 25/11 18:00 | Phòng 4 | E6 E7
(2515, 9, 37, '2026-11-25T13:49:26', 576000, N'Paid', N'Transfer', NULL, 40, 0, NULL, NULL, NULL), -- suat 444 | Godzilla Trừ Không | 25/11 18:15 | Phòng 5 | J7 J8 J9 J10
(2516, 9, NULL, '2026-11-25T14:00:33', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 504 | Bò Sữa Bay | 27/11 19:30 | Phòng 2 | D11
(2517, 8, NULL, '2026-11-25T14:04:47', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 459 | Kẻ Hồi Sinh | 26/11 12:00 | Phòng 3 | G6
(2518, 8, NULL, '2026-11-25T14:09:54', 540000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 451 | Trại Buôn Người | 25/11 21:15 | Phòng 2 | F6 F7 F8 F9 F10 F11
(2519, 8, NULL, '2026-11-25T14:10:41', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 450 | Dune: Hành Tinh Cát - Phần Hai | 25/11 21:00 | Phòng 5 | J4 J5
(2520, 8, 13, '2026-11-25T14:19:06', 450000, N'Paid', N'Cash', 450000, 31, 0, NULL, NULL, NULL), -- suat 443 | Ngày Con Còn Mẹ | 25/11 18:15 | Phòng 3 | F5 F6 F7 F8 F9
(2521, 8, NULL, '2026-11-25T14:19:12', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 494 | Ngày Con Còn Mẹ | 27/11 15:00 | Phòng 2 | H5 H6
(2522, 9, NULL, '2026-11-25T14:20:36', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | G6 G7 G8
(2523, 9, 42, '2026-11-25T14:25:24', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 439 | Clayface | 25/11 16:00 | Phòng 3 | G5
(2524, 9, 108, '2026-11-25T14:27:35', 180000, N'Paid', N'Cash', 500000, 12, 0, NULL, NULL, NULL), -- suat 441 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 25/11 16:45 | Phòng 2 | H6 H7
(2525, 9, NULL, '2026-11-25T14:28:43', 360000, N'Cancelled', N'Transfer', NULL, 0, 0, N'Khách đổi ý', '2026-11-25T14:57:01', 9), -- suat 488 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 11:30 | Phòng 1 | F4 F5 F6 F7
(2526, 9, NULL, '2026-11-25T14:42:29', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 443 | Ngày Con Còn Mẹ | 25/11 18:15 | Phòng 3 | C3 C4
(2527, 9, NULL, '2026-11-25T14:50:52', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 446 | Mẹ Mìn: Giao Kèo Với Quỷ | 25/11 19:00 | Phòng 2 | G9 G10
(2528, 9, NULL, '2026-11-25T14:55:48', 576000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 444 | Godzilla Trừ Không | 25/11 18:15 | Phòng 5 | G2 G3 G4 G5
(2529, 10, NULL, '2026-11-25T15:13:32', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 444 | Godzilla Trừ Không | 25/11 18:15 | Phòng 5 | F4 F5 F6
(2530, 3, NULL, '2026-11-25T15:16:01', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 445 | Trại Giam Hạnh Phúc | 25/11 18:30 | Phòng 1 | E6 E7 E8 E9
(2531, 10, NULL, '2026-11-25T15:19:16', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 450 | Dune: Hành Tinh Cát - Phần Hai | 25/11 21:00 | Phòng 5 | F9 F10
(2532, 10, NULL, '2026-11-25T15:29:49', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 447 | Mẹ Mìn: Giao Kèo Với Quỷ | 25/11 20:30 | Phòng 3 | B8 B9 B10
(2533, 10, NULL, '2026-11-25T15:36:07', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 442 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 25/11 18:00 | Phòng 4 | B4
(2534, 10, NULL, '2026-11-25T15:38:24', 240000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 450 | Dune: Hành Tinh Cát - Phần Hai | 25/11 21:00 | Phòng 5 | C9 C10
(2535, 3, NULL, '2026-11-25T15:41:08', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 447 | Mẹ Mìn: Giao Kèo Với Quỷ | 25/11 20:30 | Phòng 3 | E8 E9
(2536, 10, NULL, '2026-11-25T15:42:49', 108000, N'Paid', N'Cash', 110000, 0, 0, NULL, NULL, NULL), -- suat 442 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 25/11 18:00 | Phòng 4 | H6
(2537, 3, NULL, '2026-11-25T16:02:32', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 446 | Mẹ Mìn: Giao Kèo Với Quỷ | 25/11 19:00 | Phòng 2 | D9 D10
(2538, 10, NULL, '2026-11-25T16:12:42', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 449 | Bí Kíp Luyện Cướp | 25/11 21:00 | Phòng 4 | F8
(2539, 10, 25, '2026-11-25T16:15:50', 108000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 442 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 25/11 18:00 | Phòng 4 | D4
(2540, 3, NULL, '2026-11-25T16:16:18', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | E5
(2541, 10, NULL, '2026-11-25T16:19:03', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 491 | Hexed: Thế Giới Phép Thuật | 27/11 12:45 | Phòng 2 | E7
(2542, 3, 70, '2026-11-25T16:21:02', 150000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 443 | Ngày Con Còn Mẹ | 25/11 18:15 | Phòng 3 | B9 B10
(2543, 3, NULL, '2026-11-25T16:21:51', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 450 | Dune: Hành Tinh Cát - Phần Hai | 25/11 21:00 | Phòng 5 | E7 E8 E9
(2544, 10, NULL, '2026-11-25T16:24:15', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 509 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:45 | Phòng 3 | G6 G7 G8
(2545, 3, NULL, '2026-11-25T16:28:54', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 446 | Mẹ Mìn: Giao Kèo Với Quỷ | 25/11 19:00 | Phòng 2 | F2
(2546, 3, NULL, '2026-11-25T16:48:30', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 498 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 16:15 | Phòng 1 | D9 D10
(2547, 3, NULL, '2026-11-25T17:03:40', 90000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 449 | Bí Kíp Luyện Cướp | 25/11 21:00 | Phòng 4 | H8
(2548, 10, 28, '2026-11-25T17:04:45', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 443 | Ngày Con Còn Mẹ | 25/11 18:15 | Phòng 3 | H3 H4
(2549, 3, 89, '2026-11-25T17:08:46', 270000, N'Paid', N'Cash', 270000, 18, 0, NULL, NULL, NULL), -- suat 443 | Ngày Con Còn Mẹ | 25/11 18:15 | Phòng 3 | G5 G6 G7
(2550, 3, NULL, '2026-11-25T17:10:12', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 498 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 16:15 | Phòng 1 | F11
(2551, 3, NULL, '2026-11-25T17:16:21', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 446 | Mẹ Mìn: Giao Kèo Với Quỷ | 25/11 19:00 | Phòng 2 | D8
(2552, 3, NULL, '2026-11-25T17:16:27', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 445 | Trại Giam Hạnh Phúc | 25/11 18:30 | Phòng 1 | J9 J10
(2553, 10, NULL, '2026-11-25T17:17:00', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 447 | Mẹ Mìn: Giao Kèo Với Quỷ | 25/11 20:30 | Phòng 3 | J11 J12
(2554, 10, NULL, '2026-11-25T17:18:37', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 472 | Ngày Con Còn Mẹ | 26/11 18:15 | Phòng 3 | E11 E12
(2555, 10, NULL, '2026-11-25T17:37:05', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 446 | Mẹ Mìn: Giao Kèo Với Quỷ | 25/11 19:00 | Phòng 2 | H6 H7 H8 H9
(2556, 3, NULL, '2026-11-25T17:43:52', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 446 | Mẹ Mìn: Giao Kèo Với Quỷ | 25/11 19:00 | Phòng 2 | H10 H11 H12
(2557, 3, NULL, '2026-11-25T17:44:39', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 450 | Dune: Hành Tinh Cát - Phần Hai | 25/11 21:00 | Phòng 5 | J6
(2558, 3, NULL, '2026-11-25T17:55:17', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 445 | Trại Giam Hạnh Phúc | 25/11 18:30 | Phòng 1 | J1 J2
(2559, 3, 110, '2026-11-25T18:09:25', 240000, N'Paid', N'Cash', 300000, 12, 0, NULL, NULL, NULL), -- suat 466 | Dune: Hành Tinh Cát - Phần Hai | 26/11 15:00 | Phòng 5 | D8 D9
(2560, 3, NULL, '2026-11-25T18:11:17', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 447 | Mẹ Mìn: Giao Kèo Với Quỷ | 25/11 20:30 | Phòng 3 | C1 C2
(2561, 10, NULL, '2026-11-25T18:22:56', 108000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 462 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 26/11 12:30 | Phòng 4 | H3
(2562, 3, 72, '2026-11-25T18:25:13', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 509 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:45 | Phòng 3 | D4 D5 D6
(2563, 3, NULL, '2026-11-25T18:33:05', 90000, N'Cancelled', N'Card', NULL, 0, 0, N'Lỗi thanh toán', '2026-11-25T18:38:51', 3), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | E9
(2564, 3, NULL, '2026-11-25T18:41:19', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 449 | Bí Kíp Luyện Cướp | 25/11 21:00 | Phòng 4 | G5 G6 G7
(2565, 3, NULL, '2026-11-25T18:54:54', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 467 | Godzilla Trừ Không | 26/11 15:30 | Phòng 4 | E1 E2
(2566, 10, NULL, '2026-11-25T19:05:18', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 483 | Dune: Hành Tinh Cát - Phần Hai | 27/11 09:00 | Phòng 5 | C5 C6
(2567, 3, NULL, '2026-11-25T19:06:40', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 447 | Mẹ Mìn: Giao Kèo Với Quỷ | 25/11 20:30 | Phòng 3 | F4 F5 F6 F7
(2568, 3, 66, '2026-11-25T19:13:13', 450000, N'Paid', N'Cash', 450000, 31, 0, NULL, NULL, NULL), -- suat 448 | Chị Chị Em Em 3 | 25/11 21:00 | Phòng 1 | F1 F2 F3 F4 F5
(2569, 10, NULL, '2026-11-25T19:23:55', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 450 | Dune: Hành Tinh Cát - Phần Hai | 25/11 21:00 | Phòng 5 | D3 D4 D5
(2570, 10, NULL, '2026-11-25T19:26:20', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | G6 G7 G8 G9
(2571, 10, 21, '2026-11-25T19:31:15', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 447 | Mẹ Mìn: Giao Kèo Với Quỷ | 25/11 20:30 | Phòng 3 | E6 E7
(2572, 3, 102, '2026-11-25T19:32:55', 180000, N'Cancelled', N'Card', NULL, 12, 0, N'Nhầm suất / ghế', '2026-11-25T20:16:26', 3), -- suat 451 | Trại Buôn Người | 25/11 21:15 | Phòng 2 | E8 E9
(2573, 3, NULL, '2026-11-25T19:38:49', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 447 | Mẹ Mìn: Giao Kèo Với Quỷ | 25/11 20:30 | Phòng 3 | D3
(2574, 10, NULL, '2026-11-25T19:52:19', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 466 | Dune: Hành Tinh Cát - Phần Hai | 26/11 15:00 | Phòng 5 | C10 C11 C12
(2575, 10, NULL, '2026-11-25T19:52:49', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 461 | Godzilla Trừ Không | 26/11 12:15 | Phòng 5 | K5
(2576, 3, 117, '2026-11-25T20:09:51', 90000, N'Paid', N'Cash', 90000, 6, 0, NULL, NULL, NULL), -- suat 474 | Trại Giam Hạnh Phúc | 26/11 18:30 | Phòng 1 | E6
(2577, 3, NULL, '2026-11-25T20:19:10', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 467 | Godzilla Trừ Không | 26/11 15:30 | Phòng 4 | C4 C5
(2578, 3, 99, '2026-11-25T20:28:51', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 504 | Bò Sữa Bay | 27/11 19:30 | Phòng 2 | E1 E2
(2579, 10, 70, '2026-11-25T20:32:41', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 473 | Godzilla Trừ Không | 26/11 18:15 | Phòng 5 | K9 K10
(2580, 3, NULL, '2026-11-25T20:40:03', 324000, N'Paid', N'Cash', 324000, 0, 0, NULL, NULL, NULL), -- suat 462 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 26/11 12:30 | Phòng 4 | F4 F5 F6
(2581, 10, 1, '2026-11-25T20:51:55', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 487 | Ngày Con Còn Mẹ | 27/11 11:15 | Phòng 3 | E5 E6
(2582, 3, NULL, '2026-11-25T20:57:39', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 470 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 26/11 16:45 | Phòng 2 | G5 G6
(2583, 3, 52, '2026-11-25T20:57:56', 180000, N'Paid', N'Cash', 180000, 18, 0, NULL, NULL, NULL), -- suat 476 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 20:30 | Phòng 3 | J1 J2
(2584, 3, NULL, '2026-11-25T21:04:45', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 456 | Bí Kíp Luyện Cướp | 26/11 09:30 | Phòng 3 | D7 D8
(2585, 10, NULL, '2026-11-25T21:38:32', 720000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL); -- suat 466 | Dune: Hành Tinh Cát - Phần Hai | 26/11 15:00 | Phòng 5 | J5 J6 J7 J8 J9
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(5586, 2437, 454, 5, 485, 144000, N'Active'),
(5587, 2437, 454, 5, 486, 144000, N'Active'),
(5588, 2438, 423, 1, 93, 90000, N'Active'),
(5589, 2438, 423, 1, 94, 90000, N'Active'),
(5590, 2438, 423, 1, 95, 90000, N'Active'),
(5591, 2439, 429, 1, 69, 90000, N'Active'),
(5592, 2440, 462, 4, 359, 90000, N'Active'),
(5593, 2440, 462, 4, 360, 90000, N'Active'),
(5594, 2441, 497, 3, 234, 75000, N'Active'),
(5595, 2441, 497, 3, 235, 75000, N'Active'),
(5596, 2441, 497, 3, 236, 75000, N'Active'),
(5597, 2441, 497, 3, 237, 75000, N'Active'),
(5598, 2442, 502, 3, 308, 90000, N'Cancelled'),
(5599, 2442, 502, 3, 309, 90000, N'Cancelled'),
(5600, 2443, 423, 1, 81, 90000, N'Active'),
(5601, 2443, 423, 1, 82, 90000, N'Active'),
(5602, 2444, 424, 2, 148, 90000, N'Active'),
(5603, 2445, 438, 4, 412, 108000, N'Active'),
(5604, 2445, 438, 4, 413, 108000, N'Active'),
(5605, 2445, 438, 4, 414, 108000, N'Active'),
(5606, 2446, 425, 5, 537, 144000, N'Active'),
(5607, 2447, 423, 1, 76, 90000, N'Active'),
(5608, 2447, 423, 1, 77, 90000, N'Active'),
(5609, 2448, 426, 4, 399, 108000, N'Active'),
(5610, 2448, 426, 4, 400, 108000, N'Active'),
(5611, 2448, 426, 4, 401, 108000, N'Active'),
(5612, 2448, 426, 4, 402, 108000, N'Active'),
(5613, 2448, 426, 4, 403, 108000, N'Active'),
(5614, 2448, 426, 4, 404, 108000, N'Active'),
(5615, 2449, 505, 1, 86, 90000, N'Active'),
(5616, 2449, 505, 1, 87, 90000, N'Active'),
(5617, 2449, 505, 1, 88, 90000, N'Active'),
(5618, 2449, 505, 1, 89, 90000, N'Active'),
(5619, 2450, 506, 4, 431, 108000, N'Active'),
(5620, 2450, 506, 4, 432, 108000, N'Active'),
(5621, 2451, 427, 3, 278, 90000, N'Active'),
(5622, 2451, 427, 3, 279, 90000, N'Active'),
(5623, 2452, 463, 1, 78, 90000, N'Active'),
(5624, 2453, 499, 2, 136, 75000, N'Active'),
(5625, 2453, 499, 2, 137, 75000, N'Active'),
(5626, 2453, 499, 2, 138, 75000, N'Active'),
(5627, 2453, 499, 2, 139, 75000, N'Active'),
(5628, 2453, 499, 2, 140, 75000, N'Active'),
(5629, 2453, 499, 2, 141, 75000, N'Active'),
(5630, 2454, 477, 1, 52, 90000, N'Active'),
(5631, 2455, 436, 2, 174, 90000, N'Active'),
(5632, 2455, 436, 2, 175, 90000, N'Active'),
(5633, 2455, 436, 2, 176, 90000, N'Active'),
(5634, 2455, 436, 2, 177, 90000, N'Active'),
(5635, 2455, 436, 2, 178, 90000, N'Active'),
(5636, 2455, 436, 2, 179, 90000, N'Active'),
(5637, 2456, 503, 4, 326, 90000, N'Active'),
(5638, 2457, 482, 2, 141, 75000, N'Active'),
(5639, 2457, 482, 2, 142, 75000, N'Active'),
(5640, 2458, 435, 3, 291, 90000, N'Active'),
(5641, 2458, 435, 3, 292, 90000, N'Active'),
(5642, 2458, 435, 3, 293, 90000, N'Active'),
(5643, 2458, 435, 3, 294, 90000, N'Active'),
(5644, 2458, 435, 3, 295, 90000, N'Active'),
(5645, 2458, 435, 3, 296, 90000, N'Active'),
(5646, 2459, 429, 1, 70, 90000, N'Active'),
(5647, 2459, 429, 1, 71, 90000, N'Active'),
(5648, 2459, 429, 1, 72, 90000, N'Active'),
(5649, 2460, 434, 1, 31, 75000, N'Active'),
(5650, 2460, 434, 1, 32, 75000, N'Active'),
(5651, 2460, 434, 1, 33, 75000, N'Active'),
(5652, 2460, 434, 1, 34, 75000, N'Active'),
(5653, 2460, 434, 1, 35, 75000, N'Active'),
(5654, 2461, 503, 4, 355, 90000, N'Active'),
(5655, 2461, 503, 4, 356, 90000, N'Active'),
(5656, 2462, 454, 5, 522, 144000, N'Active'),
(5657, 2462, 454, 5, 523, 144000, N'Active'),
(5658, 2463, 439, 3, 261, 90000, N'Active'),
(5659, 2463, 439, 3, 262, 90000, N'Active'),
(5660, 2463, 439, 3, 263, 90000, N'Active'),
(5661, 2464, 433, 4, 431, 108000, N'Active'),
(5662, 2464, 433, 4, 432, 108000, N'Active'),
(5663, 2465, 428, 2, 140, 75000, N'Active'),
(5664, 2465, 428, 2, 141, 75000, N'Active'),
(5665, 2466, 437, 5, 522, 144000, N'Active'),
(5666, 2466, 437, 5, 523, 144000, N'Active'),
(5667, 2467, 432, 5, 514, 144000, N'Active'),
(5668, 2468, 480, 2, 161, 90000, N'Active'),
(5669, 2468, 480, 2, 162, 90000, N'Active'),
(5670, 2469, 444, 5, 478, 120000, N'Active'),
(5671, 2470, 457, 2, 179, 90000, N'Active'),
(5672, 2470, 457, 2, 180, 90000, N'Active'),
(5673, 2471, 433, 4, 383, 108000, N'Active'),
(5674, 2472, 432, 5, 510, 144000, N'Active'),
(5675, 2472, 432, 5, 511, 144000, N'Active'),
(5676, 2473, 434, 1, 73, 90000, N'Active'),
(5677, 2473, 434, 1, 74, 90000, N'Active'),
(5678, 2473, 434, 1, 75, 90000, N'Active'),
(5679, 2474, 434, 1, 68, 90000, N'Active'),
(5680, 2474, 434, 1, 69, 90000, N'Active'),
(5681, 2474, 434, 1, 70, 90000, N'Active'),
(5682, 2475, 438, 4, 389, 108000, N'Active'),
(5683, 2475, 438, 4, 390, 108000, N'Active'),
(5684, 2476, 452, 1, 50, 90000, N'Active'),
(5685, 2476, 452, 1, 51, 90000, N'Active'),
(5686, 2476, 452, 1, 52, 90000, N'Active'),
(5687, 2476, 452, 1, 53, 90000, N'Active'),
(5688, 2477, 432, 5, 497, 144000, N'Active'),
(5689, 2477, 432, 5, 498, 144000, N'Active'),
(5690, 2478, 473, 5, 532, 144000, N'Active'),
(5691, 2478, 473, 5, 533, 144000, N'Active'),
(5692, 2479, 438, 4, 365, 108000, N'Active'),
(5693, 2479, 438, 4, 366, 108000, N'Active'),
(5694, 2480, 431, 2, 165, 90000, N'Active'),
(5695, 2480, 431, 2, 166, 90000, N'Active'),
(5696, 2481, 442, 4, 381, 108000, N'Active'),
(5697, 2481, 442, 4, 382, 108000, N'Active'),
(5698, 2481, 442, 4, 383, 108000, N'Active'),
(5699, 2481, 442, 4, 384, 108000, N'Active'),
(5700, 2482, 474, 1, 31, 75000, N'Active'),
(5701, 2482, 474, 1, 32, 75000, N'Active'),
(5702, 2483, 434, 1, 63, 90000, N'Active'),
(5703, 2483, 434, 1, 64, 90000, N'Active'),
(5704, 2483, 434, 1, 65, 90000, N'Active'),
(5705, 2483, 434, 1, 66, 90000, N'Active'),
(5706, 2484, 501, 1, 50, 90000, N'Active'),
(5707, 2484, 501, 1, 51, 90000, N'Active'),
(5708, 2484, 501, 1, 52, 90000, N'Active'),
(5709, 2485, 501, 1, 94, 90000, N'Active'),
(5710, 2486, 434, 1, 40, 90000, N'Active'),
(5711, 2486, 434, 1, 41, 90000, N'Active'),
(5712, 2487, 444, 5, 501, 144000, N'Active'),
(5713, 2487, 444, 5, 502, 144000, N'Active'),
(5714, 2488, 434, 1, 15, 75000, N'Active'),
(5715, 2488, 434, 1, 16, 75000, N'Active'),
(5716, 2488, 434, 1, 17, 75000, N'Active'),
(5717, 2488, 434, 1, 18, 75000, N'Active'),
(5718, 2488, 434, 1, 19, 75000, N'Active'),
(5719, 2489, 499, 2, 209, 90000, N'Cancelled'),
(5720, 2489, 499, 2, 210, 90000, N'Cancelled'),
(5721, 2490, 432, 5, 484, 144000, N'Active'),
(5722, 2490, 432, 5, 485, 144000, N'Active'),
(5723, 2490, 432, 5, 486, 144000, N'Active'),
(5724, 2491, 452, 1, 65, 90000, N'Active'),
(5725, 2491, 452, 1, 66, 90000, N'Active'),
(5726, 2491, 452, 1, 67, 90000, N'Active'),
(5727, 2492, 436, 2, 186, 90000, N'Active'),
(5728, 2492, 436, 2, 187, 90000, N'Active'),
(5729, 2493, 438, 4, 376, 108000, N'Active'),
(5730, 2494, 434, 1, 27, 75000, N'Active'),
(5731, 2495, 488, 1, 41, 90000, N'Active'),
(5732, 2495, 488, 1, 42, 90000, N'Active'),
(5733, 2496, 446, 2, 190, 90000, N'Cancelled'),
(5734, 2496, 446, 2, 191, 90000, N'Cancelled'),
(5735, 2496, 446, 2, 192, 90000, N'Cancelled'),
(5736, 2497, 435, 3, 278, 90000, N'Active'),
(5737, 2497, 435, 3, 279, 90000, N'Active'),
(5738, 2497, 435, 3, 280, 90000, N'Active'),
(5739, 2498, 450, 5, 537, 144000, N'Active'),
(5740, 2498, 450, 5, 538, 144000, N'Active'),
(5741, 2499, 434, 1, 79, 90000, N'Active'),
(5742, 2499, 434, 1, 80, 90000, N'Active'),
(5743, 2499, 434, 1, 81, 90000, N'Active'),
(5744, 2500, 437, 5, 509, 144000, N'Active'),
(5745, 2500, 437, 5, 510, 144000, N'Active'),
(5746, 2501, 437, 5, 473, 120000, N'Active'),
(5747, 2501, 437, 5, 474, 120000, N'Active'),
(5748, 2502, 440, 1, 74, 90000, N'Active'),
(5749, 2503, 434, 1, 42, 90000, N'Active'),
(5750, 2503, 434, 1, 43, 90000, N'Active'),
(5751, 2504, 435, 3, 247, 75000, N'Active'),
(5752, 2505, 437, 5, 528, 144000, N'Active'),
(5753, 2506, 434, 1, 101, 90000, N'Active'),
(5754, 2506, 434, 1, 102, 90000, N'Active'),
(5755, 2507, 473, 5, 486, 144000, N'Active'),
(5756, 2507, 473, 5, 487, 144000, N'Active'),
(5757, 2507, 473, 5, 488, 144000, N'Active'),
(5758, 2508, 445, 1, 31, 75000, N'Active'),
(5759, 2509, 444, 5, 470, 120000, N'Active'),
(5760, 2509, 444, 5, 471, 120000, N'Active'),
(5761, 2509, 444, 5, 472, 120000, N'Active'),
(5762, 2509, 444, 5, 473, 120000, N'Active'),
(5763, 2509, 444, 5, 474, 120000, N'Active'),
(5764, 2510, 445, 1, 78, 90000, N'Active'),
(5765, 2510, 445, 1, 79, 90000, N'Active'),
(5766, 2511, 437, 5, 506, 144000, N'Active'),
(5767, 2511, 437, 5, 507, 144000, N'Active'),
(5768, 2511, 437, 5, 508, 144000, N'Active'),
(5769, 2512, 436, 2, 125, 75000, N'Active'),
(5770, 2512, 436, 2, 126, 75000, N'Active'),
(5771, 2512, 436, 2, 127, 75000, N'Active'),
(5772, 2513, 504, 2, 134, 75000, N'Active'),
(5773, 2513, 504, 2, 135, 75000, N'Active'),
(5774, 2514, 442, 4, 378, 108000, N'Cancelled'),
(5775, 2514, 442, 4, 379, 108000, N'Cancelled'),
(5776, 2515, 444, 5, 535, 144000, N'Active'),
(5777, 2515, 444, 5, 536, 144000, N'Active'),
(5778, 2515, 444, 5, 537, 144000, N'Active'),
(5779, 2515, 444, 5, 538, 144000, N'Active'),
(5780, 2516, 504, 2, 155, 90000, N'Active'),
(5781, 2517, 459, 3, 294, 90000, N'Active'),
(5782, 2518, 451, 2, 174, 90000, N'Active'),
(5783, 2518, 451, 2, 175, 90000, N'Active'),
(5784, 2518, 451, 2, 176, 90000, N'Active'),
(5785, 2518, 451, 2, 177, 90000, N'Active'),
(5786, 2518, 451, 2, 178, 90000, N'Active'),
(5787, 2518, 451, 2, 179, 90000, N'Active'),
(5788, 2519, 450, 5, 532, 144000, N'Active'),
(5789, 2519, 450, 5, 533, 144000, N'Active'),
(5790, 2520, 443, 3, 281, 90000, N'Active'),
(5791, 2520, 443, 3, 282, 90000, N'Active'),
(5792, 2520, 443, 3, 283, 90000, N'Active'),
(5793, 2520, 443, 3, 284, 90000, N'Active'),
(5794, 2520, 443, 3, 285, 90000, N'Active'),
(5795, 2521, 494, 2, 197, 90000, N'Active'),
(5796, 2521, 494, 2, 198, 90000, N'Active'),
(5797, 2522, 499, 2, 186, 90000, N'Active'),
(5798, 2522, 499, 2, 187, 90000, N'Active'),
(5799, 2522, 499, 2, 188, 90000, N'Active'),
(5800, 2523, 439, 3, 293, 90000, N'Active'),
(5801, 2524, 441, 2, 198, 90000, N'Active'),
(5802, 2524, 441, 2, 199, 90000, N'Active'),
(5803, 2525, 488, 1, 64, 90000, N'Cancelled'),
(5804, 2525, 488, 1, 65, 90000, N'Cancelled'),
(5805, 2525, 488, 1, 66, 90000, N'Cancelled'),
(5806, 2525, 488, 1, 67, 90000, N'Cancelled'),
(5807, 2526, 443, 3, 243, 75000, N'Active'),
(5808, 2526, 443, 3, 244, 75000, N'Active'),
(5809, 2527, 446, 2, 189, 90000, N'Active'),
(5810, 2527, 446, 2, 190, 90000, N'Active'),
(5811, 2528, 444, 5, 506, 144000, N'Active'),
(5812, 2528, 444, 5, 507, 144000, N'Active'),
(5813, 2528, 444, 5, 508, 144000, N'Active'),
(5814, 2528, 444, 5, 509, 144000, N'Active'),
(5815, 2529, 444, 5, 496, 144000, N'Active'),
(5816, 2529, 444, 5, 497, 144000, N'Active'),
(5817, 2529, 444, 5, 498, 144000, N'Active'),
(5818, 2530, 445, 1, 54, 90000, N'Active'),
(5819, 2530, 445, 1, 55, 90000, N'Active'),
(5820, 2530, 445, 1, 56, 90000, N'Active'),
(5821, 2530, 445, 1, 57, 90000, N'Active'),
(5822, 2531, 450, 5, 501, 144000, N'Active'),
(5823, 2531, 450, 5, 502, 144000, N'Active'),
(5824, 2532, 447, 3, 236, 75000, N'Active'),
(5825, 2532, 447, 3, 237, 75000, N'Active'),
(5826, 2532, 447, 3, 238, 75000, N'Active'),
(5827, 2533, 442, 4, 340, 90000, N'Active'),
(5828, 2534, 450, 5, 465, 120000, N'Active'),
(5829, 2534, 450, 5, 466, 120000, N'Active'),
(5830, 2535, 447, 3, 272, 90000, N'Active'),
(5831, 2535, 447, 3, 273, 90000, N'Active'),
(5832, 2536, 442, 4, 414, 108000, N'Active'),
(5833, 2537, 446, 2, 153, 90000, N'Active'),
(5834, 2537, 446, 2, 154, 90000, N'Active'),
(5835, 2538, 449, 4, 392, 90000, N'Active'),
(5836, 2539, 442, 4, 364, 108000, N'Active'),
(5837, 2540, 475, 2, 161, 90000, N'Active'),
(5838, 2541, 491, 2, 163, 90000, N'Active'),
(5839, 2542, 443, 3, 237, 75000, N'Active'),
(5840, 2542, 443, 3, 238, 75000, N'Active'),
(5841, 2543, 450, 5, 487, 144000, N'Active'),
(5842, 2543, 450, 5, 488, 144000, N'Active'),
(5843, 2543, 450, 5, 489, 144000, N'Active'),
(5844, 2544, 509, 3, 294, 90000, N'Active'),
(5845, 2544, 509, 3, 295, 90000, N'Active'),
(5846, 2544, 509, 3, 296, 90000, N'Active'),
(5847, 2545, 446, 2, 170, 90000, N'Active'),
(5848, 2546, 498, 1, 45, 90000, N'Active'),
(5849, 2546, 498, 1, 46, 90000, N'Active'),
(5850, 2547, 449, 4, 416, 90000, N'Active'),
(5851, 2548, 443, 3, 303, 90000, N'Active'),
(5852, 2548, 443, 3, 304, 90000, N'Active'),
(5853, 2549, 443, 3, 293, 90000, N'Active'),
(5854, 2549, 443, 3, 294, 90000, N'Active'),
(5855, 2549, 443, 3, 295, 90000, N'Active'),
(5856, 2550, 498, 1, 71, 90000, N'Active'),
(5857, 2551, 446, 2, 152, 90000, N'Active'),
(5858, 2552, 445, 1, 105, 90000, N'Active'),
(5859, 2552, 445, 1, 106, 90000, N'Active'),
(5860, 2553, 447, 3, 323, 90000, N'Active'),
(5861, 2553, 447, 3, 324, 90000, N'Active'),
(5862, 2554, 472, 3, 275, 90000, N'Active'),
(5863, 2554, 472, 3, 276, 90000, N'Active'),
(5864, 2555, 446, 2, 198, 90000, N'Active'),
(5865, 2555, 446, 2, 199, 90000, N'Active'),
(5866, 2555, 446, 2, 200, 90000, N'Active'),
(5867, 2555, 446, 2, 201, 90000, N'Active'),
(5868, 2556, 446, 2, 202, 90000, N'Active'),
(5869, 2556, 446, 2, 203, 90000, N'Active'),
(5870, 2556, 446, 2, 204, 90000, N'Active'),
(5871, 2557, 450, 5, 534, 144000, N'Active'),
(5872, 2558, 445, 1, 97, 90000, N'Active'),
(5873, 2558, 445, 1, 98, 90000, N'Active'),
(5874, 2559, 466, 5, 476, 120000, N'Active'),
(5875, 2559, 466, 5, 477, 120000, N'Active'),
(5876, 2560, 447, 3, 241, 75000, N'Active'),
(5877, 2560, 447, 3, 242, 75000, N'Active'),
(5878, 2561, 462, 4, 411, 108000, N'Active'),
(5879, 2562, 509, 3, 256, 90000, N'Active'),
(5880, 2562, 509, 3, 257, 90000, N'Active'),
(5881, 2562, 509, 3, 258, 90000, N'Active'),
(5882, 2563, 499, 2, 165, 90000, N'Cancelled'),
(5883, 2564, 449, 4, 401, 90000, N'Active'),
(5884, 2564, 449, 4, 402, 90000, N'Active'),
(5885, 2564, 449, 4, 403, 90000, N'Active'),
(5886, 2565, 467, 4, 373, 108000, N'Active'),
(5887, 2565, 467, 4, 374, 108000, N'Active'),
(5888, 2566, 483, 5, 461, 120000, N'Active'),
(5889, 2566, 483, 5, 462, 120000, N'Active'),
(5890, 2567, 447, 3, 280, 90000, N'Active'),
(5891, 2567, 447, 3, 281, 90000, N'Active'),
(5892, 2567, 447, 3, 282, 90000, N'Active'),
(5893, 2567, 447, 3, 283, 90000, N'Active'),
(5894, 2568, 448, 1, 61, 90000, N'Active'),
(5895, 2568, 448, 1, 62, 90000, N'Active'),
(5896, 2568, 448, 1, 63, 90000, N'Active'),
(5897, 2568, 448, 1, 64, 90000, N'Active'),
(5898, 2568, 448, 1, 65, 90000, N'Active'),
(5899, 2569, 450, 5, 471, 120000, N'Active'),
(5900, 2569, 450, 5, 472, 120000, N'Active'),
(5901, 2569, 450, 5, 473, 120000, N'Active'),
(5902, 2570, 501, 1, 78, 90000, N'Active'),
(5903, 2570, 501, 1, 79, 90000, N'Active'),
(5904, 2570, 501, 1, 80, 90000, N'Active'),
(5905, 2570, 501, 1, 81, 90000, N'Active'),
(5906, 2571, 447, 3, 270, 90000, N'Active'),
(5907, 2571, 447, 3, 271, 90000, N'Active'),
(5908, 2572, 451, 2, 164, 90000, N'Cancelled'),
(5909, 2572, 451, 2, 165, 90000, N'Cancelled'),
(5910, 2573, 447, 3, 255, 90000, N'Active'),
(5911, 2574, 466, 5, 466, 120000, N'Active'),
(5912, 2574, 466, 5, 467, 120000, N'Active'),
(5913, 2574, 466, 5, 468, 120000, N'Active'),
(5914, 2575, 461, 5, 545, 144000, N'Active'),
(5915, 2576, 474, 1, 54, 90000, N'Active'),
(5916, 2577, 467, 4, 352, 90000, N'Active'),
(5917, 2577, 467, 4, 353, 90000, N'Active'),
(5918, 2578, 504, 2, 157, 90000, N'Active'),
(5919, 2578, 504, 2, 158, 90000, N'Active'),
(5920, 2579, 473, 5, 549, 144000, N'Active'),
(5921, 2579, 473, 5, 550, 144000, N'Active'),
(5922, 2580, 462, 4, 388, 108000, N'Active'),
(5923, 2580, 462, 4, 389, 108000, N'Active'),
(5924, 2580, 462, 4, 390, 108000, N'Active'),
(5925, 2581, 487, 3, 269, 90000, N'Active'),
(5926, 2581, 487, 3, 270, 90000, N'Active'),
(5927, 2582, 470, 2, 185, 90000, N'Active'),
(5928, 2582, 470, 2, 186, 90000, N'Active'),
(5929, 2583, 476, 3, 313, 90000, N'Active'),
(5930, 2583, 476, 3, 314, 90000, N'Active'),
(5931, 2584, 456, 3, 259, 90000, N'Active'),
(5932, 2584, 456, 3, 260, 90000, N'Active'),
(5933, 2585, 466, 5, 533, 144000, N'Active'),
(5934, 2585, 466, 5, 534, 144000, N'Active'),
(5935, 2585, 466, 5, 535, 144000, N'Active'),
(5936, 2585, 466, 5, 536, 144000, N'Active'),
(5937, 2585, 466, 5, 537, 144000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 5 26/11/2026: 164 hoa don (2 huy), 365 ve, doanh thu 35.832.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(2586, 3, 114, '2026-11-26T08:01:51', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 483 | Dune: Hành Tinh Cát - Phần Hai | 27/11 09:00 | Phòng 5 | E5 E6
(2587, 4, NULL, '2026-11-26T08:17:10', 300000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 452 | Trại Giam Hạnh Phúc | 26/11 09:00 | Phòng 1 | B5 B6 B7 B8
(2588, 4, 60, '2026-11-26T08:19:50', 288000, N'Paid', N'Cash', 300000, 20, 0, NULL, NULL, NULL), -- suat 495 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:00 | Phòng 5 | J4 J5
(2589, 4, NULL, '2026-11-26T08:20:24', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 507 | Godzilla Trừ Không | 27/11 21:15 | Phòng 5 | E7 E8
(2590, 3, 69, '2026-11-26T08:24:02', 108000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 503 | Godzilla Trừ Không | 27/11 18:30 | Phòng 4 | F9
(2591, 3, NULL, '2026-11-26T08:31:22', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 458 | Ngày Con Còn Mẹ | 26/11 11:30 | Phòng 1 | G7
(2592, 4, 108, '2026-11-26T08:38:48', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 452 | Trại Giam Hạnh Phúc | 26/11 09:00 | Phòng 1 | A10 A11
(2593, 3, NULL, '2026-11-26T08:39:17', 150000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 457 | Kiến Lé Phiêu Lưu Ké | 26/11 10:30 | Phòng 2 | B2 B3
(2594, 3, 42, '2026-11-26T08:46:28', 60000, N'Paid', N'Cash', 60000, 4, 30, NULL, NULL, NULL), -- suat 456 | Bí Kíp Luyện Cướp | 26/11 09:30 | Phòng 3 | E6
(2595, 3, NULL, '2026-11-26T08:48:13', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 455 | Ramayana: Khởi Nguồn Một Huyền Thoại | 26/11 09:15 | Phòng 4 | E6 E7
(2596, 4, 92, '2026-11-26T08:52:25', 150000, N'Paid', N'Card', NULL, 7, 0, NULL, NULL, NULL), -- suat 453 | Ma Mút Con Vượt Kỷ Băng Hà | 26/11 09:00 | Phòng 2 | B7 B8
(2597, 4, 113, '2026-11-26T08:54:46', 432000, N'Paid', N'Transfer', NULL, 30, 0, NULL, NULL, NULL), -- suat 461 | Godzilla Trừ Không | 26/11 12:15 | Phòng 5 | J3 J4 J5
(2598, 4, NULL, '2026-11-26T08:55:34', 216000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 462 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 26/11 12:30 | Phòng 4 | E5 E6
(2599, 4, 83, '2026-11-26T09:03:46', 150000, N'Paid', N'Cash', 150000, 7, 0, NULL, NULL, NULL), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | A7 A8
(2600, 4, NULL, '2026-11-26T09:07:51', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 504 | Bò Sữa Bay | 27/11 19:30 | Phòng 2 | H6 H7
(2601, 3, NULL, '2026-11-26T09:12:43', 450000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 456 | Bí Kíp Luyện Cướp | 26/11 09:30 | Phòng 3 | F4 F5 F6 F7 F8
(2602, 4, NULL, '2026-11-26T09:14:45', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 456 | Bí Kíp Luyện Cướp | 26/11 09:30 | Phòng 3 | E5
(2603, 3, NULL, '2026-11-26T09:15:27', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 462 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 26/11 12:30 | Phòng 4 | F1 F2 F3
(2604, 3, 78, '2026-11-26T09:17:35', 300000, N'Paid', N'Cash', 500000, 15, 0, NULL, NULL, NULL), -- suat 458 | Ngày Con Còn Mẹ | 26/11 11:30 | Phòng 1 | C5 C6 C7 C8
(2605, 4, NULL, '2026-11-26T09:20:22', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 457 | Kiến Lé Phiêu Lưu Ké | 26/11 10:30 | Phòng 2 | G3 G4 G5
(2606, 3, 25, '2026-11-26T09:24:41', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 504 | Bò Sữa Bay | 27/11 19:30 | Phòng 2 | H3
(2607, 4, NULL, '2026-11-26T09:29:59', 144000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 495 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:00 | Phòng 5 | E7
(2608, 4, NULL, '2026-11-26T09:32:38', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | F5 F6 F7
(2609, 3, NULL, '2026-11-26T09:48:02', 270000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 496 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:30 | Phòng 4 | A4 A5 A6
(2610, 4, NULL, '2026-11-26T09:49:51', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 461 | Godzilla Trừ Không | 26/11 12:15 | Phòng 5 | K6 K7
(2611, 3, NULL, '2026-11-26T09:50:33', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 465 | Ngày Con Còn Mẹ | 26/11 14:30 | Phòng 2 | H3 H4
(2612, 4, NULL, '2026-11-26T09:52:09', 300000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 463 | Trại Giam Hạnh Phúc | 26/11 13:45 | Phòng 1 | C4 C5 C6 C7
(2613, 4, 31, '2026-11-26T10:12:59', 75000, N'Paid', N'Card', NULL, 3, 0, NULL, NULL, NULL), -- suat 465 | Ngày Con Còn Mẹ | 26/11 14:30 | Phòng 2 | C6
(2614, 3, NULL, '2026-11-26T10:13:10', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 458 | Ngày Con Còn Mẹ | 26/11 11:30 | Phòng 1 | G4 G5
(2615, 3, 88, '2026-11-26T10:17:46', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 472 | Ngày Con Còn Mẹ | 26/11 18:15 | Phòng 3 | F3 F4 F5
(2616, 3, 23, '2026-11-26T10:20:26', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | D2 D3
(2617, 3, NULL, '2026-11-26T10:23:02', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 497 | Chị Chị Em Em 3 | 27/11 16:00 | Phòng 3 | H6
(2618, 4, 30, '2026-11-26T10:35:58', 180000, N'Paid', N'Card', NULL, 9, 0, NULL, NULL, NULL), -- suat 462 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 26/11 12:30 | Phòng 4 | C5 C6
(2619, 3, NULL, '2026-11-26T10:36:02', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 459 | Kẻ Hồi Sinh | 26/11 12:00 | Phòng 3 | G7 G8 G9
(2620, 3, NULL, '2026-11-26T10:38:06', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 460 | Chàng Mèo Mang Mũ | 26/11 12:15 | Phòng 2 | J5 J6
(2621, 4, 43, '2026-11-26T10:40:50', 288000, N'Paid', N'Cash', 300000, 20, 0, NULL, NULL, NULL), -- suat 507 | Godzilla Trừ Không | 27/11 21:15 | Phòng 5 | K6 K7
(2622, 4, 35, '2026-11-26T10:45:51', 432000, N'Paid', N'Cash', 432000, 30, 0, NULL, NULL, NULL), -- suat 462 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 26/11 12:30 | Phòng 4 | H5 H6 H7 H8
(2623, 3, NULL, '2026-11-26T10:56:28', 75000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 470 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 26/11 16:45 | Phòng 2 | B7
(2624, 3, NULL, '2026-11-26T10:57:14', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 497 | Chị Chị Em Em 3 | 27/11 16:00 | Phòng 3 | G9
(2625, 4, NULL, '2026-11-26T11:01:01', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 463 | Trại Giam Hạnh Phúc | 26/11 13:45 | Phòng 1 | F6 F7 F8
(2626, 4, 99, '2026-11-26T11:04:38', 270000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | F7 F8 F9
(2627, 3, NULL, '2026-11-26T11:12:29', 324000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 462 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 26/11 12:30 | Phòng 4 | G4 G5 G6
(2628, 3, 94, '2026-11-26T11:13:03', 432000, N'Paid', N'Card', NULL, 30, 0, NULL, NULL, NULL), -- suat 466 | Dune: Hành Tinh Cát - Phần Hai | 26/11 15:00 | Phòng 5 | G8 G9 G10
(2629, 4, 66, '2026-11-26T11:17:07', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 463 | Trại Giam Hạnh Phúc | 26/11 13:45 | Phòng 1 | E7 E8
(2630, 4, NULL, '2026-11-26T11:29:48', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 472 | Ngày Con Còn Mẹ | 26/11 18:15 | Phòng 3 | H5 H6
(2631, 3, NULL, '2026-11-26T11:31:50', 240000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 483 | Dune: Hành Tinh Cát - Phần Hai | 27/11 09:00 | Phòng 5 | A5 A6
(2632, 3, 94, '2026-11-26T11:32:14', 180000, N'Paid', N'Card', NULL, 12, 0, NULL, NULL, NULL), -- suat 472 | Ngày Con Còn Mẹ | 26/11 18:15 | Phòng 3 | D9 D10
(2633, 3, NULL, '2026-11-26T11:32:46', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | H5
(2634, 3, NULL, '2026-11-26T11:34:01', 216000, N'Paid', N'Cash', 220000, 0, 0, NULL, NULL, NULL), -- suat 462 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 26/11 12:30 | Phòng 4 | F9 F10
(2635, 3, NULL, '2026-11-26T11:36:00', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 460 | Chàng Mèo Mang Mũ | 26/11 12:15 | Phòng 2 | G1
(2636, 4, 30, '2026-11-26T11:53:51', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 503 | Godzilla Trừ Không | 27/11 18:30 | Phòng 4 | H8 H9
(2637, 3, 77, '2026-11-26T11:54:34', 180000, N'Paid', N'Cash', 180000, 18, 0, NULL, NULL, NULL), -- suat 464 | Thiên Đường Tăm Tối | 26/11 14:00 | Phòng 3 | J1 J2
(2638, 3, NULL, '2026-11-26T12:11:22', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 470 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 26/11 16:45 | Phòng 2 | C9 C10
(2639, 4, NULL, '2026-11-26T12:11:33', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | F3
(2640, 4, NULL, '2026-11-26T12:13:08', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 474 | Trại Giam Hạnh Phúc | 26/11 18:30 | Phòng 1 | J1 J2
(2641, 3, 69, '2026-11-26T12:17:02', 576000, N'Paid', N'Transfer', NULL, 40, 0, NULL, NULL, NULL), -- suat 466 | Dune: Hành Tinh Cát - Phần Hai | 26/11 15:00 | Phòng 5 | F6 F7 F8 F9
(2642, 3, NULL, '2026-11-26T12:22:56', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 463 | Trại Giam Hạnh Phúc | 26/11 13:45 | Phòng 1 | D5 D6
(2643, 4, NULL, '2026-11-26T12:23:46', 300000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 474 | Trại Giam Hạnh Phúc | 26/11 18:30 | Phòng 1 | C3 C4 C5 C6
(2644, 3, NULL, '2026-11-26T12:24:43', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 466 | Dune: Hành Tinh Cát - Phần Hai | 26/11 15:00 | Phòng 5 | B9 B10
(2645, 3, 78, '2026-11-26T12:27:50', 432000, N'Paid', N'Card', NULL, 30, 0, NULL, NULL, NULL), -- suat 473 | Godzilla Trừ Không | 26/11 18:15 | Phòng 5 | G7 G8 G9
(2646, 3, NULL, '2026-11-26T12:29:05', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 465 | Ngày Con Còn Mẹ | 26/11 14:30 | Phòng 2 | G7 G8
(2647, 3, 33, '2026-11-26T12:29:27', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 463 | Trại Giam Hạnh Phúc | 26/11 13:45 | Phòng 1 | H9 H10
(2648, 3, NULL, '2026-11-26T12:32:36', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 509 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:45 | Phòng 3 | E8
(2649, 4, NULL, '2026-11-26T12:36:30', 216000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 471 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 26/11 18:00 | Phòng 4 | H4 H5
(2650, 3, NULL, '2026-11-26T12:40:42', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | H8 H9
(2651, 4, NULL, '2026-11-26T12:47:50', 216000, N'Paid', N'Cash', 220000, 0, 0, NULL, NULL, NULL), -- suat 467 | Godzilla Trừ Không | 26/11 15:30 | Phòng 4 | E3 E4
(2652, 4, NULL, '2026-11-26T12:48:29', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 472 | Ngày Con Còn Mẹ | 26/11 18:15 | Phòng 3 | E3 E4
(2653, 4, NULL, '2026-11-26T12:51:29', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 468 | Clayface | 26/11 16:00 | Phòng 3 | J5 J6
(2654, 3, 67, '2026-11-26T12:53:04', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 463 | Trại Giam Hạnh Phúc | 26/11 13:45 | Phòng 1 | F2 F3
(2655, 3, NULL, '2026-11-26T13:02:13', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 467 | Godzilla Trừ Không | 26/11 15:30 | Phòng 4 | A11
(2656, 4, 18, '2026-11-26T13:08:09', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 469 | Bò Sữa Bay | 26/11 16:15 | Phòng 1 | G10 G11
(2657, 4, NULL, '2026-11-26T13:08:18', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 463 | Trại Giam Hạnh Phúc | 26/11 13:45 | Phòng 1 | B7 B8
(2658, 3, 107, '2026-11-26T13:13:19', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 463 | Trại Giam Hạnh Phúc | 26/11 13:45 | Phòng 1 | H2
(2659, 3, NULL, '2026-11-26T13:17:56', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 490 | Godzilla Trừ Không | 27/11 12:15 | Phòng 5 | F1 F2
(2660, 4, 92, '2026-11-26T13:19:56', 216000, N'Paid', N'Cash', 250000, 15, 0, NULL, NULL, NULL), -- suat 467 | Godzilla Trừ Không | 26/11 15:30 | Phòng 4 | D10 D11
(2661, 4, NULL, '2026-11-26T13:23:49', 150000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 464 | Thiên Đường Tăm Tối | 26/11 14:00 | Phòng 3 | A5 A6
(2662, 3, 93, '2026-11-26T13:29:37', 100000, N'Paid', N'Transfer', NULL, 10, 80, NULL, NULL, NULL), -- suat 465 | Ngày Con Còn Mẹ | 26/11 14:30 | Phòng 2 | J11 J12
(2663, 4, NULL, '2026-11-26T13:32:55', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 486 | Ma Mút Con Vượt Kỷ Băng Hà | 27/11 11:15 | Phòng 2 | F11
(2664, 3, NULL, '2026-11-26T13:41:34', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 476 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 20:30 | Phòng 3 | D4 D5
(2665, 4, NULL, '2026-11-26T13:44:11', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | E7
(2666, 4, NULL, '2026-11-26T13:46:14', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 504 | Bò Sữa Bay | 27/11 19:30 | Phòng 2 | G4 G5 G6
(2667, 4, NULL, '2026-11-26T13:47:32', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 478 | Bí Kíp Luyện Cướp | 26/11 21:00 | Phòng 4 | B5 B6
(2668, 4, 86, '2026-11-26T13:48:38', 278000, N'Paid', N'Cash', 300000, 19, 46, NULL, NULL, NULL), -- suat 467 | Godzilla Trừ Không | 26/11 15:30 | Phòng 4 | F5 F6 F7
(2669, 3, NULL, '2026-11-26T13:48:43', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | D4 D5
(2670, 3, NULL, '2026-11-26T13:49:59', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | F11 F12
(2671, 3, NULL, '2026-11-26T13:58:55', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 466 | Dune: Hành Tinh Cát - Phần Hai | 26/11 15:00 | Phòng 5 | G5 G6
(2672, 4, NULL, '2026-11-26T13:59:38', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 473 | Godzilla Trừ Không | 26/11 18:15 | Phòng 5 | J10 J11
(2673, 4, NULL, '2026-11-26T14:02:26', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 472 | Ngày Con Còn Mẹ | 26/11 18:15 | Phòng 3 | C6 C7
(2674, 3, NULL, '2026-11-26T14:05:22', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 472 | Ngày Con Còn Mẹ | 26/11 18:15 | Phòng 3 | H7 H8
(2675, 4, 34, '2026-11-26T14:06:00', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 471 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 26/11 18:00 | Phòng 4 | G6 G7
(2676, 3, NULL, '2026-11-26T14:12:37', 180000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | J9 J10
(2677, 3, 93, '2026-11-26T14:13:25', 480000, N'Paid', N'Card', NULL, 24, 0, NULL, NULL, NULL), -- suat 479 | Dune: Hành Tinh Cát - Phần Hai | 26/11 21:00 | Phòng 5 | D9 D10 D11 D12
(2678, 3, 56, '2026-11-26T14:16:25', 225000, N'Paid', N'Card', NULL, 11, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | C4 C5 C6
(2679, 3, NULL, '2026-11-26T14:18:51', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | H7
(2680, 3, NULL, '2026-11-26T14:22:44', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 471 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 26/11 18:00 | Phòng 4 | F6 F7
(2681, 3, NULL, '2026-11-26T14:28:42', 432000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 471 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 26/11 18:00 | Phòng 4 | F1 F2 F3 F4
(2682, 3, NULL, '2026-11-26T14:29:26', 75000, N'Paid', N'Cash', 75000, 0, 0, NULL, NULL, NULL), -- suat 504 | Bò Sữa Bay | 27/11 19:30 | Phòng 2 | B7
(2683, 3, NULL, '2026-11-26T14:30:06', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | G6 G7
(2684, 3, NULL, '2026-11-26T14:31:14', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 506 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 21:00 | Phòng 4 | E5 E6
(2685, 3, NULL, '2026-11-26T14:36:10', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 478 | Bí Kíp Luyện Cướp | 26/11 21:00 | Phòng 4 | G3 G4
(2686, 3, 69, '2026-11-26T14:41:28', 180000, N'Paid', N'Cash', 180000, 18, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | J7 J8
(2687, 4, 55, '2026-11-26T14:48:16', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 480 | Trại Buôn Người | 26/11 21:15 | Phòng 2 | G2 G3
(2688, 3, NULL, '2026-11-26T14:50:38', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 476 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 20:30 | Phòng 3 | E6
(2689, 4, NULL, '2026-11-26T14:53:14', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 478 | Bí Kíp Luyện Cướp | 26/11 21:00 | Phòng 4 | H1 H2 H3
(2690, 5, NULL, '2026-11-26T15:00:47', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 474 | Trại Giam Hạnh Phúc | 26/11 18:30 | Phòng 1 | F9 F10
(2691, 5, NULL, '2026-11-26T15:11:02', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | B8 B9 B10
(2692, 6, 8, '2026-11-26T15:12:50', 300000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 505 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:00 | Phòng 1 | C5 C6 C7 C8
(2693, 5, 79, '2026-11-26T15:13:37', 360000, N'Paid', N'Cash', 500000, 18, 0, NULL, NULL, NULL), -- suat 473 | Godzilla Trừ Không | 26/11 18:15 | Phòng 5 | C5 C6 C7
(2694, 6, NULL, '2026-11-26T15:15:33', 225000, N'Paid', N'Cash', 225000, 0, 0, NULL, NULL, NULL), -- suat 497 | Chị Chị Em Em 3 | 27/11 16:00 | Phòng 3 | B1 B2 B3
(2695, 5, NULL, '2026-11-26T15:15:45', 375000, N'Paid', N'Cash', 380000, 0, 0, NULL, NULL, NULL), -- suat 487 | Ngày Con Còn Mẹ | 27/11 11:15 | Phòng 3 | B5 B6 B7 B8 B9
(2696, 5, NULL, '2026-11-26T15:18:58', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 480 | Trại Buôn Người | 26/11 21:15 | Phòng 2 | G12
(2697, 6, 42, '2026-11-26T15:20:16', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 472 | Ngày Con Còn Mẹ | 26/11 18:15 | Phòng 3 | G9 G10
(2698, 6, 46, '2026-11-26T15:23:41', 180000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 474 | Trại Giam Hạnh Phúc | 26/11 18:30 | Phòng 1 | J9 J10
(2699, 6, NULL, '2026-11-26T15:27:10', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | D5 D6
(2700, 5, NULL, '2026-11-26T15:29:08', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 477 | Chị Chị Em Em 3 | 26/11 21:00 | Phòng 1 | E6 E7 E8
(2701, 5, NULL, '2026-11-26T15:31:40', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 504 | Bò Sữa Bay | 27/11 19:30 | Phòng 2 | G1 G2 G3
(2702, 5, 113, '2026-11-26T15:34:41', 288000, N'Paid', N'Cash', 300000, 20, 0, NULL, NULL, NULL), -- suat 473 | Godzilla Trừ Không | 26/11 18:15 | Phòng 5 | H2 H3
(2703, 6, NULL, '2026-11-26T15:35:50', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 478 | Bí Kíp Luyện Cướp | 26/11 21:00 | Phòng 4 | G6 G7
(2704, 5, NULL, '2026-11-26T15:42:24', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 476 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 20:30 | Phòng 3 | G2 G3
(2705, 6, NULL, '2026-11-26T15:47:52', 240000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | C6 C7
(2706, 5, NULL, '2026-11-26T15:51:17', 432000, N'Paid', N'Cash', 440000, 0, 0, NULL, NULL, NULL), -- suat 473 | Godzilla Trừ Không | 26/11 18:15 | Phòng 5 | J7 J8 J9
(2707, 6, 45, '2026-11-26T15:52:14', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 473 | Godzilla Trừ Không | 26/11 18:15 | Phòng 5 | H7 H8
(2708, 5, 30, '2026-11-26T16:03:40', 180000, N'Cancelled', N'Transfer', NULL, 18, 0, N'Lỗi thanh toán', '2026-11-26T16:06:19', 5), -- suat 474 | Trại Giam Hạnh Phúc | 26/11 18:30 | Phòng 1 | J11 J12
(2709, 6, NULL, '2026-11-26T16:04:02', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | B11 B12
(2710, 5, NULL, '2026-11-26T16:04:20', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 472 | Ngày Con Còn Mẹ | 26/11 18:15 | Phòng 3 | H9 H10
(2711, 6, NULL, '2026-11-26T16:13:52', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 477 | Chị Chị Em Em 3 | 26/11 21:00 | Phòng 1 | F4 F5
(2712, 5, 13, '2026-11-26T16:15:52', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 477 | Chị Chị Em Em 3 | 26/11 21:00 | Phòng 1 | D2 D3
(2713, 5, 72, '2026-11-26T16:25:46', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | D7
(2714, 5, NULL, '2026-11-26T16:28:01', 864000, N'Paid', N'Cash', 900000, 0, 0, NULL, NULL, NULL), -- suat 473 | Godzilla Trừ Không | 26/11 18:15 | Phòng 5 | F1 F2 F3 F4 F5 F6
(2715, 6, 8, '2026-11-26T16:30:11', 90000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 493 | Trại Giam Hạnh Phúc | 27/11 13:45 | Phòng 1 | F1
(2716, 6, NULL, '2026-11-26T16:31:45', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 473 | Godzilla Trừ Không | 26/11 18:15 | Phòng 5 | G3 G4 G5
(2717, 6, NULL, '2026-11-26T16:34:50', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 476 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 20:30 | Phòng 3 | H11
(2718, 5, NULL, '2026-11-26T16:41:11', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 490 | Godzilla Trừ Không | 27/11 12:15 | Phòng 5 | G9 G10
(2719, 5, 107, '2026-11-26T16:42:03', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | E9 E10 E11 E12
(2720, 6, 24, '2026-11-26T16:43:24', 130000, N'Cancelled', N'Transfer', NULL, 9, 50, N'Khách đổi ý', '2026-11-26T17:08:47', 6), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | H6 H7
(2721, 5, NULL, '2026-11-26T16:45:24', 324000, N'Paid', N'Cash', 350000, 0, 0, NULL, NULL, NULL), -- suat 471 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 26/11 18:00 | Phòng 4 | D10 D11 D12
(2722, 5, NULL, '2026-11-26T16:46:41', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | F10 F11
(2723, 6, NULL, '2026-11-26T16:49:31', 480000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 473 | Godzilla Trừ Không | 26/11 18:15 | Phòng 5 | C1 C2 C3 C4
(2724, 6, 75, '2026-11-26T16:51:03', 288000, N'Paid', N'Card', NULL, 20, 0, NULL, NULL, NULL), -- suat 483 | Dune: Hành Tinh Cát - Phần Hai | 27/11 09:00 | Phòng 5 | F11 F12
(2725, 6, NULL, '2026-11-26T16:51:04', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 476 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 20:30 | Phòng 3 | D7 D8
(2726, 5, NULL, '2026-11-26T16:51:15', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 474 | Trại Giam Hạnh Phúc | 26/11 18:30 | Phòng 1 | F6 F7 F8
(2727, 5, NULL, '2026-11-26T17:01:17', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 474 | Trại Giam Hạnh Phúc | 26/11 18:30 | Phòng 1 | D5 D6
(2728, 5, NULL, '2026-11-26T17:04:16', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 474 | Trại Giam Hạnh Phúc | 26/11 18:30 | Phòng 1 | F3 F4
(2729, 5, NULL, '2026-11-26T17:17:54', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 503 | Godzilla Trừ Không | 27/11 18:30 | Phòng 4 | C4 C5
(2730, 5, 28, '2026-11-26T17:20:03', 432000, N'Paid', N'Transfer', NULL, 30, 0, NULL, NULL, NULL), -- suat 479 | Dune: Hành Tinh Cát - Phần Hai | 26/11 21:00 | Phòng 5 | K4 K5 K6
(2731, 5, 113, '2026-11-26T17:24:39', 180000, N'Paid', N'Cash', 180000, 9, 0, NULL, NULL, NULL), -- suat 484 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 09:15 | Phòng 4 | B11 B12
(2732, 5, NULL, '2026-11-26T17:30:22', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 486 | Ma Mút Con Vượt Kỷ Băng Hà | 27/11 11:15 | Phòng 2 | H7
(2733, 5, NULL, '2026-11-26T17:30:28', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 479 | Dune: Hành Tinh Cát - Phần Hai | 26/11 21:00 | Phòng 5 | E1
(2734, 6, NULL, '2026-11-26T17:43:53', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 475 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 19:00 | Phòng 2 | G11 G12
(2735, 5, NULL, '2026-11-26T17:47:54', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 508 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 27/11 21:45 | Phòng 2 | G4 G5 G6 G7
(2736, 6, 67, '2026-11-26T17:51:06', 288000, N'Paid', N'Cash', 500000, 20, 0, NULL, NULL, NULL), -- suat 479 | Dune: Hành Tinh Cát - Phần Hai | 26/11 21:00 | Phòng 5 | G6 G7
(2737, 5, NULL, '2026-11-26T17:55:58', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 480 | Trại Buôn Người | 26/11 21:15 | Phòng 2 | J3 J4
(2738, 6, 96, '2026-11-26T18:00:46', 450000, N'Paid', N'Cash', 450000, 31, 0, NULL, NULL, NULL), -- suat 474 | Trại Giam Hạnh Phúc | 26/11 18:30 | Phòng 1 | G3 G4 G5 G6 G7
(2739, 5, NULL, '2026-11-26T18:21:53', 75000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 491 | Hexed: Thế Giới Phép Thuật | 27/11 12:45 | Phòng 2 | A6
(2740, 6, NULL, '2026-11-26T18:46:28', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 476 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 20:30 | Phòng 3 | H9 H10
(2741, 5, NULL, '2026-11-26T18:48:27', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 479 | Dune: Hành Tinh Cát - Phần Hai | 26/11 21:00 | Phòng 5 | L3 L4
(2742, 5, 25, '2026-11-26T19:16:22', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 476 | Mẹ Mìn: Giao Kèo Với Quỷ | 26/11 20:30 | Phòng 3 | G8 G9
(2743, 5, NULL, '2026-11-26T19:31:42', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 480 | Trại Buôn Người | 26/11 21:15 | Phòng 2 | H4
(2744, 5, NULL, '2026-11-26T19:37:36', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 478 | Bí Kíp Luyện Cướp | 26/11 21:00 | Phòng 4 | F5 F6 F7 F8
(2745, 6, NULL, '2026-11-26T19:45:33', 225000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | C1 C2 C3
(2746, 5, 49, '2026-11-26T20:05:56', 144000, N'Paid', N'Cash', 150000, 10, 0, NULL, NULL, NULL), -- suat 479 | Dune: Hành Tinh Cát - Phần Hai | 26/11 21:00 | Phòng 5 | G8
(2747, 6, NULL, '2026-11-26T20:45:06', 150000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 509 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:45 | Phòng 3 | C6 C7
(2748, 6, NULL, '2026-11-26T20:56:06', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 480 | Trại Buôn Người | 26/11 21:15 | Phòng 2 | E9 E10
(2749, 5, NULL, '2026-11-26T21:06:03', 225000, N'Paid', N'Cash', 225000, 0, 0, NULL, NULL, NULL); -- suat 497 | Chị Chị Em Em 3 | 27/11 16:00 | Phòng 3 | C5 C6 C7
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(5938, 2586, 483, 5, 485, 144000, N'Active'),
(5939, 2586, 483, 5, 486, 144000, N'Active'),
(5940, 2587, 452, 1, 17, 75000, N'Active'),
(5941, 2587, 452, 1, 18, 75000, N'Active'),
(5942, 2587, 452, 1, 19, 75000, N'Active'),
(5943, 2587, 452, 1, 20, 75000, N'Active'),
(5944, 2588, 495, 5, 532, 144000, N'Active'),
(5945, 2588, 495, 5, 533, 144000, N'Active'),
(5946, 2589, 507, 5, 487, 144000, N'Active'),
(5947, 2589, 507, 5, 488, 144000, N'Active'),
(5948, 2590, 503, 4, 393, 108000, N'Active'),
(5949, 2591, 458, 1, 79, 90000, N'Active'),
(5950, 2592, 452, 1, 10, 75000, N'Active'),
(5951, 2592, 452, 1, 11, 75000, N'Active'),
(5952, 2593, 457, 2, 122, 75000, N'Active'),
(5953, 2593, 457, 2, 123, 75000, N'Active'),
(5954, 2594, 456, 3, 270, 90000, N'Active'),
(5955, 2595, 455, 4, 378, 108000, N'Active'),
(5956, 2595, 455, 4, 379, 108000, N'Active'),
(5957, 2596, 453, 2, 127, 75000, N'Active'),
(5958, 2596, 453, 2, 128, 75000, N'Active'),
(5959, 2597, 461, 5, 531, 144000, N'Active'),
(5960, 2597, 461, 5, 532, 144000, N'Active'),
(5961, 2597, 461, 5, 533, 144000, N'Active'),
(5962, 2598, 462, 4, 377, 108000, N'Active'),
(5963, 2598, 462, 4, 378, 108000, N'Active'),
(5964, 2599, 499, 2, 115, 75000, N'Active'),
(5965, 2599, 499, 2, 116, 75000, N'Active'),
(5966, 2600, 504, 2, 198, 90000, N'Active'),
(5967, 2600, 504, 2, 199, 90000, N'Active'),
(5968, 2601, 456, 3, 280, 90000, N'Active'),
(5969, 2601, 456, 3, 281, 90000, N'Active'),
(5970, 2601, 456, 3, 282, 90000, N'Active'),
(5971, 2601, 456, 3, 283, 90000, N'Active'),
(5972, 2601, 456, 3, 284, 90000, N'Active'),
(5973, 2602, 456, 3, 269, 90000, N'Active'),
(5974, 2603, 462, 4, 385, 108000, N'Active'),
(5975, 2603, 462, 4, 386, 108000, N'Active'),
(5976, 2603, 462, 4, 387, 108000, N'Active'),
(5977, 2604, 458, 1, 29, 75000, N'Active'),
(5978, 2604, 458, 1, 30, 75000, N'Active'),
(5979, 2604, 458, 1, 31, 75000, N'Active'),
(5980, 2604, 458, 1, 32, 75000, N'Active'),
(5981, 2605, 457, 2, 183, 90000, N'Active'),
(5982, 2605, 457, 2, 184, 90000, N'Active'),
(5983, 2605, 457, 2, 185, 90000, N'Active'),
(5984, 2606, 504, 2, 195, 90000, N'Active'),
(5985, 2607, 495, 5, 487, 144000, N'Active'),
(5986, 2608, 501, 1, 65, 90000, N'Active'),
(5987, 2608, 501, 1, 66, 90000, N'Active'),
(5988, 2608, 501, 1, 67, 90000, N'Active'),
(5989, 2609, 496, 4, 328, 90000, N'Active'),
(5990, 2609, 496, 4, 329, 90000, N'Active'),
(5991, 2609, 496, 4, 330, 90000, N'Active'),
(5992, 2610, 461, 5, 546, 144000, N'Active'),
(5993, 2610, 461, 5, 547, 144000, N'Active'),
(5994, 2611, 465, 2, 195, 90000, N'Active'),
(5995, 2611, 465, 2, 196, 90000, N'Active'),
(5996, 2612, 463, 1, 28, 75000, N'Active'),
(5997, 2612, 463, 1, 29, 75000, N'Active'),
(5998, 2612, 463, 1, 30, 75000, N'Active'),
(5999, 2612, 463, 1, 31, 75000, N'Active'),
(6000, 2613, 465, 2, 138, 75000, N'Active'),
(6001, 2614, 458, 1, 76, 90000, N'Active'),
(6002, 2614, 458, 1, 77, 90000, N'Active'),
(6003, 2615, 472, 3, 279, 90000, N'Active'),
(6004, 2615, 472, 3, 280, 90000, N'Active'),
(6005, 2615, 472, 3, 281, 90000, N'Active'),
(6006, 2616, 475, 2, 146, 90000, N'Active'),
(6007, 2616, 475, 2, 147, 90000, N'Active'),
(6008, 2617, 497, 3, 306, 90000, N'Active'),
(6009, 2618, 462, 4, 353, 90000, N'Active'),
(6010, 2618, 462, 4, 354, 90000, N'Active'),
(6011, 2619, 459, 3, 295, 90000, N'Active'),
(6012, 2619, 459, 3, 296, 90000, N'Active'),
(6013, 2619, 459, 3, 297, 90000, N'Active'),
(6014, 2620, 460, 2, 209, 90000, N'Active'),
(6015, 2620, 460, 2, 210, 90000, N'Active'),
(6016, 2621, 507, 5, 546, 144000, N'Active'),
(6017, 2621, 507, 5, 547, 144000, N'Active'),
(6018, 2622, 462, 4, 413, 108000, N'Active'),
(6019, 2622, 462, 4, 414, 108000, N'Active'),
(6020, 2622, 462, 4, 415, 108000, N'Active'),
(6021, 2622, 462, 4, 416, 108000, N'Active'),
(6022, 2623, 470, 2, 127, 75000, N'Active'),
(6023, 2624, 497, 3, 297, 90000, N'Active'),
(6024, 2625, 463, 1, 66, 90000, N'Active'),
(6025, 2625, 463, 1, 67, 90000, N'Active'),
(6026, 2625, 463, 1, 68, 90000, N'Active'),
(6027, 2626, 475, 2, 175, 90000, N'Active'),
(6028, 2626, 475, 2, 176, 90000, N'Active'),
(6029, 2626, 475, 2, 177, 90000, N'Active'),
(6030, 2627, 462, 4, 400, 108000, N'Active'),
(6031, 2627, 462, 4, 401, 108000, N'Active'),
(6032, 2627, 462, 4, 402, 108000, N'Active'),
(6033, 2628, 466, 5, 512, 144000, N'Active'),
(6034, 2628, 466, 5, 513, 144000, N'Active'),
(6035, 2628, 466, 5, 514, 144000, N'Active'),
(6036, 2629, 463, 1, 55, 90000, N'Active'),
(6037, 2629, 463, 1, 56, 90000, N'Active'),
(6038, 2630, 472, 3, 305, 90000, N'Active'),
(6039, 2630, 472, 3, 306, 90000, N'Active'),
(6040, 2631, 483, 5, 437, 120000, N'Active'),
(6041, 2631, 483, 5, 438, 120000, N'Active'),
(6042, 2632, 472, 3, 261, 90000, N'Active'),
(6043, 2632, 472, 3, 262, 90000, N'Active'),
(6044, 2633, 500, 5, 521, 144000, N'Active'),
(6045, 2634, 462, 4, 393, 108000, N'Active'),
(6046, 2634, 462, 4, 394, 108000, N'Active'),
(6047, 2635, 460, 2, 181, 90000, N'Active'),
(6048, 2636, 503, 4, 416, 108000, N'Active'),
(6049, 2636, 503, 4, 417, 108000, N'Active'),
(6050, 2637, 464, 3, 313, 90000, N'Active'),
(6051, 2637, 464, 3, 314, 90000, N'Active'),
(6052, 2638, 470, 2, 141, 75000, N'Active'),
(6053, 2638, 470, 2, 142, 75000, N'Active'),
(6054, 2639, 501, 1, 63, 90000, N'Active'),
(6055, 2640, 474, 1, 97, 90000, N'Active'),
(6056, 2640, 474, 1, 98, 90000, N'Active'),
(6057, 2641, 466, 5, 498, 144000, N'Active'),
(6058, 2641, 466, 5, 499, 144000, N'Active'),
(6059, 2641, 466, 5, 500, 144000, N'Active'),
(6060, 2641, 466, 5, 501, 144000, N'Active'),
(6061, 2642, 463, 1, 41, 90000, N'Active'),
(6062, 2642, 463, 1, 42, 90000, N'Active'),
(6063, 2643, 474, 1, 27, 75000, N'Active'),
(6064, 2643, 474, 1, 28, 75000, N'Active'),
(6065, 2643, 474, 1, 29, 75000, N'Active'),
(6066, 2643, 474, 1, 30, 75000, N'Active'),
(6067, 2644, 466, 5, 453, 120000, N'Active'),
(6068, 2644, 466, 5, 454, 120000, N'Active'),
(6069, 2645, 473, 5, 511, 144000, N'Active'),
(6070, 2645, 473, 5, 512, 144000, N'Active'),
(6071, 2645, 473, 5, 513, 144000, N'Active'),
(6072, 2646, 465, 2, 187, 90000, N'Active'),
(6073, 2646, 465, 2, 188, 90000, N'Active'),
(6074, 2647, 463, 1, 93, 90000, N'Active'),
(6075, 2647, 463, 1, 94, 90000, N'Active'),
(6076, 2648, 509, 3, 272, 90000, N'Active'),
(6077, 2649, 471, 4, 412, 108000, N'Active'),
(6078, 2649, 471, 4, 413, 108000, N'Active'),
(6079, 2650, 475, 2, 200, 90000, N'Active'),
(6080, 2650, 475, 2, 201, 90000, N'Active'),
(6081, 2651, 467, 4, 375, 108000, N'Active'),
(6082, 2651, 467, 4, 376, 108000, N'Active'),
(6083, 2652, 472, 3, 267, 90000, N'Active'),
(6084, 2652, 472, 3, 268, 90000, N'Active'),
(6085, 2653, 468, 3, 317, 90000, N'Active'),
(6086, 2653, 468, 3, 318, 90000, N'Active'),
(6087, 2654, 463, 1, 62, 90000, N'Active'),
(6088, 2654, 463, 1, 63, 90000, N'Active'),
(6089, 2655, 467, 4, 335, 90000, N'Active'),
(6090, 2656, 469, 1, 82, 90000, N'Active'),
(6091, 2656, 469, 1, 83, 90000, N'Active'),
(6092, 2657, 463, 1, 19, 75000, N'Active'),
(6093, 2657, 463, 1, 20, 75000, N'Active'),
(6094, 2658, 463, 1, 86, 90000, N'Active'),
(6095, 2659, 490, 5, 493, 144000, N'Active'),
(6096, 2659, 490, 5, 494, 144000, N'Active'),
(6097, 2660, 467, 4, 370, 108000, N'Active'),
(6098, 2660, 467, 4, 371, 108000, N'Active'),
(6099, 2661, 464, 3, 221, 75000, N'Active'),
(6100, 2661, 464, 3, 222, 75000, N'Active'),
(6101, 2662, 465, 2, 215, 90000, N'Active'),
(6102, 2662, 465, 2, 216, 90000, N'Active'),
(6103, 2663, 486, 2, 179, 90000, N'Active'),
(6104, 2664, 476, 3, 256, 90000, N'Active'),
(6105, 2664, 476, 3, 257, 90000, N'Active'),
(6106, 2665, 475, 2, 163, 90000, N'Active'),
(6107, 2666, 504, 2, 184, 90000, N'Active'),
(6108, 2666, 504, 2, 185, 90000, N'Active'),
(6109, 2666, 504, 2, 186, 90000, N'Active'),
(6110, 2667, 478, 4, 341, 75000, N'Active'),
(6111, 2667, 478, 4, 342, 75000, N'Active'),
(6112, 2668, 467, 4, 389, 108000, N'Active'),
(6113, 2668, 467, 4, 390, 108000, N'Active'),
(6114, 2668, 467, 4, 391, 108000, N'Active'),
(6115, 2669, 475, 2, 148, 90000, N'Active'),
(6116, 2669, 475, 2, 149, 90000, N'Active'),
(6117, 2670, 501, 1, 71, 90000, N'Active'),
(6118, 2670, 501, 1, 72, 90000, N'Active'),
(6119, 2671, 466, 5, 509, 144000, N'Active'),
(6120, 2671, 466, 5, 510, 144000, N'Active'),
(6121, 2672, 473, 5, 538, 144000, N'Active'),
(6122, 2672, 473, 5, 539, 144000, N'Active'),
(6123, 2673, 472, 3, 246, 75000, N'Active'),
(6124, 2673, 472, 3, 247, 75000, N'Active'),
(6125, 2674, 472, 3, 307, 90000, N'Active'),
(6126, 2674, 472, 3, 308, 90000, N'Active'),
(6127, 2675, 471, 4, 402, 108000, N'Active'),
(6128, 2675, 471, 4, 403, 108000, N'Active'),
(6129, 2676, 475, 2, 213, 90000, N'Active'),
(6130, 2676, 475, 2, 214, 90000, N'Active'),
(6131, 2677, 479, 5, 477, 120000, N'Active'),
(6132, 2677, 479, 5, 478, 120000, N'Active'),
(6133, 2677, 479, 5, 479, 120000, N'Active'),
(6134, 2677, 479, 5, 480, 120000, N'Active'),
(6135, 2678, 501, 1, 28, 75000, N'Active'),
(6136, 2678, 501, 1, 29, 75000, N'Active'),
(6137, 2678, 501, 1, 30, 75000, N'Active'),
(6138, 2679, 475, 2, 199, 90000, N'Active'),
(6139, 2680, 471, 4, 390, 108000, N'Active'),
(6140, 2680, 471, 4, 391, 108000, N'Active'),
(6141, 2681, 471, 4, 385, 108000, N'Active'),
(6142, 2681, 471, 4, 386, 108000, N'Active'),
(6143, 2681, 471, 4, 387, 108000, N'Active'),
(6144, 2681, 471, 4, 388, 108000, N'Active'),
(6145, 2682, 504, 2, 127, 75000, N'Active'),
(6146, 2683, 475, 2, 186, 90000, N'Active'),
(6147, 2683, 475, 2, 187, 90000, N'Active'),
(6148, 2684, 506, 4, 377, 108000, N'Active'),
(6149, 2684, 506, 4, 378, 108000, N'Active'),
(6150, 2685, 478, 4, 399, 90000, N'Active'),
(6151, 2685, 478, 4, 400, 90000, N'Active'),
(6152, 2686, 475, 2, 211, 90000, N'Active'),
(6153, 2686, 475, 2, 212, 90000, N'Active'),
(6154, 2687, 480, 2, 182, 90000, N'Active'),
(6155, 2687, 480, 2, 183, 90000, N'Active'),
(6156, 2688, 476, 3, 270, 90000, N'Active'),
(6157, 2689, 478, 4, 409, 90000, N'Active'),
(6158, 2689, 478, 4, 410, 90000, N'Active'),
(6159, 2689, 478, 4, 411, 90000, N'Active'),
(6160, 2690, 474, 1, 69, 90000, N'Active'),
(6161, 2690, 474, 1, 70, 90000, N'Active'),
(6162, 2691, 475, 2, 128, 75000, N'Active'),
(6163, 2691, 475, 2, 129, 75000, N'Active'),
(6164, 2691, 475, 2, 130, 75000, N'Active'),
(6165, 2692, 505, 1, 29, 75000, N'Active'),
(6166, 2692, 505, 1, 30, 75000, N'Active'),
(6167, 2692, 505, 1, 31, 75000, N'Active'),
(6168, 2692, 505, 1, 32, 75000, N'Active'),
(6169, 2693, 473, 5, 461, 120000, N'Active'),
(6170, 2693, 473, 5, 462, 120000, N'Active'),
(6171, 2693, 473, 5, 463, 120000, N'Active'),
(6172, 2694, 497, 3, 229, 75000, N'Active'),
(6173, 2694, 497, 3, 230, 75000, N'Active'),
(6174, 2694, 497, 3, 231, 75000, N'Active'),
(6175, 2695, 487, 3, 233, 75000, N'Active'),
(6176, 2695, 487, 3, 234, 75000, N'Active'),
(6177, 2695, 487, 3, 235, 75000, N'Active'),
(6178, 2695, 487, 3, 236, 75000, N'Active'),
(6179, 2695, 487, 3, 237, 75000, N'Active'),
(6180, 2696, 480, 2, 192, 90000, N'Active'),
(6181, 2697, 472, 3, 297, 90000, N'Active'),
(6182, 2697, 472, 3, 298, 90000, N'Active'),
(6183, 2698, 474, 1, 105, 90000, N'Active'),
(6184, 2698, 474, 1, 106, 90000, N'Active'),
(6185, 2699, 501, 1, 41, 90000, N'Active'),
(6186, 2699, 501, 1, 42, 90000, N'Active'),
(6187, 2700, 477, 1, 54, 90000, N'Active'),
(6188, 2700, 477, 1, 55, 90000, N'Active'),
(6189, 2700, 477, 1, 56, 90000, N'Active'),
(6190, 2701, 504, 2, 181, 90000, N'Active'),
(6191, 2701, 504, 2, 182, 90000, N'Active'),
(6192, 2701, 504, 2, 183, 90000, N'Active'),
(6193, 2702, 473, 5, 518, 144000, N'Active'),
(6194, 2702, 473, 5, 519, 144000, N'Active'),
(6195, 2703, 478, 4, 402, 90000, N'Active'),
(6196, 2703, 478, 4, 403, 90000, N'Active'),
(6197, 2704, 476, 3, 290, 90000, N'Active'),
(6198, 2704, 476, 3, 291, 90000, N'Active'),
(6199, 2705, 500, 5, 462, 120000, N'Active'),
(6200, 2705, 500, 5, 463, 120000, N'Active'),
(6201, 2706, 473, 5, 535, 144000, N'Active'),
(6202, 2706, 473, 5, 536, 144000, N'Active'),
(6203, 2706, 473, 5, 537, 144000, N'Active'),
(6204, 2707, 473, 5, 523, 144000, N'Active'),
(6205, 2707, 473, 5, 524, 144000, N'Active'),
(6206, 2708, 474, 1, 107, 90000, N'Cancelled'),
(6207, 2708, 474, 1, 108, 90000, N'Cancelled'),
(6208, 2709, 475, 2, 131, 75000, N'Active'),
(6209, 2709, 475, 2, 132, 75000, N'Active'),
(6210, 2710, 472, 3, 309, 90000, N'Active'),
(6211, 2710, 472, 3, 310, 90000, N'Active'),
(6212, 2711, 477, 1, 64, 90000, N'Active'),
(6213, 2711, 477, 1, 65, 90000, N'Active'),
(6214, 2712, 477, 1, 38, 90000, N'Active'),
(6215, 2712, 477, 1, 39, 90000, N'Active'),
(6216, 2713, 475, 2, 151, 90000, N'Active'),
(6217, 2714, 473, 5, 493, 144000, N'Active'),
(6218, 2714, 473, 5, 494, 144000, N'Active'),
(6219, 2714, 473, 5, 495, 144000, N'Active'),
(6220, 2714, 473, 5, 496, 144000, N'Active'),
(6221, 2714, 473, 5, 497, 144000, N'Active'),
(6222, 2714, 473, 5, 498, 144000, N'Active'),
(6223, 2715, 493, 1, 61, 90000, N'Active'),
(6224, 2716, 473, 5, 507, 144000, N'Active'),
(6225, 2716, 473, 5, 508, 144000, N'Active'),
(6226, 2716, 473, 5, 509, 144000, N'Active'),
(6227, 2717, 476, 3, 311, 90000, N'Active'),
(6228, 2718, 490, 5, 513, 144000, N'Active'),
(6229, 2718, 490, 5, 514, 144000, N'Active'),
(6230, 2719, 475, 2, 165, 90000, N'Active'),
(6231, 2719, 475, 2, 166, 90000, N'Active'),
(6232, 2719, 475, 2, 167, 90000, N'Active'),
(6233, 2719, 475, 2, 168, 90000, N'Active'),
(6234, 2720, 499, 2, 198, 90000, N'Cancelled'),
(6235, 2720, 499, 2, 199, 90000, N'Cancelled'),
(6236, 2721, 471, 4, 370, 108000, N'Active'),
(6237, 2721, 471, 4, 371, 108000, N'Active'),
(6238, 2721, 471, 4, 372, 108000, N'Active'),
(6239, 2722, 475, 2, 178, 90000, N'Active'),
(6240, 2722, 475, 2, 179, 90000, N'Active'),
(6241, 2723, 473, 5, 457, 120000, N'Active'),
(6242, 2723, 473, 5, 458, 120000, N'Active'),
(6243, 2723, 473, 5, 459, 120000, N'Active'),
(6244, 2723, 473, 5, 460, 120000, N'Active'),
(6245, 2724, 483, 5, 503, 144000, N'Active'),
(6246, 2724, 483, 5, 504, 144000, N'Active'),
(6247, 2725, 476, 3, 259, 90000, N'Active'),
(6248, 2725, 476, 3, 260, 90000, N'Active'),
(6249, 2726, 474, 1, 66, 90000, N'Active'),
(6250, 2726, 474, 1, 67, 90000, N'Active'),
(6251, 2726, 474, 1, 68, 90000, N'Active'),
(6252, 2727, 474, 1, 41, 90000, N'Active'),
(6253, 2727, 474, 1, 42, 90000, N'Active'),
(6254, 2728, 474, 1, 63, 90000, N'Active'),
(6255, 2728, 474, 1, 64, 90000, N'Active'),
(6256, 2729, 503, 4, 352, 90000, N'Active'),
(6257, 2729, 503, 4, 353, 90000, N'Active'),
(6258, 2730, 479, 5, 544, 144000, N'Active'),
(6259, 2730, 479, 5, 545, 144000, N'Active'),
(6260, 2730, 479, 5, 546, 144000, N'Active'),
(6261, 2731, 484, 4, 347, 90000, N'Active'),
(6262, 2731, 484, 4, 348, 90000, N'Active'),
(6263, 2732, 486, 2, 199, 90000, N'Active'),
(6264, 2733, 479, 5, 481, 144000, N'Active'),
(6265, 2734, 475, 2, 191, 90000, N'Active'),
(6266, 2734, 475, 2, 192, 90000, N'Active'),
(6267, 2735, 508, 2, 184, 90000, N'Active'),
(6268, 2735, 508, 2, 185, 90000, N'Active'),
(6269, 2735, 508, 2, 186, 90000, N'Active'),
(6270, 2735, 508, 2, 187, 90000, N'Active'),
(6271, 2736, 479, 5, 510, 144000, N'Active'),
(6272, 2736, 479, 5, 511, 144000, N'Active'),
(6273, 2737, 480, 2, 207, 90000, N'Active'),
(6274, 2737, 480, 2, 208, 90000, N'Active'),
(6275, 2738, 474, 1, 75, 90000, N'Active'),
(6276, 2738, 474, 1, 76, 90000, N'Active'),
(6277, 2738, 474, 1, 77, 90000, N'Active'),
(6278, 2738, 474, 1, 78, 90000, N'Active'),
(6279, 2738, 474, 1, 79, 90000, N'Active'),
(6280, 2739, 491, 2, 114, 75000, N'Active'),
(6281, 2740, 476, 3, 309, 90000, N'Active'),
(6282, 2740, 476, 3, 310, 90000, N'Active'),
(6283, 2741, 479, 5, 555, 144000, N'Active'),
(6284, 2741, 479, 5, 556, 144000, N'Active'),
(6285, 2742, 476, 3, 296, 90000, N'Active'),
(6286, 2742, 476, 3, 297, 90000, N'Active'),
(6287, 2743, 480, 2, 196, 90000, N'Active'),
(6288, 2744, 478, 4, 389, 90000, N'Active'),
(6289, 2744, 478, 4, 390, 90000, N'Active'),
(6290, 2744, 478, 4, 391, 90000, N'Active'),
(6291, 2744, 478, 4, 392, 90000, N'Active'),
(6292, 2745, 501, 1, 25, 75000, N'Active'),
(6293, 2745, 501, 1, 26, 75000, N'Active'),
(6294, 2745, 501, 1, 27, 75000, N'Active'),
(6295, 2746, 479, 5, 512, 144000, N'Active'),
(6296, 2747, 509, 3, 246, 75000, N'Active'),
(6297, 2747, 509, 3, 247, 75000, N'Active'),
(6298, 2748, 480, 2, 165, 90000, N'Active'),
(6299, 2748, 480, 2, 166, 90000, N'Active'),
(6300, 2749, 497, 3, 245, 75000, N'Active'),
(6301, 2749, 497, 3, 246, 75000, N'Active'),
(6302, 2749, 497, 3, 247, 75000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ----- Thứ 6 27/11/2026: 180 hoa don (6 huy), 418 ve, doanh thu 40.398.000 d -----
SET IDENTITY_INSERT BOOKING ON;
INSERT INTO BOOKING (BookingID, AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod, CashGiven, PointsEarned, PointsUsed, CancelReason, CancelledAt, CancelledBy) VALUES
(2750, 6, NULL, '2026-11-27T08:04:17', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 483 | Dune: Hành Tinh Cát - Phần Hai | 27/11 09:00 | Phòng 5 | H3
(2751, 6, NULL, '2026-11-27T08:07:32', 375000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 481 | Trại Giam Hạnh Phúc | 27/11 09:00 | Phòng 1 | C5 C6 C7 C8 C9
(2752, 7, NULL, '2026-11-27T08:18:56', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 482 | Hexed: Thế Giới Phép Thuật | 27/11 09:00 | Phòng 2 | E6 E7
(2753, 7, NULL, '2026-11-27T08:21:13', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 482 | Hexed: Thế Giới Phép Thuật | 27/11 09:00 | Phòng 2 | J1 J2
(2754, 6, NULL, '2026-11-27T08:22:07', 576000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 483 | Dune: Hành Tinh Cát - Phần Hai | 27/11 09:00 | Phòng 5 | H8 H9 H10 H11
(2755, 6, NULL, '2026-11-27T08:27:48', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 483 | Dune: Hành Tinh Cát - Phần Hai | 27/11 09:00 | Phòng 5 | G5 G6
(2756, 7, NULL, '2026-11-27T08:30:53', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 481 | Trại Giam Hạnh Phúc | 27/11 09:00 | Phòng 1 | D9
(2757, 8, NULL, '2026-11-27T08:31:46', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 483 | Dune: Hành Tinh Cát - Phần Hai | 27/11 09:00 | Phòng 5 | E1
(2758, 8, NULL, '2026-11-27T08:32:00', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 481 | Trại Giam Hạnh Phúc | 27/11 09:00 | Phòng 1 | D2
(2759, 7, 67, '2026-11-27T08:40:17', 324000, N'Paid', N'Card', NULL, 22, 0, NULL, NULL, NULL), -- suat 484 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 09:15 | Phòng 4 | F1 F2 F3
(2760, 8, NULL, '2026-11-27T08:40:54', 216000, N'Paid', N'Cash', 500000, 0, 0, NULL, NULL, NULL), -- suat 496 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:30 | Phòng 4 | F9 F10
(2761, 8, NULL, '2026-11-27T08:43:02', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 490 | Godzilla Trừ Không | 27/11 12:15 | Phòng 5 | L9 L10
(2762, 8, 46, '2026-11-27T08:43:25', 90000, N'Cancelled', N'Transfer', NULL, 6, 0, N'Sự cố phòng chiếu', '2026-11-27T09:24:42', 1), -- suat 481 | Trại Giam Hạnh Phúc | 27/11 09:00 | Phòng 1 | F7
(2763, 8, 25, '2026-11-27T08:43:33', 75000, N'Paid', N'Cash', 75000, 3, 0, NULL, NULL, NULL), -- suat 482 | Hexed: Thế Giới Phép Thuật | 27/11 09:00 | Phòng 2 | A5
(2764, 6, 110, '2026-11-27T08:43:50', 240000, N'Cancelled', N'Transfer', NULL, 16, 30, N'Khách đổi ý', '2026-11-27T09:14:27', 1), -- suat 481 | Trại Giam Hạnh Phúc | 27/11 09:00 | Phòng 1 | H6 H7 H8
(2765, 7, NULL, '2026-11-27T08:55:52', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 485 | Kiến Lé Phiêu Lưu Ké | 27/11 09:30 | Phòng 3 | E2 E3
(2766, 7, NULL, '2026-11-27T09:06:47', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | H1 H2 H3
(2767, 7, NULL, '2026-11-27T09:08:09', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 486 | Ma Mút Con Vượt Kỷ Băng Hà | 27/11 11:15 | Phòng 2 | D3 D4
(2768, 7, NULL, '2026-11-27T09:13:57', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 488 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 11:30 | Phòng 1 | E11 E12
(2769, 6, NULL, '2026-11-27T09:33:23', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 487 | Ngày Con Còn Mẹ | 27/11 11:15 | Phòng 3 | J1 J2
(2770, 6, 50, '2026-11-27T09:40:17', 270000, N'Paid', N'Card', NULL, 13, 0, NULL, NULL, NULL), -- suat 489 | Ramayana: Khởi Nguồn Một Huyền Thoại | 27/11 12:15 | Phòng 4 | B8 B9 B10
(2771, 6, NULL, '2026-11-27T09:46:36', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 493 | Trại Giam Hạnh Phúc | 27/11 13:45 | Phòng 1 | E9 E10
(2772, 6, NULL, '2026-11-27T09:59:44', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 486 | Ma Mút Con Vượt Kỷ Băng Hà | 27/11 11:15 | Phòng 2 | D6 D7
(2773, 8, 66, '2026-11-27T10:04:51', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 487 | Ngày Con Còn Mẹ | 27/11 11:15 | Phòng 3 | F5 F6
(2774, 6, NULL, '2026-11-27T10:09:37', 720000, N'Cancelled', N'Cash', 750000, 0, 0, N'Khách đổi ý', '2026-11-27T10:33:09', 6), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | A7 A8 A9 A10 A11 A12
(2775, 8, 1, '2026-11-27T10:09:39', 216000, N'Paid', N'Cash', 300000, 15, 0, NULL, NULL, NULL), -- suat 496 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:30 | Phòng 4 | F2 F3
(2776, 7, NULL, '2026-11-27T10:10:59', 120000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 490 | Godzilla Trừ Không | 27/11 12:15 | Phòng 5 | B11
(2777, 8, 72, '2026-11-27T10:13:09', 480000, N'Paid', N'Card', NULL, 24, 0, NULL, NULL, NULL), -- suat 490 | Godzilla Trừ Không | 27/11 12:15 | Phòng 5 | D9 D10 D11 D12
(2778, 8, NULL, '2026-11-27T10:14:46', 432000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | G5 G6 G7
(2779, 8, 90, '2026-11-27T10:21:33', 180000, N'Paid', N'Card', NULL, 18, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | J3 J4
(2780, 6, 67, '2026-11-27T10:29:24', 360000, N'Paid', N'Transfer', NULL, 25, 0, NULL, NULL, NULL), -- suat 492 | Bí Kíp Luyện Cướp | 27/11 13:30 | Phòng 3 | G5 G6 G7 G8
(2781, 7, NULL, '2026-11-27T10:30:05', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 492 | Bí Kíp Luyện Cướp | 27/11 13:30 | Phòng 3 | E4 E5
(2782, 8, NULL, '2026-11-27T10:30:32', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | C9 C10
(2783, 7, NULL, '2026-11-27T10:36:14', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | G9 G10
(2784, 8, NULL, '2026-11-27T10:36:44', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 488 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 11:30 | Phòng 1 | F2 F3 F4
(2785, 6, NULL, '2026-11-27T10:37:58', 240000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 490 | Godzilla Trừ Không | 27/11 12:15 | Phòng 5 | A11 A12
(2786, 6, NULL, '2026-11-27T10:40:28', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 498 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 16:15 | Phòng 1 | J5 J6
(2787, 7, NULL, '2026-11-27T10:40:52', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 498 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 16:15 | Phòng 1 | J3 J4
(2788, 6, NULL, '2026-11-27T10:43:02', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 490 | Godzilla Trừ Không | 27/11 12:15 | Phòng 5 | J4 J5
(2789, 8, NULL, '2026-11-27T10:51:27', 720000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 490 | Godzilla Trừ Không | 27/11 12:15 | Phòng 5 | F4 F5 F6 F7 F8
(2790, 7, NULL, '2026-11-27T10:54:48', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 491 | Hexed: Thế Giới Phép Thuật | 27/11 12:45 | Phòng 2 | H7 H8
(2791, 8, 108, '2026-11-27T10:58:57', 180000, N'Paid', N'Cash', 200000, 18, 0, NULL, NULL, NULL), -- suat 491 | Hexed: Thế Giới Phép Thuật | 27/11 12:45 | Phòng 2 | J7 J8
(2792, 7, NULL, '2026-11-27T11:00:57', 720000, N'Cancelled', N'Cash', 720000, 0, 0, N'Nhầm suất / ghế', '2026-11-27T11:35:41', 7), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | H6 H7 H8 H9 H10
(2793, 7, 44, '2026-11-27T11:02:18', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | F6 F7
(2794, 6, 117, '2026-11-27T11:02:43', 10000, N'Paid', N'Transfer', NULL, 0, 170, NULL, NULL, NULL), -- suat 503 | Godzilla Trừ Không | 27/11 18:30 | Phòng 4 | A9 A10
(2795, 8, NULL, '2026-11-27T11:05:21', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 495 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:00 | Phòng 5 | G3 G4 G5 G6
(2796, 8, 72, '2026-11-27T11:09:01', 144000, N'Paid', N'Transfer', NULL, 10, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | J6
(2797, 6, NULL, '2026-11-27T11:10:26', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 495 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:00 | Phòng 5 | F5 F6
(2798, 8, 42, '2026-11-27T11:12:58', 288000, N'Paid', N'Transfer', NULL, 20, 0, NULL, NULL, NULL), -- suat 495 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:00 | Phòng 5 | E1 E2
(2799, 8, NULL, '2026-11-27T11:13:44', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 493 | Trại Giam Hạnh Phúc | 27/11 13:45 | Phòng 1 | G8 G9
(2800, 8, 64, '2026-11-27T11:18:58', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 493 | Trại Giam Hạnh Phúc | 27/11 13:45 | Phòng 1 | D6 D7
(2801, 7, 77, '2026-11-27T11:19:38', 216000, N'Paid', N'Transfer', NULL, 21, 0, NULL, NULL, NULL), -- suat 496 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:30 | Phòng 4 | J7 J8
(2802, 6, NULL, '2026-11-27T11:20:58', 225000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | B5 B6 B7
(2803, 8, NULL, '2026-11-27T11:30:13', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 494 | Ngày Con Còn Mẹ | 27/11 15:00 | Phòng 2 | F11
(2804, 7, NULL, '2026-11-27T11:34:13', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 490 | Godzilla Trừ Không | 27/11 12:15 | Phòng 5 | E10 E11 E12
(2805, 6, 98, '2026-11-27T11:36:31', 150000, N'Paid', N'Cash', 500000, 7, 0, NULL, NULL, NULL), -- suat 492 | Bí Kíp Luyện Cướp | 27/11 13:30 | Phòng 3 | C9 C10
(2806, 6, 36, '2026-11-27T11:40:36', 180000, N'Paid', N'Cash', 500000, 12, 36, NULL, NULL, NULL), -- suat 496 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:30 | Phòng 4 | G10 G11
(2807, 7, NULL, '2026-11-27T11:40:44', 216000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 496 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:30 | Phòng 4 | H9 H10
(2808, 7, 36, '2026-11-27T11:50:22', 120000, N'Paid', N'Transfer', NULL, 6, 0, NULL, NULL, NULL), -- suat 490 | Godzilla Trừ Không | 27/11 12:15 | Phòng 5 | B1
(2809, 8, NULL, '2026-11-27T11:50:30', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 495 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:00 | Phòng 5 | J6 J7
(2810, 7, 29, '2026-11-27T12:00:53', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 493 | Trại Giam Hạnh Phúc | 27/11 13:45 | Phòng 1 | F6 F7
(2811, 7, 23, '2026-11-27T12:02:40', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL), -- suat 494 | Ngày Con Còn Mẹ | 27/11 15:00 | Phòng 2 | D6 D7
(2812, 7, NULL, '2026-11-27T12:05:55', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | F4 F5 F6
(2813, 7, NULL, '2026-11-27T12:09:31', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 491 | Hexed: Thế Giới Phép Thuật | 27/11 12:45 | Phòng 2 | F2 F3
(2814, 7, 70, '2026-11-27T12:14:27', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 492 | Bí Kíp Luyện Cướp | 27/11 13:30 | Phòng 3 | D3
(2815, 6, 114, '2026-11-27T12:16:08', 144000, N'Paid', N'Cash', 200000, 10, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | J7
(2816, 6, NULL, '2026-11-27T12:28:52', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | D3 D4 D5
(2817, 8, 46, '2026-11-27T12:36:10', 100000, N'Paid', N'Card', NULL, 5, 200, NULL, NULL, NULL), -- suat 492 | Bí Kíp Luyện Cướp | 27/11 13:30 | Phòng 3 | C5 C6 C7 C8
(2818, 7, NULL, '2026-11-27T12:36:26', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 493 | Trại Giam Hạnh Phúc | 27/11 13:45 | Phòng 1 | G2 G3
(2819, 6, 42, '2026-11-27T12:45:24', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 504 | Bò Sữa Bay | 27/11 19:30 | Phòng 2 | F6 F7 F8
(2820, 7, NULL, '2026-11-27T12:51:11', 144000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 495 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:00 | Phòng 5 | H12
(2821, 6, NULL, '2026-11-27T12:52:16', 120000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 495 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:00 | Phòng 5 | C10
(2822, 7, NULL, '2026-11-27T12:53:30', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 495 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:00 | Phòng 5 | B6 B7
(2823, 6, NULL, '2026-11-27T12:54:43', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | J1 J2
(2824, 6, NULL, '2026-11-27T12:57:24', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | H4 H5
(2825, 6, NULL, '2026-11-27T13:00:52', 270000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | H7 H8 H9
(2826, 7, NULL, '2026-11-27T13:00:57', 240000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 507 | Godzilla Trừ Không | 27/11 21:15 | Phòng 5 | D5 D6
(2827, 8, NULL, '2026-11-27T13:02:02', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 502 | Điểm Mù | 27/11 18:30 | Phòng 3 | E2 E3 E4 E5
(2828, 6, NULL, '2026-11-27T13:03:07', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 494 | Ngày Con Còn Mẹ | 27/11 15:00 | Phòng 2 | F5 F6
(2829, 6, 116, '2026-11-27T13:04:45', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | E6 E7 E8
(2830, 6, NULL, '2026-11-27T13:06:49', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 496 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:30 | Phòng 4 | J5 J6
(2831, 6, NULL, '2026-11-27T13:07:02', 540000, N'Paid', N'Cash', 540000, 0, 0, NULL, NULL, NULL), -- suat 494 | Ngày Con Còn Mẹ | 27/11 15:00 | Phòng 2 | G3 G4 G5 G6 G7 G8
(2832, 8, NULL, '2026-11-27T13:07:29', 288000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 507 | Godzilla Trừ Không | 27/11 21:15 | Phòng 5 | L3 L4
(2833, 6, 86, '2026-11-27T13:09:52', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 493 | Trại Giam Hạnh Phúc | 27/11 13:45 | Phòng 1 | H9 H10
(2834, 7, NULL, '2026-11-27T13:10:24', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | D1 D2
(2835, 6, NULL, '2026-11-27T13:12:40', 144000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | E5
(2836, 6, NULL, '2026-11-27T13:15:03', 576000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | E9 E10 E11 E12
(2837, 6, NULL, '2026-11-27T13:16:27', 90000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | E12
(2838, 7, 21, '2026-11-27T13:21:46', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 498 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 16:15 | Phòng 1 | F7 F8
(2839, 6, NULL, '2026-11-27T13:24:33', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | E6 E7
(2840, 7, 90, '2026-11-27T13:28:24', 360000, N'Paid', N'Cash', 400000, 25, 0, NULL, NULL, NULL), -- suat 508 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 27/11 21:45 | Phòng 2 | F3 F4 F5 F6
(2841, 7, NULL, '2026-11-27T13:28:51', 360000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 505 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:00 | Phòng 1 | G1 G2 G3 G4
(2842, 6, 66, '2026-11-27T13:35:53', 90000, N'Paid', N'Card', NULL, 6, 0, NULL, NULL, NULL), -- suat 509 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:45 | Phòng 3 | D12
(2843, 6, NULL, '2026-11-27T13:36:06', 450000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 497 | Chị Chị Em Em 3 | 27/11 16:00 | Phòng 3 | D5 D6 D7 D8 D9
(2844, 6, 98, '2026-11-27T13:39:12', 240000, N'Paid', N'Cash', 300000, 12, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | C3 C4
(2845, 6, NULL, '2026-11-27T13:41:00', 144000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | G9
(2846, 7, NULL, '2026-11-27T13:41:45', 432000, N'Paid', N'Cash', 450000, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | K3 K4 K5
(2847, 7, NULL, '2026-11-27T13:41:52', 75000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 498 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 16:15 | Phòng 1 | A2
(2848, 6, NULL, '2026-11-27T13:43:14', 324000, N'Paid', N'Cash', 350000, 0, 0, NULL, NULL, NULL), -- suat 503 | Godzilla Trừ Không | 27/11 18:30 | Phòng 4 | G8 G9 G10
(2849, 6, 59, '2026-11-27T13:43:45', 75000, N'Paid', N'Cash', 80000, 3, 0, NULL, NULL, NULL), -- suat 498 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 16:15 | Phòng 1 | C9
(2850, 7, NULL, '2026-11-27T13:44:15', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 494 | Ngày Con Còn Mẹ | 27/11 15:00 | Phòng 2 | E11 E12
(2851, 6, NULL, '2026-11-27T14:00:19', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | G10 G11
(2852, 7, NULL, '2026-11-27T14:03:15', 90000, N'Paid', N'Cash', 100000, 0, 0, NULL, NULL, NULL), -- suat 502 | Điểm Mù | 27/11 18:30 | Phòng 3 | E8
(2853, 8, 38, '2026-11-27T14:05:39', 180000, N'Paid', N'Cash', 180000, 12, 0, NULL, NULL, NULL), -- suat 505 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:00 | Phòng 1 | H6 H7
(2854, 6, 9, '2026-11-27T14:06:55', 288000, N'Paid', N'Cash', 300000, 20, 0, NULL, NULL, NULL), -- suat 495 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:00 | Phòng 5 | G10 G11
(2855, 7, NULL, '2026-11-27T14:07:08', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | E6 E7 E8
(2856, 8, NULL, '2026-11-27T14:10:27', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 503 | Godzilla Trừ Không | 27/11 18:30 | Phòng 4 | F6 F7
(2857, 7, NULL, '2026-11-27T14:16:24', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 499 | Gặp Gỡ Thông Gia: Dâu Mới Trình Làng | 27/11 17:15 | Phòng 2 | J11 J12
(2858, 6, NULL, '2026-11-27T14:18:02', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | H9 H10 H11
(2859, 6, NULL, '2026-11-27T14:19:19', 108000, N'Paid', N'Cash', 110000, 0, 0, NULL, NULL, NULL), -- suat 503 | Godzilla Trừ Không | 27/11 18:30 | Phòng 4 | F4
(2860, 7, NULL, '2026-11-27T14:20:26', 432000, N'Paid', N'Cash', 432000, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | J8 J9 J10
(2861, 7, NULL, '2026-11-27T14:21:20', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 496 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:30 | Phòng 4 | B6 B7
(2862, 8, NULL, '2026-11-27T14:23:10', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 498 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 16:15 | Phòng 1 | B2 B3
(2863, 8, NULL, '2026-11-27T14:26:10', 480000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | D6 D7 D8 D9
(2864, 8, NULL, '2026-11-27T14:29:28', 90000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 509 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:45 | Phòng 3 | H5
(2865, 7, NULL, '2026-11-27T14:37:18', 324000, N'Paid', N'Cash', 350000, 0, 0, NULL, NULL, NULL), -- suat 496 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 15:30 | Phòng 4 | G6 G7 G8
(2866, 8, NULL, '2026-11-27T14:40:04', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 506 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 21:00 | Phòng 4 | C5 C6
(2867, 8, NULL, '2026-11-27T14:56:50', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 504 | Bò Sữa Bay | 27/11 19:30 | Phòng 2 | F3 F4
(2868, 3, NULL, '2026-11-27T15:01:28', 288000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | G3 G4
(2869, 9, 108, '2026-11-27T15:02:38', 288000, N'Paid', N'Cash', 288000, 20, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | E1 E2
(2870, 9, 95, '2026-11-27T15:03:04', 251000, N'Paid', N'Cash', 300000, 17, 37, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | J4 J5
(2871, 10, 82, '2026-11-27T15:12:15', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | H6 H7
(2872, 10, 37, '2026-11-27T15:19:54', 216000, N'Paid', N'Transfer', NULL, 15, 0, NULL, NULL, NULL), -- suat 503 | Godzilla Trừ Không | 27/11 18:30 | Phòng 4 | E5 E6
(2873, 3, NULL, '2026-11-27T15:20:14', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 504 | Bò Sữa Bay | 27/11 19:30 | Phòng 2 | D6 D7
(2874, 3, 87, '2026-11-27T15:21:13', 270000, N'Paid', N'Transfer', NULL, 18, 0, NULL, NULL, NULL), -- suat 498 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 16:15 | Phòng 1 | D5 D6 D7
(2875, 9, 23, '2026-11-27T15:21:48', 150000, N'Paid', N'Transfer', NULL, 7, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | C7 C8
(2876, 9, 86, '2026-11-27T15:28:15', 432000, N'Paid', N'Card', NULL, 30, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | K7 K8 K9
(2877, 3, NULL, '2026-11-27T15:31:11', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 502 | Điểm Mù | 27/11 18:30 | Phòng 3 | J3 J4
(2878, 3, NULL, '2026-11-27T15:42:15', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 508 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 27/11 21:45 | Phòng 2 | E3 E4
(2879, 3, NULL, '2026-11-27T15:44:20', 288000, N'Paid', N'Cash', 300000, 0, 0, NULL, NULL, NULL), -- suat 507 | Godzilla Trừ Không | 27/11 21:15 | Phòng 5 | F4 F5
(2880, 3, NULL, '2026-11-27T15:44:42', 360000, N'Paid', N'Cash', 360000, 0, 0, NULL, NULL, NULL), -- suat 504 | Bò Sữa Bay | 27/11 19:30 | Phòng 2 | E5 E6 E7 E8
(2881, 10, NULL, '2026-11-27T15:45:08', 324000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 506 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 21:00 | Phòng 4 | D3 D4 D5
(2882, 9, 94, '2026-11-27T15:52:59', 188000, N'Paid', N'Cash', 200000, 13, 100, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | F2 F3
(2883, 9, NULL, '2026-11-27T15:56:27', 576000, N'Paid', N'Cash', 600000, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | F9 F10 F11 F12
(2884, 10, NULL, '2026-11-27T15:59:20', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | E9 E10
(2885, 10, 93, '2026-11-27T16:00:54', 240000, N'Paid', N'Cash', 240000, 12, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | C8 C9
(2886, 3, NULL, '2026-11-27T16:00:56', 288000, N'Paid', N'Cash', 288000, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | L9 L10
(2887, 9, 44, '2026-11-27T16:02:21', 216000, N'Paid', N'Card', NULL, 15, 0, NULL, NULL, NULL), -- suat 506 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 21:00 | Phòng 4 | F8 F9
(2888, 9, NULL, '2026-11-27T16:04:44', 300000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 504 | Bò Sữa Bay | 27/11 19:30 | Phòng 2 | A6 A7 A8 A9
(2889, 9, 115, '2026-11-27T16:07:13', 75000, N'Paid', N'Cash', 75000, 3, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | B3
(2890, 3, NULL, '2026-11-27T16:07:49', 375000, N'Paid', N'Cash', 375000, 0, 0, NULL, NULL, NULL), -- suat 502 | Điểm Mù | 27/11 18:30 | Phòng 3 | C5 C6 C7 C8 C9
(2891, 10, 75, '2026-11-27T16:13:10', 216000, N'Paid', N'Card', NULL, 21, 0, NULL, NULL, NULL), -- suat 503 | Godzilla Trừ Không | 27/11 18:30 | Phòng 4 | J9 J10
(2892, 3, NULL, '2026-11-27T16:21:21', 216000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 503 | Godzilla Trừ Không | 27/11 18:30 | Phòng 4 | H5 H6
(2893, 9, NULL, '2026-11-27T16:26:49', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 505 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:00 | Phòng 1 | F5 F6
(2894, 3, NULL, '2026-11-27T16:38:32', 270000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | F8 F9 F10
(2895, 3, NULL, '2026-11-27T16:39:31', 75000, N'Paid', N'Cash', 75000, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | B8
(2896, 3, 93, '2026-11-27T16:45:04', 120000, N'Paid', N'Cash', 120000, 6, 0, NULL, NULL, NULL), -- suat 507 | Godzilla Trừ Không | 27/11 21:15 | Phòng 5 | D10
(2897, 9, NULL, '2026-11-27T16:47:24', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 507 | Godzilla Trừ Không | 27/11 21:15 | Phòng 5 | K11
(2898, 10, NULL, '2026-11-27T16:50:30', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | E8
(2899, 9, NULL, '2026-11-27T17:00:22', 225000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 504 | Bò Sữa Bay | 27/11 19:30 | Phòng 2 | B8 B9 B10
(2900, 3, NULL, '2026-11-27T17:07:57', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | J5 J6
(2901, 3, NULL, '2026-11-27T17:15:09', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | D8 D9 D10 D11
(2902, 3, 108, '2026-11-27T17:24:34', 180000, N'Paid', N'Cash', 200000, 12, 0, NULL, NULL, NULL), -- suat 509 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:45 | Phòng 3 | E9 E10
(2903, 9, NULL, '2026-11-27T17:25:10', 144000, N'Paid', N'Cash', 150000, 0, 0, NULL, NULL, NULL), -- suat 500 | Dune: Hành Tinh Cát - Phần Hai | 27/11 18:00 | Phòng 5 | K1
(2904, 9, NULL, '2026-11-27T17:28:39', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 501 | Trại Giam Hạnh Phúc | 27/11 18:30 | Phòng 1 | D2 D3
(2905, 9, NULL, '2026-11-27T17:28:52', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 503 | Godzilla Trừ Không | 27/11 18:30 | Phòng 4 | C9 C10
(2906, 3, NULL, '2026-11-27T17:29:41', 240000, N'Paid', N'Cash', 250000, 0, 0, NULL, NULL, NULL), -- suat 507 | Godzilla Trừ Không | 27/11 21:15 | Phòng 5 | D1 D2
(2907, 9, 78, '2026-11-27T17:30:25', 90000, N'Paid', N'Cash', 500000, 4, 0, NULL, NULL, NULL), -- suat 503 | Godzilla Trừ Không | 27/11 18:30 | Phòng 4 | C2
(2908, 9, NULL, '2026-11-27T17:31:18', 360000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 505 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:00 | Phòng 1 | D6 D7 D8 D9
(2909, 9, NULL, '2026-11-27T17:32:12', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 509 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:45 | Phòng 3 | G2 G3
(2910, 3, NULL, '2026-11-27T17:35:55', 150000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 505 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:00 | Phòng 1 | C2 C3
(2911, 10, NULL, '2026-11-27T17:47:58', 540000, N'Cancelled', N'Cash', 540000, 0, 0, N'Khách đổi ý', '2026-11-27T18:27:34', 10), -- suat 508 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 27/11 21:45 | Phòng 2 | D4 D5 D6 D7 D8 D9
(2912, 9, NULL, '2026-11-27T17:54:50', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 505 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:00 | Phòng 1 | J7 J8
(2913, 9, NULL, '2026-11-27T17:56:17', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 504 | Bò Sữa Bay | 27/11 19:30 | Phòng 2 | D4 D5
(2914, 10, NULL, '2026-11-27T17:56:27', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 508 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 27/11 21:45 | Phòng 2 | E6 E7
(2915, 3, NULL, '2026-11-27T17:58:29', 180000, N'Paid', N'Cash', 200000, 0, 0, NULL, NULL, NULL), -- suat 502 | Điểm Mù | 27/11 18:30 | Phòng 3 | J1 J2
(2916, 3, NULL, '2026-11-27T18:09:44', 180000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 504 | Bò Sữa Bay | 27/11 19:30 | Phòng 2 | D8 D9
(2917, 9, NULL, '2026-11-27T18:20:53', 432000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 506 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 21:00 | Phòng 4 | H4 H5 H6 H7
(2918, 10, NULL, '2026-11-27T18:21:41', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 509 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:45 | Phòng 3 | J5 J6
(2919, 3, NULL, '2026-11-27T18:22:41', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 509 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:45 | Phòng 3 | D11
(2920, 3, NULL, '2026-11-27T18:31:54', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 509 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:45 | Phòng 3 | D1 D2
(2921, 9, NULL, '2026-11-27T18:52:37', 450000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 505 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:00 | Phòng 1 | A5 A6 A7 A8 A9 A10
(2922, 10, NULL, '2026-11-27T18:54:45', 180000, N'Paid', N'Transfer', NULL, 0, 0, NULL, NULL, NULL), -- suat 506 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 21:00 | Phòng 4 | B8 B9
(2923, 3, NULL, '2026-11-27T19:02:10', 90000, N'Paid', N'Cash', 90000, 0, 0, NULL, NULL, NULL), -- suat 505 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:00 | Phòng 1 | E9
(2924, 3, NULL, '2026-11-27T19:02:35', 270000, N'Paid', N'Cash', 270000, 0, 0, NULL, NULL, NULL), -- suat 509 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:45 | Phòng 3 | H2 H3 H4
(2925, 9, NULL, '2026-11-27T19:25:52', 324000, N'Paid', N'Card', NULL, 0, 0, NULL, NULL, NULL), -- suat 506 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 21:00 | Phòng 4 | F3 F4 F5
(2926, 3, NULL, '2026-11-27T20:07:55', 180000, N'Cancelled', N'Cash', 180000, 0, 0, N'Khách đổi ý', '2026-11-27T20:18:13', 3), -- suat 509 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:45 | Phòng 3 | J9 J10
(2927, 10, NULL, '2026-11-27T20:18:30', 180000, N'Paid', N'Cash', 180000, 0, 0, NULL, NULL, NULL), -- suat 508 | Thòng Lọng Ma: Quỷ Cái Đòi Mạng | 27/11 21:45 | Phòng 2 | F8 F9
(2928, 3, NULL, '2026-11-27T20:20:18', 324000, N'Paid', N'Cash', 330000, 0, 0, NULL, NULL, NULL), -- suat 506 | Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân | 27/11 21:00 | Phòng 4 | E7 E8 E9
(2929, 10, 49, '2026-11-27T20:54:33', 180000, N'Paid', N'Transfer', NULL, 12, 0, NULL, NULL, NULL); -- suat 509 | Mẹ Mìn: Giao Kèo Với Quỷ | 27/11 21:45 | Phòng 3 | D9 D10
SET IDENTITY_INSERT BOOKING OFF;
SET IDENTITY_INSERT TICKET ON;
INSERT INTO TICKET (TicketID, BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus) VALUES
(6303, 2750, 483, 5, 519, 144000, N'Active'),
(6304, 2751, 481, 1, 29, 75000, N'Active'),
(6305, 2751, 481, 1, 30, 75000, N'Active'),
(6306, 2751, 481, 1, 31, 75000, N'Active'),
(6307, 2751, 481, 1, 32, 75000, N'Active'),
(6308, 2751, 481, 1, 33, 75000, N'Active'),
(6309, 2752, 482, 2, 162, 90000, N'Active'),
(6310, 2752, 482, 2, 163, 90000, N'Active'),
(6311, 2753, 482, 2, 205, 90000, N'Active'),
(6312, 2753, 482, 2, 206, 90000, N'Active'),
(6313, 2754, 483, 5, 524, 144000, N'Active'),
(6314, 2754, 483, 5, 525, 144000, N'Active'),
(6315, 2754, 483, 5, 526, 144000, N'Active'),
(6316, 2754, 483, 5, 527, 144000, N'Active'),
(6317, 2755, 483, 5, 509, 144000, N'Active'),
(6318, 2755, 483, 5, 510, 144000, N'Active'),
(6319, 2756, 481, 1, 45, 90000, N'Active'),
(6320, 2757, 483, 5, 481, 144000, N'Active'),
(6321, 2758, 481, 1, 38, 90000, N'Active'),
(6322, 2759, 484, 4, 385, 108000, N'Active'),
(6323, 2759, 484, 4, 386, 108000, N'Active'),
(6324, 2759, 484, 4, 387, 108000, N'Active'),
(6325, 2760, 496, 4, 393, 108000, N'Active'),
(6326, 2760, 496, 4, 394, 108000, N'Active'),
(6327, 2761, 490, 5, 561, 144000, N'Active'),
(6328, 2761, 490, 5, 562, 144000, N'Active'),
(6329, 2762, 481, 1, 67, 90000, N'Cancelled'),
(6330, 2763, 482, 2, 113, 75000, N'Active'),
(6331, 2764, 481, 1, 90, 90000, N'Cancelled'),
(6332, 2764, 481, 1, 91, 90000, N'Cancelled'),
(6333, 2764, 481, 1, 92, 90000, N'Cancelled'),
(6334, 2765, 485, 3, 266, 90000, N'Active'),
(6335, 2765, 485, 3, 267, 90000, N'Active'),
(6336, 2766, 499, 2, 193, 90000, N'Active'),
(6337, 2766, 499, 2, 194, 90000, N'Active'),
(6338, 2766, 499, 2, 195, 90000, N'Active'),
(6339, 2767, 486, 2, 147, 90000, N'Active'),
(6340, 2767, 486, 2, 148, 90000, N'Active'),
(6341, 2768, 488, 1, 59, 90000, N'Active'),
(6342, 2768, 488, 1, 60, 90000, N'Active'),
(6343, 2769, 487, 3, 313, 90000, N'Active'),
(6344, 2769, 487, 3, 314, 90000, N'Active'),
(6345, 2770, 489, 4, 344, 90000, N'Active'),
(6346, 2770, 489, 4, 345, 90000, N'Active'),
(6347, 2770, 489, 4, 346, 90000, N'Active'),
(6348, 2771, 493, 1, 57, 90000, N'Active'),
(6349, 2771, 493, 1, 58, 90000, N'Active'),
(6350, 2772, 486, 2, 150, 90000, N'Active'),
(6351, 2772, 486, 2, 151, 90000, N'Active'),
(6352, 2773, 487, 3, 281, 90000, N'Active'),
(6353, 2773, 487, 3, 282, 90000, N'Active'),
(6354, 2774, 500, 5, 439, 120000, N'Cancelled'),
(6355, 2774, 500, 5, 440, 120000, N'Cancelled'),
(6356, 2774, 500, 5, 441, 120000, N'Cancelled'),
(6357, 2774, 500, 5, 442, 120000, N'Cancelled'),
(6358, 2774, 500, 5, 443, 120000, N'Cancelled'),
(6359, 2774, 500, 5, 444, 120000, N'Cancelled'),
(6360, 2775, 496, 4, 386, 108000, N'Active'),
(6361, 2775, 496, 4, 387, 108000, N'Active'),
(6362, 2776, 490, 5, 455, 120000, N'Active'),
(6363, 2777, 490, 5, 477, 120000, N'Active'),
(6364, 2777, 490, 5, 478, 120000, N'Active'),
(6365, 2777, 490, 5, 479, 120000, N'Active'),
(6366, 2777, 490, 5, 480, 120000, N'Active'),
(6367, 2778, 500, 5, 509, 144000, N'Active'),
(6368, 2778, 500, 5, 510, 144000, N'Active'),
(6369, 2778, 500, 5, 511, 144000, N'Active'),
(6370, 2779, 501, 1, 99, 90000, N'Active'),
(6371, 2779, 501, 1, 100, 90000, N'Active'),
(6372, 2780, 492, 3, 293, 90000, N'Active'),
(6373, 2780, 492, 3, 294, 90000, N'Active'),
(6374, 2780, 492, 3, 295, 90000, N'Active'),
(6375, 2780, 492, 3, 296, 90000, N'Active'),
(6376, 2781, 492, 3, 268, 90000, N'Active'),
(6377, 2781, 492, 3, 269, 90000, N'Active'),
(6378, 2782, 501, 1, 33, 75000, N'Active'),
(6379, 2782, 501, 1, 34, 75000, N'Active'),
(6380, 2783, 499, 2, 189, 90000, N'Active'),
(6381, 2783, 499, 2, 190, 90000, N'Active'),
(6382, 2784, 488, 1, 62, 90000, N'Active'),
(6383, 2784, 488, 1, 63, 90000, N'Active'),
(6384, 2784, 488, 1, 64, 90000, N'Active'),
(6385, 2785, 490, 5, 443, 120000, N'Active'),
(6386, 2785, 490, 5, 444, 120000, N'Active'),
(6387, 2786, 498, 1, 101, 90000, N'Active'),
(6388, 2786, 498, 1, 102, 90000, N'Active'),
(6389, 2787, 498, 1, 99, 90000, N'Active'),
(6390, 2787, 498, 1, 100, 90000, N'Active'),
(6391, 2788, 490, 5, 532, 144000, N'Active'),
(6392, 2788, 490, 5, 533, 144000, N'Active'),
(6393, 2789, 490, 5, 496, 144000, N'Active'),
(6394, 2789, 490, 5, 497, 144000, N'Active'),
(6395, 2789, 490, 5, 498, 144000, N'Active'),
(6396, 2789, 490, 5, 499, 144000, N'Active'),
(6397, 2789, 490, 5, 500, 144000, N'Active'),
(6398, 2790, 491, 2, 199, 90000, N'Active'),
(6399, 2790, 491, 2, 200, 90000, N'Active'),
(6400, 2791, 491, 2, 211, 90000, N'Active'),
(6401, 2791, 491, 2, 212, 90000, N'Active'),
(6402, 2792, 500, 5, 522, 144000, N'Cancelled'),
(6403, 2792, 500, 5, 523, 144000, N'Cancelled'),
(6404, 2792, 500, 5, 524, 144000, N'Cancelled'),
(6405, 2792, 500, 5, 525, 144000, N'Cancelled'),
(6406, 2792, 500, 5, 526, 144000, N'Cancelled'),
(6407, 2793, 499, 2, 174, 90000, N'Active'),
(6408, 2793, 499, 2, 175, 90000, N'Active'),
(6409, 2794, 503, 4, 333, 90000, N'Active'),
(6410, 2794, 503, 4, 334, 90000, N'Active'),
(6411, 2795, 495, 5, 507, 144000, N'Active'),
(6412, 2795, 495, 5, 508, 144000, N'Active'),
(6413, 2795, 495, 5, 509, 144000, N'Active'),
(6414, 2795, 495, 5, 510, 144000, N'Active'),
(6415, 2796, 500, 5, 534, 144000, N'Active'),
(6416, 2797, 495, 5, 497, 144000, N'Active'),
(6417, 2797, 495, 5, 498, 144000, N'Active'),
(6418, 2798, 495, 5, 481, 144000, N'Active'),
(6419, 2798, 495, 5, 482, 144000, N'Active'),
(6420, 2799, 493, 1, 80, 90000, N'Active'),
(6421, 2799, 493, 1, 81, 90000, N'Active'),
(6422, 2800, 493, 1, 42, 90000, N'Active'),
(6423, 2800, 493, 1, 43, 90000, N'Active'),
(6424, 2801, 496, 4, 427, 108000, N'Active'),
(6425, 2801, 496, 4, 428, 108000, N'Active'),
(6426, 2802, 499, 2, 125, 75000, N'Active'),
(6427, 2802, 499, 2, 126, 75000, N'Active'),
(6428, 2802, 499, 2, 127, 75000, N'Active'),
(6429, 2803, 494, 2, 179, 90000, N'Active'),
(6430, 2804, 490, 5, 490, 144000, N'Active'),
(6431, 2804, 490, 5, 491, 144000, N'Active'),
(6432, 2804, 490, 5, 492, 144000, N'Active'),
(6433, 2805, 492, 3, 249, 75000, N'Active'),
(6434, 2805, 492, 3, 250, 75000, N'Active'),
(6435, 2806, 496, 4, 406, 108000, N'Active'),
(6436, 2806, 496, 4, 407, 108000, N'Active'),
(6437, 2807, 496, 4, 417, 108000, N'Active'),
(6438, 2807, 496, 4, 418, 108000, N'Active'),
(6439, 2808, 490, 5, 445, 120000, N'Active'),
(6440, 2809, 495, 5, 534, 144000, N'Active'),
(6441, 2809, 495, 5, 535, 144000, N'Active'),
(6442, 2810, 493, 1, 66, 90000, N'Active'),
(6443, 2810, 493, 1, 67, 90000, N'Active'),
(6444, 2811, 494, 2, 150, 90000, N'Active'),
(6445, 2811, 494, 2, 151, 90000, N'Active'),
(6446, 2812, 500, 5, 496, 144000, N'Active'),
(6447, 2812, 500, 5, 497, 144000, N'Active'),
(6448, 2812, 500, 5, 498, 144000, N'Active'),
(6449, 2813, 491, 2, 170, 90000, N'Active'),
(6450, 2813, 491, 2, 171, 90000, N'Active'),
(6451, 2814, 492, 3, 255, 90000, N'Active'),
(6452, 2815, 500, 5, 535, 144000, N'Active'),
(6453, 2816, 499, 2, 147, 90000, N'Active'),
(6454, 2816, 499, 2, 148, 90000, N'Active'),
(6455, 2816, 499, 2, 149, 90000, N'Active'),
(6456, 2817, 492, 3, 245, 75000, N'Active'),
(6457, 2817, 492, 3, 246, 75000, N'Active'),
(6458, 2817, 492, 3, 247, 75000, N'Active'),
(6459, 2817, 492, 3, 248, 75000, N'Active'),
(6460, 2818, 493, 1, 74, 90000, N'Active'),
(6461, 2818, 493, 1, 75, 90000, N'Active'),
(6462, 2819, 504, 2, 174, 90000, N'Active'),
(6463, 2819, 504, 2, 175, 90000, N'Active'),
(6464, 2819, 504, 2, 176, 90000, N'Active'),
(6465, 2820, 495, 5, 528, 144000, N'Active'),
(6466, 2821, 495, 5, 466, 120000, N'Active'),
(6467, 2822, 495, 5, 450, 120000, N'Active'),
(6468, 2822, 495, 5, 451, 120000, N'Active'),
(6469, 2823, 501, 1, 97, 90000, N'Active'),
(6470, 2823, 501, 1, 98, 90000, N'Active'),
(6471, 2824, 499, 2, 196, 90000, N'Active'),
(6472, 2824, 499, 2, 197, 90000, N'Active'),
(6473, 2825, 499, 2, 199, 90000, N'Active'),
(6474, 2825, 499, 2, 200, 90000, N'Active'),
(6475, 2825, 499, 2, 201, 90000, N'Active'),
(6476, 2826, 507, 5, 473, 120000, N'Active'),
(6477, 2826, 507, 5, 474, 120000, N'Active'),
(6478, 2827, 502, 3, 266, 90000, N'Active'),
(6479, 2827, 502, 3, 267, 90000, N'Active'),
(6480, 2827, 502, 3, 268, 90000, N'Active'),
(6481, 2827, 502, 3, 269, 90000, N'Active'),
(6482, 2828, 494, 2, 173, 90000, N'Active'),
(6483, 2828, 494, 2, 174, 90000, N'Active'),
(6484, 2829, 499, 2, 162, 90000, N'Active'),
(6485, 2829, 499, 2, 163, 90000, N'Active'),
(6486, 2829, 499, 2, 164, 90000, N'Active'),
(6487, 2830, 496, 4, 425, 108000, N'Active'),
(6488, 2830, 496, 4, 426, 108000, N'Active'),
(6489, 2831, 494, 2, 183, 90000, N'Active'),
(6490, 2831, 494, 2, 184, 90000, N'Active'),
(6491, 2831, 494, 2, 185, 90000, N'Active'),
(6492, 2831, 494, 2, 186, 90000, N'Active'),
(6493, 2831, 494, 2, 187, 90000, N'Active'),
(6494, 2831, 494, 2, 188, 90000, N'Active'),
(6495, 2832, 507, 5, 555, 144000, N'Active'),
(6496, 2832, 507, 5, 556, 144000, N'Active'),
(6497, 2833, 493, 1, 93, 90000, N'Active'),
(6498, 2833, 493, 1, 94, 90000, N'Active'),
(6499, 2834, 499, 2, 145, 90000, N'Active'),
(6500, 2834, 499, 2, 146, 90000, N'Active'),
(6501, 2835, 500, 5, 485, 144000, N'Active'),
(6502, 2836, 500, 5, 489, 144000, N'Active'),
(6503, 2836, 500, 5, 490, 144000, N'Active'),
(6504, 2836, 500, 5, 491, 144000, N'Active'),
(6505, 2836, 500, 5, 492, 144000, N'Active'),
(6506, 2837, 499, 2, 168, 90000, N'Active'),
(6507, 2838, 498, 1, 67, 90000, N'Active'),
(6508, 2838, 498, 1, 68, 90000, N'Active'),
(6509, 2839, 501, 1, 54, 90000, N'Active'),
(6510, 2839, 501, 1, 55, 90000, N'Active'),
(6511, 2840, 508, 2, 171, 90000, N'Active'),
(6512, 2840, 508, 2, 172, 90000, N'Active'),
(6513, 2840, 508, 2, 173, 90000, N'Active'),
(6514, 2840, 508, 2, 174, 90000, N'Active'),
(6515, 2841, 505, 1, 73, 90000, N'Active'),
(6516, 2841, 505, 1, 74, 90000, N'Active'),
(6517, 2841, 505, 1, 75, 90000, N'Active'),
(6518, 2841, 505, 1, 76, 90000, N'Active'),
(6519, 2842, 509, 3, 264, 90000, N'Active'),
(6520, 2843, 497, 3, 257, 90000, N'Active'),
(6521, 2843, 497, 3, 258, 90000, N'Active'),
(6522, 2843, 497, 3, 259, 90000, N'Active'),
(6523, 2843, 497, 3, 260, 90000, N'Active'),
(6524, 2843, 497, 3, 261, 90000, N'Active'),
(6525, 2844, 500, 5, 459, 120000, N'Active'),
(6526, 2844, 500, 5, 460, 120000, N'Active'),
(6527, 2845, 500, 5, 513, 144000, N'Active'),
(6528, 2846, 500, 5, 543, 144000, N'Active'),
(6529, 2846, 500, 5, 544, 144000, N'Active'),
(6530, 2846, 500, 5, 545, 144000, N'Active'),
(6531, 2847, 498, 1, 2, 75000, N'Active'),
(6532, 2848, 503, 4, 404, 108000, N'Active'),
(6533, 2848, 503, 4, 405, 108000, N'Active'),
(6534, 2848, 503, 4, 406, 108000, N'Active'),
(6535, 2849, 498, 1, 33, 75000, N'Active'),
(6536, 2850, 494, 2, 167, 90000, N'Active'),
(6537, 2850, 494, 2, 168, 90000, N'Active'),
(6538, 2851, 500, 5, 514, 144000, N'Active'),
(6539, 2851, 500, 5, 515, 144000, N'Active'),
(6540, 2852, 502, 3, 272, 90000, N'Active'),
(6541, 2853, 505, 1, 90, 90000, N'Active'),
(6542, 2853, 505, 1, 91, 90000, N'Active'),
(6543, 2854, 495, 5, 514, 144000, N'Active'),
(6544, 2854, 495, 5, 515, 144000, N'Active'),
(6545, 2855, 500, 5, 486, 144000, N'Active'),
(6546, 2855, 500, 5, 487, 144000, N'Active'),
(6547, 2855, 500, 5, 488, 144000, N'Active'),
(6548, 2856, 503, 4, 390, 108000, N'Active'),
(6549, 2856, 503, 4, 391, 108000, N'Active'),
(6550, 2857, 499, 2, 215, 90000, N'Active'),
(6551, 2857, 499, 2, 216, 90000, N'Active'),
(6552, 2858, 500, 5, 525, 144000, N'Active'),
(6553, 2858, 500, 5, 526, 144000, N'Active'),
(6554, 2858, 500, 5, 527, 144000, N'Active'),
(6555, 2859, 503, 4, 388, 108000, N'Active'),
(6556, 2860, 500, 5, 536, 144000, N'Active'),
(6557, 2860, 500, 5, 537, 144000, N'Active'),
(6558, 2860, 500, 5, 538, 144000, N'Active'),
(6559, 2861, 496, 4, 342, 90000, N'Active'),
(6560, 2861, 496, 4, 343, 90000, N'Active'),
(6561, 2862, 498, 1, 14, 75000, N'Active'),
(6562, 2862, 498, 1, 15, 75000, N'Active'),
(6563, 2863, 500, 5, 474, 120000, N'Active'),
(6564, 2863, 500, 5, 475, 120000, N'Active'),
(6565, 2863, 500, 5, 476, 120000, N'Active'),
(6566, 2863, 500, 5, 477, 120000, N'Active'),
(6567, 2864, 509, 3, 305, 90000, N'Active'),
(6568, 2865, 496, 4, 402, 108000, N'Active'),
(6569, 2865, 496, 4, 403, 108000, N'Active'),
(6570, 2865, 496, 4, 404, 108000, N'Active'),
(6571, 2866, 506, 4, 353, 90000, N'Active'),
(6572, 2866, 506, 4, 354, 90000, N'Active'),
(6573, 2867, 504, 2, 171, 90000, N'Active'),
(6574, 2867, 504, 2, 172, 90000, N'Active'),
(6575, 2868, 500, 5, 507, 144000, N'Active'),
(6576, 2868, 500, 5, 508, 144000, N'Active'),
(6577, 2869, 500, 5, 481, 144000, N'Active'),
(6578, 2869, 500, 5, 482, 144000, N'Active'),
(6579, 2870, 500, 5, 532, 144000, N'Active'),
(6580, 2870, 500, 5, 533, 144000, N'Active'),
(6581, 2871, 501, 1, 90, 90000, N'Active'),
(6582, 2871, 501, 1, 91, 90000, N'Active'),
(6583, 2872, 503, 4, 377, 108000, N'Active'),
(6584, 2872, 503, 4, 378, 108000, N'Active'),
(6585, 2873, 504, 2, 150, 90000, N'Active'),
(6586, 2873, 504, 2, 151, 90000, N'Active'),
(6587, 2874, 498, 1, 41, 90000, N'Active'),
(6588, 2874, 498, 1, 42, 90000, N'Active'),
(6589, 2874, 498, 1, 43, 90000, N'Active'),
(6590, 2875, 501, 1, 31, 75000, N'Active'),
(6591, 2875, 501, 1, 32, 75000, N'Active'),
(6592, 2876, 500, 5, 547, 144000, N'Active'),
(6593, 2876, 500, 5, 548, 144000, N'Active'),
(6594, 2876, 500, 5, 549, 144000, N'Active'),
(6595, 2877, 502, 3, 315, 90000, N'Active'),
(6596, 2877, 502, 3, 316, 90000, N'Active'),
(6597, 2878, 508, 2, 159, 90000, N'Active'),
(6598, 2878, 508, 2, 160, 90000, N'Active'),
(6599, 2879, 507, 5, 496, 144000, N'Active'),
(6600, 2879, 507, 5, 497, 144000, N'Active'),
(6601, 2880, 504, 2, 161, 90000, N'Active'),
(6602, 2880, 504, 2, 162, 90000, N'Active'),
(6603, 2880, 504, 2, 163, 90000, N'Active'),
(6604, 2880, 504, 2, 164, 90000, N'Active'),
(6605, 2881, 506, 4, 363, 108000, N'Active'),
(6606, 2881, 506, 4, 364, 108000, N'Active'),
(6607, 2881, 506, 4, 365, 108000, N'Active'),
(6608, 2882, 500, 5, 494, 144000, N'Active'),
(6609, 2882, 500, 5, 495, 144000, N'Active'),
(6610, 2883, 500, 5, 501, 144000, N'Active'),
(6611, 2883, 500, 5, 502, 144000, N'Active'),
(6612, 2883, 500, 5, 503, 144000, N'Active'),
(6613, 2883, 500, 5, 504, 144000, N'Active'),
(6614, 2884, 501, 1, 57, 90000, N'Active'),
(6615, 2884, 501, 1, 58, 90000, N'Active'),
(6616, 2885, 500, 5, 464, 120000, N'Active'),
(6617, 2885, 500, 5, 465, 120000, N'Active'),
(6618, 2886, 500, 5, 561, 144000, N'Active'),
(6619, 2886, 500, 5, 562, 144000, N'Active'),
(6620, 2887, 506, 4, 392, 108000, N'Active'),
(6621, 2887, 506, 4, 393, 108000, N'Active'),
(6622, 2888, 504, 2, 114, 75000, N'Active'),
(6623, 2888, 504, 2, 115, 75000, N'Active'),
(6624, 2888, 504, 2, 116, 75000, N'Active'),
(6625, 2888, 504, 2, 117, 75000, N'Active'),
(6626, 2889, 501, 1, 15, 75000, N'Active'),
(6627, 2890, 502, 3, 245, 75000, N'Active'),
(6628, 2890, 502, 3, 246, 75000, N'Active'),
(6629, 2890, 502, 3, 247, 75000, N'Active'),
(6630, 2890, 502, 3, 248, 75000, N'Active'),
(6631, 2890, 502, 3, 249, 75000, N'Active'),
(6632, 2891, 503, 4, 429, 108000, N'Active'),
(6633, 2891, 503, 4, 430, 108000, N'Active'),
(6634, 2892, 503, 4, 413, 108000, N'Active'),
(6635, 2892, 503, 4, 414, 108000, N'Active'),
(6636, 2893, 505, 1, 65, 90000, N'Active'),
(6637, 2893, 505, 1, 66, 90000, N'Active'),
(6638, 2894, 501, 1, 68, 90000, N'Active'),
(6639, 2894, 501, 1, 69, 90000, N'Active'),
(6640, 2894, 501, 1, 70, 90000, N'Active'),
(6641, 2895, 501, 1, 20, 75000, N'Active'),
(6642, 2896, 507, 5, 478, 120000, N'Active'),
(6643, 2897, 507, 5, 551, 144000, N'Active'),
(6644, 2898, 501, 1, 56, 90000, N'Active'),
(6645, 2899, 504, 2, 128, 75000, N'Active'),
(6646, 2899, 504, 2, 129, 75000, N'Active'),
(6647, 2899, 504, 2, 130, 75000, N'Active'),
(6648, 2900, 501, 1, 101, 90000, N'Active'),
(6649, 2900, 501, 1, 102, 90000, N'Active'),
(6650, 2901, 501, 1, 44, 90000, N'Active'),
(6651, 2901, 501, 1, 45, 90000, N'Active'),
(6652, 2901, 501, 1, 46, 90000, N'Active'),
(6653, 2901, 501, 1, 47, 90000, N'Active'),
(6654, 2902, 509, 3, 273, 90000, N'Active'),
(6655, 2902, 509, 3, 274, 90000, N'Active'),
(6656, 2903, 500, 5, 541, 144000, N'Active'),
(6657, 2904, 501, 1, 38, 90000, N'Active'),
(6658, 2904, 501, 1, 39, 90000, N'Active'),
(6659, 2905, 503, 4, 357, 90000, N'Active'),
(6660, 2905, 503, 4, 358, 90000, N'Active'),
(6661, 2906, 507, 5, 469, 120000, N'Active'),
(6662, 2906, 507, 5, 470, 120000, N'Active'),
(6663, 2907, 503, 4, 350, 90000, N'Active'),
(6664, 2908, 505, 1, 42, 90000, N'Active'),
(6665, 2908, 505, 1, 43, 90000, N'Active'),
(6666, 2908, 505, 1, 44, 90000, N'Active'),
(6667, 2908, 505, 1, 45, 90000, N'Active'),
(6668, 2909, 509, 3, 290, 90000, N'Active'),
(6669, 2909, 509, 3, 291, 90000, N'Active'),
(6670, 2910, 505, 1, 26, 75000, N'Active'),
(6671, 2910, 505, 1, 27, 75000, N'Active'),
(6672, 2911, 508, 2, 148, 90000, N'Cancelled'),
(6673, 2911, 508, 2, 149, 90000, N'Cancelled'),
(6674, 2911, 508, 2, 150, 90000, N'Cancelled'),
(6675, 2911, 508, 2, 151, 90000, N'Cancelled'),
(6676, 2911, 508, 2, 152, 90000, N'Cancelled'),
(6677, 2911, 508, 2, 153, 90000, N'Cancelled'),
(6678, 2912, 505, 1, 103, 90000, N'Active'),
(6679, 2912, 505, 1, 104, 90000, N'Active'),
(6680, 2913, 504, 2, 148, 90000, N'Active'),
(6681, 2913, 504, 2, 149, 90000, N'Active'),
(6682, 2914, 508, 2, 162, 90000, N'Active'),
(6683, 2914, 508, 2, 163, 90000, N'Active'),
(6684, 2915, 502, 3, 313, 90000, N'Active'),
(6685, 2915, 502, 3, 314, 90000, N'Active'),
(6686, 2916, 504, 2, 152, 90000, N'Active'),
(6687, 2916, 504, 2, 153, 90000, N'Active'),
(6688, 2917, 506, 4, 412, 108000, N'Active'),
(6689, 2917, 506, 4, 413, 108000, N'Active'),
(6690, 2917, 506, 4, 414, 108000, N'Active'),
(6691, 2917, 506, 4, 415, 108000, N'Active'),
(6692, 2918, 509, 3, 317, 90000, N'Active'),
(6693, 2918, 509, 3, 318, 90000, N'Active'),
(6694, 2919, 509, 3, 263, 90000, N'Active'),
(6695, 2920, 509, 3, 253, 90000, N'Active'),
(6696, 2920, 509, 3, 254, 90000, N'Active'),
(6697, 2921, 505, 1, 5, 75000, N'Active'),
(6698, 2921, 505, 1, 6, 75000, N'Active'),
(6699, 2921, 505, 1, 7, 75000, N'Active'),
(6700, 2921, 505, 1, 8, 75000, N'Active'),
(6701, 2921, 505, 1, 9, 75000, N'Active'),
(6702, 2921, 505, 1, 10, 75000, N'Active'),
(6703, 2922, 506, 4, 344, 90000, N'Active'),
(6704, 2922, 506, 4, 345, 90000, N'Active'),
(6705, 2923, 505, 1, 57, 90000, N'Active'),
(6706, 2924, 509, 3, 302, 90000, N'Active'),
(6707, 2924, 509, 3, 303, 90000, N'Active'),
(6708, 2924, 509, 3, 304, 90000, N'Active'),
(6709, 2925, 506, 4, 387, 108000, N'Active'),
(6710, 2925, 506, 4, 388, 108000, N'Active'),
(6711, 2925, 506, 4, 389, 108000, N'Active'),
(6712, 2926, 509, 3, 321, 90000, N'Cancelled'),
(6713, 2926, 509, 3, 322, 90000, N'Cancelled'),
(6714, 2927, 508, 2, 176, 90000, N'Active'),
(6715, 2927, 508, 2, 177, 90000, N'Active'),
(6716, 2928, 506, 4, 379, 108000, N'Active'),
(6717, 2928, 506, 4, 380, 108000, N'Active'),
(6718, 2928, 506, 4, 381, 108000, N'Active'),
(6719, 2929, 509, 3, 261, 90000, N'Active'),
(6720, 2929, 509, 3, 262, 90000, N'Active');
SET IDENTITY_INSERT TICKET OFF;

-- ===== SHIFT_HANDOVER: chot ca cua nhan vien + xac nhan ban giao cua QTV =====
-- ReportedCash = tien mat dem duoc; tien mat he thong = tong don Paid tra bang Cash do nhan vien lap trong ngay.
SET IDENTITY_INSERT SHIFT_HANDOVER ON;
INSERT INTO SHIFT_HANDOVER (ShiftHandoverID, ShiftDate, AccountID, ReportedCash, ReportNote, ReportedAt, ConfirmedCash, ConfirmNote, ConfirmedAt, ConfirmedBy) VALUES
(1, '2026-11-10', 3, 5538000, N'', '2026-11-10T15:05:15', 5538000, N'', '2026-11-10T15:29:25', 1), -- nv01 ca sang, tien mat he thong 5.538.000 d
(2, '2026-11-10', 4, 3615000, N'', '2026-11-10T15:24:13', 3615000, N'', '2026-11-10T16:56:44', 1), -- nv02 ca sang, tien mat he thong 3.615.000 d
(3, '2026-11-10', 5, 2022000, N'', '2026-11-10T22:03:55', 2022000, N'Đủ tiền.', '2026-11-10T22:20:06', 2), -- nv03 ca toi, tien mat he thong 2.022.000 d
(4, '2026-11-10', 6, 1506000, N'', '2026-11-10T22:22:53', 1506000, N'Khớp báo cáo.', '2026-11-10T23:02:17', 2), -- nv04 ca toi, tien mat he thong 1.506.000 d
(5, '2026-11-11', 6, 3972000, N'', '2026-11-11T15:14:19', 3972000, N'', '2026-11-11T16:27:12', 1), -- nv04 ca sang, tien mat he thong 3.972.000 d
(6, '2026-11-11', 7, 4572000, N'', '2026-11-11T15:22:28', 4572000, N'', '2026-11-11T17:10:09', 1), -- nv05 ca sang, tien mat he thong 4.572.000 d
(7, '2026-11-11', 9, 1920000, N'', '2026-11-11T22:00:01', 1920000, N'', '2026-11-11T22:19:22', 2), -- nv07 ca toi, tien mat he thong 1.920.000 d
(8, '2026-11-11', 8, 1698000, N'', '2026-11-11T22:23:35', 1698000, N'', '2026-11-11T22:45:57', 2), -- nv06 ca toi, tien mat he thong 1.698.000 d
(9, '2026-11-12', 9, NULL, NULL, NULL, 4278000, N'Nhân viên quên nộp chốt ca, QTV tự kiểm két và xác nhận.', '2026-11-12T16:10:41', 1), -- nv07 ca sang, tien mat he thong 4.278.000 d
(10, '2026-11-12', 10, 3756000, N'', '2026-11-12T15:13:41', 3756000, N'', '2026-11-12T15:59:56', 1), -- nv08 ca sang, tien mat he thong 3.756.000 d
(11, '2026-11-12', 4, 1698000, N'', '2026-11-12T22:03:05', 1698000, N'Khớp báo cáo.', '2026-11-13T09:13:20', 2), -- nv02 ca toi, tien mat he thong 1.698.000 d
(12, '2026-11-12', 3, 1738000, N'Thiếu 20.000 đ, có thể do thối nhầm cho khách.', '2026-11-12T22:08:26', 1738000, N'Đã đối soát, ghi nhận chênh lệch theo báo cáo nhân viên.', '2026-11-13T09:02:23', 2), -- nv01 ca toi, tien mat he thong 1.758.000 d
(13, '2026-11-13', 5, 4569000, N'', '2026-11-13T15:06:57', 4569000, N'', '2026-11-13T16:09:47', 1), -- nv03 ca sang, tien mat he thong 4.569.000 d
(14, '2026-11-13', 6, 1467000, N'', '2026-11-13T15:09:31', 1467000, N'Khớp báo cáo.', '2026-11-13T15:53:00', 1), -- nv04 ca sang, tien mat he thong 1.467.000 d
(15, '2026-11-13', 4, 2704000, N'', '2026-11-13T15:13:08', 2704000, N'', '2026-11-13T16:22:50', 1), -- nv02 ca sang, tien mat he thong 2.704.000 d
(16, '2026-11-13', 8, 4101000, N'', '2026-11-13T21:56:09', 4101000, N'', '2026-11-13T22:08:59', 2), -- nv06 ca toi, tien mat he thong 4.101.000 d
(17, '2026-11-13', 9, 1682000, N'', '2026-11-13T22:00:35', 1682000, N'', '2026-11-13T22:20:03', 2), -- nv07 ca toi, tien mat he thong 1.682.000 d
(18, '2026-11-13', 7, 831000, N'', '2026-11-13T22:10:51', 831000, N'', '2026-11-14T08:41:17', 2), -- nv05 ca toi, tien mat he thong 831.000 d
(19, '2026-11-14', 8, 5099000, N'Thiếu 50.000 đ, đã báo quản lý.', '2026-11-14T15:05:23', 5149000, N'Kiểm đếm lại đủ tiền theo hệ thống, nhân viên đếm nhầm.', '2026-11-14T15:25:38', 1), -- nv06 ca sang, tien mat he thong 5.149.000 d
(20, '2026-11-14', 7, 4602000, N'', '2026-11-14T15:10:57', 4602000, N'Đủ tiền.', '2026-11-14T16:55:18', 1), -- nv05 ca sang, tien mat he thong 4.602.000 d
(21, '2026-11-14', 9, 4341000, N'', '2026-11-14T15:23:56', 4341000, N'Khớp báo cáo.', '2026-11-14T16:43:01', 1), -- nv07 ca sang, tien mat he thong 4.341.000 d
(22, '2026-11-14', 4, 1947000, N'', '2026-11-14T22:11:43', 1947000, N'', '2026-11-15T08:51:28', 2), -- nv02 ca toi, tien mat he thong 1.947.000 d
(23, '2026-11-14', 3, 2067000, N'', '2026-11-14T22:17:09', 2067000, N'Đủ tiền.', '2026-11-14T22:33:00', 2), -- nv01 ca toi, tien mat he thong 2.067.000 d
(24, '2026-11-14', 10, 1560000, N'', '2026-11-14T22:20:18', 1560000, N'', '2026-11-14T22:49:13', 2), -- nv08 ca toi, tien mat he thong 1.560.000 d
(25, '2026-11-15', 3, 3219000, N'', '2026-11-15T15:04:57', 3219000, N'', '2026-11-15T15:32:23', 1), -- nv01 ca sang, tien mat he thong 3.219.000 d
(26, '2026-11-15', 4, 6171000, N'', '2026-11-15T15:05:51', 6171000, N'', '2026-11-15T16:39:53', 1), -- nv02 ca sang, tien mat he thong 6.171.000 d
(27, '2026-11-15', 10, 2868000, N'', '2026-11-15T15:09:08', 2868000, N'', '2026-11-15T16:24:26', 1), -- nv08 ca sang, tien mat he thong 2.868.000 d
(28, '2026-11-15', 5, 3366000, N'', '2026-11-15T22:10:14', 3366000, N'Khớp báo cáo.', '2026-11-16T08:31:31', 2), -- nv03 ca toi, tien mat he thong 3.366.000 d
(29, '2026-11-15', 7, 3644000, N'Thiếu 10.000 đ, chưa rõ nguyên nhân.', '2026-11-15T22:12:38', 3654000, N'Kiểm đếm lại đủ tiền theo hệ thống, nhân viên đếm nhầm.', '2026-11-16T08:31:15', 2), -- nv05 ca toi, tien mat he thong 3.654.000 d
(30, '2026-11-15', 6, 3636000, N'', '2026-11-15T22:24:33', 3636000, N'', '2026-11-16T08:29:23', 2), -- nv04 ca toi, tien mat he thong 3.636.000 d
(31, '2026-11-16', 6, 1434000, N'', '2026-11-16T15:22:36', 1434000, N'', '2026-11-16T17:13:37', 1), -- nv04 ca sang, tien mat he thong 1.434.000 d
(32, '2026-11-16', 5, 3138000, N'', '2026-11-16T15:23:41', 3138000, N'Đủ tiền.', '2026-11-16T17:07:55', 1), -- nv03 ca sang, tien mat he thong 3.138.000 d
(33, '2026-11-16', 8, 2068000, N'', '2026-11-16T22:04:21', 2068000, N'', '2026-11-16T22:47:15', 2), -- nv06 ca toi, tien mat he thong 2.068.000 d
(34, '2026-11-16', 7, 4071000, N'', '2026-11-16T22:20:31', 4071000, N'', '2026-11-16T22:58:51', 2), -- nv05 ca toi, tien mat he thong 4.071.000 d
(35, '2026-11-17', 9, 4465000, N'', '2026-11-17T15:05:10', 4465000, N'', '2026-11-17T16:41:37', 1), -- nv07 ca sang, tien mat he thong 4.465.000 d
(36, '2026-11-17', 8, 2754000, N'', '2026-11-17T15:20:11', 2754000, N'', '2026-11-17T16:07:49', 1), -- nv06 ca sang, tien mat he thong 2.754.000 d
(37, '2026-11-17', 3, 3363000, N'', '2026-11-17T21:56:04', 3363000, N'', '2026-11-17T22:34:10', 2), -- nv01 ca toi, tien mat he thong 3.363.000 d
(38, '2026-11-17', 10, 1602000, N'', '2026-11-17T22:12:57', 1602000, N'Đủ tiền.', '2026-11-18T09:20:08', 2), -- nv08 ca toi, tien mat he thong 1.602.000 d
(39, '2026-11-18', 4, 3519000, N'', '2026-11-18T15:12:13', 3519000, N'', '2026-11-18T16:22:18', 1), -- nv02 ca sang, tien mat he thong 3.519.000 d
(40, '2026-11-18', 3, 4628000, N'', '2026-11-18T15:20:14', 4628000, N'Đủ tiền.', '2026-11-18T15:51:34', 1), -- nv01 ca sang, tien mat he thong 4.628.000 d
(41, '2026-11-18', 6, 1854000, N'', '2026-11-18T22:12:27', 1854000, N'', '2026-11-19T08:29:43', 2), -- nv04 ca toi, tien mat he thong 1.854.000 d
(42, '2026-11-18', 5, 4071000, N'', '2026-11-18T22:21:49', 4071000, N'Khớp báo cáo.', '2026-11-19T09:08:08', 2), -- nv03 ca toi, tien mat he thong 4.071.000 d
(43, '2026-11-19', 6, 5564000, N'', '2026-11-19T15:09:46', 5564000, N'Khớp báo cáo.', '2026-11-19T16:54:22', 1), -- nv04 ca sang, tien mat he thong 5.564.000 d
(44, '2026-11-19', 7, 5504000, N'Dư 20.000 đ, nghi khách đưa dư.', '2026-11-19T15:17:07', 5504000, N'Đã đối soát, ghi nhận chênh lệch theo báo cáo nhân viên.', '2026-11-19T16:30:38', 1), -- nv05 ca sang, tien mat he thong 5.484.000 d
(45, '2026-11-19', 8, 3747000, N'', '2026-11-19T22:03:36', 3747000, N'Đủ tiền.', '2026-11-20T08:55:08', 2), -- nv06 ca toi, tien mat he thong 3.747.000 d
(46, '2026-11-19', 9, 5029000, N'', '2026-11-19T22:23:11', 5029000, N'Đủ tiền.', '2026-11-20T09:13:15', 2), -- nv07 ca toi, tien mat he thong 5.029.000 d
(47, '2026-11-20', 9, 6697000, N'', '2026-11-20T15:09:17', 6697000, N'Đủ tiền.', '2026-11-20T15:40:53', 1), -- nv07 ca sang, tien mat he thong 6.697.000 d
(48, '2026-11-20', 10, 3783000, N'', '2026-11-20T15:13:23', 3783000, N'Khớp báo cáo.', '2026-11-20T16:40:29', 1), -- nv08 ca sang, tien mat he thong 3.783.000 d
(49, '2026-11-20', 3, 3861000, N'', '2026-11-20T15:17:57', 3861000, N'', '2026-11-20T16:48:58', 1), -- nv01 ca sang, tien mat he thong 3.861.000 d
(50, '2026-11-20', 5, 3236000, N'Thiếu 10.000 đ, chưa rõ nguyên nhân.', '2026-11-20T21:59:41', 3246000, N'Kiểm đếm lại đủ tiền theo hệ thống, nhân viên đếm nhầm.', '2026-11-21T08:29:40', 2), -- nv03 ca toi, tien mat he thong 3.246.000 d
(51, '2026-11-20', 6, 1920000, N'', '2026-11-20T22:10:37', 1920000, N'Đủ tiền.', '2026-11-20T22:33:00', 2), -- nv04 ca toi, tien mat he thong 1.920.000 d
(52, '2026-11-20', 4, 1776000, N'', '2026-11-20T22:12:27', 1776000, N'Khớp báo cáo.', '2026-11-20T22:52:04', 2), -- nv02 ca toi, tien mat he thong 1.776.000 d
(53, '2026-11-21', 4, 3333000, N'', '2026-11-21T15:12:02', 3333000, N'', '2026-11-21T16:56:25', 1), -- nv02 ca sang, tien mat he thong 3.333.000 d
(54, '2026-11-21', 5, 6054000, N'', '2026-11-21T15:13:39', 6054000, N'', '2026-11-21T16:04:03', 1), -- nv03 ca sang, tien mat he thong 6.054.000 d
(55, '2026-11-21', 6, 3345000, N'', '2026-11-21T15:21:22', 3345000, N'Khớp báo cáo.', '2026-11-21T17:17:47', 1), -- nv04 ca sang, tien mat he thong 3.345.000 d
(56, '2026-11-21', 8, 1992000, N'', '2026-11-21T21:58:38', 1992000, N'', '2026-11-21T22:41:14', 2), -- nv06 ca toi, tien mat he thong 1.992.000 d
(57, '2026-11-21', 7, 2284000, N'Dư 10.000 đ do khách không lấy tiền thối.', '2026-11-21T22:12:58', 2284000, N'Đã đối soát, ghi nhận chênh lệch theo báo cáo nhân viên.', '2026-11-21T22:52:49', 2), -- nv05 ca toi, tien mat he thong 2.274.000 d
(58, '2026-11-21', 9, 3464000, N'', '2026-11-21T22:17:46', 3464000, N'Đủ tiền.', '2026-11-22T08:40:23', 2), -- nv07 ca toi, tien mat he thong 3.464.000 d
(59, '2026-11-22', 8, 3707000, N'Thiếu 10.000 đ, chưa rõ nguyên nhân.', '2026-11-22T15:07:17', 3707000, N'Đã đối soát, ghi nhận chênh lệch theo báo cáo nhân viên.', '2026-11-22T15:49:50', 1), -- nv06 ca sang, tien mat he thong 3.717.000 d
(60, '2026-11-22', 9, 4359000, N'', '2026-11-22T15:08:42', 4359000, N'Khớp báo cáo.', '2026-11-22T16:55:13', 1), -- nv07 ca sang, tien mat he thong 4.359.000 d
(61, '2026-11-22', 7, 4867000, N'', '2026-11-22T15:13:05', 4867000, N'', '2026-11-22T16:49:21', 1), -- nv05 ca sang, tien mat he thong 4.867.000 d
(62, '2026-11-22', 4, 3129000, N'', '2026-11-22T21:57:43', 3129000, N'Khớp báo cáo.', '2026-11-22T22:38:43', 2), -- nv02 ca toi, tien mat he thong 3.129.000 d
(63, '2026-11-22', 10, 2316000, N'', '2026-11-22T22:05:42', 2316000, N'Đủ tiền.', '2026-11-23T09:13:00', 2), -- nv08 ca toi, tien mat he thong 2.316.000 d
(64, '2026-11-22', 3, 1266000, N'', '2026-11-22T22:18:09', 1266000, N'Khớp báo cáo.', '2026-11-22T22:41:35', 2), -- nv01 ca toi, tien mat he thong 1.266.000 d
(65, '2026-11-23', 3, 5046000, N'', '2026-11-23T15:09:44', 5046000, N'Khớp báo cáo.', '2026-11-23T15:49:54', 1), -- nv01 ca sang, tien mat he thong 5.046.000 d
(66, '2026-11-23', 10, 2354000, N'Dư 20.000 đ, nghi khách đưa dư.', '2026-11-23T15:20:37', 2354000, N'Đã đối soát, ghi nhận chênh lệch theo báo cáo nhân viên.', '2026-11-23T16:07:09', 1), -- nv08 ca sang, tien mat he thong 2.334.000 d
(67, '2026-11-23', 5, 3307000, N'', '2026-11-23T21:57:49', 3307000, N'Khớp báo cáo.', '2026-11-24T08:34:06', 2), -- nv03 ca toi, tien mat he thong 3.307.000 d
(68, '2026-11-23', 4, 2904000, N'', '2026-11-23T22:14:37', 2904000, N'', '2026-11-24T09:06:23', 2), -- nv02 ca toi, tien mat he thong 2.904.000 d
(69, '2026-11-24', 6, 3150000, N'', '2026-11-24T15:04:50', 3150000, N'', '2026-11-24T16:26:12', 1), -- nv04 ca sang, tien mat he thong 3.150.000 d
(70, '2026-11-24', 5, 3790000, N'', '2026-11-24T15:06:25', 3790000, N'', '2026-11-24T15:53:03', 1), -- nv03 ca sang, tien mat he thong 3.790.000 d
(71, '2026-11-24', 8, 2001000, N'', '2026-11-24T22:17:53', 2001000, N'Đủ tiền.', '2026-11-25T08:30:38', 2), -- nv06 ca toi, tien mat he thong 2.001.000 d
(72, '2026-11-24', 7, 2268000, N'', '2026-11-24T22:24:30', 2268000, N'Đủ tiền.', '2026-11-25T08:57:37', 2), -- nv05 ca toi, tien mat he thong 2.268.000 d
(73, '2026-11-25', 9, 4996000, N'', '2026-11-25T15:05:23', 4996000, N'', '2026-11-25T16:53:05', 1), -- nv07 ca sang, tien mat he thong 4.996.000 d
(74, '2026-11-25', 8, NULL, NULL, NULL, 4248000, N'Nhân viên quên nộp chốt ca, QTV tự kiểm két và xác nhận.', '2026-11-25T16:06:28', 1), -- nv06 ca sang, tien mat he thong 4.248.000 d
(75, '2026-11-25', 3, 3174000, N'', '2026-11-25T22:05:07', 3174000, N'Đủ tiền.', '2026-11-25T22:34:44', 2), -- nv01 ca toi, tien mat he thong 3.174.000 d
(76, '2026-11-25', 10, 2358000, N'', '2026-11-25T22:23:04', 2358000, N'', '2026-11-26T09:03:08', 2), -- nv08 ca toi, tien mat he thong 2.358.000 d
(77, '2026-11-26', 3, 4767000, N'', '2026-11-26T15:11:28', 4767000, N'Khớp báo cáo.', '2026-11-26T16:29:09', 1), -- nv01 ca sang, tien mat he thong 4.767.000 d
(78, '2026-11-26', 4, 4904000, N'', '2026-11-26T15:13:28', 4904000, N'', '2026-11-26T16:29:58', 1), -- nv02 ca sang, tien mat he thong 4.904.000 d
(79, '2026-11-26', 5, 5010000, N'', '2026-11-26T22:06:19', 5010000, N'', '2026-11-26T22:49:56', 2), -- nv03 ca toi, tien mat he thong 5.010.000 d
(80, '2026-11-26', 6, 1683000, N'', '2026-11-26T22:10:08', 1683000, N'Khớp báo cáo.', '2026-11-27T08:54:26', 2), -- nv04 ca toi, tien mat he thong 1.683.000 d
(81, '2026-11-27', 8, 1965000, N'', '2026-11-27T15:04:24', 1965000, N'Đủ tiền.', '2026-11-27T15:56:33', 1), -- nv06 ca sang, tien mat he thong 1.965.000 d
(82, '2026-11-27', 7, 4215000, N'', '2026-11-27T15:12:20', 4215000, N'', '2026-11-27T16:52:06', 1), -- nv05 ca sang, tien mat he thong 4.215.000 d
(83, '2026-11-27', 6, 4102000, N'Thiếu 50.000 đ, đã báo quản lý.', '2026-11-27T15:12:39', 4152000, N'Kiểm đếm lại đủ tiền theo hệ thống, nhân viên đếm nhầm.', '2026-11-27T16:38:21', 1), -- nv04 ca sang, tien mat he thong 4.152.000 d
(84, '2026-11-27', 9, 2116000, N'', '2026-11-27T21:58:10', NULL, NULL, NULL, NULL), -- nv07 ca toi, tien mat he thong 2.116.000 d
(85, '2026-11-27', 3, 3420000, N'', '2026-11-27T22:05:40', NULL, NULL, NULL, NULL), -- nv01 ca toi, tien mat he thong 3.420.000 d
(86, '2026-11-27', 10, 690000, N'', '2026-11-27T22:15:45', NULL, NULL, NULL, NULL); -- nv08 ca toi, tien mat he thong 690.000 d
SET IDENTITY_INSERT SHIFT_HANDOVER OFF;

COMMIT;

-- Tong hop sau khi chay
SELECT (SELECT COUNT(*) FROM ACCOUNT) AS TaiKhoan, (SELECT COUNT(*) FROM MOVIE) AS Phim, (SELECT COUNT(*) FROM SEAT) AS Ghe,
       (SELECT COUNT(*) FROM SHOWTIME) AS SuatChieu, (SELECT COUNT(*) FROM BOOKING) AS HoaDon, (SELECT COUNT(*) FROM TICKET) AS Ve,
       (SELECT COUNT(*) FROM CUSTOMER) AS Khach, (SELECT COUNT(*) FROM SHIFT_HANDOVER) AS ChotCa,
       (SELECT SUM(TotalAmount) FROM BOOKING WHERE BookingStatus = N'Paid') AS DoanhThu;
SELECT x.Hang, COUNT(*) AS SoKhach
FROM (SELECT CASE WHEN ISNULL(SUM(CASE WHEN b.BookingStatus = N'Paid' THEN b.TotalAmount END), 0) >= 3000000 THEN N'Vàng'
                  WHEN ISNULL(SUM(CASE WHEN b.BookingStatus = N'Paid' THEN b.TotalAmount END), 0) >= 1000000 THEN N'Bạc'
                  ELSE N'Thường' END AS Hang
      FROM CUSTOMER c LEFT JOIN BOOKING b ON b.CustomerID = c.CustomerID
      GROUP BY c.CustomerID) x
GROUP BY x.Hang;
