// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solve_tutor/feature/calendar/constants/constants.dart';
import 'package:solve_tutor/feature/calendar/helper/utility_helper.dart';
import 'package:solve_tutor/feature/calendar/widgets/widgets.dart';

class AlertDeleteChapter extends StatelessWidget {
  const AlertDeleteChapter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 150.0,
          vertical: 100.0,
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                S.h(20),
                Text(
                  'ลบบทเรียน',
                  style: CustomStyles.bold18Black363636,
                ),
                S.h(5),
                Text(
                  'คุณยืนยันที่จะลบบทเรียนนี้อออกจาก รายการบทเรียนใช่หรือไม่\nเมื่อลบบทเรียนแล้ว คุณไม่สามารถแก้ไขอะไรได้อีก',
                  style: CustomStyles.reg14Gray878787,
                ),
                S.h(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildButtonClose(context),
                    S.w(10),
                    _buildButtonConfirm(context),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonConfirm(context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(true);
        },
        child: Container(
          width: 174.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: CustomColors.redB71C1C,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text('ยืนยันการลบบทเรียน', style: CustomStyles.med14White),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonClose(context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(false);
        },
        child: Container(
          width: 174.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: CustomColors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(CustomStrings.cancel,
                style: CustomStyles.med14greenPrimary),
          ),
        ),
      ),
    );
  }
}

class AlertPublishCourse extends StatelessWidget {
  AlertPublishCourse({super.key, required this.courseId});
  final String courseId;
  final util = UtilityHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: util.isTablet() ? 400 : 800),
        child: AlertDialog(
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  S.h(20),
                  Text(
                    'เผยแพร่คอร์สเรียนของคุณ',
                    style: CustomStyles.bold18Black363636,
                  ),
                  S.h(5),
                  Text(
                    'ยืนยันการเผยแพร่ข้อมูลและเนื้อหาคอร์สเรียนของคุณ',
                    style: CustomStyles.reg14Gray878787,
                  ),
                  S.h(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildButtonClose(context),
                      S.w(10),
                      _buildButtonAdd(context),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonAdd(context) {
    final util = UtilityHelper();

    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          _publishCourse();
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const MainTabTutorPage(index: 0),
          //     ),
          //     (route) => false);
        },
        child: Container(
          width: util.isTablet() ? 174.0 : 100,
          height: 40.0,
          decoration: BoxDecoration(
            color: CustomColors.greenPrimary,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(CustomStrings.confirm, style: CustomStyles.med14White),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonClose(context) {
    final util = UtilityHelper();

    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          width: util.isTablet() ? 174.0 : 100,
          height: 40.0,
          decoration: BoxDecoration(
            color: CustomColors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(CustomStrings.cancel,
                style: CustomStyles.med14greenPrimary),
          ),
        ),
      ),
    );
  }

  Future<void> _publishCourse() async {
    // firebase
  }
}

class AlertUnpublishCourse extends StatelessWidget {
  AlertUnpublishCourse({super.key, required this.courseId});

  final String courseId;
  final util = UtilityHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: util.isTablet() ? 400 : 800),
        child: AlertDialog(
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  S.h(20),
                  Text(
                    'ยกเลิกการเผยแพร่คอร์สเรียนของคุณ',
                    style: CustomStyles.bold18Black363636,
                  ),
                  S.h(5),
                  Text(
                    'ยืนยันการยกเลิกการเผยแพร่ข้อมูลและเนื้อหาคอร์สเรียนของคุณ',
                    style: CustomStyles.reg14Gray878787,
                  ),
                  S.h(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildButtonClose(context),
                      S.w(10),
                      _buildButtonAdd(context),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonAdd(context) {
    final util = UtilityHelper();

    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          // _updateStatus();
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) =>  MainTabTutorPage(in),
          //     ),
          //     (route) => false);
        },
        child: Container(
          width: util.isTablet() ? 174.0 : 100,
          height: 40.0,
          decoration: BoxDecoration(
            color: CustomColors.greenPrimary,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(CustomStrings.confirm, style: CustomStyles.med14White),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonClose(context) {
    final util = UtilityHelper();

    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          width: util.isTablet() ? 174.0 : 100,
          height: 40.0,
          decoration: BoxDecoration(
            color: CustomColors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(CustomStrings.cancel,
                style: CustomStyles.med14greenPrimary),
          ),
        ),
      ),
    );
  }

  Future<void> _updateStatus() async {
    //
  }
}

