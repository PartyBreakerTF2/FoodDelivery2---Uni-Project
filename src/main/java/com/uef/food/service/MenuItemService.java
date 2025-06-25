package com.uef.food.service;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.uef.food.model.MenuItem;

@Service
@Transactional
public class MenuItemService {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    // Flag to track if menu_items table exists
    private Boolean menuItemsTableExists = null;
    
    private final RowMapper<MenuItem> menuItemRowMapper = (rs, rowNum) -> {
        MenuItem menuItem = new MenuItem();
        
        menuItem.setId(rs.getLong("id"));
        menuItem.setName(rs.getString("name"));
        
        // Handle restaurant_id
        try {
            menuItem.setRestaurantId(rs.getLong("restaurant_id"));
        } catch (SQLException e) {
            menuItem.setRestaurantId(1L);
        }
        
        // Handle description
        try {
            menuItem.setDescription(rs.getString("description"));
        } catch (SQLException e) {
            menuItem.setDescription("");
        }
        
        // Handle price
        try {
            Double price = rs.getDouble("price");
            menuItem.setPrice(price);
        } catch (SQLException e) {
            menuItem.setPrice(0.0);
        }
        
        // Handle category
        try {
            menuItem.setCategory(rs.getString("category"));
        } catch (SQLException e) {
            menuItem.setCategory("Main Course");
        }
        
        // Handle is_available or available
        try {
            menuItem.setAvailable(rs.getBoolean("is_available"));
        } catch (SQLException e) {
            try {
                menuItem.setAvailable(rs.getBoolean("available"));
            } catch (SQLException e2) {
                try {
                    int available = rs.getInt("is_available");
                    menuItem.setAvailable(available == 1);
                } catch (SQLException e3) {
                    menuItem.setAvailable(true);
                }
            }
        }
        
        // Handle image_url
        try {
            menuItem.setImageUrl(rs.getString("image_url"));
        } catch (SQLException e) {
            try {
                menuItem.setImageUrl(rs.getString("image"));
            } catch (SQLException e2) {
                menuItem.setImageUrl("/images/default-food.jpg");
            }
        }
        
        // Handle timestamps
        try {
            Timestamp createdAt = rs.getTimestamp("created_at");
            menuItem.setCreatedAt(createdAt);
        } catch (SQLException e) {
            menuItem.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        }
        
        try {
            Timestamp updatedAt = rs.getTimestamp("updated_at");
            menuItem.setUpdatedAt(updatedAt);
        } catch (SQLException e) {
            menuItem.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        }
        
        return menuItem;
    };
      // Check if menu_items table exists
    private boolean checkTableExists() {
        if (menuItemsTableExists == null) {
            try {
                // Use case-insensitive check for SQL Server
                String sql = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE UPPER(TABLE_NAME) = 'MENU_ITEMS'";
                Integer count = jdbcTemplate.queryForObject(sql, Integer.class);
                menuItemsTableExists = (count != null && count > 0);
            } catch (Exception e) {
                // If INFORMATION_SCHEMA fails, try direct table query
                try {
                    String directSql = "SELECT COUNT(*) FROM menu_items WHERE 1=0";
                    jdbcTemplate.queryForObject(directSql, Integer.class);
                    menuItemsTableExists = true;
                } catch (Exception e2) {
                    menuItemsTableExists = false;
                }
            }
        }
        return menuItemsTableExists;
    }
    
    public List<MenuItem> findAll() {
        if (!checkTableExists()) {
            return createSampleMenuItems(20);
        }
        
        try {
            String sql = "SELECT * FROM menu_items ORDER BY category, name";
            return jdbcTemplate.query(sql, menuItemRowMapper);
        } catch (Exception e) {
            menuItemsTableExists = false;
            return createSampleMenuItems(20);
        }
    }
    
