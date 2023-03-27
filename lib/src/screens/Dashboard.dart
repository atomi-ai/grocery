import 'package:flutter/material.dart';
import 'package:fryo/src/logic/store_provider.dart';
import 'package:provider/provider.dart';

import './StoreTab.dart';
import '../entity/entities.dart';
import '../logic/product_provider.dart';
import '../logic/user_provider.dart';
import '../screens/AccountTab.dart';
import '../shared/colors.dart';
import '../shared/fryo_icons.dart';
import '../widget/dashboard_appbar.dart';
import 'SignInPage.dart';
import 'customiz_tab.dart';
import 'favorites_tab.dart';
import 'my_cart.dart';

class Dashboard extends StatefulWidget {
  final String pageTitle;

  Dashboard({Key key, this.pageTitle}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  Store _defaultStore;

  void _checkLoginStatus(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool isLoggedIn = await userProvider.isLoggedIn;

    if (!isLoggedIn) {
      _showSignInDialog(context);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus(context);
    });

    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    storeProvider.getDefaultStore();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  void _showSignInDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 用户必须点击按钮才能关闭对话框
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign In Required'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You must sign in to access the dashboard.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Sign In'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SignInPage(),
                ));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final storeProvider = Provider.of<StoreProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final _tabs = [
      StoreTab(),
      MyCart(),
      CustomizedTab(),
      FavoritesTab(),
      AccountTab(),
    ];

    return Scaffold(
        backgroundColor: bgColor,
        appBar: DashboardAppBar(
          defaultStore: storeProvider.defaultStore,
          onSelectStore: (store) {
            setState(() {
              storeProvider.setDefaultStore(context, store);
              productProvider.getProducts(store.id);
            });
          },
        ),
        body: _tabs[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Fryo.shop),
              label: 'Store',
            ),
            BottomNavigationBarItem(icon: Icon(Fryo.cart), label: 'My Cart'),
            BottomNavigationBarItem(icon: Icon(Fryo.cart), label: 'Customize'),
            BottomNavigationBarItem(
                icon: Icon(Fryo.heart_1), label: 'Favorites'),
            BottomNavigationBarItem(
              icon: userProvider.isLoggedIn
                  ? CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(userProvider.user.photoURL),
                    )
                  : Icon(Fryo.user_1),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.green[600],
          onTap: (index) => _onItemTapped(index, userProvider),
        ));
  }

  void _onItemTapped(int index, UserProvider userProvider) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
