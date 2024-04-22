// To parse this JSON data, do
//
//     final product = productsFromJson(listOfJson);

import 'dart:convert';

List<ProductModel> productsFromJson(List<dynamic> json) =>
    List<ProductModel>.from(json.map((x)  => ProductModel.fromJson(x)));

String productsToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<CategoryDetails> categoriesFromJson(List<dynamic> json) =>
    List<CategoryDetails>.from(json.map((x) => CategoryDetails.fromJson(x)));

class ProductModel {
  ProductModel({
    required this.categoryDetails,
    required this.productDetails,
  });

  CategoryDetails categoryDetails;
  ProductDetails productDetails;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        categoryDetails: CategoryDetails.fromJson(json["categoryDetails"]),
        productDetails: ProductDetails.fromJson(json["productDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "categoryDetails": categoryDetails.toJson(),
        "productDetails": productDetails.toJson(),
      };
}

class CategoryDetails {
  CategoryDetails({
    required this.key,
    required this.categoryName,
    required this.categoryPicture,
  });

  String key;
  String categoryName;
  String categoryPicture;

  factory CategoryDetails.fromJson(Map<String, dynamic> json) =>
      CategoryDetails(
        key: json["_key"],
        categoryName: json["categoryName"],
        categoryPicture: json["categoryPicture"],
      );

  Map<String, dynamic> toJson() => {
        "_key": key,
        "categoryName": categoryName,
        "categoryPicture": categoryPicture,
      };
}

class ProductDetails {
  ProductDetails({
    required this.key,
    required this.productCategoryId,
    required this.productDescription,
    required this.productName,
    required this.productPicture,
    required this.reviews,
    required this.variations,
  });

  String key;
  String productCategoryId;
  String productDescription;
  String productName;
  String productPicture;
  List<Review> reviews;
  List<Variation> variations;

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
        key: json["_key"],
        productCategoryId: json["productCategoryId"],
        productDescription: json["productDescription"],
        productName: json["productName"],
        productPicture: json["productPicture"],
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        variations: List<Variation>.from(
            json["variations"].map((x) => Variation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_key": key,
        "productCategoryId": productCategoryId,
        "productDescription": productDescription,
        "productName": productName,
        "productPicture": productPicture,
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
        "variations": List<dynamic>.from(variations.map((x) => x.toJson())),
      };
}

class Review {
  Review({
    required this.comment,
    required this.userId,
  });

  String comment;
  String userId;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        comment: json["comment"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "userId": userId,
      };
}

class Variation {
  Variation({
    required this.availabilityQuantity,
    required this.discountPrice,
    required this.offerPrice,
    required this.quantity,
    required this.sellingPrice,
  });

  int availabilityQuantity;
  int discountPrice;
  int offerPrice;
  int quantity;
  int sellingPrice;

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
        availabilityQuantity: json["availabilityQuantity"],
        discountPrice: json["discountPrice"],
        offerPrice: json["offerPrice"],
        quantity: json["quantity"],
        sellingPrice: json["sellingPrice"],
      );

  Map<String, dynamic> toJson() => {
        "availabilityQuantity": availabilityQuantity,
        "discountPrice": discountPrice,
        "offerPrice": offerPrice,
        "quantity": quantity,
        "sellingPrice": sellingPrice,
      };
}