    public List<MenuItem> findByRestaurant(Long restaurantId) {
        if (!checkTableExists()) {
            return createSampleMenuItems(15).stream()
                .filter(item -> item.getRestaurantId().equals(restaurantId))
                .collect(java.util.stream.Collectors.toList());
        }
        
        try {
            String sql = "SELECT * FROM menu_items WHERE restaurant_id = ? ORDER BY category, name";
            return jdbcTemplate.query(sql, menuItemRowMapper, restaurantId);
        } catch (Exception e) {
            menuItemsTableExists = false;
            return createSampleMenuItems(15).stream()
                .filter(item -> item.getRestaurantId().equals(restaurantId))
                .collect(java.util.stream.Collectors.toList());
        }
    }
    
    public List<MenuItem> findAvailableByRestaurant(Long restaurantId) {
        if (!checkTableExists()) {
            return createSampleMenuItems(12).stream()
                .filter(item -> item.getRestaurantId().equals(restaurantId) && item.isAvailable())
                .collect(java.util.stream.Collectors.toList());
        }
        
        try {
            String sql = "SELECT * FROM menu_items WHERE restaurant_id = ? AND is_available = 1 ORDER BY category, name";
            return jdbcTemplate.query(sql, menuItemRowMapper, restaurantId);
        } catch (Exception e) {
            menuItemsTableExists = false;
            return createSampleMenuItems(12).stream()
                .filter(item -> item.getRestaurantId().equals(restaurantId) && item.isAvailable())
                .collect(java.util.stream.Collectors.toList());
        }
    }
    
    // Create sample menu items for demo purposes
    private List<MenuItem> createSampleMenuItems(int limit) {
        List<MenuItem> sampleItems = new ArrayList<>();
        
        String[] itemNames = {
            "Margherita Pizza", "Caesar Salad", "Chicken Burger", "Pasta Carbonara", "Fish & Chips",
            "Beef Steak", "Vegetable Curry", "Sushi Roll", "Chicken Wings", "Greek Salad",
            "BBQ Ribs", "Mushroom Risotto", "Grilled Salmon", "Taco Bowl", "Chocolate Cake",
            "Chicken Tikka", "French Fries", "Onion Rings", "Ice Cream", "Coffee"
        };
        
        String[] descriptions = {
            "Fresh tomatoes, mozzarella, and basil", "Crisp lettuce with parmesan and croutons",
            "Juicy grilled chicken with fresh veggies", "Creamy pasta with bacon and egg",
            "Traditional battered fish with golden fries", "Tender beef cooked to perfection",
            "Spicy mixed vegetables in curry sauce", "Fresh fish with seasoned rice",
            "Crispy wings with special sauce", "Fresh vegetables with feta cheese",
            "Smoky barbecue ribs with sauce", "Creamy rice with mushrooms",
            "Fresh salmon grilled with herbs", "Mexican-style bowl with seasoning",
            "Rich chocolate dessert", "Spiced chicken in curry sauce",
            "Golden crispy potato fries", "Crispy battered onion rings",
            "Creamy vanilla ice cream", "Freshly brewed aromatic coffee"
        };
        
        String[] categories = {
            "Pizza", "Salad", "Burger", "Pasta", "Fish",
            "Meat", "Curry", "Sushi", "Appetizer", "Salad",
            "Meat", "Pasta", "Fish", "Bowl", "Dessert",
            "Curry", "Side", "Side", "Dessert", "Beverage"
        };
        
        double[] prices = {
            12.99, 8.50, 11.99, 13.50, 14.99,
            18.99, 12.00, 15.99, 9.99, 9.50,
            19.99, 14.50, 16.99, 10.99, 6.99,
            13.99, 4.99, 5.50, 4.99, 2.99
        };
          // Get actual restaurant IDs from database to distribute items properly
        List<Long> availableRestaurantIds = getAvailableRestaurantIds();
        
        for (int i = 0; i < Math.min(limit, itemNames.length); i++) {
            MenuItem item = new MenuItem();
            item.setId((long) (i + 1));
            item.setName(itemNames[i]);
            item.setDescription(descriptions[i]);
            item.setPrice(prices[i]);
            item.setCategory(categories[i]);
            
            // Distribute items evenly among available restaurants
            if (!availableRestaurantIds.isEmpty()) {
                Long restaurantId = availableRestaurantIds.get(i % availableRestaurantIds.size());
                item.setRestaurantId(restaurantId);
            } else {
                // Fallback: distribute among restaurants 1-4 if no restaurants found in DB
                item.setRestaurantId((long) (i % 4 + 1));
            }
            
            item.setAvailable(i % 4 != 3); // Make 3/4 items available
            item.setImageUrl("/images/food/" + itemNames[i].toLowerCase().replace(" ", "-") + ".jpg");
            item.setCreatedAt(new Timestamp(System.currentTimeMillis() - i * 86400000L)); // Different creation times
            item.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
            
            sampleItems.add(item);
        }
        
        return sampleItems;
    }
    
