import sqlite3
from flask import jsonify
import threading
import json

from security import generate_password_hash


# Thread-local storage for database connections
thread_local = threading.local()

def get_db_connection(path='backend/assets/database/database.db'):
    if not hasattr(thread_local, 'db_conn'):
        thread_local.db_conn = sqlite3.connect(path)
    return thread_local.db_conn

def is_registered(contact_info):
    conn = get_db_connection()
    cur = conn.cursor()
    
    if not contact_info:
        return jsonify({'error': 'Missing contact_info'}), 400
     
    query = "SELECT id FROM users WHERE contact_info = ?"
    cur.execute(query, (contact_info,))

    user_exists = cur.fetchone() is not None  # Check if a row was returned

    conn.close() 

    return user_exists


def get_user(contact_info):
    """
    Retrieves user information from the MySQL database based on the given contact info.
    """
    conn = get_db_connection()
    cur = conn.cursor() 
    query = "SELECT * FROM users WHERE contact_info = ?"
    cur.execute(query, (contact_info,)) 
    user_data = cur.fetchone()
    conn.close()
    if user_data:
        return {
            'id': user_data[0],
            'username': user_data[1],
            'password_hash': user_data[4]
        }
    else:
        return None 


def create_user(username, contact_info, info_type, password):
    """
    Creates a new user in the database.
    """

    conn = get_db_connection()
    cursor = conn.cursor()

    # Hash the password
    hashed_password = generate_password_hash(password)

    try:
        cursor.execute(
            "INSERT INTO users (username, contact_info, info_type, password_hash) VALUES (?, ?, ?, ?)",
            (username, contact_info, info_type, hashed_password),
        )
        conn.commit()
        return True
    except Exception:
        return False
    finally:
        cursor.close()


# def get_product_data(category):
#     # Replace with your actual logic to retrieve product data based on product_id
#     # This could involve database queries, API calls, etc.
#     # For this example, we'll return a sample product
#     return { 'result': [{
#             "categoryDetails": {
#                 "_key": "cat_123",
#                 "categoryName": "Electronics",
#                 "categoryPicture": "http://127.0.0.1:5000/static/images/20"
#             },
#             "productDetails": {
#                 "_key": "prod_456",
#                 "productCategoryId": "cat_123",
#                 "productDescription": "A high-quality smartphone with advanced features.",
#                 "productName": "Smartphone X",
#                 "productPicture": "http://127.0.0.1:5000/static/images/iphone11promax.png",
#                 "reviews": [
#                 {
#                     "comment": "Great phone!",
#                     "userId": "user_789"
#                 },
#                 {
#                     "comment": "Excellent camera quality.",
#                     "userId": "user_012"
#                 }
#                 ],
#                 "variations": [
#                 {
#                     "availabilityQuantity": 10,
#                     "discountPrice": 0,
#                     "offerPrice": 999,
#                     "quantity": 1,
#                     "sellingPrice": 1099
#                 },
#                 {
#                     "availabilityQuantity": 5,
#                     "discountPrice": 50,
#                     "offerPrice": 1449,
#                     "quantity": 2,
#                     "sellingPrice": 1599
#                 }
#                 ]
#             }
#         },
#                 {
#                 "categoryDetails": {
#                     "_key": "cat_456",
#                     "categoryName": "Home Appliances",
#                     "categoryPicture": "http://127.0.0.1:5000/static/images/20"
#                 },
#                 "productDetails": {
#                     "_key": "prod_789",
#                     "productCategoryId": "cat_456",
#                     "productDescription": "A modern refrigerator with ample storage space and energy-efficient features.",
#                     "productName": "Refrigerator Z",
#                     "productPicture": "http://127.0.0.1:5000/static/images/refrigerator.png",
#                     "reviews": [
#                     {
#                         "comment": "Keeps food fresh for a long time!",
#                         "userId": "user_321"
#                     },
#                     {
#                         "comment": "Spacious and well-designed.",
#                         "userId": "user_654"
#                     }
#                     ],
#                     "variations": [
#                     {
#                         "availabilityQuantity": 8,
#                         "discountPrice": 100,
#                         "offerPrice": 1999,
#                         "quantity": 1,
#                         "sellingPrice": 2099
#                     },
#                     {
#                         "availabilityQuantity": 3,
#                         "discountPrice": 250,
#                         "offerPrice": 3749,
#                         "quantity": 2,
#                         "sellingPrice": 3999
#                     }
#                     ]
#                 }
#                 },
#                 {
#                 "categoryDetails": {
#                     "_key": "cat_456",
#                     "categoryName": "Home Appliances",
#                     "categoryPicture": "http://127.0.0.1:5000/static/images/"
#                 },
#                 "productDetails": {
#                     "_key": "prod_789",
#                     "productCategoryId": "cat_456",
#                     "productDescription": "A modern refrigerator with ample storage space and energy-efficient features.",
#                     "productName": "Hieu's Crush",
#                     "productPicture": "http://127.0.0.1:5000/static/images/lover.png",
#                     "reviews": [
#                     {
#                         "comment": "Keeps food fresh for a long time!",
#                         "userId": "user_321"
#                     },
#                     {
#                         "comment": "Spacious and well-designed.",
#                         "userId": "user_654"
#                     }
#                     ],
#                     "variations": [
#                     {
#                         "availabilityQuantity": 8,
#                         "discountPrice": 100,
#                         "offerPrice": 9999999999999999999,
#                         "quantity": 52,
#                         "sellingPrice": 2099
#                     },
#                     {
#                         "availabilityQuantity": 3,
#                         "discountPrice": 250,
#                         "offerPrice": 3749,
#                         "quantity": 2,
#                         "sellingPrice": 3999
#                     }
#                     ]
#                 }
#                 }]
#     }



