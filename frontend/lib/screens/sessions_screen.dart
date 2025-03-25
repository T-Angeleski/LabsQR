import 'package:flutter/material.dart';
import 'package:frontend/screens/student_sessions_screen.dart';
import 'package:frontend/service/session_service.dart';
import 'package:frontend/models/session.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  late Future<List<Session>> futureSessions;
  final SessionService _sessionService = SessionService();

  @override
  void initState() {
    super.initState();
    futureSessions = _sessionService.fetchSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions'),
      ),
      body: FutureBuilder<List<Session>>(
        future: futureSessions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No sessions found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Session session = snapshot.data![index];
                return ListTile(
                  title: Text('Session ID: ${session.id}'),
                  subtitle:
                      Text('Duration: ${session.durationInMinutes} minutes'),
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
                );
              },
            );
          }
        },
      ),
    );
  }
}
