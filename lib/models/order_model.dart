// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';
import 'package:online_store/models/user_model.dart';

List<OrderModel> orderModelFromJson(List<dynamic> list) =>
    List<OrderModel>.from(list.map((x) => OrderModel.fromJson(x)));

String orderModelToJson(List<OrderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel {
  OrderModel({
    this.key,
    required this.orderedDate,
    required this.userId,
    required this.productDetails,
    required this.paidPrice,
    required this.paymentStatus,
    required this.deliveryStages,
    required this.deliveryAddress,
  });

  String? key;
  DateTime orderedDate;
  String userId;
  ProductOrderingDetails productDetails;
  int paidPrice;
  int paymentStatus;
  List<DateTime> deliveryStages;
  DeliveryAddress deliveryAddress;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        key: json["_key"],
        orderedDate: DateTime.fromMillisecondsSinceEpoch(json["orderedDate"],
            isUtc: false),
        userId: json["userId"],
        productDetails: ProductOrderingDetails.fromJson(json["productDetails"]),
        paidPrice: json["paidPrice"],
        paymentStatus: json["paymentStatus"],
        deliveryStages: List<DateTime>.from(json["deliveryStages"]
            .map((e) => DateTime.fromMillisecondsSinceEpoch(e, isUtc: false))),
        deliveryAddress: DeliveryAddress.fromJson(json["deliveryAddress"]),
      );

  Map<String, dynamic> toJson() => {
        "orderedDate": orderedDate.toUtc().millisecondsSinceEpoch,
        "userId": userId,
        "productDetails": productDetails.toJson(),
        "paidPrice": paidPrice,
        "paymentStatus": paymentStatus,
        "deliveryStages": List<int>.from(
            deliveryStages.map((e) => e.toUtc().millisecondsSinceEpoch)),
        "deliveryAddress": deliveryAddress.toJson(),
      };
}

class DeliveryStages {
  DeliveryStages({
    required this.stageOne,
    required this.stageTwo,
    required this.stageThree,
    required this.stageFour,
  });

  String stageOne;
  String stageTwo;
  String stageThree;
  String stageFour;

  factory DeliveryStages.fromJson(Map<String, dynamic> json) => DeliveryStages(
        stageOne: json["stageOne"],
        stageTwo: json["stageTwo"],
        stageThree: json["stageThree"],
        stageFour: json["stageFour"],
      );

  Map<String, dynamic> toJson() => {
        "stageOne": stageOne,
        "stageTwo": stageTwo,
        "stageThree": stageThree,
        "stageFour": stageFour,
      };
}

class ProductOrderingDetails {
  ProductOrderingDetails({
    required this.productKey,
    required this.noOfItems,
    required this.variationQuantity,
  });

  String productKey;
  int noOfItems;
  int variationQuantity;

  factory ProductOrderingDetails.fromJson(Map<String, dynamic> json) =>
      ProductOrderingDetails(
        productKey: json["productKey"],
        noOfItems: json["noOfItems"],
        variationQuantity: json["variationQuantity"],
      );

  Map<String, dynamic> toJson() => {
        "productKey": productKey,
        "noOfItems": noOfItems,
        "variationQuantity": variationQuantity,
      };
}

// class DeliveryAddress {
//   DeliveryAddress({
//     required this.point,
//     required this.address,
//   });

//   String point;
//   String address;

//   factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
//       DeliveryAddress(
//         point: json["point"],
//         address: json["address"],
//       );

//   Map<String, dynamic> toJson() => {
//         "point": point,
//         "address": address,
//       };
// }

