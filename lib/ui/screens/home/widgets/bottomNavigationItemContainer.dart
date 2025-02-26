import 'package:test/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavItem {
  final String title;
  final String activeImageUrl;
  final String disableImageUrl;

  BottomNavItem({
    required this.activeImageUrl,
    required this.disableImageUrl,
    required this.title,
  });
}

class BottomNavItemTwo {
  String title;
  IconData? activeIconUrl;
  IconData? disableIconUrl;
  final String activeImageUrl;
  final String disableImageUrl;

  BottomNavItemTwo({
    this.activeIconUrl,
    this.disableIconUrl,
    required this.activeImageUrl,
    required this.disableImageUrl,
    required this.title,
  });
}

class BottomNavItemContainer extends StatefulWidget {
  final BoxConstraints boxConstraints;
  final int index;
  final int currentIndex;
  final AnimationController animationController;

  // final BottomNavItem bottomNavItem;
  final BottomNavItemTwo bottomNavItem;
  final Function onTap;
  final String showCaseDescription;

  const BottomNavItemContainer({
    Key? key,
    required this.boxConstraints,
    required this.currentIndex,
    required this.showCaseDescription,
    required this.bottomNavItem,
    required this.animationController,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  @override
  State<BottomNavItemContainer> createState() => _BottomNavItemContainerState();
}

class _BottomNavItemContainerState extends State<BottomNavItemContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        widget.onTap(widget.index);
      },
      child: SizedBox(
        width: widget.boxConstraints.maxWidth * (0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.05),
                end: const Offset(0.0, 0.35),
              ).animate(
                CurvedAnimation(
                  parent: widget.animationController,
                  curve: Curves.easeInOut,
                ),
              ),
              child: widget.bottomNavItem.activeIconUrl != null &&
                      widget.bottomNavItem.disableIconUrl != null
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: Icon(
                        color: widget.index == widget.currentIndex
                            ? Color(0xFF2360BF)
                            : Colors.black,
                        widget.index == widget.currentIndex
                            ? widget.bottomNavItem.activeIconUrl
                            : widget.bottomNavItem.disableIconUrl,
                      ),
                    )
                  : widget.bottomNavItem.activeImageUrl.endsWith('.svg')
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: SvgPicture.asset(
                            widget.index == widget.currentIndex
                                ? widget.bottomNavItem.activeImageUrl
                                : widget.bottomNavItem.disableImageUrl,
                          ),
                        )
                      : SizedBox(
                          width: 25,
                          height: 25,
                          child: Image.asset(widget.index == widget.currentIndex
                              ? widget.bottomNavItem.activeImageUrl
                              : widget.bottomNavItem.disableImageUrl),
                        ),
            ),
            SizedBox(
              height: widget.boxConstraints.maxHeight * (0.051),
            ),
            FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.0)
                  .animate(widget.animationController),
              child: SlideTransition(
                position: Tween<Offset>(
                  // ignore: use_named_constants
                  begin: const Offset(0.0, 0.0),
                  end: const Offset(0.0, 0.5),
                ).animate(
                  CurvedAnimation(
                    parent: widget.animationController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Text(
                  // '',
                  Utils.getTranslatedLabel(
                    widget.bottomNavItem.title,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
