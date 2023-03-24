import 'package:flutter/material.dart';
import 'package:fryo/src/logic/product_data.dart';
import 'package:provider/provider.dart';

import '../entity/entities.dart';
import '../logic/cart_provider.dart';
import '../shared/styles.dart';

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  Widget _buildCartItem(BuildContext context, Product product, int quantity) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product image
            Image.asset(
              product.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),

            // Product name and price
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '\$${product.price}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            // Quantity controls
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => cartProvider.decrementQuantity(product),
                      icon: Icon(Icons.remove),
                    ),
                    Text(
                      '$quantity',
                      style: TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      onPressed: () => cartProvider.incrementQuantity(product),
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),

                // Total price
                Text(
                  '\$${(product.price * quantity).toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: ListView.builder(
        itemCount: cartProvider.cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          int productId = cartProvider.cartItems.keys.elementAt(index);
          int quantity = cartProvider.cartItems[productId];
          Product product = productsMap[productId];
          return _buildCartItem(context, product, quantity);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${_calculateTotal(cartProvider).toStringAsFixed(2)}',
                style: h5,
              ),
              ElevatedButton(
                onPressed: () {
                  // Implement checkout logic here
                },
                child: Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTotal(CartProvider cartProvider) {
    double total = 0.0;
    cartProvider.cartItems.forEach((productId, quantity) {
      final product = productsMap[productId];
      total += product.price * quantity;
    });
    return total;
  }
}
