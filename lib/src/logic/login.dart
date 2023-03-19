import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../shared/config.dart';

Future<void> login() async {
  String token = await FirebaseAuth.instance.currentUser.getIdToken(true);
  print('xfguo: id token = ${token}');
  final response = await http.get(
    Uri.parse("${Config.instance.apiUrl}/login"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  int statusCode = response.statusCode;
  if (statusCode != 200) {
    throw Exception('Failed to send token: ${response.reasonPhrase}');
  }
}
