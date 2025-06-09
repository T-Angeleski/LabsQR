import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8080/auth';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  List<String>? userRoles;

  Future<Map<String, dynamic>> register(
      String fullName,
      String email,
      String password,
      String role,
      String index,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'role': role,
          'index': index,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Registration successful: $responseData');
        return {
          'success': true,
          'user': responseData,
        };
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        userRoles = _parseRolesFromToken(data['token']);
        await _storage.write(key: 'jwt_token', value: data['token']);
        await _storage.write(key: 'user_roles', value: jsonEncode(userRoles));

        return true;
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'user_roles');
    await _storage.delete(key: 'jwt_token');
  }

  Future<String> getCurrentUserIdAsync() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) throw Exception("Not logged in");

    final decoded = JwtDecoder.decode(token);
    return decoded['userId']?.toString() ??
        (throw Exception("Invalid user ID in token"));
  }


  List<String> _parseRolesFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid token');
      }

      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final payloadMap = json.decode(payload);


      if (payloadMap['roles'] is List) {
        return List<String>.from(payloadMap['roles']);
      }

      else if (payloadMap['scope'] is String) {
        return payloadMap['scope'].toString().split(' ');
      }

      return [];
    } catch (e) {
      print('Error parsing roles from token: $e');
      return [];
    }
  }
  
}