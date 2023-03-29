import 'package:flutter/material.dart';
import 'package:security_project/objects/crypto_utils.dart';
import 'dart:typed_data';

class UserPage extends StatelessWidget {

  final String userSecretMessage = 'The user secret message is : "I love Flutter!"';
  final String password = 'admin';

  @override
  Widget build(BuildContext context) {

    print('Original message: $userSecretMessage');
    List<int> encrypted = CryptoUtils.encrypt(userSecretMessage);
    String decrypted = CryptoUtils.decrypt(encrypted);
    print('Encrypted message: $encrypted');

    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
      ),
      body: Center(
        child: Text(decrypted),
      ),
    );
  }
}
