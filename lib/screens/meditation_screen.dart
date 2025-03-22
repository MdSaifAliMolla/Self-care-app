import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/providers/meditation_provider.dart';
import 'package:provider/provider.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final List<String> moods = ["Stressed", "Anxious", "Calm", "Happy"];
  String? selectedMood;

  void _showEditGoalDialog(BuildContext context, MeditationProvider provider) {
    final TextEditingController controller =
        TextEditingController(text: provider.meditationGoal.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Meditation Goal (minutes)"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Goal in minutes"),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Cancel")),
            TextButton(
              onPressed: () {
                int? newGoal = int.tryParse(controller.text);
                if (newGoal != null) {
                  provider.setMeditationGoal(newGoal);
                }
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showMoodSelectionDialog(BuildContext context, MeditationProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Your Mood"),
          content: DropdownButton<String>(
            value: selectedMood,
            hint: Text("Choose mood"),
            items: moods.map((mood) {
              return DropdownMenuItem<String>(
                value: mood,
                child: Text(mood),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedMood = value;
              });
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Cancel")),
            TextButton(
              onPressed: () {
                if (selectedMood != null) {
                  provider.setMood(selectedMood!);
                  if(selectedMood == "Calm"){
                    provider.setMeditationGoal(15);
                  }else if(selectedMood == "Happy"){
                    provider.setMeditationGoal(10);
                  }else if(selectedMood == "Anxious"){
                    provider.setMeditationGoal(25);
                  }else if(selectedMood == "Stressed"){
                    provider.setMeditationGoal(30);
                  }
                }
                Navigator.of(context).pop();
              },
              child: Text("Set Mood"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeditationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Container(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Meditation Tracker",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text("Mood: ${provider.mood.isEmpty ? 'Not set' : provider.mood}"),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _showMoodSelectionDialog(context, provider),
                    child: Text("Set Mood"),
                  ),
                  SizedBox(height: 8),
                  Text("Goal: ${provider.meditationGoal} minutes"),
                  SizedBox(height: 8),
                  // Circular timer widget
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: provider.progress > 1 ? 1 : provider.progress,
                          strokeWidth: 8,
                        ),
                      ),
                      Text(
                        provider.formattedTime,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: provider.isTimerRunning ? null : provider.startTimer,
                        child: Text("Start"),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: provider.isTimerRunning ? provider.pauseTimer : null,
                        child: Text("Pause"),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _showEditGoalDialog(context, provider),
                    child: Text("Edit Goal"),
                  ),
                  SizedBox(height: 8),
                  Text("Streak: ${provider.streak} days"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}