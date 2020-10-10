import 'dart:io';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:jiji/constants/endpoints.dart';
import 'package:jiji/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ChatController extends GetxController {
  var data = List().obs;
  var uid = ''.obs;

  @override
  void onInit() {
    getChatList();
    super.onInit();
  }

  Future getChatList() async {
    try {
      final Box<UserModel> _userBox =
          await Hive.openBox<UserModel>('userModel');
      uid.value = _userBox.values.first.uid;
      var token = _userBox.values.first.token;
      var url = "${Endpoints.getChatList}/$uid";
      print(url);
      var response = await http.get(
        url,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        data.value = jsonData;
        print(jsonData);
      }
    } on SocketException {
      print('No Internet');
    }
  }
}
