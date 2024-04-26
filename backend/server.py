from flask import Flask, request, jsonify
from flask_cors import CORS
from security import check_password, create_jwt_token
from database_module import get_user, is_registered, create_user
from dotenv import load_dotenv
load_dotenv('backend\key.env')

app = Flask(__name__)
CORS(app)

''' 
Check if a user exists in database.
'''
@app.route('/users/check_user', methods=['POST'])
def check_register():
    data = request.get_json()
    contact_info = data.get('userId')
    
    if not contact_info:
        return jsonify({'error': 'Missing email or phone'}), 400
    
    user_exists = is_registered(contact_info)
    
    return jsonify({'result': user_exists}), 200
    
    
'''
Processing a login request.
'''
@app.route('/users/login', methods=['POST'])
def authenticate_user():
    data = request.get_json()
    contact_info = data.get('userId')
    password = data.get('password')
    if not contact_info or not password:
        return jsonify({'error': 'Missing email or password'}), 400

    user = get_user(contact_info) 

    if not check_password(user, password):
        return jsonify({'error': 'Invalid credentials'}), 401
    token = create_jwt_token(user['id'])

    return jsonify({'token': token}), 200


'''
Processing a signup request.
'''
@app.route('/users/signup', methods=['POST'])
def sign_up():
    data = request.get_json()
    username = data.get('username')
    contact_info = data.get('userId')
    info_type = data.get('type')
    password = data.get('password')
    
    if not username or not contact_info or not type or not password:
        return jsonify({'error': 'Missing required fields'}), 400

    success = create_user(username, contact_info, info_type, password)
    
    if success:
        return jsonify({'message': 'User created successfully'}), 201
    else:
        return jsonify({'error': 'Failed to create user'}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)