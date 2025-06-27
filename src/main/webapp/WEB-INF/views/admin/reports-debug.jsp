<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - Admin Portal</title>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/restaurants">
                            <i class="fas fa-store me-1"></i>Restaurants
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="fas fa-receipt me-1"></i>Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/reports">
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
                        <h3><i class="fas fa-chart-bar me-2"></i>Reports & Analytics</h3>
                        <p class="mb-0">System performance metrics and business insights</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Statistics Cards -->
        <div class="row">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card">
                    <div class="card-body text-center">
                        <div class="icon-container mb-3">
                            <i class="fas fa-users fa-2x text-primary"></i>
                        </div>
                        <h5 class="card-title">Total Customers</h5>
                        <h3 class="text-primary"><c:out value="${totalCustomers}" default="0"/></h3>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card">
                    <div class="card-body text-center">
                        <div class="icon-container mb-3">
                            <i class="fas fa-store fa-2x text-success"></i>
                        </div>
                        <h5 class="card-title">Total Restaurants</h5>
                        <h3 class="text-success"><c:out value="${totalRestaurants}" default="0"/></h3>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card">
                    <div class="card-body text-center">
                        <div class="icon-container mb-3">
                            <i class="fas fa-receipt fa-2x text-info"></i>
                        </div>
                        <h5 class="card-title">Total Orders</h5>
                        <h3 class="text-info"><c:out value="${totalOrders}" default="0"/></h3>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card">
                    <div class="card-body text-center">
                        <div class="icon-container mb-3">
                            <i class="fas fa-dollar-sign fa-2x text-warning"></i>
                        </div>
                        <h5 class="card-title">Total Revenue</h5>
                        <h3 class="text-warning">$<c:out value="${totalRevenue}" default="0.00"/></h3>
                    </div>
                </div>
            </div>
        </div>

        <!-- Additional Reports Section -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-chart-line me-2"></i>Quick Reports</h5>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-md-4 mb-3">
                                <a href="${pageContext.request.contextPath}/admin/reports/orders" class="btn btn-outline-primary btn-lg w-100">
                                    <i class="fas fa-chart-bar me-2"></i>Order Reports
                                </a>
                            </div>
                            <div class="col-md-4 mb-3">
                                <a href="${pageContext.request.contextPath}/admin/reports/revenue" class="btn btn-outline-success btn-lg w-100">
                                    <i class="fas fa-money-bill-wave me-2"></i>Revenue Reports
                                </a>
                            </div>
                            <div class="col-md-4 mb-3">
                                <a href="${pageContext.request.contextPath}/admin/reports/users" class="btn btn-outline-info btn-lg w-100">
                                    <i class="fas fa-users-cog me-2"></i>User Reports
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Theme Management
        function initializeTheme() {
            const savedTheme = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', savedTheme);
            updateThemeIcon(savedTheme);
        }

        function toggleTheme() {
            const currentTheme = document.documentElement.getAttribute('data-theme');
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            
            document.documentElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            updateThemeIcon(newTheme);
        }

        function updateThemeIcon(theme) {
            const themeIcon = document.getElementById('themeIcon');
            if (themeIcon) {
                themeIcon.className = theme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
            }
        }

        // Initialize theme on page load
        document.addEventListener('DOMContentLoaded', initializeTheme);
    </script>
</body>
</html>
