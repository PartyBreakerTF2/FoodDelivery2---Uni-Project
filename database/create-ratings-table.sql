-- Create Ratings table for customer reviews
-- This table stores individual customer ratings and reviews

USE FoodDeliveryDB;
GO

-- Create Ratings table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ratings' AND xtype='U')
CREATE TABLE ratings (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    restaurant_id BIGINT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment NVARCHAR(1000),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES users(id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
    -- Ensure one rating per customer per restaurant (customer can update their rating)
    UNIQUE(customer_id, restaurant_id)
);
GO

-- Create index for faster queries
CREATE INDEX IX_ratings_restaurant_id ON ratings(restaurant_id);
GO
CREATE INDEX IX_ratings_customer_id ON ratings(customer_id);
GO

PRINT 'Ratings table created successfully!';
