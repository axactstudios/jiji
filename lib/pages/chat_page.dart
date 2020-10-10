import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiji/controllers/chat/chatController.dart';
import 'package:jiji/widgets/jiji_app_bar.dart';
import 'package:jiji/pages/chat_box_page.dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());

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
        vertical: SizeConfig.deviceHeight * 1.5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'CHATS',
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.deviceHeight * 1.5,
            ),
          ),
          ChatCounter(
            avatarSize: SizeConfig.deviceWidth * 3.35,
            count: 40,
          ),
        ],
      ),
    );
  }
}

class ChatCounter extends StatelessWidget {
  final int count;
  final double avatarSize;
  ChatCounter({this.count, this.avatarSize});

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
  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: Obx(
        () => ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:
              chatController.data == null ? 0 : chatController.data.length,
          itemBuilder: (context, index) {
            int timeInMillis = int.parse(chatController.data[index]['date']);
            var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
            var formattedDate = DateFormat.Hm().format(date);

            return GestureDetector(
              onTap: () {
                if (chatController.uid.value ==
                    chatController.data[index]['recipientObj'].first['_id']) {
                  var id =
                      chatController.data[index]['recipientObj'].last['_id'];
                  print(id);
                  var name =
                      chatController.data[index]['recipientObj'].last['name'];
                  Get.to(ChatBoxPage(
                    recId: id,
                    name: name,
                  ));
                } else {
                  var id =
                      chatController.data[index]['recipientObj'].first['_id'];
                  print(id);
                  var name =
                      chatController.data[index]['recipientObj'].first['name'];
                  Get.to(ChatBoxPage(
                    recId: id,
                    name: name,
                  ));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Hexcolor("#F0F0F0"))),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.deviceHeight * 2,
                      horizontal: SizeConfig.deviceWidth * 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/profile_image.jpg'),
                        radius: SizeConfig.deviceWidth * 6.5,
                      ),
                      Container(
                        width: SizeConfig.deviceWidth * 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chatController
                                  .data[index]['recipientObj'].last['name'],
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
                              chatController.data[index]['lastMessage'],
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
                            formattedDate,
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
                            avatarSize: SizeConfig.deviceWidth * 3,
                            count: 5,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
