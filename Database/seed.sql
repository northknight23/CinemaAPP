-- Du lieu mau cho CINEMADB. Chay sau CinemaDB.sql, tren CSDL vua tao (con trong).
-- Phim lay tu galaxycine.vn ngay 18/11/2026. Suat chieu va don ban tinh theo ngay chay script
-- (6 ngay truoc -> 2 ngay sau) nen luc nao chay cung co suat hom nay de ban.
-- Mat khau moi tai khoan: 123456
USE CINEMADB;
SET NOCOUNT ON;

IF EXISTS (SELECT 1 FROM MOVIE) OR EXISTS (SELECT 1 FROM ACCOUNT)
BEGIN
    RAISERROR(N'CSDL đã có dữ liệu. Chạy lại CinemaDB.sql để tạo CSDL mới rồi mới chạy seed.sql.', 16, 1);
    RETURN;
END

-- ===== ACCOUNT =====
INSERT INTO ACCOUNT (Username, PasswordHash, FullName, AccountRole, IsActive)
SELECT v.Username, LOWER(CONVERT(NVARCHAR(64), HASHBYTES('SHA2_256', CAST('123456' AS VARCHAR(50))), 2)), v.FullName, v.AccountRole, v.IsActive
FROM (VALUES
    ('admin', N'Lê Minh Quân',    N'Admin', 1),
    ('nv01',  N'Nguyễn Thu Hà',   N'Staff', 1),
    ('nv02',  N'Trần Quốc Bảo',   N'Staff', 1),
    ('nv03',  N'Phạm Ngọc Lan',   N'Staff', 1),
    ('nv04',  N'Võ Thành Đạt',    N'Staff', 0)
) v(Username, FullName, AccountRole, IsActive);

-- ===== MOVIE =====
INSERT INTO MOVIE (Title, DurationMin, Genre, Agerating, MovieStatus, ReleaseDate, PosterPath, MovieDescription) VALUES
(N'Trại Giam Hạnh Phúc', 127, N'Hài, Tình Cảm, Gia Đình', N'T16', N'Đang chiếu', '2026-11-18', NULL,
 N'Phim Việt Nam của đạo diễn Trung Lùn. Diễn viên: Tuấn Trần, Ma Ran Đô, Lương Thế Thành, Tiến Luật.'),
(N'Ngày Con Còn Mẹ', 107, N'Gia Đình, Tâm Lý', N'T16', N'Đang chiếu', '2026-11-11', NULL,
 N'Phim Việt Nam của đạo diễn Vũ Ngọc Đãng. Diễn viên: Hồng Đào, Phương Anh Đào, Ma Ran Đô.'),
(N'Godzilla Trừ Không', 135, N'Hành Động', N'T16', N'Đang chiếu', '2026-11-06', NULL,
 N'Phim Nhật Bản của đạo diễn Yamazaki Takashi. Diễn viên: Kamiki Ryunosuke, Hamabe Minami, Yamada Yuki.'),
(N'Bí Kíp Luyện Cướp', 122, N'Hành Động', N'T18', N'Đang chiếu', '2026-11-12', NULL,
 N'Phim Mỹ của đạo diễn David Leitch. Diễn viên: Nicholas Hoult, Pete Davidson, Zoë Kravitz.'),
(N'Chị Chị Em Em 3', 122, N'Tâm Lý, Tình Cảm', N'T18', N'Đang chiếu', '2026-10-29', NULL,
 N'Phim Việt Nam của đạo diễn Nguyễn Hữu Hoàng. Diễn viên: Chi Pu, Ninh Dương Lan Ngọc, NSND Lê Khanh.'),
(N'Ramayana: Khởi Nguồn Một Huyền Thoại', 168, N'Giả Tưởng, Hành Động', N'T13', N'Đang chiếu', '2026-11-06', NULL,
 N'Phim Ấn Độ của đạo diễn Nitesh Tiwari. Diễn viên: Ranbir Kapoor, Yash, Sai Pallavi.'),
(N'Dune: Hành Tinh Cát - Phần Hai', 166, N'Giả Tưởng, Hành Động', N'T16', N'Đang chiếu', '2026-11-18', NULL,
 N'Phim Mỹ của đạo diễn Denis Villeneuve. Diễn viên: Timothée Chalamet, Zendaya, Rebecca Ferguson.'),
