USE QL_NHAN_KHAU;
GO

/* =============================================================
   1. KHỞI TẠO CÁC BẢNG HỆ THỐNG & PHÂN QUYỀN
   ============================================================= */

CREATE TABLE Quyen (
    Ma_Quyen INT IDENTITY(1,1) PRIMARY KEY,
    Ten_Quyen NVARCHAR(MAX) UNIQUE NOT NULL
);

CREATE TABLE Vai_Tro (
    Ma_VT INT PRIMARY KEY IDENTITY(1,1),
    Ten_VT NVARCHAR(MAX) NOT NULL
);

CREATE TABLE Vai_Tro_Quyen (
    Ma_Quyen INT NOT NULL,
    Ma_VT INT NOT NULL,
    PRIMARY KEY(Ma_VT, Ma_Quyen),
    FOREIGN KEY (Ma_VT) REFERENCES Vai_Tro(Ma_VT),
    FOREIGN KEY (Ma_Quyen) REFERENCES Quyen(Ma_Quyen)
);

/* =============================================================
   2. KHỞI TẠO CÁC BẢNG QUẢN LÝ DÂN CƯ
   ============================================================= */

CREATE TABLE Ho_Khau (
    Ma_HK INT PRIMARY KEY IDENTITY(1,1),
    Dia_Chi NVARCHAR(MAX) NOT NULL,
    Ngay_lap DATE NOT NULL,
    CCCD_Chu_Ho VARCHAR(12) UNIQUE NULL,
    Tinh_Trang NVARCHAR(50) DEFAULT N'Tồn tại'
);

CREATE TABLE Nhan_Khau (
    Ma_NK INT PRIMARY KEY IDENTITY(1,1),
    Ma_CCCD VARCHAR(12) UNIQUE NULL,
    Ma_HK INT NULL,
    Ho_Ten NVARCHAR(MAX) NOT NULL,
    Ngay_Sinh DATE NOT NULL,
    Ngay_Cap_CC DATE,
    Noi_Cap NVARCHAR(MAX),
    DC_TT NVARCHAR(MAX),
    Gioi_Tinh NVARCHAR(MAX) NOT NULL,
    Email VARCHAR(100),
    Que_Quan NVARCHAR(200),
    Noi_Sinh NVARCHAR(200),
    TT_Hon_Nhan NVARCHAR(100),
    Bi_Danh NVARCHAR(MAX),
    Nghe_Nghiep NVARCHAR(MAX),
    Dan_Toc NVARCHAR(100),
    Ngay_DK_Thuong_Tru DATE,
    DC_Thuong_Tru_Truoc NVARCHAR(MAX),
    Noi_Lam_Viec NVARCHAR(MAX),
    Trang_Thai NVARCHAR(100) DEFAULT N'Đang sống',
    FOREIGN KEY(Ma_HK) REFERENCES Ho_Khau(Ma_HK)
);

-- Ràng buộc vòng giữa Hộ Khẩu và Nhân Khẩu (Chủ hộ)
ALTER TABLE Ho_Khau 
ADD CONSTRAINT FK_HoKhau_ChuHo 
FOREIGN KEY (CCCD_Chu_Ho) REFERENCES Nhan_Khau(Ma_CCCD);

CREATE TABLE lien_ket_HK (
    Ma_HK INT NOT NULL,
    Ma_CCCD VARCHAR(15) NOT NULL,
    Quan_He NVARCHAR(MAX) NOT NULL,
    PRIMARY KEY(Ma_HK, Ma_CCCD),
    FOREIGN KEY(Ma_HK) REFERENCES Ho_Khau(Ma_HK),
    FOREIGN KEY(Ma_CCCD) REFERENCES Nhan_Khau(Ma_CCCD)
);

CREATE TABLE Nguoi_Dung (
    Ma_ND INT PRIMARY KEY IDENTITY(1,1),
    Ma_CCCD VARCHAR(12),
    Ten_DN VARCHAR(50) UNIQUE NOT NULL,
    Mat_Khau VARCHAR(MAX) NULL,
    Ma_VT INT NOT NULL,
    FOREIGN KEY(Ma_CCCD) REFERENCES Nhan_Khau(Ma_CCCD),
    FOREIGN KEY(Ma_VT) REFERENCES Vai_Tro(Ma_VT)
);

/* =============================================================
   3. CÁC BẢNG QUẢN LÝ BIẾN ĐỘNG & TIỆN ÍCH
   ============================================================= */

