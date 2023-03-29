import 'package:flutter/material.dart';
import 'home_page.dart';

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
                  )
                ],
              )),
        ));
  }

  void _login(BuildContext context) {

  if(_username == 'myusername' && _password == 'mypassword') {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
  } else {
    showDialog(context: context, builder: (context) => AlertDialog(title: Text('Login failed'), content: Text('Please check your username and password'), actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],));
  }

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logging in...')

  }


}

