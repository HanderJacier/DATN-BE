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
	trangthai BIT DEFAULT 0 , -- 1 = ACTIVE / 0 = INACTIVE
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
-- HD_CHI_TIET
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
	ngaytao DATE DEFAULT GETDATE()
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
-- WBH_AD_SEL_getTAIKHOAN
CREATE PROCEDURE WBH_AD_SEL_getTAIKHOAN
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * 
    FROM TAI_KHOAN
    ORDER BY ngaytao DESC;
END;
GO
-- WBH_AD_SEL_getGIAMGIA
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
-- WBH_US_SEL_THONG_TIN_TAI_KHOAN
CREATE PROCEDURE WBH_US_SEL_THONG_TIN_TAI_KHOAN
    @p_id_tk INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        id_tk,
        tendangnhap,
        vaitro,
        hoveten,
        sodienthoai,
        email,
        trangthai,
        ngaytao,
        ngaycapnhat
    FROM TAI_KHOAN
    WHERE id_tk = @p_id_tk;
END;
GO
-- WBH_US_UPD_THONG_TIN_TAI_KHOAN
CREATE PROCEDURE WBH_US_UPD_THONG_TIN_TAI_KHOAN
    @p_id_tk INT,
    @p_hoveten NVARCHAR(255),
    @p_sodienthoai VARCHAR(15),
    @p_email NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @rtn_value INT;
    
    -- Validate email và số điện thoại không trùng với tài khoản khác
    IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE sodienthoai = @p_sodienthoai AND id_tk != @p_id_tk)
        SET @rtn_value = -1; -- Số điện thoại đã tồn tại
    ELSE IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE email = @p_email AND id_tk != @p_id_tk)
        SET @rtn_value = -2; -- Email đã tồn tại
    ELSE IF @p_email NOT LIKE '%_@__%.__%'
        SET @rtn_value = -3; -- Email không hợp lệ
    ELSE IF @p_sodienthoai NOT LIKE '[0-9][0-9][0-9]%' OR LEN(@p_sodienthoai) NOT IN (10, 11)
        SET @rtn_value = -4; -- Số điện thoại không hợp lệ
    ELSE
    BEGIN
        UPDATE TAI_KHOAN
        SET hoveten = @p_hoveten,
            sodienthoai = @p_sodienthoai,
            email = @p_email
        WHERE id_tk = @p_id_tk;
        
        SET @rtn_value = 0; -- Thành công
    END
    
    SELECT @rtn_value AS rtn_value;
END;
GO

-- WBH_US_UPD_DOI_MAT_KHAU
CREATE PROCEDURE WBH_US_UPD_DOI_MAT_KHAU
    @p_id_tk INT,
    @p_matkhau_cu NVARCHAR(255),
    @p_matkhau_moi NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @rtn_value INT;
    DECLARE @matkhau_db NVARCHAR(255);
    
    -- Lấy mật khẩu hiện tại
    SELECT @matkhau_db = matkhau
    FROM TAI_KHOAN
    WHERE id_tk = @p_id_tk;
    
    IF @matkhau_db IS NULL
        SET @rtn_value = -1; -- Tài khoản không tồn tại
    ELSE IF @matkhau_db != @p_matkhau_cu
        SET @rtn_value = -2; -- Mật khẩu cũ không đúng
    ELSE IF LEN(@p_matkhau_moi) < 6
        SET @rtn_value = -3; -- Mật khẩu mới quá ngắn
    ELSE
    BEGIN
        UPDATE TAI_KHOAN
        SET matkhau = @p_matkhau_moi
        WHERE id_tk = @p_id_tk;
        
        SET @rtn_value = 0; -- Thành công
    END
    
    SELECT @rtn_value AS rtn_value;
