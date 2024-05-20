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

  int? key;
  List<CartItem> cartItems;
  String deliveryAddress;
  String deviceToken;
  DateTime dob;
  String emailId;
  String shopName;
  List<int> orders;
  String phoneNo;
  String profilePic;
  String userType;
  String proprietorName;
  String gst;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        key: json["_key"],
        cartItems: List<CartItem>.from(
            json["cartItems"].map((x) => CartItem.fromJson(x))),
        deliveryAddress: json["deliveryAddress"],
        deviceToken: json["deviceToken"],
        dob: DateTime.fromMillisecondsSinceEpoch(json["dob"], isUtc: false),
        emailId: json["emailId"],
        shopName: json["shopName"],
        orders: List<int>.from(json["orders"]),
        phoneNo: json["phoneNo"],
        profilePic: json["profilePic"],
        userType: json["userType"],
        proprietorName: json['proprietorName'],
        gst: json["gst"],
      );

  Map<String, dynamic> toJson() => {
        "_key": key,
        "cartItems": List<CartItem>.from(cartItems.map((x) => x.toJson())),
        "deliveryAddress": deliveryAddress,
        "deviceToken": deviceToken,
        "dob": dob.toUtc().millisecondsSinceEpoch,
        "emailId": emailId,
        "shopName": shopName,
        "orders":orders,
        "phoneNo": phoneNo,
        "profilePic": profilePic,
        "userType": userType,
        "proprietorName": proprietorName,
        "gst": gst,
      };
}

