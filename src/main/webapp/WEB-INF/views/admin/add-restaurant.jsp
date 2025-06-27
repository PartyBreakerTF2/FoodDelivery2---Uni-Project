<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Restaurant - Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/global-styles.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-utensils me-2"></i>FoodDelivery
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                            <i class="fas fa-users me-1"></i>Users
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/restaurants">
                            <i class="fas fa-store me-1"></i>Restaurants
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="fas fa-shopping-cart me-1"></i>Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                            <i class="fas fa-chart-bar me-1"></i>Reports
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav align-items-center">
                    <li class="nav-item me-3">
                        <button class="theme-toggle btn p-0" onclick="toggleTheme()" title="Toggle theme">
                            <i class="fas fa-moon" id="themeIcon"></i>
                        </button>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="navbarDropdown" 
                           role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-2"></i>
                            <c:out value="${sessionScope.user.fullName}" default="Admin"/>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/profile">
                                    <i class="fas fa-user me-2"></i>Profile
                                </a>
                            </li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container" style="margin-top: 100px;">
        <!-- Page Header -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-2">
                        <i class="fas fa-plus-circle me-2"></i>Add New Restaurant
                    </h1>
                    <p class="mb-0">Create a new restaurant profile for the platform</p>
                </div>
                <div class="col-md-4 text-center">
                    <i class="fas fa-store fa-3x"></i>
                </div>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="glass-card">
                    <div class="card-body p-4">
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show glass-card mb-4" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show glass-card mb-4" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/admin/restaurants/add" method="post" id="restaurantForm">
                            <!-- Basic Information Section -->
                            <div class="glass-card mb-4">
                                <div class="card-body">
                                    <h6 class="section-title">
                                        <i class="fas fa-info-circle me-2"></i>Basic Information
                                    </h6>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="name" class="form-label">
                                                Restaurant Name <span class="required">*</span>
                                            </label>
                                            <input type="text" class="form-control" id="name" name="name" required 
                                                   placeholder="Enter restaurant name" maxlength="255">
                                            <div class="form-help">The official name of the restaurant</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="cuisineType" class="form-label">
                                                Cuisine Type <span class="required">*</span>
                                            </label>
                                            <select class="form-select" id="cuisineType" name="cuisineType" required>
                                                <option value="">Select cuisine type</option>
                                                <option value="Italian">Italian</option>
                                                <option value="Chinese">Chinese</option>
                                                <option value="American">American</option>
                                                <option value="Mexican">Mexican</option>
                                                <option value="Japanese">Japanese</option>
                                                <option value="Indian">Indian</option>
                                                <option value="Thai">Thai</option>
                                                <option value="Mediterranean">Mediterranean</option>
                                                <option value="French">French</option>
                                                <option value="Korean">Korean</option>
                                                <option value="Vietnamese">Vietnamese</option>
                                                <option value="Greek">Greek</option>
                                                <option value="Turkish">Turkish</option>
                                                <option value="Lebanese">Lebanese</option>
                                                <option value="Brazilian">Brazilian</option>
                                                <option value="Fast Food">Fast Food</option>
                                                <option value="Seafood">Seafood</option>
                                                <option value="Vegetarian">Vegetarian</option>
                                                <option value="Vegan">Vegan</option>
                                                <option value="General">General</option>
                                            </select>
                                            <div class="form-help">Primary type of cuisine served</div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="description" class="form-label">Description</label>
                                    <textarea class="form-control" id="description" name="description" rows="3" 
                                              placeholder="Describe the restaurant, its specialties, and atmosphere" maxlength="1000"></textarea>
                                    <div class="form-help">Optional description to help customers understand what makes this restaurant special</div>
                                </div>
                                </div>
                            </div>

                            <!-- Contact Information Section -->
                            <div class="glass-card mb-4">
                                <div class="card-body">
                                    <h6 class="section-title">
                                        <i class="fas fa-address-book me-2"></i>Contact Information
                                    </h6>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="phone" class="form-label">
                                                Phone Number <span class="required">*</span>
                                            </label>
                                            <input type="tel" class="form-control" id="phone" name="phone" required 
                                                   placeholder="(555) 123-4567" maxlength="20">
                                            <div class="form-help">Primary contact number for the restaurant</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="email" class="form-label">
                                                Email Address <span class="required">*</span>
                                            </label>
                                            <input type="email" class="form-control" id="email" name="email" required 
                                                   placeholder="restaurant@example.com" maxlength="255">
                                            <div class="form-help">Contact email for business communications</div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="address" class="form-label">
                                        Address <span class="required">*</span>
                                    </label>
                                    <textarea class="form-control" id="address" name="address" rows="2" required 
                                              placeholder="123 Main Street, City, State, ZIP Code" maxlength="500"></textarea>
                                    <div class="form-help">Full address including street, city, state, and ZIP code</div>
                                </div>
                                </div>
                            </div>

                            <!-- Business Information Section -->
                            <div class="glass-card mb-4">
                                <div class="card-body">
                                    <h6 class="section-title">
                                        <i class="fas fa-business-time me-2"></i>Business Information
                                    </h6>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="openingHours" class="form-label">
                                                Opening Hours <span class="required">*</span>
                                            </label>
                                            <input type="text" class="form-control" id="openingHours" name="openingHours" required 
                                                   placeholder="Mon-Sun: 9:00 AM - 10:00 PM" maxlength="100">
                                            <div class="form-help">Operating hours (e.g., "Mon-Fri: 9AM-9PM, Sat-Sun: 10AM-10PM")</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="deliveryFee" class="form-label">
                                                Delivery Fee ($) <span class="required">*</span>
                                            </label>
                                            <input type="number" class="form-control" id="deliveryFee" name="deliveryFee" 
                                                   step="0.01" min="0" max="50" required placeholder="2.99">
                                            <div class="form-help">Standard delivery fee charged to customers</div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="minOrderAmount" class="form-label">
                                                Minimum Order Amount ($) <span class="required">*</span>
                                            </label>
                                            <input type="number" class="form-control" id="minOrderAmount" name="minOrderAmount" 
                                                   step="0.01" min="0" max="100" required placeholder="15.00">
                                            <div class="form-help">Minimum order value required for delivery</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Initial Status</label>
                                            <div class="form-control-plaintext">
                                                <span class="badge bg-success">
                                                    <i class="fas fa-check-circle me-1"></i>Active
                                                </span>
                                                <div class="form-help">Restaurant will be activated automatically</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                </div>
                            </div>

                            <!-- Form Actions -->
                            <div class="glass-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <button type="button" class="btn btn-outline-secondary" onclick="resetForm()">
                                                <i class="fas fa-undo me-1"></i>Reset Form
                                            </button>
                                        </div>
                                        <div>
                                            <a href="${pageContext.request.contextPath}/admin/restaurants" class="btn btn-secondary me-2">
                                                <i class="fas fa-times me-1"></i>Cancel
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-plus me-1"></i>Add Restaurant
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Form Validation Help Modal -->
    <div class="modal fade" id="validationHelpModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Form Validation Guide</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <h6>Required Fields (<span class="required">*</span>):</h6>
                    <ul class="small">
                        <li><strong>Restaurant Name:</strong> Must be unique and descriptive</li>
                        <li><strong>Cuisine Type:</strong> Select the primary cuisine category</li>
                        <li><strong>Phone Number:</strong> Valid contact number</li>
                        <li><strong>Email:</strong> Valid email address format</li>
                        <li><strong>Address:</strong> Complete physical address</li>
                        <li><strong>Opening Hours:</strong> Clear operating schedule</li>
                        <li><strong>Delivery Fee:</strong> Amount between $0.00 - $50.00</li>
                        <li><strong>Min Order:</strong> Amount between $0.00 - $100.00</li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
    <script>
        // Initialize theme on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Load saved form data
            loadFormData();
            
            // Form validation and enhancement
            const form = document.getElementById('restaurantForm');
            const phoneInput = document.getElementById('phone');
            const emailInput = document.getElementById('email');
            
            // Phone number formatting
            phoneInput.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value.length >= 6) {
                    value = value.replace(/(\d{3})(\d{3})(\d{4})/, '($1) $2-$3');
                } else if (value.length >= 3) {
                    value = value.replace(/(\d{3})(\d{0,3})/, '($1) $2');
                }
                e.target.value = value;
            });
            
            // Form submission validation
            form.addEventListener('submit', function(e) {
                if (!form.checkValidity()) {
                    e.preventDefault();
                    e.stopPropagation();
                }
                form.classList.add('was-validated');
            });
            
            // Real-time validation feedback
            const inputs = form.querySelectorAll('input, select, textarea');
            inputs.forEach(input => {
                input.addEventListener('blur', function() {
                    if (input.checkValidity()) {
                        input.classList.remove('is-invalid');
                        input.classList.add('is-valid');
                    } else {
                        input.classList.remove('is-valid');
                        input.classList.add('is-invalid');
                    }
                });
            });
        });
        
        function resetForm() {
            const form = document.getElementById('restaurantForm');
            form.reset();
            form.classList.remove('was-validated');
            
            // Remove validation classes
            const inputs = form.querySelectorAll('input, select, textarea');
            inputs.forEach(input => {
                input.classList.remove('is-valid', 'is-invalid');
            });
        }
        
        function showValidationHelp() {
            const modal = new bootstrap.Modal(document.getElementById('validationHelpModal'));
            modal.show();
        }
        
        // Auto-save form data to localStorage (optional feature)
        function saveFormData() {
            const form = document.getElementById('restaurantForm');
            const formData = new FormData(form);
            const data = {};
            
            formData.forEach((value, key) => {
                data[key] = value;
            });
            
            localStorage.setItem('addRestaurantForm', JSON.stringify(data));
        }
        
        function loadFormData() {
            const savedData = localStorage.getItem('addRestaurantForm');
            if (savedData) {
                const data = JSON.parse(savedData);
                Object.keys(data).forEach(key => {
                    const input = document.querySelector(`[name="${key}"]`);
                    if (input) {
                        input.value = data[key];
                    }
                });
            }
        }
        
        // Save form data on input changes
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('restaurantForm');
            form.addEventListener('input', saveFormData);
            
            // Clear saved data on successful submission
            form.addEventListener('submit', function() {
                localStorage.removeItem('addRestaurantForm');
            });
        });
    </script>
</body>
</html>
