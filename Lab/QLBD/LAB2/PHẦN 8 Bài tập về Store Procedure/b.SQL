-- b) Cho thực thi và in giá trị của các tham số này để kiểm tra.
-- 42. Cho biết có bao nhiêu trận đấu hòa nhau ở vòng 3 năm 2009.
USE QLBongDa
GO
CREATE PROC TRANHOA
	@vong INT, @nam INT 
AS
BEGIN
	SELECT COUNT(BXH.HOA) AS "Số trận hòa"
	FROM BANGXH BXH
	WHERE BXH.VONG = @vong 
	AND BXH.NAM = @nam
END
EXEC TRANHOA 3, 2009
--DROP PROC TRANHOA

-- 43. Viết store procedure tương ứng với các câu ở phần View. Sau đó cho thực hiện để kiểm
-- tra kết quả.
-- 43.27. Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội
-- bóng “SHB Đà Nẵng” có quốc tịch “Bra-xin”.
USE QLBongDa
GO
CREATE PROC BRAXIN
	@CLB_ID NCHAR(4)
AS
BEGIN
	SELECT 
    CT.MACT,
    CT.HOTEN,
	CT.DIACHI,
    CT.NGAYSINH,
	CT.VITRI
	FROM CAULACBO CLB
	JOIN CAUTHU CT ON CT.MACLB = CLB.MACLB
	JOIN QUOCGIA QG ON QG.MAQG = CT.MAQG
	WHERE CLB.TENCLB LIKE N'SHB Đà Nẵng'
	AND QG.TENQG LIKE N'Bra-xin' 
	AND CLB.MACLB = @CLB_ID
END
EXEC BRAXIN SDN
--DROP PROC BRAXIN

-- 43.28. Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2,
-- KETQUA) các trận đấu vòng 3 của mùa bóng năm 2009.
USE QLBongDa
GO
CREATE PROC KETQUATHI
	@vong INT , @nam INT
AS
BEGIN 
SELECT TD.MATRAN,
	NGAYTD,
	S.TENSAN,
	CLB1.TENCLB AS TENCLB1,
	CLB2.TENCLB AS TENCLB2,
	TD.KETQUA
	FROM TRANDAU TD
	JOIN SANVD S ON S.MASAN = TD.MASAN
	JOIN CAULACBO AS CLB1 ON CLB1.MACLB = TD.MACLB1
	JOIN CAULACBO AS CLB2 ON CLB2.MACLB = TD.MACLB2
	WHERE TD.VONG = @vong AND TD.NAM = @nam
END
EXEC KETQUATHI 3, 2009
--DROP PROC KETQUATHI

--43.29.Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB
-- đang làm việc của các huấn luyện viên có quốc tịch “Việt Nam”.
USE QLBongDa
GO
CREATE PROC HLVVN
	@VN NVARCHAR(50)
AS
BEGIN
SELECT HLV.MAHLV,
	TENHLV,
	NGAYSINH,
	DIACHI,
	HLVCLB.VAITRO,
	CLB.TENCLB
	FROM HUANLUYENVIEN HLV
	JOIN HLV_CLB HLVCLB ON HLVCLB.MAHLV = HLV.MAHLV
	JOIN CAULACBO CLB ON CLB.MACLB = HLVCLB.MACLB
	JOIN QUOCGIA QG ON QG.MAQG = HLV.MAQG
	WHERE QG.TENQG = @VN
END
EXEC HLVVN N'Việt Nam'
--DROP PROC HLVVN

--43.30. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng
-- cầu thủ nước ngoài (có quốc tịch khác “Việt Nam”) tương ứng của các câu lạc bộ
-- có nhiều hơn 2 cầu thủ nước ngoài.
USE QLBongDa 
GO
CREATE PROC CLBNN 
	@QUOCTICH NVARCHAR(50)
AS
BEGIN 
SELECT CLB.MACLB,
	TENCLB,
	S.TENSAN,
	S.DIACHI,
	COUNT(CT.MACT) AS "Cầu thủ nước ngoài"
	FROM CAULACBO CLB
	JOIN SANVD S ON S.MASAN = CLB.MASAN
	JOIN CAUTHU CT ON CT.MACLB = CLB.MACLB
	JOIN QUOCGIA QG ON QG.MAQG = CT.MAQG
	WHERE QG.TENQG NOT LIKE @QUOCTICH
	GROUP BY CLB.MACLB,
	TENCLB,
	S.TENSAN,
	S.DIACHI
	HAVING COUNT(CT.MACT) > 2
