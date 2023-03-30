import 'package:flutter/foundation.dart';
import 'package:fryo/src/entity/stripe.dart';

import '../entity/user.dart';
import '../shared/config.dart';
import 'api_client.dart' as api;

class AtomiPaymentMethodProvider with ChangeNotifier {
  List<AtomiPaymentMethod> _paymentMethods;
  List<AtomiPaymentMethod> get paymentMethods => _paymentMethods;
  String _currentPaymentMethodId;
  String get currentPaymentMethodId => _currentPaymentMethodId;

  AtomiPaymentMethodProvider() {
    _paymentMethods = [];
    _currentPaymentMethodId = '';
  }

  AtomiPaymentMethod findPaymentMethodById(String pmId) {
    for (var pm in _paymentMethods) {
      if (pm.id == pmId) {
        return pm;
      }
    }
    return null;
  }

  Future<void> _saveCurrentPaymentMethod(String pmId) async {
    print('xfguo: _saveCurrentPaymentMethod: ${pmId}, ${_currentPaymentMethodId}');
    if (pmId == _currentPaymentMethodId) {
      return;
    }
    final User user = await api.put(
      url: '${Config.instance.apiUrl}/user/current-payment-method/${pmId}',
      fromJson: (json) => User.fromJson(json),
    );
    print('xfguo: got user: ${user}');
    _currentPaymentMethodId = user?.paymentMethodId;
  }

  Future<String> _fetchCurrentPaymentMethodId() async {
    final User user = await api.get(url: '${Config.instance.apiUrl}/user',
        fromJson: (json) => User.fromJson(json));
    return user?.paymentMethodId;
  }

  Future<void> _addNewPaymentMethod(String pmId) async {
    await api.put(
      url: '${Config.instance.apiUrl}/payment-methods/${pmId}',);
  }

  Future<void> _fetchPaymentMethods() async {
    _paymentMethods = await api.get(url: '${Config.instance.apiUrl}/payment-methods',
        fromJson:  (json) => AtomiPaymentMethod.fromJson(json));
  }

  Future<void> fetchPaymentMethods() async {
    await Future.wait([
      _fetchPaymentMethods(),
      _fetchCurrentPaymentMethodId(),
    ]);

    notifyListeners();
  }

  void setCurrentPaymentMethod(String pmId) async {
    await _saveCurrentPaymentMethod(pmId);
    notifyListeners();
  }

  Future<void> addPaymentMethod(String pmId) async {
    await Future.wait([
      _addNewPaymentMethod(pmId),
      _fetchPaymentMethods(),
    ]);
    notifyListeners();
  }
}
