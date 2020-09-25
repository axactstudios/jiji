import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiji/components/jijiappbar.dart';
import 'package:jiji/pages/chat_box_page.dart';
import 'package:jiji/utilities/size_config.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: JijiAppBar(),
          preferredSize: Size.fromHeight(SizeConfig.deviceHeight * 10),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.deviceHeight * 1,
              ),
              unreadChatsCounterWidget(),
              SizedBox(
                height: SizeConfig.deviceHeight * 1,
              ),
              ChatList()
            ],
          ),
        ),
      ),
    );
  }

  Widget unreadChatsCounterWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.deviceWidth * 5,
          vertical: SizeConfig.deviceHeight * 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'CHATS',
            style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.deviceHeight * 1.5),
          ),
          ChatCounter(avatarSize: SizeConfig.deviceWidth*3.35,count: 40,),
        ],
      ),
    );
  }
}

class ChatCounter extends StatelessWidget {

  int count;
  double avatarSize;
  ChatCounter({this.count,this.avatarSize}) ;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Hexcolor("#3DB83A"),
      child: Text(
        '$count',
        style: TextStyle(
          color: Colors.white,
          fontSize: SizeConfig.deviceHeight * 1.25,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
        ),
      ),
      radius: avatarSize,
    );
  }
}

class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        ChatTile(),
        ChatTile(),
        ChatTile(),
        ChatTile(),
        ChatTile(),
        ChatTile(),
        ChatTile(),
        ChatTile(),
        ChatTile(),
      ],
    );
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatBoxPage()));
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Hexcolor("#F0F0F0"))),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.deviceHeight * 2,
              horizontal: SizeConfig.deviceWidth * 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: SizeConfig.deviceWidth * 7.5,
                backgroundImage: AssetImage('assets/profile_image.png'),
              ),
              Container(
                width: SizeConfig.deviceWidth * 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amy James',
                      style: TextStyle(
                        color: Hexcolor("#3A3A3A"),
                        fontSize: SizeConfig.deviceHeight * 1.85,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.deviceHeight * 1,
                    ),
                    Text(
                      'Hi I am reaching out regarding the functionalty of bolt and screws',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Hexcolor("#A3A3A3"),
                        fontSize: SizeConfig.deviceHeight * 1.5,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '10.10 AM',
                    style: TextStyle(
                      color: Hexcolor("#A3A3A3"),
                      fontSize: SizeConfig.deviceHeight * 1.45,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.deviceHeight * 1.5,
                  ),
                  ChatCounter(
                    avatarSize: SizeConfig.deviceWidth*3,
                    count: 5,
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
