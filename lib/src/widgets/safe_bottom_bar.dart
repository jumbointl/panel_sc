import 'package:flutter/material.dart';

/// Wrap any widget meant to live in `Scaffold.bottomNavigationBar` so it
/// stays visible above the system gesture / 3-button navigation bar on
/// Android 15+ (API 35+) where edge-to-edge is enforced by default.
class SafeBottomBar extends StatelessWidget {
  const SafeBottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: child,
    );
  }
}
