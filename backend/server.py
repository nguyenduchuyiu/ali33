from flask import Flask, request, jsonify
from flask_cors import CORS
import security as sc
import database_module as dm 
import rcm_model as rcm

app = Flask(__name__)
CORS(app)


@app.route('/users/address')
def get_address():
    return jsonify({'result': ['Ha Noi', 'Bac Giang']})


@app.route('/users/check_user', methods=['POST'])
def check_register():
    data = request.get_json()
    contact_info = data.get('userId')
    
    if not contact_info:
        return jsonify({'error': 'Missing email or phone'}), 400
    
    user_exists = dm.is_registered(contact_info)
    
    return jsonify({'result': user_exists}), 200
    
    
'''
Processing a login request.
'''
@app.route('/users/login', methods=['POST'])
def login():
    data = request.get_json()
    contact_info = data.get('userId')
    password = data.get('password')
    if not contact_info or not password:
        return jsonify({'error': 'Missing email or password'}), 400

    user = dm.get_user_for_login(contact_info) 

    if not sc.check_password(user, password):
        return jsonify({'error': 'Invalid credentials'}), 401
    
    token = sc.create_jwt_token(user['_key'])

    return jsonify({'token': token}), 200


'''
Processing a signup request.
'''
@app.route('/users/signup', methods=['POST'])
def sign_up():
    data = request.get_json()
    username = data.get('username')
    contact_info = data.get('userId')
    password = data.get('password')
    
    if not username or not contact_info or not type or not password:
        return jsonify({'error': 'Missing required fields'}), 400

    success = dm.create_user(username, contact_info, password)
    
    if success:
        return jsonify({'message': 'User created successfully'}), 201
    else:
        return jsonify({'error': 'Failed to create user'}), 400
    


@app.route('/users/get-current-user', methods=['GET'])
def getCurrentUser():
    auth_header = request.headers.get('Authorization')
    if not auth_header:
        return jsonify({"error": "Authorization header missing"}), 401
    userKey = sc.decode_jwt_token(token=auth_header)
    if userKey is None:
        return jsonify({"error": "Session expired"}), 404
    user = dm.get_user_by_key(userKey)
        
    if user is not None:
        return jsonify({'result': user}), 200
    
    return jsonify({'error':'User not found'}), 404


@app.route('/products/get-product-from-keys')
def get_product_by_keys():
    productKeys:list = [int(key) for key in request.args.get('key').split(',')]
    print(productKeys)
    
    if not productKeys:
        return jsonify({"error": "productKeys are required"}), 400
    
    products:list = dm.get_product_from_key(productKeys)  # Adapt to fetch by category
    
    if products:
        return jsonify({'result':products}), 200
    else:
        return jsonify({"error": "No product was found!"}), 404


@app.route('/products/get-products-from-category')
def get_products_by_category():
    category = request.args.get('category')
    
    if not category:
        return jsonify({"error": "Category parameter is required"}), 400
    
    productKeys = dm.get_product_of_category(category)  # Adapt to fetch by category
    
    if productKeys:
        return jsonify({'result':productKeys}), 200
    else:
        return jsonify({"error": "Products not found for the given category"}), 404
    
    
@app.route('/products/get-all-categories')
def get_all_categories(): 
    category_data_list = dm.get_categories()
    
    if category_data_list:
        return jsonify({'result': category_data_list}), 200
    else:
        return jsonify({"error": "Categories not found"}), 404


@app.route('/products/search-product')
def search_product():
    search_term = request.args.get('searchTerm')
    if not search_term:
        return jsonify({"error": "Search term parameter is required"}), 400
    
    product_data_list:list = dm.search_products_by_name(search_term) 
    
    if product_data_list:
        return jsonify({'result':product_data_list}), 200
    else:
        return jsonify({"error": "Product not found"}), 404


@app.route('/users/add-to-cart', methods=['POST'])
def addToCart():
    data = request.get_json()
    cartItems = data['cartItems']
    auth_header = request.headers.get('Authorization')
    if not auth_header:
        return jsonify({"error": "Authorization header missing"}), 401
    userKey = sc.decode_jwt_token(token=auth_header)
    if userKey is None:
        return jsonify({"error": "Session expired"}), 404
    
    if dm.add_to_cart(cartItems, userKey):
        return jsonify({"result": "Successfully add to your cart"}), 200
    return jsonify({"error":"Failure adding to your cart"}), 400
   
   
    
