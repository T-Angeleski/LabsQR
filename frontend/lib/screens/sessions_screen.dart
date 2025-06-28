import 'package:flutter/material.dart';
import 'package:frontend/screens/show_qr_code_screen.dart';
import 'package:frontend/screens/student_sessions_screen.dart';
import 'package:frontend/service/session_service.dart';
import 'package:frontend/models/session.dart';
import 'package:frontend/util/date_util.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  late Future<List<Session>> futureSessions;
  final SessionService _sessionService = SessionService();

  @override
  void initState() {
    super.initState();
    futureSessions = _sessionService.fetchSessions();
  }

  void _refreshSessions() {
    setState(() {
      futureSessions = _sessionService.fetchSessions();
    });
  }

  Color _getSessionStatusColor(Session session) {
    if (session.isExpired || _hasNoTimeLeft(session)) {
      return Colors.red;
    }
    return Colors.green;
  }

  bool _hasNoTimeLeft(Session session) {
    final created = session.createdAt;
    final duration = Duration(minutes: session.durationInMinutes);
    final now = DateTime.now();
    final end = created.add(duration);
    final timeLeft = end.difference(now);

    return timeLeft.inMinutes <= 0;
  }

  IconData _getSessionStatusIcon(Session session) {
    if (session.isExpired || _hasNoTimeLeft(session)) {
      return Icons.schedule;
    }
    return Icons.play_circle;
  }

  String _getSessionStatusText(Session session) {
    if (session.isExpired) {
      return 'Finished';
    }
    return 'Active';
  }

  Widget _buildSessionCard(Session session) {
    final statusColor = _getSessionStatusColor(session);
    final statusIcon = _getSessionStatusIcon(session);
    final statusText = _getSessionStatusText(session);
    final isExpiredOrNoTime = session.isExpired || _hasNoTimeLeft(session);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.blue.withOpacity(0.1),
          width: 1,
        ),
      ),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentSessionsScreen(
                sessionId: session.id,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.withOpacity(0.1),
                          Colors.blue.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.school,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.subjectName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'by ${session.teacherName}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          statusIcon,
                          size: 16,
                          color: statusColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(
                height: 1,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      Icons.timer,
                      'Time Left',
                      (() {
                        final created = session.createdAt;
                        final duration =
                            Duration(minutes: session.durationInMinutes);
                        final now = DateTime.now();
                        final end = created.add(duration);
                        final timeLeft = end.difference(now);
                        final minutesLeft =
                            timeLeft.inMinutes > 0 ? timeLeft.inMinutes : 0;

                        if (minutesLeft == 0) {
                          return 'Finished';
                        }
                        return '$minutesLeft min';
                      })(),
                      (() {
                        final created = session.createdAt;
                        final duration =
                            Duration(minutes: session.durationInMinutes);
                        final now = DateTime.now();
                        final end = created.add(duration);
                        final timeLeft = end.difference(now);

                        return timeLeft.inMinutes <= 0
                            ? Colors.red
                            : statusColor;
                      })(),
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      Icons.calendar_today,
                      'Created',
                      formatDate(session.createdAt),
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentSessionsScreen(
                              sessionId: session.id,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.people, size: 18),
                      label: const Text('View Students'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  if (!isExpiredOrNoTime) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowQrCodeScreen(
                                qrCodeBytes: session.qrCode,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.qr_code, size: 18),
                        label: const Text('QR Code'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
      IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshSessions,
            tooltip: 'Refresh Sessions',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.02),
              Colors.white,
            ],
          ),
        ),
        child: FutureBuilder<List<Session>>(
          future: futureSessions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading sessions...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.grey[400],
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Failed to load sessions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _refreshSessions,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_note,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No sessions found',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sessions will appear here once they are created',
                      style: TextStyle(color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            final sessions = snapshot.data!;
            final activeSessions = sessions
                .where((s) => !s.isExpired && !_hasNoTimeLeft(s))
                .length;
            final expiredSessions = sessions.length - activeSessions;

            return Column(
              children: [
                if (sessions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Sessions',
                            '${sessions.length}',
                            Icons.event_note,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Active',
                            '$activeSessions',
                            Icons.play_circle,
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Expired',
                            '$expiredSessions',
                            Icons.schedule,
                            Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => _refreshSessions(),
                    color: Colors.blue,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        return _buildSessionCard(sessions[index]);
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
