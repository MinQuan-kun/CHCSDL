--Dùng lệnh print để in ra danh sách mã các cầu thủ, tên câu thủ, vị trí trên sân.
go
create procedure Cau_58
as
begin
declare Cur_Cauthu CurSor
for select MACT,HOTEN,VITRI from CAUTHU
open Cur_Cauthu
declare @MACT char(4),@HOTEN nvarchar(100), @VITRI nvarchar(100)
while 0=0
begin
fetch next from Cur_Cauthu into @MACT,@HOTEN, @VITRI
if @@fetch_status<>0 break
print N'Mã cầu thủ :' + @MACT + N'Tên cầu thủ :' +
@HOTEN + N' Vị trí:' + @VITRI
end
close Cur_CauThu
deallocate Cur_Cauthu