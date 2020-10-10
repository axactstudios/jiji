import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiji/models/product.dart';
import 'package:jiji/utilities/theme_data.dart';
import 'package:jiji/pages/product_details.dart';
import 'package:jiji/utilities/size_config.dart';

class SimilarProductCard extends StatelessWidget {
  // final String productImgUrl;
  // final String productName;
  // final bool isFav;
  // final double prices;
  // final String place;
  final Product product;
  const SimilarProductCard({
    Key key,
    this.product,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String img = product.photo.length > 0
        ? "https://olx-app-jiji.herokuapp.com/api/post/photo/${product.id}?photoId=${product.photo[0].id}"
        : "";
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: product),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                child: Container(
                  height: constraints.maxHeight * 0.67,
                  width: double.infinity,
                  child: img == ""
                      ? SizedBox()
                      : CachedNetworkImage(
                          imageUrl: img,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.05),
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: constraints.maxWidth * 0.05,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                          Icon(
                            true ? Icons.favorite : Icons.favorite_border,
                            color: MyThemeData.primaryColor,
                            size: constraints.maxWidth * 0.06,
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "₹ " + product.price.toString(),
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.045,
                              color: MyThemeData.primaryColor,
                            ),
                          ),
                          Text(
                            product.city,
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.045,
                              color: MyThemeData.inputPlaceHolder,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
