import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:hive/hive.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    //TODO : IOS setting

    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    tz.initializeTimeZones(); 
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'channel_description',
        importance: Importance.max,
      ),
      //ToDo : IOS
    );
  }

  Future<void> scheduleDailyNotifications() async {
    await _scheduleNotification(12, 0); // 12:00 PM
    await _scheduleNotification(18, 0); // 6:00 PM
  }

  Future<void> _scheduleNotification(int hour, int minute) async {
    final Box waterBox = Hive.box('waterBox');
    final Box stepsBox = Hive.box('stepBox');
    final Box meditationBox = Hive.box('meditationBox');

    int remainingWater = (waterBox.get('goal', defaultValue: 2000) -
            waterBox.get('currentIntake', defaultValue: 0))
        .clamp(0, 2000);

    int remainingSteps = (stepsBox.get('goal', defaultValue: 10000) -
            stepsBox.get('currentSteps', defaultValue: 0))
        .clamp(0, 10000);

    int meditationGoal = meditationBox.get('meditationGoal', defaultValue: 10);
    int currentMeditation =
        meditationBox.get('currentMeditationTime', defaultValue: 0);
    int remainingMeditation = (meditationGoal * 60 - currentMeditation)
        .clamp(0, meditationGoal * 60);

    String message =
        "Drink ${remainingWater}ml water 💧\nWalk ${remainingSteps} steps 🚶\nMeditate ${remainingMeditation ~/ 60} min 🧘";

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      hour * 100 + minute, // Unique ID
      "Daily Health Reminder",
      message,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily Reminder',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTime =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    return scheduledTime;
  }

  Future<void>showNotification({
    int id=0,
    String? title,
    String? body
  })async{
      return _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        _notificationDetails(),
      );
  }
}
