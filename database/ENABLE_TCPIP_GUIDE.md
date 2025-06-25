# SQL Server TCP/IP Configuration Guide

## Current Status ✅
- ✅ **Windows Authentication hanging issue RESOLVED** - Switched to SQL Server Authentication
- ✅ **SQL Server service is running** - MSSQLSERVER is active
- ✅ **Connection test runs without hanging** - No more blocking issues
- ❌ **TCP/IP protocol is disabled** - Need to enable TCP/IP connections

## Next Steps to Complete Setup

### Step 1: Enable TCP/IP Protocol
1. **Open SQL Server Configuration Manager**
   - Press `Win + R`, type `SQLServerManager15.msc` (for SQL Server 2019)
   - Or search for "SQL Server Configuration Manager" in Start menu

2. **Enable TCP/IP**
   - Expand "SQL Server Network Configuration"
   - Click "Protocols for MSSQLSERVER"
   - Right-click "TCP/IP" → **Properties**
   - Set "Enabled" to **Yes**
   - Go to "IP Addresses" tab
   - Scroll to "IPAll" section at bottom
   - Set "TCP Port" to **1433**
   - Click **OK**

3. **Restart SQL Server**
   ```powershell
   Restart-Service MSSQLSERVER
   ```

### Step 2: Create Database and User
After enabling TCP/IP, run this in **SQL Server Management Studio (SSMS)**:

1. **Connect to SQL Server**
   - Server: `localhost` or `.`  
   - Authentication: Windows Authentication

2. **Execute setup script**
   - Open `database/setup-sql-auth.sql`
   - Execute the entire script
   - This creates the database, user, and permissions

### Step 3: Test Connection Again
```powershell
java -cp "target/classes;target/test-classes;target/FoodDelivery2-V1/WEB-INF/lib/*" com.uef.food.test.SQLServerAuthTest
```

Expected output after successful setup:
```
✓ SQL Server JDBC Driver loaded successfully
✓ Database connection established successfully!
✓ All tests passed! The connection is working properly.
```

### Step 4: Create Database Schema
If connection works but "No tables found":
1. Open SSMS
2. Connect to your server
3. Use database: `FoodDeliveryDB`
4. Execute `database/schema.sql`

### Step 5: Test Your Application
```powershell
mvn clean package
# Deploy WAR file to Tomcat or test with embedded server
```

## Alternative: Use H2 Database for Testing

If SQL Server setup is taking too long, you can temporarily use H2 database:

**Update `database.properties`:**
```properties
# H2 Database (for quick testing)
db.driver=org.h2.Driver
db.url=jdbc:h2:mem:fooddelivery;DB_CLOSE_DELAY=-1;DATABASE_TO_UPPER=false
db.username=sa
db.password=
```

The H2 database will work immediately without any setup, but data will be lost when the application stops.

## Troubleshooting

### If SQL Server Configuration Manager is not found:
- SQL Server 2022: `SQLServerManager16.msc`
- SQL Server 2019: `SQLServerManager15.msc`
- SQL Server 2017: `SQLServerManager14.msc`
- SQL Server 2016: `SQLServerManager13.msc`

### If TCP/IP is already enabled but connection fails:
1. Check Windows Firewall
2. Verify SQL Server is listening: `netstat -an | findstr 1433`
3. Try connecting with SSMS first

### If you get "Login failed" after enabling TCP/IP:
- The `foodapp` user doesn't exist yet
- Run the `setup-sql-auth.sql` script first

## Summary
🎯 **Main Achievement**: Fixed the hanging issue by removing Windows Authentication dependencies!

🔄 **Current Step**: Enable TCP/IP protocol in SQL Server Configuration Manager

⏭️ **Next**: Create database and test full application functionality
