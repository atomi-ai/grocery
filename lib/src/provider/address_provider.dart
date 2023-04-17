import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fryo/src/api/api_client.dart' as api;
import 'package:fryo/src/entity/entities.dart';
import 'package:fryo/src/shared/config.dart';

class AddressProvider with ChangeNotifier {
  List<Address> _addresses = [];
  List<Address> get addresses => _addresses;

  Address? _shippingAddress = null;
  Address? get shippingAddress => _shippingAddress;
  Address? _billingAddress = null;
  Address? get billingAddress => _billingAddress;

  Future<Address?> fetchShippingAddress() async {
    _shippingAddress = await api.get(url: '${Config.instance.apiUrl}/addresses/shipping',
        fromJson: (json) => Address.fromJson(json)) ?? Address.UNSET_ADDRESS;
    notifyListeners();
    return _shippingAddress;
  }

  Future<Address?> fetchBillingAddress() async {
    _billingAddress = await api.get(url: '${Config.instance.apiUrl}/addresses/billing',
            fromJson: (json) => Address.fromJson(json)) ?? Address.UNSET_ADDRESS;
    notifyListeners();
    return _billingAddress;
  }

  Future<void> fetchAddresses() async {
    _addresses = await api.get(url: '${Config.instance.apiUrl}/addresses',
            fromJson: (json) => Address.fromJson(json)) ?? [];
    notifyListeners();
  }

  Future<void> addAddress(Address address) async {
    await api.post(
      url: '${Config.instance.apiUrl}/addresses',
      body: jsonEncode(address.toJson()), );
    fetchAddresses();
  }

  Future<void> saveShippingAddress(Address address) async {
    await api.post(url: '${Config.instance.apiUrl}/addresses/shipping/${address.id}');
    fetchShippingAddress();
  }

  Future<void> saveBillingAddress(Address address) async {
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
