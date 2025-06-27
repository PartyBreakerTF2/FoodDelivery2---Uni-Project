<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Delivery - Profile</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/global-styles.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/${sessionScope.user.role.name().toLowerCase()}/dashboard">
                <i class="fas fa-utensils me-2"></i>FoodDelivery
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/${sessionScope.user.role.name().toLowerCase()}/dashboard">
                            <i class="fas fa-home me-1"></i>Dashboard
                        </a>
                    </li>
                    <c:choose>
                        <c:when test="${sessionScope.user.role.name() == 'CUSTOMER'}">
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
                        </c:when>
                        <c:when test="${sessionScope.user.role.name() == 'RESTAURANT_STAFF'}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/restaurant/menu">
                                    <i class="fas fa-utensils me-1"></i>Menu
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/restaurant/orders">
                                    <i class="fas fa-receipt me-1"></i>Orders
                                </a>
                            </li>
                        </c:when>
                        <c:when test="${sessionScope.user.role.name() == 'ADMIN'}">
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
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
                                    <i class="fas fa-receipt me-1"></i>Orders
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                                    <i class="fas fa-chart-bar me-1"></i>Reports
                                </a>
                            </li>
                        </c:when>
                    </c:choose>
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
                            <c:out value="${sessionScope.user.fullName}" default="User"/>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/profile">
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

    <div class="container" style="margin-top: 100px;">
        <!-- Page Header -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-2">
                        <i class="fas fa-user-edit me-2"></i>User Profile
                    </h1>
                    <p class="mb-0">Manage your account information and preferences</p>
                </div>
                <div class="col-md-4 text-center">
                    <i class="fas fa-user-circle fa-3x"></i>
                </div>
            </div>
        </div>

        <!-- Profile Content -->
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="row">
                    <div class="col-md-4 mb-4">
                        <!-- Profile Info Card -->
                        <div class="glass-card">
                            <div class="card-body text-center">
                                <div class="profile-avatar mb-3">
                                    <i class="fas fa-user-circle"></i>
                                </div>
                                <h5><c:out value="${sessionScope.user.fullName}"/></h5>
                                <p class="text-muted"><c:out value="${sessionScope.user.email}"/></p>
                                <span class="badge role-badge">
                                    <i class="fas fa-shield-alt me-1"></i>
                                    <c:out value="${sessionScope.user.role}"/>
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-8">
                        <!-- Profile Form -->
                        <div class="glass-card">
                            <div class="card-body p-4">
                                <h5 class="section-title mb-4">
                                    <i class="fas fa-edit me-2"></i>Edit Profile Information
                                </h5>
                                
                                <c:if test="${not empty success}">
                                    <div class="alert alert-success alert-dismissible fade show glass-card mb-4" role="alert">
                                        <i class="fas fa-check-circle me-2"></i><c:out value="${success}"/>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger alert-dismissible fade show glass-card mb-4" role="alert">
                                        <i class="fas fa-exclamation-circle me-2"></i><c:out value="${error}"/>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/profile" method="post" id="profileForm">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="fullName" class="form-label">
                                                <i class="fas fa-user me-2"></i>Full Name
                                            </label>
                                            <input type="text" class="form-control" id="fullName" name="fullName" 
                                                   value="<c:out value='${sessionScope.user.fullName}'/>" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="email" class="form-label">
                                                <i class="fas fa-envelope me-2"></i>Email Address
                                            </label>
                                            <input type="email" class="form-control" id="email" name="email" 
                                                   value="<c:out value='${sessionScope.user.email}'/>" required>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="username" class="form-label">
                                                <i class="fas fa-at me-2"></i>Username
                                            </label>
                                            <input type="text" class="form-control" id="username" name="username" 
                                                   value="<c:out value='${sessionScope.user.username}'/>" readonly>
                                            <div class="form-help">Username cannot be changed</div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="role" class="form-label">
                                                <i class="fas fa-shield-alt me-2"></i>Role
                                            </label>
                                            <input type="text" class="form-control" id="role" 
                                                   value="<c:out value='${sessionScope.user.role}'/>" readonly>
                                            <div class="form-help">Role is assigned by administrators</div>
                                        </div>
                                    </div>

                                    <div class="d-flex gap-2 justify-content-end">
                                        <a href="${pageContext.request.contextPath}/${sessionScope.user.role.name().toLowerCase()}/dashboard" 
                                           class="btn btn-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                                        </a>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>Update Profile
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Change Password Card -->
                        <div class="glass-card mt-4">
                            <div class="card-body p-4">
                                <h5 class="section-title mb-4">
                                    <i class="fas fa-lock me-2"></i>Change Password
                                </h5>
                                
                                <form action="${pageContext.request.contextPath}/profile/change-password" method="post" id="passwordForm">
                                    <div class="mb-3">
                                        <label for="currentPassword" class="form-label">
                                            <i class="fas fa-key me-2"></i>Current Password
                                        </label>
                                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                        <div class="form-help">Enter your current password to verify identity</div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="newPassword" class="form-label">
                                                <i class="fas fa-lock me-2"></i>New Password
                                            </label>
                                            <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="6">
                                            <div class="form-help">Minimum 6 characters</div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="confirmPassword" class="form-label">
                                                <i class="fas fa-lock me-2"></i>Confirm New Password
                                            </label>
                                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                            <div class="form-help">Must match new password</div>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-end">
                                        <button type="submit" class="btn btn-warning">
                                            <i class="fas fa-key me-2"></i>Change Password
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Form validation for profile form
            const profileForm = document.getElementById('profileForm');
            const passwordForm = document.getElementById('passwordForm');
            
            // Profile form validation
            if (profileForm) {
                profileForm.addEventListener('submit', function(e) {
                    if (!profileForm.checkValidity()) {
                        e.preventDefault();
                        e.stopPropagation();
                    }
                    profileForm.classList.add('was-validated');
                });
            }
            
            // Password form validation
            if (passwordForm) {
                const newPassword = document.getElementById('newPassword');
                const confirmPassword = document.getElementById('confirmPassword');
                
                // Check password match
                function validatePasswordMatch() {
                    if (newPassword.value !== confirmPassword.value) {
                        confirmPassword.setCustomValidity("Passwords don't match");
                    } else {
                        confirmPassword.setCustomValidity('');
                    }
                }
                
                newPassword.addEventListener('change', validatePasswordMatch);
                confirmPassword.addEventListener('keyup', validatePasswordMatch);
                
                passwordForm.addEventListener('submit', function(e) {
                    validatePasswordMatch();
                    if (!passwordForm.checkValidity()) {
                        e.preventDefault();
                        e.stopPropagation();
                    }
                    passwordForm.classList.add('was-validated');
                });
            }
            
            // Real-time validation feedback
            const inputs = document.querySelectorAll('input');
            inputs.forEach(input => {
                input.addEventListener('blur', function() {
                    if (input.checkValidity()) {
                        input.classList.remove('is-invalid');
                        input.classList.add('is-valid');
                    } else {
                        input.classList.remove('is-valid');
                        input.classList.add('is-invalid');
                    }
                });
            });
        });
    </script>
</body>
</html>
