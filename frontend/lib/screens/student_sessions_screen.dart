import 'package:flutter/material.dart';
import 'package:frontend/models/student_session.dart';
import 'package:frontend/service/student_session_service.dart';
import 'package:frontend/util/date_util.dart';

class StudentSessionsScreen extends StatefulWidget {
  final String sessionId;
  const StudentSessionsScreen({super.key, required this.sessionId});

  @override
  State<StudentSessionsScreen> createState() => _StudentSessionsScreenState();
}

class _StudentSessionsScreenState extends State<StudentSessionsScreen> {
  late Future<List<StudentSession>> futureStudentSessions;
  final StudentSessionService _studentSessionService = StudentSessionService();
  final Map<String, String> _tempGrades = {};

  @override
  void initState() {
    super.initState();
    futureStudentSessions = _fetchStudentSessions();
  }

  Future<List<StudentSession>> _fetchStudentSessions() async {
    try {
      return await _studentSessionService
          .fetchStudentSessions(widget.sessionId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load sessions: $e')),
        );
      }
      rethrow;
    }
  }

  Future<void> _showGradeDialog(StudentSession session) async {
    final gradeController = TextEditingController(
      text: _tempGrades[session.id] ?? session.grade?.displayValue ?? '',
    );

    final grade = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.grade, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Grade ${session.displayName}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student: ${session.displayName}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            if (session.studentIndex != null)
              Text(
                'Index: ${session.studentIndex}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            Text(
              'Joined: ${formatDate(session.joinedAt)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            if (session.grade != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Grade: ${session.grade!.value}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Letter Grade: ${session.grade!.letterGrade}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (session.grade!.note != null)
                      Text(
                        'Note: ${session.grade!.note}',
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: gradeController,
              decoration: const InputDecoration(
                labelText: 'Enter points (e.g., 85/100)',
                hintText: 'e.g., 85/100 or just 85',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, gradeController.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (grade != null && grade.isNotEmpty) {
      setState(() {
        _tempGrades[session.id] = grade;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Grade "$grade" saved locally for ${session.displayName}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _toggleAttendance(StudentSession session) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Attendance toggle not implemented yet'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Color _getAttendanceColor(bool isPresent) {
    return isPresent ? Colors.green : Colors.red;
  }

  IconData _getAttendanceIcon(bool isPresent) {
    return isPresent ? Icons.check_circle : Icons.cancel;
  }

  Widget _buildStudentCard(StudentSession session, int index) {
    final hasTempGrade = _tempGrades.containsKey(session.id);
    final gradeDisplay = hasTempGrade
        ? _tempGrades[session.id]!
        : session.grade?.displayValue ?? 'No grade';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showGradeDialog(session),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (session.studentIndex != null)
                          Text(
                            'Index: ${session.studentIndex}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        if (session.displayEmail != null)
                          Text(
                            session.displayEmail!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Grade display with color coding
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: hasTempGrade
                          ? Colors.blue.withOpacity(0.1)
                          : (session.grade != null
                              ? Colors.green.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: hasTempGrade
                            ? Colors.blue
                            : (session.grade != null
                                ? Colors.green
                                : Colors.grey),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          gradeDisplay,
                          style: TextStyle(
                            color: hasTempGrade
                                ? Colors.blue
                                : (session.grade != null
                                    ? Colors.green
                                    : Colors.grey[700]),
                            fontWeight: hasTempGrade || session.grade != null
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                        if (session.grade != null && !hasTempGrade)
                          Text(
                            session.grade!.letterGrade,
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Joined: ${formatDate(session.joinedAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  // Attendance status
                  InkWell(
                    onTap: () => _toggleAttendance(session),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getAttendanceColor(session.attendanceChecked)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getAttendanceIcon(session.attendanceChecked),
                            size: 16,
                            color:
                                _getAttendanceColor(session.attendanceChecked),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            session.attendanceChecked ? 'Present' : 'Absent',
                            style: TextStyle(
                              color: _getAttendanceColor(
                                  session.attendanceChecked),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Sessions'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_tempGrades.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_tempGrades.length} unsaved',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Save all grades',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Grade submission to server not implemented yet'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              setState(() {
                futureStudentSessions = _fetchStudentSessions();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<StudentSession>>(
        future: futureStudentSessions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading student sessions...'),
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
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 64),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load student sessions',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          futureStudentSessions = _fetchStudentSessions();
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
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No students have joined this session yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Students will appear here once they join',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final sessions = snapshot.data!;
          final presentCount =
              sessions.where((s) => s.attendanceChecked).length;
          final gradedCount = sessions
              .where((s) => s.grade != null || _tempGrades.containsKey(s.id))
              .length;

          return Column(
            children: [
              // Enhanced stats header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total',
                        '${sessions.length}',
                        Icons.people,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'Present',
                        '$presentCount',
                        Icons.check_circle,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'Absent',
                        '${sessions.length - presentCount}',
                        Icons.cancel,
                        Colors.red,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'Graded',
                        '$gradedCount',
                        Icons.grade,
                        Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
              // Students list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      futureStudentSessions = _fetchStudentSessions();
                    });
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      return _buildStudentCard(sessions[index], index);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
