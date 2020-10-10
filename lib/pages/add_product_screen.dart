import 'dart:convert';
import 'dart:io' as io;
// import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiji/constants/endpoints.dart';
import 'package:jiji/data/network/api_helper.dart';
import 'package:jiji/models/categories_list.dart';
import 'package:jiji/models/subcategories_list.dart';
// import 'package:jiji/data/network/api_response.dart';
// import 'package:jiji/impl/impl.dart';
// import 'package:jiji/models/user.dart';
import 'package:jiji/models/user_model.dart';
import 'package:jiji/utilities/theme_data.dart';
import 'package:jiji/widgets/jiji_app_bar.dart';
import 'package:jiji/models/product(1).dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:jiji/widgets/custom_dropdrown.dart';
import 'package:jiji/widgets/custom_textfield.dart';
import 'package:jiji/widgets/item_images.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

//image file to string
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
  List<io.File> images = [];
  final _form = GlobalKey<FormState>();
  String title;
  double price;
  String description;
  String state;
  String city;
  String category;
  String subCategory;
  double textSize;

  List<String> filenames = [];

  String image64;
  // File imageResized;
  List<MultipartFile> fileList = [];

  bool _isLoading = false;

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
    if (_product != null) {
      title = _product.title;
      price = _product.price;
      description = _product.description;
      city = _product.city;
      state = _product.state;
      category = _product.category;
      subCategory = _product.subCategory;
    }

    // setState(() {});
    super.initState();
  }

  // Future<void> addImage(ImageSource source) async {
  //   print("func called!");
  //   final pickedFile = await picker.getImage(source: source);
  //   //file to dtring
  //   File imageResized = await FlutterNativeImage.compressImage(pickedFile.path,
  //       quality: 100, targetWidth: 120, targetHeight: 120);
  //   List<int> imageBytes = imageResized.readAsBytesSync();
  //   image64 = base64Encode(imageBytes);

  //   setState(() {
  //     if (pickedFile != null) {
  //       images.add(File(pickedFile.path));
  //     }
  //   });
  // }

  Future<void> addImage(ImageSource source) async {
    // print("func called!");
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      images.add(io.File(pickedFile.path));
      filenames.add(pickedFile.path.split('/').last);
      fileList.add(MultipartFile.fromBytes(await pickedFile.readAsBytes(),
          filename: pickedFile.path));
    }
    setState(() {});
    //Image file to base64 string

    // imageResized = await FlutterNativeImage.compressImage(pickedFile.path,
    //     quality: 100, targetWidth: 120, targetHeight: 120);
    // // print(imageResized.path);
    // List<int> imageBytes = imageResized.readAsBytesSync();
    // image64 = base64Encode(imageBytes);

  }

  Future<void> _saveForm(UserModel user) async {
    bool valid = _form.currentState.validate();

    // print(imageResized.path);
    if (valid) {
      setState(() {
        _isLoading = !_isLoading;
      });
      _form.currentState.save();
      // Map<String, String> mapHeader = {
      //   'Authorization': "Bearer " + "${user.token}",
      //   'Content-Type': "multipart/form-data"
      // };
      var uri = Uri.parse(Endpoints.savePost);

      var request = new http.MultipartRequest("POST", uri);


      for (var file in images) {
        String fileName = file.path.split("/").last;
        var stream = new http.ByteStream(Stream.castFrom(file.openRead()));

        var length = await file.length();

        var multipartFileSign =
            new http.MultipartFile('photo', stream, length, filename: fileName);

        request.files.add(multipartFileSign);
      }

      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer ${user.token}"
      };
      String subCategoryId;
      String categoryId;
      Provider.of<Categories>(context, listen: false)
          .categoriesList
          .forEach((element) {
        if (element.name == category) {
          categoryId = element.id;
        }
      });
      Provider.of<SubCategories>(context, listen: false)
          .subCategoriesList
          .forEach((element) {
        if (element.name == subCategory) {
          subCategoryId = element.id;
        }
      });
      request.headers.addAll(headers);

      request.fields['name'] = user.name;
      request.fields['description'] = description;
      request.fields['price'] = price.toString();
      request.fields['postedBy'] = user.uid;
      request.fields['title'] = title;
      request.fields['condition'] = "good";
      request.fields['city'] = city;
      request.fields['state'] = state;
      request.fields['category'] = categoryId;
      request.fields['views'] = '0';
      request.fields['subCategory'] = subCategoryId;

      var response = await request.send();


      final String response = await Impl().savePost(mapJson, mapHeader, user.uid);
      setState(() {
        _isLoading = !_isLoading;

      print(response.statusCode);
      if (response.statusCode == 200) {}
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);

      });

      setState(() {
        title = "";
        price = null;
        state = null;
        city = null;
        description = "";
        category = null;
        subCategory = null;
        images = [];
      });
      await showDialog(
        context: context,
        child: AlertDialog(
          title: Text(
            "Product Successfully Added !",
            style: TextStyle(
              color: Colors.black,
              fontSize: textSize * 1.2,
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                // Navigator.of(context).pop();
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
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Form validation failed"),
      ));
    }
  }

  Widget renderHeading(String heading) {
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
    Provider.of<Categories>(context, listen: false)
        .categoriesList
        .forEach((element) {
      if (!_categories.contains(element.name)) _categories.add(element.name);
    });
    // setState(() {});
    Provider.of<SubCategories>(context, listen: false)
        .subCategoriesList
        .forEach((element) {
      if (!_subCategories.contains(element.name))
        _subCategories.add(element.name);
    });
    final Box<UserModel> _user =
        Provider.of<Box<UserModel>>(context, listen: false);
    final UserModel _userModel = _user.values.first;
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
              renderHeading("Item Name"),
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
              renderHeading("Item Price"),
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
              renderHeading("Item Images"),
              AspectRatio(
                aspectRatio: 3,
                child: ItemImages(
                  images: images,
                  addImageFunction: addImage,
                  productUrlImages: [],
                ),
              ),
              renderHeading("Location"),
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
              renderHeading("Item Category"),
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
              renderHeading("Item Description"),
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
                  child: FlatButton(
                    onPressed: () async {
                      _saveForm(_userModel);
                    },
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            "POST AD",
                            style: TextStyle(
                              fontSize: textSize * 1.2,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                    color: _isLoading?Colors.white54:MyThemeData.primaryColor,
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
