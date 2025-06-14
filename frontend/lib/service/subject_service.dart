import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:frontend/models/subject.dart';
import 'package:frontend/auth/auth_service.dart';

class SubjectService {
  static const String _baseUrl = 'http://10.0.2.2:8080/api/subjects';

  final AuthService _authService;

  SubjectService(this._authService);

  Future<List<Subject>> getSubjects() async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Subject.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  Future<Subject> createSubject(String name) async {
    final token = await _authService.getToken();
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'name': name}),
    );

    if (response.statusCode == 200) {
      return Subject.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create subject');
    }
  }

}