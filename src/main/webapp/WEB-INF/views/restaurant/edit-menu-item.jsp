<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Menu Item - Restaurant Staff</title>
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
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/restaurant/dashboard">
                <i class="fas fa-utensils me-2"></i>Food Delivery System
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/restaurant/dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/restaurant/menu">
                            <i class="fas fa-utensils me-1"></i>Menu Management
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/restaurant/orders">
                            <i class="fas fa-shopping-cart me-1"></i>Orders
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
                        <h2><i class="fas fa-edit me-2"></i>Edit Menu Item</h2>
                        <p class="text-muted mb-0">Update menu item information</p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/restaurant/menu" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Back to Menu
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header bg-light">
                        <h5 class="mb-0"><i class="fas fa-hamburger me-2"></i>Menu Item Information</h5>
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

                        <form action="${pageContext.request.contextPath}/restaurant/menu/edit/${menuItem.id}" method="post" id="menuItemForm">
                            <!-- Basic Information Section -->
                            <div class="form-section">
                                <h6 class="section-title">
                                    <i class="fas fa-info-circle me-2"></i>Basic Information
                                </h6>
                                
                                <div class="mb-3">
                                    <label for="name" class="form-label">
                                        Item Name <span class="required">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="name" name="name" required 
                                           placeholder="Enter menu item name" maxlength="255" value="${menuItem.name}">
                                    <div class="form-help">The name of the menu item as it will appear to customers</div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="description" class="form-label">Description</label>
                                    <textarea class="form-control" id="description" name="description" rows="3" 
                                              placeholder="Describe the menu item, ingredients, and special features" maxlength="500">${menuItem.description}</textarea>
                                    <div class="form-help">Optional description to help customers understand what this item is</div>
                                </div>
                            </div>

                            <!-- Pricing and Category Section -->
                            <div class="form-section">
                                <h6 class="section-title">
                                    <i class="fas fa-tags me-2"></i>Pricing and Category
                                </h6>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="price" class="form-label">
                                                Price ($) <span class="required">*</span>
                                            </label>
                                            <input type="number" class="form-control" id="price" name="price" 
                                                   step="0.01" min="0" max="999.99" required placeholder="0.00" value="${menuItem.price}">
                                            <div class="form-help">Price in USD (e.g., 12.99)</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="category" class="form-label">
                                                Category <span class="required">*</span>
                                            </label>
                                            <select class="form-select" id="category" name="category" required>
                                                <option value="">Select category</option>
                                                <option value="Appetizers" ${menuItem.category == 'Appetizers' ? 'selected' : ''}>Appetizers</option>
                                                <option value="Main Course" ${menuItem.category == 'Main Course' ? 'selected' : ''}>Main Course</option>
                                                <option value="Desserts" ${menuItem.category == 'Desserts' ? 'selected' : ''}>Desserts</option>
                                                <option value="Beverages" ${menuItem.category == 'Beverages' ? 'selected' : ''}>Beverages</option>
                                                <option value="Salads" ${menuItem.category == 'Salads' ? 'selected' : ''}>Salads</option>
                                                <option value="Soups" ${menuItem.category == 'Soups' ? 'selected' : ''}>Soups</option>
                                                <option value="Sides" ${menuItem.category == 'Sides' ? 'selected' : ''}>Sides</option>
                                                <option value="Specials" ${menuItem.category == 'Specials' ? 'selected' : ''}>Specials</option>
                                                <option value="Pizza" ${menuItem.category == 'Pizza' ? 'selected' : ''}>Pizza</option>
                                                <option value="Pasta" ${menuItem.category == 'Pasta' ? 'selected' : ''}>Pasta</option>
                                                <option value="Sandwiches" ${menuItem.category == 'Sandwiches' ? 'selected' : ''}>Sandwiches</option>
                                                <option value="Burgers" ${menuItem.category == 'Burgers' ? 'selected' : ''}>Burgers</option>
                                                <option value="Seafood" ${menuItem.category == 'Seafood' ? 'selected' : ''}>Seafood</option>
                                                <option value="Vegetarian" ${menuItem.category == 'Vegetarian' ? 'selected' : ''}>Vegetarian</option>
                                                <option value="Vegan" ${menuItem.category == 'Vegan' ? 'selected' : ''}>Vegan</option>
                                                <option value="Other" ${menuItem.category == 'Other' ? 'selected' : ''}>Other</option>
                                            </select>
                                            <div class="form-help">Category to help customers find this item</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Availability Section -->
                            <div class="form-section">
                                <h6 class="section-title">
                                    <i class="fas fa-clock me-2"></i>Availability
                                </h6>
                                
                                <div class="mb-3">
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="available" name="available" 
                                               ${menuItem.available ? 'checked' : ''}>
                                        <label class="form-check-label" for="available">
                                            <strong>Item Available</strong>
                                        </label>
                                    </div>
                                    <div class="form-help">Uncheck to temporarily make this item unavailable to customers</div>
                                </div>
                            </div>

                            <!-- Restaurant Information (Read-only) -->
                            <c:if test="${not empty restaurant}">
                                <div class="form-section">
                                    <h6 class="section-title">
                                        <i class="fas fa-store me-2"></i>Restaurant Information
                                    </h6>
                                    
                                    <div class="alert alert-info">
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-info-circle me-2"></i>
                                            <div>
                                                <strong>${restaurant.name}</strong><br>
                                                <small class="text-muted">${restaurant.cuisineType} Cuisine</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Form Actions -->
                            <div class="d-flex justify-content-between">
                                <div>
                                    <button type="button" class="btn btn-outline-secondary" onclick="resetForm()">
                                        <i class="fas fa-undo me-1"></i>Reset Form
                                    </button>
                                </div>
                                <div>
                                    <a href="${pageContext.request.contextPath}/restaurant/menu" class="btn btn-secondary me-2">
                                        <i class="fas fa-times me-1"></i>Cancel
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-1"></i>Update Menu Item
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
            const form = document.getElementById('menuItemForm');
            const priceInput = document.getElementById('price');
            
            // Price input formatting
            priceInput.addEventListener('input', function(e) {
                let value = parseFloat(e.target.value);
                if (value < 0) {
                    e.target.value = 0;
                } else if (value > 999.99) {
                    e.target.value = 999.99;
                }
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
                document.getElementById('menuItemForm').reset();
                // Remove validation classes
                document.querySelectorAll('.is-valid, .is-invalid').forEach(el => {
                    el.classList.remove('is-valid', 'is-invalid');
                });
            }
        }
    </script>
</body>
</html>
