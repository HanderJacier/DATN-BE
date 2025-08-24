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
    tendangnhap NVARCHAR(255) UNIQUE,
    matkhau NVARCHAR(255),
    vaitro BIT DEFAULT 0,
    hoveten NVARCHAR(255),
    sodienthoai VARCHAR(15) NULL,   -- ⚡ bỏ UNIQUE ở đây
    email NVARCHAR(255) UNIQUE,
    trangthai BIT DEFAULT 0, -- 1 = ACTIVE / 0 = INACTIVE
    ngaytao NVARCHAR(255) DEFAULT FORMAT(GETDATE(), 'dd/MM/yyyy'),
    ngaycapnhat DATE
);
GO
CREATE UNIQUE INDEX UX_TAI_KHOAN_SDT_NOTNULL
ON dbo.TAI_KHOAN(sodienthoai)
WHERE sodienthoai IS NOT NULL;
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
	tensanpham NVARCHAR(255),
	dongia DECIMAL(18) DEFAULT 0 CHECK (dongia >= 0),
	loai INT,
	thuonghieu INT,
	anhgoc NVARCHAR(255),
	ngaytao NVARCHAR(255) DEFAULT FORMAT(GETDATE(), 'dd/MM/yyyy'),
    -- Giảm giá
	loaigiam INT,
	giamgia DECIMAL(18) DEFAULT 0 CHECK (giamgia >= 0),
	hangiamgia NVARCHAR(255)
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
	sanpham INT,
    model NVARCHAR(255),
    trongluong NVARCHAR(255),
    pin NVARCHAR(255),
    congketnoi NVARCHAR(255),
    tinhnang NVARCHAR(255),
	mausac NVARCHAR(255),
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
	ngaytao NVARCHAR(255) DEFAULT FORMAT(GETDATE(), 'dd/MM/yyyy'),
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
	ngaythanhtoan NVARCHAR(255) DEFAULT FORMAT(GETDATE(), 'dd/MM/yyyy'),
	magiaodich NVARCHAR(255) ,
	taikhoan INT ,
	ngaytao NVARCHAR(255) DEFAULT FORMAT(GETDATE(), 'dd/MM/yyyy')
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
	ngaytao NVARCHAR(255) DEFAULT FORMAT(GETDATE(), 'dd/MM/yyyy'),
    ngaycapnhat NVARCHAR(255)
);
GO
-- DANH_GIA
CREATE TABLE DANH_GIA(
	id_dg INT IDENTITY(1,1)  PRIMARY KEY,
	taikhoan INT ,
	sanpham INT ,
	noidung NVARCHAR(255) ,
	diemso INT DEFAULT 0 CHECK (diemso>=0 AND diemso<=5) ,
	ngaytao NVARCHAR(255) DEFAULT FORMAT(GETDATE(), 'dd/MM/yyyy')
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
    TS.model,
    TS.trongluong,
    TS.pin,
    TS.congketnoi,
    TS.tinhnang,
    TS.mausac,
    TS.soluong,

    -- Gom tất cả ảnh phụ thành một chuỗi phân tách bởi dấu phẩy
    A.ds_anh_phu
FROM 
    SAN_PHAM SP
    JOIN SP_LOAI L ON SP.loai = L.id_l
    JOIN SP_THUONG_HIEU TH ON SP.thuonghieu = TH.id_th
    JOIN GIAM_GIA GG ON SP.loaigiam = GG.id_gg
    JOIN SP_THONG_SO TS ON SP.id_sp = TS.sanpham
    JOIN (
        SELECT sanpham, STRING_AGG(diachianh, ',') AS ds_anh_phu
        FROM ANH_SP
        GROUP BY sanpham
    ) A ON SP.id_sp = A.sanpham
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
    SET ngaycapnhat = FORMAT(GETDATE(), 'dd/MM/yyyy')
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
/*-- SAN_PHAM --*/
-- WBH_AD_CRT_THEMSP
CREATE PROCEDURE WBH_AD_CRT_THEMSP
    @p_tensanpham NVARCHAR(255),
    @p_dongia DECIMAL(18),
    @p_loai INT,
    @p_thuonghieu INT,
    @p_anhgoc NVARCHAR(255),
    @p_model NVARCHAR(255),
    @p_trongluong NVARCHAR(255),
    @p_pin NVARCHAR(255),
    @p_congketnoi NVARCHAR(255),
    @p_tinhnang NVARCHAR(255),
    @p_mausac NVARCHAR(255),
    @p_soluong INT,
    @p_anhphu NVARCHAR(255),
    @p_id_gg INT,
    @p_hangiamgia NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO SAN_PHAM (tensanpham, dongia, loai, thuonghieu, anhgoc, loaigiam, hangiamgia)
        VALUES (@p_tensanpham, @p_dongia, @p_loai, @p_thuonghieu, @p_anhgoc, @p_id_gg, @p_hangiamgia);
        DECLARE @NewProductID INT = SCOPE_IDENTITY();
        INSERT INTO SP_THONG_SO (
            sanpham, model, trongluong, pin, congketnoi, tinhnang, mausac, soluong
        )
        VALUES (
            @NewProductID, @p_model, @p_trongluong, @p_pin, @p_congketnoi, @p_tinhnang,@p_mausac, @p_soluong
        );
        INSERT INTO ANH_SP (sanpham, diachianh)
        VALUES (@NewProductID, @p_anhphu);
        SELECT 
            'SUCCESS' AS status
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO
-- WBH_US_SEL_DETAIL_SP
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
-- WBH_US_SEL_XEMSP
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
-- WBH_US_SEL_NGAYTAOSP
CREATE PROCEDURE WBH_US_SEL_NGAYTAOSP
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * 
    FROM vw_SanPham_ChiTiet
    ORDER BY TRY_CONVERT(date, ngaytao, 103) DESC;
END;
GO
-- WBH_US_SEL_RANKYTSP
CREATE PROCEDURE WBH_US_SEL_RANKYTSP
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        SP.id_sp,
        SP.tensanpham,
        SP.dongia,
        SP.loai,
        SP.loaiTen,
        SP.thuonghieu,
        SP.thuonghieuTen,
        SP.anhgoc,
        SP.hangiamgia,
        SP.ngaytao,
        SP.loaigiam,
        SP.loaigiamTen,
        SP.giamgia,
        SP.soluong,
        ISNULL(YT.SoYeuThich, 0) AS SoYeuThich
    FROM 
    (
        SELECT 
            id_sp,
            tensanpham,
            dongia,
            loai,
            loaiTen,
            thuonghieu,
            thuonghieuTen,
            anhgoc,
            hangiamgia,
            ngaytao,
            loaigiam,
            loaigiamTen,
            giamgia,
            soluong
        FROM vw_SanPham_ChiTiet
        GROUP BY 
            id_sp,
            tensanpham,
            dongia,
            loai,
            loaiTen,
            thuonghieu,
            thuonghieuTen,
            anhgoc,
            hangiamgia,
            ngaytao,
            loaigiam,
            loaigiamTen,
            giamgia,
            soluong
    ) SP
    LEFT JOIN (
        SELECT sanpham, COUNT(*) AS SoYeuThich
        FROM YEU_THICH
        GROUP BY sanpham
    ) YT ON SP.id_sp = YT.sanpham
    ORDER BY YT.SoYeuThich DESC;
END;
GO
-- WBH_US_SEL_SALESP
CREATE PROCEDURE WBH_US_SEL_SALESP
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM vw_SanPham_ChiTiet
    WHERE TRY_CONVERT(date, hangiamgia, 103) >= CAST(GETDATE() AS date)
          AND TRY_CONVERT(date, hangiamgia, 103) IS NOT NULL;
END;
GO
-- WBH_AD_UPD_SUASP
CREATE PROCEDURE WBH_AD_UPD_SUASP
    @p_id_sp INT,
    @p_tensanpham NVARCHAR(255),
    @p_dongia DECIMAL(18),
    @p_loai INT,
    @p_thuonghieu INT,
    @p_anhgoc NVARCHAR(255),
    @p_model NVARCHAR(255),
    @p_trongluong NVARCHAR(255),
    @p_pin NVARCHAR(255),
    @p_congketnoi NVARCHAR(255),
    @p_tinhnang NVARCHAR(255),
    @p_mausac NVARCHAR(255),
    @p_soluong INT,
    @p_anhphu NVARCHAR(255),
    @p_id_gg INT,
    @p_hangiamgia NVARCHAR(255)
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
        SET model = @p_model,
            trongluong = @p_trongluong,
            pin = @p_pin,
            congketnoi = @p_congketnoi,
            tinhnang = @p_tinhnang,
            mausac = @p_mausac,
            soluong = @p_soluong
        WHERE sanpham = @p_id_sp;

        -- Cập nhật bảng ANH_SP
        UPDATE ANH_SP
        SET diachianh = @p_anhphu
        WHERE sanpham = @p_id_sp;
        COMMIT TRAN;
        SELECT 
            'SUCCESS' AS status
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;

        SELECT 
            'FAIL' AS status,
            ERROR_NUMBER() AS error_number,
            ERROR_MESSAGE() AS error_message,
            ERROR_LINE() AS error_line;
    END CATCH
END;
GO
-- WBH_US_SEL_SANPHAM_BY_SANPHAM_DETAIL
CREATE OR ALTER PROCEDURE WBH_US_SEL_SANPHAM_BY_SANPHAM_DETAIL
    @p_id_sp INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @v_thuonghieu INT,
            @v_loai       INT;

    -- Lấy loại & thương hiệu của sản phẩm nguồn
    SELECT 
        @v_thuonghieu = thuonghieu,
        @v_loai       = loai
    FROM SAN_PHAM
    WHERE id_sp = @p_id_sp;

    -- Nếu không tìm thấy id_sp nguồn => trả ngẫu nhiên 4 sp khác nhau
    IF @v_loai IS NULL
    BEGIN
        SELECT TOP (4) *
        FROM vw_SanPham_ChiTiet
        WHERE id_sp <> @p_id_sp
        ORDER BY NEWID();
        RETURN;
    END

    -- Tập kết quả tạm
    DECLARE @res TABLE (
        id_sp INT PRIMARY KEY
    );

    -- 1) Cùng loại + cùng thương hiệu (ưu tiên)
    INSERT INTO @res (id_sp)
    SELECT TOP (4) v.id_sp
    FROM vw_SanPham_ChiTiet v
    WHERE v.id_sp <> @p_id_sp
      AND v.loai = @v_loai
      AND v.thuonghieu = @v_thuonghieu
    ORDER BY NEWID();  -- random trong nhóm ưu tiên

    -- 2) Nếu chưa đủ 4: cùng loại (bỏ ràng buộc thương hiệu)
    DECLARE @need INT = 4 - (SELECT COUNT(*) FROM @res);
    IF @need > 0
    BEGIN
        INSERT INTO @res (id_sp)
        SELECT TOP (@need) v.id_sp
        FROM vw_SanPham_ChiTiet v
        WHERE v.id_sp <> @p_id_sp
          AND v.loai = @v_loai
          AND v.id_sp NOT IN (SELECT id_sp FROM @res)
        ORDER BY NEWID();
    END

    -- 3) Nếu vẫn thiếu: lấy ngẫu nhiên bất kỳ (trừ bản thân & trừ đã chọn)
    SET @need = 4 - (SELECT COUNT(*) FROM @res);
    IF @need > 0
    BEGIN
        INSERT INTO @res (id_sp)
        SELECT TOP (@need) v.id_sp
        FROM vw_SanPham_ChiTiet v
        WHERE v.id_sp <> @p_id_sp
          AND v.id_sp NOT IN (SELECT id_sp FROM @res)
        ORDER BY NEWID();
    END

    -- Trả chi tiết cho các id đã chọn
    SELECT v.*
    FROM vw_SanPham_ChiTiet v
    JOIN @res r ON r.id_sp = v.id_sp;
