import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiji/models/UserProfile.dart';
import 'package:jiji/pages/edit_profile_page.dart';
import 'package:jiji/pages/faq_page.dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:jiji/utilities/theme_data.dart';
import 'package:jiji/widgets/jiji_app_bar.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // UserProfile userProfile;
  @override
  void initState() {
    super.initState();
  }

  void updateUser(UserProfile updatedUserProfile) {
    final UserProfile userProfile =
        Provider.of<UserProfile>(context, listen: false)
          ..updateObject(updatedUserProfile);
    print(userProfile.name);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final UserProfile userProfile =
        Provider.of<UserProfile>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.deviceHeight * 10),
          child: JijiAppBar(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TopRowWidget(userProfile: userProfile),
              ColouredHeading(
                title: "ACCOUNT AND PROFILE",
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                          userProfile: userProfile, updateUser: updateUser),
                    ),
                  );
                },
                child: StrechedButton(
                  label: "Edit Profile",
                ),
              ),
              MaterialButton(
                onPressed: () {},
                child: StrechedButton(
                  label: "Change Email",
                ),
              ),
              MaterialButton(
                onPressed: () {},
                child: StrechedButton(
                  label: "Reset Password",
                ),
              ),
              ColouredHeading(
                title: "CONTACT AND SUPPORT",
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => FaqPage()));
                },
                child: StrechedButton(
                  label: "FAQ",
                ),
              ),
              MaterialButton(
                onPressed: () {},
                child: StrechedButton(
                  label: "Send Feedback",
                ),
              ),
              MaterialButton(
                onPressed: () {},
                child: StrechedButton(
                  label: "Contact Us",
                ),
              ),
              ColouredHeading(
                title: "RATE AND SHARE",
              ),
              MaterialButton(
                onPressed: () {},
                child: StrechedButton(
                  label: "Rate us on AppStore",
                ),
              ),
              MaterialButton(
                onPressed: () {},
                child: StrechedButton(
                  label: "Share with friends",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StrechedButton extends StatelessWidget {
  String label;

  StrechedButton({
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: MyThemeData.inputPlaceHolder,
            width: 0.2,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.deviceHeight * 2.25,
            horizontal: SizeConfig.deviceWidth * 5),
        child: Container(
            width: double.infinity,
            child: Text(
              label,
              style: TextStyle(
                color: Hexcolor("#3A3A3A"),
                fontSize: SizeConfig.deviceHeight * 1.6,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
    );
  }
}

class ColouredHeading extends StatelessWidget {
  final String title;

  ColouredHeading({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.deviceWidth * 100,
      color: Hexcolor("3DB83A"),
      child: Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.deviceWidth * 5,
            top: SizeConfig.deviceHeight * 0.5,
            bottom: SizeConfig.deviceHeight * 0.5),
        child: Text(
          '$title',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.deviceHeight * 1.5),
        ),
      ),
    );
  }
}

class TopRowWidget extends StatelessWidget {
  final UserProfile userProfile;
  const TopRowWidget({
    Key key,
    this.userProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final UserProfile userProfile = Provider.of<UserProfile>(context);
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.deviceWidth * 5,
            bottom: SizeConfig.deviceHeight * 4,
            top: SizeConfig.deviceHeight * 4),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Hexcolor("3DB83A"),
              ),
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.deviceWidth * 8.5 * 0.05),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile_image.jpg'),
                  radius: SizeConfig.deviceWidth * 8.5,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.deviceWidth * 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userProfile != null ? userProfile.name : "",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.deviceHeight * 2.75),
                  ),
                  SizedBox(
                    height: SizeConfig.deviceHeight * 1,
                  ),
                  Text(
                    userProfile == null
                        ? ""
                        : (userProfile.city + " ," + userProfile.state),
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.deviceHeight * 2,
                    ),
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
