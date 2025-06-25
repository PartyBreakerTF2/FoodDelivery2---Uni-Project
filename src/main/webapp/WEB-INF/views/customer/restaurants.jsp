<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">    <title>Restaurants - Food Delivery</title>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/customer/restaurants">
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
                <h2>Restaurants</h2>
            </div>
        </div>
        
        <!-- Search and Filter -->
        <div class="row mt-3">
            <div class="col-md-6">
                <form action="${pageContext.request.contextPath}/customer/restaurants" method="get" class="d-flex">
                    <input type="text" class="form-control me-2" name="search" placeholder="Search restaurants..." value="${searchTerm}">
                    <button type="submit" class="btn btn-outline-primary">Search</button>
                </form>
            </div>
            <div class="col-md-6">
                <form action="${pageContext.request.contextPath}/customer/restaurants" method="get">
                    <select name="cuisine" class="form-select" onchange="this.form.submit()">
                        <option value="">All Cuisines</option>
                        <c:forEach var="cuisine" items="${cuisineTypes}">
                            <option value="${cuisine}" ${selectedCuisine == cuisine ? 'selected' : ''}>${cuisine}</option>
                        </c:forEach>
                    </select>
                </form>
            </div>
        </div>
        
        <!-- Restaurants List -->
        <div class="row mt-4">
            <c:forEach var="restaurant" items="${restaurants}">
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card h-100">
                        <div class="card-body">
                            <h5 class="card-title">${restaurant.name}</h5>
                            <p class="card-text">${restaurant.description}</p>                            <p class="card-text">
                                <small class="text-muted">
                                    <strong>Cuisine:</strong> ${restaurant.cuisineType}<br>
                                    <strong>Opening Hours:</strong> ${restaurant.openingHours}<br>
                                    <strong>Delivery Fee:</strong> $${restaurant.deliveryFee}<br>
                                    <strong>Min Order:</strong> $${restaurant.minOrderAmount}
                                </small>
                            </p>
                            <p class="card-text">
                                <small class="text-muted">
                                    <i class="fas fa-star text-warning"></i> ${restaurant.rating}/5.0
                                </small>
                            </p>
                        </div>
                        <div class="card-footer">
                            <a href="${pageContext.request.contextPath}/customer/restaurant/${restaurant.id}/menu" class="btn btn-primary w-100">View Menu</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        
        <c:if test="${empty restaurants}">
            <div class="row mt-4">
                <div class="col-12 text-center">
                    <p class="lead">No restaurants found.</p>
                    <a href="${pageContext.request.contextPath}/customer/restaurants" class="btn btn-primary">View All Restaurants</a>
                </div>
            </div>
        </c:if>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
