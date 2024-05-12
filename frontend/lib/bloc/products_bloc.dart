// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:ali33/models/product_model.dart';
import 'package:ali33/services/api_service.dart';

@immutable
abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchProducts extends ProductEvent {
  final int limit;
  final bool isInitial;
  final int? category;

  FetchProducts(
      {required this.isInitial, required this.limit, required this.category});
}

// product states
enum ProductStatus { initial, success, failure }

// states
class ProductState extends Equatable {
  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const <ProductModel>[],
    this.hasReachedMax = false,
  });

  final ProductStatus status;
  final List<ProductModel> products;
  final bool hasReachedMax;

  ProductState copyWith({
    ProductStatus? status,
    List<ProductModel>? products,
    bool? hasReachedMax,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''ProductState { status: $status, hasReachedMax: $hasReachedMax, posts: ${products.length} }''';
  }

  @override
  List<Object> get props => [status, products, hasReachedMax];
}

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(const ProductState()) {
    on<FetchProducts>(
      _onProductsFetched,
      transformer: throttleDroppable(const Duration(milliseconds: 100)),
    );
  }
  final ApiService _apiService = ApiService();

  Future<void> _onProductsFetched(
    FetchProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state.hasReachedMax && !event.isInitial) return;
    try {
      if (state.status == ProductStatus.initial || event.isInitial) {
        List<ProductModel> products = [];

        products =
            await _apiService.getAllProducts(1, event.limit, event.category);

        return emit(
          state.copyWith(
            status: ProductStatus.success,
            products: products,
            hasReachedMax: products.length < 20 ? true : false,
          ),
        );
      }

      List<ProductModel> products = [];

      products = await _apiService.getAllProducts(
          state.products.last.productDetails.key, event.limit, event.category);

      products.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: ProductStatus.success,
                products: List.of(state.products)..addAll(products),
                hasReachedMax: false,
              ),
            );
      print(products.length);
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }
}
