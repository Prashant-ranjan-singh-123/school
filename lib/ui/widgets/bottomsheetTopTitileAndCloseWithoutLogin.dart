import 'package:test/ui/widgets/customCloseButton.dart';
import 'package:test/utils/utils.dart';
import 'package:flutter/material.dart';

class BottomsheetTopTitleAndCloseButtonWithoutLogin extends StatelessWidget {
  final String titleKey;
  final Function onTapCloseButton;
  const BottomsheetTopTitleAndCloseButtonWithoutLogin({
    Key? key,
    required this.onTapCloseButton,
    required this.titleKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.getTranslatedLabel(titleKey),
              style: TextStyle(
                fontSize: 22.0,
                // color: Theme.of(context).colorScheme.secondary,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            CustomCloseButton(
              onTapCloseButton: onTapCloseButton,
              color: Colors.white,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Divider(
            color: Colors.transparent,
          ),
        ),
        // SizedBox(
        //   height: MediaQuery.of(context).size.height * (0.0075),
        // ),
      ],
    );
  }
}
