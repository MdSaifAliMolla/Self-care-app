import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/providers/badge_provider.dart';
import 'package:provider/provider.dart';

class BadgesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var streakProvider = Provider.of<BadgeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("All Badges")),
      body: ListView.builder(
        itemCount: streakProvider.badges.length,
        itemBuilder: (context, index) {
          var badge = streakProvider.badges[index];
          bool isUnlocked = streakProvider.unlockedBadges.contains(badge);

          return ListTile(
            leading: Image.asset(badge['imagePath'], width: 50, height: 50),
            title: Text(badge['name']),
            subtitle: Text("Required Streak: ${badge['requiredStreak']} days"),
            trailing: isUnlocked
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.lock, color: Colors.grey),
          );
        },
      ),
    );
  }
}
