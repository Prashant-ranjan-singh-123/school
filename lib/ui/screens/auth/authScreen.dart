import 'package:test/app/routes.dart';
import 'package:test/cubits/appConfigurationCubit.dart';
import 'package:test/ui/widgets/customRoundedButton.dart';
import 'package:test/utils/labelKeys.dart';
import 'package:test/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();

  static Widget routeInstance() {
    return AuthScreen();
  }
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late final AnimationController _bottomMenuHeightAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  late final Animation<double> _patterntAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
    ),
  );

  late final Animation<double> _formAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ),
  );

  late final Animation<double> _bottomMenuHeightUpAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _bottomMenuHeightAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ),
  );
  late final Animation<double> _bottomMenuHeightDownAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _bottomMenuHeightAnimationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
    ),
  );

  Future<void> startAnimation() async {
    //cupertino page transtion duration
    await Future.delayed(const Duration(milliseconds: 300));

    _bottomMenuHeightAnimationController.forward();
  }

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  @override
  void dispose() {
    _bottomMenuHeightAnimationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildLottieAnimation() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top +
              MediaQuery.of(context).size.height * (0.05),
        ),
        height: MediaQuery.of(context).size.height * (0.4),
        child: Lottie.asset("assets/animations/onboarding.json"),
      ),
    );
  }

  Widget _buildBottomMenu() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
        animation: _bottomMenuHeightAnimationController,
        builder: (context, child) {
          final height = MediaQuery.of(context).size.height *
                  (0.525) *
                  _bottomMenuHeightUpAnimation.value -
              MediaQuery.of(context).size.height *
                  (0.05) *
                  _bottomMenuHeightDownAnimation.value;
          return Container(
            width: MediaQuery.of(context).size.width,
            height: height,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: AnimatedSwitcher(
              switchInCurve: Curves.easeInOut,
              duration: const Duration(milliseconds: 400),
              child: _bottomMenuHeightAnimationController.value != 1.0
                  ? const SizedBox()
                  : LayoutBuilder(
                      builder: (context, boxConstraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //

                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * (0.1),
                              ),
                              child: Text(
                                context
                                    .read<AppConfigurationCubit>()
                                    .getAppConfiguration()
                                    .tagline,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w300,
                                  color:
                                      Utils.getColorScheme(context).onSurface,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: boxConstraints.maxHeight * (0.05),
                            ),
                            CustomRoundedButton(
                              onTap: () {},
                              widthPercentage: 0.8,
                              backgroundColor:
                                  Utils.getColorScheme(context).primary,
                              buttonTitle:
                                  "${Utils.getTranslatedLabel(loginAsKey)} ${Utils.getTranslatedLabel(studentKey)}",
                              showBorder: false,
                            ),
                            SizedBox(
                              height: boxConstraints.maxHeight * (0.04),
                            ),
                            CustomRoundedButton(
                              onTap: () {
                                Get.toNamed(Routes.parentLogin);
                              },
                              widthPercentage: 0.8,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              buttonTitle:
                                  "${Utils.getTranslatedLabel(loginAsKey)} ${Utils.getTranslatedLabel(parentKey)}",
                              titleColor: Utils.getColorScheme(context).primary,
                              showBorder: true,
                              borderColor:
                                  Utils.getColorScheme(context).primary,
                            ),
                          ],
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // _buildLottieAnimation(),
          // _buildBottomMenu(),
          _buildForm(),
          _buildUpperPattern(),
          _buildLowerPattern(),
        ],
      ),
    );
  }

  Widget _buildUpperPattern() {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: Image.asset(Utils.getImagePath("upper_pattern_1.png")),
    );
  }

  Widget _buildLowerPattern() {
    return Align(
      alignment: AlignmentDirectional.bottomStart,
      child: Image.asset(Utils.getImagePath("lower_pattern_1.png")),
    );
  }

  Widget _buildForm() {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: NotificationListener(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * (0.075),
              right: MediaQuery.of(context).size.width * (0.075),
              top: MediaQuery.of(context).size.height * (0.12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    // color: Colors.black,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * (0.5),
                        child: Container(
                            // color: Colors.black,
                            child:
                                Image.asset('assets/images/edtus_logo.png')))),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),
                // Text(
                //   Utils.getTranslatedLabel(letsSignInKey),
                //   style: TextStyle(
                //     fontSize: 34.0,
                //     fontWeight: FontWeight.bold,
                //     color: Utils.getColorScheme(context).secondary,
                //   ),
                // ),
                // const SizedBox(
                //   height: 10.0,
                // ),
                Text(
                  "${Utils.getTranslatedLabel('Edtus – Navigate the path to success together')}",
                  style: TextStyle(
                    fontSize: 24.0,
                    height: 1.5,
                    color: Utils.getColorScheme(context).secondary,
                  ),
                ),
                Center(child: Image.asset('assets/images/auth_screen_person.png')),
                CustomRoundedButton(
                    onTap: () {
                      Get.toNamed(
                        Routes.studentLogin,
                      );
                    },
                    widthPercentage: 0.8,
                    backgroundColor: Color(0xFF2360BF),
                    buttonTitle: Utils.getTranslatedLabel('$loginAsKey') +
                        ' ' +
                        Utils.getTranslatedLabel('$studentKey'),
                    titleColor: Theme.of(context).scaffoldBackgroundColor,
                    showBorder: true,
                    height: MediaQuery.sizeOf(context).height * 0.06),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),
                CustomRoundedButton(
                    onTap: () {
                      Get.toNamed(Routes.parentLogin);
                    },
                    widthPercentage: 0.8,
                    backgroundColor: Color(0xFF2360BF),
                    buttonTitle: Utils.getTranslatedLabel('$loginAsKey') +
                        ' ' +
                        Utils.getTranslatedLabel('$parentKey'),
                    titleColor: Theme.of(context).scaffoldBackgroundColor,
                    showBorder: true,
                    height: MediaQuery.sizeOf(context).height * 0.06),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// student login

// parent login
// Get.toNamed(Routes.parentLogin);
