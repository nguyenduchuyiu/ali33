CREATE DATABASE ali33_db;
USE ali33_db;

-- Create the 'users' table
CREATE TABLE users (
  _key INT AUTO_INCREMENT PRIMARY KEY,
  hashed_password VARBINARY(255),
  deliveryAddress TEXT,
  deviceToken TEXT,
  dob BIGINT,
  emailId TEXT NOT NULL,
  shopName TEXT,
  phoneNo TEXT,
  profilePic TEXT,
  userType TEXT,
  proprietorName TEXT NOT NULL,
  gst TEXT
);

-- Create the 'products' table
CREATE TABLE products (
  _key INT AUTO_INCREMENT PRIMARY KEY,
  productName TEXT NOT NULL,
  productDescription TEXT NOT NULL,
  productPicture TEXT NOT NULL,
  productRating FLOAT
);

-- Create the 'categories' table
CREATE TABLE categories (
  _key INT AUTO_INCREMENT PRIMARY KEY,
  categoryName TEXT NOT NULL,
  categoryPicture TEXT NOT NULL
);

-- Create the 'cart_items' table
CREATE TABLE cart_items (
  _key INT AUTO_INCREMENT PRIMARY KEY,
  userKey INT NOT NULL,
  productKey INT NOT NULL,
  noOfItems INT NOT NULL,
  variationQuantity INT NOT NULL,
  FOREIGN KEY (userKey) REFERENCES users(_key),
  FOREIGN KEY (productKey) REFERENCES products(_key)
);

-- Create the 'orders' table
CREATE TABLE orders (
  _key INT AUTO_INCREMENT PRIMARY KEY,
  userKey INT NOT NULL,
  productKey INT NOT NULL,
  orderedDate BIGINT,
  paidPrice FLOAT,
  paymentStatus INT,
  deliveryStages TEXT,
  deliveryAddress TEXT,
  noOfItems INT NOT NULL,
  variationQuantity INT NOT NULL,
  FOREIGN KEY (userKey) REFERENCES users(_key),
  FOREIGN KEY (productKey) REFERENCES products(_key)
);

-- Create the 'product_categories' table (many-to-many relationship table)
CREATE TABLE product_categories (
  productKey INT NOT NULL,
  categoryKey INT NOT NULL,
  PRIMARY KEY (productKey, categoryKey), -- Composite primary key
  FOREIGN KEY (productKey) REFERENCES products(_key),
  FOREIGN KEY (categoryKey) REFERENCES categories(_key)
);


-- Create the 'reviews' table
CREATE TABLE reviews (
  _key INT AUTO_INCREMENT PRIMARY KEY,
  productKey INT NOT NULL,
  userKey INT NOT NULL,
  comment TEXT,
  FOREIGN KEY (productKey) REFERENCES products(_key),
  FOREIGN KEY (userKey) REFERENCES users(_key)
);

-- Create the 'variations' table
CREATE TABLE variations (
  _key INT AUTO_INCREMENT PRIMARY KEY,
  productKey INT NOT NULL,
  quantity INT NOT NULL,
  sellingPrice FLOAT,
  discountPrice FLOAT,
  offerPrice FLOAT,
  availabilityQuantity INT NOT NULL,
  FOREIGN KEY (productKey) REFERENCES products(_key)
);