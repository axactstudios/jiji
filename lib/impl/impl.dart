import 'dart:async';

import 'package:jiji/data/network/repository.dart';

class Impl {
  Repository _repository = new Repository();
  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> body) async {
    final Map<String, dynamic> response = await _repository.registerUser(body);
    return response;
  }

  Future<Map<String, dynamic>> checkCredentials(
      Map<String, dynamic> body) async {
    final Map<String, dynamic> response =
        await _repository.checkCredentials(body);
    return response;
  }

  Future<Map<String, dynamic>> createPost(
      Map<String, dynamic> body, Map<String, String> header) async {
    print('Creating post');
    final Map<String, dynamic> response =
        await _repository.createPost(body, header);
    return response;
  }
}
