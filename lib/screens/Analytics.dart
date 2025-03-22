import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/componenets/mood_calender.dart';
import 'package:gsoc_smart_health_reminder/providers/daily_streak_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Analytics extends StatelessWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context) {
    final streakProvider = Provider.of<DailyStreakProvider>(context);
    final List<String> streakDays = streakProvider.streakDays;

    final Set<DateTime> markedDates = streakDays.map((dateStr) {
      return DateTime.parse(dateStr);
    }).toSet();

    return Scaffold(
      appBar: AppBar(
        title: Text("Analytics"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              rowHeight: 40,
              daysOfWeekHeight: 20,
              focusedDay: DateTime.now(),
               headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) => Stack(
              alignment: Alignment.center,
              children: [
                Text(day.day.toString(),
                    style: const TextStyle(fontSize: 13, color: Color.fromARGB(255, 115, 115, 115))),
                if (markedDates.contains(day)) ...[
                  Container(
                    height: 5,
                    width: 5,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                ],
              ],
              ),),),
            MoodCalendar(),
          ],
        ),
      ),
    );
  }
}