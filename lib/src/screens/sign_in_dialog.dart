import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fryo/src/api/api_client.dart' as api;
import 'package:fryo/src/provider/user_provider.dart';
import 'package:fryo/src/widget/dashboard.dart';
import 'package:fryo/src/widget/util.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class FullScreenSignInDialog extends StatefulWidget {
  @override
  _FullScreenSignInDialogState createState() => _FullScreenSignInDialogState();
}

class _FullScreenSignInDialogState extends State<FullScreenSignInDialog> {


  Future<void> _signInWithGoogle(BuildContext context, GoogleSignIn googleSignIn) async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('User cancelled sign in');
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    print('xfguo: userCredential = ${userCredential}, googleUser = ${googleUser}');
    // Call backend to make sure the user is registered in the backend.

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userCredential.user;
    if (user == null) {
      throw Exception("Get null user in /login, please retry");
    }
    await userProvider.login(user);
    await refreshProviders(context);
    // 登录成功后，导航回Dashboard
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Dashboard(pageTitle: 'Welcome'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Sign In Required',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto', // or any other font family you prefer
                color: Colors.black, // or any other color you prefer
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'You must sign in to access the dashboard.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto', // or any other font family you prefer
                color: Colors.black, // or any other color you prefer
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final GoogleSignIn googleSignIn = GoogleSignIn();
                _signInWithGoogle(context, googleSignIn);
              },
              child: Text('Sign In with Last Google Account'),
            ),
            SizedBox(height: 20), // Add some space between the buttons
            ElevatedButton(
              onPressed: () async {
                final GoogleSignIn googleSignIn = GoogleSignIn();
                await googleSignIn.disconnect();
                _signInWithGoogle(context, googleSignIn);
              },
              child: Text('Sign In with Other Google Account'),
            ),
          ],
        ),
      ),
    );
  }
}
