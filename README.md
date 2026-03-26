#  Web Quản Lý Nhân Khẩu (Web-QLNK)

[![Node.js Version](https://img.shields.io/badge/node-%3E%3D%2018.0.0-brightgreen)](https://nodejs.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Dự án Hệ thống quản lý dân cư và phản ánh hiện trường dành cho cấp cơ sở. Hệ thống giúp tối ưu hóa việc quản lý hộ khẩu, nhân khẩu và tương tác giữa người dân với chính quyền địa phương qua nền tảng Web.

---

##  Tính năng nổi bật

###  Quản lý cư trú
* **Hộ khẩu:** Đăng ký mới, tách hộ, chuyển hộ, cập nhật chủ hộ.
* **Nhân khẩu:** Quản lý chi tiết thông tin cá nhân, tiểu sử, tiền án tiền sự (nếu có).
* **Biến động:** Theo dõi tạm trú, tạm vắng, khai báo lưu trú trực tuyến.

###  Phản ánh & Tương tác
* **Gửi phản ánh:** Người dân gửi ý kiến kèm hình ảnh/video về các vấn đề dân sinh.
* **Xử lý phản ánh:** Cán bộ tiếp nhận, phân loại và phản hồi tiến độ xử lý.
* **Thông báo:** Hệ thống tự động gửi thông báo về các thay đổi nhân khẩu hoặc phản hồi mới.

###  Bảo mật & Phân quyền
* **RBAC:** Phân quyền dựa trên vai trò (Admin, Tổ trưởng, Cán bộ xử lý, Người dân).
* **Tự động hóa:** Trigger SQL tự động tạo tài khoản dựa trên CCCD và sinh mã định danh TE cho trẻ em.

---

##  Công nghệ sử dụng

* **Frontend:** React, Tailwind CSS, Lucide Icons.
* **Backend:** Node.js, Express.js.
* **Database:** SQL Server (MSSQL).
* **Authentication:** JSON Web Token (JWT) & Bcrypt password hashing.

---

##  Cấu trúc thư mục Database

Mọi logic nghiệp vụ quan trọng đều được đóng gói trong thư mục `/db-scripts`:
* `qlnkdb.sql`: Chứa cấu trúc bảng, Index và các **Triggers** quan trọng.


---

##  Hướng dẫn cài đặt

### 1. Yêu cầu hệ thống
* Node.js (v18+)
* SQL Server (2019 hoặc mới hơn)

### 2. Thiết lập Database
1. Tạo một database mới tên là `QL_NHAN_KHAU`.
2. Chạy script trong file `db/qlnkdb.sql` để khởi tạo cấu trúc.

### 3. Cài đặt mã nguồn
```bash
# Clone dự án
git clone [https://github.com/manh-git/Web-QLNK.git](https://github.com/manh-git/Web-QLNK.git)

# Vào thư mục dự án
cd Web-QLNK

# Cài đặt dependencies
npm install
```
### 4. Cấu hình biến môi trường
Sao chép file mẫu và điền thông tin của bạn:
```batch
cp .env.example .env
```
Mở file .env và cập nhật thông tin kết nối SQL Server của bạn.
### 5. Khởi chạy
```batch# Chế độ phát triển
npm run dev

# Chế độ Production
npm run build
npm start
```

Tác giả: Manh-git 