import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:security_project/objects/user.dart';
import 'package:security_project/objects/auth_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final String _adminCode = "admin";
  String _username = "";
  String _password = "";
  String _adminCodeInput = "";
  String _confirmPassword = "";
  Role _role = Role.user;
  int _maxAdminRegisterAttemps = 3;
  int _loginAdminAttemps = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
            },
          )
        ],
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
                      }else{
                        setState(() {
                        _password = value;
                        });
                      }
                      return null;
                    },
                    onSaved: (value) {
                        _password = value!;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _password) {
                        return 'Passwords do not match';
                      }else{
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _confirmPassword = value!;
                    },
                  ),
                  Visibility(visible: _role == Role.admin, 
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Admin Code'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an admin code';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _adminCodeInput = value!;
                    },
                  ),
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
                        
                        if( _password != _confirmPassword){
                          _register(context, "Passwords do not match");
                        }

                        if (_role == Role.admin && _adminCodeInput != _adminCode) {
                          _loginAdminAttemps++;
                          if(_loginAdminAttemps >= _maxAdminRegisterAttemps){
                            Fluttertoast.showToast(
                              msg: "The maximum attempts to enter the administrator password has been exceeded",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 5,
                            );
                            Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            );
                          }else{
                            _register(context, "Invalid admin code");
                          }
                        }else{
                           String message = AuthService.addUser(newUser);

                          _register(context, message);
                        }
                      }
                    },
                    child: Text('Register'),
                  )
                ],
              ),
            )));
  }

  void _register(BuildContext context, String message) {
    if (message == "User added") {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Register Successful'),
                content: Text(message),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          ),
                      child: Text('OK'))
                ],
              ));
    } else {
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
