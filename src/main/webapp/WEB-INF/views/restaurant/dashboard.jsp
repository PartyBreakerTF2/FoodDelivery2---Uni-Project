<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">    <title>Restaurant Staff Dashboard - Food Delivery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>    <!-- Navigation -->    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/restaurant/dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/restaurant/menu">
                            <i class="fas fa-utensils me-1"></i>Menu Management
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/restaurant/orders">
                            <i class="fas fa-shopping-cart me-1"></i>Orders
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav">                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user me-1"></i>${sessionScope.user.fullName}
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
      <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h2>Restaurant Staff Dashboard</h2>
                <p class="lead">Welcome, ${user.fullName}!</p>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-md-4">
                <div class="card text-white bg-primary">
                    <div class="card-body">
                        <h5 class="card-title">Menu Management</h5>
                        <p class="card-text">Add, edit, or remove menu items.</p>
                        <a href="${pageContext.request.contextPath}/restaurant/menu" class="btn btn-light">Manage Menu</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-warning">
                    <div class="card-body">
                        <h5 class="card-title">Orders</h5>
                        <p class="card-text">View and manage incoming orders.</p>
                        <a href="${pageContext.request.contextPath}/restaurant/orders" class="btn btn-light">View Orders</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-info">
                    <div class="card-body">
                        <h5 class="card-title">Staff Profile</h5>
                        <p class="card-text">Update staff information.</p>
                        <a href="${pageContext.request.contextPath}/profile" class="btn btn-light">Update Info</a>
                    </div>
                </div>
            </div>
        </div>
        
        <c:if test="${not empty restaurant}">
            <div class="row mt-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h5>Restaurant Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">                                <div class="col-md-6">
                                    <p><strong>Name:</strong> ${restaurant.name}</p>
                                    <p><strong>Cuisine Type:</strong> ${restaurant.cuisineType}</p>
                                    <p><strong>Address:</strong> ${restaurant.address}</p>
                                    <p><strong>Opening Hours:</strong> ${restaurant.openingHours}</p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>Phone:</strong> ${restaurant.phone}</p>
                                    <p><strong>Delivery Fee:</strong> $${restaurant.deliveryFee}</p>
                                    <p><strong>Rating:</strong> ${restaurant.rating}/5.0</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        
        <div class="row mt-4">
            <div class="col-12">
                <h4>Recent Orders</h4>
                <div class="table-responsive">
                    <table class="table table-striped">
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
                                    <td>#${order.id}</td>
                                    <td>${order.customer.fullName}</td>
                                    <td>$${order.totalAmount}</td>
                                    <td>
                                        <span class="badge bg-info">${order.status}</span>
                                    </td>
                                    <td>${order.orderDate}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty recentOrders}">
                                <tr>
                                    <td colspan="5" class="text-center text-muted">No recent orders</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
