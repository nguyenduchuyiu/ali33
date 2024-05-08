-- Create the 'users' table
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS variations;
DROP TABLE IF EXISTS reviews;

CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    contact_info TEXT NOT NULL UNIQUE,
    info_type TEXT NOT NULL, 
    password_hash TEXT NOT NULL
);

-- Create the 'Categories' table
CREATE TABLE  categories (
    _key TEXT PRIMARY KEY,
    categoryName TEXT NOT NULL,
    categoryPicture TEXT NOT NULL
);

-- Create the 'Products' table
CREATE TABLE  products (
    _key TEXT PRIMARY KEY,
    productCategoryId TEXT NOT NULL,
    productName TEXT NOT NULL,
    productDescription TEXT NOT NULL,
    productPicture TEXT NOT NULL,
    FOREIGN KEY (productCategoryId) REFERENCES categories (_key)
);

-- Create the 'Variations' table
CREATE TABLE  variations (
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
CREATE TABLE  reviews (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    productKey TEXT NOT NULL,
    userId TEXT NOT NULL,
    comment TEXT NOT NULL,
    FOREIGN KEY (productKey) REFERENCES products (_key)
);

-- Inserting into Categories table
INSERT INTO categories (_key, categoryName, categoryPicture) 
VALUES ('best_seller', '', 'http://127.0.0.1:5000/static/images/20');

-- Inserting into Products table
INSERT INTO products (_key, productCategoryId, productName, productDescription, productPicture) 
VALUES ('prod_456', 'best_seller', 'Smartphone Z', 'A high-quality smartphone with advanced features.', 'http://127.0.0.1:5000/static/images/iphone11promax.png');

-- Inserting into Variations table
INSERT INTO variations (productKey, quantity, sellingPrice, discountPrice, offerPrice, availabilityQuantity) 
VALUES ('prod_456', 1, 1099, 0, 999, 10);

-- Inserting into Reviews table
INSERT INTO reviews (productKey, userId, comment) 
VALUES ('prod_456', 'user_789', 'Great phone!'); 