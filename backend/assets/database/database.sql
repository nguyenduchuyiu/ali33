-- Create the 'users' table
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS variations;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS product_categories;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS delivery_stages;
DROP TABLE IF EXISTS product_ordering_details;


CREATE TABLE users (
    _key INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    contact_info TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    deviceToken TEXT NOT NULL,
    dob DATE NOT NULL,
    shopName TEXT,
    phoneNo TEXT NOT NULL,
    profilePic TEXT,
    userType TEXT NOT NULL,
    proprietorName TEXT,
    gst TEXT 
);


CREATE TABLE categories (
    _key TEXT PRIMARY KEY,
    categoryName TEXT NOT NULL,
    categoryPicture TEXT NOT NULL
);


CREATE TABLE products (
    _key TEXT PRIMARY KEY,
    productName TEXT NOT NULL,
    productDescription TEXT NOT NULL,
    productPicture TEXT NOT NULL
); 


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


CREATE TABLE reviews (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    productKey TEXT NOT NULL, 
    userId INTEGER NOT NULL, 
    comment TEXT NOT NULL,
    FOREIGN KEY (productKey) REFERENCES products(_key),
    FOREIGN KEY (userId) REFERENCES users(id)
);

 
CREATE TABLE orders (
    _key TEXT PRIMARY KEY,
    orderedDate DATETIME NOT NULL,
    userId INTEGER NOT NULL, 
    paidPrice INTEGER NOT NULL,
    paymentStatus INTEGER NOT NULL,
    address TEXT NOT NULL, 
    FOREIGN KEY (userId) REFERENCES users(id)
);


CREATE TABLE delivery_stages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    orderKey TEXT NOT NULL,
    stageOne TEXT NOT NULL,
    stageTwo TEXT NOT NULL,
    stageThree TEXT NOT NULL,
    stageFour TEXT NOT NULL,
    FOREIGN KEY (orderKey) REFERENCES orders(_key)
);


CREATE TABLE product_ordering_details (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    orderKey TEXT NOT NULL,
    productKey TEXT NOT NULL,
    noOfItems INTEGER NOT NULL, 
    variationQuantity INTEGER NOT NULL,
    FOREIGN KEY (orderKey) REFERENCES orders(_key),
    FOREIGN KEY (productKey) REFERENCES products(_key)
);

-- Cart Items Table 
CREATE TABLE cart_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userKey INTEGER NOT NULL,
    productKey TEXT NOT NULL,
    noOfItems INTEGER NOT NULL,
    variationQuantity INTEGER NOT NULL,
    FOREIGN KEY (userKey) REFERENCES users(_key),
    FOREIGN KEY (productKey) REFERENCES products(_key)
);


-- Sample Data Insertion (adjust as needed)
INSERT INTO categories (_key, categoryName, categoryPicture) 
VALUES 
    ('best_seller', 'Best Sellers', 'http://127.0.0.1:5000/static/images/tech.jpeg'),
    ('free_delivery', 'Free Delivery', 'http://127.0.0.1:5000/static/images/tech.jpeg'),
    ('tech', 'Technology', 'https://www.usabusiness.co.in/wp-content/uploads/2021/05/Health-Beauty-Products.jpg'),
    ('home_appliances', 'Home Appliances', 'https://www.faizabeautycream.com/blog/wp-content/uploads/3dd61f6ca74afa7196878eaae78fd259.jpg'),
    ('apparel', 'Apparel', 'https://www.skinfullofseoul.com/wp-content/uploads/2017/12/IMG_5400.jpg'),
    ('beauty_health', 'Beauty & Health', 'https://i0.wp.com/immrfabulous.com/wp-content/uploads/2020/03/img_9077-scaled.jpg?fit=1200,1162'),
    ('books', 'Books', 'https://www.kikcorp.com/wp-content/uploads/2019/10/Household-1-1.jpg'),
    ('sporting_goods', 'Sporting Goods', 'https://www.womensvoices.org/wp-content/uploads/2013/11/Feminine-Care-Products.jpg'),
    ('toys', 'Toys', 'https://thegreenhubonline.com/wp-content/uploads/2020/10/Earth-Choice-Natural-Eco-friendly-Cleaning-Products-1229x1536.jpg'),
    ('electronics', 'Electronics', 'https://hul-performance-highlights.hul.co.in/performance-highlights-fy-2022-2023/images/ourbrandbanner1.jpg'),
    ('furniture', 'Furniture', 'https://www.usabusiness.co.in/wp-content/uploads/2021/05/Health-Beauty-Products.jpg'),
    ('shoes', 'Shoes', 'https://vivecosmetic.com/wp-content/uploads/2021/04/Personal-Care-Products-Manufacturers.jpg');


INSERT INTO products (_key, productName, productDescription, productPicture) 
VALUES 
    ('prod_005', 'Smartphone Z', 'A high-quality smartphone with advanced features.', 'http://127.0.0.1:5000/static/images/iphone11promax.png'),
    ('prod_001', 'Samsung Galaxy Z Flip', 'A flagship foldable smartphone from Samsung.', 'https://cdn0.vox-cdn.com/hermano/verge/product/image/9662/dseifert-4711-samsung-z-flip-3-noWM-3.jpg'),
    ('prod_002', 'Smartphone X', 'A revolutionary new smartphone with cutting-edge technology.', 'https://i0.wp.com/immrfabulous.com/wp-content/uploads/2020/03/img_9077-scaled.jpg?fit=1200,1162'),
    ('prod_003', 'Smartphone Y', 'An innovative smartphone with an immersive display.', 'https://cdn0.vox-cdn.com/hermano/verge/product/image/9662/dseifert-4711-samsung-z-flip-3-noWM-3.jpg'),
    ('prod_004', 'Smartphone Z Pro', 'The ultimate smartphone experience with unparalleled performance.', 'https://cdn0.vox-cdn.com/hermano/verge/product/image/9662/dseifert-4711-samsung-z-flip-3-noWM-3.jpg');
