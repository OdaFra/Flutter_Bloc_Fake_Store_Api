// part of 'store_bloc.dart';

// @immutable
abstract class StoreEvent {
  const StoreEvent();
}

class StoreProductsRequested extends StoreEvent {}

class StoreProductsAddedToCart extends StoreEvent {
  final int cartId;
  const StoreProductsAddedToCart(this.cartId);
}

class StoreProductsRemoveFromCart extends StoreEvent {
  final int cartId;

  const StoreProductsRemoveFromCart(this.cartId);
}
