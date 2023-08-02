import 'package:flutter/material.dart';

import '../../calendar/constants/assets_manager.dart';
import '../../calendar/constants/custom_colors.dart';
import '../../calendar/constants/custom_styles.dart';
import '../../calendar/widgets/sizebox.dart';
import '../utils/responsive.dart';
import 'divider.dart';

class ViewAllStudentMobile extends StatefulWidget {
  final List students;
  const ViewAllStudentMobile({Key? key, required this.students})
      : super(key: key);

  @override
  State<ViewAllStudentMobile> createState() => _ViewAllStudentMobileState();
}

class _ViewAllStudentMobileState extends State<ViewAllStudentMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.grayF3F3F3,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 36,
              decoration:
                  BoxDecoration(color: CustomColors.whitePrimary, boxShadow: [
                BoxShadow(
                    color: CustomColors.gray878787.withOpacity(.1),
                    offset: const Offset(0.0, 6),
                    blurRadius: 10,
                    spreadRadius: 1)
              ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  S.w(28),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      color: CustomColors.gray878787,
                      size: 24,
                    ),
                  )
                ],
              ),
            ),
            const DividerLine(),
            Padding(
              padding: Responsive.isMobile(context)
                  ? const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 0)
                  : const EdgeInsets.all(40),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('สลับหน้าไปจอของ...',
                            style: CustomStyles.bold16Black363636),
                        Expanded(child: Container()),
                        SizedBox(
                          height: 40,
                          width: 220,
                          child: TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              labelText: 'ชื่อผู้เรียน',
                              labelStyle: CustomStyles.med14Gray878787,
                              border: const OutlineInputBorder(),
                              suffixIcon: const Icon(
                                Icons.search,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    S.h(16),
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: ListView.builder(
                          itemCount: widget.students.length,
                          itemBuilder: (BuildContext context, index) {
                            return Column(
                              children: [
                                Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: CustomColors.whitePrimary,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    children: [
                                      S.w(defaultPadding),
                                      ColorFiltered(
                                        colorFilter: widget.students[index]
                                                    ['status_share'] ==
                                                'enable'
                                            ? const ColorFilter.mode(
                                                Colors.transparent,
                                                BlendMode.multiply)
                                            : const ColorFilter.matrix(<double>[
                                                0.2126,
                                                0.7152,
                                                0.0722,
                                                0,
                                                0,
                                                0.2126,
                                                0.7152,
                                                0.0722,
                                                0,
                                                0,
                                                0.2126,
                                                0.7152,
                                                0.0722,
                                                0,
                                                0,
                                                0,
                                                0,
                                                0,
                                                1,
                                                0,
                                              ]),
                                        child: Image.network(
                                          widget.students[index]['image'],
                                          height: 32,
                                          width: 32,
                                        ),
                                      ),
                                      S.w(defaultPadding),
                                      Text(
                                        widget.students[index]['name'],
                                        style: CustomStyles.bold16Black363636,
                                        maxLines: 1,
                                      ),
                                      S.w(defaultPadding),
                                      if (widget.students[index]
                                              ['status_share'] ==
                                          'enable')
                                        Row(
                                          children: [
                                            Image.asset(
                                              ImageAssets.shareGreen,
                                              width: 22,
                                            ),
                                            Text(
                                              'นักเรียนอนุญาตให้ดูจอ',
                                              style: CustomStyles
                                                  .bold12greenPrimary,
                                            ),
                                          ],
                                        ),
                                      S.w(3),
                                      if ((widget.students[index]
                                                  ['status_share'] ==
                                              'disable') &&
                                          (widget.students[index]['attend'] !=
                                              'false'))
                                        Text('ยังไม่อุนญาตให้ดูจอ',
                                            style:
                                                CustomStyles.med12gray878787),
                                      if (widget.students[index]['attend'] ==
                                          'false')
                                        Text('นักเรียนยังไม่เข้าห้องเรียน',
                                            style:
                                                CustomStyles.med12gray878787),
                                      Expanded(child: Container()),
                                      if (widget.students[index]
                                              ['status_share'] ==
                                          'enable')
                                        SizedBox(
                                          width: 80,
                                          height: 30,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    CustomColors.greenPrimary,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0), // <-- Radius
                                                ), // NEW
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context, index);
                                              },
                                              child: Text('เลือก',
                                                  style: CustomStyles
                                                      .bold11White)),
                                        ),
                                      // if (widget.students[index]['share_now'] ==
                                      //     'Y')
                                      //   Container(
                                      //     width: 100,
                                      //     height: 30,
                                      //     decoration: BoxDecoration(
                                      //       border: Border.all(
                                      //         color: CustomColors.grayCFCFCF,
                                      //         style: BorderStyle.solid,
                                      //         width: 1.0,
                                      //       ),
                                      //       borderRadius:
                                      //           BorderRadius.circular(8),
                                      //       color: CustomColors.whitePrimary,
                                      //     ),
                                      //     child: Center(
                                      //       child: Text(
                                      //         "ออกจากการแชร์",
                                      //         style:
                                      //             CustomStyles.bold11Gray878787,
                                      //       ),
                                      //     ),
                                      //   ),
                                      S.w(8)
                                    ],
                                  ),
                                ),
                                S.h(8)
                              ],
                            );
                          }),
                    ),
                    // S.h(24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
