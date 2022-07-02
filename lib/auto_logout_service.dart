import 'dart:async';
import 'package:auto_logout_sample_app/auth_service.dart';

/// Service for handling user auto logout based on user activity
class AutoLogoutService {
  static Timer? _timer;
  static const autoLogoutTimer = 15;
  final AuthService _authService = AuthService();

  /// Resets the existing timer and starts a new timer
  void startNewTimer() {
    stopTimer();
    if (_authService.isUserLoggedIn()) {
      _timer = Timer.periodic(const Duration(minutes: autoLogoutTimer), (_) {
        timedOut();
      });
    }
  }

  /// Stops the existing timer if it exists
  void stopTimer() {
    if (_timer != null || (_timer?.isActive != null && _timer!.isActive)) {
      _timer?.cancel();
    }
  }

  void trackUserActivity([_]) async {
    print('User Activity Detected!');
    if (_authService.isUserLoggedIn() && _timer != null) {
      startNewTimer();
    }
  }

  /// Called if the user is inactive for a period of time and opens a dialog
  Future<void> timedOut() async {
    stopTimer();
    if (_authService.isUserLoggedIn()) {
      _authService.logoutUser(reason: 'auto-logout');
    }
  }
}
