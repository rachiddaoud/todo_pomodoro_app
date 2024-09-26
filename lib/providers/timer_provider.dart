import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_pomodoro_app/services/notification_service.dart';


enum TimerStatus { stopped, running, paused }

class TimerProvider extends ChangeNotifier {
  // Timer durations in seconds
  int focusDuration;
  int shortBreakDuration;
  int longBreakDuration;
  int sessionsBeforeLongBreak;

  // Internal state variables
  int _remainingTime;
  TimerStatus _status = TimerStatus.stopped;
  Timer? _timer;
  bool _isFocusSession = true;
  int _completedSessions = 0;

  // Getters
  int get remainingTime => _remainingTime;
  TimerStatus get status => _status;
  bool get isFocusSession => _isFocusSession;
  int get completedSessions => _completedSessions;
  int get totalCompletedSessions => _completedSessions;

  TimerProvider({
    this.focusDuration = 1500, // 25 minutes
    this.shortBreakDuration = 300, // 5 minutes
    this.longBreakDuration = 900, // 15 minutes
    this.sessionsBeforeLongBreak = 4,
  }) : _remainingTime = 1500;

  // Start the timer
  void startTimer() {
    if (_status == TimerStatus.running) return;

    _status = TimerStatus.running;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _status = TimerStatus.stopped;
        _handleSessionCompletion();
      }
    });
    notifyListeners();
  }

  // Pause the timer
  void pauseTimer() {
    if (_status == TimerStatus.running) {
      _timer?.cancel();
      _status = TimerStatus.paused;
      notifyListeners();
    }
  }

  // Reset the timer
  void resetTimer() {
    _timer?.cancel();
    _status = TimerStatus.stopped;
    _remainingTime = _isFocusSession ? focusDuration : _getBreakDuration();
    notifyListeners();
  }

  // Handle session completion
  void _handleSessionCompletion() {
    if (_isFocusSession) {
      _completedSessions++;
      // Trigger notification
      NotificationService().showNotification(
        title: 'Focus Session Complete',
        body: 'Time for a break!',
      );
      _isFocusSession = false;
    } else {
      // Trigger notification
      NotificationService().showNotification(
        title: 'Break Over',
        body: 'Ready for the next focus session?',
      );
      _isFocusSession = true;
    }
    _remainingTime = _isFocusSession ? focusDuration : _getBreakDuration();
    notifyListeners();
  }

  // Get appropriate break duration
  int _getBreakDuration() {
    return (_completedSessions % sessionsBeforeLongBreak == 0)
        ? longBreakDuration
        : shortBreakDuration;
  }

  // Update durations
  void updateDurations({
    int? focus,
    int? shortBreak,
    int? longBreak,
    int? sessionsBeforeLongBreak,
  }) {
    focusDuration = focus ?? this.focusDuration;
    shortBreakDuration = shortBreak ?? this.shortBreakDuration;
    longBreakDuration = longBreak ?? this.longBreakDuration;
    this.sessionsBeforeLongBreak = sessionsBeforeLongBreak ?? this.sessionsBeforeLongBreak;
    resetTimer();
  }
}
