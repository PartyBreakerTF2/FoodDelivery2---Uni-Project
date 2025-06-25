<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">    <title>User Management - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>    <!-- Navigation -->    <nav class="navbar navbar-expand-lg navbar-dark bg-danger">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-utensils me-2"></i>Food Delivery System
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
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
                    </li>                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="fas fa-shopping-cart me-1"></i>Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                            <i class="fas fa-chart-bar me-1"></i>Reports
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav">                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user me-1"></i>${sessionScope.user.fullName}
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2>User Management</h2>
                        <p class="lead">Manage all platform users</p>
                    </div>
                    <div>
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                            <i class="fas fa-user-plus me-1"></i>Add Restaurant Staff
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Flash Messages -->
        <c:if test="${not empty success}">
            <div class="row mt-3">
                <div class="col-12">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </div>
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="row mt-3">
                <div class="col-12">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </div>
            </div>
        </c:if>
        
        <div class="row mt-4">
            <div class="col-12">
                <div class="table-responsive">
                    <table class="table table-striped">                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Username</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Restaurant</th>
                                <th>Status</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td>${user.id}</td>
                                    <td>${user.username}</td>
                                    <td>${user.fullName}</td>
                                    <td>${user.email}</td>                                    <td>
                                        <span class="badge 
                                            <c:choose>
                                                <c:when test="${user.role == 'ADMIN'}">bg-danger</c:when>
                                                <c:when test="${user.role == 'RESTAURANT_STAFF'}">bg-success</c:when>
                                                <c:otherwise>bg-primary</c:otherwise>
                                            </c:choose>
                                        ">${user.role}</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.role == 'RESTAURANT_STAFF'}">
                                                <c:choose>
                                                    <c:when test="${user.restaurantId != null}">
                                                        <c:forEach var="restaurant" items="${restaurants}">
                                                            <c:if test="${restaurant.id == user.restaurantId}">
                                                                <span class="badge bg-info">${restaurant.name}</span>
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning text-dark">Unassigned</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${user.active}">
                                            <span class="badge bg-success">Active</span>
                                        </c:if>
                                        <c:if test="${!user.active}">
                                            <span class="badge bg-danger">Inactive</span>
                                        </c:if>
                                    </td>
                                    <td>${user.createdAt}</td>                                    <td>
                                        <c:if test="${user.role != 'ADMIN'}">
                                            <form action="${pageContext.request.contextPath}/admin/users/${user.id}/toggle" method="post" style="display: inline;">
                                                <button type="submit" class="btn btn-sm 
                                                    <c:if test="${user.active}">btn-outline-warning</c:if>
                                                    <c:if test="${!user.active}">btn-outline-success</c:if>
                                                ">
                                                    <c:if test="${user.active}">Deactivate</c:if>
                                                    <c:if test="${!user.active}">Activate</c:if>
                                                </button>
                                            </form>
                                        </c:if>
                                                          <!-- Restaurant Assignment for RESTAURANT_STAFF -->
                        <c:if test="${user.role == 'RESTAURANT_STAFF'}">
                            <button type="button" class="btn btn-sm btn-outline-primary ms-1" 
                                    data-bs-toggle="modal" data-bs-target="#assignModal${user.id}">
                                <i class="fas fa-store"></i> 
                                <c:choose>
                                    <c:when test="${user.restaurantId != null}">Change Restaurant</c:when>
                                    <c:otherwise>Assign Restaurant</c:otherwise>
                                </c:choose>
                            </button>
                            
                            <!-- Unassign Button (only if user is assigned) -->
                            <c:if test="${user.restaurantId != null}">
                                <form action="${pageContext.request.contextPath}/admin/users/${user.id}/unassign-restaurant" method="post" style="display: inline;">
                                    <button type="submit" class="btn btn-sm btn-outline-danger ms-1" 
                                            onclick="return confirm('Are you sure you want to unassign this staff member from their restaurant?')">
                                        <i class="fas fa-unlink"></i> Unassign
                                    </button>
                                </form>
                            </c:if>
                                            
                                            <!-- Assignment Modal -->
                                            <div class="modal fade" id="assignModal${user.id}" tabindex="-1">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title">Assign Restaurant to ${user.fullName}</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <form action="${pageContext.request.contextPath}/admin/users/${user.id}/assign-restaurant" method="post">
                                                            <div class="modal-body">
                                                                <div class="mb-3">
                                                                    <label for="restaurantId${user.id}" class="form-label">Select Restaurant</label>
                                                                    <select class="form-select" id="restaurantId${user.id}" name="restaurantId" required>
                                                                        <option value="">-- Select Restaurant --</option>
                                                                        <c:forEach var="restaurant" items="${restaurants}">
                                                                            <option value="${restaurant.id}" 
                                                                                    <c:if test="${restaurant.id == user.restaurantId}">selected</c:if>>
                                                                                ${restaurant.name} (${restaurant.cuisineType})
                                                                            </option>
                                                                        </c:forEach>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-primary">Assign</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty users}">
                                <tr>
                                    <td colspan="8" class="text-center text-muted">No users found</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addUserModalLabel">
                        <i class="fas fa-user-plus me-2"></i>Add Restaurant Staff
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/users/add" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                            <div class="form-text">Must be unique across the platform</div>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                            <div class="form-text">Must be unique across the platform</div>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required minlength="6">
                            <div class="form-text">Minimum 6 characters</div>
                        </div>
                        <div class="mb-3">
                            <label for="fullName" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" required>
                        </div>
                        <div class="mb-3">
                            <label for="restaurantId" class="form-label">Assign to Restaurant (Optional)</label>
                            <select class="form-select" id="restaurantId" name="restaurantId">
                                <option value="">-- No Assignment --</option>
                                <c:forEach var="restaurant" items="${restaurants}">
                                    <option value="${restaurant.id}">${restaurant.name}</option>
                                </c:forEach>
                            </select>
                            <div class="form-text">Can be assigned later from the user list</div>
                        </div>
                        <!-- Role is hardcoded to RESTAURANT_STAFF -->
                        <input type="hidden" name="role" value="restaurant_staff">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-user-plus me-1"></i>Add Staff Member
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
