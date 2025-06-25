<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu Test</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1>Menu Test Page</h1>
        <p>Restaurant: ${restaurant.name}</p>
        <p>If you can see this, the JSP is working fine.</p>
        
        <div class="row">
            <c:forEach var="item" items="${menuItems}">
                <div class="col-md-6 mb-3">
                    <div class="card">
                        <div class="card-body">
                            <h6>${item.name}</h6>
                            <p>${item.description}</p>
                            <p><strong>$${item.price}</strong></p>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        console.log('Test JSP loaded successfully');
    </script>
</body>
</html>
