import 'package:test/app/routes.dart';
import 'package:test/cubits/authCubit.dart';
import 'package:test/cubits/noticeBoardCubit.dart';
import 'package:test/cubits/schoolConfigurationCubit.dart';
import 'package:test/cubits/studentSubjectAndSlidersCubit.dart';
import 'package:test/data/models/quick_access_item_model.dart';
import 'package:test/ui/screens/home/widgets/homeContainerTopProfileContainer.dart';
import 'package:test/ui/screens/home/widgets/homeScreenDataLoadingContainer.dart';
import 'package:test/ui/widgets/errorContainer.dart';
import 'package:test/ui/widgets/latestNoticesContainer.dart';
import 'package:test/ui/widgets/schoolGalleryContainer.dart';
import 'package:test/ui/widgets/slidersContainer.dart';
import 'package:test/ui/widgets/studentSubjectsContainer.dart';
import 'package:test/utils/labelKeys.dart';
import 'package:test/utils/systemModules.dart';
import 'package:test/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../cubits/attendanceCubit.dart';
import '../../../../cubits/holidaysCubit.dart';
import '../../../../cubits/resultsCubit.dart';
import '../../../../cubits/schoolGalleryCubit.dart';
import '../../../../cubits/studentGuardianDetailsCubit.dart';
import '../../../../cubits/timeTableCubit.dart';
import '../../../../data/repositories/schoolRepository.dart';
import '../../../../data/repositories/studentRepository.dart';
import '../../../../data/repositories/systemInfoRepository.dart';
import '../../../widgets/attendanceContainer.dart';
import '../../../widgets/noticeBoardContainer.dart';
import '../../../widgets/quick_access_container.dart';
import '../../../widgets/timetableContainer.dart';
import '../../reports/reportSubjectsContainer.dart';
import '../cubits/assignmentsTabSelectionCubit.dart';
import '../homeScreen.dart';
import 'examContainer.dart';

class HomeContainer extends StatefulWidget {
  //Need this flag in order to show the homeContainer
  //in background when bottom menu is open

  //If it is just for background showing purpose then it will not reactive or not making any api call
  final bool isForBottomMenuBackground;
  int currentIndex;

  HomeContainer({Key? key,
    required this.isForBottomMenuBackground,
    this.currentIndex = 0})
      : super(key: key);

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  @override
  void initState() {
    super.initState();
    if (!widget.isForBottomMenuBackground) {
      Future.delayed(Duration.zero, () {
        fetchSubjectSlidersAndNoticeBoardDetails();
      });
    }
  }

  void fetchSubjectSlidersAndNoticeBoardDetails() {
    context.read<StudentSubjectsAndSlidersCubit>().fetchSubjectsAndSliders(
        useParentApi: false,
        isSliderModuleEnable: Utils.isModuleEnabled(
            context: context, moduleId: sliderManagementModuleId.toString()));

    if (Utils.isModuleEnabled(
        context: context,
        moduleId: announcementManagementModuleId.toString())) {
      context
          .read<NoticeBoardCubit>()
          .fetchNoticeBoardDetails(useParentApi: false);
    }
  }

  Widget _buildAdvertisemntSliders() {
    //
    final sliders = context.read<StudentSubjectsAndSlidersCubit>().getSliders();
    return SlidersContainer(sliders: sliders);
  }

  List<QuickAccessItemModel> quickAccessItemModel = [
    QuickAccessItemModel(
        imagePath: 'assets/images/quick_access/item_0.svg',
        itemName: 'Subject',
        listOfColor: [Color(0xFFED3F78), Color(0xFFC61052)],
        onTap: (context) {
          print('i am here');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => TimeTableCubit(StudentRepository()),
                child: HomeContainer(
                  currentIndex: 1,
                  isForBottomMenuBackground: false,
                ),
              )));

