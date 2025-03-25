import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/screens/session_detail_screen.dart';
import 'package:frontend/service/session_service.dart';

class JoinSessionScreen extends StatefulWidget {
  const JoinSessionScreen({super.key});

  @override
  _JoinSessionScreenState createState() => _JoinSessionScreenState();
}

class _JoinSessionScreenState extends State<JoinSessionScreen> {
  final _sessionIdController = TextEditingController();
  final SessionService _sessionService = SessionService();

  // TODO: Replace
  static const _studentId = '3ce62b17-1577-4495-b793-dc9959e5e651';

  Future<void> _joinSession() async {
    final sessionId = _sessionIdController.text;

    if (sessionId.isEmpty) {
      _showSnackBar("Please enter a session ID");
      return;
    }

    try {
      final response = await _sessionService.joinSession(sessionId, _studentId);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

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
        _showSnackBar('Failed to join session: ${response.body}');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
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
      appBar: AppBar(
        title: const Text('Join Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _sessionIdController,
              decoration: const InputDecoration(labelText: 'Session ID'),
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
