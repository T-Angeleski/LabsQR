import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/auth/auth_wrapper.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/session_detail_screen.dart';
import 'package:frontend/service/session_service.dart';
import 'package:frontend/service/student_session_service.dart';
import 'package:frontend/service/subject_service.dart';
import 'package:frontend/service/user_service.dart';
import 'package:frontend/sessionManager/session_manager.dart';
import 'package:provider/provider.dart';
import 'auth/auth_service.dart';

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
        Provider<UserService>(
          create: (context) => UserService(),
        ),
        Provider<SessionService>(
          create: (context) => SessionService(),
        ),
        Provider<SubjectService>(
          create: (context) => SubjectService(),
        ),
        Provider<StudentSessionService>(
          create: (context) => StudentSessionService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AuthWrapper(),
      routes: {
        '/session': (context) => const SessionDetailsScreen(subject: null,),
        '/home': (context) => const HomePage(),
        '/login': (context) => const AuthScreen(),
      },
      onGenerateRoute: (settings) {
        print("Session manager is in session: ${SessionManager().isInSession}");
        if (SessionManager().isInSession && settings.name != '/session') {
          return MaterialPageRoute(
            builder: (context) => const SessionDetailsScreen(subject: null,),
          );
        }
        return null;
      },
    );
  }
}
