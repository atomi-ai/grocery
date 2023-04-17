// Command:
//     flutter drive --target=integration_test/firebase_integration_test.dart \
//     --driver=test_driver/firebase_integration_test_driver.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fryo/src/api/api_client.dart';
import 'package:integration_test/integration_test.dart';

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

  setUpAll(() async {
    if (Firebase.apps.isEmpty) {
      // 使用加载的配置手动初始化Firebase
      await Firebase.initializeApp(name: 'xfguo-app', options: firebaseOptions);
    }
  });

  tearDownAll(() async {
    await Firebase.app('xfguo-app').delete();
  });

  group('Firebase Auth Emulator Test', () {
    testWidgets('Initialization and user creation',
        (WidgetTester tester) async {
      // 设置环境变量，指向本地 Firestore 和 Authentication 模拟器
      FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);


      String email = "user@atomi.ai";
      String password = "password123";

      // 检查用户是否存在
      List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      UserCredential admin;

      // 如果用户不存在，创建一个新用户
      if (signInMethods.isEmpty) {
        admin = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print("Created admin(${admin.user})");
      } else {
        // 用户已存在，使用现有用户登录
        admin = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print("Logged in admin(${admin.user})");
      }
      print('Get user token: ${await getCurrentToken()}');

      // 删除创建的用户
      await admin.user?.delete();
      print("Deleted admin(${admin.user})");

      // 清理以免干扰其他测试
      await FirebaseAuth.instance.signOut();
    });
  });
}
