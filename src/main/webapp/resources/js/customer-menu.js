// Customer Menu JavaScript - Theme Management and Cart Functionality

// Theme Management
function initializeTheme() {
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.documentElement.setAttribute('data-theme', savedTheme);
    updateThemeIcon(savedTheme);
}

function toggleTheme() {
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    
    document.documentElement.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
    updateThemeIcon(newTheme);
}

function updateThemeIcon(theme) {
    const themeIcon = document.getElementById('themeIcon');
    if (themeIcon) {
        themeIcon.className = theme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
    }
}

// Customer Menu JavaScript - Enhanced functions when external scripts load successfully

function addToCartFromButton(button) {
    const itemId = button.dataset.itemId;
    const itemName = button.dataset.itemName;
    const itemPrice = parseFloat(button.dataset.itemPrice);
    
    addToCart(itemId, itemName, itemPrice);
}

// Cart Management
const DELIVERY_FEE = 2.99;
const MIN_ORDER_AMOUNT = 10.00;
let cart = [];

function escapeHtml(text) {
    if (text == null) return '';
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return text.toString().replace(/[&<>"']/g, function(m) { return map[m]; });
}

function addToCart(itemId, name, price) {
    try {
        if (!itemId || !name || price == null) {
            showToast('Invalid item data', 'error');
            return;
        }

        const existingItem = cart.find(item => item.id === itemId);
        if (existingItem) {
            existingItem.quantity++;
        } else {
            cart.push({
                id: itemId,
                name: name,
                price: parseFloat(price),
                quantity: 1
            });
        }
        
        updateCartDisplay();
        showToast(`${escapeHtml(name)} added to cart`, 'success');
    } catch (error) {
        console.error('Error adding to cart:', error);
        showToast('Error adding item to cart', 'error');
    }
}

function removeFromCart(itemId) {
    try {
        const itemIndex = cart.findIndex(item => item.id === itemId);
        if (itemIndex > -1) {
            const itemName = cart[itemIndex].name;
            cart.splice(itemIndex, 1);
            updateCartDisplay();
            showToast(`${escapeHtml(itemName)} removed from cart`, 'info');
        }
    } catch (error) {
        console.error('Error removing from cart:', error);
        showToast('Error removing item from cart', 'error');
    }
}

function updateQuantity(itemId, change) {
    try {
        const item = cart.find(item => item.id === itemId);
        if (item) {
            item.quantity += change;
            if (item.quantity <= 0) {
                removeFromCart(itemId);
            } else {
                updateCartDisplay();
            }
        }
    } catch (error) {
        console.error('Error updating quantity:', error);
        showToast('Error updating quantity', 'error');
    }
}

function updateCartDisplay() {
    try {
        const cartItemsContainer = document.getElementById('cartItems');
        const cartCountElement = document.getElementById('cartCount');
        const subtotalSpan = document.getElementById('subtotal');
        const cartTotalSpan = document.getElementById('cartTotal');
        const checkoutBtn = document.getElementById('checkoutBtn');

        if (!cartItemsContainer || !cartCountElement || !subtotalSpan || !cartTotalSpan || !checkoutBtn) {
            console.error('Cart display elements not found');
            return;
        }

        // Update cart count
        const totalItems = cart.reduce((total, item) => total + item.quantity, 0);
        cartCountElement.textContent = totalItems;

        // Clear and update cart items
        cartItemsContainer.innerHTML = '';

        if (cart.length === 0) {
            cartItemsContainer.innerHTML = `
                <div class="empty-cart">
                    <i class="fas fa-shopping-cart"></i>
                    <p>Your cart is empty</p>
                    <p class="small text-muted">Add some delicious items!</p>
                </div>
            `;
            subtotalSpan.textContent = '0.00';
            cartTotalSpan.textContent = DELIVERY_FEE.toFixed(2);
            checkoutBtn.disabled = true;
            return;
        }

        // Calculate subtotal
        const subtotal = cart.reduce((total, item) => total + (item.price * item.quantity), 0);
        const total = subtotal + DELIVERY_FEE;

        // Generate cart items HTML
        cart.forEach(item => {
            const itemTotal = item.price * item.quantity;
            const cartItemHtml = `
                <div class="cart-item">
                    <div class="cart-item-info">
                        <h6>${escapeHtml(item.name)}</h6>
                        <div class="cart-item-price">$${item.price.toFixed(2)} each</div>
                    </div>
                    <div class="quantity-controls">
                        <button type="button" class="quantity-btn" onclick="updateQuantity('${item.id}', -1)">
                            <i class="fas fa-minus"></i>
                        </button>
                        <span class="quantity mx-2">${item.quantity}</span>
                        <button type="button" class="quantity-btn" onclick="updateQuantity('${item.id}', 1)">
                            <i class="fas fa-plus"></i>
                        </button>
                        <button type="button" class="btn btn-sm text-danger ms-2" onclick="removeFromCart('${item.id}')" title="Remove item">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </div>
            `;
            cartItemsContainer.innerHTML += cartItemHtml;
        });

        // Update totals
        subtotalSpan.textContent = subtotal.toFixed(2);
        cartTotalSpan.textContent = total.toFixed(2);

        // Enable/disable checkout button
        if (subtotal >= MIN_ORDER_AMOUNT) {
            checkoutBtn.disabled = false;
            checkoutBtn.innerHTML = '<i class="fas fa-credit-card me-2"></i>Proceed to Checkout';
        } else {
            checkoutBtn.disabled = true;
            const remaining = MIN_ORDER_AMOUNT - subtotal;
            checkoutBtn.innerHTML = `<i class="fas fa-info-circle me-2"></i>Add $${remaining.toFixed(2)} more`;
        }
    } catch (error) {
        console.error('Error updating cart display:', error);
        showToast('Error updating cart display', 'error');
    }
}

function filterByCategory(category) {
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
        console.error('Error filtering categories:', error);
        showToast('Error filtering menu', 'error');
    }
}

function proceedToCheckout() {
    try {
        if (cart.length === 0) {
            showToast('Your cart is empty', 'warning');
            return;
        }

        const subtotal = cart.reduce((total, item) => total + (item.price * item.quantity), 0);
        if (subtotal < MIN_ORDER_AMOUNT) {
            const remaining = MIN_ORDER_AMOUNT - subtotal;
            showToast(`Minimum order amount is $${MIN_ORDER_AMOUNT.toFixed(2)}. Add $${remaining.toFixed(2)} more.`, 'warning');
            return;
        }

        // Populate checkout modal with order details
        populateCheckoutModal();
        
        // Show the checkout modal
        const checkoutModal = new bootstrap.Modal(document.getElementById('checkoutModal'));
        checkoutModal.show();
    } catch (error) {
        console.error('Error during checkout:', error);
        showToast('Error during checkout. Please try again.', 'error');
    }
}

function populateCheckoutModal() {
    // Populate order items
    const orderItemsContainer = document.getElementById('checkoutOrderItems');
    orderItemsContainer.innerHTML = '';
    
    cart.forEach(item => {
        const itemDiv = document.createElement('div');
        itemDiv.className = 'd-flex justify-content-between align-items-center mb-2';
        itemDiv.innerHTML = `
            <div>
                <strong>${escapeHtml(item.name)}</strong>
                <br>
                <small class="text-muted">Qty: ${item.quantity} × $${item.price.toFixed(2)}</small>
            </div>
            <span>$${(item.price * item.quantity).toFixed(2)}</span>
        `;
        orderItemsContainer.appendChild(itemDiv);
    });
    
    // Update totals
    const subtotal = cart.reduce((total, item) => total + (item.price * item.quantity), 0);
    const total = subtotal + DELIVERY_FEE;
    
    document.getElementById('checkoutSubtotal').textContent = subtotal.toFixed(2);
    document.getElementById('checkoutTotal').textContent = total.toFixed(2);
}

function submitOrder() {
    try {
        const form = document.getElementById('checkoutForm');
        const phone = document.getElementById('deliveryPhone').value.trim();
        const address = document.getElementById('deliveryAddress').value.trim();
        const notes = document.getElementById('orderNotes').value.trim();
        
        // Validate required fields
        if (!phone) {
            showToast('Please enter your phone number', 'error');
            document.getElementById('deliveryPhone').focus();
            return;
        }
        
        if (!address) {
            showToast('Please enter your delivery address', 'error');
            document.getElementById('deliveryAddress').focus();
            return;
        }
        
        // Validate phone number format (basic validation)
        const phoneRegex = /^[\+]?[1-9][\d]{0,15}$/;
        if (!phoneRegex.test(phone.replace(/[\s\-\(\)]/g, ''))) {
            showToast('Please enter a valid phone number', 'error');
            document.getElementById('deliveryPhone').focus();
            return;
        }
        
        // Prepare order data
        const orderData = {
            restaurantId: document.getElementById('restaurantId').value,
            phone: phone,
            deliveryAddress: address,
            notes: notes,
            items: cart.map(item => ({
                menuItemId: item.id,
                quantity: item.quantity,
                unitPrice: item.price
            }))
        };
        
        // Disable submit button
        const submitBtn = document.querySelector('#checkoutModal .btn-primary');
        const originalText = submitBtn.innerHTML;
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Placing Order...';
        
        // Submit order
        fetch(window.location.origin + '/FoodDelivery2/customer/orders', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(orderData)
        })
        .then(response => {
            if (response.ok) {
                return response.json();
            } else {
                throw new Error('Failed to place order');
            }
        })
        .then(data => {
            showToast('Order placed successfully!', 'success');
            
            // Clear cart
            cart = [];
            updateCartDisplay();
            
            // Close modal
            const checkoutModal = bootstrap.Modal.getInstance(document.getElementById('checkoutModal'));
            checkoutModal.hide();
            
            // Redirect to orders page after a short delay
            setTimeout(() => {
                window.location.href = window.location.origin + '/FoodDelivery2/customer/orders';
            }, 2000);
        })
        .catch(error => {
            console.error('Error placing order:', error);
            showToast('Failed to place order. Please try again.', 'error');
        })
        .finally(() => {
            // Re-enable submit button
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalText;
        });
        
    } catch (error) {
        console.error('Error submitting order:', error);
        showToast('Error submitting order. Please try again.', 'error');
    }
}

