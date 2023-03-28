import 'package:flutter/material.dart';
import 'package:fryo/src/logic/user_provider.dart';
import 'package:provider/provider.dart';

import '../entity/entities.dart';
import '../logic/account_provider.dart';
import 'address_page.dart';
import 'dashboard.dart';

class AccountTab extends StatefulWidget {
  @override
  _AccountTabState createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  Widget getAddressText(Address t) {
    return Text('${t.street}, ${t.city}, ${t.state}');
  }

  Widget getAddress<T>(AccountProvider provider, Future<T> Function() func) {
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

    final accountProvider = Provider.of<AccountProvider>(context, listen: false);
    accountProvider.fetchShippingAddress();
    accountProvider.fetchBillingAddress();
    print('xfguo: AccountTab::initState()');
  }

  @override
  Widget build(BuildContext context) {
    print('xfguo: AccountTab::build()');
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    final accountProvider = Provider.of<AccountProvider>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (user != null) ...[
            Text('Hello, ${user.displayName}'),
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
                      MaterialPageRoute(builder: (context) => AddressPage()),
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Shipping Address'),
                    subtitle: getAddressText(accountProvider.shippingAddress),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.payment),
                  title: Text('Billing Address'),
                  subtitle: getAddressText(accountProvider.billingAddress),
                ),
                ListTile(
                  leading: Icon(Icons.credit_card),
                  title: Text('Credit Card'),
                  subtitle: Text('**** **** **** 1234'),
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
