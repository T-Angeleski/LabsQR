import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final studentSessionService =
        Provider.of<StudentSessionService>(context, listen: false);
    final sessionService = Provider.of<SessionService>(context, listen: false);
    final subjectService = Provider.of<SubjectService>(context, listen: false);

    return FutureBuilder<bool>(
      future: authService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            theme: _buildAppTheme(),
            home: _buildLoadingScreen(),
          );
        }

        final isAuthenticated = snapshot.data ?? false;
        final studentInSession =
            authService.userRoles?.contains('ROLE_STUDENT') == true &&
                SessionManager().isInSession;

        Widget home;

        if (!isAuthenticated) {
          home = const AuthWrapper();
        } else if (studentInSession) {
          home = FutureBuilder<Subject>(
            future: () async {
              final userId = await authService.getCurrentUserIdAsync();
              final joinedStudentSession = await studentSessionService
                  .getStudentSessionByStudentId(userId);
              final joinedSession = await sessionService
                  .getSessionById(joinedStudentSession.sessionId);
              final subject =
                  await subjectService.getSubjectById(joinedSession.subjectId);
              return subject;
            }(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return _buildSessionLoadingScreen();
              }
              return SessionDetailsScreen(subject: snapshot.data!);
            },
          );
        } else {
          home = const HomePage();
        }

        return MaterialApp(
          theme: _buildAppTheme(),
          home: home,
          routes: {
            '/home': (_) => const HomePage(),
            '/login': (_) => const AuthWrapper(),
          },
        );
      },
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      useMaterial3: false,
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.blue.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        primary: Colors.blue,
        onPrimary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black87,
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.withOpacity(0.1),
                      Colors.blue.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.school,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Lab Session Manager',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Loading application...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionLoadingScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.withOpacity(0.1),
                      Colors.blue.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Resuming Session',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Connecting to your active session...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
