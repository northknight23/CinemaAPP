-- Them du lieu mua hang cho 10/11/2026 -> 13/11/2026. Chay SAU seed.sql, chi chay 1 lan.
-- Lich chieu va hoa don la du lieu AO. Moi ngay chi chieu phim da khoi chieu tinh toi ngay do.
-- Ngay nao da co suat chieu thi giu nguyen, file nay chi lap cac ngay con trong.
USE CINEMADB;
SET NOCOUNT ON;
SET XACT_ABORT ON;

IF NOT EXISTS (SELECT 1 FROM ACCOUNT) OR NOT EXISTS (SELECT 1 FROM ROOM)
BEGIN
    RAISERROR(N'Chưa có dữ liệu mẫu. Chạy seed.sql trước rồi mới chạy seed_1011_1311.sql.', 16, 1);
    RETURN;
END

DECLARE @lastShowId INT = ISNULL((SELECT MAX(ShowtimeID) FROM SHOWTIME), 0);

BEGIN TRANSACTION;

-- ===== SHOWTIME =====
-- Moi dong: phong, gio, phim, dinh dang, am thanh, ap dung tu ngay -> den ngay. Da tinh 15 phut don phong.
-- Phim khoi chieu giua chung (Ngay Con Con Me, Thong Long Ma 11/11; Bi Kip Luyen Cuop 12/11;
-- Ke Hoi Sinh 13/11) thay vao suat cua phim cu tu ngay khoi chieu.
DECLARE @lich TABLE (RoomName NVARCHAR(50), Gio CHAR(5), Title NVARCHAR(200), Fmt NVARCHAR(10), Audio NVARCHAR(20), Tu DATE, Den DATE);
INSERT INTO @lich VALUES
(N'Phòng 1', '09:00', N'Bò Sữa Bay', N'2D', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 1', '11:15', N'Chị Chị Em Em 3', N'2D', N'Phụ đề', '2026-11-10', '2026-11-10'),
(N'Phòng 1', '11:15', N'Ngày Con Còn Mẹ', N'2D', N'Phụ đề', '2026-11-11', '2026-11-13'),
(N'Phòng 1', '13:45', N'Bò Sữa Bay', N'2D', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 1', '16:00', N'Chị Chị Em Em 3', N'2D', N'Phụ đề', '2026-11-10', '2026-11-10'),
(N'Phòng 1', '16:00', N'Ngày Con Còn Mẹ', N'2D', N'Phụ đề', '2026-11-11', '2026-11-13'),
(N'Phòng 1', '18:30', N'Bò Sữa Bay', N'2D', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 1', '20:45', N'Chị Chị Em Em 3', N'2D', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 2', '09:30', N'Shaun The Sheep: "Quái Lạ" Ghé Nhà', N'2D', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 2', '11:30', N'Chàng Mèo Mang Mũ', N'2D', N'Lồng tiếng', '2026-11-10', '2026-11-13'),
(N'Phòng 2', '13:45', N'Shaun The Sheep: "Quái Lạ" Ghé Nhà', N'2D', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 2', '15:45', N'Trại Buôn Người', N'2D', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 2', '18:30', N'Thiên Đường Tăm Tối', N'2D', N'Phụ đề', '2026-11-10', '2026-11-10'),
(N'Phòng 2', '18:30', N'Thòng Lọng Ma: Quỷ Cái Đòi Mạng', N'2D', N'Phụ đề', '2026-11-11', '2026-11-13'),
(N'Phòng 2', '20:45', N'Trại Buôn Người', N'2D', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 3', '09:30', N'Thiên Đường Tăm Tối', N'2D', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 3', '11:30', N'Clayface', N'2D', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 3', '13:45', N'Thiên Đường Tăm Tối', N'2D', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 3', '15:45', N'Clayface', N'2D', N'Phụ đề', '2026-11-10', '2026-11-11'),
(N'Phòng 3', '15:45', N'Bí Kíp Luyện Cướp', N'2D', N'Phụ đề', '2026-11-12', '2026-11-13'),
(N'Phòng 3', '18:15', N'Thiên Đường Tăm Tối', N'2D', N'Phụ đề', '2026-11-10', '2026-11-12'),
(N'Phòng 3', '18:15', N'Kẻ Hồi Sinh', N'2D', N'Phụ đề', '2026-11-13', '2026-11-13'),
(N'Phòng 3', '20:15', N'Clayface', N'2D', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 4', '09:15', N'Ramayana: Khởi Nguồn Một Huyền Thoại', N'2D', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 4', '12:30', N'Godzilla Trừ Không', N'2D', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 4', '15:15', N'Ramayana: Khởi Nguồn Một Huyền Thoại', N'2D', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 4', '18:30', N'Godzilla Trừ Không', N'2D', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 4', '21:00', N'Bò Sữa Bay', N'2D', N'Phụ đề', '2026-11-10', '2026-11-11'),
(N'Phòng 4', '21:00', N'Bí Kíp Luyện Cướp', N'2D', N'Phụ đề', '2026-11-12', '2026-11-13'),
(N'Phòng 5', '09:00', N'Godzilla Trừ Không', N'IMAX', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 5', '11:45', N'Ramayana: Khởi Nguồn Một Huyền Thoại', N'IMAX', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 5', '15:00', N'Godzilla Trừ Không', N'IMAX', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 5', '17:45', N'Ramayana: Khởi Nguồn Một Huyền Thoại', N'IMAX', N'Phụ đề', '2026-11-10', '2026-11-13'),
(N'Phòng 5', '21:00', N'Godzilla Trừ Không', N'IMAX', N'Phụ đề', '2026-11-10', '2026-11-13');

IF EXISTS (SELECT 1 FROM @lich l WHERE NOT EXISTS (SELECT 1 FROM MOVIE m WHERE m.Title = l.Title)
                                    OR NOT EXISTS (SELECT 1 FROM ROOM r WHERE r.RoomName = l.RoomName))
BEGIN
    RAISERROR(N'Lịch chiếu có tên phim/phòng không khớp CSDL.', 16, 1);
    ROLLBACK;
    RETURN;
END

DECLARE @ngay TABLE (D DATE PRIMARY KEY);
INSERT INTO @ngay (D) VALUES ('2026-11-10'), ('2026-11-11'), ('2026-11-12'), ('2026-11-13');
DELETE g FROM @ngay g
WHERE EXISTS (SELECT 1 FROM SHOWTIME s WHERE s.StartTime >= g.D AND s.StartTime < DATEADD(DAY, 1, g.D));

IF NOT EXISTS (SELECT 1 FROM @ngay)
BEGIN
    RAISERROR(N'Các ngày 10/11 -> 13/11 đã có suất chiếu (seed_1011_1311.sql đã chạy rồi?).', 16, 1);
    ROLLBACK;
    RETURN;
END

INSERT INTO SHOWTIME (MovieID, RoomID, StartTime, ShowFormat, AudioType, BasePrice)
SELECT m.MovieID, r.RoomID,
       DATEADD(MINUTE, DATEDIFF(MINUTE, CAST('00:00' AS time), CAST(l.Gio AS time)), CAST(g.D AS datetime2)),
       l.Fmt, l.Audio,
       CASE l.Fmt WHEN N'IMAX' THEN 120000 ELSE 75000 END
FROM @ngay g
JOIN @lich l ON g.D BETWEEN l.Tu AND l.Den
JOIN ROOM r ON r.RoomName = l.RoomName
JOIN MOVIE m ON m.Title = l.Title
WHERE g.D >= m.ReleaseDate;

-- ===== BOOKING + TICKET (ao) cho cac suat vua them =====
-- Cung quy tac voi seed.sql: 1-4 ghe/don (thinh thoang 1 cap ghe doi), VIP va ghe doi = BasePrice x 1.2,
-- 1 diem / 10.000 d khi co khach thanh vien, ~5% don bi huy. Thu 6, 7, CN dong khach hon.
DECLARE @r FLOAT = RAND(1011);
DECLARE @showId INT, @roomId INT, @start DATETIME2, @base MONEY;
DECLARE @nb INT, @i INT, @k INT, @key INT, @row NVARCHAR(5), @fromNo INT, @pairNo INT;
DECLARE @total MONEY, @method NVARCHAR(20), @cash MONEY, @custId INT, @points INT, @accId INT;
DECLARE @created DATETIME2, @status NVARCHAR(20), @cancelAt DATETIME2, @reason NVARCHAR(200), @bookingId INT;
DECLARE @nCust INT = (SELECT COUNT(*) FROM CUSTOMER);
DECLARE @pick TABLE (SeatID INT, Price MONEY);

DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
    SELECT ShowtimeID, RoomID, StartTime, BasePrice FROM SHOWTIME
    WHERE ShowtimeID > @lastShowId
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
        SET @points = CASE WHEN @custId IS NULL THEN 0 ELSE FLOOR(@total / 10000) END;

        -- Giong seed.sql: truoc khi nghi viec, nv04 van ban ~25% so don
        SELECT @accId = AccountID FROM ACCOUNT
        WHERE Username = CASE WHEN RAND() < 0.25 THEN 'nv04' ELSE CONCAT('nv0', 1 + FLOOR(RAND() * 3)) END;

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

SELECT (SELECT COUNT(*) FROM SHOWTIME WHERE ShowtimeID > @lastShowId) AS SuatThem,
       (SELECT COUNT(DISTINCT t.BookingID) FROM TICKET t WHERE t.ShowtimeID > @lastShowId) AS DonThem,
       (SELECT SUM(t.Price) FROM TICKET t WHERE t.ShowtimeID > @lastShowId AND t.TicketStatus = N'Active') AS DoanhThuThem;