END
EXEC CLBNN N'Việt Nam'
--DROP PROC CLBNN

--43.31. Cho biết tên tỉnh, số lượng cầu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc
-- bộ thuộc địa bàn tỉnh đó quản lý.
USE QLBongDa
GO
CREATE PROC TINHCLB
	@Tinh NVARCHAR(50)
AS
BEGIN
	SELECT T.TENTINH,
	COUNT(CT.MACT) AS "Số lượng cầu thủ"
	FROM TINH T
	JOIN CAULACBO CLB ON CLB.MATINH = T.MATINH
	JOIN CAUTHU CT ON CT.MACLB = CLB.MACLB
	WHERE CT.VITRI LIKE N'Tiền đạo'
	AND T.TENTINH = @Tinh
	GROUP BY T.TENTINH
END
EXEC TINHCLB  N'Bình Dương'
EXEC TINHCLB  N'Đà Nẵng'
EXEC TINHCLB  N'Đồng Tháp'
--DROP PROC TINHCLB

--43.32. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của
-- bảng xếp hạng của vòng 3, năm 2009.
USE QLBongDa
GO
CREATE PROC TOP1CLB 
	@vong INT, @nam INT	
AS
BEGIN
	SELECT 
		CLB.TENCLB,
		T.TENTINH
		--SUM(BXH.DIEM) AS "Tổng điểm"
	FROM BANGXH BXH
	JOIN CAULACBO CLB ON CLB.MACLB = BXH.MACLB
	JOIN TINH T ON T.MATINH = CLB.MATINH
	WHERE BXH.VONG = @vong AND BXH.NAM = @nam AND BXH.HANG = 1
	GROUP BY CLB.TENCLB, T.TENTINH
END
EXEC TOP1CLB 3, 2009
--DROP PROC TOP1CLB

-- 44. Viết các thủ tục để nhập số liệu cho CSDL trên (các số liệu được thêm vào thông qua
-- tham số thủ tục).
USE QLBongDa
GO
CREATE PROC THUTUC
	@CT_Ten NVARCHAR(50), 
	@vitri NVARCHAR(50),
	@Ngaysinh DATETIME,
	@MA_QG NVARCHAR(5),
	@So INT,
	@MA_CLB NVARCHAR(10)
AS
BEGIN
	INSERT INTO CAUTHU(HOTEN, VITRI, NGAYSINH, MAQG, SO, MACLB)
	VALUES (@CT_TEN,@vitri,@Ngaysinh,@MA_QG, @So, @MA_CLB)
END
EXEC THUTUC N'Nguyễn Hữu Minh Quân', N'Tiền đạo', '2005/05/27', 'VN', 5, 'BBD'
--DROP PROC THUTUC

-- 45. Nhập vào mã cầu thủ (@MaCT), cho biết thông tin các trận đấu (MaTD, TenTD,
-- NgayTD) mà cầu thủ này đã tham gia.
USE QLBongDa
GO
CREATE PROC INFO
    @CT_ID INT
AS
BEGIN
    SELECT 
        T.MATD,
        T1.NGAYTD,
		S.TENSAN
    FROM CAUTHU CT
    JOIN THAMGIA T ON T.MACT = CT.MACT
    JOIN TRANDAU T1 ON T1.MATRAN = T.MATD
    JOIN SANVD S ON S.MASAN = T1.MASAN
    WHERE CT.MACT = @CT_ID
END
EXEC INFO 4
--DROP PROC INFO

-- 46. Nhập vào mã trận đấu (@MaTD), cho biết danh sách cầu thủ ghi bàn trong trận đấu này.
USE QLBongDa
GO
CREATE PROC DSCT
	@TD_ID INT
AS
BEGIN
	SELECT *
	FROM CAUTHU CT
	JOIN THAMGIA T ON T.MACT = CT.MACT
	WHERE T.MATD = @TD_ID
END
EXEC DSCT 3
--DROP PROC DSCT

-- 47. Cho biết có tất cả bao nhiêu trận đấu hòa nhau.
USE QLBongDa
GO
CREATE PROCEDURE SOTRANHOA
AS
BEGIN
    SELECT COUNT(*) AS SoTranHoa
    FROM TRANDAU
    WHERE LEFT(KETQUA, CHARINDEX('-', KETQUA) - 1) = 
          RIGHT(KETQUA, LEN(KETQUA) - CHARINDEX('-', KETQUA))
END
EXEC SOTRANHOA
--DROP PROC SOTRANHOA