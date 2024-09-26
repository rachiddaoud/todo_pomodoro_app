import 'package:flutter/material.dart';
import 'package:todo_pomodoro_app/models/task.dart';
import 'package:todo_pomodoro_app/screens/tasks/add_edit_task_screen.dart';
import 'package:todo_pomodoro_app/screens/pomodoro/pomodoro_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_pomodoro_app/services/database_service.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (value) async {
          Task updatedTask = Task(
            id: task.id,
            title: task.title,
            description: task.description,
            category: task.category,
            priority: task.priority,
            dueDate: task.dueDate,
            isCompleted: value ?? false,
          );
          await DatabaseService(uid: user!.uid).updateTask(updatedTask);
        },
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text('${task.category} • Due: ${DateFormat('yyyy-MM-dd').format(task.dueDate)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Start Pomodoro Session
          IconButton(
            icon: Icon(Icons.timer),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation)  => PomodoroScreen(task: task),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
          // Edit Task
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => AddEditTaskScreen(task: task),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
          // Delete Task
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool? confirmDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Task'),
                  content: Text('Are you sure you want to delete this task?'),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('Delete'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              );

              if (confirmDelete ?? false) {
                await DatabaseService(uid: user!.uid).deleteTask(task.id);
              }
            },
          ),
        ],
      ),
    );
  }
}
