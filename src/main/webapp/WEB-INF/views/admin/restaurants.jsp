<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurant Management - Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/global-styles.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-utensils me-2"></i>FoodDelivery
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-home me-1"></i>Dashboard
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
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="fas fa-receipt me-1"></i>Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                            <i class="fas fa-chart-bar me-1"></i>Reports
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
                            <i class="fas fa-user me-1"></i><c:out value="${user.fullName}" default="Admin"/>
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
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-store me-2"></i>Restaurant Management</h3>
                        <p class="mb-0">Manage restaurants in the system</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Flash Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i><c:out value="${success}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i><c:out value="${error}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Action Bar -->
        <div class="row mb-4">
            <div class="col-md-6">
                <a href="${pageContext.request.contextPath}/admin/restaurants/add" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>Add New Restaurant
                </a>
            </div>
            <div class="col-md-6">
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                    <input type="text" class="form-control" placeholder="Search restaurants..." id="searchInput">
                </div>
            </div>
        </div>

        <!-- Restaurants Grid -->
        <div class="row">
            <c:forEach var="restaurant" items="${restaurants}">
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card restaurant-card">
                        <div class="card-body">
                            <h5 class="card-title">
                                <i class="fas fa-store me-2"></i><c:out value="${restaurant.name}"/>
                            </h5>
                            <p class="card-text">
                                <i class="fas fa-map-marker-alt me-2"></i><c:out value="${restaurant.address}"/>
                            </p>
                            <p class="card-text">
                                <i class="fas fa-tag me-2"></i>
                                <span class="badge" style="background: var(--info-gradient);">
                                    <c:out value="${restaurant.cuisineType}"/>
                                </span>
                            </p>
                            <p class="card-text">
                                <i class="fas fa-clock me-2"></i><c:out value="${restaurant.openingHours}"/>
                            </p>
                            <p class="card-text">
                                <i class="fas fa-star me-2"></i>
                                <span class="badge" style="background: var(--warning-gradient);">
                                    <c:out value="${restaurant.rating}"/>/5.0
                                </span>
                            </p>
                            <div class="d-flex gap-2 mt-3">
                                <a href="${pageContext.request.contextPath}/admin/restaurants/${restaurant.id}/edit" 
                                   class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-edit me-1"></i>Edit
                                </a>
                                <button class="btn btn-sm btn-outline-danger delete-restaurant-btn"
                                        data-id="<c:out value='${restaurant.id}'/>"
                                        data-name="<c:out value='${restaurant.name}'/>">
                                    <i class="fas fa-trash me-1"></i>Delete
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty restaurants}">
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body text-center py-5">
                            <i class="fas fa-store fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No restaurants found</h5>
                            <p class="text-muted">Add your first restaurant to get started.</p>
                            <a href="${pageContext.request.contextPath}/admin/restaurants/add" class="btn btn-primary">
                                <i class="fas fa-plus me-2"></i>Add Restaurant
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
    <script>
        // Delete restaurant functionality
        document.addEventListener('click', function(e) {
            if (e.target.closest('.delete-restaurant-btn')) {
                const btn = e.target.closest('.delete-restaurant-btn');
                const id = btn.getAttribute('data-id');
                const name = btn.getAttribute('data-name');
                
                if (confirm(`Are you sure you want to delete restaurant "${name}"?`)) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/admin/restaurants/delete';
                    
                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'id';
                    idInput.value = id;
                    form.appendChild(idInput);
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            }
        });

        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
            const filter = this.value.toLowerCase();
            const cards = document.querySelectorAll('.restaurant-card');
            
            cards.forEach(card => {
                const text = card.textContent.toLowerCase();
                const col = card.closest('.col-md-6, .col-lg-4');
                col.style.display = text.includes(filter) ? '' : 'none';
            });
        });
    </script>
</body>
</html>
