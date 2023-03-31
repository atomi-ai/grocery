import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fryo/src/logic/api_client.dart';
import 'package:http/http.dart' as http;

import '../entity/entities.dart';
import '../shared/config.dart';

class StoreProvider with ChangeNotifier {
  late Store _defaultStore;
  Store get defaultStore => _defaultStore;

  Future<Store> getDefaultStore() async {
    String token = await getCurrentToken();
    final response = await http.get(
      Uri.parse('${Config.instance.apiUrl}/default-store'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch default store');
    }

    print('xfguo: default store response: ${response.body}');
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final store = Store.fromJson(json);

    _defaultStore = Store.fromJson(json);
    notifyListeners();
    return _defaultStore;
  }

  Future<void> setDefaultStore(BuildContext context, Store store) async {
    if (store == null) {
      return;
    }
    String token = await getCurrentToken();
    final response = await http.put(
      Uri.parse('${Config.instance.apiUrl}/default-store/${store.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to set default store ${response.statusCode}: ${response.body}');
    }
    _defaultStore = store;
    notifyListeners();
  }
}
