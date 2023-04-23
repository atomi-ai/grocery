import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fryo/src/api/api_client.dart' as api;
import 'package:fryo/src/provider/user_provider.dart';
import 'package:fryo/src/shared/config.dart';
import 'package:mockito/annotations.dart';

import 'user_provider_test.mocks.dart';

@GenerateMocks([User])
void main() {
  late UserProvider userProvider;
  late MockUser mockUser;

  setUp(() async {
    Config.loadTestingConfig();

    const apiKey = 'fake-api-key';
    final httpClient = HttpClient();

    final request = await httpClient.postUrl(Uri.parse(
        'http://localhost:9099/identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey'));

    request.headers.contentType = ContentType.json;
    request.write(jsonEncode({
      'email': 'user@example.com',
      'password': 'YourPassword123!',
      'returnSecureToken': true,
    }));

    final response = await request.close();
    expect(response.statusCode, HttpStatus.ok);

    final responseBody = await response.transform(utf8.decoder).join();
    final jsonResponse = jsonDecode(responseBody);
    api.token = jsonResponse['idToken'];
    print('ID token: ${api.token}');

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
}
