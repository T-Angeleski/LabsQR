import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/util/constants.dart';
import 'package:http/http.dart' as http;

const FlutterSecureStorage _storage = FlutterSecureStorage();

Future<Map<String, String>> getHeaders() async {
  final token = await _storage.read(key: 'jwt_token');
  return {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };
}

Future<http.Response> makeGetRequest(String path) async {
  final headers = await getHeaders();
  return await http.get(
    Uri.parse('$backendUrl/$path'),
    headers: headers,
  );
}

Future<http.Response> makePostRequest(String path, dynamic body) async {
  final headers = await getHeaders();
  return await http.post(
    Uri.parse('$backendUrl/$path'),
    headers: headers,
    body: jsonEncode(body),
  );
}

Future<http.Response> makePutRequest(String path, dynamic body) async {
  final headers = await getHeaders();
  return await http.put(
    Uri.parse('$backendUrl/$path'),
    headers: headers,
    body: jsonEncode(body),
  );
}

Future<http.Response> makeDeleteRequest(String path) async {
  final headers = await getHeaders();
  return await http.delete(
    Uri.parse('$backendUrl/$path'),
    headers: headers,
  );
}

Future<T> handleResponse<T>(
    http.Response response, T Function(dynamic) fromJson) {
  if (response.statusCode == 401) {
    throw Exception('Unauthorized - Please login again');
  }
  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception(
        'Failed to load data: Status code ${response.statusCode}, Response: ${response.body}');
  }

  final data = jsonDecode(response.body);
  return Future.value(fromJson(data));
}

List<T> parseListResponse<T>(
    dynamic data, T Function(Map<String, dynamic>) fromJson) {
  if (data is List) {
    return data.map((item) => fromJson(item as Map<String, dynamic>)).toList();
  } else if (data is Map<String, dynamic>) {
    return [fromJson(data)];
  } else {
    throw FormatException('Unexpected response type: ${data.runtimeType}');
  }
}

bool isValidUUID(String uuid) {
  try {
    return uuid.length == 36 && uuid.split('-').length == 5;
  } catch (_) {
    return false;
  }
}
