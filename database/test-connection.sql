-- Test SQL Server Connection Script
-- Run this in SQL Server Management Studio to verify the database is set up

-- Check if database exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'FoodDeliveryDB')
    PRINT 'Database FoodDeliveryDB exists'
ELSE
    PRINT 'Database FoodDeliveryDB does not exist - run schema.sql first'

-- Check SQL Server version
SELECT @@VERSION as 'SQL Server Version'

-- Test basic connectivity
SELECT GETDATE() as 'Current Time', SYSTEM_USER as 'Current User'
