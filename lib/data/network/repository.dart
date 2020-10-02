import 'package:jiji/constants/endpoints.dart';
import 'package:jiji/data/network/api_helper.dart';

class Repository {
  ApiHelper _helper = ApiHelper();
  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> body) async {
    Map<String, dynamic> response =
        await _helper.postAndGetResponseNumber(Endpoints.registerUser, body);
    return response;
  }

  Future<Map<String, dynamic>> checkCredentials(
      Map<String, dynamic> body) async {
    Map<String, dynamic> response = await _helper.postAndGetResponseNumber(
        Endpoints.checkUserCredentials, body);
    return response;
  }

  Future<Map<String, dynamic>> createPost(Map<String, dynamic> body, Map header) async {
    Map<String, dynamic> response =
    await _helper.postWithHeadersInputs(Endpoints.createPost, body, header);
    return response;
  }
}
