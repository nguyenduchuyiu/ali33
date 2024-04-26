-- Create the 'users' table
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    contact_info TEXT NOT NULL UNIQUE,
    info_type TEXT NOT NULL, 
    password_hash TEXT NOT NULL
);
