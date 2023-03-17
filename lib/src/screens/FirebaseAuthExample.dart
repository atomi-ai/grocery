import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthExample extends StatefulWidget {
  @override
  _FirebaseAuthExampleState createState() => _FirebaseAuthExampleState();
}

class _FirebaseAuthExampleState extends State<FirebaseAuthExample> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _registerWithEmailPassword() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print("User registered: ${userCredential.user?.email}");
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _signInWithEmailPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print("User signed in: ${userCredential.user?.email}");
      print(userCredential);
      String idToken = await FirebaseAuth.instance.currentUser.getIdToken(true);
      print('user token ${idToken}');
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Auth Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _registerWithEmailPassword,
              child: Text('Register'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signInWithEmailPassword,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