END;
GO

-- WBH_US_SEL_SP_YT
CREATE PROCEDURE WBH_US_SEL_SP_YT
    @p_id_tk INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * 
    FROM YEU_THICH YT
         JOIN SAN_PHAM SP ON SP.id_sp = YT.sanpham
         JOIN SP_THONG_SO TS ON TS.sanpham = SP.id_sp
    WHERE YT.taikhoan = @p_id_tk
        and YT.trangthai = 'Y'
END;
GO
--END SAN_PHAM

/*-- GIAM_GIA --*/
-- WBH_AD_SEL_getGIAMGIA
CREATE PROCEDURE WBH_AD_SEL_getGIAMGIA
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * 
    FROM GIAM_GIA
END;
GO
--END GIAM_GIA

/*-- GOP_Y --*/
-- WBH_US_CRT_GY
CREATE PROCEDURE WBH_US_CRT_GY
    @p_id_tk INT,
    @p_noidung NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO GOP_Y(taikhoan, noidung)
    VALUES (@p_id_tk, @p_noidung);

    SELECT 1
END;
GO
-- WBH_AD_SEL_GY_PHAN_TRANG
CREATE PROCEDURE WBH_AD_SEL_GY_PHAN_TRANG
    @p_pageNo INT,
    @p_pageSize INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        g.id_gy,
        g.taikhoan,
        tk.hoveten, -- hoặc tk.hovaten nếu bạn muốn lấy họ tên
        g.noidung,
        g.ngaytao
    FROM GOP_Y g
    LEFT JOIN TAI_KHOAN tk ON g.taikhoan = tk.id_tk
    ORDER BY g.ngaytao DESC
    OFFSET (@p_pageNo - 1) * @p_pageSize ROWS
    FETCH NEXT @p_pageSize ROWS ONLY;
END;
GO

--END GOP_Y

/*-- YEU_THICH --*/
-- WBH_US_UPD_CAPNHAT_YT_SP
CREATE PROCEDURE WBH_US_UPD_CAPNHAT_YT_SP
    @p_sanpham INT,
    @p_taikhoan INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM YEU_THICH 
        WHERE sanpham = @p_sanpham AND taikhoan = @p_taikhoan
    )
    BEGIN
        UPDATE YEU_THICH
        SET trangthai = CASE WHEN trangthai = 'Y' THEN 'N' ELSE 'Y' END
        WHERE sanpham = @p_sanpham AND taikhoan = @p_taikhoan;
        SELECT 1;
    END
    ELSE
    BEGIN
        -- Nếu chưa có, thêm mới với trạng thái 1 (yêu thích)
        INSERT INTO YEU_THICH(sanpham, taikhoan, trangthai)
        VALUES (@p_sanpham, @p_taikhoan, 'Y');
        SELECT 2;
    END
