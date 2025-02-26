import 'dart:ui';
import 'package:flutter/cupertino.dart';

class QuickAccessItemModel {
  final String imagePath;
  final String itemName;
  final List<Color> listOfColor;
  final void Function(BuildContext) onTap;

  QuickAccessItemModel({
    required this.imagePath,
    required this.itemName,
    required this.onTap,
    required this.listOfColor,
  });
}
