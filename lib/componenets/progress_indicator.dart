import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/providers/daily_streak_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/task_provider.dart';
import 'package:gsoc_smart_health_reminder/utils/style.dart';
import 'package:provider/provider.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Consumer2<DailyStreakProvider, TaskProvider>(
        builder: (context, streakprov,tp, child) {
          return Container(
            height: 100,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              //border: Border.all(width: 7, color: Colors.grey[200] ?? Colors.grey),
              color: Colors.grey[200],
            ),
            child: Row(
              children: [
                Icon(Icons.electric_bolt_rounded, color: style.a, size: 50,),
                const SizedBox(width: 16), 
                Expanded( 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Daily Adventure",
                        style: TextStyle(
                          color: style.a,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(20),
                        minHeight: 20,
                        value: streakprov.getProgress(),
                        color: style.a,
                        backgroundColor: Colors.white,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          );
        },
      );
  }
}