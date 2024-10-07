--Cho biết mã số, họ tên, ngày sinh (dd/MM/yyyy) của những cầu thủ có họ lót là “Công”.
SELECT  CAUTHU.MACT,
        HOTEN,
        NGAYSINH
FROM CAUTHU
WHERE
    CAUTHU.HOTEN LIKE N'% Công%';
