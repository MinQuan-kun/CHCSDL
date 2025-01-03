
-----Phan 6 -----CAI DAT RULE
use QLBongDa
GO
---Cau24
go
create rule r_Vaitro
	as @Vaitro in (N'HLV chính',N'HLV phụ',N'HLV thể lực',N'HLV thủ môn')
	go
	sp_bindrule 'r_Vaitro','HLV_CLB.VAITRO'

--test rule ---> viết hoa /thưởng ????
insert into HLV_CLB values
('HLV06','CSDT',N'HLV Chính'),
insert into HLV_CLB values
('HLV08','BBD',N'HLV Thủ Môn')

---Cau23
go
create rule r_Vitri
	as @Vitri in (N'Thủ môn',N'Tiền đạo',N'Tiền vệ',N'Trung vệ',N'Hậu vệ')
	GO
	SP_BINDRULE 'r_Vitri','CAUTHU.VITRI'
--test rule cai dat
insert into CAUTHU (HOTEN,VITRI,NGAYSINH,MACLB,MAQG,SO)values
 (N'Nguyễn Vũ Phong',N'Tiền Vệ','2016-10-23','BBD','VN',17)
insert into CAUTHU (HOTEN,VITRI,NGAYSINH,MACLB,MAQG,SO)values
(N'Nguyễn Công Vinh',N'Tiền Đạo','2016-10-23','HAGL','VN',9)

----go bo rule 
--go
--sp_unbindrule 'CAUTHU.VITRI'
----huy rule
--drop rule r_Vitri

---Cau25
go
create rule r_Tuoi
	as (Year(Getdate()) - Year (@Tuoi)) >=18	--between 18 and 36
	GO
	SP_BINDRULE 'r_Tuoi','CAUTHU.NGAYSINH'
--test rule
insert into CAUTHU (HOTEN,VITRI,NGAYSINH,MACLB,MAQG,SO)values 
(N'Ronaldo',N'Tiền Vệ','1990-10-23','SDN','BRA',8)
insert into CAUTHU (HOTEN,VITRI,NGAYSINH,MACLB,MAQG,SO)values 
(N'Vidic',N'Tiền Vệ','1996-10-23','HAGL','ANH',3)

---Cau26
go
create rule r_Sotrai
	as @Sotrai >0
	GO
	SP_BINDRULE 'r_Sotrai','THAMGIA.SOTRAI'
	
--test rule
insert into THAMGIA values
('1','1','2')
	
-----Phan 7 -----CAI DAT VIEW
---Cau27 (c1)
go
CREATE VIEW SHB_Braxin 
AS 
SELECT MACT,HOTEN,NGAYSINH,DIACHI,VITRI
FROM CAUTHU
WHERE MAQG = (select MAQG	from QUOCGIA where TENQG=N'Bra-xin') and 
	MACLB=	(select MACLB	from CAULACBO where TENCLB=N'SHB Đà Nẵng')

---Cau28 (c3)
go
CREATE VIEW Trandau_v3n2009 
as
select MATRAN,NGAYTD,KETQUA,TENSAN,C1.TENCLB,C2.TENCLB
from (SELECT * FROM TRANDAU WHERE VONG='3' AND NAM=2009) TD 
		JOIN CAULACBO C1 ON TD.MACLB1=C1.MACLB
		JOIN CAULACBO C2 ON TD.MACLB2=C2.MACLB
		JOIN SANVD ON TD.MASAN=SANVD.MASAN

---Cau29 (c4)
go
Create view clb_hlv_vietnam 
as
select hv.MAHLV,TENHLV,hv.NGAYSINH,hv.DIACHI,h.VAITRO,c.TENCLB
from (CAULACBO c join HLV_CLB h on c.MACLB=H.MACLB)  
	JOIN HUANLUYENVIEN hv ON h.MAHLV= hv.MAHLV
where hv.MAQG IN (
	SELECT MAQG
	FROM QUOCGIA
	WHERE TENQG=N'Việt Nam')
	
---Cau30 (c5)
create view Cau30 as
select CAULACBO.MACLB , TENCLB,SANVD.TENSAN ,SANVD.DIACHI, COUNT(MACT) AS SLNB
from ( CAULACBO JOIN 	(
	SELECT CAUTHU.*
	FROM CAUTHU join QUOCGIA on CAUTHU.MAQG=QUOCGIA.MAQG
	WHERE TENQG!=N'Việt Nam') CT ON CAULACBO .MACLB=CT.MACLB) 
	 join  SANVD on CAULACBO.MASAN=SANVD.MASAN
