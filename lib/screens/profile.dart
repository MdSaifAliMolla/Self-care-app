import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/componenets/heatmap.dart';
import 'package:gsoc_smart_health_reminder/componenets/mood_calender.dart';
import 'package:gsoc_smart_health_reminder/componenets/unlocked_badge.dart';
import 'package:gsoc_smart_health_reminder/providers/auth_provider.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Box authBox = Hive.box('authBox'); 
  final List<String> avatarList = [
    'https://i.pravatar.cc/150?img=1',
    'https://i.pravatar.cc/150?img=2',
    'https://i.pravatar.cc/150?img=3',
    'https://i.pravatar.cc/150?img=4',
    'https://i.pravatar.cc/150?img=5',
    'https://i.pravatar.cc/150?img=6',
  ];

  void _pickAvatar() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Pick an Avatar"),
        content: SizedBox(
          width: double.maxFinite, // Ensure it takes full width
          height: 250, // Set a fixed height to avoid layout issues
          child: GridView.builder(
            shrinkWrap: true, // Ensures GridView doesn’t take infinite space
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: avatarList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  authBox.put('avatar', avatarList[index]); 
                  setState(() {});
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(avatarList[index]),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    String? savedAvatar = authBox.get('avatar');
    String userAvatar = savedAvatar ?? (user?.photoURL ?? 'https://via.placeholder.com/150');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: Text("Profile",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),)),
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickAvatar, 
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userAvatar),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(user?.displayName ?? 'Anonymous'),
                ],
              ),
              UnlockedBadgesGrid(),
              MoodCalendar(),
              ProgressHeatmap(),
              ElevatedButton(
                onPressed: () {
                  auth.signOut();
                },
                child: Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
