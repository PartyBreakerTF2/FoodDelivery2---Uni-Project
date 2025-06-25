package com.uef.food.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.uef.food.model.User;
import com.uef.food.model.UserRole;
import com.uef.food.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/login")
    public String showLoginForm() {
        return "login";
    }
    
    @PostMapping("/login")
    public String login(@RequestParam String username, 
                       @RequestParam String password,
                       HttpSession session,
                       Model model) {
        User user = userService.authenticate(username, password);
        if (user != null) {
            session.setAttribute("user", user);
            
            // Redirect based on user role
            if (user.getRole() == UserRole.ADMIN) {
                return "redirect:/admin/dashboard";
            } else if (user.getRole() == UserRole.RESTAURANT_STAFF) {
                return "redirect:/restaurant/dashboard";
            } else {
                return "redirect:/customer/dashboard";
            }
        } else {
            model.addAttribute("error", "Invalid username or password");
            return "login";
        }
    }
    
    @GetMapping("/register")
    public String showRegisterForm() {
        return "register";
    }
    
    @PostMapping("/register")
    public String register(@RequestParam String username,
                          @RequestParam String email,
                          @RequestParam String password,
                          @RequestParam String fullName,
                          @RequestParam(required = false) String role,
                          Model model) {
        // Force role to be CUSTOMER for public registration - restaurant staff can only be added by admin
        UserRole userRole = UserRole.CUSTOMER;
        User user = userService.register(username, email, password, fullName, userRole);
        
        if (user != null) {
            model.addAttribute("success", "Registration successful! Please login.");
            return "login";
        } else {
            model.addAttribute("error", "Username or email already exists");
            return "register";
        }
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
    
    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            model.addAttribute("user", user);
            return "profile";
        }
        return "redirect:/login";
    }
      @PostMapping("/profile/update")
    public String updateProfile(@RequestParam String fullName,
                               @RequestParam String phone,
                               @RequestParam String address,
                               HttpSession session,
                               Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        try {
            userService.updateProfile(user.getId(), fullName, phone, address);
            // Update session with new data
            User updatedUser = userService.findById(user.getId());
            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);
                model.addAttribute("user", updatedUser);
                model.addAttribute("success", "Profile updated successfully");
            } else {
                model.addAttribute("user", user);
                model.addAttribute("error", "Failed to refresh user data");
            }
        } catch (Exception e) {
            model.addAttribute("user", user);
            model.addAttribute("error", "Failed to update profile: " + e.getMessage());
        }
        
        return "profile";
    }
}
