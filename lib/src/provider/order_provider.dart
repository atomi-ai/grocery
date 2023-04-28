import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fryo/src/entity/entities.dart';
import 'package:fryo/src/api/api_client.dart' as api;
import 'package:fryo/src/shared/config.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  List<Order> get orders => _orders;
  Order? _currentOrder = null;
  Order? get currentOrder => _currentOrder;

  set currentOrder(Order? order) {
    _currentOrder = order;
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    _orders = await api.get(
            url: '${Config.instance.apiUrl}/orders',
            fromJson: (json) => Order.fromJson(json)) ??
        [];
    _orders.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    notifyListeners();
  }

  Future<Order> addOrder(Order order) async {
    final res = await api.post(
      url: '${Config.instance.apiUrl}/order',
      body: jsonEncode(order.toJson()),
      fromJson: (json) => Order.fromJson(json),
    );
    await fetchOrders();
    return res;
  }
}
