// Run command:
//    flutter drive --driver=test_driver/integration_test_driver.dart \
//    --target integration_test/firebase_integration2_test.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  });

  tearDownAll(() async {
    await FirebaseAuth.instance.signOut();
  });

  group('Firebase Auth Emulator Test', () {
    testWidgets('Initialization and user creation',
            (WidgetTester tester) async {
          // 设置环境变量，指向本地 Firestore 和 Authentication 模拟器
          FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);

          // 创建一个新用户
          UserCredential admin =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: "admin@atomi.ai",
            password: "admin123",
          );

          print("Created admin(${admin.user})");

          // 删除创建的用户
          await admin.user?.delete();
          print("Deleted admin(${admin.user})");
        });
  });
}
