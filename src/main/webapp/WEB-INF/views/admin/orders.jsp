<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .status-badge {
            font-size: 0.75em;
            padding: 0.25em 0.5em;
        }
        .order-details {
            font-size: 0.9em;
        }
        .collapsible-row {
            cursor: pointer;
        }
        .order-items-details {
            background-color: #f8f9fa;
            border-left: 4px solid #0d6efd;
        }
        .filter-section {
            background-color: #f8f9fa;
            border-radius: 0.375rem;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        .stats-card {
            border: none;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/orders">
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
                        <h2><i class="fas fa-clipboard-list me-2"></i>Order Management</h2>
                        <p class="text-muted mb-0">Manage and monitor all platform orders</p>
                    </div>
                    <div>
                        <button class="btn btn-outline-primary me-2" onclick="refreshOrders()">
                            <i class="fas fa-sync-alt me-1"></i>Refresh
                        </button>
                        <button class="btn btn-success" onclick="exportOrders()">
                            <i class="fas fa-download me-1"></i>Export
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="card stats-card text-white bg-primary">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">Total Orders</h6>
                                <h4 class="mb-0">${orders.size()}</h4>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-shopping-cart fa-2x opacity-75"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="card stats-card text-white bg-warning">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">Pending Orders</h6>
                                <h4 class="mb-0">
                                    <c:set var="pendingCount" value="0" />
                                    <c:forEach var="order" items="${orders}">
                                        <c:if test="${order.status == 'PENDING'}">
                                            <c:set var="pendingCount" value="${pendingCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${pendingCount}
                                </h4>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-clock fa-2x opacity-75"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="card stats-card text-white bg-info">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">In Progress</h6>
                                <h4 class="mb-0">
                                    <c:set var="progressCount" value="0" />
                                    <c:forEach var="order" items="${orders}">
                                        <c:if test="${order.status == 'CONFIRMED' || order.status == 'PREPARING' || order.status == 'OUT_FOR_DELIVERY'}">
                                            <c:set var="progressCount" value="${progressCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${progressCount}
                                </h4>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-spinner fa-2x opacity-75"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="card stats-card text-white bg-success">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">Completed</h6>
                                <h4 class="mb-0">
                                    <c:set var="completedCount" value="0" />
                                    <c:forEach var="order" items="${orders}">
                                        <c:if test="${order.status == 'DELIVERED'}">
                                            <c:set var="completedCount" value="${completedCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${completedCount}
                                </h4>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-check-circle fa-2x opacity-75"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="row">
            <div class="col-12">
                <div class="filter-section">
                    <div class="row align-items-end">
                        <div class="col-md-3">
                            <label for="statusFilter" class="form-label">Filter by Status</label>
                            <select id="statusFilter" class="form-select" onchange="filterOrders()">
                                <option value="">All Statuses</option>
                                <option value="PENDING">Pending</option>
                                <option value="CONFIRMED">Confirmed</option>
                                <option value="PREPARING">Preparing</option>
                                <option value="OUT_FOR_DELIVERY">Out for Delivery</option>
                                <option value="DELIVERED">Delivered</option>
                                <option value="CANCELLED">Cancelled</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="dateFilter" class="form-label">Filter by Date</label>
                            <select id="dateFilter" class="form-select" onchange="filterOrders()">
                                <option value="">All Dates</option>
                                <option value="today">Today</option>
                                <option value="yesterday">Yesterday</option>
                                <option value="week">This Week</option>
                                <option value="month">This Month</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="searchInput" class="form-label">Search Orders</label>
                            <input type="text" id="searchInput" class="form-control" placeholder="Search by Order ID, Customer, or Restaurant..." onkeyup="searchOrders()">
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-outline-secondary w-100" onclick="clearFilters()">
                                <i class="fas fa-times me-1"></i>Clear
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Orders Table -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-light">
                        <h5 class="mb-0"><i class="fas fa-list me-2"></i>All Orders</h5>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty orders}">
                                <div class="text-center py-5">
                                    <i class="fas fa-shopping-cart fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">No orders found</h5>
                                    <p class="text-muted">Orders will appear here when customers start placing them.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0" id="ordersTable">
                                        <thead class="table-light">
                                            <tr>
                                                <th width="8%">Order ID</th>
                                                <th width="15%">Customer</th>
                                                <th width="15%">Restaurant</th>
                                                <th width="10%">Total</th>
                                                <th width="12%">Status</th>
                                                <th width="15%">Order Date</th>
                                                <th width="15%">Delivery Address</th>
                                                <th width="10%">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="order" items="${orders}">
                                                <tr class="collapsible-row" data-order-id="${order.id}" onclick="toggleOrderDetails('${order.id}')">
                                                    <td>
                                                        <strong>#${order.id}</strong>
                                                        <c:if test="${not empty order.orderItems}">
                                                            <br><small class="text-muted">${order.orderItems.size()} items</small>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${order.customer != null}">
                                                                <div class="fw-bold">${order.customer.fullName}</div>
                                                                <small class="text-muted">${order.customer.email}</small>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">Customer #${order.customerId}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${order.restaurant != null}">
                                                                <div class="fw-bold">${order.restaurant.name}</div>
                                                                <small class="text-muted">${order.restaurant.cuisineType}</small>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">Restaurant #${order.restaurantId}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="fw-bold text-success">$<fmt:formatNumber value="${order.totalAmount}" pattern="#.##"/></div>
                                                    </td>
                                                    <td>
                                                        <span class="badge status-badge
                                                            <c:choose>
                                                                <c:when test="${order.status == 'PENDING'}">bg-warning text-dark</c:when>
                                                                <c:when test="${order.status == 'CONFIRMED'}">bg-info</c:when>
                                                                <c:when test="${order.status == 'PREPARING'}">bg-primary</c:when>
                                                                <c:when test="${order.status == 'OUT_FOR_DELIVERY'}">bg-secondary</c:when>
                                                                <c:when test="${order.status == 'DELIVERED'}">bg-success</c:when>
                                                                <c:when test="${order.status == 'CANCELLED'}">bg-danger</c:when>
                                                                <c:otherwise>bg-dark</c:otherwise>
                                                            </c:choose>
                                                        ">${order.status}</span>
                                                    </td>
                                                    <td>
                                                        <div class="order-details">
                                                            <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy" />
                                                            <br><small class="text-muted">
                                                                <fmt:formatDate value="${order.orderDate}" pattern="hh:mm a" />
                                                            </small>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="order-details">
                                                            <c:choose>
                                                                <c:when test="${not empty order.deliveryAddress}">
                                                                    ${order.deliveryAddress}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">No address</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group-vertical btn-group-sm" role="group">                                                            <button class="btn btn-outline-primary btn-sm" onclick="event.stopPropagation(); viewOrderDetails('${order.id}')" title="View Details">
                                                                <i class="fas fa-eye"></i>
                                                            </button>
                                                            <c:if test="${order.status == 'PENDING'}">
                                                                <button class="btn btn-outline-success btn-sm" onclick="event.stopPropagation(); updateOrderStatus('${order.id}', 'CONFIRMED')" title="Confirm Order">
                                                                    <i class="fas fa-check"></i>
                                                                </button>
                                                            </c:if>
                                                            <c:if test="${order.status != 'DELIVERED' && order.status != 'CANCELLED'}">
                                                                <button class="btn btn-outline-danger btn-sm" onclick="event.stopPropagation(); updateOrderStatus('${order.id}', 'CANCELLED')" title="Cancel Order">
                                                                    <i class="fas fa-times"></i>
                                                                </button>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                                
                                                <!-- Expandable Order Details Row -->
                                                <tr class="order-details-row d-none" id="details-${order.id}">
                                                    <td colspan="8" class="order-items-details">
                                                        <div class="row p-3">
                                                            <div class="col-md-6">
                                                                <h6><i class="fas fa-utensils me-2"></i>Order Items</h6>
                                                                <c:choose>
                                                                    <c:when test="${not empty order.orderItems}">
                                                                        <div class="table-responsive">
                                                                            <table class="table table-sm">
                                                                                <thead>
                                                                                    <tr>
                                                                                        <th>Item</th>
                                                                                        <th>Price</th>
                                                                                        <th>Qty</th>
                                                                                        <th>Total</th>
                                                                                    </tr>
                                                                                </thead>
                                                                                <tbody>
                                                                                    <c:forEach var="item" items="${order.orderItems}">
                                                                                        <tr>
                                                                                            <td>${item.menuItemName}</td>
                                                                                            <td>$<fmt:formatNumber value="${item.menuItemPrice}" pattern="#.##"/></td>
                                                                                            <td>${item.quantity}</td>
                                                                                            <td>$<fmt:formatNumber value="${item.subtotal}" pattern="#.##"/></td>
                                                                                        </tr>
                                                                                    </c:forEach>
                                                                                </tbody>
                                                                            </table>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <p class="text-muted">No items available</p>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <h6><i class="fas fa-info-circle me-2"></i>Order Information</h6>
                                                                <div class="row">
                                                                    <div class="col-6">
                                                                        <strong>Order Date:</strong><br>
                                                                        <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy 'at' hh:mm a" />
                                                                    </div>
                                                                    <div class="col-6">
                                                                        <strong>Status:</strong><br>
                                                                        <span class="badge bg-secondary">${order.status}</span>
                                                                    </div>
                                                                </div>
                                                                <hr>
                                                                <c:if test="${not empty order.specialInstructions}">
                                                                    <div class="mb-2">
                                                                        <strong>Special Instructions:</strong><br>
                                                                        <span class="text-muted">${order.specialInstructions}</span>
                                                                    </div>
                                                                </c:if>
                                                                <div class="mb-2">
                                                                    <strong>Total Amount:</strong><br>
                                                                    <span class="h5 text-success">$<fmt:formatNumber value="${order.totalAmount}" pattern="#.##"/></span>
                                                                </div>
                                                                <c:if test="${order.deliveryDate != null}">
                                                                    <div>
                                                                        <strong>Delivered:</strong><br>
                                                                        <fmt:formatDate value="${order.deliveryDate}" pattern="MMM dd, yyyy 'at' hh:mm a" />
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Order Details Modal -->
    <div class="modal fade" id="orderDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Order Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="orderDetailsContent">
                    <!-- Order details will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Status Update Modal -->
    <div class="modal fade" id="statusUpdateModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Update Order Status</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to update the status of Order <span id="updateOrderId"></span>?</p>
                    <input type="hidden" id="updateOrderIdValue">
                    <input type="hidden" id="updateStatusValue">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="confirmStatusUpdate()">Update Status</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>        function toggleOrderDetails(orderId) {
            const detailsRow = document.getElementById('details-' + orderId);
            if (detailsRow.classList.contains('d-none')) {
                // Hide all other details first
                document.querySelectorAll('.order-details-row').forEach(row => {
                    row.classList.add('d-none');
                });
                detailsRow.classList.remove('d-none');
            } else {
                detailsRow.classList.add('d-none');
            }
        }

        function viewOrderDetails(orderId) {
            // In a real application, you might load this via AJAX
            const modal = new bootstrap.Modal(document.getElementById('orderDetailsModal'));
            modal.show();
        }

        function updateOrderStatus(orderId, newStatus) {
            document.getElementById('updateOrderId').textContent = '#' + orderId;
            document.getElementById('updateOrderIdValue').value = orderId;
            document.getElementById('updateStatusValue').value = newStatus;
            
            const modal = new bootstrap.Modal(document.getElementById('statusUpdateModal'));
            modal.show();
        }

        function confirmStatusUpdate() {
            const orderId = document.getElementById('updateOrderIdValue').value;
            const newStatus = document.getElementById('updateStatusValue').value;
            
            // Create a form and submit it
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/admin/orders/' + orderId + '/status';
            
            const statusInput = document.createElement('input');
            statusInput.type = 'hidden';
            statusInput.name = 'status';
            statusInput.value = newStatus;
            form.appendChild(statusInput);
            
            document.body.appendChild(form);
            form.submit();
        }

        function filterOrders() {
            const statusFilter = document.getElementById('statusFilter').value.toLowerCase();
            const dateFilter = document.getElementById('dateFilter').value;
            const table = document.getElementById('ordersTable');
            const rows = table.querySelectorAll('tbody tr:not(.order-details-row)');
            
            rows.forEach(row => {
                let show = true;
                
                // Status filter
                if (statusFilter && !row.textContent.toLowerCase().includes(statusFilter)) {
                    show = false;
                }
                
                // Date filter (simplified - in a real app you'd parse the actual dates)
                if (dateFilter && dateFilter !== '') {
                    // This would need proper date parsing in a real application
                    const orderDate = row.cells[5].textContent;
                    const today = new Date();
                    
                    // Basic date filtering logic would go here
                }
                
                row.style.display = show ? '' : 'none';
                
                // Also hide/show corresponding details row
                const orderId = row.getAttribute('data-order-id');
                const detailsRow = document.getElementById('details-' + orderId);
                if (detailsRow) {
                    detailsRow.style.display = show ? '' : 'none';
                }
            });
        }

        function searchOrders() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const table = document.getElementById('ordersTable');
            const rows = table.querySelectorAll('tbody tr:not(.order-details-row)');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                const show = text.includes(searchTerm);
                row.style.display = show ? '' : 'none';
                
                // Also hide/show corresponding details row
                const orderId = row.getAttribute('data-order-id');
                const detailsRow = document.getElementById('details-' + orderId);
                if (detailsRow) {
                    detailsRow.style.display = show ? '' : 'none';
                }
            });
        }

        function clearFilters() {
            document.getElementById('statusFilter').value = '';
            document.getElementById('dateFilter').value = '';
            document.getElementById('searchInput').value = '';
            
            // Show all rows
            const table = document.getElementById('ordersTable');
            const rows = table.querySelectorAll('tbody tr');
            rows.forEach(row => {
                row.style.display = '';
            });
            
            // Hide all details rows
            document.querySelectorAll('.order-details-row').forEach(row => {
                row.classList.add('d-none');
            });
        }

        function refreshOrders() {
            location.reload();
        }

        function exportOrders() {
            // In a real application, this would trigger a CSV/Excel export
            alert('Export functionality would be implemented here');
        }

        // Auto-refresh every 30 seconds for real-time updates
        // setInterval(refreshOrders, 30000);
    </script>
</body>
</html>
