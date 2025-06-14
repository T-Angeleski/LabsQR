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
  final Map<String, String> _tempGrades = {};

  @override
  void initState() {
    super.initState();
    futureStudentSessions = _fetchStudentSessions();
  }

  Future<List<StudentSession>> _fetchStudentSessions() async {
    try {
      return await _sessionService.fetchStudentSessions(widget.sessionId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load sessions: $e')),
      );
      rethrow;
    }
  }

  Future<void> _showGradeDialog(StudentSession session) async {
    final gradeController = TextEditingController(
      text: _tempGrades[session.id] ?? session.grade?.value ?? '',
    );

    final grade = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(session.student?.fullName ?? 'Grade Student'),
        content: TextField(
          controller: gradeController,
          decoration: const InputDecoration(
            labelText: 'Enter grade',
            hintText: 'e.g., A, B+, 85',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, gradeController.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (grade != null) {
      setState(() {
        _tempGrades[session.id] = grade;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grade saved locally')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Sessions'),
        actions: [
          if (_tempGrades.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Grade submission to server not implemented yet'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
        ],
      ),
      body: FutureBuilder<List<StudentSession>>(
        future: futureStudentSessions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureStudentSessions = _fetchStudentSessions();
                      });
                    },
                    child: const Text('Retry Again'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No student sessions found'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                futureStudentSessions = _fetchStudentSessions();
              });
            },
            child: ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final session = snapshot.data![index];
                final hasTempGrade = _tempGrades.containsKey(session.id);
                final gradeDisplay = hasTempGrade
                    ? _tempGrades[session.id]
                    : session.grade?.value ?? 'No grade';

                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(session.student?.fullName ?? 'Student ${index + 1}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Joined: ${_formatDate(session.joinedAt)}'),
                      Text(
                        session.attendanceChecked ? 'Present' : 'Absent',
                        style: TextStyle(
                          color: session.attendanceChecked ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    gradeDisplay!,
                    style: TextStyle(
                      color: hasTempGrade ? Colors.blue : Colors.black,
                      fontWeight: hasTempGrade ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  onTap: () => _showGradeDialog(session),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}