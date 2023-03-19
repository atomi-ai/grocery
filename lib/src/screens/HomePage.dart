import 'package:flutter/material.dart';
import 'package:fryo/src/screens/SignInPage.dart';
import 'package:fryo/src/screens/Dashboard.dart'; // 确保已经导入了 Dashboard.dart
import '../shared/styles.dart';
import '../shared/colors.dart';
import '../shared/buttons.dart';

import 'package:page_transition/page_transition.dart';
import './SignUpPage.dart';

class HomePage extends StatefulWidget {
  final String pageTitle;

  HomePage({Key key, this.pageTitle}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rotate,
          duration: Duration(seconds: 1),
          alignment: Alignment.center,
          child: Dashboard(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
      backgroundColor: bgColor,
    );
  }
}
