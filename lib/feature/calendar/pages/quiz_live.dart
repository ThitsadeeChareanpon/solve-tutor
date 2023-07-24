// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/feature/calendar/constants/constants.dart';
import 'package:solve_tutor/feature/calendar/controller/create_course_live_controller.dart';
import 'package:solve_tutor/feature/calendar/helper/utility_helper.dart';
import 'package:solve_tutor/feature/calendar/widgets/sizebox.dart';

class QuizLive extends StatefulWidget {
  QuizLive({Key? key}) : super(key: key);

  @override
  _QuizLiveState createState() => _QuizLiveState();
}

class _QuizLiveState extends State<QuizLive> {
  static final _util = UtilityHelper();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<CourseLiveController>(builder: (_, course, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _topicText('คำถามในห้องเรียน'),
                    Expanded(child: Container()),
                    if (_util.isTablet()) ...[
                      _buttonExample(),
                      _buttonSaveCourse()
                    ],
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_util.isTablet() == false) ...[
                      _buttonExample(),
                      _buttonSaveCourse()
                    ],
                  ],
                ),
                S.h(10),
                _alertQuiz(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _topicText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: _util.isTablet()
              ? CustomStyles.bold22Black363636
              : CustomStyles.bold18Black363636,
        ),
      ),
    );
  }

  Widget _buttonExample() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        icon: const Icon(
          Icons.add,
          color: CustomColors.gray878787,
        ),
        label: Text(
          "สร้างชุดคำถามใหม่",
          style: CustomStyles.med14White.copyWith(
            color: CustomColors.gray878787,
          ),
        ),
        onPressed: () async {},
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }

  Widget _buttonSaveCourse() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.green20B153,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      onPressed: () {},
      child: Text(
        "เลือกจากคลังคำถาม",
        style: CustomStyles.med14White,
      ),
    );
  }

  Widget _alertQuiz() {
    return Container(
      width: double.infinity,
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
          Container(
            height: 44,
            width: 44,
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: CustomColors.yellowFF9800,
            ),
            child: Image.asset(
              'assets/images/share-06.png',
            ),
          ),
          S.w(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "เลือกชุดคำถามที่จะใช้สอนในห้องเรียน",
                  style: CustomStyles.med14White.copyWith(
                    color: CustomColors.black,
                  ),
                ),
                Text(
                  "คุณสามารถเปิดชุดคำถามนี้ในระหว่างที่คุณสอนนักเรียนได้",
                  style: CustomStyles.med14White.copyWith(
                    color: CustomColors.gray363636,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
