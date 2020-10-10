import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiji/widgets/bottom_nav.dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final pHeight = MediaQuery.of(context).size.height;
    final pWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: pHeight * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'OTP',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: pHeight * 0.035,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: pHeight * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: pWidth,
                    child: Text(
                      'Confirm your One Time Password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.65),
                          fontFamily: 'Roboto',
                          fontSize: pHeight * 0.026),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: pHeight * 0.065,
              ),
              Container(
                height: SizeConfig.deviceHeight * 5,
                child: OTPTextField(
                  length: 4,
                  width: MediaQuery.of(context).size.width * 0.8,
                  fieldWidth: SizeConfig.deviceWidth * 10,
                  style: TextStyle(
                    fontSize: SizeConfig.deviceWidth * 5,
                  ),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onCompleted: (pin) {
                    print("Completed: " + pin);
                  },
                ),
              ),
              SizedBox(
                height: pHeight * 0.05,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNav(),
                    ),
                  );
                },
                child: Container(
                  width: pWidth * 0.85,
                  height: pHeight * 0.055,
                  decoration: BoxDecoration(
                      color: Hexcolor("#3DB83A"),
                      borderRadius: BorderRadius.circular(5)
                      // color: kPrimaryColor
                      ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "CONFIRM",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.deviceHeight * 2.25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: pHeight * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Resending code in 01:03',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Roboto',
                        fontSize: pHeight * 0.020),
                  ),
                  SizedBox(
                    width: pWidth * 0.01,
                  ),
                ],
              ),
              SizedBox(
                height: pHeight * 0.03,
              ),
              Text('Resend code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Hexcolor("#3DB83A"),
                    fontFamily: 'Roboto',
                    fontSize: pHeight * 0.020,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