function showToast(message, type = 'info') {
    try {
        const toastContainer = document.getElementById('toastContainer');
        if (!toastContainer) {
            console.warn('Toast container not found');
            return;
        }

        const toast = document.createElement('div');
        toast.className = 'custom-toast';
        
        let iconClass = 'fas fa-info-circle';
        let bgColor = 'var(--primary-color)';
        
        switch(type) {
            case 'success':
                iconClass = 'fas fa-check-circle';
                bgColor = 'var(--success-color)';
                break;
            case 'error':
                iconClass = 'fas fa-exclamation-circle';
                bgColor = 'var(--danger-color)';
                break;
            case 'warning':
                iconClass = 'fas fa-exclamation-triangle';
                bgColor = 'var(--warning-color)';
                break;
        }
        
        toast.innerHTML = `
            <div class="toast-body d-flex align-items-center" style="background: ${bgColor}; color: white; border-radius: 15px; padding: 1rem;">
                <i class="${iconClass} me-2"></i>
                <span class="flex-grow-1">${escapeHtml(message)}</span>
                <button type="button" class="btn-close btn-close-white ms-2" onclick="this.parentElement.parentElement.remove()"></button>
            </div>
        `;
        
        toastContainer.appendChild(toast);
        
        // Auto remove after 4 seconds
        setTimeout(function() {
            if (toast.parentElement) {
                toast.remove();
            }
        }, 4000);
    } catch (error) {
        console.error('Error showing toast:', error);
    }
}

