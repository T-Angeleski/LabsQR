import 'package:flutter/material.dart';
import 'package:frontend/models/student_session.dart';
import 'package:frontend/util/service_helpers.dart';

class StudentSessionService {
  Future<Map<String, dynamic>> joinSession(String sessionId) async {
    debugPrint('Attempting to join session: $sessionId');

    if (sessionId.isEmpty || !isValidUUID(sessionId)) {
      throw Exception('Invalid session ID format');
    }

    final response =
        await makePostRequest('student-sessions/join/$sessionId', {});
    return handleResponse<Map<String, dynamic>>(
        response, (data) => data as Map<String, dynamic>);
  }

  Future<StudentSession> getStudentSessionById(String sessionId) async {
    final response = await makeGetRequest('student-sessions/$sessionId');
    return handleResponse<StudentSession>(
        response, (data) => StudentSession.fromJson(data));
  }

  Future<List<StudentSession>> fetchStudentSessions(String sessionId) async {
    final response = await makeGetRequest('student-sessions/$sessionId');
    return handleResponse<List<StudentSession>>(
      response,
      (data) {
        debugPrint('Raw API response: $data');
        return parseListResponse(data, StudentSession.fromJson);
      },
    );
  }

  Future<StudentSession> getStudentSessionByStudentId(String userId) async {
    final response = await makeGetRequest('student-sessions/user/$userId');
    return handleResponse<StudentSession>(
        response, (data) => StudentSession.fromJson(data));
  }

  Future<StudentSession> finishStudentSession(String userId, String studentSessionId) async {
    final response = await makePostRequest(
      'student-sessions/finish/$userId/$studentSessionId',
      {},
    );
    return handleResponse<StudentSession>(
      response, (data) => StudentSession.fromJson(data));
  }

  Future<StudentSession> markAttendance(String userId, String sessionId) async {
    final response = await makePostRequest(
      'student-sessions/attendance/$userId/$sessionId',
      {},
    );
    return handleResponse<StudentSession>(
        response, (data) => StudentSession.fromJson(data));
  }

}
