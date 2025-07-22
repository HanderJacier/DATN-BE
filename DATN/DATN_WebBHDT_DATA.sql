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
-- DATN_CRE_SP_DB00001_0
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'iPhone 14 Pro', @dongia = 25990000, @loai = 1, @thuonghieu = 1, @anhgoc = N'default.png', @cpu_brand = N'Apple', @cpu_model = N'A16 Bionic', @cpu_type = N'High-end', @cpu_min_speed = N'3.46 GHz', @cpu_max_speed = N'3.46 GHz', @cpu_cores = N'6', @cpu_threads = N'6', @cpu_cache = N'16MB', @gpu_brand = N'Apple', @gpu_model = N'Apple GPU', @gpu_full_name = N'Apple GPU 5-core', @gpu_memory = N'6GB', @ram = N'6GB', @storage = N'128GB', @screen = N'6.1"', @mausac = N'Tím', @soluong = 10, @anhphu = N'detail_iphone14.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'Samsung Galaxy A25', @dongia = 6290000, @loai = 1, @thuonghieu = 2, @anhgoc = N'default.png', @cpu_brand = N'Samsung', @cpu_model = N'Exynos 1280', @cpu_type = N'Mid-range', @cpu_min_speed = N'2.4 GHz', @cpu_max_speed = N'2.0 GHz', @cpu_cores = N'8', @cpu_threads = N'8', @cpu_cache = N'2MB', @gpu_brand = N'Mali', @gpu_model = N'Mali-G68', @gpu_full_name = N'Mali-G68', @gpu_memory = N'6GB', @ram = N'6GB', @storage = N'128GB', @screen = N'6.5"', @mausac = N'Xanh dương', @soluong = 15, @anhphu = N'detail_a25.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'Xiaomi 13T Pro', @dongia = 13990000, @loai = 1, @thuonghieu = 3, @anhgoc = N'default.png', @cpu_brand = N'MediaTek', @cpu_model = N'Dimensity 9200+', @cpu_type = N'Flagship', @cpu_min_speed = N'3.35 GHz', @cpu_max_speed = N'3.0 GHz', @cpu_cores = N'8', @cpu_threads = N'8', @cpu_cache = N'8MB', @gpu_brand = N'Mali', @gpu_model = N'Mali-G715', @gpu_full_name = N'Mali-G715 Immortalis', @gpu_memory = N'12GB', @ram = N'12GB', @storage = N'256GB', @screen = N'6.67"', @mausac = N'Đen', @soluong = 20, @anhphu = N'detail_13tpro.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'Oppo A78', @dongia = 5990000, @loai = 1, @thuonghieu = 4, @anhgoc = N'default.png', @cpu_brand = N'Qualcomm', @cpu_model = N'Snapdragon 680', @cpu_type = N'Mid-range', @cpu_min_speed = N'2.4 GHz', @cpu_max_speed = N'1.9 GHz', @cpu_cores = N'8', @cpu_threads = N'8', @cpu_cache = N'4MB', @gpu_brand = N'Adreno', @gpu_model = N'Adreno 610', @gpu_full_name = N'Adreno 610', @gpu_memory = N'8GB', @ram = N'8GB', @storage = N'128GB', @screen = N'6.56"', @mausac = N'Xanh', @soluong = 18, @anhphu = N'detail_a78.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'Vivo V25e', @dongia = 7490000, @loai = 1, @thuonghieu = 5, @anhgoc = N'default.png', @cpu_brand = N'MediaTek', @cpu_model = N'Helio G99', @cpu_type = N'Mid-range', @cpu_min_speed = N'2.2 GHz', @cpu_max_speed = N'2.0 GHz', @cpu_cores = N'8', @cpu_threads = N'8', @cpu_cache = N'2MB', @gpu_brand = N'Mali', @gpu_model = N'Mali-G57', @gpu_full_name = N'Mali-G57 MC2', @gpu_memory = N'8GB', @ram = N'8GB', @storage = N'128GB', @screen = N'6.44"', @mausac = N'Vàng', @soluong = 12, @anhphu = N'detail_v25e.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'Realme Narzo 50A', @dongia = 3290000, @loai = 1, @thuonghieu = 6, @anhgoc = N'default.png', @cpu_brand = N'MediaTek', @cpu_model = N'Helio G85', @cpu_type = N'Entry', @cpu_min_speed = N'2.0 GHz', @cpu_max_speed = N'1.8 GHz', @cpu_cores = N'8', @cpu_threads = N'8', @cpu_cache = N'2MB', @gpu_brand = N'Mali', @gpu_model = N'Mali-G52', @gpu_full_name = N'Mali-G52 MC2', @gpu_memory = N'4GB', @ram = N'4GB', @storage = N'64GB', @screen = N'6.5"', @mausac = N'Xám', @soluong = 30, @anhphu = N'detail_narzo.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'Nokia C31', @dongia = 2390000, @loai = 1, @thuonghieu = 7, @anhgoc = N'default.png', @cpu_brand = N'Unisoc', @cpu_model = N'9863A1', @cpu_type = N'Entry', @cpu_min_speed = N'1.6 GHz', @cpu_max_speed = N'1.2 GHz', @cpu_cores = N'8', @cpu_threads = N'8', @cpu_cache = N'1MB', @gpu_brand = N'IMG', @gpu_model = N'PowerVR GE8322', @gpu_full_name = N'PowerVR GE8322', @gpu_memory = N'3GB', @ram = N'3GB', @storage = N'32GB', @screen = N'6.75"', @mausac = N'Xanh lá', @soluong = 25, @anhphu = N'detail_c31.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'ASUS ROG Phone 6', @dongia = 18990000, @loai = 1, @thuonghieu = 8, @anhgoc = N'default.png', @cpu_brand = N'Qualcomm', @cpu_model = N'Snapdragon 8+ Gen 1', @cpu_type = N'Flagship', @cpu_min_speed = N'3.2 GHz', @cpu_max_speed = N'2.0 GHz', @cpu_cores = N'8', @cpu_threads = N'8', @cpu_cache = N'8MB', @gpu_brand = N'Adreno', @gpu_model = N'Adreno 730', @gpu_full_name = N'Adreno 730', @gpu_memory = N'12GB', @ram = N'12GB', @storage = N'256GB', @screen = N'6.78"', @mausac = N'Đen cam', @soluong = 8, @anhphu = N'detail_rog6.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'Dell XPS 13', @dongia = 31990000, @loai = 3, @thuonghieu = 9, @anhgoc = N'default.png', @cpu_brand = N'Intel', @cpu_model = N'i7-1260P', @cpu_type = N'Laptop', @cpu_min_speed = N'2.1 GHz', @cpu_max_speed = N'4.7 GHz', @cpu_cores = N'12', @cpu_threads = N'16', @cpu_cache = N'18MB', @gpu_brand = N'Intel', @gpu_model = N'Iris Xe', @gpu_full_name = N'Iris Xe Graphics', @gpu_memory = N'16GB', @ram = N'16GB', @storage = N'512GB SSD', @screen = N'13.4"', @mausac = N'Bạc', @soluong = 5, @anhphu = N'detail_xps13.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'HP Envy x360', @dongia = 21990000, @loai = 3, @thuonghieu = 10, @anhgoc = N'default.png', @cpu_brand = N'AMD', @cpu_model = N'Ryzen 5 7530U', @cpu_type = N'Laptop', @cpu_min_speed = N'2.0 GHz', @cpu_max_speed = N'4.5 GHz', @cpu_cores = N'6', @cpu_threads = N'12', @cpu_cache = N'16MB', @gpu_brand = N'AMD', @gpu_model = N'Radeon Vega', @gpu_full_name = N'Radeon Vega 7', @gpu_memory = N'16GB', @ram = N'16GB', @storage = N'512GB SSD', @screen = N'15.6"', @mausac = N'Xám', @soluong = 7, @anhphu = N'detail_envy.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'Lenovo Yoga Slim 7', @dongia = 18990000, @loai = 3, @thuonghieu = 11, @anhgoc = N'default.png', @cpu_brand = N'AMD', @cpu_model = N'Ryzen 7 6800U', @cpu_type = N'Laptop', @cpu_min_speed = N'2.7 GHz', @cpu_max_speed = N'4.7 GHz', @cpu_cores = N'8', @cpu_threads = N'16', @cpu_cache = N'16MB', @gpu_brand = N'AMD', @gpu_model = N'Radeon 680M', @gpu_full_name = N'Radeon 680M', @gpu_memory = N'16GB', @ram = N'16GB', @storage = N'512GB SSD', @screen = N'14"', @mausac = N'Tím', @soluong = 6, @anhphu = N'detail_yoga.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'Acer Aspire 5', @dongia = 13990000, @loai = 3, @thuonghieu = 12, @anhgoc = N'default.png', @cpu_brand = N'Intel', @cpu_model = N'i5-1135G7', @cpu_type = N'Laptop', @cpu_min_speed = N'2.4 GHz', @cpu_max_speed = N'4.2 GHz', @cpu_cores = N'4', @cpu_threads = N'8', @cpu_cache = N'8MB', @gpu_brand = N'Intel', @gpu_model = N'Iris Xe', @gpu_full_name = N'Iris Xe Graphics', @gpu_memory = N'8GB', @ram = N'8GB', @storage = N'512GB SSD', @screen = N'15.6"', @mausac = N'Xám bạc', @soluong = 10, @anhphu = N'detail_aspire.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'Sony Xperia 5 V', @dongia = 24990000, @loai = 1, @thuonghieu = 13, @anhgoc = N'default.png', @cpu_brand = N'Qualcomm', @cpu_model = N'Snapdragon 8 Gen 2', @cpu_type = N'Flagship', @cpu_min_speed = N'3.2 GHz', @cpu_max_speed = N'2.0 GHz', @cpu_cores = N'8', @cpu_threads = N'8', @cpu_cache = N'8MB', @gpu_brand = N'Adreno', @gpu_model = N'Adreno 740', @gpu_full_name = N'Adreno 740', @gpu_memory = N'8GB', @ram = N'8GB', @storage = N'128GB', @screen = N'6.1"', @mausac = N'Trắng', @soluong = 9, @anhphu = N'detail_xperia5v.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'LG Wing 5G', @dongia = 15990000, @loai = 1, @thuonghieu = 14, @anhgoc = N'default.png', @cpu_brand = N'Qualcomm', @cpu_model = N'Snapdragon 765G', @cpu_type = N'Mid-range', @cpu_min_speed = N'2.4 GHz', @cpu_max_speed = N'2.0 GHz', @cpu_cores = N'8', @cpu_threads = N'8', @cpu_cache = N'4MB', @gpu_brand = N'Adreno', @gpu_model = N'Adreno 620', @gpu_full_name = N'Adreno 620', @gpu_memory = N'8GB', @ram = N'8GB', @storage = N'128GB', @screen = N'6.8"', @mausac = N'Bạc', @soluong = 4, @anhphu = N'detail_wing.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'Panasonic Toughpad', @dongia = 18990000, @loai = 2, @thuonghieu = 15, @anhgoc = N'default.png', @cpu_brand = N'Intel', @cpu_model = N'Atom Z8550', @cpu_type = N'Tablet', @cpu_min_speed = N'1.44 GHz', @cpu_max_speed = N'2.4 GHz', @cpu_cores = N'4', @cpu_threads = N'4', @cpu_cache = N'2MB', @gpu_brand = N'Intel', @gpu_model = N'HD Graphics', @gpu_full_name = N'HD Graphics', @gpu_memory = N'4GB', @ram = N'4GB', @storage = N'128GB', @screen = N'10.1"', @mausac = N'Đen', @soluong = 2, @anhphu = N'detail_toughpad.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'Canon EOS M50', @dongia = 15990000, @loai = 13, @thuonghieu = 16, @anhgoc = N'default.png', @cpu_brand = N'Canon', @cpu_model = N'CMOS APS-C', @cpu_type = N'Camera', @cpu_min_speed = N'0', @cpu_max_speed = N'0', @cpu_cores = N'4', @cpu_threads = N'4', @cpu_cache = N'0', @gpu_brand = N'Canon', @gpu_model = N'DIGIC 8', @gpu_full_name = N'DIGIC 8', @gpu_memory = N'4GB', @ram = N'4GB', @storage = N'32GB', @screen = N'3.0"', @mausac = N'Đen', @soluong = 3, @anhphu = N'detail_m50.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'Epson L3250', @dongia = 3990000, @loai = 14, @thuonghieu = 17, @anhgoc = N'default.png', @cpu_brand = N'Epson', @cpu_model = N'L3250', @cpu_type = N'Printer', @cpu_min_speed = N'0', @cpu_max_speed = N'0', @cpu_cores = N'2', @cpu_threads = N'2', @cpu_cache = N'0', @gpu_brand = N'0', @gpu_model = N'0', @gpu_full_name = N'0', @gpu_memory = N'2GB', @ram = N'2GB', @storage = N'16GB', @screen = N'No screen', @mausac = N'Trắng', @soluong = 6, @anhphu = N'detail_l3250.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'JBL Flip 6', @dongia = 2290000, @loai = 11, @thuonghieu = 18, @anhgoc = N'default.png', @cpu_brand = N'0', @cpu_model = N'0', @cpu_type = N'Speaker', @cpu_min_speed = N'0', @cpu_max_speed = N'0', @cpu_cores = N'2', @cpu_threads = N'2', @cpu_cache = N'0', @gpu_brand = N'0', @gpu_model = N'0', @gpu_full_name = N'0', @gpu_memory = N'2GB', @ram = N'2GB', @storage = N'8GB', @screen = N'No screen', @mausac = N'Xanh Navy', @soluong = 13, @anhphu = N'detail_flip6.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'Anker Soundcore 2', @dongia = 1490000, @loai = 11, @thuonghieu = 19, @anhgoc = N'default.png', @cpu_brand = N'0', @cpu_model = N'0', @cpu_type = N'Speaker', @cpu_min_speed = N'0', @cpu_max_speed = N'0', @cpu_cores = N'2', @cpu_threads = N'2', @cpu_cache = N'0', @gpu_brand = N'0', @gpu_model = N'0', @gpu_full_name = N'0', @gpu_memory = N'2GB', @ram = N'2GB', @storage = N'8GB', @screen = N'No screen', @mausac = N'Đen', @soluong = 11, @anhphu = N'detail_soundcore2.png';
EXEC DATN_CRE_SP_DB00001_0 @tensanpham = N'Huawei Watch GT 3', @dongia = 4990000, @loai = 12, @thuonghieu = 20, @anhgoc = N'default.png', @cpu_brand = N'Huawei', @cpu_model = N'GT 3', @cpu_type = N'Smartwatch', @cpu_min_speed = N'0', @cpu_max_speed = N'0', @cpu_cores = N'2', @cpu_threads = N'2', @cpu_cache = N'0', @gpu_brand = N'0', @gpu_model = N'0', @gpu_full_name = N'0', @gpu_memory = N'2GB', @ram = N'2GB', @storage = N'16GB', @screen = N'1.43"', @mausac = N'Vàng hồng', @soluong = 7, @anhphu = N'detail_gt3.png';
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