GROUP BY CAULACBO.MACLB,TENCLB,SANVD.TENSAN,SANVD.DIACHI
HAVING COUNT (MACT)>2

---Cau31 (c6)
create view Cau31 as
select TENTINH,COUNT(MACT) SLCT_TINH
from CAUTHU join CAULACBO on CAUTHU.MACLB=CAULACBO.MACLB 
	join TINH on CAULACBO.MATINH=TINH.MATINH
WHERE CAUTHU.VITRI=N'Tiền đạo' 
GROUP BY TENTINH

---Cau32 (c7)
create view Cau32 as
select CAULACBO.TENCLB, TENTINH 
from BANGXH join CAULACBO on BANGXH.MACLB=CAULACBO.MACLB 
	join TINH on CAULACBO.MATINH=TINH.MATINH
WHERE NAM=2009 AND VONG=3 AND HANG=1

---Cau33 (c8)
create view Cau33 as
SELECT TENHLV
FROM HUANLUYENVIEN join HLV_CLB on HUANLUYENVIEN.MAHLV=HLV_CLB.MAHLV
WHERE DIENTHOAI IS NULL

-----Phan 8 -----CAI DAT STORE_PROCEDURE
use QLBongDa
go

---Cau35
create procedure hello(@tenban nvarchar(50))
as
begin
	print N'Xin chào '+@tenban	
end
--DROP PROC hello
hello N'khl'

---Cau36
create procedure tong(@s1 int,@s2 int)
as
begin
	declare @tg int
	set @tg=@s1 + @s2
	print N'Tổng là  '+ cast( @tg as nvarchar(10))
end

drop procedure tong
--test ham
tong 2,3


---Cau37
create procedure tongt(@s1 int,@s2 int,@t int output)
as
begin
	set @t=@s1 + @s2
	return @t
end

--drop procedure tongt
declare @tg int
select @tg=0
execute tongt 2,3,@tg out
select @tg as Tong2so 

---Cau38
create procedure TimMax(@s1 int,@s2 int)
as
begin
	declare @max int
	if (@s1 <@s2)
	begin 
		select @max=@s2		
		print N'Số lơn hơn là '+ cast( @max as nvarchar(10))
	end
	else 
	begin
		select @max=@s1
		if (@s1 > @s2)
		begin
			print N'Số lơn hơn là '+ cast( @max as nvarchar(10))
		end
		else
		begin
			print N'Hai số bằng nhau'		
		end
	end
	return @max	
end	

--drop procedure TimMax
 execute TimMax 5,5

---Cau39
create procedure minmax(@s1 int,@s2 int,@nho int output,@lon int output)
as
begin
	if(@s1>@s2)
	begin
		select @lon=@s1, @nho=@s2
	end
	else 
	begin
		select @lon=@s2, @nho=@s1
	end
	return
end

--drop procedure minmax
declare @min int ,@max int
select @min=0,@max=0
execute minmax 2,3,@min out,@max out
select @min as soNho,@max as soLon


---Cau40
create procedure tong1n (@n int)
as
begin
	if(@n>0)
	begin
		declare @i int, @s int
		select @s=0, @i=1
		while (@i<=@n)
		begin
			select @s=@s+@i
			select @i=@i+1
		end
		print N'Tổng từ 1 tới ' +cast( @n as nvarchar(10)) 
		+ ' là '+cast( @s as nvarchar(10))
	end
	else
	begin
		print N'Vui lòng nhập số dương'
	end	 
end
--drop procedure tong1n
tong1n 4

---Cau41
create procedure tongchan1n (@n int)
as
begin
	if(@n>0)
	begin
		declare @i int, @s int,@dem int
		select @s=0, @i=1,@dem=0
		while (@i<=@n)
		begin
			if (@i % 2=0)
			begin				
				select @s=@s+@i
				select @i=@i+2
				select @dem=@dem+1
			end
			else
			begin
				select @i=@i+1
			end
		end
		print N'Tổng các số chẵn từ 1 tới ' +cast( @n as nvarchar(10)) 
		+ ' là '+cast( @s as nvarchar(10))
		print N'số lượng số chẵn trong khoảng trên là '+cast( @dem as nvarchar(10))
	end
	else
	begin
		print N'Vui lòng nhập số dương'
	end	 