INSERT INTO variations (productKey, quantity, sellingPrice, discountPrice, offerPrice, availabilityQuantity) 
VALUES 
    ('prod_005', 1, 1099, 0, 999, 10),
    ('prod_001', 1, 1099, 0, 999, 10),
    ('prod_002', 1, 1099, 0, 999, 10),
    ('prod_003', 1, 1099, 0, 999, 10),
    ('prod_004', 1, 1099, 0, 999, 10);

INSERT INTO reviews (productKey, userId, comment) 
VALUES 
    ('prod_005', 'user_789', 'Great phone!'),
    ('prod_001', 'nyuhe.li', 'Great phone!'),
    ('prod_002', 'nyuhe.li', 'Great phone!'),
    ('prod_003', 'nyuhe.li', 'Great phone!'),
    ('prod_004', 'nyuhe.li', 'Great phone!');
    

INSERT INTO product_categories (product_key, category_key) 
VALUES 
    ('prod_005', 'best_seller'),
    ('prod_005', 'free_delivery'),  
    ('prod_001', 'free_delivery'),
    ('prod_001', 'best_seller'),
    ('prod_002', 'free_delivery'),
    ('prod_002', 'best_seller'),
    ('prod_003', 'free_delivery'),
    ('prod_003', 'best_seller'),
    ('prod_004', 'free_delivery'),
    ('prod_004', 'best_seller');


INSERT INTO orders (_key, orderedDate, userId, paidPrice, paymentStatus, address) VALUES
('order_001', '2023-12-18 10:00:00', 1, 120, 1, '104 Pham Van Dong, Mach Dich, Cau Giay, Ha Noi'),
('order_002', '2023-12-17 14:30:00', 2, 55, 0, '104 Pham Van Dong, Mach Dich, Cau Giay, Ha Noi'),
('order_003', '2023-12-16 09:15:00', 3, 200, 1, '104 Pham Van Dong, Mach Dich, Cau Giay, Ha Noi'),
('order_004', '2023-12-15 18:45:00', 1, 80, 1, '104 Pham Van Dong, Mach Dich, Cau Giay, Ha Noi'),
('order_005', '2023-12-14 12:20:00', 4, 35, 1, '104 Pham Van Dong, Mach Dich, Cau Giay, Ha Noi'),
('order_006', '2023-12-13 20:10:00', 2, 150, 0, '104 Pham Van Dong, Mach Dich, Cau Giay, Ha Noi'),
('order_007', '2023-12-12 11:55:00', 5, 60, 1, '104 Pham Van Dong, Mach Dich, Cau Giay, Ha Noi'),
('order_008', '2023-12-11 16:30:00', 3, 95, 1, '104 Pham Van Dong, Mach Dich, Cau Giay, Ha Noi'),
('order_009', '2023-12-10 08:00:00', 1, 40, 1, '104 Pham Van Dong, Mach Dich, Cau Giay, Ha Noi'),
('order_010', '2023-12-09 19:25:00', 4, 110, 1, '104 Pham Van Dong, Mach Dich, Cau Giay, Ha Noi');


INSERT INTO delivery_stages (orderKey, stageOne, stageTwo, stageThree, stageFour) VALUES
('order_001', 'Order Placed', 'Processing', 'Shipped', 'Delivered'),
('order_002', 'Order Placed', 'Processing', 'Pending', 'Pending'),
('order_003', 'Order Placed', 'Shipped', 'Delivered', 'Completed'),
('order_004', 'Order Placed', 'Processing', 'Shipped', 'Delivered'),
('order_005', 'Order Placed', 'Processing', 'Pending', 'Pending'),
('order_006', 'Order Placed', 'Processing', 'Shipped', 'Delivered'),
('order_007', 'Order Placed', 'Shipped', 'Delivered', 'Completed'),
('order_008', 'Order Placed', 'Processing', 'Shipped', 'Delivered'),
('order_009', 'Order Placed', 'Processing', 'Pending', 'Pending'),
('order_010', 'Order Placed', 'Processing', 'Shipped', 'Delivered');

INSERT INTO product_ordering_details (orderKey, productKey, noOfItems, variationQuantity) VALUES
('order_001', 'prod_001', 2, 1),
('order_002', 'prod_003', 1, 2),
('order_003', 'prod_002', 3, 1),
('order_004', 'prod_005', 1, 1),
('order_005', 'prod_001', 2, 2),
('order_006', 'prod_004', 1, 1),
('order_007', 'prod_002', 2, 1),
('order_008', 'prod_003', 1, 2),
('order_009', 'prod_001', 1, 1),
('order_010', 'prod_005', 2, 2);

INSERT INTO cart_items (userKey, productKey, noOfItems, variationQuantity) VALUES
(1, 'prod_002', 1, 1),
(2, 'prod_001', 2, 2),
(3, 'prod_004', 3, 1),
(1, 'prod_003', 1, 2),
(4, 'prod_005', 2, 1),
(2, 'prod_002', 1, 1),
(5, 'prod_001', 2, 2),
(3, 'prod_003', 1, 1),
(1, 'prod_004', 1, 2),
(4, 'prod_005', 2, 1);