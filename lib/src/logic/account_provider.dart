
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../entity/entities.dart';
import '../shared/config.dart';
import 'api_client.dart' as api;

class AccountProvider with ChangeNotifier {
  Address _shippingAddress = Address.UNSET_ADDRESS;
  Address get shippingAddress => _shippingAddress;
  Address _billingAddress = Address.UNSET_ADDRESS;
  Address get billingAddress => _billingAddress;

  List<Address> _addresses = [];
  List<Address> get addresses => _addresses;

  Future<Address> fetchShippingAddress() async {
    final resp = await api.get(Uri.parse('${Config.instance.apiUrl}/addresses/shipping'));
    _shippingAddress = Address.fromJson(jsonDecode(resp) as Map<String, dynamic>);
    notifyListeners();
    return _shippingAddress;
  }

  Future<Address> fetchBillingAddress() async {
    final resp = await api.get(Uri.parse('${Config.instance.apiUrl}/addresses/billing'));
    _billingAddress = Address.fromJson(jsonDecode(resp) as Map<String, dynamic>);
    notifyListeners();
    return _billingAddress;
  }

  Future<void> fetchAddresses() async {
    final resp = await api.get(Uri.parse('${Config.instance.apiUrl}/addresses'));
    final jsonList = jsonDecode(resp) as List<dynamic>;
    _addresses = jsonList.map((json) => Address.fromJson(json)).toList();
    print('xfguo: fetchAddresses: new addresses: ${_addresses}');
    notifyListeners();
  }

  Future<void> addAddress(Address address) async {
    await api.post(
      Uri.parse('${Config.instance.apiUrl}/addresses'),
          (json) => Address.fromJson(json),
      body: jsonEncode(address.toJson()),
    );
    fetchAddresses();
  }

  void selectShippingAddress(Address address) {
    _shippingAddress = address;
    notifyListeners();
  }

  void selectBillingAddress(Address address) {
    _billingAddress = address;
    notifyListeners();
  }
}
