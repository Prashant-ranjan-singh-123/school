import 'package:test/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../../utils/utils.dart';

class StudentGpt extends StatelessWidget {
  const StudentGpt({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: Scaffold(
        body: Column(
          children: [
            ScreenTopBackgroundContainer(
              padding: EdgeInsets.zero,
              heightPercentage: Utils.appBarSmallerHeightPercentage,
              child: Center(
                child: Text(
                  'Student GPT',
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: Utils.screenTitleFontSize,
                  ),
                ),
              ),
            ),
            Spacer(),
            _buildSendMessageContainer(context: context),
            SizedBox(
                height: MediaQuery.of(context).size.height *
                    Utils.bottomNavigationHeightPercentage)
          ],
        ),
      ),
    );
  }

  Widget _buildSendMessageContainer({required BuildContext context}) {
    void onTapSendMessage() {
      print('send click');
    }

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      padding: EdgeInsetsDirectional.symmetric(vertical: 20, horizontal: 20),
      child: Container(
        constraints: BoxConstraints(maxHeight: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                maxLines: null,
                // controller: _messageController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: Utils.getTranslatedLabel("typeMessageHere"),
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.75)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: onTapSendMessage,
              child: CircleAvatar(
                radius: 15.5,
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.send,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.75),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
