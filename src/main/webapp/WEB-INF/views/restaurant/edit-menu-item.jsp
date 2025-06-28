<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Menu Item - Restaurant Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/global-styles.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/restaurant/dashboard">
                <i class="fas fa-utensils me-2"></i>Restaurant Portal
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
                            <i class="fas fa-utensils me-1"></i>Menu
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/restaurant/orders">
                            <i class="fas fa-shopping-cart me-1"></i>Orders
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
                            <c:out value="${sessionScope.user.fullName}" default="Restaurant"/>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/restaurant/profile">
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
                        <i class="fas fa-edit me-2"></i>Edit Menu Item
                    </h1>
                    <p class="mb-0">Update menu item details and settings</p>
                </div>
                <div class="col-md-4 text-center">
                    <i class="fas fa-utensils fa-3x"></i>
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

                        <form action="${pageContext.request.contextPath}/restaurant/menu/edit/${menuItem.id}" method="post" 
                              enctype="multipart/form-data" id="menuItemForm">
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
                                                    Item Name <span class="required">*</span>
                                                </label>
                                                <input type="text" class="form-control" id="name" name="name" required 
                                                       value="<c:out value="${menuItem.name}"/>" 
                                                       placeholder="Enter item name" maxlength="255">
                                                <div class="form-help">The name of the menu item</div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="category" class="form-label">
                                                    Category <span class="required">*</span>
                                                </label>
                                                <select class="form-select" id="category" name="category" required>
                                                    <option value="">Select category</option>
                                                    <option value="Pizza" ${menuItem.category == 'Pizza' ? 'selected' : ''}>Pizza</option>
                                                    <option value="Burger" ${menuItem.category == 'Burger' ? 'selected' : ''}>Burger</option>
                                                    <option value="Pasta" ${menuItem.category == 'Pasta' ? 'selected' : ''}>Pasta</option>
                                                    <option value="Salad" ${menuItem.category == 'Salad' ? 'selected' : ''}>Salad</option>
                                                    <option value="Fish" ${menuItem.category == 'Fish' ? 'selected' : ''}>Fish</option>
                                                    <option value="Meat" ${menuItem.category == 'Meat' ? 'selected' : ''}>Meat</option>
                                                    <option value="Curry" ${menuItem.category == 'Curry' ? 'selected' : ''}>Curry</option>
                                                    <option value="Sushi" ${menuItem.category == 'Sushi' ? 'selected' : ''}>Sushi</option>
                                                    <option value="Appetizer" ${menuItem.category == 'Appetizer' ? 'selected' : ''}>Appetizer</option>
                                                    <option value="Side" ${menuItem.category == 'Side' ? 'selected' : ''}>Side Dish</option>
                                                    <option value="Dessert" ${menuItem.category == 'Dessert' ? 'selected' : ''}>Dessert</option>
                                                    <option value="Beverage" ${menuItem.category == 'Beverage' ? 'selected' : ''}>Beverage</option>
                                                    <option value="Bowl" ${menuItem.category == 'Bowl' ? 'selected' : ''}>Bowl</option>
                                                </select>
                                                <div class="form-help">Category for menu organization</div>
                                            </div>
                                        </div>
                                    </div>
                                
                                    <div class="mb-3">
                                        <label for="description" class="form-label">Description</label>
                                        <textarea class="form-control" id="description" name="description" rows="3" 
                                                  placeholder="Describe the menu item, ingredients, and preparation style" maxlength="1000"><c:out value="${menuItem.description}"/></textarea>
                                        <div class="form-help">Detailed description to help customers understand the item</div>
                                    </div>
                                    
                                    <!-- Image Section -->
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="itemImage" class="form-label">
                                                    <i class="fas fa-image me-2"></i>Item Image
                                                </label>
                                                <input type="file" class="form-control" id="itemImage" name="itemImage" 
                                                       accept="image/*" onchange="previewImage(this)">
                                                <div class="form-help">Upload a new image to replace the current one</div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <!-- Current Image Display -->
                                            <div class="mb-3">
                                                <label class="form-label">Current Image</label>
                                                <div class="current-image-wrapper">
                                                    <img id="currentImage" 
                                                         src="${pageContext.request.contextPath}/resources/images/menu-items/${menuItem.id}.jpg?v=${System.currentTimeMillis()}" 
                                                         alt="<c:out value='${menuItem.name}'/>"
                                                         onerror="this.src='${pageContext.request.contextPath}/resources/images/menu-items/default.svg'"
                                                         style="max-width: 150px; max-height: 150px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Image Preview -->
                                    <div class="mb-3" id="imagePreviewContainer" style="display: none;">
                                        <label class="form-label">
                                            <i class="fas fa-eye me-2"></i>New Image Preview
                                        </label>
                                        <div class="image-preview-wrapper">
                                            <img id="imagePreview" src="" alt="Preview" style="max-width: 200px; max-height: 200px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
                                            <button type="button" class="btn btn-sm btn-outline-danger ms-3" onclick="removeImage()">
                                                <i class="fas fa-times me-1"></i>Remove
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Pricing and Availability Section -->
                            <div class="glass-card mb-4">
                                <div class="card-body">
                                    <h6 class="section-title">
                                        <i class="fas fa-dollar-sign me-2"></i>Pricing and Availability
                                    </h6>
                                
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="price" class="form-label">
                                                    Price ($) <span class="required">*</span>
                                                </label>
                                                <input type="number" class="form-control" id="price" name="price" 
                                                       step="0.01" min="0" max="999.99" required 
                                                       value="${menuItem.price}" placeholder="0.00">
                                                <div class="form-help">Price in USD</div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="available" class="form-label">Availability Status</label>
                                                <select class="form-select" id="available" name="available">
                                                    <option value="true" ${menuItem.available ? 'selected' : ''}>Available</option>
                                                    <option value="false" ${!menuItem.available ? 'selected' : ''}>Not Available</option>
                                                </select>
                                                <div class="form-help">Whether this item is currently available for order</div>
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
                                                <i class="fas fa-undo me-1"></i>Reset Changes
                                            </button>
                                        </div>
                                        <div>
                                            <a href="${pageContext.request.contextPath}/restaurant/menu" class="btn btn-secondary me-2">
                                                <i class="fas fa-times me-1"></i>Cancel
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save me-1"></i>Update Item
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
        function previewImage(input) {
            const file = input.files[0];
            const previewContainer = document.getElementById('imagePreviewContainer');
            const preview = document.getElementById('imagePreview');
            
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    previewContainer.style.display = 'block';
                };
                reader.readAsDataURL(file);
            } else {
                previewContainer.style.display = 'none';
            }
        }
        
        function removeImage() {
            const input = document.getElementById('itemImage');
            const previewContainer = document.getElementById('imagePreviewContainer');
            const preview = document.getElementById('imagePreview');
            
            input.value = '';
            preview.src = '';
            previewContainer.style.display = 'none';
        }

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Form validation and enhancement
            const form = document.getElementById('menuItemForm');
            
            // Form submission validation
            form.addEventListener('submit', function(e) {
                console.log('Form submission started');
                
                // Debug form data
                const formData = new FormData(form);
                console.log('Form data:');
                for (let [key, value] of formData.entries()) {
                    console.log(key + ': ' + value);
                }
                
                // Use browser's built-in validation
                if (!form.checkValidity()) {
                    e.preventDefault();
                    e.stopPropagation();
                    console.log('Form validation failed - using browser validation');
                    form.classList.add('was-validated');
                    return false;
                } 
                
                console.log('Form validation passed, submitting...');
                return true;
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
            const form = document.getElementById('menuItemForm');
            const originalData = {
                name: '<c:out value="${menuItem.name}"/>',
                category: '<c:out value="${menuItem.category}"/>',
                description: '<c:out value="${menuItem.description}"/>',
                price: '${menuItem.price}',
                available: '${menuItem.available}'
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
