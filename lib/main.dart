import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fryo/src/screens/SignInPage.dart';
import 'package:provider/provider.dart';

import './src/logic/cart_provider.dart';
import './src/logic/user_provider.dart';
import './src/logic/product_data.dart';
import './src/screens/Dashboard.dart';
import './src/screens/ProductPage.dart';
import './src/shared/config.dart';
import 'firebase_options.dart';

void main() async {
  initProducts();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Config.loadConfig();
  print('xfguo: main() to run app');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
