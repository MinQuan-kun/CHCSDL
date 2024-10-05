--Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện tại bất kỳ một câu lạc bộ nào.
SELECT 
    HLV.TENHLV
FROM 
    HUANLUYENVIEN HLV
LEFT JOIN 
    HLV_CLB HLV_CLB ON HLV.MAHLV = HLV_CLB.MAHLV
WHERE 
    HLV.MAQG = 'VN' 
    AND HLV_CLB.MAHLV IS NULL;
