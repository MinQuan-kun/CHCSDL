-- Câu 1
- Tổng kích thước của mẫu DIEMDL bao gồm cả Header là:
8 + 50 + 8 + 20 + 12 = 98 Bytes
- Kích thước khả dụng cho dữ liệu trong một block:
1024 - 24 = 1000 Bytes
- Số bản ghi để có thể lưu trữ trong một block là:
1000 / 98 = 10 bản ghi
- Số block cần thiết để lữu trữ 1000 bản ghi:
1000 / 10 = 100 blocks
- Kích thước file tối thiểu chứa 1000 bản ghi:
100 * 1024 = 102400 Bytes

-- Câu 2

        (5) SELECT π(MATOUR, TENTOUR, SONGAY,PT_DI)                   
                          |
                        MaDDL 
                          |      \    
                          |           \
                          |               \
                          |                    \                    
                          |                         \                                             
                    (4)π(MaDDL)                         \
                                                            \              
                          |                                     \                              
                        MaTTP                                      \                
                    /           \                                      \                    
                /                   \                                     \                     
            /                           \                                     \                     
        /                                   \                                    \                      
(1)SELECT π(MaTTP)       (2)SELECT π(MaDDL, MaTTP)                (3)SELECT π(MATOUR, TENTOUR, SONGAY,PT_DI,MADDL)                                 
        |                                 |                                       |
        |                                 |                                       |
Where Mien LIKE N'Miền trung'   WHERE DACTRUNG LIKE N'%Tham quan%'           Where SONGAY >= 6
                               AND DACTRUNG LIKE N'%Mua sắm%'                     |
        |                                 |                                       |
    (TINHTP)                         (DIEMDL)                                  (TOUR)



SELECT KH.MAH, GD.MALOP, HV.MAHV, HV.HO, HV.TEN, GD.SOBL, GD.DIEM, GD.KQUA, GD.XEPLOAI
FROM(SELECT KH.MAKH, GD.MALOP, GD.MAHV, GD.)


-- Câu 4
    T1      T2      T3      T4    
1   L(A)             
    R(A)                
2           L(C);
            R(C)
3                   L(B);                    
                    R(B)                     
4                           L(D);
                            R(D)
5           L(A)
            --Chờ
6                   L(C)               
                    --Chờ            
7                           L(B)
                            --Chờ                    
8   L(C)
    --Chờ
