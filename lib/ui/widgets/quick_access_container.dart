import 'package:test/app/routes.dart';
import 'package:test/data/models/subject.dart';
import 'package:test/ui/widgets/subjectImageContainer.dart';
import 'package:test/utils/systemModules.dart';
import 'package:test/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../data/models/quick_access_item_model.dart';
import '../../utils/animationConfiguration.dart';

class QuickAccessContainer extends StatelessWidget {
  final String subjectsTitleKey;
  final List<QuickAccessItemModel> quickAccessItemModel;
  final int? childId;
  final bool showReport;
  final bool animate;

  const QuickAccessContainer({
    Key? key,
    this.childId,
    required this.quickAccessItemModel,
    required this.subjectsTitleKey,
    this.showReport = false,
    this.animate = true,
  }) : super(key: key);

  Widget _buildSubjectContainer({
    required BoxConstraints boxConstraints,
    required String Imagepath,
    required void Function(BuildContext) onTap,
    required List<Color> colorList,
    required String name,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        onTap(context);
      },
      child: Container(
        width: boxConstraints.maxWidth * (0.26),
        margin: const EdgeInsets.only(
          bottom: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            QuicAccessImageContainer(
              showShadow: false,
              animate: animate,
              width: boxConstraints.maxWidth * (0.26),
              height: boxConstraints.maxWidth * (0.26),
              radius: 20,
              imagePath: Imagepath,
              colorList: colorList,
            ),
            5.sizedBoxHeight,
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Utils.getColorScheme(context).secondary,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width *
            Utils.screenContentHorizontalPaddingInPercentage,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              Utils.getTranslatedLabel(subjectsTitleKey),
              style: TextStyle(
                color: Utils.getColorScheme(context).secondary,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * (0.025),
          ),
          LayoutBuilder(
            builder: (context, boxConstraints) {
              return Wrap(
                spacing: boxConstraints.maxWidth * (0.1),
                children:
                    List.generate(quickAccessItemModel.length, (index) => index)
                        .map(
                          (index) => _buildSubjectContainer(
                            boxConstraints: boxConstraints,
                            context: context,
                            Imagepath: quickAccessItemModel[index].imagePath,
                            name: quickAccessItemModel[index].itemName,
                            colorList: quickAccessItemModel[index].listOfColor,
                            onTap: quickAccessItemModel[index].onTap,
                          ),
                        )
                        .toList(),
              );
            },
          )
        ],
      ),
    );
  }
}

class QuicAccessImageContainer extends StatelessWidget {
  final String imagePath;
  final double height;
  final double width;
  final double radius;
  final List<Color> colorList;
  final BoxBorder? border;
  final bool showShadow;
  final bool animate;

  const QuicAccessImageContainer({
    Key? key,
    this.border,
    required this.showShadow,
    required this.height,
    required this.radius,
    required this.colorList,
    required this.imagePath,
    required this.width,
    this.animate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: animate ? customItemFadeAppearanceEffects() : null,
      child: Container(
          decoration: BoxDecoration(
              border: border,
              // image: DecorationImage(image: AssetImage(imagePath)),
              // color: Colors.black,
              borderRadius: BorderRadius.circular(radius),
              gradient: LinearGradient(
                  colors: colorList,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          height: height,
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(imagePath),
          )),
    );
  }
}
