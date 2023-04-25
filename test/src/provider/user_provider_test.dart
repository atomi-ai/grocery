import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fryo/src/api/api_client.dart' as api;
import 'package:fryo/src/entity/entities.dart';
import 'package:fryo/src/provider/address_provider.dart';
import 'package:fryo/src/provider/product_provider.dart';
import 'package:fryo/src/provider/store_provider.dart';
import 'package:fryo/src/provider/user_provider.dart';
import 'package:fryo/src/shared/config.dart';
import 'package:mockito/annotations.dart';

import 'user_provider_test.mocks.dart';

@GenerateMocks([User])
void main() {
  late UserProvider userProvider;
  late MockUser mockUser;

  Future<String> prepareApiTokenForTesting() async {
    const apiKey = 'fake-api-key';
    final httpClient = HttpClient();

    final request = await httpClient.postUrl(Uri.parse(
        'http://localhost:9099/identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey'));

    request.headers.contentType = ContentType.json;
    request.write(jsonEncode({
      'email': 'user@atomi.ai',
      'password': 'password123',
      'returnSecureToken': true,
    }));

    final response = await request.close();
    expect(response.statusCode, HttpStatus.ok);

    final responseBody = await response.transform(utf8.decoder).join();
    final jsonResponse = jsonDecode(responseBody);
    api.token = jsonResponse['idToken'];

    return api.token ?? '';
  }

  setUp(() async {
    Config.loadTestingConfig();
    final token = await prepareApiTokenForTesting();
    print('ID token: ${token}');

    userProvider = UserProvider();
    mockUser = MockUser();
  });

  test('UserProvider login and logout test', () async {
    // Test login
    await userProvider.login(mockUser);
    expect(userProvider.isLoggedIn, true);
    expect(userProvider.user, mockUser);

    // Test logout
    await userProvider.logout();
    expect(userProvider.isLoggedIn, false);
    expect(userProvider.user, null);
  });

  test('Get default store and fetch products', () async {
    StoreProvider storeProvider = StoreProvider();
    ProductProvider productProvider = ProductProvider();

    // Unset the default store before the test
    await storeProvider.unsetDefaultStore();
    Store? defaultStore = await storeProvider.getDefaultStore();
    expect(defaultStore, null);

    // Create and save a new store
    Store store = Store(id: 1, name: "first_store", address: "1200 Fremont Blvd");
    await storeProvider.saveDefaultStore(store);
    defaultStore = await storeProvider.getDefaultStore();
    expect(defaultStore?.id, 1);

    // Fetch products for the default store
    await productProvider.getProducts(defaultStore!.id);
    List<Product> products = productProvider.products;
    expect(products.isNotEmpty, true);

    // Find a product with id 1 from the products list
    Product? product = products.firstWhere((p) => p.id == 1);
    expect(product, isNotNull);

    // Compare the name and price of the product
    expect(product.name, 'Hamburger');
    expect(product.price, 25.0);
  });

  test('Address provider operations', () async {
    AddressProvider addressProvider = AddressProvider();

    // 清空所有地址
    await addressProvider.deleteAllAddresses();

    // 检查现在 address 列表
    List<Address> initialAddresses = addressProvider.addresses;
    int initialCount = initialAddresses.length;

    // 添加一个 shipping address
    Address shippingAddress = Address(
      line1: '123 Shipping St.',
      city: 'Shipping City',
      state: 'Shipping State',
      country: 'USA',
      postalCode: '12345',
    );
    await addressProvider.addAddress(shippingAddress);

    // 检查目前 address 列表是否增加一个 item
    List<Address> updatedAddresses = addressProvider.addresses;
    expect(updatedAddresses.length, initialCount + 1);
    Address? updatedShippingAddress = updatedAddresses.firstWhere((p) => p.line1 == shippingAddress.line1 && p.city == shippingAddress.city);
    // 设置刚刚添加的 shipping address 为默认 shipping address
    await addressProvider.saveShippingAddress(updatedShippingAddress);

    // 检查默认 shipping address 是否为刚刚添加的 shipping address
    Address? defaultShippingAddress = addressProvider.shippingAddress;
    expect(defaultShippingAddress?.id, updatedShippingAddress.id);

    // 添加一个 billing address
    Address billingAddress = Address(
      line1: '456 Billing St.',
      city: 'Billing City',
      state: 'Billing State',
      country: 'USA',
      postalCode: '23456',
    );
    await addressProvider.addAddress(billingAddress);

    // 检查目前 address 列表是否增加一个 item
    List<Address> updatedAddresses2 = addressProvider.addresses;
    expect(updatedAddresses2.length, initialCount + 2);
    Address? updatedBillingAddress = updatedAddresses2.firstWhere((p) => p.line1 == billingAddress.line1 && p.city == billingAddress.city);
    // 设置刚刚添加的 billing address 为默认 billing address
    await addressProvider.saveBillingAddress(updatedBillingAddress);

    // 检查默认 billing address 是否为刚刚添加的 billing address
    Address? defaultBillingAddress = addressProvider.billingAddress;
    expect(defaultBillingAddress?.id, updatedBillingAddress.id);

    await addressProvider.deleteAddress(updatedShippingAddress.id);
    await addressProvider.deleteAddress(updatedBillingAddress.id);
    List<Address> endAddresses = addressProvider.addresses;
    expect(endAddresses.length, initialCount);
  });
}
