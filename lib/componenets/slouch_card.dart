import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SlouchDetectorCard extends StatefulWidget {
  const SlouchDetectorCard({Key? key}) : super(key: key);
  
  @override
  _SlouchDetectorCardState createState() => _SlouchDetectorCardState();
}

class _SlouchDetectorCardState extends State<SlouchDetectorCard> {
  // Built-in constants
  static const double _slouchThreshold = 6.0;
  static const double _neckTiltThreshold = 0.2; // Radians
  static const Duration _slouchDuration = Duration(seconds: 5);
  static const Duration _calibrationDuration = Duration(seconds: 5);
  static const int _smoothingWindowSize = 5;
  
  // Accelerometer data
  AccelerometerEvent? _accelerometerEvent;
  List<double> _yValueHistory = [];
  double _calibratedUpright = 9.8; // Default value (approximately gravity)
  
  // Gyroscope data
  GyroscopeEvent? _gyroscopeEvent;
  List<double> _xTiltHistory = []; // Forward/backward tilt
  List<double> _zTiltHistory = []; // Side-to-side tilt
  double _calibratedXTilt = 0.0;
  double _calibratedZTilt = 0.0;
  
  // Slouch detection
  bool _isSlouching = false;
  String _slouchSeverity = 'None';
  String _slouchType = 'None';
  DateTime _lastUpdate = DateTime.now();
  DateTime? _slouchStartTime;
  
  // Calibration variables
  bool _isCalibrating = false;
  bool _isCalibrated = false;
  List<double> _calibrationAccelValues = [];
  List<double> _calibrationGyroXValues = [];
  List<double> _calibrationGyroZValues = [];
  Timer? _calibrationTimer;
  
  // Subscriptions
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize accelerometer stream
    _accelSubscription = accelerometerEventStream().listen((event) {
      final now = DateTime.now();
      if (now.difference(_lastUpdate) >= Duration(milliseconds: 200)) {
        _lastUpdate = now;
        setState(() {
          _accelerometerEvent = event;
          _updateYValueHistory(event.y);
          if (_isCalibrating) {
            _collectCalibrationData();
          } else if (_isCalibrated && _gyroscopeEvent != null) {
            _detectSlouching();
          }
        });
      }
    });
    
    // Initialize gyroscope stream
    _gyroSubscription = gyroscopeEventStream().listen((event) {
      setState(() {
        _gyroscopeEvent = event;
        _updateTiltHistory(event.x, event.z);
        if (_isCalibrating) {
          _collectCalibrationData();
        }
      });
    });
    
