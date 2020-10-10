

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:jiji/pages/search_page.dart';
import 'package:jiji/pages/search_result_page.dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:provider/provider.dart';

import '../impl/impl.dart';
import '../models/product.dart';
import '../models/user_model.dart';
import '../models/user_model.dart';

class JijiSearchAppBar extends StatelessWidget {
  Future<List<Product>> _search(UserModel user, String query) async {
    Map<String, String> header = {'Authentication': "Bearer ${user.token}"};
    Map<String, dynamic> params = {
      'search': 'delhi',
    };

    final List<Product> response = await Impl().getSearch(header, params);
    print(response[1].postedBy.name);
    return response;
  }

  Widget build(BuildContext context) {
    final Box<UserModel> _user =
        Provider.of<Box<UserModel>>(context, listen: false);
    final UserModel _userModel = _user.values.first;
    SizeConfig().init(context);
    final TextEditingController _searchController = TextEditingController();
    double appBarHeight = SizeConfig.deviceHeight * 10;
    return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Hexcolor("#3DB83A"),
        elevation: 10,
        // centerTitle: false,
        // titleSpacing: 0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: appBarHeight * 0.25,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Jiji",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: appBarHeight * 0.30),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.deviceWidth * 5),
                    child: Container(
                      height: appBarHeight * 0.50,
                      width: SizeConfig.deviceWidth * 60,
                      child: TextField(
                        onSubmitted: (value) async {
                          final List response =
                              await _search(_userModel, value.toString());

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchResultPage(
                                        results: response,
                                      )));
                        },
                        autofocus: true,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: appBarHeight * 0.1,
                                bottom: appBarHeight * 0.1,
                                left: SizeConfig.deviceWidth * 4),
                            suffixIcon: Icon(
                              Icons.search_outlined,
                              size: SizeConfig.deviceWidth * 5.5,
                            ),
                            filled: true,
                            fillColor: Hexcolor("#F0F0F0"),
                            hintStyle: TextStyle(
                              fontSize: appBarHeight * 0.18,
                              color: Colors.grey,
                            ),
                            hintText: "Search",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.notifications_outlined,
                    size: SizeConfig.deviceWidth * 6.0,
                  ),
                ]),
          ],
        ));
  }
}