end
--drop procedure tongchan1n
tongchan1n 7

---Cau42-- TRAN HOA
use QLBongDa
go
CReate procedure SoTranHoav3n2009
as
begin
	declare @s int
	select @s=COUNT(*)
	from TRANDAU
	WHERE VONG=3 AND NAM=2009 
	AND LEFT(KETQUA,CHARINDEX('-',KETQUA)-1)=RIGHT(KETQUA,LEN(KETQUA)-CHARINDEX('-',KETQUA))
	
	print N'Số trận đầu hòa vòng 3 năm 2009 là '+cast(@s as varchar(10))	
end	
--drop procedure SoTranHoa
SoTranHoav3n2009



---Cau43 --khoi tao lai view qua procedure
use QLBongDa
go
--43_27
create procedure Cau43_27
as
begin		
	select MACT, HOTEN,NGAYSINH,DIACHI,VITRI
	from ( CAUTHU join CAULACBO on CAUTHU.MACLB=CAULACBO.MACLB)
				 join QUOCGIA on CAUTHU.MAQG=QUOCGIA.MAQG
	where CAULACBO.TENCLB=N'SHB Đà Nẵng' and QUOCGIA.TENQG='Bra-xin'
	return
end
--drop procedure Cau43_27
execute Cau43_27
go

--43_28
create procedure Cau43_28
as
begin
	select MATRAN,NGAYTD, TENSAN,C1.TENCLB,C2.TENCLB,KETQUA
	from (SELECT * FROM TRANDAU WHERE VONG='3' AND NAM=2009) TD 
			JOIN CAULACBO C1 ON TD.MACLB1=C1.MACLB
			JOIN CAULACBO C2 ON TD.MACLB2=C2.MACLB
			JOIN SANVD ON TD.MASAN=SANVD.MASAN
end
--DROP procedure Cau43_28
execute Cau43_28


--43_29
create procedure Cau43_29
as
begin
	select hv.MAHLV,TENHLV,hv.NGAYSINH,hv.DIACHI,h.VAITRO,c.TENCLB
from (CAULACBO c join HLV_CLB h on c.MACLB=H.MACLB)  
	JOIN HUANLUYENVIEN hv ON h.MAHLV= hv.MAHLV
where hv.MAQG IN (
	SELECT MAQG
	FROM QUOCGIA
	WHERE TENQG=N'Việt Nam')
end
--DROP procedure Cau43_29
execute Cau43_29

--43_30
create procedure Cau43_30
as
begin
	select CAULACBO.MACLB , TENCLB,SANVD.TENSAN ,SANVD.DIACHI, COUNT(MACT) AS SLNB
	from ( CAULACBO JOIN 	(
		SELECT CAUTHU.*
		FROM CAUTHU join QUOCGIA on CAUTHU.MAQG=QUOCGIA.MAQG
		WHERE TENQG!=N'Việt Nam') CT ON CAULACBO .MACLB=CT.MACLB) 
		 join  SANVD on CAULACBO.MASAN=SANVD.MASAN
	GROUP BY CAULACBO.MACLB,TENCLB,SANVD.TENSAN,SANVD.DIACHI
	HAVING COUNT (MACT)>2
end
--DROP procedure Cau43_30
execute Cau43_30

--43_31
create procedure Cau43_31
as
begin
	select TENTINH,COUNT(MACT) SLCT_TINH
	from CAUTHU join CAULACBO on CAUTHU.MACLB=CAULACBO.MACLB 
		join TINH on CAULACBO.MATINH=TINH.MATINH
	WHERE CAUTHU.VITRI=N'Tiền đạo' 
	GROUP BY TENTINH
end
--drop procedure Cau43_31
Cau43_31

--43_32
create procedure Cau43_32
as
begin
	select CAULACBO.TENCLB, TENTINH 
	from BANGXH join CAULACBO on BANGXH.MACLB=CAULACBO.MACLB 
		join TINH on CAULACBO.MATINH=TINH.MATINH
	WHERE NAM=2009 AND VONG=3 AND HANG=1
end
--drop proc Cau43_32
Cau43_32

