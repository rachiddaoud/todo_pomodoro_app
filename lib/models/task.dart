import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String description;
  String category;
  String priority;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
  });

  // Convert Task object to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'dueDate': Timestamp.fromDate(dueDate),
      'isCompleted': isCompleted,
    };
  }

  // Create Task object from DocumentSnapshot
  factory Task.fromDocument(DocumentSnapshot doc) {
    return Task(
      id: doc.id,
      title: doc['title'],
      description: doc['description'],
      category: doc['category'],
      priority: doc['priority'],
      dueDate: (doc['dueDate'] as Timestamp).toDate(),
      isCompleted: doc['isCompleted'],
    );
  }
}
