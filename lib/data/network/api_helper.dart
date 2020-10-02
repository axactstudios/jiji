import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:jiji/data/network/network_exceptions.dart';

class ApiHelper {
  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
    return responseJson;
  }

  Future<dynamic> getWithHeadersInputs(
      String url, Map header, Map parameters) async {
    var responseJson;
    Dio dio = new Dio();
    try {
      var response = await dio.get(url,
          queryParameters: parameters, options: Options(headers: header));
      responseJson = _returnDioResponse(response);
    } catch (e) {
      print(e);
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Map mappedJson) async {
    var responseJson;
    try {
      final response = await http.post(
        url,
        body: jsonEncode(mappedJson),
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        },
      );
      responseJson = _returnResponse(response);
    } catch (e) {
      print(e);
    }
    return responseJson;
  }

  Future<dynamic> postAndGetResponseNumber(String url, Map mappedJson) async {
    Map<String, dynamic> responseJson;
    try {
      final response = await http.post(
        url,
        body: jsonEncode(mappedJson),
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        },
      );
      responseJson = _returnResponse(response, dontThrow: true);
      responseJson.addAll({"statusCode": response.statusCode});
    } catch (e) {
      print(e);
    }
    return responseJson;
  }

  Future<dynamic> postWithHeadersInputs(
      String url, Map mappedJson, Map header) async {
    var responseJson;
    try {
      final response = await http.post(
        url,
        body: mappedJson,
        headers: header,
      );
      responseJson = _returnResponse(response);
    } catch (e) {
      print(e);
    }
    return responseJson;
  }

  Future<dynamic> postWithHeadersFormData(
      String url, Map mappedJson, Map<String, String> header) async {
    var responseJson;
    try {
      final response = await http.post(
        url,
        body: FormData.fromMap(mappedJson),
        headers: header,
      );
      responseJson = _returnResponse(response);
    } catch (e) {
      print(e);
    }
    return responseJson;
  }

  dynamic _returnDioResponse(Response response) {
    print('status code - ${response.statusCode}');
    switch (response.statusCode) {
      case 200:
        var responseJson = response.data.toString();
        print(responseJson);
        return responseJson;

      case 400:
        throw BadRequestException(response.data.toString());

      case 401:
      case 403:
        throw UnauthorisedException(response.data.toString());

      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode '
            ': ${response.statusCode} \n and error response : ${response.data}');
    }
  }

  dynamic _returnResponse(http.Response response, {bool dontThrow = false}) {
    if (dontThrow) {
      return json.decode(response.body.toString());
    }

    // print('status code - ${response.statusCode}');
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;

      case 400:
        throw BadRequestException(response.body.toString());

      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());

      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode '
            ': ${response.statusCode} \n and error response : ${response.body}');
    }
  }
}
