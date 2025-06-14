import 'package:flutter/material.dart';
import 'package:frontend/screens/create_session_screen.dart';
import 'package:frontend/screens/join_session_screen.dart';
import 'package:frontend/screens/sessions_screen.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../auth/auth_wrapper.dart';
import 'create_subjects_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final isProfessor = auth.userRoles?.contains('ROLE_PROFESSOR') ?? false;
    final isStudent = auth.userRoles?.contains('ROLE_STUDENT') ?? false;

    print("User roles: ${auth.userRoles}");


    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Frontend"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthWrapper()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isProfessor) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SessionsScreen()),
                  );
                },
                child: const Text("View Sessions"),
              ),
              const SizedBox(height: 20),
            ],

            if (isProfessor) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateSessionScreen()),
                  );
                },
                child: const Text("Create Session"),
              ),
              const SizedBox(height: 20),
            ],
            if (isProfessor) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SubjectsScreen()),
                  );
                },
                child: const Text("Manage Subjects"),
              ),
              const SizedBox(height: 20),
            ],


            if (isStudent) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const JoinSessionScreen()),
                  );
                },
                child: const Text("Join Session"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}