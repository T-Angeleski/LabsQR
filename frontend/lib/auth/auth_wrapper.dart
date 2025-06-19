import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/session_detail_screen.dart';
import 'package:frontend/sessionManager/session_manager.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'auth_service.dart';

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
      return const SessionDetailsScreen();
    } else if (_isLoggedIn) {
      return const HomePage();
    } else {
      return const AuthScreen();
    }
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {
    return showLogin
        ? LoginScreen(
            onRegisterClicked: () => setState(() => showLogin = false),
            onLoginSuccess: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            ),
          )
        : RegisterScreen(
            onLoginClicked: () => setState(() => showLogin = true),
            onRegisterSuccess: () {
              setState(() => showLogin = true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Registration successful! Please login.')),
              );
            },
          );
  }
}
