import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/providers/task_provider.dart';
import 'package:provider/provider.dart';

class AddTaskDialog extends StatefulWidget {
  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _taskController = TextEditingController();
  TimeOfDay? _selectedTime;
  bool _setAlarm = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New Task"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _taskController,
            decoration: InputDecoration(labelText: "Task Name"),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: _setAlarm,
                onChanged: (value) {
                  setState(() {
                    _setAlarm = value ?? false;
                  });
                },
              ),
              Text("Set Alarm")
            ],
          ),
          if (_setAlarm) ...[
            SizedBox(height: 10),
            ElevatedButton(
              child: Text(_selectedTime == null
                  ? "Select Alarm Time"
                  : "Alarm: ${_selectedTime!.format(context)}"),
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() => _selectedTime = pickedTime);
                }
              },
            ),
          ]
        ],
      ),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: Text("Save Task"),
          onPressed: () {
            if (_taskController.text.isNotEmpty) {
              final now = DateTime.now();
              DateTime? alarmDateTime;

              if (_setAlarm && _selectedTime != null) {
                alarmDateTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  _selectedTime!.hour,
                  _selectedTime!.minute,
                );
              }

              Provider.of<TaskProvider>(context, listen: false)
                  .addTask(_taskController.text, alarmTime: alarmDateTime, hasAlarm: _setAlarm);

              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
