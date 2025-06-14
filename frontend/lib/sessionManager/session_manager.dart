import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _sessionKey = 'active_session';

  bool _isInSession = false;
  DateTime? _sessionStartTime;
  DateTime? _sessionEndTime;
  Duration? _sessionDuration;

  bool get isInSession => _isInSession;
  DateTime? get sessionEndTime => _sessionEndTime;

  Future<void> loadSessionState() async {
    final sessionData = await _storage.read(key: _sessionKey);
    if (sessionData != null) {
      final data = jsonDecode(sessionData);
      _isInSession = data['isActive'] ?? false;
      if (data['endTime'] != null) {
        _sessionEndTime = DateTime.parse(data['endTime']);

        if (DateTime.now().isAfter(_sessionEndTime!)) {
          await endSession();
        } else {
          _sessionDuration = _sessionEndTime!.difference(DateTime.now());
        }
      }
    }
  }

  Future<void> startSession(Duration duration) async {
    _isInSession = true;
    _sessionStartTime = DateTime.now();
    _sessionEndTime = _sessionStartTime!.add(duration);
    _sessionDuration = duration;

    await _storage.write(
      key: _sessionKey,
      value: jsonEncode({
        'isActive': true,
        'startTime': _sessionStartTime!.toIso8601String(),
        'endTime': _sessionEndTime!.toIso8601String(),
        'durationInMinutes': duration.inMinutes,
      }),
    );
  }

  Future<void> endSession() async {
    _isInSession = false;
    _sessionStartTime = null;
    _sessionEndTime = null;
    _sessionDuration = null;
    await _storage.delete(key: _sessionKey);
  }

  Future<bool> checkSessionActive() async {
    await loadSessionState();
    if (_isInSession && _sessionEndTime != null) {
      return DateTime.now().isBefore(_sessionEndTime!);
    }
    return false;
  }
}