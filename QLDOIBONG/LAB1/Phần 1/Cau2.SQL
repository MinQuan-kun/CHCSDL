--Cho biết tên cầu thủ đã ghi từ 2 bàn thắng trở lên trong một trận đấu.
SELECT 
    CT.HOTEN
FROM 
    CAUTHU CT
    JOIN THAMGIA TG ON CT.MACT = TG.MACT
WHERE 
    TG.SOTRAI >= 2;