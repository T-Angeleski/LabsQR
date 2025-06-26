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
  Duration? get sessionDuration => _sessionDuration;

  /// Load persisted state and automatically end expired sessions
  Future<void> loadSessionState() async {
    final sessionData = await _storage.read(key: _sessionKey);
    if (sessionData != null) {
      final data = jsonDecode(sessionData) as Map<String, dynamic>;
      _isInSession = data['isActive'] == true;

      if (data['endTime'] != null) {
        _sessionEndTime = DateTime.parse(data['endTime']);

        // If already past end time, clear session
        if (DateTime.now().isAfter(_sessionEndTime!)) {
          await endSession();
        } else {
          // Calculate remaining duration
          _sessionDuration = _sessionEndTime!.difference(DateTime.now());
        }
      }
    }
  }

  /// Start a session for the given duration
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

  /// End the current session and clear storage
  Future<void> endSession() async {
    _isInSession = false;
    _sessionStartTime = null;
    _sessionEndTime = null;
    _sessionDuration = null;
    await _storage.delete(key: _sessionKey);
  }

  /// Check if session is still active (and refresh state)
  Future<bool> checkSessionActive() async {
    await loadSessionState();
    if (_isInSession && _sessionEndTime != null) {
      return DateTime.now().isBefore(_sessionEndTime!);
    }
    return false;
  }
}