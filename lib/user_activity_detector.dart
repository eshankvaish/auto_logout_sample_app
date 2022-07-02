import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_logout_sample_app/auto_logout_service.dart';

class UserActivityDetector extends StatefulWidget {
  const UserActivityDetector({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<UserActivityDetector> createState() => _UserActivityDetectorState();
}

class _UserActivityDetectorState extends State<UserActivityDetector> {
  // Prefer singleton for the auto logout service
  final AutoLogoutService _autoLogoutService = AutoLogoutService();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    _autoLogoutService.startNewTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);
    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          _autoLogoutService.trackUserActivity();
        }
      },
      child: GestureDetector(
        // Important for detecting the clicks properly for clickable and non-clickable places.
        behavior: HitTestBehavior.deferToChild,
        onTapDown: _autoLogoutService.trackUserActivity,
        child: widget.child,
      ),
    );
  }
}
