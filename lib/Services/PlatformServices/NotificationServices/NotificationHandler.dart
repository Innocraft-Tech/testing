import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class NotificationHandler {
  static AudioPlayer? _audioPlayer;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static bool _isInitialized = false;
  static Map<String, dynamic>? _pendingNotification;

  static Future<void> initialize() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer
        ?.setAsset('lib/Helpers/Resources/Sounds/zappy_sound.mp3');
    _isInitialized = true;

    if (_pendingNotification != null) {
      _handleNavigation(_pendingNotification!);
      _pendingNotification = null;
    }
  }

  static void _handleNavigation(Map<String, dynamic> data) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentContext != null) {
        Navigator.pushNamed(
          navigatorKey.currentContext!,
          '/booking-request',
          arguments: data,
        );
      }
    });
  }

  // Modified to only handle sound and navigation
  @pragma('vm:entry-point')
  static Future<void> handleBookingRequest(RemoteMessage message) async {
    try {
      if (_audioPlayer == null) {
        _audioPlayer = AudioPlayer();
        await _audioPlayer
            ?.setAsset('lib/Helpers/Resources/Sounds/zappy_sound.mp3');
      }

      await _audioPlayer?.seek(Duration.zero);
      await _audioPlayer?.play();

      if (_isInitialized) {
        _handleNavigation(message.data);
      } else {
        _pendingNotification = message.data;
      }
    } catch (e) {
      print('Error handling booking request: $e');
    }
  }

  static Future<void> handleInitialNotification() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _handleNavigation(message.data);
    }
  }
}
