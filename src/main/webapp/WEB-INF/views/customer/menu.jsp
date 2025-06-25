<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">    <title>${restaurant.name} - Menu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .category-btn {
            transition: all 0.3s ease;
        }
        .category-btn.active {
            background-color: #0d6efd;
            color: white;
            border-color: #0d6efd;
        }
        .category-btn:hover {
            background-color: #0d6efd;
            color: white;
            border-color: #0d6efd;
        }
        .menu-item {
            transition: opacity 0.3s ease;
        }
        .menu-item[style*="none"] {
            opacity: 0;
        }
        .cart-item {
            transition: all 0.3s ease;
        }
        #no-items-message {
            transition: opacity 0.3s ease;
        }
    </style>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/orders">
                            <i class="fas fa-shopping-bag me-1"></i>My Orders
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
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
        <!-- Restaurant Info -->
        <div class="row">
            <div class="col-12">
                <div class="card mb-4">
                    <div class="card-body">
                        <h2>${restaurant.name}</h2>
                        <p class="lead">${restaurant.description}</p>                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Cuisine:</strong> ${restaurant.cuisineType}</p>
                                <p><strong>Address:</strong> ${restaurant.address}</p>
                                <p><strong>Phone:</strong> ${restaurant.phone}</p>
                                <p><strong>Opening Hours:</strong> ${restaurant.openingHours}</p>
                            </div>                            <div class="col-md-6">
                                <p><strong>Delivery Fee:</strong> $2.99</p>
                                <p><strong>Minimum Order:</strong> $15.00</p>
                                <p><strong>Rating:</strong> <span data-rating-display>${restaurant.rating}/5.0</span></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Menu Items -->
        <div class="row">
            <div class="col-md-9">
                <h3>Menu</h3>
                  <!-- Category Filter -->
                <div class="mb-3">
                    <button class="btn btn-outline-secondary btn-sm me-2 category-btn active">All</button>
                    <c:forEach var="category" items="${categories}">
                        <button class="btn btn-outline-secondary btn-sm me-2 category-btn">${category}</button>
                    </c:forEach>
                </div>
                
                <!-- Menu Items -->
                <div class="row" id="menuItems">
                    <c:forEach var="item" items="${menuItems}">
                        <div class="col-md-6 mb-4 menu-item" data-category="${item.category}">
                            <div class="card">
                                <div class="card-body">
                                    <h6 class="card-title">${item.name}</h6>
                                    <p class="card-text">${item.description}</p>
                                    <p class="card-text">
                                        <strong class="text-primary">$${item.price}</strong>
                                        <span class="badge bg-secondary ms-2">${item.category}</span>
                                    </p>
                                    <c:if test="${item.available}">
                                        <div class="d-flex align-items-center">
                                            <input type="number" class="form-control form-control-sm me-2" 
                                                   style="width: 80px;" value="1" min="1" id="qty-${item.id}">                                            <button class="btn btn-primary btn-sm add-to-cart-btn" 
                                                    data-item-id="${item.id}" 
                                                    data-item-name="${item.name}" 
                                                    data-item-price="${item.price}">
                                                Add to Cart
                                            </button>
                                        </div>
                                    </c:if>
                                    <c:if test="${!item.available}">
                                        <span class="badge bg-danger">Not Available</span>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <c:if test="${empty menuItems}">
                    <div class="alert alert-info">
                        <h5>No menu items available</h5>
                        <p>This restaurant hasn't added any menu items yet. Please check back later!</p>
                    </div>
                </c:if>
            </div>
            
            <!-- Cart Sidebar -->
            <div class="col-md-3">
                <div class="card sticky-top">
                    <div class="card-header">
                        <h6>Your Cart</h6>
                    </div>
                    <div class="card-body">
                        <div id="cartItems">
                            <p class="text-muted">Your cart is empty</p>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Subtotal:</span>
                            <span>$<span id="subtotal">0.00</span></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Delivery Fee:</span>
                            <span>$<span id="deliveryFee">2.99</span></span>
                        </div>
                        <div class="d-flex justify-content-between">
                            <strong>Total: $<span id="cartTotal">2.99</span></strong>
                        </div>                        <button class="btn btn-success w-100 mt-3" id="checkoutBtn" disabled>
                            Checkout ($15 min)
                        </button>
                        <button class="btn btn-outline-danger w-100 mt-2" id="clearCartBtn" style="display: none;">
                            Clear Cart
                        </button>
                    </div>
                </div>
            </div>        </div>
    </div>    <!-- Hidden fields to store user data for JavaScript -->
    <div style="display: none;" id="userData">
        <input type="hidden" id="userAddress" value="${sessionScope.user.address}">
        <input type="hidden" id="userPhone" value="${sessionScope.user.phone}">
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let cart = [];
        const DELIVERY_FEE = 2.99;
        const MIN_ORDER_AMOUNT = 15.00;
          // Add event listeners for Add to Cart buttons
        document.addEventListener('DOMContentLoaded', function() {
            const addToCartButtons = document.querySelectorAll('.add-to-cart-btn');
            addToCartButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const itemId = this.getAttribute('data-item-id');
                    const itemName = this.getAttribute('data-item-name');
                    const itemPrice = parseFloat(this.getAttribute('data-item-price'));
                    addToCart(itemId, itemName, itemPrice);
                });
            });
            
            // Add category filter button event listeners
            const categoryButtons = document.querySelectorAll('.category-btn');
            categoryButtons.forEach(button => {
                button.addEventListener('click', function() {
                    filterMenuItems(this.textContent.trim());
                    
                    // Update active button
                    categoryButtons.forEach(btn => btn.classList.remove('active'));
                    this.classList.add('active');
                });
            });
            
            // Add checkout button event listener
            const checkoutBtn = document.getElementById('checkoutBtn');
            if (checkoutBtn) {
                checkoutBtn.addEventListener('click', proceedToCheckout);
            }
            
            // Add clear cart button event listener
            const clearCartBtn = document.getElementById('clearCartBtn');
            if (clearCartBtn) {
                clearCartBtn.addEventListener('click', clearCart);
            }
        });
          function addToCart(itemId, itemName, itemPrice) {
            const quantity = parseInt(document.getElementById('qty-' + itemId).value);
            
            // Check if item already exists in cart
            const existingItemIndex = cart.findIndex(item => item.id === itemId);
            
            if (existingItemIndex > -1) {
                // Update quantity if item exists
                cart[existingItemIndex].quantity += quantity;
            } else {
                // Add new item to cart
                cart.push({
                    id: itemId,
                    name: itemName,
                    price: itemPrice,
                    quantity: quantity
                });
            }
            
            // Reset quantity input
            document.getElementById('qty-' + itemId).value = 1;
            
            updateCartDisplay();
            
            // Show success message
            showToast('Added ' + quantity + ' × ' + itemName + ' to cart!', 'success');
        }
        
        function filterMenuItems(category) {
            const menuItems = document.querySelectorAll('.menu-item');
            
            menuItems.forEach(item => {
                const itemCategory = item.getAttribute('data-category');
                
                if (category === 'All' || itemCategory === category) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
            
            // Show/hide no items message if needed
            const visibleItems = document.querySelectorAll('.menu-item[style*="block"], .menu-item:not([style*="none"])');
            const noItemsAlert = document.querySelector('.alert-info');
            
            if (visibleItems.length === 0 && category !== 'All') {
                // Create or show "no items in category" message
                let noItemsDiv = document.getElementById('no-items-message');
                if (!noItemsDiv) {
                    noItemsDiv = document.createElement('div');
                    noItemsDiv.id = 'no-items-message';
                    noItemsDiv.className = 'alert alert-warning';
                    noItemsDiv.innerHTML = '<h6>No items found</h6><p>No menu items available in the selected category.</p>';
                    document.getElementById('menuItems').appendChild(noItemsDiv);
                }
                noItemsDiv.style.display = 'block';
            } else {
                // Hide the no items message
                const noItemsDiv = document.getElementById('no-items-message');
                if (noItemsDiv) {
                    noItemsDiv.style.display = 'none';
                }
            }
        }
        
        function removeFromCart(itemId) {
            cart = cart.filter(item => item.id !== itemId);
            updateCartDisplay();
            showToast('Item removed from cart', 'info');
        }
        
        function updateItemQuantity(itemId, newQuantity) {
            const item = cart.find(item => item.id === itemId);
            if (item) {
                if (newQuantity <= 0) {
                    removeFromCart(itemId);
                } else {
                    item.quantity = parseInt(newQuantity);
                    updateCartDisplay();
                }
            }
        }
        
        function updateCartDisplay() {
            const cartItemsDiv = document.getElementById('cartItems');
            const subtotalSpan = document.getElementById('subtotal');
            const cartTotalSpan = document.getElementById('cartTotal');
            const checkoutBtn = document.getElementById('checkoutBtn');
            const clearCartBtn = document.getElementById('clearCartBtn');
            
            if (cart.length === 0) {
                cartItemsDiv.innerHTML = '<p class="text-muted">Your cart is empty</p>';
                subtotalSpan.textContent = '0.00';
                cartTotalSpan.textContent = DELIVERY_FEE.toFixed(2);
                checkoutBtn.disabled = true;
                checkoutBtn.textContent = 'Checkout ($15 min)';
                clearCartBtn.style.display = 'none';
                return;
            }
            
            // Calculate subtotal
            const subtotal = cart.reduce((total, item) => total + (item.price * item.quantity), 0);
            const total = subtotal + DELIVERY_FEE;
            
            // Update cart items display
            let cartHTML = '';
            cart.forEach(item => {
                cartHTML += '<div class="cart-item mb-2 p-2 border rounded">';
                cartHTML += '  <div class="d-flex justify-content-between align-items-start">';
                cartHTML += '    <div class="flex-grow-1">';
                cartHTML += '      <h6 class="mb-1" style="font-size: 0.9rem;">' + escapeHtml(item.name) + '</h6>';
                cartHTML += '      <small class="text-muted">$' + item.price.toFixed(2) + ' each</small>';
                cartHTML += '    </div>';
                cartHTML += '    <button class="btn btn-sm btn-outline-danger" onclick="removeFromCart(\'' + item.id + '\')" title="Remove">×</button>';
                cartHTML += '  </div>';
                cartHTML += '  <div class="d-flex justify-content-between align-items-center mt-2">';
                cartHTML += '    <div class="d-flex align-items-center">';
                cartHTML += '      <button class="btn btn-sm btn-outline-secondary" onclick="updateItemQuantity(\'' + item.id + '\', ' + (item.quantity - 1) + ')">-</button>';
                cartHTML += '      <span class="mx-2">' + item.quantity + '</span>';
                cartHTML += '      <button class="btn btn-sm btn-outline-secondary" onclick="updateItemQuantity(\'' + item.id + '\', ' + (item.quantity + 1) + ')">+</button>';
                cartHTML += '    </div>';
                cartHTML += '    <strong>$' + (item.price * item.quantity).toFixed(2) + '</strong>';
                cartHTML += '  </div>';
                cartHTML += '</div>';
            });
            
            cartItemsDiv.innerHTML = cartHTML;
            subtotalSpan.textContent = subtotal.toFixed(2);
            cartTotalSpan.textContent = total.toFixed(2);
            
            // Enable/disable checkout button based on minimum order amount
            if (subtotal >= MIN_ORDER_AMOUNT) {
                checkoutBtn.disabled = false;
                checkoutBtn.textContent = 'Proceed to Checkout';
            } else {
                checkoutBtn.disabled = true;
                const remaining = MIN_ORDER_AMOUNT - subtotal;
                checkoutBtn.textContent = '$' + remaining.toFixed(2) + ' more needed';
            }
            
            clearCartBtn.style.display = 'block';
        }
        
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
        
        function clearCart() {
            if (confirm('Are you sure you want to clear your cart?')) {
                cart = [];
                updateCartDisplay();
                showToast('Cart cleared', 'info');
            }
        }
        
        function proceedToCheckout() {
            if (cart.length === 0) {
                showToast('Your cart is empty', 'warning');
                return;
            }
            
            const subtotal = cart.reduce((total, item) => total + (item.price * item.quantity), 0);
            if (subtotal < MIN_ORDER_AMOUNT) {
                showToast('Minimum order amount is $' + MIN_ORDER_AMOUNT.toFixed(2), 'warning');
                return;
            }
              // Get user's saved address and phone as defaults from hidden fields
            const userAddress = document.getElementById('userAddress').value || '';
            const userPhone = document.getElementById('userPhone').value || '';
            
            const deliveryAddress = prompt('Enter your delivery address:', userAddress);
            if (!deliveryAddress || deliveryAddress.trim() === '') {
                showToast('Delivery address is required', 'warning');
                return;
            }
            
            const phone = prompt('Enter your phone number:', userPhone);
            if (!phone || phone.trim() === '') {
                showToast('Phone number is required', 'warning');
                return;
            }
            
            const specialInstructions = prompt('Any special instructions? (optional)') || '';
            
            // Calculate totals
            const totalAmount = subtotal + DELIVERY_FEE;
            
            // Get restaurant ID from URL
            const pathParts = window.location.pathname.split('/');
            const restaurantId = pathParts[pathParts.indexOf('restaurant') + 1];
            
            // Validate restaurant ID
            if (!restaurantId || isNaN(restaurantId)) {
                showToast('Error: Restaurant ID not found. Please refresh the page.', 'danger');
                return;
            }
            
            // Prepare order data
            const orderData = {
                restaurantId: restaurantId,
                items: cart,
                deliveryAddress: deliveryAddress.trim(),
                phone: phone.trim(),
                specialInstructions: specialInstructions.trim(),
                paymentMethod: 'cash',
                subtotal: subtotal,
                deliveryFee: DELIVERY_FEE,
                total: totalAmount
            };
            
            console.log('Sending order data:', orderData);
            
            // Show loading message
            showToast('Placing your order...', 'info');
            
            // Send order to server
            fetch('/FoodDelivery2/customer/place-order', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(orderData)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                }
                
                const contentType = response.headers.get('Content-Type');
                if (!contentType || !contentType.includes('application/json')) {
                    throw new Error('Server returned non-JSON response: ' + contentType);
                }
                
                return response.json();
            })
            .then(data => {
                console.log('Order response:', data);
                
                if (data.success) {
                    showToast('Order placed successfully! Order ' + data.orderNumber, 'success');
                    
                    // Clear cart after successful order
                    cart = [];
                    updateCartDisplay();
                    
                    // Redirect to orders page after a delay
                    setTimeout(function() {
                        window.location.href = '/FoodDelivery2/customer/orders';
                    }, 2000);
                    
                } else {
                    showToast('Failed to place order: ' + data.message, 'danger');
                }
            })
            .catch(error => {
                console.error('Error placing order:', error);
                showToast('Error placing order: ' + error.message, 'danger');
            });
        }
        
        function showToast(message, type) {
            type = type || 'info';
            
            // Create toast element
            const toast = document.createElement('div');
            toast.className = 'alert alert-' + type + ' position-fixed';
            toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px; max-width: 400px;';
            
            const closeBtn = document.createElement('button');
            closeBtn.type = 'button';
            closeBtn.className = 'btn-close ms-2';
            closeBtn.onclick = function() { toast.remove(); };
            
            const messageSpan = document.createElement('span');
            messageSpan.textContent = message;
            
            const flexDiv = document.createElement('div');
            flexDiv.className = 'd-flex justify-content-between align-items-center';
            flexDiv.appendChild(messageSpan);
            flexDiv.appendChild(closeBtn);
            
            toast.appendChild(flexDiv);
            document.body.appendChild(toast);
            
            // Auto remove after 4 seconds
            setTimeout(function() {
                if (toast.parentElement) {
                    toast.remove();
                }
            }, 4000);        }
    </script>



    <script>
        
        document.addEventListener('DOMContentLoaded', function() {
            // ...existing code...
        });
    </script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
