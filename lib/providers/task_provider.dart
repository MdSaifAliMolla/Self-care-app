import 'package:gsoc_smart_health_reminder/providers/daily_streak_provider.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:provider/provider.dart';

class TaskProvider extends ChangeNotifier {
  final Box _taskBox = Hive.box('taskBox');
  final Box _coinBox = Hive.box('coinBox');

  List<Map<String, dynamic>> get tasks {
    return _taskBox.keys.map((key) {
      final rawTask = _taskBox.get(key);
      final task = Map<String, dynamic>.from(rawTask);

      return {
        'key': key, // Ensuring key remains as int
        'title': task['title'] ?? "Untitled Task",
        'alarmTime': task['alarmTime'] != null ? DateTime.tryParse(task['alarmTime']) : null,
        'hasAlarm': task['hasAlarm'] ?? false,
        'isCompleted': task['isCompleted'] ?? false,
      };
    }).toList();
  }

  Future<void> addTask(String title, {DateTime? alarmTime, bool hasAlarm = false}) async {
    int key = await _taskBox.add({
      'title': title,
      'alarmTime': alarmTime?.toIso8601String(),
      'hasAlarm': hasAlarm,
      'isCompleted': false,
    });

    if (hasAlarm && alarmTime != null) {
      _scheduleAlarm(key, alarmTime);
    }
    notifyListeners();
  }

  void removeTask(int key) {
    final task = _taskBox.get(key);
    if (task['hasAlarm'] == true) {
      _cancelAlarm(key);
    }
    _taskBox.delete(key);
    notifyListeners();
  }

  void toggleTaskCompletion(int key) {
    final task = _taskBox.get(key);
    task['isCompleted'] = !(task['isCompleted'] ?? false);
    if(task['isCompleted'] == true) {
      _coinBox.put('coins', _coinBox.get('coins') + 3);

      notifyListeners();
    }else{
      _coinBox.put('coins', _coinBox.get('coins') - 3);
      notifyListeners();
    }
    _taskBox.put(key, task);
    notifyListeners();
  }

  void _scheduleAlarm(int key, DateTime alarmTime) async {
    await AndroidAlarmManager.oneShotAt(
      alarmTime,
      key,
      _alarmCallback,
      exact: true,
      wakeup: true,
    );
  }

  void _cancelAlarm(int key) async {
    await AndroidAlarmManager.cancel(key);
  }
}

void _alarmCallback() {
  print("Alarm triggered!");
}
