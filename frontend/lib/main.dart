import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/session_detail_screen.dart';
import 'package:frontend/service/session_service.dart';
import 'package:frontend/service/subject_service.dart';
import 'package:frontend/sessionManager/session_manager.dart';
import 'package:provider/provider.dart';
import 'auth/auth_service.dart';
import 'auth/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = await AuthService.create();
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
          create: (context) => SubjectService(authService),
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
        '/session': (context) => const SessionDetailsScreen(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const AuthScreen(),
      },
      onGenerateRoute: (settings) {
        print("Session manager is in session: ${SessionManager().isInSession}");
        if (SessionManager().isInSession && settings.name != '/session') {
          return MaterialPageRoute(
            builder: (context) => const SessionDetailsScreen(),
          );
        }
        return null;
      },
    );
  }
}


class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _initialized = false;
  bool _isInSession = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final sessionManager = SessionManager();

    await Future.wait([
      sessionManager.loadSessionState(),
      authService.loadAuthState(),
    ]);

    final sessionActive = await sessionManager.checkSessionActive();
    final loggedIn = await authService.isLoggedIn();

    if (mounted) {
      setState(() {
        _isInSession = sessionActive;
        _isLoggedIn = loggedIn;
        _initialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isInSession) {
      return WillPopScope(
        onWillPop: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please end the session first')),
          );
          return false;
        },
        child: const SessionDetailsScreen(),
      );
    } else if (_isLoggedIn) {
      return const HomePage();
    } else {
      return const AuthScreen();
    }
  }
}

