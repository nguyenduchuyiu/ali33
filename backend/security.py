import datetime
import bcrypt
import jwt
import configparser
import os

# initiate
config = configparser.ConfigParser()
config.read(os.path.abspath('config.ini'))
SECRET_KEY = config.get('key', 'key')




def decode_jwt_token(token, secret_key=SECRET_KEY) -> bool:
    """
    Decodes a JWT token and checks if it's expired.

    Args:
        token: The JWT token to decode.
        secret_key: The secret key used to encode the token.

    Returns:
        The decoded payload of the token if it's not expired.

    Raises:
        ValueError: If the token is invalid, the secret key is not provided, or the token is expired.
    """
    try:
        if not secret_key:
            raise ValueError("Secret key not found.")
        payload = jwt.decode(token, secret_key, algorithms=['HS256'])
        
        # Check if the 'exp' (expiration) claim exists
        if 'exp' and 'userKey' in payload:
            expiration_timestamp = payload['exp']
            now = datetime.datetime.now().timestamp()
            if now >= expiration_timestamp:
                # raise ValueError("JWT token is expired")
                return None
        else:
            return None
            # raise ValueError("JWT token does not contain correct info.")

        return payload['userKey']
    except jwt.exceptions.DecodeError:
        return None
        # raise ValueError("Invalid JWT token")
    except Exception as e:
        return None
        # raise ValueError("Error decoding JWT token") from e


def create_jwt_token(userKey, expires_in_minutes=30):
    try:
        payload = {
            'userKey': userKey,
            'exp': datetime.datetime.now() + datetime.timedelta(minutes=expires_in_minutes)
        }

        if not SECRET_KEY:
            raise ValueError("Secret key not found in environment variables.")
        token = jwt.encode(payload, SECRET_KEY, algorithm='HS256')
        
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
    if not user or not bcrypt.checkpw(password.encode('utf-8'), bytes(user['hashed_password'])):
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

