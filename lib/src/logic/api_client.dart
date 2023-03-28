
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../entity/entities.dart';
import '../shared/config.dart';

Future<String> getCurrentToken() async {
  final user = await FirebaseAuth.instance.currentUser;
  if (user == null) {
    return null;
  }
  return user.getIdToken();
}

Future<List<Store>> fetchStores() async {
  String token = await getCurrentToken();
  final response = await http.get(
    Uri.parse('${Config.instance.apiUrl}/stores'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch stores');
  }

  final jsonList = jsonDecode(response.body) as List<dynamic>;
  final stores = jsonList.map((json) => Store.fromJson(json)).toList();
  return stores;
}

Future<List<Product>> fetchProducts(int storeId) async {
  String token = await getCurrentToken();
  final url = '${Config.instance.apiUrl}/products/$storeId';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch products');
  }

  final jsonList = jsonDecode(response.body) as List<dynamic>;
  print('xfguo: products jsonList: ${jsonList}');
  final products = jsonList.map((json) => Product.fromJson(json)).toList();
  return products;
}

// Address related
Future<String> get(Uri uri) async {
  String token = await getCurrentToken();
  final response = await http.get(uri, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  },);

  print('xfguo: GET response = ${response.statusCode}, body = ${response.body}');
  if (response.statusCode != HttpStatus.ok) {
    print('xfguo: Failed to fetch uri: ${uri}, resp = ${response.statusCode}, ${response.body}');
    throw Exception('Failed to fetch uri: ${uri}');
  }
  return response.body;
}

Future<T> post<T>(Uri url,
    T Function(Map<String, dynamic> json) parser,
    {dynamic body}) async {
  String token = await getCurrentToken();
  print('xfguo: ${url}, body: ${body}');
  final response = await http.post(
      url, body: body, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
  print('xfguo: post response = ${response.statusCode}, body = ${response.body}');
  if (response.statusCode != HttpStatus.ok) {
    throw Exception('Failed to post ${url} with data ${body}, and response code: ${response.statusCode}');
  }
  final json = jsonDecode(response.body);
  return parser(json);
}
