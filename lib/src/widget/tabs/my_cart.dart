import 'package:flutter/material.dart';
import 'package:fryo/src/provider/order_provider.dart';
import 'package:provider/provider.dart';

import 'package:fryo/src/entity/entities.dart';
import 'package:fryo/src/provider/cart_provider.dart';
import 'package:fryo/src/provider/product_provider.dart';
import 'package:fryo/src/shared/styles.dart';
import 'package:fryo/src/screens/checkout.dart';

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  Future<Order?>? _orderFuture;
  bool _orderProcessed = false;

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
    final productProvider = Provider.of<ProductProvider>(context);

    final total = cartProvider.calculateTotal(
      cartProvider.cartItems, productProvider.productIdsInCurrentStore, productProvider.productsMap);
    OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: ListView.builder(
        itemCount: cartProvider.cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          int productId = cartProvider.cartItems.keys.elementAt(index);
          if (!cartProvider.cartItems.containsKey(productId) || !productProvider.productsMap.containsKey(productId)) {
            print('xfguo: (ERROR) not found product(${productId}) in cartItems or productMap.');
            return SizedBox.shrink();
          }
          int quantity = cartProvider.cartItems[productId]!;
          Product product = productProvider.productsMap[productId]!;
          return _buildCartItem(context, product, quantity);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!cartProvider.cartItemsInCurrentStore(
                  cartProvider.cartItems, productProvider.productIdsInCurrentStore))
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Warning: Some items are not available in this store.',
                        style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${total.toStringAsFixed(2)}',
                    style: h5,
                  ),
                  FutureBuilder<Order?>(
                    future: _orderFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        if (snapshot.hasData && !_orderProcessed) {
                          _orderProcessed = true;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // 将currentOrder设置为添加的订单
                            orderProvider.currentOrder = snapshot.data;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(),
                              ),
                            );
                          });
                        }
                        return ElevatedButton(
                          onPressed: () async {
                            // 调用addOrder方法添加订单
                            Order newOrder = cartProvider.createOrderFromCart(productProvider.productIdsInCurrentStore, productProvider.productsMap);
                            setState(() {
                              _orderFuture = orderProvider.addOrder(newOrder);
                              _orderProcessed = false;
                            });
                          },
                          child: Text('Checkout'),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
