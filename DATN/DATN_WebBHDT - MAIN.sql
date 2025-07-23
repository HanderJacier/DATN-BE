-- PHẦN 1: Gỡ kết nối và xóa database nếu tồn tại
USE master;
GO

SET IMPLICIT_TRANSACTIONS OFF;
GO

SELECT @@TRANCOUNT;

WHILE @@TRANCOUNT > 0
BEGIN
    ROLLBACK;
END

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'DATN_WebBHDT')
BEGIN
    ALTER DATABASE DATN_WebBHDT SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DATN_WebBHDT;
END
GO

-- PHẦN 2: Tạo lại database
CREATE DATABASE DATN_WebBHDT;
GO

-- PHẦN 3: Tạo login cấp server nếu chưa có
IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name = 'DEV_BACKEND')
BEGIN
    CREATE LOGIN DEV_BACKEND 
    WITH PASSWORD = 'DEV', 
         CHECK_POLICY = OFF, 
         CHECK_EXPIRATION = OFF;
END
GO

-- PHẦN 4: Tạo user gắn với login trong database mới
USE DATN_WebBHDT;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'DEV_BACKEND')
BEGIN
    CREATE USER DEV_BACKEND FOR LOGIN DEV_BACKEND;
END
GO

-- PHẦN 5: Gán quyền db_owner cho user
EXEC sp_addrolemember 'db_owner', 'DEV_BACKEND';
GO
/*===== API_KEY =====*/
CREATE TABLE api_keys (
    api_key VARCHAR(64) PRIMARY KEY,
    role VARCHAR(10),
    description VARCHAR(255),
    is_active BIT DEFAULT 0 -- 1 = ADMIN / 0 = PROCECURE
);
INSERT INTO api_keys (api_key, role, description)
VALUES 
    ('datn_ad', 'ADMIN', N'Toàn quyền truy cập DB'),
    ('datn_us', 'PROCEDURE', N'Chỉ gọi được procedure động');
