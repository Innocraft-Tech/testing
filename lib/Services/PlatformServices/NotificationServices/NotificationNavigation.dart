import 'package:flutter/material.dart';

class NotificationNavigation {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void navigateToBookingRequest(Map<String, dynamic> data) {
    // Ensure we're on the main thread and wait for frames to be rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = navigatorKey.currentContext;
      if (context != null) {
        // Use pushNamedAndRemoveUntil to clear any existing routes
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/booking-request',
          (route) => route.isFirst, // Keep only the first route
          arguments: data,
        );
      }
    });
  }
}
