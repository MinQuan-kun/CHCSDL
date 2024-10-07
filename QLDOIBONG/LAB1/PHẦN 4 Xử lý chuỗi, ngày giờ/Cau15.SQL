-- Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ của những huấn luyện viên Việt Nam có tuổi nằm trong khoảng 35 – 40.
DECLARE TUOI INT;

SELECT HUANLUYENVIEN.MAHLV,
        HOTEN,
        NGAYSINH.
        DIACHI
FROM HUANLUYENVIEN
    JOIN QUOCGIA ON HUANLUYENVIEN.MAQG = QUOCGIA.MAQG
WHERE
