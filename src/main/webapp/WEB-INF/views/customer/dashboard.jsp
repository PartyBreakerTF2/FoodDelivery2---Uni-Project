<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard - FoodDelivery</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/global-styles.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/customer/dashboard">
                <i class="fas fa-utensils me-2"></i>FoodDelivery
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/customer/dashboard">
                            <i class="fas fa-home me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/restaurants">
                            <i class="fas fa-store me-1"></i>Restaurants
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/orders">
                            <i class="fas fa-receipt me-1"></i>My Orders
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
                            <i class="fas fa-user me-1"></i><c:out value="${user.fullName}" default="User"/>
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
        <!-- Hero Welcome Section -->
        <div class="hero-section">
            <h1><i class="fas fa-utensils me-2"></i>Welcome, ${sessionScope.user.fullName}!</h1>
            <p>Find your favorite restaurants and order delicious food delivered to your door.</p>
        </div>
        
        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-md-6 mb-4">
                <div class="action-card card-restaurants">
                    <i class="fas fa-store"></i>
                    <h4>Browse Restaurants</h4>
                    <p>Discover restaurants near you and browse their menus.</p>
                    <a href="${pageContext.request.contextPath}/customer/restaurants" class="btn btn-success">
                        <i class="fas fa-arrow-right me-2"></i>View Restaurants
                    </a>
                </div>
            </div>
            
            <div class="col-md-6 mb-4">
                <div class="action-card card-orders">
                    <i class="fas fa-shopping-bag"></i>
                    <h4>My Orders</h4>
                    <p>Track your orders and view order history.</p>
                    <a href="${pageContext.request.contextPath}/customer/orders" class="btn btn-primary">
                        <i class="fas fa-arrow-right me-2"></i>View Orders
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Popular Cuisine Types -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="section-header">
                    <h4><i class="fas fa-utensils me-2"></i>Popular Cuisine Types</h4>
                </div>
                <div class="row">
                    <c:forEach var="cuisine" items="${cuisineTypes}">
                        <div class="col-md-3 col-sm-6 mb-3">
                            <a href="${pageContext.request.contextPath}/customer/restaurants?cuisine=${cuisine}" class="btn cuisine-btn w-100">
                                <i class="fas fa-utensils me-2"></i>${cuisine}
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        
        <!-- Featured Restaurants -->
        <div class="row">
            <div class="col-12">
                <div class="section-header">
                    <h4><i class="fas fa-star me-2"></i>Featured Restaurants</h4>
                </div>
                <div class="row">
                    <c:forEach var="restaurant" items="${restaurants}" begin="0" end="3">
                        <div class="col-md-6 col-lg-3 mb-3">
                            <div class="restaurant-card">
                                <div class="card-body">
                                    <h6 class="card-title">
                                        <i class="fas fa-store me-2"></i>${restaurant.name}
                                    </h6>
                                    <p class="card-text">
                                        <i class="fas fa-tag me-2"></i>
                                        <span class="badge" style="background: var(--info-gradient);">${restaurant.cuisineType}</span>
                                    </p>
                                    <p class="card-text">
                                        <i class="fas fa-map-marker-alt me-2"></i>${restaurant.address}
                                    </p>
                                    <p class="card-text">
                                        <i class="fas fa-clock me-2"></i>${restaurant.openingHours}
                                    </p>
                                    <p class="card-text">
                                        <i class="fas fa-star me-2"></i>
                                        <span class="badge" style="background: var(--warning-gradient);">${restaurant.rating}/5.0</span>
                                    </p>
                                    <a href="${pageContext.request.contextPath}/customer/restaurant/${restaurant.id}/menu" class="btn btn-primary w-100">
                                        <i class="fas fa-eye me-2"></i>View Menu
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
</body>
</html>
