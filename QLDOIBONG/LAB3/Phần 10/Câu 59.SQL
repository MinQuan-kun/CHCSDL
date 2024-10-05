--Dùng lệnh print để in ra danh sách mã câu lạc bộ, tên câu lạc bộ, tên sân vận động.
go
CREATE PROCEDURE Cau_59
AS
BEGIN
    DECLARE Cur_CauLacBo CURSOR
    FOR
    SELECT CLB.MACLB, CLB.TENCLB, SVD.TENSAN
    FROM CAULACBO CLB
    JOIN SANVD SVD ON CLB.MASAN = SVD.MASAN

    OPEN Cur_CauLacBo

    DECLARE @MACLB VARCHAR(5), @TENCLB NVARCHAR(100), @TENSAN NVARCHAR(100)

    WHILE 1 = 1
    BEGIN

        FETCH NEXT FROM Cur_CauLacBo INTO @MACLB, @TENCLB, @TENSAN
        
        IF @@FETCH_STATUS <> 0
            BREAK

        PRINT N'Mã câu lạc bộ: ' + @MACLB + N' | Tên câu lạc bộ: ' + @TENCLB + N' | Tên sân vận động: ' + @TENSAN
    END

    CLOSE Cur_CauLacBo
    DEALLOCATE Cur_CauLacBo
