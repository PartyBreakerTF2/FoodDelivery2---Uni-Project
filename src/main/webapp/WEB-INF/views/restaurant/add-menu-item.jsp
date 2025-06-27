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

                        <form action="${pageContext.request.contextPath}/restaurant/menu/add" method="post" enctype="multipart/form-data">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="name" class="form-label">
                                        <i class="fas fa-utensils me-2"></i>Item Name
                                    </label>
                                    <input type="text" class="form-control" id="name" name="name" required
                                           placeholder="Enter item name">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="price" class="form-label">
                                        <i class="fas fa-dollar-sign me-2"></i>Price
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
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="category" class="form-label">
                                        <i class="fas fa-tags me-2"></i>Category
                                    </label>
                                    <select class="form-select" id="category" name="category" required>
                                        <option value="">Select Category</option>
                                        <option value="appetizers">Appetizers</option>
                                        <option value="main-course">Main Course</option>
                                        <option value="desserts">Desserts</option>
                                        <option value="beverages">Beverages</option>
                                        <option value="specials">Specials</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="preparationTime" class="form-label">
                                        <i class="fas fa-clock me-2"></i>Preparation Time (minutes)
                                    </label>
                                    <input type="number" class="form-control" id="preparationTime" 
                                           name="preparationTime" min="1" placeholder="15">
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="image" class="form-label">
                                        <i class="fas fa-image me-2"></i>Item Image
                                    </label>
                                    <input type="file" class="form-control" id="image" name="image" 
                                           accept="image/*">
                                    <div class="form-text">Upload an image for this menu item (optional)</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <div class="form-check mt-4">
                                        <input class="form-check-input" type="checkbox" id="available" 
                                               name="available" checked>
                                        <label class="form-check-label" for="available">
                                            <i class="fas fa-check-circle me-2"></i>Available for order
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="featured" 
                                               name="featured">
                                        <label class="form-check-label" for="featured">
                                            <i class="fas fa-star me-2"></i>Featured item
                                        </label>
                                    </div>
                                </div>
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
        // Image preview functionality
        document.getElementById('image').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    // Create or update image preview
                    let preview = document.getElementById('imagePreview');
                    if (!preview) {
                        preview = document.createElement('img');
                        preview.id = 'imagePreview';
                        preview.className = 'img-thumbnail mt-2';
                        preview.style.maxWidth = '200px';
                        e.target.parentNode.appendChild(preview);
                    }
                    preview.src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        });

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
            line-height: 1.6;
            min-height: 100vh;
            transition: all 0.3s ease;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            opacity: 0.1;
            z-index: -1;
            transition: opacity 0.3s ease;
        }

        [data-theme="dark"] body::before {
            opacity: 0.2;
        }

        .glass-nav {
            background: var(--glass-bg);
            backdrop-filter: blur(20px) saturate(180%);
            border-bottom: 1px solid var(--glass-border);
            transition: all 0.3s ease;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .nav-link {
            color: var(--text-primary) !important;
            font-weight: 500;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-link:hover {
            color: var(--primary-color) !important;
            transform: translateY(-2px);
        }

        .nav-link.active {
            color: var(--primary-color) !important;
        }

        .nav-link::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 50%;
            width: 0;
            height: 2px;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }

        .nav-link:hover::after,
        .nav-link.active::after {
            width: 80%;
        }

        .dropdown-menu {
            background: var(--glass-bg);
            backdrop-filter: blur(20px) saturate(180%);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            box-shadow: var(--shadow);
            margin-top: 10px;
        }

        .dropdown-item {
            color: var(--text-primary);
            transition: all 0.3s ease;
        }

        .dropdown-item:hover {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            transform: translateX(5px);
        }

        .theme-toggle {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 50px;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            color: var(--text-primary);
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }

        .theme-toggle:hover {
            transform: scale(1.1) rotate(180deg);
            box-shadow: var(--shadow);
        }

        .glass-card {
            background: var(--card-bg);
            backdrop-filter: blur(20px) saturate(180%);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            box-shadow: var(--shadow);
            transition: all 0.3s ease;
            overflow: hidden;
        }

        .glass-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(31, 38, 135, 0.4);
        }

        .form-control {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: 15px;
            color: var(--text-primary);
            transition: all 0.3s ease;
            padding: 0.75rem 1rem;
        }

        .form-control:focus {
            background: var(--card-bg);
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(16, 185, 129, 0.25);
            color: var(--text-primary);
        }

        .form-control::placeholder {
            color: var(--text-secondary);
        }

        .form-label {
            color: var(--text-primary);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .btn {
            border-radius: 15px;
            font-weight: 600;
            padding: 0.75rem 1.5rem;
            border: none;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(16, 185, 129, 0.6);
        }

        .btn-secondary {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            color: var(--text-primary);
        }

        .btn-secondary:hover {
            background: linear-gradient(135deg, var(--text-secondary), var(--text-primary));
            color: white;
            transform: translateY(-2px);
        }

        .page-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 200px;
            height: 200px;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            border-radius: 50%;
            transform: translate(50%, -50%);
        }

        .form-control-plaintext {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 15px;
            padding: 0.75rem 1rem;
            color: var(--text-primary);
        }

        @media (max-width: 768px) {
            .theme-toggle {
                width: 45px;
                height: 45px;
                top: 15px;
                right: 15px;
            }

            .page-header {
                padding: 1.5rem;
                margin-bottom: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg glass-nav fixed-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/restaurant/dashboard">
                <i class="fas fa-utensils me-2"></i>FoodDelivery
            </a>
            
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
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
                            <i class="fas fa-user me-1"></i><c:out value="${user.fullName}" default="Restaurant Staff"/>
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
    
    <div class="container" style="margin-top: 100px;">
        <!-- Page Header -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-2">
                        <i class="fas fa-plus-circle me-2"></i>Add New Menu Item
                    </h1>
                    <p class="mb-0">Create a new menu item for your restaurant</p>
                </div>
                <div class="col-md-4 text-center">
                    <i class="fas fa-utensils fa-3x"></i>
                </div>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="glass-card">
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/restaurant/menu/add" method="post">
                            <div class="row">
                                <div class="col-md-6 mb-4">
                                    <label for="name" class="form-label">
                                        <i class="fas fa-utensils me-2"></i>Item Name
                                    </label>
                                    <input type="text" class="form-control" id="name" name="name" placeholder="Enter menu item name" required>
                                </div>
                                
                                <div class="col-md-6 mb-4">
                                    <label for="category" class="form-label">
                                        <i class="fas fa-tags me-2"></i>Category
                                    </label>
                                    <input type="text" class="form-control" id="category" name="category" placeholder="e.g., Appetizers, Main Course" required>
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label for="description" class="form-label">
                                    <i class="fas fa-align-left me-2"></i>Description
                                </label>
                                <textarea class="form-control" id="description" name="description" rows="4" placeholder="Describe your menu item..."></textarea>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-4">
                                    <label for="price" class="form-label">
                                        <i class="fas fa-dollar-sign me-2"></i>Price ($)
                                    </label>
                                    <input type="number" class="form-control" id="price" name="price" step="0.01" min="0" placeholder="0.00" required>
                                </div>
                                <div class="col-md-6 mb-4">
                                    <c:if test="${not empty restaurant}">
                                        <label class="form-label">
                                            <i class="fas fa-store me-2"></i>Restaurant
                                        </label>
                                        <div class="form-control-plaintext">
                                            <strong>${restaurant.name}</strong> - ${restaurant.cuisineType}
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="d-flex justify-content-between pt-3">
                                <a href="${pageContext.request.contextPath}/restaurant/menu" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Back to Menu
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-plus me-2"></i>Add Menu Item
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Theme Management
        function initializeTheme() {
            const savedTheme = localStorage.getItem('theme') || 'light';
            const htmlElement = document.documentElement;
            const themeIcon = document.getElementById('theme-icon');
            
            if (savedTheme === 'dark') {
                htmlElement.setAttribute('data-theme', 'dark');
                if (themeIcon) themeIcon.className = 'fas fa-sun';
            } else {
                htmlElement.setAttribute('data-theme', 'light');
                if (themeIcon) themeIcon.className = 'fas fa-moon';
            }
        }
        
        function toggleTheme() {
            const htmlElement = document.documentElement;
            const currentTheme = htmlElement.getAttribute('data-theme');
            const themeIcon = document.getElementById('theme-icon');
            
            if (currentTheme === 'dark') {
                htmlElement.setAttribute('data-theme', 'light');
                localStorage.setItem('theme', 'light');
                if (themeIcon) themeIcon.className = 'fas fa-moon';
            } else {
                htmlElement.setAttribute('data-theme', 'dark');
                localStorage.setItem('theme', 'dark');
                if (themeIcon) themeIcon.className = 'fas fa-sun';
            }
        }

        // Form validation and enhancements
        document.addEventListener('DOMContentLoaded', function() {
            initializeTheme();
            
            // Add smooth transitions to form
            const form = document.querySelector('form');
            form.style.opacity = '0';
            form.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                form.style.transition = 'all 0.5s ease';
                form.style.opacity = '1';
                form.style.transform = 'translateY(0)';
            }, 300);

            // Format price input
            const priceInput = document.getElementById('price');
            priceInput.addEventListener('input', function() {
                const value = parseFloat(this.value);
                if (!isNaN(value)) {
                    this.value = value.toFixed(2);
                }
            });

            // Auto-capitalize category input
            const categoryInput = document.getElementById('category');
            categoryInput.addEventListener('input', function() {
                this.value = this.value.charAt(0).toUpperCase() + this.value.slice(1);
            });
        });
    </script>
    
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
</body>
</html>