(N'Kiến Lé Phiêu Lưu Ké', 77, N'Hoạt Hình', N'P', N'Đang chiếu', '2026-11-14', NULL,
 N'Phim hoạt hình Đức của đạo diễn Sean Heuston, chiếu bản lồng tiếng.'),
(N'Kẻ Hồi Sinh', 101, N'Hành Động', N'T16', N'Đang chiếu', '2026-11-13', NULL,
 N'Phim Hàn Quốc của đạo diễn Baek Jong Yeol. Diễn viên: Koo Kyo Hwan, Shin Seung Ho, Kang Ki Young.'),
(N'Dune: Hành Tinh Cát', 165, N'Hành Động, Phiêu Lưu, Tâm Lý', N'T13', N'Đang chiếu', '2026-11-13', NULL,
 N'Phim Mỹ của đạo diễn Denis Villeneuve. Diễn viên: Timothée Chalamet, Zendaya, Oscar Isaac.'),
(N'Thòng Lọng Ma: Quỷ Cái Đòi Mạng', 105, N'Kinh Dị', N'T18', N'Đang chiếu', '2026-11-11', NULL,
 N'Phim Đài Loan của đạo diễn Liêu Sĩ Hàn. Diễn viên: Wilson Hsu, Vera Chen.'),
(N'Chàng Mèo Mang Mũ', 107, N'Hoạt Hình, Phiêu Lưu', N'P', N'Đang chiếu', '2026-11-06', NULL,
 N'Phim hoạt hình Mỹ của Warner Bros. Animation, chiếu bản lồng tiếng.'),
(N'Thiên Đường Tăm Tối', 100, N'Tâm Lý, Giật Gân', N'T18', N'Đang chiếu', '2026-11-05', NULL,
 N'Phim Hàn Quốc của đạo diễn Yeon Sang Ho. Diễn viên: Kim Hyun Joo, Bae Hyun Sung.'),
(N'Bò Sữa Bay', 108, N'Hài, Tình Cảm, Hành Động', N'T18', N'Đang chiếu', '2026-11-05', NULL,
 N'Phim Việt Nam của đạo diễn Nguyễn Phạm Thành Đạt. Diễn viên: Nguyễn Hùng, Ngọc Xuân, Võ Điền Gia Huy.'),
(N'Clayface', 108, N'Kinh Dị, Giật Gân', N'T18', N'Đang chiếu', '2026-10-28', NULL,
 N'Phim Mỹ của đạo diễn James Watkins. Diễn viên: Tom Rhys Harries, Naomi Ackie, Eddie Marsan.'),
(N'Shaun The Sheep: "Quái Lạ" Ghé Nhà', 91, N'Hoạt Hình', N'P', N'Đang chiếu', '2026-10-16', NULL,
 N'Phim hoạt hình của Aardman Animations, đạo diễn Steve Cox và Matthew Walker.'),
(N'Trại Buôn Người', 135, N'Hành Động, Tâm Lý', N'T18', N'Đang chiếu', '2026-09-24', NULL,
 N'Phim Việt Nam của đạo diễn Toni Dương Bảo Anh. Diễn viên: Steven Nguyễn, Quách Ngọc Ngoan, Huỳnh Minh Kiên.'),
(N'Điểm Mù', 175, N'Tài Liệu', N'T16', N'Sắp chiếu', '2026-11-27', NULL,
 N'Phim Mỹ của hãng A24, đạo diễn Nathan Fielder và Lance Oppenheim.'),
(N'Ma Mút Con Vượt Kỷ Băng Hà', 73, N'Hoạt Hình, Phiêu Lưu', N'P', N'Sắp chiếu', '2026-11-20', NULL,
 N'Phim hoạt hình Nga của đạo diễn Alexander Voytinskiy.'),
(N'Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân', 158, N'Hành Động, Giả Tưởng', N'T16', N'Sắp chiếu', '2026-11-20', NULL,
 N'Phim Mỹ của đạo diễn Francis Lawrence. Diễn viên: Mckenna Grace, Ralph Fiennes, Joseph Zada.'),
(N'Rosetta (EUFF)', 95, N'Tâm Lý', N'T16', N'Sắp chiếu', '2026-11-21', NULL,
 N'Phim Pháp - Bỉ của đạo diễn Luc Dardenne và Jean-Pierre Dardenne.');

