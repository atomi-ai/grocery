// Command:
//     flutter drive --target=integration_test/firebase_integration_test.dart \
//     --driver=test_driver/firebase_integration_test_driver.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fryo/src/entity/entities.dart';
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
            expect(defaultStore?.id, "test_store_id");
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
}
