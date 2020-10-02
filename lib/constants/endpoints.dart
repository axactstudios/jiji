import 'package:jiji/constants/global.dart';

class Endpoints {
  static String baseUrl = "https://olx-app-jiji.herokuapp.com";

  static String registerUser = "$baseUrl/api/register";
  static String checkUserCredentials = "$baseUrl/api/login";
  static String createPost = '$baseUrl/api/post/create/$globalUid';
}

// https://olx-app-jiji.herokuapp.com/api/post/create/5f5fc6d051c4e73148ccd17a