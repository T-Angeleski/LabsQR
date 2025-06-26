import 'package:flutter/material.dart';
import 'package:frontend/auth/auth_wrapper.dart';
import 'package:frontend/auth/auth_service.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/session_detail_screen.dart';
import 'package:frontend/service/session_service.dart';
import 'package:frontend/service/student_session_service.dart';
import 'package:frontend/service/subject_service.dart';
import 'package:frontend/service/user_service.dart';
import 'package:frontend/sessionManager/session_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'models/subject.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = await AuthService.create();
  await authService.loadAuthState();

  await SessionManager().loadSessionState();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        Provider<FlutterSecureStorage>(
          create: (_) => const FlutterSecureStorage(),
        ),
        Provider<UserService>(create: (_) => UserService()),
        Provider<SessionService>(create: (_) => SessionService()),
        Provider<SubjectService>(create: (_) => SubjectService()),
        Provider<StudentSessionService>(create: (_) => StudentSessionService()),
        Provider<SubjectService>(create: (_) => SubjectService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final studentSessionService = Provider.of<StudentSessionService>(context, listen: false);
    final sessionService = Provider.of<SessionService>(context, listen: false);
    final subjectService = Provider.of<SubjectService>(context, listen: false);

    Widget home;

    if (!(authService.isInSession)) {
      home = const AuthWrapper();
    } else if (authService.userRoles?.contains('ROLE_STUDENT') == true && SessionManager().isInSession) {
      print("AUF STUDENTOT SUM JAAASS");
      home = FutureBuilder<Subject>(
        future: () async {
          final userId = await authService.getCurrentUserIdAsync();
          final joinedStudentSession = await studentSessionService.getStudentSessionByStudentId(userId);
          final joinedSession = await sessionService.getSessionById(joinedStudentSession.sessionId);
          final subject = await subjectService.getSubjectById(joinedSession.subjectId);
          return subject;
        }(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return SessionDetailsScreen(subject: snapshot.data!);
        },
      );
    } else {
      home = const HomePage();
    }

    return MaterialApp(
      home: home,
      routes: {
        '/home': (_) => const HomePage(),
        '/login': (_) => const AuthWrapper(),
      },
    );
  }
}
