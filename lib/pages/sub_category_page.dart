import 'package:flutter/material.dart';
import 'package:jiji/models/sub_category.dart';
import 'package:jiji/models/subcategories_list.dart';
import 'package:jiji/pages/home_page.dart';
import 'package:jiji/pages/show_selected_category_products.dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:jiji/widgets/jiji_app_bar.dart';
import 'package:provider/provider.dart';

class SubCategoryScreen extends StatefulWidget {
  final String categoryId;
  const SubCategoryScreen({
    Key key,
    this.categoryId,
  }) : super(key: key);

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState(categoryId);
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  List<SubCategory> subCategories = [];
  final String categoryId;

  _SubCategoryScreenState(this.categoryId);
  @override
  void initState() {
    super.initState();
    // getSubCategoriesList();
  }

  // getSubCategoriesList() async {
  //   // print(subCategories.length);
  //   final data = await Impl().getSubCategoriesList();
  //   data.forEach((element) {
  //     subCategories.add(element);
  //   });
  //   // print(subCategories.length);
  //   setState(() {});
  // }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    subCategories = Provider.of<SubCategories>(context).subCategoriesList;
    return Scaffold(
      appBar: PreferredSize(
        child: JijiAppBar(),
        preferredSize: Size.fromHeight(SizeConfig.deviceHeight * 10),
      ),
      body: GridView.count(
        primary: false,
        crossAxisSpacing: SizeConfig.deviceWidth,
        mainAxisSpacing: SizeConfig.deviceHeight,
        crossAxisCount: 2,
        children: subCategories
            .map(
              (subCategory) => CategoryCard(
                label: subCategory.name,
                categoryId: subCategory.id,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShowSelectedSubCategoryProducts(
                      subCategoryId: subCategory.id,
                    ),
                  ),
                ),
                subText: "(${subCategories[0].view} ads)",
              ),
            )
            .toList(),
      ),
    );
  }
}
