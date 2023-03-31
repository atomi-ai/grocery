import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../shared/config.dart';
import 'api_client.dart';

// TODO(lamuguo): Move the function to api_client.dart
Future<void> backendLogin() async {
  String token = await getCurrentToken();
  print('xfguo: id token = ${token}');
  final response = await http.get(
    Uri.parse("${Config.instance.apiUrl}/login"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  int statusCode = response.statusCode;
  if (statusCode != 200) {
    throw Exception('Failed to send token: ${response.reasonPhrase}');
  }
}

class UserProvider with ChangeNotifier {
  User? _user = null;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  void login(User? user) {
    backendLogin();

    _user = user;
    notifyListeners();
  }

  Future<void> logout() async {
    print('xfguo: logout - start');
    await FirebaseAuth.instance.signOut();
    _user = null;
    print('xfguo: logout - after signOut');
    notifyListeners();
    print('xfguo: logout - after notifyListeners');
  }

}
