-- 58. Dùng lệnh print để in ra danh sách mã các cầu thủ, tên câu thủ, vị trí trên sân.
USE QLBongDa
GO
CREATE PROC LISTCT
AS
BEGIN
    DECLARE L_CT CURSOR FOR (SELECT
    MACT, HOTEN, VITRI
    FROM CAUTHU
    )
    OPEN L_CT 
    DECLARE @CT_ID CHAR(4)
    DECLARE @Ten NVARCHAR(50)
    DECLARE @Vitri NVARCHAR(50)
    FETCH NEXT FROM L_CT INTO @CT_ID, @Ten, @Vitri
    WHILE @@FETCH_STATUS = 0
    BEGIN
    PRINT (N'Mã cầu thủ: '+ @CT_ID + N'Tên cầu thủ: ' + @Ten + N'Vị trí: ' + @Vitri)
    FETCH NEXT FROM L_CT INTO @CT_ID, @Ten, @Vitri
    END
    CLOSE L_CT
    DEALLOCATE L_CT
END
EXEC LISTCT
-- DROP PROC LISTCT
-- 59. Dùng lệnh print để in ra danh sách mã câu lạc bộ, tên câu lạc bộ, tên sân vận động.
USE QLBongDa
GO
CREATE PROCEDURE LISTCLB
AS
BEGIN
    DECLARE Cur_CauLacBo CURSOR
    FOR
    SELECT CLB.MACLB, CLB.TENCLB, SVD.TENSAN
    FROM CAULACBO CLB
    JOIN SANVD SVD ON CLB.MASAN = SVD.MASAN

    OPEN Cur_CauLacBo

    DECLARE @MACLB VARCHAR(5), @TENCLB NVARCHAR(100), @TENSAN NVARCHAR(100)

    WHILE 1 = 1
    BEGIN

        FETCH NEXT FROM Cur_CauLacBo INTO @MACLB, @TENCLB, @TENSAN
        
        IF @@FETCH_STATUS <> 0
            BREAK

        PRINT N'Mã câu lạc bộ: ' + @MACLB + N' | Tên câu lạc bộ: ' + @TENCLB + N' | Tên sân vận động: ' + @TENSAN
    END

    CLOSE Cur_CauLacBo
    DEALLOCATE Cur_CauLacBo
END 
EXEC LISTCLB
-- DROP PROC LISTCLB
-- 60. In danh sách các đội bóng và số cầu thủ nước ngoài của mỗi đội.
USE QLBongDa
GO
CREATE PROC CTNN
AS
BEGIN
	DECLARE C_NN CURSOR FOR(
	SELECT
	MACLB,
	COUNT(MACT) AS "Số câu thủ"
	FROM CAUTHU
	WHERE MAQG NOT LIKE 'VN'
	GROUP BY MACLB
	)
	OPEN C_NN
	DECLARE @CLB_ID NVARCHAR(5)
	DECLARE @Count INT
	FETCH NEXT FROM C_NN INTO @CLB_ID, @Count
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT TENCLB, @Count AS "Số cầu thủ nước ngoài"
        FROM CAULACBO
        WHERE MACLB = @CLB_ID
        FETCH NEXT FROM C_NN INTO @CLB_ID, @Count
    END
	CLOSE C_NN
	DEALLOCATE C_NN
END
EXEC CTNN
--DROP PROC CTNN

-- 61. In danh sách các đội bóng và ghi chú thêm cột HLV_NN, nếu có thì ghi số lượng, nếu
-- không có thì ghi chú là “Không có”
USE QLBongDa
GO
CREATE PROC DSDOI
AS
BEGIN
    DECLARE C_HLV CURSOR FOR
    (
        SELECT 
            CLB.TENCLB,
            COUNT(HLVCLB.MACLB) AS "Số lượng HLV"
        FROM CAULACBO CLB
        LEFT JOIN HLV_CLB HLVCLB ON HLVCLB.MACLB = CLB.MACLB
        LEFT JOIN HUANLUYENVIEN HLV ON HLV.MAHLV = HLVCLB.MAHLV
        AND HLV.MAQG NOT LIKE 'VN'
        GROUP BY CLB.TENCLB
    )

    OPEN C_HLV
    DECLARE @TeamName NVARCHAR(50)
    DECLARE @Count INT

    FETCH NEXT FROM C_HLV INTO @TeamName, @Count
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT 
            @TeamName AS "Tên CLB",
            CASE 
                WHEN @Count > 0 THEN CAST(@Count AS NVARCHAR)
                ELSE N'Không có'
            END AS "HLV_NN"
        
        FETCH NEXT FROM C_HLV INTO @TeamName, @Count
    END

    CLOSE C_HLV
    DEALLOCATE C_HLV
