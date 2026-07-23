-- ============================================================
-- HRDesk Database Schema
-- Database: hrdesk_db
-- ============================================================

CREATE DATABASE IF NOT EXISTS hrdesk_db;

USE hrdesk_db;

-- ============================================================
-- 1. departments table
--    Referenced by: employees.dept_id
-- ============================================================
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(200) DEFAULT NULL
);

-- ============================================================
-- 2. employees table
--    Columns: role, designation, and all employee data
-- ============================================================
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) DEFAULT NULL,
    gender ENUM('MALE','FEMALE','OTHER') DEFAULT NULL,
    dob DATE DEFAULT NULL,
    hire_date DATE DEFAULT NULL,
    salary DECIMAL(10, 2) DEFAULT 0.00,
    dept_id INT DEFAULT NULL,
    designation VARCHAR(100) DEFAULT NULL,
    role ENUM('ADMIN','EMPLOYEE') DEFAULT 'EMPLOYEE',
    password_hash VARCHAR(255) DEFAULT NULL,
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    qr_code VARCHAR(255) DEFAULT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments (dept_id) ON DELETE SET NULL
);

-- ============================================================
-- 3. attendance table
--    Unique key on (emp_id, date) for ON DUPLICATE KEY UPDATE
-- ============================================================
DROP TABLE IF EXISTS attendance;

CREATE TABLE attendance (
    att_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    date DATE NOT NULL,
    status ENUM('PRESENT','ABSENT','HALF_DAY','LEAVE') DEFAULT 'PRESENT',
    check_in TIME DEFAULT NULL,
    check_out TIME DEFAULT NULL,
    UNIQUE KEY uk_emp_date (emp_id, date),
    FOREIGN KEY (emp_id) REFERENCES employees (emp_id) ON DELETE CASCADE
);

-- ============================================================
-- 4. leave_requests table
-- ============================================================
DROP TABLE IF EXISTS leave_requests;

CREATE TABLE leave_requests (
    leave_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    leave_type ENUM('SICK','CASUAL','EARNED','OTHER') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason TEXT DEFAULT NULL,
    status ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_id) REFERENCES employees (emp_id) ON DELETE CASCADE
);

-- ============================================================
-- 5. payroll table
-- ============================================================
DROP TABLE IF EXISTS payroll;

CREATE TABLE payroll (
    payroll_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    month_year VARCHAR(10) NOT NULL,
    basic_salary DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    leave_deductions DECIMAL(10, 2) DEFAULT 0.00,
    bonus DECIMAL(10, 2) DEFAULT 0.00,
    net_salary DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_id) REFERENCES employees (emp_id) ON DELETE CASCADE
);

-- ============================================================
-- 6. support_tokens table
-- ============================================================
DROP TABLE IF EXISTS support_tokens;

CREATE TABLE support_tokens (
    token_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT DEFAULT NULL,
    category ENUM('HARDWARE','SOFTWARE','NETWORK','ACCESSORY','OTHER') DEFAULT NULL,
    priority ENUM('LOW','MEDIUM','HIGH','URGENT') DEFAULT 'MEDIUM',
    status ENUM('OPEN','IN_PROGRESS','RESOLVED','CLOSED') NOT NULL DEFAULT 'OPEN',
    assigned_to INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees (emp_id) ON DELETE CASCADE
);

-- ============================================================
-- SEED DATA
-- ============================================================

-- Default departments
INSERT INTO
    departments (dept_name, location)
VALUES ('Engineering', 'Bangalore'),
    ('Human Resources', 'Mumbai'),
    ('Marketing', 'Pune'),
    ('Sales', 'Delhi'),
    ('Finance', 'Bangalore');

-- Default admin user (password: admin123)
-- You can change the password after first login.
-- Password hash is generated using a simple SHA-256 (in plain app logic).
-- For production, use a proper password hashing library.
INSERT INTO
    employees (
        full_name,
        email,
        phone,
        gender,
        dob,
        hire_date,
        salary,
        dept_id,
        designation,
        role,
        password_hash,
        status
    )
VALUES (
        'Admin User',
        'admin@hrdesk.com',
        '9999999999',
        'MALE',
        '1990-01-01',
        '2024-01-01',
        100000.00,
        1,
        'System Administrator',
        'ADMIN',
        'admin123',
        'ACTIVE'
    );