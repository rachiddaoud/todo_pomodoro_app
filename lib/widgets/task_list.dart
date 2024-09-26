import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_pomodoro_app/models/task.dart';
import 'package:todo_pomodoro_app/widgets/task_tile.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<List<Task>>(context);

    if (tasks.isEmpty) {
      return Center(
        child: Text('No tasks added yet.'),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskTile(task: tasks[index]);
      },
    );
  }
}
