-- SQL Server Connection Testing Script
-- This script helps test different connection scenarios

-- 1. Check SQL Server Instance Names and Versions
SELECT 
    @@SERVERNAME AS ServerName,
    @@VERSION AS Version,
    SERVERPROPERTY('InstanceName') AS InstanceName,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductLevel') AS ProductLevel,
    SERVERPROPERTY('ProductVersion') AS ProductVersion;

-- 2. Check if FoodDeliveryDB database exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'FoodDeliveryDB')
BEGIN
    PRINT 'FoodDeliveryDB database EXISTS'
    USE FoodDeliveryDB
    
    -- Check if tables exist
    SELECT 
        table_name,
        table_type
    FROM INFORMATION_SCHEMA.TABLES
    WHERE table_type = 'BASE TABLE'
    ORDER BY table_name;
    
    -- Check table row counts
    SELECT 
        'Users' as TableName, COUNT(*) as RowCount FROM Users
    UNION ALL
    SELECT 
        'Restaurants' as TableName, COUNT(*) as RowCount FROM Restaurants
    UNION ALL
    SELECT 
        'MenuItems' as TableName, COUNT(*) as RowCount FROM MenuItems
    UNION ALL
    SELECT 
        'Orders' as TableName, COUNT(*) as RowCount FROM Orders
    UNION ALL
    SELECT 
        'OrderItems' as TableName, COUNT(*) as RowCount FROM OrderItems;
END
ELSE
BEGIN
    PRINT 'FoodDeliveryDB database DOES NOT EXIST'
    PRINT 'Please run the schema.sql script first to create the database'
END

-- 3. Check Authentication Mode
SELECT 
    CASE SERVERPROPERTY('IsIntegratedSecurityOnly')
        WHEN 1 THEN 'Windows Authentication Only'
        WHEN 0 THEN 'Mixed Mode (Windows + SQL Server Authentication)'
    END AS AuthenticationMode;

-- 4. Check TCP/IP Protocol Status (run this in SQL Server Configuration Manager)
-- This query shows network protocols but you need to check SQL Server Configuration Manager
-- for TCP/IP protocol status

-- 5. Check current user and permissions
SELECT 
    SYSTEM_USER AS CurrentUser,
    USER_NAME() AS DatabaseUser,
    IS_SRVROLEMEMBER('sysadmin') AS IsSysAdmin;

-- 6. Test connection parameters that Java application will use
PRINT 'Current Connection Details:'
PRINT 'Server: ' + @@SERVERNAME
PRINT 'Database: ' + DB_NAME()
PRINT 'User: ' + SYSTEM_USER
