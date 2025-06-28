import 'package:flutter/material.dart';
import 'package:frontend/auth/auth_service.dart';
import 'package:frontend/models/subject.dart';
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
  String? _currentUserId;
  String? _selectedSubjectId;
  List<Subject> _subjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserAndSubjects();
  }

  Future<void> _loadCurrentUserAndSubjects() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final subjectService =
          Provider.of<SubjectService>(context, listen: false);

      final results = await Future.wait([
        authService.getCurrentUserIdAsync(),
        subjectService.getSubjects(),
      ]);

      if (mounted) {
        setState(() {
          _currentUserId = results[0] as String;
          _subjects = results[1] as List<Subject>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar("Failed to load data: $e");
      }
    }
  }

  Future<void> _createSession() async {
    if (!_formKey.currentState!.validate()) return;

    if (_currentUserId == null || _selectedSubjectId == null) {
      _showSnackBar('Please select a subject');
      return;
    }

    try {
      final sessionService =
          Provider.of<SessionService>(context, listen: false);
      await sessionService.createSession(
        durationInMinutes: int.parse(_durationController.text),
        teacherId: _currentUserId!,
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
    if (!mounted) return;
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
