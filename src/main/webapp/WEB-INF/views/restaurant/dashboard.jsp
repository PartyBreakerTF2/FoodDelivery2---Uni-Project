<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurant Dashboard - FoodDelivery</title>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/restaurant/dashboard">
                            <i class="fas fa-home me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/restaurant/menu">
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
    
    <div class="container mt-4">
        <!-- Page Header -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="section-header">
                    <h2><i class="fas fa-utensils me-2"></i>Restaurant Dashboard</h2>
                    <p>Welcome, <c:out value="${user.fullName}"/>! Manage your restaurant operations.</p>
                </div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-md-6 mb-4">
                <div class="card h-100">
                    <div class="card-body text-center">
                        <i class="fas fa-utensils fa-3x text-success mb-3"></i>
                        <h5 class="card-title">Menu Management</h5>
                        <p class="card-text">Add, edit, or remove menu items for your restaurant.</p>
                        <a href="${pageContext.request.contextPath}/restaurant/menu" class="btn btn-success">
                            <i class="fas fa-arrow-right me-2"></i>Manage Menu
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6 mb-4">
                <div class="card h-100">
                    <div class="card-body text-center">
                        <i class="fas fa-receipt fa-3x text-primary mb-3"></i>
                        <h5 class="card-title">Orders</h5>
                        <p class="card-text">View and manage incoming orders from customers.</p>
                        <a href="${pageContext.request.contextPath}/restaurant/orders" class="btn btn-primary">
                            <i class="fas fa-arrow-right me-2"></i>View Orders
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Restaurant Information -->
        <c:if test="${not empty restaurant}">
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h5><i class="fas fa-store me-2"></i>Restaurant Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Name:</strong> <c:out value="${restaurant.name}"/></p>
                                    <p><strong>Cuisine Type:</strong> <c:out value="${restaurant.cuisineType}"/></p>
                                    <p><strong>Address:</strong> <c:out value="${restaurant.address}"/></p>
                                    <p><strong>Opening Hours:</strong> <c:out value="${restaurant.openingHours}"/></p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>Phone:</strong> <c:out value="${restaurant.phone}"/></p>
                                    <p><strong>Email:</strong> <c:out value="${restaurant.email}"/></p>
                                    <p><strong>Delivery Fee:</strong> $<c:out value="${restaurant.deliveryFee}"/></p>
                                    <p><strong>Rating:</strong> <c:out value="${restaurant.rating}"/>/5.0</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        
        <!-- Recent Orders -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-clock me-2"></i>Recent Orders</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer</th>
                                        <th>Total</th>
                                        <th>Status</th>
                                        <th>Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${recentOrders}" begin="0" end="4">
                                        <tr>
                                            <td>#<c:out value="${order.id}"/></td>
                                            <td><c:out value="${order.customer.fullName}"/></td>
                                            <td>$<c:out value="${order.totalAmount}"/></td>
                                            <td>
                                                <span class="badge bg-info"><c:out value="${order.status}"/></span>
                                            </td>
                                            <td><c:out value="${order.orderDate}"/></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty recentOrders}">
                                        <tr>
                                            <td colspan="5" class="text-center text-muted">
                                                <i class="fas fa-inbox me-2"></i>No recent orders
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                        <c:if test="${not empty recentOrders}">
                            <div class="text-center">
                                <a href="${pageContext.request.contextPath}/restaurant/orders" class="btn btn-outline-primary">
                                    <i class="fas fa-eye me-2"></i>View All Orders
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
</body>
</html>