GO
SELECT * FROM api_keys;
GO
/*===== TABLE =====*/
-- TAI_KHOAN
CREATE TABLE TAI_KHOAN(
	id_tk INT IDENTITY(1,1) PRIMARY KEY,
	tendangnhap NVARCHAR(255)  UNIQUE,
	matkhau NVARCHAR(255) ,
	vaitro BIT DEFAULT 0 ,
	hoveten NVARCHAR(255) ,
	sodienthoai VARCHAR(15)  UNIQUE,
	email NVARCHAR(255)  UNIQUE,
	trangthai BIT DEFAULT 0 , -- 1 = ADMIN / 0 = USER
	ngaytao DATE  DEFAULT GETDATE(),
	ngaycapnhat DATE 
);
GO
-- DIA_CHI
CREATE TABLE DIA_CHI(
	id_dc INT IDENTITY(1,1)  PRIMARY KEY,
	taikhoan INT ,
	diachi NVARCHAR(255) ,
);
GO
-- SAN_PHAM
CREATE TABLE SAN_PHAM(
	id_sp INT IDENTITY(1,1)  PRIMARY KEY,
	tensanpham NVARCHAR(255) ,
	dongia DECIMAL(18, 0) DEFAULT 0 CHECK(dongia >= 0),
	loai INT ,
	thuonghieu INT ,
	anhgoc NVARCHAR(255) ,
	ngaytao DATE DEFAULT GETDATE() ,
    --Giảm giá
	loaigiam INT ,
	giamgia DECIMAL(18) DEFAULT 0 CHECK(giamgia >= 0),
	hangiamgia DATE
); 
GO
-- GIAM_GIA
CREATE TABLE GIAM_GIA (
    id_gg INT IDENTITY(1,1) PRIMARY KEY,
    loaigiamTen DECIMAL(18) DEFAULT 0 CHECK(loaigiamTen >= 0)
);
GO
-- SP_LOAI
CREATE TABLE SP_LOAI(
	id_l INT IDENTITY(1,1)  PRIMARY KEY,
	loaiTen NVARCHAR(255) ,
);
GO
-- SP_THUONG_HIEU
CREATE TABLE SP_THUONG_HIEU(
	id_th INT IDENTITY(1,1)  PRIMARY KEY,
	thuonghieuTen NVARCHAR(255) ,
);
GO
-- SP_THONG_SO
CREATE TABLE SP_THONG_SO(
	id_ts INT IDENTITY(1,1)  PRIMARY KEY,
	sanpham INT ,
	cpuBrand NVARCHAR(255) ,
	cpuModel NVARCHAR(255) ,
	cpuType NVARCHAR(255) ,
	cpuMinSpeed NVARCHAR(255) ,
	cpuMaxSpeed NVARCHAR(255) ,
	cpuCores NVARCHAR(255) ,
	cpuThreads NVARCHAR(255) ,
	cpuCache NVARCHAR(255) ,
	gpuBrand NVARCHAR(255) ,
	gpuModel NVARCHAR(255) ,
	gpuFullName NVARCHAR(255) ,
	gpuMemory NVARCHAR(255) ,
	ram NVARCHAR(255) ,
	rom NVARCHAR(255) ,
	screen NVARCHAR(255) ,
	mausac NVARCHAR(255) ,
	soluong INT DEFAULT 0 CHECK (soluong>= 0) ,
);
GO
-- ANH_SP
CREATE TABLE ANH_SP(
	id_a INT IDENTITY(1,1)  PRIMARY KEY,
	sanpham INT ,
	diachianh NVARCHAR(255) ,
);
GO
-- HOA_DON
CREATE TABLE HOA_DON(
	id_hd INT IDENTITY(1,1)  PRIMARY KEY,
	taikhoan INT ,
	ngaytao DATE DEFAULT GETDATE() ,
	giahoadon DECIMAL(18) DEFAULT 0 CHECK(giahoadon >= 0),
	trangthai NVARCHAR(255) ,
	noidung NVARCHAR(255) ,
);
GO
-- HD_CHI__TIET
CREATE TABLE HD_CHI_TIET(
	id_hdct INT IDENTITY(1,1)  PRIMARY KEY,
	hoadon INT ,
	sanpham INT ,
	dongia DECIMAL(18) DEFAULT 0 CHECK(dongia >= 0),
	soluong INT DEFAULT 0 CHECK (soluong>= 0) ,
);
GO
-- THANH_TOAN
CREATE TABLE THANH_TOAN(
	id_tt INT IDENTITY(1,1)  PRIMARY KEY,
	hoadon INT ,
	phuongthuc NVARCHAR(255) ,
	sotien DECIMAL(18) DEFAULT 0 CHECK(sotien >= 0) ,
	ngaythanhtoan DATE ,
	magiaodich NVARCHAR(255) ,
	taikhoan INT ,
	ngaytao DATE DEFAULT GETDATE() ,
);
GO
-- GIO_HANG
CREATE TABLE GIO_HANG(
	id_gh INT IDENTITY(1,1)  PRIMARY KEY,
	sanpham INT ,
	taikhoan INT ,
);
GO
-- GOP_Y
CREATE TABLE GOP_Y(
	id_gy INT IDENTITY(1,1)  PRIMARY KEY,
	taikhoan INT ,
	noidung NVARCHAR(255) ,
	ngaytao DATE DEFAULT GETDATE(),
    ngaycapnhat DATE
);
GO
-- DANH_GIA
CREATE TABLE DANH_GIA(
	id_dg INT IDENTITY(1,1)  PRIMARY KEY,
	taikhoan INT ,
	sanpham INT ,
	noidung NVARCHAR(255) ,
	diemso INT DEFAULT 0 CHECK (diemso>=0 AND diemso<=5) ,
);
GO
-- YEU_THICH
CREATE TABLE YEU_THICH(
	id_yt INT IDENTITY(1,1)  PRIMARY KEY,
	sanpham INT ,
	taikhoan INT ,
    trangthai NVARCHAR(5)
);
GO
/*===== VIEW =====*/
CREATE VIEW vw_SanPham_ChiTiet
AS
SELECT 
    -- Thông tin sản phẩm chính
    SP.id_sp,
    SP.tensanpham,
    SP.dongia,

    SP.loai,
    L.loaiTen,

    SP.thuonghieu,
    TH.thuonghieuTen,

    SP.anhgoc,
    SP.hangiamgia,
    SP.ngaytao,

    SP.loaigiam,
    GG.loaigiamTen,
    SP.giamgia,

    -- Thông số kỹ thuật
    TS.id_ts,
    TS.cpuBrand,
    TS.cpuModel,
    TS.cpuType,
    TS.cpuMinSpeed,
    TS.cpuMaxSpeed,
    TS.cpuCores,
    TS.cpuThreads,
    TS.cpuCache,
    TS.gpuBrand,
    TS.gpuModel,
    TS.gpuFullName,
    TS.gpuMemory,
    TS.ram,
    TS.rom,
    TS.screen,
    TS.mausac,
    TS.soluong,

    -- Ảnh phụ
    A.id_a,
    A.diachianh,

    -- Đánh giá
    DG.id_dg,
	DG.taikhoan as dg_taikhoan,
	DG.sanpham as dg_sanpham,
	DG.noidung,
	DG.diemso,

    -- Yêu thích
    YT.id_yt,
	YT.sanpham as yt_sanpham,
	YT.taikhoan as yt_taikhoan,
    YT.trangthai