END
GO
EXEC DSDOI
--DROP PROC DSDOI

-- 62. Tính điểm, xếp hạng các đội bóng theo vòng, năm và INSERT kết quả vào bảng
-- BANGXH.
-- Hướng dẫn:
-- a. Tạo 2 View xem kết quả điểm sân nhà, điểm sân khách ứng với mỗi câu lạc bộ.

--Tạo view điểm sân nhà
CREATE VIEW DIEMSANNHA AS
SELECT 
    T.MACLB1 AS MACLB,
    T.NAM,
    T.VONG,
    SUM(CASE 
        WHEN CAST(SUBSTRING(T.KETQUA, 1, CHARINDEX('-', T.KETQUA) - 1) AS INT) >
             CAST(SUBSTRING(T.KETQUA, CHARINDEX('-', T.KETQUA) + 1, LEN(T.KETQUA)) AS INT) 
        THEN 3
        WHEN CAST(SUBSTRING(T.KETQUA, 1, CHARINDEX('-', T.KETQUA) - 1) AS INT) =
             CAST(SUBSTRING(T.KETQUA, CHARINDEX('-', T.KETQUA) + 1, LEN(T.KETQUA)) AS INT) 
        THEN 1
        ELSE 0
    END) AS TotalDIEMSANNHA,
    SUM(CAST(SUBSTRING(T.KETQUA, 1, CHARINDEX('-', T.KETQUA) - 1) AS INT)) AS GoalsScored,
    SUM(CAST(SUBSTRING(T.KETQUA, CHARINDEX('-', T.KETQUA) + 1, LEN(T.KETQUA)) AS INT)) AS GoalsConceded
FROM TRANDAU T
GROUP BY T.MACLB1, T.NAM, T.VONG;

--Kiểm tra
SELECT *
FROM DIEMSANNHA
--DROP VIEW DIEMSANNHA

--Tạo view điểm sân khách
CREATE VIEW DIEMSANKHACH AS
SELECT 
    T.MACLB2 AS MACLB,
    T.NAM,
    T.VONG,
    SUM(CASE 
        WHEN CAST(SUBSTRING(T.KETQUA, CHARINDEX('-', T.KETQUA) + 1, LEN(T.KETQUA)) AS INT) >
             CAST(SUBSTRING(T.KETQUA, 1, CHARINDEX('-', T.KETQUA) - 1) AS INT)
        THEN 3
        WHEN CAST(SUBSTRING(T.KETQUA, CHARINDEX('-', T.KETQUA) + 1, LEN(T.KETQUA)) AS INT) =
             CAST(SUBSTRING(T.KETQUA, 1, CHARINDEX('-', T.KETQUA) - 1) AS INT)
        THEN 1
        ELSE 0
    END) AS TotalDIEMSANKHACH,
    SUM(CAST(SUBSTRING(T.KETQUA, CHARINDEX('-', T.KETQUA) + 1, LEN(T.KETQUA)) AS INT)) AS GoalsScored,
    SUM(CAST(SUBSTRING(T.KETQUA, 1, CHARINDEX('-', T.KETQUA) - 1) AS INT)) AS GoalsConceded
FROM TRANDAU T
GROUP BY T.MACLB2, T.NAM, T.VONG;
GO

--Kiểm tra
SELECT *
FROM DIEMSANKHACH
--DROP VIEW DIEMSANKHACH

-- b. Tính điểm của từng câu lạc bộ theo năm, vòng đấu  sắp xếp theo tổng điểm,
-- hiệu số, tổng bàn thắng, tổng bàn thua.

