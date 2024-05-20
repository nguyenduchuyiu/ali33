import 'package:ali33/models/order_model.dart';
import 'package:ali33/models/product_model.dart';

List<OrderCombinedModel> orderItemsFromJson(List<dynamic> json) =>
    List<OrderCombinedModel>.from(
        json.map((x) => OrderCombinedModel.fromJson(x)));

class OrderCombinedModel {
  OrderCombinedModel(
      {required this.orderDetails, required this.productDetails});
  OrderModel orderDetails;
  ProductDetails productDetails;

  factory OrderCombinedModel.fromJson(Map<String, dynamic> json) =>
      OrderCombinedModel(
        orderDetails: OrderModel.fromJson(json["orderModel"]),
        productDetails: ProductDetails.fromJson(json["productDetails"]),
      );
}
