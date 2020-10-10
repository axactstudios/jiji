import 'package:jiji/constants/endpoints.dart';
import 'package:jiji/data/network/api_helper.dart';
import 'package:jiji/models/category.dart';
import 'package:jiji/models/product.dart';
import 'package:jiji/models/sub_category.dart';
import 'dart:convert';

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

  Future<String> savePost(
      Map<String, dynamic> body, Map<String, String> header, String uid) async {
    String url = Endpoints.savePost + uid;
    String response = await _helper.postWithHeadersInputs(url, body, header);
    return response;
  }

  Future<List<Category>> getCategoriesList() async {
    List<Category> categories = [];
    final response = await _helper.get(Endpoints.categories);
    response.toList().forEach((element) {
      categories.add(Category.fromJson(element));
    });
    return categories;
  }

  Future<List<SubCategory>> getSubCategoriesList() async {
    List<SubCategory> subCategories = [];
    final response = await _helper.get(Endpoints.subCategories);
    // print(response);
    response.toList().forEach((element) {
      subCategories.add(SubCategory.fromJson(element));
    });
    return subCategories;
  }

  Future<List<Product>> getPopularProductsList() async {
    List<Product> products = [];
    final response = await _helper.get(Endpoints.popularProducts);
    response.toList().forEach((element) {
      products.add(Product.fromJson(element));
    });
    return products;
  }

  Future<List<Product>> getSearch(
      Map<String, String> header, Map<String, dynamic> param) async {
    List<Product> products = [];
    final response =
        await _helper.getWithHeadersInputs(Endpoints.search, header, param);

    response.toList().forEach((element) {
      products.add(Product.fromJson(element));
    });
    return products;
  }

  Future putLike(Map<String, String> header, Map<String, dynamic> mappedJson,
      String uid) async {
    String url = Endpoints.savePost + uid;
    final response =
        await _helper.putWithHeadersInputs(url, mappedJson, header);
    return response;
  }

  Future putUnlike(Map<String, String> header, Map<String, dynamic> mappedJson,
      String uid) async {
    String url = Endpoints.savePost + uid;
    final response =
        await _helper.putWithHeadersInputs(url, mappedJson, header);
    return response;
  }

  Future<List<Product>> getSimilarProductsList(
      Map<String, dynamic> header, Map<String, dynamic> para) async {
    List<Product> products = [];
    final response = await _helper.getWithHeadersInputs(
        Endpoints.similarProducts, header, para);

    response.toList().forEach((element) {
      products.add(Product.fromJson(element));
    });
    return products;
  }
  // Future<List<VehicleName>> fetchVehicalNames() async {
  //   List<VehicleName> vehicalNames = [];
  //   Map<String, dynamic> response =
  //       await _helper.get("http://happymoney.in/api/v1/vehicle/makes");
  //   response["data"].toList().forEach((element) {
  //     vehicalNames.add(VehicleName.fromJson(element));
  //   });
  //   return vehicalNames;
  // }

}
