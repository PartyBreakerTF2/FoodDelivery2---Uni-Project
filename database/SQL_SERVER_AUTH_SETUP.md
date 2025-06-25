# SQL Server Authentication Setup Guide

## Problem Solved
The application was hanging during login/register operations because Windows Authentication requires native libraries (mssql-jdbc_auth.dll) that cause dependency conflicts. This has been fixed by switching to SQL Server Authentication.

## Changes Made

### 1. Updated pom.xml
- ✅ Removed the problematic `mssql-jdbc_auth` dependency
- ✅ Kept the standard SQL Server JDBC driver

### 2. Updated database.properties
- ✅ Changed from Windows Authentication to SQL Server Authentication
- ✅ Set default credentials: username=`foodapp`, password=`FoodApp123!`
- ✅ Added configuration comments for different scenarios

### 3. Created Setup Scripts
- ✅ `setup-sql-auth.sql` - Creates the database user and permissions
- ✅ `SQLServerAuthTest.java` - Tests the connection without hanging

## Setup Instructions

### Step 1: Run the SQL Server Setup Script
1. Open **SQL Server Management Studio (SSMS)**
2. Connect as administrator (sa or Windows admin)
3. Open and execute `database/setup-sql-auth.sql`
4. This will create:
   - Database: `FoodDeliveryDB`
   - Login: `foodapp` with password `FoodApp123!`
   - Necessary permissions for the application

### Step 2: Enable SQL Server Authentication (if needed)
If you get "Login failed" errors, SQL Server might be in Windows Authentication only mode:

1. Open **SQL Server Management Studio**
2. Right-click your server instance → **Properties**
3. Go to **Security** tab
4. Select **SQL Server and Windows Authentication mode**
5. Click **OK**
6. **Restart SQL Server service**

### Step 3: Test the Connection
Run the connection test to verify everything works:

```bash
# From the project root directory
mvn compile
mvn exec:java -Dexec.mainClass="com.uef.food.test.SQLServerAuthTest"
```

Expected output:
```
✓ SQL Server JDBC Driver loaded successfully
✓ Database connection established successfully!
✓ All tests passed! The connection is working properly.
```

### Step 4: Create the Database Schema
If the connection test passes but shows "No tables found":

1. Open **SQL Server Management Studio**
2. Connect to your server
3. Use database: `FoodDeliveryDB`
4. Open and execute `database/schema.sql`

### Step 5: Start Your Application
Now your Spring application should start without hanging:

```bash
mvn clean package
# Deploy the WAR file to Tomcat or run with embedded server
```

## Troubleshooting

### Connection Issues
- **"TCP/IP connection failed"**: Enable TCP/IP in SQL Server Configuration Manager
- **"Login failed"**: Make sure SQL Server Authentication is enabled and restart the service
- **"Database doesn't exist"**: Run the `setup-sql-auth.sql` script first

### Alternative Configurations

#### If you prefer using 'sa' account:
Update `database.properties`:
```properties
db.username=sa
db.password=your_sa_password
```

#### If using default SQL Server instance (not SQLEXPRESS):
Update `database.properties`:
```properties
db.url=jdbc:sqlserver://localhost:1433;databaseName=FoodDeliveryDB;encrypt=false;trustServerCertificate=true;integratedSecurity=false
```

#### If using a remote SQL Server:
Update `database.properties`:
```properties
db.url=jdbc:sqlserver://your-server-name:1433;databaseName=FoodDeliveryDB;encrypt=false;trustServerCertificate=true;integratedSecurity=false
```

## Security Notes
- The password `FoodApp123!` is for development only
- For production, use a stronger password and consider:
  - Environment variables for credentials
  - Encrypted connection strings
  - Database connection pooling limits
  - Regular password rotation

## Next Steps
1. ✅ Run the setup script
2. ✅ Test the connection 
3. ✅ Create the database schema
4. ✅ Start your application
5. 🔄 Test all CRUD operations (users, restaurants, orders)
6. 🔄 Verify login/register functionality works without hanging
