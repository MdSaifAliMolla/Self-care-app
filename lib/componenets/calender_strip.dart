import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/providers/daily_streak_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarStrip extends StatefulWidget {
  const CalendarStrip({Key? key}) : super(key: key);

  @override
  _CalendarStripState createState() => _CalendarStripState();
}

class _CalendarStripState extends State<CalendarStrip> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    _focusedDay = today;
    int daysFromMonday = today.weekday - DateTime.monday;
    _firstDay = today.subtract(Duration(days: daysFromMonday));
    _lastDay = _firstDay.add(const Duration(days: 6));
  }

  @override
  Widget build(BuildContext context) {
    final dailyStreakProvider = Provider.of<DailyStreakProvider>(context);
    final List<String> streakDaysStr = dailyStreakProvider.streakDays;
    final Set<DateTime> streakDates = streakDaysStr.map((dateStr) {
      final dt = DateTime.parse(dateStr);
      return DateTime(dt.year, dt.month, dt.day);
    }).toSet();

    return TableCalendar(
      firstDay: _firstDay,
      lastDay: _lastDay,
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.week,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerVisible: false,
      daysOfWeekVisible: true,
      rowHeight: 50,
      daysOfWeekStyle:  DaysOfWeekStyle(
        weekdayStyle: const TextStyle(fontSize: 11,fontWeight: FontWeight.bold,color: Colors.grey),
        weekendStyle:  const TextStyle(fontSize: 11,fontWeight: FontWeight.bold,color: Colors.grey),
      ),
      daysOfWeekHeight: 20,
      availableCalendarFormats: const {CalendarFormat.week: 'Week'},
      calendarBuilders: CalendarBuilders(
        todayBuilder: (context, day, focusedDay) {
          bool isToday = isSameDay(day, _focusedDay);
          bool isStreaked = streakDates.contains(DateTime(day.year, day.month, day.day));
    
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5 ,horizontal: 1),
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                decoration: BoxDecoration(
                  color: isStreaked?null: Color.fromARGB(197, 205, 189, 248) ,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16), bottom: Radius.circular(16)),
                ),
                child: Text(
                  DateFormat.d().format(day),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isToday ?  Colors.black:Colors.grey,
                  ),
                ),
              ),
              if (isStreaked)
                Positioned(
                  child: Icon(Icons.star, color: Colors.amberAccent, size: 40),
                ),
            ],
          );
        }, 
        defaultBuilder: (context, day, focusedDay) {
          bool isToday = isSameDay(day, _focusedDay);
          bool isStreaked = streakDates.contains(DateTime(day.year, day.month, day.day));
    
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5 ,horizontal: 1),
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                decoration: BoxDecoration(
                  color: isStreaked ? const Color.fromARGB(255, 255, 248, 190):Colors.transparent,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16), bottom: Radius.circular(16)),
                ),
                child: Text(
                  DateFormat.d().format(day),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isToday ? Colors.black:Colors.grey,
                  ),
                ),
              ),
              if (isStreaked)
                Positioned(
                  child: Icon(Icons.electric_bolt_rounded, color: Colors.yellow[700], size: 40),
                ),
            ],
          );
        },
      ),
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
    );
  }
}
