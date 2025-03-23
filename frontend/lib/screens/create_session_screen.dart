import 'package:flutter/material.dart';
import 'package:frontend/models/subject.dart';
import 'package:frontend/models/teacher.dart';
import 'package:frontend/service/session_service.dart';

class CreateSessionScreen extends StatefulWidget {
  const CreateSessionScreen({super.key});

  @override
  _CreateSessionScreenState createState() => _CreateSessionScreenState();
}

class _CreateSessionScreenState extends State<CreateSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  String? _selectedTeacherId;
  String? _selectedSubjectId;
  List<Teacher> _teachers = [];
  List<Subject> _subjects = [];
  final SessionService _sessionService = SessionService();

  @override
  void initState() {
    super.initState();
    _loadTeachersAndSubjects();
  }

  Future<void> _loadTeachersAndSubjects() async {
    try {
      final teachers = await _sessionService.fetchTeachers();
      final subjects = await _sessionService.fetchSubjects();
      if (mounted) {
        setState(() {
          _teachers = teachers;
          _subjects = subjects;
        });
      }
    } catch (e) {
      _showSnackBar("Failed to load data: $e");
    }
  }

  Future<void> _createSession() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTeacherId == null || _selectedSubjectId == null) {
      _showSnackBar('Please select a teacher and a subject');
      return;
    }

    final sessionData = {
      "durationInMinutes": int.parse(_durationController.text),
      "teacher": {"id": _selectedTeacherId},
      "subject": {"id": _selectedSubjectId},
    };

    try {
      final response = await _sessionService.createSession(sessionData);

      if (response.statusCode == 200) {
        _showSnackBar('Session created successfully!');
        Navigator.pop(context);
      } else {
        _showSnackBar('Failed to create session: ${response.body}');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _durationController,
                decoration:
                    const InputDecoration(labelText: 'Duration (in minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedTeacherId,
                decoration: const InputDecoration(labelText: 'Teacher'),
                items: _teachers
                    .map((teacher) => DropdownMenuItem(
                          value: teacher.id,
                          child: Text(teacher.name),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedTeacherId = value),
                validator: (value) =>
                    value == null ? 'Please select a teacher' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedSubjectId,
                decoration: const InputDecoration(labelText: 'Subject'),
                items: _subjects
                    .map((subject) => DropdownMenuItem(
                          value: subject.id,
                          child: Text(subject.name),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedSubjectId = value),
                validator: (value) =>
                    value == null ? 'Please select a subject' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createSession,
                child: const Text('Create Session'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }
}
