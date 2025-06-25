<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">    <title>Menu Management - Restaurant Staff</title>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/restaurant/dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/restaurant/menu">
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
                        </a>                        <ul class="dropdown-menu">
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
                <div class="d-flex justify-content-between align-items-center">
                    <h2>Menu Management</h2>
                    <a href="${pageContext.request.contextPath}/restaurant/menu/add" class="btn btn-primary">Add New Item</a>
                </div>
            </div>
        </div>
        
        <c:if test="${not empty restaurant}">
            <div class="row mt-3">
                <div class="col-12">
                    <div class="alert alert-info">
                        <strong>Restaurant:</strong> ${restaurant.name} | <strong>Cuisine:</strong> ${restaurant.cuisineType}
                    </div>
                </div>
            </div>
        </c:if>
        
        <div class="row mt-4">
            <div class="col-12">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Description</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Available</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${menuItems}">
                                <tr>
                                    <td>${item.name}</td>
                                    <td>${item.description}</td>
                                    <td>
                                        <span class="badge bg-secondary">${item.category}</span>
                                    </td>
                                    <td>$${item.price}</td>
                                    <td>
                                        <c:if test="${item.available}">
                                            <span class="badge bg-success">Available</span>
                                        </c:if>
                                        <c:if test="${!item.available}">
                                            <span class="badge bg-danger">Not Available</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/restaurant/menu/edit/${item.id}" class="btn btn-sm btn-outline-primary">Edit</a>
                                        <button type="button" class="btn btn-sm btn-outline-danger" 
                                                onclick="confirmDelete('${item.id}')">Delete</button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty menuItems}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted">
                                        No menu items found. <a href="${pageContext.request.contextPath}/restaurant/menu/add">Add your first item</a>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(itemId) {
            if (confirm('Are you sure you want to delete this menu item?')) {
                // In a real application, you would make an AJAX call or submit a form
                alert('Delete functionality would be implemented here');
            }
        }
    </script>
</body>
</html>
