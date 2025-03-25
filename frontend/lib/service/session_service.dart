import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/session.dart';
import 'package:frontend/models/student_session.dart';
import 'package:frontend/models/subject.dart';
import 'package:frontend/models/teacher.dart';

class SessionService {
  static const String _baseUrl = 'http://10.0.2.2:8080/api';

  Future<T> _handleResponse<T>(
      http.Response response, T Function(dynamic) fromJson) {
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load data: Status code ${response.statusCode}, Response: ${response.body}');
    }

    dynamic data = jsonDecode(response.body);
    return Future.value(fromJson(data));
  }

  Future<http.Response> _makeGetRequest(String path) async {
    return await http.get(Uri.parse('$_baseUrl/$path'));
  }

  Future<http.Response> _makePostRequest(String path, {dynamic body}) async {
    return await http.post(
      Uri.parse('$_baseUrl/$path'),
      headers: {'Content-Type': 'application/json'},
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

  Future<http.Response> joinSession(String sessionId, String studentId) async {
    return await _makePostRequest(
        'student-sessions/join/$sessionId/student/$studentId');
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
    final response = await _makeGetRequest('student-sessions/$sessionId');
    return _handleResponse<List<StudentSession>>(
        response,
        (data) => (data as List<dynamic>)
            .map((json) => StudentSession.fromJson(json))
            .toList());
  }
}