    public MenuItem findById(Long id) {
        if (!checkTableExists()) {
            if (id != null && id <= 20) {
                List<MenuItem> sampleItems = createSampleMenuItems(20);
                return sampleItems.stream()
                    .filter(item -> item.getId().equals(id))
                    .findFirst()
                    .orElse(null);
            }
            return null;
        }
        
        try {
            String sql = "SELECT * FROM menu_items WHERE id = ?";
            List<MenuItem> items = jdbcTemplate.query(sql, menuItemRowMapper, id);
            return items.isEmpty() ? null : items.get(0);
        } catch (Exception e) {
            menuItemsTableExists = false;
            return null;
        }
    }
    
    public List<MenuItem> findByCategory(String category) {
        if (!checkTableExists()) {
            return createSampleMenuItems(20).stream()
                .filter(item -> item.getCategory().equalsIgnoreCase(category))
                .collect(java.util.stream.Collectors.toList());
        }
        
        try {
            String sql = "SELECT * FROM menu_items WHERE category = ? ORDER BY name";
            return jdbcTemplate.query(sql, menuItemRowMapper, category);
        } catch (Exception e) {
            menuItemsTableExists = false;
            return new ArrayList<>();
        }
    }
    
    public List<String> getAllCategories() {
        if (!checkTableExists()) {
            List<String> defaultCategories = new ArrayList<>();
            defaultCategories.add("Pizza");
            defaultCategories.add("Burger");
            defaultCategories.add("Pasta");
            defaultCategories.add("Salad");
            defaultCategories.add("Fish");
            defaultCategories.add("Meat");
            defaultCategories.add("Curry");
            defaultCategories.add("Sushi");
            defaultCategories.add("Appetizer");
            defaultCategories.add("Side");
            defaultCategories.add("Dessert");
            defaultCategories.add("Beverage");
            return defaultCategories;
        }
        
        try {
            String sql = "SELECT DISTINCT category FROM menu_items WHERE category IS NOT NULL AND category != '' ORDER BY category";
            List<String> categories = jdbcTemplate.queryForList(sql, String.class);
            return categories != null ? categories : new ArrayList<>();
        } catch (Exception e) {
            menuItemsTableExists = false;
            return getAllCategories(); // Recursive call will return default categories
        }
    }
    
    public MenuItem save(MenuItem menuItem) {
        if (!checkTableExists()) {
            // For demo purposes, just return the item with an ID
            if (menuItem.getId() == null) {
                menuItem.setId(System.currentTimeMillis() % 1000);
            }
            menuItem.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
            return menuItem;
        }
        
        if (menuItem.getId() == null) {
            return insert(menuItem);
        } else {
            return update(menuItem);
        }
    }
    
    private MenuItem insert(MenuItem menuItem) {
        try {
            String sql = "INSERT INTO menu_items (name, description, price, category, restaurant_id, is_available, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, menuItem.getName());
                ps.setString(2, menuItem.getDescription());
                ps.setDouble(3, menuItem.getPrice());
                ps.setString(4, menuItem.getCategory());
                ps.setLong(5, menuItem.getRestaurantId());
                ps.setBoolean(6, menuItem.isAvailable());
                ps.setString(7, menuItem.getImageUrl());
                return ps;
            }, keyHolder);
            
