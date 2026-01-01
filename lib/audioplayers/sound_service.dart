import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  Future<void> playAlarmSound() async {
    if (_isPlaying) return;
    _isPlaying = true;
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('sounds/alarm.mp3'));
  }

  Future<void> stopAlarmSound() async {
    if (!_isPlaying) return;
    _isPlaying = false;
    await _audioPlayer.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}