<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Delivery - Customer Registration</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/global-styles.css" rel="stylesheet">
</head>
<body data-theme="light">
    <div class="auth-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6">
                    <div class="card auth-card">
                        <div class="card-header text-center">
                            <div class="brand-icon mb-3">
                                <i class="fas fa-utensils fa-3x text-primary"></i>
                            </div>
                            <h2 class="mb-0">Join FoodDelivery</h2>
                            <p class="text-muted">Create your customer account</p>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <c:out value="${error}"/>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
                                <div class="mb-3">
                                    <label for="fullName" class="form-label">
                                        <i class="fas fa-user me-2"></i>Full Name
                                    </label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="username" class="form-label">
                                        <i class="fas fa-at me-2"></i>Username
                                    </label>
                                    <input type="text" class="form-control" id="username" name="username" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="email" class="form-label">
                                        <i class="fas fa-envelope me-2"></i>Email
                                    </label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="password" class="form-label">
                                        <i class="fas fa-lock me-2"></i>Password
                                    </label>
                                    <input type="password" class="form-control" id="password" name="password" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="confirmPassword" class="form-label">
                                        <i class="fas fa-lock me-2"></i>Confirm Password
                                    </label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                </div>
                                
                                <div class="mb-3 form-check">
                                    <input type="checkbox" class="form-check-input" id="terms" name="terms" required>
                                    <label class="form-check-label" for="terms">
                                        I agree to the <a href="#" class="text-decoration-none">Terms and Conditions</a>
                                    </label>
                                </div>
                                
                                <button type="submit" class="btn btn-primary w-100 mb-3">
                                    <i class="fas fa-user-plus me-2"></i>Create Account
                                </button>
                                
                                <div class="text-center">
                                    <p class="mb-0">Already have an account? 
                                        <a href="${pageContext.request.contextPath}/login" class="text-decoration-none">
                                            Sign in here
                                        </a>
                                    </p>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Theme Toggle (floating) -->
    <button class="theme-toggle-floating" onclick="toggleTheme()" title="Toggle theme">
        <i id="theme-icon" class="fas fa-moon"></i>
    </button>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('registerForm');
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');
            const submitBtn = form.querySelector('button[type="submit"]');
            
            // Password confirmation validation
            function validatePasswords() {
                if (password.value && confirmPassword.value) {
                    if (password.value !== confirmPassword.value) {
                        confirmPassword.setCustomValidity('Passwords do not match');
                        confirmPassword.classList.add('is-invalid');
                        confirmPassword.classList.remove('is-valid');
                        return false;
                    } else {
                        confirmPassword.setCustomValidity('');
                        confirmPassword.classList.remove('is-invalid');
                        confirmPassword.classList.add('is-valid');
                        return true;
                    }
                }
                return true;
            }
            
            // Real-time password validation
            confirmPassword.addEventListener('input', validatePasswords);
            password.addEventListener('input', function() {
                if (confirmPassword.value) {
                    validatePasswords();
                }
            });
            
            // Form submission validation
            form.addEventListener('submit', function(e) {
                if (!validatePasswords()) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    // Show error message
                    const alertDiv = document.createElement('div');
                    alertDiv.className = 'alert alert-danger alert-dismissible fade show mt-3';
                    alertDiv.innerHTML = `
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Passwords do not match. Please check your password confirmation.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    `;
                    
                    // Remove any existing error alerts
                    const existingAlert = form.querySelector('.alert-danger');
                    if (existingAlert) {
                        existingAlert.remove();
                    }
                    
                    // Add new alert before the submit button
                    submitBtn.parentNode.insertBefore(alertDiv, submitBtn);
                    
                    // Focus on the confirm password field
                    confirmPassword.focus();
                    return false;
                }
                
                // Show loading state
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Creating Account...';
                
                return true;
            });
            
            // Add visual feedback for all form inputs
            const inputs = form.querySelectorAll('input[required]');
            inputs.forEach(input => {
                input.addEventListener('blur', function() {
                    if (this.type === 'password' && this.id === 'confirmPassword') {
                        validatePasswords();
                    } else if (this.checkValidity()) {
                        this.classList.remove('is-invalid');
                        this.classList.add('is-valid');
                    } else {
                        this.classList.remove('is-valid');
                        this.classList.add('is-invalid');
                    }
                });
            });
        });
    </script>
</body>
</html>
