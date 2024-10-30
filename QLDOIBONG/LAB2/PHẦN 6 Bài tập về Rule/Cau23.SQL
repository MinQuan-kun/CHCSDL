-- Khi thêm cầu thủ mới, kiểm tra vị trí trên sân của cần thủ chỉ thuộc một trong các
-- vị trí sau: Thủ môn, Tiền đạo, Tiền vệ, Trung vệ, Hậu vệ.
USE QLBongDa
GO

CREATE RULE R_VITRI AS
@Vitri IN (N'Thủ Môn', N'Tiền Đạo', N'Tiền Vệ', N'Trung Vệ', N'Hậu Vệ')

GO 
SP_BINDRULE 'R_VITRI', 'CAUTHU.VITRI'

--Kiểm tra, thêm điều kiện  vị trí
ALTER TABLE CAUTHU
CONSTRAINT chk_vitri
CHECK(VITRI IN (N'Thủ môn', N'Tiền đạo', N'Tiền vệ', N'Trung vệ', N'Hậu vệ'))