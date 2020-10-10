import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:jiji/impl/impl.dart';
import 'package:jiji/models/user.dart';
import 'package:jiji/models/user_model.dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:jiji/utilities/theme_data.dart';
import 'package:jiji/widgets/bottom_nav.dart';
import 'package:jiji/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  String phoneOrEmail = "";
  String password = "";

  Future<void> _saveForm(BuildContext context) async {
    bool valid = _form.currentState.validate();
    if (valid) {
      setState(() {
        _isLoading = !_isLoading;
      });
      _form.currentState.save();
      print(phoneOrEmail);
      print(password);
      final Map<String, dynamic> response = await Impl().checkCredentials({
        "email": phoneOrEmail,
        "password": password,
      });

      print(response["statusCode"]);

      if (response["statusCode"] != 200) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response["errors"],
              style: TextStyle(
                color: MyThemeData.primaryColor,
                fontSize: SizeConfig.deviceHeight * 1.7,
              ),
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.black.withOpacity(0.8),
          ),
        );
        setState(() {
          _isLoading = !_isLoading;
        });
      } else {
        final UserModel userModel = UserModel(
          token: response['token'],
          uid: response['user']['_id'],
          name: response['user']['name'],
          emailId: response['user']['email'],
          phone: response['user']['phone'],
          role: response['user']['role'],
          password: password,
        );
        // Provider.of<User>(context, listen: false).updateUser(userModel);
        _saveUserToHive(userModel);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNav(),
          ),
          (Route<dynamic> route) => false,
        );

        print("object");
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: SizeConfig.deviceWidth * 5,
            right: SizeConfig.deviceWidth * 5,
            top: SizeConfig.deviceHeight * 8,
          ),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.deviceHeight * 2),
                Text(
                  'SIGN IN',
                  style: TextStyle(
                    fontSize: SizeConfig.deviceHeight * 2,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Pacifico",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.deviceHeight * 4),
                  child: Text(
                    "Welcome back to the community!",
                    style: TextStyle(
                        fontSize: SizeConfig.deviceHeight * 1.5,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: SizeConfig.deviceHeight * 7),
                CustomTextField(
                  value: phoneOrEmail,
                  onSaved: (value) => setState(() => phoneOrEmail = value),
                  validator: (value) {
                    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                    RegExp regExp = new RegExp(patttern);
                    if (value.length == 0) {
                      return 'Please enter mobile number';
                    }
                    if (!regExp.hasMatch(value)) {
                      if (RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) return null;
                      return 'Please enter valid data';
                    }
                    return null;
                  },
                  hintText: 'Phone or Email',
                  textInputType: TextInputType.text,
                  aspectRatioValue: 8,
                ),
                SizedBox(height: SizeConfig.deviceHeight * 3),
                CustomTextField(
                  value: password,
                  onSaved: (value) => setState(() => password = value),
                  validator: (value) {
                    if (value.isEmpty) return 'Enter Password';
                    if (value.toString().length < 6)
                      return "Please enter valid password";
                    return null;
                  },
                  hintText: 'Password',
                  textInputType: TextInputType.text,
                  aspectRatioValue: 8,
                ),
                SizedBox(height: SizeConfig.deviceHeight * 7),
                Container(
                  child: AspectRatio(
                    aspectRatio: 8,
                    child: Builder(
                      builder: (context) =>
                          buildButtonContainer(_saveForm, context, _isLoading),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.deviceHeight * 4),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.deviceHeight * 1.4,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.deviceHeight * 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Not a Member yet?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.deviceHeight * 1.5,
                      ),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "SIGN UP",
                      style: TextStyle(
                        color: MyThemeData.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.deviceHeight * 1.5,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveUserToHive(UserModel userModel) {
    final Box<UserModel> _userBox =
        Provider.of<Box<UserModel>>(context, listen: false);
    print('Saving user ${userModel.name}...');
    _userBox.add(userModel);
  }

  Widget buildButtonContainer(
      Function signInFunc, BuildContext context, bool isLoading) {
    return InkWell(
      onTap: () {
        
        signInFunc(context);
      },
      child: isLoading
          ? Center(child: CircularProgressIndicator(),)
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Hexcolor("#3DB83A"),
              ),
              child: Center(
                child: Text(
                  "SIGN IN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.deviceHeight * 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
    );
  }
}
