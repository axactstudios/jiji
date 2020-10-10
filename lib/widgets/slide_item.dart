import 'package:flutter/material.dart';
import 'package:jiji/utilities/size_config.dart';

import '../models/slide.dart';

class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: SizeConfig.deviceWidth * 100,
          height: SizeConfig.deviceHeight * 30,
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(slideList[index].imageUrl),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.deviceHeight * 3,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              slideList[index].title,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: SizeConfig.deviceHeight * 4,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto'),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.deviceHeight * 3,
        ),
        Text(
          slideList[index].description,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: SizeConfig.deviceHeight * 2.3,
              fontFamily: 'Roboto'),
        ),
      ],
    );
  }
}