            if (keyHolder.getKey() != null) {
                menuItem.setId(keyHolder.getKey().longValue());
            }
            return menuItem;
        } catch (Exception e) {
            menuItemsTableExists = false;
            return menuItem;
        }
    }
    
    private MenuItem update(MenuItem menuItem) {
        try {
            String sql = "UPDATE menu_items SET name=?, description=?, price=?, category=?, restaurant_id=?, is_available=?, image_url=? WHERE id=?";
            jdbcTemplate.update(sql,
                menuItem.getName(),
                menuItem.getDescription(),
                menuItem.getPrice(),
                menuItem.getCategory(),
                menuItem.getRestaurantId(),
                menuItem.isAvailable(),
                menuItem.getImageUrl(),
                menuItem.getId()
            );
            return menuItem;
        } catch (Exception e) {
            menuItemsTableExists = false;
            return menuItem;
        }
    }
    
    public void delete(Long id) {
        if (!checkTableExists()) {
            return;
        }
        
        try {
            String sql = "DELETE FROM menu_items WHERE id = ?";
            jdbcTemplate.update(sql, id);
        } catch (Exception e) {
            menuItemsTableExists = false;
        }
    }
    
    public List<MenuItem> searchByName(String name) {
        if (!checkTableExists()) {
            return createSampleMenuItems(20).stream()
                .filter(item -> item.getName().toLowerCase().contains(name.toLowerCase()))
                .collect(java.util.stream.Collectors.toList());
        }
        
        try {
            String sql = "SELECT * FROM menu_items WHERE name LIKE ? ORDER BY name";
            return jdbcTemplate.query(sql, menuItemRowMapper, "%" + name + "%");
        } catch (Exception e) {
            menuItemsTableExists = false;
            return new ArrayList<>();
        }
    }
    
    public List<MenuItem> findByPriceRange(Double minPrice, Double maxPrice) {
        if (!checkTableExists()) {
            return createSampleMenuItems(20).stream()
                .filter(item -> item.getPrice() >= minPrice && item.getPrice() <= maxPrice)
                .collect(java.util.stream.Collectors.toList());
        }
        
        try {
            String sql = "SELECT * FROM menu_items WHERE price BETWEEN ? AND ? ORDER BY price";
            return jdbcTemplate.query(sql, menuItemRowMapper, minPrice, maxPrice);
        } catch (Exception e) {
            menuItemsTableExists = false;
            return new ArrayList<>();
        }
    }
    
    public boolean existsById(Long id) {
        if (!checkTableExists()) {
            return id != null && id <= 20;
        }
        
        try {
            String sql = "SELECT COUNT(*) FROM menu_items WHERE id = ?";
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, id);
            return count != null && count > 0;
        } catch (Exception e) {
            menuItemsTableExists = false;
            return false;
        }
    }
    
    public long count() {
        if (!checkTableExists()) {
            return 20L;
        }
        
        try {
            String sql = "SELECT COUNT(*) FROM menu_items";
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class);
            return count != null ? count.longValue() : 0L;
        } catch (Exception e) {
            menuItemsTableExists = false;
            return 20L;
        }
    }
    
    public long countByRestaurant(Long restaurantId) {
        if (!checkTableExists()) {
            return 10L; // Default count per restaurant
        }
        
        try {
            String sql = "SELECT COUNT(*) FROM menu_items WHERE restaurant_id = ?";
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, restaurantId);
            return count != null ? count.longValue() : 0L;
        } catch (Exception e) {
            menuItemsTableExists = false;
            return 10L;
        }
    }
    
    // Helper method to force refresh table existence check
    public void refreshTableExistence() {
        menuItemsTableExists = null;
        checkTableExists();
    }

    // Helper method to get available restaurant IDs from database
    private List<Long> getAvailableRestaurantIds() {
        List<Long> restaurantIds = new ArrayList<>();
        try {
            String sql = "SELECT id FROM restaurants ORDER BY id";
            restaurantIds = jdbcTemplate.queryForList(sql, Long.class);
        } catch (Exception e) {
            // If restaurants table doesn't exist or query fails, return empty list
            // This will trigger the fallback logic in createSampleMenuItems
        }
        return restaurantIds;
    }
}