END;
GO
-- WBH_AD_SEL_DANH_SACH_NGUOI_DUNG
CREATE PROCEDURE WBH_AD_SEL_DANH_SACH_NGUOI_DUNG
    @p_pageNo INT = 1,
    @p_pageSize INT = 10,
    @p_keyword NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        id_tk,
        tendangnhap,
        vaitro,
        hoveten,
        sodienthoai,
        email,
        trangthai,
        ngaytao,
        ngaycapnhat
    FROM TAI_KHOAN
    WHERE (@p_keyword IS NULL OR 
           hoveten LIKE '%' + @p_keyword + '%' OR 
           tendangnhap LIKE '%' + @p_keyword + '%' OR 
           email LIKE '%' + @p_keyword + '%')
    ORDER BY ngaytao DESC
    OFFSET (@p_pageNo - 1) * @p_pageSize ROWS
    FETCH NEXT @p_pageSize ROWS ONLY;
END;
GO
-- WBH_AD_UPD_TRANG_THAI_TAI_KHOAN
CREATE PROCEDURE WBH_AD_UPD_TRANG_THAI_TAI_KHOAN
    @p_id_tk INT,
    @p_trangthai BIT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE TAI_KHOAN
    SET trangthai = @p_trangthai
    WHERE id_tk = @p_id_tk;
    
    SELECT @@ROWCOUNT AS affected_rows;
END;
GO
-- WBH_AD_UPD_VAI_TRO_TAI_KHOAN
CREATE PROCEDURE WBH_AD_UPD_VAI_TRO_TAI_KHOAN
    @p_id_tk INT,
    @p_vaitro BIT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE TAI_KHOAN
    SET vaitro = @p_vaitro
    WHERE id_tk = @p_id_tk;
    
    SELECT @@ROWCOUNT AS affected_rows;
END;
GO
-- WBH_US_CRT_HOA_DON
CREATE PROCEDURE WBH_US_CRT_HOA_DON
    @p_taikhoan INT,
    @p_giahoadon DECIMAL(18),
    @p_noidung NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO HOA_DON (taikhoan, giahoadon, trangthai, noidung)
    VALUES (@p_taikhoan, @p_giahoadon, N'Chờ thanh toán', @p_noidung);
    
    SELECT SCOPE_IDENTITY() AS id_hd;
END;
GO

-- WBH_US_CRT_HOA_DON_CHI_TIET
CREATE PROCEDURE WBH_US_CRT_HOA_DON_CHI_TIET
    @p_hoadon INT,
    @p_sanpham INT,
    @p_dongia DECIMAL(18),
    @p_soluong INT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO HD_CHI_TIET (hoadon, sanpham, dongia, soluong)
    VALUES (@p_hoadon, @p_sanpham, @p_dongia, @p_soluong);
    
    -- Cập nhật số lượng sản phẩm
    UPDATE SP_THONG_SO
    SET soluong = soluong - @p_soluong
    WHERE sanpham = @p_sanpham;
    
    SELECT SCOPE_IDENTITY() AS id_hdct;
END;
GO

-- WBH_US_CRT_THANH_TOAN
CREATE PROCEDURE WBH_US_CRT_THANH_TOAN
    @p_hoadon INT,
    @p_phuongthuc NVARCHAR(255),
    @p_sotien DECIMAL(18),
    @p_magiaodich NVARCHAR(255) = NULL,
    @p_taikhoan INT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO THANH_TOAN (hoadon, phuongthuc, sotien, ngaythanhtoan, magiaodich, taikhoan)
    VALUES (@p_hoadon, @p_phuongthuc, @p_sotien, GETDATE(), @p_magiaodich, @p_taikhoan);
    
    -- Cập nhật trạng thái hóa đơn
    UPDATE HOA_DON
    SET trangthai = N'Đã thanh toán'
    WHERE id_hd = @p_hoadon;
    
    SELECT SCOPE_IDENTITY() AS id_tt;
END;
GO

