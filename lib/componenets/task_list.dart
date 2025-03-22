import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/providers/task_provider.dart';
import 'package:provider/provider.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = taskProvider.tasks;

        if (tasks.isEmpty) {
          return const Center(
            child: Text(""),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            final time = task['alarmTime'] != null ? "Alarm at: ${task['alarmTime'].toLocal()}" : "";

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Dismissible(
                key: Key(task['key'].toString()),
                onDismissed: (direction) {
                  taskProvider.removeTask(task['key']);
                },
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: const Icon(
                    Icons.delete,
                    color: Color.fromARGB(255, 254, 1, 1),
                  ),
                ),
                child: ListTile(
                  title: Text(task['title'],
                  style: TextStyle(
                    color: task['isCompleted'] ? Colors.grey : Colors.black,
                    decoration: task['isCompleted'] ? TextDecoration.lineThrough : null,
                  ),),
                  subtitle: task['alarmTime'] != null ? Text(time) : null,
                  trailing:Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      side: const BorderSide(color: Colors.grey, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1),
                      ),
                      checkColor: Colors.white,
                      activeColor: Colors.green,
                      value: task['isCompleted'],
                      onChanged: (value) => taskProvider.toggleTaskCompletion(task['key']),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
