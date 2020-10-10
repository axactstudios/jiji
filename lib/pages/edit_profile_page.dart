import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:jiji/data/network/api_helper.dart';
import 'package:jiji/models/UserProfile.dart';
import 'package:jiji/models/user_model.dart';
import 'package:jiji/utilities/theme_data.dart';
import 'package:jiji/widgets/custom_textfield.dart';
import 'package:jiji/widgets/jiji_app_bar.dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile userProfile;
  final Function updateUser;

  const EditProfilePage({Key key, this.userProfile, this.updateUser})
      : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState(userProfile);
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UserProfile userProfile;
  String firstName;
  String lastName;
  String location;
  double textSize;
  // final UserProfile userProfile;
  final _form = GlobalKey<FormState>();

  _EditProfilePageState(this.userProfile);

  // _EditProfilePageState(this.userProfile);
  @override
  void initState() {
    final name = userProfile.name.split(" ");
    firstName = name[0];
    lastName = name.length == 2 ? name[1] : "";
    location = userProfile.city + ", " + userProfile.state;
    super.initState();
  }

  Future<void> _saveForm(BuildContext context) async {
    bool valid = _form.currentState.validate();
    if (valid) {
      _form.currentState.save();
      final l = location.trim().split(",");
      // print(firstName + " " + lastName);
      String city = l[0].trim();
      String state = l[1].trim();
      final Box<UserModel> _userBox =
          Provider.of<Box<UserModel>>(context, listen: false);
      final UserModel userModel = _userBox.values.first;
      Map<String, dynamic> para = {
        "name": firstName.trim() + " " + lastName.trim(),
        "city": city,
        "state": state,
      };
      Map<String, String> header = {
        "Authorization": "Bearer " + userModel.token,
        "Content-Type": "application/json",
      };
      final response = await ApiHelper().putWithHeadersInputs(
        "https://olx-app-jiji.herokuapp.com/api/user/${userModel.uid}",
        para,
        header,
      );
      widget.updateUser(UserProfile.fromJson(response));
      await showDialog(
        context: context,
        child: AlertDialog(
          title: Text(
            "User Profile Successfully Updated",
            style: TextStyle(
              color: Colors.black,
              fontSize: textSize * 1.2,
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'Okay',
                style: TextStyle(
                  color: MyThemeData.primaryColor,
                  fontSize: textSize,
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final deviceHorizontalPadding = SizeConfig.deviceWidth * 4;
    final availableWidthSpace =
        (SizeConfig.deviceWidth * 100) - (2 * deviceHorizontalPadding);
    textSize = availableWidthSpace * 0.03;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.deviceHeight * 10),
          child: JijiAppBar(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.deviceWidth * 4,
            ),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  backPressWidget(context),
                  SizedBox(
                    height: SizeConfig.deviceHeight * 5,
                  ),
                  Center(child: ProfileImage()),
                  SizedBox(
                    height: SizeConfig.deviceHeight * 5,
                  ),
                  Text(
                    'Edit Personal Information',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.deviceWidth * 3.5,
                    ),
                  ),
                  SizedBox(height: SizeConfig.deviceHeight * 2),
                  AspectRatio(
                    aspectRatio: 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: availableWidthSpace * 0.48,
                          child: CustomTextField(
                            value: firstName,
                            onSaved: (value) =>
                                setState(() => firstName = value),
                            validator: (value) {
                              if (value.isEmpty) return 'Enter First Name';
                              if (value.toString().length < 2)
                                return 'Enter valid Name';
                              return null;
                            },
                            hintText: 'First Name',
                            textInputType: TextInputType.text,
                            isAspectRatio: false,
                            aspectRatioValue: 7,
                          ),
                        ),
                        SizedBox(
                          width: availableWidthSpace * 0.48,
                          child: CustomTextField(
                            value: lastName,
                            onSaved: (value) =>
                                setState(() => lastName = value),
                            validator: (value) {
                              if (value.isEmpty) return 'Enter Last Name';
                              if (value.toString().length < 2)
                                return 'Enter valid Last Name';
                              return null;
                            },
                            hintText: 'Last Name',
                            textInputType: TextInputType.text,
                            isAspectRatio: false,
                            aspectRatioValue: 7,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.deviceHeight * 2),
                  CustomTextField(
                    value: location,
                    onSaved: (value) => setState(() => location = value),
                    validator: (value) {
                      if (value.isEmpty) return 'Enter city, state';
                      if (!value.toString().contains(","))
                        return "Enter both city, state";
                      return null;
                    },
                    hintText: 'City, State',
                    textInputType: TextInputType.text,
                    aspectRatioValue: 7,
                  ),
                  SizedBox(
                    height: SizeConfig.deviceHeight * 3,
                  ),
                  Builder(
                    builder: (context) => AspectRatio(
                      aspectRatio: 7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Hexcolor("3DB83A"), width: 2),
                                borderRadius: BorderRadius.circular(5)),
                            width: availableWidthSpace * 0.45,
                            child: MaterialButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Center(
                                child: Text(
                                  'CANCEL',
                                  style: TextStyle(
                                      color: Hexcolor("3DB83A"),
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      fontSize: SizeConfig.deviceWidth * 3.75),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Hexcolor("3DB83A"),
                                borderRadius: BorderRadius.circular(5)),
                            width: availableWidthSpace * 0.45,
                            child: MaterialButton(
                              onPressed: () => _saveForm(context),
                              child: Center(
                                child: Text(
                                  'SAVE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      fontSize: SizeConfig.deviceWidth * 3.75),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget personalInfoEditTexts() {
  //   return Padding(
  //     padding: EdgeInsets.only(left: SizeConfig.deviceWidth * 5),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Edit Personal Information',
  //           style: TextStyle(
  //               color: Colors.grey,
  //               fontFamily: 'Roboto',
  //               fontWeight: FontWeight.bold,
  //               fontSize: SizeConfig.deviceWidth * 3.5),
  //         ),
  //         SizedBox(
  //           height: SizeConfig.deviceHeight * 3,
  //         ),
  //         AspectRatio(
  //           aspectRatio: 8,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               CustomTextField(value: null, onSaved: null, validator: null, hintText: null, textInputType: null)
  //             ],
  //           ),
  //         ),
  //         SizedBox(
  //           height: SizeConfig.deviceHeight * 3,
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(right: SizeConfig.deviceWidth * 5),
  //           child: Container(
  //             height: SizeConfig.deviceHeight * 7,
  //             child: TextField(
  //                 decoration: InputDecoration(
  //               filled: true,
  //               hintText: "Goa, GA",
  //               hintStyle: TextStyle(
  //                 color: Colors.grey,
  //                 fontSize: SizeConfig.deviceWidth * 3.5,
  //               ),
  //               suffixIcon: Icon(
  //                 Icons.my_location,
  //                 color: Colors.grey,
  //               ),
  //               border: OutlineInputBorder(
  //                 borderSide: BorderSide.none,
  //                 // borderRadius: BorderRadius.circular(0),
  //               ),
  //             )),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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

class ProfileImage extends StatelessWidget {
  final double avatarRadius = SizeConfig.deviceWidth * 15;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Hexcolor("3DB83A"),
          ),
          child: Padding(
            padding: EdgeInsets.all(avatarRadius * 0.05),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/profile_image.jpg'),
              radius: avatarRadius,
            ),
          ),
        ),
        // Positioned(
        //   top: avatarRadius * 1.2,
        //   left: avatarRadius * 1.5,
        //   child: Container(
        //     width: SizeConfig.deviceWidth * 7.5,
        //     child: FloatingActionButton(
        //       onPressed: null,
        //       elevation: 0,
        //       child: Icon(
        //         Icons.add,
        //         color: Colors.black,
        //         size: SizeConfig.deviceWidth * 4,
        //       ),
        //       backgroundColor: Hexcolor("F0F0F0"),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
