-- Nhập vào 2 số @s1,@s2. In ra câu ‘tổng là : @tg ‘ với @tg =@s1+@s2.
USE QLBongDa
GO
CREATE PROC TONG
    @s1 INT , @s2 INT
AS 
BEGIN
    DECLARE @tg INT 
    SET @tg = @s1 + @s2
    print CONCAT(N'Tổng là: ', @tg)
    --CONCAT để nối chuỗi trong SQL Server. 
    --Hàm CONCAT tự động chuyển đổi các giá trị không phải chuỗi sang kiểu chuỗi, giúp mã gọn gàng hơn.
END

EXEC TONG 1, 2
--DROP PROC TONG