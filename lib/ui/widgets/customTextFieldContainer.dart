import 'package:test/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class CustomTextFieldContainer extends StatelessWidget {
  final String hintTextKey;
  final bool hideText;
  final double? bottomPadding;
  TextInputType? textInputType;
  final Widget? suffixWidget;
  Color? theme;
  final int minLine;
  final TextEditingController? textEditingController;

  CustomTextFieldContainer({
    Key? key,
    this.bottomPadding,
    this.suffixWidget,
    this.theme,
    required this.hideText,
    required this.hintTextKey,
    this.minLine = 1,
    this.textInputType,
    this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50,
      margin: EdgeInsets.only(bottom: bottomPadding ?? 20.0),
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: theme ?? Utils.getColorScheme(context).secondary),
      ),
      child: TextFormField(
          controller: textEditingController,
          obscureText: hideText,
          minLines: minLine,
          maxLines: minLine,
          keyboardType: textInputType,
          style: TextStyle(
              color: theme ?? Utils.getColorScheme(context).secondary),
          decoration: InputDecoration(
            suffixIcon: suffixWidget,
            hintStyle: TextStyle(
                color: theme != null
                    ? theme!.withAlpha(-50)
                    : Utils.getColorScheme(context).secondary),
            hintText: Utils.getTranslatedLabel(hintTextKey),
            border: InputBorder.none,
            contentPadding:
                suffixWidget != null ? EdgeInsets.only(top: 12.5) : null,
          )),
    );
  }
}
