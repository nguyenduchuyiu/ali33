-- Create the 'users' table
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS variations;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS product_categories;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS orders;


CREATE TABLE users (
  _key INTEGER PRIMARY KEY AUTOINCREMENT,
  hashed_password TEXT NOT NULL,
  deliveryAddress TEXT,
  deviceToken TEXT,
  dob DATETIME,
  emailId TEXT NOT NULL,
  shopName TEXT,
  phoneNo TEXT,
  profilePic TEXT,
  userType TEXT,
  proprietorName TEXT NOT NULL,
  gst TEXT
);

INSERT INTO users (_key, hashed_password, deliveryAddress, deviceToken, dob, emailId, shopName, phoneNo, profilePic, userType, proprietorName, gst)
VALUES (1, 'hashed_password123', '123 Main Street, Anytown, CA 54321', 'somedevicetoken123', '2000-01-01', 'user1@example.com', 'User1 Shop', '555-123-4567', 'https://example.com/profilepic1.jpg', 'buyer', 'John Doe', '1234567890');

CREATE TABLE categories (
    _key INTEGER PRIMARY KEY AUTOINCREMENT,
    categoryName TEXT NOT NULL,
    categoryPicture TEXT NOT NULL
);


CREATE TABLE products (
    _key INTEGER PRIMARY KEY AUTOINCREMENT,
    productName TEXT NOT NULL,
    productDescription TEXT NOT NULL,
    productPicture TEXT NOT NULL
); 


CREATE TABLE product_categories (
    productKey INTEGER NOT NULL ,
    categoryKey INTEGER NOT NULL ,
    PRIMARY KEY (productKey, categoryKey),
    FOREIGN KEY (productKey) REFERENCES products (_key),
    FOREIGN KEY (categoryKey) REFERENCES categories (_key)
);


CREATE TABLE variations (
    _key INTEGER PRIMARY KEY AUTOINCREMENT,
    productKey TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    sellingPrice REAL NOT NULL,
    discountPrice REAL NOT NULL,
    offerPrice REAL NOT NULL,
    availabilityQuantity INTEGER NOT NULL,
    FOREIGN KEY (productKey) REFERENCES products (_key)
);


CREATE TABLE reviews (
    _key INTEGER PRIMARY KEY AUTOINCREMENT,
    productKey TEXT NOT NULL, 
    userKey INTEGER NOT NULL, 
    comment TEXT NOT NULL,
    FOREIGN KEY (productKey) REFERENCES products(_key),
    FOREIGN KEY (userKey) REFERENCES users(_key)
);

 
CREATE TABLE orders (
    _key INTEGER PRIMARY KEY AUTOINCREMENT,
    userKey INTEGER NOT NULL,
    cartKey INTEGER NOT NULL,
    orderedDate DATETIME NOT NULL, 
    paidPrice INTEGER NOT NULL,
    paymentStatus INTEGER NOT NULL,
    stageOne TEXT NOT NULL,
    stageTwo TEXT NOT NULL,
    stageThree TEXT NOT NULL,
    stageFour TEXT NOT NULL,
    FOREIGN KEY (userKey) REFERENCES users(_key)
);


CREATE TABLE cart_items (
    _key INTEGER PRIMARY KEY AUTOINCREMENT,
    userKey INTEGER NOT NULL,
    productKey INTEGER NOT NULL,
    noOfItems INTEGER NOT NULL,
    variationQuantity INTEGER NOT NULL,
    FOREIGN KEY (userKey) REFERENCES users(_key),
    FOREIGN KEY (productKey) REFERENCES products(_key)
);



-- Sample Data Insertion (adjust as needed)
INSERT INTO categories (categoryName, categoryPicture) VALUES 
('Electronics', 'electronics.jpg'),
('Clothing', 'clothing.jpg'),
('Home & Kitchen', 'homekitchen.jpg'),
('Books', 'books.jpg'),
('Beauty & Personal Care', 'beauty.jpg'),
('Sports & Outdoors', 'sports.jpg'),
('Toys & Games', 'toys.jpg'),
('Automotive', 'automotive.jpg'),
('Pet Supplies', 'pets.jpg'),
('Groceries', 'groceries.jpg');

INSERT INTO products (productName, productDescription, productPicture) VALUES
('Laptop', 'Powerful laptop for work and play', 'laptop.jpg'),
('T-shirt', 'Comfortable cotton t-shirt', 'tshirt.jpg'),
('Frying Pan', 'Non-stick frying pan', 'fryingpan.jpg'),
('The Lord of the Rings', 'Epic fantasy novel', 'lotr.jpg'),
('Shampoo', 'Moisturizing shampoo for dry hair', 'shampoo.jpg'),
('Soccer Ball', 'Durable soccer ball for outdoor play', 'soccerball.jpg'),
('Building Blocks', 'Colorful building blocks for kids', 'buildingblocks.jpg'),
('Tire Inflator', 'Portable tire inflator for emergencies', 'tireinflator.jpg'),
('Dog Food', 'Nutritious dog food for adult dogs', 'dogfood.jpg'),
('Pasta', 'High-quality pasta for delicious meals', 'pasta.jpg');

INSERT INTO product_categories (productKey, categoryKey) VALUES
(1, 1), -- Laptop - Electronics
(2, 2), -- T-shirt - Clothing
(3, 3), -- Frying Pan - Home & Kitchen
(4, 4), -- The Lord of the Rings - Books
(5, 5), -- Shampoo - Beauty & Personal Care
(6, 6), -- Soccer Ball - Sports & Outdoors
(7, 7), -- Building Blocks - Toys & Games
(8, 8), -- Tire Inflator - Automotive
(9, 9), -- Dog Food - Pet Supplies
(10, 10), -- Pasta - Groceries
(1, 7), -- Laptop - Toys & Games (Example of a product in multiple categories)
(2, 3);  -- T-shirt - Home & Kitchen (Example of a product in multiple categories)

INSERT INTO variations (productKey, quantity, sellingPrice, discountPrice, offerPrice, availabilityQuantity) VALUES
('1', 10, 1200.00, 1000.00, 1100.00, 5),
('2', 20, 25.00, 20.00, 22.00, 15),
('3', 5, 35.00, 30.00, 32.00, 2),
('4', 30, 15.00, 12.00, 13.00, 25),
('5', 15, 8.00, 6.00, 7.00, 10),
('6', 10, 20.00, 15.00, 18.00, 5),
('7', 25, 40.00, 35.00, 37.00, 20),
('8', 8, 50.00, 45.00, 47.00, 3),
('9', 12, 60.00, 50.00, 55.00, 8),
('10', 18, 5.00, 4.00, 4.50, 15); 

INSERT INTO reviews (productKey, userKey, comment) 
VALUES 
    ('5', 'user_789', 'Great phone!'),
    ('1', 'nyuhe.li', 'Great phone!'),
    ('2', 'nyuhe.li', 'Great phone!'),
    ('3', 'nyuhe.li', 'Great phone!'),
    ('4', 'nyuhe.li', 'Great phone!');
    

INSERT INTO product_categories (productKey, categoryKey) 
VALUES 
    (5, 'best_seller'),
    (5, 'free_delivery'),  
    (1, 'free_delivery'),
    (1, 'best_seller'),
    (2, 'free_delivery'),
    (2, 'best_seller'),
    (3, 'free_delivery'),
    (3, 'best_seller'),
    (4, 'free_delivery'),
    (4, 'best_seller');



