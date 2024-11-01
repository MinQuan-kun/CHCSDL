-- 55. Khi phân công huấn luyện viên cho câu lạc bộ:
-- a. Kiểm tra vai trò của huấn luyện viên chỉ thuộc một trong các vai trò sau: HLV
-- chính, HLV phụ, HLV thể lực, HLV thủ môn.
USE QLBongDa
GO
CREATE TRIGGER C_HLV
ON [HLV_CLB]
FOR UPDATE, INSERT
AS
BEGIN
    SET NOCOUNT ON
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE VAITRO NOT IN (N'HLV chính', N'HLV phụ', N'HLV thể lực', N'HLV thủ môn')
    )
    BEGIN
        RAISERROR(N'Vai trò phải là HLV chính, HLV phụ, HLV thể lực, hoặc HLV thủ môn.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
--DROP TRIGEER C_HLV
-- b. Kiểm tra mỗi câu lạc bộ chỉ có tối đa 2 HLV chính.
USE QLBongDa
GO
CREATE TRIGGER C_HLVCHINH
ON [HLV_CLB]
FOR UPDATE, INSERT
AS
BEGIN
    SET NOCOUNT ON
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.VAITRO = N'HLV chính'
        AND (
            SELECT COUNT(*)
            FROM HLV_CLB h
            WHERE h.VAITRO = N'HLV chính'
            AND h.MACLB = i.MACLB  
        ) >= 2
    )
    BEGIN
        RAISERROR(N'Số lượng Huấn luyện viên chính tối đa chỉ có thể là 2 cho mỗi câu lạc bộ.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
--DROP TRIGGER C_HLVCHINH

-- 56. Khi thêm mới một câu lạc bộ thì kiểm tra xem đã có câu lạc bộ trùng tên với câu
-- lạc bộ vừa được thêm hay không?
-- a. chỉ thông báo vẫn cho insert.
USE QLBongDa
GO
CREATE TRIGGER C_CLB
ON CAULACBO
FOR UPDATE, INSERT
AS
BEGIN
    SET NOCOUNT ON
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE EXISTS (
            SELECT 1
            FROM CAULACBO c
            WHERE c.TENCLB = i.TENCLB
        )
    )
    BEGIN
        RAISERROR(N'Tên câu lạc bộ này đã tồn tại', 16, 1)
    END
END
--DROP TRIGGER C_CLB
--Thêm 1 dữ liệu và kiểm tra
INSERT INTO CAULACBO (MACLB, TENCLB, MASAN, MATINH)
VALUES ('TTT', N'THÉP PHÚ YÊN', 'NT', 'PY')
--Xóa dữ liệu vừa thêm
DELETE FROM CAULACBO
WHERE MACLB = 'TTT'
--Kiểm tra lại bảng
SELECT *
FROM CAULACBO

-- b. thông báo và không cho insert.
USE QLBongDa
GO
CREATE TRIGGER C_CLB
ON CAULACBO
FOR UPDATE, INSERT
AS
BEGIN
    SET NOCOUNT ON
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE EXISTS (
            SELECT 1
            FROM CAULACBO c
            WHERE c.TENCLB = i.TENCLB
        )
    )
    BEGIN
        RAISERROR(N'Tên câu lạc bộ này đã tồn tại', 16, 1)
        ROLLBACK TRANSACTION
    END
END
--DROP TRIGGER C_CLB
--Thêm 1 dữ liệu và kiểm tra
INSERT INTO CAULACBO (MACLB, TENCLB, MASAN, MATINH)
VALUES ('TTT', N'THÉP PHÚ YÊN', 'NT', 'PY')
--Xóa dữ liệu vừa thêm
DELETE FROM CAULACBO
WHERE MACLB = 'TTT'
--Kiểm tra lại bảng
SELECT *
FROM CAULACBO

-- 57. Khi sửa tên cầu thủ cho một (hoặc nhiều) cầu thủ thì in ra:
-- a. danh sách mã cầu thủ của các cầu thủ vừa được sửa.
USE QLBongDa
GO
CREATE TRIGGER C_CAUTHU
ON CAUTHU
FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    -- In ra danh sách mã cầu thủ đã được sửa
    SELECT MACT  
    FROM inserted;
