--18. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, 
--địa chỉ và số lượng cầu thủ nước ngoài (có quốc tịch khác “Việt Nam”) 
--tương ứng của các câu lạc bộ có nhiều hơn 2 cầu thủ nước ngoài.
SELECT CLB.MACLB,
	TENCLB,
	S.TENSAN,
	S.DIACHI,
	COUNT(CAUTHU.MACT) AS "Số lượng cầu thủ nước ngoài"
FROM CAULACBO CLB
JOIN SANVD S ON S.MASAN = CLB.MASAN
JOIN CAUTHU ON CLB.MACLB = CAUTHU.MACLB
JOIN QUOCGIA ON CAUTHU.MAQG = QUOCGIA.MAQG
WHERE QUOCGIA.MAQG != 'VN'
GROUP BY CLB.MACLB, CLB.TENCLB, S.TENSAN, S.DIACHI 
HAVING COUNT(CAUTHU.MACT) > 2

--19. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng có hiệu số bàn thắng bại cao nhất năm 2009.
SELECT TOP 1 CLB.TENCLB,
	T.TENTINH,
	(SUM(BXH.THANG) - SUM(BXH.THUA)) AS "HIEUSOBANGTHANG"
FROM CAULACBO CLB
JOIN TINH T ON T.MATINH = CLB.MATINH
JOIN BANGXH BXH ON BXH.MACLB = CLB.MACLB
WHERE BXH.NAM = 2009
GROUP BY CLB.TENCLB,
	T.TENTINH
ORDER BY HIEUSOBANGTHANG DESC

--20. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) của câu lạc bộ CLB có thứ hạng thấp nhất trong bảng xếp hạng vòng 3 năm 2009.
WITH "DOIYEU" AS (SELECT TOP 1 BXH.HANG,
	BXH.MACLB
FROM BANGXH BXH
WHERE BXH.NAM = 2009
AND BXH.VONG = 3
ORDER BY HANG DESC
) 

SELECT TD.NGAYTD ,
	SAN.TENSAN,
	CLB1.TENCLB,
	CLB2.TENCLB,
	TD.KETQUA
FROM TRANDAU TD
JOIN CAULACBO CLB1 ON CLB1.MACLB = TD.MACLB1
JOIN CAULACBO CLB2 ON CLB2.MACLB = TD.MACLB2
JOIN SANVD SAN ON SAN.MASAN = TD.MASAN
WHERE TD.MACLB1 =(SELECT MACLB FROM DOIYEU)
OR TD.MACLB2 = (SELECT MACLB FROM DOIYEU)

--21. Cho biết mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với tất cả các câu lạc bộ còn lại (kể cả sân nhà và sân khách) trong mùa giải năm 2009.
WITH CacDoi AS (
    SELECT DISTINCT MACLB1 AS MACLB FROM TRANDAU WHERE NAM = 2009
    UNION
    SELECT DISTINCT MACLB2 AS MACLB FROM TRANDAU WHERE NAM = 2009
),
SoLuotThiDau AS (
    SELECT c.MACLB, COUNT(DISTINCT t.MACLB1) + COUNT(DISTINCT t.MACLB2) AS SoDoiDau
    FROM CAULACBO c
    JOIN TRANDAU t ON c.MACLB IN (t.MACLB1, t.MACLB2)
    WHERE t.NAM = 2009
    GROUP BY c.MACLB
)
SELECT c.MACLB, c.TENCLB
FROM CAULACBO c
JOIN SoLuotThiDau s ON c.MACLB = s.MACLB
WHERE s.SoDoiDau = (SELECT COUNT(*) FROM CacDoi)
ORDER BY c.MACLB;

--22. Cho biết mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với tất cả các câu lạc bộ còn lại (chỉ tính sân nhà) trong mùa giải năm 2009.
WITH CacDoi AS (
    SELECT DISTINCT MACLB2 AS MACLB FROM TRANDAU WHERE NAM = 2009
),
SoLuotThiDau AS (
    SELECT c.MACLB, COUNT(DISTINCT t.MACLB2) AS SoDoiDau
    FROM CAULACBO c
    JOIN TRANDAU t ON c.MACLB = t.MACLB1
    WHERE t.NAM = 2009 AND c.MASAN = t.MASAN  -- Chỉ tính sân nhà
    GROUP BY c.MACLB
)
SELECT c.MACLB, c.TENCLB
FROM CAULACBO c
JOIN SoLuotThiDau s ON c.MACLB = s.MACLB
WHERE s.SoDoiDau = (SELECT COUNT(*) FROM CacDoi)  -- So sánh với số đội đã thi đấu
ORDER BY c.MACLB;
