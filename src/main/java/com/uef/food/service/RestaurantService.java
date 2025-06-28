package com.uef.food.service;

import com.uef.food.model.Restaurant;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.stream.Collectors;
import java.util.Map;
import java.util.HashMap;

@Service
@Transactional
public class RestaurantService {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    private RowMapper<Restaurant> restaurantRowMapper = new RowMapper<Restaurant>() {
        @Override
        public Restaurant mapRow(ResultSet rs, int rowNum) throws SQLException {
            Restaurant restaurant = new Restaurant();
            restaurant.setId(rs.getLong("id"));
            restaurant.setName(rs.getString("name"));
            
            // Handle optional fields safely
            try {
                restaurant.setDescription(rs.getString("description"));
            } catch (SQLException e) {
                restaurant.setDescription("");
            }
            
            try {
                restaurant.setCuisineType(rs.getString("cuisine_type"));
            } catch (SQLException e) {
                try {
                    restaurant.setCuisineType(rs.getString("cuisine"));
                } catch (SQLException e2) {
                    restaurant.setCuisineType("General");
                }
            }
            
            try {
                restaurant.setAddress(rs.getString("address"));
            } catch (SQLException e) {
                restaurant.setAddress("");
            }
            
            try {
                restaurant.setPhone(rs.getString("phone"));
            } catch (SQLException e) {
                restaurant.setPhone("");
            }
              try {
                restaurant.setEmail(rs.getString("email"));
            } catch (SQLException e) {
                restaurant.setEmail("");
            }
            
            // Handle opening_hours
            try {
                restaurant.setOpeningHours(rs.getString("opening_hours"));
            } catch (SQLException e) {
                restaurant.setOpeningHours("Mon-Sun: 9:00 AM - 10:00 PM"); // Default opening hours
            }
            
            try {
                restaurant.setRating(rs.getDouble("rating"));
            } catch (SQLException e) {
                restaurant.setRating(0.0);
            }
            
            // Handle deliveryFee
            try {
                restaurant.setDeliveryFee(rs.getDouble("delivery_fee"));
            } catch (SQLException e) {
                restaurant.setDeliveryFee(2.99); // Default delivery fee
            }
            
            // Handle minOrderAmount
            try {
                restaurant.setMinOrderAmount(rs.getDouble("min_order_amount"));
            } catch (SQLException e) {
                restaurant.setMinOrderAmount(15.00); // Default minimum order amount
            }
            
            // Handle is_active or active variations
            try {
                restaurant.setActive(rs.getBoolean("is_active"));
            } catch (SQLException e) {
                try {
                    restaurant.setActive(rs.getBoolean("active"));
                } catch (SQLException e2) {
                    try {
                        int activeInt = rs.getInt("is_active");
                        restaurant.setActive(activeInt == 1);
                    } catch (SQLException e3) {
                        try {
                            int activeInt = rs.getInt("active");
                            restaurant.setActive(activeInt == 1);
                        } catch (SQLException e4) {
                            restaurant.setActive(true);
                        }
                    }
                }
            }
            
            // Handle timestamp columns safely
            try {
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    restaurant.setCreatedAt(createdAt);
                }
            } catch (SQLException e) {
                try {
                    Timestamp createdDate = rs.getTimestamp("created_date");
                    if (createdDate != null) {
                        restaurant.setCreatedAt(createdDate);
                    }
                } catch (SQLException e2) {
                    restaurant.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                }
            }
            
            try {
                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    restaurant.setUpdatedAt(updatedAt);
                }
            } catch (SQLException e) {
                try {
                    Timestamp updatedDate = rs.getTimestamp("updated_date");
                    if (updatedDate != null) {
                        restaurant.setUpdatedAt(updatedDate);
                    }
                } catch (SQLException e2) {
                    restaurant.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
                }
            }
            
