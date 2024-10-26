--Cho biết mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với tất cả các câu lạc bộ còn lại (chỉ tính sân nhà) trong mùa giải năm 2009.
WITH CacDoi AS (
    SELECT DISTINCT MACLB2 AS MACLB FROM TRANDAU WHERE NAM = 2009
),
SoLuotThiDau AS (
    SELECT c.MACLB, COUNT(DISTINCT t.MACLB2) AS SoDoiDau
    FROM CAULACBO c
    JOIN TRANDAU t ON c.MACLB = t.MACLB1
    WHERE t.NAM = 2009 AND c.MASAN = t.MASAN  -- Chỉ tính sân nhà
    GROUP BY c.MACLB
)
SELECT c.MACLB, c.TENCLB
FROM CAULACBO c
JOIN SoLuotThiDau s ON c.MACLB = s.MACLB
WHERE s.SoDoiDau = (SELECT COUNT(*) FROM CacDoi)  -- So sánh với số đội đã thi đấu
ORDER BY c.MACLB;
