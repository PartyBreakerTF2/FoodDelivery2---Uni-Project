# Food Delivery System - Database Setup Guide

## Prerequisites

1. **SQL Server** (Local instance or SQL Server Express)
2. **SQL Server Management Studio (SSMS)**
3. **Java 11 or higher**
4. **Apache Tomcat 10+**
5. **Maven**

## Setup Steps

### 1. SQL Server Configuration

1. **Install SQL Server** (if not already installed)
   - Download SQL Server Express or Developer Edition
   - During installation, enable Mixed Mode Authentication
   - Set SA password to `123456` (or update `database.properties`)

2. **Enable SQL Server Authentication**
   - Open SQL Server Configuration Manager
   - Enable SQL Server and SQL Server Browser services
   - Set SQL Server to start automatically

3. **Test SQL Server Connection**
   - Open SSMS
   - Connect to `localhost` with SA user and password
   - Run the test script: `database/test-connection.sql`

### 2. Database Setup

1. **Create Database and Tables**
   ```sql
   -- Run this script in SSMS
   -- File: database/schema.sql
   ```

2. **Verify Database Creation**
   - Check if `FoodDeliveryDB` database exists
   - Verify tables: users, restaurants, menu_items, orders, order_items
   - Confirm sample data is inserted

### 3. Application Configuration

1. **Update Database Connection** (if needed)
   - Edit `src/main/resources/database.properties`
   - Update username, password, and connection string

2. **Build and Deploy**
   ```bash
   mvn clean package
   # Deploy target/FoodDelivery2-V1.war to Tomcat
   ```

### 4. Troubleshooting

#### Common Issues:

1. **"No suitable driver" Error**
   - Ensure SQL Server JDBC driver is in classpath
   - Check if driver JAR is in WEB-INF/lib

2. **Connection Refused**
   - Verify SQL Server is running
   - Check firewall settings (port 1433)
   - Test with SQL Server Configuration Manager

3. **Authentication Failed**
   - Verify SA account is enabled
   - Check password in database.properties
   - Ensure Mixed Mode Authentication is enabled

4. **Database Not Found**
   - Run the schema.sql script first
   - Verify database name spelling
   - Check if user has database access

### 5. Default Login Credentials

After successful setup, you can login with:

- **Admin**: username: `admin`, password: `admin123`
- **Customer**: username: `customer`, password: `customer123`
- **Restaurant Staff**: username: `staff`, password: `staff123`

### 6. Application URLs

- Login: `http://localhost:8080/FoodDelivery2/login`
- Register: `http://localhost:8080/FoodDelivery2/register`
- Home: `http://localhost:8080/FoodDelivery2/`

## Development Notes

- The application uses Spring JDBC with HikariCP connection pooling
- Database schema includes proper indexes for performance
- Sample data is automatically inserted for testing
- All passwords are stored in plain text (for development only)

## Production Considerations

Before deploying to production:
1. Change all default passwords
2. Implement password hashing
3. Use environment variables for database credentials
4. Enable SSL/TLS for database connections
5. Configure proper backup strategy
6. Set up monitoring and logging
