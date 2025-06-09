import 'package:flutter/material.dart';
import 'package:frontend/models/student_session.dart';
import 'package:frontend/service/session_service.dart';

class StudentSessionsScreen extends StatefulWidget {
  final String sessionId;

  const StudentSessionsScreen({super.key, required this.sessionId});

  @override
  _StudentSessionsScreenState createState() => _StudentSessionsScreenState();
}

class _StudentSessionsScreenState extends State<StudentSessionsScreen> {
  late Future<List<StudentSession>> futureStudentSessions;
  final SessionService _sessionService = SessionService();

  @override
  void initState() {
    super.initState();
    futureStudentSessions =
        _sessionService.fetchStudentSessions(widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Sessions'),
      ),
      body: FutureBuilder<List<StudentSession>>(
        future: futureStudentSessions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No student sessions found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                StudentSession studentSession = snapshot.data![index];
                return ListTile(
                  title: Text('Student: ${studentSession.student?.fullName}'),
                  subtitle: Text('Joined At: ${studentSession.joinedAt}'),
                  trailing: Text(
                      'Attendance: ${studentSession.attendanceChecked ? 'Present' : 'Absent'}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
