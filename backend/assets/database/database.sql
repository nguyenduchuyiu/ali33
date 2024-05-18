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


CREATE TABLE categories (
    _key INTEGER PRIMARY KEY AUTOINCREMENT,
    categoryName TEXT NOT NULL,
    categoryPicture TEXT NOT NULL
);


CREATE TABLE products (
    _key INTEGER PRIMARY KEY AUTOINCREMENT,
    productName TEXT NOT NULL,
    productDescription TEXT NOT NULL,
    productPicture TEXT NOT NULL,
    productRating FLOAT
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
    productKey INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    sellingPrice REAL NOT NULL,
    discountPrice REAL NOT NULL,
    offerPrice REAL NOT NULL,
    availabilityQuantity INTEGER NOT NULL,
    FOREIGN KEY (productKey) REFERENCES products (_key)
);


CREATE TABLE reviews (
    _key INTEGER PRIMARY KEY AUTOINCREMENT,
    productKey INTEGER NOT NULL, 
    userKey INTEGER NOT NULL, 
    comment TEXT,
    FOREIGN KEY (productKey) REFERENCES products(_key),
    FOREIGN KEY (userKey) REFERENCES users(_key)
);

 
CREATE TABLE orders (
    _key INTEGER PRIMARY KEY AUTOINCREMENT,
    userKey INTEGER NOT NULL,
    productKey INTEGER NOT NULL,
    orderedDate DATETIME , 
    paidPrice INTEGER ,
    paymentStatus INTEGER ,
    deliveryStages TEXT,
    deliveryAddress TEXT,
    noOfItems INTEGER NOT NULL,
    variationQuantity INTEGER NOT NULL,
    FOREIGN KEY (userKey) REFERENCES users(_key),
    FOREIGN KEY (productKey) REFERENCES products(_key)
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

-- Example data for 'users' table
INSERT INTO users (hashed_password, emailId, proprietorName) VALUES
    ('password123', 'john.doe@example.com', 'John Doe'),
    ('secure_password', 'jane.smith@example.com', 'Jane Smith'),
    ('mysecret', 'robert.jones@example.com', 'Robert Jones'),
    ('password456', 'emily.wilson@example.com', 'Emily Wilson'),
    ('qwerty', 'david.brown@example.com', 'David Brown'),
    ('123456', 'sarah.miller@example.com', 'Sarah Miller'),
    ('strongpassword', 'michael.davis@example.com', 'Michael Davis'),
    ('password789', 'jessica.garcia@example.com', 'Jessica Garcia'),
    ('secure123', 'matthew.wilson@example.com', 'Matthew Wilson'),
    ('mysecretpass', 'ashley.rodriguez@example.com', 'Ashley Rodriguez');

-- Example data for 'categories' table
INSERT INTO categories (categoryName, categoryPicture) VALUES
    ('Electronics', 'electronics.jpg'),
    ('Fashion', 'fashion.jpg'),
    ('Home & Kitchen', 'home_kitchen.jpg'),
    ('Books', 'books.jpg'),
    ('Sports', 'sports.jpg'),
    ('Toys', 'toys.jpg'),
    ('Beauty & Personal Care', 'beauty.jpg'),
    ('Grocery', 'grocery.jpg'),
    ('Furniture', 'furniture.jpg'),
    ('Automotive', 'automotive.jpg');

-- Example data for 'products' table
INSERT INTO products (productName, productDescription, productPicture, productRating) VALUES
    ('Smart TV', '4K Ultra HD Smart TV with HDR', 'smart_tv.jpg', 4.5),
    ('Running Shoes', 'Lightweight and breathable running shoes', 'running_shoes.jpg', 4.2),
    ('Kitchen Knife Set', 'High-quality stainless steel kitchen knife set', 'kitchen_knives.jpg', 4.8),
    ('The Hobbit', 'J.R.R. Tolkien''s classic fantasy novel', 'hobbit_book.jpg', 4.7),
    ('Basketball', 'Official size basketball for outdoor play', 'basketball.jpg', 4.3),
    ('Teddy Bear', 'Soft and cuddly teddy bear for children', 'teddy_bear.jpg', 4.9),
    ('Face Cream', 'Hydrating and anti-aging face cream', 'face_cream.jpg', 4.6),
    ('Organic Coffee', 'Freshly roasted organic coffee beans', 'coffee_beans.jpg', 4.4),
    ('Sofa Bed', 'Comfortable sofa bed for small spaces', 'sofa_bed.jpg', 4.1),
    ('Car Battery', 'High-performance car battery with long life', 'car_battery.jpg', 4.0);

-- Example data for 'product_categories' table
INSERT INTO product_categories (productKey, categoryKey) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 9),
    (10, 10);

