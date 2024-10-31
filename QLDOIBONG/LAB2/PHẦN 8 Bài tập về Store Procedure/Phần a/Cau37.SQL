-- Nhập vào 2 số @s1,@s2. Xuat tong @s1+@s2 ra tham so @tong.
USE QLBongDa
GO
CREATE PROC XUATTONG
    @s1 INT, @s2 INT
AS 
BEGIN
    DECLARE @tong INT 
    SET @tong = @s1 + @s2
    PRINT (@tong)
END

EXEC XUATTONG 1, 2
--DROP PROC XUATTONG