--Cho biết tên cầu thủ đã ghi từ 2 bàn thắng trở lên trong một trận đấu.
SELECT
	CAUTHU.HOTEN
FROM CAUTHU
	JOIN THAMGIA ON CAUTHU.MACT = THAMGIA.MACT
WHERE
	THAMGIA.SOTRAI >= 2