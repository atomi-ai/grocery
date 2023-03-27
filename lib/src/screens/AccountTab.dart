import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fryo/src/logic/user_provider.dart';
import 'package:provider/provider.dart';

import '../logic/api_client.dart' as api;
import '../entity/entities.dart' as entities;
import 'Dashboard.dart';

class AccountTab extends StatelessWidget {
  Widget getAddress<T>(Future<T> Function() func) {
    return FutureBuilder<T>(
      future: func(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final t = snapshot.data;
            return Text('${t.street}, ${t.city}, ${t.state}');
          }
        } else {
          return Text('');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

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
                ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Shipping Address'),
                    subtitle: getAddress(api.getDefaultShippingAddress),
                ),
                ListTile(
                  leading: Icon(Icons.payment),
                  title: Text('Billing Address'),
                  subtitle: getAddress(api.getDefaultBillingAddress),
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
