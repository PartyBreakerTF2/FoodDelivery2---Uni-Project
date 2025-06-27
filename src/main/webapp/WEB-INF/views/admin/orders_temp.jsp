<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management - Admin</title>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/orders">
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
                        <h3><i class="fas fa-receipt me-2"></i>Order Management</h3>
                        <p class="mb-0">Monitor and manage all orders in the system</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter Bar -->
        <div class="row mb-4">
            <div class="col-md-4">
                <select class="form-select" id="statusFilter">
                    <option value="">All Statuses</option>
                    <option value="PENDING">Pending</option>
                    <option value="CONFIRMED">Confirmed</option>
                    <option value="PREPARING">Preparing</option>
                    <option value="READY">Ready</option>
                    <option value="DELIVERED">Delivered</option>
                    <option value="CANCELLED">Cancelled</option>
                </select>
            </div>
            <div class="col-md-4">
                <input type="date" class="form-control" id="dateFilter">
            </div>
            <div class="col-md-4">
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                    <input type="text" class="form-control" placeholder="Search orders..." id="searchInput">
                </div>
            </div>
        </div>

        <!-- Orders Table -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-list me-2"></i>All Orders</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer</th>
                                        <th>Restaurant</th>
                                        <th>Total</th>
                                        <th>Status</th>
                                        <th>Order Date</th>
                                    </tr>
                                </thead>
                                <tbody id="ordersTableBody">
                                    <c:forEach var="order" items="${orders}">
                                        <tr data-status="<c:out value='${order.status}'/>" 
                                            data-date="<fmt:formatDate value='${order.orderDate}' pattern='yyyy-MM-dd'/>"
                                            onclick="loadOrderDetails('<c:out value='${order.id}'/>')"
                                            style="cursor: pointer;">
                                            <td><strong>#<c:out value="${order.id}"/></strong></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.customer != null}">
                                                        <c:out value="${order.customer.fullName}"/>
                                                    </c:when>
                                                    <c:otherwise>Unknown Customer</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.restaurant != null}">
                                                        <c:out value="${order.restaurant.name}"/>
                                                    </c:when>
                                                    <c:otherwise>Unknown Restaurant</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><strong>$<fmt:formatNumber value="${order.totalAmount}" pattern="0.00"/></strong></td>
                                            <td>
                                                <span class="badge status-badge status-${order.status}">
                                                    <c:choose>
                                                        <c:when test="${order.status.name() == 'PENDING'}">
                                                            <i class="fas fa-clock me-1"></i>Pending
                                                        </c:when>
                                                        <c:when test="${order.status.name() == 'CONFIRMED'}">
                                                            <i class="fas fa-check me-1"></i>Confirmed
                                                        </c:when>
                                                        <c:when test="${order.status.name() == 'PREPARING'}">
                                                            <i class="fas fa-utensils me-1"></i>Preparing
                                                        </c:when>
                                                        <c:when test="${order.status.name() == 'READY'}">
                                                            <i class="fas fa-box me-1"></i>Ready
                                                        </c:when>
                                                        <c:when test="${order.status.name() == 'OUT_FOR_DELIVERY'}">
                                                            <i class="fas fa-truck me-1"></i>Out for Delivery
                                                        </c:when>
                                                        <c:when test="${order.status.name() == 'DELIVERED'}">
                                                            <i class="fas fa-check-circle me-1"></i>Delivered
                                                        </c:when>
                                                        <c:when test="${order.status.name() == 'CANCELLED'}">
                                                            <i class="fas fa-times-circle me-1"></i>Cancelled
                                                        </c:when>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td><fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy HH:mm"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <c:if test="${empty orders}">
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body text-center py-5">
                            <i class="fas fa-receipt fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No orders found</h5>
                            <p class="text-muted">Orders will appear here when customers place them.</p>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Order Details Modal -->
    <div class="modal fade" id="orderDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-receipt me-2"></i>Order Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="orderDetailsContent">
                    <!-- Order details will be loaded here -->
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
    <script>
        // Filter functionality
        document.getElementById('statusFilter').addEventListener('change', filterOrders);
        document.getElementById('dateFilter').addEventListener('change', filterOrders);
        document.getElementById('searchInput').addEventListener('input', filterOrders);

        function filterOrders() {
            const statusFilter = document.getElementById('statusFilter').value;
            const dateFilter = document.getElementById('dateFilter').value;
            const searchFilter = document.getElementById('searchInput').value.toLowerCase();
            const rows = document.querySelectorAll('#ordersTableBody tr');

            rows.forEach(row => {
                const status = row.getAttribute('data-status');
                const date = row.getAttribute('data-date');
                const text = row.textContent.toLowerCase();
                
                const statusMatch = !statusFilter || status === statusFilter;
                const dateMatch = !dateFilter || date === dateFilter;
                const textMatch = !searchFilter || text.includes(searchFilter);
                
                row.style.display = statusMatch && dateMatch && textMatch ? '' : 'none';
            });
        }

        function loadOrderDetails(orderId) {
            // Here you would typically make an AJAX call to load order details
            // For now, showing a comprehensive placeholder
            const content = `
                <div class="row">
                    <div class="col-md-6">
                        <h6><i class="fas fa-info-circle me-2"></i>Order Information</h6>
                        <table class="table table-borderless table-sm">
                            <tr><td><strong>Order ID:</strong></td><td>#${orderId}</td></tr>
                            <tr><td><strong>Status:</strong></td><td><span class="badge bg-warning">Loading...</span></td></tr>
                            <tr><td><strong>Order Date:</strong></td><td>Loading...</td></tr>
                            <tr><td><strong>Total Amount:</strong></td><td>Loading...</td></tr>
                        </table>
                    </div>
                    <div class="col-md-6">
                        <h6><i class="fas fa-user me-2"></i>Customer Information</h6>
                        <table class="table table-borderless table-sm">
                            <tr><td><strong>Name:</strong></td><td>Loading...</td></tr>
                            <tr><td><strong>Email:</strong></td><td>Loading...</td></tr>
                            <tr><td><strong>Phone:</strong></td><td>Loading...</td></tr>
                            <tr><td><strong>Address:</strong></td><td>Loading...</td></tr>
                        </table>
                    </div>
                </div>
                <hr>
                <div class="row">
                    <div class="col-12">
                        <h6><i class="fas fa-utensils me-2"></i>Order Items</h6>
                        <div class="text-center py-3">
                            <i class="fas fa-spinner fa-spin fa-2x"></i>
                            <p class="mt-2">Loading order items...</p>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <h6><i class="fas fa-store me-2"></i>Restaurant Information</h6>
                        <div class="text-center py-3">
                            <i class="fas fa-spinner fa-spin"></i>
                            <span class="ms-2">Loading restaurant details...</span>
                        </div>
                    </div>
                </div>
            `;
            document.getElementById('orderDetailsContent').innerHTML = content;
            new bootstrap.Modal(document.getElementById('orderDetailsModal')).show();
        }
    </script>
</body>
</html>
