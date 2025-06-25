package com.uef.food.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Simple connection test for SQL Server Authentication
 * This test verifies the database connection works without hanging
 */
public class SQLServerAuthTest {
    
    private static final String DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=FoodDeliveryDB;encrypt=false;trustServerCertificate=true;integratedSecurity=false";
    private static final String USERNAME = "foodapp";
    private static final String PASSWORD = "FoodApp123!";
    
    public static void main(String[] args) {
        System.out.println("Starting SQL Server Authentication Test...");
        System.out.println("========================================");
        
        try {
            // Load the driver
            Class.forName(DRIVER);
            System.out.println("✓ SQL Server JDBC Driver loaded successfully");
            
            // Test connection
            System.out.println("Attempting to connect to database...");
            try (Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD)) {
                System.out.println("✓ Database connection established successfully!");
                
                // Test a simple query
                String testQuery = "SELECT @@VERSION AS ServerVersion, DB_NAME() AS DatabaseName, SYSTEM_USER AS CurrentUser";
                try (PreparedStatement stmt = connection.prepareStatement(testQuery);
                     ResultSet rs = stmt.executeQuery()) {
                    
                    if (rs.next()) {
                        System.out.println("\nDatabase Information:");
                        System.out.println("- Server Version: " + rs.getString("ServerVersion").split("\n")[0]);
                        System.out.println("- Database Name: " + rs.getString("DatabaseName"));
                        System.out.println("- Current User: " + rs.getString("CurrentUser"));
                    }
                }
                
                // Test if our tables exist
                String tableQuery = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'";
                try (PreparedStatement stmt = connection.prepareStatement(tableQuery);
                     ResultSet rs = stmt.executeQuery()) {
                    
                    System.out.println("\nExisting Tables:");
                    boolean hasData = false;
                    while (rs.next()) {
                        System.out.println("- " + rs.getString("TABLE_NAME"));
                        hasData = true;
                    }
                    
                    if (!hasData) {
                        System.out.println("- No tables found. You may need to run the schema.sql script.");
                    }
                }
                
                System.out.println("\n✓ All tests passed! The connection is working properly.");
                
            }
            
        } catch (ClassNotFoundException e) {
            System.err.println("✗ SQL Server JDBC Driver not found!");
            System.err.println("Make sure mssql-jdbc is in your classpath.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("✗ Database connection failed!");
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Message: " + e.getMessage());
            
            // Provide helpful suggestions
            if (e.getMessage().contains("Login failed")) {
                System.err.println("\nSuggestions:");
                System.err.println("1. Run the setup-sql-auth.sql script as administrator");
                System.err.println("2. Make sure SQL Server authentication is enabled");
                System.err.println("3. Check if the username/password are correct");
            } else if (e.getMessage().contains("TCP/IP connection")) {
                System.err.println("\nSuggestions:");
                System.err.println("1. Make sure SQL Server is running");
                System.err.println("2. Check if TCP/IP is enabled in SQL Server Configuration Manager");
                System.err.println("3. Verify the server name and instance (SQLEXPRESS)");
            }
            
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("✗ Unexpected error occurred!");
            e.printStackTrace();
        }
        
        System.out.println("\n========================================");
        System.out.println("Test completed.");
    }
}
