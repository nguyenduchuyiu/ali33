// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:io';
import 'dart:js_util';
import 'package:ali33/models/cart_item_model.dart';
import 'package:ali33/models/order_item_model.dart';
import 'package:ali33/models/order_model.dart';
import 'package:ali33/models/place_model.dart';
import 'package:ali33/models/product_model.dart';
import 'package:ali33/models/user_model.dart';
import 'package:ali33/services/user_data_storage_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  
  // final String baseUrl = "https://nguyenduchuy.pythonanywhere.com/";
  // final String userBaseUrl = "https://nguyenduchuy.pythonanywhere.com/users";
  // final String productBaseUrl = "https://nguyenduchuy.pythonanywhere.com/products";
  // final String orderBaseUrl = "https://nguyenduchuy.pythonanywhere.com/orders";

  final String baseUrl = "http://127.0.0.1:5000";
  final String userBaseUrl = "http://127.0.0.1:5000/users";
  final String productBaseUrl = "http://127.0.0.1:5000/products";
  final String orderBaseUrl = "http://127.0.0.1:5000/orders";

  // final String baseUrl = "http://192.168.0.101:8080";
  // final String userBaseUrl = "http://192.168.0.101:8080/users";
  // final String productBaseUrl = "http://192.168.0.101:8080/products";
  // final String orderBaseUrl = "http://192.168.0.101:8080/orders";

  Future<bool?> checkUser(Map<String, String> data) async {
    try {
      Response<Map<String, dynamic>> response =
          await _dio.post("$userBaseUrl/check_user", data: data);
      if (response.statusCode == 200) {
        // print('user exist ${response.data!['result']}');
        return response.data!['result'];
      }
    } on DioException catch (e) {
      if (e.error is SocketException) {
        internetToastMessage();
      }
    } catch (e) {
      toastMessage("Something went wrong! Try again");
    }
    return null;
  }



  // Future<bool> register(UserModel userModel) async {
  //   try {
  //     Response<Map<String, dynamic>> response =
  //         await _dio.post("$userBaseUrl/user", data: userModel.toJson());

  //     await UserDataStorageService().setToken(response.data!["authToken"]);
  //     return true;
  //   } on DioException catch (e) {
  //     print("dio error occured: ${e.response}");
  //     if (e.error is SocketException) {
  //       internetToastMessage();
  //     } else {
  //       toastMessage("Something went wrong! Try again");
  //     }
  //   } catch (e) {
  //     print("Exception Occured : $e");

  //     toastMessage("Something went wrong! Try again");
  //   }
  //   return false;
  // }

  Future<bool> login(Map<String, String> data) async {
    try {
      Response<Map<String, dynamic>> response = await _dio.post("$userBaseUrl/login", data: data);
      print(response);
      await UserDataStorageService().setToken(response.data!["token"]);
      return true;
    } on DioException catch (e) {
      if (e.error is SocketException) {
        internetToastMessage();
      }else{
        print('login response : ${e.response}');
      }
    }
    return false;
  }
 

  Future<bool> signup(Map<String, String> data) async {
    try {
      Response<Map<String, dynamic>> response = await _dio.post("$userBaseUrl/signup", data: data);
      // print('signup: $response');
      return true;
    } on DioException catch (e) {
      if (e.error is SocketException) {
        internetToastMessage();
      } else {
        print('signup response : ${e.response}');
      }
    }
    return false;
  }

  Future<bool> logout() async {
    await UserDataStorageService().deleteToken();
    return true;
  }

  Future<bool> updateProfile(UserModel userModel) async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Response<Map<String, dynamic>> response =
          await _dio.put(userBaseUrl + "/user", data: userModel.toJson());
      print(response);
      return true;
    } on DioException catch (e) {
      print("dio error occured: ${e.response}");
      if (e.error is SocketException) {
        internetToastMessage();
      } else {
        toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured : $e");
      toastMessage("Something went wrong! Try again");
    }
    return false;
  }

  Future<String> uploadProfilePhoto(File pic) async {
    String? token = await UserDataStorageService().getToken();
    try {
      _dio.options.headers["Authorization"] = token!;
      FormData formData = FormData.fromMap({
        "profilePic": await MultipartFile.fromFile(pic.path),
      });
      Response<Map<String, dynamic>> response = await _dio
          .post(userBaseUrl + "/upload-profile-picture", data: formData);
      print(response);
      return response.data!["result"];
    } on DioException catch (e) {
      print("dio error occured: ${e.response}");
      if (e.error is SocketException) {
        // internetToastMessage();
      } else {
        // toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured : $e");
      // toastMessage("Something went wrong! Try again");
    }
    return "";
  }

  Future<UserModel?> getCurrentUser() async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Response<Map<String, dynamic>> response = await _dio.get("$userBaseUrl/get-current-user");
      // print(response);
      UserModel user = UserModel.fromJson(response.data!["result"]);
      return user;
    } on DioException catch (e) {
      print("get cur user dio error occured: ${e.message}");
      if (e.error is SocketException) {
        internetToastMessage();
      } else {
        toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured : $e");
      // toastMessage("Something went wrong! Try again");
    }
    return null;
  }
 
  Future<bool> addAddress(String address) async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Response<Map<String, dynamic>> response =
          await _dio.post("$userBaseUrl/address", data: address);
      print(response);
      return true;
    } on DioException catch (e) {
      print("dio error occured: ${e.response}");
      if (e.error is SocketException) {
        // internetToastMessage();
      } else {
        // toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured : $e");
      // toastMessage("Something went wrong! Try again");
    }
    return false;
  }

  Future<bool> deleteAddress(String address) async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Response<Map<String, dynamic>> response =
          await _dio.delete(userBaseUrl + "/address", data: address);
      print(response);
      return true;
    } on DioException catch (e) {
      print("dio error occured: ${e.response}");
      if (e.error is SocketException) {
      } else {}
    } catch (e) {
      print("Exception Occured : $e");
    }
    return false;
  }

  Future<List<String>> getAllAddresses() async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Response<Map<String, dynamic>> response = await _dio.get(userBaseUrl + "/address");
      return response.data!['result'];
    } on DioException catch (e) {
      print("dio error occured: ${e.response}");
      if (e.error is SocketException) {
        // internetToastMessage();
      } else {
        // toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured : $e");
      // toastMessage("Something went wrong! Try again");
    }
    return [];
  }

  Future<List<OrderCombinedModel>> getAllOrders() async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Response<Map<String, dynamic>> response = await _dio.get(userBaseUrl + "/get-all-orders");

      // print("list order: ${response.data!["result"][0]}");
      // print("list order below: ${response.data!["result"][0]["productDetails"]}");

      List<OrderCombinedModel> orders = orderItemsFromJson(response.data!["result"]);
      return orders;
    } on DioException catch (e) {
      print("dio error occured: ${e.response}");
      if (e.error is SocketException) {
        internetToastMessage();
      } else {
        // toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured : $e");
      // toastMessage("Something went wrong! Try again");
    }
    return [];
  }

  Future<bool> setDefaultAddress(String address) async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Response<Map<String, dynamic>> response = await _dio
          .post(userBaseUrl + "/set-default-address", data: address);
      print(response);
      return true;
    } on DioException catch (e) {
      print("dio error occured: ${e.response}");
      if (e.error is SocketException) {
        internetToastMessage();
      } else {
        toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured : $e");
      toastMessage("Something went wrong! Try again");
    }
    return false;
  }

  /// products related api calls

  Future<List<CategoryDetail>> getAllCategories() async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Response<Map<String, dynamic>> response =
          await _dio.get(productBaseUrl + "/get-all-categories");
      List<CategoryDetail> categories =
          categoriesFromJson(response.data!["result"]);
      return categories;
    } on DioException catch (e) {
      print("dio error occured: ${e.response}");
      if (e.error is SocketException) {
        // internetToastMessage();
      } else {
        // toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured : $e");
      // toastMessage("Something went wrong! Try again");
    }
    return [];
  }

  Future<CategoryDetail?> getCategory() async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Response<Map<String, dynamic>> response =
          await _dio.get(productBaseUrl + "/category");
      CategoryDetail category =
          CategoryDetail.fromJson(response.data!["result"]);
      return category;
    } on DioException catch (e) {
      print("dio error occured: ${e.response}");
      if (e.error is SocketException) {
        // internetToastMessage();
      } else {
        // toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured : $e");
      // toastMessage("Something went wrong! Try again");
    }
    return null;
  }

  Future<ProductModel?> getProduct(String key) async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Response<Map<String, dynamic>> response =
          await _dio.get(productBaseUrl + "/product");
      ProductModel product = ProductModel.fromJson(response.data!["result"]);
      return product;
    } on DioException catch (e) {
      print("dio error occured: ${e.response}");
      if (e.error is SocketException) {
        // internetToastMessage();
      } else {
        // toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured : $e");
      // toastMessage("Something went wrong! Try again");
    }
    return null;
  }

  Future<List<ProductModel>> getAllProducts(int lastDocKey, 
                                            int limit, 
                                            int? category)
                                            async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Response<Map<String, dynamic>> response = await _dio.get(
                        "$productBaseUrl/get-all-products",
                        queryParameters: {"category": category}
                                                             );
      List<ProductModel> products = productsFromJson(response.data!["result"]);
      return products;
    } on DioException catch (e) {
      print("dio error occured: ${e.response}");
      if (e.error is SocketException) {
        internetToastMessage();
      } else {
        // toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured : $e");
      // toastMessage("Something went wrong! Try again");
    }
    return [];
  }

  Future<List<ProductModel>> searchProduct(String searchTerm) async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      print(searchTerm);
      Response<Map<String, dynamic>> response = await _dio.get(
          "$productBaseUrl/search-product",
          queryParameters: {"searchTerm": searchTerm});
      List<ProductModel> products = productsFromJson(response.data!["result"]);
      return products;
    } on DioException catch (e) {
      print("dio error occured: ${e.response}");
      if (e.error is SocketException) {
        internetToastMessage();
      } else {
        // toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured : $e");
      // toastMessage("Something went wrong! Try again");
    }
    return [];
  }

  Future<bool> addToCart(CartItem cartItems, userKey) async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Map<String, dynamic> data = {'cartItems': cartItems.toJson(),
                                    'userKey': userKey};
      Response<Map<String, dynamic>> response = await _dio.post(userBaseUrl + "/add-to-cart", data: data);
      return true;
    } on DioException catch (e) {
      print("dio error occured on add to cart: ${e.response}");
      if (e.error is SocketException) {
        internetToastMessage();
      }
    } catch (e) {
      print("Exception Occured at addtocart : $e");
    }
    return false;
  }

  Future<CartCombinedModel?> getCartItems(int userKey) async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Response<Map<String, dynamic>> response = await _dio.get(
                                                userBaseUrl + "/get-cart-items");
      CartCombinedModel prods = CartCombinedModel.fromJson(response.data!['result']);
      return prods;
    } on DioException catch (e) {
      print("dio error occured: ${e.message}");
      if (e.error is SocketException) {
        internetToastMessage();
      } else {
        toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured at get cart item : $e");
      // throw Error;
      toastMessage("Something went wrong! Try again");
    }
    return null;
  }

  Future<bool> removeFromCart(List<CartItem> items) async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Response<Map<String, dynamic>> response = await _dio.delete(
                                                userBaseUrl + "/remove-from-cart", 
                                                data: {"cartItems": items});
      print("remove:  ${response.data!['result']}");
      return true;
    } on DioException catch (e) {
      print("dio error occured in removeFromCart: ${e.response}");
      if (e.error is SocketException) {
        internetToastMessage();
      } else {
        // toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured at removeFromCart : $e");
      // throw Error;
      // toastMessage("Something went wrong! Try again");
    }
    return false;
  }

  Future<bool> changeNoOfProdCart(Map<String, dynamic> item) async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Response<Map<String, dynamic>> response = await _dio.put(
                                                userBaseUrl + "/change-no-of-product-in-cart", 
                                                data: item);
      print("res ${response.data!['result']}");
      return true;
    } on DioException catch (e) {
      print("dio error occured at changeNoOfProd: ${e.response}");
      if (e.error is SocketException) {
        internetToastMessage();
      } else {
        // toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured at changeNoOfProd : $e");
      // throw Error;
      // toastMessage("Something went wrong! Try again");
    }
    return false;
  }

  Future<bool> placeOrder(List<OrderModel> orders) async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Response<Map<String, dynamic>> response =
          await _dio.post(orderBaseUrl + "/place-order", data: {"orders": orders});
      print("res ${response.data!['result']}");
      return true;
    } on DioException catch (e) {
      print("dio error occured: ${e.response}");
      if (e.error is SocketException) {
        internetToastMessage();
      } else {
        toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured at placeOrder : $e");
      toastMessage("Something went wrong! Try again");
    }
    return false;
  }

  Future<List<PlaceModel>> searchPlaceOnMap(String input) async {
    const mapApiKey = "AIzaSyC_2fIFDCfbf0xI7lTOEARgCQeH-yQV9h0";
    final requestUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$mapApiKey';
    try {
      Response<Map<String, dynamic>> response = await _dio.post(requestUrl);
      List<PlaceModel> placesSuggestions =
          placesModelFromJson(response.data!["predictions"]);
      return placesSuggestions;
    } on DioException catch (e) {
      print("dio error occured: ${e.response}");
      if (e.error is SocketException) {
        internetToastMessage();
      } else {
        // toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured at addtocart : $e");
      // toastMessage("Something went wrong! Try again");
    }
    return [];
  }

  Future<List<ProductModel>> getRelatedProducts(String productName) async {
    String? token = await UserDataStorageService().getToken();
    _dio.options.headers["Authorization"] = token!;
    try {
      Response<Map<String, dynamic>> response = await _dio.get('$productBaseUrl/get-related-products',
                                                                queryParameters: {"productName": productName});
      // print("respones : ${response.data!['result']}");
      List<ProductModel> relatedProducts = productsFromJson(response.data!['result']);
      return relatedProducts;
    } on DioException catch (e) {
      print("dio error occured on get rcm: ${e.response}");
      if (e.error is SocketException) {
        internetToastMessage();
      } else {
        // toastMessage("Something went wrong! Try again");
      }
    } catch (e) {
      print("Exception Occured at rcm : $e");
      // toastMessage("Something went wrong! Try again");
    }
    return [];
  }
}