def get_product_data(category):
    # Connect to DB
    connection = get_db_connection()
    cursor = connection.cursor()
    
    # Query to get category details
    cursor.execute("SELECT _key, categoryName, categoryPicture FROM Categories WHERE _key=?", (category,))
    category_details = cursor.fetchall()
    
    # List to hold the results
    results = []
    
    for category_detail in category_details:
        category_data = {
            "_key": category_detail[0],
            "categoryName": category_detail[1],
            "categoryPicture": category_detail[2]
        }
        
        # Query to get product details
        cursor.execute("SELECT _key, productCategoryId, productName, productDescription, productPicture FROM Products WHERE productCategoryId=?", (category_data["_key"],))
        product_details = cursor.fetchall()
        
        for product_detail in product_details:
            product_data = {
                "_key": product_detail[0],
                "productCategoryId": product_detail[1],
                "productDescription": product_detail[2],
                "productName": product_detail[3],
                "productPicture": product_detail[4],
                "reviews": [],
                "variations": []
            }
            
            # Query to get reviews
            cursor.execute("SELECT userId, comment FROM Reviews WHERE productKey=?", (product_data["_key"],))
            reviews = cursor.fetchall()
            for review in reviews:
                product_data["reviews"].append({
                    "userId": review[0],
                    "comment": review[1]
                })
            
            # Query to get variations
            cursor.execute("SELECT availabilityQuantity, discountPrice, offerPrice, quantity, sellingPrice FROM Variations WHERE productKey=?", (product_data["_key"],))
            variations = cursor.fetchall()
            for variation in variations:
                product_data["variations"].append({
                    "availabilityQuantity": variation[0],
                    "discountPrice": variation[1],
                    "offerPrice": variation[2],
                    "quantity": variation[3],
                    "sellingPrice": variation[4]
                })
            
            results.append({
                "categoryDetails": category_data,
                "productDetails": product_data
            })
    
    # Close connection
    connection.close()
    
    # Return the result as json
    return jsonify({'result': results })

# Example use:
# print(get_product_data('Electronics')) # Pass the category name as parameter