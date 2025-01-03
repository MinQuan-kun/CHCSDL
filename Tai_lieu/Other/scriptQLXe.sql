USE [dbXe]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BangLai](
	[MaBangLai] [varchar](4) NOT NULL,
	[MaTaiXe] [varchar](4) NULL,
	[NgayCap] [date] NULL,
	[LoaiGPLX] [nvarchar](50) NULL,
 CONSTRAINT [PK_BangLai] PRIMARY KEY CLUSTERED 
(
	[MaBangLai] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LoaiXe](
	[MaLoaiXe] [varchar](4) NOT NULL,
	[TenLoaiXe] [nvarchar](50) NULL,
	[NhaSX] [nvarchar](20) NULL,
	[TaiTrongXe] [int] NULL,
	[NienHan] [int] NULL,
 CONSTRAINT [PK_LoaiXe] PRIMARY KEY CLUSTERED 
(
	[MaLoaiXe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TaiXe](
	[MaTaiXe] [varchar](4) NOT NULL,
	[HoTenTaiXe] [nvarchar](50) NULL,
	[NgaySinh] [date] NULL,
	[DiaChi] [nvarchar](100) NULL,
 CONSTRAINT [PK_TaiXe] PRIMARY KEY CLUSTERED 
(
	[MaTaiXe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [VanChuyen](
	[MaChuyen] [int] IDENTITY(1,1) NOT NULL,
	[MaTaiXe] [varchar](4) NULL,
	[BienSo] [varchar](10) NULL,
	[TaiTrong] [int] NULL,
	[QuangDuong] [int] NULL,
	[NgayChuyen] [date] NULL,
 CONSTRAINT [PK_VanChuyen] PRIMARY KEY CLUSTERED 
(
	[MaChuyen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [XeTai](
	[BienSo] [varchar](10) NOT NULL,
	[MaLoaiXe] [varchar](4) NULL,
	[NgayMua] [date] NULL,
	[SoKm] [int] NULL,
	[NamDangKiem] [int] NULL,
 CONSTRAINT [PK_XeTai] PRIMARY KEY CLUSTERED 
(
	[BienSo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [BangLai] ([MaBangLai], [MaTaiXe], [NgayCap], [LoaiGPLX]) VALUES (N'M001', N'X001', CAST(N'1990-12-01' AS Date), N'B2')
INSERT [BangLai] ([MaBangLai], [MaTaiXe], [NgayCap], [LoaiGPLX]) VALUES (N'M002', N'X001', CAST(N'1995-02-20' AS Date), N'D')
INSERT [BangLai] ([MaBangLai], [MaTaiXe], [NgayCap], [LoaiGPLX]) VALUES (N'M003', N'X001', CAST(N'1997-02-04' AS Date), N'C')
INSERT [BangLai] ([MaBangLai], [MaTaiXe], [NgayCap], [LoaiGPLX]) VALUES (N'M004', N'X002', CAST(N'1990-04-02' AS Date), N'B2')
INSERT [BangLai] ([MaBangLai], [MaTaiXe], [NgayCap], [LoaiGPLX]) VALUES (N'M005', N'X002', CAST(N'1992-04-13' AS Date), N'C')
INSERT [BangLai] ([MaBangLai], [MaTaiXe], [NgayCap], [LoaiGPLX]) VALUES (N'M006', N'X003', CAST(N'1993-07-01' AS Date), N'D')
INSERT [BangLai] ([MaBangLai], [MaTaiXe], [NgayCap], [LoaiGPLX]) VALUES (N'M007', N'X004', CAST(N'1994-09-21' AS Date), N'E')
INSERT [BangLai] ([MaBangLai], [MaTaiXe], [NgayCap], [LoaiGPLX]) VALUES (N'M008', N'X005', CAST(N'1995-05-11' AS Date), N'B2')
GO
INSERT [LoaiXe] ([MaLoaiXe], [TenLoaiXe], [NhaSX], [TaiTrongXe], [NienHan]) VALUES (N'L001', N'Tải hạng nhẹ', N'ThaCo', 2000, 50)
INSERT [LoaiXe] ([MaLoaiXe], [TenLoaiXe], [NhaSX], [TaiTrongXe], [NienHan]) VALUES (N'L002', N'Tải hạng trung', N'Honda', 5000, 45)
INSERT [LoaiXe] ([MaLoaiXe], [TenLoaiXe], [NhaSX], [TaiTrongXe], [NienHan]) VALUES (N'L003', N'Tải hạng nặng', N'Huyndai', 8000, 40)
INSERT [LoaiXe] ([MaLoaiXe], [TenLoaiXe], [NhaSX], [TaiTrongXe], [NienHan]) VALUES (N'L004', N'Tải siêu trường', N'KIA', 12000, 30)
GO
INSERT [TaiXe] ([MaTaiXe], [HoTenTaiXe], [NgaySinh], [DiaChi]) VALUES (N'X001', N'Nguyễn Minh An', CAST(N'1975-04-02' AS Date), N'Phổ Quang, Tân Bình, Tp Hồ Chí Minh')
INSERT [TaiXe] ([MaTaiXe], [HoTenTaiXe], [NgaySinh], [DiaChi]) VALUES (N'X002', N'Trần Chí Hào', CAST(N'1980-11-21' AS Date), N'Bùi Đình Túy, Bình Thạnh, Tp Hồ Chí Minh')
INSERT [TaiXe] ([MaTaiXe], [HoTenTaiXe], [NgaySinh], [DiaChi]) VALUES (N'X003', N'Lê Nhật Khải', CAST(N'1983-04-12' AS Date), N'Hồ Hảo Hớn, Q1, Tp Hồ Chí Minh')
INSERT [TaiXe] ([MaTaiXe], [HoTenTaiXe], [NgaySinh], [DiaChi]) VALUES (N'X004', N'Ngô Minh Xuân', CAST(N'1990-08-02' AS Date), N'Hậu Giang, Q6, Tp Hồ Chí Minh')
INSERT [TaiXe] ([MaTaiXe], [HoTenTaiXe], [NgaySinh], [DiaChi]) VALUES (N'X005', N'Lưu Gia Minh', CAST(N'1995-01-30' AS Date), N'Âu Cơ, Q11, Tp Hồ Chí Minh')
GO
SET IDENTITY_INSERT [VanChuyen] ON 

INSERT [VanChuyen] ([MaChuyen], [MaTaiXe], [BienSo], [TaiTrong], [QuangDuong], [NgayChuyen]) VALUES (1, N'X001', N'55K1-10003', 7, 50, CAST(N'2001-01-10' AS Date))
INSERT [VanChuyen] ([MaChuyen], [MaTaiXe], [BienSo], [TaiTrong], [QuangDuong], [NgayChuyen]) VALUES (2, N'X001', N'55K1-10003', 20, 120, CAST(N'2001-01-25' AS Date))
INSERT [VanChuyen] ([MaChuyen], [MaTaiXe], [BienSo], [TaiTrong], [QuangDuong], [NgayChuyen]) VALUES (3, N'X002', N'55K1-10003', 20, 50, CAST(N'2001-01-20' AS Date))
INSERT [VanChuyen] ([MaChuyen], [MaTaiXe], [BienSo], [TaiTrong], [QuangDuong], [NgayChuyen]) VALUES (4, N'X002', N'59K3-10102', 5, 15, CAST(N'2001-02-15' AS Date))
SET IDENTITY_INSERT [VanChuyen] OFF
GO
INSERT [XeTai] ([BienSo], [MaLoaiXe], [NgayMua], [SoKm], [NamDangKiem]) VALUES (N'55K1-10003', N'L002', CAST(N'2006-09-02' AS Date), 3010, 2025)
INSERT [XeTai] ([BienSo], [MaLoaiXe], [NgayMua], [SoKm], [NamDangKiem]) VALUES (N'55K2-10004', N'L003', CAST(N'2010-12-03' AS Date), 510, 2030)
INSERT [XeTai] ([BienSo], [MaLoaiXe], [NgayMua], [SoKm], [NamDangKiem]) VALUES (N'55K3-10105', N'L004', CAST(N'2010-05-22' AS Date), 1000, 2030)
INSERT [XeTai] ([BienSo], [MaLoaiXe], [NgayMua], [SoKm], [NamDangKiem]) VALUES (N'59K3-10102', N'L001', CAST(N'2005-08-20' AS Date), 1850, 2025)
INSERT [XeTai] ([BienSo], [MaLoaiXe], [NgayMua], [SoKm], [NamDangKiem]) VALUES (N'59K4-10201', N'L001', CAST(N'2000-04-12' AS Date), 2000, 2020)
GO
ALTER TABLE [BangLai]  WITH CHECK ADD  CONSTRAINT [FK_BangLai_TaiXe] FOREIGN KEY([MaTaiXe])
REFERENCES [TaiXe] ([MaTaiXe])
GO
ALTER TABLE [BangLai] CHECK CONSTRAINT [FK_BangLai_TaiXe]
GO
ALTER TABLE [VanChuyen]  WITH CHECK ADD  CONSTRAINT [FK_VanChuyen_TaiXe] FOREIGN KEY([MaTaiXe])
REFERENCES [TaiXe] ([MaTaiXe])
GO
ALTER TABLE [VanChuyen] CHECK CONSTRAINT [FK_VanChuyen_TaiXe]
GO
ALTER TABLE [VanChuyen]  WITH CHECK ADD  CONSTRAINT [FK_VanChuyen_XeTai] FOREIGN KEY([BienSo])
REFERENCES [XeTai] ([BienSo])
GO
ALTER TABLE [VanChuyen] CHECK CONSTRAINT [FK_VanChuyen_XeTai]
GO
ALTER TABLE [XeTai]  WITH CHECK ADD  CONSTRAINT [FK_XeTai_LoaiXe] FOREIGN KEY([MaLoaiXe])
REFERENCES [LoaiXe] ([MaLoaiXe])
GO
ALTER TABLE [XeTai] CHECK CONSTRAINT [FK_XeTai_LoaiXe]
GO
