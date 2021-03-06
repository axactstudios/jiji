import 'package:flutter/cupertino.dart';
import 'package:jiji/models/user_model.dart';

class User with ChangeNotifier {
  User(
      {this.name,
      this.email,
      this.password,
      this.password1,
      this.id,
      this.phone,
      this.token});

  String name;
  String email;
  String password;
  String password1;
  String id;
  int phone;
  String token;
  void updateUser(UserModel user) {
    name = user.name;
    token = user.token;
    email = user.emailId;
    phone = user.phone;
    id = user.uid;
    notifyListeners();
  }
}
