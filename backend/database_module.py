import datetime
import sqlite3
from flask import jsonify
import threading
import mysql.connector
import security as sc
import configparser


# initiate
config = configparser.ConfigParser()
config.read('backend/config.ini')

thread_local = threading.local()

def get_db_connection():
    """Connects to the specified AWS database using environment variables."""
    if not hasattr(thread_local, 'db_conn'):
        thread_local.db_conn = mysql.connector.connect(
            host=config.get('database', 'host'),
            user=config.get('database', 'user'),
            password=config.get('database', 'password'),
            database=config.get('database', 'database')
        )
    return thread_local.db_conn



# def get_db_connection(path='E:/ali33/backend/assets/database/database.db'):
#     if not hasattr(thread_local, 'db_conn'):
#         thread_local.db_conn = sqlite3.connect(path)
#     return thread_local.db_conn



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
            WHERE users._key = %s
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
                WHERE userKey = %s
            """, (userKey,))
            orders_data = cursor.fetchall()
            for order in orders_data:
                user["orders"].append(order[0])

            cursor.execute("""
                SELECT productKey, noOfItems, variationQuantity
                FROM cart_items
                WHERE userKey = %s
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

        query = "SELECT _key FROM users WHERE emailId = %s"
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
            WHERE u.emailId = %s
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
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
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
        # 1. Full-Text Search (FTS) - If available
        fts_results = []
        try:
            query = """
            SELECT _key FROM products
            WHERE MATCH(product_name, description) AGAINST (%s IN NATURAL LANGUAGE MODE)
            LIMIT 5
            """
            cursor.execute(query, (search_term,))
            fts_results = cursor.fetchall()
        except mysql.connector.errors.ProgrammingError:
            # FTS might not be enabled or table doesn't have FTS index; handle gracefully
            pass

        # 2. Basic Keyword Matching (Case-Insensitive)
        search_term_like = '%' + search_term.lower() + '%'
        query = """
            SELECT _key FROM products
            WHERE lower(productName) LIKE %s
            LIMIT 5
        """
        cursor.execute(query, (search_term_like,))
        basic_results = cursor.fetchall()

        # 3. Combine and De-duplicate Results
        all_results = fts_results + basic_results
        unique_results = list(set(all_results))

        # 4. Fetch Product Details 
        matched_product_list = []
        for result in unique_results:
            product_id = result[0]
            matched_product = get_product_from_key({'type': 'product', 'key': product_id})
            matched_product_list.extend(matched_product)  # Use extend to add items from a list

        return matched_product_list

    finally:
        cursor.close()
        connection.close()
        
        
def get_product_of_category(category) -> list:
    # Connect to DB
    connection = get_db_connection()
    cursor = connection.cursor()

    query = """
        SELECT pc.productKey
        FROM product_categories pc
        WHERE pc.categoryKey = %s 
        LIMIT 8
    """
    cursor.execute(query, (category,))
    productKeys = []
    for row in cursor.fetchall():
        productKeys.append(row[0])
    cursor.close()
    connection.close()
    return productKeys


def get_product_from_key(keys:list) -> list:
    # Connect to DB
    connection = get_db_connection()
    cursor = connection.cursor()
    results = []
    for key in keys:
        query = """
            SELECT p._key, p.productName, p.productDescription, p.productPicture, p.productRating
            FROM products p
            WHERE p._key = %s 
        """
        cursor.execute(query, (key,))
        
        for row in cursor.fetchall(): # key is unique

            product_data = {
                "_key": row[0],
                "productName": row[1],
                "productDescription": row[2],
                "productPicture": row[3],
                "productRating": row[4],
                "reviews": [],
                "variations": []
            }

            # Query to get list of category that product belongs to
            query = """
                SELECT c._key, c.categoryName, c.categoryPicture
                FROM product_categories pc
                INNER JOIN categories c ON pc.categoryKey = c._key
                WHERE pc.productKey = %s
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
            cursor.execute("SELECT userKey, comment FROM reviews WHERE productKey=%s", (product_data["_key"],))
            for review in cursor.fetchall():
                product_data["reviews"].append({
                    "userId": review[0],
                    "comment": review[1]
                })

            # Query to get variations (using product_data["_key"] directly)
            cursor.execute("SELECT availabilityQuantity, discountPrice, offerPrice, quantity, sellingPrice FROM variations WHERE productKey=%s",
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
            WHERE userKey = %s AND productKey = %s AND variationQuantity = %s
        ''', (userKey, cartItems['productKey'], cartItems['variationQuantity']))

        item_exists = cursor.fetchone()

        if item_exists:
            # If item exists, increment noOfItems
            cursor.execute('''
                UPDATE cart_items 
                SET noOfItems = noOfItems + %s 
                WHERE userKey = %s AND productKey = %s AND variationQuantity = %s
            ''', (cartItems['noOfItems'], userKey, cartItems['productKey'], cartItems['variationQuantity']))
        else:
            # If item doesn't exist, insert a new row
            cursor.execute('''
                INSERT INTO cart_items (userKey, productKey, noOfItems, variationQuantity)
                VALUES (%s, %s, %s, %s)
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
                SET noOfItems = noOfItems - %s 
                WHERE userKey = %s AND productKey = %s AND variationQuantity = %s
            ''', (cartItem['noOfItems'], userKey, cartItem['productKey'], cartItem['variationQuantity']))

            # If the quantity becomes zero or negative, delete the item
            cursor.execute('''
                DELETE FROM cart_items 
                WHERE userKey = %s AND productKey = %s AND variationQuantity = %s AND noOfItems <= 0
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
            SET productKey = %s, variationQuantity = %s, noOfItems = %s
            WHERE userKey = %s AND productKey = %s AND variationQuantity = %s
        ''', (new_product_key, new_variation_quantity, new_no_of_items,
              userKey, old_product_key, old_variation_quantity))

        # If no rows were updated, it means the old item doesn't exist, so insert the new one
        if cursor.rowcount == 0:
            cursor.execute('''
                INSERT INTO cart_items (userKey, productKey, noOfItems, variationQuantity)
                VALUES (%s, %s, %s, %s)
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
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
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
    

def get_orders_of_user(userKey) -> dict[str, any]:
    conn = get_db_connection()  
    cursor = conn.cursor()

    cursor.execute("""
        SELECT 
            _key, productKey, orderedDate, paidPrice, paymentStatus, 
            deliveryStages, deliveryAddress, noOfItems, variationQuantity
        FROM orders 
        WHERE userKey = %s
    """, (userKey,))

    orders = []
    for row in cursor.fetchall():
        order = {
            '_key': row[0],
            'productKey': row[1],
            'orderedDate': row[2],
            'paidPrice': row[3],
            'paymentStatus': row[4],
            'deliveryStages': row[5].split(","), 
            'deliveryAddress': row[6],
            'noOfItems': row[7],
            'variationQuantity': row[8],
        }
        orders.append(order)

    return orders

    # finally:
    #     cursor.close()
    #     conn.close()
        
        
# def get_cart_items(userKey:int) -> list[dict]:
#     conn = get_db_connection()
#     cursor = conn.cursor()

#     try:
#         cursor.execute('''
#             SELECT * FROM cart_items WHERE userKey = %s
#         ''', (userKey,)) 

#         cart_items = cursor.fetchall()
#         return cart_items

#     except sqlite3.Error as e:
#         print(f"An error occurred: {e}")
#         return None 
    