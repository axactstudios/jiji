import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiji/components/jijiappbar.dart';
import 'package:jiji/utilities/size_config.dart';

class ChatBoxPage extends StatelessWidget {
  List<MessageWidget> conversationList = [
    MessageWidget(
      message: "Hi, How are you?",
      time: "10.03 AM",
      clientMessage: false,
    ),
    MessageWidget(
      message: "Hi, I’m fine. How are you?",
      time: "10.11 AM",
      clientMessage: true,
    ),
    MessageWidget(
      message: "Price is \$ 13000",
      time: "10.15 AM",
      clientMessage: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: sendMessageWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        appBar: PreferredSize(
          child: JijiAppBar(),
          preferredSize: Size.fromHeight(SizeConfig.deviceHeight * 10),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopRowWidget(),
              SizedBox(
                height: SizeConfig.deviceHeight * 5,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: conversationList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return conversationList[index];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sendMessageWidget() {

    final _messageController = TextEditingController();

    void _sendMessage() {
      if (_messageController.text != null) {
        conversationList.add(MessageWidget(
          message: _messageController.text.trim(),
          clientMessage: false,
          time: "10.50 AM",
        ));
      }
    }

    return Padding(
      padding: EdgeInsets.only(left: 0, right: SizeConfig.deviceWidth * 7),
      child: Container(
        height: SizeConfig.deviceHeight * 6,
        decoration: BoxDecoration(
            color: Colors.grey[400].withOpacity(0.5),
            borderRadius: BorderRadius.circular(SizeConfig.deviceWidth * 7)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: SizeConfig.deviceWidth * 2,
                ),
                Container(
                  width: SizeConfig.deviceWidth * 60,
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        icon: Icon(
                          Icons.attach_file,
                          color: Colors.black,
                          size: SizeConfig.deviceWidth * 5,
                        ),
                        hintText: "Enter Message"),
                  ),
                )
              ],
            ),
            CircleAvatar(
                radius: SizeConfig.deviceWidth * 5.5,
                backgroundColor: Hexcolor("3DB83A"),
                child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: SizeConfig.deviceWidth * 5,
                    ),
                    onPressed: _sendMessage)),
          ],
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  bool clientMessage;
  String time;
  String message;

  MessageWidget({this.clientMessage, this.time, this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.deviceWidth * 5,
          vertical: SizeConfig.deviceHeight * 1),
      child: Column(
        crossAxisAlignment:
            clientMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                clientMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        clientMessage ? Hexcolor("3DB83A") : Hexcolor("F0F0F0"),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(SizeConfig.deviceWidth * 3),
                    child: Text(
                      message,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: clientMessage ? Colors.white : Colors.black),
                    ),
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.deviceHeight * 0.75),
            child: Text(
              time,
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.deviceHeight * 1.35),
            ),
          )
        ],
      ),
    );
  }
}

class TopRowWidget extends StatelessWidget {
  const TopRowWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.deviceHeight * 15,
      color: Hexcolor("#F0F0F0"),
      child: Padding(
        padding: EdgeInsets.only(left: SizeConfig.deviceWidth * 7),
        child: Row(
          children: [
            Icon(
              Icons.arrow_back_ios,
              size: SizeConfig.deviceWidth * 5,
            ),
            SizedBox(
              width: SizeConfig.deviceWidth * 5,
            ),
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile_image.png'),
              radius: SizeConfig.deviceWidth * 7.5,
            ),
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.deviceWidth * 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amy James',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.deviceHeight * 2.5),
                  ),
                  SizedBox(
                    height: SizeConfig.deviceHeight * 1,
                  ),
                  Text(
                    'online',
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: SizeConfig.deviceHeight * 1.5),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
