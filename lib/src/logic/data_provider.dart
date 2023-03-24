import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../entity/entities.dart';
import '../shared/config.dart';
import 'product_data.dart';

class DataProvider with ChangeNotifier {
  Future<List<Store>> fetchStores() async {
    String token = await FirebaseAuth.instance.currentUser.getIdToken(true);

    final response = await http.get(
      Uri.parse('${Config.instance.apiUrl}/stores'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch stores');
    }

    final jsonList = jsonDecode(response.body) as List<dynamic>;
    final stores = jsonList.map((json) => Store.fromJson(json)).toList();
    return stores;
  }

  Future<Store> getDefaultStore() async {
    String token = await FirebaseAuth.instance.currentUser.getIdToken(true);

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
    return _defaultStore;
  }

  Future<void> setDefaultStore(Store store) async {
    String token = await FirebaseAuth.instance.currentUser.getIdToken(true);
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
    await getProducts();
    notifyListeners();
  }

  Future<List<Product>> _fetchProducts(int storeId) async {
    String token = await FirebaseAuth.instance.currentUser.getIdToken(true);
    final url = '${Config.instance.apiUrl}/products/$storeId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch products');
    }

    final jsonList = jsonDecode(response.body) as List<dynamic>;
    print('xfguo: products jsonList: ${jsonList}');
    final products = jsonList.map((json) => Product.fromJson(json)).toList();
    return products;
  }

  Store _defaultStore = null;
  Store get defaultStore => _defaultStore;
  List<Product> _products = [];
  List<Product> get products => _products;

  Timer _productsTimer;

  Future<List<Product>> getProducts() async {
    _products = await _fetchProducts(_defaultStore == null ? 1 : _defaultStore.id);
    print('xfguo: products: ${_products}');
    initializeProducts(_products);
    print('xfguo: foods: ${foods}');
    return _products;
  }

  void startFetchingProducts() {
    stopFetchingProducts();
    _productsTimer = Timer.periodic(Duration(minutes: 1), (timer) async {
      await getProducts();
      notifyListeners();
    });
  }

  void stopFetchingProducts() {
    _productsTimer?.cancel();
    _productsTimer = null;
  }
}
