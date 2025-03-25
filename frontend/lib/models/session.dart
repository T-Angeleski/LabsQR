import 'package:frontend/models/student_session.dart';

class Session {
  final String id;
  final String createdAt;
  final int durationInMinutes;
  final List<StudentSession>? studentSessions;

  Session({
    required this.id,
    required this.createdAt,
    required this.durationInMinutes,
    this.studentSessions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'durationInMinutes': durationInMinutes,
      'studentSessions':
          studentSessions?.map((session) => session.toJson()).toList(),
    };
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] ?? 'unknown',
      createdAt: json['createdAt'] ?? 'unknown',
      durationInMinutes: json['durationInMinutes'] ?? 0,
      studentSessions: json['studentSessions'] != null
          ? (json['studentSessions'] as List)
              .map((studentSessionJson) =>
                  StudentSession.fromJson(studentSessionJson))
              .toList()
          : null,
    );
  }
}
