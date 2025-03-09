import 'package:flutter/material.dart';
import 'package:frontend/screens/create_session_screen.dart';
import 'package:frontend/screens/join_session_screen.dart';
import 'package:frontend/screens/sessions_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Frontend")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SessionsScreen()),
                );
              },
              child: const Text("View Sessions"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateSessionScreen()),
                );
              },
              child: const Text("Create Session"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JoinSessionScreen()),
                );
              },
              child: const Text("Join Session"),
            ),
          ],
        ),
      ),
    );
  }
}