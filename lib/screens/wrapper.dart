import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_pomodoro_app/screens/home/home_screen.dart';
import 'package:todo_pomodoro_app/screens/authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    // Return HomeScreen if logged in, else Authenticate
    if (user == null) {
      return Authenticate();
    } else {
      return HomeScreen();
    }
  }
}
