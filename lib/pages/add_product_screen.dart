import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiji/constants/global.dart';
import 'package:jiji/models/product.dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:jiji/utilities/theme_data.dart';
import 'package:jiji/widgets/custom_dropdrown.dart';
import 'package:jiji/widgets/custom_textfield.dart';
import 'package:jiji/widgets/item_images.dart';
import 'package:jiji/widgets/jiji_app_bar.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

class AddProductScreen extends StatefulWidget {
  static String routeName = '/AddProductScreen';
  final MyProductModel product;

  const AddProductScreen({Key key, this.product}) : super(key: key);
  @override
  _AddProductScreenState createState() => _AddProductScreenState(product);
}

class _AddProductScreenState extends State<AddProductScreen> {
  List<String> _states = [];
  List<String> _cities = [];
  List<String> _categories = [];
  List<String> _subCategories = [];
  List<File> images = [];
  final _form = GlobalKey<FormState>();
  String title;
  double price;
  String description;
  String state;
  String city;
  String category;
  String subCategory;
  double textSize;

  MyProductModel _product;
  final picker = ImagePicker();

  _AddProductScreenState(this._product);
  @override
  void initState() {
    _states.add("Maharashtra");
    _states.add("UP");
    _states.add("Kerela");
    _states.add("Delhi");
    _states.add("Goa");
    _cities.add("Pune");
    _cities.add("Mumbai");
    _cities.add("Banglore");
    _categories.add("Electronics");
    _categories.add("Gadgets");
    _categories.add("Other");
    _subCategories.add("Smart Watches");
    _subCategories.add("Mobiles");
    _subCategories.add("Laptops");
    if (_product != null) {
      title = _product.title;
      price = _product.price;
      description = _product.description;
      city = _product.city;
      state = _product.state;
      category = _product.category;
      subCategory = _product.subCategory;
    }
    super.initState();
  }

  Future<void> addImage(ImageSource source) async {
    print("func called!");
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        images.add(File(pickedFile.path));
      }
    });
  }

  Future<void> _saveForm() async {
    final Box<UserModel> _userBox = Provider.of<Box<UserModel>>(
      context,
      listen: false,
    );
    final UserModel _userModel = _userBox.values.first;
    bool valid = _form.currentState.validate();
    if (valid) {
      _form.currentState.save();
      print('Form saved, sending request...');
      print('Global User UID: $globalUid, token: ${_userModel.token}');

      var response;
      // send POST request here

      print('RESPONSE: $response');
      if (response["statusCode"] != 200) {
        print('API post failed');
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
      } else {
        print('API post success');
      }
    }
  }

  Widget renderhHeading(String heading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: textSize * 2),
        Text(
          heading,
          style: TextStyle(
            color: MyThemeData.inputPlaceHolder,
            fontSize: textSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: textSize),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final deviceHorizontalPadding = SizeConfig.deviceWidth * 4;
    final availableWidthSpace =
        (SizeConfig.deviceWidth * 100) - (2 * deviceHorizontalPadding);
    textSize = availableWidthSpace * 0.03;
    return Scaffold(
      appBar: PreferredSize(
        child: JijiAppBar(),
        preferredSize: Size.fromHeight(SizeConfig.deviceHeight * 10),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceHorizontalPadding),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              SizedBox(height: SizeConfig.deviceHeight * 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "POST NEW ADD",
                    style: TextStyle(
                      color: MyThemeData.inputPlaceHolder,
                      fontSize: textSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Need Help?",
                    style: TextStyle(
                      color: MyThemeData.primaryColor,
                      fontSize: textSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              renderhHeading("Item Name"),
              CustomTextField(
                value: title,
                onSaved: (value) => setState(() => title = value),
                validator: (value) {
                  if (value.isEmpty) return 'Enter title';
                  return null;
                },
                hintText: 'Item Name',
                textInputType: TextInputType.text,
              ),
              renderhHeading("Item Price"),
              CustomTextField(
                value: price == null ? "" : price.toString(),
                onSaved: (value) => setState(
                  () => price = double.parse(value),
                ),
                validator: (value) {
                  if (value.isEmpty) return 'Enter price';
                  return null;
                },
                hintText: 'Price',
                textInputType: TextInputType.number,
              ),
              renderhHeading("Item Images"),
              AspectRatio(
                aspectRatio: 3,
                child: ItemImages(
                  images: images,
                  addImageFunction: addImage,
                  productUrlImages: [],
                ),
              ),
              renderhHeading("Location"),
              AspectRatio(
                aspectRatio: 8 / 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomDropDownMenu(
                      hintText: "State",
                      items: _states,
                      value: state,
                      updateProductDetails: (String newValue) => setState(
                        () => state = newValue,
                      ),
                    ),
                    CustomDropDownMenu(
                      hintText: "City",
                      items: _cities,
                      value: city,
                      updateProductDetails: (String newValue) =>
                          setState(() => city = newValue),
                    ),
                  ],
                ),
              ),
              renderhHeading("Item Category"),
              AspectRatio(
                aspectRatio: 8 / 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomDropDownMenu(
                      value: category,
                      hintText: "Category",
                      items: _categories,
                      updateProductDetails: (String newValue) => setState(
                        () => category = newValue,
                      ),
                    ),
                    CustomDropDownMenu(
                      value: subCategory,
                      hintText: "Sub Category",
                      items: _subCategories,
                      updateProductDetails: (String newValue) => setState(
                        () => subCategory = newValue,
                      ),
                    )
                  ],
                ),
              ),
              renderhHeading("Item Description"),
              CustomTextField(
                value: description,
                onSaved: (value) => setState(
                  () => description = value,
                ),
                validator: (value) {
                  if (value.isEmpty) return 'Enter Description';
                  return null;
                },
                hintText: 'Description',
                textInputType: TextInputType.multiline,
              ),
              SizedBox(height: SizeConfig.deviceHeight * 4),
              AspectRatio(
                aspectRatio: 8,
                child: ButtonTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: RaisedButton(
                    onPressed: _saveForm,
                    child: Text(
                      "POST AD",
                      style: TextStyle(
                        fontSize: textSize * 1.2,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    color: MyThemeData.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.deviceHeight),
              FlatButton(
                onPressed: () {},
                child: Text(
                  "or Save as a Draft",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: textSize,
                    color: MyThemeData.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.deviceHeight * 3),
            ],
          ),
        ),
      ),
    );
  }
}
