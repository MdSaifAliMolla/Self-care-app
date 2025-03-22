import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:gsoc_smart_health_reminder/providers/daily_streak_provider.dart';
import 'package:provider/provider.dart';

class ProgressHeatmap extends StatelessWidget {
  const ProgressHeatmap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DailyStreakProvider>(
      builder: (context, provider, child) {
        if (!provider.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        final progressData = provider.progressData;
        
        Map<DateTime, int> heatmapData = {};
        
        progressData.forEach((dateStr, progress) {
          try {
            final date = DateTime.parse(dateStr);
            final intensity = (progress * 5).round();
            heatmapData[date] = intensity;
          } catch (e) {
            debugPrint('Invalid date format: $dateStr');
          }
        });

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Heatmap',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 16),
              HeatMap(
                datasets: {
                    DateTime(2025, 3, 6): 3,
                    DateTime(2025, 3, 7): 7,
                    DateTime(2025, 3, 8): 10,
                    DateTime(2025, 3, 9): 13,
                    DateTime(2025, 3, 13): 6,
                  },
                fontSize: 11,
                colorMode: ColorMode.opacity,
                defaultColor: Colors.white54,
                showColorTip: true,
                showText: false,
                scrollable: true,
                colorsets: const {
                  1: Colors.green,
                },
                size: 30,
                startDate: DateTime.now().subtract(const Duration(days: 70)),
                
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}