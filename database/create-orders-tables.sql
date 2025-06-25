-- Script to create Orders and Order Items tables
-- Run this script in SQL Server Management Studio (SSMS)

USE FoodDeliveryDB;
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
    menu_item_id BIGINT,
    menu_item_name NVARCHAR(100) NOT NULL,
    menu_item_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    subtotal DECIMAL(10,2) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);
GO

-- Create indexes for better performance
CREATE INDEX idx_orders_customer ON orders(customer_id);
GO
CREATE INDEX idx_orders_restaurant ON orders(restaurant_id);
GO
CREATE INDEX idx_orders_status ON orders(status);
GO
CREATE INDEX idx_order_items_order ON order_items(order_id);
GO

PRINT 'Orders and Order Items tables created successfully!';
GO
