import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/feature/calendar/constants/constants.dart';
import 'package:solve_tutor/feature/calendar/controller/create_course_controller.dart';
import 'package:solve_tutor/feature/calendar/helper/utility_helper.dart';
import 'package:solve_tutor/feature/calendar/model/course_model.dart';

class ReorderableViewPage extends StatefulWidget {
  @override
  _ReorderableViewPageState createState() => _ReorderableViewPageState();
}

class _ReorderableViewPageState extends State<ReorderableViewPage> {
  final _util = UtilityHelper();
  var courseController = CourseController();

  void reorderData(int oldindex, int newindex) {
    print('${oldindex} ${newindex}');
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = lessons.removeAt(oldindex);
      lessons.insert(newindex, items);
    });
  }

  void sorting() {
    setState(() {
      courseController.courseData?.lessons?.sort();
    });
  }

  List<Lessons> lessons = [];
  @override
  void initState() {
    super.initState();
    var courseController = context.read<CourseController>();
    lessons = courseController.courseData?.lessons ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.grayE5E6E9,
        elevation: 6,
        title: Text(
          'เรียงลำดับเนื้อหา',
          style: CustomStyles.bold18Black363636,
        ),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.close, color: Colors.grey),
        ),
      ),
      body: Column(
        children: [
          _alert(),
          Expanded(
            child: ReorderableListView(
              padding: const EdgeInsets.only(top: 20),
              onReorder: reorderData,
              children: <Widget>[
                for (var i = 0; i < lessons.length; i++)
                  Card(
                      color: CustomColors.grayEFF0F2,
                      key: ValueKey(lessons[i]),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: _headBuilder(lessons[i], i)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _alert() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomColors.grayCFCFCF,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8.0),
        color: CustomColors.grayEFF0F2,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: Image.asset(
                        'assets/images/pan_tool_alt.png',
                        scale: 4,
                        color: CustomColors.greenPrimary,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      "ลากเพื่อเรียงลำดับบทเรียน",
                      style: CustomStyles.med14White.copyWith(
                          color: CustomColors.black,
                          fontSize: _util.addMinusFontSize(18)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _headBuilder(Lessons? lesson, int index) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (lesson?.isExpanded == false) ...[
            Text(
              "บทที่ # ${index + 1}:",
              style: CustomStyles.blod16gray878787,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "${lesson?.lessonName}",
                style:
                    CustomStyles.blod16gray878787.copyWith(color: Colors.black),
              ),
            ),
            _moveList(lesson),
          ],
        ],
      ),
    );
  }

  Widget _moveList(Lessons? lesson) {
    return InkWell(
      onTap: () {},
      child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              border: Border.all(color: CustomColors.greenPrimary),
              borderRadius: BorderRadius.circular(8.0),
              color: CustomColors.greenPrimary),
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/arrow_move.png',
            scale: 4,
            color: Colors.white,
          )),
    );
  }
}
