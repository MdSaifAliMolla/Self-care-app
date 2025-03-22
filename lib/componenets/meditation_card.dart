import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/screens/meditation_screen.dart';

class MeditationCard extends StatelessWidget {
  const MeditationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MeditationScreen())),
      child: Container(
        height: 90,
        width: MediaQuery.of(context).size.width/2.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade500,
              Colors.green.shade400,
              Colors.green.shade300,
            ],
          ),
        ),
        child:Stack(
          children: [
            Positioned(
              left: 0,top: 0,
              child: Image(image: AssetImage('assets/animation/leaf.gif')),
            ),
            Center(
              child: Text('Meditation',style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900
              ),),
            )
          ],
        ),
      ),
    );
  }
}