import 'package:just_audio/just_audio.dart';

class NotificationSound {
  static AudioPlayer? _audioPlayer;

  static Future<void> initialize() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer
        ?.setAsset('lib/Helpers/Resources/Sounds/zappy_sound.mp3');
  }

  static Future<void> playSound() async {
    try {
      if (_audioPlayer == null) {
        await initialize();
      }
      await _audioPlayer?.seek(Duration.zero);
      await _audioPlayer?.play();
    } catch (e) {
      print('Error playing notification sound: $e');
    }
  }

  static Future<void> stopSound() async {
    try {
      if (_audioPlayer == null) {
        await initialize();
      }
      await _audioPlayer?.stop();
    } catch (e) {
      print('Error playing notification sound: $e');
    }
  }
}
