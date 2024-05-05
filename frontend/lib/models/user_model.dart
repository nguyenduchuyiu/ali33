import 'dart:convert';

import 'package:ali33/models/cart_item_model.dart';

UserModel usersFromJson(String str) => UserModel.fromJson(json.decode(str));

String usersToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.key,
    required this.cartItems,
    required this.deliveryAddress,
    required this.deviceToken,
    required this.dob,
    required this.emailId,
    required this.shopName,
    required this.orders,
    required this.phoneNo,
    required this.profilePic,
    required this.userType,
    required this.proprietorName,
    required this.gst,
  });

  String? key;
  List<CartItem> cartItems;
  List<DeliveryAddress> deliveryAddress;
  String deviceToken;
  DateTime dob;
  String emailId;
  String shopName;
  List<String> orders;
  String phoneNo;
  String profilePic;
  String userType;
  String proprietorName;
  String gst;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        key: json["_key"],
        cartItems: List<CartItem>.from(
            json["cartItems"].map((x) => CartItem.fromJson(x))),
        deliveryAddress: List<DeliveryAddress>.from(
            json["deliveryAddress"].map((x) => DeliveryAddress.fromJson(x))),
        deviceToken: json["deviceToken"],
        dob: DateTime.fromMillisecondsSinceEpoch(json["dob"], isUtc: false),
        emailId: json["emailId"],
        shopName: json["shopName"],
        orders: List<String>.from(json["orders"]),
        phoneNo: json["phoneNo"],
        profilePic: json["profilePic"],
        userType: json["userType"],
        proprietorName: json['proprietorName'],
        gst: json["gst"],
      );

  Map<String, dynamic> toJson() => {
        // "_key": key,
        "cartItems": List<CartItem>.from(cartItems.map((x) => x.toJson())),
        "deliveryAddress": List<DeliveryAddress>.from(
            deliveryAddress.map((x) => DeliveryAddress.fromJson(x.toJson()))),
        "deviceToken": deviceToken,
        "dob": dob.toUtc().millisecondsSinceEpoch,
        "emailId": emailId,
        "shopName": shopName,
        "orders":orders,
            // List<String>.from(orders.map((x) => Order.fromJson(x.toJson()))),
        "phoneNo": phoneNo,
        "profilePic": profilePic,
        "userType": userType,
        "proprietorName": proprietorName,
        "gst": gst,
      };
}

List<DeliveryAddress> deliveryAddressessFromJson(List<dynamic> json) =>
    List<DeliveryAddress>.from(json.map((x)  => DeliveryAddress.fromJson(x)));

class DeliveryAddress {
  DeliveryAddress({
    required this.point,
    required this.address,
  });

  String point;
  String address;

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
        point: json["point"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "point": point,
        "address": address,
      };
}

// class Order {
//   Order({
//     required this.orderId,
//     required this.quantity,
//   });

//   String orderId;
//   String quantity;

//   factory Order.fromJson(Map<String, dynamic> json) => Order(
//         orderId: json["orderId"],
//         quantity: json["quantity"],
//       );

//   Map<String, dynamic> toJson() => {
//         "orderId": orderId,
//         "quantity": quantity,
//       };
// }
