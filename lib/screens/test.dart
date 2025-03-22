import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class SensorTestScreen extends StatefulWidget {
  @override
  _SensorTestScreenState createState() => _SensorTestScreenState();
}

class _SensorTestScreenState extends State<SensorTestScreen> {
  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;
  List<double> _accelerometerValues = [0, 0, 0];
  List<double> _gyroscopeValues = [0, 0, 0];
  bool _isSensorSupported = true;
  String _sensorStatus = 'Checking Sensors...';

  @override
  void initState() {
    super.initState();
    _checkAndRequestSensorPermissions();
    _initializeSensorListeners();
  }

  Future<void> _checkAndRequestSensorPermissions() async {

    var status = await Permission.activityRecognition.status;
    if (!status.isGranted) {
      status = await Permission.activityRecognition.request();
    }

    if (!status.isGranted) {
      setState(() {
        _sensorStatus = 'Sensor Permissions Denied';
      });
    }
  }

  void _initializeSensorListeners() {
    try {
      // Accelerometer listener
      accelerometerEventStream().throttleTime(Duration(milliseconds:500)).listen((AccelerometerEvent event) {
        setState(() {
          _accelerometerEvent = event;
          _accelerometerValues = [event.x, event.y, event.z];
        });
      }).onError((error) {
        setState(() {
          _isSensorSupported = false;
          _sensorStatus = 'Accelerometer Not Supported: $error';
        });
      });

      // Gyroscope listener
      gyroscopeEventStream().throttleTime(Duration(milliseconds:500)).listen((GyroscopeEvent event) {
        setState(() {
          _gyroscopeEvent = event;
          _gyroscopeValues = [event.x, event.y, event.z];
        });
      }).onError((error) {
        setState(() {
          _isSensorSupported = false;
          _sensorStatus = 'Gyroscope Not Supported: $error';
        });
      });
    } catch (e) {
      setState(() {
        _isSensorSupported = false;
        _sensorStatus = 'Sensor Initialization Failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Diagnostic Tool'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sensor Status Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sensor Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _sensorStatus,
                      style: TextStyle(
                        color: _isSensorSupported ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Accelerometer Data Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Accelerometer Data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('X: ${_accelerometerValues[0].toStringAsFixed(2)}'),
                    Text('Y: ${_accelerometerValues[1].toStringAsFixed(2)}'),
                    Text('Z: ${_accelerometerValues[2].toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Gyroscope Data Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gyroscope Data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('X: ${_gyroscopeValues[0].toStringAsFixed(2)}'),
                    Text('Y: ${_gyroscopeValues[1].toStringAsFixed(2)}'),
                    Text('Z: ${_gyroscopeValues[2].toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}