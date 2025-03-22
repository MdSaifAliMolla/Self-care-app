import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

// Slouch Detection Provider
class SensorProvider with ChangeNotifier {
  AccelerometerEvent? _accelerometerEvent;
  bool _isSlouching = false;
  DateTime _lastUpdate = DateTime.now();

  final double _slouchThreshold = 0.5; 
  final Duration _slouchDuration = Duration(seconds: 5);
  DateTime? _slouchStartTime;

  AccelerometerEvent? get accelerometerEvent => _accelerometerEvent;
  bool get isSlouching => _isSlouching;

  void initSensorListening() {
      accelerometerEventStream().listen((event) {
      final now = DateTime.now();
      if (now.difference(_lastUpdate) >= Duration(milliseconds: 2000)) {
        _lastUpdate = now;
        _accelerometerEvent = event;
        _detectSlouching(event);
        notifyListeners();
      }
    });
}

  void _detectSlouching(AccelerometerEvent event) {
     if (event.y < 18.0) {
        if (!_isSlouching) {
          _isSlouching = true;
          notifyListeners();

        }
     }
    // Calculate angle in degrees using y and z axis.
    // double angle = math.atan2(event.y, event.z) * (180 / math.pi);

    // if (angle.abs() > 1) {
    //   if (_slouchStartTime == null) {
    //     _slouchStartTime = DateTime.now();
    //   }
    //   // If slouch condition persists for defined duration, mark as slouching.
    //   if (DateTime.now().difference(_slouchStartTime!) >= _slouchDuration) {
    //     if (!_isSlouching) {
    //       _isSlouching = true;
    //       notifyListeners();
    //     }
    //   }
    // } else {
    //   _slouchStartTime = null;
    //   if (_isSlouching) {
    //     _isSlouching = false;
    //     notifyListeners();
    //   }
    // }
  }
}
