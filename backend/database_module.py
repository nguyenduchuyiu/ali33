import datetime
import sqlite3
from flask import jsonify
import threading
import json

import security as sc


# Thread-local storage for database connections
thread_local = threading.local()

def get_db_connection(path='E:/ali33/backend/assets/database/database.db'):
    if not hasattr(thread_local, 'db_conn'):
        thread_local.db_conn = sqlite3.connect(path)
    return thread_local.db_conn


def get_user_by_key(userKey):
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("""
            SELECT  users._key,
                    users.proprietorName,
                    users.deliveryAddress,
                    users.deviceToken,
                    users.dob,
                    users.emailId,
                    users.shopName,
                    users.phoneNo,
                    users.profilePic,
                    users.userType,
                    users.gst
            FROM users
            WHERE users._key = ?
        """, (userKey,))
        user_data = cursor.fetchone()

        if user_data:
            user = {
                "_key": user_data[0],
                "cartItems": [],
                "proprietorName": user_data[1],
                "deliveryAddress": user_data[2],
                "deviceToken": user_data[3],
                "dob": user_data[4],
                "emailId": user_data[5],
                "shopName": user_data[6],
                "orders": [],
                "phoneNo": user_data[7],
                "profilePic": user_data[8],
                "userType": user_data[9],
                "gst": user_data[10]
            }
            cursor.execute("""
                SELECT _key 
                FROM orders
                WHERE userKey = ?
            """, (userKey,))
            orders_data = cursor.fetchall()
            for order in orders_data:
                user["orders"].append(order[0])

            cursor.execute("""
                SELECT productKey, noOfItems, variationQuantity
                FROM cart_items
                WHERE userKey = ?
            """, (userKey,))
            cart_items_data = cursor.fetchall()
            for cart_item in cart_items_data:
                user["cartItems"].append({
                    "productKey": cart_item[0],
                    "noOfItems": cart_item[1],
                    "variationQuantity": cart_item[2]
                })
            return user
        else:
            return None

    except Exception:
        return None
    # finally:
    #     cursor.close()
    #     conn.close()


def is_registered(contact_info):
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        if not contact_info:
            return jsonify({'error': 'Missing contact_info'}), 400

        query = "SELECT _key FROM users WHERE emailId = ?"
        cur.execute(query, (contact_info,))

        user_exists = cur.fetchone() is not None

        return user_exists
    
    finally:
        cur.close()
        conn.close() 


def get_user_for_login(contact_info) -> dict:
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        query = """
            SELECT
                u._key,
                u.hashed_password
            FROM users u
            WHERE u.emailId = ?
        """
        cur.execute(query, (contact_info,))
        user_data = cur.fetchone()

        if not user_data:
            return None

        user_info = {
            '_key': user_data[0],
            'hashed_password': user_data[1]
        }
        return user_info
    finally: 
        cur.close()
        conn.close() 


