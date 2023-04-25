import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fryo/src/api/api_client.dart' as api;
import 'package:fryo/src/entity/entities.dart';
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
}
