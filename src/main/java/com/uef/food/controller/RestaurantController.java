package com.uef.food.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
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
        List<String> categories = menuItemService.getAllCategories();
        model.addAttribute("restaurant", restaurant);
        model.addAttribute("menuItems", menuItems);
        model.addAttribute("categories", categories);
        
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
                             @RequestParam(required = false) MultipartFile itemImage,
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
            MenuItem savedItem = menuItemService.save(menuItem);
            
            // Handle image upload if provided
            if (itemImage != null && !itemImage.isEmpty()) {
                try {
                    saveMenuItemImage(itemImage, savedItem.getId());
                } catch (Exception e) {
                    System.err.println("Error saving image for menu item " + savedItem.getId() + ": " + e.getMessage());
                    // Don't fail the whole operation if image save fails
                }
            }
            
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
                              @RequestParam("name") String name,
                              @RequestParam("description") String description,
                              @RequestParam("price") Double price,
                              @RequestParam("category") String category,
                              @RequestParam("available") boolean available,
                              @RequestParam(value = "itemImage", required = false) MultipartFile itemImage,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        
        System.out.println("DEBUG: === EDIT MENU ITEM METHOD CALLED ===");
        System.out.println("DEBUG: Menu Item ID: " + id);
        System.out.println("DEBUG: Received parameters:");
        System.out.println("  name: " + name);
        System.out.println("  description: " + description);
        System.out.println("  price: " + price);
        System.out.println("  category: " + category);
        System.out.println("  available: " + available);
        System.out.println("  itemImage: " + (itemImage != null ? itemImage.getOriginalFilename() : "null"));
        System.out.println("  itemImage isEmpty: " + (itemImage != null ? itemImage.isEmpty() : "null"));
        System.out.println("  itemImage size: " + (itemImage != null ? itemImage.getSize() : "null"));
        
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.RESTAURANT_STAFF) {
            return "redirect:/login";
        }
        
        try {
            MenuItem menuItem = menuItemService.findById(id);
            if (menuItem != null) {
                // Security check: ensure the menu item belongs to the staff's restaurant
                if (user.getRestaurantId() == null || !user.getRestaurantId().equals(menuItem.getRestaurantId())) {
                    redirectAttributes.addFlashAttribute("error", "Unauthorized access to menu item");
                    return "redirect:/restaurant/menu";
                }
                
                menuItem.setName(name);
                menuItem.setDescription(description);
                menuItem.setPrice(price);
                menuItem.setCategory(category);
                menuItem.setAvailable(available);
                menuItemService.save(menuItem);
                
                // Handle image upload if provided
                if (itemImage != null && !itemImage.isEmpty()) {
                    System.out.println("DEBUG: Processing image upload - filename: " + itemImage.getOriginalFilename() + ", size: " + itemImage.getSize());
                    try {
                        saveMenuItemImage(itemImage, menuItem.getId());
                        redirectAttributes.addFlashAttribute("success", "Menu item updated successfully with new image");
                    } catch (IOException e) {
                        System.err.println("Error saving image for menu item " + menuItem.getId() + ": " + e.getMessage());
                        e.printStackTrace();
                        redirectAttributes.addFlashAttribute("success", "Menu item updated successfully (image upload failed: " + e.getMessage() + ")");
                    }
                } else {
                    System.out.println("DEBUG: No image uploaded or image is empty");
                    redirectAttributes.addFlashAttribute("success", "Menu item updated successfully");
                }
            } else {
                redirectAttributes.addFlashAttribute("error", "Menu item not found");
            }
        } catch (Exception e) {
            System.err.println("Error updating menu item: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Failed to update menu item: " + e.getMessage());
        }
        
        return "redirect:/restaurant/menu";
    }
    
    /**
     * Save uploaded image file for a menu item
     */
    private void saveMenuItemImage(MultipartFile file, Long menuItemId) throws IOException {
        if (file == null || file.isEmpty()) {
            System.out.println("DEBUG: File is null or empty");
            return;
        }
        
        System.out.println("DEBUG: Starting image save process");
        System.out.println("DEBUG: File original name: " + file.getOriginalFilename());
        System.out.println("DEBUG: File size: " + file.getSize());
        System.out.println("DEBUG: File content type: " + file.getContentType());
        
        // Validate file type
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new IllegalArgumentException("File must be an image");
        }
        
        // Use absolute path with proper Windows file separators
        String currentDir = System.getProperty("user.dir");
        Path uploadPath = Paths.get(currentDir, "src", "main", "webapp", "resources", "images", "menu-items");
        
        System.out.println("DEBUG: Current directory: " + currentDir);
        System.out.println("DEBUG: Upload path: " + uploadPath.toString());
        System.out.println("DEBUG: Upload path exists: " + Files.exists(uploadPath));
        
        // Create directory if it doesn't exist
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
            System.out.println("DEBUG: Created directory: " + uploadPath.toString());
        }
        
        // Save file with menu item ID as filename (always use .jpg for consistency)
        String fileName = menuItemId + ".jpg";
        Path filePath = uploadPath.resolve(fileName);
        
        System.out.println("DEBUG: Saving to file: " + filePath.toString());
        
        // Copy file to destination
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
        
        System.out.println("DEBUG: Image saved successfully for menu item " + menuItemId + ": " + filePath.toString());
        System.out.println("DEBUG: File exists after save: " + Files.exists(filePath));
        System.out.println("DEBUG: File size after save: " + Files.size(filePath));
    }

    @PostMapping("/menu/delete/{id}")
    @ResponseBody
    public ResponseEntity<String> deleteMenuItem(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != UserRole.RESTAURANT_STAFF) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        
        // Check if user is assigned to a restaurant
        if (user.getRestaurantId() == null) {
            return ResponseEntity.status(403).body("You are not assigned to any restaurant");
        }
        
        MenuItem menuItem = menuItemService.findById(id);
        if (menuItem == null) {
            return ResponseEntity.status(404).body("Menu item not found");
        }
        
        // Security check: ensure the menu item belongs to the staff's restaurant
        if (!user.getRestaurantId().equals(menuItem.getRestaurantId())) {
            return ResponseEntity.status(403).body("Unauthorized access to menu item");
        }
        
        try {
            menuItemService.delete(id);
            return ResponseEntity.ok("Menu item deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error deleting menu item: " + e.getMessage());
        }
    }

    @GetMapping("/orders")
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
        long deliveryCount = allOrders.stream().filter(o -> o.getStatus() == OrderStatus.OUT_FOR_DELIVERY).count();
        long deliveredCount = allOrders.stream().filter(o -> o.getStatus() == OrderStatus.DELIVERED).count();
        long cancelledCount = allOrders.stream().filter(o -> o.getStatus() == OrderStatus.CANCELLED).count();

        model.addAttribute("restaurant", restaurant);
        model.addAttribute("orders", orders);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("confirmedCount", confirmedCount);
        model.addAttribute("preparingCount", preparingCount);
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
            
            // Try to save the order
            try {
                orderService.save(order);
                redirectAttributes.addFlashAttribute("success", "Order #" + orderId + " status updated to " + status.replace("_", " ").toLowerCase() + ".");
            } catch (RuntimeException e) {
                redirectAttributes.addFlashAttribute("error", "Failed to update order status: " + e.getMessage());
            }
            
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", "Invalid order status: " + status);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to update order status: " + e.getMessage());
        }
        
        return "redirect:/restaurant/orders";
    }
}