class AlertDeleteCourse extends StatelessWidget {
  AlertDeleteCourse({super.key});
  final _util = UtilityHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: _util.isTablet() ? 150.0 : 20,
          vertical: _util.isTablet() ? 100.0 : 0,
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                S.h(20),
                Text(
                  'ลบวิดิโอ',
                  style: CustomStyles.bold18Black363636,
                ),
                S.h(5),
                Text(
                  'คุณยืนยันที่จะลบวิดิโอนี้อออกจาก รายการบทเรียนใช่หรือไม่\nเมื่อลบวิดิโอ คุณสามารถเข้าไปดูวิดิโอนี้ได้อีกจาก “มีเดียของฉัน”',
                  style: CustomStyles.reg14Gray878787,
                ),
                S.h(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: _buildButtonDelete(context),
                    ),
                    S.w(10),
                    Expanded(
                      child: _buildButtonClose(context),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inputAnswer(
      {required String choiceValue,
      required String hintTextAnswer,
      required TextEditingController controllerAnswer,
      required TextEditingController controllerExplain}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            S.w(20),
            SizedBox(
              height: 40,
              width: 450,
              child: TextFormField(
                style: CustomStyles.med14Black363636,
                controller: controllerAnswer,
                decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: hintTextAnswer,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    )),
                maxLines: 1,
              ),
            ),
            S.w(20),
            Container(
                height: 32,
                width: 32,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: CustomColors.gray878787),
                    color: CustomColors.white),
                child: const Icon(
                  Icons.delete,
                  color: CustomColors.gray878787,
                  size: 20,
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            S.w(44),
            SizedBox(
              height: 40,
              width: 450,
              child: TextFormField(
                style: CustomStyles.med14Black363636,
                controller: controllerExplain,
                decoration: const InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'คำอธิบายคำตอบ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    )),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonDelete(context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
          color: CustomColors.redF44336,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Center(
            child: Text(CustomStrings.deleteCourse,
                style: CustomStyles.med14White),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonClose(context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 174.0,
        height: 40.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: CustomColors.gray878787,
            width: 1,
          ),
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Center(
            child:
                Text(CustomStrings.backTo, style: CustomStyles.med14Gray878787),
          ),
        ),
      ),
    );
  }
}

class AlertDeleteDocument extends StatelessWidget {
  AlertDeleteDocument({super.key, required this.onTap});
  Function onTap;
  final _util = UtilityHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: _util.isTablet() ? 150.0 : 20,
          vertical: _util.isTablet() ? 100.0 : 0,
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                S.h(20),
                Text(
                  'ต้องการลบเอกสารนี้ ?',
                  style: CustomStyles.bold18Black363636,
                ),

                /// TODO: removed on first launch
                // S.h(5),
                // Text(
                //   'เอกสารนี้ถูกใช้กับคอร์สเรียนของคุณ',
                //   style: CustomStyles.blod16gray878787,
                // ),
                // Text(
                //   'หากลบเอกสาร คอร์สเรียนเหล่านี้ จะไม่มีเอกสารประกอบการสอน',
                //   style: CustomStyles.blod16gray878787
                //       .copyWith(fontWeight: FontWeight.normal),
                // ),
                S.h(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: _buildButtonDelete(context, onTap),
                    ),
                    S.w(10),
                    Expanded(
                      child: _buildButtonClose(context),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonDelete(context, Function onTap) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
          color: CustomColors.redF44336,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextButton(
          onPressed: () {
            onTap();
          },
          child: Center(
            child: Text('ลบเอกสาร', style: CustomStyles.med14White),
          ),
        ),
      ),
    );
  }
}

