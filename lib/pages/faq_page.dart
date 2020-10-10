import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:jiji/widgets/jiji_app_bar.dart';

class FaqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(SizeConfig.deviceHeight * 10),
            child: JijiAppBar()),
        body: SingleChildScrollView(
          child: Column(
            children: [
              backPressWidget(context),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 14,
                  itemBuilder: (context, count) {
                    return CustomExpansionTile();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget backPressWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Hexcolor("F0F0F0"),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.deviceWidth * 5,
              top: SizeConfig.deviceHeight * 1,
              bottom: SizeConfig.deviceHeight * 1),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Hexcolor("3A3A3A"),
                size: SizeConfig.deviceWidth * 2.75,
              ),
              SizedBox(
                width: SizeConfig.deviceWidth * 1,
              ),
              Text(
                'Settings',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.deviceWidth * 3.5),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomExpansionTile extends StatelessWidget {
  final String childText =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
      "Praesent auctor porta sem, et dictum neque porttitor non. Donec id tellus"
      " nec elit efficitur finibus. Sed vel eros et sem auctor molestie. Vestibulum"
      " tempor leo quis metus aliquam feugiat. Pellentesque in condimentum tortor,"
      " at varius ipsum. Nunc sed congue justo, in posuere velit. Vivamus arcu nibh,"
      " mollis ut semper eu, laoreet sed ex. Mauris nec dictum sapien, ut vulputate mi.";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Hexcolor("#F0F0F0"))),
      child: ExpansionTile(
        title: Padding(
          padding: EdgeInsets.only(
              top: SizeConfig.deviceHeight * 1.5,
              bottom: SizeConfig.deviceHeight * 1.5,
              left: SizeConfig.deviceWidth * 4),
          child: Text(
            'Question',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.deviceHeight * 2.5),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.deviceWidth * 5,
                vertical: SizeConfig.deviceHeight * 2),
            child: Text(childText),
          )
        ],
      ),
    );
  }
}