--Tạo view điểm câu lạc bộ 
CREATE VIEW ClubPoints AS
SELECT 
    COALESCE(HP.MACLB, AP.MACLB) AS MACLB,
    COALESCE(HP.NAM, AP.NAM) AS NAM,
    COALESCE(HP.VONG, AP.VONG) AS VONG,
    ISNULL(HP.TotalDIEMSANNHA, 0) + ISNULL(AP.TotalDIEMSANKHACH, 0) AS TotalPoints,
    ISNULL(HP.GoalsScored, 0) + ISNULL(AP.GoalsScored, 0) AS TotalGoalsScored,
    ISNULL(HP.GoalsConceded, 0) + ISNULL(AP.GoalsConceded, 0) AS TotalGoalsConceded,
    (ISNULL(HP.GoalsScored, 0) + ISNULL(AP.GoalsScored, 0)) - 
    (ISNULL(HP.GoalsConceded, 0) + ISNULL(AP.GoalsConceded, 0)) AS GoalDifference
FROM DIEMSANNHA HP
FULL OUTER JOIN DIEMSANKHACH AP 
ON HP.MACLB = AP.MACLB AND HP.NAM = AP.NAM AND HP.VONG = AP.VONG;

--Kiểm tra
SELECT *
FROM ClubPoints
--DROP VIEW ClubPoints

GO
SELECT 
    MACLB,
    NAM,
    VONG,
    TotalPoints,
    TotalGoalsScored,
    TotalGoalsConceded,
    GoalDifference,
    RANK() OVER (PARTITION BY NAM, VONG ORDER BY TotalPoints DESC, GoalDifference DESC, TotalGoalsScored DESC) AS Ranking
FROM ClubPoints
ORDER BY NAM, VONG, Ranking;
-- c. Duyệt CURSOR và INSERT dữ liệu vào bảng BANGXH (có kiểm tra tồn tại của
-- dữ liệu)  Nếu chưa có thì INSERT, ngược lại thì UPDATE 
-- INSERT/UPDATE trực tiếp hoặc thông qua STORE PROCEDURE.

CREATE PROCEDURE UpdateBANGXH AS
BEGIN
    DECLARE ClubCursor CURSOR FOR
    SELECT 
        MACLB, 
        NAM, 
        VONG, 
        TotalPoints, 
        TotalGoalsScored, 
        TotalGoalsConceded, 
        GoalDifference, 
        RANK() OVER (PARTITION BY NAM, VONG ORDER BY TotalPoints DESC, GoalDifference DESC, TotalGoalsScored DESC) AS Ranking
    FROM ClubPoints
    ORDER BY NAM, VONG, Ranking;

    OPEN ClubCursor;

    DECLARE @MACLB NVARCHAR(5), @NAM INT, @VONG INT, 
            @TotalPoints INT, @TotalGoalsScored INT, @TotalGoalsConceded INT, 
            @GoalDifference INT, @Ranking INT;

    FETCH NEXT FROM ClubCursor INTO @MACLB, @NAM, @VONG, @TotalPoints, @TotalGoalsScored, @TotalGoalsConceded, @GoalDifference, @Ranking;

    WHILE @@FETCH_STATUS = 0
    BEGIN

        IF EXISTS (SELECT 1 FROM BANGXH WHERE MACLB = @MACLB AND NAM = @NAM AND VONG = @VONG)
        BEGIN
        
            UPDATE BANGXH
            SET 
                DIEM = @TotalPoints, 
                THANG = NULL,  
                HOA = NULL,    
                THUA = NULL,   
                HIEUSO = @GoalDifference, 
                SOTRAI = NULL, 
                HANG = @Ranking
            WHERE MACLB = @MACLB AND NAM = @NAM AND VONG = @VONG;
        END
        ELSE
        BEGIN
            
            INSERT INTO BANGXH (MACLB, NAM, VONG, DIEM, THANG, HOA, THUA, HIEUSO, SOTRAI, HANG)
            VALUES (@MACLB, @NAM, @VONG, @TotalPoints, NULL, NULL, NULL, @GoalDifference, NULL, @Ranking);
        END

        FETCH NEXT FROM ClubCursor INTO @MACLB, @NAM, @VONG, @TotalPoints, @TotalGoalsScored, @TotalGoalsConceded, @GoalDifference, @Ranking;
    END

    CLOSE ClubCursor;
    DEALLOCATE ClubCursor;
END;
GO
-- DROP PROC UPDATE
