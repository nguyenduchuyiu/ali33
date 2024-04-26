import sqlite3
from flask import jsonify
import threading

from security import generate_password_hash


# Thread-local storage for database connections
thread_local = threading.local()

def get_db_connection(path='backend/database.db'):
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

