import 'dart:convert';

import '../entity/entities.dart';
import '../entity/payment_intent_request.dart';
import '../shared/config.dart';
import 'api_client.dart' as api;

Future<List<Store>> fetchStores() async {
  List<Store>? res = await api.get(
    url: '${Config.instance.apiUrl}/stores',
    fromJson: (json) => Store.fromJson(json));
  return res ?? [];
}

Future<List<Product>> fetchProducts(int storeId) async {
  List<Product>? res = await api.get(
      url:'${Config.instance.apiUrl}/products/$storeId',
      fromJson: (json) => Product.fromJson(json),
  );
  return res ?? [];
}

// TODO(lamuguo): Should return something like OrderSummary.
Future<void> placeOrder(PaymentIntentRequest paymentIntentRequest) async {
  return api.post(
    url: '${Config.instance.apiUrl}/pay',
    body: jsonEncode(paymentIntentRequest.toJson()), );
}