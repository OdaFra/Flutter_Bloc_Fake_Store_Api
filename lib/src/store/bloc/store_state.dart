// ignore_for_file: public_member_api_docs, sort_constructors_first
// part of 'store_bloc.dart';

// @immutable
//abstract
// class StoreInitial extends StoreState {}

import '../store.dart';

enum StoreRequest {
  unknown,
  requestInProgess,
  requestSucess,
  requestFailure,
}

class StoreState {
  final List<Product> products;
  final StoreRequest productsStatus;
  final Set<int> cartId;

  StoreState({
    this.products = const [],
    this.productsStatus = StoreRequest.unknown,
    this.cartId = const {},
  });

  StoreState copyWith({
    List<Product>? products,
    StoreRequest? productsStatus,
    Set<int>? cartId,
  }) {
    return StoreState(
      products: products ?? this.products,
      productsStatus: productsStatus ?? this.productsStatus,
      cartId: cartId ?? this.cartId,
    );
  }
}