END;
GO
--END TAI_KHOAN

/*-- TAI_KHOAN --*/
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
-- Updated stored procedures to work with existing TAI_KHOAN schema without adding new columns

-- WBH_US_SEL_GOOGLE_LOGIN
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'WBH_US_SEL_GOOGLE_LOGIN')
BEGIN
    DROP PROCEDURE WBH_US_SEL_GOOGLE_LOGIN;
END
GO

CREATE PROCEDURE WBH_US_SEL_GOOGLE_LOGIN
    @p_email NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra xem user đã tồn tại chưa theo email
    SELECT 
        id_tk,
        tendangnhap,
        CAST(vaitro AS BIT) as vaitro,
        hoveten,
        sodienthoai,
        email,
        CAST(trangthai AS BIT) as trangthai,
        ngaytao,
        ngaycapnhat
    FROM TAI_KHOAN 
    WHERE email = @p_email 
       AND trangthai = 1;
END
GO

--WBH_US_INS_GOOGLE_USER
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'WBH_US_INS_GOOGLE_USER')
BEGIN
    DROP PROCEDURE WBH_US_INS_GOOGLE_USER;
END
GO

CREATE PROCEDURE WBH_US_INS_GOOGLE_USER
    @p_email NVARCHAR(255),
    @p_hoveten NVARCHAR(255),
    @p_vaitro BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @new_id INT;
    
    -- Kiểm tra xem email đã tồn tại chưa
    IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE email = @p_email)
    BEGIN
        -- Nếu đã tồn tại, trả về thông tin user hiện tại
        SELECT 
            id_tk,
            tendangnhap,
            CAST(vaitro AS BIT) as vaitro,
            hoveten,
            sodienthoai,
            email,
            CAST(trangthai AS BIT) as trangthai,
            ngaytao,
            ngaycapnhat
        FROM TAI_KHOAN 
        WHERE email = @p_email;
        RETURN;
    END
    
    -- Tạo tài khoản mới
    INSERT INTO TAI_KHOAN (
        tendangnhap,
        matkhau,
        vaitro,
        hoveten,
        email,
        trangthai,
        ngaytao,
        ngaycapnhat
    )
    VALUES (
        @p_email, -- Sử dụng email làm username
        NULL, -- Không cần mật khẩu cho Google login
        @p_vaitro,
        @p_hoveten,
        @p_email,
        1, -- Kích hoạt ngay
        GETDATE(),
        GETDATE()
    );
    
    SET @new_id = SCOPE_IDENTITY();
    
    -- Trả về thông tin user vừa tạo
    SELECT 
        id_tk,
        tendangnhap,
        CAST(vaitro AS BIT) as vaitro,
        hoveten,
        sodienthoai,
        email,
        CAST(trangthai AS BIT) as trangthai,
        ngaytao,
        ngaycapnhat
    FROM TAI_KHOAN 
    WHERE id_tk = @new_id;
END
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
-- WBH_US_SEL_HD_CHI_TIET_THEO_DANH_SACH
CREATE OR ALTER PROCEDURE WBH_US_SEL_HD_CHI_TIET_THEO_DANH_SACH
    @p_ids NVARCHAR(MAX)   -- CSV: "1,2,3"
AS
BEGIN
    SET NOCOUNT ON;

    -- Nếu rỗng -> trả mảng rỗng (schema đúng cột)
    IF @p_ids IS NULL OR LTRIM(RTRIM(@p_ids)) = ''
    BEGIN
        SELECT TOP (0)
            CAST(NULL AS INT)      AS id_hd,
            CAST(NULL AS INT)      AS id_hdct,
            CAST(NULL AS INT)      AS id_sp,
            CAST(NULL AS NVARCHAR(255)) AS tensanpham,
            CAST(NULL AS NVARCHAR(255)) AS anhgoc,
            CAST(NULL AS DECIMAL(18,2)) AS dongia,
            CAST(NULL AS INT)      AS soluong,
            CAST(NULL AS DECIMAL(18,2)) AS thanhtien;
        RETURN;
    END

    -- Chuẩn hoá danh sách id hoá đơn
    DECLARE @ids TABLE (id_hd INT PRIMARY KEY);
    INSERT INTO @ids(id_hd)
    SELECT DISTINCT TRY_CONVERT(INT, LTRIM(RTRIM(value)))
    FROM STRING_SPLIT(@p_ids, ',')
    WHERE TRY_CONVERT(INT, LTRIM(RTRIM(value))) IS NOT NULL;

    -- Trả danh sách chi tiết theo các id_hd
    SELECT
        hdct.hoadon                                AS id_hd,
        hdct.id_hdct                               AS id_hdct,
        sp.id_sp                                   AS id_sp,
        sp.tensanpham                              AS tensanpham,
        sp.anhgoc                                  AS anhgoc,
        CAST(hdct.dongia AS DECIMAL(18,2))         AS dongia,
        hdct.soluong                               AS soluong,
        CAST(hdct.dongia * hdct.soluong AS DECIMAL(18,2)) AS thanhtien
    FROM HD_CHI_TIET hdct
    JOIN @ids i       ON i.id_hd = hdct.hoadon
    JOIN SAN_PHAM sp  ON sp.id_sp = hdct.sanpham
    ORDER BY hdct.hoadon, hdct.id_hdct;
END
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
-- WBH_US_UPD_DIACHI
CREATE PROCEDURE WBH_US_UPD_DIACHI
    @p_action INT,
    @p_id_dc INT,
    @p_taikhoan INT,
    @p_diachi NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    IF @p_action = 1   -- Thêm mới
    BEGIN
        INSERT INTO DIA_CHI (taikhoan, diachi)
        VALUES (@p_taikhoan, @p_diachi);
        SELECT 1;
    END
    ELSE IF @p_action = 2  -- Xóa
    BEGIN
        DELETE FROM DIA_CHI
        WHERE id_dc = @p_id_dc
          AND taikhoan = @p_taikhoan;
        SELECT 2;
    END
    ELSE IF @p_action = 3  -- Cập nhật
    BEGIN
        UPDATE DIA_CHI
        SET diachi = @p_diachi
        WHERE id_dc = @p_id_dc
          AND taikhoan = @p_taikhoan;
        SELECT 3;
    END
    ELSE
    BEGIN
        SELECT 'ERROR';
    END
END;
GO
--END TAI_KHOAN

