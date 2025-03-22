import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:hive/hive.dart';

class HeartRateProvider extends ChangeNotifier {
  final Box heartRateBox = Hive.box('heartRateBox');
  final  health = Health();
  int _currentHeartRate = 0;
  int get currentHeartRate => _currentHeartRate;

  Timer? _timer;

  HeartRateProvider() {
    _fetchLatestHeartRate();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _fetchLatestHeartRate();
    });
  }

  Future<void> _fetchLatestHeartRate() async {
    // Request authorization for heart rate data.
    bool requested = await health.requestAuthorization([HealthDataType.HEART_RATE]);
    if (requested) {
      DateTime now = DateTime.now();
      DateTime startTime = now.subtract(Duration(hours: 1));
      try {
        List<HealthDataPoint> heartRateData = await health.getHealthDataFromTypes(
          startTime: startTime,
          endTime:now,
          types: [HealthDataType.HEART_RATE],
        );
        if (heartRateData.isNotEmpty) {
          heartRateData.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
          var latest = heartRateData.first;
          int hr = 0;
          if (latest.value is int) {
            hr = latest.value as int;
          } else if (latest.value is double) {
            hr = (latest.value as double).round();
          }
          _currentHeartRate = hr;
        } else {
          // If no data, keep the last value.
          print("No heart rate data found in the last hour.");
        }
      } catch (e) {
        print("Error fetching heart rate data: $e");
      }
      // Save to Hive and notify listeners.
      heartRateBox.put('currentHeartRate', _currentHeartRate);
      notifyListeners();
    } else {
      print("Authorization for heart rate data denied.");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
