import 'package:online_store/models/product_model.dart';
import 'package:online_store/models/user_model.dart';

class CartCombinedModel {
  CartCombinedModel({
    required this.userDetails,
    required this.cartModel,
  });

  UserModel userDetails;
  List<CartModel> cartModel;

  factory CartCombinedModel.fromJson(Map<String, dynamic> json) =>
      CartCombinedModel(
        cartModel: List<CartModel>.from(
            json["others"].map((x) => CartModel.fromJson(x))),
        userDetails: UserModel.fromJson(json["userDetails"]),
      );

  Map<String, dynamic> toJson() =>
      {"userDetails": userDetails, "cartModel": cartModel};
}

List<CartModel> cartItemsFromJson(List<dynamic> json) =>
    List<CartModel>.from(json.map((x) => CartModel.fromJson(x)));

class CartModel {
  CartModel(
      {required this.cartItem,
      required this.productDetails,
      required this.categoryDetails});

  CartItem cartItem;
  ProductDetails productDetails;
  CategoryDetails categoryDetails;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        cartItem: CartItem.fromJson(json["cartItemDetails"]),
        productDetails: ProductDetails.fromJson(json["productDetails"]),
        categoryDetails: CategoryDetails.fromJson(json["categoryDetails"]),
      );
}

class CartItem {
  CartItem({
    required this.productKey,
    required this.noOfItems,
    required this.variationQuantity,
  });

  String productKey;
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
