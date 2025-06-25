package com.uef.food.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.uef.food.model.Order;
import com.uef.food.model.OrderStatus;
import com.uef.food.model.Restaurant;
import com.uef.food.model.User;
import com.uef.food.model.UserRole;
import com.uef.food.service.MenuItemService;
import com.uef.food.service.OrderService;
import com.uef.food.service.RestaurantService;
import com.uef.food.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private RestaurantService restaurantService;
    
    @Autowired
    private OrderService orderService;
    
    @Autowired
    private MenuItemService menuItemService;
    
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/login";
        }
        
        // Get statistics
        List<User> allUsers = userService.findAll();
        List<Restaurant> allRestaurants = restaurantService.findAll();
        List<Order> recentOrders = orderService.findRecentOrders(10);
        
        model.addAttribute("user", user);
        model.addAttribute("totalUsers", allUsers.size());
        model.addAttribute("totalRestaurants", allRestaurants.size());
        model.addAttribute("recentOrders", recentOrders);
        
        return "admin/dashboard";
    }
      @GetMapping("/users")
    public String manageUsers(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/login";
        }
        
        List<User> users = userService.findAll();
        List<Restaurant> restaurants = restaurantService.findAll();
        model.addAttribute("users", users);
        model.addAttribute("restaurants", restaurants);
        
        return "admin/users";
    }
    
    @PostMapping("/users/add")
    public String addRestaurantStaff(@RequestParam String username,
                                   @RequestParam String email,
                                   @RequestParam String password,
                                   @RequestParam String fullName,
                                   @RequestParam String role,
                                   @RequestParam(required = false) Long restaurantId,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/login";
        }
        
        try {
            // Force role to be RESTAURANT_STAFF (admins can only add restaurant staff)
            UserRole userRole = UserRole.RESTAURANT_STAFF;
            User newUser = userService.register(username, email, password, fullName, userRole);
            
            if (newUser != null) {
                // If a restaurant was selected, assign the user to it
                if (restaurantId != null) {
                    newUser.setRestaurantId(restaurantId);
                    userService.save(newUser);
                }
                
                redirectAttributes.addFlashAttribute("success", 
                    "Restaurant staff member '" + fullName + "' has been added successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", 
                    "Failed to add staff member. Username or email may already exist.");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "Error adding staff member: " + e.getMessage());
        }
        
        return "redirect:/admin/users";
    }
    
    @PostMapping("/users/{id}/assign-restaurant")
    public String assignUserToRestaurant(@PathVariable Long id,
                                       @RequestParam Long restaurantId,
                                       HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRole() != UserRole.ADMIN) {
            return "redirect:/login";
        }
        
        User user = userService.findById(id);
        if (user != null && user.getRole() == UserRole.RESTAURANT_STAFF) {
            user.setRestaurantId(restaurantId);
            userService.save(user);
        }
        
        return "redirect:/admin/users";
    }
    
    @PostMapping("/users/{id}/unassign-restaurant")
    public String unassignUserFromRestaurant(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRole() != UserRole.ADMIN) {
            return "redirect:/login";
        }
        
        User user = userService.findById(id);
        if (user != null && user.getRole() == UserRole.RESTAURANT_STAFF) {
            user.setRestaurantId(null);
            userService.save(user);
        }
        
        return "redirect:/admin/users";
    }
    
    @PostMapping("/users/{id}/toggle")
    public String toggleUserStatus(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRole() != UserRole.ADMIN) {
            return "redirect:/login";
        }
        
        User user = userService.findById(id);
        if (user != null && !user.getId().equals(currentUser.getId())) {
            user.setActive(!user.isActive());
            userService.save(user);
        }
        
        return "redirect:/admin/users";
    }
    
    @GetMapping("/restaurants")
    public String manageRestaurants(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/login";
        }
        
        List<Restaurant> restaurants = restaurantService.findAll();
        model.addAttribute("restaurants", restaurants);
        
        return "admin/restaurants";
    }
    
    @GetMapping("/restaurants/add")
    public String showAddRestaurant(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/login";
        }
        
        return "admin/add-restaurant";
    }
    
    @PostMapping("/restaurants/add")
    public String addRestaurant(@RequestParam String name,
                               @RequestParam String description,
                               @RequestParam String address,
                               @RequestParam String phone,
                               @RequestParam String email,
                               @RequestParam String cuisineType,
                               @RequestParam String openingHours,
                               @RequestParam Double deliveryFee,
                               @RequestParam Double minOrderAmount,
                               HttpSession session,
                               Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/login";
        }
        
        Restaurant restaurant = new Restaurant(name, address, phone, cuisineType);
        restaurant.setDescription(description);
        restaurant.setEmail(email);
        restaurant.setOpeningHours(openingHours);
        restaurant.setDeliveryFee(deliveryFee);
        restaurant.setMinOrderAmount(minOrderAmount);
        
        restaurantService.save(restaurant);
        model.addAttribute("success", "Restaurant added successfully");
        
        return "redirect:/admin/restaurants";
    }
    
    @GetMapping("/restaurants/{id}/edit")
    public String showEditRestaurant(@PathVariable Long id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/login";
        }
        
        Restaurant restaurant = restaurantService.findById(id);
        if (restaurant == null) {
            model.addAttribute("error", "Restaurant not found");
            return "redirect:/admin/restaurants";
        }
        
        model.addAttribute("restaurant", restaurant);
        return "admin/edit-restaurant";
    }
    
    @PostMapping("/restaurants/{id}/edit")
    public String updateRestaurant(@PathVariable Long id,
                                   @RequestParam String name,
                                   @RequestParam String description,
                                   @RequestParam String address,
                                   @RequestParam String phone,
                                   @RequestParam String email,
                                   @RequestParam String cuisineType,
                                   @RequestParam String openingHours,
                                   @RequestParam Double deliveryFee,
                                   @RequestParam Double minOrderAmount,
                                   HttpSession session,
                                   Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/login";
        }
        
        Restaurant restaurant = restaurantService.findById(id);
        if (restaurant == null) {
            model.addAttribute("error", "Restaurant not found");
            return "redirect:/admin/restaurants";
        }
        
        // Update restaurant fields
        restaurant.setName(name);
        restaurant.setDescription(description);
        restaurant.setAddress(address);
        restaurant.setPhone(phone);
        restaurant.setEmail(email);
        restaurant.setCuisineType(cuisineType);
        restaurant.setOpeningHours(openingHours);
        restaurant.setDeliveryFee(deliveryFee);
        restaurant.setMinOrderAmount(minOrderAmount);
        
        restaurantService.save(restaurant);
        model.addAttribute("success", "Restaurant updated successfully");
        
        return "redirect:/admin/restaurants";
    }

    @PostMapping("/restaurants/{id}/toggle")
    public String toggleRestaurantStatus(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/login";
        }
        
        Restaurant restaurant = restaurantService.findById(id);
        if (restaurant != null) {
            restaurant.setActive(!restaurant.isActive());
            restaurantService.save(restaurant);
        }
        
        return "redirect:/admin/restaurants";
    }
    
    @GetMapping("/orders")
    public String viewAllOrders(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/login";
        }
        
        List<Order> orders = orderService.findAll();
        model.addAttribute("orders", orders);
        
        return "admin/orders";
    }
    
    @PostMapping("/orders/{id}/status")
    public String updateOrderStatus(@PathVariable Long id,
                                   @RequestParam String status,
                                   HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/login";
        }
        
        try {
            OrderStatus orderStatus = OrderStatus.valueOf(status.toUpperCase());
            orderService.updateStatus(id, orderStatus);
        } catch (IllegalArgumentException e) {
            // Invalid status - just redirect back
            System.err.println("Invalid order status: " + status);
        }
        
        return "redirect:/admin/orders";
    }
      @GetMapping("/reports")
    public String viewReports(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/login";
        }
        
        // Basic statistics
        List<User> customers = userService.findByRole(UserRole.CUSTOMER);
        List<User> restaurantStaff = userService.findByRole(UserRole.RESTAURANT_STAFF);
        List<Restaurant> activeRestaurants = restaurantService.findAll();
        List<Order> allOrders = orderService.findAll();
        
        model.addAttribute("totalCustomers", customers.size());
        model.addAttribute("totalRestaurantStaff", restaurantStaff.size());
        model.addAttribute("totalRestaurants", activeRestaurants.size());
        model.addAttribute("totalOrders", allOrders.size());
        
        // Enhanced analytics data
        // Revenue analytics
        Double totalRevenue = orderService.getTotalRevenue();
        Double todayRevenue = orderService.getTodayRevenue();
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("todayRevenue", todayRevenue);
        
        // Order analytics
        long totalOrderCount = orderService.getTotalOrderCount();
        long todayOrderCount = orderService.getTodayOrderCount();
        model.addAttribute("totalOrderCount", totalOrderCount);
        model.addAttribute("todayOrderCount", todayOrderCount);
        
        // Calculate average order value
        Double avgOrderValue = totalOrderCount > 0 ? totalRevenue / totalOrderCount : 0.0;
        model.addAttribute("avgOrderValue", avgOrderValue);
        
        // Order status breakdown
        List<Order> pendingOrders = orderService.findPendingOrders();
        List<Order> deliveredOrders = orderService.findByStatus(OrderStatus.DELIVERED);
        List<Order> activeOrders = orderService.findActiveOrders();
        
        model.addAttribute("pendingOrdersCount", pendingOrders.size());
        model.addAttribute("deliveredOrdersCount", deliveredOrders.size());
        model.addAttribute("activeOrdersCount", activeOrders.size());
        
        // Calculate success rate (delivered vs total orders)
        double successRate = totalOrderCount > 0 ? 
            (deliveredOrders.size() * 100.0) / totalOrderCount : 0.0;
        model.addAttribute("orderSuccessRate", Math.round(successRate * 10.0) / 10.0);
        
        // Popular cuisine types (from restaurants)
        Map<String, Integer> cuisineStats = new HashMap<>();
        for (Restaurant restaurant : activeRestaurants) {
            String cuisine = restaurant.getCuisineType();
            cuisineStats.put(cuisine, cuisineStats.getOrDefault(cuisine, 0) + 1);
        }
        model.addAttribute("cuisineStats", cuisineStats);
        
        return "admin/reports";
    }
}
