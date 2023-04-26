import 'dart:convert';

import 'package:fryo/src/entity/entities.dart';
import 'package:fryo/src/entity/payment_intent_request.dart';
import 'package:fryo/src/shared/config.dart';
import 'package:fryo/src/api/api_client.dart' as api;

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
Future<PaymentResult?> placeOrder(PaymentIntentRequest paymentIntentRequest) async {
  final res = await api.post(
    url: '${Config.instance.apiUrl}/pay',
    body: jsonEncode(paymentIntentRequest.toJson()));
  if (res == null) {
    return null;
  }
  Map<String, dynamic> result = jsonDecode(res);
  return PaymentResult(id: result['id'], status: result['status']);
}
