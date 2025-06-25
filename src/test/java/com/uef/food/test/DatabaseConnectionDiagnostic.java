package com.uef.food.test;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

/**
 * Comprehensive Database Connection Diagnostic Tool
 * This class tests various connection scenarios to help identify the issue
 */
public class DatabaseConnectionDiagnostic {

    public static void main(String[] args) {
        System.out.println("=== Database Connection Diagnostic Tool ===\n");
        
        DatabaseConnectionDiagnostic diagnostic = new DatabaseConnectionDiagnostic();
        
        // Test 1: Load properties file
        diagnostic.testPropertiesFile();
        
        // Test 2: Check JDBC driver
        diagnostic.testJdbcDriver();
        
        // Test 3: Test different connection URLs
        diagnostic.testConnectionScenarios();
        
        // Test 4: Test with/without authentication library
        diagnostic.testAuthenticationLibrary();
        
        System.out.println("\n=== Diagnostic Complete ===");
    }
    
    private void testPropertiesFile() {
        System.out.println("1. Testing Properties File Loading:");
        try {
            Properties props = new Properties();
            InputStream is = getClass().getClassLoader().getResourceAsStream("database.properties");
            if (is != null) {
                props.load(is);
                System.out.println("   ✓ database.properties loaded successfully");
                System.out.println("   Driver: " + props.getProperty("db.driver"));
                System.out.println("   URL: " + props.getProperty("db.url"));
                System.out.println("   Username: [" + props.getProperty("db.username") + "]");
                is.close();
            } else {
                System.out.println("   ✗ database.properties not found");
            }
        } catch (Exception e) {
            System.out.println("   ✗ Error loading properties: " + e.getMessage());
        }
        System.out.println();
    }
    
    private void testJdbcDriver() {
        System.out.println("2. Testing JDBC Driver:");
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            System.out.println("   ✓ SQL Server JDBC driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.out.println("   ✗ SQL Server JDBC driver not found: " + e.getMessage());
        }
        System.out.println();
    }
    
    private void testConnectionScenarios() {
        System.out.println("3. Testing Connection Scenarios:");
        
        // Scenario 1: Windows Authentication with SQLEXPRESS (dynamic port)
        testConnection("SQLEXPRESS Dynamic Port", 
            "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=FoodDeliveryDB;encrypt=false;trustServerCertificate=true;integratedSecurity=true",
            "", "");
        
        // Scenario 2: Windows Authentication with SQLEXPRESS (fixed port 1433)
        testConnection("SQLEXPRESS Fixed Port 1433", 
            "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=FoodDeliveryDB;encrypt=false;trustServerCertificate=true;integratedSecurity=true",
            "", "");
        
        // Scenario 3: Default instance with Windows Authentication
        testConnection("Default Instance", 
            "jdbc:sqlserver://localhost:1433;databaseName=FoodDeliveryDB;encrypt=false;trustServerCertificate=true;integratedSecurity=true",
            "", "");
        
        // Scenario 4: Test without database name (connect to master)
        testConnection("Master Database", 
            "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=master;encrypt=false;trustServerCertificate=true;integratedSecurity=true",
            "", "");
        
        // Scenario 5: Test with different authentication
        testConnection("SQL Server Authentication", 
            "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=FoodDeliveryDB;encrypt=false;trustServerCertificate=true;integratedSecurity=false",
            "sa", "yourpassword");
    }
    
    private void testConnection(String scenarioName, String url, String username, String password) {
        System.out.println("   Testing: " + scenarioName);
        System.out.println("   URL: " + url);
        
        try (Connection conn = DriverManager.getConnection(url, username, password)) {
            System.out.println("   ✓ Connection successful!");
            
            // Test basic query
            try (Statement stmt = conn.createStatement()) {
                ResultSet rs = stmt.executeQuery("SELECT @@VERSION as Version, DB_NAME() as DatabaseName");
                if (rs.next()) {
                    System.out.println("   Database: " + rs.getString("DatabaseName"));
                    System.out.println("   Version: " + rs.getString("Version").substring(0, 50) + "...");
                }
                rs.close();
            }
            
        } catch (SQLException e) {
            System.out.println("   ✗ Connection failed: " + e.getMessage());
            System.out.println("   Error Code: " + e.getErrorCode());
            System.out.println("   SQL State: " + e.getSQLState());
        }
        System.out.println();
    }
    
    private void testAuthenticationLibrary() {
        System.out.println("4. Testing Authentication Library:");
        
        try {
            // Try to load the authentication library
            String authDll = "mssql-jdbc_auth-12.4.1.x64.dll";
            System.out.println("   Looking for: " + authDll);
            
            // Check system properties
            String javaLibPath = System.getProperty("java.library.path");
            System.out.println("   Java Library Path: " + javaLibPath);
            
            // Check if we can load the library
            try {
                System.loadLibrary("mssql-jdbc_auth-12.4.1.x64");
                System.out.println("   ✓ Authentication library loaded successfully");
            } catch (UnsatisfiedLinkError e) {
                System.out.println("   ✗ Authentication library not found or not loadable");
                System.out.println("   Error: " + e.getMessage());
                System.out.println("   Note: This is expected if the DLL is not in the system PATH");
            }
            
        } catch (Exception e) {
            System.out.println("   ✗ Error testing authentication library: " + e.getMessage());
        }
        System.out.println();
    }
}
