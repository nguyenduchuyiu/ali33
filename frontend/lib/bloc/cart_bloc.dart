// ignore_for_file: must_be_immutable

import 'package:ali33/models/cart_item_model.dart';
import 'package:ali33/services/api_service.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

@immutable
abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCartItems extends CartEvent {
  FetchCartItems();
}

class RemoveItemFromCart extends CartEvent {
  final CartItem item;
  RemoveItemFromCart({required this.item});

  @override
  String toString() {
    return super.toString();
  }
}

class ChangeNoOfProducts extends CartEvent {
  final Map<String, dynamic> item;

  ChangeNoOfProducts({required this.item});
}

class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartInitialState extends CartState {}

class CartProductsLoading extends CartState {}

// ignore: duplicate_ignore
// ignore: must_be_immutable
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
  CartBloc() : super(CartInitialState()) {
    
    on<FetchCartItems>((event, emit) async {
      emit(CartProductsLoading());
      try {
        CartCombinedModel? prods = await _apiService.getCartItems();
        emit(CartProductsFetched(products: prods!));
      } catch (e) {
        emit(CartError(error: e as Error)); 
      }
    });

    on<RemoveItemFromCart>((event, emit) async { 
      emit(CartProductsLoading());
      try {
        bool res = await _apiService.removeFromCart([event.item]);
        print("result $res");
        CartCombinedModel? prods = await _apiService.getCartItems();
        emit(CartProductsFetched(products: prods!)); 
      } catch (e) {
        emit(CartError(error: e as Error)); 
      }
    });

    on<ChangeNoOfProducts>((event, emit) async {
      emit(CartProductsLoading());
      try {
        bool res = await _apiService.changeNoOfProdCart(event.item);
        CartCombinedModel? prods = await _apiService.getCartItems();
        emit(CartProductsFetched(products: prods!)); 
      } catch (e) {
        emit(CartError(error: e as Error)); 
      }
    });
  }

  final ApiService _apiService = ApiService();
}