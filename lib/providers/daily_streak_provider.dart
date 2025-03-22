// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

// class DailyStreakProvider extends ChangeNotifier {
//   late Box streakBox;
//   late Box stepBox;
//   late Box waterBox;
//   late Box meditationBox;
//   late Box taskBox;
//   bool _isInitialized = false;

//   DailyStreakProvider() {
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     streakBox = Hive.box('dailyStreakBox');
//     stepBox = Hive.box('stepBox');
//     waterBox = Hive.box('waterBox');
//     meditationBox = Hive.box('meditationBox');
//     taskBox = Hive.box('taskBox');
    
//     _isInitialized = true;
//     notifyListeners();
//   }

//   bool get isInitialized => _isInitialized;

//   int get streak => _isInitialized ? streakBox.get('streak', defaultValue: 0) : 0;
//   int get longestStreak => _isInitialized ? streakBox.get('longestStreak', defaultValue: 0) : 0;
//   List<String> get streakDays =>
//       _isInitialized ? List<String>.from(streakBox.get('streakDays', defaultValue: [])) : [];

//   void checkDailyStreak() {
//     if (!_isInitialized) return;

//     final bool stepCompleted = stepBox.get('completed', defaultValue: false);
//     final bool waterCompleted = waterBox.get('completed', defaultValue: false);
//     final bool meditationCompleted = meditationBox.get('completed', defaultValue: false);
//     final List<dynamic> allTasks = taskBox.keys.map((key) => taskBox.get(key)).toList();
//     final bool allTasksCompleted = allTasks.isEmpty || allTasks.every((task) => task['isCompleted'] == true);

//     final String today = DateTime.now().toIso8601String().substring(0, 10);
//     final String lastUpdated = streakBox.get('lastUpdated', defaultValue: '');

//     if (lastUpdated != today) {
//       _removePreviousDayTasks();
//       if ( waterCompleted && meditationCompleted && allTasksCompleted) {
//         int currentStreak = streakBox.get('streak', defaultValue: 0);
//         int longestStreak = streakBox.get('longestStreak', defaultValue: 0);
//         List<String> currentStreakDays = List<String>.from(streakBox.get('streakDays', defaultValue: []));

//         currentStreak++;
//         if (currentStreak > longestStreak) {
//           longestStreak = currentStreak;
//           streakBox.put('longestStreak', longestStreak);
//         }
        
//         streakBox.put('streak', currentStreak);
//         streakBox.put('lastUpdated', today);

//         if (!currentStreakDays.contains(today)) {
//           currentStreakDays.add(today);
//           streakBox.put('streakDays', currentStreakDays);
//         }
//       } else {
//         streakBox.put('streak', 0); 
//       }
//       notifyListeners();
//     }
//   }

//   double getProgress() {
//     if (!_isInitialized) return 0.0;

//     int totalTasks = taskBox.keys.length + 3; // Steps, Water, Meditation + tasks
//     int completedTasks = 0;
//     if (stepBox.get('completed', defaultValue: false)) completedTasks++;
//     if (waterBox.get('completed', defaultValue: false)) completedTasks++;
//     if (meditationBox.get('completed', defaultValue: false)) completedTasks++;
    
//     completedTasks += taskBox.keys.where((key) => taskBox.get(key)['isCompleted'] == true).length;
    
//     return totalTasks > 0 ? completedTasks / totalTasks : 0.0;
//   }

