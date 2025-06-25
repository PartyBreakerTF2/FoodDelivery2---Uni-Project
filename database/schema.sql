-- Food Delivery Database Schema for SQL Server
-- Run this script in SQL Server Management Studio (SSMS)

-- Create Database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'FoodDeliveryDB')
BEGIN
    CREATE DATABASE FoodDeliveryDB;
END
GO

USE FoodDeliveryDB;
GO

-- Create Users table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U')
CREATE TABLE users (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    full_name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    address NVARCHAR(255),
    role NVARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'CUSTOMER', 'RESTAURANT_STAFF')),
    restaurant_id BIGINT NULL, -- For RESTAURANT_STAFF role - which restaurant they work at
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

-- Create Restaurants table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='restaurants' AND xtype='U')
CREATE TABLE restaurants (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    address NVARCHAR(255) NOT NULL,
    phone NVARCHAR(20),
    email NVARCHAR(100),
    cuisine_type NVARCHAR(50),
    delivery_fee DECIMAL(10,2) DEFAULT 2.99,
    min_order_amount DECIMAL(10,2) DEFAULT 15.00,
    is_active BIT DEFAULT 1,
    rating DECIMAL(3,2) DEFAULT 0.0,
    owner_id BIGINT,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (owner_id) REFERENCES users(id)
);
GO

-- Create Menu Items table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='menu_items' AND xtype='U')
CREATE TABLE menu_items (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    price DECIMAL(10,2) NOT NULL,
    category NVARCHAR(50),
    image_url NVARCHAR(255),
    is_available BIT DEFAULT 1,
    restaurant_id BIGINT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);
GO

-- Create Orders table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='orders' AND xtype='U')
CREATE TABLE orders (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    restaurant_id BIGINT NOT NULL,
    status NVARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'CONFIRMED', 'PREPARING', 'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED')),
    total_amount DECIMAL(10,2) NOT NULL,
    delivery_address NVARCHAR(255) NOT NULL,
    special_instructions NVARCHAR(500),
    order_date DATETIME2 DEFAULT GETDATE(),
    delivery_date DATETIME2,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES users(id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);
GO

-- Create Order Items table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='order_items' AND xtype='U')
CREATE TABLE order_items (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id BIGINT NOT NULL,
    menu_item_id BIGINT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
);
GO

-- Insert sample data
-- Sample Users
INSERT INTO users (username, password, email, full_name, phone, address, role) VALUES 
('admin', 'admin123', 'admin@fooddelivery.com', 'System Administrator', '1234567890', '123 Admin St', 'ADMIN'),
('customer', 'customer123', 'customer@example.com', 'John Doe', '0987654321', '456 Customer Ave', 'CUSTOMER'),
('staff', 'staff123', 'staff@restaurant.com', 'Jane Smith', '1122334455', '789 Restaurant Rd', 'RESTAURANT_STAFF');
GO

-- Sample Restaurants
INSERT INTO restaurants (name, description, address, phone, email, cuisine_type, owner_id) VALUES 
('Pizza Palace', 'Best pizzas in town with fresh ingredients', '123 Pizza St', '111-222-3333', 'info@pizzapalace.com', 'Italian', 3),
('Burger House', 'Gourmet burgers and fast service', '456 Burger Ave', '444-555-6666', 'contact@burgerhouse.com', 'American', 3),
('Sushi Corner', 'Fresh sushi and Japanese cuisine', '789 Sushi Blvd', '777-888-9999', 'hello@sushicorner.com', 'Japanese', 3);
GO

-- Sample Menu Items
INSERT INTO menu_items (name, description, price, category, restaurant_id) VALUES 
-- Pizza Palace Menu
('Margherita Pizza', 'Classic pizza with tomato sauce, mozzarella, and basil', 15.99, 'Pizza', 1),
('Pepperoni Pizza', 'Delicious pizza with pepperoni and cheese', 17.99, 'Pizza', 1),
('Caesar Salad', 'Fresh romaine lettuce with caesar dressing', 9.99, 'Salad', 1),

-- Burger House Menu
('Classic Burger', 'Beef patty with lettuce, tomato, and special sauce', 12.99, 'Burger', 2),
('Chicken Burger', 'Grilled chicken breast with fresh vegetables', 11.99, 'Burger', 2),
('French Fries', 'Crispy golden fries', 4.99, 'Sides', 2),

-- Sushi Corner Menu
('California Roll', 'Crab, avocado, and cucumber roll', 8.99, 'Sushi', 3),
('Salmon Nigiri', 'Fresh salmon over sushi rice', 6.99, 'Sushi', 3),
('Miso Soup', 'Traditional Japanese soup', 3.99, 'Soup', 3);
GO

-- Create indexes for better performance
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_restaurant ON users(restaurant_id);
CREATE INDEX idx_restaurants_owner ON restaurants(owner_id);
CREATE INDEX idx_menu_items_restaurant ON menu_items(restaurant_id);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_restaurant ON orders(restaurant_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_menu_item ON order_items(menu_item_id);
GO

-- Add foreign key constraints
-- Note: FK constraint for users.restaurant_id -> restaurants.id should be added after restaurants table is created
IF EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U') AND 
   EXISTS (SELECT * FROM sysobjects WHERE name='restaurants' AND xtype='U')
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_users_restaurant_id')
    BEGIN
        ALTER TABLE users ADD CONSTRAINT FK_users_restaurant_id 
        FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
    END
END
GO

PRINT 'Database schema created successfully!';
GO
