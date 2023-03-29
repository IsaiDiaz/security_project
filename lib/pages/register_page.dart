import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:security_project/objects/user.dart';
import 'package:security_project/objects/auth_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";
  Role _role = Role.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    },
                  ),
                  DropdownButtonFormField(
                    //value: _role,
                    decoration: InputDecoration(labelText: 'Role'),
                    items: Role.values
                        .map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(role.toString().split('.').last),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a role';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _role = value!;
                      });
                    },
                  ),
                  //Text('Role: $_role'),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final newUser = User(
                            username: _username,
                            password: _password,
                            role: _role);

                        String message = AuthService.addUser(newUser);

                        _register(context, message);
                      }
                    },
                    child: Text('Register'),
                  )
                ],
              ),
            )));
  }

  void _register(BuildContext context, String message) {
    if(message == "User added"){
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Register Successful'),
              content: Text(message),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        ),
                    child: Text('OK'))
              ],
            ));
    }else{
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('ERROR'),
              content: Text(message),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'))
              ],
            ));
    }
    
  }
}
