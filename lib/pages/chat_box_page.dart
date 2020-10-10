import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiji/controllers/chat/dmController.dart';
import 'package:jiji/widgets/jiji_app_bar.dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class ChatBoxPage extends StatefulWidget {
  final String recId;
  final String name;
  ChatBoxPage({this.recId, this.name});

  @override
  _ChatBoxPageState createState() => _ChatBoxPageState();
}

class _ChatBoxPageState extends State<ChatBoxPage> {
  final DmController _dmController = Get.put(DmController());
  Timer timer;
  @override
  void initState() {
    super.initState();
    _dmController.msgController = TextEditingController();
    _dmController.getHistory(widget.recId);
    timer = Timer.periodic(Duration(seconds: 5),
        (Timer t) => _dmController.getHistory(widget.recId));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

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
              Container(
                height: SizeConfig.deviceHeight * 15,
                color: Hexcolor("#F0F0F0"),
                child: Padding(
                  padding: EdgeInsets.only(left: SizeConfig.deviceWidth * 7),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: SizeConfig.deviceWidth * 5,
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.deviceWidth * 5,
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/profile_image.jpg'),
                        radius: SizeConfig.deviceWidth * 7.5,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: SizeConfig.deviceWidth * 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
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
              ),
              SizedBox(
                height: SizeConfig.deviceHeight * 5,
              ),
              Obx(
                () => Padding(
                  padding: EdgeInsets.only(bottom: Get.height / 3.4),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _dmController.chatData == null
                        ? 0
                        : _dmController.chatData.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                        child: MessageWidget(
                          message: _dmController.chatData[index]['body'],
                          time: DateFormat.Hm().format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(_dmController.chatData[index]['date']),
                            ),
                          ),
                          clientMessage: _dmController.uid.value ==
                                  _dmController.chatData[index]['from']
                              ? true
                              : false,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sendMessageWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: SizeConfig.deviceWidth * 9),
      child: Container(
        height: SizeConfig.deviceHeight * 6,
        decoration: BoxDecoration(
            color: Hexcolor("#F0F0F0"),
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
                  width: SizeConfig.deviceWidth * 70,
                  child: TextField(
                    controller: _dmController.msgController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        icon: Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                          size: SizeConfig.deviceWidth * 5,
                        ),
                        hintText: "Enter Message",
                        fillColor: Colors.grey),
                  ),
                )
              ],
            ),
            CircleAvatar(
              radius: SizeConfig.deviceWidth * 5,
              backgroundColor: Hexcolor("3DB83A"),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: SizeConfig.deviceWidth * 5,
                ),
                onPressed: () {
                  _dmController.personalChat(
                    _dmController.msgController.text,
                    widget.recId,
                  );
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final bool clientMessage;
  final String time;
  final String message;

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
                  color: Hexcolor("#F0F0F0"),
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
