import 'dart:async';

import 'package:jiji/data/network/repository.dart';
import 'package:jiji/models/category.dart';
import 'package:jiji/models/product.dart';
import 'package:jiji/models/sub_category.dart';

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

  Future<List<Category>> getCategoriesList() async {
    final List<Category> categories = await _repository.getCategoriesList();
    return categories;
  }

  Future<List<SubCategory>> getSubCategoriesList() async {
    final List<SubCategory> subCategories =
        await _repository.getSubCategoriesList();
    return subCategories;
  }

  Future<List<Product>> getPopularProductsList() async {
    final List<Product> products = await _repository.getPopularProductsList();
    return products;
  }

  Future<List<Product>> getSimilarProductsList(
      Map<String, dynamic> header, Map<String, dynamic> para) async {
    final List<Product> products = await _repository.getPopularProductsList();
    return products;
  }

  Future<String> savePost(
      Map<String, dynamic> body, Map<String, String> header) async {
    final String response = await _repository.savePost(body, header);
    return response;
  }

  // Future<List<VehicleModel>> getVehicalModelsList() async {
  //   VehicalRepository _repository = new VehicalRepository();
  //   final List<VehicleModel> vehicalModels =
  //       await _repository.fetchVehicalModels();
  //   return vehicalModels;
  // }

  // Future<List<VehicleAddon>> getVehicalAddons() async {
  //   VehicalRepository _repository = new VehicalRepository();
  //   final List<VehicleAddon> vehicalAddons =
  //       await _repository.fetchVehicalAddons();
  //   return vehicalAddons;
  // }
}
