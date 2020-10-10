import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:jiji/models/categories_list.dart';
import 'package:jiji/models/user_model.dart';
import 'package:jiji/models/user_posts.dart';
import 'package:jiji/pages/onboarding_page.dart';
import 'package:jiji/widgets/bottom_nav.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'impl/impl.dart';
import 'models/subcategories_list.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Box<UserModel> _userBox = await _hiveSetup();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Hexcolor("#3DB83A"), // status bar color
    ),
  );
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp(userBox: _userBox));
}

Future<Box<UserModel>> _hiveSetup() async {
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(UserModelAdapter());
  final Box<UserModel> _userBox = await Hive.openBox<UserModel>('userModel');

  return _userBox;
}

Future<Box<UserModel>> _saveUserToHive(
    UserModel userModel, Box<UserModel> _userBox) async {
  // final Box<UserModel> _userBox =
  //     Provider.of<Box<UserModel>>(context, listen: false);

  print('Saving user ${userModel.name}...');
  // print(_userBox.length);
  await _userBox.clear();
  // print(_userBox.length);
  await _userBox.add(userModel);
  // print(_userBox.length);
  return _userBox;
}

Future<Box<UserModel>> _tryLogin(Box<UserModel> _userBox) async {
  final Map<String, dynamic> response = await Impl().checkCredentials({
    "email": _userBox.values.first.emailId,
    "password": _userBox.values.first.password,
  });
  print(response);
  if (response["statusCode"] != 200) {
    await _userBox.clear();
  } else {
    final UserModel userModel = UserModel(
      token: response['token'],
      uid: response['user']['_id'],
      name: response['user']['name'],
      emailId: response['user']['email'],
      phone: response['user']['phone'],
      role: response['user']['role'],
      password: _userBox.values.first.password,
    );
    // Provider.of<User>(context, listen: false).updateUser(userModel);
    _userBox = await _saveUserToHive(userModel, _userBox);
  }
  return _userBox;
}

class MyApp extends StatefulWidget {
  Box<UserModel> userBox;
  MyApp({this.userBox});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    tryAutoLogin();
    super.initState();
  }

  tryAutoLogin() async {
    if (widget.userBox.isNotEmpty)
      widget.userBox = await _tryLogin(widget.userBox);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Box<UserModel>>(create: (context) => widget.userBox),
        Provider<User>(
          create: (context) => User()..updateUser(widget.userBox.values.first),
        ),
        Provider<Categories>(
          create: (context) => Categories()..initialiseData(),
        ),
        Provider<SubCategories>(
          create: (context) => SubCategories()..initialiseData(),
        ),
        Provider<UserPosts>(
          create: (context) => UserPosts(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Jiji',
        theme: ThemeData(
          primarySwatch: Colors.green,
          hintColor: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: widget.userBox.isEmpty ? '/login' : '/home',
        routes: {
          '/login': (context) => GettingStartedScreen(),
          '/home': (context) => BottomNav(),
        },
      ),
    );
  }
}
