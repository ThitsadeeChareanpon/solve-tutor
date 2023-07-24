import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/feature/calendar/constants/constants.dart';
import 'package:solve_tutor/feature/calendar/controller/create_course_controller.dart';
import 'package:solve_tutor/feature/calendar/helper/utility_helper.dart';
import 'package:solve_tutor/feature/calendar/model/course_model.dart';
import 'package:solve_tutor/feature/calendar/widgets/alert_overlay.dart';
import 'package:solve_tutor/feature/calendar/widgets/dropdown.dart';
import 'package:solve_tutor/feature/calendar/widgets/widgets.dart';
import 'package:solve_tutor/feature/market_place/pages/update_course.dart';

enum CourseType { vdo, pad, non }

class CreateCoursePage extends StatefulWidget {
  CreateCoursePage({Key? key, required this.tutorId, required this.courseType})
      : super(key: key);
  String tutorId;
  CourseType courseType;
  @override
  State<CreateCoursePage> createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  final _util = UtilityHelper();
  var courseController = CourseController();

  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async {
    courseController = Provider.of<CourseController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: CustomColors.white,
        elevation: 6,
        title: Text(
          CustomStrings.createCourse,
          style: CustomStyles.bold22Black363636,
        ),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back, color: Colors.grey),
        ),
      ),
      body: Consumer<CourseController>(builder: (_, controller, child) {
        return SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: _util.isTablet() ? 120.0 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                S.h(32.0),
                Text(
                  "ตั้งชื่อคอร์ส",
                  style: CustomStyles.bold22Black363636,
                ),
                S.h(32.0),
                if (widget.courseType == CourseType.pad) ...[widgetPAD()],
                if (widget.courseType == CourseType.vdo) ...[widgetVDO()],
                S.h(20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: controller.courseNameTextEditing,
                    decoration: InputDecoration(
                      labelText: 'ชื่อคอร์ส',
                      labelStyle: CustomStyles.med14Black363636,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      suffix: Text(
                          '${controller.courseNameTextEditing.value.text.length}/70'),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(70),
                    ],
                    onChanged: (value) {
                      controller.lastChangeName(value);
                    },
                  ),
                ),
                S.h(32.0),
                Dropdown(
                  selectedValue: controller.selectedLevel,
                  items: controller.levels,
                  hintText: '-- ระดับชั้นปีการศึกษา --',
                  onChanged: (value) {
                    courseController.selectedLevel = value ?? '';
                    setState(() {});
                  },
                ),
                S.h(32.0),
                Dropdown(
                  selectedValue: controller.selectedSubject,
                  items: controller.subjects,
                  hintText: '-- เลือกหมวดหมู่ --',
                  onChanged: (value) {
                    controller.selectedSubject = value ?? '';
                    setState(() {});
                  },
                ),
                S.h(32.0),
                SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: CustomColors.green20B153),
                    onPressed: () async {
                      String courseId = '';
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      var courseData = CourseModel(
                          courseName:
                              courseController.courseNameTextEditing.text,
                          levelId: courseController.selectedLevel,
                          subjectId: courseController.selectedSubject,
                          tutorId: widget.tutorId,
                          courseType: stringCourseType());
                      if (courseData.courseName?.isNotEmpty == true &&
                          courseData.levelId?.isNotEmpty == true &&
                          courseData.subjectId?.isNotEmpty == true &&
                          courseData.tutorId?.isNotEmpty == true) {
                        await Alert.showOverlay(
                          loadingWidget: Alert.getOverlayScreen(),
                          asyncFunction: () async {
                            courseId =
                                await courseController.saveCourse(courseData);
                          },
                          context: context,
                        );

                        if (courseId.isNotEmpty) {
                          // ignore: use_build_context_synchronously
                          await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateCourseTab(
                                courseId: courseId,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        S.w(10),
                        Text(
                          "ดำเนินการต่อ",
                          style: CustomStyles.bold14White,
                        ),
                        S.w(10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget dropdownObject(
      {required String selectValue, required List<String> objects}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomColors.gray878787,
          width: 1,
        ),
        color: CustomColors.whitePrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton(
        value: selectValue.isEmpty ? null : selectValue,
        onChanged: (value) {
          if (value != '') {
            selectValue = value.toString();
            print(selectValue);
          }
        },
        hint: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '-- ระดับชั้นปีการศึกษา --',
            style: CustomStyles.med14Black363636,
          ),
        ),
        underline: Container(),
        dropdownColor: CustomColors.whitePrimary,
        icon: const Icon(
          Icons.keyboard_arrow_down_sharp,
          color: CustomColors.black363636,
        ),
        isExpanded: true,
        items: objects
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    e,
                    style: CustomStyles.med14Black363636,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget widgetVDO() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomColors.gray878787),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/ph_video.png',
                scale: _util.isTablet() ? 1 : 2,
              ),
              S.w(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'คอร์สแบบอัดวิดิโอ',
                    style: _util.isTablet()
                        ? CustomStyles.med18Black363636
                        : CustomStyles.med16Black363636,
                  ),
                  Text(
                    'นักเรียนเรียนผ่านคอร์สอัดวิดิโอที่ติวเตอร์บันทึกไว้ล่วงหน้า',
                    style: _util.isTablet()
                        ? CustomStyles.med16Black363636
                            .copyWith(color: CustomColors.gray878787)
                        : CustomStyles.med14Black363636
                            .copyWith(color: CustomColors.gray878787),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget widgetPAD() {
    return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CustomColors.gray878787),
        ),
        child: Row(
          children: [
            Image.asset('assets/images/ph_video.png',
                scale: _util.isTablet() ? 1 : 2),
            S.w(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'คอร์สแบบอัดการเขียนจากเทคโนโลยี SOLVEPAD',
                    style: _util.isTablet()
                        ? CustomStyles.med18Black363636
                        : CustomStyles.med16Black363636,
                  ),
                  Text(
                    'นักเรียนเรียนผ่านวิดิโอที่ติวเตอร์บันทึกการเขียนบน SOLVEPAD ',
                    style: _util.isTablet()
                        ? CustomStyles.med16Black363636
                            .copyWith(color: CustomColors.gray878787)
                        : CustomStyles.med14Black363636
                            .copyWith(color: CustomColors.gray878787),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  String stringCourseType() {
    String value = '';
    if (widget.courseType == CourseType.vdo) {
      value = 'vdo';
    } else if (widget.courseType == CourseType.pad) {
      value = 'pad';
    }
    return value;
  }
}
