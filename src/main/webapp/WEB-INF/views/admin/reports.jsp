<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports & Analytics - Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/global-styles.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        <div class="row mb-4">
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

        <!-- Charts Section -->
        <div class="row mb-4">
            <!-- Order Status Chart -->
            <div class="col-lg-6 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-chart-pie me-2"></i>Order Status Distribution</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container" style="position: relative; height: 300px;">
                            <canvas id="orderStatusChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Revenue Trend Chart -->
            <div class="col-lg-6 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-chart-line me-2"></i>Revenue Trend</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container" style="position: relative; height: 300px;">
                            <canvas id="revenueTrendChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Detailed Analytics -->
        <div class="row mb-4">
            <!-- Restaurant Performance Table -->
            <div class="col-lg-8 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-store me-2"></i>Restaurant Performance</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-store me-1"></i>Restaurant</th>
                                        <th><i class="fas fa-receipt me-1"></i>Orders</th>
                                        <th><i class="fas fa-dollar-sign me-1"></i>Revenue</th>
                                        <th><i class="fas fa-star me-1"></i>Rating</th>
                                        <th><i class="fas fa-chart-line me-1"></i>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="restaurant" items="${restaurants}" varStatus="status">
                                        <c:if test="${status.index < 5}">
                                            <tr>
                                                <td>
                                                    <strong><c:out value="${restaurant.name}"/></strong>
                                                    <br><small class="text-muted"><c:out value="${restaurant.cuisineType}"/></small>
                                                </td>
                                                <td>
                                                    <span class="badge bg-primary">${restaurant.orderCount != null ? restaurant.orderCount : 0}</span>
                                                </td>
                                                <td>
                                                    <strong>$<fmt:formatNumber value="${restaurant.revenue != null ? restaurant.revenue : 0}" pattern="0.00"/></strong>
                                                </td>
                                                <td>
                                                    <span class="badge bg-warning">
                                                        <i class="fas fa-star"></i> <c:out value="${restaurant.rating}"/>/5.0
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${restaurant.active}">
                                                            <span class="badge bg-success">Active</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger">Inactive</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${empty restaurants}">
                                        <tr>
                                            <td colspan="5" class="text-center text-muted py-4">
                                                <i class="fas fa-store fa-2x mb-2 d-block"></i>
                                                No restaurant data available
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Quick Stats -->
            <div class="col-lg-4 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-tachometer-alt me-2"></i>Quick Insights</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="fw-medium">Pending Orders:</span>
                            <span class="badge bg-warning">${pendingOrders != null ? pendingOrders : 0}</span>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="fw-medium">Completed Orders:</span>
                            <span class="badge bg-success">${completedOrders != null ? completedOrders : 0}</span>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="fw-medium">Active Orders:</span>
                            <span class="badge bg-info">${activeOrders != null ? activeOrders : 0}</span>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <span class="fw-medium">Avg Order Value:</span>
                            <strong class="text-primary">$<fmt:formatNumber value="${avgOrderValue != null ? avgOrderValue : 0}" pattern="0.00"/></strong>
                        </div>
                        
                        <hr>
                        <div class="text-center">
                            <small class="text-muted">
                                <i class="fas fa-clock me-1"></i>
                                Last updated: <span id="currentTime" class="fw-medium"></span>
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Export Data Section -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-download me-2"></i>Export Options</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4 mb-2">
                                <button class="btn btn-outline-primary w-100" onclick="exportToCSV()">
                                    <i class="fas fa-file-csv me-1"></i>Export to CSV
                                </button>
                            </div>
                            <div class="col-md-4 mb-2">
                                <button class="btn btn-outline-success w-100" onclick="exportToExcel()">
                                    <i class="fas fa-file-excel me-1"></i>Export to Excel
                                </button>
                            </div>
                            <div class="col-md-4 mb-2">
                                <button class="btn btn-outline-danger w-100" onclick="exportToPDF()">
                                    <i class="fas fa-file-pdf me-1"></i>Export to PDF
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
    <script>
        // Initialize charts and data when page loads
        document.addEventListener('DOMContentLoaded', function() {
            // Update current time
            updateCurrentTime();
            setInterval(updateCurrentTime, 1000);
            
            // Initialize Order Status Chart
            initOrderStatusChart();
            
            // Initialize Revenue Trend Chart
            initRevenueTrendChart();
        });
        
        function updateCurrentTime() {
            const now = new Date();
            const timeElement = document.getElementById('currentTime');
            if (timeElement) {
                timeElement.textContent = now.toLocaleTimeString();
            }
        }
        
        function initOrderStatusChart() {
            const ctx = document.getElementById('orderStatusChart');
            if (!ctx) return;
            
            // Get actual data from server or use defaults
            const pendingCount = ${pendingOrders != null ? pendingOrders : 0};
            const completedCount = ${completedOrders != null ? completedOrders : 0};
            const activeCount = ${activeOrders != null ? activeOrders : 0};
            
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Completed', 'Active', 'Pending'],
                    datasets: [{
                        data: [completedCount, activeCount, pendingCount],
                        backgroundColor: [
                            '#28a745',
                            '#17a2b8', 
                            '#ffc107'
                        ],
                        borderWidth: 2,
                        borderColor: '#fff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 20,
                                usePointStyle: true
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = ((context.parsed * 100) / total).toFixed(1);
                                    return context.label + ': ' + context.parsed + ' (' + percentage + '%)';
                                }
                            }
                        }
                    }
                }
            });
        }
        
        function initRevenueTrendChart() {
            const ctx = document.getElementById('revenueTrendChart');
            if (!ctx) return;
            
            // Sample data - in real app this would come from server
            const last7Days = [];
            const revenueData = [];
            
            for (let i = 6; i >= 0; i--) {
                const date = new Date();
                date.setDate(date.getDate() - i);
                last7Days.push(date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }));
                
                // Generate sample revenue data (in real app, this comes from database)
                const baseRevenue = ${totalRevenue != null ? totalRevenue : 1000} / 30; // Daily average
                const variation = (Math.random() - 0.5) * 0.4; // ±20% variation
                revenueData.push(Math.max(0, baseRevenue * (1 + variation)));
            }
            
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: last7Days,
                    datasets: [{
                        label: 'Daily Revenue',
                        data: revenueData,
                        borderColor: '#667eea',
                        backgroundColor: 'rgba(102, 126, 234, 0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointBackgroundColor: '#667eea',
                        pointBorderColor: '#fff',
                        pointBorderWidth: 2,
                        pointRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return '$' + value.toFixed(0);
                                }
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return 'Revenue: $' + context.parsed.y.toFixed(2);
                                }
                            }
                        }
                    }
                }
            });
        }
        
        function exportToCSV() {
            const data = [
                ['Metric', 'Value'],
                ['Total Customers', '${totalCustomers != null ? totalCustomers : 0}'],
                ['Total Restaurants', '${totalRestaurants != null ? totalRestaurants : 0}'],
                ['Total Orders', '${totalOrders != null ? totalOrders : 0}'],
                ['Pending Orders', '${pendingOrders != null ? pendingOrders : 0}'],
                ['Completed Orders', '${completedOrders != null ? completedOrders : 0}'],
                ['Active Orders', '${activeOrders != null ? activeOrders : 0}'],
                ['Total Revenue', '$${totalRevenue != null ? totalRevenue : 0}'],
                ['Average Order Value', '$${avgOrderValue != null ? avgOrderValue : 0}']
            ];
            
            const csvContent = data.map(row => row.join(',')).join('\n');
            const blob = new Blob([csvContent], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.setAttribute('hidden', '');
            a.setAttribute('href', url);
            a.setAttribute('download', 'food-delivery-reports-' + new Date().toISOString().split('T')[0] + '.csv');
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
        }
        
        function exportToExcel() {
            alert('Excel export feature coming soon!');
        }
        
        function exportToPDF() {
            window.print();
        }
    </script>
</body>
</html>
