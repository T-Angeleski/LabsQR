import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/session.dart';
import '../models/student_session.dart';
import '../models/subject.dart';
import '../models/teacher.dart';

class SessionService {
  static const String _baseUrl = 'http://10.0.2.2:8080/api/sessions';

  Future<http.Response> createSession(Map<String, dynamic> sessionData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(sessionData),
    );
    return response;
  }

  Future<List<Session>> fetchSessions() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/sessions/sessions'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Session.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sessions: ${response.body}');
    }
  }


  Future<http.Response> joinSession(String sessionId, String studentId) async {
    return await http.post(
      Uri.parse('http://10.0.2.2:8080/api/student-sessions/join/$sessionId/student/$studentId'),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<StudentSession> getStudentSessionById(String sessionId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/student-sessions/$sessionId'),
    );

    if (response.statusCode == 200) {
      return StudentSession.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load student session: ${response.body}');
    }
  }


  Future<List<Teacher>> fetchTeachers() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/users/teachers'));
    if (response.statusCode == 200) {
      List<dynamic> teachersJson = jsonDecode(response.body);
      return teachersJson.map((json) => Teacher.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load teachers');
    }
  }

  Future<List<Subject>> fetchSubjects() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/subjects'));
    if (response.statusCode == 200) {
      List<dynamic> subjectsJson = jsonDecode(response.body);
      return subjectsJson.map((json) => Subject.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  Future<List<StudentSession>> fetchStudentSessions(String sessionId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/student-sessions/$sessionId'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => StudentSession.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load student sessions');
    }
  }
}