END;
--DROP TRIGGER C_CAUTHU

-- b. danh sách mã cầu thủ vừa được sửa và tên cầu thủ mới.
USE QLBongDa
GO
CREATE TRIGGER C_CAUTHU
ON CAUTHU
FOR UPDATE, INSERT
AS
BEGIN
    SET NOCOUNT ON;
    -- In ra danh sách mã cầu thủ và tên cầu thủ đã được sửa va thêm mới
    SELECT MACT,
    HOTEN
    FROM inserted;
END;
--DROP TRIGGER C_CAUTHU

-- c. danh sách mã cầu thủ vừa được sửa và tên cầu thủ cũ.
USE QLBongDa
GO
CREATE TRIGGER C_CAUTHU
ON CAUTHU
FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    -- In ra danh sách mã cầu thủ và tên cầu thủ cũ
    SELECT d.MACT,       -- Mã cầu thủ từ bảng deleted
           d.HOTEN AS "HOTEN_CU"  -- Tên cầu thủ cũ
    FROM deleted d
    JOIN inserted i ON d.MACT = i.MACT;  -- Kết nối với bảng inserted để lấy mã cầu thủ tương ứng
END;
--DROP TRIGGER C_CAUTHU

-- d. danh sách mã cầu thủ vừa được sửa và tên cầu thủ cũ và cầu thủ mới.
USE QLBongDa
GO
CREATE TRIGGER C_CAUTHU
ON CAUTHU
FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    -- In ra danh sách mã cầu thủ và tên cầu thủ cũ và tên mới
    SELECT d.MACT,       -- Mã cầu thủ từ bảng deleted
           d.HOTEN AS "HOTEN_CU"  -- Tên cầu thủ cũ,
           i.HOTEN AS "HOTEN_MOI" -- Tên cầu thủ mới
    FROM deleted d
    JOIN inserted i ON d.MACT = i.MACT;  -- Kết nối với bảng inserted để lấy mã cầu thủ tương ứng
END;
--DROP TRIGGER C_CAUTHU

-- e. câu thông báo bằng Tiếng Việt:
-- ‘Vừa sửa thông tin của cầu thủ có mã số xxx’
-- với xxx là mã cầu thủ vừa được sửa.
USE QLBongDa
GO
CREATE TRIGGER C_CAUTHU
ON CAUTHU
FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Mact INT 
    SET @Mact = i.MACT
    FROM inserted
    -- In ra danh sách mã cầu thủ và tên cầu thủ cũ và tên mới
    SELECT d.MACT,       -- Mã cầu thủ từ bảng deleted
           d.HOTEN AS "HOTEN_CU"  -- Tên cầu thủ cũ,
           i.HOTEN AS "HOTEN_MOI" -- Tên cầu thủ mới
    FROM deleted d
    JOIN inserted i ON d.MACT = i.MACT;  -- Kết nối với bảng inserted để lấy mã cầu thủ tương ứng
    DECLARE @Mact INT; 
    DECLARE @HotenCu NVARCHAR(100);
    DECLARE @HotenMoi NVARCHAR(100);
    DECLARE cur CURSOR FOR 
    SELECT d.MACT, d.HOTEN, i.HOTEN
    FROM deleted d
    JOIN inserted i ON d.MACT = i.MACT;  -- Kết nối với bảng inserted
    OPEN cur;
    FETCH NEXT FROM cur INTO @Mact, @HotenCu, @HotenMoi;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT CONCAT(N'Vừa sửa thông tin của cầu thủ có mã: ', @Mact, 
                     N', tên cũ: ', @HotenCu, 
                     N', tên mới: ', @HotenMoi);
        FETCH NEXT FROM cur INTO @Mact, @HotenCu, @HotenMoi;
    END
    CLOSE cur;
    DEALLOCATE cur;
END;
--DROP TRIGGER C_CAUTHU