import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_pomodoro_app/models/task.dart';
import 'package:todo_pomodoro_app/providers/timer_provider.dart';
import 'package:todo_pomodoro_app/screens/settings/settings_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class PomodoroScreen extends StatelessWidget {
  final Task? task;

  PomodoroScreen({this.task});

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pomodoro Timer'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => SettingsScreen(),
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
          ],
        ),
        body: Consumer<TimerProvider>(
          builder: (context, timerProvider, child) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (task != null) ...[
                    Text(
                      'Task:',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      task!.title,
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20.0),
                  ],
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: timerProvider.isFocusSession ? Colors.blue[100] : Colors.green[100],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      timerProvider.isFocusSession ? 'Focus Session' : 'Break Time',
                      style: TextStyle(fontSize: 28.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Text(
                      _formatTime(timerProvider.remainingTime),
                      key: ValueKey<int>(timerProvider.remainingTime),
                      style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (timerProvider.status == TimerStatus.stopped ||
                          timerProvider.status == TimerStatus.paused)
                        ElevatedButton.icon(
                          onPressed: () => timerProvider.startTimer(),
                          icon: Icon(Icons.play_arrow),
                          label: Text('Start'),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(120, 50)),
                        ),
                      if (timerProvider.status == TimerStatus.running) ...[
                        ElevatedButton.icon(
                          onPressed: () => timerProvider.pauseTimer(),
                          icon: Icon(Icons.pause),
                          label: Text('Pause'),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(120, 50)),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: () => timerProvider.resetTimer(),
                          icon: Icon(Icons.stop),
                          label: Text('Reset'),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(120, 50)),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
  }
}