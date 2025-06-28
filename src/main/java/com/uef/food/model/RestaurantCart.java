package com.uef.food.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class RestaurantCart implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Long restaurantId;
    private String restaurantName;
    private List<CartItem> items;
    
    public RestaurantCart() {
        this.items = new ArrayList<>();
    }
    
    public RestaurantCart(Long restaurantId, String restaurantName) {
        this.restaurantId = restaurantId;
        this.restaurantName = restaurantName;
        this.items = new ArrayList<>();
    }
    
    // Getters and Setters
    public Long getRestaurantId() {
        return restaurantId;
    }
    
    public void setRestaurantId(Long restaurantId) {
        this.restaurantId = restaurantId;
    }
    
    public String getRestaurantName() {
        return restaurantName;
    }
    
    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }
    
    public List<CartItem> getItems() {
        return items;
    }
    
    public void setItems(List<CartItem> items) {
        this.items = items;
    }
    
    // Business methods
    public void addItem(CartItem newItem) {
        // Check if item already exists
        for (CartItem item : items) {
            if (item.getItemId().equals(newItem.getItemId())) {
                item.setQuantity(item.getQuantity() + newItem.getQuantity());
                return;
            }
        }
        // If not found, add new item
        items.add(newItem);
    }
    
    public void removeItem(String itemId) {
        items.removeIf(item -> item.getItemId().equals(itemId));
    }
    
    public void updateItemQuantity(String itemId, Integer newQuantity) {
        if (newQuantity <= 0) {
            removeItem(itemId);
            return;
        }
        
        for (CartItem item : items) {
            if (item.getItemId().equals(itemId)) {
                item.setQuantity(newQuantity);
                return;
            }
        }
    }
    
    public void clear() {
        items.clear();
    }
    
    public boolean isEmpty() {
        return items.isEmpty();
    }
    
    public int getItemCount() {
        return items.size();
    }
    
    public int getLength() {
        return items.size();
    }
    
    public Double getSubtotal() {
        return items.stream()
                .mapToDouble(CartItem::getSubtotal)
                .sum();
    }
    
    @Override
    public String toString() {
        return "RestaurantCart{" +
                "restaurantId=" + restaurantId +
                ", restaurantName='" + restaurantName + '\'' +
                ", items=" + items +
                '}';
    }
}
