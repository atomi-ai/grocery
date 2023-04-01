import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entity/entities.dart';
import '../logic/product_provider.dart';
import '../logic/store_provider.dart';

Widget getAddressText(Address? t) {
  if (t == null) {
    return Text('not set address');
  }
  return Text('${t.line1} ${t.line2}, ${t.city}, ${t.state}');
}

Future<void> refreshProviders(BuildContext context) async {
  print('xfguo: refreshProviders - start');
  final storeProvider = Provider.of<StoreProvider>(context, listen: false);
  print('xfguo: refreshProviders - get store provider');

  // Get default store based on current firebase user.
  Store? store = await storeProvider.getDefaultStore();
  print('xfguo: refreshProviders - get default store: ${store}');
  if (store == null) {
    print('xfguo: refreshProviders - store is null');
    return;
  }
  print('xfguo: refreshProviders - store is not null');

  final productProvider = Provider.of<ProductProvider>(context, listen: false);
  productProvider.startFetchingProducts(context);
  print('xfguo: refreshProviders - end');
}
