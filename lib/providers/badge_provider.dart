import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'daily_streak_provider.dart'; // Import DailyStreakProvider

class BadgeProvider extends ChangeNotifier {
  Box streakBox = Hive.box('dailyStreakBox');
  bool _isInitialized = false;

  final List<Map<String, dynamic>> badges = [
    {"name": "3-Day Streak", "imagePath": "assets/images/b.jpg", "requiredStreak": 3},
    {"name": "7-Day Streak", "imagePath": "assets/images/b.jpg", "requiredStreak": 7},
    // {"name": "15-Day Streak", "imagePath": "assets/images/15_day.png", "requiredStreak": 15},
    // {"name": "30-Day Streak", "imagePath": "assets/images/30_day.png", "requiredStreak": 30},
  ];

  BadgeProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _isInitialized = true;
    _checkBadges();
    notifyListeners();
  }

  bool get isInitialized => _isInitialized;

  void _checkBadges() {
    if (!_isInitialized) return;

    int streak = streakBox.get('streak', defaultValue: 0);

    for (var badge in badges) {
      if (streak >= badge['requiredStreak'] && !streakBox.get(badge['name'], defaultValue: false)) {
        streakBox.put(badge['name'], true);
        notifyListeners();
      }
    }
  }

  List<Map<String, dynamic>> get unlockedBadges =>
      badges.where((b) => streakBox.get(b['name'], defaultValue: false)).toList();

  List<Map<String, dynamic>> get lockedBadges =>
      badges.where((b) => !streakBox.get(b['name'], defaultValue: false)).toList();
}
