--Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bóng “SHB Đà Nẵng” có quốc tịch “Bra-xin”.
SELECT	CAUTHU.MACT,
		HOTEN,
		NGAYSINH,
		DIACHI,
		VITRI
FROM CAUTHU
	JOIN QUOCGIA ON QUOCGIA.MAQG = CAUTHU.MAQG
	JOIN CAULACBO ON CAULACBO.MACLB = CAUTHU.MACLB
WHERE
	QUOCGIA.TENQG = N'Bra-xin'
	AND CAULACBO.TENCLB = N'SHB Đà Nẵng';
