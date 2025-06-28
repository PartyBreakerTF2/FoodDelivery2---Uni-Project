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
        // Test if JavaScript is running
        console.log('JavaScript is loading...');
        
        // Session-based cart system using existing backend infrastructure
        let currentRestaurantId = parseInt('<c:out value="${restaurant.id}"/>');
        let currentRestaurantName = '<c:out value="${restaurant.name}"/>';
        
        console.log('Raw restaurant ID from JSP:', '<c:out value="${restaurant.id}"/>');
        console.log('Parsed restaurant ID:', currentRestaurantId);
        console.log('Restaurant name:', currentRestaurantName);
        
        // Constants
        const DELIVERY_FEE = 2.99;
        const MIN_ORDER_AMOUNT = 15.00;
        
        // Cart data - synced with session storage but managed per restaurant
        let restaurantCarts = {};
        let currentCart = [];
        
        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Initializing menu page for restaurant:', currentRestaurantId);
            
            if (!currentRestaurantId || isNaN(currentRestaurantId)) {
                console.error('Invalid restaurant ID:', currentRestaurantId);
                return;
            }
            
            loadCartsFromStorage();
            setupEventListeners();
            updateCartDisplay();
            
            console.log('Initialization complete');
        });
        
        function loadCartsFromStorage() {
            try {
                const saved = sessionStorage.getItem('restaurantCarts');
                if (saved) {
                    restaurantCarts = JSON.parse(saved);
                }
            } catch (e) {
                console.warn('Could not load from sessionStorage:', e);
                restaurantCarts = {};
            }
            
            // Get current restaurant cart
            if (!restaurantCarts[currentRestaurantId]) {
                restaurantCarts[currentRestaurantId] = {
                    restaurantId: currentRestaurantId,
                    restaurantName: currentRestaurantName,
                    items: []
                };
            }
            
            currentCart = restaurantCarts[currentRestaurantId].items;
            console.log('Loaded cart for restaurant', currentRestaurantId, ':', currentCart);
        }
        
        function saveCartsToStorage() {
            try {
                sessionStorage.setItem('restaurantCarts', JSON.stringify(restaurantCarts));
            } catch (e) {
                console.warn('Could not save to sessionStorage:', e);
            }
        }
        
        function setupEventListeners() {
            // Add to cart buttons
            const addToCartButtons = document.querySelectorAll('.add-to-cart-btn');
            console.log('Found', addToCartButtons.length, 'add to cart buttons');
            
            if (addToCartButtons.length === 0) {
                console.error('No add to cart buttons found! Check if menu items are loading correctly.');
                return;
            }
            
            addToCartButtons.forEach((button, index) => {
                console.log('Setting up button', index, 'with data:', {
                    itemId: button.getAttribute('data-item-id'),
                    itemName: button.getAttribute('data-item-name'),
                    itemPrice: button.getAttribute('data-item-price')
                });
                
                button.addEventListener('click', function(event) {
                    console.log('=== BUTTON CLICKED ===');
                    event.preventDefault();
                    
                    const itemId = this.getAttribute('data-item-id');
                    const itemName = this.getAttribute('data-item-name');
                    const itemPrice = parseFloat(this.getAttribute('data-item-price'));
                    const qtyElement = document.getElementById('qty-' + itemId);
                    
                    if (!qtyElement) {
                        console.error('Quantity element not found for item:', itemId);
                        showToast('Error: Could not find quantity input', 'danger');
                        return;
                    }
                    
                    const quantity = parseInt(qtyElement.value);
                    console.log('About to call addToCart with:', {itemId, itemName, itemPrice, quantity});
                    addToCart(itemId, itemName, itemPrice, quantity);
                });
            });
            
            // Category filter buttons
            const categoryButtons = document.querySelectorAll('.category-btn');
            categoryButtons.forEach(button => {
                button.addEventListener('click', function() {
                    filterMenuItems(this.textContent.trim());
                    
                    // Update active button
                    categoryButtons.forEach(btn => btn.classList.remove('active'));
                    this.classList.add('active');
                });
            });
            
            // Checkout and clear cart buttons
            const checkoutBtn = document.getElementById('checkoutBtn');
            if (checkoutBtn) {
                checkoutBtn.addEventListener('click', proceedToCheckout);
            }
            
            const clearCartBtn = document.getElementById('clearCartBtn');
            if (clearCartBtn) {
                clearCartBtn.addEventListener('click', clearCart);
            }
        }
        
        function addToCart(itemId, itemName, itemPrice, quantity) {
            console.log('Adding to cart:', {itemId, itemName, itemPrice, quantity});
            
            try {
                // Validate inputs
                if (!itemId || !itemName || !itemPrice || !quantity) {
                    console.error('Invalid input parameters');
                    showToast('Error: Invalid item data', 'danger');
                    return;
                }
                
                if (isNaN(itemPrice) || isNaN(quantity) || quantity <= 0) {
                    console.error('Invalid price or quantity');
                    showToast('Error: Invalid price or quantity', 'danger');
                    return;
                }
                
                // Find existing item
                const existingItemIndex = currentCart.findIndex(item => item.itemId === itemId);
                
                if (existingItemIndex > -1) {
                    // Update existing item
                    currentCart[existingItemIndex].quantity += quantity;
                } else {
                    // Add new item
                    currentCart.push({
                        itemId: itemId,
                        name: itemName,
                        price: itemPrice,
                        quantity: quantity
                    });
                }
                
                // Update storage
                restaurantCarts[currentRestaurantId].items = currentCart;
                saveCartsToStorage();
                
                // Reset quantity input
                const qtyElement = document.getElementById('qty-' + itemId);
                if (qtyElement) {
                    qtyElement.value = 1;
                }
                
                // Update display
                updateCartDisplay();
                
                // Show success message
                showToast('Added ' + quantity + ' × ' + itemName + ' to cart!', 'success');
                console.log('Item added successfully');
                
            } catch (error) {
                console.error('Error in addToCart function:', error);
                showToast('Error adding item to cart', 'danger');
            }
        }
        
        function removeFromCart(itemId) {
            currentCart = currentCart.filter(item => item.itemId !== itemId);
            restaurantCarts[currentRestaurantId].items = currentCart;
            saveCartsToStorage();
            updateCartDisplay();
            showToast('Item removed from cart', 'info');
        }
        
        function updateItemQuantity(itemId, newQuantity) {
            if (newQuantity <= 0) {
                removeFromCart(itemId);
                return;
            }
            
            const item = currentCart.find(item => item.itemId === itemId);
            if (item) {
                item.quantity = newQuantity;
                restaurantCarts[currentRestaurantId].items = currentCart;
                saveCartsToStorage();
                updateCartDisplay();
            }
        }
        
        function clearCart() {
            if (currentCart.length === 0) {
                showToast('Your cart is already empty', 'info');
                return;
            }
            
            if (confirm('Are you sure you want to clear your cart? This will remove all ' + currentCart.length + ' item(s).')) {
                currentCart = [];
                restaurantCarts[currentRestaurantId].items = currentCart;
                saveCartsToStorage();
                updateCartDisplay();
                showToast('Cart cleared successfully', 'success');
            }
        }
        
        function updateCartDisplay() {
            const cartItemsDiv = document.getElementById('cartItems');
            const subtotalSpan = document.getElementById('subtotal');
            const cartTotalSpan = document.getElementById('cartTotal');
            const checkoutBtn = document.getElementById('checkoutBtn');
            const clearCartBtn = document.getElementById('clearCartBtn');
            
            if (currentCart.length === 0) {
                cartItemsDiv.innerHTML = '<p class="text-muted">Your cart is empty</p>';
                subtotalSpan.textContent = '0.00';
                cartTotalSpan.textContent = DELIVERY_FEE.toFixed(2);
                checkoutBtn.disabled = true;
                checkoutBtn.textContent = 'Checkout ($15 min)';
                clearCartBtn.style.display = 'none';
                
                showOtherRestaurantCarts();
                return;
            }
            
            // Calculate subtotal
            const subtotal = currentCart.reduce((total, item) => total + (item.price * item.quantity), 0);
            const total = subtotal + DELIVERY_FEE;
            
            // Update cart items display
            let cartHTML = '';
            currentCart.forEach(item => {
                cartHTML += '<div class="cart-item mb-2 p-2 border rounded">';
                cartHTML += '  <div class="d-flex justify-content-between align-items-start">';
                cartHTML += '    <div class="flex-grow-1">';
                cartHTML += '      <h6 class="mb-1" style="font-size: 0.9rem;">' + escapeHtml(item.name) + '</h6>';
                cartHTML += '      <small class="text-muted">$' + item.price.toFixed(2) + ' each</small>';
                cartHTML += '    </div>';
                cartHTML += '    <button class="btn btn-sm btn-outline-danger" onclick="removeFromCart(\'' + item.itemId + '\')" title="Remove">×</button>';
                cartHTML += '  </div>';
                cartHTML += '  <div class="d-flex justify-content-between align-items-center mt-2">';
                cartHTML += '    <div class="d-flex align-items-center">';
                cartHTML += '      <button class="btn btn-sm btn-outline-secondary" onclick="updateItemQuantity(\'' + item.itemId + '\', ' + (item.quantity - 1) + ')">-</button>';
                cartHTML += '      <span class="mx-2">' + item.quantity + '</span>';
                cartHTML += '      <button class="btn btn-sm btn-outline-secondary" onclick="updateItemQuantity(\'' + item.itemId + '\', ' + (item.quantity + 1) + ')">+</button>';
                cartHTML += '    </div>';
                cartHTML += '    <strong>$' + (item.price * item.quantity).toFixed(2) + '</strong>';
                cartHTML += '  </div>';
                cartHTML += '</div>';
            });
            
            cartItemsDiv.innerHTML = cartHTML;
            subtotalSpan.textContent = subtotal.toFixed(2);
            cartTotalSpan.textContent = total.toFixed(2);
            
            // Enable/disable checkout button
            if (subtotal >= MIN_ORDER_AMOUNT) {
                checkoutBtn.disabled = false;
                checkoutBtn.textContent = 'Proceed to Checkout';
            } else {
                checkoutBtn.disabled = true;
                const remaining = MIN_ORDER_AMOUNT - subtotal;
                checkoutBtn.textContent = '$' + remaining.toFixed(2) + ' more needed';
            }
            
            clearCartBtn.style.display = 'block';
            
            // Show other restaurant carts
            showOtherRestaurantCarts();
        }
        
        function showOtherRestaurantCarts() {
            let otherCartsHTML = '';
            let hasOtherCarts = false;
            
            for (const [restaurantId, cart] of Object.entries(restaurantCarts)) {
                if (restaurantId != currentRestaurantId && cart.items && cart.items.length > 0) {
                    hasOtherCarts = true;
                    const itemCount = cart.items.length;
                    const totalValue = cart.items.reduce((total, item) => total + (item.price * item.quantity), 0);
                    
                    otherCartsHTML += '<div class="mt-2 p-2 bg-light rounded">';
                    otherCartsHTML += '  <small class="text-muted d-block">' + escapeHtml(cart.restaurantName) + '</small>';
                    otherCartsHTML += '  <small>' + itemCount + ' item(s) - $' + totalValue.toFixed(2) + '</small>';
                    otherCartsHTML += '  <a href="/FoodDelivery2/customer/restaurant/' + restaurantId + '/menu" class="btn btn-sm btn-outline-primary ms-2">View</a>';
                    otherCartsHTML += '</div>';
                }
            }
            
            // Add or update the other carts section
            let otherCartsSection = document.getElementById('otherCartsSection');
            
            if (hasOtherCarts) {
                if (!otherCartsSection) {
                    otherCartsSection = document.createElement('div');
                    otherCartsSection.id = 'otherCartsSection';
                    
                    // Find the specific cart card body that contains the checkout button
                    const checkoutBtn = document.getElementById('checkoutBtn');
                    if (checkoutBtn) {
                        const cartCardBody = checkoutBtn.closest('.card-body');
                        if (cartCardBody) {
                            cartCardBody.insertBefore(otherCartsSection, checkoutBtn);
                        }
                    }
                }
                
                if (otherCartsSection) {
                    otherCartsSection.innerHTML = '<hr><small class="text-muted">Items in other restaurants:</small>' + otherCartsHTML;
                }
            } else {
                if (otherCartsSection) {
                    otherCartsSection.remove();
                }
            }
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
            
            // Show/hide no items message
            const visibleItems = document.querySelectorAll('.menu-item[style*="block"], .menu-item:not([style*="none"])');
            
            if (visibleItems.length === 0 && category !== 'All') {
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
                const noItemsDiv = document.getElementById('no-items-message');
                if (noItemsDiv) {
                    noItemsDiv.style.display = 'none';
                }
            }
        }
        
        function proceedToCheckout() {
            if (currentCart.length === 0) {
                showToast('Your cart is empty', 'warning');
                return;
            }
            
            const subtotal = currentCart.reduce((total, item) => total + (item.price * item.quantity), 0);
            if (subtotal < MIN_ORDER_AMOUNT) {
                showToast('Minimum order amount is $' + MIN_ORDER_AMOUNT.toFixed(2), 'warning');
                return;
            }
            
            // Check if user has items in other restaurants' carts
            const otherCartCount = Object.keys(restaurantCarts).filter(id => 
                id != currentRestaurantId && restaurantCarts[id].items && restaurantCarts[id].items.length > 0
            ).length;
            
            // Inform user if they have items in other restaurant carts
            if (otherCartCount > 0) {
                const otherCartsInfo = Object.entries(restaurantCarts)
                    .filter(([id, cart]) => id != currentRestaurantId && cart.items && cart.items.length > 0)
                    .map(([id, cart]) => `${cart.restaurantName}: ${cart.items.length} item(s)`)
                    .join('\n');
                
                const proceed = confirm(
                    `You are about to place an order from this restaurant only.\n\n` +
                    `Current cart: ${currentCart.length} item(s) from this restaurant\n\n` +
                    `Note: You also have items in other restaurant carts:\n${otherCartsInfo}\n\n` +
                    `Those items will remain saved for later. Continue with this order?`
                );
                
                if (!proceed) {
                    return;
                }
            }
            
            // Get user info
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
            
            // Prepare order data (convert cart items to match expected format)
            const orderItems = currentCart.map(item => ({
                id: item.itemId,
                name: item.name,
                price: item.price,
                quantity: item.quantity
            }));
            
            const orderData = {
                restaurantId: currentRestaurantId,
                items: orderItems,
                deliveryAddress: deliveryAddress.trim(),
                phone: phone.trim(),
                specialInstructions: specialInstructions.trim(),
                paymentMethod: 'cash',
                subtotal: subtotal,
                deliveryFee: DELIVERY_FEE,
                total: totalAmount
            };
            
            console.log('Placing order:', orderData);
            showToast('Placing your order...', 'info');
            
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
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showToast('Order placed successfully! Order ' + data.orderNumber, 'success');
                    
                    // Clear all restaurant carts after successful order
                    restaurantCarts = {};
                    currentCart = [];
                    saveCartsToStorage();
                    updateCartDisplay();
                    
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
        
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
        
        function showToast(message, type) {
            type = type || 'info';
            
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
            
            setTimeout(function() {
                if (toast.parentElement) {
                    toast.remove();
                }
            }, 4000);
        }
    </script>
</body>
</html>
