import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void setupFirebaseTestConfig() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCf8-0FupTJCpYh1y0GK1xH8-tv9iKj3qM',
      authDomain: 'your-app-id.firebaseapp.com',
      projectId: 'your-app-id',
      storageBucket: 'your-app-id.appspot.com',
      messagingSenderId: '1234567890',
      appId: '1:1234567890:web:1234567890abcdef',
    ),
  );

  FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
}
