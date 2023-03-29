import 'dart:io';

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'package:security_project/objects/user.dart';
import 'package:security_project/objects/auth_service.dart';
import 'package:flutter/services.dart';

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
                        Navigator.pushReplacement(
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

  void _login(BuildContext context) {
    User currentUser = AuthService.searchUser(_username, _password);

    if (currentUser.username != 'placeholder') {
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

    Future.delayed(Duration(seconds: 5), () {
      overlayEntry.remove();
    });
  }

  void _showSecurityTips(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Recomendaciones de seguridad'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('- Cambiar periodicamente la contraseña, para reducir el riesgo de que alguien adivine la contraseña'),
            Text('- Evita reutilizar contraseñas que hayas usado en otros sitios'),
            Text('- No compartas tus accesos con nadie externo a la organización'),
            Text('- No uses contraseñas obvias, como tu nombre o fecha de nacimiento'),
            Text('- Evita tener tus contraseñas guardadas tanto en fisico como en digital'),
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
