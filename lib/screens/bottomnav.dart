import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/providers/slouch_provider.dart';
import 'package:gsoc_smart_health_reminder/screens/Analytics.dart';
import 'package:gsoc_smart_health_reminder/screens/Home.dart';
import 'package:gsoc_smart_health_reminder/screens/LeaderBoard.dart';
import 'package:gsoc_smart_health_reminder/screens/music_store.dart';
import 'package:gsoc_smart_health_reminder/screens/profile.dart';
import 'package:gsoc_smart_health_reminder/utils/style.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Home(),
      Leaderboard(),
      MeditationSoundStore(),
      Profile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items:  [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,size: 30,color: style.b), 
            label: "Home",),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard,size: 30,color:style.b), 
            label: "LeaderBoard"),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note,size: 30,color: style.b), 
            label: "Store"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,size: 30,color: style.b), 
            label: "Profile"),
        ],
      ),
    );
  }
}