-- WBH_US_UPD_TRANG_THAI_THANH_TOAN
CREATE PROCEDURE WBH_US_UPD_TRANG_THAI_THANH_TOAN
    @p_magiaodich NVARCHAR(255),
    @p_trangthai NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @hoadon_id INT;
    
    -- Lấy ID hóa đơn từ mã giao dịch
    SELECT @hoadon_id = hoadon
    FROM THANH_TOAN
    WHERE magiaodich = @p_magiaodich;
    
    IF @hoadon_id IS NOT NULL
    BEGIN
        -- Cập nhật trạng thái hóa đơn
        UPDATE HOA_DON
        SET trangthai = @p_trangthai
        WHERE id_hd = @hoadon_id;
        
        SELECT 1 AS success, @hoadon_id AS id_hd;
    END
    ELSE
    BEGIN
        SELECT 0 AS success, NULL AS id_hd;
    END
END;
GO

-- WBH_US_SEL_LICH_SU_DON_HANG
CREATE PROCEDURE WBH_US_SEL_LICH_SU_DON_HANG
    @p_taikhoan INT,
    @p_pageNo INT = 1,
    @p_pageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        hd.id_hd,
        hd.ngaytao,
        hd.giahoadon,
        hd.trangthai,
        hd.noidung,
        tt.phuongthuc,
        tt.magiaodich,
        tt.ngaythanhtoan
    FROM HOA_DON hd
    LEFT JOIN THANH_TOAN tt ON hd.id_hd = tt.hoadon
    WHERE hd.taikhoan = @p_taikhoan
    ORDER BY hd.ngaytao DESC
    OFFSET (@p_pageNo - 1) * @p_pageSize ROWS
    FETCH NEXT @p_pageSize ROWS ONLY;
END;
GO

-- WBH_US_SEL_CHI_TIET_HOA_DON
CREATE PROCEDURE WBH_US_SEL_CHI_TIET_HOA_DON
    @p_id_hd INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Thông tin hóa đơn
    SELECT 
        hd.id_hd,
        hd.taikhoan,
        tk.hoveten,
        tk.sodienthoai,
        tk.email,
        hd.ngaytao,
        hd.giahoadon,
        hd.trangthai,
        hd.noidung
    FROM HOA_DON hd
    JOIN TAI_KHOAN tk ON hd.taikhoan = tk.id_tk
    WHERE hd.id_hd = @p_id_hd;
    
    -- Chi tiết sản phẩm
    SELECT 
        hdct.id_hdct,
        hdct.sanpham,
        sp.tensanpham,
        sp.anhgoc,
        hdct.dongia,
        hdct.soluong,
        (hdct.dongia * hdct.soluong) AS thanhtien
    FROM HD_CHI_TIET hdct
    JOIN SAN_PHAM sp ON hdct.sanpham = sp.id_sp
    WHERE hdct.hoadon = @p_id_hd;
    
    -- Thông tin thanh toán
    SELECT 
        tt.id_tt,
        tt.phuongthuc,
        tt.sotien,
        tt.ngaythanhtoan,
        tt.magiaodich
    FROM THANH_TOAN tt
    WHERE tt.hoadon = @p_id_hd;
END;
GO
-- WBH_AD_SEL_TAT_CA_HOA_DON
CREATE PROCEDURE WBH_AD_SEL_TAT_CA_HOA_DON
    @p_pageNo INT = 1,
    @p_pageSize INT = 10,
    @p_trangthai NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        hd.id_hd,
        hd.taikhoan,
        tk.hoveten,
        tk.sodienthoai,
        hd.ngaytao,
        hd.giahoadon,
        hd.trangthai,
        tt.phuongthuc,
        tt.magiaodich
    FROM HOA_DON hd
    JOIN TAI_KHOAN tk ON hd.taikhoan = tk.id_tk
    LEFT JOIN THANH_TOAN tt ON hd.id_hd = tt.hoadon
    WHERE (@p_trangthai IS NULL OR hd.trangthai = @p_trangthai)
    ORDER BY hd.ngaytao DESC
    OFFSET (@p_pageNo - 1) * @p_pageSize ROWS
    FETCH NEXT @p_pageSize ROWS ONLY;
