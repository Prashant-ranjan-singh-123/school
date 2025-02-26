import 'package:flutter/material.dart';

class CustomCloseButton extends StatelessWidget {
  final Function onTapCloseButton;
  late Color? color;

  CustomCloseButton({Key? key, required this.onTapCloseButton, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (color == null) {
      color = Theme.of(context).colorScheme.secondary;
    }
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      onTap: () {
        onTapCloseButton();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
              color: color ?? Theme.of(context).colorScheme.secondary),
        ),
        width: 25,
        height: 25,
        child: Icon(
          Icons.close,
          size: 20,
          color: color ?? Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
