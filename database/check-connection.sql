-- Test SQL Server Connection
-- Run this in SSMS to check your current setup

-- 1. Check if FoodDeliveryDB exists
SELECT name FROM sys.databases WHERE name = 'FoodDeliveryDB';

-- 2. Check SQL Server version and instance
SELECT @@VERSION;

-- 3. Check current server configuration
SELECT 
    SERVERPROPERTY('ServerName') AS ServerName,
    SERVERPROPERTY('InstanceName') AS InstanceName,
    SERVERPROPERTY('IsClustered') AS IsClustered,
    SERVERPROPERTY('MachineName') AS MachineName;

-- 4. Check TCP/IP port (should be 1433)
EXEC xp_readerrorlog 0, 1, N'Server is listening on';

-- 5. Check authentication mode (should allow SQL Server authentication)
SELECT CASE SERVERPROPERTY('IsIntegratedSecurityOnly')
    WHEN 1 THEN 'Windows Authentication'
    WHEN 0 THEN 'SQL Server and Windows Authentication mode'
END AS AuthenticationMode;

-- 6. Check if 'sa' user exists and is enabled
SELECT 
    name,
    is_disabled,
    is_policy_checked,
    is_expiration_checked
FROM sys.sql_logins 
WHERE name = 'sa';
