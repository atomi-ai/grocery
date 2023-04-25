import 'package:flutter/material.dart';
import 'package:fryo/src/api/api_client.dart' as api;
import 'package:fryo/src/entity/entities.dart';
import 'package:fryo/src/shared/config.dart';

class StoreProvider with ChangeNotifier {
  Store? _defaultStore = null;
  Store? get defaultStore => _defaultStore;

  Store? setDefaultStore(Store? store) {
    _defaultStore = store;
    notifyListeners();
    return store;
  }

  Future<Store?> getDefaultStore() async {
    Store? store = null;
    store = await api.get(
        url: '${Config.instance.apiUrl}/default-store',
        fromJson: (json) => Store.fromJson(json)
    );
    return setDefaultStore(store);
  }

  Future<void> saveDefaultStore(Store store) async {
    final Store savedStore = await api.put(
      url: '${Config.instance.apiUrl}/default-store/${store.id}',
      fromJson: (json) => Store.fromJson(json)
    );
    setDefaultStore(savedStore);
  }

  // @TestingOnly
  // Please remove the tag if you want to use the fucntion in production.
  Future<void> unsetDefaultStore() async {
    try {
      await api.delete(url: '${Config.instance.apiUrl}/default-store');
      setDefaultStore(null);
    } catch (e) {
      print('Failed to unset default store: $e');
      throw e;
    }
  }
}
