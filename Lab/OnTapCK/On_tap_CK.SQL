Thi cuối kì sẽ ghi giấy
--Tạo Database (không có ghi trong đề thi)
CREATE Database STICKER
USE  [STICKER]
GO
CREATE TABLE [CHUDE]
(
	[MaCD] numeric identity Primary key,
	[TenCD] nvarchar(50),
	[DacTrung] nvarchar(50)
)
CREATE TABLE [PHANLOAI]
(
	[MaLoai] nvarchar(4) Primary key,
	[TenLoai] nvarchar(50),
	[SoLuong] int
)
CREATE TABLE STICKER
(
	[MaSo] numeric identity Primary key,
	[TenSticker] nvarchar(50),
	[NamSX] INT,
	[MaCD] NUMERIC not null,
	[LanSuDung] int,
	[MaLoai] nvarchar(4),
	[GiaBan] float,
	FOREIGN KEY (MaCD) REFERENCES CHUDE,
	FOREIGN KEY (MaLoai) REFERENCES PHANLOAI,
)
INSERT INTO PHANLOAI(MaLoai, TenLoai, SoLuong) VALUES
('FREE', N'Miễn phí', '10'),
('PAID', N'Trả phí', '10')

INSERT INTO CHUDE(TenCD, DacTrung) VALUES
(N'Game',N'Thế giới mở'),
(N'Game',N'Đối kháng'),
(N'Nhà hàng',N'Các nhà hàng phúc vụ Ăn uống'),
(N'Quần áo',N'Mua sắm, thời trang'),
(N'Siêu thị',N'Ăn uống và Mua sắm')


INSERT INTO STICKER(TenSticker,NamSX,MaCD,LanSuDung,MaLoai,GiaBan) VALUES
(N'Genshin', '2018', 1, 0, 'FREE', 100),
(N'Liên Quân', '2018', 1, 0, 'PAID', 100),
(N'Honkai Star Rail', '2020', 1, 0, 'PAID', 100),
(N'Trấn Thành', '2015', 3, 0, 'PAID', 10),
(N'Gà', '2015', 4, 0, 'PAID', 10),
(N'BigC', '2015', 5, 0, 'PAID', 10)

--Câu 1

- Tổng kích thước của mẫu tập tin STICKER bao gồm cả header là:
8 + 40 + 10 + 8 + 8 + 8 + 8 + 12 = 102 Bytes

-Kích thước khả dụng cho dữ liệu trong một block:
1024 - 24 = 1000 bytes
*Giải thích mỗi block có kích thước 1024, Block Header chiếm 24 bytes
phải trừ 24 bytes

Số bản ghi để có thể lưu trữ trong một block là:
1000 / 102 = 9 bản ghi (phần này phải làm tròn xuống)

Số block cần thiết để lữu trữ 1000 bản ghi:
1000 / 9 = 112 blocks(phải làm tròn lên)

Kích thước file tối thiểu chứa 1000 bản ghi 
112 * 1024 = 114,688 bytes

-- Câu 2

*Vẽ cây cơ bản (không bắt buộc vẽ trong đề thi)

                        (5)π(MaSo, TenSticker,NamSX,
                            GiaBan, MaCD, MaLoai)
                                        | 
                                      MaCD
                                    /       \
                                /               \                   
                            /                       \                                              
            (4)π(MaSo, TenSticker,NamSX,               \
                GiaBan, MaCD, MaLoai)                       \                    
                          |                                     \                                   
                        MaLoai                                      \
                    /           \                                       \
                /                   \                                       \
            /                           \                                       \
        /                                   \                                       \
(1)SELECT π(MaLoai)          (2)SELECT π(MaSo, TenSticker,               (3)SELECT π(TenCD, MaCD)
        |                           NamSX,GiaBan, MaCD, MaLoai)                       |
        |                                 |                                  WHERE DacTrung LIKE N'%Ăn uống %' 
Where PhanLoai = 'Paid'        WHERE YEAR(GETDATE) - NamSX > 3             AND DacTrung LIKE N'%Mua sắm %'
        |                                 |                                           |
    (PHANLOAI)                        (STICKER)                                    (CHUDE)

