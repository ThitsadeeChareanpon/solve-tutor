import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/feature/calendar/constants/constants.dart';
import 'package:solve_tutor/feature/calendar/controller/create_course_controller.dart';
import 'package:solve_tutor/feature/calendar/helper/utility_helper.dart';
import 'package:solve_tutor/feature/calendar/model/course_model.dart';
import 'package:solve_tutor/feature/calendar/pages/course_detail_page.dart';
import 'package:solve_tutor/feature/calendar/pages/quiz_live.dart';
import 'package:solve_tutor/feature/calendar/widgets/alert_overlay.dart';
import 'package:solve_tutor/feature/calendar/widgets/alert_snackbar.dart';
import 'package:solve_tutor/feature/calendar/widgets/format_date.dart';
import 'package:solve_tutor/feature/calendar/widgets/widgets.dart';
import 'package:solve_tutor/feature/market_place/pages/course_details.dart';
import 'package:solve_tutor/feature/market_place/pages/lesson_tab.dart';
import 'package:solve_tutor/feature/market_place/pages/video_lesson_tab.dart';

import '../../calendar/model/menu_create_ course_model.dart';

class UpdateCourseTab extends StatefulWidget {
  UpdateCourseTab({
    Key? key,
    required this.courseId,
  }) : super(key: key);

  final String courseId;

  @override
  _UpdateCourseTabState createState() => _UpdateCourseTabState();
}

class _UpdateCourseTabState extends State<UpdateCourseTab>
    with SingleTickerProviderStateMixin {
  final _util = UtilityHelper();
  List<Widget> _pageCourse = [];
  var courseController = CourseController();

  @override
  void initState() {
    super.initState();
    courseController = context.read<CourseController>();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await Alert.showOverlay(
        loadingWidget: Alert.getOverlayScreen(),
        asyncFunction: () async {
          // ues courseId get course details
          final course = await courseController.getCourseById(widget.courseId);
          await courseController.setInitData(course);
          // await courseController.(course);
          await courseController
              .getCalendarListAll(courseController.courseData?.tutorId ?? '');
          await courseController.getDataCalendarList(
              courseController.courseData?.calendars ?? []);
        },
        context: context,
      );
    });
    _pageCourse = [
      const CourseDetails(),
      const LessonTab(),
      VideoLessonTab(),
      QuizLive(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    courseController.courseData = null;
    courseController.clearData();
  }

  @override
  Widget build(BuildContext context) {
    var courseController = context.watch<CourseController>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: CustomColors.white,
        elevation: 6,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back,
              color: CustomColors.gray878787,
            )),
        title: Text(
          courseController.courseData?.courseName ?? '',
          style: CustomStyles.bold22Black363636,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _buildRowList(courseController.menuCreateCourse),
              ),
            ),
            Expanded(
              child: _pageCourse[courseController.indexSelected],
            ),
            _bottom(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRowList(List<MenuCreateCourseModel> menuCreateCourse) {
    List<Widget> list = [];
    for (var i = 0; i < menuCreateCourse.length; i++) {
      list.add(Expanded(child: _tab(value: menuCreateCourse[i], index: i)));
    }
    return list;
  }

  Widget _tab({required MenuCreateCourseModel value, required int index}) {
    var courseController = context.read<CourseController>();
    return InkWell(
      onTap: () {
        context.read<CourseController>().indexTo(index);
      },
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (courseController.indexSelected) > index
                    ? const Icon(Icons.check_circle_outline_outlined,
                        size: 15, color: CustomColors.greenPrimary)
                    : const SizedBox(),
                S.w(5),
                Text(
                  value.title,
                  style: CustomStyles.med16Black363636.copyWith(
                    color: (courseController.indexSelected) >= index
                        ? CustomColors.greenPrimary
                        : CustomColors.gray878787,
                  ),
                ),
              ],
            ),
          ),
          S.h(10),
          if (courseController.menuCreateCourse[index].active) ...[
            Container(
                color: CustomColors.greenPrimary,
                height: 3,
                width: double.infinity),
          ],
        ],
      ),
    );
  }

  _bottom() {
    return Container(
        height: 72,
        padding: EdgeInsets.symmetric(horizontal: _util.isTablet() ? 24 : 10),
        width: double.infinity,
        color: CustomColors.grayE5E6E9,
        child: Row(
          children: [
            _lastUpdate(courseController.courseData?.updateTime),
            Expanded(child: Container()),
            _buttonExample(),
            S.w(10),
            _buttonSaveCourse(context),
            S.w(10),
            Container(
              height: 30,
              width: 1,
              color: CustomColors.gray878787,
            ),
            S.w(10),
            _buttonPublishing()
          ],
        ));
  }

  Widget _lastUpdate(DateTime? dt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'แก้ไขล่าสุด: ${FormatDate.dt(dt)} ',
          style: CustomStyles.med12gray878787,
        ),
      ],
    );
  }

  Widget _buttonExample() {
    return _util.isTablet()
        ? Container(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.visibility,
                color: CustomColors.gray878787,
              ),
              label: Text(
                "ดูตัวอย่าง",
                style: CustomStyles.med14White.copyWith(
                  color: CustomColors.gray878787,
                ),
              ),
              onPressed: () async {
                if (courseController.courseData != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CourseDetailPage(
                              courseData:
                                  courseController.courseData ?? CourseModel(),
                            )),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CourseDetailPage(
                          courseData:
                              courseController.courseData ?? CourseModel(),
                        )),
              );
            },
            child: const Icon(
              Icons.visibility,
              color: CustomColors.gray878787,
            ),
          );
  }

  Widget _buttonPublishing() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: ElevatedButton.icon(
        icon: Image.asset(
          'assets/images/publishing.png',
          scale: 2.5,
        ),
        label: Text(
          "เผยแพร่",
          style: CustomStyles.med14White.copyWith(
            color: CustomColors.white,
          ),
        ),
        onPressed: () async {
          if (courseController.courseData?.publishing == false) {
            courseController.setPublishing(true);
            await Alert.showOverlay(
              asyncFunction: () async {
                await courseController.updateCoursePublishing(
                    courseController.courseData, true);
              },
              context: context,
              loadingWidget: Alert.getOverlayScreen(),
            );
          } else {
            courseController.setPublishing(false);
            await Alert.showOverlay(
              asyncFunction: () async {
                await courseController.updateCoursePublishing(
                    courseController.courseData, false);
              },
              context: context,
              loadingWidget: Alert.getOverlayScreen(),
            );
          }
          // ignore: use_build_context_synchronously
          showSnackBar(context, 'อัพเดทสำเร็จ');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: courseController.courseData?.publishing == true
              ? CustomColors.yellowFF9800
              : CustomColors.grayCFCFCF,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }

  Widget _buttonSaveCourse(BuildContext context) {
    var courseController = context.read<CourseController>();
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.green20B153,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      onPressed: () async {
        await Alert.showOverlay(
          asyncFunction: () async {
            await courseController
                .updateCourseDetails(courseController.courseData);
          },
          context: context,
          loadingWidget: Alert.getOverlayScreen(),
        );
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'อัพเดทสำเร็จ');
      },
      child: Text(
        "บันทึก",
        style: CustomStyles.med14White,
      ),
    );
  }
}