FROM 
    SAN_PHAM SP
LEFT JOIN SP_LOAI L ON SP.loai = L.id_l
LEFT JOIN SP_THUONG_HIEU TH ON SP.thuonghieu = TH.id_th
LEFT JOIN GIAM_GIA GG ON SP.loaigiam = GG.id_gg
LEFT JOIN SP_THONG_SO TS ON SP.id_sp = TS.sanpham
LEFT JOIN ANH_SP A ON SP.id_sp = A.sanpham
LEFT JOIN DANH_GIA DG ON SP.id_sp = DG.sanpham
LEFT JOIN YEU_THICH YT ON SP.id_sp = YT.sanpham
GO
/*===== TRIGGER =====*/
--trg_auto_dayedit_taikhoan
CREATE TRIGGER trg_auto_dayedit_taikhoan
ON TAI_KHOAN
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON

    UPDATE TAI_KHOAN
    SET ngaycapnhat = GETDATE()
    FROM TAI_KHOAN
    INNER JOIN inserted i ON TAI_KHOAN.id_tk = i.id_tk;
END;
GO
--trg_auto_giagiam_sanpham
CREATE TRIGGER trg_upsert_giagiam_sanpham
ON SAN_PHAM
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE sp
    SET sp.giamgia = sp.dongia * (1 - (gg.loaigiamTen) / 100)
    FROM SAN_PHAM sp
    JOIN GIAM_GIA gg ON gg.id_gg = sp.loaigiam 
    JOIN inserted i ON sp.id_sp = i.id_sp;
END;
GO
/*===== PROC =====*/
-- DATN_CRE_SP_DB00001_0
CREATE PROCEDURE WBH_AD_CRT_THEMSP
    @p_tensanpham NVARCHAR(255),
    @p_dongia BIGINT,
    @p_loai INT,
    @p_thuonghieu INT,
    @p_anhgoc NVARCHAR(255),
    @p_cpuBrand NVARCHAR(255),
    @p_cpuModel NVARCHAR(255),
    @p_cpuType NVARCHAR(255),
    @p_cpuMinSpeed NVARCHAR(255),
    @p_cpuMaxSpeed NVARCHAR(255),
    @p_cpuCores NVARCHAR(255),
    @p_cpuThreads NVARCHAR(255),
    @p_cpuCache NVARCHAR(255),
    @p_gpuBrand NVARCHAR(255),
    @p_gpuModel NVARCHAR(255),
    @p_gpuFullName NVARCHAR(255),
    @p_gpuMemory NVARCHAR(255),
    @p_ram NVARCHAR(255),
    @p_rom NVARCHAR(255),
    @p_screen NVARCHAR(255),
    @p_mausac NVARCHAR(255),
    @p_soluong INT,
    @p_anhphu NVARCHAR(255),
    @p_id_gg INT,
    @p_hangiamgia DATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO SAN_PHAM (tensanpham, dongia, loai, thuonghieu, anhgoc, loaigiam, hangiamgia)
        VALUES (@p_tensanpham, @p_dongia, @p_loai, @p_thuonghieu, @p_anhgoc, @p_id_gg, @p_hangiamgia);
        DECLARE @NewProductID INT = SCOPE_IDENTITY();
        INSERT INTO SP_THONG_SO (
            sanpham, cpuBrand, cpuModel, cpuType, cpuMinSpeed, cpuMaxSpeed, cpuCores, cpuThreads, cpuCache,
            gpuBrand, gpuModel, gpuFullName, gpuMemory, ram, rom, screen, mausac, soluong
        )
        VALUES (
            @NewProductID, @p_cpuBrand, @p_cpuModel, @p_cpuType, @p_cpuMinSpeed, @p_cpuMaxSpeed, @p_cpuCores, @p_cpuThreads, @p_cpuCache,
            @p_gpuBrand, @p_gpuModel, @p_gpuFullName, @p_gpuMemory, @p_ram, @p_rom, @p_screen, @p_mausac, @p_soluong
        );
        INSERT INTO ANH_SP (sanpham, diachianh)
        VALUES (@NewProductID, @p_anhphu);
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO
-- DATN_CRE_SP_DB00001_1
CREATE PROCEDURE WBH_US_SEL_DETAIL_SP
    @p_id_sp INT 
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        *
    FROM 
        vw_SanPham_ChiTiet
    WHERE 
        id_sp = @p_id_sp;
