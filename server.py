from flask import Flask, request, jsonify
from flask_cors import CORS
import jwt
import datetime

app = Flask(__name__)
CORS(app)

@app.route('/users/check_user', methods=['POST'])
def check_register():
    data = request.get_json()
    userId = data.get('userId')
    type = data.get('type')
    if not userId or not type:
        return jsonify({'error': 'Missing userId or type'}), 400
    # Replace with actual validation logic (e.g., database query)
    if userId == 'h@g.c' and type == 'email':
        return jsonify({'result': True}), 200
    else:
        return jsonify({'result': False}), 200

@app.route('/users/login', methods=['POST'])

# def create_jwt_token(user_id):
#     payload = {
#         'user_id': user_id,
#         'exp': datetime.datetime.now() + datetime.timedelta(minutes=30)  # Thời gian hết hạn
#     }
#     secret_key = 'your_secret_key'  # Thay thế bằng secret key của bạn
#     token = jwt.encode(payload, secret_key, algorithm='HS256')
#     return token.decode('utf-8')

def check_login():
    data = request.get_json()
    email = data.get('userId')
    password = data.get('password')

    if not email or not password:
        return jsonify({'error': 'Missing email or password'}), 400

    if not email == 'h@g.c' or not password == 'qwerty':
        return jsonify({'error': 'Invalid credentials'}), 401

    # Tạo token JWT (cần cài đặt thư viện PyJWT)
    # token = create_jwt_token(user.id)
    token = 'hahaha'
    return jsonify({'authToken': token}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)