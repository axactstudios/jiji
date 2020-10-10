import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:jiji/impl/impl.dart';
import 'package:jiji/models/UserProfile.dart';
import 'package:jiji/models/categories_list.dart';
import 'package:jiji/models/category.dart';
import 'package:jiji/models/product.dart';
import 'package:jiji/models/user_model.dart';
import 'package:jiji/models/user_posts.dart';

import 'package:jiji/pages/sub_category_page.dart';
import 'package:jiji/pages/view_all_page.dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:jiji/utilities/theme_data.dart';
import 'package:jiji/widgets/jiji_app_bar.dart';
import 'package:jiji/widgets/show_products_gridview.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserProfile userProfile;
  List<Category> categories = [];
  List<Product> popularProducts = [];
  List<ListItem> _dropdownItems = [
    ListItem(1, "Goa, GA"),
    ListItem(2, "Assam"),
    ListItem(3, "Delhi"),
    ListItem(4, "Mumbai")
  ];

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;

  void initState() {
    super.initState();
    // getCategoriesList();
    getPopularProductList();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
  }

  // getUserProfile() async {
  //   final Box<UserModel> _userBox = Provider.of<Box<UserModel>>(
  //     context,
  //     listen: false,
  //   );
  //   final UserModel _userModel = _userBox.values.first;
  //   // print("name : " + _userModel.name);
  //   userProfile = UserProfile.fromJson(
  //     await ApiHelper().get("${Endpoints.getUserProfile}/${_userModel.uid}"),
  //   );
  //   // print(userProfile.name);
  // }

  // getCategoriesList() async {
  //   categories = await Impl().getCategoriesList();
  //   setState(() {});
  // }

  getPopularProductList() async {
    popularProducts = await Impl().getPopularProductsList();
    setState(() {});
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(
            listItem.name,
            style: TextStyle(color: Hexcolor("#3DB83A"), fontSize: 15),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    categories = Provider.of<Categories>(context).categoriesList;
    final Box<UserModel> _userBox =
        Provider.of<Box<UserModel>>(context, listen: false);
    Provider.of<UserPosts>(context)
        .initialize(_userBox.values.first.uid, _userBox.values.first.token);

    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  FlatButton(
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      },
      child: Scaffold(
        appBar: PreferredSize(
          child: JijiAppBar(),
          preferredSize: Size.fromHeight(SizeConfig.deviceHeight * 10),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.deviceWidth * 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: SizeConfig.deviceHeight),
                Align(
                  alignment: Alignment.center,
                  child: DropdownButtonHideUnderline(
                    child: SizedBox(
                      height: SizeConfig.deviceHeight * 3,
                      child: DropdownButton(
                          value: _selectedItem,
                          items: _dropdownMenuItems,
                          style: TextStyle(
                            fontSize: SizeConfig.deviceHeight * 1,
                            color: MyThemeData.primaryColor,
                          ),
                          iconSize: SizeConfig.deviceHeight * 2,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Hexcolor("#3DB83A"),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _selectedItem = value;
                            });
                          }),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.deviceHeight * 0.5,
                ),
                HeaderText(
                  title: 'JIJI ASSIST',
                ),
                SizedBox(
                  height: SizeConfig.deviceHeight * 3,
                ),
                AspectRatio(
                  aspectRatio: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AssistButton(
                        onPressed: null,
                        label: "How to Buy",
                      ),
                      SizedBox(
                        width: SizeConfig.deviceWidth * 7.5,
                      ),
                      AssistButton(
                        onPressed: null,
                        label: "Hot Deals",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.deviceHeight * 2,
                ),
                AspectRatio(
                  aspectRatio: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AssistButton(
                        onPressed: null,
                        label: "How to Sell",
                      ),
                      SizedBox(
                        width: SizeConfig.deviceWidth * 7.5,
                      ),
                      AssistButton(
                        onPressed: null,
                        label: "Games",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.deviceHeight * 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    HeaderText(
                      title: 'CATEGORIES',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Text(
                            'VIEW All',
                            style: TextStyle(
                                color: Hexcolor("#3DB83A"),
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.deviceWidth * 2.5),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyViewAllPage(
                                categories: categories,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: SizeConfig.deviceWidth * 3,
                          color: Hexcolor("#3DB83A"),
                        ),
                        // Icon(
                        //   Icons.arrow_forward_ios,
                        //   size: SizeConfig.deviceWidth * 3,
                        //   color: Hexcolor("#3DB83A"),
                        // ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.deviceHeight * 2,
                ),
                if (categories.length > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CategoryCard(
                        label: categories[0].name,
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SubCategoryScreen(
                              categoryId: categories[0].id,
                            ),
                          ),
                        ),
                        // image: categories[0].photo[0],
                        categoryId: categories[0].id,
                        subText: "(${categories[0].view} ads)",
                      ),
                      CategoryCard(
                        label: categories[1].name,
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SubCategoryScreen(
                              categoryId: categories[1].id,
                            ),
                          ),
                        ),
                        categoryId: categories[1].id,
                        subText: "(${categories[1].view} ads)",
                      ),
                    ],
                  ),
                SizedBox(
                  height: SizeConfig.deviceHeight * 3,
                ),
                HeaderText(
                  title: 'POPULAR PRODUCTS',
                ),
                SizedBox(
                  height: SizeConfig.deviceHeight * 2,
                ),
                ShowProductsGridView(
                  products: popularProducts,
                )
                // Column(
                //   children: [
                //     Container(
                //       child: GridView(
                //           shrinkWrap: true,
                //           physics: NeverScrollableScrollPhysics(),
                //           gridDelegate:
                //               SliverGridDelegateWithFixedCrossAxisCount(
                //                   crossAxisCount: 2),
                //           children: <Widget>[
                //             ProductCard(
                //               location: "Goa, India",
                //               price: "1200",
                //               productName: "Brand New Smart Watch",
                //             ),
                //             ProductCard(
                //               location: "Goa, India",
                //               price: "1200",
                //               productName:
                //                   "Brand New Smart Watch from United States of America",
                //             ),
                //             ProductCard(
                //               location: "Goa, India",
                //               price: "1200",
                //               productName: "Brand New Smart Watch",
                //             ),
                //             ProductCard(
                //               location: "Goa, India",
                //               price: "1200",
                //               productName: "Brand New Smart Watch",
                //             ),
                //           ]),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  final String title;
  HeaderText({this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.grey,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: SizeConfig.deviceWidth * 3,
      ),
    );
  }
}

class AssistButton extends StatelessWidget {
  String label;
  Function onPressed;

  AssistButton({this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: double.infinity,
      width: SizeConfig.deviceWidth * 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.5),
          border: Border.all(color: Hexcolor("#3DB83A"), width: 2)),
      child: Text(
        label,
        style: TextStyle(
          fontSize: SizeConfig.deviceWidth * 3,
          color: Hexcolor("#3DB83A"),
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String label;
  final String subText;
  final Function onPressed;
  final String categoryId;
  const CategoryCard({
    this.label,
    this.onPressed,
    this.subText,
    this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.deviceWidth * 1),
        child: GestureDetector(
          onTap: onPressed,
          child: Card(
            // elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: SizeConfig.deviceHeight * 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.deviceWidth * 10,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: SizedBox(
                        height: SizeConfig.deviceWidth * 35,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                              "https://olx-app-jiji.herokuapp.com/api/category/photo/$categoryId?photoId=$categoryId",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.deviceHeight * 1),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.deviceHeight * 1.35,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.deviceHeight * 0.5,
                    ),
                    child: Text(
                      subText,
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.deviceHeight * 1.00,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}
