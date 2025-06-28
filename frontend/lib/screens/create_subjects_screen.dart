import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend/service/subject_service.dart';
import 'package:frontend/models/subject.dart';
import 'edit_subject_screen.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  late Future<List<Subject>> _subjectsFuture;

  @override
  void initState() {
    super.initState();
    _refreshSubjects();
  }

  void _refreshSubjects() {
    final subjectService = Provider.of<SubjectService>(context, listen: false);
    setState(() {
      _subjectsFuture = subjectService.getSubjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Subjects',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditSubjectScreen(),
                  ),
                ).then((_) => _refreshSubjects());
              },
              icon: const Icon(Icons.add, size: 14),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        ],
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
        child: FutureBuilder<List<Subject>>(
          future: _subjectsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No subjects found',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your first subject to get started',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final subject = snapshot.data![index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.blue.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        color: Colors.white,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue.withOpacity(0.1),
                                  Colors.blue.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.book,
                              color: Colors.blue,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            subject.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              color: Colors.blue,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditSubjectScreen(subject: subject),
                                  ),
                                ).then((_) => _refreshSubjects());
                              },
                              tooltip: 'Edit Subject',
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
