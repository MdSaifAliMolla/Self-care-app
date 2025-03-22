import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/providers/step_provider.dart';
import 'package:provider/provider.dart';

class StepCountCard extends StatelessWidget {
  const StepCountCard({Key? key}) : super(key: key);

  void _showEditGoalDialog(BuildContext context, StepProvider provider) {
    final TextEditingController controller =
        TextEditingController(text: provider.stepGoal.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Step Goal"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Step Goal"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                int newGoal = int.tryParse(controller.text) ?? provider.stepGoal;
                provider.setDailyStepGoal(newGoal);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StepProvider>(
      builder: (context, provider, child) {
        double progress = provider.stepGoal > 0
            ? provider.currentSteps / provider.stepGoal
            : 0;
        if (progress > 1) progress = 1;
        return Container(
          //margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.amber.shade400,
              Colors.amber.shade300,
              Colors.amber.shade200,
            ],
          ),
          image: DecorationImage(image: AssetImage("assets/animation/walk.gif")),
          ),
          height:90,
          width: MediaQuery.of(context).size.width/2.2,
          child: Column(
            children: [
              Text("streak: ${provider.streak} days"),
              Row(
                children: [
                  Text("${provider.currentSteps}/${provider.stepGoal} steps"),
                  IconButton(
                    onPressed: () => _showEditGoalDialog(context, provider),
                    icon: Icon(Icons.edit),
                  ),
                ],
              ),
              
            ],
          ),
        );
      },
    );
  }
}