-- Poster: copy thu muc Posters vao Assets/Posters cua project, app tu tim theo ten file
UPDATE m SET PosterPath = p.FileName
FROM MOVIE m
JOIN (VALUES
    (N'Trại Giam Hạnh Phúc', N'trai-giam-hanh-phuc.jpg'),
    (N'Ngày Con Còn Mẹ', N'ngay-con-con-me.jpg'),
    (N'Godzilla Trừ Không', N'godzilla-minus-zero.jpg'),
    (N'Bí Kíp Luyện Cướp', N'how-to-rob-a-bank.jpg'),
    (N'Chị Chị Em Em 3', N'chi-chi-em-em-3.jpg'),
    (N'Ramayana: Khởi Nguồn Một Huyền Thoại', N'ramayana-rise-of-a-legend.jpg'),
    (N'Dune: Hành Tinh Cát - Phần Hai', N'dune-2.jpg'),
    (N'Kiến Lé Phiêu Lưu Ké', N'arnie--barney.jpg'),
    (N'Kẻ Hồi Sinh', N'reawaken-man-the-red.jpg'),
    (N'Dune: Hành Tinh Cát', N'dune.jpg'),
    (N'Thòng Lọng Ma: Quỷ Cái Đòi Mạng', N'the-rope-curse-4-kuntilanak.jpg'),
    (N'Chàng Mèo Mang Mũ', N'the-cat-in-the-hat.jpg'),
    (N'Thiên Đường Tăm Tối', N'paradise-lost.jpg'),
    (N'Bò Sữa Bay', N'bo-sua-bay.jpg'),
    (N'Clayface', N'clayface.jpg'),
    (N'Shaun The Sheep: "Quái Lạ" Ghé Nhà', N'shaun-the-sheep-the-beast-of-mossy-bottom.jpg'),
    (N'Trại Buôn Người', N'trai-buon-nguoi.jpg'),
    (N'Điểm Mù', N'you-can-see-everything.jpg'),
    (N'Ma Mút Con Vượt Kỷ Băng Hà', N'mother-for-a-little-mammoth.jpg'),
    (N'Đấu Trường Sinh Tử: Bình Minh Ngày Chiêu Quân', N'the-hunger-games-sunrise-on-the-reaping.jpg'),
    (N'Rosetta (EUFF)', N'rosetta.jpg')
) p(Title, FileName) ON p.Title = m.Title;

-- ===== ROOM + SEAT =====
-- Bo cuc giong man ban ve: 12 ghe/hang, hang thuong -> VIP -> hang ghe doi cuoi phong (moi cap = 2 dong SEAT)
INSERT INTO ROOM (RoomName, RoomType, NumRows, SeatsPerRow) VALUES
(N'Phòng 1', N'2D', 9, 12),
(N'Phòng 2', N'2D', 9, 12),
(N'Phòng 3', N'2D', 9, 12),
(N'Phòng 4', N'3D', 9, 12),
(N'Phòng 5', N'IMAX', 11, 12);

INSERT INTO SEAT (RoomID, RowLabel, SeatNumber, SeatType)
SELECT r.RoomID, h.RowLabel, n.Num, h.SeatType
FROM ROOM r
JOIN (VALUES
    (0, N'A', N'Standard'), (0, N'B', N'Standard'), (0, N'C', N'Standard'),
    (0, N'D', N'Vip'), (0, N'E', N'Vip'), (0, N'F', N'Vip'), (0, N'G', N'Vip'), (0, N'H', N'Vip'),
    (0, N'J', N'Couple'),
    (1, N'A', N'Standard'), (1, N'B', N'Standard'), (1, N'C', N'Standard'), (1, N'D', N'Standard'),
    (1, N'E', N'Vip'), (1, N'F', N'Vip'), (1, N'G', N'Vip'), (1, N'H', N'Vip'), (1, N'J', N'Vip'), (1, N'K', N'Vip'),
    (1, N'L', N'Couple')
) h(IsImax, RowLabel, SeatType) ON h.IsImax = CASE WHEN r.RoomType = N'IMAX' THEN 1 ELSE 0 END
CROSS JOIN (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)) n(Num);

