package com.uef.food.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.uef.food.model.MenuItem;
import com.uef.food.model.Order;
import com.uef.food.model.OrderStatus;
import com.uef.food.model.Restaurant;
import com.uef.food.model.User;
import com.uef.food.model.UserRole;
import com.uef.food.service.MenuItemService;
import com.uef.food.service.OrderService;
import com.uef.food.service.RestaurantService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/restaurant")
public class RestaurantController {
    
    @Autowired
    private RestaurantService restaurantService;
    
    @Autowired
    private MenuItemService menuItemService;
    
    @Autowired
    private OrderService orderService;
      @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.RESTAURANT_STAFF) {
            return "redirect:/login";
        }
        
        // Check if user is assigned to a restaurant
        if (user.getRestaurantId() == null) {
            model.addAttribute("error", "You are not assigned to any restaurant. Please contact administrator.");
            return "redirect:/login";
        }
        
        // Get the restaurant this staff member is assigned to
        Restaurant restaurant = restaurantService.findById(user.getRestaurantId());
        if (restaurant == null) {
            model.addAttribute("error", "Restaurant not found. Please contact administrator.");
            return "redirect:/login";
        }
        
        // Get orders for this specific restaurant
        List<Order> recentOrders = orderService.findByRestaurantId(user.getRestaurantId());
        
        model.addAttribute("user", user);
        model.addAttribute("restaurant", restaurant);
        model.addAttribute("recentOrders", recentOrders);
        
        return "restaurant/dashboard";
    }
      @GetMapping("/menu")
    public String manageMenu(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.RESTAURANT_STAFF) {
            return "redirect:/login";
        }
        
        // Check if user is assigned to a restaurant
        if (user.getRestaurantId() == null) {
            model.addAttribute("error", "You are not assigned to any restaurant. Please contact administrator.");
            return "redirect:/login";
        }
        
        // Get the restaurant this staff member is assigned to
        Restaurant restaurant = restaurantService.findById(user.getRestaurantId());
        if (restaurant == null) {
            model.addAttribute("error", "Restaurant not found. Please contact administrator.");
            return "redirect:/login";
        }
        
        List<MenuItem> menuItems = menuItemService.findByRestaurant(restaurant.getId());
        model.addAttribute("restaurant", restaurant);
        model.addAttribute("menuItems", menuItems);
        
        return "restaurant/menu";
    }
      @GetMapping("/menu/add")
    public String showAddMenuItem(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.RESTAURANT_STAFF) {
            return "redirect:/login";
        }
        
        // Check if user is assigned to a restaurant
        if (user.getRestaurantId() == null) {
            model.addAttribute("error", "You are not assigned to any restaurant. Please contact administrator.");
            return "redirect:/login";
        }
        
        // Get the restaurant this staff member is assigned to
        Restaurant restaurant = restaurantService.findById(user.getRestaurantId());
        if (restaurant == null) {
            model.addAttribute("error", "Restaurant not found. Please contact administrator.");
            return "redirect:/login";
        }
        
        model.addAttribute("restaurant", restaurant);
        
        return "restaurant/add-menu-item";
    }
      @PostMapping("/menu/add")
    public String addMenuItem(@RequestParam String name,
                             @RequestParam String description,
                             @RequestParam Double price,
                             @RequestParam String category,
                             HttpSession session,
                             Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.RESTAURANT_STAFF) {
            return "redirect:/login";
        }
        
        // Validate user has a restaurant assignment
        if (user.getRestaurantId() == null) {
            model.addAttribute("error", "You are not assigned to any restaurant. Please contact administrator.");
            return "redirect:/login";
        }
        
        Restaurant restaurant = restaurantService.findById(user.getRestaurantId());
        if (restaurant != null) {
            MenuItem menuItem = new MenuItem(name, description, price, category, restaurant);
            menuItemService.save(menuItem);
            model.addAttribute("success", "Menu item added successfully");
        } else {
            model.addAttribute("error", "Restaurant not found.");
        }
        
        return "redirect:/restaurant/menu";
    }
    
    @GetMapping("/menu/edit/{id}")
    public String showEditMenuItem(@PathVariable Long id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.RESTAURANT_STAFF) {
            return "redirect:/login";
        }
        
        MenuItem menuItem = menuItemService.findById(id);
        if (menuItem != null) {
            model.addAttribute("menuItem", menuItem);
            return "restaurant/edit-menu-item";
        }
        
        return "redirect:/restaurant/menu";
    }
      @PostMapping("/menu/edit/{id}")
    public String editMenuItem(@PathVariable Long id,
                              @RequestParam String name,
                              @RequestParam String description,
                              @RequestParam Double price,
                              @RequestParam String category,
                              @RequestParam boolean available,
                              HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.RESTAURANT_STAFF) {
            return "redirect:/login";
        }
        
        MenuItem menuItem = menuItemService.findById(id);
        if (menuItem != null) {
            // Security check: ensure the menu item belongs to the staff's restaurant
            if (user.getRestaurantId() == null || !user.getRestaurantId().equals(menuItem.getRestaurantId())) {
                return "redirect:/restaurant/menu?error=unauthorized";
            }
            
            menuItem.setName(name);
            menuItem.setDescription(description);
            menuItem.setPrice(price);
            menuItem.setCategory(category);
            menuItem.setAvailable(available);
            menuItemService.save(menuItem);
        }
        
        return "redirect:/restaurant/menu";
    }    @GetMapping("/orders")
    public String manageOrders(@RequestParam(required = false) String status,
                             HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.RESTAURANT_STAFF) {
            return "redirect:/login";
        }

        // Check if user is assigned to a restaurant
        if (user.getRestaurantId() == null) {
            model.addAttribute("error", "You are not assigned to any restaurant. Please contact administrator.");
            return "redirect:/login";
        }

        // Get the restaurant this staff member is assigned to
        Restaurant restaurant = restaurantService.findById(user.getRestaurantId());
        if (restaurant == null) {
            model.addAttribute("error", "Restaurant not found. Please contact administrator.");
            return "redirect:/login";
        }

        // Get orders for this specific restaurant only
        List<Order> orders = orderService.findByRestaurantId(user.getRestaurantId());
        
        // Filter by status if provided
        if (status != null && !status.trim().isEmpty()) {
            try {
                OrderStatus filterStatus = OrderStatus.valueOf(status.toUpperCase());
                orders = orders.stream()
                    .filter(order -> order.getStatus() == filterStatus)
                    .collect(Collectors.toList());
            } catch (IllegalArgumentException e) {
                // Invalid status, ignore filter
            }
        }

        // Calculate order statistics from all orders (not filtered)
        List<Order> allOrders = orderService.findByRestaurantId(user.getRestaurantId());
        long pendingCount = allOrders.stream().filter(o -> o.getStatus() == OrderStatus.PENDING).count();
        long confirmedCount = allOrders.stream().filter(o -> o.getStatus() == OrderStatus.CONFIRMED).count();
        long preparingCount = allOrders.stream().filter(o -> o.getStatus() == OrderStatus.PREPARING).count();
        long readyCount = allOrders.stream().filter(o -> o.getStatus() == OrderStatus.READY).count();
        long deliveryCount = allOrders.stream().filter(o -> o.getStatus() == OrderStatus.OUT_FOR_DELIVERY).count();
        long deliveredCount = allOrders.stream().filter(o -> o.getStatus() == OrderStatus.DELIVERED).count();
        long cancelledCount = allOrders.stream().filter(o -> o.getStatus() == OrderStatus.CANCELLED).count();

        model.addAttribute("restaurant", restaurant);
        model.addAttribute("orders", orders);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("confirmedCount", confirmedCount);
        model.addAttribute("preparingCount", preparingCount);
        model.addAttribute("readyCount", readyCount);
        model.addAttribute("deliveryCount", deliveryCount);
        model.addAttribute("deliveredCount", deliveredCount);
        model.addAttribute("cancelledCount", cancelledCount);
        model.addAttribute("currentStatus", status); // For highlighting active filter

        return "restaurant/orders";
    }
    
    @PostMapping("/orders/update-status")
    public String updateOrderStatus(@RequestParam Long orderId, 
                                  @RequestParam String status,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.RESTAURANT_STAFF) {
            return "redirect:/login";
        }
        
        // Check if user is assigned to a restaurant
        if (user.getRestaurantId() == null) {
            redirectAttributes.addFlashAttribute("error", "You are not assigned to any restaurant. Please contact administrator.");
            return "redirect:/login";
        }
        
        try {
            Order order = orderService.findById(orderId);
            if (order == null) {
                redirectAttributes.addFlashAttribute("error", "Order not found.");
                return "redirect:/restaurant/orders";
            }
            
            // Security check: ensure the order belongs to the staff's restaurant
            if (!user.getRestaurantId().equals(order.getRestaurantId())) {
                redirectAttributes.addFlashAttribute("error", "You can only update orders for your assigned restaurant.");
                return "redirect:/restaurant/orders";
            }
            
            // Update order status
            OrderStatus newStatus = OrderStatus.valueOf(status);
            order.setStatus(newStatus);
            orderService.save(order);
            
            redirectAttributes.addFlashAttribute("success", "Order #" + orderId + " status updated to " + status.replace("_", " ").toLowerCase() + ".");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to update order status: " + e.getMessage());
        }
        
        return "redirect:/restaurant/orders";
    }
}
