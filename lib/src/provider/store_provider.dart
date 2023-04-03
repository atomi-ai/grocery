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
    try {
      store = await api.get(
          url: '${Config.instance.apiUrl}/default-store',
          fromJson: (json) => Store.fromJson(json)
      );
    } catch (e) {
      print('xfguo: get exception in getting store');
    }
    return setDefaultStore(store);
  }

  Future<void> saveDefaultStore(BuildContext context, Store store) async {
    final Store savedStore = await api.put(
      url: '${Config.instance.apiUrl}/default-store/${store.id}',
      fromJson: (json) => Store.fromJson(json)
    );
    setDefaultStore(savedStore);
  }
}
