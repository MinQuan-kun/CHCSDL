--Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của bảng xếp hạng của vòng 3, năm 2009.
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
