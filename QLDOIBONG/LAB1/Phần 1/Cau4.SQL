--Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc của các huấn luyện viên có quốc tịch “Việt Nam”.
SELECT 
	HUANLUYENVIEN.MAHLV, 
    TENHLV, 
	NGAYSINH, 
    DIACHI, 
    HLV_CLB.VAITRO, 
    CLB.TENCLB
FROM 
    HUANLUYENVIEN 
    JOIN QUOCGIA ON HUANLUYENVIEN.MAQG = QUOCGIA.MAQG
    JOIN HLV_CLB ON HUANLUYENVIEN.MAHLV = HLV_CLB.MAHLV
    JOIN CAULACBO CLB ON HLV_CLB.MACLB = CLB.MACLB
WHERE 
    QUOCGIA.TENQG = N'Việt Nam';
