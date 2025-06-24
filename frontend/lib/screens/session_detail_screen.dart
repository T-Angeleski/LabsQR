import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/auth/auth_service.dart';
import 'package:frontend/service/student_session_service.dart';
import 'package:frontend/sessionManager/session_manager.dart';
import 'package:provider/provider.dart';

import '../models/subject.dart';

class SessionDetailsScreen extends StatefulWidget {
  final Subject? subject;

  const SessionDetailsScreen({super.key, required this.subject});

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen>
    with TickerProviderStateMixin {
  Timer? _sessionTimer;
  Duration? _remainingTime;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _startSessionTimer();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
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

    final authService = Provider.of<AuthService>(context, listen: false);
    final studentSessionService = Provider.of<StudentSessionService>(context, listen: false);

    final userId = await authService.getCurrentUserIdAsync();
    final studentSession = await studentSessionService.getStudentSessionByStudentId(userId);

    print("JOINED STUDENT SESSION " + studentSession.isFinished.toString());

    await studentSessionService.finishStudentSession(userId, studentSession.id);

    await _sessionManager.endSession();

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _showEndSessionDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('End Session'),
          content: const Text(
              'Are you sure you want to end this session? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('End Session'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _endSession();
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

  Color _getTimerColor() {
    if (_remainingTime == null) return Colors.green;

    final totalMinutes = _remainingTime!.inMinutes;
    if (totalMinutes <= 5) return Colors.red;
    if (totalMinutes <= 10) return Colors.orange;
    return Colors.green;
  }

  String _formatTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _pulseController.dispose();
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
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Session Info'),
                    content: const Text(
                        'You are currently in an active session. Use the "End Session" button to exit properly.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Status indicator
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green.withOpacity(0.2),
                                  border:
                                      Border.all(color: Colors.green, width: 3),
                                ),
                                child: const Icon(
                                  Icons.wifi_tethering,
                                  size: 60,
                                  color: Colors.green,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),

                        // Session active text
                        const Text(
                          'Session Active',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Subject display
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.book, color: Colors.purple),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.subject?.name ?? 'No subject',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Timer display
                        if (_remainingTime != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            decoration: BoxDecoration(
                              color: _getTimerColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: _getTimerColor(), width: 2),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Time Remaining',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _getTimerColor(),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _formatTime(_remainingTime!),
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: _getTimerColor(),
                                    fontFeatures: const [
                                      FontFeature.tabularFigures()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Warning message for low time
                          if (_remainingTime!.inMinutes <= 10)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.warning, color: Colors.orange),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Session ending soon! Please save your work.',
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],

                        const SizedBox(height: 48),

                        // Instructions
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.info, color: Colors.blue, size: 32),
                              SizedBox(height: 8),
                              Text(
                                'Session Instructions',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '• Stay connected during the entire session\n'
                                '• Complete assigned tasks before time runs out\n'
                                '• Use the "End Session" button when finished',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // End session button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showEndSessionDialog,
                      icon: const Icon(Icons.exit_to_app),
                      label: const Text(
                        'END SESSION',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
