<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu Management - FoodDelivery</title>
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
        <!-- Page Header -->
        <div class="hero-section">
            <h1><i class="fas fa-utensils me-2"></i>Menu Management</h1>
            <p>Manage your restaurant's menu items and categories.</p>
            <a href="${pageContext.request.contextPath}/restaurant/menu/add" class="btn btn-success">
                <i class="fas fa-plus me-2"></i>Add New Item
            </a>
        </div>

        <!-- Menu Items -->
        <div class="row">
            <c:choose>
                <c:when test="${not empty menuItems}">
                    <c:forEach var="category" items="${categories}">
                        <!-- Check if this category has any items -->
                        <c:set var="hasItemsInCategory" value="false" />
                        <c:forEach var="item" items="${menuItems}">
                            <c:if test="${item.category == category}">
                                <c:set var="hasItemsInCategory" value="true" />
                            </c:if>
                        </c:forEach>
                        
                        <!-- Only show the category section if it has items -->
                        <c:if test="${hasItemsInCategory}">
                            <div class="col-12 mb-4">
                                <div class="glass-card">
                                    <div class="card-header">
                                        <h5 class="mb-0">
                                            <i class="fas fa-list me-2"></i><c:out value="${category}"/>
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <c:forEach var="item" items="${menuItems}">
                                                <c:if test="${item.category == category}">
                                                    <div class="col-md-6 col-lg-4 mb-3">
                                                        <div class="glass-card h-100">
                                                            <div class="card-body">
                                                                <h6 class="card-title">
                                                                    <c:out value="${item.name}"/>
                                                                </h6>
                                                                <c:if test="${not empty item.description}">
                                                                    <p class="card-text text-muted">
                                                                        <c:out value="${item.description}"/>
                                                                    </p>
                                                                </c:if>
                                                                <p class="card-text">
                                                                    <strong>$<c:out value="${item.price}"/></strong>
                                                                </p>
                                                                <p class="card-text">
                                                                    <small class="text-muted">
                                                                        Available: 
                                                                        <c:choose>
                                                                            <c:when test="${item.available}">
                                                                                <span class="badge bg-success">Yes</span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="badge bg-danger">No</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </small>
                                                                </p>
                                                                <div class="btn-group w-100" role="group">
                                                                    <a href="${pageContext.request.contextPath}/restaurant/menu/edit/${item.id}" 
                                                                       class="btn btn-outline-primary btn-sm">
                                                                        <i class="fas fa-edit me-1"></i>Edit
                                                                    </a>
                                                                    <button class="btn btn-outline-danger btn-sm" 
                                                                            onclick="deleteItem('${item.id}')">
                                                                        <i class="fas fa-trash me-1"></i>Delete
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="text-center mt-5">
                            <i class="fas fa-utensils" style="font-size: 4rem; opacity: 0.5;"></i>
                            <h3 class="mt-3">No menu items yet</h3>
                            <p class="text-muted">Start building your menu by adding your first item.</p>
                            <a href="${pageContext.request.contextPath}/restaurant/menu/add" class="btn btn-success">
                                <i class="fas fa-plus me-2"></i>Add First Item
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function deleteItem(itemId) {
            if (confirm('Are you sure you want to delete this menu item?')) {
                fetch('${pageContext.request.contextPath}/restaurant/menu/delete/' + itemId, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    }
                })
                .then(response => {
                    if (response.ok) {
                        // Show success message and reload page
                        const successAlert = document.createElement('div');
                        successAlert.className = 'alert alert-success alert-dismissible fade show position-fixed';
                        successAlert.style.cssText = 'top: 100px; right: 20px; z-index: 9999; max-width: 400px;';
                        successAlert.innerHTML = `
                            <i class="fas fa-check-circle me-2"></i>Menu item deleted successfully!
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        `;
                        document.body.appendChild(successAlert);
                        
                        // Reload page after a short delay
                        setTimeout(() => {
                            location.reload();
                        }, 1500);
                    } else {
                        response.text().then(errorMessage => {
                            alert('Failed to delete menu item: ' + errorMessage);
                        });
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to delete menu item. Please try again.');
                });
            }
        }
    </script>
    
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
</body>
</html>