--43_33
create procedure Cau43_33
as
begin
	SELECT TENHLV
	FROM HUANLUYENVIEN join HLV_CLB on HUANLUYENVIEN.MAHLV=HLV_CLB.MAHLV
	WHERE DIENTHOAI IS NULL
end
--drop proc Cau43_33
Cau43_33


----------------########------------------
---Cau44 --tao lai cac tham so
--# c42 tham so vong, nam
CReate procedure SoTranHoa (@v int, @n int)
as
begin
	declare @s int
	select @s=COUNT(*)
	from TRANDAU
	WHERE VONG=@v AND NAM=@n 
	AND LEFT(KETQUA,CHARINDEX('-',KETQUA)-1)=RIGHT(KETQUA,LEN(KETQUA)-CHARINDEX('-',KETQUA))
	
	print N'Số trận đầu hòa vòng 3 năm 2009 là '+cast(@s as varchar(10))	
end	
--drop procedure SoTranHoa
SoTranHoa '2','2009'

--# 44c27
create procedure Cau44_27 (@tenclb nvarchar(50),@tenqgia nvarchar(50))
as
begin		
	select MACT, HOTEN,NGAYSINH,DIACHI,VITRI
	from ( CAUTHU join CAULACBO on CAUTHU.MACLB=CAULACBO.MACLB)
				 join QUOCGIA on CAUTHU.MAQG=QUOCGIA.MAQG
	where CAULACBO.TENCLB=@tenclb and QUOCGIA.TENQG=@tenqgia
	return
end
--drop procedure Cau44_27
execute Cau44_27 N'SHB Đà Nẵng',N'Bra-xin'
go

--# 44c28
create procedure Cau44_28(@vong int, @nam int)
as
begin
	select MATRAN,NGAYTD, TENSAN,C1.TENCLB,C2.TENCLB,KETQUA
	from (SELECT * FROM TRANDAU WHERE VONG=@vong AND NAM=@nam) TD 
			JOIN CAULACBO C1 ON TD.MACLB1=C1.MACLB
			JOIN CAULACBO C2 ON TD.MACLB2=C2.MACLB
			JOIN SANVD ON TD.MASAN=SANVD.MASAN
end
--DROP procedure Cau44_28
execute Cau44_28 2,2009

--# 44c29
create procedure Cau44_29 (@tenqgia nvarchar(50))
as
begin
	select hv.MAHLV,TENHLV,hv.NGAYSINH,hv.DIACHI,h.VAITRO,c.TENCLB
from (CAULACBO c join HLV_CLB h on c.MACLB=H.MACLB)  
	JOIN HUANLUYENVIEN hv ON h.MAHLV= hv.MAHLV
where hv.MAQG IN (
	SELECT MAQG
	FROM QUOCGIA
	WHERE TENQG=@tenqgia)
end
--DROP procedure Cau44_29
execute Cau44_29 N'Việt Nam'

--# 44c30
create procedure Cau44_30 (@tenqgia nvarchar(50))
as
begin
	select CAULACBO.MACLB , TENCLB,SANVD.TENSAN ,SANVD.DIACHI, COUNT(MACT) AS SLNB
	from ( CAULACBO JOIN 	(
		SELECT CAUTHU.*
		FROM CAUTHU join QUOCGIA on CAUTHU.MAQG=QUOCGIA.MAQG
		WHERE TENQG!=@tenqgia) CT ON CAULACBO .MACLB=CT.MACLB) 
		 join  SANVD on CAULACBO.MASAN=SANVD.MASAN
	GROUP BY CAULACBO.MACLB,TENCLB,SANVD.TENSAN,SANVD.DIACHI
	HAVING COUNT (MACT)>2
end
--DROP procedure Cau44_30
execute Cau44_30 N'Việt Nam'

--# 44c31
create procedure Cau44_31 (@vitri nvarchar )
as
begin
	select TENTINH,COUNT(MACT) SLCT_TINH
	from CAUTHU join CAULACBO on CAUTHU.MACLB=CAULACBO.MACLB 
		join TINH on CAULACBO.MATINH=TINH.MATINH
	WHERE CAUTHU.VITRI=@vitri 
	GROUP BY TENTINH
end
--drop procedure Cau44_31
Cau44_31 N'Tiền đạo'

