import 'package:frontend/models/qrcode.dart';
import 'package:frontend/models/user.dart';
import 'grade.dart';

class StudentSession {
  final String id;
  final DateTime joinedAt;
  final bool attendanceChecked;
  final User? student;
  final QRCode? qrCode;
  final Grade? grade;

  StudentSession({
    required this.id,
    required this.joinedAt,
    required this.attendanceChecked,
    this.student,
    this.qrCode,
    this.grade,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'joinedAt': joinedAt.toIso8601String(),
      'attendanceChecked': attendanceChecked,
      'student': student?.toJson(),
      'qrCode': qrCode?.toJson(),
      'grade': grade?.toJson(),
    };
  }


  factory StudentSession.fromJson(Map<String, dynamic> json) {
    return StudentSession(
      id: json['id'] ?? 'unknown',
      joinedAt: DateTime.parse(json['joinedAt'] ?? '1970-01-01T00:00:00Z'),
      attendanceChecked: json['attendanceChecked'] ?? false,
      student: json['student'] != null ? User.fromJson(json['student']) : null,
      qrCode: json['qrCode'] != null ? QRCode.fromJson(json['qrCode']) : null,
      grade: json['grade'] != null ? Grade.fromJson(json['grade']) : null,
    );
  }
}