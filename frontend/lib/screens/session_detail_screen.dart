import 'package:flutter/material.dart';
import 'dart:convert';

class SessionDetailsScreen extends StatelessWidget {
  final String qrCodeBase64;
  final String teacherUrl;
  final String joinedAt;
  final String attendanceChecked;

  const SessionDetailsScreen({
    super.key,
    required this.qrCodeBase64,
    required this.teacherUrl,
    required this.joinedAt,
    required this.attendanceChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.memory(
                base64Decode(qrCodeBase64),
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            Text('Teacher URL: $teacherUrl'),
            Text('Joined At: $joinedAt'),
            Text('Attendance Checked: $attendanceChecked'),
          ],
        ),
      ),
    );
  }
}