-- Script to assign restaurant staff to restaurants
-- This fixes the issue where restaurant staff cannot see orders because they're not assigned to restaurants

USE FoodDeliveryDB;
GO

-- Update existing staff users to be assigned to restaurants
-- Assign staff to Pizza Palace (restaurant ID 1)
UPDATE users 
SET restaurant_id = 1 
WHERE username = 'staff' AND role = 'RESTAURANT_STAFF';

-- Create additional staff for other restaurants if needed
-- Check if we need more staff for other restaurants
DECLARE @restaurant_count INT;
SELECT @restaurant_count = COUNT(*) FROM restaurants WHERE is_active = 1;

-- If we have more than 1 restaurant, create additional staff
IF @restaurant_count > 1
BEGIN
    -- Create staff for Burger House (restaurant ID 2)
    IF NOT EXISTS (SELECT * FROM users WHERE username = 'staff2')
    BEGIN
        INSERT INTO users (username, password, email, full_name, phone, address, role, restaurant_id) 
        VALUES ('staff2', 'staff123', 'staff2@burgerhouse.com', 'Mike Johnson', '2233445566', '456 Burger Staff St', 'RESTAURANT_STAFF', 2);
        PRINT 'Created staff2 for Burger House';
    END
    ELSE
    BEGIN
        UPDATE users SET restaurant_id = 2 WHERE username = 'staff2' AND role = 'RESTAURANT_STAFF';
        PRINT 'Updated staff2 restaurant assignment';
    END
END

IF @restaurant_count > 2
BEGIN
    -- Create staff for Sushi Corner (restaurant ID 3)
    IF NOT EXISTS (SELECT * FROM users WHERE username = 'staff3')
    BEGIN
        INSERT INTO users (username, password, email, full_name, phone, address, role, restaurant_id) 
        VALUES ('staff3', 'staff123', 'staff3@sushicorner.com', 'Sarah Wilson', '3344556677', '789 Sushi Staff Rd', 'RESTAURANT_STAFF', 3);
        PRINT 'Created staff3 for Sushi Corner';
    END
    ELSE
    BEGIN
        UPDATE users SET restaurant_id = 3 WHERE username = 'staff3' AND role = 'RESTAURANT_STAFF';
        PRINT 'Updated staff3 restaurant assignment';
    END
END

-- Verify the assignments
SELECT 
    u.username,
    u.full_name,
    u.role,
    u.restaurant_id,
    r.name as restaurant_name
FROM users u
LEFT JOIN restaurants r ON u.restaurant_id = r.id
WHERE u.role = 'RESTAURANT_STAFF'
ORDER BY u.restaurant_id;

PRINT 'Restaurant staff assignments completed';
GO