@app.route('/users/remove-from-cart', methods=['DELETE'])
def removeFromCart():
    data = request.get_json()
    cartItems:list = data['cartItems']
    auth_header = request.headers.get('Authorization')
    if not auth_header:
        return jsonify({"error": "Authorization header missing"}), 401
    userKey = sc.decode_jwt_token(token=auth_header)
    if userKey is None:
        return jsonify({"error": "Session expired"}), 404
    
    if dm.remove_from_cart(cartItems, userKey):
        return jsonify({"result": "Successfully remove from your cart"}), 200
    return jsonify({"error":"Failure removing from your cart"}), 400
    # return jsonify({"result": data})



@app.route('/users/change-no-of-product-in-cart', methods=['PUT'])
def changeNoOfProductInCart():
    data = request.get_json()
    auth_header = request.headers.get('Authorization')
    if not auth_header:
        return jsonify({"error": "Authorization header missing"}), 401
    userKey = sc.decode_jwt_token(token=auth_header)
    if userKey is None:
        return jsonify({"error": "Session expired"}), 404
    
    if dm.change_no_of_product_in_cart(data, userKey):
        return jsonify({"result": "Successfully change number of product in your cart"}), 200
    return jsonify({"error":"Failure changing number of product in your cart"}), 400



@app.route('/users/get-cart-items', methods=['GET'])
def getCartItems():
    auth_header = request.headers.get('Authorization')
    if not auth_header:
        return jsonify({"error": "Authorization header missing"}), 401
    userKey = sc.decode_jwt_token(token=auth_header)
    if userKey is None:
        return jsonify({"error": "Session expired"}), 404
    
    user = dm.get_user_by_key(userKey)
    cartModels = []
    for item in user['cartItems']:
        product = dm.get_product_from_key([item["productKey"]])
        cartModels.append({"cartItemDetails": item,
                          "productDetails": product[0]["productDetails"]})
    if user:
        return jsonify({"result": {
                            "userDetails": user,
                            "cartModels": cartModels
                            }}), 200
    
    return jsonify({"error":"Cart items not found"}), 404



@app.route('/orders/place-order', methods=['POST'])
def placeOrder():
    orders:list = request.get_json()
    auth_header = request.headers.get('Authorization')
    if not auth_header:
        return jsonify({"error": "Authorization header missing"}), 401
    userKey = sc.decode_jwt_token(token=auth_header)
    if userKey is None:
        return jsonify({"error": "Session expired"}), 404
    
    placeOrder = dm.place_order(orders, userKey)
    if placeOrder["result"]:
        return jsonify({"result":"Successfully place order"}), 200
    return jsonify({"result": placeOrder["message"]}), 400
    
   
@app.route('/users/get-all-orders', methods=['GET'])
def getAllOrders():
    auth_header = request.headers.get('Authorization')
    if not auth_header:
        return jsonify({"error": "Authorization header missing"}), 401
    userKey = sc.decode_jwt_token(token=auth_header)
    if userKey is None:
        return jsonify({"error": "Session expired"}), 404
    
    orders = dm.get_orders_of_user(userKey)
    orderCombinedModel = []
    
    for order in orders:
        product = dm.get_product_from_key([order["productKey"]])
        
        orderCombinedModel.append(
            {
            "orderModel": 
                {
                    "_key": order["_key"],
                    "orderedDate": order["orderedDate"], 
                    "userId": userKey,
                    "productDetails": 
                        {
                        "productKey": order["productKey"],
                        "noOfItems": order["noOfItems"],
                        "variationQuantity": order["variationQuantity"]
                        },
                    "paidPrice": order["paidPrice"],
                    "paymentStatus": order["paymentStatus"], 
                    "deliveryStages": order["deliveryStages"],
                    "deliveryAddress": order["deliveryAddress"]
                },
            "productDetails": product[0]["productDetails"]
            })
        
    return jsonify({"result": orderCombinedModel}), 200



@app.route('/products/get-related-products', methods=['GET'])
def getRelatedProducts():
    productKey:int = int(request.args.get('productKey'))
    relatedProductKeys:list = rcm.get_recommendations(productKey)
    
    relatedProducts = []
    for key in relatedProductKeys:
        relatedProduct = dm.get_product_from_key([key])
        relatedProducts.extend(relatedProduct)
    return jsonify({"result": relatedProducts}), 200


# @app.route('/images/<string:product_name>')
# def get_image(product_name):
#     image_path = f'/static/images/{product_name}.png'
#     return render_template('template.html', image_path=image_path)


# @app.route('/users/cancel/<request_id>', methods=['POST'])
# def cancel_request(request_id):
#     pen
#     if request_id in pending_requests:
#         del pending_requests[request_id]
#         return jsonify({"status": "cancelled"})
#     else:
#         return jsonify({"status": "not found"})


if __name__ == '__main__':
    app.run(host='127.0.0.1', debug=True)