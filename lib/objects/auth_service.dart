import 'user.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthService{

  static List<User> users = [];

  static void addUser(User user){

    var bytes = utf8.encode(user.password);
    var digest = sha256.convert(bytes);
    String encryptedPassword = digest.toString();

    User encUser = User(
      username: user.username,
      password: encryptedPassword,
      role: user.role
    );

    print("New User: \n${encUser.username} ${encUser.password} ${encUser.role}");
    users.add(encUser);
  }

  static User searchUser(_username, _password){
    for(var user in users){
      if(user.username == _username){
        var bytes = utf8.encode(_password);
        var digest = sha256.convert(bytes);
        String encryptedPassword = digest.toString();

        print('Encrypted password in login: $encryptedPassword');
        
        if(user.password == encryptedPassword){
          return user;
        }
      }
    }
    return User(password: 'placeholder', username: 'placeholder', role: Role.user);
  }

}

