import 'package:ali33/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenCacheStorage {
  Future<void> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token")!;
  }

  Future<void> deleteToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }
}

class ProductCacheStorage {
  Map<int, ProductModel> cachedProducts = {}; // Store products by ID
  Map<int, List<ProductModel>> relatedProducts = {}; // Store related product IDs by category
  List<int> productViewHistory = [];
  List<int> unviewedProductKeys = [];
  List<int> viewedProductKeys = [];

  List<int> filterUnviewedProductKeys(List<int> productKeys) {
    List<int> unviewedProductKeys = [];
    List<int> viewedProductKeys = [];
    for (var key in productKeys) {
        if (!isProductViewed(key)) {
          unviewedProductKeys.add(key);
        }
        else {
          viewedProductKeys.add(key);
        }
      }
    return unviewedProductKeys;
  }

  List<int> filterViewedProductKeys(List<int> productKeys) {
    return viewedProductKeys;
  }

  bool isProductViewed(int key) {
    return productViewHistory.contains(key);
  }

  // Add/update a product
  void addProduct(int key, ProductModel product) {
    cachedProducts[key] = product;
    productViewHistory.add(key);
    print("after add $cachedProducts");
  }

  // Get products by list of key
  List<ProductModel>? getProducts(List<int> productKeys) {
    List<ProductModel>? products = [];
    for(int key in productKeys) {
      ProductModel? product = cachedProducts[key];
      products.add(product!);
    }
    return products;
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
}
