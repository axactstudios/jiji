import 'package:flutter/material.dart';
import 'package:jiji/impl/impl.dart';
import 'package:jiji/pages/signin_page.dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:jiji/utilities/theme_data.dart';
import 'package:jiji/widgets/custom_textfield.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String phone = "";
  String firstName = "";
  String lastName = "";
  String password = "";
  String emailId = "";
  final _form = GlobalKey<FormState>();
  double textSize;
  bool _isLoading = false;

  Future<void> _saveForm(BuildContext context) async {
    bool valid = _form.currentState.validate();
    if (valid) {
      setState(() {
        _isLoading = !_isLoading;
      });
      _form.currentState.save();
      print(firstName + " " + lastName);
      print(password);
      print(emailId);
      print(phone);
      final Map<String, dynamic> response = await Impl().registerUser({
        "name": firstName.trim() + " " + lastName.trim(),
        "email": emailId.trim(),
        "password": password.trim(),
        "password1": password.trim(),
        "phone": phone.trim(),
      });
      print(response);
      if (response["statusCode"] != 200)
        await showDialog(
          context: context,
          child: AlertDialog(
            title: Text(
              response["message"],
              style: TextStyle(
                color: Colors.black,
                fontSize: textSize * 1.2,
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
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
      if (response["statusCode"] == 200)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      else {
        setState(() {
          _isLoading = !_isLoading;
        });
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            response["errors"],
            style: TextStyle(
              color: MyThemeData.primaryColor,
              fontSize: textSize,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black.withOpacity(0.8),
        ));
      }
      print(response["errors"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final deviceHorizontalPadding = SizeConfig.deviceWidth * 4;
    final availableWidthSpace =
        (SizeConfig.deviceWidth * 100) - (2 * deviceHorizontalPadding);
    textSize = availableWidthSpace * 0.03;
    final pHeight = MediaQuery.of(context).size.height;
    final pWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceHorizontalPadding),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: pHeight * 0.05,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Text(
                'SIGN UP',
                style: TextStyle(
                  fontSize: textSize * 1.5,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Pacifico",
                ),
              ),
              SizedBox(
                height: pHeight * 0.02,
              ),
              Container(
                width: pWidth,
                child: Text(
                  'Join a wonderful community!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: textSize * 1.2,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: pHeight * 0.07,
              ),
              AspectRatio(
                aspectRatio: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: availableWidthSpace * 0.48,
                      child: CustomTextField(
                        value: firstName,
                        onSaved: (value) => setState(() => firstName = value),
                        validator: (value) {
                          if (value.isEmpty) return 'Enter First Name';
                          if (value.toString().length < 2)
                            return 'Enter valid Name';
                          return null;
                        },
                        hintText: 'First Name',
                        textInputType: TextInputType.text,
                        isAspectRatio: false,
                      ),
                    ),
                    SizedBox(
                      width: availableWidthSpace * 0.48,
                      child: CustomTextField(
                        value: lastName,
                        onSaved: (value) => setState(() => lastName = value),
                        validator: (value) {
                          if (value.isEmpty) return 'Enter Last Name';
                          if (value.toString().length < 2)
                            return 'Enter valid Last Name';
                          return null;
                        },
                        hintText: 'Last Name',
                        textInputType: TextInputType.text,
                        isAspectRatio: false,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: pHeight * 0.02,
              ),
              CustomTextField(
                value: emailId,
                onSaved: (value) => setState(() => emailId = value),
                validator: (value) {
                  if (value.isEmpty) return 'Enter Email';
                  if (!value.toString().contains("@") ||
                      !value.toString().toLowerCase().contains(".com") ||
                      (value.toString().length < 7)) return "Enter Valid Email";
                  return null;
                },
                hintText: 'Email',
                textInputType: TextInputType.text,
                aspectRatioValue: 8,
              ),
              SizedBox(
                height: pHeight * 0.02,
              ),
              CustomTextField(
                value: phone,
                onSaved: (value) => setState(() => phone = value),
                validator: (value) {
                  if (value.isEmpty) return 'Enter phone number';
                  if (value.toString().length < 10)
                    return 'Enter valid phone number';
                  return null;
                },
                hintText: 'Phone',
                textInputType: TextInputType.number,
                aspectRatioValue: 8,
              ),
              SizedBox(
                height: pHeight * 0.02,
              ),
              CustomTextField(
                value: password,
                onSaved: (value) => setState(() => password = value),
                validator: (value) {
                  if (value.isEmpty) return 'Enter Password';
                  if (value.toString().length < 7)
                    return 'Password must be more than 6 characters';
                  return null;
                },
                hintText: 'Password',
                textInputType: TextInputType.text,
                aspectRatioValue: 8,
              ),
              SizedBox(
                height: pHeight * 0.04,
              ),
              Builder(
                builder: (context) => AspectRatio(
                  aspectRatio: 9,
                  child: ButtonTheme(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: FlatButton(
                      onPressed: () async => await _saveForm(context),
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              "SIGN UP",
                              style: TextStyle(
                                fontSize: textSize * 1.2,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                      color:
                          _isLoading ? Colors.white54 : MyThemeData.primaryColor,
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: pHeight * 0.3,
              // ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Already a Member?",
                        style: TextStyle(fontSize: textSize),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "SIGN IN",
                        style: TextStyle(
                          color: MyThemeData.primaryColor,
                          fontSize: textSize * 1.1,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.deviceHeight * 4,
              )
            ],
          ),
        ),
      ),
    );
  }
}
