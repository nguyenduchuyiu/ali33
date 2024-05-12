import datetime
import os

import bcrypt
import jwt


def create_jwt_token(user_id, expires_in_minutes=30):
    """
    Creates a JWT token with the given user ID and expiration time.

    Args:
        user_id (str): The user ID to include in the token payload.
        expires_in_minutes (int, optional): The expiration time of the token in minutes. Defaults to 30.

    Returns:
        str: The encoded JWT token.

    Raises:
        ValueError: If there is an error creating the token.
    """

    try:
        payload = {
            'user_id': user_id,
            'exp': datetime.datetime.now() + datetime.timedelta(minutes=expires_in_minutes)
        }
        secret_key = 'Huy'

        if not secret_key:
            raise ValueError("Secret key not found in environment variables.")
        token = jwt.encode(payload, secret_key, algorithm='HS256')
        
        return token
    except Exception as e:
        raise ValueError("Error creating JWT token") from e
    
 
def check_password(user, password):
    """
    Check password with the given user info and password.

    Args:
        user (dict): The user info.
        password (string): The password entered by user.

    Returns:
        bool: Password is correct or not.
    """
    if not user or not bcrypt.checkpw(password.encode('utf-8'), user['password_hash']):
        return False
    return True


def generate_password_hash(password):
    """
    Hash password with the given password.

    Args:
        password (string): The password entered by user.

    Returns:
        bytes: Hash password.
    """
    salt = bcrypt.gensalt()
    return bcrypt.hashpw(password.encode('utf-8'), salt)