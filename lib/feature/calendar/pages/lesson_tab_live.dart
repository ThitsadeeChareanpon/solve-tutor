import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/feature/calendar/constants/constants.dart';
import 'package:solve_tutor/feature/calendar/controller/create_course_live_controller.dart';
import 'package:solve_tutor/feature/calendar/helper/utility_helper.dart';
import 'package:solve_tutor/feature/calendar/model/chapter_model.dart';
import 'package:solve_tutor/feature/calendar/model/document_model.dart';
import 'package:solve_tutor/feature/calendar/pages/dialog_file_manager_live.dart';
import 'package:solve_tutor/feature/calendar/pages/preview_document.dart';
import 'package:solve_tutor/feature/calendar/widgets/widgets.dart';

enum Select { form, quiz, video }

class LessonTabLive extends StatefulWidget {
  const LessonTabLive({
    Key? key,
  }) : super(key: key);

  @override
  State<LessonTabLive> createState() => _LessonTabLiveState();
}

class _LessonTabLiveState extends State<LessonTabLive> {
  final _util = UtilityHelper();
  var courseController = CourseLiveController();
  TextEditingController courseName = TextEditingController();
  TextEditingController chapterName = TextEditingController();
  TextEditingController chapterDetail = TextEditingController();
  Select selected = Select.form;
  List<dynamic> chapterList = [];
  Map<String, String> chapterIdMapGlobal = {};
  Map<String, List<ChapterPart>> chapterPartsMap = {};
  List<dynamic> subjects = [];
  List<dynamic> chapters = [];
  String? selectedSubject;
  String? selectedChapter;
  String? selectedChapterId;

  @override
  void initState() {
    super.initState();
    courseController =
        Provider.of<CourseLiveController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseLiveController>(builder: (_, controller, child) {
      return GestureDetector(
        onTap: () => _util.hideKeyboard(context),
        child: Scaffold(
          backgroundColor: const Color(0xffFFFFFF),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: controller.courseData?.document != null
                      ? _docLesson(controller.courseData?.document)
                      : controller.courseData?.document != null
                          ? _docLesson(
                              controller.courseData?.document,
                            )
                          : _addLesson(),
                ),
                S.h(32.0),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _docLesson(DocumentModel? document) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "เอกสารประกอบการสอน",
                style: _util.isTablet()
                    ? CustomStyles.bold22Black363636
                    : CustomStyles.bold18Black363636,
              ),
              if (_util.isTablet() == false) ...[
                _buttonChangeDoc(),
              ]
            ],
          ),
          S.h(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              solveIcon(),
              S.w(10),

              /// TODO: Removed from first launch
              // Text(
              //   "เอกสารประกอบการเรียน: ${courseController.courseData?.document != null ? courseController.courseData?.document?.data?.documentName : courseController.courseData?.document?.data?.documentName}",
              //   textAlign: TextAlign.center,
              //   style: CustomStyles.med14Black363636
              //       .copyWith(fontSize: _util.addMinusFontSize(18)),
              // ),
              const SizedBox(width: 20),
              if (_util.isTablet() == true) ...[
                _buttonChangeDoc(),
              ]
            ],
          ),
          S.h(20),
          Expanded(
            child: GridView(
              addAutomaticKeepAlives: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 8,
              ),
              children: List.generate(
                document?.data?.docFiles?.length ?? 0,
                (index) {
                  return InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreviewDocument(
                            images: document?.data?.docFiles ?? [],
                            index: index,
                            name: document?.data?.documentName ?? '',
                          ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.grey),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      height: 180,
                      imageUrl: document?.data?.docFiles?[index] ?? '',
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addLesson() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "เอกสารประกอบการสอน",
          style: CustomStyles.med14Black363636.copyWith(fontSize: 22),
        ),
        S.h(10),
        Text(
          "เอกสารประกอบการสอนเป็นเอกสารที่คุณใช้สำหรับบันทึกบทเรียน\nนักเรียนของคุณจะสามารถเปิดอ่านเอกสารนี้ และจดบันทึกบนเอกสารระหว่างเรียนได้",
          textAlign: TextAlign.center,
          style: CustomStyles.med14Gray878787,
        ),
        S.w(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buttonStepCreateDoc(), S.w(24), _buttonChoose()],
        ),
      ],
    );
  }

  Widget _buttonStepCreateDoc() {
    return ElevatedButton.icon(
      icon: const Icon(
        Icons.question_answer,
        size: 20,
        color: Colors.grey,
      ),
      label: Text(
        "ขั้นตอนการสร้างเอกสาร",
        style: CustomStyles.med14White.copyWith(
          color: CustomColors.gray878787,
        ),
      ),
      onPressed: () async {
        // final result = await showDialog(
        //     context: context,
        //     builder: ((context) => DialogFileManager(
        //           tutorId: tutorId,
        //         )));
        // if (result != null) {
        //   widget.document = null;
        //   setState(() {});
        // }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }

  Widget _buttonChoose() {
    return ElevatedButton.icon(
      icon: const Icon(
        Icons.add,
        size: 20,
        color: Colors.white,
      ), //Button icon
      label: Text(
        "เลือกเอกสาร",
        style: CustomStyles.med14White,
      ),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DialogFileManagerLive(
              tutorId: courseController.courseData?.tutorId ?? '',
            ),
          ),
        );
        // if (id?.isNotEmpty) {
        // // ignore: use_build_context_synchronously
        // await Alert.showOverlay(
        //   asyncFunction: () async {
        //     await courseController
        //         .getCourseById(courseController.courseData?.id ?? '');
        //   },
        //   context: context,
        //   loadingWidget: Alert.getOverlayScreen(),
        // );
        // }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.green20B153,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }

  Widget _buttonChangeDoc() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.green20B153,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DialogFileManagerLive(
              tutorId: courseController.courseData?.tutorId ?? '',
            ),
          ),
        );
        setState(() {});
      },
      child: Text(
        "เปลี่ยนเอกสาร",
        style: CustomStyles.med14White,
      ),
    );
  }
}
