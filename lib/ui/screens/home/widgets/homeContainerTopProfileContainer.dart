import 'package:flutter_svg/flutter_svg.dart';
import 'package:test/app/routes.dart';
import 'package:test/cubits/appConfigurationCubit.dart';
import 'package:test/cubits/authCubit.dart';
import 'package:test/ui/widgets/borderedProfilePictureContainer.dart';
import 'package:test/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:test/ui/widgets/svgButton.dart';
import 'package:test/utils/labelKeys.dart';
import 'package:test/utils/systemModules.dart';
import 'package:test/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class HomeContainerTopProfileContainer extends StatelessWidget {
  const HomeContainerTopProfileContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTopBackgroundContainer(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  right: false,
                  left: false,
                  bottom: false,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.sizeOf(context).height*0.05,
                    // color: Colors.black,
                    child: Image.asset('assets/images/edtus_logo.png'),
                  ),
                ),
              ),
              //Bordered circles
              PositionedDirectional(
                top: MediaQuery.of(context).size.width * (-0.15),
                start: MediaQuery.of(context).size.width * (-0.225),
                child: Container(
                  padding:
                      const EdgeInsetsDirectional.only(end: 20.0, bottom: 20.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.1),
                    ),
                    shape: BoxShape.circle,
                  ),
                  width: MediaQuery.of(context).size.width * (0.6),
                  height: MediaQuery.of(context).size.width * (0.6),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.1),
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              //bottom fill circle
              PositionedDirectional(
                bottom: MediaQuery.of(context).size.width * (-0.15),
                end: MediaQuery.of(context).size.width * (-0.15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  width: MediaQuery.of(context).size.width * (0.4),
                  height: MediaQuery.of(context).size.width * (0.4),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsetsDirectional.only(
                    end: boxConstraints.maxWidth * (0.065),
                    start: boxConstraints.maxWidth * (0.065),
                    bottom: boxConstraints.maxHeight * (0.2),
                  ),
                  child: Row(
                    children: [
                      BorderedProfilePictureContainer(
                        heightAndWidth: 60,
                        imageUrl: context
                                .read<AuthCubit>()
                                .getStudentDetails()
                                .image ??
                            "",
                        onTap: () {
                          Get.toNamed(Routes.studentProfile);
                        },
                      ),
                      SizedBox(
                        width: boxConstraints.maxWidth * (0.03),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context
                                  .read<AuthCubit>()
                                  .getStudentDetails()
                                  .getFullName(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    "${Utils.getTranslatedLabel(classKey)} : ${context.read<AuthCubit>().getStudentDetails().classSection?.fullName}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Container(
                                  width: 1.5,
                                  height: 12.0,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Flexible(
                                  child: Text(
                                    "${Utils.getTranslatedLabel(rollNoKey)} : ${context.read<AuthCubit>().getStudentDetails().rollNumber}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.notifications);
                          },
                          child: Icon(
                            IconlyLight.notification,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        width: 20.0,
                      ),
                      BlocBuilder<AppConfigurationCubit, AppConfigurationState>(
                        builder: (context, state) {
                          return Utils.isModuleEnabled(
                                  context: context,
                                  moduleId: chatModuleId.toString())
                              ? SvgButton(
                                  onTap: () {
                                    Get.toNamed(Routes.chatContacts);
                                  },
                                  svgIconUrl:
                                      Utils.getImagePath("chat_icon.svg"),
                                )
                              : const SizedBox();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
