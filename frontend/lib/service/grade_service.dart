import 'package:frontend/util/service_helpers.dart';
import 'package:frontend/models/grade.dart';
import 'dart:convert';

class GradeService {
  Future<Grade> createOrUpdateGrade({
    required String studentSessionId,
    required int points,
    required int maxPoints,
    required String note,
  }) async {
    final gradeData = {
      'studentSessionId': studentSessionId,
      'points': points,
      'maxPoints': maxPoints,
      'note': note,
    };

    final response = await makePostRequest('grades', gradeData);

    if (response.statusCode != 200) {
      throw Exception('Failed to create or update grade: ${response.body}');
    }

    return Grade.fromJson(jsonDecode(response.body));
  }
}