// Simple fallback functions for when external scripts fail
window.fallbackCart = [];

window.addToCartFromButtonFallback = function(button) {
    try {
        const itemId = button.dataset.itemId;
        const itemName = button.dataset.itemName;
        const itemPrice = parseFloat(button.dataset.itemPrice);
        
        const existingItem = window.fallbackCart.find(item => item.id === itemId);
        if (existingItem) {
            existingItem.quantity += 1;
        } else {
            window.fallbackCart.push({ id: itemId, name: itemName, price: itemPrice, quantity: 1 });
        }
        
        updateFallbackCart();
        alert(itemName + ' added to cart!');
    } catch (error) {
        console.error('Fallback add to cart error:', error);
    }
};

function updateFallbackCart() {
    try {
        const cart = window.fallbackCart || [];
        const cartCount = document.getElementById('cartCount');
        const cartItems = document.getElementById('cartItems');
        const subtotalElement = document.getElementById('subtotal');
        const cartTotalElement = document.getElementById('cartTotal');
        const checkoutBtn = document.getElementById('checkoutBtn');
        
        if (!cartCount || !cartItems || !subtotalElement || !cartTotalElement || !checkoutBtn) return;
        
        if (cart.length === 0) {
            cartCount.textContent = '0';
            cartItems.innerHTML = '<div class="empty-cart"><i class="fas fa-shopping-cart"></i><p>Your cart is empty</p></div>';
            subtotalElement.textContent = '0.00';
            cartTotalElement.textContent = '2.99';
            checkoutBtn.disabled = true;
            return;
        }
        
        const itemCount = cart.reduce((total, item) => total + item.quantity, 0);
        const subtotal = cart.reduce((total, item) => total + (item.price * item.quantity), 0);
        const total = subtotal + 2.99;
        
        cartCount.textContent = itemCount;
        subtotalElement.textContent = subtotal.toFixed(2);
        cartTotalElement.textContent = total.toFixed(2);
        
        cartItems.innerHTML = cart.map(item => 
            '<div class="cart-item"><div class="cart-item-info"><h6>' + escapeHtml(item.name) + '</h6><span>Qty: ' + item.quantity + '</span></div><div class="cart-item-price">$' + (item.price * item.quantity).toFixed(2) + '</div></div>'
        ).join('');
        
        checkoutBtn.disabled = subtotal < 10;
    } catch (error) {
        console.error('Fallback cart update error:', error);
    }
}

