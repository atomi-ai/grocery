// Command:
//     flutter drive --target=integration_test/firebase_integration_test.dart \
//     --driver=test_driver/firebase_integration_test_driver.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:flutter_test/flutter_test.dart';
import 'package:fryo/main.dart';
import 'package:fryo/src/entity/entities.dart';
import 'package:fryo/src/entity/stripe.dart';
import 'package:fryo/src/provider/address_provider.dart';
import 'package:fryo/src/provider/payment_method_provider.dart';
import 'package:fryo/src/provider/product_provider.dart';
import 'package:fryo/src/provider/store_provider.dart';
import 'package:fryo/src/provider/user_provider.dart';
import 'package:fryo/src/shared/config.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fryo/src/api/api_client.dart';
import 'package:fryo/src/entity/user.dart' as myUser;

final FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: 'AIzaSyXXXXXX',
  authDomain: 'your-project-id.firebaseapp.com',
  projectId: 'your-project-id',
  storageBucket: 'your-project-id.appspot.com',
  messagingSenderId: '123456789',
  appId: '1:123456789:web:123456789',
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  UserProvider userProvider = UserProvider();
  Future<void> userLogin() async {
    // 加载测试环境的配置
    Config.loadTestingConfig();

    // 设置环境变量，指向本地 Firestore 和 Authentication 模拟器
    FirebaseAuth.instance.useAuthEmulator(Config.instance.host, Config.instance.authPort);
    String email = "user@atomi.ai";
    String password = "password123";

    // 检查用户是否存在
    List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    UserCredential userCred;

    // 如果用户不存在，创建一个新用户
    if (signInMethods.isEmpty) {
      userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Created userCred(${userCred.user})");
    } else {
      // 用户已存在，使用现有用户登录
      userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Logged in userCred(${userCred.user})");
    }
    print('Get user token: ${await getCurrentToken()}');

    // 使用已创建的用户凭据初始化 UserProvider 实例
    User? testUser = FirebaseAuth.instance.currentUser;

    // 调用 UserProvider 的 login 方法
    await userProvider.login(testUser);
  }

  setUpAll(() async {
    if (Firebase.apps.isEmpty) {
      // 使用加载的配置手动初始化Firebase
      await Firebase.initializeApp(name: 'xfguo-app', options: firebaseOptions);
    }
  });

  tearDownAll(() async {
    await Firebase.app('xfguo-app').delete();
  });

  setUp(() async {
    await userLogin();
  });

  tearDown(() async {
    // 注销用户
    await userProvider.logout();
    // 清理以免干扰其他测试
    await FirebaseAuth.instance.signOut();
  });

  group('Firebase Auth Emulator Test', () {
    testWidgets('Initialization and user creation',
        (WidgetTester tester) async {
          // 检查登录状态是否为 true
          expect(userProvider.isLoggedIn, true);
          final myUser.User user = await get(url: '${Config.instance.apiUrl}/user',
              fromJson: (json) => myUser.User.fromJson(json));
          expect(user.email, FirebaseAuth.instance.currentUser?.email);
    });

    testWidgets('Get default store and fetch products',
            (WidgetTester tester) async {
          StoreProvider storeProvider = StoreProvider();
          ProductProvider productProvider = ProductProvider();

          Store? defaultStore = await storeProvider.getDefaultStore();
          if (defaultStore == null) {
            Store store = Store(id: 1, name: "first_store", address: "1200 Fremont Blvd");
            await storeProvider.saveDefaultStore(store);
            defaultStore = await storeProvider.getDefaultStore();
            expect(defaultStore?.id, 1);
          }

          await productProvider.getProducts(defaultStore!.id);
          List<Product> products = productProvider.products;
          expect(products.isNotEmpty, true);
          // 从 products 列表中获取 id 为 1 的项
          Product? product = products.firstWhere((p) => p.id == 1);
          expect(product, isNotNull);
          // 比较该项的 name 和 price 是否一致
          expect(product.name, 'Hamburger');
          expect(product.price, 25.0);
        });
  });

  testWidgets('Address provider operations', (WidgetTester tester) async {
    AddressProvider addressProvider = AddressProvider();

    // 检查现在 address 列表
    await addressProvider.fetchAddresses();
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
    await addressProvider.fetchAddresses();
    List<Address> updatedAddresses = addressProvider.addresses;
    expect(updatedAddresses.length, initialCount + 1);
    Address? updatedShippingAddress = updatedAddresses.firstWhere((p) => p.line1 == shippingAddress.line1 && p.city == shippingAddress.city);
    // 设置刚刚添加的 shipping address 为默认 shipping address
    await addressProvider.saveShippingAddress(updatedShippingAddress);
    await addressProvider.fetchShippingAddress();

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
    await addressProvider.fetchAddresses();
    List<Address> updatedAddresses2 = addressProvider.addresses;
    expect(updatedAddresses2.length, initialCount + 2);
    Address? updatedBillingAddress = updatedAddresses2.firstWhere((p) => p.line1 == billingAddress.line1 && p.city == billingAddress.city);
    // 设置刚刚添加的 billing address 为默认 billing address
    await addressProvider.saveBillingAddress(updatedBillingAddress);
    await addressProvider.fetchBillingAddress();

    // 检查默认 billing address 是否为刚刚添加的 billing address
    Address? defaultBillingAddress = addressProvider.billingAddress;
    expect(defaultBillingAddress?.id, updatedBillingAddress.id);

    await addressProvider.deleteAddress(updatedShippingAddress.id);
    await addressProvider.deleteAddress(updatedBillingAddress.id);
    await addressProvider.fetchAddresses();
    List<Address> endAddresses = addressProvider.addresses;
    expect(endAddresses.length, initialCount);
  });

  group('Stripe Payment Method Test', () {
    testWidgets('Test AtomiPaymentMethodProvider with Stripe', (WidgetTester tester) async {
      await initStripe();
      AtomiPaymentMethodProvider atomiPaymentMethodProvider = AtomiPaymentMethodProvider();

      // 1. 调用 fetchPaymentMethods，确认 currentPaymentMethod 为空
      await atomiPaymentMethodProvider.fetchPaymentMethods();
      AtomiPaymentMethod? currentPaymentMethod = atomiPaymentMethodProvider.getCurrentPaymentMethod();
      expect(currentPaymentMethod, null);

      // 2. 从 Stripe 创建一个 paymentMethod
      final billingDetails = stripe.BillingDetails(
        email: 'email@stripe.com',
        phone: '+48888000888',
        address: stripe.Address(
          city: 'Houston',
          country: 'US',
          line1: '1459  Circle Drive',
          line2: '',
          state: 'Texas',
          postalCode: '77063',
        ),
      );
      await stripe.Stripe.instance.dangerouslyUpdateCardDetails(stripe.CardDetails(
        number: '4242424242424242',
        cvc: '424',
        expirationMonth: 04,
        expirationYear: 2025,
      ));
      final paymentMethod = await stripe.Stripe.instance.createPaymentMethod(
        params: stripe.PaymentMethodParams.card(
          paymentMethodData: stripe.PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );
      expect(paymentMethod.id, startsWith('pm_'));
      expect(paymentMethod.card.brand, equals('Visa'));
      expect(paymentMethod.card.country, equals('US'));
      expect(paymentMethod.card.expMonth, equals(04));
      expect(paymentMethod.card.expYear, equals(2025));
      expect(paymentMethod.card.last4, equals('4242'));
      // 添加一个 payment method
      await atomiPaymentMethodProvider.addPaymentMethod(paymentMethod.id);

      // 设置为 current payment method
      await atomiPaymentMethodProvider.setCurrentPaymentMethod(paymentMethod.id);

      // 验证
      AtomiPaymentMethod? updatedCurrentPaymentMethod = atomiPaymentMethodProvider.getCurrentPaymentMethod();
      expect(updatedCurrentPaymentMethod, isNotNull);
      expect(updatedCurrentPaymentMethod!.id, paymentMethod.id);

      // 验证完毕后删除 paymentMethod
      await atomiPaymentMethodProvider.deletePaymentMethod(updatedCurrentPaymentMethod.id);

      // 重新获取 paymentMethods 并确认 paymentMethod 已删除
      await atomiPaymentMethodProvider.fetchPaymentMethods();
      AtomiPaymentMethod? deletedPaymentMethod = atomiPaymentMethodProvider.findPaymentMethodById(updatedCurrentPaymentMethod.id);
      expect(deletedPaymentMethod, null);
    });
  });

}
