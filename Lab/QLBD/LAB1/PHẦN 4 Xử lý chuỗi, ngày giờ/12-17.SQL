--12. Cho biết NGAYTD, TENCLB1, TENCLB2, KETQUA các trận đấu diễn ra vào tháng 3 trên sân nhà mà không bị thủng lưới.
SELECT
    TRANDAU.NGAYTD,
    CLB2.TENCLB AS TENCLB1,
    CLB2.TENCLB AS TENCLB2,
    TRANDAU.KETQUA
FROM
    TRANDAU
    JOIN CAULACBO AS CLB1 ON TRANDAU.MACLB1 = CLB1.MACLB
    JOIN CAULACBO AS CLB2 ON TRANDAU.MACLB2 = CLB2.MACLB
WHERE 
    MONTH(NGAYTD) = 3 AND KETQUA LIKE '%-0'  

--13. Cho biết mã số, họ tên, ngày sinh (dd/MM/yyyy) của những cầu thủ có họ lót là “Công”.
SELECT  CAUTHU.MACT,
        HOTEN,
        NGAYSINH
FROM CAUTHU
WHERE
    CAUTHU.HOTEN LIKE N'% Công%';

--14. Cho biết mã số, họ tên, ngày sinh của những cầu thủ có họ không phải là họ “Nguyễn”.
SELECT CAUTHU.MACT,
        HOTEN,
        NGAYSINH
FROM CAUTHU
WHERE
    CAUTHU.HOTEN NOT LIKE N'Nguyễn %';

--15. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ của những huấn luyện viên Việt Nam có tuổi nằm trong khoảng 35 – 40.
SELECT HUANLUYENVIEN.MAHLV,
		HUANLUYENVIEN.TENHLV,
		HUANLUYENVIEN.NGAYSINH,
        HUANLUYENVIEN.DIACHI
FROM HUANLUYENVIEN 
    JOIN QUOCGIA ON HUANLUYENVIEN.MAQG = QUOCGIA.MAQG
WHERE QUOCGIA.TENQG = N'Việt Nam'
	AND DATEDIFF(YEAR, HUANLUYENVIEN.NGAYSINH, GETDATE()) BETWEEN 35 AND 40;

--16. Cho biết tên câu lạc bộ có huấn luyện viên trưởng sinh vào ngày 20 tháng 5.
SELECT CAULACBO.TENCLB
FROM CAULACBO
	JOIN HLV_CLB ON HLV_CLB.MACLB = CAULACBO.MACLB
	JOIN HUANLUYENVIEN ON HUANLUYENVIEN.MAHLV = HLV_CLB.MAHLV
WHERE
    VAITRO = N'HLV Chính'
	AND DAY(HUANLUYENVIEN.NGAYSINH) = 20
	AND MONTH(HUANLUYENVIEN.NGAYSINH) = 5;
	
--17. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng 
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