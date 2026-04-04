-- Community Complaint System Database Schema
-- Run this in your MySQL Workbench to ensure everything matches the code perfectly.

USE complaint_system;

-- -------------------------------------------------------------------------
-- STEP 1: RESET TABLES (MANUAL ORDER)
-- -------------------------------------------------------------------------
-- If the script fails, run these lines ONE BY ONE in this exact order:

-- First, drop the tables that reference others (the "children")
DROP TABLE IF EXISTS complaints;
DROP TABLE IF EXISTS feedback;

-- Then, drop the tables that ARE referenced (the "parents")
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS admins;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS departments;

-- -------------------------------------------------------------------------
-- STEP 2: CREATE TABLES
-- -------------------------------------------------------------------------

-- 2. Create Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Create Admins table
CREATE TABLE admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Create Categories table
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- 5. Create Complaints table
CREATE TABLE complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    subject VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    status ENUM('Pending', 'In Progress', 'Resolved', 'Rejected') DEFAULT 'Pending',
    resolution_notes TEXT,
    resolved_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- 6. Insert some initial data
INSERT INTO categories (name) VALUES ('Electricity'), ('Water Supply'), ('Roads'), ('Sanitation'), ('Other');

-- 7. Create a default admin (Password is 'admin123' - you should change this later)
INSERT INTO admins (name, email, password) VALUES ('System Admin', 'admin@example.com', 'admin123');
