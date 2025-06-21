import 'dart:convert';

class Session {
  final String id;
  final String teacherId;
  final String subjectId;
  final int durationInMinutes;
  final DateTime createdAt;
  final String teacherName;
  final String subjectName;
  final bool isExpired;
  final List<int> qrCode;

  Session({
    required this.id,
    required this.teacherId,
    required this.subjectId,
    required this.durationInMinutes,
    required this.createdAt,
    required this.teacherName,
    required this.subjectName,
    required this.isExpired,
    required this.qrCode,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      teacherId: json['teacherId'],
      subjectId: json['subjectId'],
      durationInMinutes: json['durationInMinutes'],
      createdAt: DateTime.parse(json['createdAt']),
      teacherName: json['teacherName'],
      subjectName: json['subjectName'],
      isExpired: json['isExpired'] ?? false,
      qrCode: base64Decode(json['qrCode']),
    );
  }
}