import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MaterialApp(home: StoreScreen(), debugShowCheckedModeBanner: false,),
    ),
  );
}

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fruit Shop"),
        actions: [
          // THE BADGE: This listens specifically for changes in the cart
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Badge(
                label: Text('${cart.items.length}'),
                child: const Icon(Icons.shopping_cart),
              );
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: ListView(
        children: [
          _ProductTile(product: Product(name: "Apple", price: 1.50)),
          _ProductTile(product: Product(name: "Banana", price: 0.80)),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text("\$${product.price}"),
      trailing: IconButton(
        icon: const Icon(Icons.add_shopping_cart),
        onPressed: () {
          // We use context.read here because we just want to CALL a function,
          // we don't need this specific button to rebuild itself.
          context.read<CartProvider>().addToCart(product);
        },
      ),
    );
  }
}