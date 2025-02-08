import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationActions {
  static const String acceptAction = 'ACCEPT_ACTION';
  static const String skipAction = 'SKIP_ACTION';

  static final List<AndroidNotificationAction> androidActions = [
    const AndroidNotificationAction(
      acceptAction,
      'Accept',
      showsUserInterface: true,
    ),
    const AndroidNotificationAction(
      skipAction,
      'Skip',
      showsUserInterface: true,
    ),
  ];

  static final List<DarwinNotificationAction> iOSActions = [
    DarwinNotificationAction.plain(
      acceptAction,
      'Accept',
    ),
    DarwinNotificationAction.plain(
      skipAction,
      'Skip',
    ),
  ];

  static final DarwinNotificationCategory iOSCategory =
      DarwinNotificationCategory(
    'booking_requests',
    actions: iOSActions,
  );
}
