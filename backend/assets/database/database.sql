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
    ('prod_456', 'Smartphone Z', 'A high-quality smartphone with advanced features.', 'http://127.0.0.1:5000/static/images/iphone11promax.png'),
    ('prod_001', 'Samsung Galaxy Z Flip', 'A flagship foldable smartphone from Samsung.', 'https://cdn0.vox-cdn.com/hermano/verge/product/image/9662/dseifert-4711-samsung-z-flip-3-noWM-3.jpg'),
    ('prod_002', 'Smartphone X', 'A revolutionary new smartphone with cutting-edge technology.', 'https://i0.wp.com/immrfabulous.com/wp-content/uploads/2020/03/img_9077-scaled.jpg?fit=1200,1162'),
    ('prod_003', 'Smartphone Y', 'An innovative smartphone with an immersive display.', 'https://cdn0.vox-cdn.com/hermano/verge/product/image/9662/dseifert-4711-samsung-z-flip-3-noWM-3.jpg'),
    ('prod_004', 'Smartphone Z Pro', 'The ultimate smartphone experience with unparalleled performance.', 'https://cdn0.vox-cdn.com/hermano/verge/product/image/9662/dseifert-4711-samsung-z-flip-3-noWM-3.jpg');
INSERT INTO variations (productKey, quantity, sellingPrice, discountPrice, offerPrice, availabilityQuantity) 
VALUES 
    ('prod_456', 1, 1099, 0, 999, 10),
    ('prod_001', 1, 1099, 0, 999, 10),
    ('prod_002', 1, 1099, 0, 999, 10),
    ('prod_003', 1, 1099, 0, 999, 10),
    ('prod_004', 1, 1099, 0, 999, 10);

INSERT INTO reviews (productKey, userId, comment) 
VALUES 
    ('prod_456', 'user_789', 'Great phone!'),
    ('prod_001', 'nyuhe.li', 'Great phone!'),
    ('prod_002', 'nyuhe.li', 'Great phone!'),
    ('prod_003', 'nyuhe.li', 'Great phone!'),
    ('prod_004', 'nyuhe.li', 'Great phone!');
    

INSERT INTO product_categories (product_key, category_key) 
VALUES 
    ('prod_456', 'best_seller'),
    ('prod_456', 'free_delivery'),  -- Assuming you have a 'free_delivery' category
    ('prod_001', 'free_delivery'),
    ('prod_001', 'best_seller'),
    ('prod_002', 'free_delivery'),
    ('prod_002', 'best_seller'),
    ('prod_003', 'free_delivery'),
    ('prod_003', 'best_seller'),
    ('prod_004', 'free_delivery'),
    ('prod_004', 'best_seller');