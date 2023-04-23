import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fryo/src/api/api_client.dart' as api;
import 'package:fryo/src/shared/config.dart';
import 'package:fryo/src/entity/user.dart' as atomi;


class UserProvider with ChangeNotifier {
  // 如果使用User的时候因为import firebase_auth的原因导致正常测试写不了的话，
  // 我们就需要重新reassign一下User（创建一个新的User），确保firebase相关代码
  // 在主逻辑之外。 (by lamuguo)
  User? _user = null;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> login(User? user) async {
    atomi.User? atomiUser = await api.get(
      url:'${Config.instance.apiUrl}/login',
      fromJson: (json) => atomi.User.fromJson(json),
    );
    if (atomiUser != null) {
      _user = user;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    print('xfguo: logout - start');
    _user = null;
    print('xfguo: logout - after signOut');
    notifyListeners();
    print('xfguo: logout - after notifyListeners');
  }
}
