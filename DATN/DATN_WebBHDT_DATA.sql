USE DATN_WebBHDT;
GO
/*===== INSERT =====*/

/*
-- DIA_CHI
INSERT INTO DIA_CHI (taikhoan, diachi)
VALUES 
(2, N'123 Lê Lợi, Quận 1, TP.HCM');
GO
--SP_LOAI
INSERT INTO SP_LOAI (loai) VALUES 
(N'Điện thoại di động'),
(N'Máy tính bảng'),
(N'Laptop'),
(N'Máy tính để bàn'),
(N'Thiết bị đeo thông minh'),
(N'Phụ kiện điện thoại'),
(N'Phụ kiện máy tính'),
(N'Thiết bị mạng'),
(N'Thiết bị lưu trữ'),
(N'Tivi'),
(N'Loa và tai nghe'),
(N'Đồng hồ thông minh'),
(N'Máy ảnh và máy quay'),
(N'Máy in và mực in'),
(N'Đồ gia dụng thông minh');
GO
-- SP_THUONG_HIEU
INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES 
(N'Apple'),
(N'Samsung'),
(N'Xiaomi'),
(N'Oppo'),
(N'Vivo'),
(N'Realme'),
(N'Nokia'),
(N'ASUS'),
(N'Dell'),
(N'HP'),
(N'Lenovo'),
(N'Acer'),
(N'Sony'),
(N'LG'),
(N'Panasonic'),
(N'Canon'),
(N'Epson'),
(N'JBL'),
(N'Anker'),
(N'Huawei');
GO
-- YEU_THICH
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (5, 1);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (12, 3);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (7, 4);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (18, 2);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (3, 8);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (9, 5);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (14, 7);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (2, 9);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (20, 6);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (6, 10);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (11, 1);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (1, 3);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (8, 4);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (16, 2);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (4, 8);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (10, 5);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (13, 7);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (19, 9);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (15, 6);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (17, 10);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (2, 1);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (5, 3);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (9, 4);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (14, 2);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (6, 8);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (12, 5);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (3, 7);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (18, 9);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (7, 6);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (20, 10);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (1, 2);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (11, 8);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (4, 5);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (10, 3);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (13, 4);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (16, 6);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (15, 1);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (17, 7);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (8, 9);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (19, 10);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (6, 2);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (3, 6);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (7, 1);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (14, 10);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (1, 5);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (12, 6);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (20, 2);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (9, 3);
INSERT INTO YEU_THICH (sanpham, taikhoan) VALUES (18, 7);
GO
*/
/*===== CHECK P2 =====*/
SELECT * FROM TAI_KHOAN;
SELECT * FROM DIA_CHI;
SELECT * FROM SAN_PHAM;
SELECT * FROM SP_LOAI;
SELECT * FROM SP_THUONG_HIEU;
SELECT * FROM SP_THONG_SO;
SELECT * FROM ANH_SP;
SELECT * FROM HOA_DON;
SELECT * FROM HD_CHI_TIET;
SELECT * FROM THANH_TOAN;
SELECT * FROM GIO_HANG;
SELECT * FROM GOP_Y;
SELECT * FROM DANH_GIA;
SELECT * FROM YEU_THICH;
SELECT * FROM sys.tables;
GO
