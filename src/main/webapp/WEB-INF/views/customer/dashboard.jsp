<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">    <title>Customer Dashboard - Food Delivery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/customer/dashboard">
                <i class="fas fa-utensils me-2"></i>Food Delivery System
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/customer/dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/restaurants">
                            <i class="fas fa-store me-1"></i>Restaurants
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/orders">
                            <i class="fas fa-shopping-bag me-1"></i>My Orders
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
                <h2>Welcome, ${user.fullName}!</h2>
                <p class="lead">Find your favorite restaurants and order delicious food.</p>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Browse Restaurants</h5>
                        <p class="card-text">Discover restaurants near you and browse their menus.</p>
                        <a href="${pageContext.request.contextPath}/customer/restaurants" class="btn btn-primary">View Restaurants</a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">My Orders</h5>
                        <p class="card-text">Track your orders and view order history.</p>
                        <a href="${pageContext.request.contextPath}/customer/orders" class="btn btn-outline-primary">View Orders</a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-12">
                <h4>Popular Cuisine Types</h4>
                <div class="row">
                    <c:forEach var="cuisine" items="${cuisineTypes}">
                        <div class="col-md-3 mb-3">
                            <a href="${pageContext.request.contextPath}/customer/restaurants?cuisine=${cuisine}" class="btn btn-outline-secondary w-100">
                                ${cuisine}
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-12">
                <h4>Featured Restaurants</h4>
                <div class="row">
                    <c:forEach var="restaurant" items="${restaurants}" begin="0" end="3">
                        <div class="col-md-6 col-lg-3 mb-3">
                            <div class="card">                                <div class="card-body">
                                    <h6 class="card-title">${restaurant.name}</h6>
                                    <p class="card-text small">${restaurant.cuisineType}</p>
                                    <p class="card-text small text-muted">${restaurant.address}</p>
                                    <p class="card-text small text-muted">
                                        <i class="fas fa-clock me-1"></i>${restaurant.openingHours}
                                    </p>
                                    <a href="${pageContext.request.contextPath}/customer/restaurant/${restaurant.id}/menu" class="btn btn-sm btn-primary">View Menu</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
