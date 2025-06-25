<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">    <title>Admin Dashboard - Food Delivery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>    <!-- Navigation -->    <nav class="navbar navbar-expand-lg navbar-dark bg-danger">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-utensils me-2"></i>Food Delivery System
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                            <i class="fas fa-users me-1"></i>Users
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/restaurants">
                            <i class="fas fa-store me-1"></i>Restaurants
                        </a>
                    </li>                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="fas fa-shopping-cart me-1"></i>Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                            <i class="fas fa-chart-bar me-1"></i>Reports
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
                <h2>Admin Dashboard</h2>
                <p class="lead">Welcome, ${user.fullName}! Manage your food delivery platform.</p>
            </div>
        </div>
        
        <!-- Statistics Cards -->
        <div class="row mt-4">
            <div class="col-md-3">
                <div class="card text-white bg-primary">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h5 class="card-title">Total Users</h5>
                                <h2>${totalUsers}</h2>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-users fa-2x"></i>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-light btn-sm mt-2">View Users</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card text-white bg-success">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h5 class="card-title">Restaurants</h5>
                                <h2>${totalRestaurants}</h2>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-store fa-2x"></i>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/restaurants" class="btn btn-light btn-sm mt-2">Manage</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card text-white bg-warning">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h5 class="card-title">Recent Orders</h5>
                                <h2>${recentOrders.size()}</h2>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-shopping-cart fa-2x"></i>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-light btn-sm mt-2">View Orders</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card text-white bg-info">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h5 class="card-title">Reports</h5>
                                <h2><i class="fas fa-chart-bar"></i></h2>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-light btn-sm mt-2">View Reports</a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="row mt-4">
            <div class="col-12">
                <h4>Quick Actions</h4>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">User Management</h5>
                        <p class="card-text">Manage customer and restaurant staff accounts.</p>
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-primary">Manage Users</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Restaurant Management</h5>
                        <p class="card-text">Add new restaurants and manage existing ones.</p>
                        <a href="${pageContext.request.contextPath}/admin/restaurants" class="btn btn-success">Manage Restaurants</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">System Reports</h5>
                        <p class="card-text">View platform statistics and performance reports.</p>
                        <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-info">View Reports</a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Recent Orders Table -->
        <div class="row mt-4">
            <div class="col-12">
                <h4>Recent Orders</h4>
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Restaurant</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${recentOrders}">
                                <tr>
                                    <td>#${order.id}</td>
                                    <td>${order.customer.fullName}</td>
                                    <td>${order.restaurant.name}</td>
                                    <td>$${order.totalAmount}</td>
                                    <td>
                                        <span class="badge bg-info">${order.status}</span>
                                    </td>
                                    <td>${order.orderDate}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty recentOrders}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted">No recent orders</td>
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
