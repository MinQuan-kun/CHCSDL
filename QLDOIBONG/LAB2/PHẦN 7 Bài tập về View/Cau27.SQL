-- 27.Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội
-- bóng “SHB Đà Nẵng” có quốc tịch “Bra-xin”.
USE QLBongDa
GO

CREATE VIEW [SHB Đà Nẵng] AS 
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

GO
SELECT *
FROM [SHB Đà Nẵng]

