--Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bóng “SHB Đà Nẵng” có quốc tịch “Bra-xin”.
SELECT 
    CT.MACT, 
    CT.HOTEN, 
    CT.NGAYSINH, 
    CT.DIACHI, 
    CT.VITRI
FROM 
    CAUTHU CT
    JOIN QUOCGIA QG ON CT.MAQG = QG.MAQG
    JOIN CAULACBO CLB ON CT.MACLB = CLB.MACLB
WHERE 
    CLB.TENCLB = N'SHB Đà Nẵng' 
    AND QG.TENQG = N'Bra-xin';
