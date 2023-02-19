import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../store.dart';

class CardScreenCubit extends StatelessWidget {
  const CardScreenCubit({super.key});

  @override
  Widget build(BuildContext context) {
    final hastEmptyCard =
        context.select<StoreCubit, bool>((b) => b.state.cartId.isEmpty);
    final cartProducts = context.select<StoreCubit, List<Product>>(
      (b) => b.state.products
          .where((product) => b.state.cartId.contains(product.id))
          .toList(),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
      ),
      body: hastEmptyCard
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Your cart is empty'),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Add product'),
                  )
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: cartProducts.length,
                itemBuilder: (context, index) {
                  final product = cartProducts[index];
                  // final inCart = cartProducts.contains(product.id);
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
                              onPressed: () => context
                                  .read<StoreCubit>()
                                  .removeFromCart(product.id),
                              style: const ButtonStyle(
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.all(10)),
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          Colors.black12)),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.remove_shopping_cart,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Remove to cart',
                                      style: TextStyle(color: Colors.black54),
                                    )
                                  ])),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
