import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:gsoc_smart_health_reminder/providers/water_reminder_provider.dart';


class WaterLevelCard extends StatefulWidget {

  const WaterLevelCard({super.key});

  @override
  _WaterLevelCardState createState() => _WaterLevelCardState();
}

class _WaterLevelCardState extends State<WaterLevelCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _waterLevelAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showEditGoalDialog(BuildContext context, WaterReminderProvider provider) {
    final TextEditingController controller =
        TextEditingController(text: provider.waterGoal.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Water Goal"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration:
                InputDecoration(labelText: "Water Goal (number of glasses)"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                int newGoal = int.tryParse(controller.text) ?? provider.waterGoal;
                provider.setWaterGoal(newGoal);
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
    final prov=Provider.of<WaterReminderProvider>(context);
    return Container(
      decoration:BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color.fromARGB(255, 212, 235, 254),
        //border: Border.all(color: Colors.blue, width: 4),
      ),
      height: 180,
      width: MediaQuery.of(context).size.width/2.2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(200, 300),
                  painter: WaterPainter(
                    animationValue: _controller.value,
                    waterLevel: prov.currentIntake / 10,
                  ),
                );
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("streak: "+prov.streak.toString()),
                Text("${prov.currentIntake} / ${prov.waterGoal} glasses"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed:  () => _showEditGoalDialog(context, prov),
                   icon: Icon( Icons.edit,size: 20,color: const Color.fromARGB(255, 107, 105, 105),),),
                    IconButton(
                      onPressed: () =>
                          Provider.of<WaterReminderProvider>(context, listen: false)
                              .decreaseIntake(),
                      icon: const Icon(Icons.remove),
                    ),
                    IconButton(
                      onPressed: () =>
                          Provider.of<WaterReminderProvider>(context, listen: false)
                              .increaseIntake(),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WaterPainter extends CustomPainter {
  final double animationValue;
  final double waterLevel;

  WaterPainter({required this.animationValue, required this.waterLevel});

  @override
  void paint(Canvas canvas, Size size) {
    Paint waterPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.blue.shade200,
          Colors.blue.shade400,
          Colors.blue.shade600,
        ],
      ).createShader(Rect.fromLTWH(0, size.height * (1 - waterLevel), size.width, size.height));

    Path wavePath = Path();
    double waveHeight = 8;
    double baseHeight = size.height * (1 - waterLevel);

    for (double i = 0; i <= size.width; i += 1) {
      double y = baseHeight +
          math.sin((i / size.width * 2 * math.pi) + (animationValue * 2 * math.pi)) * waveHeight;
      if (i == 0) {
        wavePath.moveTo(i, y);
      } else {
        wavePath.lineTo(i, y);
      }
    }

    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    canvas.drawPath(wavePath, waterPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}