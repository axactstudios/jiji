import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:jiji/constants/endpoints.dart';
import 'package:jiji/models/user_model.dart';
import 'package:http/http.dart' as http;

class DmController extends GetxController {
  var chatData = List().obs;
  var uid = ''.obs;
  TextEditingController msgController;
  Future getHistory(String rec) async {
    try {
      final Box<UserModel> _userBox =
          await Hive.openBox<UserModel>('userModel');
      uid.value = _userBox.values.first.uid;
      var token = _userBox.values.first.token;
      var url = "${Endpoints.chatHistory}$uid?userId=$rec";

      var response = await http.get(
        url,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        chatData.value = jsonData;
      }
    } on SocketException {
      print('No Internet');
    }
  }

  @override
  onClose() {
    msgController?.dispose();
    super.onClose();
  }

  Future personalChat(String body, String rec) async {
    try {
      var data = {"to": rec, "body": body};

      print(rec);
      final Box<UserModel> _userBox =
          await Hive.openBox<UserModel>('userModel');
      var uid = _userBox.values.first.uid;
      var token = _userBox.values.first.token;
      var url = "${Endpoints.personalChat}$uid";
      print(url);
      var response = await http.post(
        url,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(data),
      );
      msgController.clear();

      print(response.statusCode);
    } on SocketException {
      print('No Internet');
    }
  }
}