END;
GO
-- DATN_CRE_SP_DB00001_2
CREATE PROCEDURE WBH_US_SEL_XEMSP
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        *
    FROM 
        vw_SanPham_ChiTiet
END;
GO
-- DATN_CRE_SP_DB00001_3
CREATE PROCEDURE WBH_US_SEL_NGAYTAOSP
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * 
    FROM vw_SanPham_ChiTiet
    ORDER BY ngaytao DESC;
END;
GO
-- DATN_CRE_SP_DB00001_4
CREATE PROCEDURE WBH_US_SEL_RANKYTSP
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        SPCT.*, 
        ISNULL(YT.SoYeuThich, 0) AS SoYeuThich
    FROM 
        vw_SanPham_ChiTiet SPCT
    LEFT JOIN (
        SELECT sanpham, COUNT(*) AS SoYeuThich
        FROM YEU_THICH
        GROUP BY sanpham
    ) YT ON SPCT.id_sp = YT.sanpham
    ORDER BY 
        YT.SoYeuThich DESC;
END;
GO
-- DATN_CRE_SP_DB00001_5 
CREATE PROCEDURE WBH_US_SEL_SALESP
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM vw_SanPham_ChiTiet
    WHERE hangiamgia >= GETDATE();
END;
GO
-- DATN_CRE_SP_DB00001_6
CREATE PROCEDURE WBH_AD_UPD_SUASP
    @p_id_sp INT,
    @p_tensanpham NVARCHAR(255),
    @p_dongia BIGINT,
    @p_loai INT,
    @p_thuonghieu INT,
    @p_anhgoc NVARCHAR(255),
    @p_cpuBrand NVARCHAR(255),
    @p_cpuModel NVARCHAR(255),
    @p_cpuType NVARCHAR(255),
    @p_cpuMinSpeed NVARCHAR(255),
    @p_cpuMaxSpeed NVARCHAR(255),
    @p_cpuCores NVARCHAR(255),
    @p_cpuThreads NVARCHAR(255),
    @p_cpuCache NVARCHAR(255),
    @p_gpuBrand NVARCHAR(255),
    @p_gpuModel NVARCHAR(255),
    @p_gpuFullName NVARCHAR(255),
    @p_gpuMemory NVARCHAR(255),
    @p_ram NVARCHAR(255),
    @p_rom NVARCHAR(255),
    @p_screen NVARCHAR(255),
    @p_mausac NVARCHAR(255),
    @p_soluong INT,
    @p_anhphu NVARCHAR(255),
    @p_id_gg INT,
    @p_hangiamgia DATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        -- Cập nhật bảng SAN_PHAM
        UPDATE SAN_PHAM
        SET tensanpham = @p_tensanpham,
            dongia = @p_dongia,
            loai = @p_loai,
            thuonghieu = @p_thuonghieu,
            anhgoc = @p_anhgoc,
            loaigiam = @p_id_gg,
            hangiamgia = @p_hangiamgia
        WHERE id_sp = @p_id_sp;

        -- Cập nhật bảng SP_THONG_SO
        UPDATE SP_THONG_SO
        SET cpuBrand = @p_cpuBrand,
            cpuModel = @p_cpuModel,
            cpuType = @p_cpuType,
            cpuMinSpeed = @p_cpuMinSpeed,
            cpuMaxSpeed = @p_cpuMaxSpeed,
            cpuCores = @p_cpuCores,
            cpuThreads = @p_cpuThreads,
            cpuCache = @p_cpuCache,
            gpuBrand = @p_gpuBrand,
            gpuModel = @p_gpuModel,
            gpuFullName = @p_gpuFullName,
            gpuMemory = @p_gpuMemory,
            ram = @p_ram,
            rom = @p_rom,
            screen = @p_screen,
            mausac = @p_mausac,
            soluong = @p_soluong
        WHERE sanpham = @p_id_sp;

        -- Cập nhật bảng ANH_SP
        UPDATE ANH_SP
        SET diachianh = @p_anhphu
        WHERE sanpham = @p_id_sp;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO
