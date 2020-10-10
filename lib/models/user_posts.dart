import 'package:flutter/cupertino.dart';
import 'package:jiji/constants/endpoints.dart';
import 'package:jiji/data/network/api_helper.dart';
import 'package:jiji/models/my_product.dart';

class UserPosts with ChangeNotifier {
  List<MyProduct> userPostedProducts = [];
  void initialize(String userId, String userToken) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $userToken"
    };
    final response = await ApiHelper()
        .getWithHeadersInputs(Endpoints.userPosts, headers, {"id": userId});
    // print("UserProducts : " + response.toString());
    userPostedProducts = [];
    response.toList().forEach((element) {
      userPostedProducts.add(MyProduct.fromJson(element));
    });
    // print("length" + userPostedProducts.length.toString());
    notifyListeners();
  }
}