/*-- HOA_DON --*/
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
-- WBH_US_SEL_HOA_DON_THEO_TAI_KHOAN
CREATE PROCEDURE WBH_US_SEL_HOA_DON_THEO_TAI_KHOAN
     @p_id_tk    INT,
  @p_pageNo   INT = 1,
  @p_pageSize INT = 10
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH base AS (
    SELECT 
      hd.id_hd, hd.taikhoan, hd.ngaytao, hd.giahoadon, hd.trangthai, hd.noidung,
      tt.phuongthuc, tt.magiaodich, tt.ngaythanhtoan
    FROM HOA_DON hd
    LEFT JOIN THANH_TOAN tt ON tt.hoadon = hd.id_hd
    WHERE hd.taikhoan = @p_id_tk
  ),
  paged AS (
    SELECT 
      b.*,
      ROW_NUMBER() OVER (ORDER BY TRY_CONVERT(date, b.ngaytao, 103) DESC, b.id_hd DESC) AS rn
    FROM base b
  )
  SELECT 
    p.id_hd, p.ngaytao, p.giahoadon, p.trangthai, p.noidung,
    p.phuongthuc, p.magiaodich, p.ngaythanhtoan,
    ISNULL((
      SELECT 
        hdct.id_hdct,
        hdct.sanpham        AS id_sp,
        sp.tensanpham,
        sp.anhgoc,
        hdct.dongia,
        hdct.soluong,
        (hdct.dongia * hdct.soluong) AS thanhtien
      FROM HD_CHI_TIET hdct
      JOIN SAN_PHAM sp ON sp.id_sp = hdct.sanpham
      WHERE hdct.hoadon = p.id_hd
      FOR JSON PATH
    ), '[]') AS items
  INTO #paged_invoices
  FROM paged p
  WHERE p.rn BETWEEN ((@p_pageNo - 1) * @p_pageSize + 1) AND (@p_pageNo * @p_pageSize);

  -- RS#1
  SELECT * 
  FROM #paged_invoices
  ORDER BY TRY_CONVERT(date, ngaytao, 103) DESC, id_hd DESC;

  -- RS#2
  SELECT 
    pi.id_hd,
    hdct.id_hdct,
    hdct.sanpham AS id_sp,
    sp.tensanpham,
    sp.anhgoc,
    hdct.dongia,
    hdct.soluong,
    (hdct.dongia * hdct.soluong) AS thanhtien
  FROM #paged_invoices pi
  JOIN HD_CHI_TIET hdct ON hdct.hoadon = pi.id_hd
  JOIN SAN_PHAM sp ON sp.id_sp = hdct.sanpham
  ORDER BY pi.id_hd, hdct.id_hdct;

  -- RS#3
  SELECT COUNT(*) AS total FROM base;

  DROP TABLE #paged_invoices;
END
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
-- WBH_AD_SEL_CHI_TIET_HOA_DON
CREATE PROCEDURE WBH_AD_SEL_CHI_TIET_HOA_DON
    @p_id_hd INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Gọi lại procedure chi tiết hóa đơn user
    EXEC WBH_US_SEL_CHI_TIET_HOA_DON @p_id_hd;
END;
GO
-- WBH_AD_UPD_TRANG_THAI_HOA_DON
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
    @p_tu_ngay NVARCHAR(255) = NULL,
    @p_den_ngay NVARCHAR(255) = NULL,
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
-- WBH_US_CRT_DAT_HANG
CREATE OR ALTER PROCEDURE WBH_US_CRT_DAT_HANG
    @p_hoveten NVARCHAR(255),
    @p_sodienthoai VARCHAR(15),
    @p_email NVARCHAR(255) = NULL,
    @p_diachi NVARCHAR(255),
    @p_noidung NVARCHAR(255) = NULL,
    @p_trangthai NVARCHAR(255) = N'Chờ xác nhận',
    @p_sanphams NVARCHAR(MAX)  -- JSON string chứa danh sách sản phẩm: [{"sanpham": int, "dongia": decimal, "soluong": int}, ...]
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @rtn_value INT = 0;
    DECLARE @id_tk INT;
    DECLARE @id_hd INT;
    DECLARE @giahoadon DECIMAL(18,2) = 0;
    
    BEGIN TRY
        BEGIN TRAN;
        
        -- 1. Kiểm tra tài khoản user đã đăng nhập và hợp lệ
        SELECT @id_tk = id_tk 
        FROM TAI_KHOAN 
        WHERE sodienthoai = @p_sodienthoai 
          AND email = @p_email 
          AND trangthai = 1; -- Chỉ cho phép tài khoản active
        
        IF @id_tk IS NULL
        BEGIN
            SET @rtn_value = -1;
            SELECT @rtn_value AS rtn_value, N'Tài khoản không tồn tại hoặc chưa được kích hoạt' AS message;
            RETURN;
        END
        
        -- 2. Kiểm tra vai trò (chỉ user, không phải admin)
        IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE id_tk = @id_tk AND vaitro = 1)
        BEGIN
            SET @rtn_value = -2;
            SELECT @rtn_value AS rtn_value, N'Tài khoản quản trị không được phép đặt hàng' AS message;
            RETURN;
        END
        
        -- 3. Tính tổng giá hóa đơn từ danh sách sản phẩm
        SELECT @giahoadon = SUM(CAST(JSON_VALUE(value, '$.dongia') AS DECIMAL(18,2)) * CAST(JSON_VALUE(value, '$.soluong') AS INT))
        FROM OPENJSON(@p_sanphams);
        
        -- 4. Tạo hóa đơn
        INSERT INTO HOA_DON (taikhoan, giahoadon, trangthai, noidung)
        VALUES (@id_tk, @giahoadon, @p_trangthai, @p_noidung);
        
        SET @id_hd = SCOPE_IDENTITY();
        
        -- 5. Tạo chi tiết hóa đơn từ JSON
        INSERT INTO HD_CHI_TIET (hoadon, sanpham, dongia, soluong)
        SELECT 
            @id_hd,
            CAST(JSON_VALUE(value, '$.sanpham') AS INT),
            CAST(JSON_VALUE(value, '$.dongia') AS DECIMAL(18,2)),
            CAST(JSON_VALUE(value, '$.soluong') AS INT)
        FROM OPENJSON(@p_sanphams);
        
        -- 6. Cập nhật số lượng sản phẩm (giảm tồn kho)
        UPDATE TS
        SET TS.soluong = TS.soluong - CAST(JSON_VALUE(SP.value, '$.soluong') AS INT)
        FROM SP_THONG_SO TS
        INNER JOIN OPENJSON(@p_sanphams) SP ON TS.sanpham = CAST(JSON_VALUE(SP.value, '$.sanpham') AS INT);
        
        -- 7. Tạo địa chỉ nếu cần
        IF NOT EXISTS (SELECT 1 FROM DIA_CHI WHERE taikhoan = @id_tk AND diachi = @p_diachi)
        BEGIN
            INSERT INTO DIA_CHI (taikhoan, diachi)
            VALUES (@id_tk, @p_diachi);
        END
        
        COMMIT TRAN;
        
        -- Trả về kết quả
        SELECT 
            0 AS rtn_value,
            @id_hd AS id_hd,
            @giahoadon AS giahoadon,
            @p_trangthai AS trangthai
        UNION ALL
        SELECT 1, NULL, NULL, NULL;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        
        SET @rtn_value = ERROR_NUMBER();
        SELECT @rtn_value AS rtn_value, ERROR_MESSAGE() AS message;
    END CATCH
