-- Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng 
--có số bàn thắng nhiều nhất tính đến hết vòng 3 năm 2009.
SELECT TOP 1
	CLB.TENCLB,
	T.TENTINH
FROM CAULACBO CLB
JOIN TINH T ON T.MATINH = CLB.MATINH
JOIN(
	SELECT MACLB, SUM(THANG) AS "Số bàn thắng"
	FROM BANGXH BXH
	WHERE NAM = 2009 AND VONG <=3
	GROUP BY MACLB
) TMT ON TMT.MACLB = CLB.MACLB
ORDER BY TMT.[Số bàn thắng] DESC