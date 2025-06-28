import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/models/student_session.dart';
import 'package:frontend/service/student_session_service.dart';
import 'package:frontend/util/date_util.dart';

import 'package:frontend/models/grade.dart';
import 'package:frontend/service/grade_service.dart';

class StudentSessionsScreen extends StatefulWidget {
  final String sessionId;
  const StudentSessionsScreen({super.key, required this.sessionId});

  @override
  State<StudentSessionsScreen> createState() => _StudentSessionsScreenState();
}

class _StudentSessionsScreenState extends State<StudentSessionsScreen> {
  late Future<List<StudentSession>> _futureStudentSessions;
  final StudentSessionService _studentSessionService = StudentSessionService();

  @override
  void initState() {
    super.initState();
    _futureStudentSessions = _fetchStudentSessions();
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
      return Future.error(e);
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _futureStudentSessions = _fetchStudentSessions();
    });
  }

  Future<Grade?> _showGradeDialog(StudentSession session) async {
    final gradeService = GradeService();
    final currentGrade = session.grade;

    final pointsController =
        TextEditingController(text: currentGrade?.points.toString() ?? '');
    final maxPointsController =
        TextEditingController(text: currentGrade?.maxPoints.toString() ?? '10');
    final noteController =
        TextEditingController(text: currentGrade?.note ?? '');

    final formKey = GlobalKey<FormState>();

    return await showDialog<Grade?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isSubmitting = false;

            return AlertDialog(
              title: Text('Grade ${session.displayName}',
                  style: const TextStyle(fontSize: 18)),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: pointsController,
                              decoration: const InputDecoration(
                                  labelText: 'Points',
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                final points = int.tryParse(value);
                                final maxPoints =
                                    int.tryParse(maxPointsController.text);
                                if (points == null || points < 0) {
                                  return 'Invalid';
                                }
                                if (maxPoints != null && points > maxPoints) {
                                  return 'Pts > Max';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: maxPointsController,
                              decoration: const InputDecoration(
                                  labelText: 'Max Points',
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                if (int.tryParse(value) == null ||
                                    int.parse(value) <= 0) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: noteController,
                        decoration: const InputDecoration(
                            labelText: 'Note (optional)',
                            border: OutlineInputBorder()),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                      isSubmitting ? null : () => Navigator.pop(context, null),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setState(() => isSubmitting = true);
                            try {
                              final grade =
                                  await gradeService.createOrUpdateGrade(
                                studentSessionId: session.id,
                                points: int.parse(pointsController.text),
                                maxPoints: int.parse(maxPointsController.text),
                                note: noteController.text,
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      'Grade saved for ${session.displayName}'),
                                  backgroundColor: Colors.green,
                                ));
                                Navigator.pop(context, grade);
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      'Error: ${e.toString().replaceAll('Exception: ', '')}'),
                                  backgroundColor: Colors.red,
                                ));
                                setState(() => isSubmitting = false);
                              }
                            }
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _toggleAttendance(StudentSession session) async {
    // TODO: Implement API call
    setState(() {
      session.attendanceChecked = !session.attendanceChecked;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${session.displayName} marked as ${session.attendanceChecked ? 'Present' : 'Absent'}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildGradeChip(Grade? grade) {
    if (grade == null) {
      return const Chip(
        label: Text('No Grade'),
        backgroundColor: Color(0xFFE0E0E0),
        avatar: Icon(Icons.edit_note, size: 16, color: Colors.black54),
      );
    }

    return Chip(
      label: Text(
        '${grade.points} / ${grade.maxPoints}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
      avatar:
          Icon(Icons.grade, size: 16, color: Theme.of(context).primaryColor),
    );
  }

  Widget _buildAttendanceChip(StudentSession session) {
    return ActionChip(
      onPressed: () => _toggleAttendance(session),
      avatar: Icon(
        session.attendanceChecked ? Icons.check_circle : Icons.cancel,
        color: session.attendanceChecked ? Colors.green : Colors.red,
        size: 16,
      ),
      label: Text(session.attendanceChecked ? 'Present' : 'Absent'),
      backgroundColor: (session.attendanceChecked ? Colors.green : Colors.red)
          .withOpacity(0.1),
    );
  }

  Widget _buildStudentCard(StudentSession session, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        key: ValueKey(session.id),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Text('${index + 1}',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold)),
        ),
        title: Text(session.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            session.studentIndex ?? session.displayEmail ?? 'No identifier'),
        trailing: _buildGradeChip(session.grade),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Joined: ${formatDate(session.joinedAt)}',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[700])),
                      if (session.grade?.note?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 8),
                        Text('Note: ${session.grade!.note}',
                            style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[800])),
                      ],
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit, size: 16),
                        label: Text(
                            session.grade == null ? 'Add Grade' : 'Edit Grade'),
                        onPressed: () async {
                          final newGrade = await _showGradeDialog(session);
                          if (newGrade != null && mounted) {
                            await _refreshData();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _buildAttendanceChip(session),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Sessions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _refreshData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<StudentSession>>(
          future: _futureStudentSessions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('No students have joined this session yet.'));
            }

            final sessions = snapshot.data!;
            final presentCount =
                sessions.where((s) => s.attendanceChecked).length;
            final gradedCount = sessions.where((s) => s.grade != null).length;

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceVariant
                      .withOpacity(0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard('Total', '${sessions.length}',
                          Icons.people, Colors.blue),
                      _buildStatCard('Present', '$presentCount',
                          Icons.check_circle, Colors.green),
                      _buildStatCard(
                          'Absent',
                          '${sessions.length - presentCount}',
                          Icons.abc,
                          Colors.red),
                      _buildStatCard(
                          'Graded', '$gradedCount', Icons.grade, Colors.purple),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      return _buildStudentCard(sessions[index], index);
                    },
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
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(title,
            style: TextStyle(fontSize: 12, color: color.withOpacity(0.9))),
      ],
    );
  }
}