END;
GO

-- Chi tiết hóa đơn cho admin
CREATE PROCEDURE WBH_AD_SEL_CHI_TIET_HOA_DON
    @p_id_hd INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Gọi lại procedure chi tiết hóa đơn user
    EXEC WBH_US_SEL_CHI_TIET_HOA_DON @p_id_hd;
END;
GO

-- Cập nhật trạng thái hóa đơn
CREATE PROCEDURE WBH_AD_UPD_TRANG_THAI_HOA_DON
    @p_id_hd INT,
    @p_trangthai NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE HOA_DON
    SET trangthai = @p_trangthai
    WHERE id_hd = @p_id_hd;
    
    SELECT @@ROWCOUNT AS affected_rows;
END;
GO

-- WBH_AD_SEL_TIM_KIEM_HOA_DON
CREATE PROCEDURE WBH_AD_SEL_TIM_KIEM_HOA_DON
    @p_keyword NVARCHAR(255) = NULL,
    @p_tu_ngay DATE = NULL,
    @p_den_ngay DATE = NULL,
    @p_pageNo INT = 1,
    @p_pageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        hd.id_hd,
        hd.taikhoan,
        tk.hoveten,
        tk.sodienthoai,
        hd.ngaytao,
        hd.giahoadon,
        hd.trangthai,
        tt.phuongthuc,
        tt.magiaodich
    FROM HOA_DON hd
    JOIN TAI_KHOAN tk ON hd.taikhoan = tk.id_tk
    LEFT JOIN THANH_TOAN tt ON hd.id_hd = tt.hoadon
    WHERE (@p_keyword IS NULL OR 
           tk.hoveten LIKE '%' + @p_keyword + '%' OR 
           tk.sodienthoai LIKE '%' + @p_keyword + '%' OR
           tt.magiaodich LIKE '%' + @p_keyword + '%')
      AND (@p_tu_ngay IS NULL OR hd.ngaytao >= @p_tu_ngay)
      AND (@p_den_ngay IS NULL OR hd.ngaytao <= @p_den_ngay)
    ORDER BY hd.ngaytao DESC
    OFFSET (@p_pageNo - 1) * @p_pageSize ROWS
    FETCH NEXT @p_pageSize ROWS ONLY;
END;
GO

-- WBH_AD_SEL_THONG_KE_HOA_DON
CREATE PROCEDURE WBH_AD_SEL_THONG_KE_HOA_DON
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        COUNT(*) AS tong_hoa_don,
        SUM(CASE WHEN trangthai = N'Đã thanh toán' THEN 1 ELSE 0 END) AS da_thanh_toan,
        SUM(CASE WHEN trangthai = N'Chờ thanh toán' THEN 1 ELSE 0 END) AS cho_thanh_toan,
        SUM(CASE WHEN trangthai = N'Đã hủy' THEN 1 ELSE 0 END) AS da_huy,
        SUM(CASE WHEN trangthai = N'Đã thanh toán' THEN giahoadon ELSE 0 END) AS tong_doanh_thu
    FROM HOA_DON;
    
    -- Thống kê theo tháng
    SELECT 
        YEAR(ngaytao) AS nam,
        MONTH(ngaytao) AS thang,
        COUNT(*) AS so_hoa_don,
        SUM(CASE WHEN trangthai = N'Đã thanh toán' THEN giahoadon ELSE 0 END) AS doanh_thu
    FROM HOA_DON
    WHERE ngaytao >= DATEADD(MONTH, -12, GETDATE())
    GROUP BY YEAR(ngaytao), MONTH(ngaytao)
    ORDER BY nam DESC, thang DESC;
END;
GO

