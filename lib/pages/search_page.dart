import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiji/components/jijiappbar.dart';
import 'package:jiji/utilities/size_config.dart';

class SearchPage extends StatelessWidget {

  bool resultsFound = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: JijiAppBar(),
          preferredSize: Size.fromHeight(SizeConfig.deviceHeight * 10),
        ),
        body: resultsFound==true ? Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeConfig.deviceHeight * 1,
            ),
            searchHistoryTitleWidget(),
            SizedBox(
              height: SizeConfig.deviceHeight * 1,
            ),
            SearchHistoryList(),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.deviceWidth * 5,
                  top: SizeConfig.deviceHeight * 3),
              child: Text(
                'RECOMMENDED',
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.deviceHeight * 1.45),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.deviceWidth * 5,
                  top: SizeConfig.deviceHeight * 2),
              child: Row(
                children: [
                  customChip('Phones'),
                  customChip('Books'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.deviceWidth * 5,
                  top: SizeConfig.deviceHeight * 2),
              child: Row(
                children: [
                  customChip('Tools'),
                  customChip('Televisons'),
                ],
              ),
            )
          ],
        ) : NoResultsFound(),
      ),
    );
  }

  Widget customChip(String title) {
    return Padding(
      padding:  EdgeInsets.only(left: SizeConfig.deviceWidth*4),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.5),width: 2)
        ),
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.deviceWidth * 7.5,
              vertical: SizeConfig.deviceWidth * 2,
            ),
            child: Text('$title',style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.deviceHeight * 1.75),),
        ),
      ),
    );
  }

  Widget searchHistoryTitleWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.deviceWidth * 5,
          vertical: SizeConfig.deviceHeight * 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SEARCH HISTORY',
            style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.deviceHeight * 1.5),
          ),
          Text(
            'CLEAR',
            style: TextStyle(
                color: Hexcolor("3DB83A"),
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.deviceHeight * 1.5),
          ),
        ],
      ),
    );
  }
}

class SearchHistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        SearchHistoryTile(
          title: 'Mobiles',
        ),
        SearchHistoryTile(
          title: 'Phones',
        ),
        SearchHistoryTile(
          title: 'Cameras',
        ),
      ],
    );
  }
}

class SearchHistoryTile extends StatelessWidget {
  String title;

  SearchHistoryTile({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Hexcolor("#F0F0F0"))),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.deviceWidth * 5,
          vertical: SizeConfig.deviceHeight * 1.75,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$title',
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.deviceHeight * 1.85),
            ),
            Icon(
              Icons.clear,
              size: SizeConfig.deviceWidth * 5,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}

class NoResultsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
          vertical: SizeConfig.deviceWidth * 5
      ),
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

