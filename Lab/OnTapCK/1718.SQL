-- Câu 1
- Tổng kích thước của mẫu HOCVIEN bao gồm cả Header là: 
8 + 40 + 10 + 10 + 40 + 12 = 120 Bytes
- Kích thước khả dụng cho dữ liệu trong một block:
1024 - 24 = 1000 Bytes
- Số bản ghi để có thể lưu trữ trong một block là:
1000 / 120 = 8 bản ghi
- Số block cần thiết để lữu trữ 5000 bản ghi:
5000 / 8 = 625 blocks
- Kích thước file tối thiểu chứa 5000 bản ghi:
625 * 1024 = 640 KB

-- Câu 2
                (5)π(MAKH, MALOP, MAHV,HO, TEN,
                    SOBL, DIEM, KQUA, XEPLOAI, TIENNOP)
                          |
                        MAHV 
                          |      \    
                          |           \
                          |               \
                          |                    \                    
                          |                         \                                             
            (4)π(MAKH, MALOP, MAHV, SOBL,               \
            DIEM, KQUA, XEPLOAI, TIENNOP)                    \              
                          |                                     \                                  
                        MaKH                                      \
                    /           \                                      \
                /                   \                                     \  
            /                           \                                     \  
        /                                   \                                    \   
(1)SELECT π(MAKH, MALOP, MAHV,         (2)SELECT π(MAKH)                (3) SELECT π(HO, TEN)
    SOBL, DIEM, KQUA, XEPLOAI, TIENNOP)                                           |
        |                                 |                                       |
        |                                 |                                       |
Where TIENNOP > 5000000        WHERE MONTH(NGAYBATDAU) = 12                       |
                                AND YEAR(NGAYBATDAU) = 2017                       |
        |                                 |                                       |
    (GHIDANH)                         (KHOAHOC)                               (HOCVIEN)

SELECT A.MAKH, A.MALOP, A.MAHV, HV.HO, HV.TEN, A.SOBL, A.DIEM, A.KQUA, A.XEPLOAI, A.TIENNOP
FROM (SELECT MAKH, MALOP, MAHV, SOBL,DIEM, KQUA, XEPLOAI, TIENNOP)
	FROM(
(SELECT MaLoai
FROM PHANLOAI
WHERE MaLoai = 'PAID') A 
JOIN 
(SELECT MaSo, TenSticker, NamSX,GiaBan, MaCD, MaLoai
FROM STICKER
WHERE YEAR(GETDATE()) - YEAR(NamSX) > 3) B
ON A.MaLoai = B.MaLoai
) D
JOIN 
(SELECT TenCD, MaCD
FROM CHUDE
WHERE DacTrung LIKE N'%Ăn uống%'
AND DacTrung LIKE N'%Mua sắm%') C 
ON C.MaCD = D.MaCD


--Câu 4
    T1      T2      T3      T4    
1                   L(A)
                    R(A)
2           L(C);
            R(C)
3   L(B);                    
    R(B)                     
4                           L(D);
                            R(D)
5           L(A)
            --Chờ
6   L(C)               
    --Chờ            
7                           L(A)
                            --Chờ                    
8                   L(B)
                    --Chờ

T3 -> T1 -> T2 -> T3 <- T4

Điểm quan trọng nhất:
T3
chịu sự chi phối của T3 , T2

Bài này có xảy ra hiện tưởng deadlock
T1 chờ tài nguyên C từ T2 
T2 chờ tài nguyên A từ T3
T3 chờ tài nguyên B từ T1
T4 chờ tài nguyên A từ T1
Do đó, có deadlock xảy ra vì có chu trình chờ tài nguyên giữa các tiến trình, 
làm cho tất cả các tiến trình đều không thể tiến hành. Cụ thể, T3 chờ B từ T1, 
nhưng T1 cũng đang chờ C từ T2. Đây là chu trình chờ trong đồ thị tài nguyên, dẫn đến tình trạng deadlock.

Cách giải quyết deadlock
Time-out 
T1 yêu cầu C từ T2, nếu T2 không cung cấp C trong vòng 5 giây, ta sẽ bỏ qua chu trình.

Wait-die
Chờ lâu quá sẽ ngắt 
ta sẽ ngắt nhánh từ T3 qua T1