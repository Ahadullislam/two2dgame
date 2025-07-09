import 'package:audioplayers/audioplayers.dart';

class SoundPlayer {
  static final AudioPlayer _player = AudioPlayer();
  static Future<void> play(String assetName) async {
    try {
      await _player.play(AssetSource('sounds/$assetName'));
    } catch (_) {}
  }
}

// Usage:
// SoundPlayer.play('tap.mp3'); // Place tap.mp3 in assets/sounds/
// SoundPlayer.play('win.mp3');
// SoundPlayer.play('lose.mp3');
// SoundPlayer.play('draw.mp3');
