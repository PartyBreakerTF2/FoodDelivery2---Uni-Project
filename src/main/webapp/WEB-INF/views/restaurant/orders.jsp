<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurant Orders - Food Delivery System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .status-badge {
            font-size: 0.75rem;
            padding: 0.375rem 0.75rem;
        }
        .order-card {
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }
        .order-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .order-card.pending {
            border-left-color: #ffc107;
        }
        .order-card.confirmed {
            border-left-color: #17a2b8;
        }
        .order-card.preparing {
            border-left-color: #fd7e14;
        }
        .order-card.out-for-delivery {
            border-left-color: #6f42c1;
        }
        .order-card.delivered {
            border-left-color: #28a745;
        }
        .order-card.cancelled {
            border-left-color: #dc3545;
        }
        .restaurant-info {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        .order-items {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-top: 1rem;
        }
        .action-buttons .btn {
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/restaurant/menu">
                            <i class="fas fa-utensils me-1"></i>Menu Management
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/restaurant/orders">
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
        <!-- Restaurant Info Header -->
        <c:if test="${not empty restaurant}">
            <div class="restaurant-info">
                <div class="row align-items-center">                    <div class="col-md-8">
                        <h3><i class="fas fa-store me-2"></i>${restaurant.name}</h3>
                        <p class="mb-2"><i class="fas fa-map-marker-alt me-2"></i>${restaurant.address}</p>
                        <p class="mb-2"><i class="fas fa-utensils me-2"></i>${restaurant.cuisineType} Cuisine</p>
                        <p class="mb-0"><i class="fas fa-clock me-2"></i>${restaurant.openingHours}</p>
                    </div>
                    <div class="col-md-4 text-md-end">
                        <h4><i class="fas fa-star text-warning me-1"></i>${restaurant.rating}/5.0</h4>
                        <p class="mb-0"><i class="fas fa-phone me-2"></i>${restaurant.phone}</p>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Page Header -->
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2><i class="fas fa-clipboard-list me-2"></i>Restaurant Orders</h2>
                        <p class="text-muted mb-0">Manage incoming orders for your restaurant</p>
                    </div>
                    <div>
                        <button class="btn btn-outline-primary" onclick="location.reload()">
                            <i class="fas fa-sync-alt me-1"></i>Refresh
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Order Statistics -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card text-center border-warning">
                    <div class="card-body">
                        <h5 class="card-title text-warning">
                            <i class="fas fa-clock"></i>
                        </h5>
                        <h3 class="mb-0">${pendingCount}</h3>
                        <p class="text-muted">Pending</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center border-info">
                    <div class="card-body">
                        <h5 class="card-title text-info">
                            <i class="fas fa-check-circle"></i>
                        </h5>
                        <h3 class="mb-0">${confirmedCount}</h3>
                        <p class="text-muted">Confirmed</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center border-primary">
                    <div class="card-body">
                        <h5 class="card-title text-primary">
                            <i class="fas fa-utensils"></i>
                        </h5>
                        <h3 class="mb-0">${preparingCount}</h3>
                        <p class="text-muted">Preparing</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center border-success">
                    <div class="card-body">
                        <h5 class="card-title text-success">
                            <i class="fas fa-truck"></i>
                        </h5>
                        <h3 class="mb-0">${deliveryCount}</h3>
                        <p class="text-muted">Out for Delivery</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Error/Success Messages -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Orders List -->
        <div class="row">
            <div class="col-12">
                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="text-center py-5">
                            <i class="fas fa-clipboard-list fa-5x text-muted mb-3"></i>
                            <h4 class="text-muted">No Orders Yet</h4>
                            <p class="text-muted">You haven't received any orders for your restaurant yet.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="order" items="${orders}">
                            <div class="card order-card ${order.status.toString().toLowerCase().replace('_', '-')} mb-3">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <h5 class="card-title mb-0">
                                                    <i class="fas fa-receipt me-2"></i>Order #${order.id}
                                                </h5>
                                                <span class="badge status-badge
                                                    <c:choose>
                                                        <c:when test="${order.status == 'PENDING'}">bg-warning text-dark</c:when>
                                                        <c:when test="${order.status == 'CONFIRMED'}">bg-info</c:when>
                                                        <c:when test="${order.status == 'PREPARING'}">bg-primary</c:when>
                                                        <c:when test="${order.status == 'OUT_FOR_DELIVERY'}">bg-purple</c:when>
                                                        <c:when test="${order.status == 'DELIVERED'}">bg-success</c:when>
                                                        <c:when test="${order.status == 'CANCELLED'}">bg-danger</c:when>
                                                        <c:otherwise>bg-secondary</c:otherwise>
                                                    </c:choose>
                                                ">
                                                    <c:choose>
                                                        <c:when test="${order.status == 'PENDING'}">
                                                            <i class="fas fa-clock me-1"></i>Pending
                                                        </c:when>
                                                        <c:when test="${order.status == 'CONFIRMED'}">
                                                            <i class="fas fa-check-circle me-1"></i>Confirmed
                                                        </c:when>
                                                        <c:when test="${order.status == 'PREPARING'}">
                                                            <i class="fas fa-utensils me-1"></i>Preparing
                                                        </c:when>
                                                        <c:when test="${order.status == 'OUT_FOR_DELIVERY'}">
                                                            <i class="fas fa-truck me-1"></i>Out for Delivery
                                                        </c:when>
                                                        <c:when test="${order.status == 'DELIVERED'}">
                                                            <i class="fas fa-check-double me-1"></i>Delivered
                                                        </c:when>
                                                        <c:when test="${order.status == 'CANCELLED'}">
                                                            <i class="fas fa-times-circle me-1"></i>Cancelled
                                                        </c:when>
                                                        <c:otherwise>${order.status}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            
                                            <div class="row">
                                                <div class="col-sm-6">
                                                    <p class="mb-1">
                                                        <i class="fas fa-user me-2 text-muted"></i>
                                                        <strong>Customer:</strong> 
                                                        <c:choose>
                                                            <c:when test="${not empty order.customer.fullName}">
                                                                ${order.customer.fullName}
                                                            </c:when>
                                                            <c:otherwise>
                                                                Customer #${order.customerId}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                    <p class="mb-1">
                                                        <i class="fas fa-calendar me-2 text-muted"></i>
                                                        <strong>Order Date:</strong> 
                                                        <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy HH:mm" />
                                                    </p>
                                                </div>
                                                <div class="col-sm-6">
                                                    <p class="mb-1">
                                                        <i class="fas fa-dollar-sign me-2 text-muted"></i>
                                                        <strong>Total:</strong> 
                                                        <span class="fw-bold text-success">$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                                                    </p>
                                                    <p class="mb-1">
                                                        <i class="fas fa-map-marker-alt me-2 text-muted"></i>
                                                        <strong>Delivery:</strong> ${order.deliveryAddress}
                                                    </p>
                                                </div>
                                            </div>

                                            <c:if test="${not empty order.specialInstructions}">
                                                <div class="mt-2">
                                                    <p class="mb-0">
                                                        <i class="fas fa-sticky-note me-2 text-muted"></i>
                                                        <strong>Special Instructions:</strong> ${order.specialInstructions}
                                                    </p>
                                                </div>
                                            </c:if>

                                            <!-- Order Items (if available) -->
                                            <c:if test="${not empty order.orderItems}">
                                                <div class="order-items">
                                                    <h6><i class="fas fa-list me-2"></i>Order Items:</h6>
                                                    <c:forEach var="item" items="${order.orderItems}">
                                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                                            <span>${item.quantity}x ${item.menuItemName}</span>
                                                            <span class="fw-bold">$<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></span>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="action-buttons text-md-end">
                                                <c:choose>
                                                    <c:when test="${order.status == 'PENDING'}">
                                                        <form action="${pageContext.request.contextPath}/restaurant/orders/update-status" method="post" style="display: inline;">
                                                            <input type="hidden" name="orderId" value="${order.id}">
                                                            <input type="hidden" name="status" value="CONFIRMED">
                                                            <button type="submit" class="btn btn-success btn-sm">
                                                                <i class="fas fa-check me-1"></i>Confirm
                                                            </button>
                                                        </form>
                                                        <form action="${pageContext.request.contextPath}/restaurant/orders/update-status" method="post" style="display: inline;">
                                                            <input type="hidden" name="orderId" value="${order.id}">
                                                            <input type="hidden" name="status" value="CANCELLED">
                                                            <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to cancel this order?')">
                                                                <i class="fas fa-times me-1"></i>Cancel
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:when test="${order.status == 'CONFIRMED'}">
                                                        <form action="${pageContext.request.contextPath}/restaurant/orders/update-status" method="post" style="display: inline;">
                                                            <input type="hidden" name="orderId" value="${order.id}">
                                                            <input type="hidden" name="status" value="PREPARING">
                                                            <button type="submit" class="btn btn-primary btn-sm">
                                                                <i class="fas fa-utensils me-1"></i>Start Preparing
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:when test="${order.status == 'PREPARING'}">
                                                        <form action="${pageContext.request.contextPath}/restaurant/orders/update-status" method="post" style="display: inline;">
                                                            <input type="hidden" name="orderId" value="${order.id}">
                                                            <input type="hidden" name="status" value="OUT_FOR_DELIVERY">
                                                            <button type="submit" class="btn btn-warning btn-sm">
                                                                <i class="fas fa-truck me-1"></i>Ready for Delivery
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:when test="${order.status == 'OUT_FOR_DELIVERY'}">
                                                        <form action="${pageContext.request.contextPath}/restaurant/orders/update-status" method="post" style="display: inline;">
                                                            <input type="hidden" name="orderId" value="${order.id}">
                                                            <input type="hidden" name="status" value="DELIVERED">
                                                            <button type="submit" class="btn btn-success btn-sm">
                                                                <i class="fas fa-check-double me-1"></i>Mark as Delivered
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">
                                                            <i class="fas fa-info-circle me-1"></i>No actions available
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .bg-purple {
            background-color: #6f42c1 !important;
        }
    </style>
</body>
</html>
