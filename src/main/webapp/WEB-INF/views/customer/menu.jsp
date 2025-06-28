<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${restaurant.name}" default="Restaurant"/> - Menu</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/global-styles.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/customer-menu.css" rel="stylesheet">
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/orders">
                            <i class="fas fa-receipt me-1"></i>My Orders
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav align-items-center">
                    <li class="nav-item me-3">
                        <button class="theme-toggle btn p-0" onclick="toggleTheme()" title="Toggle theme">
                            <i id="themeIcon" class="fas fa-moon"></i>
                        </button>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="navbarDropdown" 
                           role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-2"></i>
                            <c:out value="${user.fullName}" default="User"/>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
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

    <!-- Main Content -->
    <div class="container-fluid">
        <!-- Restaurant Header -->
        <div class="restaurant-header">
            <h1><c:out value="${restaurant.name}" default="Restaurant"/></h1>
            <div class="restaurant-info">
                <c:if test="${not empty restaurant.cuisineType}">
                    <span><i class="fas fa-utensils"></i><c:out value="${restaurant.cuisineType}"/></span>
                </c:if>
                <c:if test="${not empty restaurant.address}">
                    <span class="ms-3"><i class="fas fa-map-marker-alt"></i><c:out value="${restaurant.address}"/></span>
                </c:if>
                <c:if test="${not empty restaurant.phone}">
                    <span class="ms-3"><i class="fas fa-phone"></i><c:out value="${restaurant.phone}"/></span>
                </c:if>
            </div>
        </div>


        <div class="main-content">
            <!-- Menu Section -->
            <div class="menu-section">
                <!-- Category Filter Tabs -->
                <c:if test="${not empty categories}">
                    <div class="category-tabs">
                        <button class="category-tab active" onclick="filterByCategory('all')">All Items</button>
                        <c:forEach var="category" items="${categories}">
                            <button class="category-tab" onclick="filterByCategory('${category}')">
                                <c:out value="${category}"/>
                            </button>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- Menu Categories and Items -->
                <c:choose>
                    <c:when test="${not empty categories}">
                        <c:forEach var="category" items="${categories}">
                            <div class="menu-category" data-category="${category}">
                                <h2 class="category-title"><c:out value="${category}"/></h2>
                                <div class="menu-items">
                                    <c:if test="${not empty menuItems}">
                                        <c:forEach var="item" items="${menuItems}">
                                            <c:if test="${item.category == category}">
                                                <div class="menu-item">
                                                    <div class="menu-item-content">
                                                        <div class="menu-item-info">
                                                            <h5><c:out value="${item.name}"/></h5>
                                                            <c:if test="${not empty item.description}">
                                                                <p class="menu-item-description"><c:out value="${item.description}"/></p>
                                                            </c:if>
                                                            <div class="menu-item-price">$<c:out value="${item.price}"/></div>
                                                        </div>
                                                        <button class="add-to-cart-btn" 
                                                                data-item-id="${item.id}"
                                                                data-item-name="<c:out value='${item.name}'/>"
                                                                data-item-price="${item.price}"
                                                                onclick="addToCartFromButton(this)">
                                                            <i class="fas fa-plus me-2"></i>Add to Cart
                                                        </button>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>

                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-menu">
                            <i class="fas fa-utensils"></i>
                            <h3>No menu items available</h3>
                            <p>This restaurant hasn't added any menu items yet.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Cart Section -->
            <div class="cart-section">
                <div class="cart-container">
                    <div class="cart-header">
                        <h3 class="cart-title">Your Order</h3>
                        <div class="cart-count" id="cartCount">0</div>
                    </div>
                    
                    <div class="cart-items" id="cartItems">
                        <div class="empty-cart">
                            <i class="fas fa-shopping-cart"></i>
                            <p>Your cart is empty</p>
                            <p class="small text-muted">Add some delicious items!</p>
                        </div>
                    </div>
                    
                    <div class="cart-summary">
                        <div class="summary-row">
                            <span>Subtotal:</span>
                            <span class="fw-semibold">$<span id="subtotal">0.00</span></span>
                        </div>
                        <div class="summary-row">
                            <span>Delivery Fee:</span>
                            <span class="fw-semibold">$2.99</span>
                        </div>
                        <hr>
                        <div class="summary-row">
                            <strong>Total:</strong>
                            <strong class="text-primary">$<span id="cartTotal">2.99</span></strong>
                        </div>
                        
                        <button class="checkout-btn" id="checkoutBtn" onclick="proceedToCheckout()" disabled>
                            <i class="fas fa-info-circle me-2"></i>Add $10.00 more
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden form data -->
    <c:if test="${not empty restaurant}">
        <input type="hidden" id="restaurantId" value="<c:out value='${restaurant.id}'/>">
    </c:if>
    <c:if test="${not empty user}">
        <input type="hidden" id="userId" value="<c:out value='${user.id}'/>">
    </c:if>

    <!-- Toast Container -->
    <div id="toastContainer" class="toast-container"></div>

    <!-- Checkout Modal -->
    <div class="modal fade" id="checkoutModal" tabindex="-1" aria-labelledby="checkoutModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="checkoutModalLabel">
                        <i class="fas fa-shopping-cart me-2"></i>Complete Your Order
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="checkoutForm">
                        <div class="row">
                            <div class="col-md-6">
                                <h6 class="mb-3"><i class="fas fa-receipt me-2"></i>Order Summary</h6>
                                <div id="checkoutOrderItems" class="mb-3"></div>
                                <div class="checkout-totals">
                                    <div class="d-flex justify-content-between">
                                        <span>Subtotal:</span>
                                        <span>$<span id="checkoutSubtotal">0.00</span></span>
                                    </div>
                                    <div class="d-flex justify-content-between">
                                        <span>Delivery Fee:</span>
                                        <span>$2.99</span>
                                    </div>
                                    <hr>
                                    <div class="d-flex justify-content-between fw-bold">
                                        <span>Total:</span>
                                        <span class="text-primary">$<span id="checkoutTotal">2.99</span></span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h6 class="mb-3"><i class="fas fa-user me-2"></i>Delivery Information</h6>
                                <div class="mb-3">
                                    <label for="deliveryPhone" class="form-label">
                                        <i class="fas fa-phone me-2"></i>Phone Number
                                    </label>
                                    <input type="tel" class="form-control" id="deliveryPhone" name="phone" 
                                           placeholder="Enter your phone number" required>
                                </div>
                                <div class="mb-3">
                                    <label for="deliveryAddress" class="form-label">
                                        <i class="fas fa-map-marker-alt me-2"></i>Delivery Address
                                    </label>
                                    <textarea class="form-control" id="deliveryAddress" name="address" rows="3" 
                                              placeholder="Enter your delivery address" required></textarea>
                                </div>
                                <div class="mb-3">
                                    <label for="orderNotes" class="form-label">
                                        <i class="fas fa-sticky-note me-2"></i>Special Instructions (Optional)
                                    </label>
                                    <textarea class="form-control" id="orderNotes" name="notes" rows="2" 
                                              placeholder="Any special instructions for your order"></textarea>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Cancel
                    </button>
                    <button type="button" class="btn btn-primary" onclick="submitOrder()">
                        <i class="fas fa-credit-card me-2"></i>Place Order
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
    <!-- Remove the external customer-menu.js to prevent conflicts -->
    <!-- <script src="${pageContext.request.contextPath}/resources/js/customer-menu.js"></script> -->
    
    <script>

        // Initialize essential functions immediately (before external scripts load)
        // Use window.globalCart to ensure it persists across script loads
        if (!window.globalCart) {
            window.globalCart = [];
        }
        let fallbackCart = window.globalCart;
        
        // Add debug function to check cart state
        window.debugCart = function() {
            console.log('=== CART DEBUG ===');
            console.log('fallbackCart:', fallbackCart);
            console.log('window.globalCart:', window.globalCart);
            console.log('cart length:', fallbackCart ? fallbackCart.length : 'undefined');
            console.log('Cart elements found:');
            console.log('- cartCount:', document.getElementById('cartCount'));
            console.log('- cartItems:', document.getElementById('cartItems'));
            console.log('- subtotal:', document.getElementById('subtotal'));
            console.log('- cartTotal:', document.getElementById('cartTotal'));
            console.log('- checkoutBtn:', document.getElementById('checkoutBtn'));
            console.log('==================');
            return fallbackCart;
        };
        
        // Make debug function available in console
        window.cart = fallbackCart;
        
        // Ensure addToCartFromButton is immediately available
        window.addToCartFromButton = function(button) {
            try {
                const itemId = button.dataset.itemId;
                const itemName = button.dataset.itemName;
                const itemPrice = parseFloat(button.dataset.itemPrice);
                
                console.log('Adding to cart:', { itemId, itemName, itemPrice });
                
                if (!itemId || !itemName || isNaN(itemPrice)) {
                    console.error('Invalid item data:', { itemId, itemName, itemPrice });
                    alert('Invalid item data');
                    return;
                }
                
                // Ensure we're using the global cart
                if (!window.globalCart) {
                    window.globalCart = [];
                }
                fallbackCart = window.globalCart;
                
                const existingItem = fallbackCart.find(item => item.id === itemId);
                if (existingItem) {
                    existingItem.quantity += 1;
                    console.log('Updated existing item quantity:', existingItem);
                } else {
                    const newItem = { id: itemId, name: itemName, price: itemPrice, quantity: 1 };
                    fallbackCart.push(newItem);
                    console.log('Added new item to cart:', newItem);
                }
                
                console.log('Current cart state:', fallbackCart);
                console.log('Global cart state:', window.globalCart);
                updateFallbackCartDisplay();
                
                // Show success feedback
                button.innerHTML = '<i class="fas fa-check me-2"></i>Added!';
                button.classList.add('btn-success');
                setTimeout(() => {
                    button.innerHTML = '<i class="fas fa-plus me-2"></i>Add to Cart';
                    button.classList.remove('btn-success');
                }, 1500);
                
            } catch (error) {
                console.error('Add to cart error:', error);
                alert('Error adding item to cart: ' + error.message);
            }
        };
        
        function updateFallbackCartDisplay() {
            try {
                // Always use the global cart
                fallbackCart = window.globalCart || [];
                
                console.log('Updating cart display, current cart:', fallbackCart);
                
                const cartCount = document.getElementById('cartCount');
                const cartItems = document.getElementById('cartItems');
                const subtotalElement = document.getElementById('subtotal');
                const cartTotalElement = document.getElementById('cartTotal');
                const checkoutBtn = document.getElementById('checkoutBtn');
                
                if (!cartCount || !cartItems || !subtotalElement || !cartTotalElement || !checkoutBtn) {
                    console.error('Cart display elements not found');
                    return;
                }
                
                if (!fallbackCart || fallbackCart.length === 0) {
                    console.log('Cart is empty, showing empty state');
                    cartCount.textContent = '0';
                    cartItems.innerHTML = '<div class="empty-cart"><i class="fas fa-shopping-cart"></i><p>Your cart is empty</p><p class="small text-muted">Add some delicious items!</p></div>';
                    subtotalElement.textContent = '0.00';
                    cartTotalElement.textContent = '2.99';
                    checkoutBtn.disabled = true;
                    checkoutBtn.innerHTML = '<i class="fas fa-info-circle me-2"></i>Add $10.00 more';
                    return;
                }
                
                const itemCount = fallbackCart.reduce((total, item) => total + item.quantity, 0);
                const subtotal = fallbackCart.reduce((total, item) => total + (item.price * item.quantity), 0);
                const total = subtotal + 2.99;
                
                console.log('Cart calculations:', { itemCount, subtotal, total });
                
                cartCount.textContent = itemCount;
                subtotalElement.textContent = subtotal.toFixed(2);
                cartTotalElement.textContent = total.toFixed(2);
                
                cartItems.innerHTML = fallbackCart.map(item => 
                    '<div class="cart-item">' +
                        '<div class="cart-item-info">' +
                            '<h6>' + item.name + '</h6>' +
                            '<span>Qty: ' + item.quantity + '</span>' +
                        '</div>' +
                        '<div class="cart-item-price">$' + (item.price * item.quantity).toFixed(2) + '</div>' +
                    '</div>'
                ).join('');
                
                if (subtotal >= 10) {
                    checkoutBtn.disabled = false;
                    checkoutBtn.innerHTML = '<i class="fas fa-credit-card me-2"></i>Checkout';
                    console.log('Checkout button enabled');
                } else {
                    checkoutBtn.disabled = true;
                    checkoutBtn.innerHTML = '<i class="fas fa-info-circle me-2"></i>Add $' + (10 - subtotal).toFixed(2) + ' more';
                    console.log('Checkout button disabled, need $' + (10 - subtotal).toFixed(2) + ' more');
                }
            } catch (error) {
                console.error('Cart display error:', error);
            }
        }
        
        // Other essential functions
        window.proceedToCheckout = function() {
            // Always use the global cart
            fallbackCart = window.globalCart || [];

            
            console.log('proceedToCheckout called, fallbackCart:', fallbackCart);
            console.log('fallbackCart length:', fallbackCart.length);
            console.log('window.globalCart:', window.globalCart);
            
            if (!fallbackCart || fallbackCart.length === 0) {
                alert('Your cart is empty. Please add some items first.');
                return;
            }
            
            try {
                const modal = new bootstrap.Modal(document.getElementById('checkoutModal'));
                const orderItems = document.getElementById('checkoutOrderItems');
                
                if (!orderItems) {
                    console.error('checkoutOrderItems element not found');
                    alert('Error: Checkout form not ready');
                    return;
                }
                
                orderItems.innerHTML = fallbackCart.map(item => 
                    '<div class="d-flex justify-content-between mb-2"><span>' + item.name + ' (x' + item.quantity + ')</span><span>$' + (item.price * item.quantity).toFixed(2) + '</span></div>'
                ).join('');
                
                const subtotal = fallbackCart.reduce((total, item) => total + (item.price * item.quantity), 0);
                const checkoutSubtotal = document.getElementById('checkoutSubtotal');
                const checkoutTotal = document.getElementById('checkoutTotal');
                
                if (checkoutSubtotal) checkoutSubtotal.textContent = subtotal.toFixed(2);
                if (checkoutTotal) checkoutTotal.textContent = (subtotal + 2.99).toFixed(2);
                
                modal.show();
                console.log('Checkout modal opened successfully');
            } catch (error) {
                console.error('Checkout error:', error);
                alert('Error opening checkout: ' + error.message);
            }
        };
        
        window.submitOrder = function() {
            try {
                // Always use the global cart
                fallbackCart = window.globalCart || [];
                
                const phone = document.getElementById('deliveryPhone').value.trim();
                const address = document.getElementById('deliveryAddress').value.trim();
                
                if (!phone || !address) {
                    alert('Please fill in phone and address');
                    return;
                }
                
                const restaurantId = document.getElementById('restaurantId').value;
                if (!restaurantId) {
                    alert('Restaurant ID not found');
                    return;
                }
                
                if (fallbackCart.length === 0) {
                    alert('Your cart is empty');
                    return;
                }
                
                const orderData = {
                    restaurantId: restaurantId,
                    phone: phone,
                    deliveryAddress: address,
                    notes: document.getElementById('orderNotes').value.trim(),
                    items: fallbackCart.map(item => ({
                        menuItemId: item.id,
                        quantity: item.quantity,
                        unitPrice: item.price
                    }))
                };
                
                console.log('Submitting order data:', orderData);
                
                // Disable the submit button
                const submitBtn = document.querySelector('#checkoutModal .btn-primary');
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Placing Order...';
                
                fetch(window.location.origin + '/FoodDelivery2/customer/orders', {
                    method: 'POST',
                    headers: { 
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify(orderData)
                })
                .then(response => {
                    console.log('Response status:', response.status);
                    console.log('Response headers:', response.headers);
                    
                    if (!response.ok) {
                        return response.text().then(text => {
                            console.error('Server error response:', text);
                            throw new Error(`Server error: ${response.status} - ${text}`);
                        });
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Order response:', data);
                    if (data.success) {
                        alert('Order placed successfully!');
                        // Clear both carts
                        fallbackCart.length = 0;
                        window.globalCart.length = 0;
                        updateFallbackCartDisplay();
                        const modal = bootstrap.Modal.getInstance(document.getElementById('checkoutModal'));
                        if (modal) modal.hide();
                        setTimeout(() => location.href = window.location.origin + '/FoodDelivery2/customer/orders', 1000);
                    } else {
                        alert('Error placing order: ' + (data.message || 'Unknown error'));
                    }
                })
                .catch(error => {
                    console.error('Order submission error:', error);
                    alert('Failed to place order: ' + error.message);
                })
                .finally(() => {
                    // Re-enable the submit button
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = '<i class="fas fa-credit-card me-2"></i>Place Order';
                });
            } catch (error) {
                console.error('Order submit error:', error);
                alert('Error submitting order: ' + error.message);
            }
        };
        
        window.toggleTheme = function() {
            const current = document.documentElement.getAttribute('data-theme');
            const newTheme = current === 'dark' ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            const icon = document.getElementById('themeIcon');
            if (icon) icon.className = newTheme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
        };
        
        window.filterByCategory = function(category) {
            try {
                // Update active tab
                document.querySelectorAll('.category-tab').forEach(tab => {
                    tab.classList.remove('active');
                });
                event.target.classList.add('active');

                // Show/hide menu categories
                document.querySelectorAll('.menu-category').forEach(categoryDiv => {
                    if (category === 'all' || categoryDiv.dataset.category === category) {
                        categoryDiv.style.display = 'block';
                    } else {
                        categoryDiv.style.display = 'none';
                    }
                });
            } catch (error) {
                console.error('Filter category error:', error);
            }
        };
        
        // Initialize theme
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded, initializing...');
            
            // Initialize theme
            const savedTheme = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', savedTheme);
            const themeIcon = document.getElementById('themeIcon');
            if (themeIcon) {
                themeIcon.className = savedTheme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
            }

            
            // Initialize global cart if not exists
            if (!window.globalCart) {
                window.globalCart = [];
            }
            fallbackCart = window.globalCart;
            
            // Initialize cart display
            updateFallbackCartDisplay();
            
            // Make cart globally accessible for debugging
            window.cart = window.globalCart;
            window.updateCart = updateFallbackCartDisplay;
            
            console.log('Initialization complete, global cart:', window.globalCart);
            console.log('Local fallbackCart reference:', fallbackCart);
        });
    </script>
</body>
</html>
