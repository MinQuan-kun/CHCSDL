--Cho biết mã số, họ tên, ngày sinh của những cầu thủ có họ không phải là họ “Nguyễn”.
SELECT CAUTHU.MACT,
        HOTEN,
        NGAYSINH
FROM CAUTHU
WHERE
    CAUTHU.HOTEN NOT LIKE N'Nguyễn %';