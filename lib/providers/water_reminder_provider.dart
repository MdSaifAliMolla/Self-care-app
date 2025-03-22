import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class WaterReminderProvider extends ChangeNotifier {
  int _currentIntake = 0;
  int _waterGoal = 8;
  int _streak = 0;
  String _lastUpdated = '';
  bool _completed = false;
  final Box waterBox = Hive.box('waterBox');

  WaterReminderProvider() {
    _loadData();
    _checkAndResetDailyData();
    if (!waterBox.containsKey('customGoal')) {
      _fetchWeatherData();
    }
  }

  int get currentIntake => _currentIntake;
  int get waterGoal => _waterGoal;
  bool get completed => _completed;
  int get streak => _streak;
  String get lastUpdated => _lastUpdated;

  void _loadData() {
    _currentIntake = waterBox.get('currentIntake', defaultValue: 0);
    _waterGoal = waterBox.get('waterGoal', defaultValue: 8);
    _completed = waterBox.get('completed', defaultValue: false);
    _streak = waterBox.get('streak', defaultValue: 0);
    _lastUpdated = waterBox.get('lastUpdated', defaultValue: '');
  }

  void _checkAndResetDailyData() {
    String today = DateTime.now().toIso8601String().substring(0, 10);
    if (_lastUpdated != today) {
      resetDailyData();
    }
  }

  void increaseIntake() {
    _checkAndResetDailyData();
    _currentIntake++;
    waterBox.put('currentIntake', _currentIntake);
    _checkGoalCompletion();
    notifyListeners();
  }

  void decreaseIntake() {
    if (_currentIntake > 0) {
      _currentIntake--;
      waterBox.put('currentIntake', _currentIntake);
      notifyListeners();
    }
  }

  void setWaterGoal(int goal) {
    _waterGoal = goal;
    waterBox.put('waterGoal', _waterGoal);
    waterBox.put('customGoal', true);
    notifyListeners();
  }

  void _fetchWeatherData() async {

    //use api to fetch weather data
    double simulatedTemperature = 35;
    if (simulatedTemperature > 30) {
      _waterGoal = 12;
    } else if (simulatedTemperature > 20) {
      _waterGoal = 8;
    } else {
      _waterGoal = 6;
    }
    waterBox.put('waterGoal', _waterGoal);
    notifyListeners();
  }

  void _checkGoalCompletion() {
    String today = DateTime.now().toIso8601String().substring(0, 10);
    if (!_completed && _currentIntake >= _waterGoal) {
      _completed = true;
      _streak++;
      waterBox.put('completed', _completed);
      waterBox.put('streak', _streak);
      waterBox.put('lastUpdated', today);
      var coinBox = Hive.box('coinBox');
      coinBox.put('coins', coinBox.get('coins', defaultValue: 0) + 3);
      notifyListeners();
    }
  }

  void resetDailyData() {
    _currentIntake = 0;
    _completed = false;
    _lastUpdated = DateTime.now().toIso8601String().substring(0, 10);
    waterBox.put('currentIntake', _currentIntake);
    waterBox.put('completed', _completed);
    waterBox.put('lastUpdated', _lastUpdated);
    _fetchWeatherData();
    waterBox.delete('customGoal');
    notifyListeners();
  }
}
