-- 31. Cho biết tên tỉnh, số lượng cầu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc
-- bộ thuộc địa bàn tỉnh đó quản lý.
USE QLBongDa
GO
CREATE VIEW TINHCLB AS
SELECT T.TENTINH,
COUNT(CT.MACT) AS "Số lượng cầu thủ"
FROM TINH T
JOIN CAULACBO CLB ON CLB.MATINH = T.MATINH
JOIN CAUTHU CT ON CT.MACLB = CLB.MACLB
WHERE CT.VITRI LIKE N'Tiền đạo'
GROUP BY T.TENTINH
GO
SELECT *
FROM TINHCLB
-- DROP VIEW TINHCLB