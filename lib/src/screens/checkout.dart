import 'package:flutter/material.dart';
import 'package:fryo/src/api/backend_api.dart';
import 'package:fryo/src/entity/entities.dart';
import 'package:fryo/src/entity/payment_intent_request.dart';
import 'package:fryo/src/entity/uber.dart';
import 'package:fryo/src/provider/address_provider.dart';
import 'package:fryo/src/provider/cart_provider.dart';
import 'package:fryo/src/provider/order_provider.dart';
import 'package:fryo/src/provider/payment_method_provider.dart';
import 'package:fryo/src/provider/store_provider.dart';
import 'package:fryo/src/screens/address_selector.dart';
import 'package:fryo/src/screens/payment_method_dialog.dart';
import 'package:fryo/src/widget/util.dart';
import 'package:provider/provider.dart';

enum DeliveryMethod { Pickup, UberDelivery }

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  DeliveryMethod _deliveryMethod = DeliveryMethod.Pickup;
  double _shippingCost = 0.0;
  double _tax_rate = 0.0;
  TaxInfo? _taxInfo;
  double _total = 0.0;
  UberQuoteResult? _uberQuoteResult;
  Address? _shippingAddress;
  late String _currentPaymentMethodId;
  Future<PaymentResult?>? _paymentResultFuture;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final addressProvider = Provider.of<AddressProvider>(
        context, listen: false);
    addressProvider.init();
    final pmProvider = Provider.of<AtomiPaymentMethodProvider>(context, listen: false);
    pmProvider.fetchPaymentMethods();
    _getTaxInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _shippingAddress = Provider.of<AddressProvider>(context).shippingAddress;
    _currentPaymentMethodId =
        Provider.of<AtomiPaymentMethodProvider>(context).currentPaymentMethodId;
  }

  double _calculateTotal() {
    double total = 0.0;
    OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);
    List<OrderItem> orderItems = orderProvider.currentOrder!.orderItems;
    for (var e in orderItems) {
      int quantity = e.quantity;
      Product product = e.product;
      double price = product.price * quantity;
      total += price;
    }
    return total;
  }

  Future<void> _getTaxInfo() async {
    String postalCode = '';
    String state = '';
    if (_deliveryMethod == DeliveryMethod.Pickup) {
      final storeProvider = Provider.of<StoreProvider>(context, listen: false);
      postalCode = storeProvider.defaultStore!.zipCode;
      state = storeProvider.defaultStore!.state;
    } else if (_shippingAddress != null && _shippingAddress!.postalCode != '') {
        postalCode = _shippingAddress!.postalCode;
        state = _shippingAddress!.state;
    }
    if (postalCode != '') {
      TaxAddress taxAddress = TaxAddress(
        postalCode: postalCode,
        state: state,
      );
      _taxInfo = await getTaxRate(taxAddress);
    } else {
      _taxInfo = TaxInfo(estimatedCombinedRate: 0.0);
    }
    double subtotal = _calculateTotal();
    _tax_rate = _taxInfo!.estimatedCombinedRate;
    double tax = subtotal * _tax_rate;
    setState(() {
      _total = subtotal + _shippingCost + tax;
    });
  }

  Widget _buildOrderSummary(BuildContext context) {
    OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);
    List<OrderItem> orderItems = orderProvider.currentOrder!.orderItems;
    List<Widget> itemsList = [];

    for (var e in orderItems) {
      int quantity = e.quantity;
      Product product = e.product;
      double price = product.price * quantity;

      itemsList.add(
        Card(
          child: Row(
            children: [
              Image.network(
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

    columnItems.add(_buildDeliveryMethodSelector());

    if (_taxInfo == null) {
      columnItems.add(CircularProgressIndicator());
    } else {
      // 显示订单总结信息
      double subtotal = _calculateTotal();
      double tax = subtotal * _tax_rate;
      columnItems.add(Divider());
      columnItems.add(Padding(
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
      ));
      columnItems.add(Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shipping Cost:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '\$${_shippingCost.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ));
      columnItems.add(Padding(
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
      ));
      columnItems.add(Divider(thickness: 2.0));
      columnItems.add(Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${_total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnItems,
    );

  }

  Widget _buildDeliveryMethodSelector() {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Delivery Method:',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        ListTile(
          leading: Radio<DeliveryMethod>(
            value: DeliveryMethod.Pickup,
            groupValue: _deliveryMethod,
            onChanged: (DeliveryMethod? value) {
              setState(() {
                _deliveryMethod = value!;
                _shippingCost = 0.0;
                _uberQuoteResult = null;
              });
              _getTaxInfo();
            },
          ),
          title: Text('In-Store Pickup'),
        ),
        ListTile(
          leading: Radio<DeliveryMethod>(
            value: DeliveryMethod.UberDelivery,
            groupValue: _deliveryMethod,
            onChanged: (DeliveryMethod? value) async {
              if (_shippingAddress == null || _shippingAddress!.getAddressString().isEmpty ||
                      _nameController.text.isEmpty || _phoneController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please select a shipping address and enter the pickup name and phone number.'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              setState(() {
                _deliveryMethod = value!;
              });
              // Call API to calculate shipping cost
              UberQuoteRequest uberQuoteRequest = UberQuoteRequest(
                dropoffAddress: _shippingAddress!.getAddressString(),
                dropoffName: _nameController.text,
                dropoffPhoneNumber: _phoneController.text,
                pickupAddress: storeProvider.defaultStore!.getAddressString(),
                pickupName: storeProvider.defaultStore!.name,
                pickupPhoneNumber: storeProvider.defaultStore!.phone,
              );
              UberQuoteResult uberQuoteResult = await getUberQuote(uberQuoteRequest);
              if (uberQuoteResult.result == UberQuoteResultStatus.SUCCEEDED && uberQuoteResult.id.isNotEmpty) {
                setState(() {
                  _shippingCost = uberQuoteResult.fee.toDouble() / 100.0;
                  _uberQuoteResult = uberQuoteResult;
                });
                _getTaxInfo();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Uber delivery not available.'),
                    duration: Duration(seconds: 2),
                  ),
                );
                setState(() {
                  _deliveryMethod = DeliveryMethod.Pickup;
                  _shippingCost = 0.0;
                  _uberQuoteResult = null;
                });
              }
            },
          ),
          title: Text('Uber Delivery'),
        ),
        if (_deliveryMethod == DeliveryMethod.UberDelivery) _buildUberDeliveryInfo(),
      ],
    );
  }

  Widget _buildDropoffInfo() {
    bool canEdit = _deliveryMethod == DeliveryMethod.Pickup;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Enter Name',
          ),
          enabled: canEdit,  // 根据 _deliveryMethod 设置是否可以编辑
        ),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
            hintText: 'Enter Phone Number',
          ),
          enabled: canEdit,  // 根据 _deliveryMethod 设置是否可以编辑
        ),
      ],
    );
  }

  Widget _buildUberDeliveryInfo() {
    if (_uberQuoteResult == null) {
      return Center(child: CircularProgressIndicator());
    } else if (_uberQuoteResult!.result != UberQuoteResultStatus.SUCCEEDED || _uberQuoteResult!.id.isEmpty) {
      return Text('Uber delivery not available.');
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Duration: ${_uberQuoteResult!.duration}'),
          Text('Expires: ${_uberQuoteResult!.expires}'),
        ],
      );
    }
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<AtomiPaymentMethodProvider>(
          builder: (context, pmProvider, child) {
            return GestureDetector(
              onTap: () async {
                final String? pmId = await showDialog<String>(
                  context: context,
                  builder: (context) => PaymentMethodDialog(),
                );
                print('xfguo: pmId = ${pmId}');
                await pmProvider.setCurrentPaymentMethod(pmId);
              },
              child: ListTile(
                leading: Icon(Icons.payment),
                title: Text('Payment Method'),
                subtitle:
                    getPaymentMethodText(pmProvider.getCurrentPaymentMethod()),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildShippingAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            final newSelectedAddress = await showDialog<Address>(
                context: context,
                builder: (context) {
                  return AddressSelector(
                      defaultAddress: _shippingAddress ?? Address.UNSET_ADDRESS);
                });
            if (newSelectedAddress == null) {
              return;
            }
            print('xfguo: new selectedBillingAddress: ${newSelectedAddress}');
            if (_deliveryMethod == DeliveryMethod.UberDelivery) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('The address has been changed. Please select the delivery method again'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
            setState(() {
              _shippingAddress = newSelectedAddress;
              _deliveryMethod = DeliveryMethod.Pickup;
              _shippingCost = 0.0;
              _uberQuoteResult = null;
            });
            _getTaxInfo();
          },
          child: ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Shipping Address'),
            subtitle: getAddressText(_shippingAddress),
          ),
        ),
      ],
    );
  }

  void showPaymentDialog(BuildContext context, PaymentResult? paymentResult) {
    bool success = paymentResult?.result == PaymentResultStatus.SUCCEEDED;
    String title = success ? "Payment Successful" : "Payment Failed";
    String message = success
        ? "Your payment has been processed successfully."
        : "There was an error processing your payment.";

    Widget statusSection = success
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text("Payment ID: ${paymentResult!.id}",
                  style: TextStyle(fontSize: 12)),
              Text("Status: ${paymentResult.status}",
                  style: TextStyle(fontSize: 12)),
            ],
          )
        : Container();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              statusSection,
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Return to the previous page
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);
    List<OrderItem> orderItems = orderProvider.currentOrder!.orderItems;
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
                _buildDropoffInfo(),
                _buildShippingAddress(),
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
                'Total: \$${_total.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              FutureBuilder<PaymentResult?>(
                future: _paymentResultFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    if (snapshot.hasData) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showPaymentDialog(context, snapshot.data);
                      });
                    }
                    return ElevatedButton(
                      onPressed: () async {
                        if (_deliveryMethod == DeliveryMethod.UberDelivery &&
                            (_nameController.text.isEmpty || _phoneController.text.isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter the pickup name and phone number.')),
                          );
                          return;
                        }
                        if (_deliveryMethod == DeliveryMethod.UberDelivery) {
                          DateTime expiryTime = DateTime.parse(_uberQuoteResult!.expires);
                          DateTime now = DateTime.now().toUtc();
                          if (expiryTime.difference(now).inMinutes < 2) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Uber delivery order is close to expiry. Please reselect.')),
                            );
                            setState(() {
                              _deliveryMethod = DeliveryMethod.Pickup;
                              _shippingCost = 0.0;
                              _uberQuoteResult = null;
                            });
                            return;
                          }
                        }

                        OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);
                        UberDeliveryData? deliveryData;
                        if (_deliveryMethod == DeliveryMethod.UberDelivery) {
                          deliveryData = UberDeliveryData(
                            quoteId: _uberQuoteResult!.id,
                            dropoffAddress: _shippingAddress!.getAddressString(),
                            dropoffName: _nameController.text,
                            dropoffPhoneNumber: _phoneController.text,
                            manifestItems: orderItems.map((orderItem) {
                              return ManifestItem(
                                name: orderItem.product.name,
                                quantity: orderItem.quantity,
                              );
                            }).toList(),
                            pickupAddress: storeProvider.defaultStore!.getAddressString(),
                            pickupName: storeProvider.defaultStore!.name,
                            pickupPhoneNumber: storeProvider.defaultStore!.phone,
                          );
                        }
                        PaymentIntentRequest piReq = PaymentIntentRequest(
                          amount: (_total * 100).round(),
                          paymentMethodId: _currentPaymentMethodId,
                          shippingAddressId: _shippingAddress?.id ?? -1,
                          orderId: orderProvider.currentOrder!.id!,
                          deliveryData: deliveryData,
                        );
                        print('xfguo: place order, ${piReq}');
                        setState(() {
                          _paymentResultFuture = placeOrder(piReq);
                        });
                        cartProvider.clearCart();
                      },
                      child: Text('Place Order'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
