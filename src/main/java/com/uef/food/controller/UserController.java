package com.uef.food.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
                          RedirectAttributes redirectAttributes,
                          Model model) {
        // Force role to be CUSTOMER for public registration - restaurant staff can only be added by admin
        UserRole userRole = UserRole.CUSTOMER;
        User user = userService.register(username, email, password, fullName, userRole);
        
        if (user != null) {
            redirectAttributes.addFlashAttribute("success", "Registration successful! Please login with your credentials.");
            return "redirect:/login";
        } else {
            model.addAttribute("error", "Username or email already exists. Please try different credentials.");
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
                               @RequestParam String email,
                               @RequestParam(required = false) String phone,
                               @RequestParam(required = false) String address,
                               HttpSession session,
                               Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        try {
            // Update user with the new information
            user.setFullName(fullName);
            user.setEmail(email);
            
            // Save the updated user
            userService.save(user);
            
            // Update session with new data
            session.setAttribute("user", user);
            model.addAttribute("user", user);
            model.addAttribute("success", "Profile updated successfully");
        } catch (Exception e) {
            model.addAttribute("user", user);
            model.addAttribute("error", "Failed to update profile: " + e.getMessage());
        }
        
        return "profile";
    }
    
    @PostMapping("/profile/change-password")
    public String changePassword(@RequestParam String currentPassword,
                                @RequestParam String newPassword,
                                @RequestParam String confirmPassword,
                                HttpSession session,
                                Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        try {
            // Validate current password
            if (!user.getPassword().equals(currentPassword)) {
                model.addAttribute("user", user);
                model.addAttribute("error", "Current password is incorrect");
                return "profile";
            }
            
            // Validate new password
            if (newPassword == null || newPassword.length() < 6) {
                model.addAttribute("user", user);
                model.addAttribute("error", "New password must be at least 6 characters long");
                return "profile";
            }
            
            // Validate password confirmation
            if (!newPassword.equals(confirmPassword)) {
                model.addAttribute("user", user);
                model.addAttribute("error", "New password and confirmation do not match");
                return "profile";
            }
            
            // Update password
            user.setPassword(newPassword);
            userService.save(user);
            
            // Update session
            session.setAttribute("user", user);
            model.addAttribute("user", user);
            model.addAttribute("success", "Password changed successfully");
            
        } catch (Exception e) {
            model.addAttribute("user", user);
            model.addAttribute("error", "Failed to change password: " + e.getMessage());
        }
        
        return "profile";
    }
}