--CODE SQL
SELECT D.MaSo, D.TenSticker, D.NamSX, D.GiaBan, D.MaCD, C.TenCD
FROM (SELECT MaSo, TenSticker, NamSX, GiaBan, MaCD
	FROM(
(SELECT MaLoai
FROM PHANLOAI
WHERE MaLoai = 'PAID') A 
JOIN 
(SELECT MaSo, TenSticker, NamSX,GiaBan, MaCD, MaLoai
FROM STICKER
WHERE YEAR(GETDATE()) - YEAR(NamSX) > 3) B
ON A.MaLoai = B.MaLoai
)) D
JOIN 
(SELECT TenCD, MaCD
FROM CHUDE
WHERE DacTrung LIKE N'%Ăn uống%'
AND DacTrung LIKE N'%Mua sắm%') C 
ON C.MaCD = D.MaCD

--Câu 3
CREATE TRIGGER trg_UpdateSoLuong
ON STICKER
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @New_MaLoai nvarchar(4);
    DECLARE @Old_MaLoai nvarchar(4);

    -- Gán giá trị MaLoai từ inserted và deleted vào biến nếu có
    SELECT @New_MaLoai = MaLoai FROM inserted;
    SELECT @Old_MaLoai = MaLoai FROM deleted;

    -- Xử lý khi có INSERT: Thêm số lượng cho các MaLoai mới
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        -- Cập nhật số lượng của từng MaLoai mới bằng cách đếm số dòng cho từng MaLoai trong bảng inserted
        UPDATE PHANLOAI
        SET SoLuong = SoLuong + i.SoLuongMoi
        FROM PHANLOAI
        JOIN (
            SELECT MaLoai, COUNT(*) AS SoLuongMoi
            FROM inserted
            GROUP BY MaLoai
        ) AS i ON PHANLOAI.MaLoai = i.MaLoai;
    END

    -- Xử lý khi có DELETE: Giảm số lượng cho các MaLoai bị xóa
    IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Cập nhật số lượng của từng MaLoai bị xóa bằng cách đếm số dòng cho từng MaLoai trong bảng deleted
        UPDATE PHANLOAI
        SET SoLuong = SoLuong - d.SoLuongCu
        FROM PHANLOAI
        JOIN (
            SELECT MaLoai, COUNT(*) AS SoLuongCu
            FROM deleted
            GROUP BY MaLoai
        ) AS d ON PHANLOAI.MaLoai = d.MaLoai;
    END

    -- Xử lý khi có UPDATE: Giảm số lượng cho các MaLoai cũ và tăng số lượng cho các MaLoai mới
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        -- Giảm số lượng cho các MaLoai cũ
        UPDATE PHANLOAI
        SET SoLuong = SoLuong - d.SoLuongCu
        FROM PHANLOAI
        JOIN (
            SELECT MaLoai, COUNT(*) AS SoLuongCu
            FROM deleted
            GROUP BY MaLoai
        ) AS d ON PHANLOAI.MaLoai = d.MaLoai;

        -- Tăng số lượng cho các MaLoai mới
        UPDATE PHANLOAI
        SET SoLuong = SoLuong + i.SoLuongMoi
        FROM PHANLOAI
        JOIN (
            SELECT MaLoai, COUNT(*) AS SoLuongMoi
            FROM inserted
            GROUP BY MaLoai
        ) AS i ON PHANLOAI.MaLoai = i.MaLoai;
    END
END;

-- Drop the trigger
DROP TRIGGER trg_UpdateSoLuong;

--Câu 4
    T1      T2      T3      T4    
1   L(A);
    R(A)
2           L(C);
            R(C)
3                           L(B);
                            R(B) 
4                   L(D);
                    R(D)
5           L(A)
            --Chờ
6                   L(C)
                    --Chờ
7                           L(A)
                            --Chờ                    
8   L(B)
    --Chờ

T3 -> T2 -> T1 <-> T4

Điểm quan trọng nhất:
T1
chịu sự chi phối của T4 và T2

Bài này có xảy ra hiện tưởng deadlock
T1 chờ tài nguyên B từ T4 
T2 chờ tài nguyên A từ T1
T3 chờ tài nguyên C từ T2 
T4 chờ tài nguyên A từ T1
Do đó, có deadlock xảy ra vì có chu trình chờ tài nguyên giữa các tiến trình, 
làm cho tất cả các tiến trình đều không thể tiến hành. Cụ thể, T1 chờ A từ T4, 
nhưng T4 cũng đang chờ A từ T1. Đây là chu trình chờ trong đồ thị tài nguyên, dẫn đến tình trạng deadlock.

Cách giải quyết deadlock
Time-out 
T4 yêu cầu A từ T1, nếu T1 không cung cấp A trong vòng 5 giây, ta sẽ bỏ qua chu trình.

Wait-die
Chờ lâu quá sẽ ngắt 
ta sẽ ngắt nhánh từ T1 qua T4 