-- DATN_CRE_GY_DB00002_0
CREATE PROCEDURE WBH_US_CRT_GY
    @id_tk INT,
    @noidung NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO GOP_Y(taikhoan, noidung)
    VALUES (@id_tk, @noidung);
END;
GO
-- DATN_CRE_GY_DB00002_1
CREATE PROCEDURE WBH_AD_SEL_GY_PHAN_TRANG
    @p_pageNo INT,
    @p_pageSize INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        *
    FROM 
        GOP_Y
    ORDER BY 
        ngaytao DESC
    OFFSET (@p_pageNo - 1) * @p_pageSize ROWS
    FETCH NEXT @p_pageSize ROWS ONLY;
END;
GO
-- DATN_CRE_GY_DB00003_0
CREATE PROCEDURE WBH_US_UPD_CAPNHAT_YT_SP
    @sanpham INT,
    @taikhoan INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM YEU_THICH 
        WHERE sanpham = @sanpham AND taikhoan = @taikhoan
    )
    BEGIN
        UPDATE YEU_THICH
        SET trangthai = CASE WHEN trangthai = 'Y' THEN 'N' ELSE 'Y' END
        WHERE sanpham = @sanpham AND taikhoan = @taikhoan;
    END
    ELSE
    BEGIN
        -- Nếu chưa có, thêm mới với trạng thái 1 (yêu thích)
        INSERT INTO YEU_THICH(sanpham, taikhoan, trangthai)
        VALUES (@sanpham, @taikhoan, 'Y');
    END
END;
GO
-- DATN_CRE_SP_DB00001_3
CREATE PROCEDURE WBH_AD_SEL_getTAIKHOAN
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * 
    FROM TAI_KHOAN
    ORDER BY ngaytao DESC;
END;
GO
-- DATN_CRE_SP_DB00001_3
CREATE PROCEDURE WBH_AD_SEL_getGIAMGIA
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * 
    FROM GIAM_GIA
END;
GO
-- WBH_US_SEL_LOGIN_USER
CREATE PROCEDURE WBH_US_SEL_LOGIN_USER
    @p_tendangnhap NVARCHAR(255),
    @p_matkhau NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @p_rtn_value INT;

    BEGIN TRY
        -- 1. Kiểm tra dữ liệu đầu vào
        IF (@p_tendangnhap IS NULL OR LTRIM(RTRIM(@p_tendangnhap)) = '')
        BEGIN
            SET @p_rtn_value = 1;
            SELECT @p_rtn_value AS rtn_value;
            RETURN;
        END

        IF (@p_matkhau IS NULL OR LTRIM(RTRIM(@p_matkhau)) = '')
        BEGIN
            SET @p_rtn_value = 2;
            SELECT @p_rtn_value AS rtn_value;
            RETURN;
        END

        -- 2. Tìm tài khoản
        DECLARE @id_tk INT,
                @matkhau_db NVARCHAR(255),
                @trangthai BIT;

        SELECT 
            @id_tk = id_tk,
            @matkhau_db = matkhau,
            @trangthai = trangthai
        FROM TAI_KHOAN
        WHERE tendangnhap = @p_tendangnhap;

        IF (@id_tk IS NULL)
        BEGIN
            SET @p_rtn_value = 3;
            SELECT @p_rtn_value AS rtn_value;
            RETURN;
        END

        IF (@matkhau_db <> @p_matkhau)
        BEGIN
            SET @p_rtn_value = 4;
            SELECT @p_rtn_value AS rtn_value;
            RETURN;
        END

        IF (@trangthai = 0)
        BEGIN
            SET @p_rtn_value = 5;
            SELECT @p_rtn_value AS rtn_value;
            RETURN;
        END

        -- Đăng nhập thành công
        SET @p_rtn_value = 0;

        -- Trả thông tin tài khoản
        SELECT 
            id_tk,
            tendangnhap,
            vaitro,
            hoveten,
            sodienthoai,
            email,
            ngaytao,
            ngaycapnhat
        FROM TAI_KHOAN
        WHERE id_tk = @id_tk;
        -- Trả mã kết quả
        SELECT @p_rtn_value AS rtn_value;
    END TRY
    BEGIN CATCH
        SET @p_rtn_value = 99;
        SELECT @p_rtn_value AS rtn_value;
    END CATCH
