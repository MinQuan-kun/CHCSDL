-- Số trái bóng mà cầu thủ ghi được phải lớn hơn 0.
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
