import datetime
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
     
    query = "SELECT _key FROM users WHERE contact_info = ?"
    cur.execute(query, (contact_info,))

    user_exists = cur.fetchone() is not None  # Check if a row was returned

    cur.close()
    conn.close() 

    return user_exists


def get_user_for_login(contact_info):
    conn = get_db_connection()
    cur = conn.cursor()

    query = """
        SELECT
            u._key,
            u.password_hash
        FROM users u
        WHERE u.contact_info = ?
    """
    cur.execute(query, (contact_info,))
    user_data = cur.fetchone()
    cur.close()
    conn.close()
    
    if not user_data:
        return None  #

    user_info = {
        '_key': user_data[0],
        'password_hash': user_data[1]
    }
    return user_info


def create_user(username, contact_info, user_type, password):
    """
    Creates a new user in the database.
    """

    conn = get_db_connection()
    cursor = conn.cursor()

    # Hash the password
    hashed_password = generate_password_hash(password)
    current_datetime = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    try:
        cursor.execute(
            """
            INSERT INTO users (
                username, 
                contact_info, 
                password_hash, 
                deviceToken, 
                dob, 
                shopName, 
                phoneNo, 
                profilePic, 
                userType, 
                proprietorName, 
                gst
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (username, contact_info, hashed_password, "", current_datetime, "", "", "", user_type, "", "") 
            )
        conn.commit()
        return True
    except Exception as e:
        return False
    finally:
        cursor.close()
        conn.close()


def get_categories():
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
    
    cursor.close()
    connection.close()

    return results


def search_products_by_name(search_term):
    connection = get_db_connection()
    cursor = connection.cursor()

    search_term = search_term.replace(" ", "").lower()
    # 1. Basic Keyword Matching (Case-Insensitive)
    query = """
        SELECT * FROM products
        WHERE productName LIKE ?
    """
    cursor.execute(query, ('%' + search_term + '%',))
    basic_results = cursor.fetchall()

    # 2. Full-Text Search (FTS) - If available
    fts_results = []
    try:
        query = """
            SELECT * FROM products
            WHERE products MATCH ?
        """
        cursor.execute(query, (search_term,))
        fts_results = cursor.fetchall()
    except sqlite3.OperationalError:
        # FTS might not be enabled; handle gracefully
        pass 

    # 3. Combine and Rank Results (Simple Example)
    keys = []
    seen = set()  # To avoid duplicates
    for key in fts_results + basic_results:
        if key[0] not in seen:  # Assuming product ID is the first column
            keys.append(key[0])
            seen.add(key[0])
            
    matched_product_list = []
    for key in keys:
        matched_product = get_product_from_key({'type': 'product',
                                                'key': key}) 
        matched_product_list += matched_product
    cursor.close()
    connection.close()
    return matched_product_list
    

def get_product_from_category(category):
    connection = get_db_connection()
    cursor = connection.cursor()
    result = get_product_from_key({'type':'category',
                                              'key':category})
    cursor.close()
    connection.close()
    return result


def get_product_from_key(key):  
    '''
    Function to get all information of products by arbitrary key.
    '''
    # Connect to DB
    connection = get_db_connection()
    cursor = connection.cursor()

    # Set key to search
    key_name = 'p' # Default querying by product key
    if key['type'] == 'category':
        key_name = 'c'
        
    # Query to get category details (use JOIN for efficiency)
    query = """
        SELECT p._key, p.productName, p.productDescription, p.productPicture
        FROM categories c
        INNER JOIN product_categories pc ON c._key = pc.category_key
        INNER JOIN products p ON pc.product_key = p._key
        WHERE {key_name}._key = ? """.format(key_name=key_name)
    
    cursor.execute(query, (key['key'],))

    results = []
    for row in cursor.fetchall():
        
        product_data = {
            "_key": row[0],
            "productName": row[1],
            "productDescription": row[2],
            "productPicture": row[3],
            "reviews": [],
            "variations": []
        }
        
        # Query to get list of category that product belongs to
        query = """
            SELECT c._key, c.categoryName, c.categoryPicture
            FROM product_categories pc
            INNER JOIN categories c ON pc.category_key = c._key
            WHERE pc.product_key = ?
        """
        cursor.execute(query, (product_data['_key'],))
        category_data = [
            {
                "_key": row[0],
                "categoryName": row[1],
                "categoryPicture": row[2],
            }
            for row in cursor.fetchall()
        ]

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

    return results

    