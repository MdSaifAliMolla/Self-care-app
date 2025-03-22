import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/providers/heart_provider.dart';
import 'package:provider/provider.dart';

class HeartRateCard extends StatelessWidget {
  const HeartRateCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HeartRateProvider>(
      builder: (context, provider, child) {
        return Card(
          margin: EdgeInsets.all(16),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Heart Rate Monitor",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("Current Heart Rate:", style: TextStyle(fontSize: 16)),
                SizedBox(height: 4),
                Text(
                  "${provider.currentHeartRate} bpm",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  child: Text("Refresh"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
