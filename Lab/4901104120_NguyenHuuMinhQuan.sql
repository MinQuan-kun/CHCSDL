/*----------------------------------------------------

HO TEN: Nguyễn Hữu Minh Quân        MASV: 49.01.104.120

MA ĐE: 1                    -    NGAY THI: 11/6/2024

----------------------------------------------------*/


--Trình bày các câu bên dưới trong file scrip mới và nộp bài tại MS Teams:
--Câu 1: (3.0 đ) Tạo các Store Procedure kèm Cursor và viết lệnh thực thi để kiểm tra store vừa tạo: 
--Dùng lệnh print để in ra màn hình danh sách tất cả các chuyến xe vận chuyển có tải trọng chuyến trên 5000 kg với quãng đường dưới @sokm (là tham số đầu vào store). 
CREATE PROC C_1
    @sokm INT
AS
BEGIN
    -- Khai báo cursor để lấy danh sách chuyến xe thỏa mãn điều kiện
    DECLARE ch_kg CURSOR 
    FOR
    SELECT MaChuyen, QuangDuong, lx.TaiTrongXe
    FROM VanChuyen vc
    JOIN TaiXe tx ON tx.MaTaiXe = vc.MaTaiXe
    JOIN XeTai xt ON xt.BienSo = vc.BienSo
    JOIN LoaiXe lx ON xt.MaLoaiXe = lx.MaLoaiXe
    WHERE lx.TaiTrongXe > 5000 AND vc.QuangDuong < @sokm -- Sử dụng tham số @sokm thay vì số cố định
    OPEN ch_kg

    DECLARE @MaChuyenXe NVARCHAR(50), @QuangDuong INT, @TaiTrongXe INT

    -- Lấy giá trị đầu tiên từ cursor
    FETCH NEXT FROM ch_kg INTO @MaChuyenXe, @QuangDuong, @TaiTrongXe
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- In thông tin chuyến xe thỏa mãn điều kiện
        PRINT 'Mã Chuyến: ' + @MaChuyenXe + ', Quãng Đường: ' + CAST(@QuangDuong AS NVARCHAR) + ' km, Tải Trọng: ' + CAST(@TaiTrongXe AS NVARCHAR) + ' kg'

        -- Lấy giá trị tiếp theo từ cursor
        FETCH NEXT FROM ch_kg INTO @MaChuyenXe, @QuangDuong, @TaiTrongXe
    END

    -- Đóng và giải phóng cursor
    CLOSE ch_kg
    DEALLOCATE ch_kg
END

-- Kiểm tra store procedure bằng cách thực thi với quãng đường dưới 50 km
EXEC C_1 50

-- Xóa store procedure nếu cần thiết
-- DROP PROC C_1


SELECT *
FROM VanChuyen
SELECT *
FROM LoaiXe
SELECT *
FROM XeTai

SELECT * FROM [dbo].[LoaiXe]
--Câu 2: (3.0 đ) Cài đặt Trigger cho các chức năng sau và viết câu lệnh kiểm tra:
--Không tạo hoặc chỉnh sửa hồ sơ tài xế dưới 18 tuổi (tính theo năm sinh).
USE dbXe
GO
CREATE TRIGGER C_Tuoi
ON TaiXe
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    DECLARE @error NVARCHAR(100);

    -- Kiểm tra điều kiện tuổi
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE YEAR(GETDATE()) - YEAR(NgaySinh) < 18
    )
    BEGIN
        -- Gán thông báo lỗi khi tuổi < 18
        SET @error = N'Không thể tạo hoặc chỉnh sửa hồ sơ cho tài xế dưới 18 tuổi.';
        RAISERROR(@error, 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Nếu tuổi hợp lệ thì tiếp tục thực hiện lệnh
    ELSE
    BEGIN
        -- Chèn hoặc cập nhật bản ghi trong bảng TaiXe
        INSERT INTO TaiXe (MaTaiXe, HoTenTaiXe, NgaySinh, DiaChi)
        SELECT MaTaiXe, HoTenTaiXe, NgaySinh, DiaChi
        FROM inserted;
    END
END;
--Kiểm tra thêm dữ liệu
INSERT INTO TaiXe(MaTaiXe, HoTenTaiXe, NgaySinh, DiaChi)
VALUES (N'X007', N'Tỷ','2025-05-27', 'VN')
--Kiểm tra update lại ngày sinh
UPDATE TaiXe
SET NgaySinh = '2025-05-27'
WHERE MaTaiXe = 'X006'
--DROP TRIGGER C_Tuoi
SELECT *
FROM TaiXe

--Câu 3: (3.0 đ) Viết câu lệnh bổ sung thuộc tính điểm kinh nghiệm cho bảng Tài xế (sử dụng ALTER TABLE) và cài đặt Trigger điều chỉnh điểm kinh nghiệm cho tài xế khi được nhận vận chuyển theo tỉ lệ 100km tương đương 1 điểm kinh nghiệm
-- Câu lệnh ALTER TABLE để thêm thuộc tính điểm kinh nghiệm
-- Câu lệnh ALTER TABLE để thêm thuộc tính điểm kinh nghiệm
ALTER TABLE TaiXe
ADD KinhNghiem INT DEFAULT 0;

CREATE TRIGGER trg_UpdateKinhNghiem
ON VanChuyen
AFTER INSERT
AS
BEGIN
    UPDATE TaiXe
    SET KinhNghiem = KinhNghiem + (i.QuangDuong / 100)
    FROM TaiXe tx
    INNER JOIN INSERTED i ON tx.MaTaiXe = i.MaTaiXe;
END;
--DROP TRIGGER trg_UpdateKinhNghiem
-- Xem kết quả sau khi Trigger được thực thi
SELECT *,
       vc.QuangDuong
FROM TaiXe
JOIN VanChuyen VC ON VC.MaTaiXe = TaiXe.MaTaiXe;

-- Kiểm tra các bản ghi trong bảng VanChuyen
SELECT * FROM VanChuyen;

-- Tạo thủ tục lưu trữ để chèn bản ghi mới vào bảng VanChuyen
CREATE PROC insrKn
    @MaTaiXe NVARCHAR(50)
AS
BEGIN
    -- Chèn bản ghi mới vào bảng VanChuyen với @MaTaiXe
    INSERT INTO VanChuyen (MaTaiXe, QuangDuong, BienSo, TaiTrong, NgayChuyen)
    VALUES (@MaTaiXe, 250, '55K1-10003', 7, GETDATE());
END;

EXEC insrKn 'X001';

IF NOT EXISTS (SELECT 1 FROM TaiXe WHERE MaTaiXe = 'X001')
BEGIN
    
    INSERT INTO TaiXe (MaTaiXe, KinhNghiem) VALUES ('X001', 0);
END;

INSERT INTO VanChuyen (MaTaiXe, QuangDuong, BienSo, TaiTrong, NgayChuyen)
VALUES ('X001', 250, '55K1-10003', 7, GETDATE());