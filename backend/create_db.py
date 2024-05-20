import sqlite3

def create_db(db_file="backend/assets/database/database.db", sql_file="backend/assets/database/database.sql"):
    conn = sqlite3.connect(db_file)
    cursor = conn.cursor()

    # Read SQL statements from the file
    with open(sql_file, 'r') as file:
        sql_script = file.read()
        print(sql_script)

    # Execute each SQL statement
    for statement in sql_script.split(';'):
        if statement.strip():
            cursor.execute(statement)
            print(statement)

    conn.commit()
    conn.close()

# Create the database file
create_db()