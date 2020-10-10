import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:hive/hive.dart';
import 'package:jiji/data/network/api_helper.dart';


import 'package:url_launcher/url_launcher.dart' as urlLauncher;


import 'package:jiji/impl/impl.dart';
import 'package:jiji/models/product.dart';
import 'package:jiji/models/user_model.dart';
import 'package:jiji/pages/chat_box_page.dart';
import 'package:jiji/utilities/size_config.dart';
import 'package:jiji/widgets/custom_button.dart';
import 'package:jiji/widgets/jiji_app_bar.dart';
import 'package:jiji/widgets/product_images.dart';
import 'package:jiji/widgets/seller_card.dart';
import 'package:jiji/widgets/show_products_gridview.dart';
import 'package:provider/provider.dart';

import '../utilities/theme_data.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({Key key, this.product}) : super(key: key);
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedImageIndex = 0;
  Box<UserModel> _user;
  UserModel _userModel;

  bool isFavourite = false;
  List<Product> similarProducts = [];
  List<String> img = [];
  @override
  void initState() {
    getSimilarProducts();
    isFavourite = true; //_isFavourite(_userModel);
    widget.product.photo.forEach((element) {
      img.add(element.id);
    });
    super.initState();
  }

  getSimilarProducts() async {
    similarProducts = await Impl().getSimilarProductsList(
        {}, {"subCategory": "5f61ba5da12dce2918eacc62"});
    setState(() {});
  }

  void updateSelectedImage(int index) {
    setState(() {
      selectedImageIndex = index;
    });
  }

  void toggleFavourite(UserModel user) async {
    setState(() {
      isFavourite = !isFavourite;
    });
    Map<String, String> header = {'Authorization': "Bearer ${user.token}"};

    Map<String, dynamic> body = {'postId': widget.product.id};

    dynamic _response;

    if (isFavourite) {
      _response = await Impl().putUnlike(header, body, user.uid);
      /*
      ***MUST BE IMPLEMENTED AFTERWARDS DEPENDING UPON RESULT***
      if(succesful){
        print("Added to Fav");
      }
      else{
        setState(){
          isFavourite = !isFavourite;
        }
      }*/
    } else {
      _response = await Impl().putLike(header, body, user.uid);
      /*
      ***MUST BE IMPLEMENTED AFTERWARDS DEPENDING UPON RESULT***
      if(succesful){
        print("Added to Fav");
      }
      else{
        setState(){
          isFavourite = !isFavourite;
        }
      }*/
    }
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<Box<UserModel>>(context, listen: false);
    _userModel = _user.values.first;
    SizeConfig().init(context);
    final deviceHorizontalPadding = SizeConfig.deviceWidth * 4;
    final availableWidthSpace =
        (SizeConfig.deviceWidth * 100) - (2 * deviceHorizontalPadding);
    final textSize = availableWidthSpace * 0.045;
    const imageAspectRatio = 335 / 190;
    const callMessageButtonsAspectRatio = 9 / 1;
    return Scaffold(
      appBar: PreferredSize(
        child: JijiAppBar(),
        preferredSize: Size.fromHeight(SizeConfig.deviceHeight * 10),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Color.fromRGBO(240, 240, 240, 1),
              height: SizeConfig.deviceHeight * 3,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Electronics",
                    style: TextStyle(
                      fontSize: textSize * 0.6,
                    ),
                  ),
                  Text(
                    " > ",
                    style: TextStyle(
                      fontSize: textSize * 0.6,
                      color: MyThemeData.primaryColor,
                    ),
                  ),
                  Text(
                    "Wearables",
                    style: TextStyle(
                      fontSize: textSize * 0.6,
                    ),
                  ),
                  Text(
                    " > ",
                    style: TextStyle(
                      fontSize: textSize * 0.6,
                      color: MyThemeData.primaryColor,
                    ),
                  ),
                  Text(
                    "SmartWatches",
                    style: TextStyle(
                      fontSize: textSize * 0.6,
                    ),
                  ),
                  Text(
                    " > ",
                    style: TextStyle(
                      fontSize: textSize * 0.6,
                      color: MyThemeData.primaryColor,
                    ),
                  ),
                  Text(
                    "Brand New...",
                    style: TextStyle(
                      fontSize: textSize * 0.6,
                      color: MyThemeData.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.deviceHeight * 2),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.deviceWidth * 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: imageAspectRatio,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: MyThemeData.inputPlaceHolder,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            widget.product.photo.length > 0
                                ? "https://olx-app-jiji.herokuapp.com/api/post/photo/${widget.product.id}?photoId=${widget.product.photo[selectedImageIndex].id}"
                                : "",
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.deviceHeight * 2),
                  ProductImages(
                    img: img,
                    selectedImageIndex: selectedImageIndex,
                    updateSelectedImage: updateSelectedImage,
                    categoryId: widget.product.id,
                  ),
                  SizedBox(height: SizeConfig.deviceHeight * 3),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: textSize,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: SizeConfig.deviceHeight * 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹ ${widget.product.price}",
                        style: TextStyle(
                          fontSize: textSize,
                          fontWeight: FontWeight.w700,
                          color: MyThemeData.primaryColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => toggleFavourite(_userModel),
                        child: Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: MyThemeData.primaryColor,
                          size: textSize * 1.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.deviceHeight * 2),
                  SellerCard(
                    postedBy: widget.product.postedBy,
                  ),
                  SizedBox(height: SizeConfig.deviceHeight * 3),
                  AspectRatio(
                    aspectRatio: callMessageButtonsAspectRatio,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          icon: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          onPressed: () => urlLauncher
                              .launch('tel:${widget.product.postedBy.phone}'),
                          text: 'CALL',
                          isBorder: false,
                          color: MyThemeData.primaryColor,
                        ),
                        CustomButton(
                          icon: Icon(
                            Icons.message,
                            color: MyThemeData.primaryColor,
                          ),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatBoxPage(
                                recId: widget.product.postedBy.id,
                                name: widget.product.postedBy.name,
                              ),
                            ),
                          ),
                          isBorder: true,
                          text: 'CHAT',
                          color: MyThemeData.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.deviceHeight * 4),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ITEM DESCRIPTION",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: textSize * 0.7,
                        color: MyThemeData.inputPlaceHolder,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.deviceHeight * 3),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.product.description,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: textSize * 0.75,
                        color: Color.fromRGBO(58, 58, 58, 1),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.deviceHeight * 4),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "SIMILAR PRODUCTS",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: textSize * 0.7,
                        color: MyThemeData.inputPlaceHolder,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.deviceHeight * 3),
                  ShowProductsGridView(
                    products: similarProducts,
                  ),
                  SizedBox(height: SizeConfig.deviceHeight * 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isFavourite(UserModel user) {
    List likedPost = widget.product.postedBy.likedPost;
    likedPost.forEach((element) {
      if (element == user.uid) {
        return true;
      }
    });
    return false;
  }
}
