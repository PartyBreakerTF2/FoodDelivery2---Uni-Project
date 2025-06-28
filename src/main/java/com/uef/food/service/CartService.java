package com.uef.food.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.uef.food.model.CartItem;
import com.uef.food.model.RestaurantCart;

import jakarta.servlet.http.HttpSession;

@Service
public class CartService {
    
    private static final String CARTS_SESSION_KEY = "restaurantCarts";
    
    /**
     * Get all restaurant carts from session
     */
    @SuppressWarnings("unchecked")
    private Map<Long, RestaurantCart> getCartsFromSession(HttpSession session) {
        Map<Long, RestaurantCart> carts = (Map<Long, RestaurantCart>) session.getAttribute(CARTS_SESSION_KEY);
        if (carts == null) {
            carts = new HashMap<>();
            session.setAttribute(CARTS_SESSION_KEY, carts);
        }
        return carts;
    }
    
    /**
     * Get cart for specific restaurant
     */
    public RestaurantCart getRestaurantCart(HttpSession session, Long restaurantId, String restaurantName) {
        Map<Long, RestaurantCart> carts = getCartsFromSession(session);
        
        RestaurantCart cart = carts.get(restaurantId);
        if (cart == null) {
            cart = new RestaurantCart(restaurantId, restaurantName);
            carts.put(restaurantId, cart);
        }
        
        return cart;
    }
    
    /**
     * Add item to restaurant cart
     */
    public void addToCart(HttpSession session, Long restaurantId, String restaurantName, 
                         String itemId, String itemName, Double itemPrice, Integer quantity) {
        RestaurantCart cart = getRestaurantCart(session, restaurantId, restaurantName);
        CartItem item = new CartItem(itemId, itemName, itemPrice, quantity);
        cart.addItem(item);
        
        System.out.println("Added to cart: " + itemName + " x" + quantity + " for restaurant " + restaurantId);
        System.out.println("Cart now has " + cart.getItemCount() + " items, subtotal: $" + cart.getSubtotal());
    }
    
    /**
     * Remove item from restaurant cart
     */
    public void removeFromCart(HttpSession session, Long restaurantId, String itemId) {
        Map<Long, RestaurantCart> carts = getCartsFromSession(session);
        RestaurantCart cart = carts.get(restaurantId);
        
        if (cart != null) {
            cart.removeItem(itemId);
            System.out.println("Removed item " + itemId + " from restaurant " + restaurantId + " cart");
        }
    }
    
    /**
     * Update item quantity in restaurant cart
     */
    public void updateItemQuantity(HttpSession session, Long restaurantId, String itemId, Integer newQuantity) {
        Map<Long, RestaurantCart> carts = getCartsFromSession(session);
        RestaurantCart cart = carts.get(restaurantId);
        
        if (cart != null) {
            cart.updateItemQuantity(itemId, newQuantity);
            System.out.println("Updated item " + itemId + " quantity to " + newQuantity + " in restaurant " + restaurantId + " cart");
        }
    }
    
    /**
     * Clear specific restaurant cart
     */
    public void clearRestaurantCart(HttpSession session, Long restaurantId) {
        Map<Long, RestaurantCart> carts = getCartsFromSession(session);
        RestaurantCart cart = carts.get(restaurantId);
        
        if (cart != null) {
            cart.clear();
            System.out.println("Cleared cart for restaurant " + restaurantId);
        }
    }
    
    /**
     * Get all restaurant carts (for display in other restaurants)
     */
    public Map<Long, RestaurantCart> getAllCarts(HttpSession session) {
        return getCartsFromSession(session);
    }
    
    /**
     * Get other restaurant carts (excluding current restaurant)
     */
    public Map<Long, RestaurantCart> getOtherCarts(HttpSession session, Long currentRestaurantId) {
        Map<Long, RestaurantCart> allCarts = getCartsFromSession(session);
        Map<Long, RestaurantCart> otherCarts = new HashMap<>();
        
        for (Map.Entry<Long, RestaurantCart> entry : allCarts.entrySet()) {
            if (!entry.getKey().equals(currentRestaurantId) && !entry.getValue().isEmpty()) {
                otherCarts.put(entry.getKey(), entry.getValue());
            }
        }
        
        return otherCarts;
    }
    
    /**
     * Remove restaurant cart after checkout
     */
    public void removeRestaurantCart(HttpSession session, Long restaurantId) {
        Map<Long, RestaurantCart> carts = getCartsFromSession(session);
        carts.remove(restaurantId);
        System.out.println("Removed cart for restaurant " + restaurantId + " after checkout");
    }
}