--# 44c32
create procedure Cau44_32(@nam int, @vong int,@hang int)
as
begin
	select CAULACBO.TENCLB, TENTINH 
	from BANGXH join CAULACBO on BANGXH.MACLB=CAULACBO.MACLB 
		join TINH on CAULACBO.MATINH=TINH.MATINH
	WHERE NAM=@nam AND VONG=@vong AND HANG=@hang
end
--drop proc Cau44_32
Cau44_32 2009,3,1


---Cau45
CReate proc Cauthu_Trandau (@MACT int)
as
begin
	print N'Các trận đầu cầu thủ này tham gia là '+cast(@MACT as varchar(10))
	
	declare @madb varchar(5)
	select top 1 @madb=MACLB
	FROM CAUTHU
	WHERE MACT=@MACT
		
	select MATRAN,NGAYTD,KETQUA,CLB1.TENCLB,CLB2.TENCLB,CLB1.MASAN,CLB2.MASAN
	from (	(TRANDAU JOIN CAULACBO as CLB1  ON CLB1.MACLB=TRANDAU.MACLB1 )
				JOIN	  CAULACBO AS CLB2 ON CLB2.MACLB=TRANDAU.MACLB2	) 
	WHERE MACLB1 =@madb or MACLB2=@madb
end		
--drop procedure Cauthu_Trandau
Cauthu_Trandau '3'


---Cau46
CReate proc Trandau_DSGhiban (@MATD int)
as
begin
	select *
	from CAUTHU
	where MACT IN  
	(select MACT
	from TRANDAU JOIN THAMGIA ON TRANDAU.MATRAN=THAMGIA.MATD
	WHERE MATD=@MATD)
end		
--drop procedure Trandau_DSGhiban
Trandau_DSGhiban 1

---Cau47
create proc SoTranHoa_Nam (@nam int)
as
begin
	select COUNT(*) as sotran
	from TRANDAU
	WHERE NAM=@nam
	AND LEFT(KETQUA,CHARINDEX('-',KETQUA)-1)=RIGHT(KETQUA,LEN(KETQUA)-CHARINDEX('-',KETQUA))
end	
--drop procedure SoTranHoa_Nam
SoTranHoa_Nam '2009'

-----Phan 9 -----CAI DAT TRIGGER
---Cau48
Create trigger tg_Cauthu_vitri on Cauthu
FOR INSERT
AS 
BEGIN
	declare @vitri nvarchar(20)
	select @vitri=vitri from inserted 
	if @vitri not in (N'Thủ môn',N'Tiền đạo',N'Tiền vệ', 
	N'Trung vệ',N'Hậu vệ')
	begin
		raiserror ('Vi tri khong hop le',15,1)
		rolLback tran
		return
	end
END
--DROP TRIGGER tg_Cauthu_vitri
insert into CAUTHU (HOTEN,VITRI,NGAYSINH,MACLB,MAQG,SO)values 
(N'Lý Tiểu Long',N'Tiền Vệ','1936-10-23','TPY','VN',7)

---Cau49
Create trigger tg_Cauthu_soao on Cauthu
FOR INSERT
AS 
BEGIN
	declare @so int, @maclb varchar(5)
	select @so=so, @maclb=maclb
	from Inserted 
	if ((select count(*) from cauthu where maclb=@maclb and so=@so) >1)
	begin
		raiserror (N'Số áo bị trùng',15,1)
		rolLback tran
		return
	end
END
--DROP TRIGGER tg_Cauthu_soao
insert into CAUTHU (HOTEN,VITRI,NGAYSINH,MACLB,MAQG,SO)values 
(N'Lý Tiểu Long',N'Tiền Vệ','1936-10-23','TPY','VN',9)

---Cau50
create trigger tg_Cauthu_success on Cauthu
for insert
as
begin
	print N'Đã thêm cầu thủ thành công'
end
--DROP TRIGGER tg_Cauthu_success
insert into CAUTHU (HOTEN,VITRI,NGAYSINH,MACLB,MAQG,SO)values 
(N'Lý Tiểu Long',N'Tiền Vệ','1936-10-23','TPY','VN',9)

