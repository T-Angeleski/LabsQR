import 'package:flutter/material.dart';
import 'package:frontend/models/subject.dart';
import 'package:frontend/screens/create_session_screen.dart';
import 'package:frontend/screens/qr_scanner_screen.dart';
import 'package:frontend/screens/session_detail_screen.dart';
import 'package:frontend/screens/sessions_screen.dart';
import 'package:provider/provider.dart';

import 'package:frontend/auth/auth_service.dart';
import 'package:frontend/auth/auth_wrapper.dart';
import '../service/session_service.dart';
import '../service/student_session_service.dart';
import '../service/subject_service.dart';
import 'create_subjects_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final isProfessor = auth.userRoles?.contains('ROLE_PROFESSOR') ?? false;
    final isStudent = auth.userRoles?.contains('ROLE_STUDENT') ?? false;
    final userName = auth.userFullName ?? 'Guest';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).primaryColor.withOpacity(0.6),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, $userName!',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            isProfessor ? 'Professor' : 'Student',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () async {
                          await Provider.of<AuthService>(context, listen: false)
                              .logout();
                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AuthWrapper()),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.qr_code_scanner,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'LabsQR',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Digital Lab Session Management',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),

                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  if (isProfessor) ...[
                                    Text(
                                      'Professor Dashboard',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    _buildActionCard(
                                      title: 'View Sessions',
                                      subtitle: 'See all your created sessions',
                                      icon: Icons.view_list,
                                      color: Colors.blue,
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SessionsScreen(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildActionCard(
                                      title: 'Create Session',
                                      subtitle: 'Start a new lab session',
                                      icon: Icons.add_circle,
                                      color: Colors.green,
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CreateSessionScreen(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildActionCard(
                                      title: 'Manage Subjects',
                                      subtitle: 'Add or edit your subjects',
                                      icon: Icons.school,
                                      color: Colors.purple,
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SubjectsScreen(),
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (isStudent) ...[
                                    Text(
                                      'Student Portal',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    _buildActionCard(
                                      title: 'Join Session',
                                      subtitle:
                                          'Scan QR code to join a lab session',
                                      icon: Icons.qr_code_scanner,
                                      color: Colors.orange,
                                      onTap: () => _handleJoinSession(context),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildActionCard(
                                      title: 'Show Current Session',
                                      subtitle:
                                          'View the session you have joined',
                                      icon: Icons.visibility,
                                      color: Colors.teal,
                                      onTap: () async {
                                        try {
                                          final studentSessionService = Provider
                                              .of<StudentSessionService>(
                                                  context,
                                                  listen: false);
                                          final sessionService =
                                              Provider.of<SessionService>(
                                                  context,
                                                  listen: false);
                                          final authService =
                                              Provider.of<AuthService>(context,
                                                  listen: false);
                                          final subjectService =
                                              Provider.of<SubjectService>(
                                                  context,
                                                  listen: false);

                                          final userId = await authService
                                              .getCurrentUserIdAsync();
                                          final joinedStudentSession =
                                              await studentSessionService
                                                  .getStudentSessionByStudentId(
                                                      userId);

                                          if (joinedStudentSession.isFinished ==
                                              true) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    'Session Finished'),
                                                content: const Text(
                                                    'You have already finished your session.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            );
                                            return;
                                          }

                                          final joinedSession =
                                              await sessionService
                                                  .getSessionById(
                                                      joinedStudentSession
                                                          .sessionId);
                                          final subject = await subjectService
                                              .getSubjectById(
                                                  joinedSession.subjectId);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SessionDetailsScreen(
                                                subject: subject,
                                              ),
                                            ),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'No active session found or failed to load: $e')),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                  const SizedBox(height: 40),
                                ],
                              ),
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
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color.withOpacity(0.05),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _handleJoinSession(BuildContext context) async {
  try {
    final hasActiveSession = await _hasActiveStudentSession(context);

    if (hasActiveSession) {
      if (context.mounted) {
        _showActiveSessionDialog(context);
      }
      return;
    }

    if (context.mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QrScannerScreen()),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking sessions: $e')),
      );
    }
  }
}

Future<bool> _hasActiveStudentSession(BuildContext context) async {
  try {
    final studentSessionService =
        Provider.of<StudentSessionService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    final userId = await authService.getCurrentUserIdAsync();
    final session =
        await studentSessionService.getStudentSessionByStudentId(userId);

    return !session.isFinished;
  } catch (e) {
    debugPrint('Error checking active session: $e');
    return false;
  }
}

void _showActiveSessionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Active Session Found'),
      content: const Text(
          'You already have an active session. Please end it before joining a new one.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SessionDetailsScreen(
                  subject: new Subject(id: "id", name: "testing"),
                ),
              ),
            );
          },
          child: const Text('View Session'),
        ),
      ],
    ),
  );
}
