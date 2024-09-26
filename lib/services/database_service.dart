import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_pomodoro_app/models/task.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // Collection reference
  final CollectionReference taskCollection = FirebaseFirestore.instance.collection('tasks');

  // Add a new task
  Future<DocumentReference<Map<String, dynamic>>> addTask(Task task) async {
  return await taskCollection.doc(uid).collection('userTasks').add(task.toMap());
}

  // Update an existing task
  Future<void> updateTask(Task task) async {
    return await taskCollection
        .doc(uid)
        .collection('userTasks')
        .doc(task.id)
        .update(task.toMap());
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    return await taskCollection.doc(uid).collection('userTasks').doc(taskId).delete();
  }

  // Get task stream
  Stream<List<Task>> get tasks {
    return taskCollection
        .doc(uid)
        .collection('userTasks')
        .orderBy('dueDate')
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  // Task list from snapshot
  List<Task> _taskListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Task.fromDocument(doc);
    }).toList();
  }
}
