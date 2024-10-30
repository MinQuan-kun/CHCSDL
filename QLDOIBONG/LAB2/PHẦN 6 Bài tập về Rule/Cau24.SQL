--Khi phân công huấn luyện viên, kiểm tra vai trò của huấn luyện viên chỉ thuộc
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