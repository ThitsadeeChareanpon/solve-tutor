import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/feature/calendar/constants/constants.dart';
import 'package:solve_tutor/feature/calendar/controller/create_course_live_controller.dart';
import 'package:solve_tutor/feature/calendar/helper/utility_helper.dart';
import 'package:solve_tutor/feature/calendar/model/course_model.dart';
import 'package:solve_tutor/feature/calendar/model/student_model.dart';
import 'package:solve_tutor/feature/calendar/pages/update_course_live.dart';
import 'package:solve_tutor/feature/calendar/widgets/alert_overlay.dart';
import 'package:solve_tutor/feature/calendar/widgets/dropdown.dart';
import 'package:solve_tutor/feature/calendar/widgets/sizebox.dart';

class CreateCourseLivePage extends StatefulWidget {
  CreateCourseLivePage({
    Key? key,
    required this.tutorId,
    this.studentId,
    this.studentName,
  }) : super(key: key);
  String tutorId;
  String? studentId;
  String? studentName;
  @override
  State<CreateCourseLivePage> createState() => _CreateCourseLivePageState();
}

class _CreateCourseLivePageState extends State<CreateCourseLivePage> {
  final _util = UtilityHelper();
  var courseController = CourseLiveController();

  initStudent(CourseModel courseData) async {
    try {
      StudentModel student = StudentModel(
          id: widget.studentId ?? '',
          name: widget.studentName ?? '',
          createTime: DateTime.now());
      if (widget.studentId != null) {
        log("initStudent");
        List<String>? studentList = [widget.studentId ?? ''];
        courseData.studentIds = studentList;
        courseData.studentDetails = [student];
        courseData.documentId = 'test';
        log("initStudent2");
        setState(() {});
        log("data : ${courseData.toJson()}");
        // courseController.courseData?.studentDetails?.add(filterStudent.first);
        await courseController.updateCourseDestailsOnlyStudent(courseData);
        log("initStudent3");
      } else {
        log("error : ไม่มีนักเรียนเริ่มต้น");
      }
      return courseData;
    } catch (e) {
      log("error : เพิ่มนักเรียนไม่สำเร็จ");
      return courseData;
    }
  }

  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async {
    courseController =
        Provider.of<CourseLiveController>(context, listen: false);
  }

  TextEditingController courseName = TextEditingController();

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
      body: SingleChildScrollView(
        child: Consumer<CourseLiveController>(builder: (_, controller, child) {
          return Padding(
            padding:
                EdgeInsets.symmetric(horizontal: _util.isTablet() ? 120.0 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                S.h(32.0),
                Text(
                  "ข้อมูลคอร์ส",
                  style: CustomStyles.bold22Black363636,
                ),
                S.h(32.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: controller.courseNameTextEditing,
                    decoration: InputDecoration(
                      labelText: 'ชื่อคอร์ส',
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
                      controller.lastChangeName(courseName.text);
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
                        courseName: courseController.courseNameTextEditing.text,
                        levelId: courseController.selectedLevel,
                        subjectId: courseController.selectedSubject,
                        tutorId: widget.tutorId,
                      );
                      courseData = await initStudent(courseData);
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
                              builder: (context) => UpdateCourseLiveTab(
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
          );
        }),
      ),
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
}
