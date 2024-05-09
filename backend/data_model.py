from datetime import datetime

class CartItem:
    def __init__(self, product_key, no_of_items, variation_quantity):
        self.product_key = product_key
        self.no_of_items = no_of_items
        self.variation_quantity = variation_quantity

    @classmethod
    def from_json(cls, json_data):
        return cls(
            json_data['productKey'],
            json_data['noOfItems'],
            json_data['variationQuantity']
        )

    def to_json(self):
        return {
            "productKey": self.product_key,
            "noOfItems": self.no_of_items,
            "variationQuantity": self.variation_quantity
        }

class UserModel:
    def __init__(self, key, cart_items, delivery_address, device_token, dob, email_id, 
                 shop_name, orders, phone_no, profile_pic, user_type, proprietor_name, gst):
        self.key = key
        self.cart_items = cart_items
        self.delivery_address = delivery_address
        self.device_token = device_token
        self.dob = dob
        self.email_id = email_id
        self.shop_name = shop_name
        self.orders = orders
        self.phone_no = phone_no
        self.profile_pic = profile_pic
        self.user_type = user_type
        self.proprietor_name = proprietor_name
        self.gst = gst

    @classmethod
    def from_json(cls, json_data):
        cart_items = [CartItem.from_json(item) for item in json_data['cartItems']]
        delivery_address = [DeliveryAddress.from_json(item) for item in json_data['deliveryAddress']]
        dob = datetime.fromtimestamp(json_data['dob'] / 1000.0)  # Convert milliseconds to datetime
        return cls(
            json_data.get('_key'),
            cart_items,
            delivery_address,
            json_data['deviceToken'],
            dob,
            json_data['emailId'],
            json_data['shopName'],
            json_data['orders'],
            json_data['phoneNo'],
            json_data['profilePic'],
            json_data['userType'],
            json_data['proprietorName'],
            json_data['gst']
        )

    def to_json(self):
        return {
            # "_key": self.key,  # Consider whether to include the key in the JSON
            "cartItems": [item.to_json() for item in self.cart_items],
            "deliveryAddress": [item.to_json() for item in self.delivery_address],
            "deviceToken": self.device_token,
            "dob": int(self.dob.timestamp() * 1000),  # Convert datetime to milliseconds
            "emailId": self.email_id,
            "shopName": self.shop_name,
            "orders": self.orders,
            "phoneNo": self.phone_no,
            "profilePic": self.profile_pic,
            "userType": self.user_type,
            "proprietorName": self.proprietor_name,
            "gst": self.gst
        }

class DeliveryAddress:
    def __init__(self, point, address):
        self.point = point
        self.address = address

    @classmethod
    def from_json(cls, json_data):
        return cls(json_data['point'], json_data['address'])

    def to_json(self):
        return {"point": self.point, "address": self.address}

class ProductModel:
    def __init__(self, category_details, product_details):
        self.category_details = category_details
        self.product_details = product_details

    @classmethod
    def from_json(cls, json_data):
        category_details = [CategoryDetails.from_json(category_detail) for category_detail in json_data['CategoryDetails']]
        product_details = ProductDetails.from_json(json_data['productDetails'])
        return cls(category_details, product_details)

    def to_json(self):
        return {
            "categoryDetails": self.category_details.to_json(),
            "productDetails": self.product_details.to_json()
        }

class CategoryDetails:
    def __init__(self, key, category_name, category_picture):
        self.key = key
        self.category_name = category_name
        self.category_picture = category_picture

    @classmethod
    def from_json(cls, json_data):
        return cls(
            json_data['_key'],
            json_data['categoryName'],
            json_data['categoryPicture']
        )

    def to_json(self):
        return {
            "_key": self.key,
            "categoryName": self.category_name,
            "categoryPicture": self.category_picture
        }

class ProductDetails:
    def __init__(self, key, product_description, product_name, product_picture, reviews, variations):
        self.key = key
        self.product_description = product_description
        self.product_name = product_name
        self.product_picture = product_picture
        self.reviews = reviews
        self.variations = variations

    @classmethod
    def from_json(cls, json_data):
        reviews = [Review.from_json(review_data) for review_data in json_data['reviews']]
        variations = [Variation.from_json(variation_data) for variation_data in json_data['variations']]
        return cls(
            json_data['_key'],
            json_data['productDescription'],
            json_data['productName'],
            json_data['productPicture'],
            reviews,
            variations
        )

    def to_json(self):
        return {
            "_key": self.key,
            "productCategoryId": self.product_category_id,
            "productDescription": self.product_description,
            "productName": self.product_name,
            "productPicture": self.product_picture,
            "reviews": [review.to_json() for review in self.reviews],
            "variations": [variation.to_json() for variation in self.variations]
        }

class Review:
    def __init__(self, comment, user_id):
        self.comment = comment
        self.user_id = user_id

    @classmethod
    def from_json(cls, json_data):
        return cls(json_data['comment'], json_data['userId'])

    def to_json(self):
        return {
            "comment": self.comment,
            "userId": self.user_id
        }

class Variation:
    def __init__(self, availability_quantity, discount_price, offer_price, quantity, selling_price):
        self.availability_quantity = availability_quantity
        self.discount_price = discount_price
        self.offer_price = offer_price
        self.quantity = quantity
        self.selling_price = selling_price

    @classmethod
    def from_json(cls, json_data):
        return cls(
            json_data['availabilityQuantity'],
            json_data['discountPrice'],
            json_data['offerPrice'],
            json_data['quantity'],
            json_data['sellingPrice']
        )

    def to_json(self):
        return {
            "availabilityQuantity": self.availability_quantity,
            "discountPrice": self.discount_price,
            "offerPrice": self.offer_price,
            "quantity": self.quantity,
            "sellingPrice": self.selling_price
        }