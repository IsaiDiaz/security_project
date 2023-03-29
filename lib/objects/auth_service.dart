import 'user.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthService {
  static List<User> users = [];

  static String addUser(User user) {
    var bytes = utf8.encode(user.password);
    var digest = sha256.convert(bytes);
    String encryptedPassword = digest.toString();

    if(checkIfExist(user.username)){
      return 'Username already exists';
    }

    if (validatePassword(user.password)) {
      User encUser = User(
          username: user.username,
          password: encryptedPassword,
          role: user.role);

      print(
          "New User: \n${encUser.username} ${encUser.password} ${encUser.role}");
      users.add(encUser);
      return 'User added';
    } else {
      return 'Password does not meet requirements. The password must be at least 12 characters long, contain at least one uppercase letter, one lowercase letter, one number, and one special character ';
    }
  }

  static User searchUser(_username, _password) {
    for (var user in users) {
      if (user.username == _username) {
        var bytes = utf8.encode(_password);
        var digest = sha256.convert(bytes);
        String encryptedPassword = digest.toString();

        print('Encrypted password in login: $encryptedPassword');

        if (user.password == encryptedPassword) {
          return user;
        }
      }
    }
    return User(
        password: 'placeholder', username: 'placeholder', role: Role.user);
  }

  static bool validatePassword(String password) {
    if (password.length < 12) {
      return false;
    }

    bool hasNumber = password.contains(new RegExp(r'[0-9]'));
    if (!hasNumber) {
      return false;
    }

    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    if (!hasLowercase) {
      return false;
    }

    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    if (!hasUppercase) {
      return false;
    }

    bool hasSpecial = password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    if (!hasSpecial) {
      return false;
    }

    return true;
  }

  static bool checkIfExist(String username) {
    for (var user in users) {
      if (user.username == username) {
        return true;
      }
    }
    return false;
  }
}
