import 'dart:io';

import 'package:flutter/material.dart';
import 'package:security_project/objects/session_manager.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'package:security_project/objects/user.dart';
import 'package:security_project/objects/auth_service.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          actions: [
            IconButton(
              icon: Icon(Icons.help),
              onPressed: () {
                _showSecurityTips(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _username = value!;
                    },
                  ),
                  TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      }),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _login(context);
                      }
                    },
                    child: Text('Login'),
                  ),
                  SizedBox(height: 16.0),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      },
                      child: Text('Create an account')),
                ],
              )),
        ));
  }

  int _maxLoginAttempts = 3;
  int _loginAttempts = 0;
  final sessionManager = SessionManager();

  void _login(BuildContext context) {
    User currentUser = AuthService.searchUser(_username, _password);

    if (currentUser.username != 'placeholder') {
      final random = Random();
      final now = DateTime.now();
      final hostName = Platform.localHostname;

      final sessionId = '${now.microsecondsSinceEpoch}-${hostName}-${random.nextInt(10000)}';
      sessionManager.startSession(sessionId);
      
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomePage(user: currentUser)));
    } else {
      _loginAttempts++;
      if (_loginAttempts >= _maxLoginAttempts) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Login failed'),
                  content: Text(
                      'You have exceeded the maximum number of login attempts.'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _blockApp(context);
                        },
                        child: Text('OK'))
                  ],
                ));
        _loginAttempts = 0;
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Login failed'),
                  content: Text('Please check your username and password'),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'))
                  ],
                ));
      }
    }
  }

  void _blockApp(BuildContext context) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(Duration(seconds: 10), () {
      overlayEntry.remove();
    });
  }

  void _showSecurityTips(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Security Recomendations'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('- Periodically change the password, to reduce the risk of someone guessing the password'),
            Text('- Do not use passwords that you used in other sites'),
            Text('- Do not share your credentials with nobody'),
            Text('- Avoid to use your personal information in your passwords'),
            Text('- Avoid keeping your credentials on paper, notepads or digital notes without security'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