END;
GO
-- WBH_US_CRT_DAT_HANG_VA_HOA_DON
CREATE PROCEDURE WBH_US_CRT_DAT_HANG_VA_HOA_DON
    @p_hoveten NVARCHAR(255),
    @p_sodienthoai NVARCHAR(20),
    @p_email NVARCHAR(255) = NULL,
    @p_diachi NVARCHAR(500),
    @p_noidung NVARCHAR(1000),
    @p_trangthai NVARCHAR(50),
    @p_phuongthuc_thanhtoan NVARCHAR(50),
    @p_sotien_thanhtoan DECIMAL(18,2),
    @p_sanphams NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @id_hd INT, @id_hoa_don INT;
    DECLARE @rtn_value INT = 0;
    DECLARE @message NVARCHAR(500) = '';
    DECLARE @id_tk INT;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Tìm tài khoản dựa trên số điện thoại và email
        SELECT @id_tk = id_tk 
        FROM TAI_KHOAN 
        WHERE sodienthoai = @p_sodienthoai 
          AND (@p_email IS NULL OR email = @p_email)
          AND trangthai = 1; -- Chỉ tài khoản active
        
        -- Nếu không tìm thấy tài khoản, tạo tài khoản mới (guest)
        IF @id_tk IS NULL
        BEGIN
            INSERT INTO TAI_KHOAN (
                tendangnhap, matkhau, vaitro, hoveten, 
                sodienthoai, email, trangthai
            )
            VALUES (
                @p_sodienthoai, 'guest123', 0, @p_hoveten,
                @p_sodienthoai, @p_email, 1
            );
            
            SET @id_tk = SCOPE_IDENTITY();
        END
        
        -- Tính tổng giá hóa đơn từ JSON sản phẩm
        DECLARE @giahoadon DECIMAL(18,2) = 0;
        SELECT @giahoadon = SUM(
            CAST(JSON_VALUE(value, '$.dongia') AS DECIMAL(18,2)) * 
            CAST(JSON_VALUE(value, '$.soluong') AS INT)
        )
        FROM OPENJSON(@p_sanphams);
        
        -- Tạo hóa đơn
        INSERT INTO HOA_DON (
            taikhoan, giahoadon, trangthai, noidung
        )
        VALUES (
            @id_tk, @giahoadon, @p_trangthai, @p_noidung
        );
        
        SET @id_hd = SCOPE_IDENTITY();
        SET @id_hoa_don = @id_hd; -- Trong schema này HOA_DON chính là hóa đơn
        
        -- Tạo chi tiết hóa đơn từ JSON
        INSERT INTO HD_CHI_TIET (hoadon, sanpham, dongia, soluong)
        SELECT 
            @id_hd,
            CAST(JSON_VALUE(value, '$.sanpham') AS INT),
            CAST(JSON_VALUE(value, '$.dongia') AS DECIMAL(18,2)),
            CAST(JSON_VALUE(value, '$.soluong') AS INT)
        FROM OPENJSON(@p_sanphams);
        
        -- Cập nhật số lượng tồn kho
        UPDATE TS
        SET TS.soluong = TS.soluong - CAST(JSON_VALUE(SP.value, '$.soluong') AS INT)
        FROM SP_THONG_SO TS
        INNER JOIN OPENJSON(@p_sanphams) SP 
            ON TS.sanpham = CAST(JSON_VALUE(SP.value, '$.sanpham') AS INT);
        
        -- Tạo bản ghi thanh toán
        INSERT INTO THANH_TOAN (
            hoadon, phuongthuc, sotien, magiaodich, taikhoan
        )
        VALUES (
            @id_hd, @p_phuongthuc_thanhtoan, @p_sotien_thanhtoan,
            'ORDER_' + CAST(@id_hd AS NVARCHAR) + '_' + FORMAT(GETDATE(), 'yyyyMMddHHmmss'),
            @id_tk
        );
        
        -- Tạo địa chỉ nếu chưa có
        IF NOT EXISTS (
            SELECT 1 FROM DIA_CHI 
            WHERE taikhoan = @id_tk AND diachi = @p_diachi
        )
        BEGIN
            INSERT INTO DIA_CHI (taikhoan, diachi)
            VALUES (@id_tk, @p_diachi);
        END
        
        COMMIT TRANSACTION;
        
        SET @message = N'Tạo đơn hàng và hóa đơn thành công';
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @rtn_value = -1;
        SET @message = ERROR_MESSAGE();
    END CATCH
    
    -- Trả về kết quả
    SELECT 
        @rtn_value as rtn_value,
        @id_hd as id_hd,
        @id_hoa_don as id_hoa_don,
        @message as message;
END;
GO
-- WBH_US_CRT_HOA_DON_DIEN_TU
CREATE OR ALTER PROCEDURE WBH_US_CRT_HOA_DON_DIEN_TU
    @p_id_hd INT,
    @p_id_hoa_don INT,
    @p_khach_hang NVARCHAR(255),
    @p_so_dien_thoai NVARCHAR(20),
    @p_email NVARCHAR(255) = NULL,
    @p_dia_chi NVARCHAR(500),
    @p_phuong_thuc_thanh_toan NVARCHAR(100),
    @p_tong_tien DECIMAL(18,2),
    @p_ma_giao_dich NVARCHAR(100),
    @p_chi_tiet_san_pham NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @rtn_value INT = 0;
    DECLARE @message NVARCHAR(500) = '';
    DECLARE @invoice_number NVARCHAR(50);
    DECLARE @current_date NVARCHAR(20);
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Tạo ngày hiện tại dưới dạng string
        SET @current_date = FORMAT(GETDATE(), 'dd/MM/yyyy');
        
        -- Kiểm tra hóa đơn có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM HOA_DON WHERE id_hd = @p_id_hd)
        BEGIN
            SET @rtn_value = -1;
            SET @message = N'Hóa đơn không tồn tại';
            SELECT @rtn_value as rtn_value, @message as message;
            RETURN;
        END
        
        -- Tạo số hóa đơn điện tử
        SET @invoice_number = 'HD' + RIGHT('00000000' + CAST(@p_id_hoa_don AS NVARCHAR), 8);
        
        -- Cập nhật thông tin hóa đơn với thông tin hóa đơn điện tử
        UPDATE HOA_DON 
        SET noidung = CONCAT(
            ISNULL(noidung, ''), 
            CHAR(13) + CHAR(10) + '=== HÓA ĐƠN ĐIỆN TỬ ===',
            CHAR(13) + CHAR(10) + 'Số HĐ: ', @invoice_number,
            CHAR(13) + CHAR(10) + 'Khách hàng: ', @p_khach_hang,
            CHAR(13) + CHAR(10) + 'SĐT: ', @p_so_dien_thoai,
            CASE WHEN @p_email IS NOT NULL THEN CHAR(13) + CHAR(10) + 'Email: ' + @p_email ELSE '' END,
            CHAR(13) + CHAR(10) + 'Địa chỉ: ', @p_dia_chi,
            CHAR(13) + CHAR(10) + 'Phương thức TT: ', @p_phuong_thuc_thanh_toan,
            CHAR(13) + CHAR(10) + 'Mã giao dịch: ', @p_ma_giao_dich,
            CHAR(13) + CHAR(10) + 'Tổng tiền: ', FORMAT(@p_tong_tien, 'N0'), ' VNĐ'
        )
        WHERE id_hd = @p_id_hd;
        
        -- Cập nhật thông tin thanh toán với mã giao dịch mới
        UPDATE THANH_TOAN 
        SET magiaodich = @p_ma_giao_dich,
            phuongthuc = @p_phuong_thuc_thanh_toan,
            sotien = @p_tong_tien
        WHERE hoadon = @p_id_hd;
        
        -- Nếu chưa có bản ghi thanh toán, tạo mới
        IF @@ROWCOUNT = 0
        BEGIN
            INSERT INTO THANH_TOAN (
                hoadon, phuongthuc, sotien, magiaodich, 
                taikhoan, ngaythanhtoan
            )
            SELECT 
                @p_id_hd, @p_phuong_thuc_thanh_toan, @p_tong_tien, @p_ma_giao_dich,
                taikhoan, @current_date
            FROM HOA_DON 
            WHERE id_hd = @p_id_hd;
        END
        
        -- Cập nhật địa chỉ khách hàng nếu cần
        DECLARE @taikhoan_id INT;
        SELECT @taikhoan_id = taikhoan FROM HOA_DON WHERE id_hd = @p_id_hd;
        
        IF @taikhoan_id IS NOT NULL
        BEGIN
            -- Cập nhật thông tin tài khoản
            UPDATE TAI_KHOAN 
            SET hoveten = @p_khach_hang,
                sodienthoai = @p_so_dien_thoai,
                email = ISNULL(@p_email, email)
            WHERE id_tk = @taikhoan_id;
            
            -- Thêm địa chỉ nếu chưa có
            IF NOT EXISTS (
                SELECT 1 FROM DIA_CHI 
                WHERE taikhoan = @taikhoan_id AND diachi = @p_dia_chi
            )
            BEGIN
                INSERT INTO DIA_CHI (taikhoan, diachi)
                VALUES (@taikhoan_id, @p_dia_chi);
            END
        END
        
        COMMIT TRANSACTION;
        
        SET @message = N'Tạo hóa đơn điện tử thành công';
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @rtn_value = ERROR_NUMBER();
        SET @message = ERROR_MESSAGE();
    END CATCH
    
    -- Trả về kết quả theo format mà Vue.js code mong đợi
    SELECT 
        @rtn_value as rtn_value,
        @message as message,
        @invoice_number as invoice_number,
        @p_id_hd as id_hd,
        @p_id_hoa_don as id_hoa_don;
