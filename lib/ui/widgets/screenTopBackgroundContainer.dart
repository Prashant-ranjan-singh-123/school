import 'package:test/utils/utils.dart';
import 'package:flutter/material.dart';

class ScreenTopBackgroundContainer extends StatelessWidget {
  final Widget? child;
  final double? heightPercentage;
  final EdgeInsets? padding;
  bool isBackButton;

  ScreenTopBackgroundContainer({
    Key? key,
    this.child,
    this.isBackButton = false,
    this.heightPercentage,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          EdgeInsets.only(
            top: MediaQuery.of(context).padding.top +
                Utils.screenContentTopPadding,
          ),
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height *
          (heightPercentage ?? Utils.appBarBiggerHeightPercentage),
      decoration: BoxDecoration(
        // color: Utils.getColorScheme(context).primary,
        gradient: LinearGradient(colors: [
          Color.fromRGBO(85, 140, 225, 1),
          Color.fromRGBO(35, 96, 191, 1),
        ]),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Stack(
        children: [
          child ?? SizedBox(),
          isBackButton
              ? SafeArea(
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      )),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
