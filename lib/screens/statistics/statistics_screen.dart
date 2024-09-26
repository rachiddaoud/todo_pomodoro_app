import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_pomodoro_app/providers/timer_provider.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: Center(
        child: Text(
          'Total Pomodoro Sessions Completed: ${timerProvider.totalCompletedSessions}',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
