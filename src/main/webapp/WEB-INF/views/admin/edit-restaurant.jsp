<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Restaurant - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .form-section {
            background-color: #f8f9fa;
            border-radius: 0.375rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .section-title {
            color: #495057;
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 1rem;
            border-bottom: 2px solid #dee2e6;
            padding-bottom: 0.5rem;
        }
        .required {
            color: #dc3545;
        }
        .form-help {
            font-size: 0.875rem;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-danger">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-utensils me-2"></i>Food Delivery System
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
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user me-1"></i>${sessionScope.user.fullName}
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                <i class="fas fa-user me-2"></i>Profile
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                <i class="fas fa-sign-out-alt me-2"></i>Logout
                            </a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2><i class="fas fa-edit me-2"></i>Edit Restaurant</h2>
                        <p class="text-muted mb-0">Update restaurant information</p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/restaurants" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Back to Restaurants
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-light">
                        <h5 class="mb-0"><i class="fas fa-store me-2"></i>Restaurant Information</h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/admin/restaurants/${restaurant.id}/edit" method="post" id="restaurantForm">
                            <!-- Basic Information Section -->
                            <div class="form-section">
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
                                                   placeholder="Enter restaurant name" maxlength="255" value="${restaurant.name}">
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
                                              placeholder="Describe the restaurant, its specialties, and atmosphere" maxlength="1000">${restaurant.description}</textarea>
                                    <div class="form-help">Optional description to help customers understand what makes this restaurant special</div>
                                </div>
                            </div>

                            <!-- Contact Information Section -->
                            <div class="form-section">
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
                                                   placeholder="(555) 123-4567" maxlength="20" value="${restaurant.phone}">
                                            <div class="form-help">Primary contact number for the restaurant</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="email" class="form-label">
                                                Email Address <span class="required">*</span>
                                            </label>
                                            <input type="email" class="form-control" id="email" name="email" required 
                                                   placeholder="restaurant@example.com" maxlength="255" value="${restaurant.email}">
                                            <div class="form-help">Contact email for business communications</div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="address" class="form-label">
                                        Address <span class="required">*</span>
                                    </label>
                                    <textarea class="form-control" id="address" name="address" rows="2" required 
                                              placeholder="123 Main Street, City, State, ZIP Code" maxlength="500">${restaurant.address}</textarea>
                                    <div class="form-help">Full address including street, city, state, and ZIP code</div>
                                </div>
                            </div>

                            <!-- Business Information Section -->
                            <div class="form-section">
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
                                                   placeholder="Mon-Sun: 9:00 AM - 10:00 PM" maxlength="100" value="${restaurant.openingHours}">
                                            <div class="form-help">Operating hours (e.g., "Mon-Fri: 9AM-9PM, Sat-Sun: 10AM-10PM")</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="deliveryFee" class="form-label">
                                                Delivery Fee ($) <span class="required">*</span>
                                            </label>
                                            <input type="number" class="form-control" id="deliveryFee" name="deliveryFee" 
                                                   step="0.01" min="0" max="50" required placeholder="2.99" value="${restaurant.deliveryFee}">
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
                                                   step="0.01" min="0" max="100" required placeholder="15.00" value="${restaurant.minOrderAmount}">
                                            <div class="form-help">Minimum order value required for delivery</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Current Status</label>
                                            <div class="form-control-plaintext">
                                                <c:if test="${restaurant.active}">
                                                    <span class="badge bg-success">
                                                        <i class="fas fa-check-circle me-1"></i>Active
                                                    </span>
                                                </c:if>
                                                <c:if test="${!restaurant.active}">
                                                    <span class="badge bg-danger">
                                                        <i class="fas fa-times-circle me-1"></i>Inactive
                                                    </span>
                                                </c:if>
                                                <div class="form-help">Use the toggle button in the main list to change status</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Form Actions -->
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
                                        <i class="fas fa-save me-1"></i>Update Restaurant
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation and enhancement
        document.addEventListener('DOMContentLoaded', function() {
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
            if (confirm('Are you sure you want to reset all changes? This will restore the original values.')) {
                location.reload();
            }
        }
    </script>
</body>
</html>
