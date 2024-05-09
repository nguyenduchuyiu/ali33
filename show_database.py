'''

Print all database

'''
import sqlite3
from flask import jsonify
import threading

thread_local = threading.local()

def get_db_connection(path='backend/assets/database/database.db'):
    if not hasattr(thread_local, 'db_conn'):
        thread_local.db_conn = sqlite3.connect(path)
    return thread_local.db_conn

def print_all_tables():
    """Prints the contents of all tables in the database."""
    conn = get_db_connection()
    cursor = conn.cursor()

    # Get a list of all tables
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = cursor.fetchall()

    for table_name in tables:
        table_name = table_name[0]  # Extract table name from tuple

        # Get column names
        cursor.execute(f"PRAGMA table_info({table_name});")
        column_names = [column_info[1] for column_info in cursor.fetchall()]

        # Fetch data for the table
        cursor.execute(f"SELECT * FROM {table_name};")
        table_data = cursor.fetchall()

        # Print table name and column names
        print("-" * 30)
        print(f"Table: {table_name}")
        print("-" * 30)
        print(f"Columns: {', '.join(column_names)}")

        # Print each row of data
        for row in table_data:
            print(row)

    cursor.close()

# Example usage:
print_all_tables()