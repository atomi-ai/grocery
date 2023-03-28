import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:provider/provider.dart';

import '../entity/entities.dart';
import '../logic/cart_provider.dart';
import '../logic/product_provider.dart';

class CheckoutPage extends StatefulWidget {
  final double total;

  CheckoutPage({this.total});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _paymentMethod = 'Credit Card';

  Widget _buildOrderSummary(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    double total = 0.0;
    double shippingCost = 5.0;
    double tax = 0.0;
    List<Widget> itemsList = [];

    for (var e in cartProvider.cartItems.entries) {
      int productId = e.key;
      int quantity = e.value;
      Product product = productProvider.productsMap[productId];
      double price = product.price * quantity;
      total += price;

      itemsList.add(
        Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0),
            child: Row(
              children: [
                Image.asset(
                  product.imageUrl,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        '${quantity} x \$${product.price}',
                        style: TextStyle(fontSize: 14.0, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
    }

    List<Widget> columnItems = [];
    columnItems.add(
      Container(
        alignment: Alignment.center,
        child: Text(
          'Order Summary',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );

    columnItems.add(
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 180),
        child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: itemsList.length,
          itemBuilder: (BuildContext context, int index) => itemsList[index],
        ),
      ),
    );

    // TODO(lamuguo): Call some API to calculate shipping cost and tax.
    var subtotal = total;
    total += shippingCost + tax;

    columnItems.add(Divider());
    columnItems.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '\$${subtotal.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );

    columnItems.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shipping Cost:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '\$${shippingCost.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
    columnItems.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tax:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '\$${tax.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
    columnItems.add(
      Divider(thickness: 2.0),
    );
    columnItems.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnItems,
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            'Payment Method',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        stripe.CardField(
          controller: stripe.CardEditController(),
        ),
      ],
    );
  }

  Widget _buildShippingAddress() {
    bool _hasShippingAddress = false;
    String _shippingAddress = '123 Main St, Anytown, USA';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            'Shipping Address',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: _hasShippingAddress
              ? Container(child: Text(_shippingAddress))
              : ElevatedButton(
                  onPressed: () {
                    // Implement add shipping address logic here
                  },
                  child: Text('Add Shipping Address'),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(context),
            // SizedBox(height: 10),
            // _buildShippingAddress(),
            SizedBox(height: 10),
            _buildPaymentMethod(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${(widget.total + 6.0).toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              ElevatedButton(
                onPressed: () {
                  // Implement place order logic here
                },
                child: Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
