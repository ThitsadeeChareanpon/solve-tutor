import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/feature/calendar/constants/assets_manager.dart';
import 'package:solve_tutor/feature/calendar/constants/custom_colors.dart';
import 'package:solve_tutor/feature/calendar/constants/custom_strings.dart';
import 'package:solve_tutor/feature/calendar/constants/custom_styles.dart';
import 'package:solve_tutor/feature/calendar/controller/create_course_live_controller.dart';
import 'package:solve_tutor/feature/calendar/helper/utility_helper.dart';
import 'package:solve_tutor/feature/calendar/model/course_model.dart';
import 'package:solve_tutor/feature/calendar/widgets/divider.dart';
import 'package:solve_tutor/feature/calendar/widgets/format_date.dart';
import 'package:solve_tutor/feature/calendar/widgets/sizebox.dart';

import '../../../constants/theme.dart';
import '../../../firebase/database.dart';
import '../../../widgets/sizer.dart';

class CourseDetailPage extends StatefulWidget {
  CourseDetailPage({Key? key, required this.courseData}) : super(key: key);
  CourseModel courseData;
  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final _util = UtilityHelper();
  double? _ratingValue;
  var courseController = CourseLiveController();
  FirebaseService dbService = FirebaseService();
  String tutorName = 'ติวเตอร์ ติวเตอร์';
  String tutorAbout = '';
  String tutorImage = '';
  @override
  void initState() {
    super.initState();
    // SchedulerBinding.instance.addPostFrameCallback((_) => callAlertPopup());
    courseController =
        Provider.of<CourseLiveController>(context, listen: false);
    initDB();
  }

  void initDB() async {
    var user = await dbService.getUserById(widget.courseData.tutorId);
    setState(() {
      tutorName = user['name'];
      tutorAbout = user['about'];
      tutorImage = user['image'];
    });
  }

  Future<void> callAlertPopup() async {
    await _buildMaintenancePopup();
  }

