import 'dart:async';
import 'package:flutter/material.dart';
import '../sessionManager/session_manager.dart';

class SessionDetailsScreen extends StatefulWidget {
  const SessionDetailsScreen({super.key});

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen> {
  Timer? _sessionTimer;
  Duration? _remainingTime;
  final SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _startSessionTimer();
  }

  void _startSessionTimer() {
    _updateRemainingTime();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    if (_sessionManager.sessionEndTime != null) {
      final now = DateTime.now();
      if (now.isAfter(_sessionManager.sessionEndTime!)) {
        _endSession();
      } else {
        setState(() {
          _remainingTime = _sessionManager.sessionEndTime!.difference(now);
        });
      }
    }
  }

  Future<void> _endSession() async {
    _sessionTimer?.cancel();
    await _sessionManager.endSession();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<bool> _onWillPop() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please end the session first to exit'),
        duration: Duration(seconds: 2),
      ),
    );
    return false;
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Active Session'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please use the End Session button'),
                  ),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_remainingTime != null)
                Text(
                  'Time remaining: ${_remainingTime!.inMinutes}m ${_remainingTime!.inSeconds.remainder(60)}s',
                  style: const TextStyle(fontSize: 24),
                ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _endSession,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: const Text(
                  'END SESSION',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}