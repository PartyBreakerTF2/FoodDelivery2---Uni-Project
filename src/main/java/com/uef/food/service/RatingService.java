package com.uef.food.service;

import java.sql.Timestamp;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class RatingService {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    @Autowired
    private RestaurantService restaurantService;
    
    /**
     * Save or update a customer's rating for a restaurant
     */
    public boolean saveRating(Long customerId, Long restaurantId, int rating, String comment) {
        System.out.println("DEBUG: saveRating called with customerId: " + customerId + ", restaurantId: " + restaurantId + ", rating: " + rating);
        try {
            // Check if customer has already rated this restaurant
            String checkSql = "SELECT COUNT(*) FROM ratings WHERE customer_id = ? AND restaurant_id = ?";
            Integer existingCount = jdbcTemplate.queryForObject(checkSql, Integer.class, customerId, restaurantId);
            System.out.println("DEBUG: Existing rating count for customer " + customerId + " on restaurant " + restaurantId + ": " + existingCount);
            
            if (existingCount != null && existingCount > 0) {
                System.out.println("DEBUG: Attempting to update existing rating...");
                // Update existing rating
                String updateSql = "UPDATE ratings SET rating = ?, comment = ?, updated_at = ? WHERE customer_id = ? AND restaurant_id = ?";
                int result = jdbcTemplate.update(updateSql, rating, comment, new Timestamp(System.currentTimeMillis()), customerId, restaurantId);
                System.out.println("DEBUG: Update result: " + result);
                
                if (result > 0) {
                    System.out.println("DEBUG: Update successful. Updating average rating...");
                    updateRestaurantAverageRating(restaurantId);
                    return true;
                } else {
                    System.out.println("DEBUG: Update failed (0 rows affected).");
                }
            } else {
                System.out.println("DEBUG: Attempting to insert new rating...");
                // Insert new rating
                String insertSql = "INSERT INTO ratings (customer_id, restaurant_id, rating, comment, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)";
                Timestamp now = new Timestamp(System.currentTimeMillis());
                int result = jdbcTemplate.update(insertSql, customerId, restaurantId, rating, comment, now, now);
                System.out.println("DEBUG: Insert result: " + result);
                
                if (result > 0) {
                    System.out.println("DEBUG: Insert successful. Updating average rating...");
                    updateRestaurantAverageRating(restaurantId);
                    return true;
                } else {
                    System.out.println("DEBUG: Insert failed (0 rows affected).");
                }
            }
            
            System.out.println("DEBUG: saveRating returning false (no update/insert occurred or failed).");
            return false;
        } catch (Exception e) {
            System.err.println("Error saving rating: " + e.getMessage());
            e.printStackTrace(); // Print stack trace for detailed error
            System.out.println("DEBUG: saveRating returning false due to exception.");
            return false;
        }
    }
    
    /**
     * Calculate and update the restaurant's average rating based on all user ratings
     */
    public void updateRestaurantAverageRating(Long restaurantId) {
        System.out.println("DEBUG: updateRestaurantAverageRating called for restaurantId: " + restaurantId);
        try {
            // Calculate average rating from all user ratings for this restaurant
            String avgSql = "SELECT AVG(CAST(rating AS FLOAT)) FROM ratings WHERE restaurant_id = ?";
            Double averageRating = jdbcTemplate.queryForObject(avgSql, Double.class, restaurantId);
            System.out.println("DEBUG: Calculated average rating: " + averageRating);
            
            if (averageRating != null) {
                // Round to 1 decimal place
                double roundedRating = Math.round(averageRating * 10.0) / 10.0;
                System.out.println("DEBUG: Rounded average rating: " + roundedRating);
                
                // Update restaurant's rating field
                restaurantService.updateRestaurantRating(restaurantId, roundedRating);
                
                System.out.println("Updated restaurant " + restaurantId + " average rating to: " + roundedRating);
            } else {
                System.out.println("DEBUG: Average rating is null, not updating restaurant rating.");
            }
        } catch (Exception e) {
            System.err.println("Error updating restaurant average rating: " + e.getMessage());
            e.printStackTrace(); // Print stack trace for detailed error
        }
    }
    
    /**
     * Get the average rating for a restaurant from user reviews
     */
    public double getAverageRating(Long restaurantId) {
        try {
            String sql = "SELECT AVG(CAST(rating AS FLOAT)) FROM ratings WHERE restaurant_id = ?";
            Double avgRating = jdbcTemplate.queryForObject(sql, Double.class, restaurantId);
            return avgRating != null ? Math.round(avgRating * 10.0) / 10.0 : 0.0;
        } catch (Exception e) {
            return 0.0;
        }
    }
    
    /**
     * Get the total number of ratings for a restaurant
     */
    public int getRatingCount(Long restaurantId) {
        try {
            String sql = "SELECT COUNT(*) FROM ratings WHERE restaurant_id = ?";
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, restaurantId);
            return count != null ? count : 0;
        } catch (Exception e) {
            return 0;
        }
    }
    
    /**
     * Check if a customer has already rated a restaurant
     */
    public boolean hasCustomerRated(Long customerId, Long restaurantId) {
        try {
            String sql = "SELECT COUNT(*) FROM ratings WHERE customer_id = ? AND restaurant_id = ?";
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, customerId, restaurantId);
            return count != null && count > 0;
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Get customer's existing rating for a restaurant
     */
    public Integer getCustomerRating(Long customerId, Long restaurantId) {
        try {
            String sql = "SELECT rating FROM ratings WHERE customer_id = ? AND restaurant_id = ?";
            return jdbcTemplate.queryForObject(sql, Integer.class, customerId, restaurantId);
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * Get customer's existing rating details (rating and comment) for a restaurant
     */
    public Map<String, Object> getCustomerRatingDetails(Long customerId, Long restaurantId) {
        try {
            String sql = "SELECT rating, comment FROM ratings WHERE customer_id = ? AND restaurant_id = ?";
            return jdbcTemplate.queryForMap(sql, customerId, restaurantId);
        } catch (Exception e) {
            return null;
        }
    }
}
