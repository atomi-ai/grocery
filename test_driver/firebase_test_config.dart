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

{
"type": "service_account",
"project_id": "quickstart-123456",
"private_key_id": "f6556e7ddaffeba6de462746d2603fd4a8012f64",
"private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC2pg0P5jkE1GAq\n3KLcHvn65pQ9poCP+SHBaWBJb8gjP/k4Sl9EUXADzeCgtBtFCZDxCWgrcpWHdZVH\nUIzJ3yEOGSyF4RZwGbGrzrg8euRpRQdIptQ/QiLzVlg0Kz3LeuWz284P0NAvkt54\nZt0uX/W97AEkzPw0xEOaLU8y60Mryw++9V7Zf5FICtxQQV75hFLRHJmabAFg3vbP\nPKjSQGgPkC3nzf+QV9EV/SiM+3UW/dkG8o6Ea6MurR/wgcngwSUsD22gdqwtegW0\n5FCfjScij8T2UEahiBrs5DcOw5PX9jD9vWSiBv3PVlBk/OJQQiUuP3o7Ak0u+PSL\ny/JRI9hpAgMBAAECggEAFnpqGh5Rvxvp9+xuaJuxVSUCcnHm2ZEmC9kNngwRO/FY\nGQriHZTOLdGtBuoTfxQVz+xB8zLnXyPj6sJpiUCaH1OOzK0uZz5qRMQsnVjcem4h\n3tmVPnHDvmHOeiEmOkAWO+PdwMmIjYpMMdIq/1WU9zovy9kkYtQSo8tWt2QHwMBI\nGX7i11PBhL1y6NaLTVUqfFnGzidXME2uj/7e4B0kgvgY2eY3aGwiXNqRJfyDQbMy\naysPb7ln9p5nqm/n1sIW147PVvIunL1OjaoDJ90OcJnQWuwvCXqMLFV8DyFLqJqH\nUejxQOJMm3P5DHhoTPkcM+GGVeqWua33wLAAOmQ+5wKBgQDiCt9YOUV4lVidnlhR\nP1grNx9M/u/NwIhpAzsFBKSHJCiZRTEAi1i+40/ABwm+0fiBqRxxyQSCj72GcYd3\njTis1IGv4F4OaWp9d1h7VYfFLOhfyPwKihSwQ1N+1FLJGBwLZU79UpETjWiWbd/O\n6kzlMCeVsjJleTIbdWIfAD0mkwKBgQDO2uuocjdvaYU7jzhJ1MF/bQl/lY+doj8i\nSZadwdUucPavyfwYgJ9x5RMy5YZDkeWc/igLyiawYw/3Kofr4T06GE6AlDsJXgzr\nknLwUd62q0NJyy/1ASKFqT4uzkZctahZWYOVvGAL4NExJrmkJyWp+R5ojzG9VBcj\nBXCzKqvGkwKBgFrIhRT4w3b/fDypiMzwxOduVwrkZMlc5yxN2NlWGQIRuqB8Eocm\nb/kScEguS3Kw/76LfdoRIteRBUxGsmKIfFelbYSGdyAQpG1JjmbSXhoJxDYcEWXm\nORLlp1YLzkfnf/Pvtz60d4HDzFqGPFns7f8qTOupSuZIO6Cdj0/mF6kzAoGBAMEs\n+xTFDXYTUiQr/QIeGVI57rviXUt14IXRuUG8aazEO+wwsifjvoNrzYEjjj59+rOh\nOp6/+1+QM7G8W1DyeO5PEsjLJVL7LQ+2JXa+zkFDMUSx5yhkFexDAFpPsrATyZMf\noF3unLebDWFca9Ob53WTu00kJOxNoonHI9d+SwrXAoGBAN4vumoCQiomreV/LqtU\nDKaEXVUiMbAWPZc5M3rrmJH0uHGrUtyz1csPVTwmcj61J0LisDqaPE5N0CbWD7qU\nh0ljMwvi7xSoU0UKvW1FxgvcO1QJxOwm6qJkBbdEDmE8UkzlDA8ZdABF3BeZ/1oC\nidw7MWB1BkTrLcaUbbk1zoiS\n-----END PRIVATE KEY-----\n",
"client_email": "https://securetoken.google.com/quickstart-123456",
"client_id": "115302381298565387652",
"auth_uri": "https://accounts.google.com/o/oauth2/auth",
"token_uri": "https://oauth2.googleapis.com/token",
"auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
"client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/fake-email%40your-project-id.iam.gserviceaccount.com"
}
