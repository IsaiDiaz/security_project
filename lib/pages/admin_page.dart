import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:security_project/objects/crypto_utils.dart';
import 'package:security_project/objects/session_manager.dart';

class AdminPage extends StatelessWidget {
  final String adminSecretMessage =
      'The admin secret message is: "I love Flutter!"';
  final String password = 'admin';
  final sessionManager = SessionManager();

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
      body: Center(
        child: Text(decrypted),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'dart:convert';

// class AdminPage extends StatefulWidget {
//   @override
//   _AdminPageState createState() => _AdminPageState();
// }

// class _AdminPageState extends State<AdminPage> {
//   TextEditingController _textController = TextEditingController();
//   String _hashedText = '';
//   String _unhashedText = '';

//   void _hashText() {
//     setState(() {
//       _hashedText = json.encode(_textController.text.hashCode);
//       _textController.clear();
//     });
//   }

//   void _unhashText() {
//     setState(() {
//       _unhashedText = utf8.decode(json.decode(_hashedText));
//       _hashedText = '';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _textController,
//               decoration: InputDecoration(
//                 hintText: 'Enter text to hash',
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _hashText,
//               child: Text('Hash'),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Hashed text',
//               ),
//               readOnly: true,
//               controller: TextEditingController(text: _hashedText),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _unhashText,
//               child: Text('Unhash'),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Unhashed text',
//               ),
//               readOnly: true,
//               controller: TextEditingController(text: _unhashedText),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
