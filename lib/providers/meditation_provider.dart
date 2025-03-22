import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:audioplayers/audioplayers.dart';

class MeditationProvider extends ChangeNotifier {
  final Box meditationBox = Hive.box('meditationBox');
  final Box coinBox = Hive.box('coinBox');
  Timer? _timer;
  AudioPlayer _audioPlayer = AudioPlayer();

  int _currentMeditationTime = 0;
  int _meditationGoal = 2;
  bool _isTimerRunning = false;
  int _streak = 0;
  String _mood = "";
  bool _completed = false;
  String _lastUpdated = "";

  MeditationProvider() {
    _loadData();
    _checkAndResetDailyData();
  }

  void _loadData() {
    _currentMeditationTime = meditationBox.get('currentMeditationTime', defaultValue: 0);
    _meditationGoal = meditationBox.get('meditationGoal', defaultValue: 2);
    _streak = meditationBox.get('streak', defaultValue: 0);
    _mood = meditationBox.get('mood', defaultValue: "");
    _completed = meditationBox.get('completed', defaultValue: false);
    _lastUpdated = meditationBox.get('lastUpdated', defaultValue: "");
  }

  void _checkAndResetDailyData() {
    String today = DateTime.now().toIso8601String().substring(0, 10);
    if (_lastUpdated != today) {
      _currentMeditationTime = 0;
      _completed = false;
      _mood = "";
      _lastUpdated = today;
      meditationBox.put('currentMeditationTime', _currentMeditationTime);
      meditationBox.put('completed', _completed);
      meditationBox.put('mood', _mood);
      meditationBox.put('lastUpdated', _lastUpdated);
      notifyListeners();
    }
  }

  int get currentMeditationTime => _currentMeditationTime;
  int get meditationGoal => _meditationGoal;
  bool get isTimerRunning => _isTimerRunning;
  int get streak => _streak;
  String get mood => _mood;
  bool get completed => _completed;
  String get lastUpdated => _lastUpdated;

  double get progress => _currentMeditationTime / (_meditationGoal * 60);

  String get formattedTime {
    int minutes = _currentMeditationTime ~/ 60;
    int seconds = _currentMeditationTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    if (_isTimerRunning) return;
    _isTimerRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _currentMeditationTime++;
      meditationBox.put('currentMeditationTime', _currentMeditationTime);
      _checkGoalCompletion();
      notifyListeners();
    });
  }

  void pauseTimer() {
    if (!_isTimerRunning) return;
    _stopTimer();
  }

  void _stopTimer() {
    _isTimerRunning = false;
    _timer?.cancel();
    _timer = null;
  }

  void setMeditationGoal(int minutes) {
    _meditationGoal = minutes;
    meditationBox.put('meditationGoal', _meditationGoal);
    notifyListeners();
  }

  void setMood(String mood) {
    _mood = mood;
    meditationBox.put('mood', _mood);
    notifyListeners();
  }

  void _checkGoalCompletion() {
    if (!_completed && _currentMeditationTime >= _meditationGoal * 60) {
      _completed = true;
      _streak++;
      meditationBox.put('completed', _completed);
      meditationBox.put('streak', _streak);
      coinBox.put('coins', coinBox.get('coins', defaultValue: 0) + 3);
      _playCompletionSound();
      notifyListeners();
    }
  }

  Future<void> _playCompletionSound() async {
    await _audioPlayer.play(AssetSource('sound/alert.wav'));
  }
}
