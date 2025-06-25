package com.uef.food.model;

import java.sql.Timestamp;

public class OrderItem {
    private Long id;
    private Long orderId;
    private Long menuItemId;
    private String menuItemName;
    private Double menuItemPrice;
    private Integer quantity;
    private Double unitPrice;
    private Double totalPrice;
    private Double subtotal;
    private Timestamp createdAt;
    
    // For convenience, not persisted
    private Order order;
    private MenuItem menuItem;
    
    // Constructors
    public OrderItem() {}
    
    public OrderItem(Long orderId, Long menuItemId, Integer quantity, Double unitPrice) {
        this.orderId = orderId;
        this.menuItemId = menuItemId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = quantity * unitPrice;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getOrderId() {
        return orderId;
    }
    
    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }
    
    public Long getMenuItemId() {
        return menuItemId;
    }
      public void setMenuItemId(Long menuItemId) {
        this.menuItemId = menuItemId;
    }
    
    public String getMenuItemName() {
        return menuItemName;
    }
    
    public void setMenuItemName(String menuItemName) {
        this.menuItemName = menuItemName;
    }
    
    public Double getMenuItemPrice() {
        return menuItemPrice;
    }
    
    public void setMenuItemPrice(Double menuItemPrice) {
        this.menuItemPrice = menuItemPrice;
    }
    
    public Double getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(Double subtotal) {
        this.subtotal = subtotal;
    }
    
    public Order getOrder() {
        return order;
    }
    
    public void setOrder(Order order) {
        this.order = order;
        if (order != null) {
            this.orderId = order.getId();
        }
    }
    
    public MenuItem getMenuItem() {
        return menuItem;
    }
    
    public void setMenuItem(MenuItem menuItem) {
        this.menuItem = menuItem;
        if (menuItem != null) {
            this.menuItemId = menuItem.getId();
        }
    }
    
    public Integer getQuantity() {
        return quantity;
    }
      public void setQuantity(Integer quantity) {
        this.quantity = quantity;
        // Recalculate total price when quantity changes
        if (this.unitPrice != null && quantity != null) {
            this.totalPrice = quantity * this.unitPrice;
        }
    }
    
    public Double getUnitPrice() {
        return unitPrice;
    }
    
    public void setUnitPrice(Double unitPrice) {
        this.unitPrice = unitPrice;
        // Recalculate total price when unit price changes
        if (this.quantity != null && unitPrice != null) {
            this.totalPrice = this.quantity * unitPrice;
        }
    }
    
    public Double getTotalPrice() {
        return totalPrice;
    }
    
    public void setTotalPrice(Double totalPrice) {
        this.totalPrice = totalPrice;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
      public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