          // Get.toNamed(Routes.subjectWiseReport);
        }),
    QuickAccessItemModel(
        imagePath: 'assets/images/quick_access/item_1.svg',
        itemName: 'Time Table',
        listOfColor: [Color(0xFF73DC7D), Color(0xFF3CC895)],
        onTap: (context) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  BlocProvider(
                    create: (context) => TimeTableCubit(StudentRepository()),
                    child: HomeContainer(
                      currentIndex: 2,
                      isForBottomMenuBackground: false,
                    ),
                  )));
        }),
    QuickAccessItemModel(
        imagePath: 'assets/images/quick_access/item_2.svg',
        itemName: 'Notice Board',
        listOfColor: [Color(0xFFC87DFA), Color(0xFF811ED5)],
        onTap: (context) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  HomeContainer(
                    currentIndex: 3,
                    isForBottomMenuBackground: false,
                  ),
            ),
          );
        }),
    QuickAccessItemModel(
        imagePath: 'assets/images/quick_access/item_3.svg',
        itemName: 'Attendance',
        listOfColor: [Color(0xFF8C87D2), Color(0xFF5344E3)],
        onTap: (context) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  BlocProvider(
                    create: (context) => AttendanceCubit(StudentRepository()),
                    child: HomeContainer(
                      currentIndex: 4,
                      isForBottomMenuBackground: false,
                    ),
                  )));
        }),
    QuickAccessItemModel(
        imagePath: 'assets/images/quick_access/item_4.svg',
        itemName: 'Exams',
        listOfColor: [Color(0xFF61CCF0), Color(0xFF289ECE)],
        onTap: (context) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  HomeContainer(
                    currentIndex: 5,
                    isForBottomMenuBackground: false,
                  ),
            ),
          );
        }),
    QuickAccessItemModel(
        imagePath: 'assets/images/quick_access/item_5.svg',
        itemName: 'Plans',
        listOfColor: [Color(0xFFEA3C77), Color(0xFFC7094B)],
        onTap: (context) {
          print('hello 5');
        }),
  ];

  Widget _buildSlidersSubjectsAndLatestNotcies() {
    return BlocConsumer<StudentSubjectsAndSlidersCubit,
        StudentSubjectsAndSlidersState>(
      listener: (context, state) {
        if (state is StudentSubjectsAndSlidersFetchSuccess) {
          if (state.doesClassHaveElectiveSubjects &&
              state.electiveSubjects.isEmpty) {
            if (Get.currentRoute == Routes.selectSubjects) {
              return;
            }
            Get.toNamed(Routes.selectSubjects);
          }
        }
      },
      builder: (context, state) {
        if (state is StudentSubjectsAndSlidersFetchSuccess) {
          return RefreshIndicator(
            displacement: Utils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
            ),
            color: Theme
                .of(context)
                .colorScheme
                .primary,
            onRefresh: () async {
              context
                  .read<SchoolConfigurationCubit>()
                  .fetchSchoolConfiguration(useParentApi: false);
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                top: Utils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
                ),
                bottom: Utils.getScrollViewBottomPadding(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAdvertisemntSliders(),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * (0.025),
                  ),
                  Utils.isModuleEnabled(
                      context: context,
                      moduleId: announcementManagementModuleId.toString())
                      ? Column(
                    children: [
                      SizedBox(
                        height:
                        MediaQuery
                            .of(context)
                            .size
                            .height * (0.025),
                      ),
                      LatestNoticiesContainer(
                        animate: !widget.isForBottomMenuBackground,
                      ),
                    ],
                  )
                      : const SizedBox(),
                  QuickAccessContainer(
                    subjectsTitleKey: quickAccessKey,
                    animate: !widget.isForBottomMenuBackground,
                    quickAccessItemModel: quickAccessItemModel,
                  ),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * (0.025),
                  ),
                  Utils.isModuleEnabled(
                      context: context,
                      moduleId: galleryManagementModuleId.toString())
                      ? SchoolGalleryContainer(
                    student:
                    context.read<AuthCubit>().getStudentDetails(),
                  )
                      : const SizedBox(),
                  Center(
                      child: Image.asset('assets/images/powered_by_edtus.png'))
                ],
              ),
            ),
          );
        }

        if (state is StudentSubjectsAndSlidersFetchFailure) {
          return Center(
            child: ErrorContainer(
              onTapRetry: () {
                context
                    .read<StudentSubjectsAndSlidersCubit>()
                    .fetchSubjectsAndSliders(
                    useParentApi: false,
                    isSliderModuleEnable: Utils.isModuleEnabled(
                        context: context,
                        moduleId: sliderManagementModuleId.toString()));
              },
              errorMessageCode: state.errorMessage,
            ),
          );
        }

        return HomeScreenDataLoadingContainer(
          addTopPadding: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentIndex == 0) {
      return Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: _buildSlidersSubjectsAndLatestNotcies(),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: HomeContainerTopProfileContainer(),
          ),
        ],
      );
    } else if (widget.currentIndex == 1) {
      return Scaffold(
          body: MultiBlocProvider(providers: [
            BlocProvider<TimeTableCubit>(
              create: (_) => TimeTableCubit(StudentRepository()),
            ),
            BlocProvider<StudentGuardianDetailsCubit>(
              create: (_) => StudentGuardianDetailsCubit(StudentRepository()),
            ),
            BlocProvider<AttendanceCubit>(
              create: (context) => AttendanceCubit(StudentRepository()),
            ),
            BlocProvider<HolidaysCubit>(
              create: (context) => HolidaysCubit(SystemRepository()),
            ),
            BlocProvider<AssignmentsTabSelectionCubit>(
              create: (_) => AssignmentsTabSelectionCubit(),
            ),
            BlocProvider<ResultsCubit>(
              create: (_) => ResultsCubit(StudentRepository()),
            ),
            BlocProvider<SchoolGalleryCubit>(
              create: (_) => SchoolGalleryCubit(SchoolRepository()),
            ),
          ], child: ReportSubjectsContainer())
      );
    }

    else if (widget.currentIndex == 2) {
    return Scaffold(
    body: TimeTableContainer(),
    );
    } else if (widget.currentIndex == 3) {
    return Scaffold(
    body: NoticeBoardContainer(
    showBackButton: false,
    ),
    );
    } else if (widget.currentIndex == 4) {
    return Scaffold(
    body: AttendanceContainer(),
    );
    } else if (widget.currentIndex == 5) {
    return Scaffold(
    body: ExamContainer(),
    );
    } else {
    return Stack(
    children: [
    Align(
    alignment: Alignment.topCenter,
    child: _buildSlidersSubjectsAndLatestNotcies(),
    ),
    Align(
    alignment: Alignment.topCenter,
    child: HomeContainerTopProfileContainer(),
    ),
    ],
    );
    }
  }
}
