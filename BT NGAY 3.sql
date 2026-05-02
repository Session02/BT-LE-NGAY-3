CREATE DATABASE cinema_management;
USE cinema_management;

-- Bảng movies
CREATE TABLE movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    duration_minutes INT NOT NULL,
    age_restriction INT DEFAULT 0 CHECK (age_restriction IN (0, 13, 16, 18))
);

-- Bảng rooms
CREATE TABLE rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    max_seats INT NOT NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'maintenance'))
);

-- Bảng showtimes
CREATE TABLE showtimes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    room_id INT NOT NULL,
    show_time DATETIME NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL CHECK (ticket_price >= 0),
    
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    FOREIGN KEY (room_id) REFERENCES rooms(id)
);

-- Bảng bookings
CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    showtime_id INT NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (showtime_id) REFERENCES showtimes(id)
);

-- Thêm 4 phim (có 1 phim 18+)
INSERT INTO movies (title, duration_minutes, age_restriction) VALUES
('Avengers: Secret Wars', 150, 13),
('Inside Out 2', 100, 0),
('The Conjuring 4', 120, 18), -- phim 18+
('Dune: Part Two', 165, 13);

-- Thêm 3 phòng (1 phòng bảo trì)
INSERT INTO rooms (name, max_seats, status) VALUES
('Room 1', 100, 'active'),
('Room 2', 80, 'active'),
('Room 3', 120, 'maintenance'); -- phòng bảo trì

-- Thêm 5 lịch chiếu (KHÔNG dùng Room 3)
INSERT INTO showtimes (movie_id, room_id, show_time, ticket_price) VALUES
(1, 1, '2026-05-02 09:00:00', 75000),
(2, 1, '2026-05-02 13:00:00', 70000),
(3, 2, '2026-05-02 18:00:00', 90000), -- phim 18+
(4, 2, '2026-05-02 21:00:00', 85000),
(1, 1, '2026-05-03 10:00:00', 75000);

-- Thêm 10 vé đặt (rải rác các lịch chiếu)
INSERT INTO bookings (showtime_id, customer_name, phone) VALUES
(1, 'Nguyen Van A', '0900000001'),
(1, 'Tran Thi B', '0900000002'),
(2, 'Le Van C', '0900000003'),
(2, 'Pham Thi D', '0900000004'),
(3, 'Hoang Van E', '0900000005'),
(3, 'Vo Thi F', '0900000006'),
(4, 'Dang Van G', '0900000007'),
(4, 'Bui Thi H', '0900000008'),
(5, 'Do Van I', '0900000009'),
(5, 'Nguyen Thi K', '0900000010');

SET SQL_SAFE_UPDATES = 0;
-- 1. Chuyển trạng thái phòng 1 sang bảo trì
UPDATE rooms
SET status = 'maintenance'
WHERE id = 1;

-- 2. Chuyển toàn bộ lịch chiếu từ phòng 1 sang phòng 2
UPDATE showtimes
SET room_id = 2
WHERE room_id = 1;

-- 3. Hủy toàn bộ vé của khách có số điện thoại 0987654321
DELETE FROM bookings
WHERE phone = '0987654321';

-- 4. Gỡ bỏ phim có id = 3 (tránh lỗi FK bằng cách xóa theo thứ tự)

-- Xóa booking liên quan đến các lịch chiếu của phim 3
DELETE FROM bookings
WHERE showtime_id IN (
    SELECT id FROM showtimes WHERE movie_id = 3
);

-- Xóa các lịch chiếu của phim 3
DELETE FROM showtimes
WHERE movie_id = 3;

-- Cuối cùng xóa phim
DELETE FROM movies
WHERE id = 3;