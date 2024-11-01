--35. In ra dòng ‘Xin chào’ + @ten với @ten là tham số đầu vào là tên của bạn.
USE QLBongDa
GO
CREATE PROC XINCHAO
    @ten NVARCHAR(50)
AS
BEGIN 
    Print(N'Xin chào ' + @ten)
END
EXEC XINCHAO  N'Minh Quân'
--DROP PROC XINCHAO

--a)Cho thực thi và in giá trị của các tham số này để kiểm tra.
--36. Nhập vào 2 số @s1,@s2. In ra câu ‘tổng là : @tg ‘ với @tg =@s1+@s2.
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

--37. Nhập vào 2 số @s1,@s2. Xuat tong @s1+@s2 ra tham so @tong.
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

--38. Nhập vào 2 số @s1,@s2. In ra câu ‘Số lớn nhất của @s1 và @s2 là max’ với
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

--39. Nhập vào 2 số @s1,@s2. Xuất min và max của chúng ra tham so @max.
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

--40. Nhập vào số nguyên @n. In ra các số từ 1 đến @n.
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

--41. Nhập vào số nguyên @n. In ra tổng và số lượng các số chẵn từ 1 đến @n
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