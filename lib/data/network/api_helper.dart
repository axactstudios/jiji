import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as _dio;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:jiji/data/network/network_exceptions.dart';

class ApiHelper {
  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(url);
      // print(url);
      responseJson = _returnResponse(response);
      // print(responseJson);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
    return responseJson;
  }

  Future<dynamic> getWithHeadersInputs(String url, Map<String, dynamic> header,
      Map<String, dynamic> parameters) async {
    var responseJson;
    _dio.Dio dio = new _dio.Dio();
    try {
      var response = await dio.get(url,
          queryParameters: parameters, options: _dio.Options(headers: header));
      responseJson = _returnDioResponse(response);
    } catch (e) {
      print(e);
    }
    return responseJson;
  }

  Future<dynamic> postWithHeadersInputsDio(String url,
      Map<String, dynamic> header, Map<String, dynamic> parameters) async {
    var responseJson;
    _dio.Dio dio = new _dio.Dio();
    try {
      var response = await dio.post(
        url,
        queryParameters: parameters,
        options: _dio.Options(
          headers: header,
        ),
      );
      // print(response);
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

  Future<dynamic> postWithHeadersInputs(String url,
      Map<String, dynamic> mappedJson, Map<String, String> header) async {
    var responseJson;

    try {
      // print("b4");
      final response = await http.post(
        url,
        body: jsonEncode(mappedJson),
        headers: header,
      );
      responseJson = _returnResponse(response);
      // print(responseJson);
    } catch (e) {
      print(e);
    }
    return responseJson;
  }

  Future<dynamic> putWithHeadersInputs(String url,
      Map<String, dynamic> mappedJson, Map<String, String> header) async {
    // print(url);
    var responseJson;

    try {
      final response = await http.put(
        url,
        body: jsonEncode(mappedJson),
        headers: header,
      );
      print("aftr");
      responseJson = _returnResponse(response);
      // print(responseJson);
    } catch (e) {
      print(e);
    }
    return responseJson;
  }

  // Future<String> multipartRequest(
  //     {var url,
  //     var partParams,
  //     Iterable<_dio.MultipartFile> files,
  //     var headers}) async {
  //   var request = http.MultipartRequest("POST", Uri.parse(url));
  //   request.headers.addAll(headers);
  //   print("1");
  //   if (partParams != null) request.fields.addAll(partParams);
  //   print("11"); // add part params if not null
  //   if (files != null) request.files.addAll(Iterable<MultipartFile>files); // add files if not null
  //   print("2");
  //   var response = await request.send();
  //   var responseData = await response.stream.toBytes();
  //   var responseString = String.fromCharCodes(responseData);
  //   print("responseBody " + responseString);
  //   if (response.statusCode == 200) return responseString;
  // }

  dynamic _returnDioResponse(_dio.Response response) {
    // print('status code - ${response.statusCode}');
    switch (response.statusCode) {
      case 200:
        // print(responseJson);
        return response.data;

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
    print('status code - ${response.statusCode}');
    if (dontThrow) {
      return json.decode(response.body.toString());
    }

    switch (response.statusCode) {
      case 200:
        // print(response.body);
        var responseJson = json.decode(response.body.toString());

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
