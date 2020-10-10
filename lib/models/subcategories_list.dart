import 'package:flutter/cupertino.dart';
import 'package:jiji/impl/impl.dart';
import 'package:jiji/models/sub_category.dart';

class SubCategories with ChangeNotifier {
  List<SubCategory> catergories = [];
  void updateCategories(List<SubCategory> cat) {
    catergories = cat;
    notifyListeners();
  }

  initialiseData() async {
    catergories = await Impl().getSubCategoriesList();
    notifyListeners();
  }

  List<SubCategory> get subCategoriesList => catergories;
}
