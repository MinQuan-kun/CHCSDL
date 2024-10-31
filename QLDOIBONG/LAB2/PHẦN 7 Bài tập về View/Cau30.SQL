-- 30. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng
-- cầu thủ nước ngoài (có quốc tịch khác “Việt Nam”) tương ứng của các câu lạc bộ
-- có nhiều hơn 2 cầu thủ nước ngoài.
USE QLBongDa 
GO
CREATE VIEW CLBNN AS
SELECT CLB.MACLB,
	TENCLB,
	S.TENSAN,
	S.DIACHI,
	COUNT(CT.MACT) AS "Cầu thủ nước ngoài"
FROM CAULACBO CLB
JOIN SANVD S ON S.MASAN = CLB.MASAN
JOIN CAUTHU CT ON CT.MACLB = CLB.MACLB
JOIN QUOCGIA QG ON QG.MAQG = CT.MAQG
WHERE QG.TENQG NOT LIKE N'Việt Nam'
GROUP BY CLB.MACLB,
	TENCLB,
	S.TENSAN,
	S.DIACHI
HAVING COUNT(CT.MACT) > 2
GO 
SELECT * FROM CLBNN
-- DROP VIEW CLBNN