---Cau51
create trigger tg_Cauthu_ngoaibinh on Cauthu
for insert
as
begin
	declare @maqg varchar(5), @maclb varchar(5)
	select @maqg=maqg, @maclb=maclb
	from Inserted 
	
	declare @mavn varchar(5)--luu ma qgia vietnam
	select @mavn=MAQG
	FROM QUOCGIA
	WHERE TENQG=N'Việt Nam'
		
	declare @sl_nb int --dem sl cauthu ngoai binh
	select @sl_nb =COUNT(MACT) 
	from CAULACBO JOIN CAUTHU ON CAULACBO.MACLB=CAUTHU.MACLB
	where CAULACBO.MACLB=@maclb AND MAQG<>@mavn
	
	if( (@maqg!=@mavn) AND (@sl_nb >2) )		
	begin
		raiserror (N'Đội dã đủ 2 cầu thủ ngoại binh',15,2)
		rolLback tran
		return
	end	
end

--DROP TRIGGER tg_Cauthu_ngoaibinh
insert into CAUTHU (HOTEN,VITRI,NGAYSINH,MACLB,MAQG,SO)values 
(N'Lý Tiểu Long',N'Tiền Vệ','1936-10-23','SDN','ANH',9)


---Cau52
create trigger tg_Quocgia on Quocgia
for insert
as
begin
	declare @ten nvarchar(60)
	select @ten=tenqg
	from Inserted 
	
	if( (select COUNT(*) from QUOCGIA where TENQG=@ten) > 1 )
	begin
		raiserror (N'Trùng tên quốc gia',15,1)
		rolLback tran
		return
	end	
end
drop trigger tg_Quocgia

---Cau53
create trigger tg_Tinh on Tinh
for insert
as
begin
	declare @ten nvarchar(60)
	select @ten=tentinh
	from Inserted 
	
	if( (select COUNT(*) from Tinh where TENTINH=@ten) > 1 )
	begin
		raiserror (N'Trùng tên tỉnh',15,1)
		rolLback tran
		return
	end	
end

---Cau54
create trigger tg_Trandau_kq on TRANDAU
for update
as
	if update(KETQUA)
	begin
		raiserror (N'Không được sửa đổi thông tin',15,1)
		rolLback tran
		return
	end	
--drop trigger tg_Trandau_kq
update trandau
set ketqua='2-2'
where matran=15

---Cau55
--55A vai tro hlv
Create trigger tg_HlvClb_Vaitro on HLV_CLB
FOR INSERT
AS 
BEGIN
	declare @vitri nvarchar(100)
	select @vitri=vaitro from inserted 
	if @vitri not in (N'HLV Thủ môn',N'HLV Chính',N'HLV Phụ',N'HLV Thể lực')
	begin
		raiserror ('Vai tro khong hop le',15,1)
		rolLback tran
		return
	end
END
--DROP TRIGGER tg_HlvClb_Vaitro
insert into HLV_CLB values
('HLV08','KKH',N'HLV Thủ môn')

--55B rang buoc sl hlv chinh
Create trigger tg_HlvClb_slChinh on HLV_CLB
FOR INSERT
AS 
BEGIN
	declare @vitri nvarchar(100), @madb varchar(5)
	select @vitri=vaitro, @madb=maclb
	from inserted 
	if ( (select count(*)
		 from HLV_CLB
		 where maclb=@madb and vaitro=N'HLV chính'
		 group by maclb)	>2	 and @vitri=N'HLV chính')
	begin
		raiserror ('CLB đã có đủ 2 HLV Chính',15,1)
		rolLback tran
		return
	end
END
--drop trigger tg_HlvClb_slChinh
insert into HLV_CLB values
('HLV06','KKH',N'HLV chính')

---Cau56
--56a--thong bao van cho insert
create trigger tg_CLB_tb on CAULACBO
for insert
as
begin
	declare @ten nvarchar(60)
	select @ten=tenclb
	from Inserted 
	
	if( (select COUNT(*) from CAULACBO where TENCLB=@ten) > 1 )
	begin
		raiserror (N'Trùng tên câu lạc bộ khác',15,1)
	end	
end

drop trigger tg_CLB

--56b--- thong bao va ko cho insert
create trigger tg_CLB on CAULACBO
for insert
as
begin
	declare @ten nvarchar(60)
	select @ten=tenclb
	from Inserted 
	PRINT 'ten '+@ten
	
	if( (select COUNT(*) from CAULACBO where TENCLB=@ten) > 1 )
	begin
		raiserror (N'Trùng tên câu lạc bộ khác',15,1)
		rolLback tran	
		return			
	end	
end

drop trigger tg_CLB

insert into CAULACBO values('abc',N'THÉP PHÚ YÊN','TH','DN')

