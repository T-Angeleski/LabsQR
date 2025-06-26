import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/subject.dart';
import '../screens/session_detail_screen.dart';
import '../service/session_service.dart';
import '../service/student_session_service.dart';

class SessionHelper {
  static Future<void> joinSessionAndNavigate(
      BuildContext context,
      String sessionId
      ) async {
    try {
      final studentSessionService = Provider.of<StudentSessionService>(context, listen: false);
      final sessionService = Provider.of<SessionService>(context, listen: false);

      await studentSessionService.joinSession(sessionId);
      final session = await sessionService.getSessionById(sessionId);

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SessionDetailsScreen(
              subject: Subject(
                  id: session.subjectId,
                  name: session.subjectName
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join session: ${e.toString()}')),
        );
      }
      rethrow;
    }
  }
}