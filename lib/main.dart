import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gsoc_smart_health_reminder/game/game_provider.dart';
import 'package:gsoc_smart_health_reminder/pet/pet_provider.dart.dart';
import 'package:gsoc_smart_health_reminder/providers/auth_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/badge_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/daily_streak_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/friend_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/heart_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/meditation_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/mood_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/music_player_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/music_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/task_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/step_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/wallet_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/water_reminder_provider.dart';
import 'package:gsoc_smart_health_reminder/screens/Login.dart';
import 'package:gsoc_smart_health_reminder/screens/bottomnav.dart';
import 'package:gsoc_smart_health_reminder/services/notification_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('authBox');
  await Hive.openBox('waterBox');
  await Hive .openBox('stepBox');
  await Hive.openBox('meditationBox');
  await Hive.openBox('moodBox');
  await Hive.openBox('dailyStreakBox');
  await Hive.openBox('heartRateBox');
  await Hive.openBox('coinBox');
  await Hive.openBox('purchasedSoundsBox');
  await Hive.openBox('taskBox');
  await Hive.openBox('gameBox');
  await Hive.openBox('userBox');
  await Hive.openBox('progressBox');

   NotificationService().initNotifications();
   //await NotificationService().scheduleDailyNotifications();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AndroidAlarmManager.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => StepProvider()),
        ChangeNotifierProvider(create: (context) => MeditationProvider()),
        ChangeNotifierProvider(create: (context) => WaterReminderProvider()),
        ChangeNotifierProvider(create: (context) => DailyStreakProvider()),
        ChangeNotifierProvider(create: (context) => MoodProvider()),
        ChangeNotifierProvider(create: (context) => FriendProvider()),
        ChangeNotifierProvider(create: (context) => HeartRateProvider()),
        ChangeNotifierProvider(create: (context) => WalletProvider()),
        ChangeNotifierProvider(create: (context) => MeditationSoundProvider()),
        ChangeNotifierProvider(create: (context) => MusicPlayerProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => GameProvider()),
        ChangeNotifierProvider(create: (context) => BadgeProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        //ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Poppins"
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.currentUser != null ? BottomNav() :Login();
        },
      ),
      //home: BottomNav(),
    );
  }
}
