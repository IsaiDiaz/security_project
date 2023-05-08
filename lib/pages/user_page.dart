import 'package:flutter/material.dart';
import 'package:security_project/objects/crypto_utils.dart';
import 'dart:typed_data';
import 'package:security_project/objects/session_manager.dart';

class UserPage extends StatelessWidget {

  final String userSecretMessage = 'The user secret message is : "I love Flutter!"';
  final String password = 'admin';
  final sessionManager = SessionManager();
  @override
  Widget build(BuildContext context) {

    print('Original message: $userSecretMessage');
    var encrypted = CryptoUtils.encrypt(userSecretMessage);
    var decrypted = CryptoUtils.decrypt(encrypted);
    print('Encrypted message: ${encrypted.base16}');
    
    if (!sessionManager.isActive!) {
      Navigator.pushReplacementNamed(context, '/login');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
        actions: [
          IconButton(
            onPressed: () {
              sessionManager.endSession();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Text(decrypted),
      ),
    );
  }
}