    // Automatically start calibration on init
   // _startCalibration();
  }
  
  void _updateYValueHistory(double value) {
    _yValueHistory.add(value);
    if (_yValueHistory.length > _smoothingWindowSize) {
      _yValueHistory.removeAt(0);
    }
  }
  
  void _updateTiltHistory(double xTilt, double zTilt) {
    _xTiltHistory.add(xTilt);
    _zTiltHistory.add(zTilt);
    
    if (_xTiltHistory.length > _smoothingWindowSize) {
      _xTiltHistory.removeAt(0);
    }
    
    if (_zTiltHistory.length > _smoothingWindowSize) {
      _zTiltHistory.removeAt(0);
    }
  }
  
  double get _smoothedYValue {
    if (_yValueHistory.isEmpty) return 0;
    return _yValueHistory.reduce((a, b) => a + b) / _yValueHistory.length;
  }
  
  double get _smoothedXTilt {
    if (_xTiltHistory.isEmpty) return 0;
    return _xTiltHistory.reduce((a, b) => a + b) / _xTiltHistory.length;
  }
  
  double get _smoothedZTilt {
    if (_zTiltHistory.isEmpty) return 0;
    return _zTiltHistory.reduce((a, b) => a + b) / _zTiltHistory.length;
  }
  
  void _startCalibration() {
    setState(() {
      _isCalibrating = true;
      _isCalibrated = false;
      _calibrationAccelValues = [];
      _calibrationGyroXValues = [];
      _calibrationGyroZValues = [];
      _yValueHistory = [];
      _xTiltHistory = [];
      _zTiltHistory = [];
    });
    
    _calibrationTimer = Timer(_calibrationDuration, () {
      _finishCalibration();
    });
  }
  
  void _collectCalibrationData() {
    if (_accelerometerEvent != null) {
      _calibrationAccelValues.add(_accelerometerEvent!.y);
    }
    
    if (_gyroscopeEvent != null) {
      _calibrationGyroXValues.add(_gyroscopeEvent!.x);
      _calibrationGyroZValues.add(_gyroscopeEvent!.z);
    }
  }
  
  void _finishCalibration() {
    // Calculate calibrated accelerometer values
    if (_calibrationAccelValues.isNotEmpty) {
      _calibratedUpright = _calibrationAccelValues.reduce((a, b) => a + b) / _calibrationAccelValues.length;
    } else {
      _calibratedUpright = 9.8; // Default
    }
    
    // Calculate calibrated gyroscope values
    if (_calibrationGyroXValues.isNotEmpty) {
      _calibratedXTilt = _calibrationGyroXValues.reduce((a, b) => a + b) / _calibrationGyroXValues.length;
    }
    
    if (_calibrationGyroZValues.isNotEmpty) {
      _calibratedZTilt = _calibrationGyroZValues.reduce((a, b) => a + b) / _calibrationGyroZValues.length;
    }
    
    setState(() {
      _isCalibrating = false;
      _isCalibrated = true;
    });
  }
  
  void _detectSlouching() {
    if (_accelerometerEvent == null || _gyroscopeEvent == null) return;
    
    // Check for back slouching using accelerometer
    final yDeviation = _calibratedUpright - _smoothedYValue;
    
    // Check for neck tilting using gyroscope
    final xTiltDeviation = (_smoothedXTilt - _calibratedXTilt).abs();
    final zTiltDeviation = (_smoothedZTilt - _calibratedZTilt).abs();
    
    // Define slouch severity thresholds
    final minorThreshold = _slouchThreshold * 0.2;
    final moderateThreshold = _slouchThreshold;
    final severeThreshold = _slouchThreshold * 1;
    
    // Determine type of posture issue
    String prevSlouchType = _slouchType;
    
    if (yDeviation >= minorThreshold) {
      _slouchType = 'Back Slouching';
    } else if (xTiltDeviation >= _neckTiltThreshold) {
      _slouchType = 'Forward Head';
    } else if (zTiltDeviation >= _neckTiltThreshold) {
      _slouchType = 'Side Tilt';
    } else {
      _slouchType = 'None';
    }
    
    // Determine slouch severity based on the most problematic posture issue
    if (yDeviation >= severeThreshold || 
        xTiltDeviation >= _neckTiltThreshold * 1.5 || 
        zTiltDeviation >= _neckTiltThreshold * 1.5) {
      _slouchSeverity = 'Severe';
    } else if (yDeviation >= moderateThreshold || 
               xTiltDeviation >= _neckTiltThreshold * 1.25 || 
               zTiltDeviation >= _neckTiltThreshold * 1.25) {
      _slouchSeverity = 'Moderate';
    } else if (yDeviation >= minorThreshold || 
               xTiltDeviation >= _neckTiltThreshold || 
               zTiltDeviation >= _neckTiltThreshold) {
      _slouchSeverity = 'Mild';
    } else {
      _slouchSeverity = 'None';
    }
    
    if (_slouchType != 'None') {
      if (_slouchStartTime == null || prevSlouchType != _slouchType) {
        _slouchStartTime = DateTime.now();
      }
      
      if (DateTime.now().difference(_slouchStartTime!) >= _slouchDuration) {
        _isSlouching = true;
      }
    } else {
      _slouchStartTime = null;
      _isSlouching = false;
    }
  }
  
  void _recalibrate() {
    _startCalibration();
  }
  
  @override
  void dispose() {
    _accelSubscription?.cancel();
    _gyroSubscription?.cancel();
    _calibrationTimer?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isCalibrating)
              _buildCalibrationUI()
            else
              _buildSlouchDetectionUI(),

            const SizedBox(height: 16),
            
            if (!_isCalibrating)
              ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(1),
                ),
                onPressed: _recalibrate,
                child: const Text('Recalibrate'),
              ),
            
            const SizedBox(height: 16),
            
            _buildSensorDataDisplay(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSensorDataDisplay() {
    return ExpansionTile(
      title: const Text('Sensor Data'),
      children:[ 
        Text(
        'Accelerometer Data:\n'
        'X: ${_accelerometerEvent!.x.toStringAsFixed(2)}\n'
        'Y: ${_accelerometerEvent!.y.toStringAsFixed(2)} (Smoothed: ${_smoothedYValue.toStringAsFixed(2)})\n'
        'Z: ${_accelerometerEvent!.z.toStringAsFixed(2)}\n'
        'Y Deviation: ${(_calibratedUpright - _smoothedYValue).toStringAsFixed(2)}\n\n'
        'Gyroscope Data:\n'
        'X: ${_gyroscopeEvent!.x.toStringAsFixed(2)} (Smoothed: ${_smoothedXTilt.toStringAsFixed(2)})\n'
        'Y: ${_gyroscopeEvent!.y.toStringAsFixed(2)}\n'
        'Z: ${_gyroscopeEvent!.z.toStringAsFixed(2)} (Smoothed: ${_smoothedZTilt.toStringAsFixed(2)})\n'
        'X Tilt Deviation: ${(_smoothedXTilt - _calibratedXTilt).abs().toStringAsFixed(2)}\n'
        'Z Tilt Deviation: ${(_smoothedZTilt - _calibratedZTilt).abs().toStringAsFixed(2)}',
        style: TextStyle(color: Colors.grey[700], fontSize: 12),
      ),
      const SizedBox(height: 10),]
    );
  }
  
  Widget _buildCalibrationUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.timelapse,
          color: Colors.blue,
          size: 48,
        ),
        const SizedBox(height: 10),
        const Text(
          'Calibrating...',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Please sit upright with proper posture\nKeep your head level and look straight ahead',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: _calibrationAccelValues.length / 
            (_calibrationDuration.inMilliseconds / 100),
        ),
      ],
    );
  }
  
  Widget _buildSlouchDetectionUI() {
    Color statusColor;
    IconData statusIcon;
    
    switch (_slouchSeverity) {
      case 'Severe':
        statusColor = Colors.red;
        statusIcon = Icons.warning_amber_rounded;
        break;
      case 'Moderate':
        statusColor = Colors.orange;
        statusIcon = Icons.warning_amber_rounded;
        break;
      case 'Mild':
        statusColor = Colors.yellow.shade700;
        statusIcon = Icons.info_outline;
        break;
      case 'None':
      default:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              statusIcon,
              color: statusColor,
              size: 32,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isSlouching ? 'Poor Posture Detected' : 'Posture Looks Good',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  if (_isSlouching)
                    Text(
                      '$_slouchSeverity $_slouchType',
                      style: TextStyle(
                        color: statusColor,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // if (_isSlouching)
        //   Text(
        //     _getPostureTip(),
        //     style: const TextStyle(
        //       fontStyle: FontStyle.italic,
        //     ),
        //   ),
      ],
    );
  }
  
  String _getPostureTip() {
    Map<String, List<String>> tipsByType = {
      'Back Slouching': [
        'Roll your shoulders back and down.',
        'Keep your lower back supported against your chair.',
        'Engage your core muscles to support your spine.',
        'Adjust your chair height so your feet are flat on the floor.',
      ],
      'Forward Head': [
        'Tuck your chin slightly to align your head with your shoulders.',
        'Position your screen at eye level to avoid looking down.',
        'Do gentle neck stretches: tilt your head back, looking at the ceiling.',
        'Try the "wall test": stand with your back against a wall and touch the wall with the back of your head.',
      ],
      'Side Tilt': [
        'Center your head over your shoulders.',
        'Position your screen directly in front of you, not to the side.',
        'Try shoulder rolls to relax neck muscles.',
        'Check if you are leaning on one armrest or crossing your legs often.',
      ]
    };
    
    List<String> relevantTips = tipsByType[_slouchType] ?? [
      'Align your head with your shoulders and spine.',
      'Pull your shoulders back and down.',
      'Take a short break and stretch regularly.',
      'Position your screen at eye level.',
    ];
    
    // Return a random tip from the relevant category
    return relevantTips[DateTime.now().second % relevantTips.length];
  }
}