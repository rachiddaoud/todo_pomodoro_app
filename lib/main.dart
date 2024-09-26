// main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_pomodoro_app/screens/wrapper.dart';
import 'package:todo_pomodoro_app/services/auth_service.dart';
import 'package:todo_pomodoro_app/providers/theme_provider.dart';
import 'package:todo_pomodoro_app/providers/timer_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize ThemeProvider and load theme preference
  ThemeProvider themeProvider = ThemeProvider();
  await themeProvider.loadThemePreference();

  runApp(
    TodoPomodoroApp(themeProvider: themeProvider),
  );
}

class TodoPomodoroApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  TodoPomodoroApp({required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: AuthService().user,
          initialData: null,
          catchError: (_, __) => null,
        ),
        ChangeNotifierProvider<ThemeProvider>.value(
          value: themeProvider,
        ),
        ChangeNotifierProvider<TimerProvider>(
          create: (_) => TimerProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            home: Wrapper(),
          );
        },
      ),
    );
  }
}