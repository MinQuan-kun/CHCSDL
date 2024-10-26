--Cho biết mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với tất cả các câu lạc bộ còn lại (kể cả sân nhà và sân khách) trong mùa giải năm 2009.
WITH CacDoi AS (
    SELECT DISTINCT MACLB1 AS MACLB FROM TRANDAU WHERE NAM = 2009
    UNION
    SELECT DISTINCT MACLB2 AS MACLB FROM TRANDAU WHERE NAM = 2009
),
SoLuotThiDau AS (
    SELECT c.MACLB, COUNT(DISTINCT t.MACLB1) + COUNT(DISTINCT t.MACLB2) AS SoDoiDau
    FROM CAULACBO c
    JOIN TRANDAU t ON c.MACLB IN (t.MACLB1, t.MACLB2)
    WHERE t.NAM = 2009
    GROUP BY c.MACLB
)
SELECT c.MACLB, c.TENCLB
FROM CAULACBO c
JOIN SoLuotThiDau s ON c.MACLB = s.MACLB
WHERE s.SoDoiDau = (SELECT COUNT(*) FROM CacDoi)
ORDER BY c.MACLB;
