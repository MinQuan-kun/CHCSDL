-- Nhập vào số nguyên @n. In ra tổng và số lượng các số chẵn từ 1 đến @n
USE QLBongDa
GO
CREATE PROC INTONGSOLUONGCHAN
    @n INT 
AS 
BEGIN 
    DECLARE @temp INT = 1
    DECLARE @count INT = 0
    DECLARE @tong INT = 0
    DECLARE @tong2 INT = 0
    WHILE @temp <= @n
    BEGIN
        IF @temp % 2 = 0
        BEGIN 
            SET @tong += @temp
            SET @count += 1
        END
        SET @tong2 += @temp
        SET @temp += 1
    END
    Print CONCAT(N'Tổng các số: ', @tong2)
    PRINT CONCAT(N'Tổng các số chẵn: ', @tong)
    PRINT CONCAT(N'Số lương số chẵn: ', @count)
END

EXEC INTONGSOLUONGCHAN 4

--DROP PROC INTONGSOLUONGCHAN