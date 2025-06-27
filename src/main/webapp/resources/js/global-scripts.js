// Global Theme Management and Utilities
document.addEventListener('DOMContentLoaded', function() {
    initializeTheme();
    initializeAnimations();
    initializeTooltips();
});

// Theme Management
function initializeTheme() {
    const savedTheme = localStorage.getItem('theme') || 'light';
    const htmlElement = document.documentElement;
    const themeIcon = document.getElementById('theme-icon');
    
    htmlElement.setAttribute('data-theme', savedTheme);
    
    if (themeIcon) {
        if (savedTheme === 'dark') {
            themeIcon.className = 'fas fa-sun';
        } else {
            themeIcon.className = 'fas fa-moon';
        }
    }
}

function toggleTheme() {
    const htmlElement = document.documentElement;
    const currentTheme = htmlElement.getAttribute('data-theme');
    const themeIcon = document.getElementById('theme-icon');
    
    if (currentTheme === 'dark') {
        htmlElement.setAttribute('data-theme', 'light');
        localStorage.setItem('theme', 'light');
        if (themeIcon) themeIcon.className = 'fas fa-moon';
    } else {
        htmlElement.setAttribute('data-theme', 'dark');
        localStorage.setItem('theme', 'dark');
        if (themeIcon) themeIcon.className = 'fas fa-sun';
    }
}

// Initialize animations
function initializeAnimations() {
    // Add fade-in animation to cards
    const cards = document.querySelectorAll('.card, .glass-card, .stats-card');
    cards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            card.style.transition = 'all 0.5s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });
    
    // Add slide-up animation to main content
    const mainContent = document.querySelector('.main-content');
    if (mainContent) {
        mainContent.classList.add('slide-up');
    }
}

// Initialize Bootstrap tooltips
function initializeTooltips() {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

// Toast notification utility
function showToast(message, type = 'info', duration = 3000) {
    const toastContainer = document.getElementById('toastContainer') || createToastContainer();
    
    const toastId = 'toast-' + Date.now();
    const toastHTML = `
        <div id="${toastId}" class="toast custom-toast ${type}" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header">
                <i class="fas fa-${getToastIcon(type)} me-2"></i>
                <strong class="me-auto">${getToastTitle(type)}</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body">
                ${message}
            </div>
        </div>
    `;
    
    toastContainer.insertAdjacentHTML('beforeend', toastHTML);
    
    const toastElement = document.getElementById(toastId);
    const toast = new bootstrap.Toast(toastElement, { delay: duration });
    toast.show();
    
    // Remove toast element after it's hidden
    toastElement.addEventListener('hidden.bs.toast', function() {
        toastElement.remove();
    });
}

function createToastContainer() {
    const container = document.createElement('div');
    container.id = 'toastContainer';
    container.className = 'toast-container position-fixed top-0 end-0 p-3';
    container.style.zIndex = '1055';
    container.style.marginTop = '100px';
    document.body.appendChild(container);
    return container;
}

function getToastIcon(type) {
    switch(type) {
        case 'success': return 'check-circle';
        case 'error': 
        case 'danger': return 'exclamation-circle';
        case 'warning': return 'exclamation-triangle';
        case 'info':
        default: return 'info-circle';
    }
}

function getToastTitle(type) {
    switch(type) {
        case 'success': return 'Success';
        case 'error':
        case 'danger': return 'Error';
        case 'warning': return 'Warning';
        case 'info':
        default: return 'Information';
    }
}

// Form validation enhancement
function enhanceFormValidation() {
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            if (!form.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
                showToast('Please fill in all required fields correctly.', 'warning');
            }
            form.classList.add('was-validated');
        });
    });
}

// Initialize form enhancements
document.addEventListener('DOMContentLoaded', function() {
    enhanceFormValidation();
});

// Utility function to format currency
function formatCurrency(amount) {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
    }).format(amount);
}

// Utility function to format date
function formatDate(date) {
    return new Intl.DateTimeFormat('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    }).format(new Date(date));
}

// Utility function to format time
function formatTime(date) {
    return new Intl.DateTimeFormat('en-US', {
        hour: '2-digit',
        minute: '2-digit',
        hour12: true
    }).format(new Date(date));
}

// Loading spinner utility
function showLoading(element) {
    if (element) {
        element.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Loading...';
        element.disabled = true;
    }
}

function hideLoading(element, originalText) {
    if (element) {
        element.innerHTML = originalText;
        element.disabled = false;
    }
}

// Smooth scroll to element
function scrollToElement(elementId) {
    const element = document.getElementById(elementId);
    if (element) {
        element.scrollIntoView({
            behavior: 'smooth',
            block: 'start'
        });
    }
}

// Debounce utility for search inputs
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}
