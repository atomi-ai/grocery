import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:provider/provider.dart';

import '../entity/entities.dart';
import '../entity/stripe.dart';
import '../provider/product_provider.dart';
import '../provider/store_provider.dart';

Widget getAddressText(Address? t) {
  if (t == null) {
    return Text('not set address');
  }
  return Text('${t.line1} ${t.line2}, ${t.city}, ${t.state}');
}

String getAddressStr(Address t) {
  return '${t.line1} ${t.line2}, ${t.city}, ${t.state} ${t.postalCode}, ${t.country}';
}

String getBillingDetailStr(AtomiBillingDetails bd) {
  return '${bd.email} / ${bd.phone}\n${getAddressStr(bd.address)}';
}

Widget getPaymentMethodText(AtomiPaymentMethod? pm) {
  if (pm == null) {
    return Text('no payment method');
  }
  return Text('Card: ****${pm.card.last4}(${pm.card.brand})'
      ' | exp: ${pm.card.expMonth}/${pm.card.expYear}'
      '\n${getBillingDetailStr(pm.billingDetails)}');
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
