import 'package:frontend/util/service_helpers.dart';
import 'package:frontend/models/session.dart';

class SessionService {
  Future<void> createSession({
    required int durationInMinutes,
    required String teacherId,
    required String subjectId,
  }) async {
    final sessionData = {
      'durationInMinutes': durationInMinutes,
      'teacherId': teacherId,
      'subjectId': subjectId,
    };
    final response = await makePostRequest('create', sessionData);


    if (response.statusCode != 200) {
      throw Exception('Failed to create session: ${response.body}');
    }
  }

  Future<Session> getSessionById(String sessionId) async {
    final response = await makeGetRequest(sessionId);
    return handleResponse<Session>(
        response, (data) => Session.fromJson(data));
  }

  Future<List<Session>> fetchSessions() async {
    final response = await makeGetRequest(
        'sessions');
    return handleResponse<List<Session>>(
        response, (data) => parseListResponse(data, Session.fromJson));
  }

  Future<List<Session>> fetchActiveSessions() async {
      final response = await makeGetRequest('sessions/active');
      return handleResponse<List<Session>>(
          response, (data) => parseListResponse(data, Session.fromJson));
    }
}
