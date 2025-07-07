-- Create Database
CREATE DATABASE IF NOT EXISTS hotspot_manager;
USE hotspot_manager;

-- Organizations Table
CREATE TABLE organizations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    business_type VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL,
    subscription_plan ENUM('basic', 'premium', 'enterprise') DEFAULT 'basic',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    organization_id INT NOT NULL,
    role ENUM('admin', 'user') DEFAULT 'user',
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (organization_id) REFERENCES organizations(id) ON DELETE CASCADE
);

-- Routers Table
CREATE TABLE routers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    port INT DEFAULT 8728,
    organization_id INT NOT NULL,
    status ENUM('active', 'inactive', 'error') DEFAULT 'inactive',
    location VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (organization_id) REFERENCES organizations(id) ON DELETE CASCADE
);

-- Packages Table
CREATE TABLE packages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    duration VARCHAR(50) NOT NULL, -- e.g., '1h', '24h', '7d', '30d'
    speed_limit VARCHAR(50), -- e.g., '1M/1M', '5M/5M'
    data_limit VARCHAR(50), -- e.g., '1GB', '5GB', 'unlimited'
    organization_id INT NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (organization_id) REFERENCES organizations(id) ON DELETE CASCADE
);

-- Vouchers Table
CREATE TABLE vouchers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL,
    package_id INT NOT NULL,
    router_id INT NOT NULL,
    organization_id INT NOT NULL,
    status ENUM('unused', 'active', 'expired', 'disabled') DEFAULT 'unused',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL,
    used_at TIMESTAMP NULL,
    FOREIGN KEY (package_id) REFERENCES packages(id) ON DELETE CASCADE,
    FOREIGN KEY (router_id) REFERENCES routers(id) ON DELETE CASCADE,
    FOREIGN KEY (organization_id) REFERENCES organizations(id) ON DELETE CASCADE,
    UNIQUE KEY unique_username_router (username, router_id)
);

-- User Sessions Table (for tracking active connections)
CREATE TABLE user_sessions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    voucher_id INT NOT NULL,
    ip_address VARCHAR(45),
    mac_address VARCHAR(17),
    bytes_in BIGINT DEFAULT 0,
    bytes_out BIGINT DEFAULT 0,
    session_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    session_end TIMESTAMP NULL,
    status ENUM('active', 'terminated') DEFAULT 'active',
    FOREIGN KEY (voucher_id) REFERENCES vouchers(id) ON DELETE CASCADE
);

-- Revenue Tracking Table
CREATE TABLE revenue (
    id INT PRIMARY KEY AUTO_INCREMENT,
    organization_id INT NOT NULL,
    voucher_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (organization_id) REFERENCES organizations(id) ON DELETE CASCADE,
    FOREIGN KEY (voucher_id) REFERENCES vouchers(id) ON DELETE CASCADE
);

-- Indexes for better performance
CREATE INDEX idx_users_org ON users(organization_id);
CREATE INDEX idx_routers_org ON routers(organization_id);
CREATE INDEX idx_packages_org ON packages(organization_id);
CREATE INDEX idx_vouchers_org ON vouchers(organization_id);
CREATE INDEX idx_vouchers_status ON vouchers(status);
CREATE INDEX idx_vouchers_router ON vouchers(router_id);
CREATE INDEX idx_sessions_voucher ON user_sessions(voucher_id);
CREATE INDEX idx_revenue_org ON revenue(organization_id);

-- Insert sample data
INSERT INTO organizations (name, business_type, address, phone, email) VALUES
('Demo Cafe', 'Restaurant', '123 Main Street, City', '+1234567890', 'demo@cafe.com');

INSERT INTO users (email, password, name, organization_id, role) VALUES
('admin@demo.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Demo Admin', 1, 'admin');

INSERT INTO packages (name, price, duration, speed_limit, data_limit, organization_id) VALUES
('1 Hour Basic', 1.00, '1h', '1M/1M', '500MB', 1),
('4 Hours Premium', 3.00, '4h', '2M/2M', '2GB', 1),
('24 Hours Unlimited', 5.00, '24h', '5M/5M', 'unlimited', 1);