window.proceedToCheckoutFallback = function() {
    try {
        const cart = window.fallbackCart || [];
        if (cart.length === 0) {
            alert('Your cart is empty');
            return;
        }
        
        const modal = new bootstrap.Modal(document.getElementById('checkoutModal'));
        const orderItems = document.getElementById('checkoutOrderItems');
        
        if (orderItems) {
            orderItems.innerHTML = cart.map(item => 
                '<div class="d-flex justify-content-between mb-2"><span>' + escapeHtml(item.name) + ' (x' + item.quantity + ')</span><span>$' + (item.price * item.quantity).toFixed(2) + '</span></div>'
            ).join('');
        }
        
        const subtotal = cart.reduce((total, item) => total + (item.price * item.quantity), 0);
        const subtotalEl = document.getElementById('checkoutSubtotal');
        const totalEl = document.getElementById('checkoutTotal');
        
        if (subtotalEl) subtotalEl.textContent = subtotal.toFixed(2);
        if (totalEl) totalEl.textContent = (subtotal + 2.99).toFixed(2);
        
        modal.show();
    } catch (error) {
        console.error('Fallback checkout error:', error);
    }
};

window.submitOrderFallback = function() {
    try {
        const phone = document.getElementById('deliveryPhone').value.trim();
        const address = document.getElementById('deliveryAddress').value.trim();
        
        if (!phone || !address) {
            alert('Please fill in phone and address');
            return;
        }
        
        const cart = window.fallbackCart || [];
        const orderData = {
            restaurantId: document.getElementById('restaurantId').value,
            phone: phone,
            deliveryAddress: address,
            notes: document.getElementById('orderNotes').value.trim(),
            items: cart.map(item => ({
                menuItemId: item.id,
                quantity: item.quantity,
                unitPrice: item.price
            }))
        };
        
        fetch(window.location.origin + '/FoodDelivery2/customer/orders', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(orderData)
        })
        .then(response => response.json())
        .then(data => {
            alert('Order placed successfully!');
            window.fallbackCart = [];
            updateFallbackCart();
            const modal = bootstrap.Modal.getInstance(document.getElementById('checkoutModal'));
            if (modal) modal.hide();
            setTimeout(() => location.href = window.location.origin + '/FoodDelivery2/customer/orders', 1000);
        })
        .catch(() => alert('Failed to place order'));
    } catch (error) {
        console.error('Fallback order submit error:', error);
    }
};

// Initialize on page load - only override functions if they don't already exist
document.addEventListener('DOMContentLoaded', function() {
    try {
        console.log('External customer-menu.js loading...');
        
        // Only override if fallback functions aren't already working
        if (typeof window.addToCartFromButton === 'function') {
            // Check if it's our enhanced version or fallback
            const testButton = { dataset: { itemId: 'test', itemName: 'test', itemPrice: '1.00' } };
            
            // If external scripts loaded properly, use enhanced functions
            if (typeof addToCart === 'function' && typeof updateCartDisplay === 'function') {
                window.addToCartFromButton = function(button) {
                    const itemId = button.dataset.itemId;
                    const itemName = button.dataset.itemName;
                    const itemPrice = parseFloat(button.dataset.itemPrice);
                    addToCart(itemId, itemName, itemPrice);
                };
                
                window.proceedToCheckout = proceedToCheckout;
                window.submitOrder = submitOrder;
                window.filterByCategory = filterByCategory;
                
                // Initialize enhanced cart display
                updateCartDisplay();
                console.log('Enhanced menu functions loaded');
            } else {
                console.log('Using fallback menu functions');
            }
        }
        
        initializeTheme();
        
        // Set first category as active if exists
        const firstCategoryTab = document.querySelector('.category-tab');
        if (firstCategoryTab && !firstCategoryTab.classList.contains('active')) {
            firstCategoryTab.classList.add('active');
        }
    } catch (error) {
        console.error('Error during external script initialization:', error);
        console.log('Fallback functions will be used');
    }
});
