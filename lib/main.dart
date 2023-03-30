import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fryo/src/logic/product_provider.dart';
import 'package:fryo/src/logic/store_provider.dart';
import 'package:fryo/src/screens/SignInPage.dart';
import 'package:provider/provider.dart';

import './src/logic/cart_provider.dart';
import './src/logic/favorites_provider.dart';
import './src/logic/user_provider.dart';
import './src/screens/ProductPage.dart';
import './src/screens/dashboard.dart';
import './src/shared/config.dart';
import 'firebase_options.dart';
import 'src/logic/address_provider.dart';
import 'src/logic/payment_method_provider.dart';

Future<void> initStripe() async {
  Stripe.publishableKey = "pk_test_b23w3aM03rrkeOOFbpp2pPWJ";
  await Stripe.instance.applySettings();
}

// TODO(lamuguo): Upgrade flutter to newer version (support ? and more)
// TODO(lamuguo): 把fryo的名字改掉。
// TODO(lamuguo): 升级flutter（这个太需要了）
// TODO(lamuguo): Review all providers for data usage.
// TODO(lamuguo): Dart lint / static code check.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Config.loadConfig();
  initStripe();

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
        '/signin': (BuildContext context) =>  SignInPage(),
        '/dashboard': (BuildContext context) => Dashboard(),
        '/productPage': (BuildContext context) => ProductPage(),
      },
    );
  }
}