-- ===== CUSTOMER =====
INSERT INTO CUSTOMER (FullName, Phone) VALUES
(N'Nguyễn Văn An', '0901234567'),
(N'Trần Thị Bình', '0912345678'),
(N'Lê Hoàng Phúc', '0903111222'),
(N'Phạm Minh Thư', '0938222333'),
(N'Đỗ Gia Huy', '0977333444'),
(N'Hoàng Bảo Ngọc', '0965444555'),
(N'Bùi Thanh Tùng', '0889555666'),
(N'Vũ Khánh Linh', '0326666777'),
(N'Ngô Đức Mạnh', '0357777888'),
(N'Đặng Mỹ Duyên', '0703888999'),
(N'Huỳnh Tấn Phát', '0796999000'),
(N'Trương Ngọc Hân', '0848000111');

-- ===== SHOWTIME =====
-- Lich mau 1 ngay cho tung phong (da tinh 15 phut don phong), lap lai cho 9 ngay.
-- Phim chua toi ngay khoi chieu thi bo qua suat do.
INSERT INTO SHOWTIME (MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice)
SELECT m.MovieID, r.RoomID,
       DATEADD(MINUTE, DATEDIFF(MINUTE, CAST('00:00' AS time), CAST(l.Gio AS time)),
               CAST(DATEADD(DAY, d.n, CAST(GETDATE() AS date)) AS datetime2)),
       l.Fmt, l.Audio,
       CASE l.Fmt WHEN N'IMAX' THEN 120000 ELSE 75000 END
FROM (VALUES
    (N'Phòng 1', '09:00', N'Trại Giam Hạnh Phúc', N'2D', N'Phụ đề'),
    (N'Phòng 1', '11:30', N'Ngày Con Còn Mẹ', N'2D', N'Phụ đề'),
    (N'Phòng 1', '14:00', N'Trại Giam Hạnh Phúc', N'2D', N'Phụ đề'),
    (N'Phòng 1', '16:30', N'Bò Sữa Bay', N'2D', N'Phụ đề'),
    (N'Phòng 1', '19:00', N'Trại Giam Hạnh Phúc', N'2D', N'Phụ đề'),
    (N'Phòng 1', '21:30', N'Chị Chị Em Em 3', N'2D', N'Phụ đề'),
    (N'Phòng 2', '09:30', N'Kiến Lé Phiêu Lưu Ké', N'2D', N'Lồng tiếng'),
    (N'Phòng 2', '11:15', N'Chàng Mèo Mang Mũ', N'2D', N'Lồng tiếng'),
    (N'Phòng 2', '13:30', N'Shaun The Sheep: "Quái Lạ" Ghé Nhà', N'2D', N'Phụ đề'),
    (N'Phòng 2', '15:30', N'Ngày Con Còn Mẹ', N'2D', N'Phụ đề'),
    (N'Phòng 2', '18:00', N'Trại Buôn Người', N'2D', N'Phụ đề'),
    (N'Phòng 2', '20:45', N'Thòng Lọng Ma: Quỷ Cái Đòi Mạng', N'2D', N'Phụ đề'),
    (N'Phòng 3', '10:00', N'Bí Kíp Luyện Cướp', N'2D', N'Phụ đề'),
    (N'Phòng 3', '12:30', N'Kẻ Hồi Sinh', N'2D', N'Phụ đề'),
    (N'Phòng 3', '14:45', N'Thiên Đường Tăm Tối', N'2D', N'Phụ đề'),
    (N'Phòng 3', '17:00', N'Clayface', N'2D', N'Phụ đề'),
    (N'Phòng 3', '19:15', N'Ngày Con Còn Mẹ', N'2D', N'Phụ đề'),
    (N'Phòng 3', '21:30', N'Trại Giam Hạnh Phúc', N'2D', N'Phụ đề'),
    (N'Phòng 4', '09:15', N'Ramayana: Khởi Nguồn Một Huyền Thoại', N'2D', N'Phụ đề'),
    (N'Phòng 4', '12:30', N'Godzilla Trừ Không', N'2D', N'Phụ đề'),
    (N'Phòng 4', '15:15', N'Bí Kíp Luyện Cướp', N'2D', N'Phụ đề'),
    (N'Phòng 4', '17:45', N'Ramayana: Khởi Nguồn Một Huyền Thoại', N'2D', N'Phụ đề'),
    (N'Phòng 4', '21:00', N'Godzilla Trừ Không', N'2D', N'Phụ đề'),
    (N'Phòng 5', '09:00', N'Dune: Hành Tinh Cát', N'IMAX', N'Phụ đề'),
    (N'Phòng 5', '12:15', N'Godzilla Trừ Không', N'IMAX', N'Phụ đề'),
    (N'Phòng 5', '15:00', N'Dune: Hành Tinh Cát - Phần Hai', N'IMAX', N'Phụ đề'),
    (N'Phòng 5', '18:15', N'Godzilla Trừ Không', N'IMAX', N'Phụ đề'),
    (N'Phòng 5', '21:00', N'Dune: Hành Tinh Cát - Phần Hai', N'IMAX', N'Phụ đề')
) l(RoomName, Gio, Title, Fmt, Audio)
JOIN ROOM r ON r.RoomName = l.RoomName
JOIN MOVIE m ON m.Title = l.Title
CROSS JOIN (VALUES (-6),(-5),(-4),(-3),(-2),(-1),(0),(1),(2)) d(n)
WHERE DATEADD(DAY, d.n, CAST(GETDATE() AS date)) >= m.ReleaseDate;

