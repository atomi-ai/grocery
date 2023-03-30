import 'package:flutter/material.dart';
import 'package:fryo/src/logic/payment_method_provider.dart';
import 'package:fryo/src/logic/user_provider.dart';
import 'package:fryo/src/screens/payment_method_page.dart';
import 'package:provider/provider.dart';

import '../entity/entities.dart';
import '../logic/address_provider.dart';
import '../widget/util.dart';
import 'address_page.dart';
import 'dashboard.dart';

class AccountTab extends StatefulWidget {
  @override
  _AccountTabState createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  Widget getAddress<T>(AddressProvider provider, Future<T> Function() func) {
    return FutureBuilder(
      future: func(),
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return getAddressText(provider.shippingAddress);
      },
    );
  }

  Widget aaa(BuildContext context) {
    return Text('');
  }

  @override
  void initState() {
    super.initState();

    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    addressProvider.fetchShippingAddress();
    addressProvider.fetchBillingAddress();
    print('xfguo: AccountTab::initState()');
  }

  @override
  Widget build(BuildContext context) {
    print('xfguo: AccountTab::build()');
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    final accountProvider = Provider.of<AddressProvider>(context);
    final pmProvider = Provider.of<AtomiPaymentMethodProvider>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (user != null) ...[
            SizedBox(height: 10),
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL),
              radius: 40,
            ),
            SizedBox(height: 20),
          ],
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(user?.displayName ?? ''),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text(user?.email ?? ''),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddressPage(is_shipping: true)),
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Shipping Address'),
                    subtitle: getAddressText(accountProvider.shippingAddress),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddressPage(is_shipping: false)),
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Billing Address'),
                    subtitle: getAddressText(accountProvider.billingAddress),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.payment),
                  title: Text('Payment Method'),
                  subtitle: Text(pmProvider.currentPaymentMethodId?.toString() ?? 'No payment method selected'),
                  onTap: () async {
                    final pmId = await showDialog<String>(
                        context: context,
                        builder: (context) => PaymentMethodDialog(),
                    );
                    print('xfguo: pmId = ${pmId}');
                    Provider.of<AtomiPaymentMethodProvider>(context, listen: false)
                        .setCurrentPaymentMethod(pmId);
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await userProvider.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Dashboard(pageTitle: 'Welcome'),
                ),
              );
            },
            child: Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