def create_user(username, contact_info, password):
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Hash the password
        hashed_password = sc.generate_password_hash(password)
        cur_time = int(datetime.datetime.now().timestamp())

        cursor.execute(
            """
            INSERT INTO users (
                hashed_password,
                deliveryAddress,
                deviceToken,
                dob,
                emailId,
                shopName,
                phoneNo,
                profilePic,
                userType,
                proprietorName,
                gst 
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (hashed_password, " ", " ", cur_time, contact_info, " ", " ", " ", " ", username, " ")
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

    try: 
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

        return results

    finally:
        cursor.close()
        connection.close()


def search_products_by_name(search_term):
    connection = get_db_connection()
    cursor = connection.cursor()

    try:
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
        return matched_product_list 

    finally:
        cursor.close()
        connection.close()
        
        

def get_product_from_key(key):
    '''
    Function to get all information of products by arbitrary key.
    '''
    # Connect to DB
    connection = get_db_connection()
    cursor = connection.cursor()

    # Set key to search
    key_name = 'p'  # Default querying by product key
    if key['type'] == 'category':
        key_name = 'c'

    # Query to get category details (use JOIN for efficiency)
    query = """
        SELECT p._key, p.productName, p.productDescription, p.productPicture
        FROM categories c
        INNER JOIN product_categories pc ON c._key = pc.categoryKey
        INNER JOIN products p ON pc.productKey = p._key
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
            INNER JOIN categories c ON pc.categoryKey = c._key
            WHERE pc.productKey = ?
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
        cursor.execute("SELECT userKey, comment FROM Reviews WHERE productKey=?", (product_data["_key"],))
        for review in cursor.fetchall():
            product_data["reviews"].append({
                "userId": review[0],
                "comment": review[1]
            })

        # Query to get variations (using product_data["_key"] directly)
        cursor.execute("SELECT availabilityQuantity, discountPrice, offerPrice, quantity, sellingPrice FROM Variations WHERE productKey=?",
                        (product_data["_key"],))
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


def add_to_cart(cartItems, userKey):
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Check if the item already exists in the cart
        cursor.execute('''
            SELECT 1 
            FROM cart_items 
            WHERE userKey = ? AND productKey = ? AND variationQuantity = ?
        ''', (userKey, cartItems['productKey'], cartItems['variationQuantity']))

        item_exists = cursor.fetchone()

        if item_exists:
            # If item exists, increment noOfItems
            cursor.execute('''
                UPDATE cart_items 
                SET noOfItems = noOfItems + ? 
                WHERE userKey = ? AND productKey = ? AND variationQuantity = ?
            ''', (cartItems['noOfItems'], userKey, cartItems['productKey'], cartItems['variationQuantity']))
        else:
            # If item doesn't exist, insert a new row
            cursor.execute('''
                INSERT INTO cart_items (userKey, productKey, noOfItems, variationQuantity)
                VALUES (?, ?, ?, ?)
            ''', (userKey, cartItems['productKey'], cartItems['noOfItems'], cartItems['variationQuantity']))

        conn.commit()  # Commit changes within the try block
        return True

    except sqlite3.Error as e:
        print(f"An error occurred: {e}")
        conn.rollback()
        return False
    finally:
        cursor.close()
        conn.close()


def remove_from_cart(cartItems: list[dict], userKey: int) -> bool:
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Directly decrease the quantity 
        for cartItem in cartItems:
            cursor.execute('''
                UPDATE cart_items 
                SET noOfItems = noOfItems - ? 
                WHERE userKey = ? AND productKey = ? AND variationQuantity = ?
            ''', (cartItem['noOfItems'], userKey, cartItem['productKey'], cartItem['variationQuantity']))

            # If the quantity becomes zero or negative, delete the item
            cursor.execute('''
                DELETE FROM cart_items 
                WHERE userKey = ? AND productKey = ? AND variationQuantity = ? AND noOfItems <= 0
            ''', (userKey, cartItem['productKey'], cartItem['variationQuantity']))

        conn.commit() # Commit changes within the try block
        return True

    except sqlite3.Error as e:
        print(f"An error occurred: {e}")
        conn.rollback()
        return False
    finally:
        cursor.close()
        conn.close() 
  
 
def change_no_of_product_in_cart(data: dict, userKey: int) -> bool:
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        old_product_key = data['old']['productKey']
        old_variation_quantity = data['old']['variationQuantity']

        new_product_key = data['new']['productKey']
        new_variation_quantity = data['new']['variationQuantity']
        new_no_of_items = data['new']['noOfItems']

        # First, try to update the existing item with the new values
        cursor.execute('''
            UPDATE cart_items 
            SET productKey = ?, variationQuantity = ?, noOfItems = ?
            WHERE userKey = ? AND productKey = ? AND variationQuantity = ?
        ''', (new_product_key, new_variation_quantity, new_no_of_items,
              userKey, old_product_key, old_variation_quantity))

        # If no rows were updated, it means the old item doesn't exist, so insert the new one
        if cursor.rowcount == 0:
            cursor.execute('''
                INSERT INTO cart_items (userKey, productKey, noOfItems, variationQuantity)
                VALUES (?, ?, ?, ?)
            ''', (userKey, new_product_key, new_no_of_items, new_variation_quantity))

        conn.commit()  # Commit changes
        return True

    except sqlite3.Error as e:
        print(f"An error occurred: {e}")
        conn.rollback()
        return False
    finally:
        cursor.close()
        conn.close()


def place_order(orders: list, user_key: int) -> dict:
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        for order in orders['orders']:
            delivery_address = order['deliveryAddress']
            delivery_stages = ','.join(order['deliveryStages'])  # Storing as comma-separated
            ordered_date = order['orderedDate']
            paid_price = order['paidPrice']
            payment_status = order['paymentStatus']
            product_key = order['productDetails']['productKey']
            no_of_items = order['productDetails']['noOfItems']
            variation_quantity = order['productDetails']['variationQuantity']

            cursor.execute("""
                INSERT INTO orders (userKey, deliveryAddress, deliveryStages, orderedDate, 
                                   paidPrice, paymentStatus, productKey, noOfItems, 
                                   variationQuantity)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (user_key, delivery_address, delivery_stages, ordered_date, paid_price,
                  payment_status, product_key, no_of_items, variation_quantity))
        conn.commit()  # Commit changes
        return {"result": True,
                "message": "Successful"}

    except sqlite3.Error as e:
        print(f"An error occurred: {e}")
        conn.rollback()
        return {"result": False,
                "message": e}
    finally:
        cursor.close()
        conn.close() 
    
# def get_cart_items(userKey:int) -> list[dict]:
#     conn = get_db_connection()
#     cursor = conn.cursor()

#     try:
#         cursor.execute('''
#             SELECT * FROM cart_items WHERE userKey = ?
#         ''', (userKey,)) 

#         cart_items = cursor.fetchall()
#         return cart_items

#     except sqlite3.Error as e:
#         print(f"An error occurred: {e}")
#         return None 
    