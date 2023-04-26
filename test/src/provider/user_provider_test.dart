import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fryo/src/api/api_client.dart' as api;
import 'package:fryo/src/entity/entities.dart';
import 'package:fryo/src/entity/stripe.dart';
import 'package:fryo/src/provider/address_provider.dart';
import 'package:fryo/src/provider/payment_method_provider.dart';
import 'package:fryo/src/provider/product_provider.dart';
import 'package:fryo/src/provider/store_provider.dart';
import 'package:fryo/src/provider/user_provider.dart';
import 'package:fryo/src/shared/config.dart';
import 'package:http/http.dart' as http;
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

    // // 确保在测试中初始化WidgetsFlutterBinding
    // TestWidgetsFlutterBinding.ensureInitialized();

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

  test('Test AtomiPaymentMethodProvider with Stripe', () async {
    AtomiPaymentMethodProvider atomiPaymentMethodProvider = AtomiPaymentMethodProvider();

    // 0. 清空现在所有的payment methods.
    atomiPaymentMethodProvider.deleteAllPaymentMethods();

    // 1. 确认currentPaymentMethod 为空
    expect(atomiPaymentMethodProvider.currentPaymentMethodId, '');

    // 2. 从Stripe创建一个 paymentMethod
    final pmId = await createPaymentMethod() ?? "";
    // 添加一个 payment method
    await atomiPaymentMethodProvider.addPaymentMethod(pmId);

    // 设置为 current payment method
    await atomiPaymentMethodProvider.setCurrentPaymentMethod(pmId);

    // 验证
    AtomiPaymentMethod? updatedCurrentPaymentMethod = atomiPaymentMethodProvider.getCurrentPaymentMethod();
    expect(updatedCurrentPaymentMethod, isNotNull);
    expect(updatedCurrentPaymentMethod!.id, pmId);

    // 验证完毕后删除 paymentMethod
    await atomiPaymentMethodProvider.deletePaymentMethod(updatedCurrentPaymentMethod.id);

    // 重新获取 paymentMethods 并确认 paymentMethod 已删除
    AtomiPaymentMethod? deletedPaymentMethod = atomiPaymentMethodProvider.findPaymentMethodById(updatedCurrentPaymentMethod.id);
    expect(deletedPaymentMethod, null);

    expect(atomiPaymentMethodProvider.getCurrentPaymentMethod(), null);
  });
}

Future<String?> createPaymentMethod() async {
  // 使用您的Stripe API密钥替换下面的字符串
  final apiKey = 'sk_test_x7J2qxqTLBNo4WQoYkRNMEGx';

  final client = http.Client();
  final url = Uri.parse('https://api.stripe.com/v1/payment_methods');
  final response = await client.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'type': 'card',
      'card[number]': '4242424242424242',
      'card[exp_month]': '04',
      'card[exp_year]': '2025',
      'card[cvc]': '424',
      'billing_details[email]': 'email@stripe.com',
      'billing_details[phone]': '+48888000888',
      'billing_details[address][city]': 'Houston',
      'billing_details[address][country]': 'US',
      'billing_details[address][line1]': '1459 Circle Drive',
      'billing_details[address][line2]': '',
      'billing_details[address][state]': 'Texas',
      'billing_details[address][postal_code]': '77063',
    },
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    final card = responseBody['card'];
    expect(responseBody['id'], startsWith('pm_'));
    expect(card['brand'], equals('visa'));
    expect(card['country'], equals('US'));
    expect(card['exp_month'], equals(04));
    expect(card['exp_year'], equals(2025));
    expect(card['last4'], equals('4242'));
    return responseBody['id'] as String?;
  } else {
    print('Error creating PaymentMethod: ${response.body}');
    return null;
  }
}