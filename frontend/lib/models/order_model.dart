import 'dart:convert';


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

  int? key;
  DateTime orderedDate;
  int userId;
  ProductOrderingDetails productDetails;
  int paidPrice;
  int paymentStatus;
  List<String> deliveryStages;
  String deliveryAddress;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        key: json["_key"],
        orderedDate: DateTime.fromMillisecondsSinceEpoch(json["orderedDate"],
            isUtc: false),
        userId: json["userId"],
        productDetails: ProductOrderingDetails.fromJson(json["productDetails"]),
        paidPrice: json["paidPrice"],
        paymentStatus: json["paymentStatus"],
        deliveryStages: List<String>.from(json["deliveryStages"]),
        deliveryAddress: json["deliveryAddress"],
  );

  Map<String, dynamic> toJson() => {
        "orderedDate": orderedDate.toUtc().millisecondsSinceEpoch,
        "userId": userId,
        "productDetails": productDetails.toJson(),
        "paidPrice": paidPrice,
        "paymentStatus": paymentStatus,
        "deliveryStages": deliveryStages,
        "deliveryAddress": deliveryAddress,
      };
}


class ProductOrderingDetails {
  ProductOrderingDetails({
    required this.productKey,
    required this.noOfItems,
    required this.variationQuantity,
  });

  int productKey;
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

