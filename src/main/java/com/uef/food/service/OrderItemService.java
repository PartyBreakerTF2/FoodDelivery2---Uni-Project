package com.uef.food.service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.uef.food.model.OrderItem;

@Service
@Transactional
public class OrderItemService {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
      private static final String INSERT_ORDER_ITEM = 
        "INSERT INTO order_items (order_id, menu_item_name, menu_item_price, quantity, subtotal) VALUES (?, ?, ?, ?, ?)";
    
    private static final String UPDATE_ORDER_ITEM = 
        "UPDATE order_items SET order_id = ?, menu_item_name = ?, menu_item_price = ?, quantity = ?, subtotal = ? WHERE id = ?";
    
    private static final String DELETE_ORDER_ITEM = 
        "DELETE FROM order_items WHERE id = ?";
    
    private static final String DELETE_ORDER_ITEMS_BY_ORDER = 
        "DELETE FROM order_items WHERE order_id = ?";
    
    private static final String SELECT_ORDER_ITEM_BY_ID = 
        "SELECT * FROM order_items WHERE id = ?";
    
    private static final String SELECT_ORDER_ITEMS_BY_ORDER = 
        "SELECT * FROM order_items WHERE order_id = ? ORDER BY created_at";
    
    private static final String COUNT_ORDER_ITEMS = 
        "SELECT COUNT(*) FROM order_items";    private RowMapper<OrderItem> orderItemRowMapper = new RowMapper<OrderItem>() {
        @Override
        public OrderItem mapRow(ResultSet rs, int rowNum) throws SQLException {
            OrderItem orderItem = new OrderItem();
            orderItem.setId(rs.getLong("id"));
            orderItem.setOrderId(rs.getLong("order_id"));
            
            // Try to get menu_item_name and menu_item_price (new schema)
            try {
                orderItem.setMenuItemName(rs.getString("menu_item_name"));
                orderItem.setMenuItemPrice(rs.getDouble("menu_item_price"));
                orderItem.setSubtotal(rs.getDouble("subtotal"));
            } catch (SQLException e) {
                // Fallback to old schema if new columns don't exist
                try {
                    orderItem.setMenuItemId(rs.getLong("menu_item_id"));
                    orderItem.setUnitPrice(rs.getDouble("unit_price"));
                    orderItem.setTotalPrice(rs.getDouble("total_price"));
                } catch (SQLException e2) {
                    // Set default values if neither schema works
                    orderItem.setMenuItemName("Unknown Item");
                    orderItem.setMenuItemPrice(0.0);
                    orderItem.setSubtotal(0.0);
                }
            }
            
            orderItem.setQuantity(rs.getInt("quantity"));
            orderItem.setCreatedAt(rs.getTimestamp("created_at"));
            return orderItem;
        }
    };    public OrderItem save(OrderItem orderItem) {
        try {
            if (orderItem.getId() == null) {
                // Insert new order item
                jdbcTemplate.update(INSERT_ORDER_ITEM,
                    orderItem.getOrderId(),
                    orderItem.getMenuItemName(),
                    orderItem.getMenuItemPrice(),
                    orderItem.getQuantity(),
                    orderItem.getSubtotal()
                );
                
                // Get the generated ID
                Long generatedId = jdbcTemplate.queryForObject(
                    "SELECT SCOPE_IDENTITY()", Long.class);
                orderItem.setId(generatedId);
            } else {
                // Update existing order item
                jdbcTemplate.update(UPDATE_ORDER_ITEM,
                    orderItem.getOrderId(),
                    orderItem.getMenuItemName(),
                    orderItem.getMenuItemPrice(),
                    orderItem.getQuantity(),
                    orderItem.getSubtotal(),
                    orderItem.getId()
                );
            }
            return orderItem;
        } catch (Exception e) {
            System.err.println("Error saving order item: " + e.getMessage());
            e.printStackTrace();
            throw e; // Re-throw to let the controller handle it
        }
    }

    public OrderItem findById(Long id) {
        try {
            return jdbcTemplate.queryForObject(SELECT_ORDER_ITEM_BY_ID, orderItemRowMapper, id);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    public List<OrderItem> findByOrderId(Long orderId) {
        return jdbcTemplate.query(SELECT_ORDER_ITEMS_BY_ORDER, orderItemRowMapper, orderId);
    }

    public void delete(Long id) {
        jdbcTemplate.update(DELETE_ORDER_ITEM, id);
    }

    public void deleteByOrderId(Long orderId) {
        jdbcTemplate.update(DELETE_ORDER_ITEMS_BY_ORDER, orderId);
    }

    public long count() {
        Integer count = jdbcTemplate.queryForObject(COUNT_ORDER_ITEMS, Integer.class);
        return count != null ? count.longValue() : 0L;
    }
}
