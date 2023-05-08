import 'package:flutter/material.dart';
import 'package:security_project/pages/login_page.dart';
import 'package:security_project/pages/home_page.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
      },
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}
