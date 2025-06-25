-- Add delivery_fee and min_order_amount columns to restaurants table
-- Run this script in SQL Server Management Studio (SSMS)

USE FoodDeliveryDB;
GO

-- Add delivery_fee column if it doesn't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'restaurants' AND COLUMN_NAME = 'delivery_fee')
BEGIN
    ALTER TABLE restaurants ADD delivery_fee DECIMAL(10,2) DEFAULT 2.99;
    PRINT 'Added delivery_fee column to restaurants table';
END
ELSE
BEGIN
    PRINT 'delivery_fee column already exists in restaurants table';
END
GO

-- Add min_order_amount column if it doesn't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'restaurants' AND COLUMN_NAME = 'min_order_amount')
BEGIN
    ALTER TABLE restaurants ADD min_order_amount DECIMAL(10,2) DEFAULT 15.00;
    PRINT 'Added min_order_amount column to restaurants table';
END
ELSE
BEGIN
    PRINT 'min_order_amount column already exists in restaurants table';
END
GO

-- Update existing restaurants with default values (if any exist with NULL values)
UPDATE restaurants 
SET delivery_fee = 2.99 
WHERE delivery_fee IS NULL;

UPDATE restaurants 
SET min_order_amount = 15.00 
WHERE min_order_amount IS NULL;

PRINT 'Updated existing restaurants with default delivery_fee and min_order_amount values';
GO

-- Optional: View the updated table structure
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'restaurants'
ORDER BY ORDINAL_POSITION;
GO