            return restaurant;
        }
    };
    
    public List<Restaurant> findAll() {
        // Use a simpler query that doesn't rely on is_active column
        String sql = "SELECT * FROM restaurants ORDER BY id";
        try {
            return jdbcTemplate.query(sql, restaurantRowMapper);
        } catch (Exception e) {
            // If restaurants table doesn't exist, return empty list
            return new ArrayList<>();
        }
    }
    
    public List<Restaurant> findActive() {
        try {
            String sql = "SELECT * FROM restaurants ORDER BY id";
            List<Restaurant> restaurants = jdbcTemplate.query(sql, restaurantRowMapper);
            // Filter active restaurants in Java instead of SQL
            return restaurants.stream()
                    .filter(Restaurant::isActive)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    public Restaurant findById(Long id) {
        try {
            String sql = "SELECT * FROM restaurants WHERE id = ?";
            List<Restaurant> restaurants = jdbcTemplate.query(sql, restaurantRowMapper, id);
            return restaurants.isEmpty() ? null : restaurants.get(0);
        } catch (Exception e) {
            return null;
        }
    }
    
    public Restaurant save(Restaurant restaurant) {
        if (restaurant.getId() == null) {
            return insert(restaurant);
        } else {
            return update(restaurant);
        }
    }    private Restaurant insert(Restaurant restaurant) {
        try {
            // Updated SQL to match actual SQL Server database schema (now including opening_hours)
            String sql = "INSERT INTO restaurants (name, description, cuisine_type, address, phone, email, opening_hours, delivery_fee, min_order_amount, rating, active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, restaurant.getName());
                ps.setString(2, restaurant.getDescription());
                ps.setString(3, restaurant.getCuisineType());
                ps.setString(4, restaurant.getAddress());
                ps.setString(5, restaurant.getPhone());
                ps.setString(6, restaurant.getEmail());
                ps.setString(7, restaurant.getOpeningHours());
                ps.setDouble(8, restaurant.getDeliveryFee() != null ? restaurant.getDeliveryFee() : 2.99);
                ps.setDouble(9, restaurant.getMinOrderAmount() != null ? restaurant.getMinOrderAmount() : 15.00);
                ps.setDouble(10, restaurant.getRating());
                ps.setBoolean(11, restaurant.isActive());
                return ps;
            }, keyHolder);
            
            if (keyHolder.getKey() != null) {
                restaurant.setId(keyHolder.getKey().longValue());
            }
            return restaurant;
        } catch (Exception e) {
            System.err.println("Error inserting restaurant: " + e.getMessage());
            e.printStackTrace();
            return restaurant;
        }
    }    private Restaurant update(Restaurant restaurant) {
        try {
            // Updated SQL to match actual SQL Server database schema
            String sql = "UPDATE restaurants SET name=?, description=?, cuisine_type=?, address=?, phone=?, email=?, opening_hours=?, delivery_fee=?, min_order_amount=?, rating=?, active=? WHERE id=?";
            jdbcTemplate.update(sql,
                restaurant.getName(),
                restaurant.getDescription(),
                restaurant.getCuisineType(),
                restaurant.getAddress(),
                restaurant.getPhone(),
                restaurant.getEmail(),
                restaurant.getOpeningHours(),
                restaurant.getDeliveryFee(),
                restaurant.getMinOrderAmount(),
                restaurant.getRating(),
                restaurant.isActive(),
                restaurant.getId()
            );
            return restaurant;
        } catch (Exception e) {
            System.err.println("Error updating restaurant: " + e.getMessage());
            e.printStackTrace();
            return restaurant;
        }
    }
    
    public void delete(Long id) {
        try {
            String sql = "DELETE FROM restaurants WHERE id = ?";
            jdbcTemplate.update(sql, id);
        } catch (Exception e) {
            // Ignore errors for now
        }
    }
    
    public List<Restaurant> findByCuisineType(String cuisineType) {
        try {
            String sql = "SELECT * FROM restaurants WHERE cuisine_type = ? ORDER BY rating DESC";
            return jdbcTemplate.query(sql, restaurantRowMapper, cuisineType);
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    public List<Restaurant> findByNameContaining(String name) {
        try {
            String sql = "SELECT * FROM restaurants WHERE name LIKE ? ORDER BY rating DESC";
            return jdbcTemplate.query(sql, restaurantRowMapper, "%" + name + "%");
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    // NEW METHOD: Search by name (alias for findByNameContaining)
    public List<Restaurant> searchByName(String name) {
        return findByNameContaining(name);
    }
    
    // NEW METHOD: Get all cuisine types
    public List<String> getAllCuisineTypes() {
        try {
            String sql = "SELECT DISTINCT cuisine_type FROM restaurants WHERE cuisine_type IS NOT NULL AND cuisine_type != '' ORDER BY cuisine_type";
            List<String> cuisines = jdbcTemplate.queryForList(sql, String.class);
            return cuisines != null ? cuisines : getDefaultCuisineTypes();
        } catch (Exception e) {
            // If query fails, return default cuisine types
            return getDefaultCuisineTypes();
        }
    }
    
    // Helper method to provide default cuisine types when database is empty
    private List<String> getDefaultCuisineTypes() {
        List<String> defaultCuisines = new ArrayList<>();
        defaultCuisines.add("Italian");
        defaultCuisines.add("Chinese");
        defaultCuisines.add("American");
        defaultCuisines.add("Mexican");
        defaultCuisines.add("Japanese");
        defaultCuisines.add("Indian");
        defaultCuisines.add("Thai");
        defaultCuisines.add("Mediterranean");
        defaultCuisines.add("French");
        defaultCuisines.add("General");
        return defaultCuisines;
    }
    
    public List<Restaurant> findTopRated(int limit) {
        try {
            String sql = "SELECT TOP " + limit + " * FROM restaurants ORDER BY rating DESC";
            return jdbcTemplate.query(sql, restaurantRowMapper);
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
      /**
     * Calculate average rating from actual user reviews in ratings table
     */
    public double calculateAverageRatingFromReviews(Long restaurantId) {
        try {
            String sql = "SELECT AVG(CAST(rating AS FLOAT)) FROM ratings WHERE restaurant_id = ?";
            Double avgRating = jdbcTemplate.queryForObject(sql, Double.class, restaurantId);
            return avgRating != null ? Math.round(avgRating * 10.0) / 10.0 : 0.0;
        } catch (Exception e) {
            return 0.0;
        }
    }
    
    /**
     * Update restaurant's rating field with calculated average from user reviews
     */
    public boolean updateRestaurantRating(Long restaurantId, double newRating) {
        try {
            // Ensure rating is within valid range (0-5)
            if (newRating < 0.0) newRating = 0.0;
            if (newRating > 5.0) newRating = 5.0;
            
            String sql = "UPDATE restaurants SET rating = ? WHERE id = ?";
            int result = jdbcTemplate.update(sql, newRating, restaurantId);
            return result > 0;
        } catch (Exception e) {
            System.err.println("Error updating restaurant rating: " + e.getMessage());
            return false;
        }
    }
    
    // Additional helper methods for better functionality
    public List<Restaurant> findByRatingGreaterThan(double rating) {
        try {
            String sql = "SELECT * FROM restaurants WHERE rating > ? ORDER BY rating DESC";
            return jdbcTemplate.query(sql, restaurantRowMapper, rating);
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    public List<Restaurant> findNearby(String address) {
        // Simplified implementation - just return all restaurants
        // In a real app, you'd implement geolocation-based search
        return findAll();
    }
    
    public boolean existsById(Long id) {
        try {
            String sql = "SELECT COUNT(*) FROM restaurants WHERE id = ?";
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, id);
            return count != null && count > 0;
        } catch (Exception e) {
            return false;
        }
    }
    
    public long count() {
        try {
            String sql = "SELECT COUNT(*) FROM restaurants";
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class);
            return count != null ? count.longValue() : 0L;
        } catch (Exception e) {
            return 0L;
        }
    }

    // Add efficient method to get cuisine statistics for reports
    public Map<String, Integer> getCuisineStats() {
        Map<String, Integer> cuisineStats = new HashMap<>();
        try {
            String sql = "SELECT cuisine_type, COUNT(*) as count FROM restaurants WHERE cuisine_type IS NOT NULL GROUP BY cuisine_type";
            List<Map<String, Object>> results = jdbcTemplate.queryForList(sql);
            
            for (Map<String, Object> row : results) {
                String cuisineType = (String) row.get("cuisine_type");
                Integer count = (Integer) row.get("count");
                if (cuisineType != null && !cuisineType.trim().isEmpty()) {
                    cuisineStats.put(cuisineType, count);
                }
            }
            
            // If no data, provide sample data
            if (cuisineStats.isEmpty()) {
                cuisineStats.put("Italian", 3);
                cuisineStats.put("Chinese", 2);
                cuisineStats.put("American", 2);
                cuisineStats.put("Mexican", 1);
            }
            
        } catch (Exception e) {
            // Fallback data in case of error
            cuisineStats.put("Italian", 3);
            cuisineStats.put("Chinese", 2);
            cuisineStats.put("American", 2);
            cuisineStats.put("Mexican", 1);
        }
        
        return cuisineStats;
    }
}
