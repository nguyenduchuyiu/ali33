import 'package:ali33/models/product_model.dart';
import 'package:ali33/models/user_model.dart';

class CartCombinedModel {
  CartCombinedModel({
    required this.userDetails,
    required this.cartModels,
  });

  UserModel userDetails;
  List<CartModel> cartModels;

  factory CartCombinedModel.fromJson(Map<String, dynamic> json) =>
      CartCombinedModel(
        cartModels: List<CartModel>.from(
            json["cartModels"].map((x) => CartModel.fromJson(x))),
        userDetails: UserModel.fromJson(json["userDetails"]),
      );

  Map<String, dynamic> toJson() =>
      {"userDetails": userDetails, "cartModels": cartModels};
}

List<CartModel> cartItemsFromJson(List<dynamic> json) =>
    List<CartModel>.from(json.map((x) => CartModel.fromJson(x)));

class CartModel {
  CartModel(
      {required this.cartItem,
      required this.productDetails});

  CartItem cartItem;
  ProductDetails productDetails;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        cartItem: CartItem.fromJson(json["cartItemDetails"]),
        productDetails: ProductDetails.fromJson(json["productDetails"]),
      );
}

class CartItem {
  CartItem({
    required this.productKey,
    required this.noOfItems,
    required this.variationQuantity,
  });

  int productKey;
  int noOfItems;
  int variationQuantity;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
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
