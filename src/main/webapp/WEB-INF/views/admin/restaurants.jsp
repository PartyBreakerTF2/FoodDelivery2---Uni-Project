<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">    <title>Restaurant Management - Admin</title>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                            <i class="fas fa-users me-1"></i>Users
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/restaurants">
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
                <div class="d-flex justify-content-between align-items-center">
                    <h2>Restaurant Management</h2>
                    <a href="${pageContext.request.contextPath}/admin/restaurants/add" class="btn btn-primary">Add New Restaurant</a>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-12">
                <div class="table-responsive">
                    <table class="table table-striped">                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Cuisine Type</th>
                                <th>Address</th>
                                <th>Phone</th>
                                <th>Opening Hours</th>
                                <th>Delivery Fee</th>
                                <th>Min Order</th>
                                <th>Rating</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="restaurant" items="${restaurants}">
                                <tr>
                                    <td>${restaurant.id}</td>
                                    <td>${restaurant.name}</td>
                                    <td>
                                        <span class="badge bg-secondary">${restaurant.cuisineType}</span>
                                    </td>                                    <td>${restaurant.address}</td>
                                    <td>${restaurant.phone}</td>
                                    <td>
                                        <small class="text-muted">${restaurant.openingHours}</small>
                                    </td>
                                    <td>$${restaurant.deliveryFee}</td>
                                    <td>$${restaurant.minOrderAmount}</td>
                                    <td>
                                        <span class="badge bg-warning text-dark">${restaurant.rating}/5.0</span>
                                    </td>
                                    <td>
                                        <c:if test="${restaurant.active}">
                                            <span class="badge bg-success">Active</span>
                                        </c:if>
                                        <c:if test="${!restaurant.active}">
                                            <span class="badge bg-danger">Inactive</span>
                                        </c:if>
                                    </td>                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/restaurants/${restaurant.id}/edit" 
                                           class="btn btn-sm btn-outline-primary me-1">
                                            <i class="fas fa-edit"></i> Edit
                                        </a>
                                        <form action="${pageContext.request.contextPath}/admin/restaurants/${restaurant.id}/toggle" method="post" style="display: inline;">
                                            <button type="submit" class="btn btn-sm 
                                                <c:if test="${restaurant.active}">btn-outline-warning</c:if>
                                                <c:if test="${!restaurant.active}">btn-outline-success</c:if>
                                            ">
                                                <c:if test="${restaurant.active}"><i class="fas fa-pause"></i> Deactivate</c:if>
                                                <c:if test="${!restaurant.active}"><i class="fas fa-play"></i> Activate</c:if>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>                            <c:if test="${empty restaurants}">
                                <tr>
                                    <td colspan="11" class="text-center text-muted">No restaurants found</td>
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
