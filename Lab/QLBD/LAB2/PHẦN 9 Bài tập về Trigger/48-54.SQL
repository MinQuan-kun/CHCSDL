-- c) Viết các trigger có nội dung như sau :
-- 48. Khi thêm cầu thủ mới, kiểm tra vị trí trên sân của cần thủ chỉ thuộc một trong các
-- vị trí sau: Thủ môn, Tiền đạo, Tiền vệ, Trung vệ, Hậu vệ.
USE QLBongDa
GO
CREATE TRIGGER C_Vitri
ON CAUTHU
FOR INSERT, UPDATE
AS
BEGIN 
	SET NOCOUNT ON;
	DECLARE @vitri NVARCHAR(50)
	SELECT @vitri = VITRI
	FROM Inserted
	IF @viTri NOT IN (N'Thủ môn', N'Tiền đạo', N'Tiền vệ', N'Trung vệ', N'Hậu vệ')
    BEGIN
        -- Nếu không hợp lệ, rollback và thông báo lỗi
        RAISERROR (N'Vị trí không hợp lệ. Vị trí chỉ được thuộc các giá trị: Thủ môn, Tiền đạo, Tiền vệ, Trung vệ, Hậu vệ.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
--DROP TRIGGER C_Vitri

-- 49. Khi thêm cầu thủ mới, kiểm tra số áo của cầu thủ thuộc cùng một câu lạc bộ phải
-- khác nhau.
USE QLBongDa
GO
CREATE TRIGGER C_SOAO
ON CAUTHU
FOR INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CT_ao INT, @CT_MACLB INT;
    -- Lấy số áo và mã câu lạc bộ của cầu thủ từ bảng inserted
    SELECT @CT_ao = SO, @CT_MACLB = MACLB
    FROM inserted;
    -- Kiểm tra nếu đã tồn tại cầu thủ với cùng số áo trong cùng một câu lạc bộ
    IF EXISTS (
        SELECT 1
        FROM CAUTHU
        WHERE MACLB = @CT_MACLB AND SO = @CT_ao
    )
    BEGIN
        -- Nếu trùng số áo, thông báo lỗi và rollback transaction
        RAISERROR ('Số áo đã tồn tại trong câu lạc bộ. Vui lòng chọn số áo khác.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
-- DROP TRIGGER C_SOAO

-- 50. Khi thêm thông tin cầu thủ thì in ra câu thông báo bằng Tiếng Việt ‘Đã thêm cầu
-- thủ mới’.
USE QLBongDa
GO
CREATE TRIGGER NOTICE 
ON CAUTHU
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;
    -- In thông báo khi thêm cầu thủ mới
    PRINT N'Đã thêm cầu thủ mới';
END
-- DROP TRIGEER NOTICE

-- 51. Khi thêm cầu thủ mới, kiểm tra số lượng cầu thủ nước ngoài ở mỗi câu lạc bộ chỉ
-- được phép đăng ký tối đa 8 cầu thủ.
USE QLBongDa
GO
CREATE TRIGGER PRV
ON CAUTHU
FOR INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CT_MACLB INT, @SoLuongNuocNgoai INT;
    -- Lấy mã câu lạc bộ từ bản ghi được thêm hoặc cập nhật
    SELECT @CT_MACLB = MACLB 
    FROM inserted;
    SET @SoLuongNuocNgoai = (
        SELECT COUNT(*)
        FROM CAUTHU
        WHERE MACLB = @CT_MACLB AND MAQG <> 'VN'
    );
	IF @SoLuongNuocNgoai >8
	BEGIN
		RAISERROR(N'Số lượng cầu thủ nước ngoài ở câu lạc bộ này chỉ được phép có tối đa là 8', 16, 1)
		ROLLBACK TRANSACTION;
	END
END
--DROP TRIGGER PRV

-- 52. Khi thêm tên quốc gia, kiểm tra tên quốc gia không được trùng với tên quốc gia
-- đã có.
USE QLBongDa
GO
CREATE TRIGGER C_QG
ON QUOCGIA
FOR UPDATE, INSERT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @QG NVARCHAR(500)
	SELECT @QG = TENQG
	FROM inserted
	IF EXISTS(
	SELECT 1 TENQG
	FROM QUOCGIA
	WHERE TENQG = @QG
	)
	BEGIN
		RAISERROR(N'Quốc gia này đã tồn tại', 16, 1);
		ROLLBACK TRANSACTION
	END
END
--DROP TRIGGER C_QG

-- 53. Khi thêm tên tỉnh thành, kiểm tra tên tỉnh thành không được trùng với tên tỉnh
-- thành đã có.
USE QLBongDa
GO
CREATE TRIGGER C_TINH
ON TINH
FOR UPDATE,INSERT
AS
BEGIN
	SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        WHERE EXISTS (
            SELECT 1
            FROM TINH AS t
            WHERE t.MATINH = i.MATINH
              AND t.TENTINH = i.TENTINH 
        )
    )
    BEGIN
        RAISERROR(N'Tỉnh này đã tồn tại', 16, 1);
        ROLLBACK TRANSACTION;
	END
END
--DROP TRIGGER C_TINH

-- 54. Không cho sửa kết quả của các trận đã diễn ra.
USE QLBongDa
GO
CREATE TRIGGER C_KetQuaTranDau
ON TRANDAU
FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    -- Kiểm tra nếu có bất kỳ trận đấu nào đã diễn ra nhưng đang cố gắng sửa kết quả
    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        JOIN TRANDAU AS t ON i.MATRAN = t.MATRAN
        WHERE t.NGAYTD < GETDATE()
    )
    BEGIN
        -- Nếu trận đấu đã diễn ra, báo lỗi và hủy giao dịch
        RAISERROR(N'Không được phép sửa kết quả của các trận đấu đã diễn ra.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
--DROP TRIGGER C_KetQuaTranDau