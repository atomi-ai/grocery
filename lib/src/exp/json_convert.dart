import 'dart:convert';
import 'dart:io';

import '../entity/entities.dart';
import 'package:http/http.dart' as http;

Future<T> post<T>(Uri url, T Function(Map<String, dynamic> json) parser,
    {dynamic body}) async {
  String token = 'eyJhbGciOiJSUzI1NiIsImtpZCI6Ijk3OWVkMTU1OTdhYjM1Zjc4MjljZTc0NDMwN2I3OTNiN2ViZWIyZjAiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiWElBT0ZFTkcgR1VPIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FHTm15eFl6VTlJYXc2NXRGbTlEZWFkSUtuVzZNOHN1SEg1TUF1Ykh4WVVGPXM5Ni1jIiwiaXNzIjoiaHR0cHM6Ly9zZWN1cmV0b2tlbi5nb29nbGUuY29tL3F1aWNrc3RhcnQtMTU4OTA2ODU4NjQ5NyIsImF1ZCI6InF1aWNrc3RhcnQtMTU4OTA2ODU4NjQ5NyIsImF1dGhfdGltZSI6MTY3OTk2NDM1NywidXNlcl9pZCI6IkJHSGFZcnB5TGtibThMb3FoZEJNZWhJNzJoaDEiLCJzdWIiOiJCR0hhWXJweUxrYm04TG9xaGRCTWVoSTcyaGgxIiwiaWF0IjoxNjc5OTY0MzU4LCJleHAiOjE2Nzk5Njc5NTgsImVtYWlsIjoibGFtdWd1by50dkBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJnb29nbGUuY29tIjpbIjEwNzA2ODY1ODYyNDA1NjY4MzYyOCJdLCJlbWFpbCI6WyJsYW11Z3VvLnR2QGdtYWlsLmNvbSJdfSwic2lnbl9pbl9wcm92aWRlciI6Imdvb2dsZS5jb20ifX0.UvGqPle4CmhJocr9ecTR5UGhJLFSdUiBNB34d46Vev52_Ms57vSSdM9llb0uxS_75QkJCST58FepXI5VyGWxaVwhfP8CtOqxZydPENdJHsBSf1Q6HHIhr7pBTcY4-yR5-cADIN_7SJjciWLTSvjucNlUbAaP7PWT9A8HWkJAX71a5m96O_G_qCPWVRyHFfLVSKl67B3Qo82OfvrdAvOwwuXxAfD9aSVrWykOJlCUmsuGIPe_QQ2qVo_3FIQj8Em4_QtTetvuoNeurqqSAk9taYDvZ4uytBs1Y4DeEMiO46JYlP_-Y6yW5HiKWgReCEwCgFArGihkiO6P25_7bsIGQQ';
  print('xfguo: ${url}, body: ${body}, token = ${token}');
  final response = await http.post(url, body: body, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  });
  print('xfguo: response = ${response.statusCode}, body = ${response.body}');
  if (response.statusCode != HttpStatus.ok) {
    throw Exception(
        'Failed to post ${url} with data ${body}, and response code: ${response.statusCode}');
  }
  final json = jsonDecode(response.body);
  return parser(json);
}

dynamic convertKeysToCamelCase(dynamic data) {
  if (data is Map<String, dynamic>) {
    Map<String, dynamic> newMap = {};
    data.forEach((key, value) {
      final newKey = key.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join('');
      newMap[newKey] = convertKeysToCamelCase(value);
    });
    return newMap;
  } else if (data is List) {
    return data.map((e) => convertKeysToCamelCase(e)).toList();
  } else {
    return data;
  }
}

void main() {
}
