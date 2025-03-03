import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_preview/device_preview.dart';
import 'package:test/app/appTranslation.dart';
import 'package:test/cubits/assignmentReportCubit.dart';
import 'package:test/cubits/assignmentsCubit.dart';
import 'package:test/cubits/childFeeDetailsCubit.dart';
import 'package:test/cubits/onlineExamReportCubit.dart';
import 'package:test/cubits/resultsOnlineCubit.dart';
import 'package:test/cubits/schoolConfigurationCubit.dart';
import 'package:test/cubits/socketSettingCubit.dart';
import 'package:test/data/repositories/assignmentRepository.dart';
import 'package:test/data/repositories/feeRepository.dart';
import 'package:test/data/repositories/resultRepository.dart';
import 'package:test/data/repositories/schoolRepository.dart';
import 'package:test/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:test/app/routes.dart';

import 'package:test/cubits/appConfigurationCubit.dart';
import 'package:test/cubits/appLocalizationCubit.dart';
import 'package:test/cubits/authCubit.dart';
import 'package:test/cubits/examDetailsCubit.dart';
import 'package:test/cubits/examsOnlineCubit.dart';
import 'package:test/cubits/noticeBoardCubit.dart';
import 'package:test/cubits/notificationSettingsCubit.dart';
import 'package:test/cubits/postFeesPaymentCubit.dart';
import 'package:test/cubits/reportTabSelectionCubit.dart';
import 'package:test/cubits/resultTabSelectionCubit.dart';
import 'package:test/cubits/studentSubjectAndSlidersCubit.dart';
import 'package:test/cubits/examTabSelectionCubit.dart';

import 'package:test/data/repositories/announcementRepository.dart';
import 'package:test/data/repositories/authRepository.dart';
import 'package:test/data/repositories/onlineExamRepository.dart';
import 'package:test/data/repositories/settingsRepository.dart';
import 'package:test/data/repositories/studentRepository.dart';
import 'package:test/data/repositories/systemInfoRepository.dart';

import 'package:test/cubits/onlineExamQuestionsCubit.dart';
import 'package:test/data/repositories/reportRepository.dart';
import 'package:test/ui/screens/priceDetails/state_management/plans_cubit.dart';
import 'package:test/ui/screens/studentGpt/state_management/student_gpt_cubit.dart';
import 'package:test/ui/styles/colors.dart';

import 'package:test/utils/hiveBoxKeys.dart';
import 'package:test/utils/notificationUtility.dart';
import 'package:test/utils/utils.dart';

//to avoid handshake error on some devices
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  //Register the licence of font
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  if(kReleaseMode) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppTranslation.loadJsons();

  await NotificationUtility.initializeAwesomeNotification();

  await Hive.initFlutter();
  await Hive.openBox(showCaseBoxKey);
  await Hive.openBox(authBoxKey);
  await Hive.openBox(notificationsBoxKey);
  await Hive.openBox(settingsBoxKey);
  await Hive.openBox(studentSubjectsBoxKey);

  runApp(DevicePreview(
      enabled: kDebugMode,
      builder: (BuildContext context) {
        return MultiBlocProvider(providers: [
          BlocProvider<StudentGptCubit>(
            create: (_) => StudentGptCubit(),
          ),
          BlocProvider<PlansCubit>(
            create: (_) => PlansCubit(),
          ),
        ], child: MyApp());

          MyApp();
      }));
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationUtility.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationUtility.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationUtility.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationUtility.onDismissActionReceivedMethod,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //preloading some of the imaegs
    precacheImage(
      AssetImage(Utils.getImagePath("upper_pattern.png")),
      context,
    );

    precacheImage(
      AssetImage(Utils.getImagePath("lower_pattern.png")),
      context,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppLocalizationCubit>(
          create: (_) => AppLocalizationCubit(SettingsRepository()),
        ),
        BlocProvider<NotificationSettingsCubit>(
          create: (_) => NotificationSettingsCubit(SettingsRepository()),
        ),
        BlocProvider<AuthCubit>(create: (_) => AuthCubit(AuthRepository())),
        BlocProvider<StudentSubjectsAndSlidersCubit>(
          create: (_) => StudentSubjectsAndSlidersCubit(),
        ),
        BlocProvider<NoticeBoardCubit>(
          create: (context) => NoticeBoardCubit(AnnouncementRepository()),
        ),
        BlocProvider<AppConfigurationCubit>(
          create: (context) => AppConfigurationCubit(SystemRepository()),
        ),
        BlocProvider<ExamDetailsCubit>(
          create: (context) => ExamDetailsCubit(StudentRepository()),
        ),
        BlocProvider<PostFeesPaymentCubit>(
          create: (context) => PostFeesPaymentCubit(StudentRepository()),
        ),
        BlocProvider<ResultTabSelectionCubit>(
          create: (_) => ResultTabSelectionCubit(),
        ),
        BlocProvider<ReportTabSelectionCubit>(
          create: (_) => ReportTabSelectionCubit(),
        ),
        BlocProvider<OnlineExamReportCubit>(
          create: (_) => OnlineExamReportCubit(ReportRepository()),
        ),
        BlocProvider<AssignmentReportCubit>(
          create: (_) => AssignmentReportCubit(ReportRepository()),
        ),
        BlocProvider<ExamTabSelectionCubit>(
          create: (_) => ExamTabSelectionCubit(),
        ),
        BlocProvider<OnlineExamQuestionsCubit>(
          create: (_) => OnlineExamQuestionsCubit(OnlineExamRepository()),
        ),
        BlocProvider<ExamsOnlineCubit>(
          create: (_) => ExamsOnlineCubit(OnlineExamRepository()),
        ),
        BlocProvider<ResultsOnlineCubit>(
          create: (_) => ResultsOnlineCubit(ResultRepository()),
        ),
        BlocProvider<AssignmentsCubit>(
          create: (_) => AssignmentsCubit(AssignmentRepository()),
        ),
        BlocProvider<SchoolConfigurationCubit>(
            create: (_) => SchoolConfigurationCubit(SchoolRepository())),
        BlocProvider<ChildFeeDetailsCubit>(
            create: (_) => ChildFeeDetailsCubit(FeeRepository())),
        BlocProvider<SocketSettingCubit>(
            create: (context) => SocketSettingCubit())
      ],
      child: Builder(
        builder: (context) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Theme.of(context).copyWith(
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
              scaffoldBackgroundColor: pageBackgroundColor,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: primaryColor,
                    onPrimary: onPrimaryColor,
                    secondary: secondaryColor,
                    surface: backgroundColor,
                    error: errorColor,
                    onSecondary: onSecondaryColor,
                    onSurface: onBackgroundColor,
                  ),
            ),
            locale: context.read<AppLocalizationCubit>().state.language,
            fallbackLocale: const Locale("en"),
            getPages: Routes.getPages,
            initialRoute: Routes.splash,
            translationsKeys: AppTranslation.translationsKeys,
          );
        },
      ),
    );
  }
}
