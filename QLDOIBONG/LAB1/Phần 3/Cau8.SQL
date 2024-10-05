--Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong một câu lạc bộ mà chưa có số điện thoại.
SELECT 
    HLV.TENHLV
FROM 
    HUANLUYENVIEN HLV
    JOIN HLV_CLB HLV_CLB ON HLV.MAHLV = HLV_CLB.MAHLV
WHERE 
    HLV.DIENTHOAI IS NULL;
