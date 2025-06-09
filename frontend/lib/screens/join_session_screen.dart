import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/screens/session_detail_screen.dart';
import 'package:frontend/service/session_service.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import '../auth/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class JoinSessionScreen extends StatefulWidget {
  const JoinSessionScreen({super.key});

  @override
  _JoinSessionScreenState createState() => _JoinSessionScreenState();
}

class _JoinSessionScreenState extends State<JoinSessionScreen> {
  final _sessionIdController = TextEditingController();
  final SessionService _sessionService = SessionService();
  final AuthService _authService = AuthService();
  QRViewController? _qrViewController;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _isScanning = false;

  Future<void> _joinSession() async {
    try {
      final sessionId = _sessionIdController.text.trim();

      if (sessionId.isEmpty) {
        _showSnackBar("Please enter a valid session ID");
        return;
      }

      await _processSessionJoin(sessionId);
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}");
      debugPrint("Join session error: $e");
    }
  }

  Future<void> _processSessionJoin(String sessionId) async {
    final userId = await _authService.getCurrentUserIdAsync();
    debugPrint('Attempting to join session $sessionId as user $userId');

    final response = await _sessionService.joinSession(sessionId);

    if (!mounted) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SessionDetailsScreen(
            qrCodeBase64: responseData['qrCode'],
            teacherUrl: responseData['teacherUrl'],
            joinedAt: responseData['joinedAt'],
            attendanceChecked: responseData['attendanceChecked'],
          ),
        ),
      );
    } else {
      final error = jsonDecode(response.body)['message'] ?? 'Unknown error';
      _showSnackBar('Failed to join session: $error (${response.statusCode})');
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrViewController = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        controller.pauseCamera();
        setState(() {
          _isScanning = false;
        });
        await _processSessionJoin(scanData.code!);
      }
    });
  }

  Future<void> _scanFromGallery() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {

        _showSnackBar("Gallery scanning not implemented yet");
      }
    } catch (e) {
      _showSnackBar("Error scanning from gallery: ${e.toString()}");
    }
  }

  void _toggleScan() {
    setState(() {
      _isScanning = !_isScanning;
      if (!_isScanning) {
        _qrViewController?.dispose();
        _qrViewController = null;
      }
    });
  }

  @override
  void dispose() {
    _qrViewController?.dispose();
    _sessionIdController.dispose();
    super.dispose();
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
      appBar: AppBar(title: const Text('Join Session')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_isScanning) ...[
              TextField(
                controller: _sessionIdController,
                decoration: const InputDecoration(
                  labelText: 'Session ID',
                  hintText: 'Enter session UUID',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _joinSession,
                child: const Text('Join Session'),
              ),
              const SizedBox(height: 20),
              Text(
                'OR',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: _toggleScan,
              child: Text(_isScanning ? 'Stop Scanning' : 'Scan QR Code'),
            ),
            if (_isScanning) ...[
              const SizedBox(height: 20),
              Expanded(
                child: QRView(
                  key: _qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.blue,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
              ),
              TextButton(
                onPressed: _scanFromGallery,
                child: const Text('Scan from Gallery'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}