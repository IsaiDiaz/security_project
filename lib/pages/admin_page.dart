import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:security_project/objects/crypto_utils.dart';
import 'package:security_project/objects/session_manager.dart';
import 'package:encrypt/encrypt.dart';

List<Encrypted> messages = [];

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final String adminSecretMessage =
      'The admin secret message is: "I love Flutter!"';

  final sessionManager = SessionManager();

  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('Original message: $adminSecretMessage');
    var encrypted = CryptoUtils.encrypt(adminSecretMessage);
    var decrypted = CryptoUtils.decrypt(encrypted);
    print('Encrypted message: ${encrypted.base16}');
    if (!sessionManager.isActive!) {
      Navigator.pushReplacementNamed(context, '/login');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(decrypted),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: messageController,
            decoration:
                InputDecoration(hintText: 'Enter text', label: Text('Message')),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  String message = messageController.text;
                  var encryptedMessage = CryptoUtils.encrypt(message);
                  print("Encrypted message sent: ${encryptedMessage.base16}");
                  messageController.clear();
                  messages.add(encryptedMessage);
                });
              },
              child: Text('Send')),
          Expanded(

            child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(CryptoUtils.decrypt(messages[index])),
                  );
                }),
          )
        ]),
      ),
    );
  }
}