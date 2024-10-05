--Cho biết tên tỉnh, số lượng cầu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc bộ thuộc địa bàn tỉnh đó quản lý.
SELECT 
    TINH.TENTINH, 
    COUNT(CAUTHU.MACT) AS SoLuongTienDao
FROM 
    TINH 
    JOIN CAULACBO CLB ON TINH.MATINH = CLB.MATINH
    JOIN CAUTHU ON CLB.MACLB = CAUTHU.MACLB
WHERE 
    CAUTHU.VITRI = N'Tiền Đạo'
GROUP BY 
    TINH.TENTINH;
