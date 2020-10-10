import 'package:flutter/material.dart';
import 'package:jiji/models/category.dart';
import 'package:jiji/pages/home_page.dart';
import 'package:jiji/pages/sub_category_page.dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:jiji/widgets/jiji_app_bar.dart';

class MyViewAllPage extends StatelessWidget {
  final List<Category> categories;

  const MyViewAllPage({Key key, this.categories}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
        children: categories
            .map(
              (category) => CategoryCard(
                label: category.name,
                categoryId: category.id,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SubCategoryScreen(
                      categoryId: category.id,
                    ),
                  ),
                ),
                subText: "(${category.view} ads)",
              ),
            )
            .toList(),
      ),
    );
  }
}
