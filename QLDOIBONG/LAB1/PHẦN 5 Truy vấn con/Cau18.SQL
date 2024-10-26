--Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, 
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
