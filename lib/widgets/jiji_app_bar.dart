import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:jiji/pages/search_page.dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:provider/provider.dart';

import '../impl/impl.dart';
import '../models/product.dart';
import '../models/user_model.dart';
import '../models/user_model.dart';

class JijiAppBar extends StatelessWidget {


  Widget build(BuildContext context) {
    final Box<UserModel> _user =
        Provider.of<Box<UserModel>>(context, listen: false);
    final UserModel _userModel = _user.values.first;
    SizeConfig().init(context);
    
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPage()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.deviceWidth * 5),
                        decoration: BoxDecoration(
                            color: Hexcolor("#F0F0F0"),
                            borderRadius: BorderRadius.circular(10)),
                        height: appBarHeight * 0.50,
                        width: SizeConfig.deviceWidth * 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "Search",
                                style: TextStyle(
                                  fontSize: appBarHeight * 0.18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Container(
                              child: Icon(
                                Icons.search_outlined,
                                color: Colors.grey,
                                size: SizeConfig.deviceWidth * 5.5,
                              ),
                            )
                          ],
                        ),
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
