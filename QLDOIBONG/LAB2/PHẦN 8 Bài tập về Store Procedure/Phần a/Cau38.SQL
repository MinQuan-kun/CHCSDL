--Nhập vào 2 số @s1,@s2. In ra câu ‘Số lớn nhất của @s1 và @s2 là max’ với
-- @s1,@s2,max là các giá trị tương ứng.
USE QLBongDa
GO
CREATE PROC SOLONNHAT
    @s1 INT, @s2 INT 
AS 
BEGIN
    DECLARE @Max INT
    SET @Max = @s1
    if @Max < @s2 
    BEGIN
        SET @Max = @s2
    END
    PRINT CONCAT(N'Số lớn nhất: ', @Max)
END

EXEC SOLONNHAT 3, 2
EXEC SOLONNHAT 1, 2
--DROP PROC SOLONNHAT