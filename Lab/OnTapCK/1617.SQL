-- Câu 1
- Tổng kích thước của mẫu SANPHAM bao gồm cả Header là:
8 + 40 + 8 + 20 + 5 + 4 + 12 = 97 Bytes
- Kích thước khả dụng cho dữ liệu trong một block là:
1024 -24 = 1000 Bytes
- Số bản ghi để có thể lưu trữ trong một block là:
1000 / 97 = 10 bản ghi
- Số block cần thiết cho để lưu trữ 10000 mẫu tin là:
10000 / 10 = 1000 blocks
- Kích thước file tối thiếu chứa 10000 mẫu tin là:
1000 * 1024 = 1024000 Bytes




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