import 'package:flutter/material.dart';

import '../service/session_service.dart';

class JoinSessionScreen extends StatefulWidget {
  const JoinSessionScreen({super.key});

  @override
  _JoinSessionScreenState createState() => _JoinSessionScreenState();
}

class _JoinSessionScreenState extends State<JoinSessionScreen> {
  final _sessionIdController = TextEditingController();
  final SessionService _sessionService = SessionService();

  Future<void> _joinSession() async {
    final sessionId = _sessionIdController.text;

    if (sessionId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a session ID')),
      );
      return;
    }

    const studentId = '9e691e30-9561-4c56-9b3c-9de1a5819d98';

    try {
      final response = await _sessionService.joinSession(sessionId, studentId);

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Joined session successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join session: ${response.body}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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