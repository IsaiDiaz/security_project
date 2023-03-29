class User{
  final String username;
  final String password;
  final Role role;

  User({required this.username,required this.password,required this.role});

}

enum Role{
  admin,
  user,
}