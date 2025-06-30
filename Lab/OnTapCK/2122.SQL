-- Câu 1
- Tổng kích thước của mẫu DiemMon bao gồm cả Header là:
12 + 12 + 12 + 8 + 16 + 18 + 10 = 88 Bytes
- Kích thước khả dụng cho dữ liệu trong một block:
1024 - 20 = 1004 Bytes
- Số bản ghi để có thể lưu trữ trong một block là:
1004 / 88 = 11 bản ghi
- Số block cần thiết để lữu trữ 12000 bản ghi:
12000 / 11 = 1091 blocks
- Kích thước file tối thiểu chứa 12000 bản ghi:
1091 * 1024 = 1117184 Bytes

-- Câu 2                                                                        
                                                SELECT(7) π(MaSo, TenHS, MaLop, DiemKT ) 
                                                            MaLop
                                                    /                       \
                                                /                                \
                                        SELECT(6) π(DiemKT, MaLop)                   \
                                            KhoiLop                                     \
                                /                                  \                         \    
                            /                                         \                         \     
                SELECT(5) π(DiemKT, MaLop, KhoiLop)                      \                           \
                               MaMon                                        \                             \           
                /                         \                                    \                               \   
            /                                \                                       \                             \     
SELECT(1) π(MaMon, DiemKT)       SELECT(2) π(MaMon, KhoiLop)              SELECT(3) π(KhoiLop, MaLop)        SELECT(4) π(MaSo, TenHS, MaLop) 
WHERE DiemKT >= 8.5                     WHERE TenMon = N'Tin học'              WHERE KhoiLop = 11
AND LoaiKT = N'kiểm tra 1 tiết'                                                          
AND HeSoKT = 2.0    
                                                                                                                                                                                                                                              
(DiemMon)                                    (MonHoc)                                 (LopHoc)                        (HocSinh)


-- Cơ bản
SELECT HS.MaSo, HS.TenHS, HS.MaLop, D.DiemKT 
FROM HocSinh HS, MonHoc MH, DiemMon D, LopHoc L
WHERE D.MaSoHS = HS.MaSo AND L.MaLop = HS.MaLop AND MH.MaMon = D.MaMon
AND MH.TenMon = N'Tin học' AND D.LoaiKT = N'kiểm tra 1 tiết' AND D.HeSoKT = 2.0 AND D.DiemKT >= 8.5 AND L.KhoiLop = 11

-- Tối ưu
SELECT HS.MaSo, HS.TenHS, HS.MaLop, D.DiemKT
FROM (
    SELECT D.DiemKT, E.MaLop 
    FROM (
        SELECT D.DiemKT, D.KhoiLop, D.MaLop, D.MaMon
        FROM (
            SELECT D.MaMon, D.DiemKT
            FROM DiemMon D
            WHERE D.DiemKT >= 8.5
            AND D.LoaiKT = N'kiểm tra 1 tiết'
            AND D.HeSoKT = 2.0
        ) A 
        JOIN (
            SELECT MH.MaMon, MH.KhoiLop
            FROM MonHoc MH
            WHERE MH.TenMon = N'Tin học'
        ) B 
        ON A.MaMon = B.MaMon
    ) D 
    JOIN (
        SELECT L.MaLop, L.KhoiLop
        FROM Lop L
        WHERE L.KhoiLop = 11
    ) E 
    ON D.KhoiLop = E.KhoiLop
) M 
JOIN (
    SELECT HS.MaSo, HS.TenHS, HS.MaLop
    FROM HocSinh HS
) HS 
ON M.MaLop = HS.MaLop;

-- Câu 3
-- a
CREATE TRIGGER trg_CheckSiSo
ON HocSinh
AFTER INSERT
AS
BEGIN
    DECLARE @MaLop NVARCHAR(50);

    SELECT @MaLop = i.MaLop
    FROM inserted i;

    IF (
        SELECT COUNT(*) 
        FROM HocSinh 
        WHERE MaLop = @MaLop
    ) > (
        SELECT SiSoToiDa 
        FROM LopHoc 
        WHERE MaLop = @MaLop
    )
    BEGIN
        RAISERROR (N'Số lượng học sinh đã vượt quá sĩ số tối đa của lớp học.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

-- b
CREATE PROCEDURE sp_ThongKeHocSinhLopTheoMon
    @MaLop NVARCHAR(50),
    @TenMon NVARCHAR(100)
AS
BEGIN

    DECLARE curHocSinh CURSOR FOR
    SELECT HS.MaSo, HS.TenHS
    FROM HocSinh HS
    WHERE HS.MaLop = @MaLop;

    DECLARE @MaSo NVARCHAR(50);
    DECLARE @TenHS NVARCHAR(100);
    DECLARE @TongDiemTP FLOAT;

    OPEN curHocSinh;

    FETCH NEXT FROM curHocSinh INTO @MaSo, @TenHS;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @TongDiemTP = SUM(D.DiemKT * D.HeSoKT)
        FROM DiemMon D
        JOIN MonHoc M ON D.MaMon = M.MaMon
        WHERE D.MaSoHS = @MaSo AND M.TenMon = @TenMon;

        PRINT @MaSo + ' | ' + @TenHS + ' | ' + CAST(ISNULL(@TongDiemTP, 0) AS NVARCHAR(50));

        FETCH NEXT FROM curHocSinh INTO @MaSo, @TenHS;
    END;

    CLOSE curHocSinh;
    DEALLOCATE curHocSinh;
END;