Widget _buildButtonClose(context) {
  return Align(
    alignment: Alignment.centerRight,
    child: Container(
      width: 174.0,
      height: 40.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomColors.gray878787,
          width: 1,
        ),
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child:
              Text(CustomStrings.backTo, style: CustomStyles.med14Gray878787),
        ),
      ),
    ),
  );
}

class AlertSinglePart extends StatelessWidget {
  const AlertSinglePart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 150.0,
          vertical: 100.0,
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                S.h(20),
                Text(
                  'คุณไม่สามารถลบบทย่อยนี้ได้',
                  style: CustomStyles.bold18Black363636,
                ),
                S.h(5),
                Text(
                  'ในหนึ่งบทเรียน จำเป็นต้องมีอย่างน้อย 1 บทย่อยเสมอ\nบทย่อยบทนี้ เป็นบทย่อยเดียวของบทเรียนนี้',
                  style: CustomStyles.reg14Gray878787,
                ),
                S.h(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButtonClose(context),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonClose(context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(false);
        },
        child: Container(
          width: 174.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: CustomColors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(CustomStrings.cancel,
                style: CustomStyles.med14greenPrimary),
          ),
        ),
      ),
    );
  }
}

class AlertDeleteVideo extends StatelessWidget {
  AlertDeleteVideo({super.key, required this.onTap});
  Function onTap;
  final _util = UtilityHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: _util.isTablet() ? 150.0 : 20,
          vertical: _util.isTablet() ? 100.0 : 0,
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                S.h(20),
                Text(
                  'ต้องการลบวิดิโอ?',
                  style: CustomStyles.bold22Black363636,
                ),
                S.h(5),
                Text(
                  'หากลบแล้ว คุณไม่สามารถเรียกคืนข้อมูลได้',
                  style: CustomStyles.blod16gray878787,
                ),
                S.h(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: _buildButtonDelete(context, onTap),
                    ),
                    S.w(10),
                    Expanded(
                      child: _buildButtonClose(context),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonDelete(context, Function onTap) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
          color: CustomColors.redF44336,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextButton(
          onPressed: () {
            onTap();
          },
          child: Center(
            child: Text(CustomStrings.deleteDocument,
                style: CustomStyles.med14White),
          ),
        ),
      ),
    );
  }
}

class AlertDeleteLesson extends StatelessWidget {
  AlertDeleteLesson({super.key, required this.onTap});
  Function onTap;
  final _util = UtilityHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: _util.isTablet() ? 150.0 : 20,
          vertical: _util.isTablet() ? 100.0 : 0,
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                S.h(20),
                Text(
                  'ต้องการลบบทเรียน?',
                  style: CustomStyles.bold22Black363636,
                ),
                S.h(5),
                Text(
                  'คุณมีวิดิโดที่ผูกกับบทเรียนที่ต้องการลบ หากลบบทเรียน',
                  style: CustomStyles.blod16gray878787,
                ),
                S.h(5),
                Text(
                  'วิดิโอที่อัพโหลดในบทเรียนนี้จะถูกลบด้วย',
                  style: CustomStyles.bold14RedF44336.copyWith(
                    fontSize: _util.addMinusFontSize(16),
                  ),
                ),
                S.h(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: _buildButtonDelete(context, onTap),
                    ),
                    S.w(10),
                    Expanded(
                      child: _buildButtonClose(context),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonDelete(context, Function onTap) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
          color: CustomColors.redF44336,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextButton(
          onPressed: () {
            onTap();
          },
          child: Center(
            child: Text("ลบข้อมูลทั้งหมด", style: CustomStyles.med14White),
          ),
        ),
      ),
    );
  }
}
