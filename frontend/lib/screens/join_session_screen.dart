import 'package:flutter/material.dart';
import 'package:frontend/models/session.dart';
import 'package:frontend/service/session_service.dart';
import 'package:frontend/service/student_session_service.dart';
import 'package:frontend/util/date_util.dart';
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
  bool _showSessionList = true;
  late Future<List<Session>> _availableSessionsFuture;

  @override
  void initState() {
    super.initState();
    _loadAvailableSessions();
  }

  void _loadAvailableSessions() {
    final sessionService = Provider.of<SessionService>(context, listen: false);
    _availableSessionsFuture = sessionService.fetchSessions();
  }

  Future<void> _showJoinConfirmationDialog(Session session) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Join Session'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to join this session?'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.subjectName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Teacher: ${session.teacherName}'),
                    Text('Duration: ${session.durationInMinutes} minutes'),
                    Text('Time remaining: ${_getTimeRemaining(session)}'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Join'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _joinSession(session.id);
    }
  }

  Future<void> _joinSession(String sessionId) async {
    final studentSessionService =
        Provider.of<StudentSessionService>(context, listen: false);

    setState(() => _isLoading = true);

    try {
      final sessionData = await studentSessionService.joinSession(sessionId);

      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.startSession(sessionData);

      if (!mounted) return;

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const SessionDetailsScreen(),
      //
      //   ),
      // );
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Failed to join session: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _joinSessionManually() async {
    final sessionId = _sessionIdController.text.trim();

    if (sessionId.isEmpty) {
      _showSnackBar("Please enter a session ID");
      return;
    }

    await _joinSession(sessionId);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _getTimeRemaining(Session session) {
    if (session.isExpired) return 'Expired';

    final expiryTime =
        session.createdAt.add(Duration(minutes: session.durationInMinutes));
    final remaining = expiryTime.difference(DateTime.now());

    if (remaining.isNegative) return 'Expired';

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m remaining';
    } else {
      return '${minutes}m remaining';
    }
  }

  Color _getSessionStatusColor(Session session) {
    if (session.isExpired) return Colors.red;

    final expiryTime =
        session.createdAt.add(Duration(minutes: session.durationInMinutes));
    final remaining = expiryTime.difference(DateTime.now());

    if (remaining.inMinutes <= 10) return Colors.orange;
    return Colors.green;
  }

  @override
  void dispose() {
    _sessionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Session'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_showSessionList ? Icons.keyboard : Icons.list),
            onPressed: () {
              setState(() {
                _showSessionList = !_showSessionList;
              });
            },
            tooltip: _showSessionList ? 'Manual Entry' : 'Session List',
          ),
          if (_showSessionList)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _loadAvailableSessions();
                });
              },
              tooltip: 'Refresh Sessions',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Joining session...'),
                ],
              ),
            )
          : _showSessionList
              ? _buildSessionList()
              : _buildManualEntry(),
    );
  }

  Widget _buildSessionList() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            'Available Sessions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Session>>(
            future: _availableSessionsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 64),
                        const SizedBox(height: 16),
                        const Text(
                          'Failed to load sessions',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _loadAvailableSessions();
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_busy, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No sessions available',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Check back later or contact your instructor',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _loadAvailableSessions();
                  });
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final session = snapshot.data![index];
                    final statusColor = _getSessionStatusColor(session);
                    final timeRemaining = _getTimeRemaining(session);

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: session.isExpired
                            ? null
                            : () => _showJoinConfirmationDialog(session),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: statusColor,
                                    radius: 20,
                                    child: Icon(
                                      session.isExpired
                                          ? Icons.timer_off
                                          : Icons.timer,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          session.subjectName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'by ${session.teacherName}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!session.isExpired)
                                    const Icon(Icons.arrow_forward_ios,
                                        size: 16),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Divider(height: 1),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Created: ${formatDate(session.createdAt)}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Duration: ${session.durationInMinutes} minutes',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: statusColor, width: 1),
                                    ),
                                    child: Text(
                                      timeRemaining,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildManualEntry() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.qr_code_scanner, size: 64, color: Colors.grey),
          const SizedBox(height: 24),
          const Text(
            'Enter Session ID',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter the session ID provided by your instructor',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _sessionIdController,
            decoration: const InputDecoration(
              labelText: 'Session ID',
              hintText: 'e.g., 123e4567-e89b-12d3-a456-426614174000',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.vpn_key),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _joinSessionManually(),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _joinSessionManually,
            icon: const Icon(Icons.login),
            label: const Text('Join Session'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
