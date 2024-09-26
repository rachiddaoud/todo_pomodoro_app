import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_pomodoro_app/services/auth_service.dart';
import 'package:todo_pomodoro_app/models/task.dart';
import 'package:todo_pomodoro_app/services/database_service.dart';
import 'package:todo_pomodoro_app/widgets/task_list.dart';
import 'package:todo_pomodoro_app/screens/tasks/add_edit_task_screen.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return StreamProvider<List<Task>>.value(
      value: DatabaseService(uid: user!.uid).tasks,
      initialData: [],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Tasks'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: TaskList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to Add Task Screen
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation)  => AddEditTaskScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
