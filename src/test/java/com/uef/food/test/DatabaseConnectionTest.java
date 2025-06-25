package com.uef.food.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnectionTest {
    
    public static void main(String[] args) {
        // Test different connection strings
        String[] connectionStrings = {
            // SQL Server Express with sa authentication
            "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=FoodDeliveryDB;encrypt=false;trustServerCertificate=true;integratedSecurity=false",
            
            // Default SQL Server instance
            "jdbc:sqlserver://localhost:1433;databaseName=FoodDeliveryDB;encrypt=false;trustServerCertificate=true",
            
            // SQL Server Express with dynamic port
            "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=FoodDeliveryDB;encrypt=false;trustServerCertificate=true;integratedSecurity=false",
            
            // Windows Authentication
            "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=FoodDeliveryDB;encrypt=false;trustServerCertificate=true;integratedSecurity=true"
        };
        
        String username = "sa";  // Change this to your username
        String password = "yourpassword";  // Change this to your password
        
        System.out.println("Testing database connections...\n");
        
        for (int i = 0; i < connectionStrings.length; i++) {
            System.out.println("Testing connection " + (i + 1) + ":");
            System.out.println("URL: " + connectionStrings[i]);
            
            try {
                // Load SQL Server driver
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                
                // Try to connect
                if (i == 3) { // Windows Authentication
                    try (Connection conn = DriverManager.getConnection(connectionStrings[i])) {
                        System.out.println("✅ SUCCESS: Connected with Windows Authentication!");
                        System.out.println("   Database: " + conn.getCatalog());
                        System.out.println("   User: " + conn.getMetaData().getUserName());
                        break;
                    }
                } else {
                    try (Connection conn = DriverManager.getConnection(connectionStrings[i], username, password)) {
                        System.out.println("✅ SUCCESS: Connected with SQL Authentication!");
                        System.out.println("   Database: " + conn.getCatalog());
                        System.out.println("   User: " + conn.getMetaData().getUserName());
                        
                        // Update the properties file with working connection
                        System.out.println("\n🔧 Use this configuration in database.properties:");
                        System.out.println("db.url=" + connectionStrings[i]);
                        System.out.println("db.username=" + username);
                        System.out.println("db.password=" + password);
                        break;
                    }
                }
                
            } catch (ClassNotFoundException e) {
                System.out.println("❌ ERROR: SQL Server JDBC driver not found");
                break;
            } catch (SQLException e) {
                System.out.println("❌ FAILED: " + e.getMessage());
                if (e.getMessage().contains("Login failed")) {
                    System.out.println("   → Check username/password or enable SQL Server Authentication");
                } else if (e.getMessage().contains("database") && e.getMessage().contains("does not exist")) {
                    System.out.println("   → Database 'FoodDeliveryDB' does not exist. Create it first!");
                } else if (e.getMessage().contains("connection")) {
                    System.out.println("   → SQL Server may not be running or TCP/IP is disabled");
                }
            }
            System.out.println();
        }
    }
}