CREATE TABLE Bien_Dong_HK (
    Ma_BD INT PRIMARY KEY IDENTITY(1,1),
    Loai_Bien_Dong NVARCHAR(50) NOT NULL,
    Ma_NK INT NULL,
    Ma_HK INT NULL,
    Ma_HK_Cu INT NULL,
    Ngay_Thuc_Hien DATE NOT NULL,
    Ngay_Ket_Thuc DATE NULL,
    DC_Cu NVARCHAR(MAX) NULL,
    DC_Moi NVARCHAR(MAX) NULL,
    Ghi_Chu NVARCHAR(MAX) NULL,
    FOREIGN KEY (Ma_HK_Cu) REFERENCES Ho_Khau(Ma_HK)
);

CREATE TABLE Quan_Ly_Cu_Tru (
    Ma_CT INT PRIMARY KEY IDENTITY(1,1),
    Ma_CCCD VARCHAR(15),
    Loai_Hinh NVARCHAR(50), 
    Tu_Ngay DATE,
    Den_Ngay DATE,
    Ly_Do NVARCHAR(MAX),
    Noi_Den_Di NVARCHAR(MAX),
    DC_Den_Di NVARCHAR(MAX),
    FOREIGN KEY (Ma_CCCD) REFERENCES Nhan_Khau(Ma_CCCD)
);

CREATE TABLE Thong_Bao (
    Ma_TB INT PRIMARY KEY IDENTITY(1,1),
    Ma_CCCD_NguoiNhan VARCHAR(12), 
    Tieu_De NVARCHAR(255),
    Noi_Dung NVARCHAR(MAX),
    Loai_TB NVARCHAR(50), 
    Lien_Ket NVARCHAR(255),
    Ngay_Tao DATETIME DEFAULT GETDATE(),
    Da_Xem BIT DEFAULT 0 
);

CREATE TABLE Temp_Auth (
    Ma_CCCD VARCHAR(15) PRIMARY KEY,
    OTP_Code VARCHAR(6) NULL,
    OTP_Expiry DATETIME NULL,
    Is_Email_Verified BIT DEFAULT 0, 
    FOREIGN KEY(Ma_CCCD) REFERENCES Nhan_Khau(Ma_CCCD)
);

/* =============================================================
   4. HỆ THỐNG PHẢN ÁNH & PHẢN HỒI
   ============================================================= */

CREATE TABLE Phan_anh (
    Ma_PA INT PRIMARY KEY IDENTITY(1,1),
    Tieu_De NVARCHAR(255) NOT NULL,
    Ngay_PA DATETIME DEFAULT GETDATE(),
    Loai_Van_De NVARCHAR(100) NULL,
    ND_PA NVARCHAR(MAX) NULL,
    Ma_CCCD VARCHAR(15) NULL,
    Is_An_Danh BIT DEFAULT 0,
    Trang_Thai NVARCHAR(50) DEFAULT N'Chưa Tiếp nhận',
    FOREIGN KEY (Ma_CCCD) REFERENCES Nhan_Khau(Ma_CCCD)
);

CREATE TABLE File_PA (
    Ma_File UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Ma_PA INT NOT NULL,
    URL_File VARCHAR(MAX) NOT NULL,
    Loai_File VARCHAR(10) NULL,
    FOREIGN KEY (Ma_PA) REFERENCES Phan_Anh(Ma_PA)
);

CREATE TABLE Phan_Hoi (
    Ma_PH INT PRIMARY KEY IDENTITY(1,1),
    Ma_PA INT NOT NULL,
    Ngay_PH DATETIME DEFAULT GETDATE(),
    Noi_Dung NVARCHAR(MAX) NOT NULL,
    Ma_CCCD_XL VARCHAR(15) NOT NULL,
    FOREIGN KEY (Ma_PA) REFERENCES Phan_Anh(Ma_PA),
    FOREIGN KEY (Ma_CCCD_XL) REFERENCES Nhan_Khau(Ma_CCCD)
);

CREATE TABLE File_Phan_Hoi (
    Ma_File UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Ma_PH INT NOT NULL,
    URL_File VARCHAR(MAX) NOT NULL,
    Loai_File VARCHAR(10) NULL,
    FOREIGN KEY (Ma_PH) REFERENCES Phan_Hoi(Ma_PH) ON DELETE CASCADE
);

