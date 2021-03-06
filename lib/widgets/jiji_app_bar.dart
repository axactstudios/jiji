import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiji/utilities/size_config.dart';

class JijiAppBar extends StatelessWidget {
  Widget build(BuildContext context) {
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
                    child: Container(
                      height: appBarHeight * 0.50,
                      width: SizeConfig.deviceWidth * 60,
                      child: TextField(
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
