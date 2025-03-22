import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/componenets/addTask.dart';
import 'package:gsoc_smart_health_reminder/componenets/calender_strip.dart';
import 'package:gsoc_smart_health_reminder/componenets/heart_card.dart';
import 'package:gsoc_smart_health_reminder/componenets/meditation_card.dart';
import 'package:gsoc_smart_health_reminder/screens/meditation_screen.dart';
import 'package:gsoc_smart_health_reminder/componenets/progress_indicator.dart';
import 'package:gsoc_smart_health_reminder/componenets/slouch_card.dart';
import 'package:gsoc_smart_health_reminder/componenets/step_count_card.dart';
import 'package:gsoc_smart_health_reminder/componenets/task_list.dart';
import 'package:gsoc_smart_health_reminder/componenets/water_card.dart';
import 'package:gsoc_smart_health_reminder/game/game_screen.dart';
import 'package:gsoc_smart_health_reminder/pet/pet_screen.dart';
import 'package:gsoc_smart_health_reminder/providers/auth_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/daily_streak_provider.dart';
import 'package:gsoc_smart_health_reminder/screens/friend_notification.dart';
import 'package:gsoc_smart_health_reminder/screens/search.dart';
import 'package:gsoc_smart_health_reminder/services/notification_service.dart';
import 'package:gsoc_smart_health_reminder/utils/style.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final ds=Provider.of<DailyStreakProvider>(context);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  Icon(CupertinoIcons.heart_fill,size: 30,color: Colors.red,),
                  Text(' Health+'),
                ],
              ),
            ),
            ListTile(
              leading: Text('🪙 '),
              title: Text(
                  '${Hive.box('coinBox').get('coins', defaultValue: 0)} Coins'),
            ),
            ElevatedButton(
              onPressed: () async {
                NotificationService notificationService = NotificationService();
                await notificationService.showNotification(
                  title: "Test Notification",
                  body: "This is a test notification.",
                );
              },
              child: Text("Send Test Notification"),
            ),
            ListTile(
              title: Text("Notifications"),
              leading: Icon(Icons.notifications),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Ping()),
              ),
            ),
            ListTile(
              title: Text("pet"),
              leading: Icon(Icons.pets),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PetScreen()),
              ),
            ),
            ListTile(
              title: Text("tilegame"),
              leading: Icon(Icons.gamepad),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GameScreen()),
              ),
            ),
    
          ],
        ),
      ),
/////______________________________________________________________________/////

      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(),
          Row(
            children: [
              Icon(CupertinoIcons.flame_fill,size: 30,color: Colors.orange,),
              Text(' ${ds.streak}',style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),),
            ],
          ),
        ]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CalendarStrip(),
              const SizedBox(height: 2,),
              ProgressCard(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      MeditationCard(),
                      const SizedBox(height: 5),
                      StepCountCard()
                    ],
                  ),
                  WaterLevelCard(),
                ],
              ),
              const SizedBox(height: 10),
              TaskList(),
              SlouchDetectorCard(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddTaskDialog(),
        ),
      ),
    );
  }
}
