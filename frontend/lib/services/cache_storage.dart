import 'package:ali33/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TokenCacheStorage {
  Future<void> setToken(String token) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", token);
    } catch (e) {
      print('Error setting token: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString("token");
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  Future<void> deleteToken() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("token");
    } catch (e) {
      print('Error deleting token: $e');
    }
  }
}

class ProductCacheStorage {
  Map<int, ProductModel> cachedProducts = {}; // Store products by ID
  Map<int, List<ProductModel>> relatedProducts = {}; // Store related product IDs by category
  List<int> unviewedProductKeys = [];
  List<int> viewedProductKeys = [];

  List<int> filterUnviewedProductKeys(List<int> productKeys) {
    unviewedProductKeys.clear();
    viewedProductKeys.clear();

    for (var key in productKeys) {
      isProductViewed(key).then((isViewed) {
        if (isViewed == true) {
          viewedProductKeys.add(key);
        } else if (isViewed == false) {
          unviewedProductKeys.add(key);
        }
      });
    }
    return unviewedProductKeys;
  }

  Future<bool?> isProductViewed(int key) async {
    try {
      List<String> history = await getHistory() as List<String>;
      return history.contains(key.toString()); 
    } catch (e) {
      print('Error checking if product viewed: $e');
      return null;
    }
  }

  Map<String, dynamic> stringToJson(String jsonString) {
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Error decoding JSON string: $e');
      return {};
    }
  }

  Future<List<String>?> getHistory() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? history = prefs.getStringList('productViewHistory');
      if (history == null) {
        return [];
      }
      return history;
    } on Exception catch (e) {
      print('Error getting history: $e');
      return [];
    }
  }

  void addProduct(ProductModel product) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(product.productDetails.key.toString(), jsonEncode(product.toJson()));

      List<String>? history = await getHistory() as List<String>;
      prefs.setStringList('productViewHistory', [product.productDetails.key.toString()] + history);
      // history = await getHistory() as List<String>;
      history = prefs.getStringList('productViewHistory');
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<List<ProductModel>?> getProducts(List<int> productKeys) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<ProductModel> products = [];
      for (int key in productKeys) {
        String? productJson = prefs.getString(key.toString());
        if (productJson != null) {
          ProductModel? product = ProductModel.fromJson(stringToJson(productJson));
          products.add(product);
        }
      }
      return products;
    } catch (e) {
      print('Error getting products: $e');
      return null;
    }
  }
}


  // Add related products for a category
  // void addRelatedProducts(int key, List<ProductModel> relatedProducts) {
  //   relatedProducts[key] = relatedProducts;
  // }

  // // Get related product IDs for a category
  // List<ProductModel>? getRelatedProduct(int key) {
  //   return _relatedProducts[key];
  // }


  // List<ProductModel> getFavoriteProducts() {
  //   List<ProductModel> favoriteProducts = [];
  //   for (int i = 0; i < 5; i++) {
  //     final relatedProducts = getRelatedProduct(i);
  //     favoriteProducts.addAll(relatedProducts!);
  //   }
  //   return favoriteProducts.sublist(0, favoriteProducts.length.clamp(0, 20));
  // }
// }