  @override
  Widget build(BuildContext context) {
    var filterLevelId = courseController.levels
        .where((e) => e.id == widget.courseData.levelId)
        .toList();
    var filterSubjectId = courseController.subjects
        .where((e) => e.id == widget.courseData.subjectId)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: const Color(0xffFFFFFF),
        elevation: 6,
        title: Text(CustomStrings.courseDetail,
            style: CustomStyles.bold22Black363636),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.gray878787),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CachedNetworkImage(
              //   height: _util.isTablet() ? 447 : 200,
              //   width: double.infinity,
              //   fit: BoxFit.cover,
              //   imageUrl: widget.courseData.thumbnailUrl ?? '',
              //   placeholder: (context, url) =>
              //       const Center(child: CircularProgressIndicator()),
              //   errorWidget: (context, url, error) => const Icon(Icons.error),
              // ),
              if (widget.courseData.thumbnailUrl?.isNotEmpty == true) ...[
                CachedNetworkImage(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: 180,
                  imageUrl: widget.courseData.thumbnailUrl ?? '',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ] else ...[
                Image.asset(
                  'assets/images/img_not_available.jpeg',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
              S.h(32.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.courseData.courseName ?? '',
                      style: CustomStyles.bold22Black363636,
                    ),
                    Text(
                      widget.courseData.recommendText ?? '',
                      style: CustomStyles.med14Black363636,
                    ),
                    S.h(12.0),
                    Row(
                      children: [
                        _tagType(
                            '${filterLevelId.isNotEmpty ? filterLevelId.first.name : ''}'),
                        S.w(4.0),
                        _tagType(
                            '${filterSubjectId.isNotEmpty ? filterSubjectId.first.name : ''}'),
                      ],
                    ),
                    S.h(12.0),
                    // Row(
                    //   children: [
                    //     Image.asset(
                    //       ImageAssets.icUser2,
                    //       width: 16,
                    //       height: 16,
                    //     ),
                    //     S.w(8.0),
                    //     Text(
                    //       '${widget.courseData.studentIds?.length ?? 0}',
                    //       style: CustomStyles.reg12Gray878787,
                    //     ),
                    //     S.w(8.0),
                    //     const SizedBox(
                    //       height: 21,
                    //       child: VerticalDivider(
                    //         color: CustomColors.grayE5E6E9,
                    //         thickness: 2,
                    //         indent: 5,
                    //         endIndent: 0,
                    //         width: 8,
                    //       ),
                    //     ),
                    //     S.w(8.0),
                    //     Text(
                    //       '4.3',
                    //       style: CustomStyles.reg12yellowFF9800,
                    //     ),
                    //     S.w(8.0),
                    //     const Icon(
                    //       Icons.star,
                    //       color: CustomColors.yellowFF9800,
                    //       size: 22,
                    //     ),
                    //     S.w(8.0),
                    //     Text(
                    //       '3,324 รีวิว',
                    //       style: CustomStyles.reg12Gray878787,
                    //     ),
                    //   ],
                    // ),
                    // S.h(13.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'เรียบเรียงโดย',
                          style: CustomStyles.bold14Black363636,
                        ),
                        S.w(16.0),
                        Text(
                          tutorName,
                          style: CustomStyles.med14greenPrimary,
                        ),
                      ],
                    ),
                    S.h(13.0),
                    Text(
                      'แก้ไขครั้งล่าสุด ${FormatDate.dt(widget.courseData.updateTime)}',
                      style: CustomStyles.med16Black363636,
                    ),
                    S.h(16.0),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'ราคา: ',
                            style: CustomStyles.bold18Black363636,
                          ),
                          TextSpan(
                            text: widget.courseData.price?.toInt().toString(),
                            style: CustomStyles.med16Green
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    S.h(16.0),
                    // Text(
                    //   'ภาพรวมคอร์สเรียน:',
                    //   style: CustomStyles.bold18Black363636,
                    // ),
                    // S.h(16.0),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       'เรียนเป็นกลุ่มกับติวเตอร์ผ่านระบบ SOLVE LIVE',
                    //       style: CustomStyles.reg16Black363636,
                    //     ),
                    //     S.w(8.0),
                    //     buildVerticalDividerGray(20.0, 8.0),
                    //     S.w(8.0),
                    //     Text(
                    //       '1 แบบทดสอบ',
                    //       style: CustomStyles.reg16Black363636,
                    //     ),
                    //     S.w(8.0),
                    //     buildVerticalDividerGray(20.0, 8.0),
                    //     S.w(8.0),
                    //     Text(
                    //       '35 นาที',
                    //       style: CustomStyles.reg16Black363636,
                    //     ),
                    //   ],
                    // ),
                    // S.h(16.0),
                    // Row(
                    //   children: [
                    //     const Icon(
                    //       Icons.play_arrow,
                    //       color: CustomColors.gray878787,
                    //       size: 20,
                    //     ),
                    //     S.w(8.0),
                    //     Text(
                    //       'เรียนผ่านแอปบน tablet  และมือถือ',
                    //       style: CustomStyles.reg16Black363636,
                    //     ),
                    //   ],
                    // ),
                    // S.h(16.0),
                    // Row(
                    //   children: [
                    //     const Icon(
                    //       Icons.play_arrow,
                    //       color: CustomColors.gray878787,
                    //       size: 20,
                    //     ),
                    //     S.w(8.0),
                    //     Text(
                    //       'ทบทวนหลังจบ Live และถามคำถามได้ทันที',
                    //       style: CustomStyles.reg16Black363636,
                    //     ),
                    //   ],
                    // ),
                    // S.h(16.0),
                    // Text(
                    //   'ตารางเรียน',
                    //   style: CustomStyles.bold18Black363636,
                    // ),
                    // S.h(16.0),
                    // Text(
                    //   "ระยะเวลาเรียน:  ${FormatDate.dayOnlyNumber(widget.courseData.firstDay)} - ${FormatDate.dayOnlyNumber(widget.courseData.lastDay)}",
                    //   textAlign: TextAlign.center,
                    //   style: CustomStyles.med14Black363636
                    //       .copyWith(color: CustomColors.gray363636)
                    //       .copyWith(fontSize: _util.addMinusFontSize(16)),
                    // ),
                    // S.h(16.0),
                    // InkWell(
                    //   onTap: () {},
                    //   child: Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Text(
                    //       'ดูแบบละเอียดในปฏิทิน',
                    //       style: CustomStyles.bold14greenPrimary,
                    //     ),
                    //   ),
                    // ),
                    // S.h(16.0),
                    // Text(
                    //   'ดูแบบละเอียดในปฏิทิน',
                    //   style: CustomStyles.bold18Black363636,
                    // ),
                    // Text(
                    //   widget.courseData.detailsText ?? '',
                    //   textAlign: TextAlign.start,
                    //   style: CustomStyles.med14Black363636
                    //       .copyWith(color: CustomColors.gray363636)
                    //       .copyWith(fontSize: _util.addMinusFontSize(16)),
                    // ),
                  ],
                ),
              ),
              Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "รายการเนื้อหา",
                        style: TextStyle(
                          color: appTextPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.courseData.lessons?.length ?? 0,
                        itemBuilder: (context, index) {
                          Lessons? chapter = widget.courseData.lessons?[index];
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: Sizer(context).w,
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              decoration: BoxDecoration(
                                color: greyColor2,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.video_camera_back,
                                    color: greyColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text('${chapter?.lessonName}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              }),
              // Align(
              //   alignment: Alignment.center,
              //   child: Text(
              //     'ดูเพิ่มเติม',
              //     style: CustomStyles.bold14greenPrimary,
              //   ),
              // ),
              // S.h(32.0),
              // Padding(
              //   padding: const EdgeInsets.only(left: 24.0),
              //   child: Text(
              //     'นอกจากนี้ผู้เรียนยังดู',
              //     style: CustomStyles.bold18Black363636,
              //   ),
              // ),
              // S.h(16.0),
              // Padding(
              //   padding: const EdgeInsets.only(left: 24.0),
              //   child: ListView.builder(
              //       physics: const NeverScrollableScrollPhysics(),
              //       scrollDirection: Axis.vertical,
              //       shrinkWrap: true,
              //       // the number of items in the list
              //       itemCount: 4,
              //
              //       // display each item of the product list
              //       itemBuilder: (context, index) {
              //         return BuildCourse(
              //           util: _util,
              //         );
              //       }),
              // ),
              // Align(
              //   alignment: Alignment.center,
              //   child: Text(
              //     'ดูเพิ่มเติม',
              //     style: CustomStyles.bold14greenPrimary,
              //   ),
              // ),
              S.h(32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  S.w(20.39),
                  ClipOval(
                    child: (tutorImage == '')
                        ? Image.asset(
                            'assets/images/profile2.png',
                            height: _util.isTablet() ? 102.71 : 50,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            tutorImage,
                            height: _util.isTablet() ? 102.71 : 50,
                            fit: BoxFit.cover,
                          ),
                  ),
                  S.w(12.39),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ติวเตอร์:',
                        style: CustomStyles.bold14Black363636,
                      ),
                      InkWell(
                        // onTap: () => Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const ProfileTutor()),
                        // ),
                        onTap: () {},
                        child: Text(
                          tutorName,
                          style: CustomStyles.reg16greenPrimary,
                        ),
                      ),
                      S.h(9.0),
                      Text(tutorAbout, style: CustomStyles.reg12Black363636),
                      S.h(9.0),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       'คอร์สทั้งหมด: xx',
                      //       style: _util.isTablet()
                      //           ? CustomStyles.reg14Gray878787
                      //           : CustomStyles.reg12Gray878787,
                      //     ),
                      //     S.w(_util.isTablet() ? 8 : 4),
                      //     buildVerticalDividerGray(20.0, 8.0),
                      //     S.w(_util.isTablet() ? 8 : 4),
                      //     Text(
                      //       'จำนวนผู้เรียน: xx,xxx',
                      //       style: _util.isTablet()
                      //           ? CustomStyles.reg14Gray878787
                      //           : CustomStyles.reg12Gray878787,
                      //     ),
                      //     S.w(_util.isTablet() ? 8 : 4),
                      //     buildVerticalDividerGray(20.0, 8.0),
                      //     S.w(_util.isTablet() ? 8 : 4),
                      //     Text(
                      //       'จำนวนรีวิว: xxx',
                      //       style: _util.isTablet()
                      //           ? CustomStyles.reg14Gray878787
                      //           : CustomStyles.reg12Gray878787,
                      //     ),
                      //   ],
                      // ),
                      // Row(
                      //   children: [
                      //     Image.asset(
                      //       ImageAssets.icThumbUp,
                      //       height: _util.isTablet() ? 20 : 10,
                      //     ),
                      //     S.w(8.0),
                      //     Padding(
                      //       padding: const EdgeInsets.only(top: 5.0),
                      //       child: Text(
                      //         'xxx คะแนน',
                      //         style: CustomStyles.reg12greenPrimary,
                      //       ),
                      //     )
                      //   ],
                      // ),
                    ],
                  ),
                ],
              ),
              // S.h(32.0),
              // Padding(
              //   padding: const EdgeInsets.only(left: 24.0),
              //   child: Text(
              //     'รีวิวจากผู้เรียน',
              //     style: CustomStyles.bold18Black363636,
              //   ),
              // ),
              // S.h(16.0),
              // Padding(
              //   padding: const EdgeInsets.only(left: 24.0),
              //   child: Row(
              //     children: [
              //       Text(
              //         '4.7',
              //         style: CustomStyles.bold14yellowFF9800,
              //       ),
              //       S.w(8.0),
              //       RatingBar(
              //           ignoreGestures: true,
              //           initialRating: 4.5,
              //           direction: Axis.horizontal,
              //           allowHalfRating: true,
              //           itemCount: 5,
              //           itemSize: 24,
              //           ratingWidget: RatingWidget(
              //               full: const Icon(
              //                 Icons.star,
              //                 color: CustomColors.yellowFF9800,
              //               ),
              //               half: const Icon(
              //                 Icons.star_half,
              //                 color: CustomColors.yellowFF9800,
              //               ),
              //               empty: const Icon(
              //                 Icons.star_outline,
              //                 color: Colors.orange,
              //               )),
              //           onRatingUpdate: (value) {
              //             setState(() {
              //               _ratingValue = value;
              //             });
              //           }),
              //       S.w(8.0),
              //       Text(
              //         '3,324 รีวิว',
              //         style: CustomStyles.reg11Gray878787,
              //       ),
              //     ],
              //   ),
              // ),
              // S.h(18.0),
              // percentPoint(5, 0.8, "55"),
              // S.h(18.0),
              // percentPoint(4, 0.8, "33"),
              // S.h(18.0),
              // percentPoint(3, 0.8, "10"),
              // S.h(18.0),
              // percentPoint(2, 0.8, "2"),
              // S.h(18.0),
              // percentPoint(1, 0.1, "1"),
              // S.h(34.0),
              // comment(),
              // comment(),
              // comment(),
              // Align(
              //   alignment: Alignment.center,
              //   child: Text(
              //     'แสดงเพิ่มเติม',
              //     style: CustomStyles.bold14greenPrimary,
              //   ),
              // ),
              // S.h(100.0),
              S.h(32.0),
            ],
          ),
        ),
      ),
      // floatingActionButton: InkWell(
      //   onTap: () {
      //     // showSnackBar(context, "เพิ่มคอร์สเข้ารายการของคุณเรียบร้อย");
      //     // Navigator.push(
      //     //   context,
      //     //   MaterialPageRoute(
      //     //       builder: (context) => const SubscribeRegisterPage()),
      //     // );
      //   },
      //   child: Container(
      //     width: 165,
      //     height: 40.0,
      //     decoration: BoxDecoration(
      //       color: CustomColors.greenPrimary,
      //       borderRadius: BorderRadius.circular(8.0),
      //     ),
      //     child: Center(
      //         child:
      //             Text("ฉันอยากเรียนคอร์สนี้", style: CustomStyles.med14White)),
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _tagType(String tag) {
    return tag.isEmpty
        ? const SizedBox()
        : Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: CustomColors.grayF3F3F3,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              tag,
              style: CustomStyles.med12gray878787.copyWith(color: Colors.black),
            ),
          );
  }

  // Widget _buildClass(String nameSubject) {
  //   return Container(
  //     decoration: const BoxDecoration(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(16),
  //         topRight: Radius.circular(16),
  //         bottomLeft: Radius.circular(16),
  //         bottomRight: Radius.circular(16),
  //       ),
  //       color: Color.fromRGBO(239, 240, 241, 1),
  //     ),
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         Text(nameSubject,
  //             textAlign: TextAlign.center,
  //             style: CustomStyles.reg11Black363636),
  //       ],
  //     ),
  //   );
  // }

  Widget percentPoint(double star, double percent, String percentNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          LinearPercentIndicator(
            backgroundColor: CustomColors.grayEFF0F2,
            width: 150.0,
            animation: true,
            animationDuration: 1000,
            lineHeight: 20.0,
            percent: percent,
            progressColor: CustomColors.yellowFF9800,
            padding: EdgeInsets.zero,
          ),
          S.w(16.0),
          RatingBar(
              ignoreGestures: true,
              initialRating: star,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 20.0,
              ratingWidget: RatingWidget(
                  full: const Icon(
                    Icons.star,
                    color: CustomColors.yellowFF9800,
                  ),
                  half: const Icon(
                    Icons.star_half,
                    color: CustomColors.yellowFF9800,
                  ),
                  empty: const Icon(
                    Icons.star_outline,
                    color: Colors.orange,
                  )),
              onRatingUpdate: (value) {
                setState(() {
                  _ratingValue = value;
                });
              }),
          S.w(16.0),
          Text(
            '$percentNumber %',
            textAlign: TextAlign.right,
            style: CustomStyles.bold12BlackFF9800,
          )
        ],
      ),
    );
  }

  Widget comment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Text(
            'พรทิพา ศ***',
            style: CustomStyles.bold14Black363636,
          ),
        ),
        S.h(8.0),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Row(
            children: [
              Text(
                '4.7',
                style: CustomStyles.bold14yellowFF9800,
              ),
              S.w(8.0),
              RatingBar(
                  ignoreGestures: true,

                  /// added value point star in initialRating.
                  initialRating: 3,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 23.0,
                  ratingWidget: RatingWidget(
                      full: const Icon(
                        Icons.star,
                        color: CustomColors.yellowFF9800,
                      ),
                      half: const Icon(
                        Icons.star_half,
                        color: CustomColors.yellowFF9800,
                      ),
                      empty: const Icon(
                        Icons.star_outline,
                        color: Colors.orange,
                      )),
                  onRatingUpdate: (value) {
                    setState(() {
                      _ratingValue = value;
                    });
                  }),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: Text(
                  '31/12/2022',
                  style: CustomStyles.reg12Gray878787,
                ),
              )
            ],
          ),
        ),
        S.h(8.0),
        Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Column(
              children: [
                Text(
                  'This Section’s so good.',
                  style: CustomStyles.reg16Black363636,
                ),
                S.h(32.0)
              ],
            )),
      ],
    );
  }

  Future<void> _buildMaintenancePopup() {
    final util = UtilityHelper();

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                  // height: 602,
                  width: 613,
                  decoration: const BoxDecoration(
                    color: CustomColors.whitePrimary,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "คอร์สเรียนอยู่ระหว่างการปรับปรุง",
                              style: CustomStyles.bold22Black363636,
                            ),
                          ),
                          S.h(40),
                          Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              ImageAssets.icMaintain,
                              width: util.isTablet() ? 92.2 : 70,
                              height: util.isTablet() ? 92.2 : 70,
                            ),
                          ),
                          S.h(40),
                          Text(
                            'คอร์สเรียกนี้อยู่ใน ระหว่างการปรับปรุง อัพเดทเนื้อหาใหม่ คุณจะสามารถเข้าเรียนคอร์สนี้ได้หลังจาก อาจารย์ที่สอนเผยแพร่คอร์สอีกครั้ง',
                            style: CustomStyles.med16Black36363606,
                          ),
                          S.h(32),
                          Text(
                            'หากมีข้อสงสัยเพิ่มเติม กรุณาติดต่อเจ้าหน้าที่ของเราได้ที่',
                            style: CustomStyles.med16Black36363606,
                          ),
                          S.h(16),
                          Text(
                            'อีเมล sporter@gmail.com',
                            style: CustomStyles.med16Black36363606,
                          ),
                          S.h(42),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 160,
                                height: 40,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          CustomColors.greenPrimary,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "ปิด",
                                      style: CustomStyles.med14White,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            );
          },
        );
      },
    );
  }
}