-- ===== BOOKING + TICKET =====
-- Moi suat sinh vai don 1-4 ghe (thinh thoang 1 cap ghe doi). Suat da chieu ban nhieu, suat sap toi ban it.
-- Gia ve: ghe thuong = BasePrice, VIP va ghe doi = BasePrice x 1.2 moi ghe (75k / 90k / cap doi 180k).
-- 1 diem cho moi 10.000 d, chi cong khi co khach thanh vien. Khoang 5% don bi huy.
DECLARE @now DATETIME2 = SYSDATETIME();
DECLARE @r FLOAT = RAND(2026);
DECLARE @showId INT, @roomId INT, @start DATETIME2, @base MONEY;
DECLARE @nb INT, @i INT, @k INT, @key INT, @row NVARCHAR(5), @fromNo INT, @pairNo INT;
DECLARE @total MONEY, @method NVARCHAR(20), @cash MONEY, @custId INT, @points INT, @accId INT;
DECLARE @created DATETIME2, @status NVARCHAR(20), @cancelAt DATETIME2, @reason NVARCHAR(200), @bookingId INT;
DECLARE @nCust INT = (SELECT COUNT(*) FROM CUSTOMER);
DECLARE @pick TABLE (SeatID INT, Price MONEY);

DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
    SELECT ShowtimeID, RoomID, StartTime, BasePrice FROM SHOWTIME ORDER BY StartTime, RoomID;
OPEN cur;
FETCH NEXT FROM cur INTO @showId, @roomId, @start, @base;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @nb = CASE WHEN @start < @now THEN 2 + FLOOR(RAND() * 8) ELSE FLOOR(RAND() * 4) END;
    IF DATEPART(HOUR, @start) >= 18 SET @nb = @nb + FLOOR(RAND() * 5);
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

        SELECT @accId = AccountID FROM ACCOUNT
        WHERE Username = CASE WHEN @start < DATEADD(DAY, -3, @now) AND RAND() < 0.25 THEN 'nv04'
                              ELSE CONCAT('nv0', 1 + FLOOR(RAND() * 3)) END;

        SET @created = DATEADD(MINUTE, -(5 + FLOOR(RAND() * 2880)), @start);
        IF @created > @now SET @created = DATEADD(MINUTE, -(1 + FLOOR(RAND() * 600)), @now);

        SET @status = N'Paid';
        SET @cancelAt = NULL;
        SET @reason = NULL;
        IF RAND() < 0.05
        BEGIN
            SET @status = N'Cancelled';
            SET @cancelAt = DATEADD(MINUTE, 3 + FLOOR(RAND() * 60), @created);
            IF @cancelAt > @now SET @cancelAt = @now;
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

SELECT (SELECT COUNT(*) FROM MOVIE) AS Phim, (SELECT COUNT(*) FROM ROOM) AS Phong, (SELECT COUNT(*) FROM SEAT) AS Ghe,
       (SELECT COUNT(*) FROM SHOWTIME) AS SuatChieu, (SELECT COUNT(*) FROM BOOKING) AS Don,
       (SELECT COUNT(*) FROM TICKET) AS Ve, (SELECT COUNT(*) FROM CUSTOMER) AS Khach;
