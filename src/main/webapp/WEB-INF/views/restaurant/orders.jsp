<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurant Orders - FoodDelivery</title>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/restaurant/menu">
                            <i class="fas fa-utensils me-1"></i>Menu
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/restaurant/orders">
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
        <!-- Flash Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Page Header -->
        <div class="hero-section">
            <h1><i class="fas fa-receipt me-2"></i>Restaurant Orders</h1>
            <p>Manage incoming orders and update order status.</p>
        </div>

        <!-- Order Status Filter -->
        <div class="glass-card mb-4">
            <div class="card-body">
                <div class="btn-group" role="group">
                    <a href="${pageContext.request.contextPath}/restaurant/orders" 
                       class="btn ${empty currentStatus ? 'btn-primary' : 'btn-outline-primary'}">
                        All Orders
                    </a>
                    <a href="${pageContext.request.contextPath}/restaurant/orders?status=PENDING" 
                       class="btn ${currentStatus == 'PENDING' ? 'btn-warning' : 'btn-outline-warning'}">
                        Pending (${pendingCount})
                    </a>
                    <a href="${pageContext.request.contextPath}/restaurant/orders?status=CONFIRMED" 
                       class="btn ${currentStatus == 'CONFIRMED' ? 'btn-info' : 'btn-outline-info'}">
                        Confirmed (${confirmedCount})
                    </a>
                    <a href="${pageContext.request.contextPath}/restaurant/orders?status=PREPARING" 
                       class="btn ${currentStatus == 'PREPARING' ? 'btn-primary' : 'btn-outline-primary'}">
                        Preparing (${preparingCount})
                    </a>
                    <a href="${pageContext.request.contextPath}/restaurant/orders?status=OUT_FOR_DELIVERY" 
                       class="btn ${currentStatus == 'OUT_FOR_DELIVERY' ? 'btn-dark' : 'btn-outline-dark'}">
                        Out for Delivery (${deliveryCount})
                    </a>
                    <a href="${pageContext.request.contextPath}/restaurant/orders?status=DELIVERED" 
                       class="btn ${currentStatus == 'DELIVERED' ? 'btn-success' : 'btn-outline-success'}">
                        Delivered (${deliveredCount})
                    </a>
                    <a href="${pageContext.request.contextPath}/restaurant/orders?status=CANCELLED" 
                       class="btn ${currentStatus == 'CANCELLED' ? 'btn-danger' : 'btn-outline-danger'}">
                        Cancelled (${cancelledCount})
                    </a>
                </div>
            </div>
        </div>

        <!-- Orders List -->
        <div class="row">
            <c:choose>
                <c:when test="${not empty orders}">
                    <c:forEach var="order" items="${orders}">
                        <div class="col-12 mb-4">
                            <div class="glass-card">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <div>
                                        <h5 class="mb-0">Order #<c:out value="${order.id}"/></h5>
                                        <small class="text-muted">
                                            <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy HH:mm"/>
                                        </small>
                                    </div>
                                    <div>
                                        <span class="badge 
                                            <c:choose>
                                                <c:when test='${order.status.name() == "PENDING"}'>bg-warning</c:when>
                                                <c:when test='${order.status.name() == "CONFIRMED"}'>bg-info</c:when>
                                                <c:when test='${order.status.name() == "PREPARING"}'>bg-primary</c:when>
                                                <c:when test='${order.status.name() == "OUT_FOR_DELIVERY"}'>bg-secondary</c:when>
                                                <c:when test='${order.status.name() == "DELIVERED"}'>bg-success</c:when>
                                                <c:when test='${order.status.name() == "CANCELLED"}'>bg-danger</c:when>
                                                <c:otherwise>bg-secondary</c:otherwise>
                                            </c:choose> fs-6">
                                            <c:out value="${order.status}"/>
                                        </span>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <h6><i class="fas fa-list me-2"></i>Order Items</h6>
                                            <div class="table-responsive">
                                                <table class="glass-table table-sm">
                                                    <thead>
                                                        <tr>
                                                            <th>Item</th>
                                                            <th>Quantity</th>
                                                            <th>Price</th>
                                                            <th>Total</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="item" items="${order.orderItems}">
                                                            <tr>
                                                                <td><c:out value="${item.menuItem.name}"/></td>
                                                                <td><c:out value="${item.quantity}"/></td>
                                                                <td>$<c:out value="${item.unitPrice}"/></td>
                                                                <td>$<c:out value="${item.totalPrice}"/></td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                    <tfoot>
                                                        <tr class="fw-bold">
                                                            <td colspan="3">Total</td>
                                                            <td>$<c:out value="${order.totalAmount}"/></td>
                                                        </tr>
                                                    </tfoot>
                                                </table>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <h6><i class="fas fa-user me-2"></i>Customer Details</h6>
                                            <p><strong><c:out value="${order.customer.fullName}"/></strong></p>
                                            <p><c:out value="${order.customer.email}"/></p>
                                            <c:if test="${not empty order.customer.phone}">
                                                <p><i class="fas fa-phone me-1"></i><c:out value="${order.customer.phone}"/></p>
                                            </c:if>
                                            
                                            <c:if test="${not empty order.deliveryAddress}">
                                                <h6><i class="fas fa-map-marker-alt me-2"></i>Delivery Address</h6>
                                                <p><c:out value="${order.deliveryAddress}"/></p>
                                            </c:if>
                                            
                                            <div class="mt-3">
                                                <c:choose>
                                                    <c:when test='${order.status.name() == "PENDING"}'>
                                                        <button class="btn btn-success btn-sm me-2" 
                                                                onclick="updateOrderStatus('${order.id}', 'CONFIRMED')">
                                                            <i class="fas fa-check me-1"></i>Confirm
                                                        </button>
                                                        <button class="btn btn-danger btn-sm" 
                                                                onclick="updateOrderStatus('${order.id}', 'CANCELLED')">
                                                            <i class="fas fa-times me-1"></i>Cancel
                                                        </button>
                                                    </c:when>
                                                    <c:when test='${order.status.name() == "CONFIRMED"}'>
                                                        <button class="btn btn-primary btn-sm" 
                                                                onclick="updateOrderStatus('${order.id}', 'PREPARING')">
                                                            <i class="fas fa-utensils me-1"></i>Start Preparing
                                                        </button>
                                                    </c:when>
                                                    <c:when test='${order.status.name() == "PREPARING"}'>
                                                        <button class="btn btn-success btn-sm" 
                                                                onclick="updateOrderStatus('${order.id}', 'OUT_FOR_DELIVERY')">
                                                            <i class="fas fa-truck me-1"></i>Out for Delivery
                                                        </button>
                                                    </c:when>
                                                    <c:when test='${order.status.name() == "OUT_FOR_DELIVERY"}'>
                                                        <button class="btn btn-success btn-sm" 
                                                                onclick="updateOrderStatus('${order.id}', 'DELIVERED')">
                                                            <i class="fas fa-check-circle me-1"></i>Mark Delivered
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">No actions available</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="text-center mt-5">
                            <i class="fas fa-receipt" style="font-size: 4rem; opacity: 0.5;"></i>
                            <h3 class="mt-3">No orders found</h3>
                            <p class="text-muted">
                                <c:choose>
                                    <c:when test="${not empty currentStatus}">
                                        No orders with status: <strong>${currentStatus}</strong>
                                    </c:when>
                                    <c:otherwise>
                                        No orders have been placed yet.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
    
    <script>
        function updateOrderStatus(orderId, newStatus) {
            const confirmMessage = `Are you sure you want to update this order to ${newStatus.replace('_', ' ').toLowerCase()}?`;
            if (confirm(confirmMessage)) {
                // Create a form and submit it to match the controller's expected form parameters
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/restaurant/orders/update-status';
                
                const orderIdField = document.createElement('input');
                orderIdField.type = 'hidden';
                orderIdField.name = 'orderId';
                orderIdField.value = orderId;
                form.appendChild(orderIdField);
                
                const statusField = document.createElement('input');
                statusField.type = 'hidden';
                statusField.name = 'status';
                statusField.value = newStatus;
                form.appendChild(statusField);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Auto-refresh every 30 seconds for new orders
        setInterval(function() {
            if (!document.hidden) {
                location.reload();
            }
        }, 30000);
    </script>
</body>
</html>
