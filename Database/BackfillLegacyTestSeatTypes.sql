-- Chỉ sửa phân loại ghế của bộ [TEST] cũ do SuatChieuTest tạo khi SEAT chưa có SeatType.
-- Không đổi RoomID/SeatID/số ghế/giá vé đã bán; không áp dụng cho phòng có suất dữ liệu thật.
SET XACT_ABORT ON;
BEGIN TRANSACTION;
IF EXISTS (SELECT 1 FROM sys.default_constraints
           WHERE parent_object_id=OBJECT_ID('dbo.SEAT') AND name='DF_POS_SEAT_TYPE')
BEGIN
    ;WITH Eligible AS (
        SELECT r.RoomID,r.RoomType
        FROM ROOM r
        WHERE EXISTS (SELECT 1 FROM SHOWTIME s JOIN MOVIE m ON m.MovieID=s.MovieID
                      WHERE s.RoomID=r.RoomID AND LEFT(m.MovieDescription,6)=N'[TEST]')
          AND NOT EXISTS (SELECT 1 FROM SHOWTIME s JOIN MOVIE m ON m.MovieID=s.MovieID
                          WHERE s.RoomID=r.RoomID AND ISNULL(LEFT(m.MovieDescription,6),N'')<>N'[TEST]')
          AND NOT EXISTS (SELECT 1 FROM SEAT se WHERE se.RoomID=r.RoomID AND se.SeatType<>N'Standard')
    ), RowRanks AS (
        SELECT se.RoomID,se.RowLabel,COUNT(*) AS SeatCount,
               MAX(se.SeatNumber) AS LastSeat,
               DENSE_RANK() OVER (PARTITION BY se.RoomID ORDER BY se.RowLabel) AS RowNo,
               COUNT(*) OVER (PARTITION BY se.RoomID) AS TotalRows,
               e.RoomType
        FROM SEAT se JOIN Eligible e ON e.RoomID=se.RoomID
        GROUP BY se.RoomID,se.RowLabel,e.RoomType
    )
    UPDATE se SET SeatType=CASE
        WHEN rr.RowNo=rr.TotalRows AND rr.SeatCount=rr.LastSeat AND rr.SeatCount%2=0 THEN N'Couple'
        WHEN rr.RowNo<=CASE WHEN rr.RoomType=N'IMAX' THEN 4 ELSE 3 END THEN N'Standard'
        ELSE N'Vip' END
    FROM SEAT se JOIN RowRanks rr ON rr.RoomID=se.RoomID AND rr.RowLabel=se.RowLabel;
END;
COMMIT;
