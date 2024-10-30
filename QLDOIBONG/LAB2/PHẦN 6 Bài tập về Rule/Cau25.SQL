-- Khi thêm cầu thủ mới, kiểm tra cầu thủ đó có tuổi phải đủ 18 trở lên (chỉ tính năm
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