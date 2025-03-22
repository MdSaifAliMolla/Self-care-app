import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/providers/meditation_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/mood_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MoodCalendar extends StatefulWidget {
  const MoodCalendar({Key? key}) : super(key: key);

  @override
  _MoodCalendarState createState() => _MoodCalendarState();
}

class _MoodCalendarState extends State<MoodCalendar> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _firstDay = DateTime.utc(2023,1,1);
    _lastDay = DateTime(_focusedDay.year, _focusedDay.month + 2, 0);
  }

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);

    return TableCalendar(
      firstDay: _firstDay,
      lastDay: _lastDay,
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.month,
      daysOfWeekHeight: 20, 
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: const TextStyle(fontSize: 11),
        weekendStyle: TextStyle(fontSize: 11),
      ),
      rowHeight: 40,
      headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
        ),
        headerVisible: true,
        calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final mood = moodProvider.getMoodForDate(day);
          return GestureDetector(
            onTap: () { _showMoodDialog(context, day);
            },
            child: Stack(
              alignment: Alignment.center,
              children:[ Text(day.day.toString(),
                      style: const TextStyle(fontSize: 11, color: Color.fromARGB(255, 115, 115, 115))),
                  if (mood != null) ...[
                    Stack(
                      alignment: Alignment.center,
                      children: [ 
                        Text(mood, style: const TextStyle(fontSize: 21, color: Colors.white)),
                      ],
                    )]
              ],
            ), 
          );
        },
        todayBuilder: (context, day, focusedDay) {
          final mood = moodProvider.getMoodForDate(day);
          return GestureDetector(
            onTap: (){ _showMoodDialog(context, day);},
            child: Stack(
              alignment: Alignment.center,
              children:[ Text(day.day.toString(),
                      style: const TextStyle(fontSize: 11, color: Colors.black)),
                  if (mood != null) ...[
                    Stack(
                      children: [
                        Text(mood, style: const TextStyle(fontSize: 21, color: Colors.white)),
                      ],
                    )]
              ],
            ),
          );
        },
       ),
      onDaySelected: (selectedDay, focusedDay) {
        _showMoodDialog(context, selectedDay);
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
    );
  }



  void _showMoodDialog(BuildContext context, DateTime selectedDay) {
    final moodProvider = Provider.of<MoodProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Mood'),
          content: Row(
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMoodOption(context, selectedDay, '😊', moodProvider),
              _buildMoodOption(context, selectedDay, '😢', moodProvider),
              _buildMoodOption(context, selectedDay, '😡', moodProvider),
              _buildMoodOption(context, selectedDay, '😐', moodProvider),
            ],
          ),
          actions: [
            TextButton(onPressed: (){
              moodProvider.removeMoodForDate(selectedDay);
              Navigator.of(context).pop();
            }, child: Text('Clear Mood')),
          ],
        );
      },
    );
  }

  Widget _buildMoodOption(
      BuildContext context, DateTime selectedDay, String emoji, MoodProvider moodProvider) {
    return IconButton(
      icon: Text(emoji, style: const TextStyle(fontSize: 30)),
      onPressed: () {
        moodProvider.setMoodForDate(context,selectedDay, emoji);
        Navigator.of(context).pop();
      },
    );
  }
}
    
    