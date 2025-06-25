package com.uef.food.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;

@Configuration
@EnableTransactionManagement
@PropertySource("classpath:database.properties")
public class DatabaseConfig {

    @Value("${db.driver}")
    private String driverClassName;
    
    @Value("${db.url}")
    private String jdbcUrl;
    
    @Value("${db.username}")
    private String username;
    
    @Value("${db.password}")
    private String password;

    @Bean
    public DataSource dataSource() {
        try {
            // Try to load the driver class first
            Class.forName(driverClassName);
            
            // Try HikariCP
            HikariConfig config = new HikariConfig();
            config.setDriverClassName(driverClassName);
            config.setJdbcUrl(jdbcUrl);
            config.setUsername(username);
            config.setPassword(password);
            
            // Connection pool settings
            config.setMaximumPoolSize(20);
            config.setMinimumIdle(5);
            config.setConnectionTimeout(30000);
            config.setIdleTimeout(600000);
            config.setMaxLifetime(1800000);
            
            return new HikariDataSource(config);
        } catch (Exception e) {
            // Fallback to simple DriverManager DataSource
            System.err.println("Failed to create HikariCP DataSource, falling back to DriverManagerDataSource: " + e.getMessage());
            try {
                DriverManagerDataSource dataSource = new DriverManagerDataSource();
                dataSource.setDriverClassName(driverClassName);
                dataSource.setUrl(jdbcUrl);
                dataSource.setUsername(username);
                dataSource.setPassword(password);
                return dataSource;
            } catch (Exception fallbackException) {                System.err.println("Database connection failed: " + fallbackException.getMessage());
                System.err.println("Creating in-memory H2 database for testing...");
                
                // Return a simple in-memory datasource for testing
                DriverManagerDataSource dummyDataSource = new DriverManagerDataSource();
                dummyDataSource.setDriverClassName("org.h2.Driver");
                dummyDataSource.setUrl("jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE");
                dummyDataSource.setUsername("sa");
                dummyDataSource.setPassword("");
                return dummyDataSource;
            }
        }
    }

    @Bean
    public JdbcTemplate jdbcTemplate(DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }

    @Bean
    public PlatformTransactionManager transactionManager(DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }
}
