import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fryo/firebase_options.dart';
import 'package:fryo/src/provider/address_provider.dart';
import 'package:fryo/src/provider/cart_provider.dart';
import 'package:fryo/src/provider/favorites_provider.dart';
import 'package:fryo/src/provider/order_provider.dart';
import 'package:fryo/src/provider/payment_method_provider.dart';
import 'package:fryo/src/provider/product_provider.dart';
import 'package:fryo/src/provider/store_provider.dart';
import 'package:fryo/src/provider/user_provider.dart';
import 'package:fryo/src/api/stripe_api.dart';
import 'package:fryo/src/shared/config.dart';
import 'package:fryo/src/widget/dashboard.dart';
import 'package:provider/provider.dart';

// TODO(lamuguo): Upgrade flutter to newer version (support ? and more)
// TODO(lamuguo): 把fryo的名字改掉。
// TODO(lamuguo): 升级flutter（这个太需要了）
// TODO(lamuguo): Review all providers for data usage.
// TODO(lamuguo): Dart lint / static code check.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'atomi-grocery',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Config.loadConfig();
  await initStripe();

  print('xfguo: main() to run app');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => AtomiPaymentMethodProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    productProvider.startFetchingProducts(context);

    return MaterialApp(
      title: 'Fryo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Dashboard(pageTitle: 'Welcome'),
      routes: <String, WidgetBuilder> {
        // '/signin': (BuildContext context) =>  SignInPage(),
        '/dashboard': (BuildContext context) => Dashboard(pageTitle: 'Dashboard',),
        // '/productPage': (BuildContext context) => ProductPage(),
      },
    );
  }
}
