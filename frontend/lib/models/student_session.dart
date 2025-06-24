import 'package:frontend/models/qrcode.dart';
import 'package:frontend/models/user.dart';
import 'grade.dart';

class StudentSession {
  final String id;
  final String sessionId;
  final String studentId;
  final DateTime joinedAt;
  late final bool attendanceChecked;
  final String? subjectName;
  final String? studentName;
  final String? studentIndex;
  final User? student;
  final QRCode? qrCode;
  late final Grade? grade;

  StudentSession({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.joinedAt,
    required this.attendanceChecked,
    this.subjectName,
    this.studentName,
    this.studentIndex,
    this.student,
    this.qrCode,
    this.grade,
  });

  String get displayName {
    if (student?.fullName != null) return student!.fullName;
    if (studentName != null) return studentName!;
    return 'Unknown Student';
  }

  String? get displayEmail {
    return student?.email;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'studentId': studentId,
      'joinedAt': joinedAt.toIso8601String(),
      'attendanceChecked': attendanceChecked,
      'subjectName': subjectName,
      'studentName': studentName,
      'studentIndex': studentIndex,
      'student': student?.toJson(),
      'qrCode': qrCode?.toJson(),
      'grade': grade?.toJson(),
    };
  }

  factory StudentSession.fromJson(Map<String, dynamic> json) {
    return StudentSession(
      id: json['id'] ?? 'unknown',
      sessionId: json['sessionId'] ?? '',
      studentId: json['studentId'] ?? '',
      joinedAt: DateTime.parse(json['joinedAt'] ?? '1970-01-01T00:00:00Z'),
      attendanceChecked: json['attendanceChecked'] ?? false,
      subjectName: json['subjectName'],
      studentName: json['studentName'],
      studentIndex: json['studentIndex'],
      student: json['student'] != null ? User.fromJson(json['student']) : null,
      qrCode: json['qrCode'] != null ? QRCode.fromJson(json['qrCode']) : null,
      grade: json['grade'] != null ? Grade.fromJson(json['grade']) : null,
    );
  }
}
