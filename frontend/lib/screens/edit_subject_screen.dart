import 'package:flutter/material.dart';
import 'package:frontend/models/subject.dart';
import 'package:frontend/service/subject_service.dart';
import 'package:provider/provider.dart';

class EditSubjectScreen extends StatefulWidget {
  final Subject? subject;

  const EditSubjectScreen({super.key, this.subject});

  @override
  _EditSubjectScreenState createState() => _EditSubjectScreenState();
}

class _EditSubjectScreenState extends State<EditSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.subject?.name ?? '';
  }

  Future<void> _saveSubject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final subjectService = Provider.of<SubjectService>(context, listen: false);
    final name = _nameController.text.trim();

    try {
      if (widget.subject == null) {
        await subjectService.createSubject(name);
        _showSnackBar('Subject created successfully');
      } else {
        await subjectService.updateSubject(widget.subject!.id, name);
        _showSnackBar('Subject updated successfully');
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showSnackBar('Failed to save subject: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
    final isEditing = widget.subject != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Subject' : 'Add Subject'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Subject Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a subject name';
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveSubject,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(isEditing ? 'Update' : 'Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