END
GO
--END HOA_DON

/*-- THONG_KE --*/
-- WBH_AD_SEL_BAO_CAO_DOANH_THU
CREATE PROCEDURE WBH_AD_SEL_BAO_CAO_DOANH_THU
    @p_tu_ngay NVARCHAR(255),
    @p_den_ngay NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Ép kiểu NVARCHAR -> DATE theo format dd/MM/yyyy (style 103)
    DECLARE @fromDate DATE = TRY_CONVERT(DATE, @p_tu_ngay, 103);
    DECLARE @toDate   DATE = TRY_CONVERT(DATE, @p_den_ngay, 103);

    -- Nếu tham số không convert được -> báo lỗi
    IF @fromDate IS NULL OR @toDate IS NULL
    BEGIN
        SELECT N'Lỗi định dạng, yêu cầu dd/MM/yyyy'
        RETURN;
    END

    SELECT 
        FORMAT(TRY_CONVERT(DATE, hd.ngaytao, 103), 'dd/MM/yyyy') AS ngay,
        COUNT(*) AS so_don_hang,
        SUM(hd.giahoadon) AS tong_doanh_thu
    FROM HOA_DON hd
    WHERE hd.trangthai = N'Đã thanh toán'
      AND TRY_CONVERT(DATE, hd.ngaytao, 103) >= @fromDate
      AND TRY_CONVERT(DATE, hd.ngaytao, 103) <= @toDate
    GROUP BY FORMAT(TRY_CONVERT(DATE, hd.ngaytao, 103), 'dd/MM/yyyy')
    ORDER BY ngay DESC;
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
--END THONG_KE

/*-- DANH_GIA --*/
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
-- WBH_US_DEL_DANH_GIA
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
-- WBH_US_SEL_DIACHI_THEO_TAIKHOAN
CREATE PROCEDURE WBH_US_SEL_DIACHI_THEO_TAIKHOAN
    @p_taikhoan INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        dc.id_dc,
        dc.taikhoan,
        tk.hoveten,
        tk.sodienthoai,
        tk.email,
        dc.diachi
    FROM DIA_CHI dc
    JOIN TAI_KHOAN tk ON tk.id_tk = dc.taikhoan
    WHERE dc.taikhoan = @p_taikhoan
    ORDER BY dc.id_dc DESC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.WBH_US_CRT_GOOGLE_LOGIN
    @p_email     NVARCHAR(255),
    @p_hoveten   NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @id_tk  INT;
    DECLARE @is_new BIT = 0;

    -- Validate email sơ bộ
    IF (@p_email IS NULL OR LTRIM(RTRIM(@p_email)) = '' OR @p_email NOT LIKE '%_@__%.__%')
    BEGIN
        SELECT TOP (0)
            CAST(0 AS BIT)      AS is_new,
            CAST(NULL AS INT)   AS id_tk,
            CAST(NULL AS NVARCHAR(255)) AS tendangnhap,
            CAST(NULL AS BIT)   AS vaitro,
            CAST(NULL AS NVARCHAR(255)) AS hoveten,
            CAST(NULL AS NVARCHAR(20))  AS sodienthoai,
            CAST(NULL AS NVARCHAR(255)) AS email,
            CAST(NULL AS BIT)   AS trangthai,
            CAST(NULL AS NVARCHAR(20))  AS ngaytao,
            CAST(NULL AS DATE)  AS ngaycapnhat;
        RETURN;
    END;

    BEGIN TRAN;

    -- Tìm tài khoản theo email
    SELECT TOP (1) @id_tk = id_tk
    FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK)
    WHERE email = @p_email;

    -- Nếu chưa có thì tạo mới
    IF @id_tk IS NULL
    BEGIN
        INSERT INTO dbo.TAI_KHOAN
            (tendangnhap, matkhau, vaitro, hoveten, sodienthoai, email, trangthai, ngaytao, ngaycapnhat)
        VALUES
            (@p_email, NULL, 0, ISNULL(@p_hoveten, @p_email), NULL, @p_email, 1,
             FORMAT(GETDATE(), 'dd/MM/yyyy'), GETDATE());

        SET @id_tk = SCOPE_IDENTITY();
        SET @is_new = 1;
    END;

    COMMIT TRAN;

    -- Luôn trả về đúng 1 result set (nếu đã có thì chỉ select lại thôi)
    SELECT 
        @is_new                           AS is_new,
        tk.id_tk,
        tk.tendangnhap,
        CAST(tk.vaitro AS BIT)            AS vaitro,
        tk.hoveten,
        tk.sodienthoai,
        tk.email,
        CAST(tk.trangthai AS BIT)         AS trangthai,
        tk.ngaytao,
        tk.ngaycapnhat
    FROM dbo.TAI_KHOAN tk
    WHERE tk.id_tk = @id_tk;
END
GO


