
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../entity/entities.dart';
import '../shared/config.dart';
import 'api_client.dart' as api;

class AddressProvider with ChangeNotifier {
  List<Address> _addresses = [];
  List<Address> get addresses => _addresses;

  Address _shippingAddress = Address.UNSET_ADDRESS;
  Address get shippingAddress => _shippingAddress;
  Address _billingAddress = Address.UNSET_ADDRESS;
  Address get billingAddress => _billingAddress;

  Future<Address> fetchShippingAddress() async {
    _shippingAddress = await api.get(url: '${Config.instance.apiUrl}/addresses/shipping',
        fromJson: (json) => Address.fromJson(json));
    notifyListeners();
    return _shippingAddress;
  }

  Future<Address> fetchBillingAddress() async {
    _billingAddress = await api.get(url: '${Config.instance.apiUrl}/addresses/billing',
            fromJson: (json) => Address.fromJson(json));
    notifyListeners();
    return _billingAddress;
  }

  Future<void> fetchAddresses() async {
    _addresses = await api.get(url: '${Config.instance.apiUrl}/addresses',
            fromJson: (json) => Address.fromJson(json));
    notifyListeners();
  }

  Future<void> addAddress(Address address) async {
    await api.post(
      url: '${Config.instance.apiUrl}/addresses',
      body: jsonEncode(address.toJson()), );
    fetchAddresses();
  }

  Future<void> selectShippingAddress(Address address) async {
    await api.post(url: '${Config.instance.apiUrl}/addresses/shipping/${address.id}');
    fetchShippingAddress();
  }

  Future<void> selectBillingAddress(Address address) async {
    await api.post(url: '${Config.instance.apiUrl}/addresses/billing/${address.id}');
    fetchBillingAddress();
  }

  Future<void> deleteAddress(int id) async {
    await api.delete(url: '${Config.instance.apiUrl}/addresses/$id');
    init();
  }

  Future<void> init() async {
    await Future.wait([
      fetchBillingAddress(),
      fetchShippingAddress(),
      fetchAddresses(),
    ]);
  }
}
