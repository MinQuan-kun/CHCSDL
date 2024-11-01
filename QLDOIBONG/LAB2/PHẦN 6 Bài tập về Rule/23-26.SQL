--23. Khi thêm cầu thủ mới, kiểm tra vị trí trên sân của cần thủ chỉ thuộc một trong các
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

--24. Khi phân công huấn luyện viên, kiểm tra vai trò của huấn luyện viên chỉ thuộc
--một trong các vai trò sau: HLV chính, HLV phụ, HLV thể lực, HLV thủ môn.
USE QLBongDa
GO
CREATE RULE rHlv
as @Vaitro = N'HLV chính' or @Vaitro =N'HLV phụ' or @Vaitro =N'HLV thể lực' or @Vaitro =N'HLV thủ môn'
GO
sp_bindrule 'rHlv', 'HLV_CLB.VAITRO'
--Kiểm tra, thêm điều kiện  vaitro
ALTER TABLE HLV_CLB
ADD CONSTRAINT chk_vaitro_hlv
CHECK (VAITRO IN (N'HLV chính', N'HLV phụ', N'HLV thể lực', N'HLV thủ môn'));

--25. Khi thêm cầu thủ mới, kiểm tra cầu thủ đó có tuổi phải đủ 18 trở lên (chỉ tính năm
-- sinh).
USE QLBongDa
GO 
CREATE RULE R_TUOICT AS
YEAR(GETDATE()) - YEAR(@Tuoi) >= 18
GO 
SP_BINDRULE 'R_TUOICT', 'CAUTHU.NGAYSINH'
--Kiểm tra, thêm điều kiện  tuổi
ALTER TABLE CAUTHU
ADD CONSTRAINT chk_tuoi_cauthu
CHECK (DATEDIFF(YEAR, NGAYSINH, GETDATE()) >= 18);

--26. Số trái bóng mà cầu thủ ghi được phải lớn hơn 0.
USE QLBongDa
GO
CREATE RULE rGoal
AS @g >0
GO
sp_bindrule 'rGoal', 'THAMGIA.SOTRAI'
--Kiểm tra, thêm điều kiện số trái phải lớn hơn 0
ALTER TABLE THAMGIA
ADD CONSTRAINT chk_Sotrai
CHECK (SOTRAI > 0)
