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


def get_all_category():
    # Connect to DB
    connection = get_db_connection()
    cursor = connection.cursor()
    
    # Query to get category details
    cursor.execute("SELECT * FROM categories")
    category_details = cursor.fetchall()
    
    # List to hold the results
    results = []
    
    for category_detail in category_details:
        category_data = {
            "_key": category_detail[0],
            "categoryName": category_detail[1],
            "categoryPicture": category_detail[2]
        }
        results.append(category_data)
    return jsonify({'result': results})


def get_category_from_product(product_key):
    # Connect to DB
    connection = get_db_connection()
    cursor = connection.cursor()

    # Query to get category keys for the given product
    cursor.execute("""
        SELECT c._key
        FROM Categories c
        INNER JOIN product_categories pc ON c._key = pc.category_key
        WHERE pc.product_key = ?
    """, (product_key,))

    category_keys = [row[0] for row in cursor.fetchall()]  # Extract category keys

    return category_keys  # Return a list of category keys
    


def get_product_from_category(category_key):  # Use category_key for consistency
    # Connect to DB
    connection = get_db_connection()
    cursor = connection.cursor()

    # Query to get category details (use JOIN for efficiency)
    cursor.execute("""
        SELECT c._key, c.categoryName, c.categoryPicture, 
               p._key, p.productName, p.productDescription, p.productPicture
        FROM categories c
        INNER JOIN product_categories pc ON c._key = pc.category_key
        INNER JOIN products p ON pc.product_key = p._key
        WHERE c._key = ?
    """, (category_key,))

    results = []
    for row in cursor.fetchall():
        category_data = {
            "_key": row[0],
            "categoryName": row[1],
            "categoryPicture": row[2]
        }

        product_data = {
            "_key": row[3],
            "productCategoryId": get_category_from_product(row[3]),
            "productName": row[4],
            "productDescription": row[5],
            "productPicture": row[6],
            "reviews": [],
            "variations": []
        }

        # Query to get reviews (using product_data["_key"] directly)
        cursor.execute("SELECT userId, comment FROM Reviews WHERE productKey=?", (product_data["_key"],))
        for review in cursor.fetchall():
            product_data["reviews"].append({
                "userId": review[0],
                "comment": review[1]
            })

        # Query to get variations (using product_data["_key"] directly)
        cursor.execute("SELECT availabilityQuantity, discountPrice, offerPrice, quantity, sellingPrice FROM Variations WHERE productKey=?", (product_data["_key"],))
        for variation in cursor.fetchall():
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

    return jsonify({'result': results})