-- WBH_AD_SEL_BAO_CAO_DOANH_THU
CREATE PROCEDURE WBH_AD_SEL_BAO_CAO_DOANH_THU
    @p_tu_ngay DATE,
    @p_den_ngay DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        CONVERT(DATE, hd.ngaytao) AS ngay,
        COUNT(*) AS so_don_hang,
        SUM(hd.giahoadon) AS tong_doanh_thu,
        AVG(hd.giahoadon) AS don_hang_trung_binh
    FROM HOA_DON hd
    WHERE hd.trangthai = N'Đã thanh toán'
      AND hd.ngaytao >= @p_tu_ngay
      AND hd.ngaytao <= @p_den_ngay
    GROUP BY CONVERT(DATE, hd.ngaytao)
    ORDER BY ngay DESC;
END;
GO
-- WBH_US_CRT_DANH_GIA
CREATE PROCEDURE WBH_US_CRT_DANH_GIA
    @p_taikhoan INT,
    @p_sanpham INT,
    @p_noidung NVARCHAR(255),
    @p_diemso INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra đã đánh giá chưa
    IF EXISTS (SELECT 1 FROM DANH_GIA WHERE taikhoan = @p_taikhoan AND sanpham = @p_sanpham)
    BEGIN
        -- Cập nhật đánh giá cũ
        UPDATE DANH_GIA
        SET noidung = @p_noidung,
            diemso = @p_diemso,
            ngaytao = GETDATE()
        WHERE taikhoan = @p_taikhoan AND sanpham = @p_sanpham;
        
        SELECT 1 AS success, 'updated' AS action;
    END
    ELSE
    BEGIN
        -- Tạo đánh giá mới
        INSERT INTO DANH_GIA (taikhoan, sanpham, noidung, diemso)
        VALUES (@p_taikhoan, @p_sanpham, @p_noidung, @p_diemso);
        
        SELECT 1 AS success, 'created' AS action;
    END
END;
GO

-- WBH_US_SEL_DANH_GIA_THEO_SP
CREATE PROCEDURE WBH_US_SEL_DANH_GIA_THEO_SP
    @p_sanpham INT,
    @p_pageNo INT = 1,
    @p_pageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        dg.id_dg,
        dg.taikhoan,
        tk.hoveten,
        dg.noidung,
        dg.diemso,
        dg.ngaytao
    FROM DANH_GIA dg
    JOIN TAI_KHOAN tk ON dg.taikhoan = tk.id_tk
    WHERE dg.sanpham = @p_sanpham
    ORDER BY dg.ngaytao DESC
    OFFSET (@p_pageNo - 1) * @p_pageSize ROWS
    FETCH NEXT @p_pageSize ROWS ONLY;
END;
GO

-- Xóa đánh giá
CREATE PROCEDURE WBH_US_DEL_DANH_GIA
    @p_id_dg INT,
    @p_taikhoan INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DELETE FROM DANH_GIA
    WHERE id_dg = @p_id_dg AND taikhoan = @p_taikhoan;
    
    SELECT @@ROWCOUNT AS affected_rows;
END;
GO

-- WBH_US_SEL_THONG_KE_DANH_GIA
CREATE PROCEDURE WBH_US_SEL_THONG_KE_DANH_GIA
    @p_sanpham INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        COUNT(*) AS tong_danh_gia,
        AVG(CAST(diemso AS FLOAT)) AS diem_trung_binh,
        SUM(CASE WHEN diemso = 5 THEN 1 ELSE 0 END) AS sao_5,
        SUM(CASE WHEN diemso = 4 THEN 1 ELSE 0 END) AS sao_4,
        SUM(CASE WHEN diemso = 3 THEN 1 ELSE 0 END) AS sao_3,
        SUM(CASE WHEN diemso = 2 THEN 1 ELSE 0 END) AS sao_2,
        SUM(CASE WHEN diemso = 1 THEN 1 ELSE 0 END) AS sao_1
    FROM DANH_GIA
    WHERE sanpham = @p_sanpham;
