import 'package:flutter/material.dart';
import 'package:security_project/objects/user.dart';
import 'admin_page.dart';
import 'user_page.dart';

class HomePage extends StatefulWidget {

  final User user;

  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(user: user);
}

class _HomePageState extends State<HomePage> {

  final User user;

  _HomePageState({Key? key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home_page'),
        ),
        body:
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome ${widget.user.username}'),
              SizedBox(height: 16.0,),
              if (user.role == Role.admin)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminPage()),
                    );
                  },
                  child: Text('Admin Page'),
                ),
              if (user.role == Role.user)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserPage()),
                    );
                  },
                  child: Text('User Page'),
                ),
            ],          
          ),
        ), 
        
        );
  }

}