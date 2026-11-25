-- Du lieu them cho giai doan 23/11/2026 -> 07/12/2026. Chay SAU seed.sql, chi chay 1 lan.
-- Phim moi lay tu galaxycine.vn ngay 23/11/2026 (dang chieu + sap chieu khoi chieu truoc 07/12).
-- Lich chieu va hoa don la du lieu AO de co so lieu cho bao cao, khong phai lich that cua Galaxy.
-- Ngay nao seed.sql da co suat thi giu nguyen, file nay chi lap cac ngay con trong.
-- Hoa don sinh cho ca cac suat trong tuong lai (CreatedAt co the sau thoi diem chay script).
USE CINEMADB;
SET NOCOUNT ON;
SET XACT_ABORT ON;

IF NOT EXISTS (SELECT 1 FROM ACCOUNT) OR NOT EXISTS (SELECT 1 FROM ROOM)
BEGIN
    RAISERROR(N'Chưa có dữ liệu mẫu. Chạy seed.sql trước rồi mới chạy seed_2311_0712.sql.', 16, 1);
    RETURN;
END

IF EXISTS (SELECT 1 FROM MOVIE WHERE Title = N'Mẹ Mìn: Giao Kèo Với Quỷ')
BEGIN
    RAISERROR(N'seed_2311_0712.sql đã chạy rồi.', 16, 1);
    RETURN;
END

DECLARE @today DATE = CAST(GETDATE() AS date);
DECLARE @lastShowId INT = ISNULL((SELECT MAX(ShowtimeID) FROM SHOWTIME), 0);

BEGIN TRANSACTION;

-- ===== MOVIE moi =====
-- Bat Ca Ba Tay va Con Mat Thu Ba: galaxycine chua cong bo thoi luong/phan loai -> de tam 115 phut/T13, 100 phut/T18.
-- Hexed chua co phan loai -> de P (phim hoat hinh gia dinh).
INSERT INTO MOVIE (Title, DurationMin, Genre, Agerating, MovieStatus, ReleaseDate, PosterPath, MovieDescription) VALUES
(N'Ba Cây Số Từ Nơi Tận Cùng Thế Giới (EUFF)', 105, N'Giật Gân, Tâm Lý', N'T18', N'Đang chiếu', '2026-11-23',
 N'three-kilometres-to-the-end-of-the-world.jpg',
 N'Phim Romania của đạo diễn Emanuel Pârvu. Diễn viên: Ciprian Chiujdea, Bogdan Dumitrache, Laura Vasiliu.'),
(N'Amrum (EUFF)', 93, N'Tâm Lý, Lịch Sử', N'T13', N'Sắp chiếu', '2026-11-24', N'amrum.jpg',
 N'Phim Đức của đạo diễn Fatih Akin. Diễn viên: Jasper Billerbeck, Laura Tonke, Diane Kruger.'),
(N'Mẹ Mìn: Giao Kèo Với Quỷ', 112, N'Giật Gân, Tâm Lý', N'T18', N'Sắp chiếu', '2026-11-25', N'me-min.jpg',
 N'Phim Việt Nam của đạo diễn Jack Carry On. Diễn viên: Minh Hằng, Nhật Kim Anh, Khương Lê, Rima Thanh Vy. Suất chiếu sớm 25-26/11.'),
(N'Hexed: Thế Giới Phép Thuật', 110, N'Hoạt Hình, Gia Đình, Hài', N'P', N'Sắp chiếu', '2026-11-27', N'hexed.jpg',
 N'Phim hoạt hình Mỹ của Walt Disney Pictures, đạo diễn Jason Hand và Fawn Veerasunthorn. Lồng tiếng: Hailee Steinfeld, Rashida Jones.'),
(N'Gặp Gỡ Thông Gia: Dâu Mới Trình Làng', 106, N'Hài, Gia Đình', N'T13', N'Sắp chiếu', '2026-11-27', N'focker-in-law.jpg',
 N'Phim Mỹ của đạo diễn John Hamburg. Diễn viên: Robert De Niro, Ben Stiller, Ariana Grande.'),