/*===== CHECK TRIGGER =====*/
SELECT
    t.name AS TriggerName, 
    o.name AS TableName,
    t.is_disabled AS IsDisabled, 
    FORMAT(t.create_date, 'dd/MM/yyyy') AS CreateDate,
    FORMAT(t.modify_date, 'dd/MM/yyyy') AS ModifyDate
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
ORDER BY create_date;
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
(N'Phụ kiện'),
(N'Tivi'),
(N'Loa và tai nghe'),
(N'Đồng hồ thông minh');
GO

-- SP_THUONG_HIEU
INSERT INTO SP_THUONG_HIEU (thuonghieuTen) VALUES 
(N'LENOVO'),
(N'HP'),
(N'DELL'),
(N'APPLE'),
(N'ASUS'),
(N'SAMSUNG'),
(N'XIAOMI'),
(N'VIVO'),
(N'OPPPO'),
(N'SONY');
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

/* ===== INSERT DATA CHO BẢNG CHƯA CÓ ===== */

/* DIA_CHI */
INSERT INTO DIA_CHI (taikhoan, diachi) VALUES
(2, N'123 Nguyễn Trãi, Hà Nội'),
(3, N'456 Lê Lợi, TP.HCM'),
(4, N'789 Trần Hưng Đạo, Đà Nẵng');

-- Thông số
INSERT INTO SP_THONG_SO (sanpham, model, trongluong, pin, congketnoi, tinhnang, mausac, soluong) VALUES
(1, N'Model IP15PM', N'221g', N'4500mAh', N'USB-C', N'Cấu hình mạnh mẽ', N'Titan', 5),
(2, N'Model S24U', N'228g', N'5000mAh', N'USB-C', N'Camera 200MP', N'Đen', 10),
(3, N'Model ROG', N'2.3kg', N'90Wh', N'USB-C + HDMI', N'Gaming cao cấp', N'Đen', 3);

