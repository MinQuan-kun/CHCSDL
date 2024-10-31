--In ra dòng ‘Xin chào’ + @ten với @ten là tham số đầu vào là tên của bạn.
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