//   void _removePreviousDayTasks() {
//   for (var key in taskBox.keys.toList()) {
//     taskBox.delete(key);
//   }
//   }
// }
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DailyStreakProvider extends ChangeNotifier {
  late Box streakBox;
  late Box stepBox;
  late Box waterBox;
  late Box meditationBox;
  late Box taskBox;
  late Box progressBox; 
  bool _isInitialized = false;
  
  static const int maxStoredDays = 60; 

  DailyStreakProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    streakBox = Hive.box('dailyStreakBox');
    stepBox = Hive.box('stepBox');
    waterBox = Hive.box('waterBox');
    meditationBox = Hive.box('meditationBox');
    taskBox = Hive.box('taskBox');
    progressBox = Hive.box('progressBox');
    
    _isInitialized = true;
    notifyListeners();
  }

  bool get isInitialized => _isInitialized;

  int get streak => _isInitialized ? streakBox.get('streak', defaultValue: 0) : 0;
  int get longestStreak => _isInitialized ? streakBox.get('longestStreak', defaultValue: 0) : 0;
  List<String> get streakDays =>
      _isInitialized ? List<String>.from(streakBox.get('streakDays', defaultValue: [])) : [];

  // Get progress data for the heatmap
  Map<String, double> get progressData {
    if (!_isInitialized) return {};
    
    Map<dynamic, dynamic> rawData = progressBox.toMap();
    Map<String, double> result = {};
    
    rawData.forEach((key, value) {
      if (key is String && value is double) {
        result[key] = value;
      }
    });
    
    return result;
  }

  void checkDailyStreak() {
    if (!_isInitialized) return;

    final bool stepCompleted = stepBox.get('completed', defaultValue: false);
    final bool waterCompleted = waterBox.get('completed', defaultValue: false);
    final bool meditationCompleted = meditationBox.get('completed', defaultValue: false);
    final List<dynamic> allTasks = taskBox.keys.map((key) => taskBox.get(key)).toList();
    final bool allTasksCompleted = allTasks.isEmpty || allTasks.every((task) => task['isCompleted'] == true);

    final String today = DateTime.now().toIso8601String().substring(0, 10);
    final String lastUpdated = streakBox.get('lastUpdated', defaultValue: '');

    double todayProgress = getProgress();
    storeProgressData(today, todayProgress);

    if (lastUpdated != today) {

      if (waterCompleted && meditationCompleted && allTasksCompleted) {
        int currentStreak = streakBox.get('streak', defaultValue: 0);
        int longestStreak = streakBox.get('longestStreak', defaultValue: 0);
        List<String> currentStreakDays = List<String>.from(streakBox.get('streakDays', defaultValue: []));

        currentStreak++;
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
          streakBox.put('longestStreak', longestStreak);
        }
        
        streakBox.put('streak', currentStreak);
        streakBox.put('lastUpdated', today);

        if (!currentStreakDays.contains(today)) {
          currentStreakDays.add(today);
          streakBox.put('streakDays', currentStreakDays);
        }
      } else {
        streakBox.put('streak', 0); 
      }
      notifyListeners();
    }
  }

  double getProgress() {
    if (!_isInitialized) return 0.0;

    int totalTasks = taskBox.keys.length + 3; // Steps, Water, Meditation + tasks
    int completedTasks = 0;
    if (stepBox.get('completed', defaultValue: false)) completedTasks++;
    if (waterBox.get('completed', defaultValue: false)) completedTasks++;
    if (meditationBox.get('completed', defaultValue: false)) completedTasks++;
    
    completedTasks += taskBox.keys.where((key) => taskBox.get(key)['isCompleted'] == true).length;
    
    return totalTasks > 0 ? completedTasks / totalTasks : 0.0;
  }

  // Store progress data 
  void storeProgressData(String date, double progress) {
    if (!_isInitialized) return;
    
    progressBox.put(date, progress);
  
    _cleanupOldProgressData();
  }

  // Remove progress data older than maxStoredDays
  void _cleanupOldProgressData() {
    if (!_isInitialized) return;
    
    final now = DateTime.now();
    final cutoffDate = DateTime(now.year, now.month, now.day - maxStoredDays);
    final cutoffDateString = cutoffDate.toIso8601String().substring(0, 10);
    
    // Get all keys and sort them
    List<String> dateKeys = progressBox.keys
        .where((key) => key is String && key.length == 10) // Format: YYYY-MM-DD
        .map((key) => key as String)
        .toList();
    
    // Remove keys that are older than the cutoff date
    for (var key in dateKeys) {
      if (key.compareTo(cutoffDateString) < 0) {
        progressBox.delete(key);
      }
    }
  }

}