(N'Bắt Cá Ba Tay', 115, N'Tình Cảm, Hài', N'T13', N'Sắp chiếu', '2026-12-04', N'bat-ca-ba-tay.jpg',
 N'Phim Việt Nam của đạo diễn Như Trang. Diễn viên: Thúy Ngân, Steven Nguyễn, Ngô Kiến Huy, Otis.'),
(N'Con Mắt Thứ Ba', 100, N'Kinh Dị', N'T18', N'Sắp chiếu', '2026-12-04', N'con-mat-thu-ba.jpg',
 N'Phim Việt Nam của đạo diễn Hàm Trần. Diễn viên: Minh Anh, Quang Tuấn, Trần Nghĩa, Ngọc Phước.');

-- Trang thai theo ngay chay script (Dau Truong Sinh Tu, Ma Mut da khoi chieu 20/11)
UPDATE MOVIE SET MovieStatus = CASE WHEN ReleaseDate <= @today THEN N'Đang chiếu' ELSE N'Sắp chiếu' END
WHERE MovieStatus = N'Sắp chiếu';

-- ===== SHOWTIME =====
-- 3 giai doan: 23-26/11 (lich hien tai + Dau Truong Sinh Tu, Ma Mut, EUFF, Me Min chieu som),
-- 27/11-03/12 (them Diem Mu, Hexed, Gap Go Thong Gia, Me Min), 04-07/12 (them Bat Ca Ba Tay, Con Mat Thu Ba).
-- Moi dong: phong, gio, phim, dinh dang, am thanh, ap dung tu ngay -> den ngay. Da tinh 15 phut don phong.
DECLARE @lich TABLE (RoomName NVARCHAR(50), Gio CHAR(5), Title NVARCHAR(200), Fmt NVARCHAR(10), Audio NVARCHAR(20), Tu DATE, Den DATE);
INSERT INTO @lich VALUES
-- ---- 23/11 -> 26/11 ----
(N'Phòng 1', '09:00', N'Trại Giam Hạnh Phúc', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 1', '11:30', N'Ngày Con Còn Mẹ', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 1', '13:45', N'Trại Giam Hạnh Phúc', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 1', '16:15', N'Bò Sữa Bay', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 1', '18:30', N'Trại Giam Hạnh Phúc', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 1', '21:00', N'Chị Chị Em Em 3', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 2', '09:00', N'Ma Mút Con Vượt Kỷ Băng Hà', N'2D', N'Lồng tiếng', '2026-11-23', '2026-11-26'),
(N'Phòng 2', '10:30', N'Kiến Lé Phiêu Lưu Ké', N'2D', N'Lồng tiếng', '2026-11-23', '2026-11-26'),
(N'Phòng 2', '12:15', N'Chàng Mèo Mang Mũ', N'2D', N'Lồng tiếng', '2026-11-23', '2026-11-26'),
(N'Phòng 2', '14:30', N'Ngày Con Còn Mẹ', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 2', '16:45', N'Thòng Lọng Ma: Quỷ Cái Đòi Mạng', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 2', '19:00', N'Ba Cây Số Từ Nơi Tận Cùng Thế Giới (EUFF)', N'2D', N'Phụ đề', '2026-11-23', '2026-11-23'),
(N'Phòng 2', '19:00', N'Amrum (EUFF)', N'2D', N'Phụ đề', '2026-11-24', '2026-11-24'),
(N'Phòng 2', '19:00', N'Mẹ Mìn: Giao Kèo Với Quỷ', N'2D', N'Phụ đề', '2026-11-25', '2026-11-26'),
(N'Phòng 2', '21:15', N'Trại Buôn Người', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 3', '09:30', N'Bí Kíp Luyện Cướp', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 3', '12:00', N'Kẻ Hồi Sinh', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 3', '14:00', N'Thiên Đường Tăm Tối', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 3', '16:00', N'Clayface', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 3', '18:15', N'Ngày Con Còn Mẹ', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 3', '20:30', N'Trại Giam Hạnh Phúc', N'2D', N'Phụ đề', '2026-11-23', '2026-11-24'),
(N'Phòng 3', '20:30', N'Mẹ Mìn: Giao Kèo Với Quỷ', N'2D', N'Phụ đề', '2026-11-25', '2026-11-26'),
(N'Phòng 4', '09:15', N'Ramayana: Khởi Nguồn Một Huyền Thoại', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 4', '12:30', N'Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 4', '15:30', N'Godzilla Trừ Không', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 4', '18:00', N'Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 4', '21:00', N'Bí Kíp Luyện Cướp', N'2D', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 5', '09:00', N'Dune: Hành Tinh Cát', N'IMAX', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 5', '12:15', N'Godzilla Trừ Không', N'IMAX', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 5', '15:00', N'Dune: Hành Tinh Cát - Phần Hai', N'IMAX', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 5', '18:15', N'Godzilla Trừ Không', N'IMAX', N'Phụ đề', '2026-11-23', '2026-11-26'),
(N'Phòng 5', '21:00', N'Dune: Hành Tinh Cát - Phần Hai', N'IMAX', N'Phụ đề', '2026-11-23', '2026-11-26'),
-- ---- 27/11 -> 07/12 (Phong 4, 5 va phan lon Phong 2 giu nguyen ca giai doan) ----
(N'Phòng 1', '09:00', N'Trại Giam Hạnh Phúc', N'2D', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 1', '11:30', N'Gặp Gỡ Thông Gia: Dâu Mới Trình Làng', N'2D', N'Phụ đề', '2026-11-27', '2026-12-03'),
(N'Phòng 1', '11:30', N'Bắt Cá Ba Tay', N'2D', N'Phụ đề', '2026-12-04', '2026-12-07'),
(N'Phòng 1', '13:45', N'Trại Giam Hạnh Phúc', N'2D', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 1', '16:15', N'Mẹ Mìn: Giao Kèo Với Quỷ', N'2D', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 1', '18:30', N'Trại Giam Hạnh Phúc', N'2D', N'Phụ đề', '2026-11-27', '2026-12-03'),
(N'Phòng 1', '18:30', N'Bắt Cá Ba Tay', N'2D', N'Phụ đề', '2026-12-04', '2026-12-07'),
(N'Phòng 1', '21:00', N'Mẹ Mìn: Giao Kèo Với Quỷ', N'2D', N'Phụ đề', '2026-11-27', '2026-12-03'),
(N'Phòng 1', '21:00', N'Trại Giam Hạnh Phúc', N'2D', N'Phụ đề', '2026-12-04', '2026-12-07'),
(N'Phòng 2', '09:00', N'Hexed: Thế Giới Phép Thuật', N'2D', N'Lồng tiếng', '2026-11-27', '2026-12-07'),
(N'Phòng 2', '11:15', N'Ma Mút Con Vượt Kỷ Băng Hà', N'2D', N'Lồng tiếng', '2026-11-27', '2026-12-07'),
(N'Phòng 2', '12:45', N'Hexed: Thế Giới Phép Thuật', N'2D', N'Lồng tiếng', '2026-11-27', '2026-12-07'),
(N'Phòng 2', '15:00', N'Ngày Con Còn Mẹ', N'2D', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 2', '17:15', N'Gặp Gỡ Thông Gia: Dâu Mới Trình Làng', N'2D', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 2', '19:30', N'Bò Sữa Bay', N'2D', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 2', '21:45', N'Thòng Lọng Ma: Quỷ Cái Đòi Mạng', N'2D', N'Phụ đề', '2026-11-27', '2026-12-03'),
(N'Phòng 2', '21:45', N'Con Mắt Thứ Ba', N'2D', N'Phụ đề', '2026-12-04', '2026-12-07'),
(N'Phòng 3', '09:30', N'Kiến Lé Phiêu Lưu Ké', N'2D', N'Lồng tiếng', '2026-11-27', '2026-12-07'),
(N'Phòng 3', '11:15', N'Ngày Con Còn Mẹ', N'2D', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 3', '13:30', N'Bí Kíp Luyện Cướp', N'2D', N'Phụ đề', '2026-11-27', '2026-12-03'),
(N'Phòng 3', '13:30', N'Con Mắt Thứ Ba', N'2D', N'Phụ đề', '2026-12-04', '2026-12-07'),
(N'Phòng 3', '16:00', N'Chị Chị Em Em 3', N'2D', N'Phụ đề', '2026-11-27', '2026-12-03'),
(N'Phòng 3', '15:30', N'Gặp Gỡ Thông Gia: Dâu Mới Trình Làng', N'2D', N'Phụ đề', '2026-12-04', '2026-12-07'),
(N'Phòng 3', '18:30', N'Điểm Mù', N'2D', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 3', '21:45', N'Mẹ Mìn: Giao Kèo Với Quỷ', N'2D', N'Phụ đề', '2026-11-27', '2026-12-03'),
(N'Phòng 3', '21:45', N'Con Mắt Thứ Ba', N'2D', N'Phụ đề', '2026-12-04', '2026-12-07'),
(N'Phòng 4', '09:15', N'Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân', N'2D', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 4', '12:15', N'Ramayana: Khởi Nguồn Một Huyền Thoại', N'2D', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 4', '15:30', N'Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân', N'2D', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 4', '18:30', N'Godzilla Trừ Không', N'2D', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 4', '21:00', N'Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân', N'2D', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 5', '09:00', N'Dune: Hành Tinh Cát - Phần Hai', N'IMAX', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 5', '12:15', N'Godzilla Trừ Không', N'IMAX', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 5', '15:00', N'Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân', N'IMAX', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 5', '18:00', N'Dune: Hành Tinh Cát - Phần Hai', N'IMAX', N'Phụ đề', '2026-11-27', '2026-12-07'),
(N'Phòng 5', '21:15', N'Godzilla Trừ Không', N'IMAX', N'Phụ đề', '2026-11-27', '2026-12-07');

-- Ten phim/phong go sai thi bao loi thay vi am tham bo qua
IF EXISTS (SELECT 1 FROM @lich l WHERE NOT EXISTS (SELECT 1 FROM MOVIE m WHERE m.Title = l.Title)
                                    OR NOT EXISTS (SELECT 1 FROM ROOM r WHERE r.RoomName = l.RoomName))
BEGIN
    RAISERROR(N'Lịch chiếu có tên phim/phòng không khớp CSDL.', 16, 1);
    ROLLBACK;
    RETURN;
END

DECLARE @ngay TABLE (D DATE PRIMARY KEY);
INSERT INTO @ngay (D)
SELECT DATEADD(DAY, n, '2026-11-23')
FROM (SELECT TOP (15) CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS INT) - 1 AS n FROM sys.all_objects) x;
-- Ngay seed.sql da co suat thi giu nguyen
DELETE g FROM @ngay g
WHERE EXISTS (SELECT 1 FROM SHOWTIME s WHERE s.StartTime >= g.D AND s.StartTime < DATEADD(DAY, 1, g.D));

INSERT INTO SHOWTIME (MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice)
SELECT m.MovieID, r.RoomID,
       DATEADD(MINUTE, DATEDIFF(MINUTE, CAST('00:00' AS time), CAST(l.Gio AS time)), CAST(g.D AS datetime2)),
       l.Fmt, l.Audio,
       CASE l.Fmt WHEN N'IMAX' THEN 120000 ELSE 75000 END
FROM @ngay g
JOIN @lich l ON g.D BETWEEN l.Tu AND l.Den
JOIN ROOM r ON r.RoomName = l.RoomName
JOIN MOVIE m ON m.Title = l.Title;

-- ===== BOOKING + TICKET (ao) cho cac suat vua them =====
-- Cung quy tac voi seed.sql: 1-4 ghe/don (thinh thoang 1 cap ghe doi), VIP va ghe doi = BasePrice x 1.2,
-- 1 diem / 10.000 d khi co khach thanh vien, ~5% don bi huy. Thu 6, 7, CN dong khach hon.
DECLARE @r FLOAT = RAND(2311);
DECLARE @showId INT, @roomId INT, @start DATETIME2, @base MONEY;
DECLARE @nb INT, @i INT, @k INT, @key INT, @row NVARCHAR(5), @fromNo INT, @pairNo INT;
DECLARE @total MONEY, @method NVARCHAR(20), @cash MONEY, @custId INT, @points INT, @accId INT;
DECLARE @created DATETIME2, @status NVARCHAR(20), @cancelAt DATETIME2, @reason NVARCHAR(200), @bookingId INT;
DECLARE @nCust INT = (SELECT COUNT(*) FROM CUSTOMER);
DECLARE @pick TABLE (SeatID INT, Price MONEY);

-- Gom ca cac suat chua chieu cua seed.sql trong 23/11 -> 07/12 (seed.sql chi ban truoc it ve cho suat tuong lai)
DECLARE @now DATETIME2 = SYSDATETIME();
DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
    SELECT ShowtimeID, RoomID, StartTime, BasePrice FROM SHOWTIME
    WHERE ShowtimeID > @lastShowId
       OR (StartTime >= @now AND StartTime >= '2026-11-23' AND StartTime < '2026-12-08')
    ORDER BY StartTime, RoomID;
OPEN cur;
FETCH NEXT FROM cur INTO @showId, @roomId, @start, @base;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @nb = 2 + FLOOR(RAND() * 8);
    IF DATEPART(HOUR, @start) >= 18 SET @nb = @nb + FLOOR(RAND() * 5);
    -- 01/01/1900 la thu 2 => 4, 5, 6 la thu 6, thu 7, CN
    IF (DATEDIFF(DAY, '19000101', @start) % 7) IN (4, 5, 6) SET @nb = @nb + 1 + FLOOR(RAND() * 4);
    SET @i = 0;
    WHILE @i < @nb
    BEGIN
        SET @i = @i + 1;
        DELETE FROM @pick;
        SET @key = FLOOR(RAND() * 100000);

        IF RAND() < 0.12
        BEGIN
            SET @pairNo = NULL;
            SELECT TOP 1 @pairNo = se.SeatNumber
            FROM SEAT se
            WHERE se.RoomID = @roomId AND se.SeatType = N'Couple' AND se.SeatNumber % 2 = 1
              AND NOT EXISTS (SELECT 1 FROM TICKET t JOIN SEAT s2 ON s2.SeatID = t.SeatID
                              WHERE t.ShowtimeID = @showId AND t.TicketStatus = N'Active'
                                AND s2.RoomID = se.RoomID AND s2.RowLabel = se.RowLabel
                                AND s2.SeatNumber IN (se.SeatNumber, se.SeatNumber + 1))
            ORDER BY ABS(CHECKSUM(se.SeatID, @key));
            IF @pairNo IS NOT NULL
                INSERT INTO @pick (SeatID, Price)
                SELECT SeatID, @base * 1.2 FROM SEAT
                WHERE RoomID = @roomId AND SeatType = N'Couple' AND SeatNumber IN (@pairNo, @pairNo + 1);
        END
        ELSE
        BEGIN
            SET @k = 1 + FLOOR(RAND() * 4);
            SET @fromNo = 1 + FLOOR(RAND() * 11);
            SELECT TOP 1 @row = x.RowLabel
            FROM (SELECT DISTINCT RowLabel FROM SEAT WHERE RoomID = @roomId AND SeatType <> N'Couple') x
            ORDER BY ABS(CHECKSUM(x.RowLabel, @key));
            INSERT INTO @pick (SeatID, Price)
            SELECT TOP (@k) se.SeatID, CASE se.SeatType WHEN N'Standard' THEN @base ELSE @base * 1.2 END
            FROM SEAT se
            WHERE se.RoomID = @roomId AND se.RowLabel = @row AND se.SeatNumber >= @fromNo
              AND NOT EXISTS (SELECT 1 FROM TICKET t WHERE t.ShowtimeID = @showId
                              AND t.SeatID = se.SeatID AND t.TicketStatus = N'Active')
            ORDER BY se.SeatNumber;
        END

        IF NOT EXISTS (SELECT 1 FROM @pick) CONTINUE;

        SELECT @total = SUM(Price) FROM @pick;

        SET @r = RAND();
        SET @method = CASE WHEN @r < 0.5 THEN N'Cash' WHEN @r < 0.8 THEN N'Transfer' ELSE N'Card' END;
        SET @cash = CASE WHEN @method = N'Cash' THEN CEILING(@total / 50000) * 50000 END;

        SET @custId = NULL;
        IF RAND() < 0.4
            SELECT @custId = CustomerID FROM CUSTOMER
            ORDER BY CustomerID OFFSET CAST(FLOOR(RAND() * @nCust) AS INT) ROWS FETCH NEXT 1 ROWS ONLY;
        SELECT @points = CASE WHEN @custId IS NULL THEN 0
            ELSE CAST(FLOOR(SUM(p.Price * CASE se.SeatType WHEN N'Vip' THEN 0.07 WHEN N'Couple' THEN 0.10 ELSE 0.05 END) / 1000.0) AS INT) END
        FROM @pick p JOIN SEAT se ON se.SeatID = p.SeatID;

        -- nv04 da nghi viec nen khong ban suat moi
        SELECT @accId = AccountID FROM ACCOUNT WHERE Username = CONCAT('nv0', 1 + FLOOR(RAND() * 3));

        SET @created = DATEADD(MINUTE, -(5 + FLOOR(RAND() * 2880)), @start);

        SET @status = N'Paid';
        SET @cancelAt = NULL;
        SET @reason = NULL;
        IF RAND() < 0.05
        BEGIN
            SET @status = N'Cancelled';
            SET @cancelAt = DATEADD(MINUTE, 3 + FLOOR(RAND() * 60), @created);
            SET @r = RAND();
            SET @reason = CASE WHEN @r < 0.4 THEN N'Khách đổi ý' WHEN @r < 0.7 THEN N'Nhầm suất / ghế'
                               WHEN @r < 0.9 THEN N'Lỗi thanh toán' ELSE N'Sự cố phòng chiếu' END;
        END

        INSERT INTO BOOKING (AccountID, CustomerID, CreatedAt, TotalAmount, BookingStatus, PaymentMethod,
                             CashGiven, PointsEarned, CancelReason, CancelledAt, CancelledBy)
        VALUES (@accId, @custId, @created, @total, @status, @method,
                @cash, @points, @reason, @cancelAt, CASE WHEN @status = N'Cancelled' THEN @accId END);
        SET @bookingId = SCOPE_IDENTITY();

        INSERT INTO TICKET (BookingID, ShowtimeID, RoomID, SeatID, Price, TicketStatus)
        SELECT @bookingId, @showId, @roomId, SeatID, Price,
               CASE WHEN @status = N'Cancelled' THEN N'Cancelled' ELSE N'Active' END
        FROM @pick;
    END
    FETCH NEXT FROM cur INTO @showId, @roomId, @start, @base;
END
CLOSE cur;
DEALLOCATE cur;

-- Diem cua khach = tong diem cac don con hieu luc
UPDATE c SET Points = ISNULL((SELECT SUM(b.PointsEarned) FROM BOOKING b
                              WHERE b.CustomerID = c.CustomerID AND b.BookingStatus = N'Paid'), 0)
FROM CUSTOMER c;

COMMIT;

SELECT (SELECT COUNT(*) FROM MOVIE) AS Phim,
       (SELECT COUNT(*) FROM SHOWTIME WHERE ShowtimeID > @lastShowId) AS SuatThem,
       (SELECT COUNT(*) FROM BOOKING b WHERE EXISTS (SELECT 1 FROM TICKET t JOIN SHOWTIME s ON s.ShowtimeID = t.ShowtimeID
                                                     WHERE t.BookingID = b.BookingID AND s.StartTime >= '2026-11-23')) AS DonTu2311,
       (SELECT CAST(MIN(StartTime) AS date) FROM SHOWTIME WHERE ShowtimeID > @lastShowId) AS TuNgay,
       (SELECT CAST(MAX(StartTime) AS date) FROM SHOWTIME WHERE ShowtimeID > @lastShowId) AS DenNgay;
