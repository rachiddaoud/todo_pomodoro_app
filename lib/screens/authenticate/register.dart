import 'package:flutter/material.dart';
import 'package:todo_pomodoro_app/services/auth_service.dart';

class Register extends StatefulWidget {
  final VoidCallback toggleView;

  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  // Form key and state variables
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
            onPressed: widget.toggleView,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Email Field
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter your email' : null,
                onChanged: (val) => setState(() => email = val),
              ),
              // Password Field
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) => setState(() => password = val),
              ),
              SizedBox(height: 20.0),
              // Register Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Register'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => loading = true);
                    dynamic result =
                        await _auth.registerWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() {
                        error = result;
                        loading = false;
                      });
                    }
                  }
                },
              ),
              // Error Message
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
