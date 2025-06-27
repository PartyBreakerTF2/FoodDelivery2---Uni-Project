<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurants - FoodDelivery</title>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/dashboard">
                            <i class="fas fa-home me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/customer/restaurants">
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
        <!-- Search Section -->
        <div class="search-section">
            <h2><i class="fas fa-search me-2"></i>Find Restaurants</h2>
            <form action="${pageContext.request.contextPath}/customer/restaurants" method="get">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <input type="text" name="search" class="form-control" placeholder="Search restaurants..." value="${param.search}">
                    </div>
                    <div class="col-md-4 mb-3">
                        <select name="cuisine" class="form-control">
                            <option value="">All Cuisines</option>
                            <c:forEach var="cuisine" items="${cuisineTypes}">
                                <option value="${cuisine}" ${param.cuisine == cuisine ? 'selected' : ''}>${cuisine}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2 mb-3">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-search me-2"></i>Search
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Restaurants Grid -->
        <div class="row">
            <c:choose>
                <c:when test="${not empty restaurants}">
                    <c:forEach var="restaurant" items="${restaurants}">
                        <div class="col-md-6 col-lg-4 mb-4">
                            <div class="glass-card restaurant-card">
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <i class="fas fa-store me-2"></i><c:out value="${restaurant.name}"/>
                                    </h5>
                                    <p class="card-text">
                                        <i class="fas fa-utensils me-2"></i><c:out value="${restaurant.cuisineType}"/>
                                    </p>
                                    <p class="card-text">
                                        <i class="fas fa-map-marker-alt me-2"></i><c:out value="${restaurant.address}"/>
                                    </p>
                                    <c:if test="${not empty restaurant.phone}">
                                        <p class="card-text">
                                            <i class="fas fa-phone me-2"></i><c:out value="${restaurant.phone}"/>
                                        </p>
                                    </c:if>
                                    <c:if test="${not empty restaurant.openingHours}">
                                        <p class="card-text">
                                            <i class="fas fa-clock me-2"></i><c:out value="${restaurant.openingHours}"/>
                                        </p>
                                    </c:if>
                                    <div class="d-grid">
                                        <a href="${pageContext.request.contextPath}/customer/restaurant/${restaurant.id}/menu" class="btn btn-primary">
                                            <i class="fas fa-eye me-2"></i>View Menu
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="text-center mt-5">
                            <i class="fas fa-store-slash" style="font-size: 4rem; opacity: 0.5;"></i>
                            <h3 class="mt-3">No restaurants found</h3>
                            <p class="text-muted">Try adjusting your search criteria.</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
</body>
</html>
