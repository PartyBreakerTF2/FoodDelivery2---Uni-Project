<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - FoodDelivery Admin</title>
    
    <!-- External CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global-styles.css">
</head>

<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-utensils me-2"></i>FoodDelivery
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-home me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/users">
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
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <button class="theme-toggle" onclick="toggleTheme()" title="Toggle theme">
                            <i id="theme-icon" class="fas fa-moon"></i>
                        </button>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user me-1"></i><c:out value="${sessionScope.user.fullName}" default="Admin"/>
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

    <div class="container-fluid mt-4">
        <!-- Header -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="section-header">
                    <h2><i class="fas fa-users me-2"></i>User Management</h2>
                    <p>Manage system users, customers, and restaurant staff</p>
                </div>
            </div>
        </div>

        <!-- Flash Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i><c:out value="${success}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i><c:out value="${error}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-md-6">
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                    <i class="fas fa-user-plus me-2"></i>Add New User
                </button>
            </div>
            <div class="col-md-6">
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                    <input type="text" class="form-control" placeholder="Search users..." id="searchInput">
                </div>
            </div>
        </div>

        <!-- Users Table -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-list me-2"></i>All Users</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Username</th>
                                        <th>Full Name</th>
                                        <th>Email</th>
                                        <th>Role</th>
                                        <th>Restaurant</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${users}">
                                        <tr>
                                            <td><c:out value="${user.id}"/></td>
                                            <td><c:out value="${user.username}"/></td>
                                            <td><c:out value="${user.fullName}"/></td>
                                            <td><c:out value="${user.email}"/></td>
                                            <td>
                                                <span class="badge role-badge">
                                                    <c:choose>
                                                        <c:when test="${user.role.name() == 'ADMIN'}">
                                                            <i class="fas fa-shield-alt me-1"></i>Admin
                                                        </c:when>
                                                        <c:when test="${user.role.name() == 'RESTAURANT_STAFF'}">
                                                            <i class="fas fa-store me-1"></i>Restaurant Staff
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fas fa-user me-1"></i>Customer
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.role.name() == 'RESTAURANT_STAFF' && user.restaurantId != null}">
                                                        <c:forEach var="restaurant" items="${restaurants}">
                                                            <c:if test="${restaurant.id == user.restaurantId}">
                                                                <span class="badge bg-success">
                                                                    <i class="fas fa-store me-1"></i><c:out value="${restaurant.name}"/>
                                                                </span>
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:when test="${user.role.name() == 'RESTAURANT_STAFF'}">
                                                        <span class="badge bg-warning">
                                                            <i class="fas fa-exclamation-triangle me-1"></i>Not Assigned
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <button class="btn btn-sm btn-outline-primary edit-user-btn" 
                                                            data-id="<c:out value='${user.id}'/>"
                                                            data-username="<c:out value='${user.username}'/>"
                                                            data-fullname="<c:out value='${user.fullName}'/>"
                                                            data-email="<c:out value='${user.email}'/>"
                                                            data-role="<c:out value='${user.role.name()}'/>"
                                                            data-restaurantid="<c:out value='${user.restaurantId}'/>">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <c:if test="${user.id != sessionScope.user.id}">
                                                        <button class="btn btn-sm btn-outline-danger delete-user-btn" 
                                                                data-id="<c:out value='${user.id}'/>"
                                                                data-username="<c:out value='${user.username}'/>">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-user-plus me-2"></i>Add New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/users/add" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="fullName" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <div class="mb-3">
                            <label for="role" class="form-label">Role</label>
                            <select class="form-select" id="role" name="role" required>
                                <option value="CUSTOMER">Customer</option>
                                <option value="RESTAURANT_STAFF">Restaurant Staff</option>
                                <option value="ADMIN">Admin</option>
                            </select>
                        </div>
                        <div class="mb-3" id="restaurantSelection" style="display: none;">
                            <label for="restaurantId" class="form-label">Assign to Restaurant</label>
                            <select class="form-select" id="restaurantId" name="restaurantId">
                                <option value="">Select a restaurant...</option>
                                <c:forEach var="restaurant" items="${restaurants}">
                                    <option value="<c:out value='${restaurant.id}'/>">
                                        <c:out value="${restaurant.name}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-user-edit me-2"></i>Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/users/edit" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="editUserId" name="id">
                        <div class="mb-3">
                            <label for="editUsername" class="form-label">Username</label>
                            <input type="text" class="form-control" id="editUsername" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="editFullName" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="editFullName" name="fullName" required>
                        </div>
                        <div class="mb-3">
                            <label for="editEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="editEmail" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="editRole" class="form-label">Role</label>
                            <select class="form-select" id="editRole" name="role" required>
                                <option value="CUSTOMER">Customer</option>
                                <option value="RESTAURANT_STAFF">Restaurant Staff</option>
                                <option value="ADMIN">Admin</option>
                            </select>
                        </div>
                        <div class="mb-3" id="editRestaurantSelection" style="display: none;">
                            <label for="editRestaurantId" class="form-label">Assign to Restaurant</label>
                            <select class="form-select" id="editRestaurantId" name="restaurantId">
                                <option value="">Select a restaurant...</option>
                                <c:forEach var="restaurant" items="${restaurants}">
                                    <option value="<c:out value='${restaurant.id}'/>">
                                        <c:out value="${restaurant.name}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/global-scripts.js"></script>
    <script>
        // Show/hide restaurant selection based on role
        function toggleRestaurantSelection(roleSelect, restaurantDiv) {
            const role = roleSelect.value;
            if (role === 'RESTAURANT_STAFF') {
                restaurantDiv.style.display = 'block';
                restaurantDiv.querySelector('select').required = true;
            } else {
                restaurantDiv.style.display = 'none';
                restaurantDiv.querySelector('select').required = false;
                restaurantDiv.querySelector('select').value = '';
            }
        }

        // Add user modal - role change handler
        document.getElementById('role').addEventListener('change', function() {
            toggleRestaurantSelection(this, document.getElementById('restaurantSelection'));
        });

        // Edit user modal - role change handler
        document.getElementById('editRole').addEventListener('change', function() {
            toggleRestaurantSelection(this, document.getElementById('editRestaurantSelection'));
        });

        // Edit user functionality
        document.addEventListener('click', function(e) {
            if (e.target.closest('.edit-user-btn')) {
                const btn = e.target.closest('.edit-user-btn');
                const id = btn.getAttribute('data-id');
                const username = btn.getAttribute('data-username');
                const fullName = btn.getAttribute('data-fullname');
                const email = btn.getAttribute('data-email');
                const role = btn.getAttribute('data-role');
                const restaurantId = btn.getAttribute('data-restaurantid');
                
                document.getElementById('editUserId').value = id;
                document.getElementById('editUsername').value = username;
                document.getElementById('editFullName').value = fullName;
                document.getElementById('editEmail').value = email;
                document.getElementById('editRole').value = role;
                
                // Handle restaurant selection
                if (restaurantId && restaurantId !== 'null') {
                    document.getElementById('editRestaurantId').value = restaurantId;
                } else {
                    document.getElementById('editRestaurantId').value = '';
                }
                
                // Show/hide restaurant selection based on role
                toggleRestaurantSelection(
                    document.getElementById('editRole'), 
                    document.getElementById('editRestaurantSelection')
                );
                
                new bootstrap.Modal(document.getElementById('editUserModal')).show();
            }
            
            if (e.target.closest('.delete-user-btn')) {
                const btn = e.target.closest('.delete-user-btn');
                const id = btn.getAttribute('data-id');
                const username = btn.getAttribute('data-username');
                
                if (confirm(`Are you sure you want to delete user "${username}"?`)) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/admin/users/delete';
                    
                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'id';
                    idInput.value = id;
                    form.appendChild(idInput);
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            }
        });

        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
            const filter = this.value.toLowerCase();
            const rows = document.querySelectorAll('tbody tr');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(filter) ? '' : 'none';
            });
        });
    </script>
</body>
</html>
