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
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.subject != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Subject' : 'Add Subject',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.02),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.blue.withOpacity(0.1),
                                    Colors.blue.withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.book,
                                color: Colors.blue,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isEditing
                                        ? 'Edit Subject'
                                        : 'Create New Subject',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isEditing
                                        ? 'Update subject information'
                                        : 'Add a new subject to manage',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Colors.blue.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Subject Details',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Subject Name',
                                    labelStyle:
                                        TextStyle(color: Colors.grey[600]),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 2),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                    prefixIcon: const Icon(Icons.school,
                                        color: Colors.blue),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter a subject name';
                                    }
                                    return null;
                                  },
                                  enabled: !_isLoading,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 56,
                  margin: const EdgeInsets.only(top: 24),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveSubject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isEditing ? Icons.update : Icons.add,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isEditing ? 'Update Subject' : 'Create Subject',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
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
