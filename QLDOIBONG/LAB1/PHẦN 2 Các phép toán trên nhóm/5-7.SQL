--5. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ
--nước ngoài (có quốc tịch khác “Viet Nam”) tương ứng của các câu lạc bộ có nhiều hơn 2
--cầu thủ nước ngoài.
SELECT 
    CLB.MACLB, 
    CLB.TENCLB, 
    SAN.TENSAN, 
    SAN.DIACHI, 
    COUNT(CAUTHU.MACT) AS SoLuongCauThuNuocNgoai
FROM 
    CAULACBO CLB 
    JOIN SANVD SAN ON CLB.MASAN = SAN.MASAN
    JOIN CAUTHU ON CLB.MACLB = CAUTHU.MACLB
WHERE 
    CAUTHU.MAQG != 'VN'
GROUP BY 
    CLB.MACLB, CLB.TENCLB, SAN.TENSAN, SAN.DIACHI
HAVING 
    COUNT(CAUTHU.MACT) > 2;

--6. Cho biết tên tỉnh, số lượng cầu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc bộ thuộc địa bàn tỉnh đó quản lý.
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

--7. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của bảng xếp hạng của vòng 3, năm 2009.
WITH RankedClubs AS (
    SELECT 
        CLB.TENCLB, 
        TINH.TENTINH,
        ROW_NUMBER() OVER (ORDER BY BX.HANG ASC) AS Rank
    FROM 
        BANGXH BX 
        JOIN CAULACBO CLB ON BX.MACLB = CLB.MACLB
        JOIN TINH ON CLB.MATINH = TINH.MATINH
    WHERE 
        BX.NAM = 2009 
        AND BX.VONG = 3
)
SELECT 
    TENCLB, 
    TENTINH
FROM 
    RankedClubs
WHERE 
    Rank = 1;