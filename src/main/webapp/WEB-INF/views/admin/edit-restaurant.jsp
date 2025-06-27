<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Restaurant - Admin</title>
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
                        <i class="fas fa-edit me-2"></i>Edit Restaurant
                    </h1>
                    <p class="mb-0">Update restaurant information and settings</p>
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

                        <form action="${pageContext.request.contextPath}/admin/restaurants/${restaurant.id}/edit" method="post" id="restaurantForm">
                            <input type="hidden" name="id" value="${restaurant.id}">
                            
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
                                                       value="<c:out value='${restaurant.name}'/>" maxlength="255">
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
                                                    <option value="Italian" ${restaurant.cuisineType == 'Italian' ? 'selected' : ''}>Italian</option>
                                                    <option value="Chinese" ${restaurant.cuisineType == 'Chinese' ? 'selected' : ''}>Chinese</option>
                                                    <option value="American" ${restaurant.cuisineType == 'American' ? 'selected' : ''}>American</option>
                                                    <option value="Mexican" ${restaurant.cuisineType == 'Mexican' ? 'selected' : ''}>Mexican</option>
                                                    <option value="Japanese" ${restaurant.cuisineType == 'Japanese' ? 'selected' : ''}>Japanese</option>
                                                    <option value="Indian" ${restaurant.cuisineType == 'Indian' ? 'selected' : ''}>Indian</option>
                                                    <option value="Thai" ${restaurant.cuisineType == 'Thai' ? 'selected' : ''}>Thai</option>
                                                    <option value="Mediterranean" ${restaurant.cuisineType == 'Mediterranean' ? 'selected' : ''}>Mediterranean</option>
                                                    <option value="French" ${restaurant.cuisineType == 'French' ? 'selected' : ''}>French</option>
                                                    <option value="Korean" ${restaurant.cuisineType == 'Korean' ? 'selected' : ''}>Korean</option>
                                                    <option value="Vietnamese" ${restaurant.cuisineType == 'Vietnamese' ? 'selected' : ''}>Vietnamese</option>
                                                    <option value="Greek" ${restaurant.cuisineType == 'Greek' ? 'selected' : ''}>Greek</option>
                                                    <option value="Turkish" ${restaurant.cuisineType == 'Turkish' ? 'selected' : ''}>Turkish</option>
                                                    <option value="Lebanese" ${restaurant.cuisineType == 'Lebanese' ? 'selected' : ''}>Lebanese</option>
                                                    <option value="Brazilian" ${restaurant.cuisineType == 'Brazilian' ? 'selected' : ''}>Brazilian</option>
                                                    <option value="Fast Food" ${restaurant.cuisineType == 'Fast Food' ? 'selected' : ''}>Fast Food</option>
                                                    <option value="Seafood" ${restaurant.cuisineType == 'Seafood' ? 'selected' : ''}>Seafood</option>
                                                    <option value="Vegetarian" ${restaurant.cuisineType == 'Vegetarian' ? 'selected' : ''}>Vegetarian</option>
                                                    <option value="Vegan" ${restaurant.cuisineType == 'Vegan' ? 'selected' : ''}>Vegan</option>
                                                    <option value="General" ${restaurant.cuisineType == 'General' ? 'selected' : ''}>General</option>
                                                </select>
                                                <div class="form-help">Primary type of cuisine served</div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="description" class="form-label">Description</label>
                                        <textarea class="form-control" id="description" name="description" rows="3" 
                                                  maxlength="1000"><c:out value='${restaurant.description}'/></textarea>
                                        <div class="form-help">Description of the restaurant and its specialties</div>
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
                                                       value="<c:out value='${restaurant.phone}'/>" maxlength="20">
                                                <div class="form-help">Primary contact number for the restaurant</div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="email" class="form-label">
                                                    Email Address <span class="required">*</span>
                                                </label>
                                                <input type="email" class="form-control" id="email" name="email" required 
                                                       value="<c:out value='${restaurant.email}'/>" maxlength="255">
                                                <div class="form-help">Contact email for business communications</div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="address" class="form-label">
                                            Address <span class="required">*</span>
                                        </label>
                                        <textarea class="form-control" id="address" name="address" rows="2" required 
                                                  maxlength="500"><c:out value='${restaurant.address}'/></textarea>
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
                                                       value="<c:out value='${restaurant.openingHours}'/>" maxlength="100">
                                                <div class="form-help">Operating hours (e.g., "Mon-Fri: 9AM-9PM, Sat-Sun: 10AM-10PM")</div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="deliveryFee" class="form-label">
                                                    Delivery Fee ($) <span class="required">*</span>
                                                </label>
                                                <input type="number" class="form-control" id="deliveryFee" name="deliveryFee" 
                                                       step="0.01" min="0" max="50" required value="${restaurant.deliveryFee}">
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
                                                       step="0.01" min="0" max="100" required value="${restaurant.minOrderAmount}">
                                                <div class="form-help">Minimum order value required for delivery</div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="isActive" class="form-label">
                                                    Status <span class="required">*</span>
                                                </label>
                                                <select class="form-select" id="isActive" name="isActive" required>
                                                    <option value="true" ${restaurant.active ? 'selected' : ''}>Active</option>
                                                    <option value="false" ${!restaurant.active ? 'selected' : ''}>Inactive</option>
                                                </select>
                                                <div class="form-help">Current operational status</div>
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
                                            <a href="${pageContext.request.contextPath}/admin/restaurants" class="btn btn-outline-secondary">
                                                <i class="fas fa-arrow-left me-1"></i>Back to List
                                            </a>
                                        </div>
                                        <div>
                                            <button type="button" class="btn btn-secondary me-2" onclick="resetForm()">
                                                <i class="fas fa-undo me-1"></i>Reset Changes
                                            </button>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save me-1"></i>Update Restaurant
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Form validation and enhancement
            const form = document.getElementById('restaurantForm');
            const phoneInput = document.getElementById('phone');
            
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
            const originalData = {
                name: '<c:out value="${restaurant.name}"/>',
                cuisineType: '<c:out value="${restaurant.cuisineType}"/>',
                description: '<c:out value="${restaurant.description}"/>',
                phone: '<c:out value="${restaurant.phone}"/>',
                email: '<c:out value="${restaurant.email}"/>',
                address: '<c:out value="${restaurant.address}"/>',
                openingHours: '<c:out value="${restaurant.openingHours}"/>',
                deliveryFee: '${restaurant.deliveryFee}',
                minOrderAmount: '${restaurant.minOrderAmount}',
                isActive: '${restaurant.active}'
            };
            
            Object.keys(originalData).forEach(key => {
                const input = form.querySelector(`[name="${key}"]`);
                if (input) {
                    input.value = originalData[key];
                }
            });
            
            form.classList.remove('was-validated');
            const inputs = form.querySelectorAll('input, select, textarea');
            inputs.forEach(input => {
                input.classList.remove('is-valid', 'is-invalid');
            });
        }
    </script>
</body>
</html>
