import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../store.dart';

class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Bloc Api',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red.shade500,
        appBarTheme: AppBarTheme(
          color: Colors.red.shade400,
        ),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.red.shade400),
      ),
      home: BlocProvider(
        create: (context) => StoreBloc(),
        child: const _StoreAppView(
          title: 'My Store',
        ),
      ),
    );
  }
}

class _StoreAppView extends StatefulWidget {
  const _StoreAppView({
    required this.title,
  });
  final String title;

  @override
  State<_StoreAppView> createState() => __StoreAppViewState();
}

class __StoreAppViewState extends State<_StoreAppView> {
  void _addToCard(int cartId) {
    context.read<StoreBloc>().add(StoreProductsAddedToCart(cartId));
  }

  void _removeFromCart(int cartId) {
    context.read<StoreBloc>().add(StoreProductsRemoveFromCart(cartId));
  }

  void _viewCart() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero)
              .animate(animation),
          child: BlocProvider.value(
              value: context.read<StoreBloc>(), child: child),
        ),
        pageBuilder: ((_, __, ___) => const CardScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoreBloc, StoreState>(
      listenWhen: (previous, current) =>
          previous.cartId.length != current.cartId.length,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Shopping cart updated'),
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Center(child: BlocBuilder<StoreBloc, StoreState>(
          builder: (context, state) {
            if (state.productsStatus == StoreRequest.requestInProgess) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (state.productsStatus == StoreRequest.requestFailure) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Problem loading products'),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      context.read<StoreBloc>().add(StoreProductsRequested());
                    },
                    child: const Text('Try again'),
                  )
                ],
              );
            }
            if (state.productsStatus == StoreRequest.unknown) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shop_outlined,
                    size: 40,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  const Text('No products to view'),
                  const SizedBox(height: 10),
                  OutlinedButton(
                      onPressed: () {
                        context.read<StoreBloc>().add(StoreProductsRequested());
                      },
                      child: const Text('Load Products'))
                ],
              );
            }
            //if (state.productsStatus == StoreRequest.success)

            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  final inCart = state.cartId.contains(product.id);
                  return Card(
                    margin: const EdgeInsets.all(6.0),
                    child: Column(
                      children: [
                        Flexible(
                          child: Image.network(product.image),
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                            child: Center(
                          child: Text(
                            product.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        )),
                        // const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                              onPressed: inCart
                                  ? () => _removeFromCart(product.id)
                                  : () => _addToCard(product.id),
                              style: ButtonStyle(
                                  padding: const MaterialStatePropertyAll(
                                      EdgeInsets.all(10)),
                                  backgroundColor: inCart
                                      ? const MaterialStatePropertyAll<Color>(
                                          Colors.black12)
                                      : null),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: inCart
                                    ? const [
                                        Icon(
                                          Icons.remove_shopping_cart,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Remove to cart',
                                          style:
                                              TextStyle(color: Colors.black54),
                                        )
                                      ]
                                    : [
                                        const Icon(Icons.add_shopping_cart),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text('Add to cart')
                                      ],
                              )),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        )),
        floatingActionButton: Stack(
          alignment: Alignment.bottomRight,
          clipBehavior: Clip.none,
          children: [
            FloatingActionButton(
              onPressed: _viewCart,
              tooltip: 'View Cart',
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            BlocBuilder<StoreBloc, StoreState>(
              builder: (context, state) {
                if (state.cartId.isEmpty) {
                  return Container();
                }
                return Positioned(
                  right: -4,
                  bottom: 40,
                  child: CircleAvatar(
                    backgroundColor: Colors.pink.shade700,
                    radius: 12,
                    child: Text(
                      state.cartId.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
