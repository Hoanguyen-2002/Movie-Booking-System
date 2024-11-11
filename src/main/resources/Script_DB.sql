-- Xóa database nếu đã tồn tại và tạo mới
DROP DATABASE IF EXISTS MovieBookingSystem;
CREATE DATABASE MovieBookingSystem;
USE MovieBookingSystem;

-- Bảng Users (Người dùng và Admin)
CREATE TABLE Users (
    id CHAR(36) PRIMARY KEY,  -- Sử dụng UUID cho khóa chính
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('USER', 'ADMIN') DEFAULT 'USER',  -- Phân biệt người dùng và admin
    is_verified BOOLEAN DEFAULT FALSE,  -- Trạng thái xác thực email (OTP lưu trong Redis)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Bảng Movies (Phim)
CREATE TABLE Movies (
    id CHAR(36) PRIMARY KEY,  -- Sử dụng UUID
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(255),
    duration INT,  -- Thời lượng phim tính bằng phút
    release_date DATE,
    rating FLOAT DEFAULT 0.0,  -- Đánh giá trung bình
    cover_image_url VARCHAR(255),  -- URL ảnh bìa của phim
    created_by CHAR(36),  -- ID của admin tạo phim
    updated_by CHAR(36),  -- ID của admin cập nhật phim
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(id) ON DELETE SET NULL,
    FOREIGN KEY (updated_by) REFERENCES Users(id) ON DELETE SET NULL
);

-- Bảng Theaters (Rạp chiếu phim)
CREATE TABLE Theaters (
    id CHAR(36) PRIMARY KEY,  -- Sử dụng UUID
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Bảng Schedules (Lịch chiếu)
CREATE TABLE Schedules (
    id CHAR(36) PRIMARY KEY,  -- Sử dụng UUID
    movie_id CHAR(36) NOT NULL,
    theater_id CHAR(36) NOT NULL,
    show_time DATETIME NOT NULL,
    available_seats INT NOT NULL,
    created_by CHAR(36),  -- ID của admin tạo lịch chiếu
    updated_by CHAR(36),  -- ID của admin cập nhật lịch chiếu
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (movie_id) REFERENCES Movies(id) ON DELETE CASCADE,
    FOREIGN KEY (theater_id) REFERENCES Theaters(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES Users(id) ON DELETE SET NULL,
    FOREIGN KEY (updated_by) REFERENCES Users(id) ON DELETE SET NULL
);

-- Bảng Seats (Ghế ngồi)
CREATE TABLE Seats (
    id CHAR(36) PRIMARY KEY,  -- Sử dụng UUID
    theater_id CHAR(36) NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    is_booked BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (theater_id) REFERENCES Theaters(id) ON DELETE CASCADE
);

-- Bảng Tickets (Vé)
CREATE TABLE Tickets (
    id CHAR(36) PRIMARY KEY,  -- Sử dụng UUID
    user_id CHAR(36) NOT NULL,
    schedule_id CHAR(36) NOT NULL,
    seat_id CHAR(36) NOT NULL,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2) NOT NULL,  -- Tổng giá trị vé
    created_by CHAR(36),  -- ID của admin tạo vé (nếu có)
    updated_by CHAR(36),  -- ID của admin cập nhật vé (nếu có)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (schedule_id) REFERENCES Schedules(id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES Seats(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES Users(id) ON DELETE SET NULL,
    FOREIGN KEY (updated_by) REFERENCES Users(id) ON DELETE SET NULL
);

-- Bảng Discounts (Giảm giá)
CREATE TABLE Discounts (
    id CHAR(36) PRIMARY KEY,  -- Sử dụng UUID
    code VARCHAR(50) UNIQUE NOT NULL,  -- Mã giảm giá duy nhất
    percentage FLOAT NOT NULL,  -- Phần trăm giảm giá
    expiry_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,  -- Trạng thái hoạt động của mã giảm giá
    created_by CHAR(36),  -- ID của admin tạo mã giảm giá
    updated_by CHAR(36),  -- ID của admin cập nhật mã giảm giá
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(id) ON DELETE SET NULL,
    FOREIGN KEY (updated_by) REFERENCES Users(id) ON DELETE SET NULL
);

-- Bảng TicketDiscounts (Liên kết giữa Tickets và Discounts)
CREATE TABLE TicketDiscounts (
    ticket_id CHAR(36) NOT NULL,
    discount_id CHAR(36) NOT NULL,
    PRIMARY KEY (ticket_id, discount_id),
    FOREIGN KEY (ticket_id) REFERENCES Tickets(id) ON DELETE CASCADE,
    FOREIGN KEY (discount_id) REFERENCES Discounts(id) ON DELETE CASCADE
);

-- Bảng Reviews (Đánh giá phim)
CREATE TABLE Reviews (
    id CHAR(36) PRIMARY KEY,  -- Sử dụng UUID
    movie_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),  -- Điểm đánh giá từ 1 đến 5
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (movie_id) REFERENCES Movies(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

-- Bảng Notifications (Thông báo)
CREATE TABLE Notifications (
    id CHAR(36) PRIMARY KEY,  -- Sử dụng UUID
    user_id CHAR(36) NOT NULL,
    message TEXT NOT NULL,  -- Nội dung thông báo
    type VARCHAR(50),  -- Loại thông báo (ví dụ: xác nhận vé, nhắc nhở)
    is_read BOOLEAN DEFAULT FALSE,  -- Trạng thái đã đọc
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);
