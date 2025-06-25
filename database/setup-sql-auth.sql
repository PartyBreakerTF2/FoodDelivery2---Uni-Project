-- ================================================
-- SQL Server Authentication Setup Script
-- ================================================
-- This script creates a dedicated user for the Food Delivery application
-- Run this as a SQL Server administrator (sa or Windows admin)

-- Enable SQL Server Authentication (Mixed Mode)
-- Note: This might require SQL Server restart
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', 
    N'Software\Microsoft\MSSQLServer\MSSQLServer', 
    N'LoginMode', REG_DWORD, 2;

-- Create database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'FoodDeliveryDB')
BEGIN
    CREATE DATABASE FoodDeliveryDB;
    PRINT 'Database FoodDeliveryDB created successfully.';
END
ELSE
BEGIN
    PRINT 'Database FoodDeliveryDB already exists.';
END

-- Use the FoodDeliveryDB database
USE FoodDeliveryDB;

-- Create login for the application
IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'foodapp')
BEGIN
    CREATE LOGIN foodapp WITH PASSWORD = 'FoodApp123!';
    PRINT 'Login foodapp created successfully.';
END
ELSE
BEGIN
    PRINT 'Login foodapp already exists.';
END

-- Create user in the database
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'foodapp')
BEGIN
    CREATE USER foodapp FOR LOGIN foodapp;
    PRINT 'User foodapp created successfully.';
END
ELSE
BEGIN
    PRINT 'User foodapp already exists.';
END

-- Grant necessary permissions
ALTER ROLE db_datareader ADD MEMBER foodapp;
ALTER ROLE db_datawriter ADD MEMBER foodapp;
ALTER ROLE db_ddladmin ADD MEMBER foodapp;

PRINT 'Permissions granted to foodapp user.';

-- Test the connection
SELECT 'SQL Server Authentication setup completed successfully!' AS Status;

-- Display connection information
SELECT 
    'Server: localhost\SQLEXPRESS' AS ServerInfo,
    'Database: FoodDeliveryDB' AS DatabaseInfo,
    'Username: foodapp' AS UsernameInfo,
    'Password: FoodApp123!' AS PasswordInfo;

PRINT '================================================';
PRINT 'SETUP COMPLETE!';
PRINT 'You can now use these credentials in your Java application:';
PRINT 'URL: jdbc:sqlserver://localhost\SQLEXPRESS;databaseName=FoodDeliveryDB;encrypt=false;trustServerCertificate=true;integratedSecurity=false';
PRINT 'Username: foodapp';
PRINT 'Password: FoodApp123!';
PRINT '================================================';
