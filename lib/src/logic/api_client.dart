
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../entity/entities.dart';
import '../shared/config.dart';

Future<String> getCurrentToken() async {
  final user = await FirebaseAuth.instance.currentUser;
  if (user == null) {
    return '';
  }
  return user.getIdToken();
}

// Generic part of API calls.
String requestToString(http.Request req) {
  return '{ ${req.method} ${req.url}\tBody: ${req.body}}';
}

String responseToString(http.Response resp) {
  return '{ ${resp.statusCode} \tHeaders: ${resp.headers}\n\tBody: ${resp.body}}';
}

class HttpRequestException implements Exception {
  final String method;
  final Uri uri;
  final dynamic body;
  final http.Response response;

  HttpRequestException({
    required this.method,
    required this.uri,
    required this.response,
    this.body = '',
  });

  @override
  String toString() {
    return 'HttpRequestException: $method $uri failed with status code ${response.statusCode}.'
        ' Response body: ${response.body}';
  }
}

Future<String> rawRequest({
  required String method,
  required Uri uri,
  dynamic body,
}) async {
  String token = await getCurrentToken();
  final client = http.Client();
  final request = http.Request(method, uri)
    ..headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    })
    ..body = body ?? '';

  final streamedResponse = await client.send(request);
  final response = await http.Response.fromStream(streamedResponse);
  print('====xfguo: request: \n${requestToString(request)}');
  print('****xfguo: response: \n${responseToString(response)}');

  if (response.statusCode != HttpStatus.ok) {
    print('xfguo: error response: ${responseToString(response)}');
    throw Exception('Failed to fetch uri: ${uri}');
  }
  return response.body;
}

Future<T> request<T, E>({
  required String method,
  required String url,
  E Function(dynamic json)? fromJson,
  dynamic body,
}) async {
  final uri = Uri.parse(url);
  final resBody = await rawRequest(method: method, uri: uri, body: body);

  if (fromJson == null) {
    return resBody as T;
  }
  return parseData<T, E>(jsonDecode(resBody), fromJson);
}

T parseData<T, E>(dynamic json, E Function(dynamic json) fromJson) {
  dynamic result;

  if (json is Map<String, dynamic>) {
    result = fromJson(json);
  } else if (json is List<dynamic>) {
    result = json.map<E>((e) => fromJson(e)).toList();
  } else {
    throw Exception('Unsupport JSON: ${json}');
  }

  print('xfguo: Parsed data: $result');
  return result as T;
}

Future<T> get<T, E>({required String url, E Function(dynamic json)? fromJson = null}) async {
  return request<T, E>(method: 'GET', url: url, fromJson: fromJson);
}

Future<dynamic> put({required String url, dynamic Function(dynamic json)? fromJson = null, dynamic body = null}) async {
  return request(method: 'PUT', url: url, fromJson: fromJson, body: body);
}

Future<dynamic> post({required String url, dynamic Function(dynamic json)? fromJson = null, dynamic body = null}) async {
  return request(method: 'POST', url: url, fromJson: fromJson, body: body);
}

Future<dynamic> delete({required String url, dynamic Function(dynamic json)? fromJson = null}) async {
  return request(method: 'DELETE', url: url, fromJson: fromJson);
}
