import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/models/music._model.dart';

class MusicPlayerProvider with ChangeNotifier {
  AudioPlayer? _audioPlayer;
  MeditationSound? _currentSound;
  bool _isPlaying = false;

  MeditationSound? get currentSound => _currentSound;
  bool get isPlaying => _isPlaying;

  MusicPlayerProvider() {
    _audioPlayer = AudioPlayer();

    _audioPlayer?.onPlayerStateChanged.listen((PlayerState state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });
  }

  Future<void> playSound(MeditationSound sound) async {

    if (_isPlaying) {
      await _audioPlayer?.stop();
    }

    _currentSound = sound;
    await _audioPlayer?.play(AssetSource(sound.assetPath.replaceAll('assets/', '')));
    notifyListeners();
  }

  Future<void> pauseSound() async {
    await _audioPlayer?.pause();
    notifyListeners();
  }

  Future<void> resumeSound() async {
    await _audioPlayer?.resume();
    notifyListeners();
  }

  Future<void> stopSound() async {
    await _audioPlayer?.stop();
    _currentSound = null;
    notifyListeners();
  }

  // Cleanup
  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }
}