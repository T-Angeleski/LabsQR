import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../models/subject.dart';
import '../service/subject_service.dart';

class EditSubjectScreen extends StatefulWidget {
  final Subject? subject;

  const EditSubjectScreen({this.subject, super.key});

  @override
  _EditSubjectScreenState createState() => _EditSubjectScreenState();
}

class _EditSubjectScreenState extends State<EditSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;

  @override
  void initState() {
    super.initState();
    _name = widget.subject?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject == null ? 'Add Subject' : 'Edit Subject'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Subject Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSubject,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveSubject() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final auth = Provider.of<AuthService>(context, listen: false);
      final subjectService = SubjectService(auth);

      try {
        if (widget.subject == null) {
          await subjectService.createSubject(_name);
        } else {


        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save subject: $e')),
        );
      }
    }
  }
}