-- Example data for 'variations' table
INSERT INTO variations (productKey, quantity, sellingPrice, discountPrice, offerPrice, availabilityQuantity) VALUES
    (1, 100, 500.00, 450.00, 400.00, 50),
    (2, 150, 75.00, 65.00, 55.00, 100),
    (3, 200, 120.00, 100.00, 90.00, 150),
    (4, 50, 15.00, 12.00, 10.00, 20),
    (5, 100, 30.00, 25.00, 20.00, 75),
    (6, 250, 20.00, 15.00, 10.00, 150),
    (7, 100, 35.00, 30.00, 25.00, 80),
    (8, 200, 25.00, 20.00, 15.00, 120),
    (9, 50, 300.00, 250.00, 200.00, 30),
    (10, 100, 100.00, 80.00, 60.00, 50);

-- Example data for 'reviews' table
INSERT INTO reviews (productKey, userKey, comment) VALUES
    (1, 1, 'Excellent TV with great picture quality!'),
    (2, 2, 'These shoes are comfortable and provide good support.'),
    (3, 3, 'The knives are sharp and durable. Highly recommend them.'),
    (4, 4, 'This book was captivating from beginning to end.'),
    (5, 5, 'Perfect basketball for outdoor play. Great bounce and grip.'),
    (6, 6, 'My child loves this teddy bear. It’s soft and huggable.'),
    (7, 7, 'This face cream has made a noticeable difference in my skin.'),
    (8, 8, 'The coffee is delicious and smells amazing.'),
    (9, 9, 'This sofa bed is perfect for my small apartment. Comfortable and functional.'),
    (10, 10, 'This car battery has been working great so far. Strong and reliable.');

-- Example data for 'orders' table
INSERT INTO orders (userKey, productKey, orderedDate, paidPrice, paymentStatus, deliveryStages, deliveryAddress, noOfItems, variationQuantity) VALUES
    (1, 1, '2023-04-01', 400, 1, 'Delivered', '123 Main Street', 1, 1),
    (2, 2, '2023-04-05', 65, 1, 'Shipped', '456 Elm Street', 2, 2),
    (3, 3, '2023-04-10', 90, 1, 'Processing', '789 Oak Street', 1, 1),
    (4, 4, '2023-04-15', 10, 1, 'Completed', '101 Pine Street', 3, 3),
    (5, 5, '2023-04-20', 20, 1, 'Pending', '202 Maple Street', 1, 1),
    (6, 6, '2023-04-25', 10, 1, 'Returned', '303 Birch Street', 2, 2),
    (7, 7, '2023-05-01', 25, 1, 'Cancelled', '404 Willow Street', 1, 1),
    (8, 8, '2023-05-05', 15, 1, 'Refunded', '505 Cedar Street', 2, 2),
    (9, 9, '2023-05-10', 200, 1, 'Dispatched', '606 Walnut Street', 1, 1),
    (10, 10, '2023-05-15', 60, 1, 'Delivered', '707 Oak Street', 2, 2);

-- Example data for 'cart_items' table
INSERT INTO cart_items (userKey, productKey, noOfItems, variationQuantity) VALUES
    (1, 1, 2, 2),
    (2, 2, 1, 1),
    (3, 3, 3, 3),
    (4, 4, 1, 1),
    (5, 5, 2, 2),
    (6, 6, 1, 1),
    (7, 7, 3, 3),
    (8, 8, 2, 2),
    (9, 9, 1, 1),
    (10, 10, 2, 2);
