import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiji/models/product.dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:jiji/widgets/bottom_nav.dart';
import 'package:jiji/widgets/jiji_app_bar.dart';
import 'package:jiji/widgets/jiji_search_app_bar.dart';
import 'package:jiji/widgets/show_products_gridview.dart';

class SearchResultPage extends StatelessWidget {
  final List<Product> results;

  const SearchResultPage({Key key, @required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool resultFound = results.length > 0 ? true : false;
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: JijiAppBar(),
          preferredSize: Size.fromHeight(SizeConfig.deviceHeight * 10),
        ),
        body: resultFound
            ? Container(
                padding: EdgeInsets.all(10),
                child: ShowProductsGridView(
                  products: results,
                ),
              )
            : NoResultsFound(),
      ),
    );
  }
}

class NoResultsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.deviceWidth * 5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No Results',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.deviceHeight * 2.15),
            ),
            SizedBox(
              height: SizeConfig.deviceHeight * 3,
            ),
            Text(
              'Sorry, we couldn’t find any results for your query',
              maxLines: 2,
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.deviceHeight * 2),
            ),
          ],
        ),
      ),
    );
  }
}
