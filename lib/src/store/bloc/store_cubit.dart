import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_api_rest/src/store/repository/store_repository.dart';
import 'package:testing_bloc_api_rest/src/store/store.dart';

class StoreCubit extends Cubit<StoreState> {
  StoreCubit() : super(StoreState());

  final StoreRepository api = StoreRepository();

  Future<void> loadProducts() async {
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

  void addToCart(int cartId) async {
    emit(state.copyWith(cartId: {...state.cartId, cartId}));
  }

  void removeFromCart(int cartId) async {
    emit(
      state.copyWith(
        cartId: {...state.cartId}..remove(cartId),
      ),
    );
  }
}
