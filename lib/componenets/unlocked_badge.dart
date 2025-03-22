import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/providers/badge_provider.dart';
import 'package:gsoc_smart_health_reminder/screens/badges.dart';
import 'package:provider/provider.dart';


class UnlockedBadgesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var streakProvider = Provider.of<BadgeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Unlocked Badges",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        streakProvider.unlockedBadges.isEmpty
            ? Text("No badges unlocked yet.", style: TextStyle(color: Colors.grey))
            : GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, 
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: streakProvider.unlockedBadges.length,
                itemBuilder: (context, index) {
                  var badge = streakProvider.unlockedBadges[index];
                  return Column(
                    children: [
                      Image.asset(badge['imagePath'], width: 90, height: 90),
                      Text(badge['name'], textAlign: TextAlign.center),
                    ],
                  );
                },
              ),
        SizedBox(height: 5),
        Center(
          child: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BadgesPage()),
            ),
            child: Text("View All Badges ->"),
          ),
        ),
      ],
    );
  }
}
