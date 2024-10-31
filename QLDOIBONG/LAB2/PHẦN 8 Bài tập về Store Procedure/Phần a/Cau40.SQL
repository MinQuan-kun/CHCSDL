-- Nhập vào số nguyên @n. In ra các số từ 1 đến @n.
USE QLBongDa
GO
CREATE PROC INN
    @n INT 
AS 
BEGIN 
    DECLARE @temp INT = 1
    WHILE @temp <= @n
    BEGIN
        PRINT(@temp)
        SET @temp += 1
    END
END

EXEC INN 5
EXEC INN 50

--DROP PROC INN