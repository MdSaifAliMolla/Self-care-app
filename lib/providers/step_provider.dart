import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class StepProvider with ChangeNotifier {

  final Box _statsBox = Hive.box('stepBox');

  int _stepGoal = 5000;
  int _currentSteps = 0;
  int _streak = 0;
  int _coins = 0;
  bool _completed = false;
  String _lastupdated = DateTime.now()
        .subtract(Duration(days: 1))
        .toIso8601String()
        .substring(0, 10);

  int get stepGoal => _stepGoal;
  int get currentSteps => _currentSteps;
  int get streak => _streak;
  int get coins => _coins;
  bool get completed => _completed;
  String get lastupdated => _lastupdated;



  StepProvider() {
    _initializeProvider();
  }

  Future<void> _initializeProvider() async {
    _stepGoal = _statsBox.get('stepGoal', defaultValue: 5000);
    _streak = _statsBox.get('streak', defaultValue: 0);
    _coins = _statsBox.get('coins', defaultValue: 0);
    _completed = _statsBox.get('completed', defaultValue: false);
    _currentSteps = _statsBox.get('currentSteps', defaultValue: 0);
    _lastupdated=_statsBox.get('_lastupdated', defaultValue: DateTime.now().subtract(Duration(days: 1)).toIso8601String().substring(0, 10));
    bool isAvailable = await HealthConnectFactory.isAvailable();
    debugPrint("Health Connect available: $isAvailable");
    
    // Request permissions & sync health data
    await _requestHealthPermissions();
    await syncHealthData();

    // Schedule daily reset
    _scheduleDailyReset();
  }

  Future<void> _requestHealthPermissions() async {
    bool hasPermission = await HealthConnectFactory.requestPermissions([
      HealthConnectDataType.Steps,
    ]);

    if (!hasPermission) {
      debugPrint('Health data permissions not granted');
    }
  }

  Future<bool> syncHealthData() async {
    try {
      DateTime now = DateTime.now();
      DateTime dayStart = DateTime(now.year, now.month, now.day);

      // Fetch step data
      var results = await HealthConnectFactory.getRecord(
        startTime: dayStart,
        endTime: now,
        type: HealthConnectDataType.Steps
      );

      int todaySteps = 0;
      if (results.containsKey(HealthConnectDataType.Steps.name)) {
        var stepRecords = results[HealthConnectDataType.Steps.name];
        for (var record in stepRecords) {
          todaySteps += record.value as int;
        }
      }

      _currentSteps = todaySteps;
      _checkGoalAchievement();

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Health data sync error: $e');
      return false;
    }
  }

  void _checkGoalAchievement() {
    if (_currentSteps >= _stepGoal && !_completed && _lastupdated!=DateTime.now().toIso8601String().substring(0, 10)) {
      _completed = true;
      _streak++;
      
      int bonusCoins = 3;
      _coins += bonusCoins;

      // Save achievement data
      _statsBox.put('streak', _streak);
      _statsBox.put('coins', _coins);
      _statsBox.put('completed', true);
      _statsBox.put('lastupdated', DateTime.now().toIso8601String().substring(0, 10));


      notifyListeners();  
    }
  }

  void _scheduleDailyReset() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final duration = nextMidnight.difference(now);

    Timer(duration, () {
      _currentSteps = 0;
      _completed = false;

      _scheduleDailyReset();
      syncHealthData();

      notifyListeners();
    });
  }

  void setDailyStepGoal(int newGoal) {
    _stepGoal = newGoal;
    _statsBox.put('stepGoal', newGoal);
    notifyListeners();
  }

  @override
  void dispose() {
    _statsBox.close();
    super.dispose();
  }
}
