import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_api_rest/src/store/repository/store_repository.dart';
import '../store.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreState()) {
    on<StoreProductsRequested>(_handleStoreProductsRequested);
    on<StoreProductsAddedToCart>(_handleStoreProductsAddedToCart);
    on<StoreProductsRemoveFromCart>(_handleStoreProductsRemoveFromCart);
  }
  final StoreRepository api = StoreRepository();

  Future<void> _handleStoreProductsRequested(
      StoreProductsRequested event, Emitter<StoreState> emit) async {
    try {
      emit(state.copyWith(
        productsStatus: StoreRequest.requestInProgess,
      ));
      final response = await api.getProducts();
      emit(state.copyWith(
        productsStatus: StoreRequest.requestSucess,
        products: response,
      ));
    } catch (e) {
      emit(state.copyWith(productsStatus: StoreRequest.requestFailure));
    }
  }

  FutureOr<void> _handleStoreProductsAddedToCart(
      StoreProductsAddedToCart event, Emitter<StoreState> emit) async {
    emit(state.copyWith(cartId: {...state.cartId, event.cartId}));
  }

  FutureOr<void> _handleStoreProductsRemoveFromCart(
      StoreProductsRemoveFromCart event, Emitter<StoreState> emit) {
    emit(
      state.copyWith(
        cartId: {...state.cartId}..remove(event.cartId),
      ),
    );
  }
}
