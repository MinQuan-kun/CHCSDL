-- Nhập vào 2 số @s1,@s2. Xuất min và max của chúng ra tham so @max.
-- Cho thực thi và in giá trị của các tham số này để kiểm tra.
USE QLBongDa
GO
CREATE PROC MINMAX
    @s1 INT , @s2 INT 
AS 
BEGIN 
    DECLARE @Max INT , @Min INT 
    SET @Max = @s1
	SET @Min = @s2
    IF @Max < @Min
    BEGIN
        SET @Max = @s2
        SET @Min = @s1
    END
    PRINT CONCAT(N'Số lớn nhất: ', @Max)
    PRINT CONCAT(N'Số bé nhất: ', @Min)
END

EXEC MINMAX 1, 2
EXEC MINMAX 27, 2
--DROP PROC MINMAX