-- Script to add restaurant_id column to existing users table
-- Run this script in SQL Server Management Studio (SSMS) if your database was created before this change

USE FoodDeliveryDB;
GO

-- Check if restaurant_id column exists, if not add it
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'restaurant_id')
BEGIN
    ALTER TABLE users ADD restaurant_id BIGINT NULL;
    PRINT 'Added restaurant_id column to users table';
END
ELSE
BEGIN
    PRINT 'restaurant_id column already exists in users table';
END
GO

-- Create index on restaurant_id if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_users_restaurant')
BEGIN
    CREATE INDEX idx_users_restaurant ON users(restaurant_id);
    PRINT 'Created index on users.restaurant_id';
END
ELSE
BEGIN
    PRINT 'Index on users.restaurant_id already exists';
END
GO

-- Add foreign key constraint if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_users_restaurant_id')
BEGIN
    -- Only add FK if both tables exist
    IF EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U') AND 
       EXISTS (SELECT * FROM sysobjects WHERE name='restaurants' AND xtype='U')
    BEGIN
        ALTER TABLE users ADD CONSTRAINT FK_users_restaurant_id 
        FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
        PRINT 'Added foreign key constraint FK_users_restaurant_id';
    END
    ELSE
    BEGIN
        PRINT 'Cannot add FK constraint - one of the tables is missing';
    END
END
ELSE
BEGIN
    PRINT 'Foreign key constraint FK_users_restaurant_id already exists';
END
GO

-- Update sample restaurant staff user to be assigned to restaurant 1 (if exists)
IF EXISTS (SELECT * FROM users WHERE username = 'staff' AND role = 'RESTAURANT_STAFF')
BEGIN
    UPDATE users SET restaurant_id = 1 WHERE username = 'staff' AND role = 'RESTAURANT_STAFF';
    PRINT 'Assigned sample staff user to restaurant 1';
END
GO

PRINT 'Database schema migration completed successfully!';
GO
