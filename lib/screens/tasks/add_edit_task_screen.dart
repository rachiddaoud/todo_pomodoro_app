import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_pomodoro_app/models/task.dart';
import 'package:todo_pomodoro_app/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  AddEditTaskScreen({this.task});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String title = '';
  String description = '';
  String category = 'General';
  String priority = 'Medium';
  DateTime dueDate = DateTime.now();
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // Edit mode - populate fields with existing data
      title = widget.task!.title;
      description = widget.task!.description;
      category = widget.task!.category;
      priority = widget.task!.priority;
      dueDate = widget.task!.dueDate;
      isCompleted = widget.task!.isCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title Field
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (val) => val == null || val.isEmpty ? 'Enter a title' : null,
                onChanged: (val) => setState(() => title = val),
              ),
              SizedBox(height: 10),
              // Description Field
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onChanged: (val) => setState(() => description = val),
              ),
              SizedBox(height: 10),
              // Category Field
              DropdownButtonFormField<String>(
                value: category,
                decoration: InputDecoration(labelText: 'Category'),
                items: ['Work', 'Personal', 'Study', 'General'].map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (val) => setState(() => category = val!),
              ),
              SizedBox(height: 10),
              // Priority Field
              DropdownButtonFormField<String>(
                value: priority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: ['High', 'Medium', 'Low'].map((priority) {
                  return DropdownMenuItem(value: priority, child: Text(priority));
                }).toList(),
                onChanged: (val) => setState(() => priority = val!),
              ),
              SizedBox(height: 10),
              // Due Date Field
              ListTile(
                title: Text('Due Date: ${DateFormat('yyyy-MM-dd').format(dueDate)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDueDate,
              ),
              SizedBox(height: 20),
              // Save Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Create or update task
                    Task newTask = Task(
                      id: widget.task?.id ?? '',
                      title: title,
                      description: description,
                      category: category,
                      priority: priority,
                      dueDate: dueDate,
                      isCompleted: isCompleted,
                    );
                    DatabaseService dbService = DatabaseService(uid: user!.uid);

                    if (widget.task == null) {
                      // Add new task
                      await dbService.addTask(newTask);
                    } else {
                      // Update existing task
                      newTask.id = widget.task!.id;
                      await dbService.updateTask(newTask);
                    }
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to pick due date
  void _pickDueDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (date != null) {
      setState(() => dueDate = date);
    }
  }
}
