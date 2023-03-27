import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fryo/src/logic/store_provider.dart';
import 'package:provider/provider.dart';

import '../entity/entities.dart';
import "api_client.dart";

class ProductProvider with ChangeNotifier {

  List<Product> _products = [];
  List<Product> get products => _products;

  Map<int, Product> _productsMap = {};
  Map<int, Product> get productsMap => _productsMap;
  List<Product> _foods = [];
  List<Product> get foods => _foods;
  List<Product> _drinks = [];
  List<Product> get drinks => _drinks;
  Set<int> _productIdsInCurrentStore = {};
  Set<int> get productIdsInCurrentStore => _productIdsInCurrentStore;

  Timer _productsTimer;

  void _initializeProducts(List<Product> productsList) {
    _foods = [];
    _drinks = [];
    _productIdsInCurrentStore = {};
    productsList.forEach((product) {
      _productsMap[product.id] = product;
      _productIdsInCurrentStore.add(product.id);
      if (product.category == 'FOOD') {
        _foods.add(product);
      } else if (product.category == 'DRINK') {
        _drinks.add(product);
      }
    });
  }

  Future<void> getProducts(int storeId) async {
    _products = await fetchProducts(storeId);
    print('xfguo: getProducts(${storeId}) products: ${_products}');
    _initializeProducts(_products);
    print('xfguo: foods: ${foods}');
    notifyListeners();
  }

  void startFetchingProducts(BuildContext context) {
    stopFetchingProducts();
    _productsTimer = Timer.periodic(Duration(minutes: 1), (timer) async {
      final storeProvider = Provider.of<StoreProvider>(context);
      final store = storeProvider.defaultStore;
      if (store == null) {
        return;
      }
      await getProducts(store.id);
      notifyListeners();
    });
  }

  void stopFetchingProducts() {
    _productsTimer?.cancel();
    _productsTimer = null;
  }

}
