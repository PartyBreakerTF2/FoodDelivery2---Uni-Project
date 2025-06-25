<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">    <title>My Orders - Food Delivery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/customer/dashboard">
                <i class="fas fa-utensils me-2"></i>Food Delivery System
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/restaurants">
                            <i class="fas fa-store me-1"></i>Restaurants
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/customer/orders">
                            <i class="fas fa-shopping-bag me-1"></i>My Orders
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
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h2>My Orders</h2>
            </div>
        </div>
          <div class="row mt-4">
            <div class="col-12">
                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="card">
                            <div class="card-body">
                                <p class="text-center text-muted">No orders found. <a href="${pageContext.request.contextPath}/customer/restaurants">Start ordering now!</a></p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="order" items="${orders}">
                            <div class="card mb-3">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <div>
                                        <h5 class="mb-0">Order #${order.id}</h5>
                                        <small class="text-muted">
                                            <c:choose>
                                                <c:when test="${order.restaurant != null}">
                                                    ${order.restaurant.name}
                                                </c:when>
                                                <c:otherwise>
                                                    Restaurant
                                                </c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>
                                    <div>
                                        <span class="badge bg-
                                            <c:choose>
                                                <c:when test="${order.status == 'PENDING'}">warning</c:when>
                                                <c:when test="${order.status == 'CONFIRMED'}">info</c:when>
                                                <c:when test="${order.status == 'PREPARING'}">primary</c:when>
                                                <c:when test="${order.status == 'OUT_FOR_DELIVERY'}">secondary</c:when>
                                                <c:when test="${order.status == 'DELIVERED'}">success</c:when>
                                                <c:when test="${order.status == 'CANCELLED'}">danger</c:when>
                                                <c:otherwise>dark</c:otherwise>
                                            </c:choose>
                                        ">${order.status}</span>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <h6>Order Details:</h6>
                                            <c:choose>
                                                <c:when test="${not empty order.orderItems}">
                                                    <c:forEach var="item" items="${order.orderItems}">
                                                        <div class="d-flex justify-content-between mb-2">
                                                            <span>${item.quantity}x ${item.menuItemName}</span>
                                                            <span>$${item.subtotal}</span>
                                                        </div>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="text-muted">Order items not available</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="text-end">
                                                <h6>Total: $${order.totalAmount}</h6>
                                                <small class="text-muted">
                                                    Ordered: ${order.orderDate}
                                                </small>
                                                <c:if test="${order.deliveryAddress != null}">
                                                    <br>
                                                    <small class="text-muted">
                                                        Address: ${order.deliveryAddress}
                                                    </small>
                                                </c:if>
                                                <c:if test="${order.status == 'DELIVERED'}">
                                                    <br>
                                                    <!-- Rating button - show for all delivered orders -->
                                                    <c:set var="hasRated" value="false" />
                                                    <c:forEach var="ratedRestaurantId" items="${ratedRestaurantIds}">
                                                        <c:if test="${ratedRestaurantId == order.restaurantId}">
                                                            <c:set var="hasRated" value="true" />
                                                        </c:if>
                                                    </c:forEach>
                                                    
                                                    <c:choose>
                                                        <c:when test="${hasRated}">
                                                            <small class="text-success d-block mt-1">
                                                                <i class="fas fa-check-circle me-1"></i>You've rated this restaurant
                                                            </small>
                                                            <button type="button" class="btn btn-outline-secondary btn-sm mt-1" 
                                                                    data-bs-toggle="modal" data-bs-target="#ratingModal"
                                                                    data-order-id="${order.id}"
                                                                    data-restaurant-id="${order.restaurantId}"
                                                                    data-restaurant-name="${order.restaurant != null ? order.restaurant.name : 'Restaurant'}">
                                                                <i class="fas fa-edit me-1"></i>Update Rating
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="button" class="btn btn-outline-warning btn-sm mt-2" 
                                                                    data-bs-toggle="modal" data-bs-target="#ratingModal"
                                                                    data-order-id="${order.id}"
                                                                    data-restaurant-id="${order.restaurantId}"
                                                                    data-restaurant-name="${order.restaurant != null ? order.restaurant.name : 'Restaurant'}">
                                                                <i class="fas fa-star me-1"></i>Rate Restaurant
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
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
    
    <!-- Rating Modal -->
    <div class="modal fade" id="ratingModal" tabindex="-1" aria-labelledby="ratingModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="ratingModalLabel">
                        <i class="fas fa-star text-warning me-2"></i>Rate <span id="restaurantName">Restaurant</span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-4">
                        <p class="mb-3">How was your experience with this restaurant?</p>
                        <div class="rating-stars mb-3">
                            <i class="fas fa-star star-rating" data-rating="1"></i>
                            <i class="fas fa-star star-rating" data-rating="2"></i>
                            <i class="fas fa-star star-rating" data-rating="3"></i>
                            <i class="fas fa-star star-rating" data-rating="4"></i>
                            <i class="fas fa-star star-rating" data-rating="5"></i>
                        </div>
                        <div id="ratingText" class="text-muted">Click a star to rate</div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="reviewComment" class="form-label">Add a comment (optional)</label>
                        <textarea class="form-control" id="reviewComment" rows="3" 
                                  placeholder="Share your experience with other customers..."></textarea>
                    </div>
                    
                    <div class="alert alert-info small">
                        <i class="fas fa-info-circle me-1"></i>
                        Your rating will help other customers make informed decisions.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-warning" id="submitRatingBtn" disabled>
                        <i class="fas fa-star me-1"></i>Submit Rating
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Rating system functionality
        let selectedRating = 0;
        let currentRestaurantId = null;
        let currentOrderId = null;
        
        document.addEventListener('DOMContentLoaded', function() {
            // Rating system event listeners
            const starRatings = document.querySelectorAll('.star-rating');
            const submitRatingBtn = document.getElementById('submitRatingBtn');
            const ratingText = document.getElementById('ratingText');
            const ratingModal = document.getElementById('ratingModal');
            
            // Handle modal show event to populate data
            ratingModal.addEventListener('show.bs.modal', function (event) {
                const button = event.relatedTarget;
                currentOrderId = parseInt(button.getAttribute('data-order-id'));
                currentRestaurantId = parseInt(button.getAttribute('data-restaurant-id'));
                const restaurantName = button.getAttribute('data-restaurant-name');
                
                // Check if this is an update or new rating based on button text
                const isUpdate = button.textContent.includes('Update');
                const modalTitle = document.getElementById('ratingModalLabel');
                const submitButton = document.getElementById('submitRatingBtn');
                
                if (isUpdate) {
                    modalTitle.innerHTML = '<i class="fas fa-edit text-warning me-2"></i>Update Rating for ' + restaurantName;
                    submitButton.innerHTML = '<i class="fas fa-save me-1"></i>Update Rating';
                    
                    // Fetch existing rating data
                    fetch('${pageContext.request.contextPath}/customer/get-rating/' + currentRestaurantId)
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                // Populate the form with existing data
                                selectedRating = parseInt(data.rating);
                                updateStarDisplay(selectedRating);
                                updateRatingText(selectedRating);
                                document.getElementById('reviewComment').value = data.comment || '';
                                document.getElementById('submitRatingBtn').disabled = false;
                            }
                        })
                        .catch(error => {
                            console.error('Error fetching existing rating:', error);
                            resetRatingForm();
                        });
                } else {
                    modalTitle.innerHTML = '<i class="fas fa-star text-warning me-2"></i>Rate ' + restaurantName;
                    submitButton.innerHTML = '<i class="fas fa-star me-1"></i>Submit Rating';
                    resetRatingForm();
                }
                
                document.getElementById('restaurantName').textContent = restaurantName;
            });
            
            starRatings.forEach(star => {
                star.addEventListener('click', function() {
                    selectedRating = parseInt(this.getAttribute('data-rating'));
                    updateStarDisplay(selectedRating);
                    updateRatingText(selectedRating);
                    submitRatingBtn.disabled = false;
                });
                
                star.addEventListener('mouseenter', function() {
                    const hoverRating = parseInt(this.getAttribute('data-rating'));
                    updateStarDisplay(hoverRating);
                });
            });
            
            // Reset stars on mouse leave
            document.querySelector('.rating-stars').addEventListener('mouseleave', function() {
                updateStarDisplay(selectedRating);
            });
            
            // Submit rating
            submitRatingBtn.addEventListener('click', submitRating);
            
            // Initialize star display
            updateStarDisplay(0);
        });
        
        function updateStarDisplay(rating) {
            const stars = document.querySelectorAll('.star-rating');
            stars.forEach((star, index) => {
                if (index < rating) {
                    star.classList.add('text-warning');
                    star.classList.remove('text-muted');
                } else {
                    star.classList.add('text-muted');
                    star.classList.remove('text-warning');
                }
            });
        }
        
        function updateRatingText(rating) {
            const ratingTexts = [
                '',
                'Poor - Very disappointing',
                'Fair - Below expectations',
                'Good - Satisfactory experience',
                'Very Good - Exceeded expectations',
                'Excellent - Outstanding!'
            ];
            document.getElementById('ratingText').textContent = ratingTexts[rating];
        }
        
        function submitRating() {
            if (selectedRating === 0) {
                showToast('Please select a rating', 'warning');
                return;
            }
            
            if (!currentRestaurantId || !currentOrderId) {
                showToast('Error: Restaurant or Order ID not found', 'danger');
                return;
            }
            
            const comment = document.getElementById('reviewComment').value.trim();
            
            const ratingData = {
                restaurantId: currentRestaurantId,
                orderId: currentOrderId,
                rating: selectedRating,
                comment: comment
            };
            
            // Show loading state
            const submitBtn = document.getElementById('submitRatingBtn');
            const originalBtnText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Submitting...';
            submitBtn.disabled = true;
            
            // Send rating to server
            fetch('${pageContext.request.contextPath}/customer/rate-restaurant', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(ratingData)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showToast('Thank you for your rating!', 'success');
                    
                    // Close modal and reset form
                    const modal = bootstrap.Modal.getInstance(document.getElementById('ratingModal'));
                    modal.hide();
                    
                    // Update the UI to show that the restaurant has been rated
                    const ratingButton = document.querySelector(`[data-order-id="${currentOrderId}"]`);
                    if (ratingButton) {
                        // Check if this was a new rating or an update
                        if (ratingButton.textContent.includes('Rate Restaurant')) {
                            // This was a new rating - update the button and add the indicator
                            ratingButton.innerHTML = '<i class="fas fa-edit me-1"></i>Update Rating';
                            ratingButton.className = 'btn btn-outline-secondary btn-sm mt-1';
                            
                            // Add the "You've rated this restaurant" indicator if it doesn't exist
                            let indicator = ratingButton.parentNode.querySelector('.text-success');
                            if (!indicator) {
                                indicator = document.createElement('small');
                                indicator.className = 'text-success d-block mt-1';
                                indicator.innerHTML = '<i class="fas fa-check-circle me-1"></i>You\'ve rated this restaurant';
                                ratingButton.parentNode.insertBefore(indicator, ratingButton);
                            }
                        } else {
                            // This was an update - just show a confirmation
                            showToast('Rating updated successfully!', 'success');
                        }
                    }
                    
                } else {
                    showToast('Failed to submit rating: ' + (data.message || 'Unknown error'), 'danger');
                }
            })
            .catch(error => {
                console.error('Error submitting rating:', error);
                showToast('Error submitting rating: ' + error.message, 'danger');
            })
            .finally(() => {
                // Restore button state
                submitBtn.innerHTML = originalBtnText;
                submitBtn.disabled = selectedRating === 0;
            });
        }
        
        function resetRatingForm() {
            selectedRating = 0;
            updateStarDisplay(0);
            document.getElementById('ratingText').textContent = 'Click a star to rate';
            document.getElementById('reviewComment').value = '';
            document.getElementById('submitRatingBtn').disabled = true;
        }
        
        function showToast(message, type) {
            // Simple toast notification
            const toastContainer = document.createElement('div');
            toastContainer.style.position = 'fixed';
            toastContainer.style.top = '20px';
            toastContainer.style.right = '20px';
            toastContainer.style.zIndex = '9999';
            
            const toast = document.createElement('div');
            toast.className = `alert alert-${type} alert-dismissible fade show`;
            toast.innerHTML = `
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            
            toastContainer.appendChild(toast);
            document.body.appendChild(toastContainer);
            
            // Auto remove after 5 seconds
            setTimeout(() => {
                if (toastContainer.parentNode) {
                    toastContainer.parentNode.removeChild(toastContainer);
                }
            }, 5000);
        }
    </script>
    
    <style>
        .star-rating {
            font-size: 2rem;
            cursor: pointer;
            margin: 0 0.2rem;
            transition: color 0.2s ease;
        }
        
        .star-rating:hover {
            transform: scale(1.1);
        }
        
        .rating-stars {
            user-select: none;
        }
        
        .text-warning {
            color: #ffc107 !important;
        }
        
        .text-muted {
            color: #6c757d !important;
        }
    </style>
</body>
</html>
