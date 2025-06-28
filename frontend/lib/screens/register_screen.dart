import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/auth/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onLoginClicked;
  final Function() onRegisterSuccess;

  const RegisterScreen({
    super.key,
    required this.onLoginClicked,
    required this.onRegisterSuccess,
  });

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _indexController = TextEditingController();
  bool _isLoading = false;
  String? _selectedRole;

  final List<String> _roleOptions = ['ROLE_STUDENT', 'ROLE_PROFESSOR'];

  bool get _isProfessor => _selectedRole == 'ROLE_PROFESSOR';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: InputDecoration(
                            labelText: 'Role',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon:
                                const Icon(Icons.badge, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          hint: const Text('Select your role'),
                          items: _roleOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value
                                    .replaceAll('ROLE_', '')
                                    .toLowerCase()
                                    .capitalize(),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedRole = newValue;
                              if (_isProfessor) {
                                _indexController.clear();
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select your role';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_selectedRole == 'ROLE_STUDENT') ...[
                          TextFormField(
                            controller: _indexController,
                            decoration: InputDecoration(
                              labelText: 'Student Index',
                              labelStyle: TextStyle(color: Colors.grey[600]),
                              hintText: 'Enter your index number',
                              prefixIcon:
                                  const Icon(Icons.numbers, color: Colors.blue),
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
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (value) {
                              if (_selectedRole == 'ROLE_STUDENT' &&
                                  (value == null || value.isEmpty)) {
                                return 'Please enter your index number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextFormField(
                          controller: _fullNameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            hintText: 'Enter your full name',
                            prefixIcon:
                                const Icon(Icons.person, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            hintText: 'Enter your email address',
                            prefixIcon:
                                const Icon(Icons.email, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            hintText: 'Enter your password (min 6 characters)',
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  height: 56,
                  child: _isLoading
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_add, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: widget.onLoginClicked,
                    child: const Text(
                      'Already have an account? Sign in',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
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

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        final result = await authService.register(
          _fullNameController.text,
          _emailController.text,
          _passwordController.text,
          _selectedRole!,
          _indexController.text.isNotEmpty ? _indexController.text : '',
        );

        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: Colors.blue,
            ),
          );
          widget.onRegisterSuccess();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _indexController.dispose();
    super.dispose();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