END;
GO
-- WBH_US_CRT_CREATE_ACCOUNT
CREATE PROCEDURE WBH_US_CRT_CREATE_ACCOUNT
    @p_tendangnhap NVARCHAR(255),
    @p_matkhau NVARCHAR(255),
    @p_hoveten NVARCHAR(255),
    @p_sodienthoai VARCHAR(15),
    @p_email NVARCHAR(255),
    @p_vaitro BIT = 0,
    @p_trangthai BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @rtn_value INT;

    -- Validate
    IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE tendangnhap = @p_tendangnhap)
        SET @rtn_value = -1;
    ELSE IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE sodienthoai = @p_sodienthoai)
        SET @rtn_value = -2;
    ELSE IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE email = @p_email)
        SET @rtn_value = -3;
    ELSE IF @p_email NOT LIKE '%_@__%.__%'
        SET @rtn_value = -4;
    ELSE IF @p_sodienthoai NOT LIKE '[0-9][0-9][0-9]%' OR LEN(@p_sodienthoai) NOT IN (10, 11)
        SET @rtn_value = -5;
    ELSE
    BEGIN
        INSERT INTO TAI_KHOAN (tendangnhap, matkhau, hoveten, sodienthoai, email, vaitro, trangthai, ngaycapnhat)
        VALUES (@p_tendangnhap, @p_matkhau, @p_hoveten, @p_sodienthoai, @p_email, @p_vaitro, @p_trangthai, GETDATE());

        SET @rtn_value = 0;
    END

    -- Trả về kết quả cuối cùng
    SELECT @rtn_value AS rtn_value;
END
GO
/*===== CHECK TRIGGER =====*/
SELECT
    t.name AS TriggerName, 
    o.name AS TableName,
    t.is_disabled AS IsDisabled, 
    CONVERT(DATE, t.create_date) AS CreateDate,
    CONVERT(DATE, t.modify_date) AS ModifyDate
FROM 
    sys.triggers t
JOIN 
    sys.objects o ON t.parent_id = o.object_id
WHERE 
    t.is_ms_shipped = 0
ORDER BY 
    t.create_date DESC;
GO
/*===== CHECK PROCEDURE =====*/
SELECT name 
FROM sys.procedures;
--GIAM_GIA
INSERT INTO GIAM_GIA(loaigiamTen) VALUES
(0),
(5),
(10),
(15),
(20),
(25),
(30),
(35),
(40),
(45),
(50),
(55),
(60),
(65),
(70);
GO
--SP_LOAI
INSERT INTO SP_LOAI (loaiTen) VALUES 
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
INSERT INTO SP_THUONG_HIEU (thuonghieuTen) VALUES 
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
-- TAI_KHOAN
INSERT INTO TAI_KHOAN (tendangnhap, matkhau, vaitro, hoveten, sodienthoai, email, trangthai)
VALUES 
(N'admin', N'admin123', 1, N'Quản trị viên', '0909999999', N'admin@shop.com', 1),
(N'user', N'123456', 0, N'Nguyễn Văn A', '0908888888', N'testuser@email.com', 1),
(N'user3', N'123456', 0, N'Nguyễn Văn C', '0900000003', N'user3@example.com', 0),
(N'user4', N'123456', 0, N'Trần Thị D', '0900000004', N'user4@example.com', 0),
(N'user5', N'123456', 0, N'Lê Văn E', '0900000005', N'user5@example.com', 1),
(N'user6', N'123456', 0, N'Phạm Thị F', '0900000006', N'user6@example.com', 1),
(N'user7', N'123456', 0, N'Hồ Văn G', '0900000007', N'user7@example.com', 1),
(N'user8', N'123456', 0, N'Đặng Thị H', '0900000008', N'user8@example.com', 1),
(N'user9', N'123456', 0, N'Bùi Văn I', '0900000009', N'user9@example.com', 1),
(N'user10', N'123456', 0, N'Vũ Thị J', '0900000010', N'user10@example.com', 1);
GO