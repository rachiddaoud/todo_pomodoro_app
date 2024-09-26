import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_pomodoro_app/providers/theme_provider.dart';
import 'package:todo_pomodoro_app/providers/timer_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int focusDuration = 25;
  int shortBreakDuration = 5;
  int longBreakDuration = 15;
  int sessionsBeforeLongBreak = 4;

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Theme Toggle
            SwitchListTile(
              title: Text('Dark Mode'),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
            Divider(),
            // Focus Duration
            _buildNumberInput(
              label: 'Focus Duration (minutes)',
              value: focusDuration,
              onChanged: (val) => setState(() => focusDuration = val),
            ),
            // Short Break Duration
            _buildNumberInput(
              label: 'Short Break Duration (minutes)',
              value: shortBreakDuration,
              onChanged: (val) => setState(() => shortBreakDuration = val),
            ),
            // Long Break Duration
            _buildNumberInput(
              label: 'Long Break Duration (minutes)',
              value: longBreakDuration,
              onChanged: (val) => setState(() => longBreakDuration = val),
            ),
            // Sessions Before Long Break
            _buildNumberInput(
              label: 'Sessions Before Long Break',
              value: sessionsBeforeLongBreak,
              onChanged: (val) => setState(() => sessionsBeforeLongBreak = val),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                timerProvider.updateDurations(
                  focus: focusDuration * 60,
                  shortBreak: shortBreakDuration * 60,
                  longBreak: longBreakDuration * 60,
                  sessionsBeforeLongBreak: sessionsBeforeLongBreak,
                );
                Navigator.pop(context);
              },
              child: Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberInput({
    required String label,
    required int value,
    required Function(int) onChanged,
  }) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () => onChanged(value > 1 ? value - 1 : 1),
        ),
        Text(value.toString()),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => onChanged(value + 1),
        ),
      ],
    );
  }
}
