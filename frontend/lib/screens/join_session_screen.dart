import 'package:flutter/material.dart';
import 'package:frontend/screens/session_detail_screen.dart';
import 'package:frontend/service/student_session_service.dart';
import 'package:provider/provider.dart';

import 'package:frontend/auth/auth_service.dart';

class JoinSessionScreen extends StatefulWidget {
  const JoinSessionScreen({super.key});

  @override
  _JoinSessionScreenState createState() => _JoinSessionScreenState();
}

class _JoinSessionScreenState extends State<JoinSessionScreen> {
  final _sessionIdController = TextEditingController();
  bool _isLoading = false;

  Future<void> _joinSession() async {
    final sessionId = _sessionIdController.text.trim();
    final _studentSessionService =
        Provider.of<StudentSessionService>(context, listen: false);
    if (sessionId.isEmpty) {
      _showSnackBar("Please enter a session ID");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final sessionData = await _studentSessionService.joinSession(sessionId);

      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.startSession(sessionData);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SessionDetailsScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Failed to join session: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _sessionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Session')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _sessionIdController,
              decoration: const InputDecoration(
                labelText: 'Session ID',
                hintText: 'Enter the session ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _joinSession,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Join Session'),
            ),
          ],
        ),
      ),
    );
  }
}
