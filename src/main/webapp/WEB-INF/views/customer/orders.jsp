<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - FoodDelivery</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/global-styles.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/customer/dashboard">
                <i class="fas fa-utensils me-2"></i>FoodDelivery
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/dashboard">
                            <i class="fas fa-home me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/restaurants">
                            <i class="fas fa-store me-1"></i>Restaurants
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/customer/orders">
                            <i class="fas fa-receipt me-1"></i>My Orders
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <button class="theme-toggle btn p-0" onclick="toggleTheme()" title="Toggle theme">
                            <i id="themeIcon" class="fas fa-moon"></i>
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
            <h1><i class="fas fa-receipt me-2"></i>My Orders</h1>
            <p>Track your orders and view order history.</p>
        </div>

        <!-- Orders List -->
        <div class="row">
            <c:choose>
                <c:when test="${not empty orders}">
                    <c:forEach var="order" items="${orders}">
                        <div class="col-12 mb-4">
                            <div class="glass-card">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-md-2">
                                            <h6 class="mb-1">Order #<c:out value="${order.id}"/></h6>
                                            <small class="text-muted">
                                                <c:out value="${order.orderDate}"/>
                                            </small>
                                        </div>
                                        <div class="col-md-3">
                                            <strong class="d-block"><c:out value="${order.restaurant.name}"/></strong>
                                            <small class="text-muted">
                                                <c:out value="${order.restaurant.address}"/>
                                            </small>
                                        </div>
                                        <div class="col-md-2">
                                            <span class="badge 
                                                <c:choose>
                                                    <c:when test='${order.status.name() == "PENDING"}'>bg-warning</c:when>
                                                    <c:when test='${order.status.name() == "CONFIRMED"}'>bg-info</c:when>
                                                    <c:when test='${order.status.name() == "PREPARING"}'>bg-primary</c:when>
                                                    <c:when test='${order.status.name() == "OUT_FOR_DELIVERY"}'>bg-secondary</c:when>
                                                    <c:when test='${order.status.name() == "DELIVERED"}'>bg-success</c:when>
                                                    <c:when test='${order.status.name() == "CANCELLED"}'>bg-danger</c:when>
                                                    <c:otherwise>bg-secondary</c:otherwise>
                                                </c:choose>">
                                                <c:choose>
                                                    <c:when test='${order.status.name() == "PENDING"}'>
                                                        <i class="fas fa-clock me-1"></i>Pending
                                                    </c:when>
                                                    <c:when test='${order.status.name() == "CONFIRMED"}'>
                                                        <i class="fas fa-check me-1"></i>Confirmed
                                                    </c:when>
                                                    <c:when test='${order.status.name() == "PREPARING"}'>
                                                        <i class="fas fa-utensils me-1"></i>Preparing
                                                    </c:when>
                                                    <c:when test='${order.status.name() == "OUT_FOR_DELIVERY"}'>
                                                        <i class="fas fa-truck me-1"></i>Out for Delivery
                                                    </c:when>
                                                    <c:when test='${order.status.name() == "DELIVERED"}'>
                                                        <i class="fas fa-check-circle me-1"></i>Delivered
                                                    </c:when>
                                                    <c:when test='${order.status.name() == "CANCELLED"}'>
                                                        <i class="fas fa-times-circle me-1"></i>Cancelled
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:out value="${order.status}"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="col-md-2 text-end">
                                            <strong class="fs-5">$<c:out value="${order.totalAmount}"/></strong>
                                        </div>
                                        <div class="col-md-3">
                                            <button class="btn btn-outline-primary btn-sm" 
                                                    onclick="toggleOrderDetails('order-${order.id}')">
                                                <i class="fas fa-eye me-1"></i>View Details
                                            </button>
                                            <c:if test='${order.status.name() == "PENDING"}'>
                                                <button class="btn btn-outline-danger btn-sm ms-2" 
                                                        id="cancel-btn-${order.id}"
                                                        onclick="cancelOrder('${order.id}')">
                                                    <i class="fas fa-times me-1"></i>Cancel
                                                </button>
                                            </c:if>
                                            <c:if test='${order.status.name() == "DELIVERED"}'>
                                                <button class="btn btn-outline-success btn-sm ms-2" 
                                                        onclick="openRatingModal('${order.id}', '${fn:escapeXml(order.restaurant.name)}', '${order.restaurant.id}')">
                                                    <i class="fas fa-star me-1"></i>Rate Order
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                    <!-- Order Details (Hidden by default) -->
                                    <div id="order-${order.id}" class="mt-3" style="display: none;">
                                        <hr>
                                        <h6><i class="fas fa-list me-2"></i>Order Items</h6>
                                        <div class="table-responsive">
                                            <table class="table table-sm glass-table">
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
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty item.menuItem}">
                                                                        <c:out value="${item.menuItem.name}"/>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:out value="${item.menuItemName}"/>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td><c:out value="${item.quantity}"/></td>
                                                            <td>$<c:out value="${item.unitPrice}"/></td>
                                                            <td>$<c:out value="${item.totalPrice}"/></td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                        
                                        <c:if test="${not empty order.deliveryAddress}">
                                            <div class="mt-3">
                                                <h6><i class="fas fa-map-marker-alt me-2"></i>Delivery Address</h6>
                                                <p><c:out value="${order.deliveryAddress}"/></p>
                                            </div>
                                        </c:if>
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
                            <h3 class="mt-3">No orders yet</h3>
                            <p class="text-muted">Start ordering from your favorite restaurants!</p>
                            <a href="${pageContext.request.contextPath}/customer/restaurants" class="btn btn-primary">
                                <i class="fas fa-store me-2"></i>Browse Restaurants
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Rating Modal -->
    <div class="modal fade" id="ratingModal" tabindex="-1" aria-labelledby="ratingModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="ratingModalLabel">
                        <i class="fas fa-star me-2"></i>Rate Your Experience
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <form id="ratingForm">
                        <input type="hidden" id="ratingOrderId" name="orderId">
                        <input type="hidden" id="ratingRestaurantId" name="restaurantId">
                        <div class="mb-3">
                            <h6 id="restaurantName" class="mb-3"></h6>
                            <div class="rating-stars mb-3">
                                <span class="star" data-rating="1"><i class="fas fa-star"></i></span>
                                <span class="star" data-rating="2"><i class="fas fa-star"></i></span>
                                <span class="star" data-rating="3"><i class="fas fa-star"></i></span>
                                <span class="star" data-rating="4"><i class="fas fa-star"></i></span>
                                <span class="star" data-rating="5"><i class="fas fa-star"></i></span>
                            </div>
                            <input type="hidden" id="ratingValue" name="rating" value="0">
                            <p class="text-muted small">Click to rate from 1 to 5 stars</p>
                        </div>
                    </form>
                </div>
                <div class="modal-footer justify-content-center">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Cancel
                    </button>
                    <button type="button" class="btn btn-primary" onclick="submitRating()">
                        Submit Rating
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
    
    <style>
        .rating-stars {
            font-size: 2rem;
            text-align: center;
        }
        .star {
            cursor: pointer;
            transition: color 0.3s;
            margin: 0 2px;
        }
        .star i {
            color: #ddd !important;
            transition: color 0.3s;
        }
        .star:hover i,
        .star.active i {
            color: #ffc107 !important;
        }
        .star.active {
            animation: starPulse 0.3s ease-in-out;
        }
        @keyframes starPulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.2); }
            100% { transform: scale(1); }
        }
        
        /* Ensure star colors work in both light and dark mode */
        [data-theme="light"] .star i,
        [data-theme="dark"] .star i {
            color: #ddd !important;
        }
        [data-theme="light"] .star:hover i,
        [data-theme="light"] .star.active i,
        [data-theme="dark"] .star:hover i,
        [data-theme="dark"] .star.active i {
            color: #ffc107 !important;
        }
    </style>
    
    <script>
        function toggleOrderDetails(orderId) {
            const element = document.getElementById(orderId);
            if (element.style.display === 'none') {
                element.style.display = 'block';
            } else {
                element.style.display = 'none';
            }
        }
        
        function cancelOrder(orderId) {
            if (confirm('Are you sure you want to cancel this order?')) {
                // Show loading state
                const cancelBtn = document.getElementById('cancel-btn-' + orderId);
                if (!cancelBtn) {
                    console.error('Cancel button not found for order:', orderId);
                    return;
                }
                
                const originalText = cancelBtn.innerHTML;
                cancelBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Cancelling...';
                cancelBtn.disabled = true;
                
                fetch('${pageContext.request.contextPath}/customer/orders/' + orderId + '/cancel', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Order cancelled successfully!');
                        location.reload();
                    } else {
                        alert('Failed to cancel order: ' + (data.message || 'Unknown error'));
                        // Restore button state
                        cancelBtn.innerHTML = originalText;
                        cancelBtn.disabled = false;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to cancel order. Please try again.');
                    // Restore button state
                    cancelBtn.innerHTML = originalText;
                    cancelBtn.disabled = false;
                });
            }
        }
        
        // Rating functionality
        function openRatingModal(orderId, restaurantName, restaurantId) {
            document.getElementById('ratingOrderId').value = orderId;
            document.getElementById('ratingRestaurantId').value = restaurantId;
            document.getElementById('restaurantName').textContent = 'Rating order from: ' + restaurantName;
            
            // Reset rating
            document.getElementById('ratingValue').value = '0';
            document.querySelectorAll('.star').forEach(star => {
                star.classList.remove('active');
                const starIcon = star.querySelector('i');
                starIcon.style.color = '#ddd';
            });
            
            const modal = new bootstrap.Modal(document.getElementById('ratingModal'));
            modal.show();
        }
        
        // Initialize star rating functionality
        document.addEventListener('DOMContentLoaded', function() {
            const stars = document.querySelectorAll('.star');
            const ratingValue = document.getElementById('ratingValue');
            
            function updateStarDisplay(rating) {
                stars.forEach((star, index) => {
                    const starIcon = star.querySelector('i');
                    if (index < rating) {
                        star.classList.add('active');
                        starIcon.style.color = '#ffc107';
                    } else {
                        star.classList.remove('active');
                        starIcon.style.color = '#ddd';
                    }
                });
            }
            
            stars.forEach(star => {
                star.addEventListener('click', function() {
                    const rating = parseInt(this.getAttribute('data-rating'));
                    ratingValue.value = rating;
                    updateStarDisplay(rating);
                });
                
                star.addEventListener('mouseenter', function() {
                    const rating = parseInt(this.getAttribute('data-rating'));
                    stars.forEach((s, index) => {
                        const starIcon = s.querySelector('i');
                        if (index < rating) {
                            starIcon.style.color = '#ffc107';
                        } else {
                            starIcon.style.color = '#ddd';
                        }
                    });
                });
            });
            
            // Reset star colors on mouse leave to show current selection
            document.querySelector('.rating-stars').addEventListener('mouseleave', function() {
                const currentRating = parseInt(ratingValue.value);
                updateStarDisplay(currentRating);
            });
        });
        
        function submitRating() {
            const orderId = document.getElementById('ratingOrderId').value;
            const restaurantId = document.getElementById('ratingRestaurantId').value;
            const rating = document.getElementById('ratingValue').value;
            
            if (rating === '0') {
                alert('Please select a rating before submitting.');
                return;
            }
            
            const submitBtn = document.querySelector('#ratingModal .btn-primary');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Submitting...';
            submitBtn.disabled = true;
            
            const ratingData = {
                restaurantId: parseInt(restaurantId),
                rating: parseInt(rating),
                comment: '' // Empty comment since we're not using it
            };
            
            fetch('${pageContext.request.contextPath}/customer/rate-restaurant', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(ratingData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Thank you for your rating!');
                    const modal = bootstrap.Modal.getInstance(document.getElementById('ratingModal'));
                    modal.hide();
                    
                    // Update the rate button to show it's been rated
                    const rateBtn = document.querySelector(`button[onclick*="openRatingModal('${orderId}'"]`);
                    if (rateBtn) {
                        rateBtn.innerHTML = '<i class="fas fa-check me-1"></i>Rated';
                        rateBtn.classList.remove('btn-outline-success');
                        rateBtn.classList.add('btn-success');
                        rateBtn.disabled = true;
                    }
                } else {
                    alert('Failed to submit rating: ' + (data.message || 'Unknown error'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to submit rating. Please try again.');
            })
            .finally(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            });
        }
    </script>
</body>
</html>
