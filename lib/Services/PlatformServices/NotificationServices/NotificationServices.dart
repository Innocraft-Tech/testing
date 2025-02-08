import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import './NotificationSound.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.actionId == 'accept_action') {
          _handleAcceptAction();
        } else if (response.actionId == 'skip_action') {
          _handleSkipAction();
        } else if (response.payload != null) {
          final data = _parsePayload(response.payload!);
          handleNavigation(data);
        }
      },
    );

    await _createNotificationChannel();
  }

  static void _handleAcceptAction() {
    print('Accept button clicked');
    // Perform actions for "Accept" button
  }

  static void _handleSkipAction() {
    print('Skip button clicked');
    // Perform actions for "Skip" button
  }

  static Future<void> handleForegroundMessage(RemoteMessage message) async {
    if (isBookingRequest(message)) {
      await showNotification(
        title: message.notification?.title ?? 'New Booking Request',
        body: message.notification?.body ?? 'You have a new booking request',
        payload: message.data.toString(),
      );
      handleNavigation(message.data);
      await NotificationSound.playSound();
    } else {
      await showNotification(
        title: message.notification?.title ?? 'New Booking Request',
        body: message.notification?.body ?? 'You have a new booking request',
        payload: message.data.toString(),
      );
    }
  }

  static bool isBookingRequest(RemoteMessage message) {
    return message.data['type'] == 'new_booking_request';
  }

  static Future<void> _createNotificationChannel() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'booking_requests',
            'Booking Requests',
            description: 'Notifications for new booking requests',
            importance: Importance.max,
            enableVibration: true,
            playSound: true,
          ),
        );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'booking_requests',
      'Booking Requests',
      channelDescription: 'Notifications for new booking requests',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
      autoCancel: true,
      fullScreenIntent: true,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'accept_action',
          'Accept',
          showsUserInterface: true,
          cancelNotification: true,
        ),
        AndroidNotificationAction(
          'skip_action',
          'Skip',
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  static Map<String, dynamic> _parsePayload(String payload) {
    try {
      final Map<String, dynamic> data = {};
      payload
          .replaceAll('{', '')
          .replaceAll('}', '')
          .split(',')
          .forEach((item) {
        final parts = item.split(':');
        if (parts.length == 2) {
          data[parts[0].trim()] = parts[1].trim();
        }
      });
      return data;
    } catch (e) {
      print('Error parsing payload: $e');
      return {};
    }
  }

  static void handleNavigation(Map<String, dynamic> data) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context, rootNavigator: true).pushNamed(
        '/booking-request',
        arguments: data,
      );
    }
  }
}
