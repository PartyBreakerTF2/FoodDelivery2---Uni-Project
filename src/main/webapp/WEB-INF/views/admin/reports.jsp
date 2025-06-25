<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports & Analytics - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .stats-card {
            border: none;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            transition: transform 0.2s ease-in-out;
        }
        .stats-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.1);
        }
        .metric-value {
            font-size: 2.5rem;
            font-weight: bold;
        }
        .metric-label {
            font-size: 0.9rem;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .chart-container {
            position: relative;
            height: 300px;
            margin: 20px 0;
        }
        .export-section {
            background-color: #f8f9fa;
            border-radius: 0.375rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .time-filter {
            background-color: #f8f9fa;
            border-radius: 0.375rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        .trend-indicator {
            font-size: 0.8rem;
            margin-left: 0.5rem;
        }
        .trend-up {
            color: #28a745;
        }
        .trend-down {
            color: #dc3545;
        }
        .trend-neutral {
            color: #6c757d;
        }
        .report-section {
            margin-bottom: 2rem;
        }
        .section-header {
            border-bottom: 2px solid #dee2e6;
            padding-bottom: 0.5rem;
            margin-bottom: 1.5rem;
        }
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>    <nav class="navbar navbar-expand-lg navbar-dark bg-danger">
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/restaurants">
                            <i class="fas fa-store me-1"></i>Restaurants
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="fas fa-shopping-cart me-1"></i>Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/reports">
                            <i class="fas fa-chart-bar me-1"></i>Reports
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav">                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user me-1"></i>${sessionScope.user.fullName}
                        </a>
                        <ul class="dropdown-menu">
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

    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2><i class="fas fa-chart-line me-2"></i>Reports & Analytics</h2>
                        <p class="text-muted mb-0">Platform insights and performance metrics</p>
                    </div>
                    <div>
                        <button class="btn btn-outline-primary me-2" onclick="refreshReports()">
                            <i class="fas fa-sync-alt me-1"></i>Refresh
                        </button>
                        <div class="btn-group">
                            <button class="btn btn-success dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-download me-1"></i>Export
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#" onclick="exportReport('pdf')">
                                    <i class="fas fa-file-pdf me-2"></i>PDF Report
                                </a></li>
                                <li><a class="dropdown-item" href="#" onclick="exportReport('excel')">
                                    <i class="fas fa-file-excel me-2"></i>Excel Spreadsheet
                                </a></li>
                                <li><a class="dropdown-item" href="#" onclick="exportReport('csv')">
                                    <i class="fas fa-file-csv me-2"></i>CSV Data
                                </a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Time Filter Section -->
        <div class="time-filter">
            <div class="row align-items-center">
                <div class="col-md-3">
                    <label for="timeRange" class="form-label fw-bold">Time Period:</label>
                    <select id="timeRange" class="form-select" onchange="updateReports()">
                        <option value="today">Today</option>
                        <option value="week">This Week</option>
                        <option value="month" selected>This Month</option>
                        <option value="quarter">This Quarter</option>
                        <option value="year">This Year</option>
                        <option value="all">All Time</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold">Custom Date Range:</label>
                    <div class="input-group">
                        <input type="date" id="startDate" class="form-control">
                        <span class="input-group-text">to</span>
                        <input type="date" id="endDate" class="form-control">
                    </div>
                </div>
                <div class="col-md-2">
                    <label class="form-label">&nbsp;</label>
                    <button class="btn btn-primary w-100" onclick="applyCustomRange()">
                        <i class="fas fa-filter me-1"></i>Apply
                    </button>
                </div>
                <div class="col-md-3">
                    <div class="text-end">
                        <small class="text-muted">
                            Last updated: <span id="lastUpdated"></span>
                        </small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Key Performance Indicators -->
        <div class="report-section">
            <h4 class="section-header">
                <i class="fas fa-tachometer-alt me-2"></i>Key Performance Indicators
            </h4>
            <div class="kpi-grid">
                <!-- Total Users KPI -->
                <div class="card stats-card text-white bg-primary">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="metric-label">Total Users</div>
                                <div class="metric-value" id="totalUsersKPI">
                                    ${totalCustomers + totalRestaurantStaff}
                                </div>
                                <small class="trend-indicator trend-up">
                                    <i class="fas fa-arrow-up"></i> +12% vs last month
                                </small>
                            </div>
                            <div class="text-end">
                                <i class="fas fa-users fa-3x opacity-75"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Active Restaurants KPI -->
                <div class="card stats-card text-white bg-success">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="metric-label">Active Restaurants</div>
                                <div class="metric-value" id="totalRestaurantsKPI">
                                    ${totalRestaurants}
                                </div>
                                <small class="trend-indicator trend-up">
                                    <i class="fas fa-arrow-up"></i> +5% vs last month
                                </small>
                            </div>
                            <div class="text-end">
                                <i class="fas fa-store fa-3x opacity-75"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Orders KPI -->
                <div class="card stats-card text-white bg-warning">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="metric-label">Total Orders</div>
                                <div class="metric-value" id="totalOrdersKPI">
                                    ${totalOrders}
                                </div>
                                <small class="trend-indicator trend-up">
                                    <i class="fas fa-arrow-up"></i> +28% vs last month
                                </small>
                            </div>
                            <div class="text-end">
                                <i class="fas fa-shopping-cart fa-3x opacity-75"></i>
                            </div>
                        </div>
                    </div>
                </div>                <!-- Revenue KPI -->
                <div class="card stats-card text-white bg-info">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="metric-label">Platform Revenue</div>
                                <div class="metric-value" id="revenueKPI">
                                    $<span id="totalRevenue"><fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></span>
                                </div>
                                <small class="trend-indicator trend-up">
                                    <i class="fas fa-arrow-up"></i> Total from delivered orders
                                </small>
                            </div>
                            <div class="text-end">
                                <i class="fas fa-dollar-sign fa-3x opacity-75"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Average Order Value -->
                <div class="card stats-card text-white bg-secondary">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="metric-label">Avg Order Value</div>
                                <div class="metric-value" id="avgOrderValue">
                                    $<span><fmt:formatNumber value="${avgOrderValue}" pattern="#,##0.00"/></span>
                                </div>
                                <small class="trend-indicator trend-neutral">
                                    <i class="fas fa-calculator"></i> Revenue ÷ Total Orders
                                </small>
                            </div>
                            <div class="text-end">
                                <i class="fas fa-receipt fa-3x opacity-75"></i>
                            </div>
                        </div>
                    </div>
                </div>                <!-- Order Success Rate -->
                <div class="card stats-card text-white bg-dark">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="metric-label">Order Success Rate</div>
                                <div class="metric-value" id="successRate">
                                    <span>${orderSuccessRate}%</span>
                                </div>
                                <small class="trend-indicator trend-up">
                                    <i class="fas fa-check"></i> Delivered orders
                                </small>
                            </div>
                            <div class="text-end">
                                <i class="fas fa-chart-line fa-3x opacity-75"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Section -->
        <div class="report-section">
            <h4 class="section-header">
                <i class="fas fa-chart-bar me-2"></i>Analytics Charts
            </h4>
            <div class="row">
                <!-- Orders Trend Chart -->
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-chart-line me-2"></i>Orders Trend Over Time
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="ordersTrendChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- User Distribution Chart -->
                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-chart-pie me-2"></i>User Distribution
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="userDistributionChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <!-- Revenue Chart -->
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-dollar-sign me-2"></i>Revenue Analytics
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="revenueChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>                <!-- Popular Cuisine Types -->
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-utensils me-2"></i>Restaurant Cuisine Types
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty cuisineStats}">
                                    <div class="table-responsive">
                                        <table class="table table-sm">
                                            <tbody>
                                                <c:forEach var="cuisine" items="${cuisineStats}">
                                                    <tr>
                                                        <td><strong>${cuisine.key}:</strong></td>
                                                        <td class="text-end">
                                                            <span class="badge bg-primary">${cuisine.value} restaurants</span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-muted py-4">
                                        <i class="fas fa-utensils fa-3x mb-3"></i>
                                        <p>No cuisine data available</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Detailed Statistics Tables -->
        <div class="report-section">
            <h4 class="section-header">
                <i class="fas fa-table me-2"></i>Detailed Statistics
            </h4>
            <div class="row">
                <!-- User Statistics -->
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-users me-2"></i>User Statistics
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-sm">
                                    <tbody>
                                        <tr>
                                            <td><strong>Total Customers:</strong></td>
                                            <td class="text-end">
                                                <span class="badge bg-primary">${totalCustomers}</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Restaurant Staff:</strong></td>
                                            <td class="text-end">
                                                <span class="badge bg-success">${totalRestaurantStaff}</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Active Users:</strong></td>
                                            <td class="text-end">
                                                <span class="badge bg-info">${totalCustomers + totalRestaurantStaff}</span>
                                            </td>
                                        </tr>                                        <tr>
                                            <td><strong>New Users (This Month):</strong></td>
                                            <td class="text-end">
                                                <span class="badge bg-warning text-dark">Data not available</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>User Retention Rate:</strong></td>
                                            <td class="text-end">
                                                <span class="badge bg-success">${orderSuccessRate}%</span>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Restaurant Statistics -->
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-store me-2"></i>Restaurant Statistics
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-sm">
                                    <tbody>
                                        <tr>
                                            <td><strong>Total Restaurants:</strong></td>
                                            <td class="text-end">
                                                <span class="badge bg-primary">${totalRestaurants}</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Active Restaurants:</strong></td>
                                            <td class="text-end">
                                                <span class="badge bg-success">${totalRestaurants}</span>
                                            </td>
                                        </tr>                                        <tr>
                                            <td><strong>Average Rating:</strong></td>
                                            <td class="text-end">
                                                <span class="badge bg-warning text-dark">Data not available</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Active Orders:</strong></td>
                                            <td class="text-end">
                                                <span class="badge bg-info">${activeOrdersCount}</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Today's Revenue:</strong></td>
                                            <td class="text-end">
                                                <small class="text-muted">$<fmt:formatNumber value="${todayRevenue}" pattern="#,##0.00"/></small>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Order Analytics Table -->
            <div class="row mt-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-shopping-cart me-2"></i>Order Analytics Summary
                            </h5>
                        </div>
                        <div class="card-body">                            <div class="row">
                                <div class="col-md-3">
                                    <div class="text-center">
                                        <h6 class="text-muted">Total Orders</h6>
                                        <h3 class="text-primary">${totalOrderCount}</h3>
                                        <small class="text-info">
                                            <i class="fas fa-shopping-cart"></i> All time orders
                                        </small>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="text-center">
                                        <h6 class="text-muted">Pending Orders</h6>
                                        <h3 class="text-warning">${pendingOrdersCount}</h3>
                                        <small class="text-warning">
                                            <i class="fas fa-clock"></i> Need attention
                                        </small>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="text-center">
                                        <h6 class="text-muted">Completed Orders</h6>
                                        <h3 class="text-success">${deliveredOrdersCount}</h3>
                                        <small class="text-success">
                                            <i class="fas fa-check"></i> Successfully delivered
                                        </small>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="text-center">
                                        <h6 class="text-muted">Today's Orders</h6>
                                        <h3 class="text-info">${todayOrderCount}</h3>
                                        <small class="text-info">
                                            <i class="fas fa-calendar-day"></i> Orders today
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Export Options -->
        <div class="export-section">
            <h5>
                <i class="fas fa-download me-2"></i>Export Options
            </h5>
            <p class="text-muted mb-3">Download detailed reports for further analysis</p>
            <div class="row">
                <div class="col-md-4">
                    <div class="card h-100">
                        <div class="card-body text-center">
                            <i class="fas fa-file-pdf fa-3x text-danger mb-3"></i>
                            <h6>PDF Report</h6>
                            <p class="text-muted small">Complete analytics report in PDF format</p>
                            <button class="btn btn-outline-danger btn-sm" onclick="exportReport('pdf')">
                                Download PDF
                            </button>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card h-100">
                        <div class="card-body text-center">
                            <i class="fas fa-file-excel fa-3x text-success mb-3"></i>
                            <h6>Excel Spreadsheet</h6>
                            <p class="text-muted small">Raw data for custom analysis</p>
                            <button class="btn btn-outline-success btn-sm" onclick="exportReport('excel')">
                                Download Excel
                            </button>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card h-100">
                        <div class="card-body text-center">
                            <i class="fas fa-file-csv fa-3x text-primary mb-3"></i>
                            <h6>CSV Data</h6>
                            <p class="text-muted small">Comma-separated values for data import</p>
                            <button class="btn btn-outline-primary btn-sm" onclick="exportReport('csv')">
                                Download CSV
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>    <script>
        // Convert JSP variables to JavaScript variables safely
        var totalCustomers = 0;
        var totalRestaurantStaff = 0;
        var totalOrders = 0;
        var totalRestaurants = 0;
          // Set values from JSP if they exist
        try {
            totalCustomers = parseInt('${totalCustomers}') || 0;
            totalRestaurantStaff = parseInt('${totalRestaurantStaff}') || 0;
            totalOrders = parseInt('${totalOrders}') || 0;
            totalRestaurants = parseInt('${totalRestaurants}') || 0;
        } catch (e) {
            // Keep default values if parsing fails
            console.log('Using default values for charts');
        }
        
        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            updateLastUpdatedTime();
            initializeCharts();
            setDefaultDateRange();
        });

        function updateLastUpdatedTime() {
            const now = new Date();
            document.getElementById('lastUpdated').textContent = now.toLocaleString();
        }

        function setDefaultDateRange() {
            const today = new Date();
            const firstDayOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
            
            document.getElementById('endDate').value = today.toISOString().split('T')[0];
            document.getElementById('startDate').value = firstDayOfMonth.toISOString().split('T')[0];
        }

        function refreshReports() {
            location.reload();
        }

        function updateReports() {
            const timeRange = document.getElementById('timeRange').value;
            // In a real application, this would make an AJAX call to update the data
            console.log('Updating reports for time range:', timeRange);
            updateLastUpdatedTime();
        }

        function applyCustomRange() {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            
            if (startDate && endDate) {
                // In a real application, this would make an AJAX call with the date range
                console.log('Applying custom date range:', startDate, 'to', endDate);
                updateLastUpdatedTime();
            } else {
                alert('Please select both start and end dates');
            }
        }

        function exportReport(format) {
            // In a real application, this would trigger the actual export
            const timeRange = document.getElementById('timeRange').value;
            console.log('Exporting', format, 'report for', timeRange);
            
            // Simulate file download
            const link = document.createElement('a');
            link.href = '#';
            link.download = `food-delivery-report-${timeRange}.${format}`;
            link.textContent = `Download ${format.toUpperCase()} Report`;
            
            // Show success message
            const toast = document.createElement('div');
            toast.className = 'toast-container position-fixed top-0 end-0 p-3';
            toast.innerHTML = `
                <div class="toast show" role="alert">
                    <div class="toast-header">
                        <i class="fas fa-download text-success me-2"></i>
                        <strong class="me-auto">Export Success</strong>
                        <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
                    </div>
                    <div class="toast-body">
                        Your ${format.toUpperCase()} report is being prepared for download.
                    </div>
                </div>
            `;
            document.body.appendChild(toast);
            
            setTimeout(() => {
                document.body.removeChild(toast);
            }, 3000);
        }

        function initializeCharts() {
            // Orders Trend Chart
            const ordersTrendCtx = document.getElementById('ordersTrendChart').getContext('2d');
            new Chart(ordersTrendCtx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    datasets: [{
                        label: 'Orders',
                        data: [120, 150, 180, 220, 280, 320, 380, 420, 380, 450, 480, 520],
                        borderColor: '#007bff',
                        backgroundColor: 'rgba(0, 123, 255, 0.1)',
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });            // User Distribution Chart
            const userDistributionCtx = document.getElementById('userDistributionChart').getContext('2d');
            new Chart(userDistributionCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Customers', 'Restaurant Staff'],
                    datasets: [{
                        data: [totalCustomers, totalRestaurantStaff],
                        backgroundColor: ['#007bff', '#28a745']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });

            // Revenue Chart
            const revenueCtx = document.getElementById('revenueChart').getContext('2d');
            new Chart(revenueCtx, {
                type: 'bar',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                    datasets: [{
                        label: 'Revenue ($)',
                        data: [3200, 4100, 3800, 5200, 4800, 6100],
                        backgroundColor: '#17a2b8'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

            // Cuisine Chart
            const cuisineCtx = document.getElementById('cuisineChart').getContext('2d');
            new Chart(cuisineCtx, {
                type: 'horizontalBar',
                data: {
                    labels: ['Italian', 'Chinese', 'American', 'Mexican', 'Japanese'],
                    datasets: [{
                        label: 'Orders',
                        data: [180, 150, 120, 100, 80],
                        backgroundColor: ['#dc3545', '#fd7e14', '#ffc107', '#28a745', '#6f42c1']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    indexAxis: 'y',
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        x: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }
    </script>
</body>
</html>