END;
GO
-- WBH_US_CRT_MOMO_PAYMENT
CREATE PROCEDURE WBH_US_CRT_MOMO_PAYMENT
    @p_orderId NVARCHAR(255),
    @p_amount DECIMAL(18),
    @p_orderInfo NVARCHAR(255),
    @p_taikhoan INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @payUrl NVARCHAR(500);
    DECLARE @qrCodeUrl NVARCHAR(500);
    
    -- Tạo URL thanh toán giả lập (trong thực tế sẽ gọi MoMo API)
    SET @payUrl = 'https://test-payment.momo.vn/v2/gateway/pay?orderId=' + @p_orderId + '&amount=' + CAST(@p_amount AS NVARCHAR);
    SET @qrCodeUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=' + @payUrl;
    
    -- Lưu thông tin thanh toán tạm
    INSERT INTO THANH_TOAN (hoadon, phuongthuc, sotien, magiaodich, taikhoan)
    VALUES (0, 'MOMO', @p_amount, @p_orderId, @p_taikhoan);
    
    SELECT 
        @payUrl AS payUrl,
        @qrCodeUrl AS qrCodeUrl,
        @p_orderId AS orderId,
        @p_amount AS amount,
        'success' AS status;
END;
GO

-- WBH_US_UPD_MOMO_CALLBACK
CREATE PROCEDURE WBH_US_UPD_MOMO_CALLBACK
    @p_orderId NVARCHAR(255),
    @p_resultCode INT,
    @p_message NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @trangthai NVARCHAR(255);
    
    -- Xác định trạng thái dựa trên resultCode
    IF @p_resultCode = 0
        SET @trangthai = N'Đã thanh toán';
    ELSE
        SET @trangthai = N'Thanh toán thất bại';
    
    -- Cập nhật trạng thái thanh toán
    UPDATE THANH_TOAN
    SET ngaythanhtoan = GETDATE()
    WHERE magiaodich = @p_orderId;
    
    -- Tạo hóa đơn nếu thanh toán thành công
    IF @p_resultCode = 0
    BEGIN
        DECLARE @taikhoan INT, @sotien DECIMAL(18);
        
        SELECT @taikhoan = taikhoan, @sotien = sotien
        FROM THANH_TOAN
        WHERE magiaodich = @p_orderId;
        
        IF @taikhoan IS NOT NULL
        BEGIN
            INSERT INTO HOA_DON (taikhoan, giahoadon, trangthai, noidung)
            VALUES (@taikhoan, @sotien, @trangthai, N'Thanh toán MoMo - ' + @p_orderId);
            
            DECLARE @hoadon_id INT = SCOPE_IDENTITY();
            
            -- Cập nhật hoadon trong THANH_TOAN
            UPDATE THANH_TOAN
            SET hoadon = @hoadon_id
            WHERE magiaodich = @p_orderId;
        END
    END
    
    SELECT 
        @p_resultCode AS resultCode,
        @trangthai AS trangthai,
        'processed' AS status;
END;
GO

-- WBH_US_SEL_MOMO_STATUS
CREATE PROCEDURE WBH_US_SEL_MOMO_STATUS
    @p_orderId NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        tt.magiaodich AS orderId,
        tt.sotien AS amount,
        tt.ngaythanhtoan,
        hd.trangthai,
        CASE 
            WHEN hd.trangthai = N'Đã thanh toán' THEN 'success'
            WHEN hd.trangthai = N'Thanh toán thất bại' THEN 'failed'
            ELSE 'pending'
        END AS status
    FROM THANH_TOAN tt
    LEFT JOIN HOA_DON hd ON tt.hoadon = hd.id_hd
    WHERE tt.magiaodich = @p_orderId;
END;
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
FROM sys.procedures
ORDER BY name;
GO

/*===== INSERT DATA =====*/
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