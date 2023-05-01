import 'package:flutter/material.dart';
import 'package:fryo/src/provider/product_provider.dart';
import 'package:fryo/src/provider/store_provider.dart';
import 'package:fryo/src/provider/user_provider.dart';
import 'package:fryo/src/screens/sign_in_dialog.dart';
import 'package:fryo/src/shared/colors.dart';
import 'package:fryo/src/shared/fryo_icons.dart';
import 'package:fryo/src/widget/dashboard_appbar.dart';
import 'package:fryo/src/widget/tabs/account_tab.dart';
import 'package:fryo/src/widget/tabs/customize_tab.dart';
import 'package:fryo/src/widget/tabs/favorites_tab.dart';
import 'package:fryo/src/widget/tabs/my_cart.dart';
import 'package:fryo/src/widget/tabs/store_tab.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  final String pageTitle;

  Dashboard({Key? key, required this.pageTitle}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final _tabs = [
    StoreTab(),
    MyCart(),
    CustomizedTab(),
    FavoritesTab(),
    AccountTab(),
  ];

  @override
  void initState() {
    super.initState();

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
  void didChangeDependencies() async {
    super.didChangeDependencies();

    print('xfguo: _DashboardState::didChangeDependencies()');

    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    await storeProvider.getDefaultStore();

    if (storeProvider.defaultStore != null) {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await productProvider.getProducts(storeProvider.defaultStore!.id);
    }

    // await Provider.of<AddressProvider>(context, listen:false).init();
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
    // _checkLoginStatus(context);

    print('xfguo: _DashboardState::build()');
    final userProvider = Provider.of<UserProvider>(context);

    return Stack(
      children: [
        AbsorbPointer(
          absorbing: !userProvider.isLoggedIn,
          child: Opacity(
            opacity: userProvider.isLoggedIn ? 1.0 : 0.4,
            child: Scaffold(
                backgroundColor: bgColor,
                appBar: DashboardAppBar(),
                body: _tabs[_selectedIndex],
                bottomNavigationBar: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Fryo.shop),
                      label: 'Store',
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Fryo.cart), label: 'My Cart'),
                    BottomNavigationBarItem(
                        icon: Icon(Fryo.cart), label: 'Customize'),
                    BottomNavigationBarItem(
                        icon: Icon(Fryo.heart_1), label: 'Favorites'),
                    BottomNavigationBarItem(
                      icon: userProvider.isLoggedIn && userProvider.user?.photoURL?.isNotEmpty == true
                          ? CircleAvatar(
                        radius: 14,
                        backgroundImage:
                        NetworkImage(userProvider.user?.photoURL ?? ''),
                      )
                          : Icon(Fryo.user_1),
                      label: 'Account',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  type: BottomNavigationBarType.fixed,
                  fixedColor: Colors.green[600],
                  onTap: (index) => _onItemTapped(index, userProvider),
                )
            ),
          ),
        ),
        if (!userProvider.isLoggedIn)
          FullScreenSignInDialog(),
      ],
    );
  }

  void _onItemTapped(int index, UserProvider userProvider) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
