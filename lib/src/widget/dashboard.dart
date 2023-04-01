import 'package:flutter/material.dart';
import 'package:fryo/src/provider/address_provider.dart';
import 'package:fryo/src/provider/store_provider.dart';
import 'package:fryo/src/screens/sign_in_dialog.dart';
import 'package:provider/provider.dart';

import 'tabs/store_tab.dart';
import '../provider/product_provider.dart';
import '../provider/user_provider.dart';
import 'tabs/account_tab.dart';
import '../shared/colors.dart';
import '../shared/fryo_icons.dart';
import 'dashboard_appbar.dart';
import 'tabs/customize_tab.dart';
import 'tabs/favorites_tab.dart';
import 'tabs/my_cart.dart';

class Dashboard extends StatefulWidget {
  final String pageTitle;

  Dashboard({Key? key, required this.pageTitle}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    //
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // });

    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    storeProvider.getDefaultStore();
    Provider.of<AddressProvider>(context, listen:false).init();

    print('xfguo: _DashboardState::initState()');
  }

  void _showSignInDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许全屏显示
      backgroundColor: Colors.transparent, // 透明背景
      builder: (BuildContext context) {
        return FullScreenSignInDialog();
      },
    );
  }

  @override
  void didUpdateWidget(covariant Dashboard oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    print('xfguo: _DashboardState::didUpdateWidget()');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    print('xfguo: _DashboardState::didChangeDependencies()');
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    if (storeProvider.defaultStore != null) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.getProducts(storeProvider.defaultStore!.id);
    }
  }

  void _checkLoginStatus(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context);
    bool isLoggedIn = await userProvider.isLoggedIn;

    if (!isLoggedIn) {
      _showSignInDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkLoginStatus(context);

    print('xfguo: _DashboardState::build()');
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
          defaultStore: storeProvider.defaultStore ?? null,
          onSelectStore: (store) {
            setState(() {
              storeProvider.saveDefaultStore(context, store);
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
                      backgroundImage: NetworkImage(userProvider.user?.photoURL ?? ''),
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
