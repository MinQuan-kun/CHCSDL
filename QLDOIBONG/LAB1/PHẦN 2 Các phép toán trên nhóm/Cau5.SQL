--Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ
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
