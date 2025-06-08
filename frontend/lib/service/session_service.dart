import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/session.dart';
import 'package:frontend/models/student_session.dart';
import 'package:frontend/models/subject.dart';
import 'package:frontend/models/teacher.dart';

class SessionService {
  static const String _baseUrl = 'http://10.0.2.2:8080/api';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<T> _handleResponse<T>(
      http.Response response, T Function(dynamic) fromJson) {
    if (response.statusCode == 401) {
      throw Exception('Unauthorized - Please login again');
    }
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load data: Status code ${response.statusCode}, Response: ${response.body}');
    }

    dynamic data = jsonDecode(response.body);
    return Future.value(fromJson(data));
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> _makeGetRequest(String path) async {
    final headers = await _getHeaders();
    return await http.get(
      Uri.parse('$_baseUrl/$path'),
      headers: headers,
    );
  }

  Future<http.Response> _makePostRequest(String path, {dynamic body}) async {
    final headers = await _getHeaders();
    return await http.post(
      Uri.parse('$_baseUrl/$path'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> createSession(Map<String, dynamic> sessionData) async {
    return _makePostRequest('sessions/create', body: sessionData);
  }

  Future<List<Session>> fetchSessions() async {
    final response = await _makeGetRequest('sessions/sessions');
    return _handleResponse<List<Session>>(
        response,
            (data) => (data as List<dynamic>)
            .map((json) => Session.fromJson(json))
            .toList());
  }

  Future<http.Response> joinSession(String sessionId) async {
    try {
      debugPrint('Attempting to join session: $sessionId');

      if (sessionId.isEmpty || !_isValidUUID(sessionId)) {
        throw Exception('Invalid session ID format');
      }

      final headers = await _getHeaders();

      if (!headers.containsKey('Authorization')) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse('$_baseUrl/student-sessions/join/$sessionId');
      debugPrint('Making request to: $url');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({}),
      );
      
      return response;
    } catch (e) {
      debugPrint('Error in joinSession: $e');
      rethrow;
    }
  }

  bool _isValidUUID(String uuid) {
    try {
      return uuid.length == 36 &&
          uuid.split('-').length == 5;
    } catch (_) {
      return false;
    }
  }

  Future<StudentSession> getStudentSessionById(String sessionId) async {
    final response = await _makeGetRequest('student-sessions/$sessionId');
    return _handleResponse<StudentSession>(
        response, (data) => StudentSession.fromJson(data));
  }

  Future<List<Teacher>> fetchTeachers() async {
    final response = await _makeGetRequest('users/teachers');
    return _handleResponse<List<Teacher>>(
        response,
            (data) => (data as List<dynamic>)
            .map((json) => Teacher.fromJson(json))
            .toList());
  }

  Future<List<Subject>> fetchSubjects() async {
    final response = await _makeGetRequest('subjects');
    return _handleResponse<List<Subject>>(
        response,
            (data) => (data as List<dynamic>)
            .map((json) => Subject.fromJson(json))
            .toList());
  }

  Future<List<StudentSession>> fetchStudentSessions(String sessionId) async {
    final response = await _makeGetRequest('student-sessions/session/$sessionId');
    return _handleResponse<List<StudentSession>>(
        response,
            (data) => (data as List<dynamic>)
            .map((json) => StudentSession.fromJson(json))
            .toList());
  }

  Future<void> clearAuthToken() async {
    await _storage.delete(key: 'auth_token');
  }
}