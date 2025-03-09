import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/teacher.dart';
import '../service/session_service.dart';

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
      if (!mounted) return;
      setState(() {
        _teachers = teachers;
        _subjects = subjects;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
    }
  }

  Future<void> _createSession() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTeacherId == null || _selectedSubjectId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a teacher and a subject')),
        );
        return;
      }

      final sessionData = {
        "durationInMinutes": int.parse(_durationController.text),
        "teacher": {
          "id": _selectedTeacherId,
        },
        "subject": {
          "id": _selectedSubjectId,
        },
      };

      try {
        final response = await _sessionService.createSession(sessionData);

        if (!mounted) return;

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Session created successfully!')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create session: ${response.body}')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
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
                decoration: const InputDecoration(labelText: 'Duration (in minutes)'),
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
                items: _teachers.map((teacher) {
                  return DropdownMenuItem(
                    value: teacher.id,
                    child: Text(teacher.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTeacherId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a teacher';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedSubjectId,
                decoration: const InputDecoration(labelText: 'Subject'),
                items: _subjects.map((subject) {
                  return DropdownMenuItem(
                    value: subject.id,
                    child: Text(subject.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubjectId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a subject';
                  }
                  return null;
                },
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