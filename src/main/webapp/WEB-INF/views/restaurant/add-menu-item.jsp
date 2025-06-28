<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Menu Item - Restaurant Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/global-styles.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/restaurant/dashboard">
                <i class="fas fa-utensils me-2"></i>FoodDelivery
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/restaurant/dashboard">
                            <i class="fas fa-home me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/restaurant/menu">
                            <i class="fas fa-utensils me-1"></i>Menu
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/restaurant/orders">
                            <i class="fas fa-receipt me-1"></i>Orders
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <button class="theme-toggle" onclick="toggleTheme()" title="Toggle theme">
                            <i id="theme-icon" class="fas fa-moon"></i>
                        </button>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user me-1"></i><c:out value="${user.fullName}" default="Restaurant"/>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                <i class="fas fa-user-edit me-2"></i>Profile
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
        <!-- Page Header -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-plus me-2"></i>Add New Menu Item</h3>
                        <p class="mb-0">Add a new item to your restaurant menu</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add Item Form -->
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-utensils me-2"></i>Item Details</h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-circle me-2"></i><c:out value="${error}"/>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/restaurant/menu/add" method="post">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="name" class="form-label">
                                        <i class="fas fa-utensils me-2"></i>Item Name <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="name" name="name" required
                                           placeholder="Enter item name">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="price" class="form-label">
                                        <i class="fas fa-dollar-sign me-2"></i>Price ($) <span class="text-danger">*</span>
                                    </label>
                                    <input type="number" class="form-control" id="price" name="price" 
                                           step="0.01" min="0" required placeholder="0.00">
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">
                                    <i class="fas fa-align-left me-2"></i>Description
                                </label>
                                <textarea class="form-control" id="description" name="description" 
                                          rows="3" placeholder="Describe the item..."></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="category" class="form-label">
                                    <i class="fas fa-tags me-2"></i>Category <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="category" name="category" required>
                                    <option value="">Select Category</option>
                                    <option value="Pizza">Pizza</option>
                                    <option value="Burger">Burger</option>
                                    <option value="Pasta">Pasta</option>
                                    <option value="Salad">Salad</option>
                                    <option value="Fish">Fish</option>
                                    <option value="Meat">Meat</option>
                                    <option value="Curry">Curry</option>
                                    <option value="Sushi">Sushi</option>
                                    <option value="Appetizer">Appetizer</option>
                                    <option value="Side">Side Dish</option>
                                    <option value="Dessert">Dessert</option>
                                    <option value="Beverage">Beverage</option>
                                    <option value="Bowl">Bowl</option>
                                </select>
                            </div>
                            
                            <div class="d-flex gap-2 pt-3">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Add Menu Item
                                </button>
                                <a href="${pageContext.request.contextPath}/restaurant/menu" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Back to Menu
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
    <script>
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const name = document.getElementById('name').value.trim();
            const price = document.getElementById('price').value;
            const category = document.getElementById('category').value;

            if (!name || !price || !category) {
                e.preventDefault();
                alert('Please fill in all required fields.');
                return false;
            }

            if (parseFloat(price) <= 0) {
                e.preventDefault();
                alert('Price must be greater than 0.');
                return false;
            }
        });
    </script>
</body>
</html>
