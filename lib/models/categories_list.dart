import 'package:flutter/cupertino.dart';
import 'package:jiji/impl/impl.dart';

import 'category.dart';

class Categories with ChangeNotifier {
  List<Category> catergories = [];
  void updateCategories(List<Category> cat) {
    catergories = cat;
    notifyListeners();
  }

  initialiseData() async {
    catergories = await Impl().getCategoriesList();
    notifyListeners();
  }

  List<Category> get categoriesList => catergories;
}
