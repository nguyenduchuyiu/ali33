// To parse this JSON data, do
//
//     final product = productsFromJson(listOfJson);

import 'dart:convert'; 

List<ProductModel> productsFromJson(List<dynamic> json) =>
    List<ProductModel>.from(json.map((x)  => ProductModel.fromJson(x)));

String productsToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<CategoryDetail> categoriesFromJson(List<dynamic> json) =>
    List<CategoryDetail>.from(json.map((x) => CategoryDetail.fromJson(x)));

class ProductModel {
  ProductModel({
    required this.categoryDetails,
    required this.productDetails,
  });

  List<CategoryDetail> categoryDetails;
  ProductDetails productDetails;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        categoryDetails: categoriesFromJson(json['categoryDetails']),
        productDetails: ProductDetails.fromJson(json["productDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "categoryDetails": categoryDetails.map((x) => x.toJson()).toList(),
        "productDetails": productDetails.toJson(),
      };
}

class CategoryDetail {
  CategoryDetail({
    required this.key,
    required this.categoryName,
    required this.categoryPicture,
  });

  int key;
  String categoryName;
  String categoryPicture;

  factory CategoryDetail.fromJson(Map<String, dynamic> json) =>
      CategoryDetail(
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
    required this.productDescription,
    required this.productName,
    required this.productPicture,
    required this.productRating,
    required this.reviews,
    required this.variations,
  });

  int key;
  String productDescription;
  String productName;
  String productPicture;
  double productRating;
  List<Review> reviews;
  List<Variation> variations;

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
        key: json["_key"],
        productDescription: json["productDescription"],
        productName: json["productName"],
        productPicture: json["productPicture"],
        productRating: json['productRating'],
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        variations: 
            List<Variation>.from(json["variations"].map((x) => Variation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_key": key,
        "productDescription": productDescription,
        "productName": productName,
        "productPicture": productPicture,
        "productRating": productRating,
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
  int userId;

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
  double discountPrice;
  double offerPrice;
  int quantity;
  double sellingPrice;

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
