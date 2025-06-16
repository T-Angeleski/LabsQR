// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:frontend/models/subject.dart';
import 'package:frontend/models/teacher.dart';
import 'package:frontend/service/user_service.dart';
import 'package:provider/provider.dart';

import 'package:frontend/service/session_service.dart';
import 'package:frontend/service/subject_service.dart';

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
  bool _isLoading = true;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _loadTeachersAndSubjects();
    }
  }

  @override
  void initState() {
    super.initState();
    print("Dobrobe");
  }

  Future<void> _loadTeachersAndSubjects() async {
    try {
      final userService = Provider.of<UserService>(context, listen: false);
      final subjectService =
          Provider.of<SubjectService>(context, listen: false);

      print('Fetching users...');
      final teachers = await userService.getTeachers();
      print("Teachers: $teachers");

      print('Fetching subjects...');
      final subjects = await subjectService.getSubjects();
      print('Raw subjects response: $subjects');

      if (mounted) {
        setState(() {
          _teachers = teachers;
          _subjects = subjects;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar("Failed to load data: $e");
      }
    }
  }

  Future<void> _createSession() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTeacherId == null || _selectedSubjectId == null) {
      _showSnackBar('Please select a teacher and a subject');
      return;
    }

    try {
      final sessionService =
          Provider.of<SessionService>(context, listen: false);
      await sessionService.createSession(
        durationInMinutes: int.parse(_durationController.text),
        teacherId: _selectedTeacherId!,
        subjectId: _selectedSubjectId!,
      );

      if (mounted) {
        _showSnackBar('Session created successfully!');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to create session: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Session'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        labelText: 'Duration (in minutes)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the duration';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedTeacherId,
                      decoration: const InputDecoration(
                        labelText: 'Teacher',
                        border: OutlineInputBorder(),
                      ),
                      items: _teachers
                          .map((teacher) => DropdownMenuItem(
                                value: teacher.id,
                                child: Text(teacher.fullName),
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
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
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
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _createSession,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Create Session',
                        style: TextStyle(fontSize: 18),
                      ),
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
