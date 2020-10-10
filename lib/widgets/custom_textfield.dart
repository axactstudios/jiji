import 'package:flutter/material.dart';
import 'package:jiji/utilities/theme_data.dart';
import 'package:jiji/utilities/size_config.dart';

class CustomTextField extends StatefulWidget {
  final String value;
  final Function onSaved;
  final Function validator;
  final String hintText;
  final TextInputType textInputType;
  bool isAspectRatio;
  double aspectRatioValue;
  CustomTextField(
      {Key key,
      @required this.value,
      @required this.onSaved,
      @required this.validator,
      @required this.hintText,
      @required this.textInputType,
      this.isAspectRatio,
      this.aspectRatioValue})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isHidden = true;
  double textFieldheight;
  var availableWidthSpace;

  Widget customWidget(EdgeInsetsGeometry textFieldPadding, double textSize) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: textFieldPadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color.fromRGBO(240, 240, 240, 1),
      ),
      child: TextFormField(
        initialValue: widget.value,
        decoration: InputDecoration.collapsed(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: textSize,
            color: MyThemeData.inputPlaceHolder,
            fontWeight: FontWeight.w400,
          ),
        ).copyWith(
          suffixIcon: widget.hintText == "Password"
              ? Padding(
                  padding: EdgeInsets.all(1),
                  child: GestureDetector(
                    onTap: () => setState(() => isHidden = !isHidden),
                    child: (isHidden
                        ? Icon(
                            Icons.visibility_off,
                            size: textSize * 1.8,
                          )
                        : Icon(
                            Icons.visibility_rounded,
                            size: textSize * 1.8,
                          )),
                  ),
                )
              : null,
          errorStyle: TextStyle(
            fontSize: textSize * 0.45,
            height: 0.08,
            color: Colors.red[600],
            fontWeight: FontWeight.w400,
          ),
          suffixIconConstraints: BoxConstraints.tight(Size(
            availableWidthSpace * 0.1,
            textSize * 1.6,
          )),
        ),
        obscureText: widget.hintText == "Password" ? isHidden : false,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          fontSize: textSize,
          fontWeight: FontWeight.w400,
        ),
        keyboardType: widget.textInputType,
        maxLines: widget.textInputType == TextInputType.multiline ? 7 : 1,
        cursorColor: MyThemeData.primaryColor,
        onSaved: (value) => widget.onSaved(value),
        validator: (value) => widget.validator(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.isAspectRatio ??= true;
    SizeConfig().init(context);
    final deviceHorizontalPadding = SizeConfig.deviceWidth * 4;
    availableWidthSpace =
        SizeConfig.deviceWidth * 100 - (2 * deviceHorizontalPadding);
    // if (isSingleField) availableWidthSpace = availableWidthSpace * 0.45;
    final aspectRatio =
        widget.aspectRatioValue == null ? 8 / 1 : widget.aspectRatioValue;
    textFieldheight = availableWidthSpace / aspectRatio;
    final textSize = textFieldheight * 0.3;
    // print("Text Size" + textSize.toString());
    // print(aspectRatio.toString() + "  " + textFieldheight.toString());
    final textFieldPadding = EdgeInsets.symmetric(
        horizontal: availableWidthSpace * 0.030,
        vertical: widget.textInputType == TextInputType.multiline
            ? availableWidthSpace * 0.03
            : 0);

    return widget.isAspectRatio
        ? AspectRatio(
            aspectRatio: widget.textInputType == TextInputType.multiline
                ? aspectRatio / 3
                : aspectRatio,
            child: customWidget(
              textFieldPadding,
              textSize,
            ),
          )
        : customWidget(
            textFieldPadding,
            textSize,
          );
  }
}
