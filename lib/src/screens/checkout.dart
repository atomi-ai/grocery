import 'package:flutter/material.dart';
import 'package:fryo/src/entity/payment_intent_request.dart';
import 'package:fryo/src/provider/address_provider.dart';
import 'package:fryo/src/api/backend_api.dart';
import 'package:fryo/src/screens/address_selector.dart';
import 'package:provider/provider.dart';

import '../entity/entities.dart';
import '../provider/cart_provider.dart';
import '../provider/payment_method_provider.dart';
import '../provider/product_provider.dart';
import '../widget/util.dart';
import 'payment_method_dialog.dart';

class CheckoutPage extends StatefulWidget {
  // TODO(lamuguo): Change the type to int.
  final double total;

  CheckoutPage({required this.total});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late Address _shippingAddress;
  late String _currentPaymentMethodId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _shippingAddress = Provider.of<AddressProvider>(context).shippingAddress;
    _currentPaymentMethodId = Provider.of<AtomiPaymentMethodProvider>(context).currentPaymentMethodId;
  }

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
      if (!productProvider.productsMap.containsKey(productId)) {
        continue;
      }
      Product product = productProvider.productsMap[productId]!;
      double price = product.price * quantity;
      total += price;

      itemsList.add(
        Card(
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
      ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: itemsList.length,
        itemBuilder: (BuildContext context, int index) => itemsList[index],
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
        GestureDetector(
          onTap: () async {
            final String? pmId = await showDialog<String>(
              context: context,
              builder: (context) => PaymentMethodDialog(),
            );
            print('xfguo: pmId = ${pmId}');
            Provider.of<AtomiPaymentMethodProvider>(context, listen: false)
                .setCurrentPaymentMethod(pmId);
          },
          child: ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payment Method'),
            subtitle: Text(_currentPaymentMethodId),
          ),
        ),
      ],
    );
  }

  Widget _buildShippingAddress() {
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
        GestureDetector(
          onTap: () async {
            final newSelectedAddress = await showDialog<Address>(
                context: context,
                builder: (context) {
                  return AddressSelector(
                      defaultAddress:
                          Provider.of<AddressProvider>(context, listen: false)
                              .shippingAddress);
                });
            if (newSelectedAddress == null) {
              return;
            }
            print('xfguo: new selectedBillingAddress: ${newSelectedAddress}');
            setState(() {
              _shippingAddress = newSelectedAddress;
            });
          },
          child: ListTile(
            leading: Icon(Icons.location_on),
            subtitle: getAddressText(_shippingAddress),
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderSummary(context),
                // SizedBox(height: 10),
                _buildShippingAddress(),
                SizedBox(height: 10),
                _buildPaymentMethod(),
              ],
            ),
          )),
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
                onPressed: () async {
                  // Implement place order logic here
                  PaymentIntentRequest piReq = PaymentIntentRequest(
                    amount: 1111,
                    paymentMethodId: _currentPaymentMethodId,
                    shippingAddressId: _shippingAddress.id,
                  );
                  print('xfguo: place order, ${piReq}');
                  await placeOrder(piReq);
                  cartProvider.clearCart();
                  Navigator.pop(context);
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
