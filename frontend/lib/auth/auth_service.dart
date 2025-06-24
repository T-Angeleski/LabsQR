import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frontend/sessionManager/session_manager.dart';

class AuthService {
  // static const String baseUrl = 'http://10.0.2.2:8080/auth';
  static const String baseUrl = 'http://192.168.100.139:8080/auth';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final SharedPreferences _prefs;
  List<String>? userRoles;

  AuthService._(this._prefs);

  static Future<AuthService> create() async {
    final prefs = await SharedPreferences.getInstance();
    final authService = AuthService._(prefs);

    final token = await authService.getToken();
    if (token != null && !JwtDecoder.isExpired(token)) {
      authService.userRoles = authService._parseRolesFromToken(token);
    }

    return authService;
  }

  static const String _jwtTokenKey = 'jwt_token';
  static const String _userRolesKey = 'user_roles';
  static const String _inSessionKey = 'in_session';
  static const String _sessionDataKey = 'session_data';

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
        await _storeAuthData(data['token']);
        return true;
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  Future<void> _storeAuthData(String token) async {
    userRoles = _parseRolesFromToken(token);
    await _secureStorage.write(key: _jwtTokenKey, value: token);
    await _prefs.setString(_userRolesKey, jsonEncode(userRoles));
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _jwtTokenKey);
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _jwtTokenKey);
    await _prefs.remove(_userRolesKey);
    await _prefs.remove(_inSessionKey);
    await _prefs.remove(_sessionDataKey);
    await SessionManager().endSession();
    userRoles = null;
  }

  Future<String> getCurrentUserIdAsync() async {
    final token = await _secureStorage.read(key: _jwtTokenKey);
    if (token == null) throw Exception("Not logged in");

    final decoded = JwtDecoder.decode(token);
    return decoded['userId']?.toString() ??
        (throw Exception("Invalid user ID in token"));
  }

  Future<void> startSession(Map<String, dynamic> sessionData) async {
    await _prefs.setBool(_inSessionKey, true);
    await _prefs.setString(_sessionDataKey, jsonEncode(sessionData));
  }

  Future<void> endSession() async {
    await _prefs.remove(_inSessionKey);
    await _prefs.remove(_sessionDataKey);
  }

  bool get isInSession => _prefs.getBool(_inSessionKey) ?? false;
  get userEmail => _prefs.getString('user_email'); // TODO: fix

  Map<String, dynamic>? get currentSessionData {
    final sessionData = _prefs.getString(_sessionDataKey);
    return sessionData != null ? jsonDecode(sessionData) : null;
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) return false;

    try {
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      return false;
    }
  }

  List<String> _parseRolesFromToken(String token) {
    try {
      final decoded = JwtDecoder.decode(token);

      if (decoded['roles'] is List) {
        return List<String>.from(decoded['roles']);
      } else if (decoded['scope'] is String) {
        return decoded['scope'].toString().split(' ');
      }

      return [];
    } catch (e) {
      print('Error parsing roles from token: $e');
      return [];
    }
  }

  Future<void> loadAuthState() async {
    final token = await getToken();
    if (token != null) {
      userRoles = _parseRolesFromToken(token);
    }
  }
}
