import 'package:flutter/material.dart';
import 'package:fryo/src/entity/entities.dart';
import 'package:fryo/src/provider/address_provider.dart';
import 'package:fryo/src/provider/payment_method_provider.dart';
import 'package:fryo/src/provider/user_provider.dart';
import 'package:fryo/src/screens/address_selector.dart';
import 'package:fryo/src/screens/orders_page.dart';
import 'package:fryo/src/screens/payment_method_dialog.dart';
import 'package:fryo/src/widget/dashboard.dart';
import 'package:fryo/src/widget/util.dart';
import 'package:provider/provider.dart';

class AccountTab extends StatefulWidget {
  @override
  _AccountTabState createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  @override
  void initState() {
    super.initState();

    final addressProvider = Provider.of<AddressProvider>(
        context, listen: false);
    addressProvider.fetchShippingAddress();
    addressProvider.fetchBillingAddress();
    final pmProvider = Provider.of<AtomiPaymentMethodProvider>(context, listen: false);
    pmProvider.fetchPaymentMethods();
    print('xfguo: AccountTab::initState()');
  }

  Widget _customListTile({required IconData icon, required String title, Widget? subtitle}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              if (subtitle != null) subtitle,
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('xfguo: AccountTab::build()');
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    final addressProvider = Provider.of<AddressProvider>(context);
    final pmProvider = Provider.of<AtomiPaymentMethodProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView(
        children: [
          SizedBox(height: 20),
          if (user != null) ...[
            CircleAvatar(
              backgroundImage: user.photoURL?.isNotEmpty == true
                  ? NetworkImage(user.photoURL!)
                  : null,
              radius: 40,
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Center(
                child: Text(
                  user.displayName ?? '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Center(
                child: Text(
                  user.email ?? '',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
          Card(
            child: GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrdersPage(),
                  ),
                );
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 60),
                child: _customListTile(
                  icon: Icons.assignment, // 这是一个表示订单的图标
                  title: 'My Orders',
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final selectedAddr = await showDialog<Address>(
                      context: context,
                      builder: (context) => AddressSelector(
                          defaultAddress: addressProvider.shippingAddress ?? Address.UNSET_ADDRESS),
                    );
                    if (selectedAddr != null) {
                      await addressProvider.saveShippingAddress(selectedAddr);
                    }
                  },
                  child: _customListTile(
                    icon: Icons.location_on,
                    title: 'Default Shipping Address',
                    subtitle: getAddressText(addressProvider.shippingAddress),
                  ),
                ),
                Divider(),
                GestureDetector(
                  onTap: () async {
                    final selectedAddr = await showDialog<Address>(
                      context: context,
                      builder: (context) => AddressSelector(
                          defaultAddress: addressProvider.billingAddress ?? Address.UNSET_ADDRESS),
                    );
                    if (selectedAddr != null) {
                      await addressProvider.saveBillingAddress(selectedAddr);
                    }
                  },
                  child: _customListTile(
                    icon: Icons.location_on,
                    title: 'Default Billing Address',
                    subtitle: getAddressText(addressProvider.billingAddress),
                  ),
                ),
                Divider(),
                GestureDetector(
                  onTap: () async {
                    final pmId = await showDialog<String>(
                      context: context,
                      builder: (context) => PaymentMethodDialog(),
                    );
                    print('xfguo: pmId = ${pmId}');
                    Provider.of<AtomiPaymentMethodProvider>(
                        context, listen: false)
                        .setCurrentPaymentMethod(pmId);
                  },
                  child: _customListTile(
                    icon: Icons.payment,
                    title: 'Payment Method',
                    subtitle: getPaymentMethodText(
                        pmProvider.findPaymentMethodById(
                            pmProvider.currentPaymentMethodId)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                print('xfguo: before logout: isLoggedIn = ${userProvider
                    .isLoggedIn}, ${userProvider.user}');
                await userProvider.logout();
                print('xfguo: after1 logout: isLoggedIn = ${userProvider
                    .isLoggedIn}, ${userProvider.user}');
                await refreshProviders(context);

                print('xfguo: after logout: isLoggedIn = ${userProvider
                    .isLoggedIn}, ${userProvider.user}');
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Dashboard(pageTitle: 'Welcome'),
                  ),
                );
              },
              child: Text('Log Out'),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}