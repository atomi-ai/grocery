import 'package:flutter/material.dart';
import 'package:fryo/src/logic/data_provider.dart';
import 'package:provider/provider.dart';

import '../entity/entities.dart';
import '../widget/dashboard_appbar.dart';
import './StoreTab.dart';
import '../logic/user_provider.dart';
import '../screens/AccountTab.dart';
import '../shared/colors.dart';
import '../shared/fryo_icons.dart';
import '../shared/styles.dart';
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

  Future<void> _getDefaultStore() async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    _defaultStore ??= await dataProvider.getDefaultStore();
  }

  @override
  void initState() {
    super.initState();
    _getDefaultStore();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus(context);
    });
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
    UserProvider userProvider = Provider.of<UserProvider>(context);
    DataProvider dataProvider = Provider.of<DataProvider>(context);

    final _tabs = [
      storeTab(context),
      MyCart(),
      CustomizedTab(),
      FavoritesTab(),
      AccountTab(),
    ];

    return Scaffold(
        backgroundColor: bgColor,
        appBar: DashboardAppBar(
          defaultStore: _defaultStore,
          onSelectStore: (store) {
            setState(() {
              _defaultStore = store;
            });
            print('xfguo: select store: ${store.id}');
            dataProvider.setDefaultStore(store);
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
