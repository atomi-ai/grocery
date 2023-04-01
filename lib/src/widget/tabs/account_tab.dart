import 'package:flutter/material.dart';
import 'package:fryo/src/provider/payment_method_provider.dart';
import 'package:fryo/src/provider/user_provider.dart';
import 'package:fryo/src/screens/address_selector.dart';
import 'package:fryo/src/screens/payment_method_dialog.dart';
import 'package:provider/provider.dart';

import '../../entity/entities.dart';
import '../../provider/address_provider.dart';
import '../dashboard.dart';
import '../util.dart';

class AccountTab extends StatefulWidget {
  @override
  _AccountTabState createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  Widget getAddress<T>(AddressProvider provider, Future<T> Function() func) {
    return FutureBuilder(
      future: func(),
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
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
    final addressProvider = Provider.of<AddressProvider>(context);
    final pmProvider = Provider.of<AtomiPaymentMethodProvider>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (user != null) ...[
            SizedBox(height: 10),
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL ?? ''),
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
                  onTap: () async {
                    final selectedAddr = await showDialog<Address>(
                        context: context,
                        builder: (context) => AddressSelector(defaultAddress: addressProvider.shippingAddress),
                    );
                    if (selectedAddr != null) {
                      await addressProvider.saveShippingAddress(selectedAddr);
                    }
                  },
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Default Shipping Address'),
                    subtitle: getAddressText(addressProvider.shippingAddress),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final selectedAddr = await showDialog<Address>(
                      context: context,
                      builder: (context) => AddressSelector(defaultAddress: addressProvider.billingAddress),
                    );
                    if (selectedAddr != null) {
                      await addressProvider.saveBillingAddress(selectedAddr);
                    }
                  },
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Default Billing Address'),
                    subtitle: getAddressText(addressProvider.billingAddress),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.payment),
                  title: Text('Payment Method'),
                  subtitle: getPaymentMethodText(pmProvider.findPaymentMethodById(
                      pmProvider.currentPaymentMethodId)),
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
              print('xfguo: before logout: isLoggedIn = ${userProvider.isLoggedIn}, ${userProvider.user}');
              await userProvider.logout();
              print('xfguo: after1 logout: isLoggedIn = ${userProvider.isLoggedIn}, ${userProvider.user}');
              await refreshProviders(context);

              print('xfguo: after logout: isLoggedIn = ${userProvider.isLoggedIn}, ${userProvider.user}');
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
