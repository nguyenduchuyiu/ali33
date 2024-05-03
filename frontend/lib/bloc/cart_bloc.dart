import 'dart:io';
import 'package:online_store/models/cart_item_model.dart';
import 'package:online_store/models/product_model.dart';
import 'package:online_store/screens/product_details.dart';
import 'package:online_store/services/api_service.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

@immutable
abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCartItems extends CartEvent {}

class RemoveItemFromCart extends CartEvent {
  final CartItem item;
  RemoveItemFromCart({required this.item});
  @override
  String toString() {
    print("Fetch Cart items");
    return super.toString();
  }
}

class ChangeNoOfProducts extends CartEvent {
  final Map<String, dynamic> item;

  ChangeNoOfProducts(this.item);
}

// class DecreaseNoOfProducts extends CartEvent {
//   final int numberOfProds;

//   DecreaseNoOfProducts(this.numberOfProds);
// }

class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartInitialState extends CartState {}

class CartProductsLoading extends CartState {}

class CartProductsFetched extends CartState {
  CartCombinedModel products;
  CartProductsFetched({required this.products});

  @override
  List<Object> get props => [products];
}

class CartError extends CartState {
  final Error error;
  CartError({required this.error});

  @override
  List<Object> get props => [error];
}

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitialState());
  final ApiService _apiService = ApiService();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is FetchCartItems) {
      yield CartProductsLoading();
      CartCombinedModel? prods = await _apiService.getCartItems();
      yield CartProductsFetched(products: prods!);
      // try {
      //   List<CartModel> prods = await _apiService.getCartItems();
      //   yield CartProductsFetched(products: prods);
      // } on DioException catch (e) {
      //   print("dio error at cart bloc occured: ${e.response}");
      //   if (e.error is SocketException) {
      //     // yield CartError();
      //   } else {}
      // } on Error catch (e) {
      //   // e. = "Couldn't Reach Server! Check your Internet Connection"
      //   yield CartError(error: e);
      //   print("error in cart bloc: $e");
      // }
    } else if (event is RemoveItemFromCart) {
      yield CartProductsLoading();
      bool res = await _apiService.removeFromCart([event.item]);
      print("result $res");
      // if (res) {
      CartCombinedModel? prods = await _apiService.getCartItems();
      yield CartProductsFetched(products: prods!);
      // } else {
      //   yield CartError(error: Error());
      // }
    } else if (event is ChangeNoOfProducts) {
      yield CartProductsLoading();
      bool res = await _apiService.changeNoOfProdCart(event.item);
      CartCombinedModel? prods = await _apiService.getCartItems();
      yield CartProductsFetched(products: prods!);
    }
  }
}
