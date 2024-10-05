--Liệt kê các cầu thủ đang thi đấu trong các câu lạc bộ có thứ hạng ở vòng 3 năm 2009 lớn hơn 6 hoặc nhỏ hơn 3.
SELECT 
    CAUTHU.HOTEN, 
    CAUTHU.VITRI, 
    CLB.TENCLB, 
    BX.HANG
FROM 
    CAUTHU 
    JOIN CAULACBO CLB ON CAUTHU.MACLB = CLB.MACLB
    JOIN BANGXH BX ON CLB.MACLB = BX.MACLB
WHERE 
    BX.VONG = 3 
    AND BX.NAM = 2009 
    AND (BX.HANG > 6 OR BX.HANG < 3);
