import 'user.dart';

class AuthService{
  
  static List<User> users = [
    User(username: 'admin', password: 'admin', role: Role.admin),
    User(username: 'user', password: 'user', role: Role.user)
  ];

  static void addUser(User user){
    users.add(user);
  }

}

