-- Create the 'users' table
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS variations;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS product_categories;

CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    contact_info TEXT NOT NULL UNIQUE,
    info_type TEXT NOT NULL, 
    password_hash TEXT NOT NULL
);

-- Create the 'Categories' table (before Products to establish FK relationship)
CREATE TABLE categories (
    _key TEXT PRIMARY KEY,
    categoryName TEXT NOT NULL,
    categoryPicture TEXT NOT NULL
);

-- Create the 'Products' table
CREATE TABLE products (
    _key TEXT PRIMARY KEY,
    productName TEXT NOT NULL,
    productDescription TEXT NOT NULL,
    productPicture TEXT NOT NULL
); 

-- Create the 'Product_categories' table (after Products and Categories)
CREATE TABLE product_categories (
    product_key TEXT,
    category_key TEXT,
    PRIMARY KEY (product_key, category_key),
    FOREIGN KEY (product_key) REFERENCES products (_key),
    FOREIGN KEY (category_key) REFERENCES categories (_key)
);

-- Create the 'Variations' table
CREATE TABLE variations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    productKey TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    sellingPrice REAL NOT NULL,
    discountPrice REAL NOT NULL,
    offerPrice REAL NOT NULL,
    availabilityQuantity INTEGER NOT NULL,
    FOREIGN KEY (productKey) REFERENCES products (_key)
);

-- Create the 'Reviews' table
CREATE TABLE reviews (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    productKey TEXT NOT NULL,
    userId TEXT NOT NULL,
    comment TEXT NOT NULL,
    FOREIGN KEY (productKey) REFERENCES products (_key)
);

-- Sample Data Insertion (adjust as needed)
INSERT INTO categories (_key, categoryName, categoryPicture) 
VALUES 
    ('best_seller', 'Best Sellers', 'http://127.0.0.1:5000/static/images/tech.jpeg'),
    ('free_delivery', 'Free Delivery', 'http://127.0.0.1:5000/static/images/tech.jpeg');

INSERT INTO products (_key, productName, productDescription, productPicture) 
VALUES 
    ('prod_456', 'Smartphone Z', 'A high-quality smartphone with advanced features.', 'http://127.0.0.1:5000/static/images/iphone11promax.png'),
    ('prod_1', 'Lover', "Hehe", 'http://127.0.0.1:5000/static/images/lover.png');

INSERT INTO variations (productKey, quantity, sellingPrice, discountPrice, offerPrice, availabilityQuantity) 
VALUES 
    ('prod_456', 1, 1099, 0, 999, 10),
    ('prod_1', 1, 1099, 0, 999, 10);


INSERT INTO reviews (productKey, userId, comment) 
VALUES 
    ('prod_456', 'user_789', 'Great phone!'),
    ('prod_1', 'user_789', 'Great girl!');

INSERT INTO product_categories (product_key, category_key) 
VALUES 
    ('prod_456', 'best_seller'),
    ('prod_456', 'free_delivery'),  -- Assuming you have a 'free_delivery' category
    ('prod_1', 'best_seller');