-- Ảnh phụ
INSERT INTO ANH_SP (sanpham, diachianh) VALUES
(1, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1751982356/iphone-15-pro-max_sr3kih.png'),
(2, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1751982455/samsung-galaxy-s24-ultra-5g_x9mz9s.jpg'),
(3, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1751982541/oppo-reno-10-tgdd-321312312313121-1-250523-091139-800-resize_zgiczf.jpg');

/* HOA_DON */
INSERT INTO HOA_DON (taikhoan, giahoadon, trangthai, noidung)
VALUES
(2, 39000000, N'Chờ thanh toán', N'Mua iPhone 15 Pro Max'),
(3, 28000000, N'Đã thanh toán', N'Mua Samsung Galaxy S24 Ultra');

/* HD_CHI_TIET */
INSERT INTO HD_CHI_TIET (hoadon, sanpham, dongia, soluong)
VALUES
(1, 1, 39000000, 1),
(2, 2, 28000000, 1);

/* THANH_TOAN */
INSERT INTO THANH_TOAN (hoadon, phuongthuc, sotien, ngaythanhtoan, magiaodich, taikhoan)
VALUES
(2, N'Tiền mặt', 28000000, FORMAT(GETDATE(), 'dd/MM/yyyy'), N'TT001', 3);

/* GIO_HANG */
INSERT INTO GIO_HANG (sanpham, taikhoan) VALUES
(3, 2),
(2, 4);

/* GOP_Y */
INSERT INTO GOP_Y (taikhoan, noidung, ngaycapnhat)
VALUES
(2, N'Sản phẩm rất tốt!', FORMAT(GETDATE(), 'dd/MM/yyyy')),
(3, N'Giao hàng hơi chậm', FORMAT(GETDATE(), 'dd/MM/yyyy'));

/* DANH_GIA */
INSERT INTO DANH_GIA (taikhoan, sanpham, noidung, diemso)
VALUES
(2, 1, N'Siêu phẩm!', 5),
(3, 2, N'Rất hài lòng', 4);

/* YEU_THICH */
INSERT INTO YEU_THICH (sanpham, taikhoan, trangthai) VALUES
(1, 1, 'Y'),
(3, 1, 'Y');

-- Điện thoại di động (loai = 1)
EXEC WBH_AD_CRT_THEMSP N'iPhone 15 Pro', 30000000, 1, 4, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039942/iPhone-15-pro-max-titan-xanh-6_vkfpqr.jpg', N'Model A1', N'200g', N'4323mAh', N'USB-C', N'FaceID, 5G', N'Titan Xanh', 50, NULL, 1, '30/12/2030';
EXEC WBH_AD_CRT_THEMSP N'Samsung Galaxy S24', 25000000, 1, 6, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756038970/samsung-galaxy-s24-ultra-den_dyz5ld.jpg', N'Model A2', N'210g', N'4500mAh', N'USB-C', N'AI Camera, 5G', N'Đen', 40, NULL, 2, '30/12/2030';
EXEC WBH_AD_CRT_THEMSP N'Xiaomi 14 Ultra', 20000000, 1, 7, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039004/xiaomi-14-ultra_3_uygd6n.webp', N'Model A3', N'230g', N'5000mAh', N'USB-C', N'HyperOS, Leica Camera', N'Trắng', 35, NULL, 3, '30/12/2030';

-- Máy tính bảng (loai = 2)
EXEC WBH_AD_CRT_THEMSP N'iPad Pro M2', 28000000, 2, 4, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039037/ipad_pro_m2_-_11_inch__colors__c4189cc924bb40b181351e979df29f64_master_a21yli.png', N'Model B1', N'600g', N'Li-ion', N'Thunderbolt', N'FaceID, Apple Pencil', N'Xám', 25, NULL, 4, '30/12/2030';
EXEC WBH_AD_CRT_THEMSP N'Samsung Galaxy Tab S9', 22000000, 2, 6, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039872/unnamed_tyd48g.webp', N'Model B2', N'580g', N'Li-ion', N'USB-C', N'S Pen, Dex', N'Bạc', 30, NULL, 5, '30/12/2030';
EXEC WBH_AD_CRT_THEMSP N'Xiaomi Pad 6', 12000000, 2, 7, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039829/xiaomi-pad-6-blue-thumb-600x600_brghih.jpg', N'Model B3', N'550g', N'Li-ion', N'USB-C', N'Smart Stylus', N'Xanh dương', 20, NULL, 6, '30/12/2030';

-- Laptop (loai = 3)
EXEC WBH_AD_CRT_THEMSP N'Lenovo ThinkPad X1', 35000000, 3, 1, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039136/ThinkPad-X1-Carbon-Gen-13-CT1-05-www.laptopvip.vn-1731149987_bgl3zd.webp', N'Model C1', N'1.4kg', N'Li-ion', N'Thunderbolt, HDMI', N'Fingerprint, Camera IR', N'Đen', 15, NULL, 7, '30/12/2030';
EXEC WBH_AD_CRT_THEMSP N'Dell XPS 13', 40000000, 3, 3, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039163/dell-xps-13-9350-2024-1731577899_fskwm6.png', N'Model C2', N'1.3kg', N'Li-ion', N'USB-C, Thunderbolt', N'Touch, AI Noise Cancel', N'Bạc', 18, NULL, 8, '30/12/2030';
EXEC WBH_AD_CRT_THEMSP N'Asus ROG Zephyrus', 45000000, 3, 5, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039188/50871_rog_zephyrus_g14_23ecdf926b6a46fa887a95de8b1d409f_grande_5361640af98943f59d5b1af718d6a65a_grande_fn5soz.png', N'Model C3', N'2.0kg', N'Li-ion', N'HDMI, USB-C', N'RTX 4070, RGB Keyboard', N'Đen đỏ', 10, NULL, 9, '30/12/2030';

-- Phụ kiện (loai = 4)
EXEC WBH_AD_CRT_THEMSP N'Apple Magic Mouse', 2500000, 4, 4, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039281/003294PCR-EU_hpb7gi.jpg', N'Model D1', N'100g', N'Pin sạc', N'Bluetooth', N'Multi-Touch Surface', N'Trắng', 100, NULL, 10, '30/12/2030';
EXEC WBH_AD_CRT_THEMSP N'Samsung S Pen Pro', 1500000, 4, 6, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039309/s-pen-pro_800x450_vffklh.jpg', N'Model D2', N'20g', N'Pin sạc', N'Bluetooth', N'Air Actions', N'Đen', 80, NULL, 11, '30/12/2030';
EXEC WBH_AD_CRT_THEMSP N'Sony DualSense Controller', 2000000, 4, 10, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039339/dualsense-ps5-edge-wireless-controller-45-1400x1400-1_vgbqon.webp', N'Model D3', N'280g', N'Pin sạc', N'USB-C, Bluetooth', N'Haptic Feedback, Adaptive Trigger', N'Trắng xanh', 60, NULL, 12, '30/12/2030';

-- Tivi (loai = 5)
EXEC WBH_AD_CRT_THEMSP N'Samsung Neo QLED 55"', 30000000, 5, 6, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039364/1729790062_main_smart-tivi-samsung-neo-qled-4k-55-inch-qa55qn85dbkxxv_k9xn2t.jpg', N'Model E1', N'15kg', N'Điện trực tiếp', N'HDMI, WiFi', N'4K HDR, AI Upscale', N'Đen', 12, NULL, 13, '30/12/2030';
EXEC WBH_AD_CRT_THEMSP N'Sony Bravia XR 65"', 35000000, 5, 10, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039397/10055293-google-tivi-oled-sony-bravia-4k-65-inch-xr-65a80l-vn3-1_prask0.webp', N'Model E2', N'20kg', N'Điện trực tiếp', N'HDMI, WiFi', N'XR Cognitive Processor', N'Bạc', 10, NULL, 14, '30/12/2030';
EXEC WBH_AD_CRT_THEMSP N'LG OLED evo C3 55"', 32000000, 5, 6, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039425/TV-OLED-55-C3-A-Basic_jqpawa.jpg', N'Model E3', N'16kg', N'Điện trực tiếp', N'HDMI, WiFi', N'OLED HDR, Dolby Vision', N'Đen xám', 8, NULL, 15, '30/12/2030';

-- Loa và tai nghe (loai = 6)
EXEC WBH_AD_CRT_THEMSP N'Apple AirPods Pro 2', 6000000, 6, 4, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039454/tai-nghe-bluetooth-airpods-pro-2nd-gen-usb-c-charge-apple-thumb-1-600x600_r1wqep.jpg', N'Model F1', N'50g', N'Pin sạc', N'Bluetooth 5.3', N'ANC, Transparency Mode', N'Trắng', 70, NULL, 1, '30/12/2030';
EXEC WBH_AD_CRT_THEMSP N'Sony WH-1000XM5', 9000000, 6, 10, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039782/6145c1d32e6ac8e63a46c912dc33c5bb_eceg8c.avif', N'Model F2', N'250g', N'Pin sạc', N'Bluetooth 5.2, Jack 3.5mm', N'ANC, Hi-Res Audio', N'Đen', 40, NULL, 2, '30/12/2030';
EXEC WBH_AD_CRT_THEMSP N'JBL Charge 5', 5000000, 6, 6, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039749/jbl-charge-5-19-294_rgoqt2.png', N'Model F3', N'900g', N'Li-ion', N'Bluetooth, USB-C', N'Chống nước IP67, Bass mạnh', N'Đỏ', 30, NULL, 3, '30/12/2030';

-- Đồng hồ thông minh (loai = 7)
EXEC WBH_AD_CRT_THEMSP N'Apple Watch Series 9', 12000000, 7, 4, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039652/apple-watch-series-9-pink00000-jpeg-c139e598-3080-4750-bbdf-fa712b3e3bb4_a7aebe.webp', N'Model G1', N'40g', N'Pin sạc', N'Bluetooth, WiFi', N'SpO2, ECG, Always-on Display', N'Hồng', 25, NULL, 4, '30/12/2030';
EXEC WBH_AD_CRT_THEMSP N'Samsung Galaxy Watch 6', 10000000, 7, 6, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039681/1_191_4_2_2_1_1_1_2_1_1_u5hlh5.png', N'Model G2', N'45g', N'Pin sạc', N'Bluetooth, LTE', N'SpO2, ECG, BiaSense', N'Đen bạc', 30, NULL, 5, '30/12/2030';
EXEC WBH_AD_CRT_THEMSP N'Xiaomi Watch S2', 5000000, 7, 7, N'https://res.cloudinary.com/dkztehmmk/image/upload/v1756039718/xiaomi-watch-s2_xoggkq.jpg', N'Model G3', N'42g', N'Pin sạc', N'Bluetooth', N'SpO2, 117 chế độ luyện tập', N'Xanh lá', 20, NULL, 6, '30/12/2030';

-- Tài khoản 1 yêu thích sản phẩm 1,2,3,...
EXEC WBH_US_UPD_CAPNHAT_YT_SP 1, 1;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 2, 1;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 3, 1;

-- Tài khoản 2
EXEC WBH_US_UPD_CAPNHAT_YT_SP 4, 2;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 5, 2;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 6, 2;

-- Tài khoản 3
EXEC WBH_US_UPD_CAPNHAT_YT_SP 7, 3;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 8, 3;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 9, 3;

-- Tài khoản 4
EXEC WBH_US_UPD_CAPNHAT_YT_SP 10, 4;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 11, 4;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 12, 4;

-- Tài khoản 5
EXEC WBH_US_UPD_CAPNHAT_YT_SP 13, 5;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 14, 5;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 15, 5;

-- Tài khoản 6
EXEC WBH_US_UPD_CAPNHAT_YT_SP 16, 6;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 17, 6;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 18, 6;

-- Tài khoản 7
EXEC WBH_US_UPD_CAPNHAT_YT_SP 19, 7;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 20, 7;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 21, 7;

-- Tài khoản 8 (lặp lại từ sản phẩm 1 để vòng tròn)
EXEC WBH_US_UPD_CAPNHAT_YT_SP 1, 8;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 2, 8;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 3, 8;

-- Tài khoản 9
EXEC WBH_US_UPD_CAPNHAT_YT_SP 4, 9;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 5, 9;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 6, 9;

-- Tài khoản 10
EXEC WBH_US_UPD_CAPNHAT_YT_SP 7, 10;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 8, 10;
EXEC WBH_US_UPD_CAPNHAT_YT_SP 9, 10;