CREATE TABLE Gop_PA (
    Ma_PA_Goc INT NOT NULL,
    Ma_PA_Duoc_Gop INT NOT NULL,
    So_Lan INT DEFAULT 1,
    PRIMARY KEY(Ma_PA_Goc, Ma_PA_Duoc_Gop),
    FOREIGN KEY (Ma_PA_Goc) REFERENCES Phan_Anh(Ma_PA),
    FOREIGN KEY (Ma_PA_Duoc_Gop) REFERENCES Phan_Anh(Ma_PA),
    CONSTRAINT CHK_Gop_Khac_Goc CHECK (Ma_PA_Goc <> Ma_PA_Duoc_Gop)
);

GO

/* =============================================================
   5. CÁC TRIGGER TỰ ĐỘNG HÓA LOGIC (STORED PROCEDURES / TRIGGERS)
   ============================================================= */

-- Trigger tự động tạo tài khoản khi thêm nhân khẩu mới
CREATE OR ALTER TRIGGER tr_AutoCreateUser
ON Nhan_Khau
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Nguoi_Dung (Ma_CCCD, Ma_VT, Ten_DN, Mat_Khau)
        SELECT DISTINCT
            i.Ma_CCCD, 
            6, -- Mặc định vai trò Người Dân
            i.Ma_CCCD,      
            NULL          
        FROM inserted i
        WHERE i.Ma_CCCD IS NOT NULL 
          AND i.Ma_CCCD NOT LIKE 'T%' 
          AND (i.Trang_Thai = N'Đang sống' OR i.Trang_Thai LIKE N'Tạm trú hộ%')
          AND NOT EXISTS (
              SELECT 1 FROM Nguoi_Dung nd WHERE nd.Ma_CCCD = i.Ma_CCCD
          );
    END TRY
    BEGIN CATCH
        PRINT 'Lỗi Trigger tr_AutoCreateUser: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Trigger xóa tài khoản khi thay đổi trạng thái nhân khẩu
CREATE OR ALTER TRIGGER tr_AutoDeleteUserOnStatusChange
ON Nhan_Khau
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(Trang_Thai)
    BEGIN
        DELETE nd
        FROM Nguoi_Dung nd
        INNER JOIN inserted i ON nd.Ma_CCCD = i.Ma_CCCD
        WHERE i.Trang_Thai IN (N'Mất', N'Chuyển đi', N'Đã qua đời', N'Tạm trú chuyển đi');
    END
END;
GO

-- Trigger lưu lịch sử biến động khi đổi chủ hộ
CREATE OR ALTER TRIGGER tr_LichSuChuHo
ON Ho_Khau
AFTER UPDATE
AS
BEGIN
    IF UPDATE(CCCD_Chu_Ho)
    BEGIN
        INSERT INTO Bien_Dong_HK (Loai_Bien_Dong, Ma_HK, Ngay_Thuc_Hien, Ghi_Chu)
        SELECT N'Thay đổi chủ hộ', i.Ma_HK, GETDATE(), 
               N'Chủ hộ cũ: ' + ISNULL(d.CCCD_Chu_Ho, 'None') + N' -> Chủ hộ mới: ' + i.CCCD_Chu_Ho
        FROM inserted i
        JOIN deleted d ON i.Ma_HK = d.Ma_HK;
    END
END;
GO

-- Trigger tự động sinh mã TE cho trẻ em chưa có CCCD
CREATE OR ALTER TRIGGER tr_AutoGenerate_TE
ON Nhan_Khau
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @MaxTE INT;

    SELECT @MaxTE = ISNULL(MAX(CAST(SUBSTRING(Ma_CCCD, 3, 10) AS INT)), 0)
    FROM Nhan_Khau WHERE Ma_CCCD LIKE 'TE%';

    ;WITH NewTE AS (
        SELECT 
            i.Ma_NK,
            'TE' + RIGHT('000000' + CAST(@MaxTE + ROW_NUMBER() OVER (ORDER BY i.Ma_NK) AS VARCHAR), 6) AS NewMaCCCD
        FROM inserted i
        WHERE i.Ma_CCCD IS NULL 
           OR i.Ma_CCCD LIKE 'T%' 
           OR LTRIM(RTRIM(i.Ma_CCCD)) = ''
    )
    UPDATE nk
    SET nk.Ma_CCCD = nte.NewMaCCCD
    FROM Nhan_Khau nk
    JOIN NewTE nte ON nk.Ma_NK = nte.Ma_NK;
END;
GO

-- Index đảm bảo duy nhất cho địa chỉ hộ khẩu đang tồn tại
CREATE UNIQUE INDEX UQ_Ho_Khau_DiaChi_TonTai
ON Ho_Khau(Dia_Chi)
WHERE Tinh_Trang = N'Tồn tại';
GO