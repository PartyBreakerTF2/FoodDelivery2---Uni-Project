package com.uef.food.controller;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.uef.food.model.MenuItem;
import com.uef.food.model.Order;
import com.uef.food.model.OrderItem;
import com.uef.food.model.OrderStatus;
import com.uef.food.model.Restaurant;
import com.uef.food.model.User;
import com.uef.food.model.UserRole;
import com.uef.food.service.MenuItemService;
import com.uef.food.service.OrderItemService;
import com.uef.food.service.OrderService;
import com.uef.food.service.RatingService;
import com.uef.food.service.RestaurantService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/customer")
public class CustomerController {
    
    @Autowired
    private RestaurantService restaurantService;
    
    @Autowired
    private MenuItemService menuItemService;
      @Autowired
    private OrderService orderService;
      @Autowired
    private OrderItemService orderItemService;
    
    @Autowired
    private RatingService ratingService;
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.CUSTOMER) {
            return "redirect:/login";
        }
        
        List<Restaurant> restaurants = restaurantService.findActive();
        List<String> cuisineTypes = restaurantService.getAllCuisineTypes();
        
        model.addAttribute("restaurants", restaurants);
        model.addAttribute("cuisineTypes", cuisineTypes);
        model.addAttribute("user", user);
        
        return "customer/dashboard";
    }
    
    @GetMapping("/restaurants")
    public String listRestaurants(@RequestParam(required = false) String cuisine,
                                  @RequestParam(required = false) String search,
                                  HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.CUSTOMER) {
            return "redirect:/login";
        }
        
        List<Restaurant> restaurants;
        if (cuisine != null && !cuisine.isEmpty()) {
            restaurants = restaurantService.findByCuisineType(cuisine);
            // Filter for active restaurants only
            restaurants = restaurants.stream()
                    .filter(Restaurant::isActive)
                    .collect(Collectors.toList());
        } else if (search != null && !search.isEmpty()) {
            restaurants = restaurantService.searchByName(search);
            // Filter for active restaurants only
            restaurants = restaurants.stream()
                    .filter(Restaurant::isActive)
                    .collect(Collectors.toList());
        } else {
            restaurants = restaurantService.findActive();
        }
        
        List<String> cuisineTypes = restaurantService.getAllCuisineTypes();
        
        model.addAttribute("restaurants", restaurants);
        model.addAttribute("cuisineTypes", cuisineTypes);
        model.addAttribute("selectedCuisine", cuisine);
        model.addAttribute("searchTerm", search);
        
        return "customer/restaurants";
    }
    
    @GetMapping("/restaurant/{id}/menu")
    public String viewMenu(@PathVariable Long id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.CUSTOMER) {
            return "redirect:/login";
        }
        
        Restaurant restaurant = restaurantService.findById(id);
        if (restaurant == null || !restaurant.isActive()) {
            return "redirect:/customer/restaurants";
        }
        
        List<MenuItem> menuItems = menuItemService.findByRestaurant(id);
        List<String> categories = menuItemService.getAllCategories();        model.addAttribute("restaurant", restaurant);
        model.addAttribute("menuItems", menuItems);
        model.addAttribute("categories", categories);
        
        return "customer/menu";
    }
    
    @PostMapping("/cart/add")
    @ResponseBody
    public String addToCart(@RequestParam Long menuItemId,
                           @RequestParam Integer quantity,
                           HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "error";
        }
        
        // For simplicity, we'll store cart in session
        // In a real application, you might use a separate Cart entity
        
        return "success";
    }      @GetMapping("/orders")
    public String viewOrders(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.CUSTOMER) {
            return "redirect:/login";
        }
        
        // Fetch customer's orders from the database
        List<Order> orders = orderService.findByCustomerId(user.getId());
        
        // Get list of restaurant IDs that the customer has already rated
        try {
            String ratedRestaurantsSql = "SELECT restaurant_id FROM ratings WHERE customer_id = ?";
            List<Long> ratedRestaurantIds = jdbcTemplate.queryForList(ratedRestaurantsSql, Long.class, user.getId());
            model.addAttribute("ratedRestaurantIds", ratedRestaurantIds);
        } catch (Exception e) {
            // If there's an error, just pass an empty list
            model.addAttribute("ratedRestaurantIds", List.of());
        }
        
        model.addAttribute("user", user);
        model.addAttribute("orders", orders);
        
        return "customer/orders";
    }
    
    @PostMapping("/place-order")
    @ResponseBody
    public Map<String, Object> placeOrder(@RequestBody Map<String, Object> orderData, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Check if user is logged in
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "Please log in to place an order");
                return response;
            }
              // Extract order data
            Long restaurantId = Long.valueOf(orderData.get("restaurantId").toString());
            String deliveryAddress = (String) orderData.get("deliveryAddress");
            String specialInstructions = (String) orderData.get("specialInstructions");
            Double subtotal = Double.valueOf(orderData.get("subtotal").toString());
            Double total = Double.valueOf(orderData.get("total").toString());
            
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> items = (List<Map<String, Object>>) orderData.get("items");
            
            // Validate restaurant exists and is active
            Restaurant restaurant = restaurantService.findById(restaurantId);
            if (restaurant == null || !restaurant.isActive()) {
                response.put("success", false);
                response.put("message", "Restaurant is currently unavailable");
                return response;
            }
            
            // Validate minimum order amount
            if (subtotal < 15.00) {
                response.put("success", false);
                response.put("message", "Minimum order amount is $15.00");
                return response;
            }
            
            // Create order object
            Order order = new Order();
            order.setCustomerId(currentUser.getId());
            order.setRestaurantId(restaurantId);
            order.setStatus(OrderStatus.PENDING);
            order.setTotalAmount(total);
            order.setDeliveryAddress(deliveryAddress);
            order.setSpecialInstructions(specialInstructions);
            order.setOrderDate(new Timestamp(System.currentTimeMillis()));
            order.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            order.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
            
            // Save order to database
            Order savedOrder = orderService.save(order);            if (savedOrder != null && savedOrder.getId() != null) {
                // Save order items to order_items table
                for (Map<String, Object> item : items) {
                    OrderItem orderItem = new OrderItem();
                    orderItem.setOrderId(savedOrder.getId());
                    orderItem.setMenuItemName((String) item.get("name"));
                    orderItem.setMenuItemPrice(Double.valueOf(item.get("price").toString()));
                    orderItem.setQuantity(Integer.valueOf(item.get("quantity").toString()));
                    orderItem.setSubtotal(orderItem.getMenuItemPrice() * orderItem.getQuantity());
                    orderItem.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                    
                    // Save order item to database
                    OrderItem savedOrderItem = orderItemService.save(orderItem);
                    if (savedOrderItem == null) {
                        System.err.println("Failed to save order item: " + item.get("name"));
                    } else {
                        System.out.println("Saved order item: " + item.get("name") + 
                                         " x" + item.get("quantity") + 
                                         " = $" + orderItem.getSubtotal());
                    }
                }
                
                response.put("success", true);
                response.put("message", "Order placed successfully!");
                response.put("orderId", savedOrder.getId());
                response.put("orderNumber", "#" + savedOrder.getId());
                
            } else {
                response.put("success", false);
                response.put("message", "Failed to save order to database");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Failed to place order: " + e.getMessage());
        }
          return response;
    }
      @PostMapping("/rate-restaurant")
    @ResponseBody
    public Map<String, Object> rateRestaurant(@RequestBody Map<String, Object> ratingData, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Check if user is logged in
            User user = (User) session.getAttribute("user");
            if (user == null || user.getRole() != UserRole.CUSTOMER) {
                response.put("success", false);
                response.put("message", "You must be logged in as a customer to rate restaurants");
                return response;
            }
            
            // Extract rating data
            Long restaurantId = Long.valueOf(ratingData.get("restaurantId").toString());
            Integer rating = Integer.valueOf(ratingData.get("rating").toString());
            String comment = ratingData.get("comment") != null ? ratingData.get("comment").toString() : "";
            Long orderId = ratingData.get("orderId") != null ? Long.valueOf(ratingData.get("orderId").toString()) : null;
            
            // Validate rating
            if (rating < 1 || rating > 5) {
                response.put("success", false);
                response.put("message", "Rating must be between 1 and 5 stars");
                return response;
            }
            
            // Check if restaurant exists and is active
            Restaurant restaurant = restaurantService.findById(restaurantId);
            if (restaurant == null || !restaurant.isActive()) {
                response.put("success", false);
                response.put("message", "Restaurant not found or is unavailable");
                return response;
            }
            
            // If orderId is provided, validate that the user has a delivered order from this restaurant
            if (orderId != null) {
                try {
                    String orderValidationSql = "SELECT COUNT(*) FROM orders WHERE id = ? AND customer_id = ? AND restaurant_id = ? AND status = 'DELIVERED'";
                    Integer deliveredOrderCount = jdbcTemplate.queryForObject(orderValidationSql, Integer.class, orderId, user.getId(), restaurantId);
                    
                    if (deliveredOrderCount == null || deliveredOrderCount == 0) {
                        response.put("success", false);
                        response.put("message", "You can only rate restaurants after receiving a delivered order");
                        return response;
                    }
                } catch (Exception e) {
                    response.put("success", false);
                    response.put("message", "Error validating order: " + e.getMessage());
                    return response;
                }
            } else {
                // If no specific order is provided, check if user has any delivered order from this restaurant
                try {
                    String orderValidationSql = "SELECT COUNT(*) FROM orders WHERE customer_id = ? AND restaurant_id = ? AND status = 'DELIVERED'";
                    Integer deliveredOrderCount = jdbcTemplate.queryForObject(orderValidationSql, Integer.class, user.getId(), restaurantId);
                    
                    if (deliveredOrderCount == null || deliveredOrderCount == 0) {
                        response.put("success", false);
                        response.put("message", "You can only rate restaurants after receiving a delivered order");
                        return response;
                    }
                } catch (Exception e) {
                    response.put("success", false);
                    response.put("message", "Error validating order history: " + e.getMessage());
                    return response;
                }
            }
            
            // Save the rating using RatingService
            boolean saved = ratingService.saveRating(user.getId(), restaurantId, rating, comment);
            
            if (saved) {
                // Get the updated average rating
                double newAverageRating = ratingService.getAverageRating(restaurantId);
                int totalRatings = ratingService.getRatingCount(restaurantId);
                
                response.put("success", true);
                response.put("message", "Thank you for your rating!");
                response.put("newRating", newAverageRating);
                response.put("totalRatings", totalRatings);
                
                // Check if this was an update or new rating
                String action = ratingService.hasCustomerRated(user.getId(), restaurantId) ? "updated" : "added";
                
                System.out.println("Customer " + user.getFullName() + " " + action + " rating for restaurant " + 
                                 restaurant.getName() + " with " + rating + " stars. New average: " + newAverageRating + 
                                 " (based on " + totalRatings + " reviews)");
                
                if (!comment.trim().isEmpty()) {
                    System.out.println("Comment: " + comment);
                }
            } else {
                response.put("success", false);
                response.put("message", "Failed to save rating. Please try again.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Error processing rating: " + e.getMessage());
        }
        
        return response;
    }
    
    @GetMapping("/get-rating/{restaurantId}")
    @ResponseBody
    public Map<String, Object> getExistingRating(@PathVariable Long restaurantId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Check if user is logged in
            User user = (User) session.getAttribute("user");
            if (user == null || user.getRole() != UserRole.CUSTOMER) {
                response.put("success", false);
                response.put("message", "You must be logged in as a customer");
                return response;
            }
            
            // Get existing rating details
            Map<String, Object> ratingDetails = ratingService.getCustomerRatingDetails(user.getId(), restaurantId);
            
            if (ratingDetails != null) {
                response.put("success", true);
                response.put("rating", ratingDetails.get("rating"));
                response.put("comment", ratingDetails.get("comment"));
            } else {
                response.put("success", false);
                response.put("message", "No existing rating found");
            }
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error retrieving rating: " + e.getMessage());
        }
        
        return response;
    }
}
