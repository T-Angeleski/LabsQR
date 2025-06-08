import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/screens/session_detail_screen.dart';
import 'package:frontend/service/session_service.dart';
import '../auth/auth_service.dart';

class JoinSessionScreen extends StatefulWidget {
  const JoinSessionScreen({super.key});

  @override
  _JoinSessionScreenState createState() => _JoinSessionScreenState();
}

class _JoinSessionScreenState extends State<JoinSessionScreen> {
  final _sessionIdController = TextEditingController();
  final SessionService _sessionService = SessionService();
  final AuthService _authService = AuthService();

  Future<void> _joinSession() async {
    try {
      final sessionId = _sessionIdController.text.trim();

      print('SessionID: $sessionId');


      if (sessionId.isEmpty) {
        _showSnackBar("Please enter a valid session ID");
        return;
      }


      final userId = await _authService.getCurrentUserIdAsync();

      debugPrint('Attempting to join session $sessionId as user $userId');


      final response = await _sessionService.joinSession(sessionId);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SessionDetailsScreen(
              qrCodeBase64: responseData['qrCode'],
              teacherUrl: responseData['teacherUrl'],
              joinedAt: responseData['joinedAt'],
              attendanceChecked: responseData['attendanceChecked'],
            ),
          ),
        );
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Unknown error';
        _showSnackBar('Failed to join session: $error (${response.statusCode})');
      }
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}");
      debugPrint("Join session error: $e");
    }
  }


  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                hintText: 'Enter session UUID',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _joinSession,
              child: const Text('Join Session'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sessionIdController.dispose();
    super.dispose();
  }
}