class BuildCourse extends StatelessWidget {
  const BuildCourse({Key? key, required this.util}) : super(key: key);
  final UtilityHelper util;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            width: util.isTablet() ? 272 : 120,
            height: util.isTablet() ? 153 : 90,
            fit: BoxFit.cover,
            imageUrl:
                "https://www.techhub.in.th/wp-content/uploads/2021/12/ALBUM-FB-CourseOnline2021-01.png",
            imageBuilder: (context, imageProvider) => Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          S.w(util.isTablet() ? 16 : 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: util.isTablet() ? 500 : 180,
                child: Text(
                  'สรุป ลำดับเลขคณิต และ ลำดับเรขาคณิต | ม.5',
                  style: CustomStyles.bold14Black363636Overflow,
                ),
              ),
              SizedBox(
                width: util.isTablet() ? 500 : 180,
                child: Text(
                    'ลำดับ และ อนุกรม มีความหมายและการใช้ประโยชน์ในทั้งสองหัวข้อนี้แตกต่างกัน',
                    maxLines: 2,
                    style: CustomStyles.med14Black363636Overflow),
              ),
              SizedBox(
                width: util.isTablet() ? 500 : 180,
                child: Text(
                  'เจียมพจน์ ปิ่นแก้ว',
                  style: CustomStyles.med14greenPrimary,
                ),
              ),
              Row(
                children: [
                  Image.asset(
                    ImageAssets.icUser2,
                    width: 16,
                    height: 16,
                  ),
                  S.w(8.0),
                  Text(
                    '999',
                    style: CustomStyles.reg12Gray878787,
                  ),
                  S.w(8.0),
                  buildVerticalDividerGray(21.0, 8.0),
                  S.w(8.0),
                  const Icon(
                    Icons.star,
                    color: CustomColors.yellowFF9800,
                    size: 18,
                  ),
                  S.w(8.0),
                  Text(
                    '4.3',
                    style: CustomStyles.reg12yellowFF9800,
                  ),
                  S.w(6.0),
                  Text(
                    '(80)',
                    style: CustomStyles.reg12Gray878787,
                  ),
                ],
              ),
              S.h(6.0),
              Row(
                children: [
                  _buildClass('คณิต'),
                  S.w(12.0),
                  _buildClass('มัธยม 5')
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildClass(String nameSubject) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        color: Color.fromRGBO(239, 240, 241, 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(nameSubject,
              textAlign: TextAlign.center,
              style: CustomStyles.reg11Black363636),
        ],
      ),
    );
  }
}
